
// SPDX-License-Identifier: GPL-2.0
pragma solidity ^0.8.0;

import {BaseTargetFunctions} from "@chimera/BaseTargetFunctions.sol";
import {BeforeAfter} from "./BeforeAfter.sol";
import {Properties} from "./Properties.sol";
import {vm} from "@chimera/Hevm.sol";

abstract contract TargetFunctions is BaseTargetFunctions, Properties, BeforeAfter {

    function tokenSale_buy(uint256 amountToBuy) public {
      vm.prank(msg.sender);
      tokenSale.buy(amountToBuy);
    }

    function tokenSale_endSale() public {
      vm.prank(msg.sender);
      tokenSale.endSale();
    }

    // function this_should_fail(uint256 _a) public {
    //   uint256 a = _a ** 2;
    //   t(a > _a, "This should always fail");
    // }

}
