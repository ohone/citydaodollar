//SPDX-License-Identifier: Unlicense

pragma solidity ^0.8.0;

/**
    @title IWrapper Identifiable Token Wrapper Standard
    @dev {Wrapper} refers to any contract implementing this interface.
    @dev {Base} refers to any ERC-721 or ERC-1155 contract. It MAY be the {Wrapper}.
    @dev {Pool} refers to the contract which holds the {Base} tokens. It MAY be the {Wrapper}.
    @dev {Derivative} refers to the ERC-20 contract which is minted/burned by the {Wrapper}. It MAY be the {Wrapper}.
    @dev All uses of "single", "batch" refer to the number of token ids. This includes individual ERC-721 tokens by id, and multiple ERC-1155 by id. An ERC-1155 `TransferSingle` event may emit with a `value` greater than `1`, but it is still considered a single token.
    @dev All parameters named `_amount`, `_amounts` refer to the `value` parameters in ERC-1155. When using this interface with ERC-721, `_amount` MUST be 1, and `_amounts` MUST be either an empty list or a list of 1 with the same length as `_ids`.
*/
/* is ERC165 */
interface IERC3386 {
    /**
     * @dev MUST emit when a mint occurs where a single {Base} token is received by the {Pool}.
     * The `_from` argument MUST be the address of the account that sent the {Base} token.
     * The `_to` argument MUST be the address of the account that received the {Derivative} token(s).
     * The `_id` argument MUST be the id of the {Base} token transferred.
     * The `_amount` argument MUST be the number of {Base} tokens transferred.
     * The `_value` argument MUST be the number of {Derivative} tokens minted.
     */
    event MintSingle(
        address indexed _from,
        address indexed _to,
        uint256 _id,
        uint256 _amount,
        uint256 _value
    );

    /**
     * @dev MUST emit when a mint occurs where multiple {Base} tokens are received by the {Wrapper}.
     * The `_from` argument MUST be the address of the account that sent the {Base} tokens.
     * The `_to` argument MUST be the address of the account that received the {Derivative} token(s).
     * The `_ids` argument MUST be the list ids of the {Base} tokens transferred.
     * The `_amounts` argument MUST be the list of the numbers of {Base} tokens transferred.
     * The `_value` argument MUST be the number of {Derivative} tokens minted.
     */
    event MintBatch(
        address indexed _from,
        address indexed _to,
        uint256[] _ids,
        uint256[] _amounts,
        uint256 _value
    );

    /**
     * @dev MUST emit when a burn occurs where a single {Base} token is sent by the {Wrapper}.
     * The `_from` argument MUST be the address of the account that sent the {Derivative} token(s).
     * The `_to` argument MUST be the address of the account that received the {Base} token.
     * The `_id` argument MUST be the id of the {Base} token transferred.
     * The `_amount` argument MUST be the number of {Base} tokens transferred.
     * The `_value` argument MUST be the number of {Derivative} tokens burned.
     */
    event BurnSingle(
        address indexed _from,
        address indexed _to,
        uint256 _id,
        uint256 _amount,
        uint256 _value
    );

    /**
     * @dev MUST emit when a mint occurs where multiple {Base} tokens are sent by the {Wrapper}.
     * The `_from` argument MUST be the address of the account that sent the {Derivative} token(s).
     * The `_to` argument MUST be the address of the account that received the {Base} tokens.
     * The `_ids` argument MUST be the list of ids of the {Base} tokens transferred.
     * The `_amounts` argument MUST be the list of the numbers of {Base} tokens transferred.
     * The `_value` argument MUST be the number of {Derivative} tokens burned.
     */
    event BurnBatch(
        address indexed _from,
        address indexed _to,
        uint256[] _ids,
        uint256[] _amounts,
        uint256 _value
    );

    /**
     * @notice Transfers the {Base} token with `_id` from `msg.sender` to the {Pool} and mints {Derivative} token(s) to `_to`.
     * @param _to       Target address.
     * @param _id       Id of the {Base} token.
     * @param _amount   Amount of the {Base} token.
     *
     * Emits a {MintSingle} event.
     */
    function mint(
        address _to,
        uint256 _id,
        uint256 _amount
    ) external;

    /**
     * @notice Transfers `_amounts[i]` of the {Base} tokens with `_ids[i]` from `msg.sender` to the {Pool} and mints {Derivative} token(s) to `_to`.
     * @param _to       Target address.
     * @param _ids      Ids of the {Base} tokens.
     * @param _amounts  Amounts of the {Base} tokens.
     *
     * Emits a {MintBatch} event.
     */
    function batchMint(
        address _to,
        uint256[] calldata _ids,
        uint256[] calldata _amounts
    ) external;

    /**
     * @notice Burns {Derivative} token(s) from `_from` and transfers `_amounts` of some {Base} token from the {Pool} to `_to`. No guarantees are made as to what token is withdrawn.
     * @param _from     Source address.
     * @param _to       Target address.
     * @param _amount   Amount of the {Base} tokens.
     *
     * Emits either a {BurnSingle} or {BurnBatch} event.
     */
    function burn(
        address _from,
        address _to,
        uint256 _amount
    ) external;

    /**
     * @notice Burns {Derivative} token(s) from `_from` and transfers `_amounts` of some {Base} tokens from the {Pool} to `_to`. No guarantees are made as to what tokens are withdrawn.
     * @param _from     Source address.
     * @param _to       Target address.
     * @param _amounts  Amounts of the {Base} tokens.
     *
     * Emits either a {BurnSingle} or {BurnBatch} event.
     */
    function batchBurn(
        address _from,
        address _to,
        uint256[] calldata _amounts
    ) external;

    /**
     * @notice Burns {Derivative} token(s) from `_from` and transfers `_amounts[i]` of the {Base} tokens with `_ids[i]` from the {Pool} to `_to`.
     * @param _from     Source address.
     * @param _to       Target address.
     * @param _id       Id of the {Base} token.
     * @param _amount   Amount of the {Base} token.
     *
     * Emits either a {BurnSingle} or {BurnBatch} event.
     */
    function idBurn(
        address _from,
        address _to,
        uint256 _id,
        uint256 _amount
    ) external;

    /**
     * @notice Burns {Derivative} tokens from `_from` and transfers `_amounts[i]` of the {Base} tokens with `_ids[i]` from the {Pool} to `_to`.
     * @param _from     Source address.
     * @param _to       Target address.
     * @param _ids      Ids of the {Base} tokens.
     * @param _amounts   Amounts of the {Base} tokens.
     *
     * Emits either a {BurnSingle} or {BurnBatch} event.
     */
    function batchIdBurn(
        address _from,
        address _to,
        uint256[] calldata _ids,
        uint256[] calldata _amounts
    ) external;
}
