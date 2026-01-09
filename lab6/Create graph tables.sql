USE Auto_rental_db;
GO

CREATE TABLE ClientNode (
    id INT PRIMARY KEY,
    FullName NVARCHAR(100),
    PassportData NVARCHAR(20),
    Phone NVARCHAR(20),
    [Address] NVARCHAR(100)
) AS NODE;

CREATE TABLE CarNode (
    id INT PRIMARY KEY,
    Model NVARCHAR(100),
    [Year] INT,
    [Type] NVARCHAR(20),
    DailyCost MONEY
) AS NODE;

CREATE TABLE DealNode (
    id INT PRIMARY KEY,
    [Date] DATE,
    DaysCount INT,
    TotalPrice MONEY
) AS NODE;

CREATE TABLE ReturnNode (
    id INT PRIMARY KEY,
    Fine MONEY,
    [Date] DATE
) AS NODE;

CREATE TABLE DiscountNode (
    id INT PRIMARY KEY,
    Size INT,
    [Description] NVARCHAR(20)
) AS NODE;

CREATE TABLE RentalPointNode (
    id INT PRIMARY KEY,
    Revenue MONEY
) AS NODE;

CREATE TABLE MakesDeal AS EDGE;           -- Client -> Deal
CREATE TABLE IncludesCar AS EDGE;         -- Deal -> Car
CREATE TABLE HasReturn AS EDGE;           -- Deal -> Return
CREATE TABLE UsesDiscount AS EDGE;        -- Deal -> Discount
CREATE TABLE LocatedAt AS EDGE;           -- Car -> RentalPoint
CREATE TABLE BelongsToPoint AS EDGE;      -- Deal -> RentalPoint

INSERT INTO ClientNode (id, FullName, PassportData, Phone, [Address])
SELECT ID, FullName, PassportData, Phone, [Address] FROM Client;

INSERT INTO CarNode (id, Model, [Year], [Type], DailyCost)
SELECT ID, Model, [Year], [Type], DailyCost FROM Car;

INSERT INTO DealNode (id, [Date], DaysCount, TotalPrice)
SELECT ID, [Date], DaysCount, TotalPrice FROM Deal;

INSERT INTO ReturnNode (id, Fine, [Date])
SELECT ID, Fine, [Date] FROM [Return];

INSERT INTO DiscountNode (id, Size, [Description])
SELECT ID, Size, [Description] FROM Discount;

INSERT INTO RentalPointNode (id, Revenue)
SELECT ID, Revenue FROM RentalPoint;

INSERT INTO MakesDeal ($from_id, $to_id)
SELECT 
    cn.$node_id,
    dn.$node_id
FROM Deal d
INNER JOIN ClientNode cn ON d.ClientID = cn.id
INNER JOIN DealNode dn ON d.ID = dn.id;

INSERT INTO IncludesCar ($from_id, $to_id)
SELECT 
    dn.$node_id,
    cn.$node_id
FROM Deal_Car dc
INNER JOIN DealNode dn ON dc.DealID = dn.id
INNER JOIN CarNode cn ON dc.CarID = cn.id;

INSERT INTO HasReturn ($from_id, $to_id)
SELECT 
    dn.$node_id,
    rn.$node_id
FROM Deal_Car dc
INNER JOIN DealNode dn ON dc.DealID = dn.id
INNER JOIN ReturnNode rn ON dc.ReturnID = rn.id
WHERE dc.ReturnID IS NOT NULL;

INSERT INTO UsesDiscount ($from_id, $to_id)
SELECT 
    dn.$node_id,
    discn.$node_id
FROM Deal d
INNER JOIN DealNode dn ON d.ID = dn.id
INNER JOIN DiscountNode discn ON d.DiscountID = discn.id
WHERE d.DiscountID IS NOT NULL;

INSERT INTO LocatedAt ($from_id, $to_id)
SELECT 
    cn.$node_id,
    rpn.$node_id
FROM Car c
INNER JOIN CarNode cn ON c.ID = cn.id
INNER JOIN RentalPointNode rpn ON c.RentalPointID = rpn.id;

INSERT INTO BelongsToPoint ($from_id, $to_id)
SELECT DISTINCT
    dn.$node_id,
    rpn.$node_id
FROM Deal_Car dc
INNER JOIN DealNode dn ON dc.DealID = dn.id
INNER JOIN CarNode cn ON dc.CarID = cn.id
INNER JOIN Car c ON cn.id = c.ID
INNER JOIN RentalPointNode rpn ON c.RentalPointID = rpn.id;

