# Sistema de Gestión de Tareas

Este es un script en Bash que permite gestionar tareas a través de un menú interactivo en la terminal. Se requiere permisos de root para ejecutarlo.

## Características
- Agregar tareas con un estado inicial (pendiente, en proceso o finalizada).
- Eliminar tareas por ID.
- Modificar el estado de una tarea existente.
- Mostrar todas las tareas registradas en una lista formateada.

## Requisitos
- Sistema operativo basado en Linux.
- Acceso a una terminal con permisos de root.
- Intérprete de comandos Bash.

## Instalación y Ejecución
1. Clona este repositorio o descarga el script.
2. Otorga permisos de ejecución al script:
   ```bash
   chmod +x gestion_tareas.sh
   ```
3. Ejecuta el script como root:
   ```bash
   sudo ./gestion_tareas.sh
   ```

## Uso
Al ejecutar el script, se mostrará un menú con las siguientes opciones:
1. **Agregar tarea**: Permite registrar una nueva tarea con un estado inicial.
2. **Eliminar tarea**: Elimina una tarea a partir de su ID.
3. **Modificar estado de tarea**: Permite cambiar el estado de una tarea existente.
4. **Mostrar todas las tareas**: Lista todas las tareas registradas con su estado actual.
5. **Salir**: Finaliza la ejecución del script.

## Estructura de Datos
Las tareas se almacenan en un archivo ubicado en `/var/lib/todolist/todolist.tlf` con el siguiente formato:
```
ID:Tarea:Estado
```
Ejemplo:
```
1:Comprar leche:pendiente
2:Revisar correos:en proceso
3:Enviar reporte:finalizada
```

## Notas
- Si el archivo de tareas no existe, el script lo creará automáticamente.
- Se requiere ejecutar el script con permisos de superusuario.
- Para modificar el estado de una tarea, se debe proporcionar su ID.

## Licencia
Este proyecto se distribuye bajo la licencia MIT. Puedes modificarlo y distribuirlo libremente.

