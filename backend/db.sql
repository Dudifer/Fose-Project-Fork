-- Create a new database
CREATE DATABASE IF NOT EXISTS AidDatabase;
USE AidDatabase;

-- Create a table for patients information
CREATE TABLE AidCategories (
    AidCategoryID INT AUTO_INCREMENT PRIMARY KEY,         -- Aid category ID
    CategoryName VARCHAR(45) NOT NULL                   -- Name of the category
);

-- Create a table for storing Insurance Information
CREATE TABLE ClothingTypes (
    ClothingTypeID INT AUTO_INCREMENT PRIMARY KEY,       -- ID for each clothing type
    TypeName VARCHAR(45) NOT NULL                       -- Name of clothing type
);

CREATE TABLE Users (
    UserID INT AUTO_INCREMENT PRIMARY KEY,         -- Unique Patient ID
    Name VARCHAR(255),                             -- Patient's full name
    DateOfBirth DATE NOT NULL,                     -- Patient's date of birth. Binary?
    Address Binary(16),                            -- Patient's address
    ZipCode Binary(16),                            -- Patient's ZipCode, seperate for easy lookup.
    Email Binary(16)                               -- Patient's email 
);

-- Create a table for storing Copay/Deductible information
CREATE TABLE ActiveDonors (
    DonorID INT AUTO_INCREMENT PRIMARY KEY,       
    UserID INT NOT NULL,                       
    FOREIGN KEY (UserID) REFERENCES Users(UserID)
);

-- Create a table for storing Bill information (Bill Remaining to Patient)
CREATE TABLE ActiveRecipients (
    RecipientID INT AUTO_INCREMENT PRIMARY KEY,       
    UserID INT NOT NULL,                       
    FOREIGN KEY (UserID) REFERENCES Users(UserID)
);

-- Create a table for storing Payments
CREATE TABLE CallCenterOperators (
    OperatorID INT AUTO_INCREMENT PRIMARY KEY,       
    UserID INT NOT NULL,                       
    FOREIGN KEY (UserID) REFERENCES Users(UserID)
);

-- Create a table for storing Payments
CREATE TABLE Administrators (
    AdminID INT AUTO_INCREMENT PRIMARY KEY,       
    UserID INT NOT NULL,                       
    FOREIGN KEY (UserID) REFERENCES Users(UserID)
);

-- Create a table for storing Payments
CREATE TABLE Disasters (
    DisasterID INT AUTO_INCREMENT PRIMARY KEY,       
    Name VARCHAR(255),
    AreaID INT NOT NULL,                              
    FOREIGN KEY (AreaID) REFERENCES ImpactAreas(AreaID)
);

-- Create a table for storing Payments
CREATE TABLE ImpactAreas (
    AreaID INT AUTO_INCREMENT PRIMARY KEY,       
    ZipCodeStart INT NOT NULL,
    ZipCodeEnd INT NOT NULL,
    DisasterID INT NOT NULL,                       
    FOREIGN KEY (UserID) REFERENCES Users(UserID)
);

CREATE TABLE Donations (
    DonationID INT AUTO_INCREMENT PRIMARY KEY,       
    CategoryID INT NOT NULL,                      
    AidCategoryID INT NOT NULL,                       
    FOREIGN KEY (AidCategoryID) REFERENCES AidCategories(AidCategoryID),
    DonorID INT NOT NULL,                       
    FOREIGN KEY (DonorID) REFERENCES ActiveDonors(DonorID)
);

CREATE TABLE AidRequests (
    AidRequestID INT AUTO_INCREMENT PRIMARY KEY,   
    CategoryID INT NOT NULL,                      
    AidCategoryID INT NOT NULL,                       
    FOREIGN KEY (AidCategoryID) REFERENCES AidCategories(AidCategoryID),
    RecipientID INT NOT NULL,  
    FOREIGN KEY (RecipientID) REFERENCES ActiveRecipients(RecipientID)
);

CREATE TABLE PendingDonations (
    PendingDonationID INT AUTO_INCREMENT PRIMARY KEY,       
    Quantity INT NOT NULL,                      
    AidRequestID INT NOT NULL,                      
    FOREIGN KEY (AidRequestID) REFERENCES AidRequests(AidRequestID),
    DonationID INT NOT NULL,                       
    FOREIGN KEY (DonationID) REFERENCES Donations(DonationID)
);

-- Food Requests Table
CREATE TABLE FoodRequests (
    FoodRequestID INT AUTO_INCREMENT PRIMARY KEY,  -- Unique identifier for each request
    Calories INT NOT NULL CHECK (Calories > 0)  -- Requested calorie amount
);

-- Food Donations Table
CREATE TABLE FoodDonations (
    FoodDonationID INT AUTO_INCREMENT PRIMARY KEY,  -- Unique identifier for each donation
    CaloriesPerUnit INT NOT NULL CHECK (CaloriesPerUnit > 0),  -- Calories per unit donated
    Units INT NOT NULL CHECK (Units > 0)  -- Number of units donated
);

-- Clothing Requests Table
CREATE TABLE ClothingRequests (
    ClothingRequestID INT AUTO_INCREMENT PRIMARY KEY,  -- Unique identifier for each request
    ClothingTypeID INT NOT NULL,  -- Foreign key to ClothingTypes
    Quantity INT NOT NULL CHECK (Quantity > 0),  -- Number of clothing items requested
    FOREIGN KEY (ClothingTypeID) REFERENCES ClothingTypes(ClothingTypeID) ON DELETE CASCADE
);

-- Clothing Donations Table
CREATE TABLE ClothingDonations (
    ClothingDonationID INT AUTO_INCREMENT PRIMARY KEY,  -- Unique identifier for each donation
    ClothingTypeID INT NOT NULL,  -- Foreign key to ClothingTypes
    Quantity INT NOT NULL CHECK (Quantity > 0),  -- Number of clothing items donated
    FOREIGN KEY (ClothingTypeID) REFERENCES ClothingTypes(ClothingTypeID) ON DELETE CASCADE
);

-- Medication Requests Table
CREATE TABLE MedicationRequests (
    MedicationRequestID INT AUTO_INCREMENT PRIMARY KEY,  -- Unique identifier for each request
    name VARCHAR(100) NOT NULL,  -- Name of the medication requested
    Quantity INT NOT NULL CHECK (Quantity > 0)  -- Quantity of medication requested
);

-- Medication Donations Table
CREATE TABLE MedicationDonations (
    MedicationDonationID INT AUTO_INCREMENT PRIMARY KEY,  -- Unique identifier for each donation
    name VARCHAR(100) NOT NULL,  -- Name of the medication donated
    Quantity INT NOT NULL CHECK (Quantity > 0)  -- Quantity of medication donated
);

-- Medical Attention Requests Table
CREATE TABLE MedicalAttentionRequests (
    MedicalAttentionRequestID INT AUTO_INCREMENT PRIMARY KEY,  -- Unique identifier for each request
    Severity INT NOT NULL CHECK (Severity BETWEEN 1 AND 100)  -- Severity scale (1-100)
);

-- Medical Attention Donations Table
CREATE TABLE MedicalAttentionDonations (
    MedicalAttentionDonationID INT AUTO_INCREMENT PRIMARY KEY,  -- Unique identifier for each donation
    Severity INT NOT NULL CHECK (Severity BETWEEN 1 AND 100)  -- Severity scale (1-100)
);

-- Financial Requests Table
CREATE TABLE FinancialRequests (
    ID INT AUTO_INCREMENT PRIMARY KEY,  -- Unique identifier for each request
    Quantity DECIMAL(10,2) NOT NULL CHECK (Quantity > 0)  -- Amount of money requested
);

-- Financial Donations Table
CREATE TABLE FinancialDonations (
    FinancialDonationID INT AUTO_INCREMENT PRIMARY KEY,  -- Unique identifier for each donation
    Quantity DECIMAL(10,2) NOT NULL CHECK (Quantity > 0)  -- Amount of money donated
);

-- Labor Requests Table
CREATE TABLE LaborRequests (
    LaborRequestID INT AUTO_INCREMENT PRIMARY KEY,  -- Unique identifier for each request
    Hours INT NOT NULL CHECK (hours > 0)  -- Number of labor hours requested
);

-- Labor Donations Table
CREATE TABLE LaborDonations (
    LaborDonationID INT AUTO_INCREMENT PRIMARY KEY,  -- Unique identifier for each donation
    Hours INT NOT NULL CHECK (hours > 0)  -- Number of labor hours donated
);

-- Shelter Requests Table
CREATE TABLE ShelterRequests (
    ShelterRequestID INT AUTO_INCREMENT PRIMARY KEY,  -- Unique identifier for each request
    Days INT NOT NULL CHECK (days > 0)  -- Number of shelter days requested
);

-- Shelter Donations Table
CREATE TABLE ShelterDonations (
    ShelterDonationID INT AUTO_INCREMENT PRIMARY KEY,  -- Unique identifier for each donation
    Days INT NOT NULL CHECK (days > 0)  -- Number of shelter days donated
);
-- Stored Procedures

-- Patients Table Procedures
DELIMITER //
-- CREATE PROCEDURE CreatePatient (IN fName VARCHAR(100), IN lName VARCHAR(100), IN dob DATE, IN addr VARCHAR(255), IN phone VARCHAR(20), IN email VARCHAR(100))
-- BEGIN
--     INSERT INTO Patients (FirstName, LastName, DateOfBirth, Address, PhoneNumber, Email)
--     VALUES (fName, lName, dob, addr, phone, email);
-- END //

-- CREATE PROCEDURE UpdatePatient (IN pID INT, IN fName VARCHAR(100), IN lName VARCHAR(100), IN addr VARCHAR(255), IN phone VARCHAR(20), IN email VARCHAR(100))
-- BEGIN
--     UPDATE Patients
--     SET FirstName = fName, LastName = lName, Address = addr, PhoneNumber = phone, Email = email
--     WHERE PatientID = pID;
-- END //

-- CREATE PROCEDURE DeletePatient (IN pID INT)
-- BEGIN
--     DELETE FROM Patients WHERE PatientID = pID;
-- END //

-- CREATE PROCEDURE RetrievePatients ()
-- BEGIN
--     SELECT * FROM Patients;
-- END //

-- InsuranceInformation Table Procedures
-- CREATE PROCEDURE CreateInsurance (IN pID INT, IN provider VARCHAR(255), IN policy VARCHAR(255), IN copay DECIMAL(10, 2), IN deductible DECIMAL(10, 2), IN services TEXT)
-- BEGIN
--     INSERT INTO InsuranceInformation (PatientID, InsuranceProvider, PolicyNumber, Copay, Deductible, CoveredServices)
--     VALUES (pID, provider, policy, copay, deductible, services);
-- END //

-- CREATE PROCEDURE UpdateInsurance (IN iID INT, IN provider VARCHAR(255), IN policy VARCHAR(255), IN copay DECIMAL(10, 2), IN deductible DECIMAL(10, 2), IN services TEXT)
-- BEGIN
--     UPDATE InsuranceInformation
--     SET InsuranceProvider = provider, PolicyNumber = policy, Copay = copay, Deductible = deductible, CoveredServices = services
--     WHERE InsuranceID = iID;
-- END //

-- CREATE PROCEDURE DeleteInsurance (IN iID INT)
-- BEGIN
--     DELETE FROM InsuranceInformation WHERE InsuranceID = iID;
-- END //

-- CREATE PROCEDURE RetrieveInsurance ()
-- BEGIN
--     SELECT * FROM InsuranceInformation;
-- END //

-- CopayDeductible Table Procedures
-- CREATE PROCEDURE CreateCopayDeductible (IN iID INT, IN pID INT, IN copay DECIMAL(10, 2), IN deductible DECIMAL(10, 2), IN remaining DECIMAL(10, 2))
-- BEGIN
--     INSERT INTO CopayDeductible (InsuranceID, PatientID, CopayAmount, DeductibleAmount, RemainingDeductible)
--     VALUES (iID, pID, copay, deductible, remaining);
-- END //

-- CREATE PROCEDURE UpdateCopayDeductible (IN cdID INT, IN copay DECIMAL(10, 2), IN deductible DECIMAL(10, 2), IN remaining DECIMAL(10, 2))
-- BEGIN
--     UPDATE CopayDeductible
--     SET CopayAmount = copay, DeductibleAmount = deductible, RemainingDeductible = remaining
--     WHERE CopayDeductibleID = cdID;
-- END //

-- CREATE PROCEDURE DeleteCopayDeductible (IN cdID INT)
-- BEGIN
--     DELETE FROM CopayDeductible WHERE CopayDeductibleID = cdID;
-- END //

-- CREATE PROCEDURE RetrieveCopayDeductible ()
-- BEGIN
--     SELECT * FROM CopayDeductible;
-- END //

-- Bills Table Procedures
-- CREATE PROCEDURE CreateBill (IN pID INT, IN total DECIMAL(10, 2), IN insurancePaid DECIMAL(10, 2), IN owed DECIMAL(10, 2), IN date DATE, IN status VARCHAR(50))
-- BEGIN
--     INSERT INTO Bills (PatientID, TotalAmount, InsurancePaid, AmountOwed, BillDate, BillStatus)
--     VALUES (pID, total, insurancePaid, owed, date, status);
-- END //

-- CREATE PROCEDURE UpdateBill (IN bID INT, IN total DECIMAL(10, 2), IN insurancePaid DECIMAL(10, 2), IN owed DECIMAL(10, 2), IN status VARCHAR(50))
-- BEGIN
--     UPDATE Bills
--     SET TotalAmount = total, InsurancePaid = insurancePaid, AmountOwed = owed, BillStatus = status
--     WHERE BillID = bID;
-- END //

-- CREATE PROCEDURE DeleteBill (IN bID INT)
-- BEGIN
--     DELETE FROM Bills WHERE BillID = bID;
-- END //

-- CREATE PROCEDURE RetrieveBills ()
-- BEGIN
--     SELECT * FROM Bills;
-- END //

-- Payments Table Procedures
-- CREATE PROCEDURE CreatePayment (IN pID INT, IN bID INT, IN amount DECIMAL(10, 2), IN method VARCHAR(50), IN date DATE, IN status VARCHAR(50))
-- BEGIN
--     INSERT INTO Payments (PatientID, BillID, PaymentAmount, PaymentMethod, PaymentDate, PaymentStatus)
--     VALUES (pID, bID, amount, method, date, status);
-- END //

-- CREATE PROCEDURE UpdatePayment (IN payID INT, IN amount DECIMAL(10, 2), IN method VARCHAR(50), IN status VARCHAR(50))
-- BEGIN
--     UPDATE Payments
--     SET PaymentAmount = amount, PaymentMethod = method, PaymentStatus = status
--     WHERE PaymentID = payID;
-- END //

-- CREATE PROCEDURE DeletePayment (IN payID INT)
-- BEGIN
--     DELETE FROM Payments WHERE PaymentID = payID;
-- END //

-- CREATE PROCEDURE RetrievePayments ()
-- BEGIN
--     SELECT * FROM Payments;
-- END //
-- DELIMITER ;