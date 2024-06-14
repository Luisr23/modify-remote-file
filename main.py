import paramiko
import time

# Parámetros de conexión
hostname = 'hostname'
port = 22
username = 'username'
key_path = './demo.pem'  # Cambia esto a la ruta de tu archivo .pem
local_batch_file = './batch.sh'

if __name__ == '__main__':
    # Leer el contenido del archivo batchero local
    with open(local_batch_file, 'r') as file:
        batch_content = file.read()

    # Crear el objeto SSH
    ssh = paramiko.SSHClient()

    # Aceptar claves SSH desconocidas automáticamente
    ssh.set_missing_host_key_policy(paramiko.AutoAddPolicy())

    try:
        # Cargar la clave privada
        key = paramiko.RSAKey.from_private_key_file(key_path)

        # Conectarse a la instancia EC2
        ssh.connect(hostname, port, username, pkey=key)
        print(f'Conectado a {hostname}')

        # Ejecutar el comando
        stdin, stdout, stderr = ssh.exec_command(batch_content)

        # Esperar a que el comando termine
        time.sleep(1)

        # Leer la salida del comando
        output = stdout.read().decode()
        error = stderr.read().decode()

        if output:
            print(f'Salida del comando:\n{output}')
        if error:
            print(f'Error del comando:\n{error}')

    finally:
        # Cerrar la conexión SSH
        ssh.close()
        print('Conexión cerrada')
