// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./MyToken.sol";

contract TokenSale {

    address admin;
    MyToken public tokenContract;
    uint256 public tokenPrice;
    uint256 public tokensSold;

    event Sell(address _buyer, uint256 _amount);

    constructor(MyToken _tokenContract, uint256 _tokenPrice) {
        admin = msg.sender;
        tokenContract = _tokenContract;
        tokenPrice = _tokenPrice;
    }

    // Multiply
    function multiply(uint256 x, uint256 y) internal pure returns (uint256 z) {
        require(y == 0 || (z = x * y) / y == x, "Error multiply");
    }

    // Buy Tokens
    function buyTokens(uint256 _numberOfTokens) public payable {
        require(msg.value == multiply(_numberOfTokens, tokenPrice), "Error value");
        require(tokenContract.balanceOf(address(this)) >= _numberOfTokens, "Error balance");
        require(tokenContract.transfer(msg.sender, _numberOfTokens * 1000000000000000000), "Error transfer");

        tokensSold += _numberOfTokens;

        emit Sell(msg.sender, _numberOfTokens);
    }

    // End Sale
    function endSale() public {
        require(msg.sender == admin, "You are not admin");
        require(tokenContract.transfer(admin, tokenContract.balanceOf(address(this))), "Transfer failed");

        payable(admin).transfer(address(this).balance);
    }
}