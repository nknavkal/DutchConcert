import Web3 from 'web3';

const web3 = new Web3(new Web3.providers.HttpProvider("http://localhost:8545"));

web3.eth.defaultAccount = '0x537c17702f731f25b133d8cce9be1e3441b7fa8a';

var venuABI = [{"constant":true,"inputs":[],"name":"eventTime","outputs":[{"name":"","type":"uint256"}],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"_artist","type":"address"},{"name":"_artistName","type":"string"},{"name":"_minCapacity","type":"uint256"},{"name":"_maxCapacity","type":"uint256"},{"name":"_eventVenue","type":"string"},{"name":"_eventTime","type":"uint256"}],"name":"venu","outputs":[],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"endTime","outputs":[{"name":"","type":"uint256"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"numTickets","outputs":[{"name":"","type":"uint256"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"calcTokenPrice","outputs":[{"name":"","type":"uint256"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"artist","outputs":[{"name":"","type":"address"}],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"tickets","type":"uint256"}],"name":"bid","outputs":[{"name":"amount","type":"uint256"}],"payable":true,"type":"function"},{"constant":false,"inputs":[{"name":"tickets","type":"uint256"}],"name":"claimTokens","outputs":[{"name":"","type":"bool"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"startBlock","outputs":[{"name":"","type":"uint256"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"minRevenue","outputs":[{"name":"","type":"uint256"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"maxCapacity","outputs":[{"name":"","type":"uint256"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"artistName","outputs":[{"name":"","type":"string"}],"payable":false,"type":"function"},{"constant":true,"inputs":[{"name":"","type":"address"}],"name":"bids","outputs":[{"name":"input","type":"uint256"},{"name":"tickets","type":"uint256"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"timeCap","outputs":[{"name":"","type":"uint256"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"startTime","outputs":[{"name":"","type":"uint256"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"eventName","outputs":[{"name":"","type":"string"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"totalReceived","outputs":[{"name":"","type":"uint256"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"artistInterest","outputs":[{"name":"","type":"bool"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"finalPrice","outputs":[{"name":"","type":"uint256"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"priceFinalized","outputs":[{"name":"","type":"bool"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"stage","outputs":[{"name":"","type":"uint8"}],"payable":false,"type":"function"},{"constant":false,"inputs":[],"name":"updateStage","outputs":[{"name":"","type":"uint8"}],"payable":false,"type":"function"},{"constant":false,"inputs":[],"name":"calcCurrentTokenPrice","outputs":[{"name":"","type":"uint256"}],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"_minRevenue","type":"uint256"},{"name":"_minCapacity","type":"uint256"},{"name":"_priceFactor","type":"uint256"},{"name":"_prepTime","type":"uint256"}],"name":"verify","outputs":[],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"calcStopPrice","outputs":[{"name":"","type":"uint256"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"priceFactor","outputs":[{"name":"","type":"uint256"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"minCapacity","outputs":[{"name":"","type":"uint256"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"eventVenue","outputs":[{"name":"","type":"string"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"constantPrice","outputs":[{"name":"","type":"uint256"}],"payable":false,"type":"function"},{"anonymous":false,"inputs":[{"indexed":true,"name":"sender","type":"address"},{"indexed":false,"name":"amount","type":"uint256"}],"name":"bidSubmission","type":"event"},{"anonymous":false,"inputs":[{"indexed":false,"name":"artist","type":"address"},{"indexed":false,"name":"venue","type":"string"}],"name":"artistVerification","type":"event"},{"anonymous":false,"inputs":[{"indexed":false,"name":"totalTickets","type":"uint256"},{"indexed":false,"name":"price","type":"uint256"}],"name":"soldOut","type":"event"}]

var venuAddress = '0xcb30966e6a15a3577304feccfe383b64b59d8d1c';

const venuContract = web3.eth.contract(venuABI).at(venuAddress);

export {eightBallContract};