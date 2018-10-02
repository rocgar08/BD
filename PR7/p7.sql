SET serveroutput ON;
--1
--PRUEBA 1
select customer_id,cust_first_name, CUST_LAST_NAME
from PR5_CUSTOMERS
where CUSTOMER_ID = '116';
--PRUEBA 2
SELECT order_id, order_date, order_status, order_total
FROM PR5_ORDERS
WHERE customer_id = '101'
ORDER BY order_date;
--PRUEBA 3
SELECT SUM(order_total)
FROM Pr5_Orders
WHERE customer_id = '101';

--PROCEDIMIENTO
CREATE OR REPLACE PROCEDURE pedidosCliente(
    v_cust_id in PR5_CUSTOMERS.CUSTOMER_ID%TYPE
    )IS
    v_cust_fn pr5_Customers.cust_first_name%TYPE;
    v_cust_ln pr5_Customers.cust_last_name%TYPE;
    
    v_order_id pr5_orders.order_id%TYPE;
    v_order_date pr5_orders.order_date%TYPE;
    v_order_status pr5_orders.order_status%TYPE;
    v_order_total pr5_orders.order_total%TYPE;
    
    v_total_pedidos pr5_orders.order_total%TYPE;
    
    CURSOR c_datos_cliente IS
        SELECT cust_first_name, CUST_LAST_NAME
        FROM PR5_CUSTOMERS
        WHERE CUSTOMER_ID = v_cust_id;
        
    CURSOR c_pedidos IS
        SELECT order_id, order_date, order_status, order_total
        FROM PR5_ORDERS
        WHERE customer_id = v_cust_id
        ORDER BY order_date;
        
    no_cliente EXCEPTION;
    no_pedidos EXCEPTION;
BEGIN
    OPEN c_datos_cliente;
    FETCH c_datos_cliente INTO v_cust_fn, v_cust_ln;
    IF c_datos_cliente%NOTFOUND THEN
        RAISE no_cliente;
    END IF;
    DBMS_OUTPUT.PUT_LINE('Id: ' || v_cust_id);
    DBMS_OUTPUT.PUT_LINE('Nombre: ' || v_cust_fn);
    DBMS_OUTPUT.PUT_LINE('Apellido: ' || v_cust_ln);
    CLOSE c_datos_cliente;
    DBMS_OUTPUT.NEW_LINE();
    OPEN c_pedidos;
    DBMS_OUTPUT.PUT_LINE('Pedidos:');
    FETCH c_pedidos INTO v_order_id, v_order_date, v_order_status, v_order_total;
    IF c_pedidos%NOTFOUND THEN
        RAISE no_pedidos;
    END IF;
    WHILE c_pedidos%FOUND LOOP
        DBMS_OUTPUT.PUT_LINE('  Codigo: ' || v_order_id);
        DBMS_OUTPUT.PUT_LINE('  Fecha: ' || v_order_date);
        DBMS_OUTPUT.PUT_LINE('  Estado: ' || v_order_status);
        DBMS_OUTPUT.PUT_LINE('  Importe: ' || v_order_total);
        DBMS_OUTPUT.NEW_LINE();
        FETCH c_pedidos INTO v_order_id, v_order_date, v_order_status, v_order_total;
    END LOOP;
    CLOSE c_pedidos;
    
    SELECT SUM(order_total)
    INTO v_total_pedidos
    FROM Pr5_Orders
    WHERE customer_id = v_cust_id;
    
    DBMS_OUTPUT.PUT_LINE('Total Pedidos: ' || v_total_pedidos);
    DBMS_OUTPUT.PUT_LINE('---------------------------------------------');
EXCEPTION
    WHEN no_cliente THEN
        DBMS_OUTPUT.PUT_LINE('ERROR: ID '|| v_cust_id || ' no encontrado');
        DBMS_OUTPUT.PUT_LINE('---------------------------------------------');
    WHEN no_pedidos THEN
        DBMS_OUTPUT.PUT_LINE('No hay pedidos para el cliente con ID: '|| v_cust_id);
        DBMS_OUTPUT.PUT_LINE('---------------------------------------------');
END;
/

BEGIN
pedidosCliente('101');
pedidosCliente('102');
pedidosCliente('1');
pedidosCliente('981');
END;
/
/*SELECT DISTINCT c1.customer_id,cust_first_name, cust_last_name,order_date,order_total
FROM pr5_customers C1  JOIN pr5_orders o1 ON o1.customer_id = c1.customer_id
ORDER BY order_date ASC;



CREATE OR REPLACE PROCEDURE pedidosCliente(v_cust_id  pr5_Customers.customer_id%TYPE) IS
   v_order_id pr5_orders.order_id%TYPE;
   v_order_date pr5_orders.order_date%TYPE;
   v_order_total NUMBER(8,2):=0;
   
   v_cust_f pr5_Customers.cust_first_name%TYPE;
   v_cust_l pr5_Customers.cust_last_name%TYPE;
   
   CURSOR c_customers IS
    SELECT DISTINCT c1.customer_id,cust_first_name,cust_last_name,order_date,order_total,
    FROM pr5_customers C1  JOIN pr5_orders o1 ON o1.customer_id = c1.customer_id
    WHERE c1.customer_id = v_cust_id
    ORDER BY order_date ASC;
   
  BEGIN
  OPEN c_customers;
    FETCH c_customers INTO v_cust_f, v_cust_l,v_order_date,v_order_total;
      FOR r_customers IN c_customers LOOP
          IF c_customers%found THEN 
            v_order_total:= v_order_total+1;
            dbms_output.put_line('Codigo: ' || r_customers.customer_id);
            dbms_output.put_line('Fecha: ' || r_customers.order_date);
            dbms_output.put_line('Estado: ' || r_customers.order_status);
            dbms_output.put_line('Importe: ' || r_customers.order_total);
          END IF;
          FETCH c_customers INTO v_cust_f, v_cust_l,v_order_date,v_order_total;
       END LOOP;
      
   CLOSE c_customers;
 IF v_cust_id = 0  OR  v_order_id= 0 THEN 
  dbms_output.put_line('No hay cliente o no existe el pedido');
 END IF;
END;
/
BEGIN 
 DBMS_OUTPUT.PUT_LINE('No hay cliente');
END;
/
*/
--2 Prueba CONSULTAS
 SELECT SUM(UNIT_PRICE*QUANTITY), order_total
 FROM PR5_ORDER_ITEMS JOIN pr5_orders USING(ORDER_ID)
 GROUP BY order_total,order_id 
 HAVING SUM(UNIT_PRICE*QUANTITY)<>order_total;
--2 PROCEDIMIENTO
CREATE OR REPLACE PROCEDURE REVISTAPEDIDOS IS
  V_ORDER_TOTAL PR5_ORDER_ITEMS.UNIT_PRICE%TYPE;
  v_orders_total PR5_ORDERS.ORDER_TOTAL%TYPE;
  V_ORDER_ID PR5_ORDERS.ORDER_ID%TYPE;
  
  CURSOR c_order IS
    SELECT SUM(UNIT_PRICE*QUANTITY), order_total, ORDER_ID
    FROM PR5_ORDER_ITEMS JOIN pr5_orders USING(ORDER_ID)
    WHERE V_ORDER_TOTAL = pr5_orders.order_total 
   GROUP BY order_total,order_id;
BEGIN 
     DBMS_OUTPUT.PUT_LINE('Pedido: ' || V_ORDER_ID );
  OPEN c_order;
    FETCH c_order INTO v_order_total, v_orders_total, V_ORDER_ID;
      WHILE c_order%found LOOP
        IF V_ORDER_TOTAL <>  v_orders_total THEN
          DBMS_OUTPUT.PUT_LINE('Pedido: ' || V_ORDER_ID );
          DBMS_OUTPUT.PUT_LINE('TotalOrder: '  || V_ORDER_TOTAL);
          DBMS_OUTPUT.PUT_LINE('TotalOrderItem: ' || V_ORDERS_TOTAL);
        END IF;
       FETCH c_order INTO v_order_total, v_orders_total, V_ORDER_ID;
    
     END LOOP;
    CLOSE c_order;
END;
/

--3
--A
ALTER TABLE pr5_product_information ADD quantity NUMBER(8);
--B
DECLARE
  v_prId_inv pr5_inventories.product_id%TYPE;
  v_quant pr5_inventories.quantity_on_hand%TYPE;
  
  v_prId_PI pr5_product_information.product_id%TYPE;
  
  CURSOR c_prId IS
    SELECT product_id
    FROM pr5_product_information
    ORDER BY product_id;
  
  CURSOR c_quantity IS
    SELECT product_id, sum(quantity_on_hand)
    FROM pr5_inventories
    group by product_id
    ORDER BY product_id;
BEGIN
  OPEN c_quantity;
  OPEN c_prId;
  FETCH C_QUANTITY INTO v_prId_inv, v_quant;
  FETCH C_PRID INTO V_PRID_PI;
  
  FOR V_PRID_PI in c_prid loop
    IF v_prId_inv = V_PRID_PI then
        update pr5_product_information
        set quantity = v_quant
        WHERE V_PRID_PI = PRODUCT_ID; 
        FETCH C_QUANTITY INTO v_prId_inv, V_QUANTITY;
        FETCH C_PRID INTO V_PRID_PI;
    ELSE
        update pr5_product_information
        SET QUANTITY = 0
        WHERE V_PRID_PI <> PRODUCT_ID;
        FETCH C_PRID INTO V_PRID_PI;
    END IF;

  END LOOP;
  close c_quantity;
  close c_prId;
  
END;