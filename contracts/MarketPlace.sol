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

    unit offerID = 0;
    uint tradeID = 0;

    mapping (uint => Trade) public trades;
    mapping (uint => Offer) public offers;
    mapping(address => uint) public balances;
    mapping(address => uint) public availableBalances;
    mapping(address => bool) public members;
    address admin;

    constructor() {
        admin = msg.sender;
    }

    modifier() {
        require(msg.sender == admin, "Only Admin")
        _;
    }

    modifier(bool registered, address member) {
        if(registered) {
            require(members[member] == true, "must be registered");
        } else {
            require(members[member] == false, "must not be registered");
        }
        _;
    }

    function buy(uint offerId) external onlyMember(msg.sender, true) {
        Offer storage offer = offers[offerId];
        require(offer.id > 0, 'offer must exist');
        require(offer.status == Status.PENDING, 'offer must be pending');
        require(availableBalances[msg.sender] >= offer.price);
        availableBalances[msg.sender] -= offer.price;
        offer.status = Status.DONE;
        uint tradeId = lastTradeId++;
        trades[lastTradeId++] = Trade(tradeId, offer.id, msg.sender, offer.seller, offer.price, Status.PENDING);
    }

    function deposit() 
        external 
        payable 
        onlyMember(msg.sender, true) {
        balances[msg.sender] += msg.value;
        availableBalances[msg.sender] += msg.value;
    }
    
    /*
     * Admin functions
     */
    
    function settle(uint txId) 
        external 
        onlyAdmin() {
        Trade storage trade = trades[txId];
        require(trade.id != 0, 'trade must exist');
        require(trade.status == Status.PENDING, 'trade must be in PENDING state');
        trade.status = Status.DONE;
        availableBalances[msg.sender] += trade.price;
        _transfer(trade.buyer, trade.seller, trade.price);
    }
    
    function register(address member) 
        external 
        onlyMember(member, false)
        onlyAdmin() {
        members[member] = true;
        balances[member] += 500;
        availableBalances[member] += 500;
    }
    
    function unregister(address member) external onlyMember(member, true) onlyAdmin() {
        uint memberBalance = balances[member];
        members[member] = false;
        _transfer(member, address(this), memberBalance);
    }
    
    function _transfer(address from, address to, uint amount) internal {
        require(balances[from] >= amount, 'cannot transfer more than current balance');
        balances[from] -= amount;
        availableBalances[from] -= amount;
        balances[to] += amount;
        availableBalances[to] += amount;
    }
}