## questions
### Hipotesis
Puede un guardian modificar fees, recomendar un swap/flashloan que le permita extraer fondos?? como??

el bajo umbral de votos permitiria, ingresar y ejecutar una propuesta que cambie el GuardianStakePrice, abriendo la puerta a un sybil??

AllocationData???

s_guardians

whic actions is guardian able to perform?

A min amount of 10 ETH is required to become in Guardian, not way to skeep this stake price

updateHoldingAllocation ->
 struct AllocationData {
        uint256 holdAllocation; // hodl
        uint256 uniswapAllocation; // Simmilar to T-Swap
        uint256 aaveAllocation; // Similar to Thunder Loan
    }

getVaultFromGuardianAndToken (address guardian, IERC20 token)

### WORK

Mapa de roles al deploy
El script de deploy deja la cadena de ownership así:

vaultGuardians.transferOwnership(address(vgGovernor));
vgToken.transferOwnership(address(vaultGuardians));
Contrato	Owner	Qué implica
VaultGuardians
VaultGuardianGovernor
La gobernanza controla parámetros del protocolo
VaultGuardianToken
VaultGuardians
El protocolo puede mintear VGT
VaultGuardianGovernor
—
Solo vota y ejecuta propuestas
Qué hace cada contrato
1. VaultGuardianToken — token de gobernanza (VGT)
function mint(address to, uint256 amount) external onlyOwner {
    _mint(to, amount);
}
Es el token con el que se vota en el Governor (ERC20Votes).
mint no es público: solo lo puede llamar el owner, que es VaultGuardians.
No lo llama el Governor directamente.
2. VaultGuardianGovernor — mecanismo de votación
contract VaultGuardianGovernor is Governor, GovernorCountingSimple, GovernorVotes, GovernorVotesQuorumFraction {
    constructor(IVotes _voteToken)
        Governor("VaultGuardianGovernor")
        GovernorVotes(_voteToken)
        GovernorVotesQuorumFraction(4)
    {}
    function votingDelay() public pure override returns (uint256) {
        return 1 days;
    }
    function votingPeriod() public pure override returns (uint256) {
        return 7 days;
    }
Parámetros:

Quorum: 4% del supply votante
Delay: 1 día antes de votar
Periodo: 7 días de votación
Capacidad real del Governor: ejecutar propuestas aprobadas llamando funciones en otros contratos. Como es owner de VaultGuardians, puede ejecutar las funciones onlyOwner de ese contrato.

Importante: no hay Timelock. Una propuesta aprobada se ejecuta directamente desde el Governor.

3. VaultGuardians — capa DAO (hijo de Base)
function updateGuardianStakePrice(uint256 newStakePrice) external onlyOwner {
    s_guardianStakePrice = newStakePrice;
    ...
}
function updateGuardianAndDaoCut(uint256 newCut) external onlyOwner {
    s_guardianAndDaoCut = newCut;
    ...
}
function sweepErc20s(IERC20 asset) external {
    uint256 amount = asset.balanceOf(address(this));
    ...
    asset.safeTransfer(owner(), amount);
}
Poderes de la gobernanza (vía propuestas):

Función	Efecto
updateGuardianStakePrice
Cambia cuánto deben stakear los nuevos guardians (default: 10 tokens)
updateGuardianAndDaoCut
Cambia el divisor de fees en vaults nuevos (default: 1000)
sweepErc20s
Recoge ERC20s sobrantes en el contrato y los manda al owner() (Governor)
Nota de auditoría: sweepErc20s no tiene onlyOwner — cualquiera puede llamarla, pero los fondos van al Governor.

4. VaultGuardiansBase — lógica de guardians
Aquí está el mint como recompensa automática, no como control de gobernanza:

function _becomeTokenGuardian(IERC20 token, VaultShares tokenVault) private returns (address) {
    ...
    i_vgToken.mint(msg.sender, s_guardianStakePrice);
Cuando alguien se hace guardian:

Se crea un VaultShares nuevo
Se mintean VGT al guardian (s_guardianStakePrice tokens)
El guardian transfiere el stake al protocolo y deposita en su vault
Eso funciona porque msg.sender en el mint es VaultGuardians, que es owner del token.

5. VaultShares — fees continuos al DAO
uint256 shares = previewDeposit(assets);
_deposit(_msgSender(), receiver, assets, shares);
_mint(i_guardian, shares / i_guardianAndDaoCut);
_mint(i_vaultGuardians, shares / i_guardianAndDaoCut);
En cada deposit de usuarios:

El guardian recibe shares / 1000 (shares del vault ERC4626)
El DAO (i_vaultGuardians = contrato VaultGuardians) recibe la misma cantidad
Es decir, ~0.1% de las shares van al guardian y ~0.1% al protocolo/DAO por cada depósito.

¿Cuál es el punto de conexión?
Tu idea va bien encaminada, pero la conexión es en dos capas:

owner
owner
hereda
mint al hacer guardian
crea vaults
fees en deposit
fees en deposit
VaultGuardianToken
VaultGuardianGovernor
VaultGuardians
VaultGuardiansBase
VaultShares
Guardian address
Governor ↔ Protocolo: ownership de VaultGuardians → control de parámetros (stakePrice, cut, sweep).

Base ↔ Token: i_vgToken.mint() al convertirse en guardian → recompensa en VGT.

VaultShares ↔ DAO: _mint(i_vaultGuardians, shares/cut) → el DAO acumula shares de todos los vaults.

Respuestas directas a tus preguntas
¿La gobernanza puede mintear tokens?
Indirectamente sí, pero no hay una función expuesta para eso. El Governor no puede llamar vgToken.mint() directamente en una propuesta, porque msg.sender sería el Governor, no VaultGuardians (el owner del token).
El mint ocurre automáticamente desde Base cuando entra un guardian.

¿El mint es el punto de conexión entre Governor y Base?
No exactamente. El mint conecta Base → Token.
El Governor se conecta a VaultGuardians (que incluye Base) vía ownership, no vía mint.

¿Qué puede hacer realmente la gobernanza hoy?

Cambiar precio de stake para nuevos guardians
Cambiar fee split para vaults futuros
Recoger tokens sobrantes del contrato principal
Acumular shares de vaults como fee del DAO (automático, no requiere voto)
Los holders de VGT votan propuestas, pero no hay funciones custom más allá del Governor estándar de OpenZeppelin
Punto de auditoría clave
La gobernanza está parcialmente cableada:

Tiene control de parámetros vía onlyOwner
Recibe fees vía shares en VaultShares
Pero no puede mintear VGT arbitrariamente sin añadir una función wrapper en VaultGuardians
sweepErc20s es callable por cualquiera (aunque los fondos van al Governor)
No hay Timelock → ejecución inmediata tras aprobar propuesta



## Protocol Notes

Use of Erc4626 vault, his goal is maximize the value of user who have deposited.

VaultGuardian: only can deposit and withdraw in aave & uniswap only, they should't move founds out of the vault

Guardian stake to become a guardian and gain fees in profitable transactions.

Upgreadable

Users can leave pools through redeem or withdraw

Guardians can earn DAO tokens by becoming guardians. The DAO is responsible for:



Why are using 3 abstract contracts to keep track of allowed tokens??

Updating pricing parameters



Getting a cut of all performance of all guardians

ERC20 Tokens allowed
abstract contract AStaticWethData: this is the responsable of manage weth

abstract contract AStaticUSDCData is AStaticWethData :
weth,i_tokenOne;

abstract contract AStaticTokenData is AStaticUSDCData:
    IERC20 internal immutable i_tokenTwo;



abstract contract ERC20Votes is ERC20, Votes 

## Governance

contract VaultGuardianGovernor is Governor, GovernorCountingSimple, GovernorVotes, GovernorVotesQuorumFraction:
 Governor("VaultGuardianGovernor")
        GovernorVotes(_voteToken)
        GovernorVotesQuorumFraction(4)

### Roles

Users: liquidity providers
Guardians: liquidity operators
TokenGuardian:
VaultGuardian:contract allowed to manage asset
Owner: is the dao owner of????is centralized??

library DataTypes, core for aave

Compiler run successful with warnings:
Warning (5667): Unused function parameter. Remove or comment out the variable name to silence this warning.
  --> src/protocol/investableUniverseAdapters/AaveAdapter.sol:42:74:
   |
42 |     function _aaveDivest(IERC20 token, uint256 amount) internal returns (uint256 amountOfAssetReturned) {
   |                                                                          ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^


flowchart TD
    VGT[VaultGuardianToken]
    GOV[VaultGuardianGovernor]
    VG[VaultGuardians]
    BASE[VaultGuardiansBase]
    VS[VaultShares]

    GOV -->|owner| VG
    VG -->|owner| VGT
    VG -->|hereda| BASE
    BASE -->|mint al hacer guardian| VGT
    BASE -->|crea vaults| VS
    VS -->|fees en deposit| VG
    VS -->|fees en deposit| Guardian[Guardian address]


### VaultGuardiansBase
core logic of vault guardians and guardians   

### Follow VaultShares  
divestThenInvest 
_aaveDivest
_uniswapDivest

ConstructorData
constructorData.allocationData




| Method                                             | Identifier |
+=================================================================+
| TOKEN_ONE_VAULT_NAME()                             | 490747bd   |
|----------------------------------------------------+------------|
| TOKEN_ONE_VAULT_SYMBOL()                           | f8dfe37c   |
|----------------------------------------------------+------------|
| allowance(address,address)                         | dd62ed3e   |
|----------------------------------------------------+------------|
| approve(address,uint256)                           | 095ea7b3   |
|----------------------------------------------------+------------|
| asset()                                            | 38d52e0f   |
|----------------------------------------------------+------------|
| balanceOf(address)                                 | 70a08231   |
|----------------------------------------------------+------------|
| convertToAssets(uint256)                           | 07a2d13a   |
|----------------------------------------------------+------------|
| convertToShares(uint256)                           | c6e6f592   |
|----------------------------------------------------+------------|
| decimals()                                         | 313ce567   |
|----------------------------------------------------+------------|
| deposit(uint256,address)                           | 6e553f65   |
|----------------------------------------------------+------------|
| getAaveAToken()                                    | e9113f19   |
|----------------------------------------------------+------------|
| getAllocationData()                                | 0ed9b21b   |
|----------------------------------------------------+------------|
| getGuardian()                                      | a75b87d2   |
|----------------------------------------------------+------------|
| getGuardianAndDaoCut()                             | 50bf4fc6   |
|----------------------------------------------------+------------|
| getIsActive()                                      | fba7cc79   |
|----------------------------------------------------+------------|
| getTokenOne()                                      | ca4372e5   |
|----------------------------------------------------+------------|
| getUniswapLiquidtyToken()                          | 1c526a17   |
|----------------------------------------------------+------------|
| getVaultGuardians()                                | 0bca758e   |
|----------------------------------------------------+------------|
| getWeth()                                          | 107c279f   |
|----------------------------------------------------+------------|
| i_aavePool()                                       | fe5e5bf4   |
|----------------------------------------------------+------------|
| maxDeposit(address)                                | 402d267d   |
|----------------------------------------------------+------------|
| maxMint(address)                                   | c63d75b6   |
|----------------------------------------------------+------------|
| maxRedeem(address)                                 | d905777e   |
|----------------------------------------------------+------------|
| maxWithdraw(address)                               | ce96cb77   |
|----------------------------------------------------+------------|
| mint(uint256,address)                              | 94bf804d   |
|----------------------------------------------------+------------|
| name()                                             | 06fdde03   |
|----------------------------------------------------+------------|
| previewDeposit(uint256)                            | ef8b30f7   |
|----------------------------------------------------+------------|
| previewMint(uint256)                               | b3d7f6b9   |
|----------------------------------------------------+------------|
| previewRedeem(uint256)                             | 4cdad506   |
|----------------------------------------------------+------------|
| previewWithdraw(uint256)                           | 0a28a477   |
|----------------------------------------------------+------------|
| rebalanceFunds()                                   | 7a6785e9   |
|----------------------------------------------------+------------|
| redeem(uint256,address,address)                    | ba087652   |
|----------------------------------------------------+------------|
| setNotActive()                                     | de448f13   |
|----------------------------------------------------+------------|
| symbol()                                           | 95d89b41   |
|----------------------------------------------------+------------|
| totalAssets()                                      | 01e1d114   |
|----------------------------------------------------+------------|
| totalSupply()                                      | 18160ddd   |
|----------------------------------------------------+------------|
| transfer(address,uint256)                          | a9059cbb   |
|----------------------------------------------------+------------|
| transferFrom(address,address,uint256)              | 23b872dd   |
|----------------------------------------------------+------------|
| updateHoldingAllocation((uint256,uint256,uint256)) | 443ec85a   |
|----------------------------------------------------+------------|
| withdraw(uint256,address,address)                  | b460af94   |
╰----------------------------------------------------+------------╯