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
    function add(DecimalFloat memory a, DecimalFloat memory b, uint PRECISION) public pure returns (DecimalFloat memory) {
        int ca = addHelper(a, b);
        int cb = addHelper(b, a);
        int q = signedMin(a.q, b.q);
        DecimalFloat memory out = DecimalFloat(ca + cb, q);
        return normalize(out, PRECISION, false);
    }
    function negate(DecimalFloat memory a) public pure returns (DecimalFloat memory) {
        return DecimalFloat(-a.c, a.q);
    }
    function multiply(DecimalFloat memory a, DecimalFloat memory b, uint PRECISION) public pure returns (DecimalFloat memory) {
        DecimalFloat memory out = DecimalFloat(a.c * b.c, a.q + b.q);
        return normalize(out, PRECISION, false);
    }
    function inverse(DecimalFloat memory a, uint PRECISION) public pure returns (DecimalFloat memory) {
        int precision_m_aq = int(PRECISION) - a.q;
        if (precision_m_aq < 0) revert("precision_m_aq < 0");
        
        precision_m_aq = int(10 ** uint(precision_m_aq));
        DecimalFloat memory out = DecimalFloat(precision_m_aq / a.c, -int(PRECISION));
        return normalize(out, PRECISION, false);
    }
    function exp(DecimalFloat memory a, uint PRECISION, uint STEPS) public pure returns (DecimalFloat memory) {
        DecimalFloat memory out = DecimalFloat(1, 0);

        if (a.c == 0) return out;

        DecimalFloat memory factorial_inv;
        DecimalFloat memory a_power = DecimalFloat(1, 0);
        DecimalFloat memory factorial = DecimalFloat(1, 0);
        DecimalFloat memory factorial_next = DecimalFloat(0, 0);

        for (uint i = 0; i < STEPS; i++) {
            a_power = multiply(a_power, a, PRECISION);
            factorial_next = add(factorial_next, DecimalFloat(1, 0), PRECISION);
            factorial = multiply(factorial, factorial_next, PRECISION);
            factorial_inv = inverse(factorial, PRECISION);
            factorial_inv = multiply(factorial_inv, a_power, PRECISION);
            out = add(out, factorial_inv, PRECISION);
        }

        return out;
    }
    function sin(DecimalFloat memory a, uint PRECISION, uint STEPS) public pure returns (DecimalFloat memory) {}
    function ln(DecimalFloat memory a, uint PRECISION, uint STEPS) public pure returns (DecimalFloat memory) {}
    function lnHelper(DecimalFloat memory a, uint PRECISION, uint STEPS) private pure returns (DecimalFloat memory) {}
    function lnRecursion(DecimalFloat memory a, DecimalFloat memory two_y_plus_x, uint recursionStep, uint PRECISION, uint MAX_STEPS) private pure  returns (DecimalFloat memory) {}
    function ln10(uint PRECISION, uint STEPS) private pure  returns (DecimalFloat memory) {}
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
    function normalize(DecimalFloat memory a, uint PRECISION, bool rounded) private pure  returns (DecimalFloat memory) {
        (int p, int ten_power) = find_num_trailing_zeros_signed_DECIMAL256(a.c);
        int out_c = a.c / ten_power;
        int out_q;
        if (out_c != 0 || a.c < 0) out_q = a.q + p;
        DecimalFloat memory out = DecimalFloat(out_c, out_q);
        if (rounded) return out;
        return round(out, PRECISION, true);
    }
    function round(DecimalFloat memory a, uint PRECISION, bool normalized) private pure  returns (DecimalFloat memory) {
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