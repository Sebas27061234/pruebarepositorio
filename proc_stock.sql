create proc spstock_articulos
as
SELECT dbo.articulo.codigo, dbo.articulo.nombre, 
dbo.categoria.nombre AS Categoria, 
sum(dbo.detalle_ingreso.cantidad) as Cantidad_Ingreso, 
(dbo.articulo.stock) as Cantidad_Stock,
(sum(dbo.detalle_ingreso.cantidad)-dbo.articulo.stock) as Cantidad_Venta
FROM dbo.articulo INNER JOIN dbo.categoria 
ON dbo.articulo.idcategoria = dbo.categoria.idcategoria 
INNER JOIN dbo.detalle_ingreso 
ON dbo.articulo.idarticulo = dbo.detalle_ingreso.idarticulo 
INNER JOIN dbo.ingreso 
ON dbo.detalle_ingreso.idingreso = dbo.ingreso.idingreso
INNER JOIN dbo.detalle_venta 
ON dbo.detalle_venta.idarticulo = dbo.articulo.idarticulo
where ingreso.estado <>'ANULADO'
group by dbo.articulo.codigo, dbo.articulo.nombre, 
dbo.categoria.nombre,dbo.articulo.stock
go


