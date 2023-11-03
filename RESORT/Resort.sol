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
        uint total_buyed_tokens;
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
        Clients[msg.sender].total_buyed_tokens += _tokenAmount;

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
    event enjoy_attraction(string,uint,address);
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

    //Close existing attraction
    function closeAttraction(string memory _attractionName) public onlyOwner(){
        Attractions[_attractionName].attraction_state = false;
        emit closed_attraction(_attractionName);
    }

    //Returns Available Resort attractions
    function availableAttractions() public view returns(string[] memory){
        return attractions;
    }

    //Pay for an attraction
    function useAttraction(string memory _attractionName) public{
        require(Attractions[_attractionName].attraction_state == true,"Attraction Close");
        uint attractionPrice = Attractions[_attractionName].attraction_price;
        require(myTokenAmount() >= attractionPrice,"Insufficient Balance");
        token.transferFromClient(msg.sender, address(this),attractionPrice);
        attractionsRecords[msg.sender].push(_attractionName);
        emit enjoy_attraction(_attractionName,attractionPrice,msg.sender);
    }

    //Returns client attraction records
    function Record() public view returns (string[] memory){
        return attractionsRecords[msg.sender];
    }

    //Client returns Tokens to Disney
    function returnTokens(uint _tokenAmount) public payable{
        require(_tokenAmount>=0,"Can't be negative!");
        require(_tokenAmount<=myTokenAmount(),"Insufficient Balance");
        token.transferFromClient(msg.sender,address(this),_tokenAmount);
        payable(msg.sender).transfer(tokenPrice(_tokenAmount));
    }

    

}