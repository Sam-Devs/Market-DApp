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
}