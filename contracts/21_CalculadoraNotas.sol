// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.8.2 <0.9.0;

contract CalculadoraNotas {
    function calcularNotaFinal(uint256 teoria, uint256 practica, uint256 laboratorio) public pure returns(uint){
        //uint256 notaFinal = (teoria * 30 + practica * 30 + laboratorio * 40) / 100;
        uint256 notaFinal = (teoria * 10 + practica * 10 + laboratorio * 80) / 100;
        return notaFinal;
    }
}
