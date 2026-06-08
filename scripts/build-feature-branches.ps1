# Builds cumulative feature branches (professor style: one branch per REST capability)
param(
    [string]$SourceCommit = "main",
    [string]$Remote = "personal"
)

$ErrorActionPreference = "Stop"
Set-Location (Split-Path $PSScriptRoot -Parent)

$P = "src/main/java/com/techtitans/infratrack/platform"
$ROOT_FILES = @(
    "pom.xml", "mvnw", "mvnw.cmd", ".mvn", ".gitignore", ".gitattributes",
    ".env.example", "LICENSE.md", "README.md", "docs", "scripts"
)
$RESOURCE_FILES = @(
    "src/main/resources/application.properties",
    "src/main/resources/application-dev.properties",
    "src/main/resources/messages.properties",
    "src/main/resources/messages_es.properties"
)
$TEST_FILES = @("src/test")

function Add-PathsFromSource {
    param([string]$Commit, [string[]]$Paths)
    foreach ($path in $Paths) {
        if (Test-Path $path) { continue }
        git checkout $Commit -- $path 2>$null
        if ($LASTEXITCODE -ne 0) {
            Write-Warning "  missing in $Commit : $path"
        }
    }
}

function Apply-BranchSlices {
    param([string]$BranchName)
    $sliceRoot = Join-Path $PSScriptRoot "feature-branch-slices/$BranchName"
    if (-not (Test-Path $sliceRoot)) { return }
    Get-ChildItem $sliceRoot -Recurse -File | ForEach-Object {
        $relative = $_.FullName.Substring($sliceRoot.Length + 1)
        $dest = Join-Path (Get-Location) $relative
        $destDir = Split-Path $dest -Parent
        if (-not (Test-Path $destDir)) { New-Item -ItemType Directory -Path $destDir -Force | Out-Null }
        Copy-Item $_.FullName $dest -Force
        Write-Host "  slice -> $relative"
    }
}

function Commit-IfChanges {
    param([string]$Message)
    git add -A
    if (git diff --cached --quiet) { return $false }
    git commit -m $Message
    return $true
}

$steps = @(
    @{
        branch = "release/0.1.0-shared"
        tag    = "v0.1.0"
        slice  = $false
        paths  = @("$P/shared", "$P/InfraTrackWebServiceApplication.java")
        message = "release: shared platform (errors, i18n, OpenAPI, JPA base)"
    },
    @{
        branch = "feature/sign-up"
        tag    = "v0.2.0"
        slice  = $false
        paths  = @(
            "$P/iam/domain/model/aggregates/User.java",
            "$P/iam/domain/model/entities/Role.java",
            "$P/iam/domain/model/commands/SignUpCommand.java",
            "$P/iam/domain/model/commands/SeedRolesCommand.java",
            "$P/iam/domain/model/valueobjects/Roles.java",
            "$P/iam/domain/repositories/UserRepository.java",
            "$P/iam/domain/repositories/RoleRepository.java",
            "$P/iam/application/commandservices/UserCommandService.java",
            "$P/iam/application/commandservices/RoleCommandService.java",
            "$P/iam/application/internal/commandservices/UserCommandServiceImpl.java",
            "$P/iam/application/internal/commandservices/RoleCommandServiceImpl.java",
            "$P/iam/application/internal/eventhandlers/ApplicationReadyEventHandler.java",
            "$P/iam/application/internal/outboundservices/hashing/HashingService.java",
            "$P/iam/infrastructure/hashing/bcrypt/BCryptHashingService.java",
            "$P/iam/infrastructure/hashing/bcrypt/services/HashingServiceImpl.java",
            "$P/iam/infrastructure/persistence/jpa/adapters/RoleRepositoryImpl.java",
            "$P/iam/infrastructure/persistence/jpa/adapters/UserRepositoryImpl.java",
            "$P/iam/infrastructure/persistence/jpa/assemblers/RolePersistenceAssembler.java",
            "$P/iam/infrastructure/persistence/jpa/assemblers/UserPersistenceAssembler.java",
            "$P/iam/infrastructure/persistence/jpa/entities/RolePersistenceEntity.java",
            "$P/iam/infrastructure/persistence/jpa/entities/UserPersistenceEntity.java",
            "$P/iam/infrastructure/persistence/jpa/repositories/RolePersistenceRepository.java",
            "$P/iam/infrastructure/persistence/jpa/repositories/UserPersistenceRepository.java",
            "$P/iam/interfaces/acl/IamContextFacade.java",
            "$P/iam/interfaces/rest/SignUpController.java",
            "$P/iam/interfaces/rest/resources/SignUpResource.java",
            "$P/iam/interfaces/rest/resources/UserResource.java",
            "$P/iam/interfaces/rest/transform/SignUpCommandFromResourceAssembler.java",
            "$P/iam/interfaces/rest/transform/UserResourceFromEntityAssembler.java"
        )
        message = "feat(iam): POST /authentication/sign-up"
    },
    @{
        branch = "feature/sign-in"
        tag    = "v0.3.0"
        slice  = $false
        paths  = @(
            "$P/iam/domain/model/commands/SignInCommand.java",
            "$P/iam/application/internal/outboundservices/tokens/TokenService.java",
            "$P/iam/infrastructure/tokens/jwt/BearerTokenService.java",
            "$P/iam/infrastructure/tokens/jwt/services/TokenServiceImpl.java",
            "$P/iam/infrastructure/authorization/sfs/configuration/WebSecurityConfiguration.java",
            "$P/iam/infrastructure/authorization/sfs/model/UserDetailsImpl.java",
            "$P/iam/infrastructure/authorization/sfs/model/UsernamePasswordAuthenticationTokenBuilder.java",
            "$P/iam/infrastructure/authorization/sfs/pipeline/BearerAuthorizationRequestFilter.java",
            "$P/iam/infrastructure/authorization/sfs/pipeline/UnauthorizedRequestHandlerEntryPoint.java",
            "$P/iam/infrastructure/authorization/sfs/services/UserDetailsServiceImpl.java",
            "$P/iam/interfaces/rest/SignInController.java",
            "$P/iam/interfaces/rest/resources/AuthenticatedUserResource.java",
            "$P/iam/interfaces/rest/resources/SignInResource.java",
            "$P/iam/interfaces/rest/transform/AuthenticatedUserResourceFromEntityAssembler.java",
            "$P/iam/interfaces/rest/transform/SignInCommandFromResourceAssembler.java"
        )
        message = "feat(iam): POST /authentication/sign-in and JWT security"
    },
    @{
        branch = "feature/list-users"
        tag    = "v0.4.0"
        slice  = $false
        paths  = @(
            "$P/iam/domain/model/queries/GetAllUsersQuery.java",
            "$P/iam/domain/model/queries/GetUserByIdQuery.java",
            "$P/iam/domain/model/queries/GetUserByUsernameQuery.java",
            "$P/iam/application/queryservices/UserQueryService.java",
            "$P/iam/application/internal/queryservices/UserQueryServiceImpl.java",
            "$P/iam/interfaces/rest/UsersController.java"
        )
        message = "feat(iam): GET /users"
    },
    @{
        branch = "feature/list-roles"
        tag    = "v0.5.0"
        slice  = $false
        paths  = @(
            "$P/iam/domain/model/queries/GetAllRolesQuery.java",
            "$P/iam/domain/model/queries/GetRoleByNameQuery.java",
            "$P/iam/application/queryservices/RoleQueryService.java",
            "$P/iam/application/internal/queryservices/RoleQueryServiceImpl.java",
            "$P/iam/interfaces/rest/RolesController.java",
            "$P/iam/interfaces/rest/resources/RoleResource.java",
            "$P/iam/interfaces/rest/transform/RoleResourceFromEntityAssembler.java"
        )
        message = "feat(iam): GET /roles"
    },
    @{
        branch = "feature/create-operator"
        tag    = "v0.6.0"
        slice  = $true
        paths  = @(
            "$P/fleet/domain/model/aggregates/FleetOperator.java",
            "$P/fleet/domain/model/commands/CreateFleetOperatorCommand.java",
            "$P/fleet/domain/model/valueobjects/OperatorStatus.java",
            "$P/fleet/domain/repositories/FleetOperatorRepository.java",
            "$P/fleet/application/commandservices/FleetOperatorCommandService.java",
            "$P/fleet/application/internal/commandservices/FleetOperatorCommandServiceImpl.java",
            "$P/fleet/infrastructure/persistence/jpa/entities/FleetOperatorPersistenceEntity.java",
            "$P/fleet/infrastructure/persistence/jpa/repositories/FleetOperatorPersistenceRepository.java",
            "$P/fleet/infrastructure/persistence/jpa/adapters/FleetOperatorRepositoryImpl.java",
            "$P/fleet/infrastructure/persistence/jpa/assemblers/FleetOperatorPersistenceAssembler.java",
            "$P/fleet/interfaces/rest/resources/OperatorResource.java",
            "$P/fleet/interfaces/rest/resources/CreateOperatorResource.java",
            "$P/fleet/interfaces/rest/transform/OperatorResourceFromEntityAssembler.java"
        )
        message = "feat(fleet): POST /operators"
    },
    @{
        branch = "feature/list-operators"
        tag    = "v0.7.0"
        slice  = $true
        paths  = @(
            "$P/fleet/domain/model/queries/GetAllFleetOperatorsQuery.java",
            "$P/fleet/domain/model/queries/GetFleetOperatorByIdQuery.java",
            "$P/fleet/application/queryservices/FleetOperatorQueryService.java",
            "$P/fleet/application/internal/queryservices/FleetOperatorQueryServiceImpl.java"
        )
        message = "feat(fleet): GET /operators"
    },
    @{
        branch = "feature/list-machinery"
        tag    = "v0.8.0"
        slice  = $true
        paths  = @(
            "$P/fleet/domain/model/aggregates/Machinery.java",
            "$P/fleet/domain/model/queries/GetAllMachineryQuery.java",
            "$P/fleet/domain/model/queries/GetMachineryByIdQuery.java",
            "$P/fleet/domain/model/valueobjects/FuelType.java",
            "$P/fleet/domain/model/valueobjects/MachineryStatus.java",
            "$P/fleet/domain/repositories/MachineryRepository.java",
            "$P/fleet/application/queryservices/MachineryQueryService.java",
            "$P/fleet/application/internal/queryservices/MachineryQueryServiceImpl.java",
            "$P/fleet/infrastructure/persistence/jpa/entities/MachineryPersistenceEntity.java",
            "$P/fleet/infrastructure/persistence/jpa/repositories/MachineryPersistenceRepository.java",
            "$P/fleet/infrastructure/persistence/jpa/adapters/MachineryRepositoryImpl.java",
            "$P/fleet/infrastructure/persistence/jpa/assemblers/MachineryPersistenceAssembler.java",
            "$P/fleet/interfaces/rest/resources/MachineryResource.java",
            "$P/fleet/interfaces/rest/transform/MachineryResourceFromEntityAssembler.java"
        )
        message = "feat(fleet): GET /machinery"
    },
    @{
        branch = "feature/create-machinery"
        tag    = "v0.9.0"
        slice  = $true
        paths  = @(
            "$P/fleet/domain/model/commands/CreateMachineryCommand.java",
            "$P/fleet/domain/model/commands/UpdateMachineryCommand.java",
            "$P/fleet/application/commandservices/MachineryCommandService.java",
            "$P/fleet/application/internal/commandservices/MachineryCommandServiceImpl.java",
            "$P/fleet/interfaces/rest/resources/CreateMachineryResource.java"
        )
        message = "feat(fleet): POST /machinery"
    },
    @{
        branch = "feature/update-machinery"
        tag    = "v0.10.0"
        slice  = $true
        paths  = @(
            "$P/fleet/interfaces/rest/resources/UpdateMachineryResource.java"
        )
        message = "feat(fleet): PUT /machinery/{id}"
    },
    @{
        branch = "feature/register-iot-node"
        tag    = "v0.11.0"
        slice  = $false
        paths  = @(
            "$P/fleet/domain/model/aggregates/IotNode.java",
            "$P/fleet/domain/model/commands/CreateIotNodeCommand.java",
            "$P/fleet/domain/model/commands/LinkIotNodeToMachineryCommand.java",
            "$P/fleet/domain/model/queries/GetAllIotNodesQuery.java",
            "$P/fleet/domain/model/queries/GetIotNodeByIdQuery.java",
            "$P/fleet/domain/model/valueobjects/ConnectionStatus.java",
            "$P/fleet/domain/repositories/IotNodeRepository.java",
            "$P/fleet/application/commandservices/IotNodeCommandService.java",
            "$P/fleet/application/queryservices/IotNodeQueryService.java",
            "$P/fleet/application/internal/commandservices/IotNodeCommandServiceImpl.java",
            "$P/fleet/application/internal/queryservices/IotNodeQueryServiceImpl.java",
            "$P/fleet/infrastructure/persistence/jpa/entities/IotNodePersistenceEntity.java",
            "$P/fleet/infrastructure/persistence/jpa/repositories/IotNodePersistenceRepository.java",
            "$P/fleet/infrastructure/persistence/jpa/adapters/IotNodeRepositoryImpl.java",
            "$P/fleet/infrastructure/persistence/jpa/assemblers/IotNodePersistenceAssembler.java",
            "$P/fleet/interfaces/rest/IotNodesController.java",
            "$P/fleet/interfaces/rest/resources/IotNodeResource.java",
            "$P/fleet/interfaces/rest/resources/CreateIotNodeResource.java",
            "$P/fleet/interfaces/rest/transform/IotNodeResourceFromEntityAssembler.java"
        )
        message = "feat(fleet): GET/POST /iotNodes and link to machinery"
    },
    @{
        branch = "feature/create-maintenance-record"
        tag    = "v0.12.0"
        slice  = $false
        paths  = @(
            "$P/fleet/domain/model/aggregates/MaintenanceRecord.java",
            "$P/fleet/domain/model/commands/CreateMaintenanceRecordCommand.java",
            "$P/fleet/domain/model/queries/GetAllMaintenanceRecordsQuery.java",
            "$P/fleet/domain/model/queries/GetMaintenanceRecordByIdQuery.java",
            "$P/fleet/domain/model/valueobjects/MaintenanceServiceType.java",
            "$P/fleet/domain/repositories/MaintenanceRecordRepository.java",
            "$P/fleet/application/commandservices/MaintenanceRecordCommandService.java",
            "$P/fleet/application/queryservices/MaintenanceRecordQueryService.java",
            "$P/fleet/application/internal/commandservices/MaintenanceRecordCommandServiceImpl.java",
            "$P/fleet/application/internal/queryservices/MaintenanceRecordQueryServiceImpl.java",
            "$P/fleet/infrastructure/persistence/jpa/entities/MaintenanceRecordPersistenceEntity.java",
            "$P/fleet/infrastructure/persistence/jpa/repositories/MaintenanceRecordPersistenceRepository.java",
            "$P/fleet/infrastructure/persistence/jpa/adapters/MaintenanceRecordRepositoryImpl.java",
            "$P/fleet/infrastructure/persistence/jpa/assemblers/MaintenanceRecordPersistenceAssembler.java",
            "$P/fleet/interfaces/rest/MaintenanceRecordsController.java",
            "$P/fleet/interfaces/rest/resources/MaintenanceRecordResource.java",
            "$P/fleet/interfaces/rest/resources/CreateMaintenanceRecordResource.java",
            "$P/fleet/interfaces/rest/transform/MaintenanceRecordResourceFromEntityAssembler.java",
            "$P/fleet/application/acl",
            "$P/fleet/interfaces/acl",
            "$P/fleet/application/internal/eventhandlers/FleetApplicationReadyEventHandler.java"
        )
        message = "feat(fleet): GET/POST /maintenanceRecords and fleet ACL facade"
    },
    @{
        branch = "feature/list-telemetry-data"
        tag    = "v0.13.0"
        slice  = $false
        paths  = @(
            "$P/monitoring/domain/model/aggregates/TelemetryReading.java",
            "$P/monitoring/domain/model/commands/CreateTelemetryReadingCommand.java",
            "$P/monitoring/domain/model/queries/GetAllTelemetryReadingsQuery.java",
            "$P/monitoring/domain/model/queries/GetTelemetryReadingByIdQuery.java",
            "$P/monitoring/domain/repositories/TelemetryReadingRepository.java",
            "$P/monitoring/application/commandservices/TelemetryReadingCommandService.java",
            "$P/monitoring/application/queryservices/TelemetryReadingQueryService.java",
            "$P/monitoring/application/internal/commandservices/TelemetryReadingCommandServiceImpl.java",
            "$P/monitoring/application/internal/queryservices/TelemetryReadingQueryServiceImpl.java",
            "$P/monitoring/application/internal/outboundservices",
            "$P/monitoring/infrastructure/persistence/jpa/entities/TelemetryReadingPersistenceEntity.java",
            "$P/monitoring/infrastructure/persistence/jpa/repositories/TelemetryReadingPersistenceRepository.java",
            "$P/monitoring/infrastructure/persistence/jpa/adapters/TelemetryReadingRepositoryImpl.java",
            "$P/monitoring/infrastructure/persistence/jpa/assemblers/TelemetryReadingPersistenceAssembler.java",
            "$P/monitoring/interfaces/rest/TelemetryDataController.java",
            "$P/monitoring/interfaces/rest/resources/TelemetryDataResource.java",
            "$P/monitoring/interfaces/rest/resources/CreateTelemetryDataResource.java",
            "$P/monitoring/interfaces/rest/transform/MonitoringResourceFromEntityAssembler.java"
        )
        message = "feat(monitoring): GET/POST /telemetryData"
    },
    @{
        branch = "feature/list-alerts"
        tag    = "v0.14.0"
        slice  = $true
        paths  = @(
            "$P/monitoring/domain/model/aggregates/FleetAlert.java",
            "$P/monitoring/domain/model/queries/GetAllFleetAlertsQuery.java",
            "$P/monitoring/domain/model/queries/GetFleetAlertByIdQuery.java",
            "$P/monitoring/domain/model/valueobjects/AlertSeverity.java",
            "$P/monitoring/domain/model/valueobjects/AlertType.java",
            "$P/monitoring/domain/repositories/FleetAlertRepository.java",
            "$P/monitoring/application/queryservices/FleetAlertQueryService.java",
            "$P/monitoring/application/internal/queryservices/FleetAlertQueryServiceImpl.java",
            "$P/monitoring/infrastructure/persistence/jpa/entities/FleetAlertPersistenceEntity.java",
            "$P/monitoring/infrastructure/persistence/jpa/repositories/FleetAlertPersistenceRepository.java",
            "$P/monitoring/infrastructure/persistence/jpa/adapters/FleetAlertRepositoryImpl.java",
            "$P/monitoring/infrastructure/persistence/jpa/assemblers/FleetAlertPersistenceAssembler.java",
            "$P/monitoring/interfaces/rest/resources/AlertResource.java",
            "$P/monitoring/interfaces/rest/transform/MonitoringResourceFromEntityAssembler.java"
        )
        message = "feat(monitoring): GET /alerts"
    },
    @{
        branch = "feature/create-alert"
        tag    = "v0.15.0"
        slice  = $true
        paths  = @(
            "$P/monitoring/domain/model/commands/CreateFleetAlertCommand.java",
            "$P/monitoring/domain/model/commands/AcknowledgeFleetAlertCommand.java",
            "$P/monitoring/application/commandservices/FleetAlertCommandService.java",
            "$P/monitoring/application/internal/commandservices/FleetAlertCommandServiceImpl.java",
            "$P/monitoring/interfaces/rest/resources/CreateAlertResource.java",
            "$P/monitoring/application/internal/eventhandlers/MonitoringApplicationReadyEventHandler.java"
        )
        message = "feat(monitoring): POST /alerts"
    },
    @{
        branch = "feature/acknowledge-alert"
        tag    = "v0.16.0"
        slice  = $true
        paths  = @()
        message = "feat(monitoring): POST /alerts/{id}/acknowledgements"
    },
    @{
        branch = "feature/list-worksites"
        tag    = "v0.17.0"
        slice  = $false
        paths  = @(
            "$P/sitemanagement/domain/model/aggregates/Worksite.java",
            "$P/sitemanagement/domain/model/aggregates/WorksiteTransportAssignment.java",
            "$P/sitemanagement/domain/model/commands/CreateWorksiteCommand.java",
            "$P/sitemanagement/domain/model/queries/GetAllWorksitesQuery.java",
            "$P/sitemanagement/domain/model/queries/GetWorksiteByIdQuery.java",
            "$P/sitemanagement/domain/model/queries/GetTransportsForWorksiteQuery.java",
            "$P/sitemanagement/domain/model/valueobjects/WorksiteType.java",
            "$P/sitemanagement/domain/model/valueobjects/WorksiteStatus.java",
            "$P/sitemanagement/domain/repositories/WorksiteRepository.java",
            "$P/sitemanagement/domain/repositories/WorksiteStaffAssignmentRepository.java",
            "$P/sitemanagement/domain/repositories/WorksiteTransportAssignmentRepository.java",
            "$P/sitemanagement/application/commandservices/WorksiteCommandService.java",
            "$P/sitemanagement/application/queryservices/WorksiteQueryService.java",
            "$P/sitemanagement/application/internal/commandservices/WorksiteCommandServiceImpl.java",
            "$P/sitemanagement/application/internal/queryservices/WorksiteQueryServiceImpl.java",
            "$P/sitemanagement/infrastructure/persistence/jpa/entities/WorksitePersistenceEntity.java",
            "$P/sitemanagement/infrastructure/persistence/jpa/entities/WorksiteStaffAssignmentPersistenceEntity.java",
            "$P/sitemanagement/infrastructure/persistence/jpa/entities/WorksiteTransportAssignmentPersistenceEntity.java",
            "$P/sitemanagement/infrastructure/persistence/jpa/repositories/WorksitePersistenceRepository.java",
            "$P/sitemanagement/infrastructure/persistence/jpa/repositories/WorksiteStaffAssignmentPersistenceRepository.java",
            "$P/sitemanagement/infrastructure/persistence/jpa/repositories/WorksiteTransportAssignmentPersistenceRepository.java",
            "$P/sitemanagement/infrastructure/persistence/jpa/adapters/WorksiteRepositoryImpl.java",
            "$P/sitemanagement/infrastructure/persistence/jpa/adapters/WorksiteStaffAssignmentRepositoryImpl.java",
            "$P/sitemanagement/infrastructure/persistence/jpa/adapters/WorksiteTransportAssignmentRepositoryImpl.java",
            "$P/sitemanagement/infrastructure/persistence/jpa/assemblers/WorksitePersistenceAssembler.java",
            "$P/sitemanagement/infrastructure/persistence/jpa/assemblers/WorksiteTransportAssignmentPersistenceAssembler.java",
            "$P/sitemanagement/interfaces/rest/resources/WorksiteResource.java",
            "$P/sitemanagement/interfaces/rest/resources/CreateWorksiteResource.java",
            "$P/sitemanagement/interfaces/rest/transform/WorksiteResourceFromEntityAssembler.java"
        )
        message = "feat(site): worksites domain and persistence"
    },
    @{
        branch = "feature/create-staff-members"
        tag    = "v0.18.0"
        slice  = $false
        paths  = @(
            "$P/sitemanagement/domain/model/aggregates/WorksiteStaff.java",
            "$P/sitemanagement/domain/model/commands/CreateWorksiteStaffCommand.java",
            "$P/sitemanagement/domain/model/commands/AssignStaffToWorksiteCommand.java",
            "$P/sitemanagement/domain/model/queries/GetAllWorksiteStaffQuery.java",
            "$P/sitemanagement/domain/model/queries/GetStaffForWorksiteQuery.java",
            "$P/sitemanagement/domain/model/valueobjects/StaffStatus.java",
            "$P/sitemanagement/domain/repositories/WorksiteStaffRepository.java",
            "$P/sitemanagement/application/commandservices/WorksiteStaffCommandService.java",
            "$P/sitemanagement/application/queryservices/WorksiteStaffQueryService.java",
            "$P/sitemanagement/application/internal/commandservices/WorksiteStaffCommandServiceImpl.java",
            "$P/sitemanagement/application/internal/queryservices/WorksiteStaffQueryServiceImpl.java",
            "$P/sitemanagement/infrastructure/persistence/jpa/entities/WorksiteStaffPersistenceEntity.java",
            "$P/sitemanagement/infrastructure/persistence/jpa/repositories/WorksiteStaffPersistenceRepository.java",
            "$P/sitemanagement/infrastructure/persistence/jpa/adapters/WorksiteStaffRepositoryImpl.java",
            "$P/sitemanagement/infrastructure/persistence/jpa/assemblers/WorksiteStaffPersistenceAssembler.java",
            "$P/sitemanagement/interfaces/rest/resources/WorksiteStaffResource.java",
            "$P/sitemanagement/interfaces/rest/resources/CreateWorksiteStaffResource.java",
            "$P/sitemanagement/interfaces/rest/transform/WorksiteStaffResourceFromEntityAssembler.java"
        )
        message = "feat(site): staff domain and persistence"
    },
    @{
        branch = "feature/assign-transport-to-worksite"
        tag    = "v0.19.0"
        slice  = $false
        paths  = @(
            "$P/sitemanagement/domain/model/commands/AssignTransportToWorksiteCommand.java",
            "$P/sitemanagement/application/internal/outboundservices",
            "$P/sitemanagement/application/internal/eventhandlers/SiteManagementApplicationReadyEventHandler.java",
            "$P/sitemanagement/interfaces/rest/WorksitesController.java",
            "$P/sitemanagement/interfaces/rest/resources/WorksiteTransportResource.java",
            "$P/sitemanagement/interfaces/rest/transform/WorksiteTransportResourceFromEntityAssembler.java"
        )
        message = "feat(site): assign/list transports and Worksites REST"
    }
)

Write-Host "Saving current branch..."
$startBranch = git rev-parse --abbrev-ref HEAD

Write-Host "Creating integration base from $SourceCommit..."
git branch -D integration/features 2>$null | Out-Null
git checkout --orphan integration/features
git rm -rf . 2>$null | Out-Null

git checkout $SourceCommit -- $ROOT_FILES $RESOURCE_FILES $TEST_FILES
Add-PathsFromSource $SourceCommit @("$P/shared", "$P/InfraTrackWebServiceApplication.java")
git add -A
git commit -m "chore: integration branch bootstrap"

$parent = "integration/features"
foreach ($step in $steps) {
    Write-Host "Building $($step.branch) [$($step.tag)]..."
    git checkout -B $step.branch $parent
    Add-PathsFromSource $SourceCommit $step.paths
    if ($step.slice) { Apply-BranchSlices $step.branch }
    $committed = Commit-IfChanges $step.message
    if (-not $committed) {
        Write-Host "  (no new files)"
        git commit --allow-empty -m "$($step.message) [release $($step.tag)]"
    }
    git tag -a $step.tag -m "$($step.branch) -> $($step.tag)" -f
    $parent = $step.branch
}

git checkout -B main $parent

# Ensure main has full controllers from source (feature branches use incremental slices)
$mainSync = @(
    "$P/fleet/interfaces/rest/OperatorsController.java",
    "$P/fleet/interfaces/rest/MachineryController.java",
    "$P/monitoring/interfaces/rest/AlertsController.java",
    "$P/sitemanagement/interfaces/rest/WorksitesController.java"
)
foreach ($path in $mainSync) {
    git checkout $SourceCommit -- $path 2>$null
}
git add -A
git commit -m "chore: main integrates all features with full REST controllers" 2>$null
if ($LASTEXITCODE -ne 0) {
    git commit --allow-empty -m "chore: main integrates all features" 2>$null
}

Write-Host "Pushing branches and tags to $Remote..."
git push $Remote --all --force
git push $Remote --tags --force

git checkout $startBranch 2>$null

Write-Host "Done. Feature branches:"
git branch | Select-String "feature|release"
