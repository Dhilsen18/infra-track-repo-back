# InfraTrack — Feature branches & releases (professor style)

One branch per **REST capability** (`feature/sign-up`, `feature/create-operator`), like enrollment in the course reference.

Each branch is **cumulative** (shared + prior features + its slice).

## Semantic Versioning y tags

| Concepto | Qué es |
|----------|--------|
| **Rama `feature/*`** | Una capacidad REST nueva (trabajo del sprint) |
| **Tag `v0.x.0`** | **Snapshot agrupado** en `main` después del merge — incluye **todas** las features acumuladas hasta ese punto |
| **GitHub Release** | Publicación formal de ese tag (terminal + interfaz web) |

Flujo:

```
feature/sign-up  ──PR merge──►  main  ──tag──►  v0.2.0  ──Release──►  GitHub
feature/sign-in  ──PR merge──►  main  ──tag──►  v0.3.0  ──Release──►  GitHub
...
```

Cada tag **agrupa** lo que ya está integrado en `main`. No es solo el diff de la última rama: `v0.7.0` = shared + IAM + operators + machinery list, etc.

**PATCH** (`v0.7.1`): solo bugfix, sin feature nueva.

## Release map (19 features)

| Release | Branch | Endpoint(s) |
|---------|--------|-------------|
| **v0.1.0** | `release/0.1.0-shared` | Shared platform |
| **v0.2.0** | `feature/sign-up` | `POST /authentication/sign-up` |
| **v0.3.0** | `feature/sign-in` | `POST /authentication/sign-in` |
| **v0.4.0** | `feature/list-users` | `GET /users` |
| **v0.5.0** | `feature/list-roles` | `GET /roles` |
| **v0.6.0** | `feature/create-operator` | `POST /operators` |
| **v0.7.0** | `feature/list-operators` | `GET /operators` |
| **v0.8.0** | `feature/list-machinery` | `GET /machinery` |
| **v0.9.0** | `feature/create-machinery` | `POST /machinery` |
| **v0.10.0** | `feature/update-machinery` | `PUT /machinery/{id}` |
| **v0.11.0** | `feature/register-iot-node` | `GET/POST /iotNodes` |
| **v0.12.0** | `feature/create-maintenance-record` | `GET/POST /maintenanceRecords` |
| **v0.13.0** | `feature/list-telemetry-data` | `GET/POST /telemetryData` |
| **v0.14.0** | `feature/list-alerts` | `GET /alerts` |
| **v0.15.0** | `feature/create-alert` | `POST /alerts` |
| **v0.16.0** | `feature/acknowledge-alert` | `POST /alerts/{id}/acknowledgements` |
| **v0.17.0** | `feature/list-worksites` | Worksites domain |
| **v0.18.0** | `feature/create-staff-members` | Staff domain |
| **v0.19.0** | `feature/assign-transport-to-worksite` | REST `/worksites` completo |

`main` = integración final (= v0.19.0).

## Rebuild all branches

```powershell
.\scripts\build-feature-branches.ps1
```

Ver [`README-FEATURES-RELEASES.md`](README-FEATURES-RELEASES.md) para guía del equipo.
