pragma solidity ^0.4.10;

contract Ownable {
    address owner;

    function Ownable() public {
        // Set owner to who creates the contract
        owner = msg.sender;
    } // Access modifier

    modifier Owned() {
        require(msg.sender == owner);
        _;
    }
}

contract Mortal is Ownable {
    // Our access modifier is present, only the contract creator can      use this function
    function kill() public Owned {
        selfdestruct(owner);
    }
}
