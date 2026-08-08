
[<img width="200" alt="get in touch with Consensys Diligence" src="https://user-images.githubusercontent.com/2865694/56826101-91dcf380-685b-11e9-937c-af49c2510aa0.png">](https://consensys.io/diligence)<br/>
<sup>
[[  🌐  ](https://consensys.io/diligence)  [  📩  ](mailto:diligence@consensys.net)  [  🔥  ](https://consensys.io/diligence/tools/)]
</sup><br/><br/>



# Solidity Metrics for 'CLI'

## Table of contents

- [Scope](#t-scope)
    - [Source Units in Scope](#t-source-Units-in-Scope)
        - [Deployable Logic Contracts](#t-deployable-contracts)
    - [Out of Scope](#t-out-of-scope)
        - [Excluded Source Units](#t-out-of-scope-excluded-source-units)
        - [Duplicate Source Units](#t-out-of-scope-duplicate-source-units)
        - [Doppelganger Contracts](#t-out-of-scope-doppelganger-contracts)
- [Report Overview](#t-report)
    - [Risk Summary](#t-risk)
    - [Source Lines](#t-source-lines)
    - [Inline Documentation](#t-inline-documentation)
    - [Components](#t-components)
    - [Exposed Functions](#t-exposed-functions)
    - [StateVariables](#t-statevariables)
    - [Capabilities](#t-capabilities)
    - [Dependencies](#t-package-imports)
    - [Totals](#t-totals)

## <span id=t-scope>Scope</span>

This section lists files that are in scope for the metrics report. 

- **Project:** `'CLI'`
- **Included Files:** 
    - ``
- **Excluded Paths:** 
    - ``
- **File Limit:** `undefined`
    - **Exclude File list Limit:** `undefined`

- **Workspace Repository:** `unknown` (`undefined`@`undefined`)

### <span id=t-source-Units-in-Scope>Source Units in Scope</span>

Source Units Analyzed: **`16`**<br>
Source Units in Scope: **`16`** (**100%**)

| Type | File   | Logic Contracts | Interfaces | Lines | nLines | nSLOC | Comment Lines | Complex. Score | Capabilities |
| ---- | ------ | --------------- | ---------- | ----- | ------ | ----- | ------------- | -------------- | ------------ | 
| 🎨 | src/abstract/AStaticTokenData.sol | 1 | **** | 23 | 23 | 14 | 5 | 10 | **** |
| 🎨 | src/abstract/AStaticUSDCData.sol | 1 | **** | 23 | 23 | 14 | 5 | 10 | **** |
| 🎨 | src/abstract/AStaticWethData.sol | 1 | **** | 25 | 25 | 13 | 8 | 7 | **** |
| 📝 | src/dao/VaultGuardianGovernor.sol | 1 | **** | 35 | 30 | 22 | 2 | 19 | **** |
| 📝 | src/dao/VaultGuardianToken.sol | 1 | **** | 24 | 24 | 17 | 2 | 20 | **** |
| 🔍 | src/interfaces/IVaultData.sol | **** | 1 | 16 | 16 | 8 | 10 | 1 | **** |
| 🔍 | src/interfaces/IVaultGuardians.sol | **** | 1 | 4 | 4 | 2 | 1 | 1 | **** |
| 🔍 | src/interfaces/IVaultShares.sol | **** | 1 | 26 | 23 | 19 | 1 | 9 | **** |
| 🔍 | src/interfaces/InvestableUniverseAdapter.sol | **** | 1 | 9 | 7 | 3 | 3 | 1 | **** |
| 📝 | src/protocol/VaultGuardians.sol | 1 | **** | 98 | 98 | 34 | 56 | 23 | **** |
| 📝 | src/protocol/VaultGuardiansBase.sol | 1 | **** | 336 | 329 | 169 | 132 | 135 | **<abbr title='create/create2'>🌀</abbr>** |
| 📝 | src/protocol/VaultShares.sol | 1 | **** | 270 | 252 | 133 | 84 | 120 | **** |
| 📚 | src/vendor/DataTypes.sol | 1 | **** | 269 | 269 | 204 | 44 | 1 | **** |
| 🔍 | src/vendor/IPool.sol | **** | 1 | 40 | 19 | 4 | 29 | 7 | **** |
| 🔍 | src/vendor/IUniswapV2Factory.sol | **** | 1 | 20 | 9 | 4 | 2 | 17 | **** |
| 🔍 | src/vendor/IUniswapV2Router01.sol | **** | 1 | 61 | 8 | 3 | 17 | 13 | **** |
| 📝📚🔍🎨 | **Totals** | **9** | **7** | **1279**  | **1159** | **663** | **401** | **394** | **<abbr title='create/create2'>🌀</abbr>** |

<sub>
Legend: <a onclick="toggleVisibility('table-legend', this)">[➕]</a>
<div id="table-legend" style="display:none">

<ul>
<li> <b>Lines</b>: total lines of the source unit </li>
<li> <b>nLines</b>: normalized lines of the source unit (e.g. normalizes functions spanning multiple lines) </li>
<li> <b>nSLOC</b>: normalized source lines of code (only source-code lines; no comments, no blank lines) </li>
<li> <b>Comment Lines</b>: lines containing single or block comments </li>
<li> <b>Complexity Score</b>: a custom complexity score derived from code statements that are known to introduce code complexity (branches, loops, calls, external interfaces, ...) </li>
</ul>

</div>
</sub>


##### <span id=t-deployable-contracts>Deployable Logic Contracts</span>
Total: 4
* 📝 `VaultGuardianGovernor`
* 📝 `VaultGuardianToken`
* 📝 `VaultGuardians`
* 📝 `VaultShares`



#### <span id=t-out-of-scope>Out of Scope</span>

##### <span id=t-out-of-scope-excluded-source-units>Excluded Source Units</span>

Source Units Excluded: **`0`**

<a onclick="toggleVisibility('excluded-files', this)">[➕]</a>
<div id="excluded-files" style="display:none">
| File   |
| ------ |
| None |

</div>


##### <span id=t-out-of-scope-duplicate-source-units>Duplicate Source Units</span>

Duplicate Source Units Excluded: **`0`** 

<a onclick="toggleVisibility('duplicate-files', this)">[➕]</a>
<div id="duplicate-files" style="display:none">
| File   |
| ------ |
| None |

</div>

##### <span id=t-out-of-scope-doppelganger-contracts>Doppelganger Contracts</span>

Doppelganger Contracts: **`0`** 

<a onclick="toggleVisibility('doppelganger-contracts', this)">[➕]</a>
<div id="doppelganger-contracts" style="display:none">
| File   | Contract | Doppelganger | 
| ------ | -------- | ------------ |


</div>


## <span id=t-report>Report</span>

### Overview

The analysis finished with **`0`** errors and **`0`** duplicate files.





#### <span id=t-risk>Risk</span>

<div class="wrapper" style="max-width: 512px; margin: auto">
			<canvas id="chart-risk-summary"></canvas>
</div>

#### <span id=t-source-lines>Source Lines (sloc vs. nsloc)</span>

<div class="wrapper" style="max-width: 512px; margin: auto">
    <canvas id="chart-nsloc-total"></canvas>
</div>

#### <span id=t-inline-documentation>Inline Documentation</span>

- **Comment-to-Source Ratio:** On average there are`1.85` code lines per comment (lower=better).
- **ToDo's:** `0` 

#### <span id=t-components>Components</span>

| 📝Contracts   | 📚Libraries | 🔍Interfaces | 🎨Abstract |
| ------------- | ----------- | ------------ | ---------- |
| 5 | 1  | 7  | 3 |

#### <span id=t-exposed-functions>Exposed Functions</span>

This section lists functions that are explicitly declared public or payable. Please note that getter methods for public stateVars are not included.  

| 🌐Public   | 💰Payable |
| ---------- | --------- |
| 54 | 0  | 

| External   | Internal | Private | Pure | View |
| ---------- | -------- | ------- | ---- | ---- |
| 44 | 39  | 4 | 2 | 27 |

#### <span id=t-statevariables>StateVariables</span>

| Total      | 🌐Public  |
| ---------- | --------- |
| 25  | 4 |

#### <span id=t-capabilities>Capabilities</span>

| Solidity Versions observed | 🧪 Experimental Features | 💰 Can Receive Funds | 🖥 Uses Assembly | 💣 Has Destroyable Contracts | 
| -------------------------- | ------------------------ | -------------------- | ---------------- | ---------------------------- |
| `0.8.24` |  | **** | **** | **** | 

| 📤 Transfers ETH | ⚡ Low-Level Calls | 👥 DelegateCall | 🧮 Uses Hash Functions | 🔖 ECRecover | 🌀 New/Create/Create2 |
| ---------------- | ----------------- | --------------- | ---------------------- | ------------ | --------------------- |
| **** | **** | **** | **** | **** | `yes`<br>→ `NewContract:VaultShares` | 

| ♻️ TryCatch | Σ Unchecked |
| ---------- | ----------- |
| **** | **** |

#### <span id=t-package-imports>Dependencies / External Imports</span>

| Dependency / Import Path | Count  | 
| ------------------------ | ------ |
| @openzeppelin/contracts/access/Ownable.sol | 2 |
| @openzeppelin/contracts/governance/Governor.sol | 1 |
| @openzeppelin/contracts/governance/extensions/GovernorCountingSimple.sol | 1 |
| @openzeppelin/contracts/governance/extensions/GovernorVotes.sol | 1 |
| @openzeppelin/contracts/governance/extensions/GovernorVotesQuorumFraction.sol | 1 |
| @openzeppelin/contracts/interfaces/IERC4626.sol | 1 |
| @openzeppelin/contracts/token/ERC20/ERC20.sol | 1 |
| @openzeppelin/contracts/token/ERC20/IERC20.sol | 5 |
| @openzeppelin/contracts/token/ERC20/extensions/ERC20Permit.sol | 1 |
| @openzeppelin/contracts/token/ERC20/extensions/ERC20Votes.sol | 1 |
| @openzeppelin/contracts/token/ERC20/extensions/ERC4626.sol | 1 |
| @openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol | 1 |
| @openzeppelin/contracts/utils/ReentrancyGuard.sol | 1 |

#### <span id=t-totals>Totals</span>

##### Summary

<div class="wrapper" style="max-width: 90%; margin: auto">
    <canvas id="chart-num-bar"></canvas>
</div>

##### AST Node Statistics

###### Function Calls

<div class="wrapper" style="max-width: 90%; margin: auto">
    <canvas id="chart-num-bar-ast-funccalls"></canvas>
</div>

###### Assembly Calls

<div class="wrapper" style="max-width: 90%; margin: auto">
    <canvas id="chart-num-bar-ast-asmcalls"></canvas>
</div>

###### AST Total

<div class="wrapper" style="max-width: 90%; margin: auto">
    <canvas id="chart-num-bar-ast"></canvas>
</div>

##### Inheritance Graph

<a onclick="toggleVisibility('surya-inherit', this)">[➕]</a>
<div id="surya-inherit" style="display:none">
<div class="wrapper" style="max-width: 512px; margin: auto">
    <div id="surya-inheritance" style="text-align: center;"></div> 
</div>
</div>

##### CallGraph

<a onclick="toggleVisibility('surya-call', this)">[➕]</a>
<div id="surya-call" style="display:none">
<div class="wrapper" style="max-width: 512px; margin: auto">
    <div id="surya-callgraph" style="text-align: center;"></div>
</div>
</div>

###### Contract Summary

<a onclick="toggleVisibility('surya-mdreport', this)">[➕]</a>
<div id="surya-mdreport" style="display:none">
 

 Files Description Table


|  File Name  |  SHA-1 Hash  |
|-------------|--------------|
| src/abstract/AStaticTokenData.sol | 23e502131781f1897b3236a92f1813a2229ac271 |
| src/abstract/AStaticUSDCData.sol | 4056ce06870e957444e465d168c73f83c65d6f0e |
| src/abstract/AStaticWethData.sol | f84ff79fdddb18137d21051aa75e0754a8b03571 |
| src/dao/VaultGuardianGovernor.sol | 9d94fe12e31b43c05dc2104876e1500d8acef433 |
| src/dao/VaultGuardianToken.sol | c3709afe609064cfa3a546cfc0b6d6d90a8492eb |
| src/interfaces/IVaultData.sol | 404fad0a7a2ec5b91588510703eff7faa12ab54a |
| src/interfaces/IVaultGuardians.sol | 736380b4e868c5490e6a1e7612ea0948372cd5ea |
| src/interfaces/IVaultShares.sol | cce8b236f3771cb05648566fae7614a8a11329a8 |
| src/interfaces/InvestableUniverseAdapter.sol | 3207970bc7b17bee467a5c9274d4004af395279a |
| src/protocol/VaultGuardians.sol | a4c27c7b3764c5c2462d1f948dd1d5bb52132fe3 |
| src/protocol/VaultGuardiansBase.sol | c2bc8b91b9488ce583a5e439aa7d4b59d451b478 |
| src/protocol/VaultShares.sol | c2513dc9864f7b0c5c03de353fc9104aeb1736ae |
| src/vendor/DataTypes.sol | ad8baa6e84386d6c06cee52a13e9945be7142354 |
| src/vendor/IPool.sol | aebcb339f8515dac18d9f4e697f1f4d74e086615 |
| src/vendor/IUniswapV2Factory.sol | d992107988863b3b54f0a21db41f8e4b771a8a46 |
| src/vendor/IUniswapV2Router01.sol | 37880e2de6de9bb43062acb07e355299b9dee14a |


 Contracts Description Table


|  Contract  |         Type        |       Bases      |                  |                 |
|:----------:|:-------------------:|:----------------:|:----------------:|:---------------:|
|     └      |  **Function Name**  |  **Visibility**  |  **Mutability**  |  **Modifiers**  |
||||||
| **AStaticTokenData** | Implementation | AStaticUSDCData |||
| └ | <Constructor> | Public ❗️ | 🛑  | AStaticUSDCData |
| └ | getTokenTwo | External ❗️ |   |NO❗️ |
||||||
| **AStaticUSDCData** | Implementation | AStaticWethData |||
| └ | <Constructor> | Public ❗️ | 🛑  | AStaticWethData |
| └ | getTokenOne | External ❗️ |   |NO❗️ |
||||||
| **AStaticWethData** | Implementation |  |||
| └ | <Constructor> | Public ❗️ | 🛑  |NO❗️ |
| └ | getWeth | External ❗️ |   |NO❗️ |
||||||
| **VaultGuardianGovernor** | Implementation | Governor, GovernorCountingSimple, GovernorVotes, GovernorVotesQuorumFraction |||
| └ | <Constructor> | Public ❗️ | 🛑  | Governor GovernorVotes GovernorVotesQuorumFraction |
| └ | votingDelay | Public ❗️ |   |NO❗️ |
| └ | votingPeriod | Public ❗️ |   |NO❗️ |
| └ | quorum | Public ❗️ |   |NO❗️ |
||||||
| **VaultGuardianToken** | Implementation | ERC20, ERC20Permit, ERC20Votes, Ownable |||
| └ | <Constructor> | Public ❗️ | 🛑  | ERC20 ERC20Permit Ownable |
| └ | _update | Internal 🔒 | 🛑  | |
| └ | nonces | Public ❗️ |   |NO❗️ |
| └ | mint | External ❗️ | 🛑  | onlyOwner |
||||||
| **IVaultData** | Interface |  |||
||||||
| **IVaultGuardians** | Interface |  |||
||||||
| **IVaultShares** | Interface | IERC4626, IVaultData |||
| └ | updateHoldingAllocation | External ❗️ | 🛑  |NO❗️ |
| └ | setNotActive | External ❗️ | 🛑  |NO❗️ |
||||||
| **IInvestableUniverseAdapter** | Interface |  |||
||||||
| **VaultGuardians** | Implementation | Ownable, VaultGuardiansBase |||
| └ | <Constructor> | Public ❗️ | 🛑  | Ownable VaultGuardiansBase |
| └ | updateGuardianStakePrice | External ❗️ | 🛑  | onlyOwner |
| └ | updateGuardianAndDaoCut | External ❗️ | 🛑  | onlyOwner |
| └ | sweepErc20s | External ❗️ | 🛑  |NO❗️ |
||||||
| **VaultGuardiansBase** | Implementation | AStaticTokenData, IVaultData |||
| └ | <Constructor> | Public ❗️ | 🛑  | AStaticTokenData |
| └ | becomeGuardian | External ❗️ | 🛑  |NO❗️ |
| └ | becomeTokenGuardian | External ❗️ | 🛑  | onlyGuardian |
| └ | quitGuardian | External ❗️ | 🛑  | onlyGuardian |
| └ | quitGuardian | External ❗️ | 🛑  | onlyGuardian |
| └ | updateHoldingAllocation | External ❗️ | 🛑  | onlyGuardian |
| └ | _quitGuardian | Private 🔐 | 🛑  | |
| └ | _guardianHasNonWethVaults | Private 🔐 |   | |
| └ | _becomeTokenGuardian | Private 🔐 | 🛑  | |
| └ | getVaultFromGuardianAndToken | External ❗️ |   |NO❗️ |
| └ | isApprovedToken | External ❗️ |   |NO❗️ |
| └ | getAavePool | External ❗️ |   |NO❗️ |
| └ | getUniswapV2Router | External ❗️ |   |NO❗️ |
| └ | getGuardianStakePrice | External ❗️ |   |NO❗️ |
| └ | getGuardianAndDaoCut | External ❗️ |   |NO❗️ |
||||||
| **VaultShares** | Implementation | ERC4626, IVaultShares, AaveAdapter, UniswapAdapter, ReentrancyGuard |||
| └ | <Constructor> | Public ❗️ | 🛑  | ERC4626 ERC20 AaveAdapter UniswapAdapter |
| └ | setNotActive | Public ❗️ | 🛑  | onlyVaultGuardians isActive |
| └ | updateHoldingAllocation | Public ❗️ | 🛑  | onlyVaultGuardians isActive |
| └ | deposit | Public ❗️ | 🛑  | isActive nonReentrant |
| └ | _investFunds | Private 🔐 | 🛑  | |
| └ | rebalanceFunds | Public ❗️ | 🛑  | isActive divestThenInvest nonReentrant |
| └ | withdraw | Public ❗️ | 🛑  | divestThenInvest nonReentrant |
| └ | redeem | Public ❗️ | 🛑  | divestThenInvest nonReentrant |
| └ | getGuardian | External ❗️ |   |NO❗️ |
| └ | getGuardianAndDaoCut | External ❗️ |   |NO❗️ |
| └ | getVaultGuardians | External ❗️ |   |NO❗️ |
| └ | getIsActive | External ❗️ |   |NO❗️ |
| └ | getAaveAToken | External ❗️ |   |NO❗️ |
| └ | getUniswapLiquidtyToken | External ❗️ |   |NO❗️ |
| └ | getAllocationData | External ❗️ |   |NO❗️ |
||||||
| **DataTypes** | Library |  |||
||||||
| **IPool** | Interface |  |||
| └ | supply | External ❗️ | 🛑  |NO❗️ |
| └ | withdraw | External ❗️ | 🛑  |NO❗️ |
| └ | getReserveData | External ❗️ |   |NO❗️ |
||||||
| **IUniswapV2Factory** | Interface |  |||
| └ | feeTo | External ❗️ |   |NO❗️ |
| └ | feeToSetter | External ❗️ |   |NO❗️ |
| └ | getPair | External ❗️ |   |NO❗️ |
| └ | allPairs | External ❗️ |   |NO❗️ |
| └ | allPairsLength | External ❗️ |   |NO❗️ |
| └ | createPair | External ❗️ | 🛑  |NO❗️ |
| └ | setFeeTo | External ❗️ | 🛑  |NO❗️ |
| └ | setFeeToSetter | External ❗️ | 🛑  |NO❗️ |
||||||
| **IUniswapV2Router01** | Interface |  |||
| └ | factory | External ❗️ |   |NO❗️ |
| └ | WETH | External ❗️ |   |NO❗️ |
| └ | addLiquidity | External ❗️ | 🛑  |NO❗️ |
| └ | removeLiquidity | External ❗️ | 🛑  |NO❗️ |
| └ | swapTokensForExactTokens | External ❗️ | 🛑  |NO❗️ |
| └ | swapExactTokensForTokens | External ❗️ | 🛑  |NO❗️ |


 Legend

|  Symbol  |  Meaning  |
|:--------:|-----------|
|    🛑    | Function can modify state |
|    💵    | Function is payable |
 

</div>
____
<sub>
Thinking about smart contract security? We can provide training, ongoing advice, and smart contract auditing. [Contact us](https://consensys.io/diligence/contact/).
</sub>


