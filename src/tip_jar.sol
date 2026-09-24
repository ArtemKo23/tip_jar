// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/access/Ownable.sol";

contract TipJar is Ownable {
    mapping(address => uint256) private _totalTipped;
    uint256 private _totalReceived;

    event Tipped(address indexed from, uint256 amount, uint256 newTotal);

    constructor() Ownable(msg.sender) {}

    function deposit() external payable {
        require(msg.value > 0, "TipJar: zero deposit");
        _totalTipped[msg.sender] += msg.value;
        _totalReceived += msg.value;
        emit Tipped(msg.sender, msg.value, _totalTipped[msg.sender]);
    }

    function totalTipped(address account) external view returns (uint256) {
        return _totalTipped[account];
    }

    function totalReceived() external view returns (uint256) {
        return _totalReceived;
    }

    function withdraw() external onlyOwner {
        uint256 balance = address(this).balance;
        (bool ok, ) = payable(owner()).call{value: balance}("");
        require(ok, "TipJar: withdraw failed");
    }
}
