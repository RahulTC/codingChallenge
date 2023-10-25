import UIKit

//
//  CodingChallenge1.swift
//  Simple Banking System
//
//  Created by Rahul Adepu on 10/24/2023.
//  Copyright © 2023 Rahul Adepu. All rights reserved.
//

/*
 You are tasked with creating a simple banking system with Swift. The system should support the following features:
 * Create Customer Accounts: Create customer accounts with the following details:
 * Customer Name
 * Account Number
 * Initial Balance
 * Support Different Account Types: Implement three types of accounts - Savings, Checking, and Business. Each account type may have specific features.
 * Deposit and Withdraw: Allow customers to deposit and withdraw money from their accounts. Make sure to handle overdraft for checking accounts and minimum balance for savings account.
 * Calculate Interest: For savings accounts, calculate and add monthly interest to the balance.
 * List All Accounts: Implement a function to list all customer accounts.
 * Transfer Funds: Implement a fund transfer feature to transfer money between two customer accounts.
 * Calculate Total Bank Balance: Calculate the total balance of all accounts in the bank.
 
 
 * Your task is to design and implement the Swift code to achieve these functionalities. 
 1. You should use classes and inheritance to model accounts.
 2. Use structs or enums for the account types.
 3. Apply generics for flexible account management.
 4. Employ Swift collections to store and manage customer accounts.
 5. Make use of control statements for account operations
 6. Make use of optionals for error handling
 7. Make use of protocols and extensions for code organization.
 */

enum accountType{
    case Savings, Checking, Business
}

enum transactionType{
    case Deposit, Withdraw
}

protocol BankingSystem {
    // Properties in  protocol
    var interestRate: Double { get set }
    
    // Functions and Methods of protocols
    func addCustomerToSystem(customerAccount: CustomerAccount)
    func transferFunds(from: CustomerAccount, to: CustomerAccount, amount: Double)
}

class Bank:BankingSystem {
    var customerAccounts = [CustomerAccount]()
    var interestRate: Double = 5
    
    init(customerAccount: [CustomerAccount] = [CustomerAccount]()) {
        self.customerAccounts = customerAccount
    }
    
    // Add a customer to the system
    // Check if the account number's first caharcter starts with the appropriate banking account type and matches the account type.
    func addCustomerToSystem(customerAccount: CustomerAccount){
        if customerAccount.accountNumber.first == "S" && customerAccount.accountType == accountType.Savings {
            print("Savings account created")
            self.customerAccounts.append(customerAccount)
        }else if customerAccount.accountNumber.first == "C" && customerAccount.accountType == accountType.Checking {
            print("Checking account created")
            self.customerAccounts.append(customerAccount)
        }else if customerAccount.accountNumber.first == "B" && customerAccount.accountType == accountType.Business {
            print("Business account created")
            self.customerAccounts.append(customerAccount)
        }else{
            print("Invlaid Information - Account type and account number does not match")
        }
    }
    
    // List All Accounts: Implement a function to list all customer accounts.
    func listOfAllAcc(){
        for accounts in customerAccounts {
            print("Full Name: \(accounts.getFullName()) \n",
                  "Account Number: \(accounts.accountNumber) \n",
                  "Account Type: \(accounts.accountType) \n",
                  "Account Balance: \(accounts.balance) \n")
        }
    }
    
    // Transfer Funds
    func transferFunds(from: CustomerAccount, to: CustomerAccount, amount: Double){
        if from.accountNumber != to.accountNumber {
            // Check if the account is checking account and if the transfer amount is going to cause the account balance to go negative
            print("\(from.getFullName())'s Balance Before Transfer -> \(from.balance.doubleToString2Decimal())")
            print("\(to.getFullName())'s Balance Before Transfer -> \(to.balance.doubleToString2Decimal())")
            if (from.accountType == .Checking || from.accountType == .Business) && (from.balance - amount) > 0 {
                to.balance += amount
                from.balance -= amount
                print("Transfered $\(amount.doubleToString2Decimal()) from \(from.getFullName())'s \(from.accountType) account to \(to.getFullName())'s \(to.accountType) account")
            
            // Check if the account is savings account and if the transfer amount is going to cause the account balance to go below minimum
            }else if from.accountType == .Savings && (from.balance - amount) >= 1000 {
                to.balance += amount
                from.balance -= amount
                print("Transfered $\(amount.doubleToString2Decimal()) from \(from.getFullName())'s \(from.accountType) account to \(to.getFullName())'s \(to.accountType) account")
            } else {
                print("Insufficient Balance for transfer")
                print("Current Balance -> $\(from.balance.doubleToString2Decimal())")
                print("Estimated Balance after transfer -> $(\((from.balance - amount).doubleToString2Decimal()))")
            }
            print("\(from.getFullName())'s Balance After Transfer -> \(from.balance.doubleToString2Decimal())")
            print("\(to.getFullName())'s Balance After Transfer -> \(to.balance.doubleToString2Decimal())")
            print("----------------------------------------------------------------")
            
        }else{
            print("Invalid transaction request")
        }
    }
    
    // Calculate Total Bank Balance: Calculate the total balance of all accounts in the bank.
    func totalBankBalance() -> Double{
        var balance = 0.0
        for account in customerAccounts {
            balance += account.balance
        }
        return balance
    }
}

class CustomerAccount{
    var firstName: String
    var middleName: String?
    var lastName: String
    var accountNumber: String
    var balance: Double
    var accountType: accountType
    
    init(firstName: String, middleName: String? = "", lastName: String, accountNumber: String, balance: Double, accountType: accountType) {
        self.firstName = firstName
        self.middleName = middleName
        self.lastName = lastName
        self.accountNumber = accountNumber
        self.balance = balance
        self.accountType = accountType
    }
    
    func getFullName() -> String{
        return "\(firstName) \(middleName ?? "") \(lastName)"
    }
    
    // Calculate Interest: For savings accounts, calculate and add monthly interest to the balance.
    func interestCalculatorSavingsAcc(interestRate: Double){
        if accountType == .Savings {
            // Adding monthly interest rate
            print("Before Interest ->",balance.doubleToString2Decimal())
            balance += (interestRate/1200) * balance
            print("After Interest ->",balance.doubleToString2Decimal())
        }else{
            print("Not a savings account")
        }
    }
    
    // Deposit and Withdraw: Allow customers to deposit and withdraw money from their accounts.
    // Make sure to handle overdraft for checking accounts and minimum balance for savings account.
    func transaction(amount: Double, transactionType: transactionType, accountType: accountType){
        print("\(getFullName())'s Balance Before transaction -> \(balance.doubleToString2Decimal())")
        if transactionType == .Deposit {
            print("Amount deposited successfully")
            self.balance += amount
        }else {
            if accountType == .Checking || accountType == .Business {
                if balance-amount > 0{
                    self.balance -= amount
                    print("Amount Withdrew successfully")
                } else{
                    print("Insufficient balance amount left on your account")
                }
            }else if accountType == .Savings {
                if balance-amount > 1000{
                    self.balance -= amount
                    print("Amount Withdrew successfully")
                } else{
                    print("Insufficient balance amount left on your account")
                }
            }
        }
        print("\(getFullName())'s Balance After transaction -> \(balance.doubleToString2Decimal())")
        print("----------------------------------------------------------------")
    }
}

// ---------------------------------------------------------------------------------------------------------
// MARK: OUTPUT
// Creating Customer 1
let customer1Savings = CustomerAccount(firstName: "Rahul", middleName: "R", lastName: "Adepu",
                                       accountNumber: "S000001",
                                       balance: 1000,
                                       accountType: .Savings)

let customer1Checking = CustomerAccount(firstName: "Rahul", middleName: "R", lastName: "Adepu",
                                       accountNumber: "C000001",
                                       balance: 100,
                                       accountType: .Checking)

let customer1Business = CustomerAccount(firstName: "Rahul", middleName: "R", lastName: "Adepu",
                                       accountNumber: "B000001",
                                       balance: 10000,
                                       accountType: .Business)

// Creating Customer 2
let customer2Checking = CustomerAccount(firstName: "Tushar", lastName: "Jaiswar",
                                       accountNumber: "C000002",
                                       balance: 500,
                                       accountType: .Checking)


let bankingSystem = Bank()
// Adding customer1's bank account details in the banking system
bankingSystem.addCustomerToSystem(customerAccount: customer1Savings)
bankingSystem.addCustomerToSystem(customerAccount: customer1Checking)
bankingSystem.addCustomerToSystem(customerAccount: customer1Business)

// Adding customer2's bank account details in the banking system
bankingSystem.addCustomerToSystem(customerAccount: customer2Checking)

//print("**************************************************")
//// Check if all the accounts a created with all the detail
//bankingSystem.listOfAllAcc()

// Deposit and withdraw
print("**************************************************")
print("DEPOSIT AND WITHDRAW")
print("**************************************************")
customer1Checking.transaction(amount: 150, transactionType: .Deposit, accountType: .Checking)
customer1Checking.transaction(amount: 100, transactionType: .Withdraw, accountType: .Checking)

// Withdraw limit (check for overdraft for checking accounts)
customer1Checking.transaction(amount: 500, transactionType: .Withdraw, accountType: .Checking)

// Withdraw limit (check for minimum balance for savings account)
customer1Savings.transaction(amount: 100, transactionType: .Withdraw, accountType: .Savings)

// Calculate interest on balance for a savings account
print("**************************************************")
print("INTEREST ON BALANCE OF SAVINGS ACCOUNT")
print("**************************************************")
customer1Savings.interestCalculatorSavingsAcc(interestRate: bankingSystem.interestRate)

// List all accounts
print("**************************************************")
print("LIST OF ALL ACCOUNTS")
print("**************************************************")
bankingSystem.listOfAllAcc()

// Transfer Funds
print("**************************************************")
print("TRANSFER FUNDS")
print("**************************************************")
bankingSystem.transferFunds(from: customer2Checking, to: customer1Checking, amount: 100)

// transfer limit (check for overdraft for checking accounts)
bankingSystem.transferFunds(from: customer1Checking, to: customer2Checking, amount: 400)

// transfer limit (check for overdraft for business accounts)
bankingSystem.transferFunds(from: customer1Business, to: customer2Checking, amount: 20000)

// transfer limit (check for minimum balance for savings account)
bankingSystem.transferFunds(from: customer1Savings, to: customer2Checking, amount: 100)

// Calculate Total Bank Balance
print("**************************************************")
print("The total balance amount in the bank is $",bankingSystem.totalBankBalance().doubleToString2Decimal())

// Extension
extension Double {
    func doubleToString2Decimal() -> String {
        return String(format: "%.2f", self)
    }
}
