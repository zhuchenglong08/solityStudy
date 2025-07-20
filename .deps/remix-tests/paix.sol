// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract pai{

    function mergeArrays(uint[] memory arry1,uint[] memory arry2) public pure returns (uint[] memory array){
        uint alength = arry1.length;
        uint blength = arry1.length;
        uint[] memory merged = new uint[](alength + blength);
        uint i = 0;
        uint j = 0;
        uint k = 0;
        
        // 比较两个数组元素并按顺序合并
        while (i <alength && j < blength) {
            if (arry1[i] < arry2[j]) {
                merged[k++] = arry1[i++];
            } else {
                merged[k++] = arry2[j++];
            }
        }
        
        // 复制剩余的元素
        while (i < alength) {
            merged[k++] = arry1[i++];
        }
        
        while (j < blength) {
            merged[k++] = arry2[j++];
        }
        
        return merged;

    }
}