#!/bin/bash
yum update -y
sudo yum install -y docker

# Iniciar el servicio de Docker
sudo service docker start

# Instalar el agente Datadog (EU)
DD_API_KEY="${datadog_api_key}" DD_SITE="${datadog_site}" bash -c "$(curl -L https://s3.amazonaws.com/dd-agent/scripts/install_script.sh)"

# Habilitar integración con Docker
sudo tee /etc/datadog-agent/conf.d/docker.d/conf.yaml >/dev/null <<'EOF'
init_config:

instances:
  - url: "unix://var/run/docker.sock"
    new_tag_names: true
    collect_container_size: true
    collect_container_count: true
    collect_volume_count: true
    collect_images_stats: true
    collect_image_size: true
    collect_disk_stats: true
EOF

# Reiniciar el agente
sudo systemctl restart datadog-agent

# Descargar y descomprimir el archivo backend.zip desde S3
aws s3 cp s3://ai4devs-project-code-bucket/backend.zip /home/ec2-user/backend.zip
unzip /home/ec2-user/backend.zip -d /home/ec2-user/

# Construir la imagen Docker para el backend
cd /home/ec2-user/backend
sudo docker build -t lti-backend .

# Ejecutar el contenedor Docker
sudo docker run -d -p 8080:8080 lti-backend

# Timestamp to force update
echo "Timestamp: ${timestamp}"
