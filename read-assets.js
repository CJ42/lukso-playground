// Import and Network Setup
const Web3 = require("web3");
const { ERC725: ERC725JS } = require("@erc725/erc725.js");
require("isomorphic-fetch");

// Our static variables
const SAMPLE_PROFILE_ADDRESS = "0x0Ac71c67Fa5E4c9d4af4f99d7Ad6132936C2d6A3";
const RPC_ENDPOINT = "https://rpc.l14.lukso.network";
const IPFS_GATEWAY_URL = "https://cloudflare-ipfs.com/ipfs/";

// Parameters for ERC725 Instance
const erc725schema = require("@erc725/erc725.js/schemas/LSP3UniversalProfileMetadata.json");
const provider = new Web3.providers.HttpProvider(RPC_ENDPOINT);
const config = { ipfsGateway: IPFS_GATEWAY_URL };

/*
 * Fetch the @param's Universal Profile's
 * LSP5 data
 *
 * @param address of Universal Profile
 * @return string JSON or custom error
 */
async function fetchReceivedAssets(address) {
  try {
    // this should not be put here, but rather at the top
    const profile = new ERC725JS(erc725schema, address, provider, config);

    // this is weird
    return await (
      await profile.fetchData("LSP5ReceivedAssets[]")
    ).value;
  } catch (error) {
    return console.log("This is not an ERC725 Contract");
  }
}

// Debug
fetchReceivedAssets(SAMPLE_PROFILE_ADDRESS).then((profileData) => {
  console.log("step 1");
  console.log(JSON.stringify(profileData, undefined, 2));
});

// ABI for the asset
const LSP8 = require("@lukso/lsp-smart-contracts/artifacts/LSP8IdentifiableDigitalAsset.json");
const web3 = new Web3("https://rpc.l14.lukso.network");

/*
 * Return array of blockchain addresses
 * of assets that are owned by the
 * Univeral Profile.
 *
 * @param owner Universal Profile address
 * @return address[] of owned assets
 */
async function fetchOwnedAssets(owner) {
  const digitalAssets = await fetchReceivedAssets(SAMPLE_PROFILE_ADDRESS);
  const ownedAssets = [];

  for (let i = 0; i < digitalAssets.length; i++) {
    // Create instance of the asset to check owner balance
    const LSP8Contract = new web3.eth.Contract(LSP8.abi, digitalAssets[i]);

    const isCurrentOwner = await LSP8Contract.methods.balanceOf(owner).call();
    if (isCurrentOwner > 0) {
      ownedAssets[ownedAssets.length] = digitalAssets[i];
    }
  }
  return ownedAssets;
}

// Debug
fetchOwnedAssets(SAMPLE_PROFILE_ADDRESS).then((ownedAssets) => {
  console.log(ownedAssets);
});

const SAMPLE_ASSET_ADDRESS = "0xfE85568Fea15A7ED3c56F7ca6544F2b96Aeb1774";

const AssetInterface = require("./asset_interface.json");

/*
 * Check the ERC725Y interface of an asset's smart contract
 *
 * @param address of asset
 * @return boolean - if the address supports ERC725Y or false if it doesn't
 */
async function checkErc725YInterfaceId(address) {
  // Create instance of the contract which has to be queried
  const Contract = new web3.eth.Contract(AssetInterface, address);

  const ERC725Y_INTERFACE_ID = "0x714df77c";

  let interfaceCheck = false;

  // Check if the contract has a key-value store
  try {
    interfaceCheck = await Contract.methods.supportsInterface(ERC725Y_INTERFACE_ID).call();
  } catch (error) {
    console.log(error.message);
    console.log("Address could not be checked for ERC725 interface");
  }

  return interfaceCheck;
}

// Debug
checkErc725YInterfaceId(SAMPLE_ASSET_ADDRESS).then((standard) => console.log(standard));

// ...
// ABI's
const ERC725Y = require("@erc725/smart-contracts/artifacts/ERC725Y.json");
const LSP4schema = require("@erc725/erc725.js/schemas/LSP4DigitalAsset.json");

// Keys for properties
const TokenNameKey = LSP4schema[1].key;
const TokenSymbolKey = LSP4schema[2].key;
const MetaDataKey = LSP4schema[3].key;
const CreatorsKey = LSP4schema[4].key;

/*
 * Fetch the dataset of an asset
 *
 * @param key of asset property
 * @return string of encoded data
 */
async function getAssetData(key) {
  try {
    // Instantiate ERC725Y smart contract
    const digitalAsset = new web3.eth.Contract(ERC725Y.abi, SAMPLE_ASSET_ADDRESS);

    // Fetch the encoded contract data
    return await digitalAsset.methods["getData(bytes32)"](key).call();
  } catch (error) {
    return console.error("Data of assets address could not be loaded");
  }
}

// Debug
getAssetData(MetaDataKey).then((encodedData) => console.log(encodedData));

// Content Phrases
const decodeNamePhrase = LSP4schema[1].name;
const decodeTokenPhrase = LSP4schema[2].name;
const decodeMetaPhrase = LSP4schema[3].name;
const decodeCreatorPhrase = LSP4schema[4].name;

/*
 * Decode value from ERC725Y storage
 * based on it's key and phrase
 *
 * @param key of asset property
 * @param decodePhrase string of fetchable content
 * @return string of decoded data
 */
async function decodeData(key, decodePhrase) {
  try {
    let encodedData = await getAssetData(key);
    // Instance of the LSP4 with ERC725.js
    const erc725 = new ERC725JS(LSP4schema, SAMPLE_ASSET_ADDRESS, provider, config);
    // Decode the assets data
    return erc725.decodeData({ decodePhrase: encodedData });
  } catch (error) {
    console.log("Data of an asset could not be decoded");
  }
}

// Debug
decodeData(MetaDataKey, decodeMetaPhrase).then((decodedData) => console.log(decodedData));
