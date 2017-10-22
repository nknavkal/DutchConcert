var Venu= artifacts.require("./Venu.sol");

contract('Venu', function(accounts) {

  const owner = accounts[0]
  const fan = accounts[1];
  const artist = accounts[2];

  it("should create a new Venu venue", async () => {
    const venuDeployed = await Venu.deployed();

    await venuDeployed.venu(artist, "Taylor Swift", 250, 500, "Berkeley Greek Theater", Date.now(), {from: owner});

    const artistAddress = await venuDeployed.artist();
    assert.equal(artistAddress, artist, 'artist address is incorrect');

    const artistName = await venuDeployed.artistName();
    assert.equal(artistName, "Taylor Swift", 'artist name is incorrect');

    const minCapacity = await venuDeployed.minCapacity();
    assert.equal(minCapacity, 250, 'min capacity is incorrect');

    const maxCapacity = await venuDeployed.maxCapacity();
    assert.equal(maxCapacity, 500, 'max capacity is incorrect');

    const eventVenue = await venuDeployed.eventVenue();
    assert.equal(eventVenue, "Berkeley Greek Theater", 'event venue name is incorrect');

    /*const eventTime = await venuDeployed.eventTime();
    assert.equal(eventTime, Date.now(), 'event time is incorrect');*/

    const artistInterest = await venuDeployed.artistInterest();
    assert.equal(artistInterest, false, 'artist interest is incorrect');

  });

  it("should verify artist change", async () => {
    const venu = await Venu.deployed();

    await venu.verify(100000, 500, 1176, 10, {from: artist});

    const minRevenue = await venu.minRevenue();
    assert.equal(minRevenue, 100000, 'min revenue is incorrect');

    const minCapacity = await venu.minCapacity();
    assert.equal(minCapacity, 500, 'min capacity is incorrect');

    const priceFactor = await venu.priceFactor();
    assert.equal(priceFactor, 1176, 'price factor is incorrect');

    const endTime = await venu.endTime();
    assert.equal(endTime, 10, 'end time is incorrect');

    const artistInterest = await venu.artistInterest();
    assert.equal(artistInterest, true, 'artist interest is incorrect');

    /*await venu.deposit(deposit, {from: fan});
    const balance = await venu.balance({from: fan});
    assert.equal(deposit.plus(1000).toString(), balance, 'deposit amount incorrect, check deposit method');

    const expectedEventResult = {accountAddress: fan.address, amount: deposit};

    const LogDepositMade = await venu.allEvents();
    const log = await new Promise(function(resolve, reject) {
        LogDepositMade.watch(function(error, log){ resolve(log);});
    });

    const logAccountAddress = log.args.accountAddress;
    const logAmount = log.args.amount;
    assert.equal(expectedEventResult.accountAddress, expectedEventResult.accountAddress, "LogDepositMade event accountAddress property not emmitted, check deposit method");
    assert.equal(expectedEventResult.amount, expectedEventResult.amount, "LogDepositMade event amount property not emmitted, check deposit method");*/
  });

  /*it("should bid correctly", async () => {
    const venu = await Venu.deployed();

    await venu.bid(1, {from: fan, value: 1000000000000000000});

    const calcTokenPrice = await venu.calcTokenPrice();
    assert.equal(calcTokenPrice, (venu.priceFactor() * 10**18 / (4 - 2 + 7500) + 1), 'calc token price is incorrect');



  });*/


});
