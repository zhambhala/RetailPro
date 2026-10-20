-- Motor: SQL Server (SSMS)
-- ══════════════════════════════════════════
-- TechStore — Pre-entrega Módulo 5: Consultas con JOINs
-- Base: Ventas_Tech_DB (esquema del Módulo 3)
-- Autor: Bruno Angel Tomas Zabala
-- Fecha: 20/10/2026
-- ══════════════════════════════════════════

USE Ventas_Tech_DB;
GO

-- ── PREPARACIÓN: datos de ejemplo para las consultas 2 y 3 ──
-- Con los datos originales todos los clientes compraron y todos los productos se vendieron,
-- por lo que los LEFT JOIN no tendrían nada para mostrar. Agrego un cliente registrado
-- sin compras y un producto de catálogo sin movimiento. No afectan los totales de ventas.
-- Los IF NOT EXISTS permiten correr el script más de una vez sin errores de clave duplicada.

IF NOT EXISTS (SELECT 1 FROM clientes WHERE id_cliente = 6)
    INSERT INTO clientes (id_cliente, nombre, email, ciudad, fecha_registro)
    VALUES (6, 'Diego Fernández', 'diego@mail.com', 'La Plata', '2024-03-20');

IF NOT EXISTS (SELECT 1 FROM productos WHERE id_producto = 7)
    INSERT INTO productos (id_producto, nombre_producto, id_categoria, precio, stock, activo)
    VALUES (7, 'Webcam Full HD', 2, 65.00, 25, 1);
GO

-- ── CONSULTA 1: Vista base del proyecto (INNER JOIN) ──
-- Propósito: una fila por venta con cliente, ciudad, producto y categoría ya resueltos.
-- Es la fuente de datos principal para Power BI (ciudad y categoría sirven para agrupar y filtrar).
SELECT
    v.fecha_venta,
    c.id_cliente,
    c.nombre                  AS cliente,
    c.ciudad,
    p.nombre_producto         AS producto,
    cat.nombre_categoria      AS categoria,
    v.cantidad,
    v.precio_unitario,
    v.cantidad * v.precio_unitario AS total_venta
FROM ventas v
INNER JOIN clientes   c   ON v.id_cliente   = c.id_cliente
INNER JOIN productos  p   ON v.id_producto  = p.id_producto
INNER JOIN categorias cat ON p.id_categoria = cat.id_categoria
ORDER BY v.fecha_venta, v.id_venta;
-- Hallazgo: devuelve las 10 ventas, ninguna se perdió en el cruce.
-- $4.950 de los $6.444 facturados (cerca del 77%), sobre todo por las laptops y los monitores.
GO

-- ── CONSULTA 2: Clientes sin ventas (LEFT JOIN) ──
-- Propósito: detectar clientes registrados que nunca compraron, para que CRM los contacte.
SELECT
    c.nombre,
    c.email,
    c.fecha_registro
FROM clientes c
LEFT JOIN ventas v ON c.id_cliente = v.id_cliente
WHERE v.id_venta IS NULL;
-- Hallazgo: 1 de los 6 clientes registrados nunca compró (Diego Fernández.
--  El CRM puede contactarlo con una propuesta de primera compra antes de que se enfríe el registro.
GO

-- ── CONSULTA 3: Productos sin ventas (LEFT JOIN) ──
-- Propósito: identificar artículos del catálogo sin movimiento, para que el área de producto los revise.
SELECT
    p.nombre_producto,
    cat.nombre_categoria AS categoria,
    p.precio
FROM productos p
INNER JOIN categorias cat ON p.id_categoria = cat.id_categoria
LEFT JOIN ventas v ON p.id_producto = v.id_producto
WHERE v.id_venta IS NULL;
-- Hallazgo: 1 de los 7 productos no tiene ninguna venta (Webcam Full HD, Accesorios, $65) y
-- mantiene 25 unidades en stock. Se debería revisar si es un tema de precio o de visibilidad.
GO

-- ── CONSULTA 4: Consolidado por canal (UNION ALL) ──
-- Propósito: comparar el total vendido en dos períodos del mes. La tabla ventas no tiene un
-- campo de canal u origen, así que la columna "canal" se crea con un valor fijo en cada SELECT.
SELECT
    canal,
    SUM(total) AS total_canal
FROM (
    SELECT fecha_venta, cantidad * precio_unitario AS total, 'Periodo 1 (05-10/03)' AS canal
    FROM ventas
    WHERE fecha_venta >= '2024-03-05' AND fecha_venta < '2024-03-11'
    UNION ALL
    SELECT fecha_venta, cantidad * precio_unitario AS total, 'Periodo 2 (11-15/03)' AS canal
    FROM ventas
    WHERE fecha_venta >= '2024-03-11' AND fecha_venta <= '2024-03-15'
) AS consolidado
GROUP BY canal
ORDER BY canal;
-- Hallazgo: el primer período vendió $3.620 y el segundo $2.824, con 5 ventas cada uno.
-- La diferencia viene de la venta de 2 laptops del 05/03 ($2.400), que pesa más que cualquier venta del segundo período.
GO
