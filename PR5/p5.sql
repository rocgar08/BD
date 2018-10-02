/*Rocío García Núñez*/

/*1. Elabora un listado (sin repeticiones) con los apellidos de los clientes de la empresa que hayan
hecho algún pedido online (order_mode online) junto con el apellido del empleado que
gestiona su cuenta.
Muestra en el listado primero el apellido del empleado que gestiono la
cuenta y luego el apellido del cliente, y haz que el listado se encuentre ordenado por apellido
de empleado primero y luego por apellido del cliente. Usa reuniones para ello*/

SELECT DISTINCT e1.last_name,c1.CUST_LAST_NAME FROM PR5_CUSTOMERS c1 JOIN PR3_EMPLOYEES e1 ON e1.manager_id = c1.ACCOUNT_MGR_ID 
JOIN PR5_ORDERS o1 ON c1.customer_id = o1.CUSTOMER_ID
WHERE o1.ORDER_MODE = 'online'
ORDER BY e1.last_name,c1.CUST_LAST_NAME;

/*2.Listado de categorías con más de 2 productos obsoletos (PRODUCT_STATUS obsolete).
Lista la categoría y el número de productos obsoletos.*/
SELECT CATEGORY_ID,COUNT(*) FROM PR5_PRODUCT_INFORMATION
WHERE PRODUCT_STATUS = 'obsolete'
GROUP BY CATEGORY_ID HAVING COUNT(*)>2;

/*3.Se quiere generar un “ranking” de los productos más vendidos en el último semestre del año
1990. 
Para ello nos piden mostrar el nombre de producto y el número de unidades vendidas
para cada producto vendido en el último semestre del año 1990 (ordenado por número de
unidades vendidas de forma descendente).*/

SELECT DISTINCT PRODUCT_NAME,QUANTITY FROM PR5_ORDER_ITEMS JOIN PR5_PRODUCT_INFORMATION USING (PRODUCT_ID)
JOIN  PR5_ORDERS  O USING(ORDER_ID) JOIN PR5_CUSTOMERS CU ON CU.CUSTOMER_ID = O.CUSTOMER_ID 
WHERE ORDER_DATE BETWEEN '01/07/1990' AND '31/12/1990' 
ORDER BY QUANTITY DESC;


/*SELECT DISTINCT PRODUCT_NAME,SUM(QUANTITY) FROM PR5_ORDER_ITEMS JOIN PR5_PRODUCT_INFORMATION USING (PRODUCT_ID)
JOIN  PR5_ORDERS  O USING(ORDER_ID) JOIN PR5_CUSTOMERS CU ON CU.CUSTOMER_ID = O.CUSTOMER_ID 
WHERE ORDER_DATE BETWEEN '01/07/1990' AND '31/12/1990' 
GROUP BY PRODUCT_NAME,QUANTITY;*/


/*4.Muestra los puestos en la empresa que tienen un salario mínimo superior al salario medio de
los empleados de la compañía. 
El listado debe incluir el puesto y su salario mínimo, y estar
ordenado ascendentemente por salario mínimo.*/


SELECT DISTINCT JOB_TITLE,JB.MIN_SALARY FROM PR3_JOBS JB JOIN PR3_EMPLOYEES E1 ON JB.JOB_ID = E1.JOB_ID
WHERE JB.MIN_SALARY >(SELECT AVG(e2.SALARY) FROM PR3_EMPLOYEES e2) 
GROUP BY JOB_TITLE, JB.MIN_SALARY 
ORDER BY JB.MIN_SALARY ASC;

/*5.Mostrar el código, nombre y precio mínimo de productos de la categoría 14 que no aparecen
en ningún pedido. Usa para ello una subconsulta no correlacionada.*/
--


SELECT DISTINCT PRODUCT_ID,PRODUCT_NAME,MIN_PRICE 
FROM PR5_PRODUCT_INFORMATION
WHERE CATEGORY_ID = '14' 
MINUS 
SELECT DISTINCT IM.PRODUCT_ID,IM.PRODUCT_NAME,IM.MIN_PRICE 
FROM PR5_PRODUCT_INFORMATION IM JOIN PR5_ORDER_ITEMS OI ON IM.PRODUCT_ID = OI.PRODUCT_ID
WHERE OI.ORDER_ID<>NULL;
/*6.Mostrar el código de cliente, nombre y apellidos de aquellos clientes alemanes
(NLS_TERRITORY GERMANY) que no han realizado ningún pedido. Usa para ello una consulta
correlacionada.*/
---DEBERIAN SALIR LOS 3 ALEMANES NINGUNO DE ELLOS A HECHO UN PEDIDO 
SELECT CUSTOMER_ID,CUST_FIRST_NAME,CUST_LAST_NAME 
FROM PR5_CUSTOMERS JOIN PR5_ORDERS USING(CUSTOMER_ID)
WHERE NLS_TERRITORY = 'GERMANY' 
MINUS 
SELECT CUSTOMER_ID,CUST_FIRST_NAME,CUST_LAST_NAME 
FROM PR5_CUSTOMERS  JOIN PR5_ORDERS USING(CUSTOMER_ID)JOIN PR5_ORDER_ITEMS USING(ORDER_ID);
/*7.Mostrar el código de cliente, nombre y apellidos (sin repetición) de aquellos clientes que han
realizado al menos un pedido de tipo (order_mode) online y otro direct.*/

SELECT DISTINCT CUSTOMER_ID,CUST_FIRST_NAME,CUST_LAST_NAME,count(order_id),ORDER_MODE 
FROM PR5_CUSTOMERS JOIN PR5_ORDERS  USING (CUSTOMER_ID)JOIN PR5_ORDER_ITEMS USING(ORDER_ID)
WHERE ORDER_MODE = 'DIRECT' AND ORDER_MODE = 'ONLINE' 
group by CUSTOMER_ID, CUST_FIRST_NAME, CUST_LAST_NAME, ORDER_MODE
UNION
SELECT DISTINCT CUSTOMER_ID,CUST_FIRST_NAME,CUST_LAST_NAME,COUNT(*),ORDER_MODE
FROM PR5_CUSTOMERS JOIN PR5_ORDERS  USING (CUSTOMER_ID) JOIN PR5_ORDER_ITEMS USING(ORDER_ID)
GROUP BY  CUSTOMER_ID, CUST_FIRST_NAME, CUST_LAST_NAME, ORDER_MODE HAVING COUNT(*) > 1;

/*8.Mostrar el nombre y apellidos de aquellos clientes que, habiendo realizado algún pedido,
nunca han realizado pedidos de tipo direct.*/
--AMBAS OPCIONES ESTÁN BIEN SALEN LOS MISMOS
--OPCION A<
SELECT DISTINCT C1.CUST_FIRST_NAME,C1.CUST_LAST_NAME 
FROM PR5_CUSTOMERS C1 JOIN PR5_ORDERS OR1 ON OR1.CUSTOMER_ID =C1.CUSTOMER_ID
MINUS
SELECT DISTINCT C2.CUST_FIRST_NAME,C2.CUST_LAST_NAME 
FROM PR5_CUSTOMERS C2 JOIN PR5_ORDERS OR2 ON OR2.CUSTOMER_ID =C2.CUSTOMER_ID
WHERE OR2.ORDER_MODE = 'DIRECT';
---OPCION B
SELECT DISTINCT C1.CUST_FIRST_NAME,C1.CUST_LAST_NAME 
FROM PR5_CUSTOMERS C1 JOIN PR5_ORDERS OR1 ON OR1.CUSTOMER_ID =C1.CUSTOMER_ID
WHERE NOT EXISTS
(SELECT DISTINCT C2.CUST_FIRST_NAME,C2.CUST_LAST_NAME 
FROM PR5_CUSTOMERS C2 JOIN PR5_ORDERS OR2 ON OR2.CUSTOMER_ID =C2.CUSTOMER_ID
WHERE OR2.ORDER_MODE = 'DIRECT');

/*9.Se quiere generar un listado de los productos que generan mayor beneficio. 
Mostrar el código
de producto, su precio mínimo, su precio de venta al público y el porcentaje de incremento
de precio. En el listado deben aparecer solo aquellos cuyo precio de venta al público ha
superado en un 30 % al precio mínimo.*/

SELECT I1.PRODUCT_ID ,I1.MIN_PRICE,O1.UNIT_PRICE,ROUND(O1.UNIT_PRICE-I1.MIN_PRICE*1.3,2)AS PORCENTS,ROUND(((O1.UNIT_PRICE*100) /I1.MIN_PRICE),2) AS BENEFIT
FROM PR5_PRODUCT_INFORMATION I1 JOIN PR5_ORDER_ITEMS O1 ON O1.PRODUCT_ID = I1.PRODUCT_ID
WHERE ROUND(O1.UNIT_PRICE-I1.MIN_PRICE*1.3,2)>= 0 AND I1.MIN_PRICE <> 0 ;--EL MIN_PRICE <> 0 PORQUE DECIA QUE HABIA PRODUCTOS CON PRECIO = 0

/*10.Mostrar el apellido de los empleados que ganen un 35% más del salario medio de su puesto.
El listado debe incluir el salario del empleado y su puesto.*/
SELECT E1.LAST_NAME,(JB.MIN_SALARY+ JB.MAX_SALARY)/2 AS MEDIUM_SALARY
FROM PR3_EMPLOYEES E1 JOIN PR3_JOBS JB ON JB.JOB_ID = E1.JOB_ID
WHERE E1.SALARY >= ROUND((((JB.MIN_SALARY+ JB.MAX_SALARY)/2)*1.35),2);

