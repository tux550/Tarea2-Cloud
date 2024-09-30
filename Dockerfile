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