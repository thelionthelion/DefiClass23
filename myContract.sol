// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.10;

import "./libraries/SafeMath.sol";

contract myContract {
  using SafeMath for uint256;

  address public constant weth = 0x2362e2981E60aab56b6287aB814da1716D2f4f6d;
  address public constant leoToken = 0x7d30a8FB291F8507f9d0eE601336Cec132d97dD0;
  address public constant defiToken = 0xDeD39E717E29f2f7d1C9Ac73B9BB067fC202B2B4;
  address public constant router = 0x3141e4602Fd9B3b08029816D0C09ab177Fdc9dFA;
  address public constant factory = 0x36C859726f1D72EBC32cA61B7Dc6A3092b416b66;


  // Create the contract
  constructor () {
    
  }

  function GetWeth() public pure returns (address) {
    return weth;
  }



}