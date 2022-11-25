// SPDX-License-Identifier: MIT;
pragma solidity 0.8.7;

contract EventOragnization{

    struct Event{
        address organizer;
        string name;
        uint date;
        uint price;
        uint ticketCount;
        uint ticketRemaining;
    }

   mapping(uint=>Event)events;
   mapping(address=>mapping(uint =>uint))tickets;
   uint nextId;

   function createEvent(string memory name, uint price, uint date, uint ticketCount) public{
       require(block.timestamp <date, "you can create only in future");
       require(ticketCount>0, "atleast one ticket require to organize event");
     events[nextId]=Event(msg.sender, name, date, price,  ticketCount, ticketCount);
     nextId++; }
   
   function buyTickets(uint id, uint quantity) external payable{
      require(id>nextId,"Event does not exist");
      require(events[id].date>block.timestamp, "The event is completed");
      require(quantity>0, "atleat one ticket is require to book");
      require(msg.value==quantity * events[id].price, "amount receive is not enough");
      require(events[id].ticketRemaining>=quantity, "not enough ticket");
      tickets[msg.sender][id]+=quantity;
      events[id].ticketRemaining-=quantity;
   }
    function transferTickets(uint id, uint quantity, address to)external {
      require(id>nextId,"Event does not exist");
      require(events[id].date>block.timestamp, "The event is completed");
      require(tickets[msg.sender][id]>=quantity, "you do not have enough tickets");
     tickets[msg.sender][id]-=quantity;
     tickets[to][id]+=quantity;
   }
}