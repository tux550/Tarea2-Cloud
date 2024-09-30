# Respuestas

## Respuesta de la **Actividad 1.1**

```bash
docker volume create boston-data
```

## Respuesta de la **Actividad 1.2**

```bash
export $(grep -v '^#' .env | xargs)
docker run -e POSTGRES_USER=$DB_USER -e POSTGRES_PASSWORD=$DB_PASSWORD -e POSTGRES_DB=$DB_NAME -d --rm --name boston-db -v boston-data:/var/lib/postgresql/data -p 5432:5432 postgres:latest
```

## Respuesta de la **Actividad 1.3**

```bash
docker exec --env-file .env -i boston-db psql -U $DB_USER -d $DB_NAME < db.sql
```

## Respuesta de la **Actividad 3.1**

```Dockerfile
# Implementar el Dockerfile
FROM python:3.9-slim

# Asignar directio de trabajo app
WORKDIR /app

# Puerto de aplciaion
EXPOSE 8080

# Copiar los archivos necesarios
COPY requirements.txt requirements.txt
COPY app.py app.py
COPY .env .env

# Instalar las dependencias
RUN pip install -r requirements.txt

# Ejecutar la aplicacion
CMD ["python", "app.py"]
```


## Respuesta de la **Actividad 3.2**

```bash
docker build -t app:v1.0 .
```


## Respuesta de la **Actividad 3.3**

```bash
# Comando incompleto
docker run -e DB_HOST=$(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' boston-db) -d --rm --name boston-app -p 8080:8080 app:v1.0
```

## Respuesta de la **Actividad 4.1**

```yml

```

## Respuesta de la **Actividad 5.1**

```bash

```

## Respuesta de la **Actividad 5.2**

```bash

```