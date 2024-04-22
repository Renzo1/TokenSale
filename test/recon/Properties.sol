
// SPDX-License-Identifier: GPL-2.0
pragma solidity ^0.8.0;

import {Asserts} from "@chimera/Asserts.sol";
import {Setup} from "./Setup.sol";

abstract contract Properties is Setup, Asserts {

    // 1) the amount of tokens bought (received by this contract)
    //    should equal the amount of tokens sold as the exchange
    //    rate is 1:1, when accounted for precision difference
    function crytic_tokens_bought_eq_tokens_sold() public{
        uint256 soldAmount = tokenSale.getSellTokenSoldAmount();
        uint256 boughtBal  = buyToken.balanceOf(address(this));

        // scale up `boughtBal` by the precision difference
        boughtBal *= 10 ** (SELL_DECIMALS - BUY_DECIMALS);

        // assert the equality; if this breaks that means something
        // has gone wrong with the buying and selling. In our private
        // audit there was a precision miscalculation that allowed
        // an attacker to buy the sale tokens without paying due to
        // rounding down to zero
        t(boughtBal == soldAmount, "Invariant 1 broke: tokens bought != tokens sold");
    }

    // 2) amount each user has bought shouldn't exceed max token buy per user
    //    the code only checks on a per-transaction basis, so a user can
    //    buy over their limit through multiple smaller buys
    function crytic_max_token_buy_per_user() public{
        for(uint256 i; i<buyers.length; ++i) {
            address buyer = buyers[i];
            
            if(sellToken.balanceOf(buyer) > MAX_TOKENS_PER_BUYER) {
                t(false, "Invariant 2 broke: user exceeds max tokens per buyer");
            }
        }

        t(true, "test 2 passed: no user exceeds max tokens per buyer");
    }

    // function crytic_this_should_fail() public{
    //     t(false, "test 3 passed: should fail");
    // }



    ///// Property mode /////

    // function crytic_tokens_bought_eq_tokens_sold() public view returns(bool) {
    //     uint256 soldAmount = tokenSale.getSellTokenSoldAmount();
    //     uint256 boughtBal  = buyToken.balanceOf(address(this));

    //     // scale up `boughtBal` by the precision difference
    //     boughtBal *= 10 ** (SELL_DECIMALS - BUY_DECIMALS);

    //     // assert the equality; if this breaks that means something
    //     // has gone wrong with the buying and selling. In our private
    //     // audit there was a precision miscalculation that allowed
    //     // an attacker to buy the sale tokens without paying due to
    //     // rounding down to zero
    //     return(boughtBal == soldAmount);
    // }


    // // 2) amount each user has bought shouldn't exceed max token buy per user
    // //    the code only checks on a per-transaction basis, so a user can
    // //    buy over their limit through multiple smaller buys
    // function crytic_max_token_buy_per_user() public view returns(bool) {
    //     for(uint256 i; i<buyers.length; ++i) {
    //         address buyer = buyers[i];
            
    //         if(sellToken.balanceOf(buyer) > MAX_TOKENS_PER_BUYER) {
    //             return false;
    //         }
    //     }

    //     return true;
    // }
}
