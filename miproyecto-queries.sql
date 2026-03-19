use aceitunasdb;

-- =====================================================
-- 1. consultas
-- =====================================================

-- 1º consulta
-- mostrar cuántos días ha trabajado cada empleado en cada campaña.

select e.nombre, c.año, COUNT(*) AS 'Días Trabajados'
from EMPLEADO e
	inner join RECOGIDOS rd
  		on e.DNI = rd.EMPLEADO_DNI
	inner join RECOGIDA r
  		on rd.RECOGIDA_fechaRecogida = r.fechaRecogida
	inner join `CAMPAÑA` c
 		on r.CAMPAÑA_idCAMPAÑA = c.idCampaña
group by e.nombre, c.año
order by c.año, e.nombre;


-- 2º consulta
-- mostrar los kilos totales recogidos por cada campaña.

select c.año, SUM(r.kilosRecogidos) AS 'Kilos Totales'
from CAMPAÑA c
	inner join RECOGIDA r
		on c.idCampaña = r.CAMPAÑA_idCAMPAÑA
group by c.año
order by c.año;


-- 3º consulta
-- empleados cuyo pago medio supera la media general,
-- que se vea también su media de pago sin decimales.

select e.nombre, CONCAT(TRUNCATE(AVG(p.importe), 0), '€') as 'Media de Pagos'
from EMPLEADO e
	inner join PAGO p
		on e.DNI = p.EMPLEADO_DNI
group by e.nombre
having AVG(p.importe) > (
	select AVG(importe)
	from PAGO
);


-- 4º consulta
-- duración de cada campaña en días.

select c.año, CONCAT_WS(' / ', c.fechaInicio, c.fechaFin) as 'Rango de Fechas',
DATEDIFF(c.fechaFin, c.fechaInicio) as 'Duración (días)'
from `CAMPAÑA` c
order by c.año;


-- 5º consulta
-- mostrar el nombre en mayúsculas, los apellidos en minúsculas,
-- el nombre completo, la longitud del nombre, las 3 primeras letras del dni
-- y los 2 últimos dígitos del teléfono.

select
	UPPER(e.nombre) as 'Nombre Mayúsculas',
	LOWER(e.apellidos) as 'Apellidos Minúsculas',
	CONCAT_WS(' ', e.nombre, e.apellidos) as 'Nombre Completo',
	LENGTH(e.nombre) as 'Longitud Nombre',
	LEFT(e.DNI, 3) as 'Inicio DNI',
	RIGHT(e.telefono, 2) as 'Últimos 2 Dígitos del Teléfono'
from EMPLEADO e
order by e.nombre;


-- 6º consulta
-- mostrar los manijeros y cuántos días han trabajado.
-- si no han trabajado ningún día, que aparezca 0.

select e.nombre, m.zonaResponsable,
	IFNULL(COUNT(rd.RECOGIDA_fechaRecogida), 0) as 'Días Trabajados'
from MANIJERO m
	inner join EMPLEADO e
		on e.DNI = m.EMPLEADO_DNI
	left join RECOGIDOS rd
		on rd.EMPLEADO_DNI = e.DNI
group by e.nombre, m.zonaResponsable
order by `Días Trabajados` desc, e.nombre;


-- 7º consulta
-- el empleado que ha trabajado más días que todos los empleados sin usar limit.

select e.nombre, COUNT(*) as 'Días Trabajados'
from EMPLEADO e
	inner join RECOGIDOS r
		on r.EMPLEADO_DNI = e.DNI
group by e.DNI, e.nombre
having COUNT(*) >= ALL (
	select COUNT(*)
	from EMPLEADO e2
		inner join RECOGIDOS r2
			on r2.EMPLEADO_DNI = e2.DNI
	group by e2.DNI
)
order by e.nombre;


-- =====================================================
-- 2. vistas
-- =====================================================

-- 1º vista
-- crear una vista que muestre el nombre del empleado, la fecha del pago y el importe.

drop view if exists vista_pagos_empleados;

create view vista_pagos_empleados as
select e.nombre, p.fechaPago, p.importe
from EMPLEADO e
	inner join PAGO p
		on e.DNI = p.EMPLEADO_DNI;

select * from vista_pagos_empleados;


-- 2º vista
-- crear una vista que muestre el total de kilos y dinero vendido
-- por campaña y cooperativa, sin decimales y con símbolo €.

drop view if exists vista_total_ventas;

create view vista_total_ventas as
select
	c.año,
	v.COOPERATIVA_nombre as 'Cooperativa',
	TRUNCATE(SUM(v.kilosEntregados),0) as 'Kilos Totales',
	CONCAT(TRUNCATE(SUM(v.totalPagado),0), ' €') as 'Total Vendido'
from CAMPAÑA c
	inner join VENTA v
		on c.idCampaña = v.CAMPAÑA_idCAMPAÑA
group by c.año, v.COOPERATIVA_nombre
order by c.año, v.COOPERATIVA_nombre;

select * from vista_total_ventas;


-- =====================================================
-- 3. funciones
-- =====================================================

-- 1º función

drop function if exists calcular_pago_mensual;

delimiter //

create function calcular_pago_mensual(p_dni varchar(9), p_año int, p_mes int)
returns double
deterministic
begin
	declare total double;

	select (count(*) * 50) into total
	from RECOGIDOS
	where empleado_dni = p_dni
	  and year(recogida_fecharecogida) = p_año
	  and month(recogida_fecharecogida) = p_mes;

	return total;
end //

delimiter ;

select calcular_pago_mensual('10293847H', 2025, 7);


-- 2º función

drop function if exists total_vendido_campaña;

delimiter //

create function total_vendido_campaña(p_idcampaña int)
returns double
deterministic
begin
	declare total double;

	select sum(totalpagado) into total
	from VENTA
	where campaña_idcampaña = p_idcampaña;

	return total;
end //

delimiter ;

select total_vendido_campaña(1);


-- =====================================================
-- 4. procedimientos
-- =====================================================

-- 1º procedimiento

drop procedure if exists mostrar_pago_mensual;

delimiter //

create procedure mostrar_pago_mensual(in p_dni varchar(9), p_año int, p_mes int)
begin
	select p_dni as dni, p_año as año, p_mes as mes,
		   calcular_pago_mensual(p_dni, p_año, p_mes) as pago_mensual;
end //

delimiter ;

call mostrar_pago_mensual('10293847H', 2025, 7);


-- 2º procedimiento

drop procedure if exists insertar_pago_mensual;

delimiter //

create procedure insertar_pago_mensual(in p_dni varchar(9), in p_año int, in p_mes int)
begin
	insert into PAGO (empleado_dni, fechapago, importe)
	values (p_dni, concat(p_año, '-', p_mes, '-01'), calcular_pago_mensual(p_dni, p_año, p_mes));
end //

delimiter ;

call insertar_pago_mensual('10293847H', 2026, 7);


-- 3º procedimiento

drop procedure if exists resumen_campaña;

delimiter //

create procedure resumen_campaña(in p_idcampaña int)
begin
	select c.año, c.kilosTotales, total_vendido_campaña(p_idcampaña) as total_vendido
	from CAMPAÑA c
	where c.idcampaña = p_idcampaña;
end //

delimiter ;

call resumen_campaña(1);


-- =====================================================
-- 5. triggers
-- =====================================================

-- 1º trigger

drop trigger if exists comprobar_importe_pago;

delimiter //

create trigger comprobar_importe_pago
before insert on PAGO
for each row
begin
	if new.importe <= 0 then
		signal sqlstate '45000'
		set message_text = 'El importe del pago no puede ser menor o igual que 0';
	end if;
end //

delimiter ;

-- prueba del 1º trigger
insert into PAGO (empleado_dni, fechapago, importe)
values ('10293847H', '2025-11-30', 0);


-- 2º trigger

drop trigger if exists actualizar_kilos_campaña;

delimiter //

create trigger actualizar_kilos_campaña
after insert on RECOGIDA
for each row
begin
	update CAMPAÑA
	set kilosTotales = kilosTotales + new.kilosrecogidos
	where idcampaña = new.campaña_idcampaña;
end //

delimiter ;

-- prueba del 2º trigger
select idcampaña, año, kilosTotales
from CAMPAÑA
where idcampaña = 3;

insert into RECOGIDA (fecharecogida, kilosrecogidos, campaña_idcampaña)
values ('2025-11-21', 5000, 3);

select idcampaña, año, kilosTotales
from CAMPAÑA
where idcampaña = 3;