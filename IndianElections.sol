// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.8.2 <0.9.0;

contract IndiaElections {

// structure of candidate
struct Candidate{
string name; // Name of Candidate
uint256 votesPolled;
string candidateNFT; // metadata JSON contains Name, Description, Photo of Candidate
}

//structure of voter

struct Voter {
    uint noOfVotes; // A voter can have more than one vote it gets votes transferred from someone 
    bool voted; // we will mark voted , when the vote is transferred
    bool rightToVote; // Is the voter eligible to vote or not
    address trasferredTo; // Address to which the voting rights are transferred.
}

// Person who can add voter and candidates we will call him Election Officer
address public electionOfficer;

// Voter List

mapping (address => Voter) public voterList;

// Define the owner of the contract contract who is election offer in contructor so that it cannot be changed









