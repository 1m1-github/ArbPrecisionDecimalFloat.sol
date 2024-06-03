// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13; // todo

// based on https://github.com/1m1-github/EVMPlus/blob/main/core/vm/decimal_float.go#L268
import 'forge-std/console2.sol';
library ArbPrecisionDecimalFloat {

    // d = c * 10^q
    struct DecimalFloat {
        int c;
        int q;
    }
    
    // todo memory, calldata?
    function add(DecimalFloat memory a, DecimalFloat memory b, uint PRECISION) external returns (DecimalFloat memory) {
        int ca = addHelper(a, b);
        int cb = addHelper(b, a);
        int q = signedMin(a.q, b.q);
        DecimalFloat memory out = DecimalFloat(ca + cb, q);
        return normalize(out, PRECISION, false);
    }
    function negate(DecimalFloat memory a) external pure returns (DecimalFloat memory) {
        return DecimalFloat(-a.c, a.q);
    }
    function multiply(DecimalFloat memory a, DecimalFloat memory b, uint PRECISION) external returns (DecimalFloat memory) {
        // DecimalFloat memory out = DecimalFloat(ca + cb, q);
        // return normalize(out, PRECISION, false);
    }
    function inverse(DecimalFloat memory a, uint PRECISION) external returns (DecimalFloat memory) {}
    function exp(DecimalFloat memory a, uint PRECISION, uint STEPS) external returns (DecimalFloat memory) {}
    function sin(DecimalFloat memory a, uint PRECISION, uint STEPS) external returns (DecimalFloat memory) {}
    function ln(DecimalFloat memory a, uint PRECISION, uint STEPS) external returns (DecimalFloat memory) {}
    function lnHelper(DecimalFloat memory a, uint PRECISION, uint STEPS) private returns (DecimalFloat memory) {}
    function lnRecursion(DecimalFloat memory a, DecimalFloat memory two_y_plus_x, uint recursionStep, uint PRECISION, uint MAX_STEPS) private returns (DecimalFloat memory) {}
    function ln10(uint PRECISION, uint STEPS) private returns (DecimalFloat memory) {}
    function find_num_trailing_zeros_signed_DECIMAL256(int a) private pure returns (int p, int ten_power) {
        int b = a;
        if (b < 0) b = -b;

        p = 0;
        ten_power = 10;

        if (b != 0) {
            for (;;) {
                int m = b % ten_power;
                if (m != 0) break;
                p += 1;
                ten_power *= 10;
            }
        }
        ten_power /= 10;
    }
    function normalize(DecimalFloat memory a, uint PRECISION, bool rounded) private returns (DecimalFloat memory) {
        (int p, int ten_power) = find_num_trailing_zeros_signed_DECIMAL256(a.c);
        int out_c = a.c / ten_power;
        int out_q;
        if (out_c != 0 || a.c < 0) out_q = a.q + p;
        DecimalFloat memory out = DecimalFloat(out_c, out_q);
        if (rounded) return out;
        return round(out, PRECISION, true);
    }
    function round(DecimalFloat memory a, uint PRECISION, bool normalized) private returns (DecimalFloat memory) {
        int shift = a.q + int(PRECISION);
        if (signedCmp(shift, 0) == 1 || signedCmp(shift, a.q) == -1) {
            if (normalized) return DecimalFloat(a.c, a.q);
            return normalize(a, PRECISION, true);
        }

        shift = -shift;
        int ten_power = int(10 ** uint(shift));
        int out_c = a.c / ten_power;
        int out_q = a.q + shift;
        DecimalFloat memory out = DecimalFloat(out_c, out_q);
        if (normalized) return out;
        return normalize(out, PRECISION, true);
    }
    function signedCmp(int a, int b) private pure returns (int) {
        if (a == b) return 0;
        if (a < b) return -1;
        return 1;
    }
    function signedMin(int a, int b) private pure returns (int) {
        if (signedCmp(a, b) == -1) return a;
        return b;
    }
    function addHelper(DecimalFloat memory a, DecimalFloat memory b) private pure returns (int) {
        int exponent_diff = a.q - b.q;
        if (exponent_diff < 0) exponent_diff = 0;

        int out = int(10 ** uint(exponent_diff));
        return a.c * out;
    }
}