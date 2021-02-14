// File: contracts/coffeeaccesscontrol/Roles.sol

pragma solidity >=0.4.21 <0.7.0;

/**
 * @title Roles
 * @dev Library for managing addresses assigned to a Role.
 */
library Roles {
  struct Role {
    mapping (address => bool) bearer;
  }

  /**
   * @dev give an account access to this role
   */
  function add(Role storage role, address account) internal {
    require(account != address(0));
    require(!has(role, account));

    role.bearer[account] = true;
  }

  /**
   * @dev remove an account's access to this role
   */
  function remove(Role storage role, address account) internal {
    require(account != address(0));
    require(has(role, account));

    role.bearer[account] = false;
  }

  /**
   * @dev check if an account has this role
   * @return bool
   */
  function has(Role storage role, address account)
    internal
    view
    returns (bool)
  {
    require(account != address(0));
    return role.bearer[account];
  }
}

// File: contracts/coffeeaccesscontrol/ConsumerRole.sol

pragma solidity >=0.4.21 <0.7.0;

// Import the library 'Roles'


// Define a contract 'ConsumerRole' to manage this role - add, remove, check
contract ConsumerRole {
  using Roles for Roles.Role;

  // Define 2 events, one for Adding, and other for Removing
  event ConsumerAdded(address indexed account);
  event ConsumerRemoved(address indexed account);

  // Define a struct 'consumers' by inheriting from 'Roles' library, struct Role
  Roles.Role private consumers;

  // In the constructor make the address that deploys this contract the 1st consumer
  constructor() public {
    _addConsumer(msg.sender);
  }

  // Define a modifier that checks to see if msg.sender has the appropriate role
  modifier onlyConsumer() {
    require(isConsumer(msg.sender));
    _;
  }

  // Define a function 'isConsumer' to check this role
  function isConsumer(address account) public view returns (bool) {
    return consumers.has(account);
  }

  // Define a function 'addConsumer' that adds this role
  function addConsumer(address account) public onlyConsumer {
    _addConsumer(account);
  }

  // Define a function 'renounceConsumer' to renounce this role
  function renounceConsumer() public {
    _removeConsumer(msg.sender);
  }

  // Define an internal function '_addConsumer' to add this role, called by 'addConsumer'
  function _addConsumer(address account) internal {
    consumers.add(account);
    emit ConsumerAdded(account);
  }

  // Define an internal function '_removeConsumer' to remove this role, called by 'removeConsumer'
  function _removeConsumer(address account) internal {
    consumers.remove(account);
    emit ConsumerRemoved(account);
  }
}
