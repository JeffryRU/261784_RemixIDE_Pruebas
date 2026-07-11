// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.8.2 <0.9.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "./21_CalculadoraNotas.sol";

contract RegistroNotas is Ownable {
    address public addressCalculadora;
    mapping(address => uint256) public notasAlumnos;

    constructor(address _addressCalculadora) Ownable(msg.sender){
        addressCalculadora = _addressCalculadora;
    }

    function actualizarCalculadora(address _addressCalculadora) onlyOwner public {
        addressCalculadora = _addressCalculadora;
    }

    function registrarNota(address _dirAlumno, uint256 _teoria, uint256 _practica, uint256 _laboratorio) onlyOwner public {
        CalculadoraNotas calculador = CalculadoraNotas(addressCalculadora);
        uint256 notaFinal = calculador.calcularNotaFinal(_teoria, _practica, _laboratorio);
        notasAlumnos[_dirAlumno] = notaFinal;
    }

    function verMiNota() public view returns(uint256){
        return notasAlumnos[msg.sender];
    }
}
