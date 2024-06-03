// SPDX-License-Identifier: GPL-3.0-only
pragma solidity ^0.8.25;

import 'forge-std/console2.sol';
import {Test} from 'forge-std/Test.sol';
import {ArbPrecisionDecimalFloat as APDF} from '../src/ArbPrecisionDecimalFloat.sol';

contract TestArbPrecisionDecimalFloat is Test {
    function test_add() public {
        uint PRECISION = 10;
        APDF.DecimalFloat memory a = APDF.DecimalFloat(1, 0);
        APDF.DecimalFloat memory b = APDF.DecimalFloat(1, -1);
        APDF.DecimalFloat memory c = APDF.add(a, b, PRECISION);
        assert(c.c == 11);
        assert(c.q == -1);
    }
}
