CREATE DATABASE LibraryManagmentSystem
USE LibraryManagmentSystem

-- Table Creation
CREATE TABLE Libraries (
    LibraryID INT IDENTITY(1,1) PRIMARY KEY,
    Name VARCHAR(100) NOT NULL UNIQUE,
    Location VARCHAR(150) NOT NULL,
    ContactNumber VARCHAR(20) NOT NULL,
    EstablishedYear INT NOT NULL CHECK (EstablishedYear >= 1800 AND EstablishedYear <= YEAR(GETDATE()))
);

CREATE TABLE Books (
    BookID INT IDENTITY(1,1) PRIMARY KEY,
    ISBN VARCHAR(13) NOT NULL UNIQUE,
    Title VARCHAR(200) NOT NULL,
    Genre VARCHAR(20) NOT NULL CHECK (Genre IN ('Fiction', 'Non-fiction', 'Reference', 'Children')),
    Price DECIMAL(8,2) NOT NULL CHECK (Price > 0),
    IsAvailable BIT NOT NULL DEFAULT 1,
    ShelfLocation VARCHAR(50) NOT NULL,
    LibraryID INT NOT NULL,
    FOREIGN KEY (LibraryID) REFERENCES Libraries(LibraryID)
        ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Members (
    MemberID INT IDENTITY(1,1) PRIMARY KEY,
    FullName VARCHAR(100) NOT NULL,
    Email VARCHAR(100) NOT NULL UNIQUE,
    PhoneNumber VARCHAR(20) NOT NULL,
    MembershipDate DATE NOT NULL DEFAULT GETDATE()
);

CREATE TABLE Staff (
    StaffID INT IDENTITY(1,1) PRIMARY KEY,
    FullName VARCHAR(100) NOT NULL,
    Position VARCHAR(50) NOT NULL,
    ContactNumber VARCHAR(20) NOT NULL,
    LibraryID INT NOT NULL,
    FOREIGN KEY (LibraryID) REFERENCES Libraries(LibraryID)
        ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Loans (
    LoanID INT IDENTITY(1,1) PRIMARY KEY,
    MemberID INT NOT NULL,
    BookID INT NOT NULL,
    LoanDate DATE NOT NULL DEFAULT GETDATE(),
    DueDate DATE NOT NULL,
    ReturnDate DATE,
    LoanStatus VARCHAR(10) NOT NULL DEFAULT 'Issued'
        CHECK (LoanStatus IN ('Issued', 'Returned', 'Overdue')),
    FOREIGN KEY (MemberID) REFERENCES Members(MemberID)
        ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (BookID) REFERENCES Books(BookID)
        ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Payments (
    PaymentID INT IDENTITY(1,1) PRIMARY KEY,
    LoanID INT NOT NULL,
    PaymentDate DATE NOT NULL DEFAULT GETDATE(),
    Amount DECIMAL(8,2) NOT NULL CHECK (Amount > 0),
    Method VARCHAR(50) NOT NULL,
    FOREIGN KEY (LoanID) REFERENCES Loans(LoanID)
        ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Reviews (
    ReviewID INT IDENTITY(1,1) PRIMARY KEY,
    MemberID INT NOT NULL,
    BookID INT NOT NULL,
    Rating INT NOT NULL CHECK (Rating BETWEEN 1 AND 5),
    Comments VARCHAR(500) NOT NULL DEFAULT 'No comments',
    ReviewDate DATE NOT NULL DEFAULT GETDATE(),
    FOREIGN KEY (MemberID) REFERENCES Members(MemberID)
        ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (BookID) REFERENCES Books(BookID)
        ON DELETE CASCADE ON UPDATE CASCADE
);

-- Data Insertion

INSERT INTO Libraries (Name, Location, ContactNumber, EstablishedYear) VALUES
('Central Library', 'Downtown', '123-456-7890', 1990),
('Westside Library', 'West End', '234-567-8901', 2005),
('Eastside Library', 'East Town', '345-678-9012', 2010);

INSERT INTO Books (ISBN, Title, Genre, Price, ShelfLocation, LibraryID) VALUES
('9781234567897', 'The Great Adventure', 'Fiction', 12.99, 'A1', 1),
('9781234567898', 'Learning SQL', 'Reference', 29.99, 'B2', 1),
('9781234567899', 'History of Science', 'Non-fiction', 15.50, 'C3', 1),
('9781234567800', 'Children’s Tales', 'Children', 8.99, 'D1', 2),
('9781234567801', 'World Atlas', 'Reference', 24.50, 'B1', 2),
('9781234567802', 'Mystery Island', 'Fiction', 10.99, 'A2', 2),
('9781234567803', 'Biology Basics', 'Non-fiction', 18.75, 'C1', 3),
('9781234567804', 'Animal Stories', 'Children', 7.95, 'D2', 3),
('9781234567805', 'Fictional Minds', 'Fiction', 14.60, 'A3', 3),
('9781234567806', 'Math in Nature', 'Non-fiction', 21.00, 'C2', 3);

INSERT INTO Members (FullName, Email, PhoneNumber) VALUES
('Alice Johnson', 'alice@example.com', '111-111-1111'),
('Bob Smith', 'bob@example.com', '222-222-2222'),
('Carol White', 'carol@example.com', '333-333-3333'),
('David Lee', 'david@example.com', '444-444-4444'),
('Eva Green', 'eva@example.com', '555-555-5555'),
('Frank Brown', 'frank@example.com', '666-666-6666');

INSERT INTO Staff (FullName, Position, ContactNumber, LibraryID) VALUES
('John Manager', 'Manager', '777-111-1111', 1),
('Sara Librarian', 'Librarian', '777-222-2222', 1),
('Tom Reader', 'Assistant', '777-333-3333', 2),
('Nina Organizer', 'Manager', '777-444-4444', 3);

INSERT INTO Loans (MemberID, BookID, DueDate) VALUES
(1, 1, '2025-06-10'),
(2, 2, '2025-06-11'),
(3, 3, '2025-06-12'),
(4, 4, '2025-06-13'),
(5, 5, '2025-06-14'),
(1, 6, '2025-06-15'),
(2, 7, '2025-06-16'),
(6, 8, '2025-06-17'),
(3, 9, '2025-06-18'),
(4, 10, '2025-06-19');

INSERT INTO Payments (LoanID, Amount, Method) VALUES
(2, 5.00, 'Credit Card'),
(3, 2.50, 'Cash'),
(4, 3.00, 'Debit Card'),
(6, 1.75, 'Cash');

INSERT INTO Reviews (MemberID, BookID, Rating, Comments) VALUES
(1, 1, 5, 'Excellent read!'),
(2, 2, 4, 'Very informative.'),
(3, 3, 3, 'Average content.'),
(4, 4, 5, 'My kids loved it.'),
(5, 5, 2, 'Too technical.'),
(6, 6, 4, 'Enjoyed the mystery!');

-- Mark books as returned
UPDATE Loans
SET LoanStatus = 'Returned', ReturnDate = GETDATE()
WHERE LoanID IN (2, 4, 6);

-- Update loan status 
UPDATE Loans
SET LoanStatus = 'Overdue'
WHERE DueDate < GETDATE() AND LoanStatus = 'Issued';

-- Delete reviews&payments
DELETE FROM Reviews
WHERE Rating < 3;

DELETE FROM Payments
WHERE PaymentID = 4;
------------------------------
-- Learning from error portion
------------------------------

-- Deleting a member who:Has existing loans, Has written book reviews
DELETE FROM Members WHERE MemberID = 1
SELECT * FROM Members
SELECT * FROM Loans
SELECT * FROM Reviews

-- Deleting a book that:Is currently on loan, Has multiple reviews attached to it 
DELETE FROM Books WHERE BookID = 1;

-- Inserting a loan for:A member who doesn’t exist, A book that doesn’t exist
INSERT INTO Loans (MemberID, BookID, DueDate) VALUES (999, 1, '2025-07-01');  

-- Updating a book’s genre to: A value not included in your allowed genre list (e.g., 'Sci-Fi')
UPDATE Books SET Genre = 'Sci-Fi' WHERE BookID = 1;

-- Inserting a payment with: A zero or negative amount, A missing payment method
INSERT INTO Payments (LoanID, Amount, Method) VALUES (1, 0, 'Cash');      -- Amount zero
INSERT INTO Payments (LoanID, Amount, Method) VALUES (1, -10, 'Cash');    -- Negative amount
INSERT INTO Payments (LoanID, Amount, Method) VALUES (1, 5.00, NULL);     -- Missing method

-- Inserting a review for: A book that does not exist, A member who was never registered
INSERT INTO Reviews (MemberID, BookID, Rating, Comments) VALUES (999, 1, 4, 'Test review');  
INSERT INTO Reviews (MemberID, BookID, Rating, Comments) VALUES (1, 999, 4, 'Test review'); 

-- Updating a foreign key field (like MemberID in Loan) to a value that doesn’t exist.
UPDATE Loans SET MemberID = 999 WHERE LoanID = 1;  -- MemberID 999 does not exist

