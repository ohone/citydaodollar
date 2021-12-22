/* Autogenerated file. Do not edit manually. */
/* tslint:disable */
/* eslint-disable */

import { Contract, Signer, utils } from "ethers";
import { Provider } from "@ethersproject/providers";
import type {
  IERC1155WithRoyalty,
  IERC1155WithRoyaltyInterface,
} from "../IERC1155WithRoyalty";

const _abi = [
  {
    inputs: [
      {
        internalType: "address",
        name: "recipient",
        type: "address",
      },
      {
        internalType: "uint16",
        name: "bps",
        type: "uint16",
      },
    ],
    name: "setDefaultRoyalty",
    outputs: [],
    stateMutability: "nonpayable",
    type: "function",
  },
  {
    inputs: [
      {
        internalType: "uint256",
        name: "tokenId",
        type: "uint256",
      },
      {
        internalType: "address",
        name: "recipient",
        type: "address",
      },
      {
        internalType: "uint16",
        name: "bps",
        type: "uint16",
      },
    ],
    name: "setTokenRoyalty",
    outputs: [],
    stateMutability: "nonpayable",
    type: "function",
  },
];

export class IERC1155WithRoyalty__factory {
  static readonly abi = _abi;
  static createInterface(): IERC1155WithRoyaltyInterface {
    return new utils.Interface(_abi) as IERC1155WithRoyaltyInterface;
  }
  static connect(
    address: string,
    signerOrProvider: Signer | Provider
  ): IERC1155WithRoyalty {
    return new Contract(address, _abi, signerOrProvider) as IERC1155WithRoyalty;
  }
}
