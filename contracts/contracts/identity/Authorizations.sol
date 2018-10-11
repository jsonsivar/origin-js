pragma solidity ^0.4.24;

contract Authorizations {

    // target contract => calling address => function => permission yes/no
    // TODO: maybe there is a better way to do this
    mapping(address => mapping(address => mapping(bytes4 => bool))) authorizations;

    // TODO: do we want to support allowing all functions? (maybe another mapping that gets checked before checking function specific perms)

    // TODO: constructor should add the msg.sender to have permissions to call AddAuthorization

    function AddAuthorization(
        address _targetAddress,
        address _caller,
        bytes4 _functionSelector,
        bool _permission
    ) public 
    isAuthorized(this)
    returns(bool _result){
        authorizations[_targetAddress][_caller][_functionSelector] = _permission;
        _result = _permission;
        return _result;
    }

    modifier isAuthorizedForFunction(address _targetAddress, bytes4 _functionSelector) {
        require(authorizations[_targetAddress][msg.sender][_functionSelector], "Does not have permissions");
        _;
    }

    modifier isAuthorized(address _targetAddress) {
        require(authorizations[_targetAddress][msg.sender][bytes4(1)], "Does not have permissions");
        _;
    }

}