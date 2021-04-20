-- Ligar TraceFlag 8758 para desabilitar planos trivial plans
-- Sugestões não são exibidas para planos triviais...

DBCC TRACEON(8757)
GO
DBCC TRACEOFF(8757)
GO

-- Habilitar a traceFlag na execução

SELECT Campo
  FROM Tabela
 WHERE Condicao = 'xxxxxxx'
 ORDER BY Value
OPTION (RECOMPILE, QUERYTRACEON 8757)
