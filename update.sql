-- Criação da tabela CustomersTest 9 segundos
IF OBJECT_ID('Northwind..CustomersTest') IS NULL
	SELECT CustomerID, CompanyName, ContactName INTO CustomersTest FROM CustomersBig;

-- Criação da tabela CustomersTest 1 segundos
if OBJECT_ID('Northwind..CustomersModelTest') IS NULL
	SELECT CustomerID, ContactName INTO CustomersModelTest FROM CustomersTest;

UPDATE CustomersTest SET contactName = NULL



-- Custo 112.8 / Memory Grant 548 MB / Tempo de execução 3 min 08 seg

UPDATE t SET t.contactName = CASE WHEN m.contactName IN (
'Roland Mendel 15D2D14C'
,'Francisco Chang 85F9DB01'
,'Horst Kloss 551D67ED'
,'Ann Devon DF26B2BC'
,'Carlos González 3E4CE048'
,'Jaime Yorres E7D0415B'
,'Eduardo Saavedra 44664DCD'
,'Fran Wilson 814575BD') THEN 'SEM NOME' ELSE m.contactName END
FROM CustomersTest t INNER JOIN CustomersModelTest m ON t.CustomerID=m.CustomerID




-- Custo 12 / Memory Grant 16 MB / Tempo de execução 01 seg 

DECLARE @tab TABLE(CustomerID INT, contactName VARCHAR(209))
INSERT INTO @tab (customerID,contactName)
SELECT customerID, contactName FROM CustomersModelTest WHERE contactName IN (
'Roland Mendel 15D2D14C'
,'Francisco Chang 85F9DB01'
,'Horst Kloss 551D67ED'
,'Ann Devon DF26B2BC'
,'Carlos González 3E4CE048'
,'Jaime Yorres E7D0415B'
,'Eduardo Saavedra 44664DCD'
,'Fran Wilson 814575BD') 


UPDATE t SET t.contactName = (CASE WHEN t.customerID = m.customerID THEN 'SEM NOME' ELSE m.contactName END)
FROM CustomersTest t INNER JOIN @tab m ON t.customerID=m.customerID


