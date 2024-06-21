https://github.com/1m1-github/EVMPlus/tree/main/core/vm/decimal_float.go as a Solidity lib

`forge test`:  
[PASS] test_add() (gas: 7167)  
[PASS] test_exp() (gas: 228857)  
[PASS] test_inv() (gas: 9258)  
[PASS] test_ln() (gas: 978257)  
[PASS] test_mul() (gas: 5970)  
[PASS] test_sin() (gas: 284400)  


to compare opcode vs non-opcode gas costs:
exp(1), precision 10, steps 10:
gas as opcode: 5419
gas as non-opcode: 144806
savings factor: 228857 / 5419 ~ 40
