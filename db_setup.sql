-- DATABASE SETUP
CREATE DATABASE LibraryProject;
GO
USE LibraryProject;
GO

-- STAFF MEMBERS
CREATE TABLE STAFF_MEMBERS 
(
  StaffID INT IDENTITY(1,1) PRIMARY KEY,
  FirstName VARCHAR(50) NOT NULL,
  LastName VARCHAR(50) NOT NULL,
  Position VARCHAR(100) NOT NULL,
  ContactPhone VARCHAR(15) CHECK (ContactPhone LIKE '[0-9]%') NOT NULL
);
GO

-- PATRONS
CREATE TABLE PATRONS
(
  PatronID INT IDENTITY(1,1) PRIMARY KEY,
  FirstName VARCHAR(50) NOT NULL,
  LastName VARCHAR(50) NOT NULL,
  CheckedOutMedia INT DEFAULT 0 NOT NULL,
  PhoneNumber VARCHAR(15) CHECK (PhoneNumber LIKE '[0-9]%') NOT NULL,
  Balance DECIMAL(10,2) DEFAULT 0 CHECK (Balance >= 0) NOT NULL
);
GO

-- AUTHORS
CREATE TABLE AUTHORS
(
  AuthorID INT IDENTITY(1,1) PRIMARY KEY,
  FirstName VARCHAR(50) NOT NULL,
  LastName VARCHAR(50) NOT NULL
);
GO

-- GENRES
CREATE TABLE GENRES
(
  GenreID INT IDENTITY(1,1) PRIMARY KEY,
  GenreName VARCHAR(100) NOT NULL,
  Description TEXT NOT NULL
);
GO

-- LIBRARY SECTIONS
CREATE TABLE LIBRARY_SECTIONS
(
  SectionID INT IDENTITY(1,1) PRIMARY KEY,
  Name VARCHAR(100) NOT NULL,
  Description TEXT NOT NULL,
  Location VARCHAR(100) NOT NULL
);
GO

-- EVENT TYPES
CREATE TABLE EVENT_TYPES
(
  EventTypeID INT IDENTITY(1,1) PRIMARY KEY,
  TypeName VARCHAR(100) NOT NULL,
  Description TEXT NOT NULL
);
GO

-- EQUIPMENT RENTALS
CREATE TABLE EQUIPMENT_RENTALS
(
  EquipmentID INT IDENTITY(1,1) PRIMARY KEY,
  Name VARCHAR(100) NOT NULL,
  Location VARCHAR(100) NOT NULL,
  Condition VARCHAR(50) NOT NULL
);
GO

-- BOOKS
CREATE TABLE BOOKS
(
  ISBN VARCHAR(13) PRIMARY KEY,
  Edition VARCHAR(20) NOT NULL,
  Title VARCHAR(200) NOT NULL,
  Synopsis TEXT NOT NULL,
  GenreID INT NOT NULL,
  SectionID INT NOT NULL,
  FOREIGN KEY (GenreID) REFERENCES GENRES(GenreID),
  FOREIGN KEY (SectionID) REFERENCES LIBRARY_SECTIONS(SectionID)
);
GO

-- BOOK COPIES
CREATE TABLE BOOK_COPIES
(
  CopyID INT IDENTITY(1,1) PRIMARY KEY,
  ISBN VARCHAR(13) NOT NULL,
  Status VARCHAR(20) CHECK (Status IN ('Available', 'Checked Out', 'Lost', 'Damaged')) NOT NULL,
  FOREIGN KEY (ISBN) REFERENCES BOOKS(ISBN)
);
GO

-- BOOK AUTHORS
CREATE TABLE BOOK_AUTHORS
(
  AuthorID INT NOT NULL,
  ISBN VARCHAR(13) NOT NULL,
  AuthorType VARCHAR(50) NOT NULL,
  PRIMARY KEY (AuthorID, ISBN),
  FOREIGN KEY (AuthorID) REFERENCES AUTHORS(AuthorID),
  FOREIGN KEY (ISBN) REFERENCES BOOKS(ISBN)
);
GO

-- EVENT ROOMS
CREATE TABLE EVENT_ROOMS
(
  RoomNumberID INT IDENTITY(1,1) PRIMARY KEY,
  Capacity INT CHECK (Capacity > 0) NOT NULL,
  Amenities TEXT NOT NULL,
  BookingStatus VARCHAR(20) CHECK (BookingStatus IN ('Available', 'Booked', 'Maintenance')) NOT NULL
);
GO

-- LIBRARY EVENTS
CREATE TABLE LIBRARY_EVENTS
(
  EventID INT IDENTITY(1,1) PRIMARY KEY,
  EventName VARCHAR(100) NOT NULL,
  EventDate DATE NOT NULL,
  EventTypeID INT NOT NULL,
  StaffID INT NOT NULL,
  FOREIGN KEY (EventTypeID) REFERENCES EVENT_TYPES(EventTypeID),
  FOREIGN KEY (StaffID) REFERENCES STAFF_MEMBERS(StaffID)
);
GO

-- EVENT PARTICIPANTS
CREATE TABLE EVENT_PARTICIPANTS
(
  PatronID INT NOT NULL,
  EventID INT NOT NULL,
  RegistrationDate DATE NOT NULL,
  PRIMARY KEY (PatronID, EventID),
  FOREIGN KEY (PatronID) REFERENCES PATRONS(PatronID),
  FOREIGN KEY (EventID) REFERENCES LIBRARY_EVENTS(EventID)
);
GO

-- ROOM EQUIPMENTS
CREATE TABLE ROOM_EQUIPMENTS
(
  RoomNumberID INT NOT NULL,
  EquipmentID INT NOT NULL,
  Status VARCHAR(50) NOT NULL,
  PRIMARY KEY (RoomNumberID, EquipmentID),
  FOREIGN KEY (RoomNumberID) REFERENCES EVENT_ROOMS(RoomNumberID),
  FOREIGN KEY (EquipmentID) REFERENCES EQUIPMENT_RENTALS(EquipmentID)
);
GO

-- BOOK HOLDS
CREATE TABLE BOOK_HOLDS
(
  HoldID INT IDENTITY(1,1) PRIMARY KEY,
  DatePlaced DATE NOT NULL,
  SpotInQueue INT CHECK (SpotInQueue > 0) NOT NULL,
  Status VARCHAR(20) CHECK (Status IN ('Active', 'Fulfilled', 'Canceled')) NOT NULL,
  PatronID INT NOT NULL,
  CopyID INT NOT NULL,
  FOREIGN KEY (PatronID) REFERENCES PATRONS(PatronID),
  FOREIGN KEY (CopyID) REFERENCES BOOK_COPIES(CopyID)
);
GO

-- CHECKOUTS
CREATE TABLE CHECKOUTS
(
  CheckoutID INT IDENTITY(1,1) PRIMARY KEY,
  Status VARCHAR(20) CHECK (Status IN ('Checked Out', 'Returned', 'Overdue')) NOT NULL,
  PatronID INT NOT NULL,
  StaffID INT NOT NULL,
  CopyID INT NOT NULL,
  FOREIGN KEY (PatronID) REFERENCES PATRONS(PatronID),
  FOREIGN KEY (StaffID) REFERENCES STAFF_MEMBERS(StaffID),
  FOREIGN KEY (CopyID) REFERENCES BOOK_COPIES(CopyID)
);
GO

-- PENALTIES
CREATE TABLE PENALTIES
(
  PenaltyID INT IDENTITY(1,1) PRIMARY KEY,
  Amount DECIMAL(10,2) CHECK (Amount >= 0) NOT NULL,
  Reason TEXT NOT NULL,
  Status VARCHAR(20) CHECK (Status IN ('Pending', 'Paid', 'Waived')) NOT NULL,
  CopyID INT NOT NULL,
  PatronID INT NOT NULL,
  FOREIGN KEY (CopyID) REFERENCES BOOK_COPIES(CopyID),
  FOREIGN KEY (PatronID) REFERENCES PATRONS(PatronID)
);
GO

-- BOOKINGS
CREATE TABLE BOOKINGS
(
  BookingID INT IDENTITY(1,1) PRIMARY KEY,
  Date DATE NOT NULL,
  Time TIME NOT NULL,
  PatronID INT NOT NULL,
  RoomNumberID INT NOT NULL,
  FOREIGN KEY (PatronID) REFERENCES PATRONS(PatronID),
  FOREIGN KEY (RoomNumberID) REFERENCES EVENT_ROOMS(RoomNumberID)
);
GO

-- Data Entry Block

-- INSERT STAFF MEMBERS
INSERT INTO STAFF_MEMBERS (FirstName, LastName, Position, ContactPhone) VALUES
('John', 'Doe', 'Librarian', '1234567890'),
('Jane', 'Smith', 'Library Manager', '0987654321'),
('Michael', 'Johnson', 'Librarian', '5551112233'),
('Emily', 'Davis', 'Librarian', '4442223333'),
('David', 'Wilson', 'Library Manager', '6667778888'),
('Sarah', 'Miller', 'Librarian', '9998887777');

-- INSERT PATRONS
INSERT INTO PATRONS (FirstName, LastName, CheckedOutMedia, PhoneNumber, Balance) VALUES
('Alice', 'Brown', 2, '1112223333', 5.00),
('Bob', 'Johnson', 0, '4445556666', 0.00),
('Charlie', 'Evans', 3, '2223334444', 2.50),
('Diana', 'Wright', 1, '5556667777', 0.00),
('Edward', 'Harris', 4, '6667778888', 8.75),
('Fiona', 'Anderson', 0, '7778889999', 0.00),
('George', 'Thompson', 2, '8889990000', 1.50);

-- INSERT AUTHORS
INSERT INTO AUTHORS (FirstName, LastName) VALUES
('George', 'Orwell'),
('Jane', 'Austen'),
('J.K.', 'Rowling'),
('Isaac', 'Asimov'),
('Mark', 'Twain'),
('Mary', 'Shelley');

-- INSERT GENRES
INSERT INTO GENRES (GenreName, Description) VALUES
('Science Fiction', 'Fictional stories with futuristic elements'),
('Classic', 'Literary works recognized for enduring significance'),
('Mystery', 'Stories focused on solving crimes or puzzles'),
('Fantasy', 'Magical and supernatural storytelling'),
('Non-Fiction', 'Books based on real events, facts, and biographies');

-- INSERT LIBRARY SECTIONS
INSERT INTO LIBRARY_SECTIONS (Name, Description, Location) VALUES
('Main Hall', 'General books collection', 'First Floor'),
('Archives', 'Historical records and rare books', 'Basement'),
('Children�s Section', 'Books for young readers', 'Second Floor'),
('Reference Section', 'Dictionaries, encyclopedias, and research materials', 'First Floor'),
('Reading Lounge', 'Cozy area with seating and magazines', 'Third Floor');

-- INSERT EVENT TYPES
INSERT INTO EVENT_TYPES (TypeName, Description) VALUES
('Author Talk', 'Meet and greet with authors discussing their books'),
('Workshop', 'Interactive learning session on various topics'),
('Story Time', 'Reading session for children and families');

-- INSERT INTO EQUIPMENT_RENTALS
INSERT INTO EQUIPMENT_RENTALS (Name, Location, Condition) VALUES
('Projector', 'Conference Room', 'Good'),
('Microphone', 'Lecture Hall', 'Excellent'),
('Whiteboard', 'Study Room', 'Good'),
('Laptop', 'Reference Section', 'Fair'),
('Headphones', 'Media Room', 'Excellent');

-- INSERT BOOKS
INSERT INTO BOOKS (ISBN, Edition, Title, Synopsis, GenreID, SectionID) VALUES
('9780451524935', '1st', '1984', 'Dystopian social science fiction novel', 1, 1),
('9780141439518', '2nd', 'Pride and Prejudice', 'Romantic novel of manners', 2, 1),
('9780747532743', '3rd', 'Harry Potter and the Sorcerer�s Stone', 'A young wizard�s journey', 4, 3),
('9780553293357', '5th', 'Foundation', 'A science fiction masterpiece on galactic empire', 1, 1),
('9780061120084', '4th', 'To Kill a Mockingbird', 'A classic novel of racial injustice', 2, 1),
('9780060850524', '1st', 'The Time Machine', 'A scientist�s journey through time', 1, 2),
('9780345339706', '1st', 'The Hobbit', 'A fantasy adventure about a hobbit', 4, 3),
('9780316769488', '3rd', 'The Catcher in the Rye', 'Coming-of-age story of Holden Caulfield', 2, 1),
('9780380977284', '1st', 'American Gods', 'A tale of mythology and modern America', 4, 1),
('9780671023379', '2nd', 'The Art of War', 'Classic military strategy book', 5, 4);

-- INSERT BOOK COPIES
INSERT INTO BOOK_COPIES (ISBN, Status) VALUES
('9780451524935', 'Available'),
('9780451524935', 'Checked Out'),
('9780141439518', 'Available'),
('9780747532743', 'Checked Out'),
('9780553293357', 'Available'),
('9780061120084', 'Lost'),
('9780060850524', 'Available'),
('9780345339706', 'Checked Out'),
('9780316769488', 'Available'),
('9780380977284', 'Available');

-- INSERT BOOK AUTHORS
INSERT INTO BOOK_AUTHORS (AuthorID, ISBN, AuthorType) VALUES
(1, '9780451524935', 'Primary'),
(2, '9780141439518', 'Co-Author'),
(3, '9780747532743', 'Primary'),
(4, '9780553293357', 'Contributor'),
(5, '9780061120084', 'Primary'),
(6, '9780060850524', 'Co-Author');

-- INSERT EVENT ROOMS
INSERT INTO EVENT_ROOMS (Capacity, Amenities, BookingStatus) VALUES
(50, 'Spacious room with natural light, ideal for meetings.', 'Available'),
(30, 'Private study space with comfortable seating.', 'Booked'),
(75, 'Large event hall with a projector and speakers.', 'Available'),
(20, 'Quiet study room with individual desks.', 'Booked'),
(40, 'Multipurpose conference room with whiteboards.', 'Maintenance');

-- INSERT LIBRARY EVENTS
INSERT INTO LIBRARY_EVENTS (EventName, EventDate, EventTypeID, StaffID) VALUES
('Sci-Fi Book Night', '2024-03-10', 1, 1),
('Writing Workshop', '2024-04-15', 2, 2),
('Children�s Story Time', '2024-05-20', 1, 3),
('Author Meet & Greet', '2024-06-05', 2, 4),
('Library Tour', '2024-07-01', 1, 5);

-- INSERT EVENT PARTICIPANTS
INSERT INTO EVENT_PARTICIPANTS (PatronID, EventID, RegistrationDate) VALUES
(1, 1, '2024-02-15'),
(2, 2, '2024-02-20'),
(3, 3, '2024-02-25'),
(4, 4, '2024-03-01'),
(5, 5, '2024-03-05');

-- INSERT INTO ROOM_EQUIPMENTS
INSERT INTO ROOM_EQUIPMENTS (RoomNumberID, EquipmentID, Status) VALUES
(1, 1, 'Functional'),
(2, 2, 'Needs Maintenance'),
(3, 3, 'Functional'),
(4, 4, 'Functional'),
(5, 5, 'Functional');

-- INSERT BOOK HOLDS
INSERT INTO BOOK_HOLDS (DatePlaced, SpotInQueue, Status, PatronID, CopyID) VALUES
('2024-02-01', 1, 'Active', 2, 1),
('2024-02-05', 2, 'Active', 3, 4);

-- INSERT CHECKOUTS
INSERT INTO CHECKOUTS (Status, PatronID, StaffID, CopyID) VALUES
('Checked Out', 1, 1, 2),
('Checked Out', 3, 2, 4),
('Returned', 4, 3, 6),
('Overdue', 5, 4, 8),
('Checked Out', 6, 5, 9);

-- INSERT PENALTIES
INSERT INTO PENALTIES (Amount, Reason, Status, PatronID, CopyID) VALUES
(10.00, 'Overdue Book', 'Pending', 1, 2),
(5.00, 'Damaged Cover', 'Paid', 3, 6),
(7.50, 'Lost Book', 'Pending', 5, 8),
(2.00, 'Late Return', 'Waived', 6, 9),
(15.00, 'Severe Damage', 'Pending', 2, 4);

-- INSERT INTO BOOKINGS
INSERT INTO BOOKINGS (Date, Time, PatronID, RoomNumberID) VALUES
('2024-05-01', '10:00:00', 1, 2),
('2024-06-15', '14:30:00', 3, 3),
('2024-07-10', '09:00:00', 4, 4),
('2024-08-01', '12:00:00', 5, 5),
('2024-09-05', '15:00:00', 2, 1);
