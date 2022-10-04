pragma solidity ^0.4.10;

contract Ownable {
    address owner;

    function Ownable() public {
        owner = msg.sender;
    }

    modifier Owned() {
        require(msg.sender == owner);
        _;
    }
}

contract Mortal is Ownable {
    function kill() public Owned {
        selfdestruct(owner);
    }
}

contract Casino is Mortal {
    uint256 minBet;
    uint256 houseEdge; //in %

    event Won(bool _status, uint256 _amount);

    function Casino(uint256 _minBet, uint256 _houseEdge) public payable {
        require(_minBet > 0);
        require(_houseEdge <= 100);
        minBet = _minBet;
        houseEdge = _houseEdge;
    }

    function() public {
        //fallback
        revert();
    }

    function bet(uint256 _number) public payable {
        require(_number > 0 && _number <= 10);
        require(msg.value >= minBet);
        uint256 winningNumber = (block.number % 10) + 1;
        if (_number == winningNumber) {
            uint256 amountWon = (msg.value * (100 - houseEdge)) / 10;
            if (!msg.sender.send(amountWon)) revert();
            emit Won(true, amountWon);
        } else {
            emit Won(false, 0);
        }
    }

    function checkContractBalance() public view Owned returns (uint256) {
        address _contract = this;
        return _contract.balance;
    }
}
