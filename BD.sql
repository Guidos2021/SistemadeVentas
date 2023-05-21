
select * from USUARIO
/*
insert into USUARIO(Documento,NombreCompleto,Correo,Clave,IdRol,Estado)
values('000000','Empleado1','Empleado@gmail.com','123',2,1)
*/

select * from ROL
/*
insert into ROL(Descripcion)
values('Administrador')

insert into ROL(Descripcion)
values('Empleado')

insert into USUARIO(Documento,NombreCompleto,Correo,Clave,IdRol,Estado)
values('060476067','Gilberto G. Vela G.','Gilbertovela@gmail.com','123',1,1)
*/

select * from PERMISOS
/*
insert into PERMISOS(IdRol,NombreMenu)values
(1,'menuusuarios'),
(1,'menumantenedor'),
(1,'menuventas'),
(1,'menucompras'),
(1,'menuclientes'),
(1,'menuproveedores'),
(1,'menureportes'),
(1,'menuacercade')

insert into PERMISOS(IdRol,NombreMenu)values
(2,'menuventas'),
(2,'menucompras'),
(2,'menuclientes'),
(2,'menuproveedores'),
(2,'menuacercade')
*/

select p.IdRol,p.NombreMenu from PERMISOS p 
inner join ROL r on r.IdRol = p.IdRol 
inner join USUARIO u on u.IdRol = p.IdRol 
where u.IdUsuario = 2


select u.IdUsuario,u.Documento,u.NombreCompleto,u.Correo,u.Clave,u.Estado,r.IdRol
,r.Descripcion from USUARIO u inner join ROL r on r.IdRol = u.IdRol

update USUARIO set Estado = 0 where IdUsuario = 2

create proc SP_REGISTRARUSUARIO(
@Documento varchar(50),
@NombreCompleto varchar(100),
@Correo varchar(100),
@Clave varchar(100),
@IdRol int,
@Estado bit,
@IdUsuarioResultado int output,
@Mensaje varchar(500) output
)
as
begin
	set @IdUsuarioResultado = 0
	set @Mensaje = ''

	if not exists(select * from USUARIO where Documento = @Documento)
	begin
		insert into USUARIO(Documento,NombreCompleto,Correo,Clave,IdRol,Estado)values
		(@Documento,@NombreCompleto,@Correo,@Clave,@IdRol,@Estado)

		set @IdUsuarioResultado = SCOPE_IDENTITY()
	end
	else
	set @Mensaje = 'Numero de documento ya registrado..'
end



create proc SP_EDITARUSUARIO(
@IdUsuario int,
@Documento varchar(50),
@NombreCompleto varchar(100),
@Correo varchar(100),
@Clave varchar(100),
@IdRol int,
@Estado bit,
@Respuesta bit output,
@Mensaje varchar(500) output
)
as
begin
	set @Respuesta = 0
	set @Mensaje = ''

	if not exists(select * from USUARIO where Documento = @Documento and IdUsuario != @IdUsuario)
	begin
		update USUARIO set
		Documento = @Documento,
		NombreCompleto = @NombreCompleto,
		Correo = @Correo,
		Clave = @Clave,
		IdRol = @IdRol,
		Estado = @Estado
		where IdUsuario = @IdUsuario
		set @Respuesta = 1
	end
	else
	set @Mensaje = 'Numero de documento ya registrado..'
end


create proc SP_ELIMINARUSUARIO(
@IdUsuario int,
@Respuesta bit output,
@Mensaje varchar(500) output
)
as
begin
	set @Respuesta = 0
	set @Mensaje = ''
	declare @pasoreglas bit = 1

	if exists(select * from COMPRA C
	inner join USUARIO U on U.IdUsuario = C.IdUsuario
	where U.IdUsuario = @IdUsuario
	)
	begin 
		set @pasoreglas = 0
		set @Respuesta = 0
		set @Mensaje = @Mensaje + 'No se puede eliminar porque El usuario tiene una compra pendiente..\n'
	end

	if exists(select * from VENTA V
	inner join USUARIO U on U.IdUsuario = V.IdUsuario
	where U.IdUsuario = @IdUsuario
	)
	begin 
		set @pasoreglas = 0
		set @Respuesta = 0
		set @Mensaje = @Mensaje + 'No se puede eliminar porque El usuario tiene una venta pendiente..\n'
	end

	if(@pasoreglas = 1)
	begin
		delete from USUARIO where IdUsuario = @IdUsuario
		set @Respuesta = 1
	end
end


select * from USUARIO


/*---------- PROCEDIMIENTOS PARA CATEGORIAS */

--Procedimiento para agregar Categoria
alter proc SP_RegistrarCategoria(
@Descripcion varchar(50),
@Estado bit,
@Resultado int output,
@Mensaje varchar(500) output
)
as
begin
	set @Resultado = 0
	if not exists(select * from CATEGORIA where Descripcion = @Descripcion)
	begin 
		insert into CATEGORIA(Descripcion,Estado) values(@Descripcion,@Estado)
		set @Resultado = SCOPE_IDENTITY()
	end
	else
	begin
		set @Mensaje = 'No se puede repetir Descripcion.'
	end
end	
Go
--Procedimiento para Editar Categoria
alter proc SP_EditarCategoria(
@IdCategoria int,
@Descripcion varchar(50),
@Estado bit,
@Resultado int output,
@Mensaje varchar(500) output
)
as
begin
	set @Resultado = 1
	if not exists(select * from CATEGORIA where Descripcion = @Descripcion and IdCategoria != @IdCategoria)
	begin 
		update CATEGORIA set
		Descripcion = @Descripcion,
		Estado = @Estado
		where IdCategoria = @IdCategoria
	end
	else
	begin
		set @Resultado = 0
		set @Mensaje = 'No se puede repetir Descripcion.'
	end
end	
Go
--Procedimiento para Eliminar Categoria
create proc SP_EliminarCategoria(
@IdCategoria int,
@Resultado int output,
@Mensaje varchar(500) output
)
as
begin
	set @Resultado = 1
	if not exists(
		select * from CATEGORIA c
		inner join PRODUCTO p on p.IdCategoria = c.IdCategoria
		where c.IdCategoria = @IdCategoria
	)
	begin 
		delete top(1) from CATEGORIA where IdCategoria = @IdCategoria
	end
	else
	begin
		set @Resultado = 0
		set @Mensaje = 'La categoria se encuentra relacionada a un producto.'
	end
end	

select IdCategoria,Descripcion,Estado from CATEGORIA

select * from CATEGORIA

insert into CATEGORIA(Descripcion,Estado)
values('Memorias Ram',1)

insert into CATEGORIA(Descripcion,Estado)
values('Procesadores',1)

insert into CATEGORIA(Descripcion,Estado)
values('Case',1)

insert into CATEGORIA(Descripcion,Estado)
values('Monitores',1)


/*---------- PROCEDIMIENTOS PARA PRODUCTOS */

--Procedimiento para agregar Producto
alter proc SP_RegistrarProducto(
@Codigo varchar(50),
@Nombre varchar(100),
@Descripcion varchar(100),
@IdCategoria int,
@Estado bit,
@Resultado int output,
@Mensaje varchar(500) output
)
as
begin
	set @Resultado = 0
	set @Mensaje = ''

	if not exists(select * from PRODUCTO where Codigo = @Codigo)
	begin
		insert into PRODUCTO(Codigo,Nombre,Descripcion,IdCategoria,Estado)
		values(@Codigo,@Nombre,@Descripcion,@IdCategoria,@Estado)

		set @Resultado = SCOPE_IDENTITY()
	end
	else
	set @Mensaje = 'Ya existe un producto con el mismo codigo'
end

--Procedimiento para editar Producto

create proc SP_EditarProducto(
@IdProducto int,
@Codigo varchar(50),
@Nombre varchar(100),
@Descripcion varchar(100),
@IdCategoria int,
@Estado bit,
@Resultado int output,
@Mensaje varchar(500) output
)
as
begin
	set @Resultado = 1
	if not exists(select * from PRODUCTO where Codigo = @Codigo and IdProducto != @IdProducto)
	begin 
		update PRODUCTO set
		Codigo = @Codigo,
		Nombre = @Nombre,
		Descripcion = @Descripcion,
		IdCategoria = @IdCategoria,
		Estado = @Estado
		where IdProducto = @IdProducto
	end
	else
	begin
		set @Resultado = 0
		set @Mensaje = 'Ya existe un producto con el mismo Codigo..'
	end
end	

--Procedimiento para Eliminar Producto
create proc SP_EliminarProducto(
@IdProducto int,
@Respuesta int output,
@Mensaje varchar(500) output
)
as
begin
	set @Respuesta = 0
	set @Mensaje = ''
	declare @pasoreglas bit = 1

	if exists (select * from DETALLE_COMPRA dc
	inner join PRODUCTO p on p.IdProducto = dc.IdProducto
	where p.IdProducto = @IdProducto)
	begin
		set @pasoreglas = 0
		set @Respuesta = 0
		set @Mensaje = 'No se puede eliminar porque se encuentra relacionado a un Compra..\n'
	end

	if exists (select * from DETALLE_VENTA dv
	inner join PRODUCTO p on p.IdProducto = dv.IdProducto
	where p.IdProducto = @IdProducto)
	begin
		set @pasoreglas = 0
		set @Respuesta = 0
		set @Mensaje = 'No se puede eliminar porque se encuentra relacionado a un venta..\n'
	end

	if(@pasoreglas = 1)
	begin
		delete from PRODUCTO where IdProducto = @IdProducto
		set @Respuesta = 1
	end
end	


-----------------------------------
select IdProducto,Codigo,Nombre,p.Descripcion,c.IdCategoria,
c.Descripcion[DescripcionCategoria],Stock,PrecioCompra,PrecioVenta,p.Estado 
from PRODUCTO p inner join CATEGORIA c on c.IdCategoria = p.IdCategoria

insert into PRODUCTO(Codigo,Nombre,Descripcion,IdCategoria)
values('MR001','DDR4 XPG SPECTRIX 8GB','Memoria ram ddr4 rgb 8gb 3200hmhz',1)

update PRODUCTO set Estado =1

select * from CATEGORIA
select * from PRODUCTO

select p.IdProducto,p.Codigo,p.Nombre,p.Descripcion,c.IdCategoria,c.Descripcion[DescripcionCategoria],p.Stock,p.PrecioCompra,p.PrecioVenta,p.Estado from PRODUCTO p 
inner join CATEGORIA c on c.IdCategoria = p.IdCategoria

delete PRODUCTO where IdProducto = 6

/*---------- PROCEDIMIENTOS PARA CLIENTES */

--Procedimiento para agregar Cliente
create proc Sp_RegistrarCliente(
@Documento varchar(50),
@NombreCompleto varchar(50),
@Correo varchar(50),
@Telefono varchar(50),
@Estado bit,
@Resultado int output,
@Mensaje varchar(500) output
)as
begin
	set @Resultado = 0
	declare @IDPERSONA int
	if not exists(select * from CLIENTE where Documento = @Documento)
	begin
		insert into CLIENTE(Documento,NombreCompleto,Correo,Telefono,Estado)
		values(@Documento,@NombreCompleto,@Correo,@Telefono,@Estado)

		set @Resultado = SCOPE_IDENTITY()
	end
	else
		set @Mensaje = 'El numero de documento ya esta Registrado..!'
end

Go

--Procedimiento para Modificar Cliente
alter proc Sp_ModificarCliente(
@IdCliente int,
@Documento varchar(50),
@NombreCompleto varchar(50),
@Correo varchar(50),
@Telefono varchar(50),
@Estado bit,
@Resultado int output,
@Mensaje varchar(500) output
)as
begin
	set @Resultado = 1
	declare @IDPERSONA int
	if not exists(select * from CLIENTE where Documento = @Documento and IdCliente != @IdCliente)
	begin
		update CLIENTE set 
		Documento = @Documento,
		NombreCompleto = @NombreCompleto,
		Correo = @Correo,
		Telefono = @Telefono,
		Estado = @Estado
		where IdCliente = @IdCliente

	end
	else
		set @Resultado = 0
		set @Mensaje = 'El numero de documento ya esta Registrado..!'
end
Go

--Procedimiento para Eliminar Cliente
alter proc SP_EliminarCliente(
@IdCLiente int,
@Resultado int output,
@Mensaje varchar(500) output
)
as
begin
	set @Resultado = 1
	if(@Resultado =1)
		begin 
			delete top(1) from CLIENTE where IdCliente = @IdCLiente
		end
	else
	begin
		set @Resultado = 0
		set @Mensaje = 'No se pudo eliminar el Cliente.'
	end
end


select IdCliente,Documento,NombreCompleto,Correo,Telefono,Estado from CLIENTE

select * from CLIENTE
