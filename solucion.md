# Respuestas

## Video
[Version corta (9min)](https://youtu.be/jYaUjsFQ3qs)

[Version completa (14min)](https://youtu.be/3dAK1I88KJQ)


## Respuesta de la **Actividad 1.1**

Crear un volumen para garantizar la persistencia de los datos de la base de datos.
```bash
docker volume create boston-data
```

## Respuesta de la **Actividad 1.2**

Importar variables de entorno de archivo `.env` utilizando.
Opciones de docker run:
- `-e` para definir variables de entorno
- `-d` para correr el contenedor en segundo plano
- `--rm` para eliminar el contenedor al detenerlo
- `--name` para asignar un nombre al contenedor
- `-v` para montar un volumen de datos
- `-p` para mapear puertos
- `postgres:latest` imagen de postgres

```bash
export $(grep -v '^#' .env | xargs)
docker run -e POSTGRES_USER=$DB_USER -e POSTGRES_PASSWORD=$DB_PASSWORD -e POSTGRES_DB=$DB_NAME -d --rm --name boston-db -v boston-data:/var/lib/postgresql/data -p 5432:5432 postgres:latest
```

## Respuesta de la **Actividad 1.3**

Opciones de docker exec:
- `--env-file` para importar variables de entorno de un archivo
- `-i` habilitar estandard input
- `boston-db` nombre del contenedor
- `psql` shell de postgres
- `-U` usuario de DB
- `-d` nombre de DB

```bash
docker exec --env-file .env -i boston-db psql -U $DB_USER -d $DB_NAME < db.sql
```

## Respuesta de la **Actividad 3.1**

```Dockerfile
# Imagen base
FROM python:3.9-slim

# Directorio de trabajo
WORKDIR /app

# Exponer puerto de la aplicacion
EXPOSE 8080

# Copiar los archivos necesarios
COPY requirements.txt requirements.txt
COPY app.py app.py
COPY .env .env

# Instalar dependencias de python
RUN pip install -r requirements.txt

# Ejecutar la aplicacion
CMD ["python", "app.py"]
```


## Respuesta de la **Actividad 3.2**

Opciones de docker build:
- `-t` para asignar un tag a la imagen

```bash
docker build -t app:v1.0 .
```


## Respuesta de la **Actividad 3.3**

Opciones de docker run:
- `-e` para definir variables de entorno
- `-d` para correr el contenedor en segundo plano
- `--rm` para eliminar el contenedor al detenerlo
- `--name` para asignar un nombre al contenedor
- `-p` para mapear puertos
- `app:v1.0` imagen de la aplicacion

```bash
docker run -e DB_HOST=$(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' boston-db) -d --rm --name boston-app -p 8080:8080 app:v1.0
```

## Respuesta de la **Actividad 4.1**

```bash
# Login en Docker Hub
docker login
# Asignar un tag a la imagen
docker tag app:v1.0 tux550/app:v1.0
# Subir la imagen a Docker Hub
docker push tux550/app:v1.0
```


## Respuesta de la **Actividad 5.1**


```yml
version: '3.7'

services:
  # Servicio de la base de datos
  db:
    image: postgres:latest
    container_name: boston-db
    # Configuracion de la base de datos
    environment:
      - POSTGRES_USER=postgres
      - POSTGRES_PASSWORD=postgres
      - POSTGRES_DB=BOSTON
    volumes:
      # Volumen de datos para persistencia de la base de datos
      - boston-data:/var/lib/postgresql/data
      # Scripts de inicializacion
      - ./db.sql:/docker-entrypoint-initdb.d/db.sql
      - ./init.sh:/docker-entrypoint-initdb.d/init.sh
    ports:
      - "5432:5432"
  app:
    # Imagen previamente subida a Docker Hub
    image: tux550/app:v1.0
    container_name: boston-app
    ports:
      - "8080:8080"
    # Dependencia del servicio de la base de datos. Espera a que el servicio de la base de datos este disponible
    depends_on:
      - db
    # Asignar la direccion IP del contenedor de la base de datos a la variable de entorno DB_HOST
    environment:
      - DB_HOST=db

volumes:
  # Volume para persistencia de la base de datos
  boston-data:
```

## Respuesta de la **Actividad 5.2**
Opcciones de docker-compose:
- `up` para levantar los servicios
- `-d` para correr los contenedores en segundo plano
```bash
docker-compose up -d
```

Para detener los servicios y eliminar los volumenes
```bash
# Auxiliar para eliminar volumenes
docker-compose down --volumes
```