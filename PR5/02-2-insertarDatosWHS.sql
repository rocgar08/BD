INSERT INTO pr5_warehouses VALUES (1,NULL,'Southlake, Texas',1400, 
	MDSYS.SDO_GEOMETRY(2001, 8307, 
	MDSYS.SDO_POINT_TYPE(-103.00195, 36.500374, NULL), NULL, NULL)); 
INSERT INTO pr5_warehouses VALUES (2,NULL,'San Francisco',1500, 
	MDSYS.SDO_GEOMETRY(2001, 8307, 
	MDSYS.SDO_POINT_TYPE(-124.21014, 41.998016, NULL), NULL, NULL)); 
INSERT INTO pr5_warehouses VALUES (3,NULL,'New Jersey',1600, 
	MDSYS.SDO_GEOMETRY(2001, 8307, 
	MDSYS.SDO_POINT_TYPE(-74.695305, 41.35733, NULL), NULL, NULL)); 
INSERT INTO pr5_warehouses VALUES (4,NULL,'Seattle, Washington',1700, 
	MDSYS.SDO_GEOMETRY(2001, 8307, 
	MDSYS.SDO_POINT_TYPE(-123.61526, 46.257458, NULL), NULL, NULL)); 
INSERT INTO pr5_warehouses VALUES (5,NULL,'Toronto',1800,NULL);
INSERT INTO pr5_warehouses VALUES (6,NULL,'Sydney',2200,NULL);
INSERT INTO pr5_warehouses VALUES (7,NULL,'Mexico City',3200,NULL);
INSERT INTO pr5_warehouses VALUES (8,NULL,'Beijing',2000,NULL);
INSERT INTO pr5_warehouses VALUES (9,NULL,'Bombay',2100,NULL);


UPDATE pr5_warehouses SET warehouse_spec = sys.xmltype.createxml( 
'<?xml version="1.0"?> 
<Warehouse> 
<Building>Owned</Building> 
<Area>25000</Area> 
<Docks>2</Docks> 
<DockType>Rear load</DockType> 
<WaterAccess>Y</WaterAccess> 
<RailAccess>N</RailAccess> 
<Parking>Street</Parking> 
<VClearance>10 ft</VClearance> 
</Warehouse>' 
) WHERE warehouse_id = 1; 

UPDATE pr5_warehouses SET warehouse_spec = sys.xmltype.createxml( 
'<?xml version="1.0"?> 
<Warehouse> 
<Building>Rented</Building> 
<Area>50000</Area> 
<Docks>1</Docks> 
<DockType>Side load</DockType> 
<WaterAccess>Y</WaterAccess> 
<RailAccess>N</RailAccess> 
<Parking>Lot</Parking> 
<VClearance>12 ft</VClearance> 
</Warehouse>' 
) WHERE warehouse_id = 2; 

UPDATE pr5_warehouses SET warehouse_spec = sys.xmltype.createxml( 
'<?xml version="1.0"?> 
<Warehouse> 
<Building>Rented</Building> 
<Area>85700</Area> 
<DockType></DockType> 
<WaterAccess>N</WaterAccess> 
<RailAccess>N</RailAccess> 
<Parking>Street</Parking> 
<VClearance>11.5 ft</VClearance> 
</Warehouse>' 
) WHERE warehouse_id = 3; 

UPDATE pr5_warehouses SET warehouse_spec = sys.xmltype.createxml( 
'<?xml version="1.0"?> 
<Warehouse> 
<Building>Owned</Building> 
<Area>103000</Area> 
<Docks>3</Docks> 
<DockType>Side load</DockType> 
<WaterAccess>N</WaterAccess> 
<RailAccess>Y</RailAccess> 
<Parking>Lot</Parking> 
<VClearance>15 ft</VClearance> 
</Warehouse>' 
) WHERE warehouse_id = 4; 

