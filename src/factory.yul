object "factory" {
    code {
            {
                let ptr := memoryguard(0x0100)
                mstore(0x40, ptr)
                let freePtr := mload(0x40)
                let paramSize := sub(codesize(),datasize("factory"))
                codecopy(ptr,datasize("factory"),paramSize)
                mstore(0x40,add(freePtr,paramSize))
                let ethTempAddr := mload(add(ptr,0x00))
                let ethMissTemp := mload(add(ptr,0x20))
                let ercTemplate := mload(add(ptr,0x40))
                let ercMissTemp := mload(add(ptr,0x60))
                let feeReciver := mload(add(ptr,0x80))
                let feeMulti := mload(add(ptr,0xa0))
                constructor(ethTempAddr,ethMissTemp,ercTemplate,ercMissTemp,feeReciver,feeMulti)
                freePtr := mload(0x40)
                codecopy(freePtr,dataoffset("runtimecode"),datasize("runtimecode"))
                setimmutable(freePtr,"ethTemplate",ethTempAddr)
                setimmutable(freePtr,"ethMissTemp",ethMissTemp)
                setimmutable(freePtr,"ercTemplate",ercTemplate)
                setimmutable(freePtr,"ercMissTemp",ercMissTemp)
                return(freePtr,datasize("runtimecode"))
            }
            function constructor(ethTempAddr,ethMissTemp,ercTemplate,ercMissTemp,feeReciver,feeMulti) {
                sstore(0x00, caller())
                log3(0,0,0x8be0079c531659141344cd1fd0a4f28419497f9722a3daafe3b4186f6b6457e0,0x0000000000000000000000000000000000000000000000000000000000000000,caller())
                sstore(0x01, feeReciver)
                let freePtr := mload(0x40)
                if gt(feeMulti,0x16345785d8a0000) {
                    mstore(freePtr,           0x08c379a000000000000000000000000000000000000000000000000000000000)
                    mstore(add(freePtr,0x04), 0x0000000000000000000000000000000000000000000000000000000000000020)
                    mstore(add(freePtr,0x24), 0x000000000000000000000000000000000000000000000000000000000000000d)
                    mstore(add(freePtr,0x44), 0x46656520746f6f206c6172676500000000000000000000000000000000000000)
                    revert(freePtr, 0x64)
                }
                sstore(0x02, feeMulti)
            }
        
    }
    object "runtimecode" {
        code {
            {
                let ptr := mload(0x40)
                if eq(calldatasize(),0) {
                    revert(0,0)
                }
                let selector := shr(224,calldataload(0x00))
                switch selector 
                case 0xce9c095d {
                    if gt(callvalue(),0) {
                        revert(0,0)
                    }
                    let addr
                    {
                        // let nft := calldataload(0x04)
                        // let bondingCurve := calldataload(0x24)
                        // let assetReceipient := calldataload(0x44)
                        // let poolType := calldataload(0x64)
                        // let delta := calldataload(0x84)
                        // let fee := calldataload(0xa4)
                        // let spotPrice := calldataload(0xc4)
                        // let initOffset := calldataload(0xe4)
                        // let initLen := calldataload(add(0x04,initOffset))
                        if lt(calldatasize(),0xf4) {
                            revert(0,0)
                        }

                        addr := createPairETH(
                            calldataload(0x04),
                            calldataload(0x24),
                            calldataload(0x44),
                            calldataload(0x64),
                            calldataload(0x84),
                            calldataload(0xa4),
                            calldataload(0xc4),
                            calldataload(0xe4),
                            calldataload(add(0x04,calldataload(0xe4)))
                        )
                    }
                    
                    mstore(ptr,addr)
                    return(ptr,0x20)
                }
                case 0x4bf107c1 { //setBondingCurveAllowed
                    if gt(callvalue(),0) {
                        revert(0,0)
                    }
                    let owner := sload(0x00)
                    let freePtr := mload(0x40)
                    if iszero(eq(owner,caller())) {
                        mstore(freePtr,           0x08c379a000000000000000000000000000000000000000000000000000000000)
                        mstore(add(freePtr,0x04), 0x0000000000000000000000000000000000000000000000000000000000000020)
                        mstore(add(freePtr,0x24), 0x000000000000000000000000000000000000000000000000000000000000000a)
                        mstore(add(freePtr,0x44), 0x6f6e6c79206f776e657200000000000000000000000000000000000000000000) // only owner
                        revert(freePtr, 0x64)
                    }
                    let bondingCurve := calldataload(0x04)
                    let isAllowed := calldataload(0x24)
                    mstore(0,bondingCurve)
                    mstore(0x20, 0x03)
                    let key := keccak256(0x00, 0x40)
                    sstore(key, isAllowed)
                    log1(0x00,0x40,0x1da28d127ec72d2dde6a533c98857664b25cd827680fb1f39f57394c2b444d91)
                }
            }
            
            function createPairETH(nft,bondingCurve,assetReceipient,poolType,delta,fee,spotPrice,initOffset,initLen) -> pair {
                let freePtr := mload(0x40)
				{
					mstore(0x00, bondingCurve)
					mstore(0x20, 0x03)
					let key := keccak256(0x00,0x40)
					let res := sload(key)
                    res := and(res, 0xff)
					if eq(res,0) {
						mstore(freePtr,           0x08c379a000000000000000000000000000000000000000000000000000000000)
						mstore(add(freePtr,0x04), 0x0000000000000000000000000000000000000000000000000000000000000020)
						mstore(add(freePtr,0x24), 0x000000000000000000000000000000000000000000000000000000000000001d)
						mstore(add(freePtr,0x44), 0x426f6e64696e67206375727665206e6f742077686974656c6973746564000000)
						revert(freePtr, 0x64)
					}
				}
                
                mstore(freePtr,             0x01ffc9a700000000000000000000000000000000000000000000000000000000) //supportsInterface(bytes4)
                mstore(add(freePtr,0x04),   0x00000000000000000000000000000000000000000000000000000000780e9d63) //interfaceId
                let success := staticcall(gas(),nft,freePtr,0x24,freePtr,0x20) //i know the return value must be a boolean
                let res := mload(freePtr)
                let template := loadimmutable("ethMissTemp")
                if and(success,res) {
                    template := loadimmutable("ethTemplate")
                }
                pair := cloneETHPair(template,address(),bondingCurve,nft,poolType)
                initializePairETH(pair,nft,assetReceipient,delta,fee,spotPrice,initOffset,initLen)
                mstore(freePtr,pair)
                log1(freePtr,0x20,0xf5bdc103c3e68a20d5f97d2d46792d3fdddfa4efeb6761f8141e6a7b936ca66c)
            }
            function cloneETHPair(template,factory,bondingCurve,nft,poolType) -> pair {
                let freePtr := mload(0x40)
                mstore(freePtr,             0x60723d8160093d39f33d3d3d3d363d3d37603d6035363936603d013d73000000)
                mstore(add(freePtr,0x1d), shl(0x60, template))
                mstore(add(freePtr,0x31),   0x5af43d3d93803e603357fd5bf300000000000000000000000000000000000000)
                mstore(add(freePtr,0x3e), shl(0x60, factory))
                mstore(add(freePtr,0x52), shl(0x60, bondingCurve))
                mstore(add(freePtr,0x66), shl(0x60, nft))
                mstore8(add(freePtr,0x7a), poolType)
                pair := create(0,freePtr, 0x7b)
            }
            function initializePairETH(pair,nft,assetReceipient,delta,fee,spotPrice,initOffset,initLen) {
                let freePtr := mload(0x40)
                mstore(freePtr,             0xfd17aef900000000000000000000000000000000000000000000000000000000)
                mstore(add(freePtr,0x04),   address())
                mstore(add(freePtr,0x24),   assetReceipient)
                mstore(add(freePtr,0x44),   delta)
                mstore(add(freePtr,0x64),   fee)
                mstore(add(freePtr,0x84),   spotPrice)
                pop(call(gas(),pair,0,freePtr,0xa4,0,0))
				// pop(delta)
				// pop(fee)
				// pop(spotPrice)
                let success := call(gas(),pair,callvalue(),0,0,0,0)
                if eq(success, 0) {
                    mstore(freePtr,           0x08c379a000000000000000000000000000000000000000000000000000000000)
                    mstore(add(freePtr,0x04), 0x0000000000000000000000000000000000000000000000000000000000000020)
                    mstore(add(freePtr,0x24), 0x0000000000000000000000000000000000000000000000000000000000000013)
                    mstore(add(freePtr,0x44), 0x4554485f5452414e534645525f4641494c454400000000000000000000000000)
                    revert(freePtr, 0x64)
                }
                let i := 0
                let len := initLen
                for {} lt(i,len) {} {
                    let start := add(initOffset,mul(0x20,i))
                    let tokenId := calldataload(start)
                    mstore(freePtr,           0xb88d4fde00000000000000000000000000000000000000000000000000000000)
                    mstore(add(freePtr,0x04), caller())
                    mstore(add(freePtr,0x24), pair)
                    mstore(add(freePtr,0x44), tokenId)
                    let success2 := call(gas(),nft,0,freePtr,0x64,0,0)
                    if eq(success2, 0) {
                        mstore(freePtr,           0x08c379a000000000000000000000000000000000000000000000000000000000)
                        mstore(add(freePtr,0x04), 0x0000000000000000000000000000000000000000000000000000000000000020)
                        mstore(add(freePtr,0x24), 0x0000000000000000000000000000000000000000000000000000000000000013)
                        mstore(add(freePtr,0x44), 0x4554485f5452414e534645525f4641494c454400000000000000000000000000)
                        revert(freePtr, 0x64)
                    }
                }



            }
        }
    }

}
// data "params" hex"00000000000000000000000008ce97807a81896e85841d74fb7e7b065ab3ef05000000000000000000000000cd80c916b1194beb48abf007d0b79a7238436d56000000000000000000000000d42638863462d2f21bb7d4275d7637ee5d5541eb00000000000000000000000092de3a1511ef22abcf3526c302159882a4755b2200000000000000000000000075d4bdbf6593ed463e9625694272a0ff9a6d346f000000000000000000000000000000000000000000000000002386f26fc10000"

