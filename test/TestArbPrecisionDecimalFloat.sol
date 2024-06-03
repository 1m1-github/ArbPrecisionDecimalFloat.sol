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

    function test_mul() public {
        uint PRECISION = 10;
        APDF.DecimalFloat memory a = APDF.DecimalFloat(1, 0);
        APDF.DecimalFloat memory b = APDF.DecimalFloat(1, -1);
        APDF.DecimalFloat memory c = APDF.multiply(a, b, PRECISION);
        assert(c.c == 1);
        assert(c.q == -1);
    }

    function test_inv() public {
        uint PRECISION = 10;
        APDF.DecimalFloat memory a = APDF.DecimalFloat(2, 0);
        APDF.DecimalFloat memory b = APDF.inverse(a, PRECISION);
        assert(b.c == 5);
        assert(b.q == -1);
    }
}
