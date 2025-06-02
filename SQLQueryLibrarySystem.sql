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

--------------------------
-- Advanced SELECT Queries
--------------------------

-- List top 3 books by number of times they were loaned
SELECT TOP 3 B.BookID, B.Title, COUNT(L.LoanID) AS TimesLoaned
FROM Books AS B
JOIN Loans AS L ON B.BookID = L.BookID
GROUP BY B.BookID, B.Title
ORDER BY COUNT(L.LoanID) DESC;

-- Retrieve full loan history of a specific member including book title, loan & return dates
DECLARE @MemberID INT = 3;
SELECT L.LoanID, B.Title AS BookTitle, L.LoanDate, L.ReturnDate, L.LoanStatus
FROM Loans AS L
JOIN Books AS B ON L.BookID = B.BookID
WHERE L.MemberID = @MemberID
ORDER BY L.LoanDate DESC;

-- Show all reviews for a book with member name and comments
DECLARE @BookID INT = 2;
SELECT R.ReviewID, M.FullName AS MemberName, R.Rating, R.Comments, R.ReviewDate
FROM Reviews AS R
JOIN Members AS M ON R.MemberID = M.MemberID
WHERE R.BookID = @BookID
ORDER BY R.ReviewDate DESC;

-- List all staff working in a given library
DECLARE @LibraryID INT = 1;
SELECT StaffID, FullName, Position, ContactNumber
FROM Staff
WHERE LibraryID = @LibraryID;

-- Show books whose prices fall within a given range
DECLARE @MinPrice DECIMAL(8,2) = 5.00, @MaxPrice DECIMAL(8,2) = 15.00;
SELECT BookID, Title, Price
FROM Books
WHERE Price BETWEEN @MinPrice AND @MaxPrice;

-- List all currently active loans (not yet returned) with member and book info
SELECT L.LoanID, M.FullName, B.Title, L.LoanDate, L.DueDate
FROM Loans AS L
JOIN Members AS M ON L.MemberID = M.MemberID
JOIN Books AS B ON L.BookID = B.BookID
WHERE L.LoanStatus = 'Issued';

-- List members who have paid any fine
SELECT DISTINCT M.MemberID, M.FullName
FROM Payments AS P
JOIN Loans AS L ON P.LoanID = L.LoanID
JOIN Members AS M ON L.MemberID = M.MemberID;

-- List books that have never been reviewed
SELECT B.BookID, B.Title
FROM Books AS B
LEFT JOIN Reviews AS R ON B.BookID = R.BookID
WHERE R.ReviewID IS NULL;

-- Show a member’s loan history with book titles and loan status
DECLARE @MemberLoanID INT = 2;
SELECT L.LoanID, B.Title AS BookTitle, L.LoanStatus
FROM Loans AS L
JOIN Books AS B ON L.BookID = B.BookID
WHERE L.MemberID = @MemberLoanID;

-- List all members who have never borrowed any book
SELECT M.MemberID, M.FullName
FROM Members AS M
LEFT JOIN Loans AS L ON M.MemberID = L.MemberID
WHERE L.LoanID IS NULL;

-- List books that were never loaned
SELECT B.BookID, B.Title
FROM Books AS B
LEFT JOIN Loans AS L ON B.BookID = L.BookID
WHERE L.LoanID IS NULL;

-- List all payments with member name and book title
SELECT P.PaymentID, M.FullName, B.Title, P.Amount, P.Method, P.PaymentDate
FROM Payments AS P
JOIN Loans AS L ON P.LoanID = L.LoanID
JOIN Members AS M ON L.MemberID = M.MemberID
JOIN Books AS B ON L.BookID = B.BookID;

-- List all overdue loans with member and book details
SELECT L.LoanID, M.FullName, B.Title, L.DueDate
FROM Loans AS L
JOIN Members AS M ON L.MemberID = M.MemberID
JOIN Books AS B ON L.BookID = B.BookID
WHERE L.LoanStatus = 'Overdue';

-- Show how many times a book has been loaned
DECLARE @LoanBookID INT = 1;
SELECT B.BookID, B.Title, COUNT(L.LoanID) AS LoanCount
FROM Books AS B
LEFT JOIN Loans AS L ON B.BookID = L.BookID
WHERE B.BookID = @LoanBookID
GROUP BY B.BookID, B.Title;

-- Get total fines paid by a member across all loans
DECLARE @FineMemberID INT = 2;
SELECT M.MemberID, M.FullName, SUM(P.Amount) AS TotalFines
FROM Payments AS P
JOIN Loans AS L ON P.LoanID = L.LoanID
JOIN Members AS M ON L.MemberID = M.MemberID
WHERE M.MemberID = @FineMemberID
GROUP BY M.MemberID, M.FullName;

-- Show count of available and unavailable books in a library
DECLARE @StatsLibraryID INT = 1;
SELECT 
    LibraryID,
    SUM(CASE WHEN IsAvailable = 1 THEN 1 ELSE 0 END) AS AvailableBooks,
    SUM(CASE WHEN IsAvailable = 0 THEN 1 ELSE 0 END) AS UnavailableBooks
FROM Books
WHERE LibraryID = @StatsLibraryID
GROUP BY LibraryID;

-- Return books with more than 5 reviews and average rating > 4.5
SELECT B.BookID, B.Title, COUNT(R.ReviewID) AS ReviewCount, AVG(R.Rating) AS AvgRating
FROM Books AS B
JOIN Reviews AS R ON B.BookID = R.BookID
GROUP BY B.BookID, B.Title
HAVING COUNT(R.ReviewID) > 5 AND AVG(R.Rating) > 4.5;

------------------------
-- Simple Views Practice
------------------------

-- 1. ViewAvailableBooks: A list of all books marked as available
CREATE VIEW ViewAvailableBooks AS
SELECT BookID, ISBN, Title, Genre, Price, ShelfLocation, LibraryID
FROM Books
WHERE IsAvailable = 1;
-- Testing the view
SELECT * FROM ViewAvailableBooks;

-- 2. ViewActiveMembers: Members whose membership started in the past 12 months
CREATE VIEW ViewActiveMembers AS
SELECT MemberID, FullName, Email, PhoneNumber, MembershipDate
FROM Members
WHERE MembershipDate >= DATEADD(YEAR, -1, GETDATE());
-- Testing the view
SELECT * FROM ViewActiveMembers;

-- 3. ViewLibraryContacts: List of libraries and their contact numbers
CREATE VIEW ViewLibraryContacts AS
SELECT LibraryID, Name AS LibraryName, ContactNumber
FROM Libraries;
-- Testing the view
SELECT * FROM ViewLibraryContacts;

--------------------------
-- Transactions Simulation
--------------------------
BEGIN TRANSACTION;

BEGIN TRY
    DECLARE 
        @MemberID INT = 3,
        @BookID   INT = 3,
        @DueDate  DATE = DATEADD(DAY, 14, GETDATE());  -- e.g., 2 weeks from today

    -- 1. Insert a new loan record
    INSERT INTO Loans (MemberID, BookID, DueDate)
    VALUES (@MemberID, @BookID, @DueDate);

    -- 2. Update the book’s availability to FALSE (0)
    UPDATE Books
    SET IsAvailable = 0
    WHERE BookID = @BookID;

    -- 3. If both succeed, commit
    COMMIT TRANSACTION;
END TRY
BEGIN CATCH
    -- If any error occurs, roll back
    ROLLBACK TRANSACTION;

    DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
    PRINT 'Transaction failed: ' + @ErrorMessage;
END CATCH;

---------------------------------
-- Aggregation Functions Practice
---------------------------------
-- 1. Count total books in each genre
SELECT Genre, COUNT(BookID) AS TotalBooks
FROM Books
GROUP BY Genre
ORDER BY TotalBooks DESC;

-- 2. Average rating per book
SELECT B.BookID, B.Title, AVG(CAST(R.Rating AS DECIMAL(3,2))) AS AvgRating, COUNT(R.ReviewID) AS ReviewCount
FROM Books AS B
LEFT JOIN Reviews AS R ON B.BookID = R.BookID
GROUP BY B.BookID, B.Title
ORDER BY AvgRating DESC;

-- 3. Total fine paid by each member
SELECT M.MemberID, M.FullName, COALESCE(SUM(P.Amount), 0) AS TotalFinePaid
FROM Members AS M
LEFT JOIN Loans AS L ON M.MemberID = L.MemberID
LEFT JOIN Payments AS P ON L.LoanID = P.LoanID
GROUP BY M.MemberID, M.FullName
ORDER BY TotalFinePaid DESC;

-- 4. Highest payment ever made (single payment)
SELECT MAX(Amount) AS HighestPayment
FROM Payments;

-- 5. Number of loans per member
SELECT M.MemberID, M.FullName, COUNT(L.LoanID) AS LoanCount
FROM Members AS M
LEFT JOIN Loans AS L ON M.MemberID = L.MemberID
GROUP BY M.MemberID, M.FullName
ORDER BY LoanCount DESC;
