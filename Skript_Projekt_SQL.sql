CREATE TABLE t_Vojtech_Roule_project_SQL_primary_final AS
WITH 
pomocna1 AS (
SELECT
cp.payroll_year AS rok,
AVG(cp.value) AS prumerna_mzda,
cp.industry_branch_code AS kod_odvetvi,
ib.name AS nazev_odvetvi
FROM czechia_payroll cp
LEFT JOIN czechia_payroll_industry_branch ib 
ON cp.industry_branch_code = ib.code
WHERE value_type_code = 5958 AND calculation_code = 200
GROUP BY cp.payroll_year, cp.industry_branch_code, ib.name
),
pomocna2 AS (
SELECT
AVG(cp.value) AS prumerna_cena,
cp.category_code AS kod_kategorie,
EXTRACT(YEAR FROM cp.date_from) AS rok,
cpc.name AS nazev_kategorie
FROM czechia_price cp
LEFT JOIN czechia_price_category cpc 
ON cp.category_code = cpc.code
GROUP BY cp.category_code, EXTRACT(YEAR FROM date_from), cpc.name
)
SELECT 
p1.rok,
p1.prumerna_mzda,
p1.kod_odvetvi,
p1.nazev_odvetvi,
p2.prumerna_cena,
p2.kod_kategorie,
p2.nazev_kategorie
FROM pomocna1 p1
JOIN pomocna2 p2 ON p1.rok = p2.rok;

CREATE TABLE t_Vojtech_Roule_project_SQL_secondary_final AS
SELECT e."year", e.country, e.gdp, e.gini, e.population
FROM countries c 
LEFT JOIN economies e 
ON c.country = e.country 
WHERE c.continent = 'Europe' AND e."year" BETWEEN 2006 AND 2018;

--Úloha 1

WITH pomocna1_1 AS (
SELECT DISTINCT
t.rok,
t.prumerna_mzda,
t.nazev_odvetvi
FROM t_vojtech_roule_project_sql_primary_final t
WHERE t.nazev_odvetvi IS NOT NULL
AND t.prumerna_mzda IS NOT NULL
),
pomocna1_2 AS (
SELECT 
rok,
prumerna_mzda,
nazev_odvetvi,
LAG(prumerna_mzda) OVER (PARTITION BY nazev_odvetvi ORDER BY rok) AS predchozi_mzda
FROM pomocna1_1 p11
)
SELECT 
nazev_odvetvi,
rok,
ROUND(prumerna_mzda-predchozi_mzda) AS rozdil_mezd
FROM pomocna1_2 p12
WHERE predchozi_mzda IS NOT NULL
ORDER BY rozdil_mezd;

-- Úloha 2

WITH pomocna2 AS (
SELECT
t.rok,
t.nazev_kategorie,
t.prumerna_mzda,
t.prumerna_cena
FROM t_vojtech_roule_project_sql_primary_final t
WHERE t.nazev_kategorie IN ('Chléb konzumní kmínový', 'Mléko polotučné pasterované')
AND t.rok IN (2006, 2018)
AND t.nazev_odvetvi IS NULL
GROUP BY t.rok, t.prumerna_mzda, t.nazev_kategorie, t.prumerna_cena
)
SELECT
rok,
nazev_kategorie,
ROUND(prumerna_mzda/prumerna_cena) AS kupni_sila
FROM pomocna2 p2
ORDER BY nazev_kategorie, rok;

-- Úloha 3

WITH pomocna3_1 AS (
SELECT DISTINCT
t.rok,
t.prumerna_cena,
t.nazev_kategorie
FROM t_vojtech_roule_project_sql_primary_final t
),
pomocna3_2 AS (
SELECT 
rok,
prumerna_cena,
nazev_kategorie,
LAG(prumerna_cena) OVER (PARTITION BY nazev_kategorie ORDER BY rok) AS predchozi_cena
FROM pomocna3_1
),
pomocna3_3 AS (
SELECT
nazev_kategorie,
((prumerna_cena-predchozi_cena)/predchozi_cena)*100 AS mezirocni_zmena
FROM pomocna3_2
)
SELECT 
nazev_kategorie,
ROUND(AVG(mezirocni_zmena)::numeric, 1) AS mezirocni_zmena
FROM pomocna3_3
GROUP BY nazev_kategorie
ORDER BY mezirocni_zmena;

-- Úloha 4

WITH pomocna4_1 AS (
SELECT 
t.rok,
t.prumerna_mzda,
LAG(t.prumerna_mzda) OVER (ORDER BY t.rok) AS predchozi_mzda
FROM t_vojtech_roule_project_sql_primary_final t
WHERE t.nazev_odvetvi IS NULL
GROUP BY t.rok, t.prumerna_mzda
),
pomocna4_2 AS (
SELECT 
rok,
((prumerna_mzda-predchozi_mzda)/predchozi_mzda)*100 AS zmena_mezd
FROM pomocna4_1
WHERE predchozi_mzda IS NOT NULL
),
pomocna4_3 AS (
SELECT 
t.rok,
t.prumerna_cena,
t.kod_kategorie,
LAG(t.prumerna_cena) OVER (PARTITION BY t.kod_kategorie ORDER BY t.rok) AS predchozi_cena
FROM t_vojtech_roule_project_sql_primary_final t
),
pomocna4_4 AS (
SELECT 
rok,
AVG(((prumerna_cena-predchozi_cena)/predchozi_cena)*100) AS zmena_cen
FROM pomocna4_3
WHERE predchozi_cena IS NOT NULL
GROUP BY rok
)
SELECT 
p42.rok,
ROUND(p42.zmena_mezd::numeric, 1) AS zmena_mezd,
ROUND(p44.zmena_cen::numeric, 1) AS zmena_cen,
ROUND((p44.zmena_cen-p42.zmena_mezd)::numeric, 1) AS rozdil_cen_mezd
FROM pomocna4_2 p42
JOIN pomocna4_4 p44 ON p42.rok = p44.rok
ORDER BY rozdil_cen_mezd DESC;

-- Úloha 5

WITH pomocna5_1 AS (
SELECT 
t2."year",
t2.gdp,
LAG(t2.gdp) OVER (ORDER BY t2."year") AS predchozi_hdp
FROM t_vojtech_roule_project_sql_secondary_final t2
WHERE t2.country = 'Czech Republic'
),
pomocna5_2 AS (
SELECT 
year,
((gdp-predchozi_hdp)/predchozi_hdp)*100 AS zmena_hdp
FROM pomocna5_1
WHERE predchozi_hdp IS NOT NULL
),
pomocna5_3 AS (
SELECT 
t.rok,
AVG(t.prumerna_mzda) AS prumerna_mzda,
LAG(AVG(t.prumerna_mzda)) OVER (ORDER BY t.rok) AS predchozi_mzda
FROM t_vojtech_roule_project_sql_primary_final t
WHERE t.nazev_odvetvi IS NULL
GROUP BY t.rok
),
pomocna5_4 AS (
SELECT 
rok,
((prumerna_mzda-predchozi_mzda)/predchozi_mzda)*100 AS zmena_mezd
FROM pomocna5_3
WHERE predchozi_mzda IS NOT NULL
),
pomocna5_5 AS (
SELECT 
t.rok,
t.prumerna_cena,
t.kod_kategorie,
LAG(t.prumerna_cena) OVER (PARTITION BY t.kod_kategorie ORDER BY t.rok) AS predchozi_cena
FROM t_vojtech_roule_project_sql_primary_final t
),
pomocna5_6 AS (
SELECT 
rok,
AVG(((prumerna_cena-predchozi_cena)/predchozi_cena)*100) AS zmena_cen
FROM pomocna5_5
WHERE predchozi_cena IS NOT NULL
GROUP BY rok
)
SELECT 
p52."year",
ROUND(p52.zmena_hdp::numeric, 1) AS zmena_hdp,
ROUND(p54.zmena_mezd::numeric, 1) AS zmena_mezd,
ROUND(p56.zmena_cen::numeric, 1) AS zmena_cen
FROM pomocna5_2 p52
JOIN pomocna5_4 p54 ON p52."year" = p54.rok
JOIN pomocna5_6 p56 ON p52."year" = p56.rok
ORDER BY p52."year";







