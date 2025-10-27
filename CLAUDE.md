# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Commissioner is a Rails 8.1 application using Ruby 3.4.6. The application follows standard Rails conventions with a modern setup including Hotwire (Turbo & Stimulus), Solid Queue for background jobs, Solid Cache for caching, and Solid Cable for Action Cable.

## Core Technologies

- **Ruby**: 3.4.6
- **Rails**: 8.1.0
- **Database**: SQLite3 (with separate databases for production: primary, cache, queue, cable)
- **Background Jobs**: Solid Queue (runs in Puma process via `SOLID_QUEUE_IN_PUMA=true`)
- **Frontend**: Hotwire (Turbo, Stimulus), Importmap for JavaScript
- **Asset Pipeline**: Propshaft
- **Deployment**: Kamal (Docker-based deployment)

## Development Commands

### Setup and Installation
```bash
bin/setup                    # Initial setup: install dependencies, prepare database, start server
bin/setup --reset           # Setup with database reset
bin/setup --skip-server     # Setup without starting server
```

### Running the Application
```bash
bin/dev                     # Start development server (uses bin/rails server)
bin/rails server           # Direct server start
bin/rails console          # Start Rails console
```

### Testing
```bash
bin/rails test             # Run unit/integration tests
bin/rails test:system      # Run system tests (Capybara/Selenium)
bin/ci                     # Run full CI suite (see CI Process below)
```

To run a single test file:
```bash
bin/rails test test/path/to/test_file.rb
```

To run a specific test:
```bash
bin/rails test test/path/to/test_file.rb:LINE_NUMBER
```

### Code Quality and Security
```bash
bin/rubocop                # Ruby style linter (Omakase Rails style)
bin/brakeman               # Security vulnerability scanner
bin/bundler-audit          # Gem security audit
bin/importmap audit        # Importmap vulnerability audit
```

### Database
```bash
bin/rails db:prepare       # Create database and load schema
bin/rails db:migrate       # Run pending migrations
bin/rails db:reset         # Drop, create, load schema, seed
bin/rails db:seed          # Load seed data
bin/rails db:seed:replant  # Truncate all tables and reseed
```

### Background Jobs
```bash
bin/jobs                   # Manage Solid Queue jobs
```

### Deployment (Kamal)
```bash
bin/kamal console          # Remote Rails console
bin/kamal shell            # Remote bash shell
bin/kamal logs             # Tail application logs
bin/kamal dbc              # Remote database console
```

## CI Process

The CI pipeline (`bin/ci`) runs these steps in order:
1. **Setup**: `bin/setup --skip-server`
2. **Style**: Ruby linting with Rubocop
3. **Security**: Bundler audit, Importmap audit, Brakeman analysis
4. **Tests**: Unit tests, system tests
5. **Seed Verification**: Test environment database seeding

All CI steps must pass for the build to succeed.

## Application Structure

### Module Name
The Rails application module is `Commissioner` (see [config/application.rb](config/application.rb:9)).

### Database Configuration
- **Development/Test**: Single SQLite database
- **Production**: Multi-database setup with separate databases for:
  - Primary application data
  - Cache (Solid Cache)
  - Queue (Solid Queue)
  - Cable (Solid Cable/Action Cable)

All production databases are stored in the `storage/` directory, which is mounted as a persistent Docker volume in production.

### Background Jobs
Solid Queue is configured to run within the Puma web server process in production (`SOLID_QUEUE_IN_PUMA=true`). For scaling, jobs should be split to a dedicated server by modifying [config/deploy.yml](config/deploy.yml).

### Deployment
The application is containerized and deployed using Kamal. Configuration is in [config/deploy.yml](config/deploy.yml). The deployment uses:
- Docker images built for amd64 architecture
- Local Docker registry at `localhost:5555`
- Persistent volumes for SQLite databases and Active Storage
- Asset bridging between deployments to avoid 404s on in-flight requests

## Code Style

The project uses **Rubocop Rails Omakase** styling. The configuration inherits from `rubocop-rails-omakase` gem with minimal overrides in [.rubocop.yml](.rubocop.yml).

## Key Configuration Files

- [config/application.rb](config/application.rb) - Main application configuration
- [config/database.yml](config/database.yml) - Database configuration
- [config/routes.rb](config/routes.rb) - Application routes
- [config/deploy.yml](config/deploy.yml) - Kamal deployment configuration
- [config/ci.rb](config/ci.rb) - CI pipeline steps
- [config/puma.rb](config/puma.rb) - Puma web server configuration
- [config/recurring.yml](config/recurring.yml) - Recurring job configuration (Solid Queue)
