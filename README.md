# lukso-playground

A playground to test, learn and experiment with LSP smart contracts deployed on L14 or L16 test network.

This repository include basic guides to learn how to interact with Universal Profiles, using Node.js.

It used the main LUKSO tools and libraries:

- _lsp-factory.js_
- _erc725.js_

For more details about the smart contracts, see `@lukso/lsp-smart-contracts` npm package.

## Guides

- [x] [**How to create + deploy a Universal Profile in node.js?**](./guides/create-profile.js)

Learn how to deploy a Universal Profile using the _lsp-factory.js_. This will deploy a Full Universal Profile setup with a Key Manager, using an EOA as the main controller `address`.

- [x] [**How to give permission to another address to interact with your Universal Profile**](./guides/give-permissions.js)

Learn how to write a basic script that gives the permission `SETDATA` to another `address` so that it can edit some data keys on your Universal Profile on your behalf.

- [x] [**How to retrieve the list of addresses that have permission of the Universal PROFILE**](./guides/get-permissioned-addresses.js)

Learn how to retrieve the list of addresses that have permissions on the Universal Profile, as well as decoding which permission they actually have.
