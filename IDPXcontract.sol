// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";

contract IDPXTokencontract is Ownable {

  // Detalhes do Token
  string public name = "IDPXToken";
  string public symbol = "IDPX";
  uint8 public decimals = 4;
  uint256 private _totalSupply = 1000000;

  // Mapiando
  mapping(address => uint256) private _balances;
  mapping(address => mapping(address => uint256)) private _allowed;
  mapping(address => bool) public _blacklist;

  // Eventos
  event Transfer(address indexed from, address indexed to, uint256 value);
  event Approval(address indexed owner, address indexed spender, uint256 value);
  event BlacklistUpdated(address indexed user, bool isBlacklisted);

  // Construção
  constructor() Ownable(msg.sender) {
    _balances[msg.sender] = _totalSupply;
    emit Transfer(address(0), msg.sender, _totalSupply);
  }

  // Funções
  function mint(address to, uint256 amount) public onlyOwner {
    _totalSupply += amount;
    _balances[to] += amount;
    emit Transfer(address(0), to, amount);
  }

  function burn(uint256 amount) public {
    require(_balances[msg.sender] >= amount, "Insufficient balance");
    _totalSupply -= amount;
    _balances[msg.sender] -= amount;
    emit Transfer(msg.sender, address(0), amount);
  }

  function totalSupply() public view returns (uint256) {
    return _totalSupply - _balances[address(0)];
  }

  function balanceOf(address owner) public view returns (uint256 balance) {
    return _balances[owner];
  }

  function allowance(address owner, address spender) public view returns (uint256 remaining) {
    return _allowed[owner][spender];
  }

  function approve(address spender, uint256 value) public returns (bool success) {
    _allowed[msg.sender][spender] = value;
    emit Approval(msg.sender, spender, value);
    return true;
  }

  function transfer(address to, uint256 value) public returns (bool success) {
    require(_balances[msg.sender] >= value, "value exceeds senders balance");
    require(!_blacklist[to], "Recipient is blacklisted");

    _balances[msg.sender] -= value;
    _balances[to] += value;
    emit Transfer(msg.sender, to, value);
    return true;
  }

  function transferFrom(
    address from,
    address to,
    uint256 value
  ) public returns (bool success) {
    require(value <= _balances[from], "Not enough balance");
    require(value <= _allowed[from][msg.sender], "Not enough allowance");
    require(!_blacklist[to], "Recipient is blacklisted");

    _balances[from] -= value;
    _balances[to] += value;
    _allowed[from][msg.sender] -= value;
    emit Transfer(from, to, value);
    return true;
  }

  function addToBlacklist(address user) public onlyOwner {
    require(!_blacklist[user], "User already blacklisted");
    _blacklist[user] = true;
    emit BlacklistUpdated(user, true);
  }

  function removeFromBlacklist(address user) public onlyOwner {
    require(_blacklist[user], "User not blacklisted");
    _blacklist[user] = false;
    emit BlacklistUpdated(user, false);
  }

}
