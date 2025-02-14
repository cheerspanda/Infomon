// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import { ERC1155 } from "@openzeppelin/contracts@4.8.2/token/ERC1155/ERC1155.sol";
import { AccessControl } from "@openzeppelin/contracts@4.8.2/access/AccessControl.sol";
import { NFTLaunchpadCommon } from "../../launchpad/NFTLaunchpadCommon.sol";

contract SampleNFT1155Launchpad is ERC1155, AccessControl, NFTLaunchpadCommon {
  bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");

  constructor(address admin, address minter, string memory uri_) ERC1155(uri_) {
    _setupRole(DEFAULT_ADMIN_ROLE, admin);
    _setupRole(MINTER_ROLE, minter);
  }

  /// @dev Mint NFTs for the launchpad.
  function mintLaunchpad(address to, uint256 quantity, bytes calldata /* extraData */ )
    external
    onlyRole(MINTER_ROLE)
    returns (uint256[] memory tokenIds, uint256[] memory amounts)
  {
    _mint(to, 3, quantity, "");
    _mint(to, 4, 1, "");

    tokenIds = new uint256[](2);
    amounts = new uint256[](2);
    tokenIds[0] = 3;
    tokenIds[1] = 4;

    amounts[0] = quantity;
    amounts[1] = 1;
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
