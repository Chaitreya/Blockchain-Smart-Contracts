// SPDX-License-Identifier: GPL-3.0

pragma solidity >= 0.5.0 < 0.9.0;


contract Voting
{
    struct Vote
    {
        bool choice;
        address voterAddress;
    }

    struct Voter{
        bool Added;
        bool voted;
    }

    bool public canVote;
    uint public countVote;
    bool public finalResult;
    uint public totalVoters;
    uint public totalVote;

    string public ballotName;
    string public proposal;

    mapping(uint => Vote)public votes;
    mapping(address => Voter) public voters;

    address public chairPerson;

    constructor(string memory _ballotName,string memory _proposal)
    {   
        chairPerson = msg.sender;
        ballotName = _ballotName;
        proposal = _proposal;
    }

    modifier onlyChairPerson
    {
        require(msg.sender == chairPerson,"Only Chairperson can call this function");
        _;
    }

    function addVoter(address voterAddress) public onlyChairPerson
    {
        Voter storage newVoters = voters[voterAddress];
        newVoters.voted = false;
        newVoters.Added = true;
        voters[voterAddress] = newVoters;
        totalVoters++;
    }

    function startVote() public onlyChairPerson
    {
        canVote = true;
    }

    function voteForProposal(bool _choice) public
    {
        require(canVote == true,"Cannot vote now");
        require(voters[msg.sender].voted == false,"Already Voted");
        require(voters[msg.sender].Added == true,"Not a voter");
        Vote storage newVotes = votes[totalVote];
        newVotes.choice = _choice;
        newVotes.voterAddress = msg.sender;
        votes[totalVote] = newVotes;
        totalVote++;
        if(_choice){
            countVote++;
        }
        voters[msg.sender].voted = true;
    }

    function stopVoting() public onlyChairPerson
    {
        canVote = false;
    }

    function result() public onlyChairPerson returns(bool)
    {
        if(countVote > totalVoters/2)
        {
            finalResult = true;
        }
        else
        {
            finalResult = false;
        }
        return finalResult;
    }
}