import { ethers, network } from 'hardhat';
import * as dotenv from 'dotenv';

import { ERC725YDataKeys } from '@lukso/lsp-smart-contracts';
import LSP7DigitalAssetArtifact from '@lukso/lsp-smart-contracts/artifacts/LSP7DigitalAsset.json';
import LSP4DigitalAssetSchema from '@erc725/erc725.js/schemas/LSP4DigitalAsset.json';
import { ERC725 } from '@erc725/erc725.js';
import { lsp4SampleMetadata } from '../consts/LSP4SampleMetadata';

dotenv.config();

interface CustomNetworkConfig {
  url?: string;
}

async function attachAssetMetadata(myAssetAddress: string) {
  // Get the signer key
  const [signer] = await ethers.getSigners();

  // Set up the token contract
  const token = new ethers.Contract(myAssetAddress, LSP7DigitalAssetArtifact.abi, signer);

  const metadataKey = ERC725YDataKeys.LSP4['LSP4Metadata'];

  const customNetworkConfig = network.config as CustomNetworkConfig;
  const networkUrl = customNetworkConfig.url;

  if (!networkUrl) {
    throw new Error('Network URL is not defined in the Hardhat configuration.');
  }

  const erc725js = new ERC725(LSP4DigitalAssetSchema, myAssetAddress, networkUrl);

  // Read the current token metadata
  const currentMetadata = await erc725js.getData(metadataKey);
  console.log('Current token metadata:', currentMetadata);

  // Encode metadata
  const encodeLSP4Metadata = erc725js.encodeData(lsp4SampleMetadata);
  console.log('its encoding', encodeLSP4Metadata);

  // Update the token metadata
  const tx = await token.setDataBatch(encodeLSP4Metadata.keys, encodeLSP4Metadata.values);

  // Wait for the transaction to be included in a block
  const receipt = await tx.wait();
  console.log('Token metadata updated:', receipt);
}

attachAssetMetadata('0xdb86734b1e27F9A1e73627af6238171BD7d3716C')
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
