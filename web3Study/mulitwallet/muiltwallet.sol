// SPDX-License-Identifier: MIT
pragma solidity ^0.8.3;

contract multWallet {
    //审批事件结构
    struct Transction{
        uint txId;
        uint value;
        address from;
        address to;
        bytes data;
        uint cont;
        address[] approvals;
        bool excuted;
    }
    fallback() external payable { }
    receive() external payable { }
    mapping(uint =>Transction) public transctions;//审批列表
    mapping(uint => mapping (address => bool)) public Approveds; //审批状态
    event Submit(address indexed owner, uint indexed index);//提交事件
    event Approval(address indexed owner, uint indexed index); //审批事件
    event Revoke(address indexed owner, uint indexed index); //撤销事件
    event Execute(address indexed owner, uint indexed index);//执行事件
   
   modifier txExists(uint txId){
       Transction storage _transction = transctions[txId];
       require(_transction.txId != 0,"tx is not exists");
       _;
   }
    modifier txNotExists(uint txId){
       Transction storage _transction = transctions[txId];
       require(_transction.txId == 0,"tx is  exists");
       _;
   }
    modifier isOwner(uint  txId){
        Transction storage _transction = transctions[txId];
        require(msg.sender == _transction.from,"not is owner");
        _;
    }

     modifier noApproved(uint  txId){
        bool isApprovel =  Approveds[txId][msg.sender];
        require(!isApprovel, "is approved");
        _;
    }

    modifier isApproved(uint  txId){
        bool isApprovel =  Approveds[txId][msg.sender];
        require(isApprovel, "is not approved");
        _;
    }

    modifier noExecute(uint  txId){
     Transction storage _transction = transctions[txId]; 
     require(!_transction.excuted,"is not excuted");
     _;
    }

    modifier isApprovers(uint txId){
        address[] memory approverss = transctions[txId].approvals;
        for(uint i = 0;i < approverss.length;i++){
            require(Approveds[txId][approverss[i]],"is not approvers");
        }
        _;
    }
  
    function submit(uint txId,address to,uint value,uint cont,address[] memory approvers)external txNotExists(txId)  {
        Transction memory _transction = Transction(txId,value,msg.sender,to,msg.data,cont,approvers,false);
        transctions[txId] = _transction;
        emit Submit(msg.sender, txId);
    }

    function execute(uint txId)external  txExists(txId) isOwner(txId) isApprovers(txId) noExecute(txId) payable {
        Transction storage _transction = transctions[txId];
        _transction.excuted = true;
        (bool sucess,)=_transction.to.call{value: _transction.value}(_transction.data);
        require(sucess,"execute faild");
        emit Execute(msg.sender, txId);
    }

    function approve(uint txId)external txExists(txId) noApproved(txId) {
        Approveds[txId][msg.sender] = true; 
        emit Approval(msg.sender, txId);
    }

    //撤销审批
    function revoke(uint txId)external txExists(txId) isApproved(txId) noExecute(txId) {
        Approveds[txId][msg.sender] = false;
        emit Revoke(msg.sender, txId);
    }
    
}