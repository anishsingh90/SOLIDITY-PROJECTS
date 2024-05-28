//POINTS TO NOTE
// >Participant must have a wallet.
// >A participant can transfer ether more than one time but the transferred ether must be 2 ether.
// >As the participant will transfer ether its address will be registered.
// >Manager will have full control over the lottery.
// >The contract will be reset once a round is completed.

//SPDX-Licence-Identifier: UNLICENSED

// SPDX-License-Identifier: MIT
pragma solidity >=0.5.0 <0.9.0;

contract Lottery{
    address public manager;
    address payable[] public participants; //participants is array type because number of participants more than one or two


    constructor(){
        manager = msg.sender; //global variable
    }

    receive() external payable {
        require(msg.value == 1 ether); //condition
        participants.push(payable (msg.sender));
     }

     function getBalance() public view returns(uint){
        require(msg.sender == manager);
        return address(this).balance;
     }

     function random() public view returns(uint){
        return uint(keccak256(abi.encodePacked(blockhash(block.number - 1),block.timestamp,participants.length)));
     }

     function selectWinner() public{
        require(msg.sender == manager);
        require(participants.length >= 3);

        uint r = random();
        address payable winner;
        uint index = r % participants.length;
        winner = participants[index];
        winner.transfer(getBalance());
        participants = new address payable[](0); //new address of the partcipants are 0
     }
}