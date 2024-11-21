// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {ERC721A} from "lib/ERC721A/contracts/ERC721A.sol";
     
/**
 * @title ERC721AExtraData
 * @author 0xkuwabatake(0xkuwabatake)
 * @notice A contract example that demonstrates storage hitchhiking feature from ERC721A to:
 * - (1) store token related data via {ERC721A - setExtraData} after token is minted and
 * - (2) preserve its value when token is transferred from non-zero address to another 
 *       non-zero address by overriding {ERC721A - _extraData}.
 * @dev Do NOT copy anything here into production code unless you really know what you are doing.
 */
contract ERC721AExtraData is ERC721A {

    constructor() ERC721A("ERC721AExtraData", "721AEXTRA") {}

    /// @dev Bulk mint `quantity` of token ID(s) with `extraData` to `msg.sender`.
    /// ```
    /// Requirements:
    /// - (1) The token at `index` must be initialized.
    ///   See: https://github.com/chiru-labs/ERC721A/blob/main/docs/erc721a.md#_initializeownershipat
    /// - (2) For bulk mints, `index` is the value of _nextTokenId before bulk minting.
    ///   See: https://github.com/chiru-labs/ERC721A/blob/main/docs/erc721a.md#_setextradataat
    /// ```
    function mint(uint24 extraData, uint256 quantity) external {
        _mint(msg.sender, quantity);
        uint256 i;
        unchecked {
            do {
                // `index` is the value before bulk minting.
                uint256 index = _nextTokenId() - quantity + i;
                // Requirement #1
                _initializeOwnershipAt(index);
                // Requirement #2 
                _setExtraDataAt(index, extraData);
                ++i;
            } while (i != quantity);
        } 
    }

    /// @dev Burns `tokenId`.
    /// See: {ERC721A - _burn(uint256 id)}.
    function burn(uint256 tokenId) external {
        _burn(tokenId);
    }

    /// @dev Returns extra data from `tokenId`.
    function getExtraData(uint256 tokenId) public view returns (uint24) {
        return _ownershipOf(tokenId).extraData;
    }

    /// @dev To preserve the value of `previousExtraData` after transferred from `from` to `to`.
    /// ```
    /// Requirement:
    /// - In this case both `from` and `to` must be non-zero address.
    /// ```
    /// See: https://github.com/chiru-labs/ERC721A/blob/main/docs/erc721a.md#_extradata
    /// ```
    function _extraData(
        address from,
        address to,
        uint24 previousExtraData
    ) internal view virtual override returns (uint24) {
        if (from != address(0) && to != address(0)) return previousExtraData;
        return previousExtraData;
    }
}