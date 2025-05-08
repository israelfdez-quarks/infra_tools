# Conjunto de scripts para facilitar la gestión de la infraestructura

## Gestión de secretos

- Cree una carpeta `app_secrets` en la raíz del proyecto
Esta carpeta deberá contener un archivo de texto nombrado usando el nombre del vault que se quiere modificar. 
Dentro de ese archivo deberá poner un mapa de bash con la key siendo el nombre del secreto y el value el valor. 

- Puede comenzar usando el script: 

```bash
./list_vault.sh <nombre_vault>
```

Donde: `nombre_vault` debe ser exactamente el nombre del vault. 

Esto creará un archivo con las especificaciones antes mencionadas y todos los secretos y sus valores, listos para modificar. 

**Sugerencia** 
Siempre comience listando, modifique o agregue los secretos que quiere actualizar o crear y elimine el resto, 
de esta manera no se tarda tanto y no genera versiones de los secretos que en realidad no se quieren modificar

- Ejecute el script siguiente para aplicar los secretos: 

```bash
./create_secrets.sh <nombre_vault>
```

Donde: `nombre_vault` es el nombre del vault y del archivo que contiene los secretos en la carpeta `app_secrets`

**Advertencia**
La carpeta `app_secrets` está excluída por el .gitignore, bajo ninguna circunstancia haga commit de secretos a git. 