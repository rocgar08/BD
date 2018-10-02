/*Lidia Barja y Rocío García*/
/*1. Muestra el nombre de los canales y el tiempo total dedicado a documentales en el mes de diciembre de 2017
de aquellos canales que han emitido mas de 3 documentales en ese periodo.*/
SELECT IDCANAL,NOMBRE,SUM(DURACION),COUNT(*) AS EMITIDOS 
FROM PR5B_CANAL JOIN PR5B_PROGRAMACION USING(IDCANAL) JOIN PR5B_PROGRAMA USING(CODPROGRAMA)
WHERE TIPO = 'documental' AND fec_hora BETWEEN '1-12-2017 00:00:00' AND '31-12-2017 23:59:59'
GROUP BY IDCANAL,NOMBRE  HAVING COUNT(*) >3;

/*2. Muestra el nombre de los canales que emiten mas de 2 documentales distintos el mismo da.
NOTA: recuerda que puedes agrupar por columnas, pero tambien por expresiones (con operadores, funciones, etc.).*/

SELECT CA.NOMBRE ,COUNT(*) AS EMITIDOS /* fALTA EXTRACT DAY DROM FECHA =*/
FROM PR5B_CANAL CA JOIN PR5B_PROGRAMACION PR ON PR.IDCANAL = CA.IDCANAL 
JOIN PR5B_PROGRAMA P1 ON P1.CODPROGRAMA = PR.CODPROGRAMA 
WHERE P1.TIPO = 'documental' AND P1.CODPROGRAMA NOT IN (
                                              SELECT PR1.CODPROGRAMA
                                              FROM  PR5B_CANAL CA JOIN PR5B_PROGRAMACION PR1 ON PR1.IDCANAL = CA.IDCANAL 
                                              JOIN PR5B_PROGRAMA P2 ON P2.CODPROGRAMA = PR1.CODPROGRAMA 
                                              WHERE P2.TIPO ='documental')
GROUP BY NOMBRE  HAVING COUNT(*) >2;


/*3. Muestra el nombre de los canales que han programado algun programa con una duracion mayor a la de 'Lo
que el viento se llevo', junto con el ttulo del programa y su duracion.*/

SELECT NOMBRE,TITULO,DURACION 
FROM PR5B_CANAL CA JOIN PR5B_PROGRAMACION PR ON PR.IDCANAL = CA.IDCANAL 
JOIN PR5B_PROGRAMA P1 ON P1.CODPROGRAMA = PR.CODPROGRAMA 
WHERE DURACION >
                  (SELECT DURACION FROM PR5B_PROGRAMA
                  WHERE TITULO = 'Lo que el viento se llevo');

/*4. Muestra el titulo de los documentales que no se han emitido nunca en el canal con nombre 'Antena Sexta'.*/
SELECT TITULO 
FROM PR5B_CANAL C1 JOIN PR5B_PROGRAMACION PR ON PR.IDCANAL = C1.IDCANAL 
JOIN PR5B_PROGRAMA P1 ON P1.CODPROGRAMA = PR.CODPROGRAMA 
WHERE P1.TIPO = 'documental' 
MINUS
SELECT TITULO 
FROM PR5B_CANAL C2 JOIN PR5B_PROGRAMACION PR1 ON PR1.IDCANAL = C2.IDCANAL 
JOIN PR5B_PROGRAMA P2 ON P2.CODPROGRAMA = PR1.CODPROGRAMA 
WHERE P2.TIPO = 'documental' AND C2.NOMBRE = 'Antena Sexta';

/*5. 
Para los programas que se emiten en algun canal, muestra el tItulo del programa y el nombre del canal en el
que se emite de aquellos programas que cumplen la siguiente condicion: la duracion del programa es mayor a
la duracion media de los programas emitidos en ese mismo canal.*/


SELECT TITULO, NOMBRE
FROM PR5B_CANAL JOIN PR5B_PROGRAMACION USING(IDCANAL) 
JOIN PR5B_PROGRAMA USING(CODPROGRAMA)
WHERE NOMBRE  IN (SELECT NOMBRE 
                  FROM PR5B_CANAL JOIN PR5B_PROGRAMACION USING(IDCANAL) 
                  JOIN PR5B_PROGRAMA USING(CODPROGRAMA)
                  WHERE DURACION > (SELECT AVG(DURACION) 
                                    FROM PR5B_CANAL JOIN PR5B_PROGRAMACION USING(IDCANAL) 
                                    JOIN PR5B_PROGRAMA USING(CODPROGRAMA)));
/*6. 
Muestra el titulo de los programas de mayor duracion de cada tipo de los emitidos en el mismo mes en
cualquier canal.*/

SELECT TITULO 
FROM PR5B_PROGRAMA
WHERE DURACION > (SELECT MAX(DURACION)
                  FROM PR5B_PROGRAMA
                  GROUP BY TIPO);

 
                  
                  
                  