# Laboratorio de SQL

__Para restaurar una base de datos en *SQL Server Managenent Studio (SSMS)* a partir de un bachup:__

- Se selcciona la opción de Restaurar base de datos en el explorador.

    ```Explorador de objetos de SSMS
    Object Explorer > Databases (Click derecho) > Restore Database...
    ```

- Una vez en el menú de restauración se añade el backup con la base de datos que se quiere restaurar.

    ```Ventana restaurar base de datos de SSMS
    Restore Database > Device: > ... (Select backup devices) > Add
    Backup File location > Buscar y seleccionar el archivo .bak > OK > OK > OK > Aceptar
    ```

- Ahora ya se tendrá restaurada la base de datos y aparecerá en *Object Explorer > Databases* . En caso de que aún no aparezca, refrescar el explorador con el símbolo de flecha en bucle o con *Databases (Click derecho) > Refresh* .

- __Para usar la base de datos restaurada:__ seleccionarla por su nombre en el desplegable de justo arriba del Object Explorer o al hacer una Query, mediante el comando USE y luego hacer la consulta.

    ```New Query de SSMS
    USE <Nombre de la Base de Datos que se quiera utilizar>;

    SELECT ...
    (Resto de la consulta);
    ```
