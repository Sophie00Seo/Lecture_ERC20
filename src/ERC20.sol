// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract ERC20{

    // state variables
    mapping(address => uint256) private balances;
    mapping(address => mapping(address => uint256)) private allowances;
    uint256 private _totalSupply;

    string private _name;
    string private _symbol;
    uint8 private _decimals;

    // view functions
    function name() public view returns (string memory){
        return _name;
    }

    function symbol() public view returns (string memory){
        return _symbol;
    }

    function decimals() public view returns (uint8){
        return _decimals;
    }

    function totalSupply() public view returns (uint256){
        return _totalSupply;
    }

    function balanceOf(address _owner) public view returns (uint256){
        return balances[_owner];
    }

    // Event: To Find Internal Transaction easily
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);

    // constructor
    constructor(){
        _name = "DREAM";
        _symbol = "DRM";
        _decimals = 18;
        balances[msg.sender] = 100 ether;
        _totalSupply = 100 ether;
    }

    function transfer(address _to, uint256 _value) external returns (bool success){
        require(_to != address(0), "transfer to zero address"); // Internal Transfer -> if _to zero address, same as burn
        require(balances[msg.sender] >= _value, "value exceeds balance");

        unchecked {
            balances[msg.sender] -= _value;
            balances[_to] += _value;
        }

        emit Transfer(msg.sender, _to, _value);
        // return true;
    }

    function approve(address _spender, uint256 _value) public returns (bool success){
        require(_spender != address(0), "approve to the zero address");

        allowances[msg.sender][_spender] = _value;
        emit Approval(msg.sender, _spender, _value);
    }

    function allowance(address _owner, address _spender) public view returns (uint256 remaining){
        return allowances[_owner][_spender];
    }

    function transferFrom(address _from, address _to, uint256 _value) external returns (bool success){
        require(_from != address(0), "transfer from zero address");
        require(_to != address(0), "transfer to zero address");
        require(allowances[_from][_to] >= _value, "value exceeds allowance");
        require(balances[_from] >= _value, "value exceeds balance");

        unchecked {
            balances[_from] -= _value;
            balances[_to] += _value;
            allowances[_from][_to] -= _value;
        }

        emit Transfer(_from, _to, _value);
    }

    function _mint(address _owner, uint256 _value) internal {
        require(_owner != address(0), "mint to zero address");
        balances[_owner] += _value;
        _totalSupply += _value;
    }
    function _burn(address _owner, uint256 _value) internal {
        require(_owner != address(0), "burn from zero address");
        balances[_owner] -= _value;
        _totalSupply -= _value;
    }
}