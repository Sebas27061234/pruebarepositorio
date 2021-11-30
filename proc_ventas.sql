--Gestión Ventas
--Procedimientos almacenados
--Procedimiento Mostrar Venta
create proc spmostrar_venta
as
select top 100 v.idventa,
(t.apellidos +' '+ t.nombre) as Trabajador,
(c.apellidos + ' ' + c.nombre)  as Cliente,
v.fecha, v.tipo_comprobante,
v.serie, v.correlativo,
sum((d.precio_venta*
d.cantidad)-d.descuento) as Total
from detalle_venta d INNER JOIN venta v
on d.idventa = v.idventa
inner join cliente c
on v.idcliente = c.idcliente
inner join trabajador t
on v.idtrabajador = t.idtrabajador
group by
v.idventa,
t.apellidos +' '+ t.nombre,
c.apellidos+' '+c.nombre,
v.fecha, v.tipo_comprobante,
v.serie, v.correlativo
order by v.idventa desc
go

-- Procedimiento  Buscar venta por fecha
create proc spbuscar_venta_fecha
@textobuscar varchar(50),
@textobuscar2 varchar(50)
as
SELECT v.idventa,
(t.apellidos +' '+ t.nombre) as Trabajador,
(c.apellidos + ' ' + c.nombre)  as Cliente,
v.fecha, v.tipo_comprobante,
v.serie, v.correlativo,
sum((d.precio_venta*
d.cantidad)-d.descuento) as Total
from detalle_venta d inner join venta v
on d.idventa = v.idventa
inner join cliente c
on v.idcliente = c.idcliente
inner join trabajador t
on v.idtrabajador = t.idtrabajador
group by
v.idventa,
t.apellidos +' '+ t.nombre,
c.apellidos+' '+c.nombre,
v.fecha, v.tipo_comprobante,
v.serie, v.correlativo
having v.fecha>=@textobuscar and v.fecha<=@textobuscar2
go

-- Procedimiento  Insertar venta
create proc spinsertar_venta
@idventa int=null output,
@idcliente int,
@idtrabajador int,
@fecha date,
@tipo_comprobante varchar(20),
@serie varchar(4),
@correlativo varchar(7),
@igv decimal(4,2),
@estado varchar(7)
as
insert into venta(idcliente,idtrabajador,fecha,tipo_comprobante,serie,correlativo,igv)
values (@idcliente,@idtrabajador,@fecha,@tipo_comprobante,@serie,@correlativo,@igv)
--Obtenemos el codigo autogenerado 
set @idventa = @@IDENTITY
go

--Procedimiento eliminar venta
create proc speliminar_venta
@idventa int
as
delete from venta
where idventa=@idventa
go

--Procedimiento Insertar detalles de las ventas
create proc spinsertar_detalle_venta
@iddetalle_venta int output,
@idventa int,
@iddetalle_ingreso int,
@cantidad int,
@precio_venta money,
@descuento money
as
insert into detalle_venta (idventa,iddetalle_ingreso,cantidad,
precio_venta,descuento)
values (@idventa,@iddetalle_ingreso,@cantidad,
@precio_venta,@descuento)
go

--Restablecer el Stock despues de eliminar la venta y 
--sus detalles
create trigger trrestablecer_stock
on [detalle_venta]
for delete
as
Update di set di.stock_actual=di.stock_actual+dv.cantidad
from detalle_ingreso as di inner join
deleted as dv on di.iddetalle_ingreso=dv.iddetalle_ingreso
go

--Procedimiento almacenado para disminuir stock
create proc spdisminuir_stock
@iddetalle_ingreso int,
@cantidad int
as
update detalle_ingreso set stock_actual=stock_actual-@cantidad
where iddetalle_ingreso=@iddetalle_ingreso
go

--mostrar detalle de una ventas
create proc spmostrar_detalle_venta
@textobuscar int
as
select d.iddetalle_ingreso,a.nombre as Articulo,
d.cantidad,d.precio_venta,d.descuento,
((d.precio_venta*d.cantidad)-d.descuento) as Subtotal
from detalle_venta d inner join detalle_ingreso di
on d.iddetalle_ingreso=di.iddetalle_ingreso
inner join articulo a
on di.idarticulo=a.idarticulo
where d.idventa=@textobuscar
go

--Mostrar Artículos para la venta por nombre
create proc spbuscararticulo_venta_nombre
@textobuscar varchar(50)
as
select d.iddetalle_ingreso,a.Codigo,a.Nombre,c.nombre as Categoria,
p.nombre as Presentacion,d.stock_actual,d.precio_compra,
d.precio_venta,d.fecha_vencimiento
from articulo a inner join categoria c
on a.idcategoria=c.idcategoria
inner join presentacion p
on a.idpresentacion = p.idpresentacion
inner join detalle_ingreso d
on a.idarticulo=d.idarticulo
inner join ingreso i
on d.idingreso=i.idingreso
where a.nombre like @textobuscar + '%'
and d.stock_actual>0
and i.estado<>'ANULADO'
go

--Mostrar Artículos para la venta por Código
create proc spbuscararticulo_venta_codigo
@textobuscar varchar(50)
as
select a.Idarticulo,a.Codigo,a.Nombre,c.nombre as Categoria,
p.nombre as Presentacion,d.stock_actual,d.precio_compra,
d.precio_venta,d.fecha_vencimiento
from articulo a inner join categoria c
on a.idcategoria=c.idcategoria
inner join presentacion p
on a.idpresentacion = p.idpresentacion
inner join detalle_ingreso d
on a.idarticulo=d.idarticulo
inner join ingreso i
on i.idingreso=d.idingreso
where a.codigo=@textobuscar
and d.stock_actual>0
and i.estado<>'ANULADO'
go

