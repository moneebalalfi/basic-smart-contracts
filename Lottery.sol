// SPDX-License-Identifier: MIT
pragma solidity ^0.8.11;

contract Lottery {
  address public owner;
  address payable[] public players;

  constructor() {
    owner = msg.sender;
  }

  // Utils - Testing
  modifier onlyOwner(string memory errorMsg) {
    require(msg.sender == owner, errorMsg);
    _;
  }

  function getPotBalance() public view returns (uint256) {
    return address(this).balance;
  }

  function getPlayers() public view returns (address payable[] memory) {
    return players;
  }

  // Lottery Logic
  function enterLottery() public payable {
    require(msg.value >= .01 ether, "You have to pay at least 0.01 Eth!");
    players.push(payable(msg.sender));
  }

  function getRandomNumber() public view returns (uint256) {
    return uint256(keccak256(abi.encodePacked(owner, block.timestamp)));
  }

  function pickWinner() public onlyOwner("Only the owner can pick a winner!") {
    uint256 index = getRandomNumber() % players.length;
    players[index].transfer(address(this).balance);

    players = new address payable[](0);
  }
}
