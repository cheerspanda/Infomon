// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "./Infomon/src/ERC721Common.sol";
import "./Infomon/src/launchpad/NFTLaunchpadCommon.sol";

contract InfomonERC721 is ERC721Common, NFTLaunchpadCommon {

    // Event to log the minting process
    event MintToClaimerCalled(address indexed to, uint256 tokenId);

    constructor(
        string memory name,
        string memory symbol,
        string memory baseTokenURI
    ) ERC721Common(name, symbol, baseTokenURI) {
        _setupRole(DEFAULT_ADMIN_ROLE, msg.sender);
        _setupRole(MINTER_ROLE, msg.sender);
        _setupRole(PAUSER_ROLE, msg.sender);
    }

    // prepare for ronin launch pad
    function mintLaunchpad(
        address to,
        uint256 quantity,
        bytes calldata /* extraData */
    )
        external
        onlyRole(MINTER_ROLE)
        returns (uint256[] memory tokenIds, uint256[] memory amounts)
    {
        tokenIds = new uint256[](quantity);
        amounts = new uint256[](quantity);
        for (uint256 i; i < quantity; ++i) {
            tokenIds[i] = _mintFor(to);
            amounts[i] = 1;
        }
    }

    // Function: mintToClaimer
    // Purpose: Allows accounts with the MINTER_ROLE to mint tokens for a specified address `to`
    // Parameters: 
    //    - to: The address that will receive the minted token
    // Returns: 
    //    - uint256: The newly minted token's ID
    function mintToClaimer(address to)
        external
        onlyRole(MINTER_ROLE) // Ensures the caller has the MINTER_ROLE
        returns (uint256)
    {
        // Call the internal minting function
        uint256 tokenId = _mintFor(to);

        // Emit an event to log the mint operation
        emit MintToClaimerCalled(to, tokenId);

        // Return the new token ID
        return tokenId;
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        virtual
        override(ERC721Common, NFTLaunchpadCommon)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }
}
