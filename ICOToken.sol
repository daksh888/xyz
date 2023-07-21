// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.13;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract MyICO is ERC20 {
    address public owner;
    uint256 public startTime;
    uint256 public saleDuration = 1 days;
    uint256 tokenPrice;

    constructor(uint256 _amount) ERC20("your name", "ICO") {
        owner = msg.sender;
        _mint(msg.sender, _amount);
        startTime = block.timestamp;
    }

    function ownerMint(uint256 _amount) external {
        require(msg.sender == owner, "Not the owner");
        _mint(owner, _amount);
    }

    function buyTokens(uint256 _amount) external payable {
        require(
            block.timestamp <= startTime + saleDuration,
            "Sale has expired"
        );

        uint256 requiredETH = (_amount * tokenPrice); // Multiply _amount by the token price
        require(msg.value == requiredETH, "Wrong amount of ETH sent");

        _mint(msg.sender, _amount);
    }
}
