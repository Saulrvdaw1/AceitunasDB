-- proyecto_data.sql
-- Proyecto Base de Datos: Gestión de Recolección de Aceitunas

-- La carga masiva de datos se ha realizado principalmente mediante
-- la importación de archivos CSV utilizando la herramienta DBeaver,
-- tal y como se explica en el apartado 4 del PDF.

-- Inserción manual de la tabla COOPERATIVA
INSERT INTO COOPERATIVA (nombre, direccion, telefono) VALUES
('AljaOliva S.L.', 'Ctra. Bormujos-Bollullos km 9', 955766902),
('Aceitunas Morbe', 'Calle Lepanto, 8', 662132992),
('Labradores de la Campiña', 'Bollullos de la Mitación', 955766000);

-- Inserción de datos en la tabla VENTA

INSERT INTO VENTA
(idVENTA, fechaEntrega, kilosEntregados, totalPagado, CAMPAÑA_idCAMPAÑA, COOPERATIVA_nombre, COOPERATIVA_direccion)
VALUES
(1,'2023-07-31',87404.0,786636.0,1,'Aceitunas Morbe','Calle Lepanto, 8'),
(2,'2023-08-31',111326.0,1001934.0,1,'Aceitunas Morbe','Calle Lepanto, 8'),
(3,'2023-09-30',1184340.0,1065906.0,1,'Aceitunas Morbe','Calle Lepanto, 8'),
(4,'2023-10-31',123038.0,1107342.0,1,'AljaOliva S.L.','Ctra. Bormujos-Bollullos km 9'),
(5,'2023-11-30',118501.0,106650.9,1,'AljaOliva S.L.','Ctra. Bormujos-Bollullos km 9'),
(6,'2023-12-31',118476.0,1066284.0,1,'AljaOliva S.L.','Ctra. Bormujos-Bollullos km 9'),
(7,'2024-07-31',201400.0,181260.0,2,'Labradores de la Campiña','Bollullos de la Mitación'),
(8,'2024-08-31',201394.0,1812546.0,2,'Labradores de la Campiña','Bollullos de la Mitación'),
(9,'2024-09-30',192634.0,173370.6,2,'Labradores de la Campiña','Bollullos de la Mitación'),
(10,'2024-10-31',201014.0,180912.6,2,'Aceitunas Morbe','Calle Lepanto, 8'),
(11,'2024-11-30',201019.0,180917.1,2,'Aceitunas Morbe','Calle Lepanto, 8'),
(12,'2024-12-20',128637.0,115773.3,2,'Aceitunas Morbe','Calle Lepanto, 8'),
(13,'2025-07-31',133020.0,119718.0,3,'AljaOliva S.L.','Ctra. Bormujos-Bollullos km 9'),
(14,'2025-08-31',133025.0,119722.5,3,'AljaOliva S.L.','Ctra. Bormujos-Bollullos km 9'),
(15,'2025-09-30',129010.0,116109.0,3,'AljaOliva S.L.','Ctra. Bormujos-Bollullos km 9'),
(16,'2025-10-30',138455.0,124609.5,3,'Labradores de la Campiña','Bollullos de la Mitación'),
(17,'2025-11-20',86270.0,77643.0,3,'Labradores de la Campiña','Bollullos de la Mitación');


-- (el resto de tablas se cargaron mediante importación CSV)