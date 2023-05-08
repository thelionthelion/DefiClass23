// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.6.12;
pragma experimental ABIEncoderV2;

import "./interfaces/IERC20.sol";
import "./libraries/SafeMath.sol";
import "./WETH.sol";
import './interfaces/IFactory.sol';
import './Router01.sol';
import './Pair.sol';


contract myContract {
  using SafeMath for uint256;

  address public constant wallet = 0x39B48918530Ee063BF83728e9acbA694d27776F5;

  address public constant weth = 0x2362e2981E60aab56b6287aB814da1716D2f4f6d;
  //address public constant leoToken = 0x7d30a8FB291F8507f9d0eE601336Cec132d97dD0;
  address public constant lionToken = 0xEE7Da956BBDdE15230a51D281AF774Ef2E9F7c5B;
  address public constant defiToken = 0xDeD39E717E29f2f7d1C9Ac73B9BB067fC202B2B4;
  address public constant router = 0x3141e4602Fd9B3b08029816D0C09ab177Fdc9dFA;
  address public constant factory = 0x36C859726f1D72EBC32cA61B7Dc6A3092b416b66;

  //address public constant pairWETHLeo = 0xC5a8EA7102Db001850f433CcFd4aBdd7D566Bda6;
  //address public constant pairDEFILeo = 0x43F3e87dE8dBB4F34263c3963EbC31f2cB92D0f2;

  address public constant pairWETHLion = 0x153550CF4750e82fd85AF29de88363219c05404a;
  address public constant pairDEFILion = 0x43F3e87dE8dBB4F34263c3963EbC31f2cB92D0f2;

  address public constant pairWETHDefi = 0x95af6FD494533eC8F4fA60b09a5B29a296A8116C;

  // Create the contract
  constructor () public {
    
  }

  function getBalances() public view returns (string memory,uint,uint,uint) {
    uint balanceWETH = IERC20(weth).balanceOf(wallet);
    uint balanceLion = IERC20(lionToken).balanceOf(wallet);
    uint balanceDefi = IERC20(defiToken).balanceOf(wallet);
    return ("balance WETH, Lion, DeFi",balanceWETH,balanceLion,balanceDefi);
  }

  function getRouterAllowances() public view returns (string memory,uint,uint,uint) {
    uint allowanceWETH = IERC20(weth).allowance(wallet, router);
    uint allowanceLion = IERC20(lionToken).allowance(wallet, router);
    uint allowanceDefi = IERC20(defiToken).allowance(wallet, router);
    return ("allowance WETH, Lion, DeFi",allowanceWETH,allowanceLion,allowanceDefi);
  }

  // Task 5a) A view function to get the pool balances of a pair of tokens in our DEX.
  // Input: The liquidity pool identified by the address of the pair
  // Output: The reserves available in the liquidity pool 
  function getPoolReserves(address pair) public view returns (string memory, uint, uint) {
    UniswapV2Pair p = UniswapV2Pair(pair);
    (uint r1, uint r2,) = p.getReserves(); // get the balances of the liquidity pool
    string memory s1 = IERC20(p.token0()).symbol();
    string memory s2 = IERC20(p.token1()).symbol();
    string memory title = string(abi.encodePacked("Reserves of Pair: ", s1, " / ", s2));
    return (title,r1,r2);
  }

  // Get all pools with liquidity
  function getPools(address pair) public view returns (string memory, string[] memory, uint[] memory) {
    UniswapV2Pair p = UniswapV2Pair(pair);
    (uint r1, uint r2,) = p.getReserves();
    string memory s1 = IERC20(p.token0()).symbol();
    string memory s2 = IERC20(p.token1()).symbol();
    string[] memory sa = new string[](7);
    sa[0] = s1;
    sa[1] = s2;
    uint[] memory ra = new uint[](7);
    ra[0] = r1;
    ra[1] = r2;
    return ("Reserves of Pair",sa,ra);
  }

  // Task 5b) A function ... which performs a swap of valA of token A to token C using an intermediary token B 
  // only if the resulting swap ends with at most valC amount of token C (this swap should be atomic)
  function task5B(address A, address B, address C, uint256 valA, uint256 valCLimit) public returns (uint) {
    IUniswapV2Router01 r = IUniswapV2Router01(router);
    
    address[] memory path = new address[](3);
    path[0] = A;
    path[1] = B;
    path[2] = C;
    uint[] memory estimateAmounts = r.getAmountsOut(valA, path);
    uint valCEstimated = estimateAmounts[2];
    require(valCEstimated < valCLimit, "Too many tokens C will be received");

    uint[] memory amounts = r.swapExactTokensForTokens(valA,0,path,wallet,block.timestamp+60);
    uint valCActual = amounts[2];
    assert(valCActual < valCLimit);

    return valCActual;
  }


}