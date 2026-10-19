-- =====================================================================
-- Pre-entrega M4: Extrayendo métricas clave con SQL
-- Base de datos: Ventas_Tech_DB (SQL Server)
-- Tabla utilizada: ventas
-- Bruno Angel TOmas Zabala
-- =====================================================================

USE Ventas_Tech_DB;
GO

-- ---------------------------------------------------------------------
-- Consulta 1 — Resumen ejecutivo mensual
-- Total facturado, cantidad de pedidos y ticket promedio por mes
-- ---------------------------------------------------------------------
SELECT
    MONTH(fecha_venta)                  AS mes,
    SUM(cantidad * precio_unitario)     AS total_facturado,
    COUNT(*)                            AS cantidad_pedidos,
    AVG(cantidad * precio_unitario)     AS ticket_promedio
FROM ventas
GROUP BY MONTH(fecha_venta)
ORDER BY mes;
GO

-- ---------------------------------------------------------------------
-- Consulta 2 — Ranking de productos
-- Top 5 de id_producto por total facturado
-- ---------------------------------------------------------------------
SELECT TOP 5
    id_producto,
    SUM(cantidad)                       AS unidades_vendidas,
    SUM(cantidad * precio_unitario)     AS total_facturado
FROM ventas
GROUP BY id_producto
ORDER BY total_facturado DESC;
GO

-- ---------------------------------------------------------------------
-- Consulta 3 — Clientes recurrentes
-- Clientes con más de un pedido, con cantidad de pedidos y total gastado
-- ---------------------------------------------------------------------
SELECT
    id_cliente,
    COUNT(*)                            AS cantidad_pedidos,
    SUM(cantidad * precio_unitario)     AS total_gastado
FROM ventas
GROUP BY id_cliente
HAVING COUNT(*) > 1
ORDER BY total_gastado DESC;
GO

-- ---------------------------------------------------------------------
-- Consulta 4 — Meses por encima / por debajo del promedio mensual
-- Se calcula primero el total por mes y luego se compara contra el
-- promedio de esos totales mensuales.
-- ---------------------------------------------------------------------
WITH facturacion_mensual AS (
    SELECT
        MONTH(fecha_venta)              AS mes,
        SUM(cantidad * precio_unitario) AS total_facturado
    FROM ventas
    GROUP BY MONTH(fecha_venta)
)
SELECT
    mes,
    total_facturado,
    CASE
        WHEN total_facturado > (SELECT AVG(total_facturado) FROM facturacion_mensual) THEN 'Por encima'
        WHEN total_facturado < (SELECT AVG(total_facturado) FROM facturacion_mensual) THEN 'Por debajo'
        ELSE 'En el promedio'
    END                                 AS comparacion_con_promedio
FROM facturacion_mensual
ORDER BY mes;
GO

-- =====================================================================
-- HALLAZGOS
-- =====================================================================
-- 1) El producto 1 concentra el 55,9% de la facturación (3.600 de un
--    total de 6.444) con solo 3 unidades vendidas: es el que más
--    pesa en el negocio por su alto precio unitario (1.200).
-- 2) El producto 2 es el más vendido en unidades (13), pero apenas
--    aporta 364 en facturación (5,6% del total): mucho volumen, poco
--    ingreso, por su precio unitario bajo (28).
-- 3) Los 5 clientes compraron más de una vez (todos son recurrentes),
--    pero los clientes 1 y 5 explican el 73,6% de lo facturado
--    (4.740 de 6.444), por lo que la facturación depende bastante de
--    esos dos clientes.
-- =====================================================================
