// Sources flattened with hardhat v2.19.5 https://hardhat.org

// SPDX-License-Identifier: Apache-2.0 AND CC0-1.0 AND MIT

// File @erc725/smart-contracts/contracts/errors.sol@v7.0.0

pragma solidity ^0.8.4;

/**
 * @dev Reverts when trying to set `address(0)` as the contract owner when deploying the contract,
 * initializing it or transferring ownership of the contract.
 */
error OwnableCannotSetZeroAddressAsOwner();

/**
 * @dev Reverts when only the owner is allowed to call the function.
 * @param callerAddress The address that tried to make the call.
 */
error OwnableCallerNotTheOwner(address callerAddress);

/**
 * @dev Reverts when trying to send more native tokens `value` than available in current `balance`.
 * @param balance The balance of native tokens of the ERC725X smart contract.
 * @param value The amount of native tokens sent via `ERC725X.execute(...)`/`ERC725X.executeBatch(...)` that is greater than the contract's `balance`.
 */
error ERC725X_InsufficientBalance(uint256 balance, uint256 value);

/**
 * @dev Reverts when the `operationTypeProvided` is none of the default operation types available.
 * (CALL = 0; CREATE = 1; CREATE2 = 2; STATICCALL = 3; DELEGATECALL = 4)
 * @param operationTypeProvided The unrecognised operation type number provided to `ERC725X.execute(...)`/`ERC725X.executeBatch(...)`.
 */
error ERC725X_UnknownOperationType(uint256 operationTypeProvided);

/**
 * @dev Reverts when trying to send native tokens (`value` / `values[]` parameter of {execute} or {executeBatch} functions) while making a `staticcall` (`operationType == 3`).
 * Sending native tokens via `staticcall` is not allowed because it is a state changing operation.
 */
error ERC725X_MsgValueDisallowedInStaticCall();

/**
 * @dev Reverts when trying to send native tokens (`value` / `values[]` parameter of {execute} or {executeBatch} functions) while making a `delegatecall` (`operationType == 4`).
 * Sending native tokens via `staticcall` is not allowed because `msg.value` is persisting.
 */
error ERC725X_MsgValueDisallowedInDelegateCall();

/**
 * @dev Reverts when passing a `to` address that is not `address(0)` (= address zero) while deploying a contract via {execute} or {executeBatch} functions.
 * This error can occur using either operation type 1 (`CREATE`) or 2 (`CREATE2`).
 */
error ERC725X_CreateOperationsRequireEmptyRecipientAddress();

/**
 * @dev Reverts when contract deployment failed via {execute} or {executeBatch} functions,
 * This error can occur using either operation type 1 (`CREATE`) or 2 (`CREATE2`).
 */
error ERC725X_ContractDeploymentFailed();

/**
 * @dev Reverts when no contract bytecode was provided as parameter when trying to deploy a contract via {execute} or {executeBatch}.
 * This error can occur using either operation type 1 (`CREATE`) or 2 (`CREATE2`).
 */
error ERC725X_NoContractBytecodeProvided();

/**
 * @dev Reverts when there is not the same number of elements in the `operationTypes`, `targets` addresses, `values`, and `datas`
 * array parameters provided when calling the {executeBatch} function.
 */
error ERC725X_ExecuteParametersLengthMismatch();

/**
 * @dev Reverts when one of the array parameter provided to the {executeBatch} function is an empty array.
 */
error ERC725X_ExecuteParametersEmptyArray();

/**
 * @dev Reverts when there is not the same number of elements in the `datakeys` and `dataValues`
 * array parameters provided when calling the {setDataBatch} function.
 */
error ERC725Y_DataKeysValuesLengthMismatch();

/**
 * @dev Reverts when one of the array parameter provided to {setDataBatch} function is an empty array.
 */
error ERC725Y_DataKeysValuesEmptyArray();

/**
 * @dev Reverts when sending value to the {setData} or {setDataBatch} function.
 */
error ERC725Y_MsgValueDisallowed();

// File @erc725/smart-contracts/contracts/custom/OwnableUnset.sol@v7.0.0

// errors

/**
 * @title OwnableUnset
 * @dev modified version of OpenZeppelin implementation, where:
 * - _setOwner(address) function is internal, so this function can be used in constructor
 * of contracts implementation (instead of using transferOwnership(address)
 * - the contract does not inherit from Context contract
 */
abstract contract OwnableUnset {
    address private _owner;

    event OwnershipTransferred(
        address indexed previousOwner,
        address indexed newOwner
    );

    /**
     * @dev Returns the address of the current owner.
     */
    function owner() public view virtual returns (address) {
        return _owner;
    }

    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwner() {
        _checkOwner();
        _;
    }

    /**
     * @dev Leaves the contract without owner. It will not be possible to call
     * `onlyOwner` functions anymore. Can only be called by the current owner.
     *
     * NOTE: Renouncing ownership will leave the contract without an owner,
     * thereby removing any functionality that is only available to the owner.
     */
    function renounceOwnership() public virtual onlyOwner {
        _setOwner(address(0));
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Can only be called by the current owner.
     */
    function transferOwnership(address newOwner) public virtual onlyOwner {
        if (newOwner == address(0)) {
            revert OwnableCannotSetZeroAddressAsOwner();
        }
        _setOwner(newOwner);
    }

    /**
     * @dev Throws if the sender is not the owner.
     */
    function _checkOwner() internal view virtual {
        if (owner() != msg.sender) {
            revert OwnableCallerNotTheOwner(msg.sender);
        }
    }

    /**
     * @dev Changes the owner if `newOwner` and oldOwner are different
     * This pattern is useful in inheritance.
     */
    function _setOwner(address newOwner) internal virtual {
        if (newOwner != owner()) {
            emit OwnershipTransferred(_owner, newOwner);
            _owner = newOwner;
        }
    }
}

// File @erc725/smart-contracts/contracts/constants.sol@v7.0.0

// Original license: SPDX_License_Identifier: Apache-2.0

// ERC165 INTERFACE IDs
bytes4 constant _INTERFACEID_ERC725X = 0x7545acac;
bytes4 constant _INTERFACEID_ERC725Y = 0x629aa694;

// ERC725X OPERATION TYPES
uint256 constant OPERATION_0_CALL = 0;
uint256 constant OPERATION_1_CREATE = 1;
uint256 constant OPERATION_2_CREATE2 = 2;
uint256 constant OPERATION_3_STATICCALL = 3;
uint256 constant OPERATION_4_DELEGATECALL = 4;

// File @openzeppelin/contracts/utils/introspection/IERC165.sol@v4.9.5

// Original license: SPDX_License_Identifier: MIT
// OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)

/**
 * @dev Interface of the ERC165 standard, as defined in the
 * https://eips.ethereum.org/EIPS/eip-165[EIP].
 *
 * Implementers can declare support of contract interfaces, which can then be
 * queried by others ({ERC165Checker}).
 *
 * For an implementation, see {ERC165}.
 */
interface IERC165 {
    /**
     * @dev Returns true if this contract implements the interface defined by
     * `interfaceId`. See the corresponding
     * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
     * to learn more about how these ids are created.
     *
     * This function call must use less than 30 000 gas.
     */
    function supportsInterface(bytes4 interfaceId) external view returns (bool);
}

// File @erc725/smart-contracts/contracts/interfaces/IERC725Y.sol@v7.0.0

// Original license: SPDX_License_Identifier: CC0-1.0

// interfaces

/**
 * @title The interface for ERC725Y sub-standard, a generic data key/value store.
 * @dev ERC725Y provides the ability to set arbitrary data key/value pairs that can be changed over time.
 * It is intended to standardise certain data key/value pairs to allow automated read and writes from/to the contract storage.
 */
interface IERC725Y is IERC165 {
    /**
     * @notice The following data key/value pair has been changed in the ERC725Y storage: Data key: `dataKey`, data value: `dataValue`.
     * @dev Emitted when data at a specific `dataKey` was changed to a new value `dataValue`.
     * @param dataKey The data key for which a bytes value is set.
     * @param dataValue The value to set for the given data key.
     */
    event DataChanged(bytes32 indexed dataKey, bytes dataValue);

    /**
     * @notice Reading the ERC725Y storage for data key `dataKey` returned the following value: `dataValue`.
     * @dev Get in the ERC725Y storage the bytes data stored at a specific data key `dataKey`.
     * @param dataKey The data key for which to retrieve the value.
     * @return dataValue The bytes value stored under the specified data key.
     */
    function getData(
        bytes32 dataKey
    ) external view returns (bytes memory dataValue);

    /**
     * @notice Reading the ERC725Y storage for data keys `dataKeys` returned the following values: `dataValues`.
     * @dev Get in the ERC725Y storage the bytes data stored at multiple data keys `dataKeys`.
     * @param dataKeys The array of keys which values to retrieve
     * @return dataValues The array of data stored at multiple keys
     */
    function getDataBatch(
        bytes32[] memory dataKeys
    ) external view returns (bytes[] memory dataValues);

    /**
     * @notice Setting the following data key value pair in the ERC725Y storage. Data key: `dataKey`, data value: `dataValue`.
     *
     * @dev Sets a single bytes value `dataValue` in the ERC725Y storage for a specific data key `dataKey`.
     * The function is marked as payable to enable flexibility on child contracts. For instance to implement
     * a fee mechanism for setting specific data.
     *
     * @param dataKey The data key for which to set a new value.
     * @param dataValue The new bytes value to set.
     */
    function setData(bytes32 dataKey, bytes memory dataValue) external payable;

    /**
     * @notice Setting the following data key value pairs in the ERC725Y storage. Data keys: `dataKeys`, data values: `dataValues`.
     *
     * @dev Batch data setting function that behaves the same as {setData} but allowing to set multiple data key/value pairs in the ERC725Y storage in the same transaction.
     *
     * @param dataKeys An array of data keys to set bytes values for.
     * @param dataValues An array of bytes values to set for each `dataKeys`.
     */
    function setDataBatch(
        bytes32[] memory dataKeys,
        bytes[] memory dataValues
    ) external payable;
}

// File @openzeppelin/contracts/utils/introspection/ERC165.sol@v4.9.5

// Original license: SPDX_License_Identifier: MIT
// OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)

/**
 * @dev Implementation of the {IERC165} interface.
 *
 * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
 * for the additional interface id that will be supported. For example:
 *
 * ```solidity
 * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
 *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
 * }
 * ```
 *
 * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
 */
abstract contract ERC165 is IERC165 {
    /**
     * @dev See {IERC165-supportsInterface}.
     */
    function supportsInterface(
        bytes4 interfaceId
    ) public view virtual override returns (bool) {
        return interfaceId == type(IERC165).interfaceId;
    }
}

// File @erc725/smart-contracts/contracts/ERC725YCore.sol@v7.0.0

// Original license: SPDX_License_Identifier: Apache-2.0

// interfaces

// modules

// constants

/**
 * @title Core implementation of ERC725Y sub-standard, a general data key/value store.
 * @author Fabian Vogelsteller <fabian@lukso.network>
 * @dev ERC725Y provides the ability to set arbitrary data key/value pairs that can be changed over time.
 * It is intended to standardise certain data key/value pairs to allow automated read and writes from/to the contract storage.
 */
abstract contract ERC725YCore is OwnableUnset, ERC165, IERC725Y {
    /**
     * @dev Map `bytes32` data keys to their `bytes` data values.
     */
    mapping(bytes32 => bytes) internal _store;

    /**
     * @inheritdoc IERC725Y
     */
    function getData(
        bytes32 dataKey
    ) public view virtual override returns (bytes memory dataValue) {
        dataValue = _getData(dataKey);
    }

    /**
     * @inheritdoc IERC725Y
     */
    function getDataBatch(
        bytes32[] memory dataKeys
    ) public view virtual override returns (bytes[] memory dataValues) {
        dataValues = new bytes[](dataKeys.length);

        for (uint256 i = 0; i < dataKeys.length; ) {
            dataValues[i] = _getData(dataKeys[i]);

            // Increment the iterator in unchecked block to save gas
            unchecked {
                ++i;
            }
        }

        return dataValues;
    }

    /**
     * @inheritdoc IERC725Y
     * @custom:requirements
     * - SHOULD only be callable by the {owner}.
     *
     * @custom:warning
     * **Note for developers:** despite the fact that this function is set as `payable`, if the function is not intended to receive value
     * (= native tokens), **an additional check should be implemented to ensure that `msg.value` sent was equal to 0**.
     *
     * @custom:events {DataChanged} event.
     */
    function setData(
        bytes32 dataKey,
        bytes memory dataValue
    ) public payable virtual override onlyOwner {
        if (msg.value != 0) revert ERC725Y_MsgValueDisallowed();
        _setData(dataKey, dataValue);
    }

    /**
     * @inheritdoc IERC725Y
     * @custom:requirements
     * - SHOULD only be callable by the {owner} of the contract.
     *
     * @custom:warning
     * **Note for developers:** despite the fact that this function is set as `payable`, if the function is not intended to receive value
     * (= native tokens), **an additional check should be implemented to ensure that `msg.value` sent was equal to 0**.
     *
     * @custom:events {DataChanged} event **for each data key/value pair set**.
     */
    function setDataBatch(
        bytes32[] memory dataKeys,
        bytes[] memory dataValues
    ) public payable virtual override onlyOwner {
        /// @dev do not allow to send value by default when setting data in ERC725Y
        if (msg.value != 0) revert ERC725Y_MsgValueDisallowed();

        if (dataKeys.length != dataValues.length) {
            revert ERC725Y_DataKeysValuesLengthMismatch();
        }

        if (dataKeys.length == 0) {
            revert ERC725Y_DataKeysValuesEmptyArray();
        }

        for (uint256 i = 0; i < dataKeys.length; ) {
            _setData(dataKeys[i], dataValues[i]);

            // Increment the iterator in unchecked block to save gas
            unchecked {
                ++i;
            }
        }
    }

    /**
     * @dev Read the value stored under a specific `dataKey` inside the underlying ERC725Y storage,
     *  represented as a mapping of `bytes32` data keys mapped to their `bytes` data values.
     *
     * ```solidity
     * mapping(bytes32 => bytes) _store
     * ```
     *
     * @param dataKey A bytes32 data key to read the associated `bytes` value from the store.
     * @return dataValue The `bytes` value associated with the given `dataKey` in the ERC725Y storage.
     */
    function _getData(
        bytes32 dataKey
    ) internal view virtual returns (bytes memory dataValue) {
        return _store[dataKey];
    }

    /**
     * @dev Write a `dataValue` to the underlying ERC725Y storage, represented as a mapping of
     * `bytes32` data keys mapped to their `bytes` data values.
     *
     * ```solidity
     * mapping(bytes32 => bytes) _store
     * ```
     *
     * @param dataKey A bytes32 data key to write the associated `bytes` value to the store.
     * @param dataValue The `bytes` value to associate with the given `dataKey` in the ERC725Y storage.
     *
     * @custom:events {DataChanged} event emitted after a successful `setData` call.
     */
    function _setData(
        bytes32 dataKey,
        bytes memory dataValue
    ) internal virtual {
        _store[dataKey] = dataValue;
        emit DataChanged(dataKey, dataValue);
    }

    /**
     * @inheritdoc ERC165
     */
    function supportsInterface(
        bytes4 interfaceId
    ) public view virtual override(IERC165, ERC165) returns (bool) {
        return
            interfaceId == _INTERFACEID_ERC725Y ||
            super.supportsInterface(interfaceId);
    }
}

// File @erc725/smart-contracts/contracts/ERC725Y.sol@v7.0.0

// Original license: SPDX_License_Identifier: Apache-2.0

// modules

// errors

/**
 * @title Deployable implementation with `constructor` of ERC725Y, a generic data key/value store.
 * @author Fabian Vogelsteller <fabian@lukso.network>
 * @dev ERC725Y provides the ability to set arbitrary data key/value pairs that can be changed over time.
 * It is intended to standardise certain data key/value pairs to allow automated read and writes from/to the contract storage.
 */
contract ERC725Y is ERC725YCore {
    /**
     * @notice Deploying an ERC725Y smart contract and setting address `initialOwner` as the contract owner.
     * @dev Deploy a new ERC725Y contract with the provided `initialOwner` as the contract {owner}.
     * @param initialOwner the owner of the contract.
     *
     * @custom:requirements
     * - `initialOwner` CANNOT be the zero address.
     */
    constructor(address initialOwner) payable {
        if (initialOwner == address(0)) {
            revert OwnableCannotSetZeroAddressAsOwner();
        }
        OwnableUnset._setOwner(initialOwner);
    }
}

// File @lukso/lsp-smart-contracts/contracts/LSP17ContractExtension/LSP17Constants.sol@v0.14.0

// Original license: SPDX_License_Identifier: Apache-2.0

// --- ERC165 interface ids

// bytes4(keccack256("LSP17Extendable"))
bytes4 constant _INTERFACEID_LSP17_EXTENDABLE = 0xa918fa6b;

// bytes4(keccack256("LSP17Extension"))
bytes4 constant _INTERFACEID_LSP17_EXTENSION = 0xcee78b40;

// --- ERC725Y Data Keys

// Extension Handler Prefix

// bytes10(keccak256('LSP17Extension'))
bytes10 constant _LSP17_EXTENSION_PREFIX = 0xcee78b4094da86011096;

// File @lukso/lsp-smart-contracts/contracts/LSP17ContractExtension/LSP17Errors.sol@v0.14.0

// Original license: SPDX_License_Identifier: Apache-2.0

/**
 * @dev reverts when there is no extension for the function selector being called with
 */
error NoExtensionFoundForFunctionSelector(bytes4 functionSelector);

/**
 * @dev reverts when the contract is called with a function selector not valid (less than 4 bytes of data)
 */
error InvalidFunctionSelector(bytes data);

/**
 * @dev reverts when the bytes retrieved from the LSP17 data key is not a valid address (not 20 bytes)
 */
error InvalidExtensionAddress(bytes storedData);

// File @openzeppelin/contracts/utils/introspection/ERC165Checker.sol@v4.9.5

// Original license: SPDX_License_Identifier: MIT
// OpenZeppelin Contracts (last updated v4.9.0) (utils/introspection/ERC165Checker.sol)

/**
 * @dev Library used to query support of an interface declared via {IERC165}.
 *
 * Note that these functions return the actual result of the query: they do not
 * `revert` if an interface is not supported. It is up to the caller to decide
 * what to do in these cases.
 */
library ERC165Checker {
    // As per the EIP-165 spec, no interface should ever match 0xffffffff
    bytes4 private constant _INTERFACE_ID_INVALID = 0xffffffff;

    /**
     * @dev Returns true if `account` supports the {IERC165} interface.
     */
    function supportsERC165(address account) internal view returns (bool) {
        // Any contract that implements ERC165 must explicitly indicate support of
        // InterfaceId_ERC165 and explicitly indicate non-support of InterfaceId_Invalid
        return
            supportsERC165InterfaceUnchecked(
                account,
                type(IERC165).interfaceId
            ) &&
            !supportsERC165InterfaceUnchecked(account, _INTERFACE_ID_INVALID);
    }

    /**
     * @dev Returns true if `account` supports the interface defined by
     * `interfaceId`. Support for {IERC165} itself is queried automatically.
     *
     * See {IERC165-supportsInterface}.
     */
    function supportsInterface(
        address account,
        bytes4 interfaceId
    ) internal view returns (bool) {
        // query support of both ERC165 as per the spec and support of _interfaceId
        return
            supportsERC165(account) &&
            supportsERC165InterfaceUnchecked(account, interfaceId);
    }

    /**
     * @dev Returns a boolean array where each value corresponds to the
     * interfaces passed in and whether they're supported or not. This allows
     * you to batch check interfaces for a contract where your expectation
     * is that some interfaces may not be supported.
     *
     * See {IERC165-supportsInterface}.
     *
     * _Available since v3.4._
     */
    function getSupportedInterfaces(
        address account,
        bytes4[] memory interfaceIds
    ) internal view returns (bool[] memory) {
        // an array of booleans corresponding to interfaceIds and whether they're supported or not
        bool[] memory interfaceIdsSupported = new bool[](interfaceIds.length);

        // query support of ERC165 itself
        if (supportsERC165(account)) {
            // query support of each interface in interfaceIds
            for (uint256 i = 0; i < interfaceIds.length; i++) {
                interfaceIdsSupported[i] = supportsERC165InterfaceUnchecked(
                    account,
                    interfaceIds[i]
                );
            }
        }

        return interfaceIdsSupported;
    }

    /**
     * @dev Returns true if `account` supports all the interfaces defined in
     * `interfaceIds`. Support for {IERC165} itself is queried automatically.
     *
     * Batch-querying can lead to gas savings by skipping repeated checks for
     * {IERC165} support.
     *
     * See {IERC165-supportsInterface}.
     */
    function supportsAllInterfaces(
        address account,
        bytes4[] memory interfaceIds
    ) internal view returns (bool) {
        // query support of ERC165 itself
        if (!supportsERC165(account)) {
            return false;
        }

        // query support of each interface in interfaceIds
        for (uint256 i = 0; i < interfaceIds.length; i++) {
            if (!supportsERC165InterfaceUnchecked(account, interfaceIds[i])) {
                return false;
            }
        }

        // all interfaces supported
        return true;
    }

    /**
     * @notice Query if a contract implements an interface, does not check ERC165 support
     * @param account The address of the contract to query for support of an interface
     * @param interfaceId The interface identifier, as specified in ERC-165
     * @return true if the contract at account indicates support of the interface with
     * identifier interfaceId, false otherwise
     * @dev Assumes that account contains a contract that supports ERC165, otherwise
     * the behavior of this method is undefined. This precondition can be checked
     * with {supportsERC165}.
     *
     * Some precompiled contracts will falsely indicate support for a given interface, so caution
     * should be exercised when using this function.
     *
     * Interface identification is specified in ERC-165.
     */
    function supportsERC165InterfaceUnchecked(
        address account,
        bytes4 interfaceId
    ) internal view returns (bool) {
        // prepare call
        bytes memory encodedParams = abi.encodeWithSelector(
            IERC165.supportsInterface.selector,
            interfaceId
        );

        // perform static call
        bool success;
        uint256 returnSize;
        uint256 returnValue;
        assembly {
            success := staticcall(
                30000,
                account,
                add(encodedParams, 0x20),
                mload(encodedParams),
                0x00,
                0x20
            )
            returnSize := returndatasize()
            returnValue := mload(0x00)
        }

        return success && returnSize >= 0x20 && returnValue > 0;
    }
}

// File @lukso/lsp-smart-contracts/contracts/LSP17ContractExtension/LSP17Extendable.sol@v0.14.0

// Original license: SPDX_License_Identifier: Apache-2.0

// modules

// constants

// errors

/**
 * @title Module to add more functionalities to a contract using extensions.
 *
 * @dev Implementation of the `fallback(...)` logic according to LSP17 - Contract Extension standard.
 * This module can be inherited to extend the functionality of the parent contract when
 * calling a function that doesn't exist on the parent contract via forwarding the call
 * to an extension mapped to the function selector being called, set originally by the parent contract
 */
abstract contract LSP17Extendable is ERC165 {
    /**
     * @dev See {IERC165-supportsInterface}.
     */
    function supportsInterface(
        bytes4 interfaceId
    ) public view virtual override returns (bool) {
        return
            interfaceId == _INTERFACEID_LSP17_EXTENDABLE ||
            super.supportsInterface(interfaceId);
    }

    /**
     * @dev Returns whether the interfaceId being checked is supported in the extension of the
     * {supportsInterface} selector.
     *
     * To be used by extendable contracts wishing to extend the ERC165 interfaceIds originally
     * supported by reading whether the interfaceId queried is supported in the `supportsInterface`
     * extension if the extension is set, if not it returns false.
     */
    function _supportsInterfaceInERC165Extension(
        bytes4 interfaceId
    ) internal view virtual returns (bool) {
        (address erc165Extension, ) = _getExtensionAndForwardValue(
            ERC165.supportsInterface.selector
        );
        if (erc165Extension == address(0)) return false;

        return
            ERC165Checker.supportsERC165InterfaceUnchecked(
                erc165Extension,
                interfaceId
            );
    }

    /**
     * @dev Returns the extension mapped to a specific function selector
     * If no extension was found, return the address(0)
     * To be overrided.
     * Up to the implementor contract to return an extension based on a function selector
     */
    function _getExtensionAndForwardValue(
        bytes4 functionSelector
    ) internal view virtual returns (address, bool);

    /**
     * @dev Forwards the call to an extension mapped to a function selector.
     *
     * Calls {_getExtensionAndForwardValue} to get the address of the extension mapped to the function selector being
     * called on the account. If there is no extension, the `address(0)` will be returned.
     * Forwards the value if the extension is payable.
     *
     * Reverts if there is no extension for the function being called.
     *
     * If there is an extension for the function selector being called, it calls the extension with the
     * `CALL` opcode, passing the `msg.data` appended with the 20 bytes of the {msg.sender} and 32 bytes of the `msg.value`.
     *
     * @custom:hint This function does not forward to the extension contract the `msg.value` received by the contract that inherits `LSP17Extendable`.
     * If you would like to forward the `msg.value` to the extension contract, you can override the code of this internal function as follow:
     *
     * ```solidity
     * (bool success, bytes memory result) = extension.call{value: msg.value}(
     *     abi.encodePacked(callData, msg.sender, msg.value)
     * );
     * ```
     */
    function _fallbackLSP17Extendable(
        bytes calldata callData
    ) internal virtual returns (bytes memory) {
        // If there is a function selector
        (
            address extension,
            bool shouldForwardValue
        ) = _getExtensionAndForwardValue(msg.sig);

        // if no extension was found, revert
        if (extension == address(0))
            revert NoExtensionFoundForFunctionSelector(msg.sig);

        (bool success, bytes memory result) = extension.call{
            value: shouldForwardValue ? msg.value : 0
        }(abi.encodePacked(callData, msg.sender, msg.value));

        if (success) {
            return result;
        } else {
            // `mload(result)` -> offset in memory where `result.length` is located
            // `add(result, 32)` -> offset in memory where `result` data starts
            // solhint-disable no-inline-assembly
            /// @solidity memory-safe-assembly
            assembly {
                let resultdata_size := mload(result)
                revert(add(result, 32), resultdata_size)
            }
        }
    }
}

// File @lukso/lsp-smart-contracts/contracts/LSP1UniversalReceiver/ILSP1UniversalReceiver.sol@v0.14.0

// Original license: SPDX_License_Identifier: Apache-2.0

/**
 * @title Interface of the LSP1 - Universal Receiver standard, an entry function for a contract to receive arbitrary information.
 * @dev LSP1UniversalReceiver allows to receive arbitrary messages and to be informed when assets are sent or received.
 */
interface ILSP1UniversalReceiver {
    /**
     * @dev Emitted when the {universalReceiver} function was called with a specific `typeId` and some `receivedData`
     * @notice Address `from` called the `universalReceiver(...)` function while sending `value` LYX. Notification type (typeId): `typeId` - Data received: `receivedData`.
     *
     * @param from The address of the EOA or smart contract that called the {universalReceiver(...)} function.
     * @param value The amount sent to the {universalReceiver(...)} function.
     * @param typeId A `bytes32` unique identifier (= _"hook"_)that describe the type of notification, information or transaction received by the contract. Can be related to a specific standard or a hook.
     * @param receivedData Any arbitrary data that was sent to the {universalReceiver(...)} function.
     * @param returnedValue The value returned by the {universalReceiver(...)} function.
     */
    event UniversalReceiver(
        address indexed from,
        uint256 indexed value,
        bytes32 indexed typeId,
        bytes receivedData,
        bytes returnedValue
    );

    /**
     * @dev Generic function that can be used to notify the contract about specific incoming transactions or events like asset transfers, vault transfers, etc. Allows for custom on-chain and off-chain reactions based on the `typeId` and `data`.
     * @notice Reacted on received notification with `typeId` & `data`.
     *
     * @param typeId The hash of a specific standard or a hook.
     * @param data The arbitrary data received with the call.
     *
     * @custom:events {UniversalReceiver} event.
     */
    function universalReceiver(
        bytes32 typeId,
        bytes calldata data
    ) external payable returns (bytes memory);
}

// File @lukso/lsp-smart-contracts/contracts/LSP1UniversalReceiver/LSP1Constants.sol@v0.14.0

// Original license: SPDX_License_Identifier: Apache-2.0

// --- ERC165 interface ids
bytes4 constant _INTERFACEID_LSP1 = 0x6bb56a14;
bytes4 constant _INTERFACEID_LSP1_DELEGATE = 0xa245bbda;

// --- ERC725Y Data Keys

// bytes10(keccak256('LSP1UniversalReceiverDelegate'))
bytes10 constant _LSP1_UNIVERSAL_RECEIVER_DELEGATE_PREFIX = 0x0cfc51aec37c55a4d0b1;

// keccak256('LSP1UniversalReceiverDelegate')
bytes32 constant _LSP1_UNIVERSAL_RECEIVER_DELEGATE_KEY = 0x0cfc51aec37c55a4d0b1a65c6255c4bf2fbdf6277f3cc0730c45b828b6db8b47;

// File @lukso/lsp-smart-contracts/contracts/LSP2ERC725YJSONSchema/LSP2Utils.sol@v0.14.0

// Original license: SPDX_License_Identifier: Apache-2.0

// interfaces

/**
 * @title LSP2 Utility library.
 * @author Jean Cavallera <CJ42>, Yamen Merhi <YamenMerhi>, Daniel Afteni <B00ste>
 * @dev LSP2Utils is a library of utility functions that can be used to encode data key of different key type
 * defined on the LSP2 standard.
 * Based on LSP2 ERC725Y JSON Schema standard.
 */
library LSP2Utils {
    /**
     * @dev Generates a data key of keyType Singleton by hashing the string `keyName`. As:
     *
     * ```
     * keccak256("keyName")
     * ```
     *
     * @param keyName The string to hash to generate a Singleton data key.
     *
     * @return The generated `bytes32` data key of key type Singleton.
     */
    function generateSingletonKey(
        string memory keyName
    ) internal pure returns (bytes32) {
        return keccak256(bytes(keyName));
    }

    /**
     * @dev Generates a data key of keyType Array by hashing `arrayKeyName`. As:
     *
     * ```
     * keccak256("arrayKeyName[]")
     * ```
     *
     * @param arrayKeyName The string that will be used to generate a data key of key type Array.
     *
     * @return The generated `bytes32` data key of key type Array.
     *
     * @custom:requirements
     * - The `keyName` must include at the end of the string the square brackets `"[]"`.
     */
    function generateArrayKey(
        string memory arrayKeyName
    ) internal pure returns (bytes32) {
        bytes memory dataKey = bytes(arrayKeyName);
        require(dataKey.length >= 2, "MUST be longer than 2 characters");
        require(
            dataKey[dataKey.length - 2] == 0x5b && // "[" in utf8 encoded
                dataKey[dataKey.length - 1] == 0x5d, // "]" in utf8
            "Missing empty square brackets '[]' at the end of the key name"
        );

        return keccak256(dataKey);
    }

    /**
     * @dev Generates an Array data key at a specific `index` by concatenating together the first 16 bytes of `arrayKey`
     * with the 16 bytes of `index`. As:
     *
     * ```
     * arrayKey[index]
     * ```
     *
     * @param arrayKey The Array data key from which to generate the Array data key at a specific `index`.
     * @param index The index number in the `arrayKey`.
     *
     * @return The generated `bytes32` data key of key type Array at a specific `index`.
     */
    function generateArrayElementKeyAtIndex(
        bytes32 arrayKey,
        uint128 index
    ) internal pure returns (bytes32) {
        bytes memory elementInArray = bytes.concat(
            bytes16(arrayKey),
            bytes16(index)
        );
        return bytes32(elementInArray);
    }

    /**
     * @dev Generates a data key of key type Mapping that map `firstWord` to `lastWord`. This is done by hashing two strings words `firstWord` and `lastWord`. As:
     *
     * ```
     * bytes10(firstWordHash):0000:bytes20(lastWordHash)
     * ```
     *
     * @param firstWord The word to retrieve the first 10 bytes of its hash.
     * @param lastWord The word to retrieve the first 10 bytes of its hash.
     *
     * @return The generated `bytes32` data key of key type Mapping that map `firstWord` to a specific `lastWord`.
     */
    function generateMappingKey(
        string memory firstWord,
        string memory lastWord
    ) internal pure returns (bytes32) {
        bytes32 firstWordHash = keccak256(bytes(firstWord));
        bytes32 lastWordHash = keccak256(bytes(lastWord));

        bytes memory temporaryBytes = bytes.concat(
            bytes10(firstWordHash),
            bytes2(0),
            bytes20(lastWordHash)
        );

        return bytes32(temporaryBytes);
    }

    /**
     * @dev Generates a data key of key type Mapping that map `firstWord` to an address `addr`.
     * This is done by hashing the string word `firstWord` and concatenating its first 10 bytes with `addr`. As:
     *
     * ```
     * bytes10(firstWordHash):0000:<address>
     * ```
     *
     * @param firstWord The word to retrieve the first 10 bytes of its hash.
     * @param addr An address to map `firstWord` to.
     *
     * @return The generated `bytes32` data key of key type Mapping that map `firstWord` to a specific address `addr`.
     */
    function generateMappingKey(
        string memory firstWord,
        address addr
    ) internal pure returns (bytes32) {
        bytes32 firstWordHash = keccak256(bytes(firstWord));

        bytes memory temporaryBytes = bytes.concat(
            bytes10(firstWordHash),
            bytes2(0),
            bytes20(addr)
        );

        return bytes32(temporaryBytes);
    }

    /**
     * @dev Generate a data key of key type Mapping that map a 10 bytes `keyPrefix` to a `bytes20Value`. As:
     *
     * ```
     * keyPrefix:bytes20Value
     * ```
     *
     * @param keyPrefix The first part of the data key of key type Mapping.
     * @param bytes20Value The second part of the data key of key type Mapping.
     *
     * @return The generated `bytes32` data key of key type Mapping that map a `keyPrefix` to a specific `bytes20Value`.
     */
    function generateMappingKey(
        bytes10 keyPrefix,
        bytes20 bytes20Value
    ) internal pure returns (bytes32) {
        bytes memory generatedKey = bytes.concat(
            keyPrefix,
            bytes2(0),
            bytes20Value
        );
        return bytes32(generatedKey);
    }

    /**
     * @dev Generate a data key of key type MappingWithGrouping by using two strings `firstWord`
     * mapped to a `secondWord` mapped itself to a specific address `addr`. As:
     *
     * ```
     * bytes6(keccak256("firstWord")):bytes4(keccak256("secondWord")):0000:<address>
     * ```
     *
     * @param firstWord The word to retrieve the first 6 bytes of its hash.
     * @param secondWord The word to retrieve the first 4 bytes of its hash.
     * @param addr The address that makes the last part of the MappingWithGrouping.
     *
     * @return The generated `bytes32` data key of key type MappingWithGrouping that map a `firstWord` to a `secondWord` to a specific address `addr`.
     */
    function generateMappingWithGroupingKey(
        string memory firstWord,
        string memory secondWord,
        address addr
    ) internal pure returns (bytes32) {
        bytes32 firstWordHash = keccak256(bytes(firstWord));
        bytes32 secondWordHash = keccak256(bytes(secondWord));

        bytes memory temporaryBytes = bytes.concat(
            bytes6(firstWordHash),
            bytes4(secondWordHash),
            bytes2(0),
            bytes20(addr)
        );

        return bytes32(temporaryBytes);
    }

    /**
     * @dev Generate a data key of key type MappingWithGrouping that map a `keyPrefix` to an other `mapPrefix` to a specific `subMapKey`. As:
     *
     * ```
     * keyPrefix:mapPrefix:0000:subMapKey
     * ```
     *
     * @param keyPrefix The first part (6 bytes) of the data key of keyType MappingWithGrouping.
     * @param mapPrefix The second part (4 bytes) of the data key of keyType MappingWithGrouping.
     * @param subMapKey The last part (bytes20) of the data key of keyType MappingWithGrouping.
     *
     * @return The generated `bytes32` data key of key type MappingWithGrouping that map a `keyPrefix` to a `mapPrefix` to a specific `subMapKey`.
     */
    function generateMappingWithGroupingKey(
        bytes6 keyPrefix,
        bytes4 mapPrefix,
        bytes20 subMapKey
    ) internal pure returns (bytes32) {
        bytes memory generatedKey = bytes.concat(
            keyPrefix,
            mapPrefix,
            bytes2(0),
            subMapKey
        );
        return bytes32(generatedKey);
    }

    /**
     * @dev Generate a data key of key type MappingWithGrouping that map a 10 bytes `keyPrefix` to a specific `bytes20Value`. As:
     *
     * @param keyPrefix The first part of the data key of keyType MappingWithGrouping.
     * @param bytes20Value The last of the data key of keyType MappingWithGrouping.
     *
     * @return The generated `bytes32` data key of key type MappingWithGrouping that map a `keyPrefix`
     * (containing the first and second mapped word) to a specific `bytes20Value`.
     */
    function generateMappingWithGroupingKey(
        bytes10 keyPrefix,
        bytes20 bytes20Value
    ) internal pure returns (bytes32) {
        bytes memory generatedKey = bytes.concat(
            keyPrefix,
            bytes2(0),
            bytes20Value
        );
        return bytes32(generatedKey);
    }

    /**
     * @dev Generate a JSONURL value content.
     * @param hashFunction The function used to hash the JSON file.
     * @param json Bytes value of the JSON file.
     * @param url The URL where the JSON file is hosted.
     */
    function generateJSONURLValue(
        string memory hashFunction,
        string memory json,
        string memory url
    ) internal pure returns (bytes memory) {
        bytes32 hashFunctionDigest = keccak256(bytes(hashFunction));
        bytes32 jsonDigest = keccak256(bytes(json));

        return abi.encodePacked(bytes4(hashFunctionDigest), jsonDigest, url);
    }

    /**
     * @dev Generate a ASSETURL value content.
     *
     * @param hashFunction The function used to hash the JSON file.
     * @param assetBytes Bytes value of the JSON file.
     * @param url The URL where the JSON file is hosted.
     *
     * @return The encoded value as an `ASSETURL`.
     */
    function generateASSETURLValue(
        string memory hashFunction,
        string memory assetBytes,
        string memory url
    ) internal pure returns (bytes memory) {
        bytes32 hashFunctionDigest = keccak256(bytes(hashFunction));
        bytes32 jsonDigest = keccak256(bytes(assetBytes));

        return abi.encodePacked(bytes4(hashFunctionDigest), jsonDigest, url);
    }

    /**
     * @dev Verify if `data` is a valid array of value encoded as a `CompactBytesArray` according to the LSP2 `CompactBytesArray` valueType specification.
     *
     * @param compactBytesArray The bytes value to verify.
     *
     * @return `true` if the `data` is correctly encoded CompactBytesArray, `false` otherwise.
     */
    function isCompactBytesArray(
        bytes memory compactBytesArray
    ) internal pure returns (bool) {
        /**
         * Pointer will always land on these values:
         *
         * ↓↓↓↓
         * 0003 a00000
         * 0005 fff83a0011
         * 0020 aa0000000000000000000000000000000000000000000000000000000000cafe
         * 0012 bb000000000000000000000000000000beef
         * 0019 cc00000000000000000000000000000000000000000000deed
         * ↑↑↑↑
         *
         * The pointer can only land on the length of the following bytes value.
         */
        uint256 pointer = 0;

        /**
         * Check each length byte and make sure that when you reach the last length byte.
         * Make sure that the last length describes exactly the last bytes value and you do not get out of bounds.
         */
        while (pointer < compactBytesArray.length) {
            if (pointer + 1 >= compactBytesArray.length) return false;
            uint256 elementLength = uint16(
                bytes2(
                    abi.encodePacked(
                        compactBytesArray[pointer],
                        compactBytesArray[pointer + 1]
                    )
                )
            );
            pointer += elementLength + 2;
        }
        if (pointer == compactBytesArray.length) return true;
        return false;
    }

    /**
     * @dev Validates if the bytes `arrayLength` are exactly 16 bytes long, and are of the exact size of an LSP2 Array length value
     *
     * @param arrayLength Plain bytes that should be validated.
     *
     * @return `true` if the value is 16 bytes long, `false` otherwise.
     */
    function isValidLSP2ArrayLengthValue(
        bytes memory arrayLength
    ) internal pure returns (bool) {
        if (arrayLength.length == 16) {
            return true;
        }
        return false;
    }

    /**
     * @dev Generates Data Key/Value pairs for removing the last element from an LSP2 Array and a mapping Data Key.
     *
     * @param arrayKey The Data Key of Key Type Array.
     * @param newArrayLength The new Array Length for the `arrayKey`.
     * @param removedElementIndexKey The Data Key of Key Type Array Index for the removed element.
     * @param removedElementMapKey The Data Key of a mapping to be removed.
     */
    function removeLastElementFromArrayAndMap(
        bytes32 arrayKey,
        uint128 newArrayLength,
        bytes32 removedElementIndexKey,
        bytes32 removedElementMapKey
    )
        internal
        pure
        returns (bytes32[] memory dataKeys, bytes[] memory dataValues)
    {
        dataKeys = new bytes32[](3);
        dataValues = new bytes[](3);

        // store the number of received assets decremented by 1
        dataKeys[0] = arrayKey;
        dataValues[0] = abi.encodePacked(newArrayLength);

        // remove the data value for the map key of the element
        dataKeys[1] = removedElementMapKey;
        dataValues[1] = "";

        // remove the data value for the map key of the element
        dataKeys[2] = removedElementIndexKey;
        dataValues[2] = "";
    }

    /**
     * @dev Generates Data Key/Value pairs for removing an element from an LSP2 Array and a mapping Data Key.
     *
     * @custom:info The function assumes that the Data Value stored under the mapping Data Key is of length 20 where the last 16 bytes are the index of the element in the array.
     *
     * @param erc725YContract The ERC725Y contract.
     * @param arrayKey The Data Key of Key Type Array.
     * @param newArrayLength The new Array Length for the `arrayKey`.
     * @param removedElementIndexKey The Data Key of Key Type Array Index for the removed element.
     * @param removedElementIndex the index of the removed element.
     * @param removedElementMapKey The Data Key of a mapping to be removed.
     */
    function removeElementFromArrayAndMap(
        IERC725Y erc725YContract,
        bytes32 arrayKey,
        uint128 newArrayLength,
        bytes32 removedElementIndexKey,
        uint128 removedElementIndex,
        bytes32 removedElementMapKey
    )
        internal
        view
        returns (bytes32[] memory dataKeys, bytes[] memory dataValues)
    {
        dataKeys = new bytes32[](5);
        dataValues = new bytes[](5);

        // store the number of received assets decremented by 1
        dataKeys[0] = arrayKey;
        dataValues[0] = abi.encodePacked(newArrayLength);

        // remove the data value for the map key of the element
        dataKeys[1] = removedElementMapKey;
        dataValues[1] = "";

        // Generate the key of the last element in the array
        bytes32 lastElementIndexKey = LSP2Utils.generateArrayElementKeyAtIndex(
            arrayKey,
            newArrayLength
        );

        // Get the data value from the key of the last element in the array
        bytes20 lastElementIndexValue = bytes20(
            erc725YContract.getData(lastElementIndexKey)
        );

        // Set data value of the last element instead of the element from the array that will be removed
        dataKeys[2] = removedElementIndexKey;
        dataValues[2] = bytes.concat(lastElementIndexValue);

        // Remove the data value for the swapped array element
        dataKeys[3] = lastElementIndexKey;
        dataValues[3] = "";

        // Generate mapping key for the swapped array element
        bytes32 lastElementMapKey = LSP2Utils.generateMappingKey(
            bytes10(removedElementMapKey),
            lastElementIndexValue
        );

        // Generate the mapping value for the swapped array element
        bytes memory lastElementMapValue = abi.encodePacked(
            bytes4(erc725YContract.getData(lastElementMapKey)),
            removedElementIndex
        );

        // Update the map value of the swapped array element to the new index
        dataKeys[4] = lastElementMapKey;
        dataValues[4] = lastElementMapValue;
    }
}

// File @lukso/lsp-smart-contracts/contracts/LSP1UniversalReceiver/LSP1Utils.sol@v0.14.0

// Original license: SPDX_License_Identifier: Apache-2.0

// libraries

// constants

// constants

/**
 * @title LSP1 Utility library.
 * @author Jean Cavallera <CJ42>, Yamen Merhi <YamenMerhi>, Daniel Afteni <B00ste>
 * @dev LSP1Utils is a library of utility functions that can be used to notify the `universalReceiver` function of a contract
 * that implements LSP1 and retrieve informations related to LSP1 `typeId`.
 * Based on LSP1 Universal Receiver standard.
 */
library LSP1Utils {
    using ERC165Checker for address;

    /**
     * @dev Notify a contract at `lsp1Implementation` address by calling its `universalReceiver` function if this contract
     * supports the LSP1 interface.
     *
     * @param lsp1Implementation The address of the contract to notify.
     * @param typeId A `bytes32` typeId.
     * @param data Any optional data to send to the `universalReceiver` function to the `lsp1Implementation` address.
     */
    function notifyUniversalReceiver(
        address lsp1Implementation,
        bytes32 typeId,
        bytes memory data
    ) internal {
        if (
            lsp1Implementation.supportsERC165InterfaceUnchecked(
                _INTERFACEID_LSP1
            )
        ) {
            ILSP1UniversalReceiver(lsp1Implementation).universalReceiver(
                typeId,
                data
            );
        }
    }

    /**
     * @notice Retrieving the value stored under the ERC725Y data key `LSP1UniversalReceiverDelegate`.
     *
     * @dev Query internally the ERC725Y storage of a `ERC725Y` smart contract to retrieve
     * the value set under the `LSP1UniversalReceiverDelegate` data key.
     *
     * @param erc725YStorage A reference to the ERC725Y storage mapping of the contract.
     * @return The bytes value stored under the `LSP1UniversalReceiverDelegate` data key.
     */
    function getLSP1DelegateValue(
        mapping(bytes32 => bytes) storage erc725YStorage
    ) internal view returns (bytes memory) {
        return erc725YStorage[_LSP1_UNIVERSAL_RECEIVER_DELEGATE_KEY];
    }

    /**
     * @notice Retrieving the value stored under the ERC725Y data key `LSP1UniversalReceiverDelegate:<type-id>` for a specific `typeId`.
     *
     * @dev Query internally the ERC725Y storage of a `ERC725Y` smart contract to retrieve
     * the value set under the `LSP1UniversalReceiverDelegate:<bytes32>` data key for a specific LSP1 `typeId`.
     *
     * @param erc725YStorage A reference to the ERC725Y storage mapping of the contract.
     * @param typeId A bytes32 LSP1 `typeId`;
     * @return The bytes value stored under the `LSP1UniversalReceiverDelegate:<bytes32>` data key.
     */
    function getLSP1DelegateValueForTypeId(
        mapping(bytes32 => bytes) storage erc725YStorage,
        bytes32 typeId
    ) internal view returns (bytes memory) {
        bytes32 lsp1TypeIdDataKey = LSP2Utils.generateMappingKey(
            _LSP1_UNIVERSAL_RECEIVER_DELEGATE_PREFIX,
            bytes20(typeId)
        );
        return erc725YStorage[lsp1TypeIdDataKey];
    }
}

// File @lukso/lsp-smart-contracts/contracts/LSP4DigitalAssetMetadata/LSP4Constants.sol@v0.14.0

// Original license: SPDX_License_Identifier: Apache-2.0

// Token types
uint256 constant _LSP4_TOKEN_TYPE_TOKEN = 0;
uint256 constant _LSP4_TOKEN_TYPE_NFT = 1;
uint256 constant _LSP4_TOKEN_TYPE_COLLECTION = 2;

// --- ERC725Y entries

// bytes10(keccak256('SupportedStandards')) + bytes2(0) + bytes20(keccak256('LSP4DigitalAsset'))
bytes32 constant _LSP4_SUPPORTED_STANDARDS_KEY = 0xeafec4d89fa9619884b60000a4d96624a38f7ac2d8d9a604ecf07c12c77e480c;

// bytes4(keccak256('LSP4DigitalAsset'))
bytes constant _LSP4_SUPPORTED_STANDARDS_VALUE = hex"a4d96624";

// keccak256('LSP4TokenName')
bytes32 constant _LSP4_TOKEN_NAME_KEY = 0xdeba1e292f8ba88238e10ab3c7f88bd4be4fac56cad5194b6ecceaf653468af1;

// keccak256('LSP4TokenSymbol')
bytes32 constant _LSP4_TOKEN_SYMBOL_KEY = 0x2f0a68ab07768e01943a599e73362a0e17a63a72e94dd2e384d2c1d4db932756;

// keccak256('LSP4TokenType')
bytes32 constant _LSP4_TOKEN_TYPE_KEY = 0xe0261fa95db2eb3b5439bd033cda66d56b96f92f243a8228fd87550ed7bdfdb3;

// keccak256('LSP4Creators[]')
bytes32 constant _LSP4_CREATORS_ARRAY_KEY = 0x114bd03b3a46d48759680d81ebb2b414fda7d030a7105a851867accf1c2352e7;

// bytes10(keccak256('LSP4CreatorsMap'))
bytes10 constant _LSP4_CREATORS_MAP_KEY_PREFIX = 0x6de85eaf5d982b4e5da0;

// keccak256('LSP4Metadata')
bytes32 constant _LSP4_METADATA_KEY = 0x9afb95cacc9f95858ec44aa8c3b685511002e30ae54415823f406128b85b238e;

// File @lukso/lsp-smart-contracts/contracts/LSP4DigitalAssetMetadata/LSP4Errors.sol@v0.14.0

// Original license: SPDX_License_Identifier: Apache-2.0

/**
 * @dev Reverts when trying to edit the data key `LSP4TokenName` after the digital asset contract has been deployed / initialized.
 * The `LSP4TokenName` data key is located inside the ERC725Y data key-value store of the digital asset contract.
 * It can be set only once inside the constructor/initializer when the digital asset contract is being deployed / initialized.
 */
error LSP4TokenNameNotEditable();

/**
 * @dev Reverts when trying to edit the data key `LSP4TokenSymbol` after the digital asset contract has been deployed / initialized.
 * The `LSP4TokenSymbol` data key is located inside the ERC725Y data key-value store of the digital asset contract.
 * It can be set only once inside the constructor/initializer when the digital asset contract is being deployed / initialized.
 */
error LSP4TokenSymbolNotEditable();

/**
 * @dev Reverts when trying to edit the data key `LSP4TokenType` after the digital asset contract has been deployed / initialized.
 * The `LSP4TokenType` data key is located inside the ERC725Y data key-value store of the digital asset contract.
 * It can be set only once inside the constructor / initializer when the digital asset contract is being deployed / initialized.
 */
error LSP4TokenTypeNotEditable();

// File @lukso/lsp-smart-contracts/contracts/LSP4DigitalAssetMetadata/LSP4DigitalAssetMetadataCore.sol@v0.14.0

// Original license: SPDX_License_Identifier: Apache-2.0

// modules

// constants

// errors

/**
 * @title Implementation of a LSP4DigitalAssetMetadata contract that stores the **Token-Metadata** (`LSP4TokenName` and `LSP4TokenSymbol`) in its ERC725Y data store.
 * @author Matthew Stevens
 * @dev Standard Implementation of the LSP4 standard.
 */
abstract contract LSP4DigitalAssetMetadataCore is ERC725YCore {
    /**
     * @dev The ERC725Y data keys `LSP4TokenName` and `LSP4TokenSymbol` cannot be changed
     * via this function once the digital asset contract has been deployed.
     */
    function _setData(
        bytes32 dataKey,
        bytes memory dataValue
    ) internal virtual override {
        if (dataKey == _LSP4_TOKEN_NAME_KEY) {
            revert LSP4TokenNameNotEditable();
        } else if (dataKey == _LSP4_TOKEN_SYMBOL_KEY) {
            revert LSP4TokenSymbolNotEditable();
        } else if (dataKey == _LSP4_TOKEN_TYPE_KEY) {
            revert LSP4TokenTypeNotEditable();
        } else {
            _store[dataKey] = dataValue;

            emit DataChanged(dataKey, dataValue);
        }
    }
}

// File @lukso/lsp-smart-contracts/contracts/LSP4DigitalAssetMetadata/LSP4DigitalAssetMetadata.sol@v0.14.0

// Original license: SPDX_License_Identifier: Apache-2.0

// modules

// constants

/**
 * @title Implementation of a LSP4DigitalAssetMetadata contract that stores the **Token-Metadata** (`LSP4TokenName` and `LSP4TokenSymbol`) in its ERC725Y data store.
 * @author Matthew Stevens
 * @dev Standard Implementation of the LSP4 standard.
 */
abstract contract LSP4DigitalAssetMetadata is
    ERC725Y,
    LSP4DigitalAssetMetadataCore
{
    /**
     * @notice Deploying a digital asset `name_` with the `symbol_` symbol.
     *
     * @param name_ The name of the token.
     * @param symbol_ The symbol of the token.
     * @param initialOwner_ The owner of the token contract.
     * @param lsp4TokenType_ The type of token this digital asset contract represents (`0` = Token, `1` = NFT, `2` = Collection).
     */
    constructor(
        string memory name_,
        string memory symbol_,
        address initialOwner_,
        uint256 lsp4TokenType_
    ) ERC725Y(initialOwner_) {
        // set data key SupportedStandards:LSP4DigitalAsset
        ERC725YCore._setData(
            _LSP4_SUPPORTED_STANDARDS_KEY,
            _LSP4_SUPPORTED_STANDARDS_VALUE
        );

        ERC725YCore._setData(_LSP4_TOKEN_NAME_KEY, bytes(name_));
        ERC725YCore._setData(_LSP4_TOKEN_SYMBOL_KEY, bytes(symbol_));
        ERC725YCore._setData(_LSP4_TOKEN_TYPE_KEY, abi.encode(lsp4TokenType_));
    }

    /**
     * @dev The ERC725Y data keys `LSP4TokenName` and `LSP4TokenSymbol` cannot be changed
     * via this function once the digital asset contract has been deployed.
     */
    function _setData(
        bytes32 dataKey,
        bytes memory dataValue
    ) internal virtual override(ERC725YCore, LSP4DigitalAssetMetadataCore) {
        LSP4DigitalAssetMetadataCore._setData(dataKey, dataValue);
    }
}

// File @lukso/lsp-smart-contracts/contracts/LSP8IdentifiableDigitalAsset/ILSP8IdentifiableDigitalAsset.sol@v0.14.0

// Original license: SPDX_License_Identifier: Apache-2.0

// interfaces

/**
 * @title Interface of the LSP8 - Identifiable Digital Asset standard, a non-fungible digital asset.
 */
interface ILSP8IdentifiableDigitalAsset is IERC165, IERC725Y {
    // --- Events

    /**
     * @dev Emitted when `tokenId` token is transferred from the `from` to the `to` address.
     * @param operator The address of operator that sent the `tokenId`
     * @param from The previous owner of the `tokenId`
     * @param to The new owner of `tokenId`
     * @param tokenId The tokenId that was transferred
     * @param force If the token transfer enforces the `to` recipient address to be a contract that implements the LSP1 standard or not.
     * @param data Any additional data the caller included by the caller during the transfer, and sent in the hooks to the `from` and `to` addresses.
     */
    event Transfer(
        address operator,
        address indexed from,
        address indexed to,
        bytes32 indexed tokenId,
        bool force,
        bytes data
    );

    /**
     * @dev Emitted when `tokenOwner` enables `operator` to transfer or burn the `tokenId`.
     * @param operator The address authorized as an operator.
     * @param tokenOwner The owner of the `tokenId`.
     * @param tokenId The tokenId `operator` address has access on behalf of `tokenOwner`.
     * @param operatorNotificationData The data to notify the operator about via LSP1.
     */
    event OperatorAuthorizationChanged(
        address indexed operator,
        address indexed tokenOwner,
        bytes32 indexed tokenId,
        bytes operatorNotificationData
    );

    /**
     * @dev Emitted when `tokenOwner` disables `operator` to transfer or burn `tokenId` on its behalf.
     * @param operator The address revoked from the operator array ({getOperatorsOf}).
     * @param tokenOwner The owner of the `tokenId`.
     * @param tokenId The tokenId `operator` is revoked from operating on.
     * @param notified Bool indicating whether the operator has been notified or not
     * @param operatorNotificationData The data to notify the operator about via LSP1.
     */
    event OperatorRevoked(
        address indexed operator,
        address indexed tokenOwner,
        bytes32 indexed tokenId,
        bool notified,
        bytes operatorNotificationData
    );

    /**
     * @dev Emitted when setting data for `tokenId`.
     * @param tokenId The tokenId which data is set for.
     * @param dataKey The data key for which a bytes value is set.
     * @param dataValue The value to set for the given data key.
     */
    event TokenIdDataChanged(
        bytes32 indexed tokenId,
        bytes32 indexed dataKey,
        bytes dataValue
    );

    // --- Token queries

    /**
     * @dev Returns the number of existing tokens that have been minted in this contract.
     * @return The number of existing tokens.
     */
    function totalSupply() external view returns (uint256);

    // --- Token owner queries

    /**
     * @dev Get the number of token IDs owned by `tokenOwner`.

     * @param tokenOwner The address to query     *
     * @return The total number of token IDs that `tokenOwner` owns.
     */
    function balanceOf(address tokenOwner) external view returns (uint256);

    /**
     * @dev Returns the list of `tokenIds` for the `tokenOwner` address.
     *
     * @param tokenId tokenOwner The address to query owned tokens
     * @return The owner address of the given `tokenId`.
     *
     * @custom:requirements `tokenId` must exist.
     * @custom:info if the `tokenId` is not owned by any address, the returned address will be `address(0)`
     */
    function tokenOwnerOf(bytes32 tokenId) external view returns (address);

    /**
     * @dev Returns the list of token IDs that the `tokenOwner` address owns.
     * @param tokenOwner The address that we want to get the list of token IDs for.
     * @return An array of `bytes32[] tokenIds` owned by `tokenOwner`.
     */
    function tokenIdsOf(
        address tokenOwner
    ) external view returns (bytes32[] memory);

    // --- TokenId Metadata functionality

    /**
     * @notice Retrieves data for a specific `tokenId` and `dataKey`.
     * @param tokenId The unique identifier for a token.
     * @param dataKey The key for the data to retrieve.
     * @return dataValues The data value associated with the given `tokenId` and `dataKey`.
     */
    function getDataForTokenId(
        bytes32 tokenId,
        bytes32 dataKey
    ) external returns (bytes memory dataValues);

    /**
     * @notice Retrieves data in batch for multiple `tokenId` and `dataKey` pairs.
     * @param tokenIds An array of token IDs.
     * @param dataKeys An array of data keys corresponding to the token IDs.
     * @return dataValues An array of data values for each pair of `tokenId` and `dataKey`.
     */
    function getDataBatchForTokenIds(
        bytes32[] memory tokenIds,
        bytes32[] memory dataKeys
    ) external returns (bytes[] memory dataValues);

    /**
     * @notice Sets data for a specific `tokenId` and `dataKey`.
     * @param tokenId The unique identifier for a token.
     * @param dataKey The key for the data to set.
     * @param dataValue The value to set for the given data key.
     * @custom:events {TokenIdDataChanged} event.
     */
    function setDataForTokenId(
        bytes32 tokenId,
        bytes32 dataKey,
        bytes memory dataValue
    ) external;

    /**
     * @notice Sets data in batch for multiple `tokenId` and `dataKey` pairs.
     * @param tokenIds An array of token IDs.
     * @param dataKeys An array of data keys corresponding to the token IDs.
     * @param dataValues An array of values to set for the given data keys.
     * @custom:events {TokenIdDataChanged} event for each pair.
     */
    function setDataBatchForTokenIds(
        bytes32[] memory tokenIds,
        bytes32[] memory dataKeys,
        bytes[] memory dataValues
    ) external;

    // --- Operator functionality

    /**
     * @dev Allow an `operator` address to transfer or burn a specific `tokenId` on behalf of its token owner. See {isOperatorFor}.
     * Notify the operator based on the LSP1-UniversalReceiver standard
     *
     * @param operator The address to authorize as an operator.
     * @param tokenId The token ID operator has access to.
     * @param operatorNotificationData The data to notify the operator about via LSP1.
     *
     * @custom:requirements
     * - `tokenId` must exist.
     * - caller MUST be the {tokenOwnerOf} `tokenId`.
     * - the owner of a `tokenId` cannot grant itself as an `operator` (`operator` cannot be the calling address).
     * - `operator` cannot be the zero address.
     *
     * @custom:events {OperatorAuthorizationChanged} event.
     */
    function authorizeOperator(
        address operator,
        bytes32 tokenId,
        bytes memory operatorNotificationData
    ) external;

    /**
     * @dev Remove access of `operator` for a given `tokenId`, disallowing it to transfer `tokenId` on behalf of its owner.
     * See also {isOperatorFor}.
     *
     * @param operator The address to revoke as an operator.
     * @param tokenId The tokenId `operator` is revoked from operating on.
     * @param notify Boolean indicating whether to notify the operator or not
     * @param operatorNotificationData The data to notify the operator about via LSP1.
     *
     * @custom:requirements
     * - `tokenId` must exist.
     * - caller must be the {tokenOwnerOf} `tokenId`.
     * - the owner of a `tokenId` cannot grant revoke itself as an `operator` (`operator` cannot be the calling address).
     * - `operator` cannot be the zero address.
     *
     * @custom:events {OperatorRevoked} event with address of the operator being revoked for the caller (token owner)..
     */
    function revokeOperator(
        address operator,
        bytes32 tokenId,
        bool notify,
        bytes memory operatorNotificationData
    ) external;

    /**
     * @dev Returns whether `operator` address is an operator for a given `tokenId`.
     *
     * @param operator The address to query operator status for.
     * @param tokenId The token ID to check if `operator` is allowed to operate on.
     *
     * @return `true` if `operator` is an operator for `tokenId`, `false` otherwise.
     *
     * @custom:requirements
     * - `tokenId` must exist.
     * - caller must be the current {tokenOwnerOf} `tokenId`.
     *
     * @custom:info The tokenOwner is its own operator.
     */
    function isOperatorFor(
        address operator,
        bytes32 tokenId
    ) external view returns (bool);

    /**
     * @dev Returns all `operator` addresses that are allowed to transfer or burn a specific `tokenId` on behalf of its owner.
     *
     * @param tokenId The token ID to get the operators for.
     * @return An array of operators allowed to transfer or burn a specific `tokenId`.
     *
     * Requirements
     * - `tokenId` must exist.
     */
    function getOperatorsOf(
        bytes32 tokenId
    ) external view returns (address[] memory);

    // --- Transfer functionality

    /**
     * @dev Transfer a given `tokenId` token from the `from` address to the `to` address.
     *
     * If operators are set for a specific `tokenId`, all the operators are revoked after the tokenId have been transferred.
     *
     * The `force` parameter MUST be set to `true` when transferring tokens to Externally Owned Accounts (EOAs)
     * or contracts that do not implement the LSP1 standard.
     *
     * @param from The address that owns the given `tokenId`.
     * @param to The address that will receive the `tokenId`.
     * @param tokenId The token ID to transfer.
     * @param force When set to `true`, the `to` address CAN be any addres.
     * When set to `false`, the `to` address MUST be a contract that supports the LSP1 UniversalReceiver standard.
     * @param data Any additional data the caller wants included in the emitted event, and sent in the hooks of the `from` and `to` addresses.
     *
     * @custom:requirements
     * - `from` cannot be the zero address.
     * - `to` cannot be the zero address.
     * - `from` and `to` cannot be the same address (`from` cannot send the `tokenId` to itself).
     * - `from` must own the given `tokenId`.
     * - If the caller is not `from`, it must be an operator for the `tokenId`.
     *
     * @custom:events
     * - {Transfer} event when the `tokenId` is successfully transferred.
     *
     * @custom:hint The `force` parameter **MUST be set to `true`** to transfer tokens to Externally Owned Accounts (EOAs)
     * or contracts that do not implement the LSP1 Universal Receiver Standard. Otherwise the function will revert making the transfer fail.
     *
     * @custom:info if the `to` address is a contract that implements LSP1, it will always be notified via its `universalReceiver(...)` function, regardless if `force` is set to `true` or `false`.
     *
     * @custom:warning Be aware that when either the sender or the recipient can have logic that revert in their `universalReceiver(...)` function when being notified.
     * This even if the `force` was set to `true`.
     */
    function transfer(
        address from,
        address to,
        bytes32 tokenId,
        bool force,
        bytes memory data
    ) external;

    /**
     * @dev Transfers multiple tokens at once based on the arrays of `from`, `to` and `tokenId`.
     * If any transfer fails, the whole call will revert.
     *
     * @param from An array of sending addresses.
     * @param to An array of recipient addresses.
     * @param tokenId An array of token IDs to transfer.
     * @param force When set to `true`, `to` may be any address.
     * When set to `false`, `to` must be a contract that supports the LSP1 standard and not revert.
     * @param data Any additional data the caller wants included in the emitted event, and sent in the hooks to the `from` and `to` addresses.
     *
     *
     * @custom:requirements
     * - The arrays of `from`, `to` and `tokenId` must have the same length.
     * - no values in the `from` array can be the zero address.
     * - no values in the `to` array can be the zero address.
     * - `from` and `to` cannot be the same address at the same index on each arrays.
     * - each `tokenId` must be owned by `from`.
     * - If the caller is not `from`, it must be an operator of each `tokenId`.
     *
     * @custom:events
     * - {Transfer} events on each successful token transfer.
     */
    function transferBatch(
        address[] memory from,
        address[] memory to,
        bytes32[] memory tokenId,
        bool[] memory force,
        bytes[] memory data
    ) external;

    /**
     * @notice Executing the following batch of abi-encoded function calls on the contract: `data`.
     *
     * @dev Allows a caller to batch different function calls in one call. Perform a `delegatecall` on self, to call different functions with preserving the context.
     * @param data An array of ABI encoded function calls to be called on the contract.
     * @return results An array of abi-encoded data returned by the functions executed.
     */
    function batchCalls(
        bytes[] calldata data
    ) external returns (bytes[] memory results);
}

// File @lukso/lsp-smart-contracts/contracts/LSP8IdentifiableDigitalAsset/LSP8Constants.sol@v0.14.0

// Original license: SPDX_License_Identifier: Apache-2.0

// --- ERC165 interface ids
bytes4 constant _INTERFACEID_LSP8 = 0x3a271706;

// --- ERC725Y Data Keys

// keccak256('LSP8TokenIdFormat')
bytes32 constant _LSP8_TOKENID_FORMAT_KEY = 0xf675e9361af1c1664c1868cfa3eb97672d6b1a513aa5b81dec34c9ee330e818d;

// keccak256('LSP8TokenMetadataBaseURI')
bytes32 constant _LSP8_TOKEN_METADATA_BASE_URI = 0x1a7628600c3bac7101f53697f48df381ddc36b9015e7d7c9c5633d1252aa2843;

// keccak256('LSP8ReferenceContract')
bytes32 constant _LSP8_REFERENCE_CONTRACT = 0x708e7b881795f2e6b6c2752108c177ec89248458de3bf69d0d43480b3e5034e6;

// --- Token Hooks

// keccak256('LSP8Tokens_SenderNotification')
bytes32 constant _TYPEID_LSP8_TOKENSSENDER = 0xb23eae7e6d1564b295b4c3e3be402d9a2f0776c57bdf365903496f6fa481ab00;

// keccak256('LSP8Tokens_RecipientNotification')
bytes32 constant _TYPEID_LSP8_TOKENSRECIPIENT = 0x0b084a55ebf70fd3c06fd755269dac2212c4d3f0f4d09079780bfa50c1b2984d;

// keccak256('LSP8Tokens_OperatorNotification')
bytes32 constant _TYPEID_LSP8_TOKENOPERATOR = 0x8a1c15a8799f71b547e08e2bcb2e85257e81b0a07eee2ce6712549eef1f00970;

// --- Token IDs Format

uint256 constant _LSP8_TOKENID_FORMAT_NUMBER = 0;
uint256 constant _LSP8_TOKENID_FORMAT_STRING = 1;
uint256 constant _LSP8_TOKENID_FORMAT_ADDRESS = 2;
uint256 constant _LSP8_TOKENID_FORMAT_UNIQUE_ID = 3;
uint256 constant _LSP8_TOKENID_FORMAT_HASH = 4;

uint256 constant _LSP8_TOKENID_FORMAT_MIXED_DEFAULT_NUMBER = 100;
uint256 constant _LSP8_TOKENID_FORMAT_MIXED_DEFAULT_STRING = 101;
uint256 constant _LSP8_TOKENID_FORMAT_MIXED_DEFAULT_ADDRESS = 102;
uint256 constant _LSP8_TOKENID_FORMAT_MIXED_DEFAULT_UNIQUE_ID = 103;
uint256 constant _LSP8_TOKENID_FORMAT_MIXED_DEFAULT_HASH = 104;

// File @lukso/lsp-smart-contracts/contracts/LSP8IdentifiableDigitalAsset/LSP8Errors.sol@v0.14.0

// Original license: SPDX_License_Identifier: Apache-2.0

// --- Errors

/**
 * @dev Reverts when `tokenId` has not been minted.
 */
error LSP8NonExistentTokenId(bytes32 tokenId);

/**
 * @dev Reverts when `caller` is not the `tokenOwner` of the `tokenId`.
 */
error LSP8NotTokenOwner(address tokenOwner, bytes32 tokenId, address caller);

/**
 * @dev Reverts when `caller` is not an allowed operator for `tokenId`.
 */
error LSP8NotTokenOperator(bytes32 tokenId, address caller);

/**
 * @dev Reverts when `operator` is already authorized for the `tokenId`.
 */
error LSP8OperatorAlreadyAuthorized(address operator, bytes32 tokenId);

/**
 * @dev Reverts when trying to set the zero address as an operator.
 */
error LSP8CannotUseAddressZeroAsOperator();

/**
 * @dev Reverts when trying to send token to the zero address.
 */
error LSP8CannotSendToAddressZero();

/**
 * @dev Reverts when specifying the same address for `from` and `to` in a token transfer.
 */
error LSP8CannotSendToSelf();

/**
 * @dev Reverts when `operator` is not an operator for the `tokenId`.
 */
error LSP8NonExistingOperator(address operator, bytes32 tokenId);

/**
 * @dev Reverts when `tokenId` has already been minted.
 */
error LSP8TokenIdAlreadyMinted(bytes32 tokenId);

/**
 * @dev Reverts when the parameters used for `transferBatch` have different lengths.
 */
error LSP8InvalidTransferBatch();

/**
 * @dev Reverts if the `tokenReceiver` does not implement LSP1
 * when minting or transferring tokens with `bool force` set as `false`.
 */
error LSP8NotifyTokenReceiverContractMissingLSP1Interface(
    address tokenReceiver
);

/**
 * @dev Reverts if the `tokenReceiver` is an EOA
 * when minting or transferring tokens with `bool force` set as `false`.
 */
error LSP8NotifyTokenReceiverIsEOA(address tokenReceiver);

/**
 * @dev Reverts when trying to authorize or revoke the token's owner as an operator.
 */
error LSP8TokenOwnerCannotBeOperator();

/**
 * @dev Error occurs when sending native tokens to the LSP8 contract without sending any data.
 *
 * E.g. Sending value without passing a bytes4 function selector to call a LSP17 Extension.
 *
 * @notice LSP8 contract cannot receive native tokens.
 */
error LSP8TokenContractCannotHoldValue();

/**
 * @dev Reverts when trying to edit the data key `LSP8TokenIdFormat` after the identifiable digital asset contract has been deployed.
 * The `LSP8TokenIdFormat` data key is located inside the ERC725Y Data key-value store of the identifiable digital asset contract.
 * It can be set only once inside the constructor/initializer when the identifiable digital asset contract is being deployed.
 */
error LSP8TokenIdFormatNotEditable();

/**
 * @dev Reverts when the length of the token IDs data arrays is not equal
 */
error LSP8TokenIdsDataLengthMismatch();

/**
 * @dev Reverts when empty arrays is passed to the function
 */
error LSP8TokenIdsDataEmptyArray();

/**
 * @dev Reverts when a batch call failed.
 * @notice Batch call failed.
 */
error LSP8BatchCallFailed(uint256 callIndex);

// File @openzeppelin/contracts/utils/structs/EnumerableSet.sol@v4.9.5

// Original license: SPDX_License_Identifier: MIT
// OpenZeppelin Contracts (last updated v4.9.0) (utils/structs/EnumerableSet.sol)
// This file was procedurally generated from scripts/generate/templates/EnumerableSet.js.

/**
 * @dev Library for managing
 * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
 * types.
 *
 * Sets have the following properties:
 *
 * - Elements are added, removed, and checked for existence in constant time
 * (O(1)).
 * - Elements are enumerated in O(n). No guarantees are made on the ordering.
 *
 * ```solidity
 * contract Example {
 *     // Add the library methods
 *     using EnumerableSet for EnumerableSet.AddressSet;
 *
 *     // Declare a set state variable
 *     EnumerableSet.AddressSet private mySet;
 * }
 * ```
 *
 * As of v3.3.0, sets of type `bytes32` (`Bytes32Set`), `address` (`AddressSet`)
 * and `uint256` (`UintSet`) are supported.
 *
 * [WARNING]
 * ====
 * Trying to delete such a structure from storage will likely result in data corruption, rendering the structure
 * unusable.
 * See https://github.com/ethereum/solidity/pull/11843[ethereum/solidity#11843] for more info.
 *
 * In order to clean an EnumerableSet, you can either remove all elements one by one or create a fresh instance using an
 * array of EnumerableSet.
 * ====
 */
library EnumerableSet {
    // To implement this library for multiple types with as little code
    // repetition as possible, we write it in terms of a generic Set type with
    // bytes32 values.
    // The Set implementation uses private functions, and user-facing
    // implementations (such as AddressSet) are just wrappers around the
    // underlying Set.
    // This means that we can only create new EnumerableSets for types that fit
    // in bytes32.

    struct Set {
        // Storage of set values
        bytes32[] _values;
        // Position of the value in the `values` array, plus 1 because index 0
        // means a value is not in the set.
        mapping(bytes32 => uint256) _indexes;
    }

    /**
     * @dev Add a value to a set. O(1).
     *
     * Returns true if the value was added to the set, that is if it was not
     * already present.
     */
    function _add(Set storage set, bytes32 value) private returns (bool) {
        if (!_contains(set, value)) {
            set._values.push(value);
            // The value is stored at length-1, but we add 1 to all indexes
            // and use 0 as a sentinel value
            set._indexes[value] = set._values.length;
            return true;
        } else {
            return false;
        }
    }

    /**
     * @dev Removes a value from a set. O(1).
     *
     * Returns true if the value was removed from the set, that is if it was
     * present.
     */
    function _remove(Set storage set, bytes32 value) private returns (bool) {
        // We read and store the value's index to prevent multiple reads from the same storage slot
        uint256 valueIndex = set._indexes[value];

        if (valueIndex != 0) {
            // Equivalent to contains(set, value)
            // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
            // the array, and then remove the last element (sometimes called as 'swap and pop').
            // This modifies the order of the array, as noted in {at}.

            uint256 toDeleteIndex = valueIndex - 1;
            uint256 lastIndex = set._values.length - 1;

            if (lastIndex != toDeleteIndex) {
                bytes32 lastValue = set._values[lastIndex];

                // Move the last value to the index where the value to delete is
                set._values[toDeleteIndex] = lastValue;
                // Update the index for the moved value
                set._indexes[lastValue] = valueIndex; // Replace lastValue's index to valueIndex
            }

            // Delete the slot where the moved value was stored
            set._values.pop();

            // Delete the index for the deleted slot
            delete set._indexes[value];

            return true;
        } else {
            return false;
        }
    }

    /**
     * @dev Returns true if the value is in the set. O(1).
     */
    function _contains(
        Set storage set,
        bytes32 value
    ) private view returns (bool) {
        return set._indexes[value] != 0;
    }

    /**
     * @dev Returns the number of values on the set. O(1).
     */
    function _length(Set storage set) private view returns (uint256) {
        return set._values.length;
    }

    /**
     * @dev Returns the value stored at position `index` in the set. O(1).
     *
     * Note that there are no guarantees on the ordering of values inside the
     * array, and it may change when more values are added or removed.
     *
     * Requirements:
     *
     * - `index` must be strictly less than {length}.
     */
    function _at(
        Set storage set,
        uint256 index
    ) private view returns (bytes32) {
        return set._values[index];
    }

    /**
     * @dev Return the entire set in an array
     *
     * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
     * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
     * this function has an unbounded cost, and using it as part of a state-changing function may render the function
     * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
     */
    function _values(Set storage set) private view returns (bytes32[] memory) {
        return set._values;
    }

    // Bytes32Set

    struct Bytes32Set {
        Set _inner;
    }

    /**
     * @dev Add a value to a set. O(1).
     *
     * Returns true if the value was added to the set, that is if it was not
     * already present.
     */
    function add(
        Bytes32Set storage set,
        bytes32 value
    ) internal returns (bool) {
        return _add(set._inner, value);
    }

    /**
     * @dev Removes a value from a set. O(1).
     *
     * Returns true if the value was removed from the set, that is if it was
     * present.
     */
    function remove(
        Bytes32Set storage set,
        bytes32 value
    ) internal returns (bool) {
        return _remove(set._inner, value);
    }

    /**
     * @dev Returns true if the value is in the set. O(1).
     */
    function contains(
        Bytes32Set storage set,
        bytes32 value
    ) internal view returns (bool) {
        return _contains(set._inner, value);
    }

    /**
     * @dev Returns the number of values in the set. O(1).
     */
    function length(Bytes32Set storage set) internal view returns (uint256) {
        return _length(set._inner);
    }

    /**
     * @dev Returns the value stored at position `index` in the set. O(1).
     *
     * Note that there are no guarantees on the ordering of values inside the
     * array, and it may change when more values are added or removed.
     *
     * Requirements:
     *
     * - `index` must be strictly less than {length}.
     */
    function at(
        Bytes32Set storage set,
        uint256 index
    ) internal view returns (bytes32) {
        return _at(set._inner, index);
    }

    /**
     * @dev Return the entire set in an array
     *
     * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
     * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
     * this function has an unbounded cost, and using it as part of a state-changing function may render the function
     * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
     */
    function values(
        Bytes32Set storage set
    ) internal view returns (bytes32[] memory) {
        bytes32[] memory store = _values(set._inner);
        bytes32[] memory result;

        /// @solidity memory-safe-assembly
        assembly {
            result := store
        }

        return result;
    }

    // AddressSet

    struct AddressSet {
        Set _inner;
    }

    /**
     * @dev Add a value to a set. O(1).
     *
     * Returns true if the value was added to the set, that is if it was not
     * already present.
     */
    function add(
        AddressSet storage set,
        address value
    ) internal returns (bool) {
        return _add(set._inner, bytes32(uint256(uint160(value))));
    }

    /**
     * @dev Removes a value from a set. O(1).
     *
     * Returns true if the value was removed from the set, that is if it was
     * present.
     */
    function remove(
        AddressSet storage set,
        address value
    ) internal returns (bool) {
        return _remove(set._inner, bytes32(uint256(uint160(value))));
    }

    /**
     * @dev Returns true if the value is in the set. O(1).
     */
    function contains(
        AddressSet storage set,
        address value
    ) internal view returns (bool) {
        return _contains(set._inner, bytes32(uint256(uint160(value))));
    }

    /**
     * @dev Returns the number of values in the set. O(1).
     */
    function length(AddressSet storage set) internal view returns (uint256) {
        return _length(set._inner);
    }

    /**
     * @dev Returns the value stored at position `index` in the set. O(1).
     *
     * Note that there are no guarantees on the ordering of values inside the
     * array, and it may change when more values are added or removed.
     *
     * Requirements:
     *
     * - `index` must be strictly less than {length}.
     */
    function at(
        AddressSet storage set,
        uint256 index
    ) internal view returns (address) {
        return address(uint160(uint256(_at(set._inner, index))));
    }

    /**
     * @dev Return the entire set in an array
     *
     * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
     * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
     * this function has an unbounded cost, and using it as part of a state-changing function may render the function
     * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
     */
    function values(
        AddressSet storage set
    ) internal view returns (address[] memory) {
        bytes32[] memory store = _values(set._inner);
        address[] memory result;

        /// @solidity memory-safe-assembly
        assembly {
            result := store
        }

        return result;
    }

    // UintSet

    struct UintSet {
        Set _inner;
    }

    /**
     * @dev Add a value to a set. O(1).
     *
     * Returns true if the value was added to the set, that is if it was not
     * already present.
     */
    function add(UintSet storage set, uint256 value) internal returns (bool) {
        return _add(set._inner, bytes32(value));
    }

    /**
     * @dev Removes a value from a set. O(1).
     *
     * Returns true if the value was removed from the set, that is if it was
     * present.
     */
    function remove(
        UintSet storage set,
        uint256 value
    ) internal returns (bool) {
        return _remove(set._inner, bytes32(value));
    }

    /**
     * @dev Returns true if the value is in the set. O(1).
     */
    function contains(
        UintSet storage set,
        uint256 value
    ) internal view returns (bool) {
        return _contains(set._inner, bytes32(value));
    }

    /**
     * @dev Returns the number of values in the set. O(1).
     */
    function length(UintSet storage set) internal view returns (uint256) {
        return _length(set._inner);
    }

    /**
     * @dev Returns the value stored at position `index` in the set. O(1).
     *
     * Note that there are no guarantees on the ordering of values inside the
     * array, and it may change when more values are added or removed.
     *
     * Requirements:
     *
     * - `index` must be strictly less than {length}.
     */
    function at(
        UintSet storage set,
        uint256 index
    ) internal view returns (uint256) {
        return uint256(_at(set._inner, index));
    }

    /**
     * @dev Return the entire set in an array
     *
     * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
     * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
     * this function has an unbounded cost, and using it as part of a state-changing function may render the function
     * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
     */
    function values(
        UintSet storage set
    ) internal view returns (uint256[] memory) {
        bytes32[] memory store = _values(set._inner);
        uint256[] memory result;

        /// @solidity memory-safe-assembly
        assembly {
            result := store
        }

        return result;
    }
}

// File @lukso/lsp-smart-contracts/contracts/LSP8IdentifiableDigitalAsset/LSP8IdentifiableDigitalAssetCore.sol@v0.14.0

// Original license: SPDX_License_Identifier: Apache-2.0

// interfaces

// modules

// libraries

// errors

// constants

/**
 * @title LSP8IdentifiableDigitalAsset contract
 * @author Matthew Stevens
 * @dev Core Implementation of a LSP8 compliant contract.
 */
abstract contract LSP8IdentifiableDigitalAssetCore is
    LSP4DigitalAssetMetadataCore,
    ILSP8IdentifiableDigitalAsset
{
    using EnumerableSet for EnumerableSet.AddressSet;
    using EnumerableSet for EnumerableSet.Bytes32Set;

    // --- Storage

    uint256 internal _existingTokens;

    // Mapping from `tokenId` to `tokenOwner`
    mapping(bytes32 => address) internal _tokenOwners;

    // Mapping `tokenOwner` to owned tokenIds
    mapping(address => EnumerableSet.Bytes32Set) internal _ownedTokens;

    // Mapping a `tokenId` to its authorized operator addresses.
    mapping(bytes32 => EnumerableSet.AddressSet) internal _operators;

    mapping(address => EnumerableSet.Bytes32Set) internal _tokenIdsForOperator;

    // --- Token queries

    /**
     * @inheritdoc ILSP8IdentifiableDigitalAsset
     */
    function totalSupply() public view virtual override returns (uint256) {
        return _existingTokens;
    }

    // --- Token owner queries

    /**
     * @inheritdoc ILSP8IdentifiableDigitalAsset
     */
    function balanceOf(
        address tokenOwner
    ) public view virtual override returns (uint256) {
        return _ownedTokens[tokenOwner].length();
    }

    /**
     * @inheritdoc ILSP8IdentifiableDigitalAsset
     */
    function tokenOwnerOf(
        bytes32 tokenId
    ) public view virtual override returns (address) {
        address tokenOwner = _tokenOwners[tokenId];

        if (tokenOwner == address(0)) {
            revert LSP8NonExistentTokenId(tokenId);
        }

        return tokenOwner;
    }

    /**
     * @inheritdoc ILSP8IdentifiableDigitalAsset
     */
    function tokenIdsOf(
        address tokenOwner
    ) public view virtual override returns (bytes32[] memory) {
        return _ownedTokens[tokenOwner].values();
    }

    // --- TokenId Metadata functionality

    /**
     * @inheritdoc ILSP8IdentifiableDigitalAsset
     */
    function getDataForTokenId(
        bytes32 tokenId,
        bytes32 dataKey
    ) public view virtual override returns (bytes memory dataValue) {
        return _getDataForTokenId(tokenId, dataKey);
    }

    /**
     * @inheritdoc ILSP8IdentifiableDigitalAsset
     */
    function getDataBatchForTokenIds(
        bytes32[] memory tokenIds,
        bytes32[] memory dataKeys
    ) public view virtual override returns (bytes[] memory dataValues) {
        dataValues = new bytes[](tokenIds.length);

        for (uint256 i; i < tokenIds.length; ) {
            dataValues[i] = _getDataForTokenId(tokenIds[i], dataKeys[i]);

            // Increment the iterator in unchecked block to save gas
            unchecked {
                ++i;
            }
        }

        return dataValues;
    }

    /**
     * @inheritdoc ILSP8IdentifiableDigitalAsset
     */
    function setDataForTokenId(
        bytes32 tokenId,
        bytes32 dataKey,
        bytes memory dataValue
    ) public virtual override onlyOwner {
        _setDataForTokenId(tokenId, dataKey, dataValue);
    }

    /**
     * @inheritdoc ILSP8IdentifiableDigitalAsset
     */
    function setDataBatchForTokenIds(
        bytes32[] memory tokenIds,
        bytes32[] memory dataKeys,
        bytes[] memory dataValues
    ) public virtual override onlyOwner {
        if (
            tokenIds.length != dataKeys.length ||
            dataKeys.length != dataValues.length
        ) {
            revert LSP8TokenIdsDataLengthMismatch();
        }

        if (tokenIds.length == 0) {
            revert LSP8TokenIdsDataEmptyArray();
        }

        for (uint256 i; i < tokenIds.length; ) {
            _setDataForTokenId(tokenIds[i], dataKeys[i], dataValues[i]);

            // Increment the iterator in unchecked block to save gas
            unchecked {
                ++i;
            }
        }
    }

    // --- General functionality

    /**
     * @inheritdoc ILSP8IdentifiableDigitalAsset
     *
     * @custom:info It's not possible to send value along the functions call due to the use of `delegatecall`.
     */
    function batchCalls(
        bytes[] calldata data
    ) public virtual override returns (bytes[] memory results) {
        results = new bytes[](data.length);
        for (uint256 i; i < data.length; ) {
            (bool success, bytes memory result) = address(this).delegatecall(
                data[i]
            );

            if (!success) {
                // Look for revert reason and bubble it up if present
                if (result.length != 0) {
                    // The easiest way to bubble the revert reason is using memory via assembly
                    // solhint-disable no-inline-assembly
                    /// @solidity memory-safe-assembly
                    assembly {
                        let returndata_size := mload(result)
                        revert(add(32, result), returndata_size)
                    }
                } else {
                    revert LSP8BatchCallFailed({callIndex: i});
                }
            }

            results[i] = result;

            unchecked {
                ++i;
            }
        }
    }

    // --- Operator functionality

    /**
     * @inheritdoc ILSP8IdentifiableDigitalAsset
     */
    function authorizeOperator(
        address operator,
        bytes32 tokenId,
        bytes memory operatorNotificationData
    ) public virtual override {
        address tokenOwner = tokenOwnerOf(tokenId);

        if (tokenOwner != msg.sender) {
            revert LSP8NotTokenOwner(tokenOwner, tokenId, msg.sender);
        }

        if (operator == address(0)) {
            revert LSP8CannotUseAddressZeroAsOperator();
        }

        if (tokenOwner == operator) {
            revert LSP8TokenOwnerCannotBeOperator();
        }

        bool isAdded = _operators[tokenId].add(operator);
        if (!isAdded) revert LSP8OperatorAlreadyAuthorized(operator, tokenId);

        emit OperatorAuthorizationChanged(
            operator,
            tokenOwner,
            tokenId,
            operatorNotificationData
        );

        bytes memory lsp1Data = abi.encode(
            msg.sender,
            tokenId,
            true, // authorized
            operatorNotificationData
        );

        _notifyTokenOperator(operator, lsp1Data);
    }

    /**
     * @inheritdoc ILSP8IdentifiableDigitalAsset
     */
    function revokeOperator(
        address operator,
        bytes32 tokenId,
        bool notify,
        bytes memory operatorNotificationData
    ) public virtual override {
        address tokenOwner = tokenOwnerOf(tokenId);

        if (tokenOwner != msg.sender) {
            revert LSP8NotTokenOwner(tokenOwner, tokenId, msg.sender);
        }

        if (operator == address(0)) {
            revert LSP8CannotUseAddressZeroAsOperator();
        }

        if (tokenOwner == operator) {
            revert LSP8TokenOwnerCannotBeOperator();
        }

        _revokeOperator(
            operator,
            tokenOwner,
            tokenId,
            notify,
            operatorNotificationData
        );

        if (notify) {
            bytes memory lsp1Data = abi.encode(
                msg.sender,
                tokenId,
                false, // unauthorized
                operatorNotificationData
            );

            _notifyTokenOperator(operator, lsp1Data);
        }
    }

    /**
     * @inheritdoc ILSP8IdentifiableDigitalAsset
     */
    function isOperatorFor(
        address operator,
        bytes32 tokenId
    ) public view virtual override returns (bool) {
        _existsOrError(tokenId);

        return _isOperatorOrOwner(operator, tokenId);
    }

    /**
     * @inheritdoc ILSP8IdentifiableDigitalAsset
     */
    function getOperatorsOf(
        bytes32 tokenId
    ) public view virtual override returns (address[] memory) {
        _existsOrError(tokenId);

        return _operators[tokenId].values();
    }

    /**
     * @dev verifies if the `caller` is operator or owner for the `tokenId`
     * @return true if `caller` is either operator or owner
     */
    function _isOperatorOrOwner(
        address caller,
        bytes32 tokenId
    ) internal view virtual returns (bool) {
        return (caller == tokenOwnerOf(tokenId) ||
            _operators[tokenId].contains(caller));
    }

    // --- Transfer functionality

    /**
     * @inheritdoc ILSP8IdentifiableDigitalAsset
     */
    function transfer(
        address from,
        address to,
        bytes32 tokenId,
        bool force,
        bytes memory data
    ) public virtual override {
        if (!_isOperatorOrOwner(msg.sender, tokenId)) {
            revert LSP8NotTokenOperator(tokenId, msg.sender);
        }

        _transfer(from, to, tokenId, force, data);
    }

    /**
     * @inheritdoc ILSP8IdentifiableDigitalAsset
     */
    function transferBatch(
        address[] memory from,
        address[] memory to,
        bytes32[] memory tokenId,
        bool[] memory force,
        bytes[] memory data
    ) public virtual override {
        uint256 fromLength = from.length;
        if (
            fromLength != to.length ||
            fromLength != tokenId.length ||
            fromLength != force.length ||
            fromLength != data.length
        ) {
            revert LSP8InvalidTransferBatch();
        }

        for (uint256 i; i < fromLength; ) {
            transfer(from[i], to[i], tokenId[i], force[i], data[i]);

            unchecked {
                ++i;
            }
        }
    }

    /**
     * @dev removes `operator` from the list of operators for the `tokenId`
     */
    function _revokeOperator(
        address operator,
        address tokenOwner,
        bytes32 tokenId,
        bool notified,
        bytes memory operatorNotificationData
    ) internal virtual {
        bool isRemoved = _operators[tokenId].remove(operator);
        if (!isRemoved) revert LSP8NonExistingOperator(operator, tokenId);

        emit OperatorRevoked(
            operator,
            tokenOwner,
            tokenId,
            notified,
            operatorNotificationData
        );
    }

    /**
     * @dev revoke all the current operators for a specific `tokenId` token which belongs to `tokenOwner`.
     *
     * @param tokenOwner The address that is the owner of the `tokenId`.
     * @param tokenId The token to remove the associated operators for.
     */
    function _clearOperators(
        address tokenOwner,
        bytes32 tokenId
    ) internal virtual {
        // here is a good example of why having multiple operators will be expensive.. we
        // need to clear them on token transfer
        //
        // NOTE: this may cause a tx to fail if there is too many operators to clear, in which case
        // the tokenOwner needs to call `revokeOperator` until there is less operators to clear and
        // the desired `transfer` or `burn` call can succeed.
        EnumerableSet.AddressSet storage operatorsForTokenId = _operators[
            tokenId
        ];

        uint256 operatorListLength = operatorsForTokenId.length();
        address operator;
        for (uint256 i; i < operatorListLength; ) {
            // we are emptying the list, always remove from index 0
            operator = operatorsForTokenId.at(0);
            _revokeOperator(operator, tokenOwner, tokenId, false, "");

            unchecked {
                ++i;
            }
        }
    }

    /**
     * @dev Returns whether `tokenId` exists.
     *
     * Tokens start existing when they are minted ({_mint}), and stop existing when they are burned ({_burn}).
     */
    function _exists(bytes32 tokenId) internal view virtual returns (bool) {
        return _tokenOwners[tokenId] != address(0);
    }

    /**
     * @dev When `tokenId` does not exist then revert with an error.
     */
    function _existsOrError(bytes32 tokenId) internal view virtual {
        if (!_exists(tokenId)) {
            revert LSP8NonExistentTokenId(tokenId);
        }
    }

    /**
     * @dev Create `tokenId` by minting it and transfers it to `to`.
     *
     * @custom:info Any logic in the:
     * - {_beforeTokenTransfer} function will run before updating the balances and ownership of `tokenId`s.
     * - {_afterTokenTransfer} function will run after updating the balances and ownership of `tokenId`s, **but before notifying the recipient via LSP1**.
     *
     * @param to The address that will receive the minted `tokenId`.
     * @param tokenId The token ID to create (= mint).
     * @param force When set to `true`, `to` may be any address. When set to `false`, `to` must be a contract that supports the LSP1 standard.
     * @param data Any additional data the caller wants included in the emitted event, and sent in the hook of the `to` address.
     *
     * @custom:requirements
     * - `tokenId` must not exist and not have been already minted.
     * - `to` cannot be the zero address.

     * @custom:events {Transfer} event with `address(0)` as `from` address.
     */
    function _mint(
        address to,
        bytes32 tokenId,
        bool force,
        bytes memory data
    ) internal virtual {
        if (to == address(0)) {
            revert LSP8CannotSendToAddressZero();
        }

        _beforeTokenTransfer(address(0), to, tokenId, data);

        // Check that `tokenId` was not minted inside the `_beforeTokenTransfer` hook
        if (_exists(tokenId)) {
            revert LSP8TokenIdAlreadyMinted(tokenId);
        }

        // token being minted
        ++_existingTokens;

        _ownedTokens[to].add(tokenId);
        _tokenOwners[tokenId] = to;

        emit Transfer(msg.sender, address(0), to, tokenId, force, data);

        _afterTokenTransfer(address(0), to, tokenId, data);

        bytes memory lsp1Data = abi.encode(
            msg.sender,
            address(0),
            to,
            tokenId,
            data
        );
        _notifyTokenReceiver(to, force, lsp1Data);
    }

    /**
     * @dev Burn a specific `tokenId`, removing the `tokenId` from the {tokenIdsOf} the caller and decreasing its {balanceOf} by -1.
     * This will also clear all the operators allowed to transfer the `tokenId`.
     *
     * The owner of the `tokenId` will be notified about the `tokenId` being transferred through its LSP1 {universalReceiver}
     * function, if it is a contract that supports the LSP1 interface. Its {universalReceiver} function will receive
     * all the parameters in the calldata packed encoded.
     *
     * @custom:info Any logic in the:
     * - {_beforeTokenTransfer} function will run before updating the balances and ownership of `tokenId`s.
     * - {_afterTokenTransfer} function will run after updating the balances and ownership of `tokenId`s, **but before notifying the sender via LSP1**.
     *
     * @param tokenId The token to burn.
     * @param data Any additional data the caller wants included in the emitted event, and sent in the LSP1 hook on the token owner's address.
     *
     * @custom:hint In dApps, you can know which addresses are burning tokens by listening for the `Transfer` event and filter with the zero address as `to`.
     *
     * @custom:requirements
     * - `tokenId` must exist.
     *
     * @custom:events {Transfer} event with `address(0)` as the `to` address.
     */
    function _burn(bytes32 tokenId, bytes memory data) internal virtual {
        address tokenOwner = tokenOwnerOf(tokenId);

        _beforeTokenTransfer(tokenOwner, address(0), tokenId, data);

        // Re-fetch and update `tokenOwner` in case `tokenId`
        // was transferred inside the `_beforeTokenTransfer` hook
        tokenOwner = tokenOwnerOf(tokenId);

        // token being burned
        --_existingTokens;

        _clearOperators(tokenOwner, tokenId);

        _ownedTokens[tokenOwner].remove(tokenId);
        delete _tokenOwners[tokenId];

        emit Transfer(msg.sender, tokenOwner, address(0), tokenId, false, data);

        _afterTokenTransfer(tokenOwner, address(0), tokenId, data);

        bytes memory lsp1Data = abi.encode(
            msg.sender,
            tokenOwner,
            address(0),
            tokenId,
            data
        );

        _notifyTokenSender(tokenOwner, lsp1Data);
    }

    /**
     * @dev Change the owner of the `tokenId` from `from` to `to`.
     *
     * Both the sender and recipient will be notified of the `tokenId` being transferred through their LSP1 {universalReceiver}
     * function, if they are contracts that support the LSP1 interface. Their `universalReceiver` function will receive
     * all the parameters in the calldata packed encoded.
     *
     * @custom:info Any logic in the:
     * - {_beforeTokenTransfer} function will run before updating the balances and ownership of `tokenId`s.
     * - {_afterTokenTransfer} function will run after updating the balances and ownership of `tokenId`s, **but before notifying the sender/recipient via LSP1**.
     *
     * @param from The sender address.
     * @param to The recipient address.
     * @param tokenId The token to transfer.
     * @param force When set to `true`, `to` may be any address. When set to `false`, `to` must be a contract that supports the LSP1 standard.
     * @param data Additional data the caller wants included in the emitted event, and sent in the hooks to `from` and `to` addresses.
     *
     * @custom:requirements
     * - `to` cannot be the zero address.
     * - `tokenId` token must be owned by `from`.
     *
     * @custom:events {Transfer} event.
     *
     * @custom:danger This internal function does not check if the sender is authorized or not to operate on the `tokenId`.
     */
    function _transfer(
        address from,
        address to,
        bytes32 tokenId,
        bool force,
        bytes memory data
    ) internal virtual {
        if (from == to) {
            revert LSP8CannotSendToSelf();
        }

        address tokenOwner = tokenOwnerOf(tokenId);
        if (tokenOwner != from) {
            revert LSP8NotTokenOwner(tokenOwner, tokenId, from);
        }

        if (to == address(0)) {
            revert LSP8CannotSendToAddressZero();
        }

        _beforeTokenTransfer(from, to, tokenId, data);

        // Re-fetch and update `tokenOwner` in case `tokenId`
        // was transferred inside the `_beforeTokenTransfer` hook
        tokenOwner = tokenOwnerOf(tokenId);

        _clearOperators(from, tokenId);

        _ownedTokens[from].remove(tokenId);
        _ownedTokens[to].add(tokenId);
        _tokenOwners[tokenId] = to;

        emit Transfer(msg.sender, from, to, tokenId, force, data);

        _afterTokenTransfer(from, to, tokenId, data);

        bytes memory lsp1Data = abi.encode(msg.sender, from, to, tokenId, data);

        _notifyTokenSender(from, lsp1Data);
        _notifyTokenReceiver(to, force, lsp1Data);
    }

    /**
     * @dev Sets data for a specific `tokenId` and `dataKey` in the ERC725Y storage
     * The ERC725Y data key is the hash of the `tokenId` and `dataKey` concatenated
     * @param tokenId The unique identifier for a token.
     * @param dataKey The key for the data to set.
     * @param dataValue The value to set for the given data key.
     * @custom:events {TokenIdDataChanged} event.
     */
    function _setDataForTokenId(
        bytes32 tokenId,
        bytes32 dataKey,
        bytes memory dataValue
    ) internal virtual {
        _store[keccak256(bytes.concat(tokenId, dataKey))] = dataValue;
        emit TokenIdDataChanged(tokenId, dataKey, dataValue);
    }

    /**
     * @dev Retrieves data for a specific `tokenId` and `dataKey` from the ERC725Y storage
     * The ERC725Y data key is the hash of the `tokenId` and `dataKey` concatenated
     * @param tokenId The unique identifier for a token.
     * @param dataKey The key for the data to retrieve.
     * @return dataValues The data value associated with the given `tokenId` and `dataKey`.
     */
    function _getDataForTokenId(
        bytes32 tokenId,
        bytes32 dataKey
    ) internal view virtual returns (bytes memory dataValues) {
        return _store[keccak256(bytes.concat(tokenId, dataKey))];
    }

    /**
     * @dev Hook that is called before any token transfer, including minting and burning.
     * Allows to run custom logic before updating balances and notifiying sender/recipient by overriding this function.
     *
     * @param from The sender address
     * @param to The recipient address
     * @param tokenId The tokenId to transfer
     * @param data The data sent alongside the transfer
     */
    function _beforeTokenTransfer(
        address from,
        address to,
        bytes32 tokenId,
        bytes memory data // solhint-disable-next-line no-empty-blocks
    ) internal virtual {}

    /**
     * @dev Hook that is called after any token transfer, including minting and burning.
     * Allows to run custom logic after updating balances, but **before notifiying sender/recipient via LSP1** by overriding this function.
     *
     * @param from The sender address
     * @param to The recipient address
     * @param tokenId The tokenId to transfer
     * @param data The data sent alongside the transfer
     */
    function _afterTokenTransfer(
        address from,
        address to,
        bytes32 tokenId,
        bytes memory data // solhint-disable-next-line no-empty-blocks
    ) internal virtual {}

    /**
     * @dev Attempt to notify the operator `operator` about the `tokenId` being authorized.
     * This is done by calling its {universalReceiver} function with the `_TYPEID_LSP8_TOKENOPERATOR` as typeId, if `operator` is a contract that supports the LSP1 interface.
     * If `operator` is an EOA or a contract that does not support the LSP1 interface, nothing will happen and no notification will be sent.
     
     * @param operator The address to call the {universalReceiver} function on.                                                                                                                                                                                   
     * @param lsp1Data the data to be sent to the `operator` address in the `universalReceiver` call.
     */
    function _notifyTokenOperator(
        address operator,
        bytes memory lsp1Data
    ) internal virtual {
        LSP1Utils.notifyUniversalReceiver(
            operator,
            _TYPEID_LSP8_TOKENOPERATOR,
            lsp1Data
        );
    }

    /**
     * @dev Attempt to notify the token sender `from` about the `tokenId` being transferred.
     * This is done by calling its {universalReceiver} function with the `_TYPEID_LSP8_TOKENSSENDER` as typeId, if `from` is a contract that supports the LSP1 interface.
     * If `from` is an EOA or a contract that does not support the LSP1 interface, nothing will happen and no notification will be sent.
     
     * @param from The address to call the {universalReceiver} function on.                                                                                                                                                                                   
     * @param lsp1Data the data to be sent to the `from` address in the `universalReceiver` call.
     */
    function _notifyTokenSender(
        address from,
        bytes memory lsp1Data
    ) internal virtual {
        LSP1Utils.notifyUniversalReceiver(
            from,
            _TYPEID_LSP8_TOKENSSENDER,
            lsp1Data
        );
    }

    /**
     * @dev Attempt to notify the token receiver `to` about the `tokenId` being received.
     * This is done by calling its {universalReceiver} function with the `_TYPEID_LSP8_TOKENSRECIPIENT` as typeId, if `to` is a contract that supports the LSP1 interface.
     *
     * If `to` is is an EOA or a contract that does not support the LSP1 interface, the behaviour will depend on the `force` boolean flag.
     * - if `force` is set to `true`, nothing will happen and no notification will be sent.
     * - if `force` is set to `false, the transaction will revert.
     *
     * @param to The address to call the {universalReceiver} function on.
     * @param force A boolean that describe if transfer to a `to` address that does not support LSP1 is allowed or not.
     * @param lsp1Data The data to be sent to the `to` address in the `universalReceiver(...)` call.
     */
    function _notifyTokenReceiver(
        address to,
        bool force,
        bytes memory lsp1Data
    ) internal virtual {
        if (
            ERC165Checker.supportsERC165InterfaceUnchecked(
                to,
                _INTERFACEID_LSP1
            )
        ) {
            ILSP1UniversalReceiver(to).universalReceiver(
                _TYPEID_LSP8_TOKENSRECIPIENT,
                lsp1Data
            );
        } else if (!force) {
            if (to.code.length != 0) {
                revert LSP8NotifyTokenReceiverContractMissingLSP1Interface(to);
            } else {
                revert LSP8NotifyTokenReceiverIsEOA(to);
            }
        }
    }
}

// File @lukso/lsp-smart-contracts/contracts/LSP8IdentifiableDigitalAsset/LSP8IdentifiableDigitalAsset.sol@v0.14.0

// Original license: SPDX_License_Identifier: Apache-2.0

// interfaces

// modules

// libraries

// constants

// errors

// errors

/**
 * @title Implementation of a LSP8 Identifiable Digital Asset, a contract that represents a non-fungible token.
 * @author Matthew Stevens
 *
 * @dev Standard implementation contract of the LSP8 standard.
 *
 * Minting and transferring are done by providing a unique `tokenId`.
 * This implementation is agnostic to the way tokens are created.
 * A supply mechanism has to be added in a derived contract using {_mint}
 * For a generic mechanism, see {LSP7Mintable}.
 */
abstract contract LSP8IdentifiableDigitalAsset is
    LSP4DigitalAssetMetadata,
    LSP8IdentifiableDigitalAssetCore,
    LSP17Extendable
{
    /**
     * @notice Deploying a LSP8IdentifiableDigitalAsset with name `name_`, symbol `symbol_`, owned by address `newOwner_`
     * with tokenId format `lsp8TokenIdFormat_`.
     *
     * @dev Deploy a `LSP8IdentifiableDigitalAsset` contract and set the tokenId format inside the ERC725Y storage of the contract.
     * This will also set the token `name_` and `symbol_` under the ERC725Y data keys `LSP4TokenName` and `LSP4TokenSymbol`.
     *
     * @param name_ The name of the token
     * @param symbol_ The symbol of the token
     * @param newOwner_ The owner of the the token-Metadata
     * @param lsp4TokenType_ The type of token this digital asset contract represents (`0` = Token, `1` = NFT, `2` = Collection).
     * @param lsp8TokenIdFormat_ The format of tokenIds (= NFTs) that this contract will create.
     *
     * @custom:warning Make sure the tokenId format provided on deployment is correct, as it can only be set once
     * and cannot be changed in the ERC725Y storage after the contract has been deployed.
     */
    constructor(
        string memory name_,
        string memory symbol_,
        address newOwner_,
        uint256 lsp4TokenType_,
        uint256 lsp8TokenIdFormat_
    ) LSP4DigitalAssetMetadata(name_, symbol_, newOwner_, lsp4TokenType_) {
        LSP4DigitalAssetMetadata._setData(
            _LSP8_TOKENID_FORMAT_KEY,
            abi.encode(lsp8TokenIdFormat_)
        );
    }

    // fallback function

    /**
     * @notice The `fallback` function was called with the following amount of native tokens: `msg.value`; and the following calldata: `callData`.
     *
     * @dev Achieves the goal of [LSP-17-ContractExtension] standard by extending the contract to handle calls of functions that do not exist natively,
     * forwarding the function call to the extension address mapped to the function being called.
     *
     * This function is executed when:
     *    - Sending data of length less than 4 bytes to the contract.
     *    - The first 4 bytes of the calldata do not match any publicly callable functions from the contract ABI.
     *    - Receiving native tokens
     *
     * 1. If the data is equal or longer than 4 bytes, the [ERC-725Y] storage is queried with the following data key: [_LSP17_EXTENSION_PREFIX] + `bytes4(msg.sig)` (Check [LSP-2-ERC725YJSONSchema] for encoding the data key)
     *
     *   - If there is no address stored under the following data key, revert with {NoExtensionFoundForFunctionSelector(bytes4)}. The data key relative to `bytes4(0)` is an exception, where no reverts occurs if there is no extension address stored under. This exception is made to allow users to send random data (graffiti) to the account and to be able to react on it.
     *
     *   - If there is an address, forward the `msg.data` to the extension using the CALL opcode, appending 52 bytes (20 bytes of `msg.sender` and 32 bytes of `msg.value`). Return what the calls returns, or revert if the call failed.
     *
     * 2. If the data sent to this function is of length less than 4 bytes (not a function selector), revert.
     */
    // solhint-disable-next-line no-complex-fallback
    fallback(
        bytes calldata callData
    ) external payable virtual returns (bytes memory) {
        if (msg.data.length < 4) {
            revert InvalidFunctionSelector(callData);
        }
        return _fallbackLSP17Extendable(callData);
    }

    /**
     * @dev Reverts whenever someone tries to send native tokens to a LSP8 contract.
     * @notice LSP8 contract cannot receive native tokens.
     */
    receive() external payable virtual {
        // revert on empty calls with no value
        if (msg.value == 0) {
            revert InvalidFunctionSelector(hex"00000000");
        }

        revert LSP8TokenContractCannotHoldValue();
    }

    /**
     * @dev Forwards the call with the received value to an extension mapped to a function selector.
     *
     * Calls {_getExtensionAndForwardValue} to get the address of the extension mapped to the function selector being
     * called on the account. If there is no extension, the address(0) will be returned.
     * We will always forward the value to the extension, as the LSP8 contract is not supposed to hold any native tokens.
     *
     * Reverts if there is no extension for the function being called.
     *
     * If there is an extension for the function selector being called, it calls the extension with the
     * CALL opcode, passing the {msg.data} appended with the 20 bytes of the {msg.sender} and
     * 32 bytes of the {msg.value}
     *
     * @custom:info The LSP8 Token contract should not hold any native tokens. Any native tokens received by the contract
     * will be forwarded to the extension address mapped to the selector from `msg.sig`.
     */
    function _fallbackLSP17Extendable(
        bytes calldata callData
    ) internal virtual override returns (bytes memory) {
        // If there is a function selector
        (address extension, ) = _getExtensionAndForwardValue(msg.sig);

        // if no extension was found, revert
        if (extension == address(0))
            revert NoExtensionFoundForFunctionSelector(msg.sig);

        (bool success, bytes memory result) = extension.call{value: msg.value}(
            abi.encodePacked(callData, msg.sender, msg.value)
        );

        if (success) {
            return result;
        } else {
            // `mload(result)` -> offset in memory where `result.length` is located
            // `add(result, 32)` -> offset in memory where `result` data starts
            // solhint-disable no-inline-assembly
            /// @solidity memory-safe-assembly
            assembly {
                let resultdata_size := mload(result)
                revert(add(result, 32), resultdata_size)
            }
        }
    }

    /**
     * @dev Returns the extension address stored under the following data key:
     * - {_LSP17_EXTENSION_PREFIX} + `<bytes4>` (Check [LSP2-ERC725YJSONSchema] for encoding the data key).
     * - If no extension is stored, returns the address(0).
     */
    function _getExtensionAndForwardValue(
        bytes4 functionSelector
    ) internal view virtual override returns (address, bool) {
        // Generate the data key relevant for the functionSelector being called
        bytes32 mappedExtensionDataKey = LSP2Utils.generateMappingKey(
            _LSP17_EXTENSION_PREFIX,
            functionSelector
        );

        // Check if there is an extension stored under the generated data key
        bytes memory extensionAddress = ERC725YCore._getData(
            mappedExtensionDataKey
        );
        if (extensionAddress.length != 20 && extensionAddress.length != 0)
            revert InvalidExtensionAddress(extensionAddress);

        return (address(bytes20(extensionAddress)), true);
    }

    /**
     * @inheritdoc IERC165
     */
    function supportsInterface(
        bytes4 interfaceId
    )
        public
        view
        virtual
        override(IERC165, ERC725YCore, LSP17Extendable)
        returns (bool)
    {
        return
            interfaceId == _INTERFACEID_LSP8 ||
            super.supportsInterface(interfaceId) ||
            LSP17Extendable._supportsInterfaceInERC165Extension(interfaceId);
    }

    /**
     * @inheritdoc LSP4DigitalAssetMetadata
     * @dev The ERC725Y data key `_LSP8_TOKENID_FORMAT_KEY` cannot be changed
     * once the identifiable digital asset contract has been deployed.
     */
    function _setData(
        bytes32 dataKey,
        bytes memory dataValue
    )
        internal
        virtual
        override(LSP4DigitalAssetMetadata, LSP4DigitalAssetMetadataCore)
    {
        if (dataKey == _LSP8_TOKENID_FORMAT_KEY) {
            revert LSP8TokenIdFormatNotEditable();
        }
        LSP4DigitalAssetMetadata._setData(dataKey, dataValue);
    }
}

// File @lukso/lsp-smart-contracts/contracts/LSP0ERC725Account/LSP0Constants.sol@v0.14.0

// Original license: SPDX_License_Identifier: Apache-2.0

// --- ERC165 interface ids
bytes4 constant _INTERFACEID_LSP0 = 0x24871b3d;
bytes4 constant _INTERFACEID_ERC1271 = 0x1626ba7e;

// ERC1271 - Standard Signature Validation
bytes4 constant _ERC1271_SUCCESSVALUE = 0x1626ba7e;
bytes4 constant _ERC1271_FAILVALUE = 0xffffffff;

// --- Native Token Type Id

// keccak256('LSP0ValueReceived')
bytes32 constant _TYPEID_LSP0_VALUE_RECEIVED = 0x9c4705229491d365fb5434052e12a386d6771d976bea61070a8c694e8affea3d;

// Ownership Transfer Type IDs

// keccak256('LSP0OwnershipTransferStarted')
bytes32 constant _TYPEID_LSP0_OwnershipTransferStarted = 0xe17117c9d2665d1dbeb479ed8058bbebde3c50ac50e2e65619f60006caac6926;

// keccak256('LSP0OwnershipTransferred_SenderNotification')
bytes32 constant _TYPEID_LSP0_OwnershipTransferred_SenderNotification = 0xa4e59c931d14f7c8a7a35027f92ee40b5f2886b9fdcdb78f30bc5ecce5a2f814;

// keccak256('LSP0OwnershipTransferred_RecipientNotification')
bytes32 constant _TYPEID_LSP0_OwnershipTransferred_RecipientNotification = 0xceca317f109c43507871523e82dc2a3cc64dfa18f12da0b6db14f6e23f995538;

// File contracts/POAP/MyLUKSOPoap.sol

// Original license: SPDX_License_Identifier: Apache-2.0

// modules

// libraries

// constants

function generateKeccak256Utf8VerifiableURI(
    bytes32 verificationDataHash,
    string memory uri
) pure returns (bytes memory) {
    return
        abi.encodePacked(
            // verifiableURI identifier
            bytes2(0x0000),
            // verification method ID.
            // first 4 bytes of the keccak256 hash of the string "keccak256(utf8)"
            bytes4(0x6f357c6a),
            // verification data length
            bytes2(0x0020),
            // verification data
            verificationDataHash,
            // encoded URI
            uri
        );
}

contract MyLUKSOPoap is
    LSP8IdentifiableDigitalAsset(
        "My LUKSO POAP",
        "LYXPOAP",
        msg.sender, // deployer of the contract is the owner
        _LSP4_TOKEN_TYPE_NFT, // each token on the contract represent an NFT
        _LSP8_TOKENID_FORMAT_UNIQUE_ID // each tokenId will be represented by the address of the user that claimed the POAP
    )
{
    // using {generateArrayElementKeyAtIndex} for bytes32;
    using LSP2Utils for *;

    /// @notice Replace the address below with your UP address here to define yourself as the creator.
    /// @dev For people who do not have a UP, simply leave this address for demo purpose (it is my UP address).
    address constant WORKSHOP_CREATOR =
        0x38382B0437453004AC1af86839249037b130417B;

    constructor(
        bytes32 verificationDataHash,
        string memory poapMetadataIPFSURI
    ) {
        bytes memory poapVerifiableURI = generateKeccak256Utf8VerifiableURI(
            verificationDataHash,
            poapMetadataIPFSURI
        );

        _setData(_LSP4_METADATA_KEY, poapVerifiableURI);

        // There is only one creator: yourself!

        // Set the LSP4 Creator Array length to 1
        _setData(
            _LSP4_CREATORS_ARRAY_KEY,
            abi.encodePacked(bytes16(uint128(1)))
        );

        // Set your UP address under the LSP4_CREATORS[] at index 0
        bytes32 lsp4CreatorArrayAtIndex = _LSP4_CREATORS_ARRAY_KEY
            .generateArrayElementKeyAtIndex(0);

        _setData(lsp4CreatorArrayAtIndex, abi.encodePacked(WORKSHOP_CREATOR));

        bytes32 lsp4CreatorMapKey = _LSP4_CREATORS_MAP_KEY_PREFIX
            .generateMappingKey(bytes20(WORKSHOP_CREATOR));

        _setData(
            lsp4CreatorMapKey,
            abi.encodePacked(_INTERFACEID_LSP0, uint128(0))
        );
    }

    function claim() external {
        bytes32 tokenId = keccak256(abi.encode(msg.sender));
        _mint(msg.sender, tokenId, true, "");
    }

    function _transfer(
        address /* from */,
        address /* to */,
        bytes32 /* tokenId */,
        bool /* force */,
        bytes memory /* data */
    ) internal pure override {
        revert("LUKSO POAP is non-transferrable");
    }
}
