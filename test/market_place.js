const { expectRevert, time, expectEvent} = require("@openzeppelin/test-helpers");
const MarketPlace = artifacts.require("MarketPlace");

contract("Online Marketplace", (accounts) => {
    let marketPlace;
    const trade = {
        
    }
    const [buyer, seller] = [accounts[0], accounts[1]];
    beforeEach(async () => {
        marketPlace = MarketPlace.deployed();
    });

    
})