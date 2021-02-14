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

// File: contracts/coffeeaccesscontrol/FarmerRole.sol

pragma solidity >=0.4.21 <0.7.0;

// Import the library 'Roles'


// Define a contract 'FarmerRole' to manage this role - add, remove, check
contract FarmerRole {
  using Roles for Roles.Role;

  // Define 2 events, one for Adding, and other for Removing
  event FarmerAdded(address indexed account);
  event FarmerRemoved(address indexed account);

  // Define a struct 'farmers' by inheriting from 'Roles' library, struct Role
  Roles.Role private farmers;

  // In the constructor make the address that deploys this contract the 1st farmer
  constructor() public {
    _addFarmer(msg.sender);
  }

  // Define a modifier that checks to see if msg.sender has the appropriate role
  modifier onlyFarmer() {
    require(isFarmer(msg.sender));
    _;
  }

  // Define a function 'isFarmer' to check this role
  function isFarmer(address account) public view returns (bool) {
    return farmers.has(account);
  }

  // Define a function 'addFarmer' that adds this role
  function addFarmer(address account) public onlyFarmer {
    _addFarmer(account);
  }

  // Define a function 'renounceFarmer' to renounce this role
  function renounceFarmer() public {
    _removeFarmer(msg.sender);
  }

  // Define an internal function '_addFarmer' to add this role, called by 'addFarmer'
  function _addFarmer(address account) internal {
    farmers.add(account);
    emit FarmerAdded(account);
  }

  // Define an internal function '_removeFarmer' to remove this role, called by 'removeFarmer'
  function _removeFarmer(address account) internal {
    farmers.remove(account);
    emit FarmerRemoved(account);
  }
}
