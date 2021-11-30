--Procedimiento Mostrar Cliente

create proc spmostrar_cliente
as
select  top 100 * FROM cliente
order by apellidos asc
go

-- Procedimiento  Buscar Cliente Apellidos

create proc spbuscar_cliente_apellidos
@textobuscar varchar(50)
as
select * FROM cliente
where apellidos like @textobuscar + '%'
go

-- Procedimiento  Buscar Cliente Num_Documento
create proc spbuscar_cliente_num_documento
@textobuscar varchar(50)
as
select * from cliente
where num_documento like @textobuscar + '%'
go

-- Procedimiento  Insertar Cliente
create proc spinsertar_cliente
@idcliente int output,
@nombre varchar(50),
@apellidos varchar(40),
@sexo varchar(1),
@fecha_nacimiento date,
@tipo_documento varchar(20),
@num_documento varchar(11),
@direccion varchar(100),
@telefono varchar(10),
@email varchar(50)
as
insert into cliente(nombre,apellidos,sexo,fecha_nacimiento,tipo_documento,num_documento,direccion,telefono,email)
values (@nombre,@apellidos,@sexo,@fecha_nacimiento,@tipo_documento,@num_documento,@direccion,@telefono,@email)
go

-- Procedimiento  Editar Cliente
create proc speditar_cliente
@idcliente int,
@nombre varchar(20),
@apellidos varchar(40),
@sexo varchar(1),
@fecha_nacimiento date,
@tipo_documento varchar(20),
@num_documento varchar(8),
@direccion varchar(100),
@telefono varchar(10),
@email varchar(50)
as
update cliente set nombre=@nombre,apellidos=@apellidos,sexo=@sexo,
fecha_nacimiento=@fecha_nacimiento,
tipo_documento=@tipo_documento,num_documento=@num_documento,
direccion=@direccion,telefono=@telefono,email=@email
where idcliente=@idcliente
go

-- Procedimiento  Eliminar Cliente
create proc speliminar_cliente
@idcliente int
as
delete from cliente
where idcliente=@idcliente
go