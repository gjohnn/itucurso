#!/bin/bash

# 1. Función que detecta si el grupo "paleontologo" existe
function check_group {
    if getent group paleontologo > /dev/null; then
        echo "Entonces, ¿quién tiene hambre?"
        exit 0
    else
        groupadd paleontologo  # Lo crea si no existe
        echo "No reparamos en gastos"
    fi
}

# 2. Ejecutar la función para comprobar el grupo
check_group

# 3. Crear los usuarios con sus características
useradd -m -d /home/grant -s /bin/bash -g paleontologo alan
useradd -m -d /home/sattler -s /bin/bash -g paleontologo ellie
useradd -m -d /home/malcolm -s /bin/bash -g professor ian

# 4. Crear las carpetas con los permisos solicitados
mkdir -p apellido/doctores
mkdir -p apellido/matematica

# Asignar permisos de directorios drwxrwx---
chmod 770 apellido/doctores
chmod 770 apellido/matematica

# 5. Configurar los permisos tradicionales para los usuarios
# Alan y Ellie deben tener acceso a /apellido/doctores
# Ian debe tener acceso a /apellido/matematica, pero no a /apellido/doctores
# Alan y Ellie no deben acceder a /apellido/matematica

# Dar permisos de lectura, escritura y ejecución a alan y ellie en doctores
chown alan:paleontologo apellido/doctores
chown ellie:paleontologo apellido/doctores

# Dar permisos de lectura, escritura y ejecución a ian en matematica
chown ian:professor apellido/matematica

# Restringir el acceso a los otros usuarios
chmod 770 apellido/doctores
chmod 770 apellido/matematica

# 6. Cambiar el nombre de la carpeta "apellido" por tu apellido (Reemplaza "apellido" con tu apellido)
mv apellido $(whoami)

# 7. Actualizar la lista de repositorios
sudo apt update -y

# 8. Crear el archivo /home/alumno/info.txt y escribir la información solicitada
# - Versiones disponibles para vim-tutor
# - Nombre de la máquina
# - Archivos montados
# - Usuarios creados

echo "Versiones disponibles para instalar vim-tutor:" > /home/alumno/info.txt
apt-cache show vim-tutor | grep 'Version' >> /home/alumno/info.txt

echo "Nombre de la máquina:" >> /home/alumno/info.txt
hostname >> /home/alumno/info.txt

echo "Lista de archivos montados:" >> /home/alumno/info.txt
df -h >> /home/alumno/info.txt

echo "Usuarios creados:" >> /home/alumno/info.txt
cat /etc/passwd | grep -E 'alan|ellie|ian' >> /home/alumno/info.txt
