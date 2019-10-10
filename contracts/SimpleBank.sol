pragma solidity ^0.5.0;


contract SimpleBank {

    //
    // State variables
    //
    mapping (address => uint) private balances;
    mapping (address => bool) public enrolled;

    address public owner;

    //
    // Events
    //

    event LogEnrolled(address indexed accountAddress);
    event LogDepositMade(address indexed accountAddress, uint amount);
    event LogWithdrawal(address indexed accountAddress, uint withdrawAmount, uint newBalance);


    //
    // Functions
    //
    constructor() public {
        /* Set the owner to the creator of this contract */
        owner = msg.sender;
    }

    /// @notice Get balance
    /// @return The balance of the user
    function balance() public view returns (uint) {
        /* Get the balance of the sender of this transaction */
        return balances[msg.sender];
    }

    /// @notice Enroll a customer with the bank
    /// @return The users enrolled status
    function enroll() public returns (bool) {
        enrolled[msg.sender] = true;
        return enrolled[msg.sender];
        emit LogEnrolled(msg.sender);
    }

    /// @notice Deposit ether into bank
    /// @return The balance of the user after the deposit is made
    function deposit() public payable returns (uint) {
        require(msg.value > 0);
        balances[msg.sender] += msg.value;
        emit LogDepositMade(msg.sender, msg.value);
        return balance();
    }

    /// @notice Withdraw ether from bank
    /// @dev This does not return any excess ether sent to it
    /// @param withdrawAmount amount you want to withdraw
    /// @return The balance remaining for the user
    function withdraw(uint withdrawAmount) public returns (uint accountBalance) {
        /* If the sender's balance is at least the amount they want to withdraw,
           Subtract the amount from the sender's balance, and try to send that amount of ether
           to the user attempting to withdraw.
           return the user's balance.*/
           require(balances[msg.sender] >= withdrawAmount);
           msg.sender.transfer(withdrawAmount);
           balances[msg.sender] -= withdrawAmount;
           emit LogWithdrawal (msg.sender, withdrawAmount, balances[msg.sender]);
           return balances[msg.sender];
    }

    function() external payable {
        revert();
    }
}
