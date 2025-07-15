-- criar tabela para armazenar os dados

CREATE TABLE video_game_sales_2024 (
	id SERIAL PRIMARY KEY,
	title TEXT NOT NULL,
	console TEXT NOT NULL,
	genre TEXT NOT NULL,
	publisher TEXT,
	critic_score NUMERIC(2,1),
	total_sales NUMERIC(12,2),
	na_sales NUMERIC(12,2),
	jp_sales NUMERIC(12,2),
	pal_sales NUMERIC(12,2),
	other_sales NUMERIC(12,2),
	release_date DATE
);

-- filtrando dados

CREATE VIEW vendas_validas AS
SELECT *
FROM video_game_sales_2024
WHERE NOT (release_date IS NULL
	AND critic_score IS NULL
	AND total_sales IS NULL
	AND na_sales IS NULL
	AND jp_sales IS NULL
	AND pal_sales IS NULL
	AND other_sales IS NULL);


-- atualizando colunas para a escala de milhões

BEGIN;

UPDATE video_game_sales_2024
SET
  na_sales = na_sales / 100,
  jp_sales = jp_sales / 100,
  pal_sales = pal_sales / 100,
  other_sales = other_sales / 100,
  total_sales = total_sales / 100;


-- normalizando nomes do mesmo estudio

UPDATE video_game_sales_2024
SET publisher = 'Microsoft Game Studios'
WHERE publisher = 'Microsoft';

-- Substitui valores nulos por 0, pois valores ausentes significam vendas muito baixas

UPDATE video_game_sales_2024
SET
  total_sales = CASE WHEN total_sales IS NULL THEN 0 ELSE total_sales END,
  na_sales     = CASE WHEN na_sales     IS NULL THEN 0 ELSE na_sales END,
  jp_sales     = CASE WHEN jp_sales     IS NULL THEN 0 ELSE jp_sales END,
  pal_sales    = CASE WHEN pal_sales    IS NULL THEN 0 ELSE pal_sales END,
  other_sales  = CASE WHEN other_sales  IS NULL THEN 0 ELSE other_sales END;

 COMMIT;


