const { ERC725 } = require("@erc725/erc725.js");
const LSP6Schema = require("@erc725/erc725.js/schemas/LSP6KeyManager.json");
const UniversalProfile = require("@lukso/lsp-smart-contracts/artifacts/UniversalProfile.json");
const KeyManager = require("@lukso/lsp-smart-contracts/artifacts/LSP6KeyManager.json");

const Web3 = require("web3");

// setup
const myUniversalProfileAddress = "0xC26508178c4D7d3Ad43Dcb9F9bb1fab9ceeD58B5";
const RPC_ENDPOINT = "https://rpc.l16.lukso.network";

const web3 = new Web3(RPC_ENDPOINT);
const erc725 = new ERC725(LSP6Schema);

const PRIVATE_KEY = "0x..."; // add the private key of your EOA here (created in Step 1)
const myEOA = web3.eth.accounts.wallet.add(PRIVATE_KEY);

async function grantPermissions() {
  // step 1 - create instance of UniversalProfile and KeyManager contracts
  const myUniversalProfile = new web3.eth.Contract(UniversalProfile.abi, myUniversalProfileAddress);

  const keyManagerAddress = await myUniversalProfile.methods.owner().call();
  const myKeyManager = new web3.eth.Contract(KeyManager.abi, keyManagerAddress);

  // step 2 - setup the permissions of the beneficiary address
  const beneficiaryAddress = "0xcafecafecafecafecafecafecafecafecafecafe"; // EOA address of an exemplary person
  const beneficiaryPermissions = erc725.encodePermissions({
    SETDATA: true,
  });

  // step 3.1 - encode the data key-value pairs of the permissions to be set
  const data = erc725.encodeData({
    keyName: "AddressPermissions:Permissions:<address>",
    dynamicKeyParts: beneficiaryAddress,
    value: beneficiaryPermissions,
  });

  // step 3.2 - encode the payload to be sent to the Key Manager contract
  const payload = myUniversalProfile.methods["setData(bytes32,bytes)"](data.keys[0], data.values[0]).encodeABI();

  // step 4 - send the transaction via the Key Manager contract
  await myKeyManager.methods.execute(payload).send({
    from: myEOA.address,
    gasLimit: 300_000,
  });

  const result = await myUniversalProfile.methods["getData(bytes32)"](data.keys[0]).call();
  console.log(
    `The beneficiary address ${beneficiaryAddress} has now the following permissions:`,
    erc725.decodePermissions(result)
  );
}

grantPermissions();
