// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract search{

    function midSeach(uint[] memory  arry1,uint tagert)public pure returns (bool flag,uint a){
        uint i = 0;
        uint le =arry1.length;

        while (i < le ){
            uint mid = (le + i) /2;
            if (arry1[mid] == tagert){
                return (true,mid);
            }else if (arry1[mid] > tagert){
                le = mid -1;
            }else {
                i = mid ;
            }
        }
        return (false, 0);
    }
}