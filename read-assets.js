// Import and Network Setup
const Web3 = require("web3");
const { ERC725: ERC725JS } = require("@erc725/erc725.js");
const { ERC725Y_INTERFACE_IDS } = require("@erc725/erc725.js/build/main/src/lib/constants");
require("isomorphic-fetch");

// Our static variables
const SAMPLE_PROFILE_ADDRESS = "0x0Ac71c67Fa5E4c9d4af4f99d7Ad6132936C2d6A3";
const RPC_ENDPOINT = "https://rpc.l14.lukso.network";
const IPFS_GATEWAY_URL = "https://cloudflare-ipfs.com/ipfs/";

// Parameters for ERC725 Instance
const erc725schema = require("@erc725/erc725.js/schemas/LSP3UniversalProfileMetadata.json");
const provider = new Web3.providers.HttpProvider(RPC_ENDPOINT);
const config = { ipfsGateway: IPFS_GATEWAY_URL };

// ABI for the asset
const LSP4 = require("@lukso/lsp-smart-contracts/artifacts/LSP4DigitalAssetMetadata.json");
const LSP8 = require("@lukso/lsp-smart-contracts/artifacts/LSP8IdentifiableDigitalAsset.json");

const web3 = new Web3("https://rpc.l14.lukso.network");

/*
 * Step 1
 * Fetch the LSP5ReceivedAssets[] from a Universal Profile's
 *
 * @param universalProfileAddress the address of the Universal Profile
 * @return string JSON or custom error
 */
async function fetchReceivedAssets(universalProfileAddress) {
  try {
    // instance for the universal Profile
    const profile = new ERC725JS(erc725schema, universalProfileAddress, provider, config);

    const result = await profile.fetchData("LSP5ReceivedAssets[]");
    return result.value;
  } catch (error) {
    return console.log("Could not fetch UP's received assets. Check that this address is an ERC725 Contract");
  }
}

/*
 * Return array of blockchain addresses
 * of assets that are owned by the
 * Univeral Profile.
 *
 * @param owner Universal Profile address
 * @return address[] of owned assets
 *
 * @deprecated
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

const SAMPLE_ASSET_ADDRESS = "0xfE85568Fea15A7ED3c56F7ca6544F2b96Aeb1774";

/*
 * Check the ERC725Y interface of an asset's smart contract
 *
 * @param assetAddress address of digital asset smart contract
 * @return boolean - true if the address supports ERC725Y, false if it doesn't
 */
async function checkErc725YInterfaceId(assetAddress) {
  // Create instance of the digital asset contract
  const Contract = new web3.eth.Contract(LSP4.abi, assetAddress);

  let interfaceCheck = false;

  // Check if the contract has a key-value store
  try {
    interfaceCheck = await Contract.methods.supportsInterface(ERC725Y_INTERFACE_IDS["3.0"]).call();
  } catch (error) {
    console.log(error.message);
    console.log("Address could not be checked for ERC725 interface");
  }

  return interfaceCheck;
}

// ...
// ABI's
// use LSP4Metadata artifact for this
const ERC725Y = require("@erc725/smart-contracts/artifacts/ERC725Y.json");
const LSP4schema = require("@erc725/erc725.js/schemas/LSP4DigitalAsset.json");

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

/*
 * Decode value from ERC725Y storage
 * based on it's key and phrase
 *
 * @param key of asset property
 * @param decodePhrase string of fetchable content
 * @return string of decoded data
 */
async function decodeData(keyName, encodedData) {
  try {
    // Instance of the LSP4 with ERC725.js
    // instance for the digital asset
    const erc725 = new ERC725JS(LSP4schema, SAMPLE_ASSET_ADDRESS, provider, config);
    // Decode the assets data
    return erc725.decodeData({
      keyName: keyName,
      value: encodedData,
    });
  } catch (error) {
    console.log("Data of an asset could not be decoded");
  }
}

/*
 * Create a fetchable link for the asset data
 * that was embeded into the JSON metadata
 *
 * @return string of asset data URL
 */
async function getMetaDataLink(decodedAssetMetadata) {
  try {
    // Generate IPFS link from decoded metadata
    return IPFS_GATEWAY_URL + decodedAssetMetadata.value.url.substring(7);
  } catch (error) {
    console.log("URL could not be fetched");
  }
}

/*
 * Fetch the asset data from a link
 *
 * @return string with asset data as JSON
 */
async function fetchAssetData(dataURL) {
  try {
    const response = await fetch(dataURL);
    return await response.json();
  } catch (error) {
    console.log("JSON data of IPFS link could not be fetched");
  }
}

async function main() {
  console.log("step 1 -----");
  const receivedAssets = await fetchReceivedAssets(SAMPLE_PROFILE_ADDRESS);
  console.log(receivedAssets);

  console.log("step 3 -----");
  const check = await checkErc725YInterfaceId(SAMPLE_ASSET_ADDRESS);
  console.log(check);

  console.log("step 4 -----");

  // Keys for properties
  //   const TokenNameKey = LSP4schema[1].key;
  //   const TokenSymbolKey = LSP4schema[2].key;
  const MetaDataKey = LSP4schema[3];
  //   const CreatorsKey = LSP4schema[4].key;

  const encodedAssetData = await getAssetData(MetaDataKey.key);
  console.log(encodedAssetData);

  console.log("step 5 -----");
  const decodedAssetData = await decodeData(MetaDataKey.name, encodedAssetData);
  console.log(decodedAssetData);

  console.log("step 6 ---");
  const metadataLink = await getMetaDataLink(decodedAssetData);
  console.log(metadataLink);

  console.log("step 7 -----");
  const result = await fetchAssetData(metadataLink);
  console.log(result);
}

main();
