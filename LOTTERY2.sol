// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

contract Raffledraw{

    uint private maxPlayerNumbers;
    uint private playerNumbers;
    uint private ticketPrice;
    address public admin;
    address payable[] public players;

    constructor(){
     admin = msg.sender;
     maxPlayerNumbers = 3;
      ticketPrice= 0.1 ether;

    }

    function getBalance() public view returns(uint){
        return address(this).balance;

    }

function getPlayers() public view returns(address payable[] memory){
    return players;
}
    modifier onlyAdmin(){
        require(msg.sender==admin, "Access Denied!");
        _;

    }
    modifier notAdmin(){
        require(msg.sender!=admin, "Access Denied");
        _;

    }

     function setMaximumNumbers(uint _maxNumbers) public onlyAdmin{
         playerNumbers= _maxNumbers;
     }
     function viewTicketPrice() external view returns(uint){
         return ticketPrice;
     }
     function EnterLottery() public payable notAdmin(){
         require(msg.value > ticketPrice);
         if(playerNumbers < maxPlayerNumbers){
             players.push(payable(msg.sender));
             playerNumbers++;

         }
          else if(playerNumbers==maxPlayerNumbers){
              payable(msg.sender).transfer(msg.value);
              pickwinner();

          }
     }
         function random() private view returns(uint){
             return uint(keccak256(abi.encode(block.difficulty,block.timestamp,admin)));

         }
         function pickwinner() internal{
             uint win = random() % players.length;
             players[win].transfer(address(this).balance);

             delete players;
             playerNumbers=0;

         }
         function endGame() external onlyAdmin{
             uint win = random() % players.length;

               players[win].transfer(address(this).balance);
               delete players;
               playerNumbers=0;
         }
} 