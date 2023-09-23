// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

import {BasicNft} from "../src/BasicNft.sol";
import {DeployBasicNft} from "../script/DeployBasicNft.s.sol";
import {MintBasicNft} from "../script/Interactions.s.sol";
import {Test, console} from "forge-std/Test.sol";
import {StdCheats} from "forge-std/StdCheats.sol";

contract BasicNftTest is StdCheats, Test {
    string constant NFT_NAME = "Dogie";
    string constant NFT_SYMBOL = "DOG";
    BasicNft public basicNft;
    DeployBasicNft public deployer;
    address public deployerAddress;

    string public constant PUG_URI =
        "ipfs://bafybeig37ioir76s7mg5oobetncojcm3c3hxasyd4rvid4jqhy4gkaheg4/?filename=0-PUG.json";
    /*
    {
        "name": "PUG",
        "description": "An adorable PUG pup!",
        "image": "https://ipfs.io/ipfs/QmSsYRx3LpDAb1GZQm7zZ1AuHZjfbPkD6J7s9r41xu1mf8?filename=pug.png",
        "attributes": [
            {
                "trait_type": "cuteness",
                "value": 100
            }
        ]
    }
     */
    address public constant USER = address(1);

    function setUp() public {
        deployer = new DeployBasicNft();
        basicNft = deployer.run();
    }

    function testInitializedCorrectly() public view {
        assert(keccak256(abi.encodePacked(basicNft.name())) == keccak256(abi.encodePacked(NFT_NAME)));
        assert(keccak256(abi.encodePacked(basicNft.symbol())) == keccak256(abi.encodePacked(NFT_SYMBOL)));
    }

    function testCanMintAndHaveBalance() public {
        vm.prank(USER);
        basicNft.mintNft(PUG_URI);

        assert(basicNft.balanceOf(USER) == 1);
    }

    function testTokenURIIsCorrect() public {
        vm.prank(USER);
        basicNft.mintNft(PUG_URI);

        assert(keccak256(abi.encodePacked(basicNft.tokenURI(0))) == keccak256(abi.encodePacked(PUG_URI)));
    }

    function testMintWithScript() public {
        uint256 startingTokenCount = basicNft.getTokenCounter();
        MintBasicNft mintBasicNft = new MintBasicNft();
        mintBasicNft.mintNftOnContract(address(basicNft));
        assert(basicNft.getTokenCounter() == startingTokenCount + 1);
    }
}
