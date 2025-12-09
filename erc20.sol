// SPDX-License-Identifier: MIT
pragma solidity 0.8.30;

contract erc_20 {
    string public constant name = "DANCOIN";
    string public constant symbol = "DAN";
    uint256 public constant decimal = 18;
    uint256 public totalSupply;
    address reductionfee = 0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2;
    
    mapping (address => uint256) public balanceOf;
    mapping (address => mapping (address =>uint256)) public  allowance;

    event Transfer ( address indexed  from, address indexed to, uint256 value);
    event Approval (address indexed owner, address indexed spender, uint256 value);

    function transfer(address to, uint256 value) external  returns (bool) {
        emit Transfer(msg.sender,to, value);
        require(value <= balanceOf[msg.sender], "insuficient fund ");
        balanceOf [msg.sender] -=  value;
        uint fee = value * 1/100;
        balanceOf[reductionfee] += fee;
        balanceOf [to] += value - fee;
        return true; 
    } 

    function givetoken() external {
        balanceOf[msg.sender] += 1e18;
    }
    
    // transferfrom function
    function transferfrom(address from, address to, uint value) public   returns (bool){
        emit Transfer(msg.sender,to, value);
        emit Approval(from, msg.sender, value);
        // checking balance 
       require(allowance [from][msg.sender] >= value, "insufficient fund " );
       require(balanceOf[from] >= value, "insufficiient fund");
       //checking allowance
       allowance[from][msg.sender] -= value;
       // account which the money is being from
       balanceOf [from] -= value;

        uint fee = value * 1/100;
        balanceOf[reductionfee] += fee;      
        // acount money is being sent to
        balanceOf [to] += value - fee;
       
        return true;
    }
    
    function approve(address spender, uint256 value) external  returns (bool){
        require(balanceOf [msg.sender] >= value, "insuficient");
        emit Approval(msg.sender, spender, value);
        // fund owner giving permission     
        allowance[msg.sender][spender] += value;
        return true;
    }
}