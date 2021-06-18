pragma solidity 0.6.12;

contract MarketPlace {
    enum Status {PENDING, SOLD }
    struct Offer {
        uint id;
        string memory description;
        uint price;
        address seller;
    }

    struct Trade {
        uint id;
        address buyer;
        address seller;
        uint price;
        uint offerId;
        Status status;
    }

    mapping (uint => Trade) public trades;
    mapping (uint => Offer) public offers;
    mapping(address => uint) public balances;
    mapping(address => uint) public availableBalances;
    mapping(address => bool) public members;
    address admin;
}