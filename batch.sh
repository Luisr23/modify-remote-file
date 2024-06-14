#!/bin/bash

# Ruta del archivo remoto a modificar
rutaArchivo="./remoteFile.txt"

# Verificar si el archivo existe
if [ ! -f "$rutaArchivo" ]; then
    echo "El archivo no existe en la ruta especificada."
    exit 1
fi

# Leer el contenido del archivo en un array
mapfile -t contenido < "$rutaArchivo"

# Definir la línea a buscar y modificar
linea="database_1"

# Inicializar el índice de la línea
indiceLinea=-1

# Buscar la línea en el contenido del archivo
for i in "${!contenido[@]}"; do
    if [[ "${contenido[$i]}" =~ $linea ]]; then
        indiceLinea=$i
        break
    fi
done

# Verificar si se encontró la línea
if [ $indiceLinea -eq -1 ]; then
    echo "No se encontró la línea que contiene '$linea'."
    exit 1
fi

# Comentar y descomentar líneas contiguas
if [[ "${contenido[$indiceLinea]}" =~ ^# ]]; then
    # Descomentar la primera línea
    contenido[$indiceLinea]="${contenido[$indiceLinea]#"# "}"
    # Comentar la segunda línea
    contenido[$((indiceLinea + 1))]="# ${contenido[$((indiceLinea + 1))]}"
    echo "Se descomento la línea ${contenido[$indiceLinea]} y se comento la línea ${contenido[$((indiceLinea + 1))]}"
else
    # Descomentar la segunda línea
    contenido[$((indiceLinea + 1))]="${contenido[$((indiceLinea + 1))]#"# "}"
    # Comentar la primera línea
    contenido[$indiceLinea]="# ${contenido[$indiceLinea]}"
    echo "Se descomento la línea ${contenido[$((indiceLinea + 1))]} y se comento la línea ${contenido[$indiceLinea]}"
fi

# Guardar los cambios en el archivo
printf "%s\n" "${contenido[@]}" > "$rutaArchivo"

# Reiniciar el sistema
sudo shutdown -r now
