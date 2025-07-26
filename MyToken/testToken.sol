// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract testErc20 is ERC20 {
    address public owner;

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this function");
        _;
    }

    constructor() ERC20("MYTOKEN", "MYT") {
        owner = msg.sender;
        _mint(msg.sender, 1000000000 * 10 ** 4);
    }

   function mint(address account, uint256 amount) public onlyOwner {
        _mint(account, amount);
    }


}