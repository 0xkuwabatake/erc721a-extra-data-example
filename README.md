# erc721a-extra-data-example

## Background
I was curious about how to implement `_setExtraData` function from [ERC721A](https://github.com/chiru-labs/ERC721A/blob/main/contracts/ERC721A.sol#L1442) contract but I couldn't found one. So, I decided to make one for myself. 

## About
This repository is about:
1. How to directly sets `3 bytes(uint24)` token related extra data at [external mint function](https://github.com/0xkuwabatake/erc721a-extra-data-example/blob/main/src/ERC721AExtraData.sol#L27)
2. Get its value via a [public getter function](https://github.com/0xkuwabatake/erc721a-extra-data-example/blob/main/src/ERC721AExtraData.sol#L50)
3. Preserve its value while token is transferred between non-zero addresses by overriding `_extraData` [function](https://github.com/0xkuwabatake/erc721a-extra-data-example/blob/main/src/ERC721AExtraData.sol#L61)

Check out [their official docs](https://github.com/chiru-labs/ERC721A/blob/main/docs/erc721a.md#_setextradataat) for better understanding.

## Usage
### Test

```shell
$ forge test
```

## Important Notes
It's just an example contract, do NOT blindly copy anything here into production code unless you really know what you are doing.