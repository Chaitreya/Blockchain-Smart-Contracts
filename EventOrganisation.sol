// SPDX-License-Identifier: GPL-3.0

pragma solidity >= 0.5.0 < 0.9.0;

contract EventOrganisation
{
    struct Event{
        address organizer;
        uint date;
        uint totalTickets;
        uint remainingTickets;
        string eventName;
        uint ticketPrice;
        uint totalCollection;
    }

    mapping(uint=>Event) public events;
    mapping(address=>mapping(uint=>uint)) public tickets;
    uint public eventId;


    function createEvent(string memory name,uint _date,uint _totalTickets,uint price) public
    {
        require(_totalTickets >0,"Number of tickets cannot be zero");
        require(_date > block.timestamp,"You can only create event for future dates only");
        events[eventId] = Event(msg.sender,_date,_totalTickets,_totalTickets,name,price,0);
        eventId++;
    }

    function buyTickets(uint id,uint quantity) public payable
    {
        require(quantity >0,"Number of tickets cannot be zero");
        require(events[id].date > block.timestamp,"Event is already over");
        require(events[id].ticketPrice*quantity <= msg.value,"Ether is not enough");
        require(events[id].remainingTickets >= quantity,"Not enough tickets available");
        events[id].remainingTickets -= quantity;
        events[id].totalCollection += quantity*events[id].ticketPrice;
        tickets[msg.sender][id] += quantity;
    }

    function sendTicketsTo(uint id,uint quantity,address to) public
    {
        require(quantity < tickets[msg.sender][id],"You don't have enought tickets");
        tickets[msg.sender][id] -= quantity;
        tickets[to][id] = quantity;

    }
}

