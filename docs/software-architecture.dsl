workspace "InfraTrack Digital Machine Solution - C4 Model" "Software architecture for fleet IoT monitoring." {

    model {
        owner = person "Fleet Owner (MYPE)" "Monitors worksites, fuel and fleet KPIs."
        admin = person "Logistics Administrator" "Manages IoT nodes, transports and drivers."
        technician = person "Field Technician" "Calibrates sensors and maintains hardware."

        gpsProvider = softwareSystem "GPS / Maps Provider" "External map tiles and geocoding." {
            tags "External System"
        }

        emailProvider = softwareSystem "Email Provider" "Sends alert notifications." {
            tags "External System"
        }

        solution = softwareSystem "InfraTrack Digital Machine" "Open-source fleet monitoring platform." {

            webApp = container "InfraTrack Web Application" "Serves the Angular SPA." "Static assets" {
                tags "Directory"
            }

            singlePageApp = container "InfraTrack Single-Page Application" "Owner and admin UX for fleet monitoring." "Angular 21" {
                tags "Web Browser"
            }

            infraTrackApi = container "InfraTrack REST API" "DDD modules: IAM, Fleet, Monitoring, Site Management." "Java 26, Spring Boot 4" {
                tags "Server-side Application"
                iamModule = component "IAM Module" "Authentication, users and roles." "Spring module"
                fleetModule = component "Fleet Module" "IoT nodes, transports, operators, maintenance." "Spring module"
                monitoringModule = component "Monitoring Module" "Telemetry ingestion, alerts, dashboards." "Spring module"
                siteModule = component "Site Management Module" "Worksites and resource assignment." "Spring module"
                sharedModule = component "Shared Module" "Errors, i18n, OpenAPI, base abstractions." "Spring module"
            }

            database = container "InfraTrack Database" "Relational store for all bounded contexts." "MySQL Server" {
                tags "Database"
            }
        }

        owner -> webApp "Uses" "HTTPS"
        admin -> webApp "Uses" "HTTPS"
        technician -> webApp "Uses" "HTTPS"
        webApp -> singlePageApp "Delivers SPA" "HTTPS"

        singlePageApp -> infraTrackApi "CRUD + telemetry" "JSON/HTTPS"
        infraTrackApi -> database "Reads and writes" "JDBC"
        infraTrackApi -> gpsProvider "Map data" "HTTPS"
        infraTrackApi -> emailProvider "Alert emails" "HTTPS"

        iamModule -> sharedModule "Uses"
        fleetModule -> sharedModule "Uses"
        monitoringModule -> sharedModule "Uses"
        siteModule -> sharedModule "Uses"
        monitoringModule -> fleetModule "Reads fleet identifiers via ACL"
        siteModule -> fleetModule "Assigns transports via ACL"
        monitoringModule -> siteModule "Filters by worksite via ACL"
        fleetModule -> iamModule "Resolves owner scope via ACL"

        singlePageApp -> iamModule "Sign-in / sign-up" "JSON/HTTPS"
        singlePageApp -> fleetModule "Fleet management" "JSON/HTTPS"
        singlePageApp -> monitoringModule "Dashboards and alerts" "JSON/HTTPS"
        singlePageApp -> siteModule "Worksites" "JSON/HTTPS"
    }

    views {
        systemContext solution "SystemContext" "InfraTrack actors and external systems." {
            include *
            autoLayout lr
        }

        container solution "ContainerView" "Web client, API and database." {
            include *
            autoLayout lr
        }

        component infraTrackApi "ApiComponents" "Bounded context modules inside the REST API." {
            include *
            autoLayout lr
        }

        styles {
            element "Person" { shape Person }
            element "External System" { background "#999999" color "#ffffff" }
            element "Database" { shape Cylinder }
            element "Server-side Application" { shape Shell }
            element "Web Browser" { shape WebBrowser }
        }

        theme default
    }
}
