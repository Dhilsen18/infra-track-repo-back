# InfraTrack Platform — REST API Technical Stories

## Overview

API-focused stories for frontend integration. Same conventions as the professor's Learning Center Platform.

- Base path: `/api/v1`
- Content-Type: `application/json`
- Protected endpoints: `Authorization: Bearer <token>`
- Public: `/api/v1/authentication/sign-in`, `/api/v1/authentication/sign-up`

---

## Architecture stories (shared)

### TS-ARCH001 — JWT Bearer authentication
Same acceptance criteria as Learning Center TS-ARCH001.

### TS-ARCH002 — Standard error schema
`code`, `message`, optional `details`.

### TS-ARCH003 — Localized errors (`en`, `es`)

---

## IAM (implemented)

### TS-IAM001 — Sign-up
`POST /api/v1/authentication/sign-up`

Body: `username`, `password`, `roles` (`ROLE_OWNER` | `ROLE_ADMIN` | `ROLE_TECHNICIAN`)

Response `201`: `id`, `username`, `roles`

### TS-IAM002 — Sign-in
`POST /api/v1/authentication/sign-in`

Body: `username`, `password`

Response `200`: `id`, `username`, `token`, `role` (`owner` | `admin` | `technician` for Angular)

### TS-U001 — Users
- `GET /api/v1/users`
- `GET /api/v1/users/{userId}`

### TS-U002 — Roles
- `GET /api/v1/roles`

---

## Fleet (implemented)

| Story | Method | Path | Status |
|-------|--------|------|--------|
| TS-F001 List machinery | GET | `/machinery` | Done |
| TS-F002 Create machinery | POST | `/machinery` | Done |
| TS-F003 Update machinery (operator/status) | PUT | `/machinery/{id}` | Done |
| TS-F004 List IoT nodes | GET | `/iotNodes` | Done |
| TS-F005 Register IoT node | POST | `/iotNodes` | Done |
| TS-F006 Link node to machinery | PUT | `/iotNodes/{id}/machinery/{machineryId}` | Done |
| TS-F007 List operators | GET | `/operators` | Done |
| TS-F008 Create operator | POST | `/operators` | Done |
| TS-F009 Maintenance records | GET/POST | `/maintenanceRecords` | Done |

Domain aggregates: `Machinery`, `IotNode`, `FleetOperator`, `MaintenanceRecord`.

---

## Monitoring (implemented)

| Story | Method | Path | Status |
|-------|--------|------|--------|
| TS-M001 List telemetry | GET | `/telemetryData` | Done |
| TS-M002 Ingest telemetry | POST | `/telemetryData` | Done |
| TS-M003 List alerts | GET | `/alerts` | Done |
| TS-M004 Create alert | POST | `/alerts` | Done |
| TS-M005 Acknowledge alert | POST | `/alerts/{id}/acknowledgements` | Done |

Domain aggregates: `TelemetryReading`, `FleetAlert`. Uses `ExternalFleetService` → `FleetContextFacade` (ACL).

---

## Site Management (implemented)

| Story | Method | Path | Status |
|-------|--------|------|--------|
| TS-S001 List worksites | GET | `/worksites` | Done |
| TS-S002 Create worksite | POST | `/worksites` | Done |
| TS-S003 Assign transport | PUT | `/worksites/{id}/transports/{transportId}` | Done |
| TS-S004 Worksite detail | GET | `/worksites/{id}` | Done |
| TS-S005 Transports on site | GET | `/worksites/{id}/transports` | Done |
| TS-S006 Staff directory | GET | `/worksites/staff` | Done |
| TS-S007 Staff on site | GET | `/worksites/{id}/staff` | Done |
| TS-S008 Assign staff | PUT | `/worksites/{id}/staff/{staffId}` | Done |

Domain aggregates: `Worksite`, `WorksiteStaff`, `WorksiteTransportAssignment`. ACL → `FleetContextFacade` for machinery/IoT data.

---

## Subscriptions (future — shared/plan limits)

`GET /api/v1/subscriptions` — aligns with frontend plan guard (`/subscription-plans`).
