// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./EventNFT.sol";

contract EventManager {
    EventNFT public eventNFT;

    struct Event {
        string name;
        uint256 id;
        bool exists;
    }

    mapping(uint256 => Event) public events;  // Stores event details by eventId
    mapping(uint256 => mapping(address => bool)) public registrations; // Track who registered for each event

    constructor(EventNFT _eventNFT) {
        eventNFT = _eventNFT;
    }

    // Create a new event with a specific eventId
    function createEvent(uint256 eventId, string memory eventName) public {
        require(!events[eventId].exists, "Event with this ID already exists");
        events[eventId] = Event(eventName, eventId, true);
    }

    // Register for an event if the user holds the correct NFT
    function registerForEvent(uint256 eventId) public {
        require(events[eventId].exists, "Event does not exist");
        require(eventNFT.balanceOf(msg.sender) > 0, "You must hold an NFT to register");

        uint256 tokenId = getTokenForEvent(msg.sender, eventId);
        require(tokenId != 0, "You do not own the required NFT for this event");
        require(!registrations[eventId][msg.sender], "Already registered for this event");

        registrations[eventId][msg.sender] = true;
    }

    // Helper function to check if the user owns an NFT for the event
    function getTokenForEvent(address user, uint256 eventId) internal view returns (uint256) {
        uint256 balance = eventNFT.balanceOf(user);
        for (uint256 i = 0; i < balance; i++) {
            uint256 tokenId = eventNFT.tokenOfOwnerByIndex(user, i);
            if (eventNFT.getEventIdForToken(tokenId) == eventId) {
                return tokenId;
            }
        }
        return 0;
    }

    // Check if a user is registered for an event
    function isRegistered(uint256 eventId, address user) public view returns (bool) {
        return registrations[eventId][user];
    }
}
