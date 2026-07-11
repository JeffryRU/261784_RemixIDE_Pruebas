// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.8.2 <0.9.0;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract WeaponNFT is ERC1155, Ownable {

    struct Weapon {
        uint256 tokenId;      
        string  name;         
        uint8   damage;       
        uint8   speed;        
        uint8   critChance; 
        uint8   rarity;
        address owner; 
        bool    isListed;
        uint256 price;
    }

    // --------------------------------------------------------
    //  ESTADO
    // --------------------------------------------------------

    uint256 private _tokenIdCounter;

    // Acceso directo al struct de un arma por su tokenId
    mapping(uint256 => Weapon) public weapons;

    // Lista de tokenIds que posee cada wallet
    mapping(address => uint256[]) public ownerWeapons;

    // --------------------------------------------------------
    //  EVENTOS
    // --------------------------------------------------------

    event WeaponMinted(
        address indexed owner,
        uint256 tokenId,
        uint8   rarity,
        uint8   damage
    );

    event WeaponListed(
        uint256 indexed tokenId,
        address indexed seller,
        uint256 price
    );

    event WeaponUnlisted(
        uint256 indexed tokenId,
        address indexed owner
    );

    // --------------------------------------------------------
    //  CONSTRUCTOR
    // --------------------------------------------------------

    constructor()
        ERC1155("https://cryptoknight.io/metadata/{id}.json")
        Ownable(msg.sender)
    {}

    // --------------------------------------------------------
    //  MINTEO  —  agrega elemento en el mapping + emite event
    // --------------------------------------------------------

    function mintWeapon(address player) external onlyOwner returns (uint256) {
        uint256 tokenId = _tokenIdCounter++;

        // Semilla de aleatoriedad basada en datos del bloque actual
        uint256 seed = uint256(keccak256(abi.encodePacked(
            block.timestamp,
            blockhash(block.number - 1),
            player,
            tokenId
        )));

        // Inserción en el mapping
        weapons[tokenId] = Weapon({
            tokenId:    tokenId,
            name:       _generateName(seed),
            damage:     uint8(seed % 100) + 1,
            speed:      uint8((seed >> 8) % 100) + 1,
            critChance: uint8((seed >> 16) % 50),
            rarity:     uint8((seed >> 24) % 4),
            owner:      player,
            isListed:   false,
            price:      0
        });

        // Registro del tokenId en el array de la wallet
        ownerWeapons[player].push(tokenId);

        // Minteo ERC-1155 (1 unidad por ser NFT)
        _mint(player, tokenId, 1, "");

        // Emisión del evento — queda en el log de la transacción
        emit WeaponMinted(
            player,
            tokenId,
            weapons[tokenId].rarity,
            weapons[tokenId].damage
        );

        return tokenId;
    }

    // --------------------------------------------------------
    //  CONSULTAS  —  pintar en el log por cuenta específica
    // --------------------------------------------------------

    // Retorna el struct completo de un arma por su tokenId
    function getWeapon(uint256 _tokenId)
        public view returns (Weapon memory)
    {
        return weapons[_tokenId];
    }

    // Retorna todos los structs de armas que posee una wallet
    // → usar en Remix para pintar en el log el listado completo
    function getWeaponsByOwner(address player)
        external view returns (Weapon[] memory)
    {
        uint256[] memory ids = ownerWeapons[player];
        Weapon[] memory result = new Weapon[](ids.length);
        for (uint256 i = 0; i < ids.length; i++) {
            result[i] = weapons[ids[i]];
        }
        return result;
    }

    // Retorna solo los tokenIds de una wallet (consulta ligera)
    function getTokenIdsByOwner(address player)
        external view returns (uint256[] memory)
    {
        return ownerWeapons[player];
    }

    // --------------------------------------------------------
    //  MARKETPLACE (básico)
    // --------------------------------------------------------

    // Poner un arma en venta
    function listWeapon(uint256 _tokenId, uint256 _price) external {
        require(weapons[_tokenId].owner == msg.sender, "No eres el duenio");
        require(_price > 0, "El precio debe ser mayor a 0");
        require(!weapons[_tokenId].isListed, "Ya esta en venta");

        weapons[_tokenId].isListed = true;
        weapons[_tokenId].price    = _price;

        emit WeaponListed(_tokenId, msg.sender, _price);
    }

    // Retirar un arma de la venta
    function unlistWeapon(uint256 _tokenId) external {
        require(weapons[_tokenId].owner == msg.sender, "No eres el duenio");
        require(weapons[_tokenId].isListed, "No esta en venta");

        weapons[_tokenId].isListed = false;
        weapons[_tokenId].price    = 0;

        emit WeaponUnlisted(_tokenId, msg.sender);
    }

    // --------------------------------------------------------
    //  INTERNO  —  generador de nombre según rareza
    // --------------------------------------------------------

    function _generateName(uint256 seed) internal pure returns (string memory) {
        uint8 r = uint8((seed >> 24) % 4);
        if (r == 3) return "Legendary Blade";
        if (r == 2) return "Epic Sword";
        if (r == 1) return "Rare Dagger";
        return "Common Axe";
    }
}
