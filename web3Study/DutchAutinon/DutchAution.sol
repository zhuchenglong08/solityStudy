// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

interface IERC721   {
    function transferFrom(address from, address to, uint256 tokenId) external;
}

contract DutchAution{
    struct Dutch{
        address seller;
        IERC721 nft;
        uint nftId;
        uint startAt;
        uint endAt;
        uint startPrice;
        uint duration;
        uint discountRate;
    }
    Dutch[] public  DutchList;
    //当前地址的所有dutch
    mapping(address =>mapping (uint =>Dutch) ) public dutchs;
    //人的所有dutch
    mapping(address => mapping (uint =>Dutch)) Dutchmap;
    //出售
    function seller(uint  _startAt,address _nft,uint _nftid,uint _duration,uint _startPrice,uint _discountRate) external  {
        uint   startAt = _startAt;
        if (startAt < block.timestamp || startAt == 0){
            startAt = block.timestamp;
        }
        Dutch memory dutch = Dutch(msg.sender,IERC721(_nft),_nftid,startAt,0,_startPrice,_duration,_discountRate);
        Dutchmap[msg.sender][_nftid] = dutch;
        dutchs[_nft][_nftid]= dutch;
        DutchList.push(dutch);
    }
    //买卖
    function buy(address _nft,uint _nftid) external payable {
        Dutch memory dutch = dutchs[_nft][_nftid];
        require(block.timestamp >= dutch.startAt,"The auction has not started");
        if (block.timestamp > dutch.startAt +dutch.duration){
            delete dutchs[_nft][_nftid];
            revert("The auction has expired");
        }
        uint price = getPrice(_nft,_nftid);
        require(msg.value >= price,"The price is not enough");
        IERC721(_nft).transferFrom(dutch.seller,msg.sender,_nftid);
        if (msg.value > price) {
            payable(msg.sender).transfer(msg.value - price);
        }
        delete dutchs[_nft][_nftid];
    }

    //获取价格
    function getPrice(address _nft,uint _nftid) public view   returns(uint){
        Dutch memory dutch = dutchs[_nft][_nftid];
        uint price = dutch.startPrice - (block.timestamp - dutch.startAt)*dutch.discountRate;
        if (price > dutch.startPrice) {
            price = dutch.startPrice;
        }
        return price;
    }
    //获取当前地址已给NFt集合
}