# Guía del equipo (5 integrantes) — Repo nuevo, ramas, copiar/pegar y Releases

Documento para llevar InfraTrack Backend al **repositorio del curso**, entrega por entrega, como pide el profesor.

**Repo de referencia (código ya listo):** clonen o descarguen desde este proyecto local / [infra-track-repo-back](https://github.com/Dhilsen18/infra-track-repo-back.git) — rama `main`.

**Regla de nombres:** ramas por **endpoint** → `feature/list-operators`, `feature/create-alert`.  
**No** usar nombres de bounded context (`feature/iam`, `feature/fleet`, etc.).

---

## 1. Semantic Versioning (obligatorio)

Formato: **`vMAJOR.MINOR.PATCH`**

| Parte | Cuándo sube | Ejemplo en InfraTrack |
|-------|-------------|------------------------|
| **MAJOR** | Cambio incompatible (breaking) | Seguimos en `0` (proyecto académico) |
| **MINOR** | **Nueva feature / endpoint** | Cada merge a `main`: `v0.1.0` … `v0.19.0` (19 features) |
| **PATCH** | Solo corrección de bugs | `v0.7.1` si arreglan operators sin features nuevas |

### ¿Cuándo va el tag?

El **tag** (`v0.x.0`) va **después de mergear** la rama feature a `main`. Ese tag **agrupa** todo lo acumulado en `main` hasta ese momento (no solo el último commit de la feature).

```
feature/create-operator  →  PR  →  merge main  →  git tag v0.6.0  →  GitHub Release
```

Cada Release en GitHub marca ese punto agrupado del proyecto.

### Mapa de versiones (19 ramas — estilo enrollment)

| Versión | Rama | Endpoint |
|---------|------|----------|
| `v0.1.0` | `release/0.1.0-shared` | Shared platform |
| `v0.2.0` | `feature/sign-up` | `POST /authentication/sign-up` |
| `v0.3.0` | `feature/sign-in` | `POST /authentication/sign-in` |
| `v0.4.0` | `feature/list-users` | `GET /users` |
| `v0.5.0` | `feature/list-roles` | `GET /roles` |
| `v0.6.0` | `feature/create-operator` | `POST /operators` |
| `v0.7.0` | `feature/list-operators` | `GET /operators` |
| `v0.8.0` | `feature/list-machinery` | `GET /machinery` |
| `v0.9.0` | `feature/create-machinery` | `POST /machinery` |
| `v0.10.0` | `feature/update-machinery` | `PUT /machinery/{id}` |
| `v0.11.0` | `feature/register-iot-node` | `GET/POST /iotNodes` |
| `v0.12.0` | `feature/create-maintenance-record` | maintenance |
| `v0.13.0` | `feature/list-telemetry-data` | telemetry |
| `v0.14.0` | `feature/list-alerts` | `GET /alerts` |
| `v0.15.0` | `feature/create-alert` | `POST /alerts` |
| `v0.16.0` | `feature/acknowledge-alert` | acknowledge |
| `v0.17.0` | `feature/list-worksites` | dominio obras |
| `v0.18.0` | `feature/create-staff-members` | staff |
| `v0.19.0` | `feature/assign-transport-to-worksite` | REST `/worksites` |

`main` al final = mismo contenido que `v0.19.0`.

> **Site-management:** REST de obras en **v0.17.0**. v0.15 y v0.16 = dominio/persistencia.

---

## 2. División del equipo (5 integrantes)

Trabajan **en paralelo** preparando su parte, pero los **merge a `main` van en orden** (v0.1 → … → v0.19).

| Integrante | Rol | Entregas (en orden) | Tags |
|------------|-----|---------------------|------|
| **Integrante 1** | Líder / DevOps | Bootstrap + `release/0.1.0-shared` | `v0.1.0` |
| **Integrante 2** | IAM | `sign-up` → `sign-in` → `list-users` → `list-roles` | `v0.2.0`–`v0.5.0` |
| **Integrante 3** | Fleet (parte 1) | `create-operator` → `list-operators` → `list-machinery` → `create-machinery` → `update-machinery` → `register-iot-node` | `v0.6.0`–`v0.11.0` |
| **Integrante 4** | Fleet + Monitoring | `create-maintenance-record` → `list-telemetry-data` → `list-alerts` → `create-alert` → `acknowledge-alert` | `v0.12.0`–`v0.16.0` |
| **Integrante 5** | Site Management | `list-worksites` → `create-staff-members` → `assign-transport-to-worksite` | `v0.17.0`–`v0.19.0` |

### Responsabilidades extra

| Integrante | También hace |
|------------|--------------|
| **1** | Crear repo GitHub del equipo, proteger `main`, revisar PRs, publicar Releases |
| **2** | Probar sign-up, sign-in, users, roles en Swagger |
| **3** | Probar create/list operators, list/create/update machinery, iotNodes |
| **4** | Probar maintenance, telemetry, list/create/ack alerts |
| **5** | Probar worksites (REST completo en v0.19) |

### Calendario sugerido (19 entregas)

| Semana | Quién | Rama | Release (tag agrupa `main`) |
|--------|-------|------|------------------------------|
| 1 | Int. 1 | `release/0.1.0-shared` | `v0.1.0` |
| 2 | Int. 2 | `feature/sign-up` | `v0.2.0` |
| 3 | Int. 2 | `feature/sign-in` | `v0.3.0` |
| 4 | Int. 2 | `feature/list-users` | `v0.4.0` |
| 5 | Int. 2 | `feature/list-roles` | `v0.5.0` |
| 6 | Int. 3 | `feature/create-operator` | `v0.6.0` |
| 7 | Int. 3 | `feature/list-operators` | `v0.7.0` |
| 8 | Int. 3 | `feature/list-machinery` | `v0.8.0` |
| 9 | Int. 3 | `feature/create-machinery` | `v0.9.0` |
| 10 | Int. 3 | `feature/update-machinery` | `v0.10.0` |
| 11 | Int. 3 | `feature/register-iot-node` | `v0.11.0` |
| 12 | Int. 4 | `feature/create-maintenance-record` | `v0.12.0` |
| 13 | Int. 4 | `feature/list-telemetry-data` | `v0.13.0` |
| 14 | Int. 4 | `feature/list-alerts` | `v0.14.0` |
| 15 | Int. 4 | `feature/create-alert` | `v0.15.0` |
| 16 | Int. 4 | `feature/acknowledge-alert` | `v0.16.0` |
| 17 | Int. 5 | `feature/list-worksites` | `v0.17.0` |
| 18 | Int. 5 | `feature/create-staff-members` | `v0.18.0` |
| 19 | Int. 5 | `feature/assign-transport-to-worksite` | `v0.19.0` |

---

## 3. Paso 0 — Crear el repo nuevo (Integrante 1)

### 3.1 En GitHub

1. Crear repositorio vacío: `InfraTrack-Backend` (sin README, sin .gitignore).
2. Invitar a los 4 compañeros como colaboradores.
3. (Opcional) Proteger rama `main`: Settings → Branches → require PR.

### 3.2 En tu PC (PowerShell)

```powershell
mkdir InfraTrack-Backend-Equipo
cd InfraTrack-Backend-Equipo
git init
git branch -M main
```

### 3.3 Copiar archivos base (desde el repo de referencia)

Copiar **solo** estos archivos/carpetas (Explorador de archivos o `Copy-Item`):

```
pom.xml
mvnw
mvnw.cmd
.mvn/                    (carpeta completa)
.gitignore
.gitattributes
.env.example
LICENSE.md
README.md                (opcional, el del proyecto)
```

**No copiar aún** `src/main/java/.../iam`, `fleet`, `monitoring`, `sitemanagement`.

### 3.4 Primer commit y push

```powershell
git add .
git commit -m "chore: project bootstrap"
git remote add origin https://github.com/TU-ORG/InfraTrack-Backend.git
git push -u origin main
```

---

## 4. Plantilla repetida por cada entrega

Cada integrante sigue ** estos pasos** cuando le toque su turno (después del merge anterior):

### A) Actualizar `main`

```powershell
git checkout main
git pull origin main
```

### B) Crear rama

```powershell
git checkout -b feature/NOMBRE-DE-LA-RAMA
# Ejemplo: git checkout -b feature/list-operators
```

### C) Copiar archivos de ESTA entrega

Ver sección **5** (lista por integrante).  
Origen: repo de referencia, rama `main` o la rama feature correspondiente en [infra-track-repo-back](https://github.com/Dhilsen18/infra-track-repo-back.git).

**Atajo con git** (si clonaron el repo de referencia):

```powershell
# Desde la carpeta del repo NUEVO del equipo
git checkout REFERENCIA/main -- ruta/archivo1.java ruta/archivo2.java
# REFERENCIA = remote apuntando al repo con código completo
```

### D) Compilar y probar

```powershell
$env:DATABASE_URL="localhost"
$env:DATABASE_PORT="3306"
$env:DATABASE_NAME="infratrack-os"
$env:DATABASE_USER="root"
$env:DATABASE_PASSWORD="admin123"
$env:PORT="8080"
mvn compile
mvn spring-boot:run
```

Swagger: `http://localhost:8080/swagger-ui.html`

### E) Commit con mensaje convencional

```powershell
git add .
git commit -m "feat(fleet): GET/POST /operators"
```

### F) Tag anotado (Semantic Versioning) — **por terminal**

```powershell
git tag -a v0.3.0 -m "v0.3.0 - List and create operators"
git push origin feature/list-operators
git push origin v0.3.0
```

### G) Pull Request en GitHub

1. Push de la rama (si no lo hicieron en F).
2. GitHub → **Pull requests** → **New pull request**.
3. Base: `main` ← Compare: `feature/list-operators`.
4. Título: `[v0.3.0] feat: list-operators`.
5. Descripción: endpoints agregados + captura Swagger.
6. Revisión del Integrante 1 → **Merge**.

### H) Release en GitHub — **dos formas**

#### Opción 1 — Interfaz web (como pide el profesor)

1. Repo → **Releases** → **Draft a new release**.
2. **Choose a tag:** `v0.3.0` (seleccionar el tag ya pusheado).
3. **Target:** `main`.
4. **Release title:** `v0.3.0 — List operators`.
5. **Description:**

   ```markdown
   ## What's new
   - GET /api/v1/operators
   - POST /api/v1/operators

   ## How to test
   mvn spring-boot:run → Swagger UI
   ```

6. **Publish release**.

#### Opción 2 — Terminal con GitHub CLI

```powershell
gh release create v0.3.0 `
  --title "v0.3.0 — List operators" `
  --notes "GET/POST /api/v1/operators. Semantic version: minor bump for new feature."
```

> El profesor suele pedir **tag por terminal** (`git tag -a`) **y** **Release visible en GitHub**. Hagan **ambos**.

### I) Si hay bugfix después del release

```powershell
git checkout -b fix/operator-validation main
# corregir código
git commit -m "fix(fleet): validate operator email"
git tag -a v0.3.1 -m "v0.3.1 - Fix operator validation"
git push origin fix/operator-validation v0.3.1
# PR → merge → gh release create v0.3.1
```

Solo sube **PATCH**, no MINOR.

---

## 5. Qué copiar en cada entrega (detalle por integrante)

**Prefijo base de paquetes:**  
`src/main/java/com/techtitans/infratrack/platform/`

**Recursos compartidos (copiar una sola vez en v0.1.0):**

```
src/main/resources/application.properties
src/main/resources/application-dev.properties
src/main/resources/messages.properties
src/main/resources/messages_es.properties
src/test/java/com/techtitans/infratrack/platform/InfraTrackWebServiceApplicationTests.java
```

---

### Integrante 1 — `v0.1.0` · rama `release/0.1.0-shared`

**Rama:**

```powershell
git checkout main
git pull
git checkout -b release/0.1.0-shared
```

**Copiar carpetas/archivos:**

```
src/main/java/com/techtitans/infratrack/platform/shared/          (carpeta completa)
src/main/java/com/techtitans/infratrack/platform/InfraTrackWebServiceApplication.java
+ recursos compartidos (arriba)
```

**Commit y tag:**

```powershell
git add .
git commit -m "release: shared platform (errors, i18n, OpenAPI, JPA base)"
git tag -a v0.1.0 -m "v0.1.0 - Shared platform"
git push origin release/0.1.0-shared
git push origin v0.1.0
```

PR → merge → Release `v0.1.0`.

---

### Integrante 2 — `v0.2.0` · rama `feature/sign-up`

**Esperar:** merge de `v0.1.0` en `main`.

**Copiar:**

```
src/main/java/com/techtitans/infratrack/platform/iam/           (carpeta completa)
```

**Endpoints nuevos:**  
`POST /authentication/sign-up`, `POST /authentication/sign-in`, `GET /users`, `GET /roles`

**Tag:** `v0.2.0`  
**Commit:** `feat(iam): sign-up, sign-in, users, roles and JWT`

---

### Integrante 3 — Fleet parte 1

#### Entrega 3a — `v0.3.0` · `feature/list-operators`

**Copiar** (solo estos archivos nuevos):

```
fleet/application/commandservices/FleetOperatorCommandService.java
fleet/application/queryservices/FleetOperatorQueryService.java
fleet/application/internal/commandservices/FleetOperatorCommandServiceImpl.java
fleet/application/internal/queryservices/FleetOperatorQueryServiceImpl.java
fleet/domain/model/aggregates/FleetOperator.java
fleet/domain/model/commands/CreateFleetOperatorCommand.java
fleet/domain/model/queries/GetAllFleetOperatorsQuery.java
fleet/domain/model/queries/GetFleetOperatorByIdQuery.java
fleet/domain/model/valueobjects/OperatorStatus.java
fleet/domain/repositories/FleetOperatorRepository.java
fleet/infrastructure/persistence/jpa/entities/FleetOperatorPersistenceEntity.java
fleet/infrastructure/persistence/jpa/repositories/FleetOperatorPersistenceRepository.java
fleet/infrastructure/persistence/jpa/adapters/FleetOperatorRepositoryImpl.java
fleet/infrastructure/persistence/jpa/assemblers/FleetOperatorPersistenceAssembler.java
fleet/interfaces/rest/OperatorsController.java
fleet/interfaces/rest/resources/OperatorResource.java
fleet/interfaces/rest/resources/CreateOperatorResource.java
fleet/interfaces/rest/transform/OperatorResourceFromEntityAssembler.java
```

**Tag:** `v0.3.0` · **Endpoints:** `GET/POST /operators`

---

#### Entrega 3b — `v0.4.0` · `feature/list-machinery`

**Copiar** (archivos nuevos respecto a v0.3.0):

```
fleet/.../Machinery.java, CreateMachineryCommand.java, UpdateMachineryCommand.java
fleet/.../GetAllMachineryQuery.java, GetMachineryByIdQuery.java
fleet/.../FuelType.java, MachineryStatus.java
fleet/.../MachineryRepository.java
fleet/application/.../MachineryCommandService.java, MachineryQueryService.java
fleet/application/internal/.../MachineryCommandServiceImpl.java, MachineryQueryServiceImpl.java
fleet/infrastructure/.../MachineryPersistenceEntity.java, MachineryPersistenceRepository.java
fleet/infrastructure/.../MachineryRepositoryImpl.java, MachineryPersistenceAssembler.java
fleet/interfaces/rest/MachineryController.java
fleet/interfaces/rest/resources/MachineryResource.java, CreateMachineryResource.java, UpdateMachineryResource.java
fleet/interfaces/rest/transform/MachineryResourceFromEntityAssembler.java
```

**Atajo:**

```powershell
git diff feature/list-operators..feature/list-machinery --name-only
```

(Ejecutar en el repo de referencia.)

**Tag:** `v0.4.0` · **Endpoints:** `GET/POST/PUT /machinery`

---

#### Entrega 3c — `v0.5.0` · `feature/register-iot-node`

**Copiar:** diff `feature/list-machinery..feature/register-iot-node` (18 archivos IotNode).

**Tag:** `v0.5.0` · **Endpoints:** `GET/POST /iotNodes`, link a machinery

---

### Integrante 4 — Fleet + Monitoring

#### Entrega 4a — `v0.6.0` · `feature/create-maintenance-record`

**Copiar:** diff `feature/register-iot-node..feature/create-maintenance-record`

Incluye además:

```
fleet/application/acl/                                          (carpeta)
fleet/interfaces/acl/                                           (carpeta)
fleet/application/internal/eventhandlers/FleetApplicationReadyEventHandler.java
```

**Tag:** `v0.6.0` · **Endpoints:** `GET/POST /maintenanceRecords`

---

#### Entrega 4b — `v0.7.0` · `feature/list-telemetry-data`

**Copiar:** diff `feature/create-maintenance-record..feature/list-telemetry-data`

Incluye carpeta:

```
monitoring/application/internal/outboundservices/               (carpeta completa)
```

**Tag:** `v0.7.0` · **Endpoints:** `GET/POST /telemetryData`

---

#### Entrega 4c — `v0.8.0` · `feature/create-alert`

**Copiar:** diff `feature/list-telemetry-data..feature/create-alert`

Incluye:

```
monitoring/application/internal/eventhandlers/MonitoringApplicationReadyEventHandler.java
```

**Tag:** `v0.8.0` · **Endpoints:** `GET/POST /alerts`, acknowledge

---

### Integrante 5 — Site Management

#### Entrega 5a — `v0.9.0` · `feature/list-worksites`

**Copiar:** diff `feature/create-alert..feature/list-worksites` (28 archivos sitemanagement).

**Tag:** `v0.9.0` · Dominio obras (sin REST aún)

---

#### Entrega 5b — `v0.10.0` · `feature/create-staff-members`

**Copiar:** diff `feature/list-worksites..feature/create-staff-members` (18 archivos staff).

**Tag:** `v0.10.0`

---

#### Entrega 5c — `v0.11.0` · `feature/assign-transport-to-worksite`

**Copiar:** diff `feature/create-staff-members..feature/assign-transport-to-worksite`:

```
sitemanagement/application/internal/eventhandlers/SiteManagementApplicationReadyEventHandler.java
sitemanagement/application/internal/outboundservices/acl/SiteManagementExternalFleetService.java
sitemanagement/domain/model/commands/AssignTransportToWorksiteCommand.java
sitemanagement/interfaces/rest/WorksitesController.java
sitemanagement/interfaces/rest/resources/WorksiteTransportResource.java
sitemanagement/interfaces/rest/transform/WorksiteTransportResourceFromEntityAssembler.java
```

**Tag:** `v0.11.0` · **REST completo** `/worksites` en Swagger

---

## 6. Atajo: listar archivos exactos con git

En el **repo de referencia** (donde ya están todas las ramas):

```powershell
git diff feature/sign-up..feature/list-operators --name-only
```

Cambia las dos ramas por la pareja anterior → siguiente de la tabla de versiones.

---

## 7. Checklist antes de cada PR (todos)

- [ ] Rama con nombre de endpoint (`feature/list-operators`, no `feature/fleet`)
- [ ] Solo archivos de **esta** versión (+ lo que ya está en `main`)
- [ ] `mvn compile` sin errores
- [ ] App arranca (`mvn spring-boot:run`)
- [ ] Endpoint(s) nuevo(s) visibles en Swagger
- [ ] `.env` **no** commiteado
- [ ] Tag anotado: `git tag -a v0.x.0 -m "..."`
- [ ] Tag pusheado: `git push origin v0.x.0`
- [ ] PR abierto y mergeado a `main`
- [ ] **GitHub Release** publicado para ese tag

---

## 8. Flujo visual del equipo

```
Integrante 1:  [bootstrap] → [v0.1.0 shared] ──PR──► main ──Release──► GitHub v0.1.0
Integrante 2:                    [v0.2.0 sign-up] ──PR──► main ──Release──► v0.2.0
Integrante 3:                         [v0.3.0] ──PR──► main ──Release──► v0.3.0
                                      [v0.4.0] ──PR──► main ──Release──► v0.4.0
                                      [v0.5.0] ──PR──► main ──Release──► v0.5.0
Integrante 4:                              [v0.6.0] … [v0.8.0]  (igual patrón)
Integrante 5:                                        [v0.9.0] … [v0.11.0]
```

**Importante:** no mergear `v0.5.0` antes de que `v0.4.0` esté en `main`. El orden importa.

---

## 9. Probar localmente

```powershell
$env:DATABASE_URL="localhost"
$env:DATABASE_PORT="3306"
$env:DATABASE_NAME="infratrack-os"
$env:DATABASE_USER="root"
$env:DATABASE_PASSWORD="admin123"
$env:PORT="8080"
mvn spring-boot:run
```

- API: `http://localhost:8080/api/v1`
- Swagger: `http://localhost:8080/swagger-ui.html`

En versiones tempranas (`v0.1.0`, `v0.2.0`) solo aparecen los endpoints de esa etapa.

---

## 10. Resumen rápido

| Pregunta | Respuesta |
|----------|-----------|
| ¿Por dónde empezamos? | Integrante 1 crea repo vacío + bootstrap |
| ¿De dónde copiamos? | Repo de referencia (`main` o ramas feature) |
| ¿Cómo sabemos qué archivos? | Sección 5 o `git diff rama-anterior..rama-nueva --name-only` |
| ¿Cuándo tag? | Después del commit, **antes o después del PR** (tag en la rama feature) |
| ¿Terminal + GitHub? | `git tag -a v0.x.0` + push tag + **Publish release** en GitHub |
| ¿Semantic versioning? | MINOR sube con cada feature (`v0.3.0` → `v0.4.0`); PATCH solo bugs (`v0.3.1`) |
| ¿Cuántos somos? | 5 — tabla sección 2 |

---

## Documentos relacionados

- [`feature-release-plan.md`](feature-release-plan.md) — mapa release ↔ rama ↔ endpoints
- [`bounded-contexts-guide.md`](bounded-contexts-guide.md) — capas DDD
- [`user-stories.md`](user-stories.md) — historias técnicas API
