# --Help dialog--
HELP_MSG = '''
Our seven typical scenarios:
1. Browsing Books: Retrieve books by title, author, genre, and availability
2. Room Rentals: Check available rooms for booking
3. Browse Equipment: View equipment available for rent
4. View Holds: Show all active book holds
5. Viewing/Updating Patron Data: Retrieve a patron's checkouts, holds, and balance
6. View/Analyze Trends: Count overdue checkouts and popular book rentals
7: View Overdue Books and Associated Penalties

Our five analytical queries:
1. Most Frequently Rented Equipment
2. Most Popular Times of Day for Events
3. Most Popular Book Genres by Month
4. Most Active Patrons by Checkouts
5. Total Revenue from Fines
'''

# --Queries--
SCENARIO1 = '''
SELECT B.ISBN, B.Title, B.Edition, B.Synopsis, G.GenreName, A.FirstName, A.LastName, 
(SELECT COUNT(*) FROM BOOK_COPIES C WHERE C.ISBN = B.ISBN AND C.Status = 'Available') AS AvailableCopies
FROM BOOKS B
JOIN GENRES G ON B.GenreID = G.GenreID
JOIN BOOK_AUTHORS BA ON B.ISBN = BA.ISBN
JOIN AUTHORS A ON BA.AuthorID = A.AuthorID
ORDER BY B.Title;
'''

SCENARIO2 = '''
SELECT RoomNumberID, Capacity, Amenities, BookingStatus
FROM EVENT_ROOMS
WHERE BookingStatus = 'Available';
'''

SCENARIO3 = '''
SELECT E.EquipmentID, E.Name, E.Location, E.Condition
FROM EQUIPMENT_RENTALS E
LEFT JOIN ROOM_EQUIPMENTS RE ON E.EquipmentID = RE.EquipmentID
WHERE RE.Status = 'Functional' OR RE.Status IS NULL;
'''

SCENARIO4 = '''
SELECT H.HoldID, H.DatePlaced, H.SpotInQueue, H.Status, P.FirstName, P.LastName, B.Title
FROM BOOK_HOLDS H
JOIN PATRONS P ON H.PatronID = P.PatronID
JOIN BOOK_COPIES C ON H.CopyID = C.CopyID
JOIN BOOKS B ON C.ISBN = B.ISBN
WHERE H.Status = 'Active'
ORDER BY H.DatePlaced;
'''

SCENARIO5 = '''
SELECT P.PatronID, P.FirstName, P.LastName, P.PhoneNumber, P.Balance, 
       (SELECT COUNT(*) FROM CHECKOUTS C WHERE C.PatronID = P.PatronID AND C.Status = 'Checked Out') AS ActiveCheckouts,
       (SELECT COUNT(*) FROM BOOK_HOLDS H WHERE H.PatronID = P.PatronID AND H.Status = 'Active') AS ActiveHolds
FROM PATRONS P
ORDER BY P.LastName;
'''

SCENARIO6 = '''
SELECT B.Title, COUNT(C.CheckoutID) AS TotalCheckouts
FROM CHECKOUTS C
JOIN BOOK_COPIES BC ON C.CopyID = BC.CopyID
JOIN BOOKS B ON BC.ISBN = B.ISBN
GROUP BY B.Title
ORDER BY TotalCheckouts DESC;
'''

SCENARIO7 = '''
SELECT C.CheckoutID, P.FirstName, P.LastName, B.Title, BC.CopyID, C.Status, PE.Amount, PE.Status AS PenaltyStatus
FROM CHECKOUTS C
JOIN PATRONS P ON C.PatronID = P.PatronID
JOIN BOOK_COPIES BC ON C.CopyID = BC.CopyID
JOIN BOOKS B ON BC.ISBN = B.ISBN
LEFT JOIN PENALTIES PE ON C.CopyID = PE.CopyID
WHERE C.Status = 'Overdue'
ORDER BY PE.Amount DESC, P.LastName;
'''

ANALYTICAL1 = '''
SELECT E.Name, COUNT(RE.RoomNumberID) AS RentalCount
FROM EQUIPMENT_RENTALS E
JOIN ROOM_EQUIPMENTS RE ON E.EquipmentID = RE.EquipmentID
GROUP BY E.Name
ORDER BY RentalCount DESC;
'''

ANALYTICAL2 = '''
SELECT FORMAT(B.Time, 'HH:00') AS EventHour, COUNT(*) AS EventCount
FROM BOOKINGS B
GROUP BY FORMAT(B.Time, 'HH:00')
ORDER BY EventCount DESC;
'''

ANALYTICAL3 = '''
SELECT DATEPART(YEAR, C.CheckoutID) AS Year,
       DATEPART(MONTH, C.CheckoutID) AS Month,
       G.GenreName,
       COUNT(*) AS GenreCheckouts
FROM CHECKOUTS C
JOIN BOOK_COPIES BC ON C.CopyID = BC.CopyID
JOIN BOOKS B ON BC.ISBN = B.ISBN
JOIN GENRES G ON B.GenreID = G.GenreID
GROUP BY DATEPART(YEAR, C.CheckoutID), DATEPART(MONTH, C.CheckoutID), G.GenreName
ORDER BY Year DESC, Month DESC, GenreCheckouts DESC;
'''

ANALYTICAL4 = '''
SELECT P.PatronID, P.FirstName, P.LastName, COUNT(C.CheckoutID) AS TotalCheckouts
FROM CHECKOUTS C
JOIN PATRONS P ON C.PatronID = P.PatronID
GROUP BY P.PatronID, P.FirstName, P.LastName
ORDER BY TotalCheckouts DESC;
'''

ANALYTICAL5 = '''
SELECT SUM(Amount) AS TotalFineRevenue
FROM PENALTIES
WHERE Status = 'Paid';
'''