// SPDX-License-Identifier: MIT
pragma solidity >= 0.8.0;
import "./ERC20.sol";

contract Resort{
    
    //Token contract instance
    ERC20Basic private token;

    //Resort address
    address payable public owner;

    //Constructor
    constructor(){
        token = new ERC20Basic(10000);
        owner = payable(msg.sender);
    }

    //Data structure to store resort clients
    struct client{
        uint tokens_amount;
        string [] favorite_attractions;
    }

    //Mapping for Client Register
    mapping (address => client) public Clients;

    //functions

    //Set Token price
    function tokenPrice(uint _tokenAmount) internal pure returns (uint){
        //1 token = 1 ETH
        return _tokenAmount * (1 ether);
    }

    //Buy Tokens
    function buyTokens(uint _tokenAmount) public payable{
        //total price cost
        uint cost = tokenPrice(_tokenAmount);
        require(msg.value >= cost,"Insufficient amount");
        uint returnValue = msg.value - cost;
        payable(msg.sender).transfer(returnValue);
        uint Balance = balanceOf();
        require(_tokenAmount <= Balance, "Transaction failed");
        token.transfer(msg.sender,_tokenAmount);
        Clients[msg.sender].tokens_amount += _tokenAmount;

    }

    function balanceOf() public view returns(uint){
        return token.balanceOf(address(this)); 
    }

}