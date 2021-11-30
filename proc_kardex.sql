create proc spkardex_valorizado
as
SELECT dbo.ingreso.fecha,dbo.articulo.codigo, dbo.articulo.nombre, dbo.categoria.nombre as Categoria,
       dbo.detalle_ingreso.precio_compra, dbo.detalle_ingreso.cantidad,
	   (dbo.detalle_ingreso.precio_compra*dbo.detalle_ingreso.cantidad) as Ingreso_Valorizado, dbo.articulo.stock, 
       (dbo.articulo.stock*dbo.detalle_ingreso.precio_compra) as Stock_Valorizado,
	   (dbo.detalle_ingreso.cantidad-dbo.articulo.stock) as Total_Venta,
	   dbo.detalle_venta.precio_venta,((dbo.detalle_ingreso.cantidad-dbo.articulo.stock)*dbo.detalle_venta.precio_venta) as Venta_Valorizada
FROM   dbo.articulo INNER JOIN dbo.categoria ON 
       dbo.articulo.idcategoria = dbo.categoria.idcategoria INNER JOIN
       dbo.detalle_ingreso ON dbo.articulo.idarticulo = dbo.detalle_ingreso.idarticulo 
	   INNER JOIN dbo.detalle_venta ON dbo.articulo.idarticulo = dbo.detalle_venta.idarticulo 
	   INNER JOIN dbo.ingreso ON dbo.detalle_ingreso.idingreso = dbo.ingreso.idingreso 
	   INNER JOIN dbo.venta ON dbo.detalle_venta.idventa = dbo.venta.idventa
where ingreso.estado <> 'ANULADO'
group by dbo.articulo.codigo, dbo.articulo.nombre, dbo.categoria.nombre, 
		 dbo.detalle_ingreso.precio_compra, 
		 dbo.detalle_venta.precio_venta, dbo.detalle_ingreso.cantidad,
		 dbo.articulo.stock, dbo.ingreso.fecha,dbo.articulo.idarticulo
order by dbo.articulo.idarticulo asc


