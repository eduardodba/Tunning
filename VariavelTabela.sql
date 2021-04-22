dbcc dropcleanbuffers

-- Criação da tabela CustomersTest 9 segundos
IF OBJECT_ID('Northwind..CustomersTest') IS NULL
	SELECT CustomerID, CompanyName, ContactName INTO CustomersTest FROM CustomersBig;

-- Criação da tabela CustomersTest 1 segundos
if OBJECT_ID('Northwind..CustomersModelTest') IS NULL
	SELECT CustomerID, ContactName INTO CustomersModelTest FROM CustomersTest;


UPDATE CustomersTest SET contactName = 'SEM NOME'


-- 8 SEM NOME
select count(*) as QTD, a.TIPO from (
select case when contactName = 'SEM NOME' Then 'SEM NOME' else 'COM NOME' end as TIPO from CustomersTest
) a group by a.tipo


------------------------
-- Exemplo com Update
------------------------


-- Custo 113 / Memory Grant 83 MB / Tempo de execução 3 min 01 seg

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



-- Custo 112.8 / Memory Grant 548 MB / Tempo de execução 41 seg

DECLARE @tab TABLE(CustomerID INT, contactName VARCHAR(209))
INSERT INTO @tab (customerID,contactName)
SELECT customerID, contactName FROM CustomersModelTest WHERE contactName NOT IN (
'Roland Mendel 15D2D14C'
,'Francisco Chang 85F9DB01'
,'Horst Kloss 551D67ED'
,'Ann Devon DF26B2BC'
,'Carlos González 3E4CE048'
,'Jaime Yorres E7D0415B'
,'Eduardo Saavedra 44664DCD'
,'Fran Wilson 814575BD') 


UPDATE t SET t.contactName = (
	CASE WHEN t.customerID = m.customerID THEN m.contactName 
	ELSE 'SEM NOME' END
) FROM CustomersTest t INNER JOIN @tab m ON t.customerID=m.customerID



------------------------
-- Exemplo com Select
------------------------

dbcc dropcleanbuffers

-- Custo 17 / Memory Grant 181 MB / Tempo de execução 14 seg

SELECT t.CustomerID, CASE WHEN m.contactName IN (
 'Roland Mendel 15D2D14C'
,'Francisco Chang 85F9DB01'
,'Horst Kloss 551D67ED'
,'Ann Devon DF26B2BC'
,'Carlos González 3E4CE048'
,'Jaime Yorres E7D0415B'
,'Eduardo Saavedra 44664DCD'
,'Fran Wilson 814575BD') THEN 'SEM NOME' ELSE m.contactName END
FROM CustomersTest t INNER JOIN CustomersModelTest m ON t.CustomerID=m.CustomerID


-- Custo 55 / Memory Grant 181 MB / Tempo de execução 17 seg

DECLARE @tab TABLE(CustomerID INT, contactName VARCHAR(209))
INSERT INTO @tab (customerID,contactName)
SELECT customerID, contactName FROM CustomersModelTest WHERE contactName NOT IN (
'Roland Mendel 15D2D14C'
,'Francisco Chang 85F9DB01'
,'Horst Kloss 551D67ED'
,'Ann Devon DF26B2BC'
,'Carlos González 3E4CE048'
,'Jaime Yorres E7D0415B'
,'Eduardo Saavedra 44664DCD'
,'Fran Wilson 814575BD') 


SELECT t.CustomerID, CASE WHEN t.customerID = m.customerID THEN m.contactName ELSE 'SEM NOME' END
FROM CustomersTest t INNER JOIN @tab m ON t.customerID=m.customerID




