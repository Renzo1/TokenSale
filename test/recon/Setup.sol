
// SPDX-License-Identifier: GPL-2.0
pragma solidity ^0.8.0;

import {BaseSetup} from "@chimera/BaseSetup.sol";

import "../../src/TokenSale.sol";
import "../../src/TestToken.sol";

interface IHevm {
  function prank(address) external;
}

abstract contract Setup is BaseSetup {
  IHevm hevm = IHevm(address(0x7109709ECfa91a80626fF3989D68f67F5b1DD12D));

  uint8 internal constant SELL_DECIMALS = 18;
  uint8 internal constant BUY_DECIMALS  = 6;

  // total tokens to sell
  uint256 internal constant SELL_TOKENS = 1000e18;

  // buy tokens to give each buyer
  uint256 internal constant BUY_TOKENS  = 500e6;

  // number of buyers allowed in the token sale
  uint8 internal constant NUM_BUYERS    = 5;

  // max each buyer can buy
  uint256 internal constant MAX_TOKENS_PER_BUYER = 200e18;

  // allowed buyers
  address[] buyers;

  // contracts required for test
  ERC20     sellToken;
  ERC20     buyToken;
  TokenSale tokenSale;

  function setup() internal virtual override {
    sellToken = new TestToken(SELL_TOKENS, SELL_DECIMALS);
    buyToken  = new TestToken(BUY_TOKENS*NUM_BUYERS, BUY_DECIMALS);

    // setup the allowed list of buyers
    buyers.push(address(0x1000000000000000000000000000000000000000));
    buyers.push(address(0x2000000000000000000000000000000000000000));
    buyers.push(address(0x3000000000000000000000000000000000000000));
    buyers.push(address(0x4000000000000000000000000000000000000000));
    buyers.push(address(0x5000000000000000000000000000000000000000));

    assert(buyers.length == NUM_BUYERS);

    // setup contract to be tested
    tokenSale = new TokenSale(buyers,
      address(sellToken),
      address(buyToken),
      MAX_TOKENS_PER_BUYER,
      SELL_TOKENS);
    
    // fund the contract
    sellToken.transfer(address(tokenSale), SELL_TOKENS);

    /// verify setup ///
    // token sale tokens & parameters
    assert(sellToken.balanceOf(address(tokenSale)) == SELL_TOKENS);
    assert(tokenSale.getSellTokenTotalAmount() == SELL_TOKENS);
    assert(tokenSale.getSellTokenAddress() == address(sellToken));
    assert(tokenSale.getBuyTokenAddress() == address(buyToken));
    assert(tokenSale.getMaxTokensPerBuyer() == MAX_TOKENS_PER_BUYER);
    assert(tokenSale.getTotalAllowedBuyers() == NUM_BUYERS);

    // no tokens have yet been sold
    assert(tokenSale.getRemainingSellTokens() == SELL_TOKENS);

    // this contract is the creator
    assert(tokenSale.getCreator() == address(this));

    // constrain fuzz test senders to the set of allowed buying addresses
    // done in yaml config for echidna


    // distribute tokens to buyers
    for(uint256 i; i<buyers.length; ++i) {
      address buyer = buyers[i];

      // distribute buy tokens to buyer
      buyToken.transfer(buyer, BUY_TOKENS);
      assert(buyToken.balanceOf(buyer) == BUY_TOKENS);

      // buyer approves token sale contract to prevent reverts
      hevm.prank(buyer);
      buyToken.approve(address(tokenSale), type(uint256).max);
    }

    // no buy tokens yet received, all distributed to buyers
    assert(buyToken.balanceOf(address(this)) == 0);
  }
}
