#Evaluación de la influencia de los eventos de reducción de recompensa en la minería en el mercado de criptomonedas
# Adrián Gallego Martín

SELECT *
  FROM cripto.btc;

/*1. Hasta qué fecha hay datos de bitcoin pero no datos de ethereum? Resultado: Del julio de 2010 a marzo de 2016.*/
  SELECT MONTH(fecha), YEAR(fecha)
  FROM cripto.btc
 WHERE fecha NOT IN (
	SELECT fecha
      FROM cripto.eth
      )
GROUP BY MONTH(fecha),YEAR(fecha);

/*2. Join con todas las criptomonedas durante 2022 (solo datos hasta agosto)*/
SELECT YEAR(eth.fecha) AS "Año", MONTH(eth.fecha) AS "Mes", ROUND(AVG(eth.cierre)) AS "Media ETH", ROUND(AVG(btc.cierre)) AS "Media BTC",
AVG(doge.cierre) AS "Media Doge", ROUND(AVG(link.cierre)) AS "Media Link", ROUND(AVG(usdt.cierre)) AS "Media USDT",
AVG(xrp.cierre) AS "Media XRP"
  FROM cripto.eth eth
  JOIN cripto.btc btc
    ON eth.fecha = btc.fecha
 JOIN cripto.doge doge
    ON eth.fecha = doge.fecha
 JOIN cripto.link link
    ON eth.fecha = link.fecha
 JOIN cripto.usdt usdt
    ON eth.fecha = usdt.fecha
 JOIN cripto.xrp xrp
    ON eth.fecha = xrp.fecha
WHERE btc.fecha BETWEEN "2022-01-01" AND "2023-01-01"
 GROUP BY MONTH(eth.fecha), YEAR(eth.fecha);

/*3. Análisis del precio de BTC hasta un año después del halving de 28-noviembre
de 2012.  
Resultados: x43 veces más caro BTC*/
SELECT YEAR(btc.fecha), MONTH(btc.fecha), AVG(btc.cierre), AVG(volume)
  FROM cripto.btc btc
WHERE btc.fecha BETWEEN "2012-11-28" AND "2013-11-28"
  GROUP BY MONTH(btc.fecha), YEAR(btc.fecha);

/*4. Análisis del precio de ETH y BTC un año después del halving de 2016.
 Resultados: 20 veces más caro ETH y casi 3 veces más BTC*/
SELECT YEAR(eth.fecha) AS "Año", MONTH(eth.fecha) AS "Mes", ROUND(AVG(eth.cierre)) AS "Media ETH", ROUND(AVG(btc.cierre)) AS "Media BTC"
  FROM cripto.eth eth
  JOIN cripto.btc btc
    ON eth.fecha = btc.fecha
WHERE eth.fecha BETWEEN "2016-07-09" AND "2017-07-09"
  GROUP BY MONTH(eth.fecha), YEAR(eth.fecha);

/*5. Análisis del precio de Doge y Link en el halving de 2016 --> no hay datos aún ni de Link ni de Doge*/
SELECT YEAR(doge.fecha), MONTH(doge.fecha), AVG(doge.cierre), AVG(link.cierre)
  FROM cripto.doge doge
  LEFT JOIN cripto.link link
    ON link.fecha = doge.fecha
 WHERE doge.fecha BETWEEN "2016-07-09" AND "2017-07-09"
 GROUP BY MONTH(doge.fecha), YEAR(doge.fecha);
  
/*6. Análisis del precio de ETH y BTC un año después del halving de 2020.
 Resultados: x16 veces más caro ETH y x5 veces más caro BTC. El crecimiento fue mayor en 
 BTC que en el anterior halving*/
SELECT YEAR(eth.fecha), MONTH(eth.fecha), AVG(eth.cierre), AVG(btc.cierre)
  FROM cripto.eth eth
  JOIN cripto.btc btc
    ON eth.fecha = btc.fecha
WHERE eth.fecha BETWEEN "2020-05-11" AND "2021-05-11"
  GROUP BY MONTH(eth.fecha), YEAR(eth.fecha);
  
/*7. Análisis del precio de LINK y DOGE un año después del halving de 2020.
 Resultados: Doge hizo x20 y link x5.8 El crecimiento fue mayor en 
 BTC que en el anterior halving*/
SELECT YEAR(doge.fecha), MONTH(doge.fecha), AVG(doge.cierre), AVG(link.cierre)
  FROM cripto.doge doge
  JOIN cripto.link link
    ON doge.fecha = link.fecha
WHERE doge.fecha BETWEEN "2020-05-11" AND "2021-05-11"
  GROUP BY MONTH(doge.fecha), YEAR(doge.fecha);
  
/*8. ¿Qué mes del año tiene mayor diferencia porcentual durante el primer halving en BTC*/  
SELECT YEAR(btc.fecha), MONTH(btc.fecha),
       MAX(btc.cierre) AS max_value, MIN(btc.cierre) AS min_value,
       ((MAX(btc.cierre) - MIN(btc.cierre)) / MIN(btc.cierre)) * 100 AS percentage_difference
FROM cripto.btc btc
WHERE btc.fecha BETWEEN "2012-11-28" AND "2013-11-28"
GROUP BY MONTH(btc.fecha), YEAR(btc.fecha)
ORDER BY percentage_difference DESC
LIMIT 5;

/*9. ¿Qué mes del año tiene mayor diferencia porcentual durante el halving de 2016 en BTC*/  
SELECT YEAR(btc.fecha), MONTH(btc.fecha),
       MAX(btc.cierre) AS max_value, MIN(btc.cierre) AS min_value,
       ((MAX(btc.cierre) - MIN(btc.cierre)) / MIN(btc.cierre)) * 100 AS percentage_difference
FROM cripto.btc btc
WHERE btc.fecha BETWEEN "2016-07-09" AND "2017-07-09"
GROUP BY MONTH(btc.fecha), YEAR(btc.fecha)
ORDER BY percentage_difference DESC
LIMIT 5;

/*10 ¿Qué mes del año tiene mayor diferencia porcentual durante el halving de 2020 en BTC*/  
SELECT YEAR(btc.fecha), MONTH(btc.fecha),
       MAX(btc.cierre) AS max_value, MIN(btc.cierre) AS min_value,
       ((MAX(btc.cierre) - MIN(btc.cierre)) / MIN(btc.cierre)) * 100 AS percentage_difference
FROM cripto.btc btc
WHERE btc.fecha BETWEEN "2020-05-11" AND "2021-05-11"
GROUP BY MONTH(btc.fecha), YEAR(btc.fecha)
ORDER BY percentage_difference DESC
LIMIT 5;

/*11. Averigua qué meses de cada año tuvo una mayor diferencia porcentual de valor mínimo y valor máximo de cierre.
Esta consulta es demasiado compleja y me la tuvo que hacer Chatgpt.*/  
SELECT t1.*
FROM (
    SELECT YEAR(btc.fecha) AS year, MONTH(btc.fecha) AS month,
           MAX(btc.cierre) AS max_value, MIN(btc.cierre) AS min_value,
           ((MAX(btc.cierre) - MIN(btc.cierre)) / MIN(btc.cier01re)) * 100 AS percentage_difference
    FROM cripto.btc btc
    WHERE btc.fecha BETWEEN "2012-01-01" AND "2022-12-31"
    GROUP BY YEAR(btc.fecha), MONTH(btc.fecha)
) t1
WHERE t1.percentage_difference = (
    SELECT MAX(t2.percentage_difference)
    FROM (
        SELECT YEAR(btc.fecha) AS year, MONTH(btc.fecha) AS month,
               MAX(btc.cierre) AS max_value, MIN(btc.cierre) AS min_value,
               ((MAX(btc.cierre) - MIN(btc.cierre)) / MIN(btc.cierre)) * 100 AS percentage_difference
        FROM cripto.btc btc
        WHERE btc.fecha BETWEEN "2012-01-01" AND "2022-12-31"
        GROUP BY YEAR(btc.fecha), MONTH(btc.fecha)
    ) t2
    WHERE t2.year = t1.year
    GROUP BY t2.year
)
ORDER BY t1.year;

/*12.  ¿Qué meses del año la diferencia entre cierre más bajo y cierre más alto de BTC es mayor que ETH en 
halving de 2020?  */  
  SELECT YEAR(btc.fecha) AS year, MONTH(btc.fecha) AS month,
    ((MAX(btc.cierre) - MIN(btc.cierre)) / MIN(btc.cierre)) * 100 AS btc_percentage_difference,
    ((MAX(eth.cierre) - MIN(eth.cierre)) / MIN(eth.cierre)) * 100 AS eth_percentage_difference
  FROM cripto.btc
  INNER JOIN cripto.eth ON btc.fecha = eth.fecha
  WHERE btc.fecha BETWEEN "2020-05-11" AND "2021-05-11"
  GROUP BY YEAR(btc.fecha), MONTH(btc.fecha)
  HAVING btc_percentage_difference > eth_percentage_difference;
  
/*13.  ¿Qué meses del año la diferencia entre cierre más bajo y cierre más alto de BTC es menor que ETH en 
halving de 2020?  */  
  SELECT YEAR(btc.fecha) AS year, MONTH(btc.fecha) AS month,
    ((MAX(btc.cierre) - MIN(btc.cierre)) / MIN(btc.cierre)) * 100 AS btc_percentage_difference,
    ((MAX(eth.cierre) - MIN(eth.cierre)) / MIN(eth.cierre)) * 100 AS eth_percentage_difference
  FROM cripto.btc
  INNER JOIN cripto.eth ON btc.fecha = eth.fecha
  WHERE btc.fecha BETWEEN "2020-05-11" AND "2021-05-11"
  GROUP BY YEAR(btc.fecha), MONTH(btc.fecha)
  HAVING btc_percentage_difference < eth_percentage_difference;
  
/*14. NOTA: Hablamos de meses después del halving, por lo que el mes 1 es el mes posterior al primer halving.
Analicemos aquí el año siguiente al año del primer halving (2012, en qué mes empieza a bajar y en
 qué mes se reduce el valor más drasticamente?
Resultados --> El valor máximo en el año del halving fue de 537 y se alcanzó el mes 12 (537)
En el segundo año del halving, el máximo valor se consiguió en el mes 1 (o mes 13 después del halving). 
Un valor de 1171, desde entonces baja sufriendo la peor caida del mes 15 al 16

Resumen del primer halving:
-máximo valor al mes 13 desde el halving: 1171
-máxima caida del mes 15 al 16: -44,9%
-2º máxima caida del mes 13 al 14: -28,2%

*/
SELECT YEAR(btc.fecha), MONTH(btc.fecha), ROUND(AVG(btc.cierre))
  FROM cripto.btc 
 WHERE btc.fecha BETWEEN "2013-11-28" AND "2014-11-28"
  GROUP BY MONTH(btc.fecha), YEAR(btc.fecha);
  
/*14. Analicemos el año siguiente al año del segundo halving (2016), en qué mes empieza a bajar y en qué mes se reduce el valor más drasticamente?
Aquí no nos interesa saber el mes tal cual si no el número de mes tras el halving.
 NOTA: Hablamos de meses después del halving, por lo que el mes 1 es el mes posterior al primer halving.
Resultados --> El valor máximo en el año del segundo halving (2016) fue de 2632 y se alcanzó el mes 11, aunque se mantuvo el 12
En el segundo año del halving, el máximo valor se consiguió en el mes 18 con un valor de 15035,
desde entonces baja sufriendo la peor caida:
-del mes 13 a 14 una caida del 28,2%
-del mes 15 al 16 una caida del 44,9%

Resumen del segundo halving para BTC:
-máximo valor al mes 18 desde el halving
-máxima caida del mes 19 al 20 de -27%
-2º máxima caida del mes 23 al 24 de -19,6%

Resumen del segundo halving para ETH:
-máximo valor al mes 11 del halving, con un valor de 300
-Crecimiento muy importante los meses posteriores, llegando al máximo el mes 19 con 1089
-máxima caida del mes 21 al 22 de -28%
-2º máxima caida del mes 19 al 20 de -20%
*/
SELECT YEAR(eth.fecha) AS "Año", MONTH(eth.fecha) AS "Mes", ROUND(AVG(eth.cierre)) AS "Media ETH", ROUND(AVG(btc.cierre)) AS "Media BTC"
  FROM cripto.eth eth
  JOIN cripto.btc btc
    ON eth.fecha = btc.fecha
WHERE eth.fecha BETWEEN "2017-07-09" AND "2018-07-09"
  GROUP BY MONTH(eth.fecha), YEAR(eth.fecha);
  
/*15. Analicemos el año siguiente al año del tercer halving (2020), en qué mes empieza a bajar y en qué mes se reduce el valor más drasticamente?
Aquí no nos interesa saber el mes tal cual si no el número de mes tras el halving.
 NOTA: Hablamos de meses después del halving, por lo que el mes 1 es el mes posterior al primer halving.
Resultados --> El valor máximo en el año del segundo halving (2020) fue de 57070 y se alcanzó el mes 11, aunque se mantuvo el 12
En el segundo año del halving, el máximo valor se consiguió en el mes 19 con un valor de 60679,

Resumen del segundo halving para BTC:
-máximo valor al mes 19 desde el halving con valor de 60679
-máxima caida del mes 12 al 13 de -27,4%
-2º máxima caida del mes 19 al 20 de -18,75%

Resumen del segundo halving para ETH:
-máximo valor al mes 12 del halving, con un valor de 3549
-máximo valor (2º año del halving) en mes 19 con 4441
-máxima caida del mes 20 al 21 de -24,5%
-2º máxima caida del mes 13 al 14  de -21,5%%
*/
SELECT YEAR(eth.fecha), MONTH(eth.fecha), ROUND(AVG(eth.cierre)), ROUND(AVG(btc.cierre))
  FROM cripto.eth eth
  JOIN cripto.btc btc
    ON eth.fecha = btc.fecha
WHERE eth.fecha BETWEEN "2021-05-11" AND "2022-05-11"
  GROUP BY MONTH(eth.fecha), YEAR(eth.fecha);
  
/*16. Importamos una nueva tabla que define el estado del día del mes según greed and fear. Crypto Fear and Greed Index o CFGI. 
Estudiando factores como la volatilidad del mercado, el momentum (espacios de compra-venta acentuada), la actividad en redes sociales 
o medios de comunicación, encuestas y tendencias de mercado, es posible extrapolar información suficiente para detectar el estado emocional 
global de los traders.  */
SELECT *
  FROM cripto.feargreed;

/*17. Media por mes del Fear & Greed Index duranta el año del tercer halving (2020). 0 = fear, 100= greed*/
SELECT AVG(fng_value), MONTH(fecha), YEAR(fecha)
  FROM cripto.feargreed
WHERE fecha BETWEEN "2020-05-11" AND "2021-05-11"
GROUP BY MONTH(fecha), YEAR(fecha)
ORDER BY MONTH(fecha);

/*18. Conexión del FNG index con valores de BTC y ETH
CConclusión: No parece un índice muy certero, marca greed máximo tras el cual le siguen casi 5 meses de máximo valor de eth y btc
*/
SELECT MONTH(fng.fecha), YEAR(fng.fecha), AVG(fng.fng_value), AVG(btc.cierre), AVG(eth.cierre)
  FROM cripto.feargreed fng
  JOIN cripto.btc btc
    ON btc.fecha = fng.fecha
  JOIN cripto.eth eth
    ON fng.fecha = eth.fecha
WHERE fng. fecha BETWEEN "2020-05-11" AND "2021-05-11"
GROUP BY YEAR(fecha),  MONTH(fecha)
ORDER BY YEAR(fecha);

/*18. Conexión del FNG index con valores de BTC y ETH un año antes del Halving de 2020
Conclusión: Domina el Fear*/
SELECT MONTH(fng.fecha), YEAR(fng.fecha), AVG(fng.fng_value), AVG(btc.cierre), AVG(eth.cierre)
  FROM cripto.feargreed fng
  JOIN cripto.btc btc
    ON btc.fecha = fng.fecha
  JOIN cripto.eth eth
    ON fng.fecha = eth.fecha
WHERE fng. fecha BETWEEN "2019-05-11" AND "2020-05-11"
GROUP BY YEAR(fecha),  MONTH(fecha)
ORDER BY YEAR(fecha);

/*19. Media de fng por año comparada con valores de BTC y ETH
Conclusión: A nivel anual se ve mucha mayor media los dos años de crecimiento posteriores al halving, con caida
drástica el año posterior
*/
SELECT YEAR(fng.fecha), AVG(fng.fng_value), AVG(btc.cierre), AVG(eth.cierre)
  FROM cripto.feargreed fng
  JOIN cripto.btc btc
    ON btc.fecha = fng.fecha
  JOIN cripto.eth eth
    ON fng.fecha = eth.fecha
GROUP BY YEAR(fng.fecha)
ORDER BY YEAR(fng.fecha);

/*20. ¿Qué precios tenía bitcoin durante los periodos de extreme greed? */
SELECT YEAR(fecha), MONTH(fecha), AVG(btc.cierre)
FROM cripto.btc
WHERE fecha IN (
	SELECT fecha
	FROM cripto.feargreed
	WHERE fng_classification = "Extreme Greed"
)
GROUP BY YEAR(fecha), MONTH(fecha)
