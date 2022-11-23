// SPDX-License-Identifier: MIT
pragma solidity >=0.5.0 < 0.9.0;

contract CrowdFunding{
//all the required vaiable initilize
 mapping (address=>uint) public contributors;
 address public manager;
 uint public minimumContribution;   
 uint public deadline;
 uint public targetAmount;
 uint public raisedAmount;
 uint public noOfContributor;

struct Request{
    string description;
    address payable recipient;
    uint value;
    bool completed;
    uint noofVoters;
   mapping(address=>bool)voters;
}
mapping(uint =>Request) public requests;
uint public numRequests;


//target in wei and time in sec
  constructor (uint target, uint time){
      targetAmount= target;
      deadline=block.timestamp+time;
      manager = msg.sender;
      minimumContribution= 100 wei;
  }

//  function to send eat to crowdfunding
function sendEth() public payable{
    require(block.timestamp<deadline, "Deadline has passed");
    require(msg.value>=minimumContribution, "Minimum contribution is no met");
    if(contributors[msg.sender]==0){
        noOfContributor++;
    }
    contributors[msg.sender]+=msg.value;
    raisedAmount+=msg.value;
}
function getContractBalance() public view returns (uint){
return address(this).balance;
}
modifier onlyManger(){
    require(msg.sender==manager, "only manager can create request");
    _;
}
 function createRequest(string memory _description, address payable _recipient, uint _value) public onlyManger{
    Request storage newRequest = requests[numRequests];
    newRequest.description= _description;
    newRequest.recipient = _recipient;
    newRequest.value= _value;
    newRequest.completed = false;
    newRequest.noofVoters=0;
 }
  function voteRequest(uint requests_no) public{
     require(contributors[msg.sender]>0, "You must be contributore");
     Request storage thisRequest = requests[requests_no];
     require(thisRequest.voters[msg.sender]==false, "You allready voted");
     thisRequest.voters[msg.sender]=true;
     thisRequest.noofVoters++;
  }
  function makePayment(uint _requestNo) public onlyManger{
      require(raisedAmount>=targetAmount);
      Request storage thisRequest = requests[_requestNo];
      require(thisRequest.completed==false, "The request allready completed");
      require(thisRequest.noofVoters>noOfContributor/2, "Majority does not supports");
      thisRequest.recipient.transfer(thisRequest.value);
      thisRequest.completed=true;
  }

}