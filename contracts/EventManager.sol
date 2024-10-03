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

    error EventAlreadyExists(uint256 eventId);
    error EventDoesNotExist(uint256 eventId);
    error NotAnNFTHolder(address user);
    error NoNFTForEvent(address user, uint256 eventId);
    error AlreadyRegistered(address user, uint256 eventId);

    constructor(EventNFT _eventNFT) {
        eventNFT = _eventNFT;
    }

    function createEvent(uint256 eventId, string memory eventName) public {
        validateEventDoesNotExist(eventId);
        events[eventId] = Event(eventName, eventId, true);
    }

    function registerForEvent(uint256 eventId) public {
        validateEventExists(eventId);
        validateNFTHolder(msg.sender);
        uint256 tokenId = getTokenForEvent(msg.sender, eventId);
        validateTokenForEvent(tokenId, msg.sender, eventId);
        validateNotRegistered(msg.sender, eventId);

        registrations[eventId][msg.sender] = true;
    }

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

    function isRegistered(uint256 eventId, address user) public view returns (bool) {
        return registrations[eventId][user];
    }

    function validateEventDoesNotExist(uint256 eventId) internal view {
        if (events[eventId].exists) {
            revert EventAlreadyExists(eventId);
        }
    }

    function validateEventExists(uint256 eventId) internal view {
        if (!events[eventId].exists) {
            revert EventDoesNotExist(eventId);
        }
    }

    function validateNFTHolder(address user) internal view {
        if (eventNFT.balanceOf(user) == 0) {
            revert NotAnNFTHolder(user);
        }
    }

    function validateTokenForEvent(uint256 tokenId, address user, uint256 eventId) internal pure {
        if (tokenId == 0) {
            revert NoNFTForEvent(user, eventId);
        }
    }

    function validateNotRegistered(address user, uint256 eventId) internal view {
        if (registrations[eventId][user]) {
            revert AlreadyRegistered(user, eventId);
        }
    }
}


/*
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

    function createEvent(uint256 eventId, string memory eventName) public {
        require(!events[eventId].exists, "Event with this ID already exists");
        events[eventId] = Event(eventName, eventId, true);
    }

    function registerForEvent(uint256 eventId) public {
        require(events[eventId].exists, "Event does not exist");
        require(eventNFT.balanceOf(msg.sender) > 0, "You must hold an NFT to register");

        uint256 tokenId = getTokenForEvent(msg.sender, eventId);
        require(tokenId != 0, "You do not own the required NFT for this event");
        require(!registrations[eventId][msg.sender], "Already registered for this event");

        registrations[eventId][msg.sender] = true;
    }

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

    function isRegistered(uint256 eventId, address user) public view returns (bool) {
        return registrations[eventId][user];
    }
}
*/