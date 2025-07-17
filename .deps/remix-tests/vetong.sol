// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

contract voting {
    struct houUsers {
        string username;
        string gender;
        uint piao;
    }
    address public owner;
    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this function");
        _;
    }

    event Voted(address voter, string candidate);
    event VotesReset();

    //用户
    mapping (address => houUsers) public  houMap;
    // 记录某个候选人被哪些地址投过票
    mapping(string => mapping(address => bool)) public touMap;
    
    // 记录所有候选人的名字（方便reset操作）
    string[] public candidates;

    // 添加候选人信息
    function addCandidate(address _address, string memory _username, string memory _gender) public {
        houMap[_address] = houUsers(_username, _gender, 0);
    }

    //投票函数
    function vote (string calldata name1) external  returns (string memory ){
        //判断账户
        require(bytes(houMap[msg.sender].username).length != 0, "Voter not registered");      
        //判断是否投过票
        require(!touMap[name1][msg.sender], "You have already voted for this candidate");
        //投票记录
        touMap[name1][msg.sender] = true;

         if (houMap[address(bytes20(bytes(name1)))].piao == 0) {
            candidates.push(name1);
        }
        address candidateAddress = address(bytes20(bytes(name1)));
        houMap[candidateAddress].piao += 1;
        emit Voted(msg.sender, name1);
       return "ok";
    }
    
    function getVotes(string calldata name1) public view returns (uint) {
        address candidateAddress = address(bytes20(bytes(name1)));
        return houMap[candidateAddress].piao;
    }

      function resetVotes() public onlyOwner {
        for (uint i = 0; i < candidates.length; i++) {
            address candidateAddress = address(bytes20(bytes(candidates[i])));
            houMap[candidateAddress].piao = 0;
            
            // 清空投票记录
            // 实际中可能需要更复杂的逻辑来处理投票记录
        }
        emit VotesReset();
    }
    
    // 添加候选人到候选列表
    function addToCandidates(string memory name1) public onlyOwner {
        candidates.push(name1);
    }

}