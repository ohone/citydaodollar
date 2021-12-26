# CityDao Citizen NFT ERC20 Wrapper Contract

## Build & Test

This project uses hardhat and ethers to compile and test contracts.

```shell
npx hardhat compile 
npx hardhat test
```

# Contracts
## CitizenToken
The `CitizenToken` contract contains functionality to wrap a `CityDao Citizen` `ERC1155` token (identified by contract address specified at deployment + hard coded token id) and mint ERC20 tokens.

The `CitizenToken` contract transfers ownership of the NFT on minting to itself, and mints 1000 tokens to the reciever. 

These 1000 tokens can be burnt to retrieve the `CityDao Citizen` `ERC1155` from the contract.

### Wrapping

To wrap a `CityDao Citizen NFT`, first approve the contract to transfer your NFT by calling `setApprovalForAll` on the `CitizenNFT` contract with the address of the contract.

Invoke `mint` on the `CitizenToken` contract with arguments
-  `to` address to recieve the minted `ERC20` tokens.
-  `id` unused. Id of the token to wrap, this is hard-coded so any passed value will be ignored.
-  `amount` number of `Citizen NFT` to wrap, and . 1000 tokens are minted and transferred per `Citizen NFT`.

### Unwrapping

`1000` `CitizenToken` `ERC20` tokens can be swapped for a single `Citizen NFT` by the `CitizenToken` contract.

Invoke `burn` on the `CitizenToken` contract with arguments 

- `from` - address to transfer `CitizenToken` `ERC20` from.

- `to` - address to recieve the `Citizen NFT` redeemed.

- `amount` - the number of `Citizen NFT` to reclaim from the contract. *The `from` address must contain `1000 * amount` `CitizenToken` `ERC20` tokens. The transaction will revert if an insufficient number of tokens are contained in the wallet.*

