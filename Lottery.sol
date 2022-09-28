// SPDX-License-Identifier: MIT
pragma solidity ^0.8.11;

contract Lottery {
  address public owner;
  address payable[] public players;
  uint256 public roundId;
  mapping(uint256 => address payable) public lotteryArchive;

  constructor() {
    owner = msg.sender;
    roundId = 1;
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

  function getWinnerByRoundId(uint256 _roundId)
    public
    view
    returns (address payable)
  {
    return lotteryArchive[_roundId];
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

    lotteryArchive[roundId] = players[index];
    roundId += 1;

    // Reset the state of contract
    players = new address payable[](0);
  }
}
