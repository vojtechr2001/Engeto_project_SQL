# Projekt z SQL: Dostupnost základních potravin široké veřejnosti

## Úvod do projektu

Cílem tohoto projektu je zodpovědět definované výzkumné otázky týkající se dostupnosti základních potravin pro širokou veřejnost, a to na základě porovnání cen potravin s vývojem průměrných příjmů v čase. Součástí analýzy je rovněž doplňkový přehled srovnávající vybrané evropské státy z hlediska HDP, Giniho koeficientu a počtu obyvatel za stejné časové období, který slouží jako kontext k primárním datům za Česko.

## Popis získaných tabulek

1) Výsledná primární tabulka (t_Vojtech_Roule_project_SQL_primary_final) byla vytvořena z tabulek s údaji o úrovni cen potravin (czechia_price), kategoriích potravin (czechia_price_category), úrovni mezd (czechia_price) a kategoriích odvětví trhu práce (czechia_payroll_industry_branch) v Česku za období let 2006–2018 a obsahuje celkem 6840 řádků dat.

2) Výsledná sekundární tabulka (t_Vojtech_Roule_project_SQL_secondary_final) byla vytvořena z tabulek countries a economies, které poskytují základní údaje o vybraných evropských státech za období let 2006–2018 a obsahuje 585 řádků dat. V této tabulce se nachází značné množství chybějících hodnot, a to ve sloupcích s daty o HDP a Giniho indexu.

## Otázka 1: Rostou v průběhu let mzdy ve všech odvětvích, nebo v některých klesají?

**Odpověď:** Ve velké většině případů mzdy v jednotlivých odvětvích meziročně rostly. Existovalo ale také několik výjimek, kdy v některých letech mzdy meziročně naopak klesaly. Tyto poklesy byly nicméně obvykle pouze v řádu nižších stovek Kč. Nejčastější a nejvýraznější meziroční poklesy v úrovni mezd byly pozorovány v roce 2013. Tehdy ve třech odvětvích mzdy z roku na rok klesly o více než 1000 Kč, zdaleka nejvíce v peněžnictví a pojišťovnictví (o 4484 Kč).

## Otázka 2: Kolik je možné si koupit litrů mléka a kilogramů chleba za první a poslední srovnatelné období v dostupných datech cen a mezd?

**Odpověď:** Mezi prvním a posledním sledovaným rokem (2006 a 2018) se množství jak chleba, tak mléka, které si lze koupit za průměrnou mzdu, zvýšilo. V případě chleba šlo o nárůst z 1212 na 1322 kg, u mléka byl vzestup kupní síly ještě větší – za průměrnou mzdu bylo možné si koupit 1353 l mléka v roce 2006, zatímco v roce 2018 už šlo o 1617 l.

## Otázka 3: Která kategorie potravin zdražuje nejpomaleji (je u ní nejnižší percentuální meziroční nárůst)? 

**Odpověď:** Nejnižší průměrný meziroční nárůst cen byl pozorován u dvou kategorií potravin, které dokonce v dlouhodobém trendu zlevňovaly. Jednalo se o cukr krystalový, který průměrně zlevňoval o 1,9 % ročně, a také o rajská jablka červená kulatá, jejichž cena meziročně průměrně klesala o 0,7 %. Ceny všech ostatních kategorií potravin naopak v čase narůstaly.

## Otázka 4: Existuje rok, ve kterém byl meziroční nárůst cen potravin výrazně vyšší než růst mezd (větší než 10 %)?

**Odpověď:** Žádný rok, ve kterém by ceny potravin narůstaly oproti úrovni mezd takto výrazně, se v těchto datech nenachází. S výjimkou roku 2013, kdy mzdy jako v jedinném sledovaném kalendářním roce mírně klesly a ceny potravin naopak mírně vzrostly, dokonce pro všechny hodnocené roky platilo, že mzdy stoupaly rychleji než ceny potravin a rostla tak tedy i kupní síla obyvatel.

## Otázka 5: Má výška HDP vliv na změny ve mzdách a cenách potravin? Neboli, pokud HDP vzroste výrazněji v jednom roce, projeví se to na cenách potravin či mzdách ve stejném nebo následujícím roce výraznějším růstem?

**Odpověď:** Z dostupných dat vyplývá, že mezi vývojem HDP a mezd existuje souvislost. Nejvyšší meziroční nárůsty mezd byly obvykle pozorovány v letech následujících po těch, v nichž byl pozorován vyšší nárůst HDP. Když HDP meziročně klesalo, tak následně často docházelo i ke zpomalení (či v roce 2013 dokonce k poklesu) růstu mezd. U meziročních změn cen potravin naopak žádná zřejmná korelace s vývojem HDP nebyla nalezena.
