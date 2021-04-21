-- Simulação sem Indice

-- Custo 3750 
-- Tempo de Execução 8 min 40 seg

update b
set b.companyName = (case when a.companyName in 
('Wolski  Zajazd 95FF7788'
,'The Big Cheese D0CAAC5C'
,'Cactus Comidas para llevar C37700C5'
,'Queen Cozinha 80C60353'
,'Chop-suey Chinese 87D67C96'
,'Maison Dewey 0CE83506'
,'Comércio Mineiro CBFFB86D'
,'Tradição Hipermercados 0906602E'
,'Galería del gastrónomo DA833BF2'
,'Franchi S.p.A. 5DA780D1'
,'Familia Arquibaldo 11AF8D06'
,'Mère Paillarde BCF20AB2'
,'Pericles Comidas clásicas 5B7297D7'
,'Vaffeljernet 120747D7') then a.companyName else 'OUTROS' END)
from CustomersBig a inner join ##CustomersBig b on a.customerID=b.customerID


-- Custo Select 19
-- Custo Update 367
-- Temp de Execução 3 min

declare @tab table(customerID int, companyName varchar(209))
insert into @tab (customerID,companyName)
select customerID, companyName from CustomersBig where companyName in ('Wolski  Zajazd 95FF7788'
,'The Big Cheese D0CAAC5C'
,'Cactus Comidas para llevar C37700C5'
,'Queen Cozinha 80C60353'
,'Chop-suey Chinese 87D67C96'
,'Maison Dewey 0CE83506'
,'Comércio Mineiro CBFFB86D'
,'Tradição Hipermercados 0906602E'
,'Galería del gastrónomo DA833BF2'
,'Franchi S.p.A. 5DA780D1'
,'Familia Arquibaldo 11AF8D06'
,'Mère Paillarde BCF20AB2'
,'Pericles Comidas clásicas 5B7297D7'
,'Vaffeljernet 120747D7')

update a set a.companyName = (case when a.customerID = b.customerID then b.companyName else 'OUTROS' end)
from ##CustomersBig a inner join @tab b on a.customerID=b.customerID
