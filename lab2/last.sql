CREATE DATABASE Auto_rental_db;

USE Auto_rental_db;

CREATE TABLE Client (
    ID INT PRIMARY KEY IDENTITY(1,1),
    FullName NVARCHAR(100) NOT NULL,
    PassportData NVARCHAR(20) NOT NULL,
    Phone NVARCHAR(20) NOT NULL,
    [Address] NVARCHAR(100)
);

CREATE TABLE Discount (
    ID INT PRIMARY KEY IDENTITY(1,1),
    Size INT NOT NULL CHECK (Size BETWEEN 0 AND 100),
    [Description] NVARCHAR(20) NOT NULL
);

CREATE TABLE RentalPoint (
    ID INT PRIMARY KEY IDENTITY(1,1),
    Revenue MONEY NOT NULL CHECK (Revenue >= 0)
);

CREATE TABLE Car (
    ID INT PRIMARY KEY IDENTITY(1,1),
    Model NVARCHAR(100) NOT NULL,
    [Year] INT NOT NULL CHECK ([Year] >= 1900 AND [Year] <= YEAR(GETDATE())),
    [Type] NVARCHAR(20) NOT NULL,
    DailyCost MONEY NOT NULL CHECK (DailyCost > 0),
    RentalPointID INT NOT NULL,
    FOREIGN KEY (RentalPointID) REFERENCES RentalPoint(ID)
);

CREATE TABLE [Return] (
    ID INT PRIMARY KEY IDENTITY(1,1),
    Fine MONEY NOT NULL CHECK (Fine >= 0),
    [Date] DATE NOT NULL DEFAULT GETDATE()
);

CREATE TABLE Deal (
    ID INT PRIMARY KEY IDENTITY(1,1),
    [Date] DATE NOT NULL DEFAULT GETDATE(),
    DaysCount INT NOT NULL CHECK (DaysCount > 0),
    TotalPrice MONEY NOT NULL CHECK (TotalPrice > 0),
    ClientID INT NOT NULL,
    DiscountID INT NULL,
    FOREIGN KEY (ClientID) REFERENCES Client(ID),
    FOREIGN KEY (DiscountID) REFERENCES Discount(ID)
);

CREATE TABLE Deal_Car (
    DealID INT NOT NULL,
    CarID INT NOT NULL,
    ReturnID INT NULL,
    PRIMARY KEY (DealID, CarID),
    FOREIGN KEY (DealID) REFERENCES Deal(ID),
    FOREIGN KEY (CarID) REFERENCES Car(ID),
    FOREIGN KEY (ReturnID) REFERENCES [Return](ID)
);

INSERT INTO Client (FullName, PassportData, Phone, [Address]) VALUES
('Андрианова Анастасия Дмитриевна', '7819 123456', '+7-966-111-34-43', 'ул. Маланова, 10, кв. 5'),
('Баикин Эдуард Александрович', '7819 234567', '+7-966-222-65-22', 'пр. Наумова, 25, кв. 12'),
('Рахимова Регина Ильдаровна', '7819 345678', '+7-966-465-33-74', 'ул. Пушкина, 5, кв. 8'),
('Козлова Елена Владимировна', '7819 456789', '+7-966-256-44-44', 'ул. Гагарина, 15, кв. 3'),
('Николаев Дмитрий Олегович', '7819 567890', '+7-966-245-56-55', 'пр. Космонавтов, 8, кв. 7'),
('Смирнова Екатерина Александровна', '7819 678901', '+7-966-689-66-66', 'ул. Володарского, 20, кв. 15'),
('Смирнов Сергей Игоревич', '7819 789012', '+7-966-777-99-77', 'ул. Лесная, 30, кв. 9'),
('Федорова Анна Дмитриевна', '7819 890123', '+7-966-969-88-97', 'пр. Победы, 45, кв. 6'),
('Яковлев Павел Викторович', '7819 901234', '+7-966-986-99-99', 'ул. Центральная, 12, кв. 11'),
('Зиновьева Юлия Сергеевна', '7819 012345', '+7-966-240-99-00', 'ул. Карла Маркса, 7, кв. 4');

INSERT INTO Discount (Size, [Description]) VALUES
(5, 'Новичок'),
(10, 'Постоянный клиент'),
(25, 'VIP клиент');

INSERT INTO RentalPoint (Revenue) VALUES
(250000.00),
(180000.50),
(320000.75),
(150000.25),
(275000.00),
(190000.80),
(210000.40),
(165000.60),
(280000.90),
(195000.30);

INSERT INTO Car (Model, [Year], [Type], DailyCost, RentalPointID) VALUES
('Volkswagen Passat', 2021, 'Седан', 2600.00, 1),
('Skoda Fabia', 2022, 'Хэтчбек', 1850.00, 2),
('Hyundai Elantra', 2023, 'Седан', 1950.00, 3),
('Lada Granta', 2022, 'Седан', 1250.00, 4),
('Volvo V60', 2023, 'Универсал', 2900.00, 5),
('Kia Sorento', 2022, 'Внедорожник', 2300.00, 6),
('Audi Q7', 2023, 'Кроссовер', 5600.00, 7),
('BMW 5 Series', 2022, 'Седан', 5100.00, 8),
('Toyota RAV4', 2021, 'Кроссовер', 2400.00, 9),
('Ford Focus', 2023, 'Хэтчбек', 1750.00, 10),
('Mercedes Vito', 2022, 'Минивэн', 3100.00, 1),
('BMW 4 Series', 2023, 'Купе', 4600.00, 2),
('Lexus LX', 2022, 'Внедорожник', 6100.00, 3),
('Kia K5', 2023, 'Седан', 2150.00, 4),
('Mazda 3', 2022, 'Хэтчбек', 2000.00, 5);

INSERT INTO [Return] (Fine, [Date]) VALUES
(0, '2025-02-15'),
(1500.00, '2025-02-20'),
(0, '2025-02-05'),
(500.00, '2025-02-12'),
(2000.00, '2025-02-18'),
(0, '2025-02-25'),
(750.00, '2025-02-02'),
(0, '2025-02-10'),
(1200.00, '2025-02-15'),
(0, '2025-02-20'),
(800.00, '2025-02-25'),
(0, '2025-02-01'),
(1600.00, '2025-02-08'),
(0, '2025-02-15'),
(900.00, '2025-02-22');

INSERT INTO Deal ([Date], DaysCount, TotalPrice, ClientID, DiscountID) VALUES
('2025-02-01', 5, 12350.00, 1, 1),
('2025-02-02', 3, 5265.00, 1, 2),
('2025-02-03', 4, 7400.00, 2, NULL),
('2025-02-04', 7, 18270.00, 2, 2),
('2025-02-05', 6, 7500.00, 3, NULL),
('2025-02-06', 2, 8400.00, 3, 3),
('2025-02-07', 10, 20700.00, 4, 2),
('2025-03-08', 5, 12000.00, 4, NULL),
('2025-03-09', 8, 30600.00, 5, 3),
('2025-03-10', 3, 5250.00, 5, NULL),
('2025-03-11', 4, 11160.00, 6, 2),
('2025-03-12', 2, 12200.00, 6, NULL),
('2025-04-13', 6, 24840.00, 7, 2),
('2025-04-14', 7, 15050.00, 7, NULL),
('2025-04-15', 14, 26600.00, 8, 1);

INSERT INTO Deal_Car (DealID, CarID, ReturnID) VALUES
(1, 1, 1),
(2, 3, 2),
(3, 2, 3),
(4, 5, 4),
(5, 4, 5),
(6, 7, 6),
(7, 6, 7),
(8, 9, 8),
(9, 8, 9),
(10, 10, 10),
(11, 11, 11),
(12, 13, 12),
(13, 12, 13),
(14, 14, 14),
(15, 15, 15);
