// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
contract transnumToroma{
 struct Numeral {
        uint256 value;
        string symbol;
    }
    Numeral[] private numerals;
     constructor() {
        numerals.push(Numeral(1000, "M"));
        numerals.push(Numeral(900, "CM"));
        numerals.push(Numeral(500, "D"));
        numerals.push(Numeral(400, "CD"));
        numerals.push(Numeral(100, "C"));
        numerals.push(Numeral(90, "XC"));
        numerals.push(Numeral(50, "L"));
        numerals.push(Numeral(40, "XL"));
        numerals.push(Numeral(10, "X"));
        numerals.push(Numeral(9, "IX"));
        numerals.push(Numeral(5, "V"));
        numerals.push(Numeral(4, "IV"));
        numerals.push(Numeral(1, "I"));

    }

    function transnumToRoma(uint num) public view returns (string memory) {
        require(num > 0 && num < 4000, "Number must be between 1 and 3999");
        // 将数字转换为罗马数字字符串
        string memory result = "";
        uint _num = num;
        uint len = numerals.length;
        //遍历映射
        for (uint i = 0; i < len; i++) {
            while (_num >= numerals[i].value) {
                 _num -= numerals[i].value;
                 result = string.concat(result, numerals[i].symbol);
            }
        }

        return result;
    }
}