# Prompts para Integración Datadog-AWS con Terraform

## Prompt 1: Configuración del Proveedor Datadog

**Prompt utilizado:**
```
Necesito configurar el proveedor de Datadog en Terraform para integrar AWS con Datadog. 
Debo incluir las variables de API key y App key de Datadog, y configurar el sitio correcto.
El proveedor debe ser compatible con la versión más reciente de Terraform y usar el endpoint EU.
```

**Código generado:**
```hcl
provider "datadog" {
  api_key = var.datadog_api_key
  app_key = var.datadog_app_key
  api_url = "https://api.datadoghq.eu"
}
```

## Prompt 2: Variables de Configuración

**Prompt utilizado:**
```
Definir todas las variables necesarias para la integración Datadog-AWS:
- API key y App key de Datadog (sensibles)
- Site de Datadog (configurable para EU)
- Asegurar que las variables se pasen correctamente a los scripts
```

**Código generado:**
```hcl
variable "datadog_api_key" {
  description = "Datadog API Key"
  type        = string
  sensitive   = true
}

variable "datadog_app_key" {
  description = "Datadog Application Key"
  type        = string
  sensitive   = true
}

variable "datadog_site" {
  description = "Datadog site (e.g., datadoghq.com, datadoghq.eu)"
  type        = string
  default     = "datadoghq.eu"
}
```

## Prompt 3: Integración AWS-Datadog

**Prompt utilizado:**
```
Necesito crear una integración completa entre AWS y Datadog usando Terraform. 
Esto incluye:
1. Un rol IAM para Datadog con permisos para acceder a métricas de AWS
2. La configuración de la integración en Datadog
3. Políticas IAM que permitan a Datadog recopilar métricas de EC2, RDS, S3, Lambda, etc.
4. Configuración de external_id para seguridad
```

**Código generado:**
- Rol IAM con assume_role_policy para Datadog
- Política IAM con permisos completos para métricas AWS
- Recurso datadog_integration_aws

## Prompt 4: Dashboard de Monitoreo

**Prompt utilizado:**
```
Crear un dashboard en Datadog que muestre métricas clave de AWS:
- CPU utilization de instancias EC2
- Memory utilization
- Network traffic
- Disk usage
- Alertas para umbrales altos
El dashboard debe ser responsive y mostrar datos en tiempo real.
```

**Código generado:**
- Dashboard con widgets para métricas EC2
- Monitores para alertas de CPU y memoria
- Configuración de thresholds y escalación

## Prompt 5: Instalación del Agente Datadog

**Prompt utilizado:**
```
Modificar los scripts de user_data de EC2 para instalar el agente Datadog en las instancias.
El agente debe:
1. Instalarse automáticamente al arrancar la instancia
2. Configurarse para recopilar métricas de Docker
3. Usar las credenciales de Datadog proporcionadas
4. Reiniciarse después de la configuración
5. Usar el sitio EU de Datadog
```

**Código generado:**
- Scripts de instalación del agente Datadog
- Configuración de Docker monitoring
- Variables de entorno para API key

## Prompt 6: Configuración de Seguridad

**Prompt utilizado:**
```
Configurar la seguridad para proteger las credenciales de Datadog:
1. Añadir archivos sensibles al .gitignore
2. Marcar variables como sensibles en Terraform
3. Usar external_id para la integración AWS-Datadog
```

**Código generado:**
- Líneas en .gitignore para archivos terraform.tfvars
- Variables marcadas como sensitive = true
- External ID automático en la integración

## Desafíos Encontrados y Soluciones

### Desafío 1: Configuración de External ID
**Problema:** La integración AWS-Datadog requiere un external_id específico.
**Solución:** Usar el external_id generado automáticamente por el recurso datadog_integration_aws.

### Desafío 2: Permisos IAM Complejos
**Problema:** Datadog necesita muchos permisos específicos para recopilar métricas.
**Solución:** Crear una política IAM comprehensiva con todos los permisos necesarios.

### Desafío 3: Instalación del Agente en User Data
**Problema:** El agente debe instalarse correctamente en el script de user_data.
**Solución:** Usar el script oficial de instalación de Datadog con variables de entorno.

### Desafío 4: Configuración de Docker Monitoring
**Problema:** El agente debe monitorear contenedores Docker.
**Solución:** Crear archivo de configuración YAML para el plugin de Docker.

### Desafío 5: Configuración EU vs US
**Problema:** Diferencia entre sitios US y EU de Datadog.
**Solución:** Configurar api_url específico y usar DD_SITE en la instalación.

## Mejores Prácticas Implementadas

1. **Seguridad:** Variables marcadas como sensibles
2. **Modularidad:** Separación de recursos en archivos específicos
3. **Documentación:** Comentarios explicativos en el código
4. **Flexibilidad:** Variables configurables para diferentes entornos
5. **Monitoreo:** Alertas proactivas para métricas críticas
6. **Internacionalización:** Soporte para sitios EU y US de Datadog

## Comandos de Terraform Utilizados

```bash
# Inicializar Terraform
terraform init

# Verificar la configuración
terraform plan

# Aplicar la infraestructura
terraform apply

# Destruir la infraestructura (cuando sea necesario)
terraform destroy
```

## Estructura de Archivos Creados

```
tf/
├── provider.tf              # Proveedores AWS y Datadog
├── variables.tf             # Variables de configuración
├── datadog.tf               # Recursos de Datadog
├── ec2.tf                   # Instancias EC2 (actualizado)
├── terraform.tfvars         # Variables sensibles (no en git)
└── scripts/
    ├── backend_user_data.sh  # Script con agente Datadog
    └── frontend_user_data.sh # Script con agente Datadog
```

## Resultados Alcanzados ✅

### ✅ Infraestructura Desplegada Exitosamente

1. **Dashboard automático** con métricas de AWS ✅
   - Dashboard ID: `7sm-cdn-597`
   - Título: "AWS Infrastructure Monitoring"
   - Widgets: CPU, Memory, Network, Disk usage

2. **Alertas configuradas** para CPU y memoria ✅
   - Monitor CPU: ID `90040234` (Warning: 70%, Critical: 80%)
   - Monitor Memory: ID `90040233` (Warning: 75%, Critical: 85%)

3. **Agente Datadog** funcionando en ambas instancias ✅
   - Instalación automática via user_data
   - Configuración EU (datadoghq.eu)
   - Integración Docker habilitada

4. **Monitoreo de Docker** activo ✅
   - Configuración YAML para Docker
   - Métricas de contenedores
   - Reinicio automático del agente

5. **Integración AWS-Datadog** completa ✅
   - Rol IAM: `datadog-integration-role`
   - Política IAM: `datadog-policy`
   - Permisos completos para métricas AWS

## Desafíos Resueltos Durante la Implementación

### Desafío 6: Dependencias Circulares en Terraform
**Problema:** Error de ciclo entre `datadog_integration_aws` y `aws_iam_role`.
**Solución:** Reestructurar la creación de recursos y usar external_id temporal.

### Desafío 7: Recursos Deprecados
**Problema:** `datadog_integration_aws` está deprecado.
**Solución:** Migrar a `datadog_integration_aws_account` con argumentos correctos.

### Desafío 8: Widgets de Dashboard Demasiado Grandes
**Problema:** Error "MSL widget out of grid. 47 is greater than the maximum of 12".
**Solución:** Reducir el ancho de widgets de 47 a 12 píxeles.

### Desafío 9: Tipos de Instancia No Elegibles para Free Tier
**Problema:** `t2.micro` no disponible en Free Tier.
**Solución:** Cambiar a `t3.micro` que es elegible para Free Tier.

### Desafío 10: Archivos S3 No Existentes
**Problema:** Referencias a archivos `backend.zip` y `frontend.zip` que no existen.
**Solución:** Simplificar la configuración eliminando referencias S3 temporales.

## Comandos de Verificación Utilizados

```bash
# Verificar estado de Terraform
terraform state list

# Verificar recursos específicos
terraform show | grep -A 5 "datadog_dashboard"
terraform show | grep -A 5 "datadog_monitor"

# Verificar instancias EC2
aws ec2 describe-instances --query "Reservations[*].Instances[*].[InstanceId,State.Name,PublicIpAddress]"

# Verificar tipos de instancia elegibles para Free Tier
aws ec2 describe-instance-types --filters "Name=free-tier-eligible,Values=true"
```

## URLs de Acceso a Datadog

- **Dashboard**: https://app.datadoghq.eu/dashboard/7sm-cdn-597
- **Monitores**: https://app.datadoghq.eu/monitors/manage
- **Infrastructure**: https://app.datadoghq.eu/infrastructure

## Estado Final de la Infraestructura

### Recursos AWS Creados:
- ✅ 2 instancias EC2 (backend y frontend) - tipo t3.micro
- ✅ 2 Security Groups (backend_sg, frontend_sg)
- ✅ 2 Roles IAM (ec2_role, datadog_role)
- ✅ 1 Política IAM (datadog_policy)
- ✅ 1 Instance Profile (ec2_instance_profile)

### Recursos Datadog Creados:
- ✅ 1 Dashboard (aws_infrastructure)
- ✅ 2 Monitores (high_cpu, high_memory)
- ✅ Integración AWS-Datadog configurada

### Scripts de User Data:
- ✅ backend_user_data.sh - Con instalación de agente Datadog
- ✅ frontend_user_data.sh - Con instalación de agente Datadog

## Lecciones Aprendidas

1. **Free Tier Limitations**: Siempre verificar tipos de instancia elegibles
2. **Dashboard Layout**: Los widgets tienen límites de tamaño específicos
3. **Resource Dependencies**: Planificar cuidadosamente las dependencias
4. **Deprecated Resources**: Mantenerse actualizado con cambios en providers
5. **Error Handling**: Implementar manejo robusto de errores en Terraform

## Próximos Pasos Recomendados

1. **Verificar métricas** en el dashboard de Datadog
2. **Probar alertas** generando carga en las instancias
3. **Configurar notificaciones** para los monitores
4. **Añadir más métricas** según necesidades específicas
5. **Implementar logging** con Datadog Logs
