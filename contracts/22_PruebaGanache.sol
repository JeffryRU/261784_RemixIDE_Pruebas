// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.8.0 <0.9.0;

contract PruebaGanache {
    address public owner;
    address public addressContract;
    string message = "";

    event newContract(address owner, address addressContrato);
    event newMessage(string message);

    constructor () {
        owner = msg.sender;
        addressContract = address(this);
        emit newContract(owner, addressContract);
    }

    function setMessage(string memory _message) public {
        message = _message;
        emit newMessage(message);
    }

    function getMessage() public view returns (string memory) {
        return message;
    }
}
