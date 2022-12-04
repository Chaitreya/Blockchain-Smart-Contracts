// SPDX-License-Identifier: GPL-3.0

pragma solidity >= 0.5.0 < 0.9.0;

contract Lottery
{
    address public manager;
    address payable[] public participants;

    constructor()
    {
        manager = msg.sender; // global variable
    } 

    receive() external payable
    {
        require(msg.value == 0.01 ether); // check if the value of ether transfered is equal to 1
        participants.push(payable(msg.sender)); // push the address of the sender in the participants array
    }

    function getBalance() public view returns(uint)
    {
        require(msg.sender == manager); // check if the address is manager
        return address(this).balance;
    }

    function random() public view returns(uint) // generate random addresses
    {
        return uint(keccak256(abi.encodePacked(block.difficulty,block.timestamp,participants.length)));
    }

    function selectWinner() public 
    {
        require(msg.sender == manager);
        require(participants.length >= 3);
        uint r = random();
        address payable winner;
        uint index = r % participants.length;
        winner = participants[index];
        winner.transfer(getBalance());
        participants = new address payable[](0);
    }

}