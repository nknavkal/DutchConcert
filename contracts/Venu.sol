pragma solidity 0.4.10;


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

    /*
     *  Constants
     */

    /*
     *  Storage
     */

    string public eventName;
    uint public endTime;
    uint public currentPrice;
    string public eventVenue;
    uint public eventTime;
    address[] private contributors;
    uint public numContributors;
    uint private minRevenue;
    address public artist;

    uint private priceFactor;
    uint public startBlock;
    uint public startTime;

    uint public totalReceived;
    uint public finalPrice;
    uint public MAX_TOKENS_SOLD; // This should be passed in to the constructor
    uint public timeCap;


    mapping (address => uint) public bids; //why is this public?
    Stages public stage;

    /*
     *  Enums
     */
    enum Stages {
        AuctionDeployed,
        AuctionSetUp,
        AuctionStarted,
        AuctionEnded,
        TradingStarted
    }

    /*
     *  Modifiers
     */



    modifier atStage(Stages _stage) {
        if (stage != _stage)
            // Contract not in expected state
            throw;
        _;
    }

    modifier artistOnly {
      if ()
    }

    modifier isOwner() {
        if (msg.sender != owner)
            // Only owner is allowed to proceed
            throw;
        _;
    }

    modifier isWallet() {
        if (msg.sender != wallet)
            // Only wallet is allowed to proceed
            throw;
        _;
    }

    modifier isValidPayload() {
        if (msg.data.length != 4 && msg.data.length != 36)
            throw;
        _;
    }

    modifier timedTransitions() {
        if (stage == Stages.AuctionStarted && calcTokenPrice() <= calcStopPrice())
            finalizeAuction();
        if (stage == Stages.AuctionEnded && now > endTime + WAITING_PERIOD)
            stage = Stages.TradingStarted;
        _;
    }

    /*
     *  Public functions
     */
    /// @dev Contract constructor function sets owner.
    /// @param _wallet Gnosis wallet.
    /// @param _ceiling Auction ceiling.
    /// @param _priceFactor Auction price factor.
    function DutchConcert(address _artist, uint _minCapacity, uint _maxCapacity, string _eventVenue, uint _eventTime)
        public
    {
        if (artist == 0 || max_capacity < 1) {
            // Arguments are null.
            revert();
        }
        artist = _artist;
        minCapacity  = _minCapacity;
        maxCapacity = _maxCapacity;

        stage = Stages.AuctionDeployed;
    }

    /// @dev Setup function sets external contracts' addresses.
    /// @param _gnosisToken Gnosis token address.
    function setup(address _gnosisToken)
        public
        isOwner
        atStage(Stages.AuctionDeployed)
    {
        if (_gnosisToken == 0) {
            // Argument is null.
            revert();
        }
        gnosisToken = Token(_gnosisToken);
        // Validate token balance
        if (gnosisToken.balanceOf(this) != MAX_TOKENS_SOLD) { //MaxTokensSold for this round may be less than or equal to total tokens left
            revert();
        }
        stage = Stages.AuctionSetUp;
    }

    /// @dev Starts auction and sets startBlock.
    function startAuction()
        public
        isWallet
        atStage(Stages.AuctionSetUp)
    {
        stage = Stages.AuctionStarted;
        startBlock = block.number;
        startTime = now;
    }

    /// @dev Changes auction ceiling and start price factor before auction is started.
    /// @param _ceiling Updated auction ceiling.
    /// @param _priceFactor Updated start price factor.
    function changeSettings(uint _ceiling, uint _priceFactor)
        public
        isWallet
        atStage(Stages.AuctionSetUp)
    {
        ceiling = _ceiling;
        priceFactor = _priceFactor;
    }

    /// @dev Calculates current token price.
    /// @return Returns token price.
    function calcCurrentTokenPrice()
        public
        timedTransitions
        returns (uint)
    {
        if (stage == Stages.AuctionEnded || stage == Stages.TradingStarted)
            return finalPrice;
        return calcTokenPrice();
    }

    /// @dev Returns correct stage, even if a function with timedTransitions modifier has not yet been called yet.
    /// @return Returns current auction stage.
    function updateStage()
        public
        timedTransitions
        returns (Stages)
    {
        return stage;
    }

    /// @dev Allows to send a bid to the auction.
    /// @param receiver Bid will be assigned to this address if set.
    function (address receiver)
        public
        payable
        isValidPayload
        timedTransitions
        atStage(Stages.AuctionStarted)
        returns (uint amount)
    {
        // If a bid is done on behalf of a user via ShapeShift, the receiver address is set.
        if (now - startTime == timeCap) {
            finalizeAuction();
            msg.sender.transfer(msg.value); //refund sender since he tried to buy after time cap ended
            return;
        }
        if (receiver == 0)
            receiver = msg.sender;
        amount = msg.value;
        // Prevent that more than 90% of tokens are sold. Only relevant if cap not reached.
        uint maxWei = (MAX_TOKENS_SOLD / 10**18) * calcTokenPrice() - totalReceived; //don't need this line because we will pass in MAX_TOKENS_SOLD
        uint maxWeiBasedOnTotalReceived = ceiling - totalReceived; //ceiling is money_cap
        if (maxWeiBasedOnTotalReceived < maxWei)
            maxWei = maxWeiBasedOnTotalReceived;
        // Only invest maximum possible amount.
        if (amount > maxWei) {
            amount = maxWei;
            // Send change back to receiver address. In case of a ShapeShift bid the user receives the change back directly.
            if (!receiver.send(msg.value - amount))
                // Sending failed
                throw;
        }
        // Forward funding to ether wallet
        if (amount == 0 || !wallet.send(amount))
            // No amount sent or sending failed
            throw;
        bids[receiver] += amount;
        totalReceived += amount;
        if (maxWei == amount) {
            // When maxWei is equal to the big amount the auction is ended and finalizeAuction is triggered.
            finalizeAuction();
        }
        BidSubmission(receiver, amount);
    }

    /// @dev Claims tokens for bidder after auction.
    /// @param receiver Tokens will be assigned to this address if set.
    function claimTokens(address receiver)
        public
        isValidPayload
        timedTransitions
        atStage(Stages.TradingStarted)
    {
        if (receiver == 0)
            receiver = msg.sender;
        uint tokenCount = bids[receiver] * 10**18 / finalPrice;
        bids[receiver] = 0;
        gnosisToken.transfer(receiver, tokenCount);
    }

    /// @dev Calculates stop price.
    /// @return Returns stop price.
    function calcStopPrice()
        constant
        public
        returns (uint)
    {
        return totalReceived * 10**18 / MAX_TOKENS_SOLD + 1;
    }

    /// @dev Calculates token price.
    /// @return Returns token price.
    function calcTokenPrice()
        constant
        public
        returns (uint)
    {
        return priceFactor * 10**18 / (block.number - startBlock + 7500) + 1;
    }

    /*
     *  Private functions
     */
    function finalizeAuction()
        private
    {
        stage = Stages.AuctionEnded;
        if (totalReceived == ceiling)
            finalPrice = calcTokenPrice();
        else
            finalPrice = calcStopPrice();
        uint soldTokens = totalReceived * 10**18 / finalPrice;
        // Auction contract transfers all unsold tokens to Gnosis inventory multisig
        gnosisToken.transfer(wallet, MAX_TOKENS_SOLD - soldTokens);
        endTime = now;
    }
}
