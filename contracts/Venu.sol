pragma solidity ^0.4.10;


/// @title Abstract token contract - Functions to be implemented by token contracts.
/*
contract Libra {
  string public eventName;
  uint public closeDate;
  uint public currentPrice;
  string public eventLocation;
  uint public eventDate;
  address[] private contributors;
  uint public numContributors;
  uint private revenue;
  //minRevenue
  //minCost
  //endDate

  function balanceOf(address who) constant returns (uint);

  function name() constant returns (string _name);
  function endDate() constant returns (string _closeDate);
  function price() constant returns (uint _currentPrice);
  function location() constant returns (string _eventLocation);
  function date() constant returns (uint _eventDate);
  function numContributors() constant returns (uint _numContributors);

  //function transfer(address to, uint value) returns (bool ok);
  //event Transfer(address indexed from, address indexed to, uint value, bytes indexed data);
}
*/

/// @title Dutch auction contract - distribution of Gnosis tokens using an auction.
/// @author Stefan George - <stefan.george@consensys.net>
contract Venu {

    /*
     *  Events
     */
    event bidSubmission(address indexed sender, uint256 amount);
    event artistVerification(address performer, string venue);
    event soldOut(uint totalTickets, uint price);

    /*
     *  Constants
     */

    /*
     *  Storage
     */

    string public eventName;
    uint public endTime;
    uint public constantPrice;
    bool public priceFinalized;
    string public eventVenue;
    uint public eventTime;
    address[] private contributors;
    uint public numTickets;
    uint public minRevenue; //have to deal with venue price
    address public artist;
    uint public minCapacity;
    uint public maxCapacity;
    string public artistName;
    bool public artistInterest;

    uint public priceFactor;
    uint public startBlock;
    uint public startTime;

    uint public totalReceived;
    uint public finalPrice;
    uint public timeCap;


    mapping (address => Bid) public bids; //why is this public?
    Stages public stage;

    /*
     *  Enums
     */
    enum Stages {
        AuctionDeployed,
        AuctionSetUp,
        AuctionStarted,
        AuctionEnded
    }

    /*
     *  Modifiers
     */



    modifier atStage(Stages _stage) {
        if (stage != _stage) {
            // Contract not in expected state
            revert(); }
        _;
    }

    modifier isArtist() {
      if (msg.sender == artist) {_;}
    }

    modifier isValidPayload() {
        if (msg.data.length != 4 && msg.data.length != 36) {
            revert(); }
        _;
    }

    modifier timedTransitions() {
        if (stage == Stages.AuctionStarted && calcTokenPrice() <= calcStopPrice()) {
            finalizeAuction(); }
        _;
    }

    modifier ticketsSold() {
        if (stage == Stages.AuctionEnded) {_;}
    }

    struct Bid {
        uint input;
        uint tickets;
    }

    /*
     *  Public functions
     */
    /// @dev Contract constructor function sets owner.
    function venu(address _artist, string _artistName, uint _minCapacity, uint _maxCapacity, string _eventVenue, uint _eventTime)
        public
    {
        /*if (1 == 0 || _minCapacity < 1) {
            // Arguments are null.
            revert();
        }*/
        artist = msg.sender;
        artistName = _artistName;
        minCapacity  = _minCapacity;
        maxCapacity = _maxCapacity;
        eventVenue = _eventVenue;
        eventTime = _eventTime;
        artistInterest = false;

        stage = Stages.AuctionDeployed;
    }

    /// @dev Setup function sets external contracts' addresses.
    function verify(uint _minRevenue, uint _minCapacity, uint _priceFactor, uint _prepTime)
        public
        isArtist()
        atStage(Stages.AuctionDeployed)
    {
        minRevenue = _minRevenue;
        minCapacity = _minCapacity;
        priceFactor = _priceFactor; //TODO: Calculate pricefactor based on given parameters
        endTime = eventTime - _prepTime;
        artistInterest = true;

        stage = Stages.AuctionSetUp;
        startAuction();
    }



    /// @dev Starts auction and sets startBlock.
    function startAuction()
        private
        atStage(Stages.AuctionSetUp)
    {
        stage = Stages.AuctionStarted;
        startBlock = block.number;
        startTime = now;
    }

    /// @dev Calculates current token price.
    /// @return Returns token price.
    function calcCurrentTokenPrice()
        public
        timedTransitions()
        returns (uint)
    {
        if (stage == Stages.AuctionEnded)
            return finalPrice;
        return calcTokenPrice();
    }

    /// @dev Returns correct stage, even if a function with timedTransitions modifier has not yet been called yet.
    /// @return Returns current auction stage.
    function updateStage()
        public
        timedTransitions()
        returns (Stages)
    {
        return stage;
    }

    /// @dev Allows to send a bid to the auction.
    function bid(uint tickets)
        public
        payable
        isValidPayload()
        timedTransitions()
        atStage(Stages.AuctionStarted)
        returns (uint amount)
    {
        // If a bid is sent after the bidding period expires, you will be refunded.
        if (now > endTime) {
            finalizeAuction();
            msg.sender.transfer(msg.value); //refund sender since he tried to buy after end time ended
            return;
        }
        if (numTickets == maxCapacity) {
            finalizeAuction();
            msg.sender.transfer(msg.value);
            return;

        }

        if (numTickets + tickets > maxCapacity) {
          revert();
          //find a way to print "there are only" maxCapacity - numTickets "tickets remaining"
        }
        uint price = calcTokenPrice();
        if (msg.value < price * tickets) {
            revert();
        }
        bids[msg.sender] = Bid(msg.value, tickets);
        numTickets += tickets;

        totalReceived = numTickets * price; //does this matter??
        if (totalReceived >= minRevenue && !priceFinalized) {
            priceFinalized = true;
            constantPrice = priceFactor * 10**18 / (block.number - startBlock + 7500) + 1;
        }

        bidSubmission(msg.sender, amount);
    }

    /// @dev Claims tokens for bidder after auction.
    function claimTokens(uint tickets)
        public
        isValidPayload
        timedTransitions
        atStage(Stages.AuctionEnded)
        returns (bool)
    {
        bool truth = bids[msg.sender].tickets >= tickets;
        bids[msg.sender].tickets -= tickets;
        msg.sender.transfer(bids[msg.sender].input - tickets*finalPrice);
        return truth;
    }

    /// @dev Calculates stop price.
    /// @return Returns stop price.
    function calcStopPrice()
        public
        returns (uint)
    {
        //return totalReceived * 10**18 / MAX_TOKENS_SOLD + 1;
        revert();
    }

    /// @dev Calculates token price.
    /// @return Returns token price.
    function calcTokenPrice()
        public
        returns (uint)
    {
        //changed block.number to 4
        //changed startBlock to 2
        if (!priceFinalized) {
            return priceFactor * 10**18 / (4 - 2 + 7500) + 1;
        }
        return constantPrice;


    }

    /*
     *  Private functions
     */
    function finalizeAuction()
        private
    {
        stage = Stages.AuctionEnded;
        if (priceFinalized) {
            finalPrice = constantPrice;
        } else {
            finalPrice = calcTokenPrice();
        }
        // Auction contract transfers all unsold tokens to Gnosis inventory multisig
        soldOut(numTickets, finalPrice);
    }
}
