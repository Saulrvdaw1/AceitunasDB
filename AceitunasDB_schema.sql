CREATE DATABASE IF NOT EXISTS aceitunasdb;
USE aceitunasdb;

-- aceitunasdb.CAMPAÑA definition

CREATE TABLE `CAMPAÑA` (
  `idCampaña` int NOT NULL,
  `año` year DEFAULT NULL,
  `fechaInicio` date DEFAULT NULL,
  `fechaFin` date DEFAULT NULL,
  `kilosTotales` double DEFAULT NULL,
  PRIMARY KEY (`idCampaña`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;


-- aceitunasdb.COOPERATIVA definition

CREATE TABLE `COOPERATIVA` (
  `nombre` varchar(30) NOT NULL,
  `direccion` varchar(45) NOT NULL,
  `telefono` varchar(15) DEFAULT NULL,
  PRIMARY KEY (`nombre`,`direccion`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;


-- aceitunasdb.EMPLEADO definition

CREATE TABLE `EMPLEADO` (
  `DNI` varchar(9) NOT NULL,
  `nombre` varchar(25) DEFAULT NULL,
  `apellidos` varchar(45) DEFAULT NULL,
  `telefono` varchar(15) NOT NULL,
  `carnetConducir` enum('A1','A2','B','C1','C','D1','D','Ninguno') DEFAULT 'Ninguno',
  PRIMARY KEY (`DNI`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;


-- aceitunasdb.MANIJERO definition

CREATE TABLE `MANIJERO` (
  `zonaResponsable` varchar(50) NOT NULL,
  `EMPLEADO_DNI` varchar(9) NOT NULL,
  KEY `fk_MANIJERO_EMPLEADO1_idx` (`EMPLEADO_DNI`),
  CONSTRAINT `fk_MANIJERO_EMPLEADO1` FOREIGN KEY (`EMPLEADO_DNI`) REFERENCES `EMPLEADO` (`DNI`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;


-- aceitunasdb.PAGO definition

CREATE TABLE `PAGO` (
  `EMPLEADO_DNI` varchar(9) NOT NULL,
  `fechaPago` date NOT NULL,
  `importe` double NOT NULL,
  `idVENTA` int DEFAULT NULL,
  `fechaEntrega` varchar(50) DEFAULT NULL,
  `kilosEntregados` double DEFAULT NULL,
  `CAMPAÑA_idCAMPAÑA` int DEFAULT NULL,
  `COOPERATIVA_nombre` varchar(50) DEFAULT NULL,
  `COOPERATIVA_direccion` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`EMPLEADO_DNI`,`fechaPago`),
  CONSTRAINT `fk_pagos_empleado` FOREIGN KEY (`EMPLEADO_DNI`) REFERENCES `EMPLEADO` (`DNI`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;


-- aceitunasdb.RECOGIDA definition

CREATE TABLE `RECOGIDA` (
  `fechaRecogida` date NOT NULL,
  `kilosRecogidos` double DEFAULT NULL,
  `CAMPAÑA_idCAMPAÑA` int NOT NULL,
  PRIMARY KEY (`fechaRecogida`),
  KEY `fk_RECOGIDA_CAMPAÑA1_idx` (`CAMPAÑA_idCAMPAÑA`),
  CONSTRAINT `fk_RECOGIDA_CAMPAÑA1` FOREIGN KEY (`CAMPAÑA_idCAMPAÑA`) REFERENCES `CAMPAÑA` (`idCampaña`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;


-- aceitunasdb.RECOGIDOS definition

CREATE TABLE `RECOGIDOS` (
  `EMPLEADO_DNI` varchar(9) NOT NULL,
  `RECOGIDA_fechaRecogida` date NOT NULL,
  PRIMARY KEY (`EMPLEADO_DNI`,`RECOGIDA_fechaRecogida`),
  KEY `fk_EMPLEADO_has_RECOGIDA_RECOGIDA1_idx` (`RECOGIDA_fechaRecogida`),
  KEY `fk_EMPLEADO_has_RECOGIDA_EMPLEADO1_idx` (`EMPLEADO_DNI`),
  CONSTRAINT `fk_EMPLEADO_has_RECOGIDA_EMPLEADO1` FOREIGN KEY (`EMPLEADO_DNI`) REFERENCES `EMPLEADO` (`DNI`),
  CONSTRAINT `fk_EMPLEADO_has_RECOGIDA_RECOGIDA1` FOREIGN KEY (`RECOGIDA_fechaRecogida`) REFERENCES `RECOGIDA` (`fechaRecogida`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;


-- aceitunasdb.RECOLECTOR definition

CREATE TABLE `RECOLECTOR` (
  `fechaInicioExperiencia` year NOT NULL,
  `EMPLEADO_DNI` varchar(9) NOT NULL,
  KEY `fk_RECOLECTOR_EMPLEADO1_idx` (`EMPLEADO_DNI`),
  CONSTRAINT `fk_RECOLECTOR_EMPLEADO1` FOREIGN KEY (`EMPLEADO_DNI`) REFERENCES `EMPLEADO` (`DNI`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;


-- aceitunasdb.VENTA definition

CREATE TABLE `VENTA` (
  `idVENTA` int NOT NULL,
  `fechaEntrega` date DEFAULT NULL,
  `kilosEntregados` double DEFAULT NULL,
  `totalPagado` double DEFAULT NULL,
  `CAMPAÑA_idCAMPAÑA` int NOT NULL,
  `COOPERATIVA_nombre` varchar(30) NOT NULL,
  `COOPERATIVA_direccion` varchar(45) NOT NULL,
  PRIMARY KEY (`idVENTA`),
  KEY `fk_VENTA_CAMPAÑA1_idx` (`CAMPAÑA_idCAMPAÑA`),
  KEY `fk_VENTA_COOPERATIVA1_idx` (`COOPERATIVA_nombre`,`COOPERATIVA_direccion`),
  CONSTRAINT `fk_VENTA_CAMPAÑA1` FOREIGN KEY (`CAMPAÑA_idCAMPAÑA`) REFERENCES `CAMPAÑA` (`idCampaña`),
  CONSTRAINT `fk_VENTA_COOPERATIVA1` FOREIGN KEY (`COOPERATIVA_nombre`, `COOPERATIVA_direccion`) REFERENCES `COOPERATIVA` (`nombre`, `direccion`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;