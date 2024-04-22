
// SPDX-License-Identifier: GPL-2.0
pragma solidity ^0.8.0;

import {Test} from "forge-std/Test.sol";
import {TargetFunctions} from "./TargetFunctions.sol";
import {FoundryAsserts} from "@chimera/FoundryAsserts.sol";

contract CryticToFoundry is Test, TargetFunctions, FoundryAsserts {
    function setUp() public {
        setup();
    }

    function testDemo1() public {
        // TODO: Given any target function and foundry assert, test your results
        vm.prank(0x5000000000000000000000000000000000000000);
        tokenSale.buy(1);

        uint256 soldAmount = tokenSale.getSellTokenSoldAmount();
        uint256 boughtBal  = buyToken.balanceOf(address(this));

        // scale up `boughtBal` by the precision difference
        boughtBal *= 10 ** (SELL_DECIMALS - BUY_DECIMALS);
        
        t(boughtBal == soldAmount, "Invariant 1 broke: tokens bought != tokens sold");
    }



    function testDemo2() public {
        // TODO: Given any target function and foundry assert, test your results
        vm.startPrank(0x1000000000000000000000000000000000000000);
        tokenSale.buy(404098525);
        tokenSale.buy(200000000000000000000);
        vm.stopPrank();

        for(uint256 i; i<buyers.length; ++i) {
            address buyer = buyers[i];
            
            if(sellToken.balanceOf(buyer) > MAX_TOKENS_PER_BUYER) {
                t(false, "Invariant 2 broke: user exceeds max tokens per buyer");
            }
        }

        t(true, "test 2 passed: no user exceeds max tokens per buyer");
        
    }
}
