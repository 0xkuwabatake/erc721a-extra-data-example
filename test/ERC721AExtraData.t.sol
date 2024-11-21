// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/ERC721AExtraData.sol";

contract ERC721AExtraDataTest is Test {
    ERC721AExtraData erc721AExtraData;

    event Transfer(address indexed from, address indexed to, uint256 indexed id);
    
    error OwnerQueryForNonexistentToken();

    function setUp() public {
        erc721AExtraData = new ERC721AExtraData();
    }

    function test_GetExtraData_AfterMintOneQuantity() public {
        erc721AExtraData.mint(69, 1);
        assertEq(erc721AExtraData.getExtraData(0), 69);
    }

    function test_GetExtraData_AfterMintMoreThanOneQuantity() public {
        erc721AExtraData.mint(42, 2);
        assertEq(erc721AExtraData.getExtraData(0), 42);
        assertEq(erc721AExtraData.getExtraData(1), 42);
    }

    function test_GetExtraData_AfterTokenIsTransferedToNonZeroAddress() public {
        address sender = address(0xA11CE);
        address receiver = address(0xB0B);
        vm.startPrank(sender);
        erc721AExtraData.mint(420, 1);
        erc721AExtraData.safeTransferFrom(sender, receiver, 0);
        vm.stopPrank();
        assertEq(erc721AExtraData.getExtraData(0), 420);
    }

    function test_GetExtraData_AfterTokenIsBurned() public {
        address burner = address(0xDEAD);
        vm.startPrank(burner);
        erc721AExtraData.mint(666, 1);
        erc721AExtraData.burn(0);
        vm.stopPrank();
        vm.expectRevert(OwnerQueryForNonexistentToken.selector);
        erc721AExtraData.getExtraData(0);
    }

    function test_GetExtraData_WhenTokenDoesNotExist() public {
        vm.expectRevert(OwnerQueryForNonexistentToken.selector);
        erc721AExtraData.getExtraData(0);
    }
}