### HIGH

### [H-1] Uniswap invest/divest paths have zero slippage protection

**Description:**

`UniswapAdapter::_uniswapInvest` and `_uniswapDivest` call the Uniswap V2 router with `amountOutMin: 0`, `amountAMin: 0`, and `amountBMin: 0`, and use `deadline: block.timestamp`.

These functions run on every `VaultShares::deposit`, and again inside the `divestThenInvest` modifier used by `withdraw`, `redeem`, and public `rebalanceFunds()`.

**Impact:**

MEV searchers can sandwich vault swaps and liquidity add/remove operations, extracting value from depositors whenever the vault invests or divests.

**Proof of Concept:**

N/A — the vulnerable parameters are in `src/protocol/investableUniverseAdapters/UniswapAdapter.sol`:

```solidity
i_uniswapRouter.swapExactTokensForTokens({
    amountIn: amountOfTokenToSwap,
    amountOutMin: 0,
    path: s_pathArray,
    to: address(this),
    deadline: block.timestamp
});

i_uniswapRouter.addLiquidity({
    ...
    amountAMin: 0,
    amountBMin: 0,
    ...
});
```

`VaultSharesWithdrawTest::testAnyoneCanTriggerRebalanceOnTenThousandEthVault` shows any address can trigger the divest/reinvest path on a funded vault.

**Recommended Mitigation:**

Use oracle- or TWAP-based minimum outputs, a real deadline, and restrict `rebalanceFunds()`:

```diff
 uint256[] memory amounts = i_uniswapRouter.swapExactTokensForTokens({
     amountIn: amountOfTokenToSwap,
-    amountOutMin: 0,
+    amountOutMin: minOut,
     path: s_pathArray,
     to: address(this),
-    deadline: block.timestamp
+    deadline: block.timestamp + DEADLINE_BUFFER
 });
```

### [H-2] `ERC4626::totalAssets` only checks idle vault balance even when assets are invested

**Description:**

`VaultShares` inherits OpenZeppelin `ERC4626` without overriding `totalAssets()`. The default implementation returns only `IERC20(asset()).balanceOf(address(this))`.

After deposits, `_investFunds` moves capital into Aave and Uniswap, so the reported total no longer reflects assets under management.

**Impact:**

`previewDeposit`, `previewRedeem`, `maxWithdraw`, and share pricing all use incorrect values. Depositors can mint or redeem against the wrong exchange rate while funds are invested.

**Proof of Concept:**

Local test `testLargeDepositThenWithdrawWithoutIsActiveGuard` in `test/unit/concrete/VaultSharesWithdrawTest.t.sol` deposits `10_000 ether` and shows the vault under-reports assets while capital is deployed:

```solidity
wethVault.deposit(DEPOSIT_AMOUNT, user);

uint256 reportedTotalAssets = wethVault.totalAssets();
assertLt(reportedTotalAssets, DEPOSIT_AMOUNT);

uint256 maxWithdrawWhileInvested = wethVault.maxWithdraw(user);
assertLt(maxWithdrawWhileInvested, DEPOSIT_AMOUNT);
```

Run:

```bash
forge test --match-test testLargeDepositThenWithdrawWithoutIsActiveGuard -vvv
```

**Recommended Mitigation:**

Override `totalAssets()` to include idle balance plus the value of Aave and Uniswap positions:

```solidity
function totalAssets() public view override returns (uint256) {
    return IERC20(asset()).balanceOf(address(this))
        + _aaveUnderlyingValue()
        + _uniswapUnderlyingValue();
}
```

### [H-3] Guardians can repeatedly mint `VaultGuardianToken` and take over the DAO

**Description:**

Each call to `_becomeTokenGuardian` mints `s_guardianStakePrice` VGT to the caller. `_quitGuardian` clears `s_guardians[msg.sender][token]`, so the same address can call `becomeGuardian` again and receive another VGT mint.

The attacker keeps the minted governance tokens while recovering most of their staked WETH through `quitGuardian`. With enough VGT they control the governor, pass proposals on `VaultGuardians`, steal DAO fee flows, and set malicious parameters such as `updateGuardianStakePrice(1)`.

This is **not** the same as the fee-share mint in `VaultShares::deposit` — the attack is unlimited **governance token** inflation, not ERC4626 share dilution.

**Impact:**

An attacker can farm voting power, capture the DAO, lower guardian stake requirements, and manipulate protocol parameters without proportional economic cost.

**Proof of Concept:**

**Step 1 — farm VGT:** `testGuardianFarmsVGTByCyclingBecomeAndQuit` in `test/integration/IntegrationTest.t.sol`:

```solidity
for (uint256 i; i < 10; i++) {
    weth.approve(address(vaultGuardians), stakePrice);
    address vault = vaultGuardians.becomeGuardian(allocationData);
    IERC20(vault).approve(address(vaultGuardians), type(uint256).max);
    vaultGuardians.quitGuardian();
}
assertEq(vaultGuardianToken.balanceOf(attacker), stakePrice * 10);
```

**Step 2 — takeover DAO:** `testAttackerCapturesGovernanceAndLowersStakePrice` in the same file (single iteration is enough once VGT balance exceeds quorum):

```solidity
vaultGuardianToken.delegate(attacker);
_passProposal(
    attacker,
    address(vaultGuardians),
    abi.encodeWithSelector(VaultGuardians.updateGuardianStakePrice.selector, uint256(1)),
    "lower stake price"
);
assertEq(vaultGuardians.getGuardianStakePrice(), 1);
```

Run:

```bash
forge test --match-contract IntegrationTest -vvv
```

**Recommended Mitigation:**

Mint VGT only once per address, or burn VGT on `quitGuardian`. Separate governance token distribution from the guardian onboarding flow:

```diff
 function _becomeTokenGuardian(IERC20 token, VaultShares tokenVault) private returns (address) {
+    if (s_hasBeenGuardian[msg.sender]) {
+        revert VaultGuardiansBase__AlreadyBeenGuardian();
+    }
+    s_hasBeenGuardian[msg.sender] = true;
     s_guardians[msg.sender][token] = IVaultShares(address(tokenVault));
     ...
 }

 function _quitGuardian(IERC20 token) private returns (uint256) {
     ...
+    i_vgToken.burn(msg.sender, s_guardianStakePrice);
     return numberOfAssetsReturned;
 }
```

### MEDIUM

### [M-1] `VaultShares::deposit` mints fee shares without depositing underlying

**Description:**

After a user deposit, the vault mints extra shares to the guardian and DAO without pulling additional assets:

```solidity
_mint(i_guardian, shares / i_guardianAndDaoCut);
_mint(i_vaultGuardians, shares / i_guardianAndDaoCut);
```

**Impact:**

Existing LPs are diluted on every deposit. This is separate from the VGT governance mint in [H-3].

**Proof of Concept:**

N/A — see `VaultShares::deposit` and `testUserDepositsFundsAndDaoAndGuardianGetShares` in `test/unit/concrete/VaultSharesTest.t.sol`.

**Recommended Mitigation:**

Charge the fee in underlying assets before minting fee shares, or use a pull-based fee mechanism.

### [M-2] `rebalanceFunds()` is callable by anyone on an active vault

**Description:**

`VaultShares::rebalanceFunds` is `public`, has no role check, and triggers a full divest and reinvest through `divestThenInvest`.

**Impact:**

Any address can force expensive portfolio churn and expose the vault to sandwich attacks on Uniswap operations.

**Proof of Concept:**

`testAnyoneCanTriggerRebalanceOnTenThousandEthVault` in `test/unit/concrete/VaultSharesWithdrawTest.t.sol`.

**Recommended Mitigation:**

```diff
- function rebalanceFunds() public isActive divestThenInvest nonReentrant {}
+ function rebalanceFunds() public onlyGuardian isActive divestThenInvest nonReentrant {}
```

### [M-3] Governance executes immediately with no timelock

**Description:**

`VaultGuardianGovernor` has no timelock controller. Successful proposals execute directly through the governor.

**Impact:**

Token holders and users have no delay to react after a malicious proposal succeeds.

**Proof of Concept:**

N/A

**Recommended Mitigation:**

Deploy OpenZeppelin `TimelockController` and route successful proposals through a delayed execution queue.

### LOW

### [L-1] `VaultGuardians::updateGuardianAndDaoCut` emits the wrong event

**Description:**

The function updates the DAO/guardian fee divisor but emits `VaultGuardians__UpdatedStakePrice` instead of a fee-specific event.

**Impact:**

Off-chain monitoring and indexers can misread fee updates as stake-price changes.

**Proof of Concept:**

N/A

**Recommended Mitigation:**

```diff
- emit VaultGuardians__UpdatedStakePrice(s_guardianAndDaoCut, newCut);
+ emit VaultGuardians__UpdatedFee(s_guardianAndDaoCut, newCut);
```

### [L-2] `VaultGuardians::sweepErc20s` has no access control

**Description:**

Any caller can invoke `sweepErc20s`, although transferred tokens are always sent to `owner()` (the governor).

**Impact:**

Unexpected tokens can be swept by arbitrary callers.

**Proof of Concept:**

N/A

**Recommended Mitigation:**

```diff
- function sweepErc20s(IERC20 asset) external {
+ function sweepErc20s(IERC20 asset) external onlyOwner {
```

### INFO

### [I-1] `GUARDIAN_FEE` constant is never used

**Description:**

`VaultGuardiansBase` defines `GUARDIAN_FEE = 0.1 ether` but never references it.

**Impact:**

Dead code and misleading documentation for integrators.

**Proof of Concept:**

N/A

**Recommended Mitigation:**

Remove the unused constant or enforce the intended fee in `_becomeTokenGuardian`.
