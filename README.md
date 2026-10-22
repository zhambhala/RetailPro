RetailPro – Proyecto de Análisis de Datos

Proyecto integrador de la cursada de Analista de Datos (Coderhouse). Trabaja sobre la base Ventas_Tech_DB (TechStore) en SQL Server y reúne las consultas analíticas de los módulos 4 y 5 y el modelo en Power BI de los módulos 6 a 8.

Objetivo

Responder preguntas comerciales (facturación mensual, ranking de productos, clientes recurrentes, clientes y productos sin ventas) con cifras que se puedan rastrear hasta la tabla de origen.

Herramientas
SQL Server y SSMS: base de datos y consultas.
Power BI Desktop: Power Query (ETL), modelo en estrella y medidas DAX.
GitHub: versionado y documentación.
Contenido
Pre-entrega 4: métricas con GROUP BY, HAVING y CTE (resumen mensual, ranking de productos, clientes recurrentes, meses sobre/bajo el promedio).
Pre-entrega 5: consultas con JOINs (vista base con INNER JOIN, clientes y productos sin ventas con LEFT JOIN, consolidado con UNION ALL).
Cómo ejecutar los scripts SQL
Abrir SSMS y conectarse a la instancia local.
Crear la base con el script del Módulo 3 (Ventas_Tech_DB).
Ejecutar el script de la Pre-entrega 4 (usa USE Ventas_Tech_DB;).
Ejecutar el script de la Pre-entrega 5. Al inicio inserta un cliente y un producto de ejemplo sin ventas (para que los LEFT JOIN tengan algo que mostrar); usa IF NOT EXISTS, por lo que se puede correr más de una vez sin errores de clave duplicada y no afecta los totales de ventas.
Autor

Bruno Angel Tomas Zabala
