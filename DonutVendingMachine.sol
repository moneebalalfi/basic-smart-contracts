// SPDX-License-Identifier: MIT
pragma solidity ^0.8.11;

contract DonutVendingMachine {
  address public owner; // 20 bytes value => size of eth address
  mapping(address => uint256) public donutBalances;

  constructor() {
    owner = msg.sender;
    donutBalances[address(this)] = 40;
  }

  function getVendingMachineBalance() public view returns (uint256) {
    return donutBalances[address(this)];
  }

  function restock(uint256 amount) public {
    require(msg.sender == owner, "Only the owner can restock this machine!");

    donutBalances[address(this)] += amount;
  }

  function purchase(uint256 amount) public payable {
    require(
      msg.value >= amount * 2 ether,
      "You must pay at least 2 ether per donut!"
    );
    require(
      donutBalances[address(this)] >= amount,
      "Not enough donuts in stock to fulfill purchase request!"
    );

    donutBalances[address(this)] -= amount;
    donutBalances[msg.sender] += amount;
  }
}
