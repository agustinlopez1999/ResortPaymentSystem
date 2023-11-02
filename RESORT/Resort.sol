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


}