// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

contract IDPXTokencontract {

    // Detalhes do Token
    address public owner;
    string public name = "IDPXToken";
    string public symbol = "IDPX";
    uint8 public decimals = 4;
    uint256 private _totalSupply = 1000000;

    // Mapiando
    mapping (address => uint256) _balances;
    mapping (address => mapping(address => uint256)) _allowed;

    // Eventos
    event Transfer(address indexed _from, address indexed _to, uint256 _value);
    event Approval(address indexed _owner, address indexed _spender, uint256 _value);

    // Construção
    constructor(){
        owner = msg.sender;
        _balances[msg.sender] = _totalSupply;
        emit Transfer(address(0), msg.sender, _totalSupply);
    }

    // Funções
    function mint(address to, uint256 amount) private  {
        require(msg.sender == owner, "Only owner can mint tokens");
        _totalSupply += amount;
        _balances[to] += amount;
        emit Transfer(address(0), to, amount);
    }

    function burn(uint256 amount) private {
        require(_balances[msg.sender] >= amount, "Insufficient balance");
        _totalSupply -= amount;
        _balances[msg.sender] -= amount;
        emit Transfer(msg.sender, address(0), amount);
    }

    function totalSupply() public view returns (uint) {
        return _totalSupply - _balances[address(0)];
    }

    function balanceOf(address _owner) public view returns (uint balance) {
        return _balances[_owner];
    }

    function allowance(address _owner, address _spender) public view returns (uint remaining) {
        return _allowed[_owner][_spender];
    }

    function transfer(address _to, uint256 _value) public returns (bool success) {
        require(_balances[msg.sender] >= _value,"value exceeds senders balance");
        _balances[msg.sender] -= _value;
        _balances[_to] += _value;
        emit Transfer(msg.sender, _to, _value);
        return true;
    }

    function approve(address _spender, uint256 _value) public returns (bool success) {
        _allowed[msg.sender][_spender] = _value;
        emit Approval(msg.sender, _spender, _value);
        return true;
    }

    function transferfrom(address _from, address _to, uint256 _value) public returns (bool success) {
        require(_value <= _balances[_from],"Not enough balance");
        require(_value <= _allowed[_from][msg.sender],"Not enough allowance");
        _balances[_from] -= _value;
        _balances[_to] += _value;
        _allowed[_from][msg.sender] -= _value;
        emit Transfer(_from, _to, _value);
        return true;
    }
}