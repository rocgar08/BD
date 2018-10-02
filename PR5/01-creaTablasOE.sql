CREATE TYPE pr5_cust_address_typ
AS OBJECT
    ( street_address     VARCHAR2(40)
    , postal_code        VARCHAR2(10)
    , city               VARCHAR2(30)
    , state_province     VARCHAR2(10)
    , country_id         CHAR(2)
    );
/
CREATE TYPE pr5_phone_list_typ
AS VARRAY(5) OF VARCHAR2(25);
/
CREATE TABLE pr5_customers
    ( customer_id        NUMBER(6) PRIMARY KEY,  
      cust_first_name    VARCHAR2(20) NOT NULL,
      cust_last_name     VARCHAR2(20) NOT NULL,
      cust_address       pr5_cust_address_typ,
      phone_numbers      pr5_phone_list_typ,
      nls_language       VARCHAR2(3),
      nls_territory      VARCHAR2(30),
      credit_limit       NUMBER(9,2),
      cust_email         VARCHAR2(30),
      account_mgr_id     NUMBER(6),
      cust_geo_location  MDSYS.SDO_GEOMETRY
    ) ;
/
CREATE TABLE pr5_warehouses
    ( warehouse_id       NUMBER(3) PRIMARY KEY, 
      warehouse_spec     SYS.XMLTYPE,
      warehouse_name     VARCHAR2(35),
      location_id        NUMBER(4),
      wh_geo_location    MDSYS.SDO_GEOMETRY
    ) ;
	
CREATE TABLE pr5_order_items
    ( order_id           NUMBER(12), 
      line_item_id       NUMBER(3)  NOT NULL,
      product_id         NUMBER(6)  NOT NULL,
      unit_price         NUMBER(8,2),
      quantity           NUMBER(8),
	 PRIMARY KEY (order_id, line_item_id)
    ) ;

CREATE TABLE pr5_orders
    ( order_id           NUMBER(12) PRIMARY KEY,
      order_date         TIMESTAMP WITH LOCAL TIME ZONE NOT NULL,
      order_mode         VARCHAR2(8),
      customer_id        NUMBER(6) NOT NULL,
      order_status       NUMBER(2),
      order_total        NUMBER(8,2),
      sales_rep_id       NUMBER(6),
      promotion_id       NUMBER(6)
    ) ;
    
CREATE TABLE pr5_inventories
  ( product_id         NUMBER(6),
    warehouse_id       NUMBER(3) NOT NULL,
    quantity_on_hand   NUMBER(8) NOT NULL,
    PRIMARY KEY (product_id, warehouse_id)
  ) ;

CREATE TABLE pr5_product_information
    ( product_id          NUMBER(6) PRIMARY KEY,
      product_name        VARCHAR2(50),
      product_description VARCHAR2(2000),
      category_id         NUMBER(2),
      weight_class        NUMBER(1),
      warranty_period     INTERVAL YEAR TO MONTH,
      supplier_id         NUMBER(6),
      product_status      VARCHAR2(20),
      list_price          NUMBER(8,2),
      min_price           NUMBER(8,2),
      catalog_url         VARCHAR2(50)
    ) ;

CREATE TABLE pr5_product_descriptions
    ( product_id             NUMBER(6)
    , language_id            VARCHAR2(3)
    , translated_name        NVARCHAR2(50) NOT NULL
    , translated_description NVARCHAR2(2000) NOT NULL
	, PRIMARY KEY (product_id, language_id)
    );

ALTER TABLE pr5_orders 
ADD ( CONSTRAINT pr5_orders_sales_rep_fk 
      FOREIGN KEY (sales_rep_id) 
      REFERENCES pr3_employees(employee_id)
      ON DELETE SET NULL
    ) ;

ALTER TABLE pr5_orders 
ADD ( CONSTRAINT pr5_orders_customer_id_fk 
      FOREIGN KEY (customer_id) 
      REFERENCES pr5_customers(customer_id) 
      ON DELETE SET NULL 
    ) ;

ALTER TABLE pr5_warehouses 
ADD ( CONSTRAINT pr5_warehouses_location_fk 
      FOREIGN KEY (location_id)
      REFERENCES pr3_locations(location_id)
      ON DELETE SET NULL
    ) ;

ALTER TABLE pr5_customers
ADD ( CONSTRAINT pr5_cust_account_manager_fk
      FOREIGN KEY (account_mgr_id)
      REFERENCES pr3_employees(employee_id)
      ON DELETE SET NULL
    ) ;

ALTER TABLE pr5_inventories 
ADD ( CONSTRAINT pr5_inventories_warehouses_fk 
      FOREIGN KEY (warehouse_id)
      REFERENCES pr5_warehouses (warehouse_id)
      ENABLE NOVALIDATE
    ) ;

ALTER TABLE pr5_inventories 
ADD ( CONSTRAINT pr5_inventories_product_id_fk 
      FOREIGN KEY (product_id)
      REFERENCES pr5_product_information (product_id)
    ) ;

ALTER TABLE pr5_order_items
ADD ( CONSTRAINT pr5_order_items_order_id_fk 
      FOREIGN KEY (order_id)
      REFERENCES pr5_orders(order_id)
      ON DELETE CASCADE
    ) ;

ALTER TABLE pr5_order_items
ADD ( CONSTRAINT pr5_order_items_product_id_fk 
      FOREIGN KEY (product_id)
      REFERENCES pr5_product_information(product_id)
    ) ;

ALTER TABLE pr5_product_descriptions
ADD ( CONSTRAINT pd_product_id_fk
      FOREIGN KEY (product_id)
      REFERENCES pr5_product_information(product_id)
    ) ;

ALTER TABLE pr5_warehouses
ADD ( CONSTRAINT pd_location_id_fk
      FOREIGN KEY (location_id)
      REFERENCES pr3_locations(location_id)
    ) ;


CREATE SEQUENCE pr5_orders_seq
 START WITH     1000
 INCREMENT BY   1
 NOCACHE
 NOCYCLE;