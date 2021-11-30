create proc spreporte_ingreso
@idingreso int
as 
SELECT i.idingreso, (t.apellidos+ ' ' +t.nombre) as Trabajador, (p.razon_social) as Proveedor, 
p.sector_comercial, p.num_documento, i.fecha, i.tipo_comprobante, 
i.serie, i.correlativo, i.igv, a.codigo, a.nombre AS Articulo, c.nombre AS Categoria, di.stock_inicial, di.precio_compra,
(((di.precio_venta-di.precio_compra)/di.precio_venta)*100) as Utilidad_Porcentaje, 
di.precio_venta, (di.precio_compra*di.stock_inicial) as Total_Invertido
FROM articulo a INNER JOIN categoria c 
ON a.idcategoria = c.idcategoria 
INNER JOIN detalle_ingreso di 
ON a.idarticulo = di.idarticulo 
INNER JOIN ingreso i 
ON di.idingreso = i.idingreso 
INNER JOIN proveedor p 
ON i.idproveedor = p.idproveedor 
INNER JOIN trabajador t 
ON i.idtrabajador = t.idtrabajador
where i.idingreso = @idingreso
go