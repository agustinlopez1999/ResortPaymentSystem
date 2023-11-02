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

    //Token Managment Functions:

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

    //Returns balance of contract tokens
    function balanceOf() public view returns(uint){
        return token.balanceOf(address(this)); 
    }

    //Returns balance of msg.sender
    function myTokenAmount() public view returns(uint){
        return token.balanceOf(msg.sender);
    }

    //Increase total supply
    function mintTokens(uint _tokenAmount) public onlyOwner(){
        token.increaseTotalSupply(_tokenAmount);
    }

    //Modifier onlyOwner
    modifier onlyOwner(){
        require(msg.sender == owner);
        _;
    }

    //Resort Managment:

    //Events
    event enjoy_attraction(string);
    event new_attraction(string,uint);
    event closed_attraction(string);

    //Data structure for attraction
    struct attraction{
        string attraction_name;
        uint attraction_price;
        bool attraction_state;
    }

    //Mapping for attraction
    mapping(string => attraction) public Attractions;

    //Arrray for store attraction names
    string[] attractions;

    //Mapping with client attraction record
    mapping(address => string[]) attractionsRecords;

    //Resort Managment functions:

    //Adds new attraction
    function newAttraction(string memory _attractionName, uint _price) public onlyOwner{
        Attractions[_attractionName] = attraction(_attractionName,_price,true);
        attractions.push(_attractionName);
        emit new_attraction(_attractionName,_price);
    }

    


}