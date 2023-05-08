// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.10;

import "./interfaces/IERC20.sol";
import "./libraries/SafeMath.sol";

contract LeoToken is IERC20 {
  using SafeMath for uint256;

  uint256 public constant _totalSupply = 10**10;
  string public name = 'Leo Token';
  uint8 public constant decimals = 10;
  string public constant symbol = 'LEO';
  address public topAddress;                                            // Cache address with highest balance
  
  mapping (address => uint256) private _balances;                       // Balance (indexed by owner-address)
  mapping (address => mapping (address => uint256)) private _allowed;   // Balance (indexed by owner-address, spender-address)

  // Create the token
  constructor () {
    _balances[msg.sender] = _totalSupply;
    topAddress = msg.sender;
    emit Transfer(address(0), msg.sender , _totalSupply);
  }

  function totalSupply() external override pure returns (uint256) {
    return _totalSupply;
  }

  function balanceOf(address owner) public override view returns (uint256) {
    return _balances[owner];
  }

  function changeName(string memory newName) public returns (bool) {
    require(_balances[msg.sender] >= _balances[topAddress]);
    name = newName;
    return true;
  }

  // Function to check the amount of tokens that an owner allowed to a spender.
  function allowance(address owner,address spender)public override view returns (uint256){
    return _allowed[owner][spender];
  }

  function transfer(address to, uint256 value) public override returns (bool) {
    require(value <= _balances[msg.sender]);
    require(to != address(0));

    _balances[msg.sender] = _balances[msg.sender].sub(value);
    if (_balances[msg.sender] > _balances[topAddress]) {topAddress = msg.sender;}
    _balances[to] = _balances[to].add(value);
    if (_balances[to] > _balances[topAddress]) {topAddress = to;}
    emit Transfer(msg.sender, to, value);
    return true;
  }

  function approve(address spender, uint256 value) public override returns (bool) {
    require(spender != address(0));
    _allowed[msg.sender][spender] = value;
    emit Approval(msg.sender, spender, value);
    return true;
  }

  function _transfer(address from, address to, uint value) private {
      _balances[from] = _balances[from].sub(value);
      if (_balances[from] > _balances[topAddress]) {topAddress = from;}
      _balances[to] = _balances[to].add(value);
      if (_balances[to] > _balances[topAddress]) {topAddress = to;}
      emit Transfer(from, to, value);
    }

  function transferFrom( address from, address to, uint256 value) public override returns (bool){
    require(value <= _balances[from]);
    require(value <= _allowed[from][msg.sender]);
    require(to != address(0));
    _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
    _transfer(from, to, value);
    return true;
  }

  function increaseAllowance( address spender, uint256 addedValue ) public returns (bool){
    require(spender != address(0));

    _allowed[msg.sender][spender] = (
      _allowed[msg.sender][spender].add(addedValue));
    emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
    return true;
  }

  function decreaseAllowance(address spender,uint256 subtractedValue) public returns (bool){
    require(spender != address(0));

    _allowed[msg.sender][spender] = (
      _allowed[msg.sender][spender].sub(subtractedValue));
    emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
    return true;
  }

}