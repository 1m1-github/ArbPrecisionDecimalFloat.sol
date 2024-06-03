// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13; // todo

// based on https://github.com/1m1-github/EVMPlus/blob/main/core/vm/decimal_float.go#L268

library ArbPrecisionDecimalFloat {

    // d = c * 10^q
    struct DecimalFloat {
        int c;
        int q;
    }

    // todo memory, calldata?
    function add(DecimalFloat memory a, DecimalFloat memory b, uint PRECISION) external returns (DecimalFloat memory) {}
    function negate(DecimalFloat memory a) external returns (DecimalFloat memory) {}
    function multiply(DecimalFloat memory a, DecimalFloat memory b, uint PRECISION) external returns (DecimalFloat memory) {}
    function inverse(DecimalFloat memory a, uint PRECISION) external returns (DecimalFloat memory) {}
    function exp(DecimalFloat memory a, uint PRECISION, uint STEPS) external returns (DecimalFloat memory) {}
    function sin(DecimalFloat memory a, uint PRECISION, uint STEPS) external returns (DecimalFloat memory) {}
    function ln(DecimalFloat memory a, uint PRECISION, uint STEPS) external returns (DecimalFloat memory) {}
    function lnHelper(DecimalFloat memory a, uint PRECISION, uint STEPS) private returns (DecimalFloat memory) {}
    function lnRecursion(DecimalFloat memory a, DecimalFloat memory two_y_plus_x, uint recursionStep, uint PRECISION, uint MAX_STEPS) private returns (DecimalFloat memory) {}
    function ln10(uint PRECISION, uint STEPS) private returns (DecimalFloat memory) {}
    function normalize(DecimalFloat memory a, uint PRECISION, bool rounded) external returns (DecimalFloat memory) {}
    function round(DecimalFloat memory a, uint PRECISION, bool normalized) external returns (DecimalFloat memory) {}
    function signedCmp(DecimalFloat memory a, DecimalFloat memory b) private returns (int) {}
    function addHelper(DecimalFloat memory a, DecimalFloat memory b) private returns (DecimalFloat memory) {}
}