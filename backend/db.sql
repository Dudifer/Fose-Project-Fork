-- Temporary Database:

-- CREATE DATABASE dams;
-- USE dams;
-- CREATE TABLE users (
--     id INT AUTO_INCREMENT PRIMARY KEY,
--     username VARCHAR(50) UNIQUE NOT NULL,
--     password_hash VARCHAR(255) NOT NULL
-- );

-- Create a new database
CREATE DATABASE IF NOT EXISTS DAMS;
USE DAMS;

-- Create a table for patients information
CREATE TABLE IF NOT EXISTS AidCategories(
    AidCategoryID INT PRIMARY KEY,         -- Aid category ID
    CategoryName VARCHAR(45) UNIQUE NOT NULL                   -- Name of the category
);

-- INSERT INTO AidCategories (AidCategoryID, CategoryName)
-- SELECT 0, 'food' FROM DUAL WHERE NOT EXISTS (SELECT * FROM AidCategories WHERE AidCategoryID = 0)
-- UNION ALL
-- SELECT 1, 'clothing' FROM DUAL WHERE NOT EXISTS (SELECT * FROM AidCategories WHERE AidCategoryID = 1)
-- UNION ALL
-- SELECT 2, 'medication' FROM DUAL WHERE NOT EXISTS (SELECT * FROM AidCategories WHERE AidCategoryID = 2)
-- UNION ALL
-- SELECT 3, 'medical attention' FROM DUAL WHERE NOT EXISTS (SELECT * FROM AidCategories WHERE AidCategoryID = 3)
-- UNION ALL
-- SELECT 4, 'shelter' FROM DUAL WHERE NOT EXISTS (SELECT * FROM AidCategories WHERE AidCategoryID = 4)
-- UNION ALL
-- SELECT 5, 'financial' FROM DUAL WHERE NOT EXISTS (SELECT * FROM AidCategories WHERE AidCategoryID = 5)
-- UNION ALL
-- SELECT 6, 'volunteer' FROM DUAL WHERE NOT EXISTS (SELECT * FROM AidCategories WHERE AidCategoryID = 6)
-- UNION ALL
-- SELECT 7, 'consumables' FROM DUAL WHERE NOT EXISTS (SELECT * FROM AidCategories WHERE AidCategoryID = 7);

-- Create a table for storing Insurance Information
CREATE TABLE IF NOT EXISTS ClothingTypes (
    ClothingTypeID INT PRIMARY KEY,       -- ID for each clothing type
    TypeName VARCHAR(45) NOT NULL                       -- Name of clothing type
);

-- INSERT INTO ClothingTypes(ClothingTypeID, TypeName)
-- SELECT 0, 'shirt' FROM DUAL WHERE NOT EXISTS (SELECT * FROM ClothingTypes WHERE ClothingTypeID = 0)
-- UNION ALL
-- SELECT 1, 'jacket/coat' FROM DUAL WHERE NOT EXISTS (SELECT * FROM ClothingTypes WHERE ClothingTypeID = 1)
-- UNION ALL
-- SELECT 2, 'face/head covering' FROM DUAL WHERE NOT EXISTS (SELECT * FROM ClothingTypes WHERE ClothingTypeID = 2)
-- UNION ALL
-- SELECT 3, 'gloves' FROM DUAL WHERE NOT EXISTS (SELECT * FROM ClothingTypes WHERE ClothingTypeID = 3)
-- UNION ALL
-- SELECT 4, 'socks' FROM DUAL WHERE NOT EXISTS (SELECT * FROM ClothingTypes WHERE ClothingTypeID = 4)
-- UNION ALL
-- SELECT 5, 'underwear' FROM DUAL WHERE NOT EXISTS (SELECT * FROM ClothingTypes WHERE ClothingTypeID = 5)
-- UNION ALL
-- SELECT 6, 'shoes' FROM DUAL WHERE NOT EXISTS (SELECT * FROM ClothingTypes WHERE ClothingTypeID = 6);

-- (0, 'crown/hear covering') vs face/head covering
-- (0, 'jacket') and (0, 'coat')

CREATE TABLE IF NOT EXISTS Users (
    UserID INT AUTO_INCREMENT PRIMARY KEY,         -- Unique Patient ID
    Name VARCHAR(50),                             -- Patient's full name
    DateOfBirth DATE NOT NULL,                     -- Patient's date of birth. Binary?
    Address VARCHAR(255) NOT NULL,                            -- Patient's address
    ZipCode INT NOT NULL,                            -- Patient's ZipCode, seperate for easy lookup.
    Email VARCHAR(50) NOT NULL,                               -- Patient's email 
    Password VARCHAR(50) NOT NULL, 
    SecurityQuestion1 VARCHAR(255),
    SecurityAnswer1 VARCHAR(255)
);

-- Make default/admin account 
INSERT INTO Users(Name, DateOfBirth, Address, ZipCode, Email, Password)
SELECT "Jacob Nyberg", '2002-01-03', "316 Tantara Court, North Liberty IA", 52317, "sheeshthebot@gmail.com", "luvgothmommys" FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM Users WHERE UserID = 1);

-- Create a table for storing Payments
CREATE TABLE IF NOT EXISTS Administrators (
    AdminID INT AUTO_INCREMENT PRIMARY KEY,       
    UserID INT NOT NULL,                       
    FOREIGN KEY (UserID) REFERENCES Users(UserID)
);

INSERT INTO Administrators(UserID)
SELECT (1) FROM DUAL
WHERE NOT EXISTS (SELECT * FROM Administrators);

-- Create a table for storing Copay/Deductible information
CREATE TABLE IF NOT EXISTS ActiveDonors (
    DonorID INT AUTO_INCREMENT PRIMARY KEY,       
    UserID INT NOT NULL,                       
    FOREIGN KEY (UserID) REFERENCES Users(UserID)
);

-- Create a table for storing Bill information (Bill Remaining to Patient)
CREATE TABLE IF NOT EXISTS ActiveRecipients (
    RecipientID INT AUTO_INCREMENT PRIMARY KEY,       
    UserID INT NOT NULL,                       
    FOREIGN KEY (UserID) REFERENCES Users(UserID)
);

-- Create a table for storing Payments
CREATE TABLE IF NOT EXISTS CallCenterOperators (
    OperatorID INT AUTO_INCREMENT PRIMARY KEY,       
    UserID INT NOT NULL,                       
    FOREIGN KEY (UserID) REFERENCES Users(UserID)
);

-- Create a table for storing Payments
CREATE TABLE IF NOT EXISTS ImpactAreas (
    AreaID INT AUTO_INCREMENT PRIMARY KEY,       
    ZipCodeStart INT NOT NULL,
    ZipCodeEnd INT NOT NULL,
    DisasterID INT NOT NULL,                       
    FOREIGN KEY (UserID) REFERENCES Users(UserID)
);

-- Create a table for storing Payments
CREATE TABLE IF NOT EXISTS Disasters (
    DisasterID INT AUTO_INCREMENT PRIMARY KEY,       
    Name VARCHAR(255),
    AreaID INT NOT NULL,                              
    FOREIGN KEY (AreaID) REFERENCES ImpactAreas(AreaID)
);

CREATE TABLE IF NOT EXISTS Donations (
    DonationID INT AUTO_INCREMENT PRIMARY KEY,       
    CategoryID INT NOT NULL,                      
    AidCategoryID INT NOT NULL,                       
    FOREIGN KEY (AidCategoryID) REFERENCES AidCategories(AidCategoryID),
    DonorID INT NOT NULL,                       
    FOREIGN KEY (DonorID) REFERENCES ActiveDonors(DonorID)
);

CREATE TABLE IF NOT EXISTS AidRequests (
    AidRequestID INT AUTO_INCREMENT PRIMARY KEY,   
    CategoryID INT NOT NULL,                      
    AidCategoryID INT NOT NULL,                       
    FOREIGN KEY (AidCategoryID) REFERENCES AidCategories(AidCategoryID),
    RecipientID INT NOT NULL,  
    FOREIGN KEY (RecipientID) REFERENCES ActiveRecipients(RecipientID)
);

CREATE TABLE IF NOT EXISTS PendingDonations (
    PendingDonationID INT AUTO_INCREMENT PRIMARY KEY,       
    Quantity INT NOT NULL,                      
    AidRequestID INT NOT NULL,                      
    FOREIGN KEY (AidRequestID) REFERENCES AidRequests(AidRequestID),
    DonationID INT NOT NULL,                       
    FOREIGN KEY (DonationID) REFERENCES Donations(DonationID)
);

-- Food Requests Table
CREATE TABLE IF NOT EXISTS FoodRequests (
    FoodRequestID INT AUTO_INCREMENT PRIMARY KEY,  -- Unique identifier for each request
    Calories INT NOT NULL CHECK (Calories > 0)  -- Requested calorie amount
);

-- Food Donations Table
CREATE TABLE IF NOT EXISTS FoodDonations (
    FoodDonationID INT AUTO_INCREMENT PRIMARY KEY,  -- Unique identifier for each donation
    CaloriesPerUnit INT NOT NULL CHECK (CaloriesPerUnit > 0),  -- Calories per unit donated
    Units INT NOT NULL CHECK (Units > 0)  -- Number of units donated
);

-- Clothing Requests Table
CREATE TABLE IF NOT EXISTS ClothingRequests (
    ClothingRequestID INT AUTO_INCREMENT PRIMARY KEY,  -- Unique identifier for each request
    ClothingTypeID INT NOT NULL,  -- Foreign key to ClothingTypes
    Quantity INT NOT NULL CHECK (Quantity > 0),  -- Number of clothing items requested
    FOREIGN KEY (ClothingTypeID) REFERENCES ClothingTypes(ClothingTypeID) ON DELETE CASCADE
);

-- Clothing Donations Table
CREATE TABLE IF NOT EXISTS ClothingDonations (
    ClothingDonationID INT AUTO_INCREMENT PRIMARY KEY,  -- Unique identifier for each donation
    ClothingTypeID INT NOT NULL,  -- Foreign key to ClothingTypes
    Quantity INT NOT NULL CHECK (Quantity > 0),  -- Number of clothing items donated
    FOREIGN KEY (ClothingTypeID) REFERENCES ClothingTypes(ClothingTypeID) ON DELETE CASCADE
);

-- Medication Requests Table
CREATE TABLE IF NOT EXISTS MedicationRequests (
    MedicationRequestID INT AUTO_INCREMENT PRIMARY KEY,  -- Unique identifier for each request
    name VARCHAR(100) NOT NULL,  -- Name of the medication requested
    Quantity INT NOT NULL CHECK (Quantity > 0)  -- Quantity of medication requested
);

-- Medication Donations Table
CREATE TABLE IF NOT EXISTS MedicationDonations (
    MedicationDonationID INT AUTO_INCREMENT PRIMARY KEY,  -- Unique identifier for each donation
    name VARCHAR(100) NOT NULL,  -- Name of the medication donated
    Quantity INT NOT NULL CHECK (Quantity > 0)  -- Quantity of medication donated
);

-- Medical Attention Requests Table
CREATE TABLE IF NOT EXISTS MedicalAttentionRequests (
    MedicalAttentionRequestID INT AUTO_INCREMENT PRIMARY KEY,  -- Unique identifier for each request
    Severity INT NOT NULL CHECK (Severity BETWEEN 1 AND 100)  -- Severity scale (1-100)
);

-- Medical Attention Donations Table
CREATE TABLE IF NOT EXISTS MedicalAttentionDonations (
    MedicalAttentionDonationID INT AUTO_INCREMENT PRIMARY KEY,  -- Unique identifier for each donation
    Severity INT NOT NULL CHECK (Severity BETWEEN 1 AND 100)  -- Severity scale (1-100)
);

-- Financial Requests Table
CREATE TABLE IF NOT EXISTS FinancialRequests (
    ID INT AUTO_INCREMENT PRIMARY KEY,  -- Unique identifier for each request
    Quantity DECIMAL(10,2) NOT NULL CHECK (Quantity > 0)  -- Amount of money requested
);

-- Financial Donations Table
CREATE TABLE IF NOT EXISTS FinancialDonations (
    FinancialDonationID INT AUTO_INCREMENT PRIMARY KEY,  -- Unique identifier for each donation
    Quantity DECIMAL(10,2) NOT NULL CHECK (Quantity > 0)  -- Amount of money donated
);

-- Labor Requests Table
CREATE TABLE IF NOT EXISTS LaborRequests (
    LaborRequestID INT AUTO_INCREMENT PRIMARY KEY,  -- Unique identifier for each request
    Hours INT NOT NULL CHECK (hours > 0)  -- Number of labor hours requested
);

-- Labor Donations Table
CREATE TABLE IF NOT EXISTS LaborDonations (
    LaborDonationID INT AUTO_INCREMENT PRIMARY KEY,  -- Unique identifier for each donation
    Hours INT NOT NULL CHECK (hours > 0)  -- Number of labor hours donated
);

-- Shelter Requests Table
CREATE TABLE IF NOT EXISTS ShelterRequests (
    ShelterRequestID INT AUTO_INCREMENT PRIMARY KEY,  -- Unique identifier for each request
    Days INT NOT NULL CHECK (days > 0)  -- Number of shelter days requested
);

-- Shelter Donations Table
CREATE TABLE IF NOT EXISTS ShelterDonations (
    ShelterDonationID INT AUTO_INCREMENT PRIMARY KEY,  -- Unique identifier for each donation
    Days INT NOT NULL CHECK (days > 0)  -- Number of shelter days donated
);
-- Stored Procedures

-- Patients Table Procedures
----------------------------------------------------------------------------------------------------------------------------------------
-- THESE FUNCS ERE ADDED ALREADY 
-- DELIMITER //
-- CREATE PROCEDURE CreateUser (IN name VARCHAR(100), IN dob DATE, IN addr Binary(16), IN zip Binary(16), IN email Binary(16), IN pwd Binary(16))
-- BEGIN
--     INSERT INTO Users (Name, DateOfBirth, Address, ZipCode, Email, Password)
--     VALUES (name, dob, addr, zip, email, pwd);
-- END //

-- CREATE PROCEDURE UpdateUser (IN uid INT, IN name VARCHAR(100), IN addr VARCHAR(255), IN zip VARCHAR(20), IN email VARCHAR(100), IN pwd Binary(16))
-- BEGIN
--     UPDATE Users
--     SET Name = name, Address = addr, ZipCode = zip, Email = email
--     WHERE UserID = uid;
-- END //

-- CREATE PROCEDURE DeletePatient (IN uid INT)
-- BEGIN
--     DELETE FROM Users WHERE UserID = uid;
-- END //

-- CREATE PROCEDURE GetUsers ()
-- BEGIN
--     SELECT * FROM Users;
-- END //

-- CREATE PROCEDURE GetUser (IN email Binary(16), IN pwd Binary (16))
-- BEGIN 
--     SELECT * FROM Users
--     WHERE Email = email and Password = pwd;
-- END //
----------------------------------------------------------------------------------------------------------------------------------------




-- CREATE PROCEDURE AddDonation ()


-- CREATE TABLE Donations (
--     DonationID INT AUTO_INCREMENT PRIMARY KEY,       
--     CategoryID INT NOT NULL CHECK ((CategoryID > -1) AND CategoryID ),                      
--     AidCategoryID INT NOT NULL,                       
--     FOREIGN KEY (AidCategoryID) REFERENCES AidCategories(AidCategoryID),
--     DonorID INT NOT NULL,                       
--     FOREIGN KEY (DonorID) REFERENCES ActiveDonors(DonorID)
-- );
-- -- InsuranceInformation Table Procedures
-- -- CREATE PROCEDURE CreateInsurance (IN pID INT, IN provider VARCHAR(255), IN policy VARCHAR(255), IN copay DECIMAL(10, 2), IN deductible DECIMAL(10, 2), IN services TEXT)
-- -- BEGIN
-- --     INSERT INTO InsuranceInformation (PatientID, InsuranceProvider, PolicyNumber, Copay, Deductible, CoveredServices)
-- --     VALUES (pID, provider, policy, copay, deductible, services);
-- -- END //

-- -- CREATE PROCEDURE UpdateInsurance (IN iID INT, IN provider VARCHAR(255), IN policy VARCHAR(255), IN copay DECIMAL(10, 2), IN deductible DECIMAL(10, 2), IN services TEXT)
-- -- BEGIN
-- --     UPDATE InsuranceInformation
-- --     SET InsuranceProvider = provider, PolicyNumber = policy, Copay = copay, Deductible = deductible, CoveredServices = services
-- --     WHERE InsuranceID = iID;
-- -- END //

-- -- CREATE PROCEDURE DeleteInsurance (IN iID INT)
-- -- BEGIN
-- --     DELETE FROM InsuranceInformation WHERE InsuranceID = iID;
-- -- END //

-- -- CREATE PROCEDURE RetrieveInsurance ()
-- -- BEGIN
-- --     SELECT * FROM InsuranceInformation;
-- -- END //

-- -- CopayDeductible Table Procedures
-- -- CREATE PROCEDURE CreateCopayDeductible (IN iID INT, IN pID INT, IN copay DECIMAL(10, 2), IN deductible DECIMAL(10, 2), IN remaining DECIMAL(10, 2))
-- -- BEGIN
-- --     INSERT INTO CopayDeductible (InsuranceID, PatientID, CopayAmount, DeductibleAmount, RemainingDeductible)
-- --     VALUES (iID, pID, copay, deductible, remaining);
-- -- END //

-- -- CREATE PROCEDURE UpdateCopayDeductible (IN cdID INT, IN copay DECIMAL(10, 2), IN deductible DECIMAL(10, 2), IN remaining DECIMAL(10, 2))
-- -- BEGIN
-- --     UPDATE CopayDeductible
-- --     SET CopayAmount = copay, DeductibleAmount = deductible, RemainingDeductible = remaining
-- --     WHERE CopayDeductibleID = cdID;
-- -- END //

-- -- CREATE PROCEDURE DeleteCopayDeductible (IN cdID INT)
-- -- BEGIN
-- --     DELETE FROM CopayDeductible WHERE CopayDeductibleID = cdID;
-- -- END //

-- -- CREATE PROCEDURE RetrieveCopayDeductible ()
-- -- BEGIN
-- --     SELECT * FROM CopayDeductible;
-- -- END //

-- -- Bills Table Procedures
-- -- CREATE PROCEDURE CreateBill (IN pID INT, IN total DECIMAL(10, 2), IN insurancePaid DECIMAL(10, 2), IN owed DECIMAL(10, 2), IN date DATE, IN status VARCHAR(50))
-- -- BEGIN
-- --     INSERT INTO Bills (PatientID, TotalAmount, InsurancePaid, AmountOwed, BillDate, BillStatus)
-- --     VALUES (pID, total, insurancePaid, owed, date, status);
-- -- END //

-- -- CREATE PROCEDURE UpdateBill (IN bID INT, IN total DECIMAL(10, 2), IN insurancePaid DECIMAL(10, 2), IN owed DECIMAL(10, 2), IN status VARCHAR(50))
-- -- BEGIN
-- --     UPDATE Bills
-- --     SET TotalAmount = total, InsurancePaid = insurancePaid, AmountOwed = owed, BillStatus = status
-- --     WHERE BillID = bID;
-- -- END //

-- -- CREATE PROCEDURE DeleteBill (IN bID INT)
-- -- BEGIN
-- --     DELETE FROM Bills WHERE BillID = bID;
-- -- END //

-- -- CREATE PROCEDURE RetrieveBills ()
-- -- BEGIN
-- --     SELECT * FROM Bills;
-- -- END //

-- -- Payments Table Procedures
-- -- CREATE PROCEDURE CreatePayment (IN pID INT, IN bID INT, IN amount DECIMAL(10, 2), IN method VARCHAR(50), IN date DATE, IN status VARCHAR(50))
-- -- BEGIN
-- --     INSERT INTO Payments (PatientID, BillID, PaymentAmount, PaymentMethod, PaymentDate, PaymentStatus)
-- --     VALUES (pID, bID, amount, method, date, status);
-- -- END //

-- -- CREATE PROCEDURE UpdatePayment (IN payID INT, IN amount DECIMAL(10, 2), IN method VARCHAR(50), IN status VARCHAR(50))
-- -- BEGIN
-- --     UPDATE Payments
-- --     SET PaymentAmount = amount, PaymentMethod = method, PaymentStatus = status
-- --     WHERE PaymentID = payID;
-- -- END //

-- -- CREATE PROCEDURE DeletePayment (IN payID INT)
-- -- BEGIN
-- --     DELETE FROM Payments WHERE PaymentID = payID;
-- -- END //

-- -- CREATE PROCEDURE RetrievePayments ()
-- -- BEGIN
-- --     SELECT * FROM Payments;
-- -- END //
-- DELIMITER ;