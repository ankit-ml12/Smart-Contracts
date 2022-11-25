// SPDX-License-Identifier: MIT;
pragma solidity 0.8.7;

contract EventOragnization{

    struct public event{
        address organizer;
        string name;
        uint data;
        uint price;
        uint ticketCount;
        uint ticketRemaining;
    }

   mapping(int=>event)events;
   mapping(address=>mapping(int =>int))tickes;
   uint nextId;

   function createEvent() public payable{
       
   }


}