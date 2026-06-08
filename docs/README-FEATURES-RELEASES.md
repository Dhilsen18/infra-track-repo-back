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

> **Site-management:** REST de obras en **v0.19.0**. v0.17 y v0.18 = dominio/persistencia.

---

## 2. División del equipo (5 integrantes)

Trabajan **en paralelo** preparando su parte, pero los **merge a `main` van en orden** (v0.1 → … → v0.19).

| Integrante | Rol | Entregas (en orden) | Tags |
|------------|-----|---------------------|------|
| **Integrante 1** | Líder / DevOps | Bootstrap + `release/0.1.0-shared` | `v0.1.0` |
| **Integrante 2** | IAM | `sign-up` → `sign-in` → `list-users` → `list-roles` | `v0.2.0`–`v0.5.0` |
| **Integrante 3** | Fleet (parte 1) | `create-operator` → … → `register-iot-node` | `v0.6.0`–`v0.11.0` |
| **Integrante 4** | Fleet + Monitoring | `create-maintenance-record` → … → `acknowledge-alert` | `v0.12.0`–`v0.16.0` |
| **Integrante 5** | Site Management | `list-worksites` → `create-staff-members` → `assign-transport-to-worksite` | `v0.17.0`–`v0.19.0` |

| Integrante | También hace |
|------------|--------------|
| **1** | Crear repo, revisar PRs, **merge a main**, **tag + GitHub Release** |
| **2–5** | Copiar archivos, probar Swagger, abrir PR |

---

## 3. Conceptos clave — Rama, Merge, Tag, Release

| Concepto | Qué es | Quién |
|----------|--------|-------|
| **Rama `feature/*`** | Código de **un** endpoint | Int. 2, 3, 4 o 5 |
| **PR** | Pedir unir tu rama → `main` | Quien hizo la feature |
| **Merge** | Aprobar PR; código entra a `main` | **Integrante 1** |
| **Tag `v0.x.0`** | Marca Git del `main` agrupado | **Integrante 1** (terminal) |
| **GitHub Release** | Publicación formal del tag | **Integrante 1** (web) |

### Flujo completo (repítelo en cada entrega)

```
1. Copiar archivos de ESTA feature (sección 6)
2. mvn spring-boot:run + probar Swagger
3. git commit + git push (rama feature)
4. Abrir PR → main
5. Integrante 1 revisa y MERGEA
6. git tag -a v0.X.0 + git push origin v0.X.0
7. GitHub → Releases → Publish v0.X.0
8. Siguiente persona espera main actualizado
```

**Merge ≠ Release:** merge integra código; release publica la versión agrupada en GitHub.

**El tag agrupa** todo lo que ya está en `main` (shared + IAM + … + tu feature), no solo tu diff.

---

## 4. ¿Estará funcional?

**Sí**, si:

1. Copian **en orden** (no saltar v0.6 antes de v0.5).
2. Copian **solo** los archivos de esa entrega (sección 6).
3. MySQL corre con base `infratrack-os`.
4. Pasan `mvn compile` antes del PR.

| Después de | Qué funciona en Swagger |
|------------|-------------------------|
| v0.1.0 | App arranca (shared) |
| v0.2.0–v0.5.0 | Auth, users, roles |
| v0.6.0–v0.11.0 | Operators, machinery, iotNodes |
| v0.12.0–v0.16.0 | Maintenance, telemetry, alerts |
| v0.19.0 | **Todo** incluido `/worksites` |

El repo [infra-track-repo-back](https://github.com/Dhilsen18/infra-track-repo-back.git) ya tiene **todas las ramas listas** — ustedes replican el proceso en su repo del curso.

---

## 5. Paso 0 — Crear repo del equipo (Integrante 1)

1. GitHub → repo vacío `InfraTrack-Backend` (sin README).
2. Invitar a los 4 compañeros.
3. Local:

```powershell
mkdir InfraTrack-Backend-Equipo
cd InfraTrack-Backend-Equipo
git init
git branch -M main
```

4. Copiar **solo** bootstrap desde referencia:

```
pom.xml, mvnw, mvnw.cmd, .mvn/, .gitignore, .gitattributes, .env.example, LICENSE.md
```

5. `git add .` → `commit` → `push -u origin main`

6. Clonar referencia en otra carpeta:

```powershell
git clone https://github.com/Dhilsen18/infra-track-repo-back.git ..\InfraTrack-Referencia
```

---

## 6. Qué copiar en CADA rama

**Prefijo:** `src/main/java/com/techtitans/infratrack/platform/` → abreviado **`.../`**

**Recursos (solo v0.1.0):** `src/main/resources/application*.properties`, `messages*.properties`, `src/test/.../InfraTrackWebServiceApplicationTests.java`

**Plantilla por entrega:**

```powershell
git checkout main && git pull
git checkout -b feature/NOMBRE
# copiar archivos de abajo desde ..\InfraTrack-Referencia
mvn compile && mvn spring-boot:run
git add . && git commit -m "feat(...): ..."
git push -u origin feature/NOMBRE
# PR → merge (Int.1) → tag v0.X.0 → Release
```

---

### v0.1.0 · `release/0.1.0-shared` · **Int. 1**

```
.../shared/                              (carpeta completa)
.../InfraTrackWebServiceApplication.java
+ recursos y test
```

---

### v0.2.0 · `feature/sign-up` · **Int. 2**

Esperar: v0.1.0 en main.

```
.../iam/   (parcial — archivos de sign-up, ver lista en repo referencia)
```

Lista exacta:

```
.../iam/application/commandservices/RoleCommandService.java
.../iam/application/commandservices/UserCommandService.java
.../iam/application/internal/commandservices/RoleCommandServiceImpl.java
.../iam/application/internal/commandservices/UserCommandServiceImpl.java
.../iam/application/internal/eventhandlers/ApplicationReadyEventHandler.java
.../iam/application/internal/outboundservices/hashing/HashingService.java
.../iam/domain/model/aggregates/User.java
.../iam/domain/model/commands/SeedRolesCommand.java
.../iam/domain/model/commands/SignUpCommand.java
.../iam/domain/model/entities/Role.java
.../iam/domain/model/valueobjects/Roles.java
.../iam/domain/repositories/RoleRepository.java
.../iam/domain/repositories/UserRepository.java
.../iam/infrastructure/hashing/bcrypt/BCryptHashingService.java
.../iam/infrastructure/hashing/bcrypt/services/HashingServiceImpl.java
.../iam/infrastructure/persistence/jpa/adapters/RoleRepositoryImpl.java
.../iam/infrastructure/persistence/jpa/adapters/UserRepositoryImpl.java
.../iam/infrastructure/persistence/jpa/assemblers/RolePersistenceAssembler.java
.../iam/infrastructure/persistence/jpa/assemblers/UserPersistenceAssembler.java
.../iam/infrastructure/persistence/jpa/entities/RolePersistenceEntity.java
.../iam/infrastructure/persistence/jpa/entities/UserPersistenceEntity.java
.../iam/infrastructure/persistence/jpa/repositories/RolePersistenceRepository.java
.../iam/infrastructure/persistence/jpa/repositories/UserPersistenceRepository.java
.../iam/interfaces/acl/IamContextFacade.java
.../iam/interfaces/rest/SignUpController.java
.../iam/interfaces/rest/resources/SignUpResource.java
.../iam/interfaces/rest/resources/UserResource.java
.../iam/interfaces/rest/transform/SignUpCommandFromResourceAssembler.java
.../iam/interfaces/rest/transform/UserResourceFromEntityAssembler.java
```

**Probar:** POST `/authentication/sign-up`

---

### v0.3.0 · `feature/sign-in` · **Int. 2**

```
.../iam/domain/model/commands/SignInCommand.java
.../iam/application/internal/outboundservices/tokens/TokenService.java
.../iam/infrastructure/tokens/jwt/BearerTokenService.java
.../iam/infrastructure/tokens/jwt/services/TokenServiceImpl.java
.../iam/infrastructure/authorization/sfs/          (carpeta completa)
.../iam/interfaces/rest/SignInController.java
.../iam/interfaces/rest/resources/AuthenticatedUserResource.java
.../iam/interfaces/rest/resources/SignInResource.java
.../iam/interfaces/rest/transform/AuthenticatedUserResourceFromEntityAssembler.java
.../iam/interfaces/rest/transform/SignInCommandFromResourceAssembler.java
```

**Probar:** POST `/authentication/sign-in` → token JWT

---

### v0.4.0 · `feature/list-users` · **Int. 2**

```
.../iam/application/queryservices/UserQueryService.java
.../iam/application/internal/queryservices/UserQueryServiceImpl.java
.../iam/domain/model/queries/GetAllUsersQuery.java
.../iam/domain/model/queries/GetUserByIdQuery.java
.../iam/domain/model/queries/GetUserByUsernameQuery.java
.../iam/interfaces/rest/UsersController.java
```

**Probar:** GET `/users` (con Bearer)

---

### v0.5.0 · `feature/list-roles` · **Int. 2**

```
.../iam/application/queryservices/RoleQueryService.java
.../iam/application/internal/queryservices/RoleQueryServiceImpl.java
.../iam/domain/model/queries/GetAllRolesQuery.java
.../iam/domain/model/queries/GetRoleByNameQuery.java
.../iam/interfaces/rest/RolesController.java
.../iam/interfaces/rest/resources/RoleResource.java
.../iam/interfaces/rest/transform/RoleResourceFromEntityAssembler.java
```

**Probar:** GET `/roles`

---

### v0.6.0 · `feature/create-operator` · **Int. 3**

```
.../fleet/domain/model/aggregates/FleetOperator.java
.../fleet/domain/model/commands/CreateFleetOperatorCommand.java
.../fleet/domain/model/valueobjects/OperatorStatus.java
.../fleet/domain/repositories/FleetOperatorRepository.java
.../fleet/application/commandservices/FleetOperatorCommandService.java
.../fleet/application/internal/commandservices/FleetOperatorCommandServiceImpl.java
.../fleet/infrastructure/persistence/jpa/entities/FleetOperatorPersistenceEntity.java
.../fleet/infrastructure/persistence/jpa/repositories/FleetOperatorPersistenceRepository.java
.../fleet/infrastructure/persistence/jpa/adapters/FleetOperatorRepositoryImpl.java
.../fleet/infrastructure/persistence/jpa/assemblers/FleetOperatorPersistenceAssembler.java
.../fleet/interfaces/rest/OperatorsController.java
.../fleet/interfaces/rest/resources/OperatorResource.java
.../fleet/interfaces/rest/resources/CreateOperatorResource.java
.../fleet/interfaces/rest/transform/OperatorResourceFromEntityAssembler.java
```

**Probar:** POST `/operators`

---

### v0.7.0 · `feature/list-operators` · **Int. 3**

```
.../fleet/domain/model/queries/GetAllFleetOperatorsQuery.java
.../fleet/domain/model/queries/GetFleetOperatorByIdQuery.java
.../fleet/application/queryservices/FleetOperatorQueryService.java
.../fleet/application/internal/queryservices/FleetOperatorQueryServiceImpl.java
.../fleet/interfaces/rest/OperatorsController.java    ← reemplazar (GET+POST)
```

**Probar:** GET `/operators`

---

### v0.8.0 · `feature/list-machinery` · **Int. 3**

```
.../fleet/domain/model/aggregates/Machinery.java
.../fleet/domain/model/queries/GetAllMachineryQuery.java
.../fleet/domain/model/queries/GetMachineryByIdQuery.java
.../fleet/domain/model/valueobjects/FuelType.java
.../fleet/domain/model/valueobjects/MachineryStatus.java
.../fleet/domain/repositories/MachineryRepository.java
.../fleet/application/queryservices/MachineryQueryService.java
.../fleet/application/internal/queryservices/MachineryQueryServiceImpl.java
.../fleet/infrastructure/persistence/jpa/entities/MachineryPersistenceEntity.java
.../fleet/infrastructure/persistence/jpa/repositories/MachineryPersistenceRepository.java
.../fleet/infrastructure/persistence/jpa/adapters/MachineryRepositoryImpl.java
.../fleet/infrastructure/persistence/jpa/assemblers/MachineryPersistenceAssembler.java
.../fleet/interfaces/rest/MachineryController.java    ← solo GET
.../fleet/interfaces/rest/resources/MachineryResource.java
.../fleet/interfaces/rest/transform/MachineryResourceFromEntityAssembler.java
```

**Probar:** GET `/machinery`

---

### v0.9.0 · `feature/create-machinery` · **Int. 3**

```
.../fleet/domain/model/commands/CreateMachineryCommand.java
.../fleet/domain/model/commands/UpdateMachineryCommand.java
.../fleet/application/commandservices/MachineryCommandService.java
.../fleet/application/internal/commandservices/MachineryCommandServiceImpl.java
.../fleet/interfaces/rest/resources/CreateMachineryResource.java
.../fleet/interfaces/rest/MachineryController.java    ← GET+POST
```

**Probar:** POST `/machinery`

---

### v0.10.0 · `feature/update-machinery` · **Int. 3**

```
.../fleet/interfaces/rest/resources/UpdateMachineryResource.java
.../fleet/interfaces/rest/MachineryController.java    ← GET+POST+PUT completo
```

**Probar:** PUT `/machinery/{id}`

---

### v0.11.0 · `feature/register-iot-node` · **Int. 3**

En referencia:

```powershell
git diff feature/update-machinery..feature/register-iot-node --name-only
```

**Probar:** GET/POST `/iotNodes`

---

### v0.12.0 · `feature/create-maintenance-record` · **Int. 4**

```powershell
git diff feature/register-iot-node..feature/create-maintenance-record --name-only
```

Incluye `.../fleet/application/acl/`, `.../fleet/interfaces/acl/`, seeder fleet.

**Probar:** GET/POST `/maintenanceRecords`

---

### v0.13.0 · `feature/list-telemetry-data` · **Int. 4**

```powershell
git diff feature/create-maintenance-record..feature/list-telemetry-data --name-only
```

**Probar:** GET/POST `/telemetryData`

---

### v0.14.0 · `feature/list-alerts` · **Int. 4**

```
.../monitoring/domain/model/aggregates/FleetAlert.java
.../monitoring/domain/model/queries/GetAllFleetAlertsQuery.java
.../monitoring/domain/model/queries/GetFleetAlertByIdQuery.java
.../monitoring/domain/model/valueobjects/AlertType.java
.../monitoring/domain/model/valueobjects/AlertSeverity.java
.../monitoring/domain/repositories/FleetAlertRepository.java
.../monitoring/application/queryservices/FleetAlertQueryService.java
.../monitoring/application/internal/queryservices/FleetAlertQueryServiceImpl.java
.../monitoring/infrastructure/persistence/jpa/   (FleetAlert)
.../monitoring/interfaces/rest/AlertsController.java    ← solo GET
.../monitoring/interfaces/rest/resources/AlertResource.java
.../monitoring/interfaces/rest/transform/MonitoringResourceFromEntityAssembler.java
```

**Probar:** GET `/alerts`

---

### v0.15.0 · `feature/create-alert` · **Int. 4**

```
.../monitoring/domain/model/commands/CreateFleetAlertCommand.java
.../monitoring/domain/model/commands/AcknowledgeFleetAlertCommand.java
.../monitoring/application/commandservices/FleetAlertCommandService.java
.../monitoring/application/internal/commandservices/FleetAlertCommandServiceImpl.java
.../monitoring/application/internal/eventhandlers/MonitoringApplicationReadyEventHandler.java
.../monitoring/interfaces/rest/resources/CreateAlertResource.java
.../monitoring/interfaces/rest/AlertsController.java    ← GET+POST
```

**Probar:** POST `/alerts`

---

### v0.16.0 · `feature/acknowledge-alert` · **Int. 4**

```
.../monitoring/interfaces/rest/AlertsController.java    ← completo con acknowledge
```

**Probar:** POST `/alerts/{id}/acknowledgements`

---

### v0.17.0 · `feature/list-worksites` · **Int. 5**

```powershell
git diff feature/acknowledge-alert..feature/list-worksites --name-only
```

Dominio obras (~28 archivos). **Sin** REST en Swagger aún.

---

### v0.18.0 · `feature/create-staff-members` · **Int. 5**

```powershell
git diff feature/list-worksites..feature/create-staff-members --name-only
```

---

### v0.19.0 · `feature/assign-transport-to-worksite` · **Int. 5**

```
.../sitemanagement/domain/model/commands/AssignTransportToWorksiteCommand.java
.../sitemanagement/application/internal/outboundservices/acl/SiteManagementExternalFleetService.java
.../sitemanagement/application/internal/eventhandlers/SiteManagementApplicationReadyEventHandler.java
.../sitemanagement/interfaces/rest/WorksitesController.java
.../sitemanagement/interfaces/rest/resources/WorksiteTransportResource.java
.../sitemanagement/interfaces/rest/transform/WorksiteTransportResourceFromEntityAssembler.java
```

**Probar:** todos los endpoints `/worksites` — **release final**.

---

## 7. Merge y Release — paso a paso con roles

**Ejemplo: Integrante 3 entrega v0.8.0**

| Paso | Quién | Acción |
|------|-------|--------|
| 1 | Int. 3 | Copia archivos, prueba, push `feature/list-machinery` |
| 2 | Int. 3 | Abre PR en GitHub → base: `main` |
| 3 | Int. 1 | Revisa PR (compile, Swagger, archivos correctos) |
| 4 | Int. 1 | Click **Merge pull request** |
| 5 | Int. 1 | Terminal: `git checkout main && git pull && git tag -a v0.8.0 -m "..." && git push origin v0.8.0` |
| 6 | Int. 1 | GitHub → Releases → Publish **v0.8.0** |
| 7 | Int. 3 | Espera; luego empieza v0.9.0 desde `main` actualizado |

**Tag por terminal:**

```powershell
git tag -a v0.8.0 -m "v0.8.0 - GET /machinery"
git push origin v0.8.0
```

**Release por GitHub:** Releases → Draft new release → tag `v0.8.0` → target `main` → Publish.

**Release por CLI:** `gh release create v0.8.0 --title "v0.8.0" --notes "GET /machinery"`

---

## 8. Atajo — copiar desde repo referencia

```powershell
cd InfraTrack-Referencia
git checkout feature/sign-up

cd ..\InfraTrack-Backend-Equipo
git checkout -b feature/sign-up
git checkout ..\InfraTrack-Referencia\feature\sign-up -- src/
git add . && git commit -m "feat(iam): sign-up"
```

O listar diff exacto:

```powershell
cd InfraTrack-Referencia
git diff feature/sign-up..feature/sign-in --name-only
```

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

Swagger: `http://localhost:8080/swagger-ui.html`

---

## 10. Checklist y resumen

**Antes de cada PR:**

- [ ] Main tiene merge anterior
- [ ] Solo archivos de esta entrega
- [ ] `mvn compile` OK
- [ ] Swagger probado
- [ ] PR mergeado por Int. 1
- [ ] Tag + Release publicados

| Pregunta | Respuesta |
|----------|-----------|
| ¿Qué subo en cada rama? | Archivos de sección 6 para **esa** versión |
| ¿Merge o Release? | **Merge primero**, Release después |
| ¿Quién mergea? | **Integrante 1** |
| ¿Quién Release? | **Integrante 1** |
| ¿Funcional? | **Sí** siguiendo orden + MySQL |
| ¿Cuántas releases? | **19** (v0.1.0 … v0.19.0) |

---

## Documentos relacionados

- [`feature-release-plan.md`](feature-release-plan.md)
- [`bounded-contexts-guide.md`](bounded-contexts-guide.md)
- [`user-stories.md`](user-stories.md)
