// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract fan {
    function f(string calldata message) public pure returns (string memory) {
        uint len = bytes(message).length;
        bytes memory m = bytes(message);
        bytes memory result = new bytes(len);
        for (uint i = 0; i < len; i++) {
            result[i] = m[len-i-1];
        }
        return string(result);
    }
}