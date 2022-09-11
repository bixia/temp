for issue:
https://github.com/foundry-rs/foundry/issues/3174
you may check the LSSVMPairFactory.ir file for reference
and if you want to build the file by yourself, you may do the following things:
1. rename the .yul file to .ir file to make it buildable
2. run the following command
```js
forge inspect LSSVMPairFactory ir-optimized > LSSVMPairFactory.ir
```

for issue:
https://github.com/foundry-rs/foundry/issues/3173
the way to reproduce is:
```js
(base) ➜  temp git:(master) ✗ forge b
[⠆] Compiling...
[⠢] Compiling 44 files with 0.8.16
[⠆] Solc 0.8.16 finished in 6.06s
[⠰] Compiling 1 files with 0.8.16
[⠑] Solc 0.8.16 finished in 6.76ms
Error: 
Compiler run failed
warning[3420]: Warning: Source file does not specify required compiler version! Consider adding "pragma solidity ^0.8.16;"
--> src/Factory.sol



Field "settings.remappings" cannot be used for Yul.
```