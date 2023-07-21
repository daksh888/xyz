// SPDX-License-Identifier: MIT

pragma solidity ^0.8.13;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {sToken} from "./sToken.sol";

contract StackupVault {
    mapping(address => IERC20) public tokens;
    mapping(address => sToken) public claimTokens;

    constructor(address uniAddr, address linkAddr) {
        tokens[uniAddr] = IERC20(uniAddr);
        claimTokens[uniAddr] = new sToken("Claim Uni", "sUNI");

        tokens[linkAddr] = IERC20(linkAddr);
        claimTokens[linkAddr] = new sToken("Claim Link", "sLINK");
    }

    function deposit(address tokenAddr, uint256 amount) external {
        IERC20 underlyingToken = tokens[tokenAddr];
        sToken claimToken = claimTokens[tokenAddr];

        // Transfer underlying tokens from user to vault
        underlyingToken.transferFrom(msg.sender, address(this), amount);

        // Mint sTokens
        claimToken.mint(msg.sender, amount);
    }

    function withdraw(address tokenAddr, uint256 amount) external {
        IERC20 underlyingToken = tokens[tokenAddr];
        sToken claimToken = claimTokens[tokenAddr];

        // Burn sTokens
        claimToken.burn(msg.sender, amount);

        // Transfer underlying tokens from vault to user
        underlyingToken.transfer(msg.sender, amount);
    }
}