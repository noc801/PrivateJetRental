// Nicholas Cochran, Thomas Coyle, Jake Stiegler
// designate license & Solidity version
// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <0.9.0;

contract PrivateJetRental {
    // Designate contract owner
    address payable public owner;
    // State Variables
    bool public available;
    uint public ratePerHour;

    // Event
    event Log(address indexed sender, string message);

    // Constructor 
    constructor() {
        owner = payable(msg.sender);
        available = true;
        ratePerHour = 2 ether;
    }

    // Modifiers
    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can do this.");
        _;
    }

    modifier changeOwner {
         require(msg.sender == owner);
       _;
   }

    // Public Functions
    function rentJet(uint numHours) public payable {
        require(available, "Jet is unavailable.");

        uint minOffer = ratePerHour * numHours;
        require(msg.value >= minOffer, "Insufficient funds.");

        (bool sent, bytes memory data) = owner.call{value: msg.value}("");
        if (sent) {
        available = false;
        emit Log(msg.sender, "Jet has been rented.");
        }
    }

    function updateRate(uint newRate) public onlyOwner {
        ratePerHour = newRate;
        emit Log(msg.sender, "Jet price has been adjusted.");
    }

    function makeJetAvailable() public onlyOwner {
        available = true;
        emit Log(msg.sender, "Jet available to rent");
    }

    function transferJetOwnership(address newOwner) onlyOwner changeOwner public {
        owner = payable(newOwner);
        emit Log(msg.sender, "Ownership of jet has been transfered.");
    }

}
