// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract transnmber{

    mapping (bytes1  => uint) public transnumToName;

     constructor() {
        // 初始化罗马字符对应的数值
        transnumToName['I'] = 1;
        transnumToName['V'] = 5;
        transnumToName['X'] = 10;
        transnumToName['L'] = 50;
        transnumToName['C'] = 100;
        transnumToName['D'] = 500;
        transnumToName['M'] = 1000;
    }
    function setTransnum(string calldata roma) public view  returns (uint) {
       uint len = bytes(roma).length;
       bytes memory m = bytes(roma);
       uint romaNumber;
       uint prevalue = 0;
       for (uint i =len;i > 0; i--){
         bytes1 currentChar = m[i-1];
         uint currentValue = transnumToName[currentChar];
         if (currentValue < prevalue){
            romaNumber  -= currentValue;
         }else {
            romaNumber += currentValue;
         }
         prevalue = currentValue;
       }
       return romaNumber;
    }
}