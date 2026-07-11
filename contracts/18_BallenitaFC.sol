// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.8.2 <0.9.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract BallenitaFCToken is ERC20 {

    constructor() ERC20("Ballenita Futbol Club Token", "BFT") {
        _mint(msg.sender, 1000);
    }

}