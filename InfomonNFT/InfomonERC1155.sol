// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {ERC1155} from "@openzeppelin/contracts@4.8.2/token/ERC1155/ERC1155.sol";
import {AccessControl} from "@openzeppelin/contracts@4.8.2/access/AccessControl.sol";
import {NFTLaunchpadCommon} from "./Infomon/src/launchpad/NFTLaunchpadCommon.sol";

contract InfomonERC1155 is ERC1155, AccessControl, NFTLaunchpadCommon {
    bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");

    // Event to log the minting process
    event MintToClaimerCalled(
        address indexed to,
        uint256 tokenId,
        uint256 amount
    );

    constructor(
        address admin,
        address minter,
        string memory uri_
    ) ERC1155(uri_) {
        _setupRole(DEFAULT_ADMIN_ROLE, admin);
        _setupRole(MINTER_ROLE, minter);
    }

    /// @dev Mint NFTs for ronin launchpad.
    function mintLaunchpad(
        address to,
        uint256, /* quantity */
        bytes calldata extraData
    )
        external
        onlyRole(MINTER_ROLE)
        returns (uint256[] memory tokenIds, uint256[] memory amounts)
    {
        (uint256[] memory mintTokenIds, uint256[] memory mintAmounts) = abi
            .decode(extraData, (uint256[], uint256[]));

        require(
            mintTokenIds.length == mintAmounts.length,
            "Mismatched tokenIds and amounts length"
        );

        tokenIds = new uint256[](mintTokenIds.length);
        amounts = new uint256[](mintAmounts.length);

        for (uint256 i = 0; i < tokenIds.length; i++) {
            _mint(to, tokenIds[i], amounts[i], "");
            tokenIds[i] = tokenIds[i];
            amounts[i] = amounts[i];
        }
    }
    // Function: mintToClaimer
    // Purpose: Allows accounts with the MINTER_ROLE to mint tokens for a specified address `to_`.
    // Parameters: 
    //    - to_: The address that will receive the minted tokens.
    //    - tokenId_: The ID of the token type to mint (for ERC1155 tokens, this is the type of the token).
    //    - amount_: The quantity of tokens to mint (for ERC1155, this could be greater than 1).
    // Returns: 
    //    - uint256: The ID of the minted token (same as `tokenId_` provided).
    //    - uint256: The amount of tokens minted (same as `amount_` provided).
    // Events:
    //    - Emits a MintToClaimerCalled event indicating the recipient address, tokenId, and amount of tokens minted.
    function mintToClaimer(
        address to_,
        uint256 tokenId_,
        uint256 amount_
    ) external onlyRole(MINTER_ROLE) returns (uint256, uint256) {
        _mint(to_, tokenId_, amount_, "");
        emit MintToClaimerCalled(to_, tokenId_, amount_);
        return (tokenId_, amount_);
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        virtual
        override(ERC1155, AccessControl, NFTLaunchpadCommon)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }
}
