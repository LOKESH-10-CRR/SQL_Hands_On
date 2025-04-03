
DELIMITER $$

CREATE PROCEDURE AddCustomer(
    IN cust_name VARCHAR(100),
    IN cust_email VARCHAR(100),
    IN cust_phone VARCHAR(15),
    IN cust_address TEXT
)
BEGIN
    INSERT INTO Customers (name, email, phone, address) 
    VALUES (cust_name, cust_email, cust_phone, cust_address);
END $$

DELIMITER ;

DELIMITER $$

CREATE PROCEDURE OpenAccount(
    IN cust_id INT,
    IN acc_type ENUM('Savings', 'Checking', 'Fixed Deposit'),
    IN initial_balance DECIMAL(15,2)
)
BEGIN
    INSERT INTO Accounts (customer_id, account_type, balance) 
    VALUES (cust_id, acc_type, initial_balance);
END $$

DELIMITER ;

DELIMITER $$

CREATE PROCEDURE DepositMoney(
    IN acc_id INT,
    IN dep_amount DECIMAL(15,2)
)
BEGIN
    UPDATE Accounts 
    SET balance = balance + dep_amount 
    WHERE account_id = acc_id;

    INSERT INTO Transactions (account_id, transaction_type, amount) 
    VALUES (acc_id, 'Deposit', dep_amount);
END $$

DELIMITER ;

DELIMITER $$

CREATE PROCEDURE WithdrawMoney(
    IN acc_id INT,
    IN withdraw_amount DECIMAL(15,2)
)
BEGIN
    -- Check if balance is sufficient before withdrawal
    IF (SELECT balance FROM Accounts WHERE account_id = acc_id) >= withdraw_amount THEN
        UPDATE Accounts 
        SET balance = balance - withdraw_amount 
        WHERE account_id = acc_id;

        INSERT INTO Transactions (account_id, transaction_type, amount) 
        VALUES (acc_id, 'Withdrawal', withdraw_amount);
    ELSE
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Insufficient balance';
    END IF;
END $$

DELIMITER ;

DELIMITER $$

CREATE PROCEDURE CheckBalance(
    IN acc_id INT
)
BEGIN
    SELECT account_id, balance FROM Accounts WHERE account_id = acc_id;
END $$

DELIMITER ;


DELIMITER $$

CREATE PROCEDURE GetTransactionHistory(
    IN acc_id INT
)
BEGIN
    SELECT * FROM Transactions WHERE account_id = acc_id ORDER BY transaction_date DESC;
END $$

DELIMITER ;

DELIMITER $$

CREATE PROCEDURE ApproveLoan(
    IN loan_id_param INT
)
BEGIN
    UPDATE Loans 
    SET loan_status = 'Approved' 
    WHERE loan_id = loan_id_param;
END $$

DELIMITER ;