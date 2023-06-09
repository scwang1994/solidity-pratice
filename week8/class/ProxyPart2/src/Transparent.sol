// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.17;

import {Slots} from "./SlotManipulate.sol";
import {BasicProxy} from "./BasicProxy.sol";

contract Transparent is Slots, BasicProxy {
    bytes32 public constant slotAdmin =
        bytes32(uint256(keccak256("eip1967.proxy.admin")) - 1);

    constructor(address _implementation) BasicProxy(_implementation) {
        // TODO: set admin address to Admin slot
        _setSlotToAddress(slotAdmin, msg.sender);
    }

    modifier onlyAdmin() {
        // TODO: finish onlyAdmin modifier
        require(msg.sender == _getSlotToAddress(slotAdmin), "Not Admin");
        _;
    }

    function upgradeTo(address _newImpl) public onlyAdmin {
        // TODO: rewrite upgradeTo
        _setSlotToAddress(slot, _newImpl);
    }

    function upgradeToAndCall(
        address _newImpl,
        bytes memory data
    ) public onlyAdmin {
        // TODO: rewrite upgradeToAndCall
        _setSlotToAddress(slot, _newImpl);
        (bool success, ) = _getSlotToAddress(slot).delegatecall(data);
        require(success);
    }

    fallback() external payable override {
        // rewrite fallback
        require(msg.sender != _getSlotToAddress(slotAdmin));
        _fallback();
    }

    function _fallback() internal virtual {
        _delegate(_getSlotToAddress(slot));
    }
}
