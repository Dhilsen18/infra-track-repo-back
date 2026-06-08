# InfraTrack Backend (`InfraTrack-web-service`)

REST API for **Digital Machine** — fleet IoT monitoring. Built with **Domain-Driven Design** (same layered structure as the course reference project).

## Bounded contexts

| Context | Package | Status |
|---------|---------|--------|
| **shared** | `...platform.shared` | Ready (errors, i18n, OpenAPI, JPA base) |
| **iam** | `...platform.iam` | **Implemented** (JWT, sign-in/sign-up, users, roles) |
| **fleet** | `...platform.fleet` | **Implemented** (machinery, IoT nodes, operators, maintenance) |
| **monitoring** | `...platform.monitoring` | **Implemented** (telemetry, alerts, ACL → fleet) |
| **site-management** | `...platform.sitemanagement` | **Implemented** (worksites, staff, transport assignments) |

See [`docs/bounded-contexts-guide.md`](docs/bounded-contexts-guide.md) for the full layer map and frontend alignment.

## Run locally

**Requirements:** JDK 21+, MySQL 8+

```bash
# Copy env template and adjust credentials
cp .env.example .env

# Start MySQL, then:
mvn spring-boot:run
```

- API base: `http://localhost:8080/api/v1`
- Swagger UI: `http://localhost:8080/swagger-ui.html`
- Public auth: `POST /api/v1/authentication/sign-in`, `POST /api/v1/authentication/sign-up`

### Example sign-up (owner)

```json
POST /api/v1/authentication/sign-up
{
  "username": "owner.demo",
  "password": "SecurePass123!",
  "roles": ["ROLE_OWNER"]
}
```

### Example sign-in (matches Angular frontend)

```json
POST /api/v1/authentication/sign-in
{
  "username": "owner.demo",
  "password": "SecurePass123!"
}
```

Response includes `token` and `role` (`owner` | `admin` | `technician`) for `InfraTrack-Frontend`.

## Documentation

- **[`docs/README-FEATURES-RELEASES.md`](docs/README-FEATURES-RELEASES.md)** — **Guía del equipo:** ramas por endpoint, releases, copia gradual al repo nuevo
- [`docs/feature-release-plan.md`](docs/feature-release-plan.md) — mapa release ↔ rama ↔ endpoints
- [`docs/bounded-contexts-guide.md`](docs/bounded-contexts-guide.md) — DDD structure guide (temporary)
- [`docs/user-stories.md`](docs/user-stories.md) — API technical stories
- [`docs/software-architecture.dsl`](docs/software-architecture.dsl) — C4 / Structurizr model

## Related repos

- **Frontend:** `../InfraTrack-Frontend` (Angular SPA — separate repository)
