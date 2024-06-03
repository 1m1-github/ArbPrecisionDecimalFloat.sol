// SPDX-License-Identifier: GPL-3.0-only
pragma solidity ^0.8.25;

import 'forge-std/console2.sol';
import {Test} from 'forge-std/Test.sol';
import {ArbPrecisionDecimalFloat as APDF} from '../src/ArbPrecisionDecimalFloat.sol';

contract TestArbPrecisionDecimalFloat is Test {
    function test_add() public pure {
        uint PRECISION = 10;
        APDF.DecimalFloat memory a = APDF.DecimalFloat(1, 0);
        APDF.DecimalFloat memory b = APDF.DecimalFloat(1, -1);
        APDF.DecimalFloat memory c = APDF.add(a, b, PRECISION);
        assert(c.c == 11);
        assert(c.q == -1);
    }

    function test_mul() public pure {
        uint PRECISION = 10;
        APDF.DecimalFloat memory a = APDF.DecimalFloat(1, 0);
        APDF.DecimalFloat memory b = APDF.DecimalFloat(1, -1);
        APDF.DecimalFloat memory c = APDF.multiply(a, b, PRECISION);
        assert(c.c == 1);
        assert(c.q == -1);
    }

    function test_inv() public pure {
        uint PRECISION = 10;
        APDF.DecimalFloat memory a = APDF.DecimalFloat(2, 0);
        APDF.DecimalFloat memory b = APDF.inverse(a, PRECISION);
        assert(b.c == 5);
        assert(b.q == -1);
    }

    function test_exp() public pure {
        uint PRECISION = 20;
        uint STEPS = 15;
        APDF.DecimalFloat memory a = APDF.DecimalFloat(1, 0);
        APDF.DecimalFloat memory b = APDF.exp(a, PRECISION, STEPS);
        assert(b.c / 1e10 == 27182818284);
        assert(b.q + 10 == -10);
    }
}
