// SPDX-License-Identifier: MIT
pragma solidity >=0.5.0 < 0.9.0;


contract Lottery{
    address public manger;
    address payable[] public participants;

    constructor (){
        manger = msg.sender;
    }
    receive () external payable
    {   require(msg.value== 1 ether);
        participants.push(payable(msg.sender));
    }

    function getBalance() public view returns(uint){
        require(msg.sender==manger);
        return address(this).balance;
    }
    
    function random() public view returns(uint){
 return uint(keccak256(abi.encodePacked(block.timestamp,block.difficulty, 
 msg.sender)))%participants.length;
    }

    function selectWinner() public {
        require(msg.sender==manger);
        require(participants.length>=3);
        uint r= random();
        address payable winner;
        uint index= r% participants.length;
        winner = participants[index];
       winner.transfer(getBalance());
       participants = new address payable[](0);
    }
}