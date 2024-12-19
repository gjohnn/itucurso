#!/bin/bash

# 1. Función que detecta si el grupo "paleontologo" existe
function check_group {
    if getent group paleontologo > /dev/null; then
        echo "Entonces, ¿quién tiene hambre?"
        exit 0
    else
        sudo groupadd paleontologo  # Lo crea si no existe
        echo "No reparamos en gastos"
    fi
}

# 2. Ejecutar la función para comprobar el grupo
check_group

# Crear el grupo "professor" si no existe
sudo groupadd professor

# 3. Crear los usuarios con sus características
sudo useradd -m -d /home/grant -s /bin/bash -g paleontologo alan
sudo useradd -m -d /home/sattler -s /bin/bash -g paleontologo ellie
sudo useradd -m -d /home/malcolm -s /bin/bash -g professor ian

# 4. Crear las carpetas con los permisos solicitados
sudo mkdir -p apellido/doctores
sudo mkdir -p apellido/matematica

# Asignar permisos de directorios drwxrwx---
sudo chmod 770 apellido/doctores
sudo chmod 770 apellido/matematica

# 5. Configurar los permisos tradicionales para los usuarios
# Alan y Ellie deben tener acceso a /apellido/doctores
# Ian debe tener acceso a /apellido/matematica, pero no a /apellido/doctores
# Alan y Ellie no deben acceder a /apellido/matematica

# Dar permisos de lectura, escritura y ejecución a alan y ellie en doctores
sudo chown alan:paleontologo apellido/doctores
sudo chown ellie:paleontologo apellido/doctores

# Dar permisos de lectura, escritura y ejecución a ian en matematica
sudo chown ian:professor apellido/matematica

# Restringir el acceso a los otros usuarios
sudo chmod 770 apellido/doctores
sudo chmod 770 apellido/matematica

# 6. Cambiar el nombre de la carpeta "apellido" por tu apellido (Reemplaza "apellido" con tu apellido)
sudo mv apellido $(whoami)

# 7. Actualizar la lista de repositorios
sudo apt update -y

# 8. Crear el archivo /home/alumno/info.txt y escribir la información solicitada
# Crear el directorio /home/alumno si no existe
sudo mkdir -p /home/alumno

echo "Versiones disponibles para instalar vim-tutor:" | sudo tee /home/alumno/info.txt
sudo apt-cache show vim-tutor | grep 'Version' | sudo tee -a /home/alumno/info.txt

echo "Nombre de la máquina:" | sudo tee -a /home/alumno/info.txt
sudo hostname | sudo tee -a /home/alumno/info.txt

echo "Lista de archivos montados:" | sudo tee -a /home/alumno/info.txt
sudo df -h | sudo tee -a /home/alumno/info.txt

echo "Usuarios creados:" | sudo tee -a /home/alumno/info.txt
sudo cat /etc/passwd | grep -E 'alan|ellie|ian' | sudo tee -a /home/alumno/info.txt
