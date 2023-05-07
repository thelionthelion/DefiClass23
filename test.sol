// SPDX-License-Identifier: XXX
pragma solidity =0.6.12;

import "hardhat/console.sol";

contract test {
 
    constructor() public {
        console.log("constructor END");
    }

    function aaa() view external {
        console.log("log AAA");
    }

}