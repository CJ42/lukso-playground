const { ERC725 } = require("@erc725/erc725.js");
const LSP6Schema = require("@erc725/erc725.js/schemas/LSP6KeyManager.json");

const Web3 = require("web3");

// setup
const myUniversalProfileAddress = "0xC26508178c4D7d3Ad43Dcb9F9bb1fab9ceeD58B5";
const RPC_ENDPOINT = "https://rpc.l16.lukso.network";

const web3 = new Web3(RPC_ENDPOINT);

// setup instantiate erc725.js
const erc725 = new ERC725(LSP6Schema, myUniversalProfileAddress, web3.currentProvider);

async function getPermissionedAddresses() {
  // step 1 -get the list of addresses that have permissioned on the Universal Profile
  const result = await erc725.getData("AddressPermissions[]");

  for (let ii = 0; ii < result.value.length; ii++) {
    const address = result.value[ii];

    // step 2 - get the permissions of each address
    const addressPermission = await erc725.getData({
      keyName: "AddressPermissions:Permissions:<address>",
      dynamicKeyParts: address,
    });

    // step 3 - decode the permission of each address
    const decodedPermission = erc725.decodePermissions(addressPermission.value);

    // we use JSON.stringify to display the permission in a readable format
    console.log(`decoded permission for ${address} = ` + JSON.stringify(decodedPermission, null, 2));
  }
}

getPermissionedAddresses();
