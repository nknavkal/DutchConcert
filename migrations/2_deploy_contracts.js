var SimpleStorage = artifacts.require("./SimpleStorage.sol");
var Venu = artifacts.require("./Venu.sol");

module.exports = function(deployer) {
  deployer.deploy(SimpleStorage);
  deployer.deploy(Venu);
};
