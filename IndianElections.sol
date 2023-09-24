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

constructor () {
electionOfficer = msg.sender;
}
// create a candidate list

Candidate[] public candidateList;

// Election officer to create candidates

function addCandidates (string memory _name, string memory _NFTJson) public {
require(msg.sender == electionOfficer , "Only Election Officer can Create Candiadates");
candidateList.push(
    Candidate({
    name: _name,
    votesPolled:0,
    candidateNFT:_NFTJson

}));

}
// Election office to create voter list and decide if voter can vote nor not
// we will ensure only  Election Officer can create this list

function createVoter(address _voter) public {

// Checking that the sender of this message is election officer
require(msg.sender == electionOfficer , "Only Election Officer can create Voter");

// checking that the voter is already not voted
require(!voterList[_voter].voted, "Voter already Voted");

// Give right to vote and give 1 vote to vote 

voterList[_voter].rightToVote = true;
voterList[_voter].noOfVotes = 1;

}

// Voter to transfer his vote to another voter example A is transferring to B

function voteTransfer(address _trasferredTo) public {

// ------------------ Checking eligibility of voter A and other conditions ------------- 

// get a reference to the voter A
Voter storage voter_A = voterList[msg.sender];

//Checking whether the voter has right to vote or not
require(voter_A.rightToVote, "You do not have rights to vote");

// Checking whether  voter has already voted. If alrady voted voter cannot transfer his vote
require(!voter_A.voted, "You have already voted so cannot transfer");

// Cannot transfer self
require(_trasferredTo != msg.sender, "Cannot Transfer to Self");

// Update voter A to mark that vote is transferred to B
voter_A.trasferredTo = _trasferredTo;
voter_A.voted = true;

// <------ Updating the Voter B with Transfer ------------->

// Get reference to B

Voter storage voter_B = voterList[_trasferredTo];

// Checking Voter B is eligible to vote

require(voter_B.rightToVote, "Cannot transfer to someone who cannot vote");

// Update voter_B by votes transferred by A

voter_B.noOfVotes += voter_A.noOfVotes;

}


//--- Casting a vote to candidate

function castVote (uint _id, uint _votesToCast) public {

    // get voter referenece

    Voter storage voter_X = voterList[msg.sender];

    // Check if the voter has rigit to vote
    require(voter_X.rightToVote, "You have no voting rights to vote");

    // Check if already voted
   require(!voter_X.voted, "You have already voted or transferred your vote");
   
   // Updating voter after he voted and exhausted all his votes
 
if (voter_X.noOfVotes == _votesToCast ) {
    // update the voter status to voted
voter_X.voted = true;
} 

// Casting the vote

 if (voter_X.noOfVotes > 0) {
         // reduce the votes casted from the number of votes of Voter
         voter_X.noOfVotes = voter_X.noOfVotes - _votesToCast;
         // cast the vote
         candidateList[_id].votesPolled += _votesToCast;
        
     }
     }

/* Getting the winning candidate ID from the Candidate List */

function getWinner() public view returns (uint _winnerId){
uint winningVoteCount = 0;
        for (uint p = 0; p < candidateList.length; p++) {
            if (candidateList[p].votesPolled > winningVoteCount) {
                winningVoteCount = candidateList[p].votesPolled;
                _winnerId = p;
            }
        }

}

// Get the winning candidate Name

function winningCandidate() public view returns (string memory _winningCandidate) {

_winningCandidate = candidateList[getWinner()].name;

}

}




