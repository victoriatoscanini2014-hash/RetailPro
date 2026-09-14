-- =========================================================
-- M4 - CONSULTAS DE NEGOCIO
-- Base de datos: Ventas_Tech_DB
-- Motor: SQL Server
-- Tabla utilizada: ventas
-- =========================================================


-- =========================================================
-- CONSULTA 1 - RESUMEN EJECUTIVO MENSUAL
-- =========================================================

SELECT
   EXTRACT(MONTH FROM fecha_venta) AS mes,
    SUM(cantidad * precio_unitario) AS total_facturado,
    COUNT(*) AS cantidad_pedidos,
    AVG(cantidad * precio_unitario) AS ticket_promedio
FROM ventas
GROUP BY MONTH(fecha_venta)
ORDER BY mes;


-- =========================================================
-- CONSULTA 2 - RANKING DE PRODUCTOS
-- =========================================================

SELECT TOP 5
    id_producto,
    SUM(cantidad) AS unidades_vendidas,
    SUM(cantidad * precio_unitario) AS total_generado
FROM ventas
GROUP BY id_producto
ORDER BY total_generado DESC;


-- =========================================================
-- CONSULTA 3 - CLIENTES RECURRENTES
-- =========================================================

SELECT
    id_cliente,
    COUNT(*) AS cantidad_pedidos,
    SUM(cantidad * precio_unitario) AS total_gastado
FROM ventas
GROUP BY id_cliente
HAVING COUNT(*) > 1
ORDER BY cantidad_pedidos DESC;


-- =========================================================
-- CONSULTA 4 - MESES POR ENCIMA / POR DEBAJO DEL PROMEDIO
-- =========================================================

WITH resumen_mensual AS (
    SELECT
        MONTH(fecha_venta) AS mes,
        SUM(cantidad * precio_unitario) AS total_facturado
    FROM ventas
    GROUP BY MONTH(fecha_venta)
)
SELECT
    mes,
    total_facturado,
    CASE
        WHEN total_facturado > AVG(total_facturado) OVER ()
            THEN 'Por encima'
        ELSE 'Por debajo'
    END AS comparacion_promedio
FROM resumen_mensual
ORDER BY mes;


-- =========================================================
-- HALLAZGOS
-- Completar después de revisar los resultados.
-- =========================================================

-- 1. El producto 1 fue el de mayor facturación, con $3600.
-- 2. El mes 3 superó el promedio mensual de facturación.
-- 3. El cliente 1 realizó 2 pedidos y generó un gasto total de $2640.
