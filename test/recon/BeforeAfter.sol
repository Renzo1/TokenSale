
// SPDX-License-Identifier: GPL-2.0
pragma solidity ^0.8.0;

import {Setup} from "./Setup.sol";

abstract contract BeforeAfter is Setup {

    struct Vars {
        uint256 tokenSale_getRemainingSellTokens;
        uint256 tokenSale_getSellTokenSoldAmount;
        uint256 tokenSale_getTotalAllowedBuyers;
    }

    Vars internal _before;
    Vars internal _after;

    function __before() internal {
        _before.tokenSale_getRemainingSellTokens = tokenSale.getRemainingSellTokens();
        _before.tokenSale_getSellTokenSoldAmount = tokenSale.getSellTokenSoldAmount();
        _before.tokenSale_getTotalAllowedBuyers = tokenSale.getTotalAllowedBuyers();
    }

    function __after() internal {
        _after.tokenSale_getRemainingSellTokens = tokenSale.getRemainingSellTokens();
        _after.tokenSale_getSellTokenSoldAmount = tokenSale.getSellTokenSoldAmount();
        _after.tokenSale_getTotalAllowedBuyers = tokenSale.getTotalAllowedBuyers();
    }
}
