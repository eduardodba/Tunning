/*
  Sr.Nimbus - OnDemand
  http://www.srnimbus.com.br
*/

USE NorthWind
GO

-- Pegar um CompanyName para usar como exemplo
SELECT CompanyName
  FROM CustomersBig
 WHERE CustomerID = 50000
GO


-- Exemplo de falta de índice nonclustered
-- É Realizado um scan por não possuir um indice no campo CompanyName
SET STATISTICS IO ON
SELECT CustomerID, CompanyName, Col1 
  FROM CustomersBig
 WHERE CompanyName = 'Frankenversand 86DC35AF'
SET STATISTICS IO OFF

-- Na ausência da palavra NONCLUSTERED
-- o índice é considerado NONCLUSTERED.
CREATE NONCLUSTERED INDEX ix_CompanyName ON CustomersBig(CompanyName)
GO

--  Agora a consulta pode fazer proveito do índice ix_CompanyName
--  Porém como somente o campo CompanyName é coberto pelo indice, ainda é necessário
--  relizar um Key Lookup para obter o campo Col1

SET STATISTICS IO ON
SELECT CustomerID, CompanyName, Col1 
  FROM CustomersBig
 WHERE CompanyName = 'Frankenversand 86DC35AF'
SET STATISTICS IO OFF

DROP INDEX ix_CompanyName ON CustomersBig
GO

-- Criano um indice com INCLUDE Col1, o valor é adicionado no nó folha do indice não cluster
-- O valor CustomerID é contemplado no indice cluster

CREATE NONCLUSTERED INDEX ix_CompanyName ON CustomersBig(CompanyName) INCLUDE (Col1)
GO


SET STATISTICS IO ON
SELECT CustomerID, CompanyName, Col1 
  FROM CustomersBig
 WHERE CompanyName = 'Frankenversand 86DC35AF'
SET STATISTICS IO OFF


------------------------------
-- SIMULANDO A LEITURA
------------------------------

CREATE NONCLUSTERED INDEX ix_CompanyName ON CustomersBig(CompanyName)
GO

SET STATISTICS IO ON
SELECT CustomerID, CompanyName, Col1 
  FROM CustomersBig
 WHERE CompanyName = 'Frankenversand 86DC35AF'
SET STATISTICS IO OFF


--  Novamente, vamos simular os 6 IOs usando o DBCC PAGE

-- Vamos identificar a página Root do índice ix_CompanyName
SELECT dbo.fn_HexaToDBCCPAGE(Root) 
  FROM sys.sysindexes
 WHERE name = 'ix_CompanyName'
   AND id = OBJECT_ID ('CustomersBig')

-- Vamos navegar pelo índice a partir da página Raiz procurando pelo Value
-- CustomerID = 50000
DBCC TRACEON (3604)
DBCC PAGE (Northwind,1,480962,3) -- 1 Leitura
DBCC PAGE (Northwind,1,480935,3) -- 2 Leitura
DBCC PAGE (Northwind,1,484686,3) -- 3 Leitura Encontramos o CompanyName = 'QUICK-Stop 763CB129'

-- Com o CustomerID 50000, vamos navegar pelo índice cluster para 
-- achar o Value da coluna Col1, pois ela não pertence ao índice

SELECT dbo.fn_HexaToDBCCPAGE(Root)
  FROM sys.sysindexes
 WHERE name = 'xpk_CustomersBig'
   AND id = OBJECT_ID ('CustomersBig')

DBCC PAGE (Northwind,1,23114,3) -- 4 Leitura
DBCC PAGE (Northwind,1,23113,3) -- 5 Leitura
DBCC PAGE (Northwind,1,26564,3) -- 6 Leitura Encontramos o CustomerID = 50000
