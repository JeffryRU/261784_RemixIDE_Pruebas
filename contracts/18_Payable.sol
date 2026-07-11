// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.8.2 <0.9.0;
contract Teleton {
    address public owner;  
    constructor() {
        owner = msg.sender;
    }
    modifier isOwner() {
       require(msg.sender == owner, "No eres el propietario");
       _;
    }
    function transferOwnership(address nuevoOwner) public isOwner {
        owner = nuevoOwner;
    }
    function despositar() public payable {
    }
    function retirar() public isOwner {
        payable(owner).transfer(address(this).balance);
    }
}