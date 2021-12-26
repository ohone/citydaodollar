//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC1155/IERC1155Receiver.sol";
import "@openzeppelin/contracts/token/ERC1155/IERC1155.sol";
import "@openzeppelin/contracts/token/ERC1155/utils/ERC1155Holder.sol";
import "@rari-capital/solmate/src/tokens/ERC20.sol";
import "@openzeppelin/contracts/interfaces/IERC165.sol";
import "@openzeppelin/contracts/interfaces/IERC20.sol";
import "@openzeppelin/contracts/utils/introspection/IERC165.sol";
import "./interfaces/IERC3386.sol";

contract CitizenToken is IERC3386, IERC165, ERC20, ERC1155Holder {
    uint256 private constant citizenNftId = 42;
    address public immutable cityDaoNftAddress;
    uint256 citizens_;

    constructor(address nftContractAddress)
        ERC20("CityDaoCitizenERC20", "CITIZEN_", 18)
    {
        cityDaoNftAddress = nftContractAddress;
    }

    function onERC1155Received(
        address operator,
        address from,
        uint256 id,
        uint256 value,
        bytes calldata data
    ) public override returns (bytes4) {
        citizens_++;
        return ERC1155Holder.onERC1155Received(operator, from, id, value, data);
    }

    function onERC1155BatchReceived(
        address,
        address,
        uint256[] calldata,
        uint256[] calldata,
        bytes calldata
    ) public pure override returns (bytes4) {
        revert("not implemented");
    }

    /**
     * @dev See {IERC165-supportsInterface}.
     */
    function supportsInterface(bytes4 interfaceId)
        public
        view
        virtual
        override(IERC165, ERC1155Receiver)
        returns (bool)
    {
        return
            interfaceId == type(IERC165).interfaceId ||
            interfaceId == type(IERC1155Receiver).interfaceId ||
            interfaceId == type(IERC20).interfaceId ||
            interfaceId == type(IERC3386).interfaceId;
    }

    /**
     * @dev See {IERC3386-mint}.
     */
    function mint(
        address _to,
        uint256,
        uint256 _amount
    ) external override(IERC3386) {
        IERC1155(cityDaoNftAddress).safeTransferFrom(
            msg.sender,
            address(this),
            citizenNftId,
            _amount,
            ""
        );
        _mint(_to, _amount * 1000);
        emit MintSingle(msg.sender, _to, citizenNftId, _amount, 0);
    }

    /**
     * @dev See {IERC3386-batchMint}.
     */
    function batchMint(
        address,
        uint256[] calldata,
        uint256[] calldata
    ) external pure override(IERC3386) {
        revert("not implemented");
    }

    /**
     * @dev See {IERC3386-burn}.
     */
    function burn(
        address _from,
        address _to,
        uint256 _amount // number of nfts to withdraw from contract
    ) external override(IERC3386) {
        uint256 burnAmount = 1000 * _amount;
        require(balanceOf[_from] >= burnAmount);

        // remove from circulation
        IERC1155(cityDaoNftAddress).safeTransferFrom(
            address(this),
            _to,
            citizenNftId,
            _amount,
            ""
        );
        _burn(_from, burnAmount);

        citizens_--;
        emit BurnSingle(_from, _to, citizenNftId, _amount, burnAmount);
    }

    /**
     * @dev See {IERC3386-batchBurn}.
     */
    function batchBurn(
        address,
        address,
        uint256[] calldata
    ) external pure override(IERC3386) {
        revert("not implemented");
    }

    /**
     * @dev See {IERC3386-idBurn}.
     */
    function idBurn(
        address,
        address,
        uint256,
        uint256
    ) external pure override(IERC3386) {
        revert("not implemented");
    }

    /**
     * @dev See {IERC3386-batchIdBurn}.
     */
    function batchIdBurn(
        address,
        address,
        uint256[] calldata,
        uint256[] calldata
    ) external pure override(IERC3386) {
        revert("not implemented");
    }
}
