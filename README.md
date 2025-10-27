# Commissioner

A modern Rails 8.1 application built with the Solid stack for performance and simplicity.

## Requirements

* Ruby 3.4.6
* SQLite 3.8.0 or higher
* Docker (optional, for deployment)

## System Dependencies

The application uses the following key technologies:

* **Rails 8.1** - Web framework
* **SQLite3** - Database (with multi-database support in production)
* **Hotwire** - Turbo and Stimulus for interactive UIs
* **Solid Queue** - Background job processing
* **Solid Cache** - Database-backed caching
* **Solid Cable** - Database-backed Action Cable
* **Propshaft** - Modern asset pipeline
* **Importmap** - JavaScript module management
* **Kamal** - Docker-based deployment

## Getting Started

### Initial Setup

Run the setup script to install dependencies, prepare the database, and start the server:

```bash
bin/setup
```

This will:
- Install Ruby gem dependencies
- Prepare the database (create and load schema)
- Clear old logs and temporary files
- Start the development server

If you want to reset the database during setup:

```bash
bin/setup --reset
```

To setup without starting the server:

```bash
bin/setup --skip-server
```

### Running the Application

Start the development server:

```bash
bin/dev
```

The application will be available at `http://localhost:3000`

### Development Console

Access the Rails console:

```bash
bin/rails console
```

## Database

### Configuration

The application uses SQLite3 with different configurations per environment:

* **Development**: Single database at `storage/development.sqlite3`
* **Test**: Single database at `storage/test.sqlite3`
* **Production**: Multi-database setup:
  * Primary: `storage/production.sqlite3`
  * Cache: `storage/production_cache.sqlite3`
  * Queue: `storage/production_queue.sqlite3`
  * Cable: `storage/production_cable.sqlite3`

### Database Commands

```bash
bin/rails db:prepare      # Create database and load schema
bin/rails db:migrate      # Run pending migrations
bin/rails db:reset        # Drop, create, load schema, and seed
bin/rails db:seed         # Load seed data
bin/rails db:seed:replant # Truncate all tables and reseed
```

## Running Tests

Run the full test suite:

```bash
bin/rails test        # Unit and integration tests
bin/rails test:system # System tests (browser-based)
```

Run a specific test file:

```bash
bin/rails test test/models/example_test.rb
```

Run a specific test:

```bash
bin/rails test test/models/example_test.rb:10
```

## Code Quality

### Style Checking

The project uses Rubocop with the Rails Omakase style guide:

```bash
bin/rubocop
```

### Security Audits

Run security checks:

```bash
bin/bundler-audit    # Check gems for known vulnerabilities
bin/brakeman         # Static security analysis
bin/importmap audit  # Check JavaScript dependencies
```

### Full CI Suite

Run all checks (style, security, tests):

```bash
bin/ci
```

This runs the complete continuous integration pipeline including:
- Dependency installation
- Style checking
- Security audits (gems, importmap, Brakeman)
- All tests (unit, integration, system)
- Seed verification

## Background Jobs

The application uses Solid Queue for background job processing.

In development and test, jobs run inline or in a separate process.

In production, Solid Queue runs within the Puma web server process (configured via `SOLID_QUEUE_IN_PUMA=true`). For applications with heavy job processing, split jobs to a dedicated server by uncommenting the job section in `config/deploy.yml`.

Manage jobs directly:

```bash
bin/jobs
```

## Deployment

The application is deployed using Kamal, which provides zero-downtime Docker-based deployments.

### Configuration

Deployment configuration is in `config/deploy.yml`. Key settings:

* **Service name**: commissioner
* **Registry**: Local registry at `localhost:5555`
* **Architecture**: amd64
* **Storage**: Persistent volume for SQLite databases at `/rails/storage`

### Deployment Commands

```bash
bin/kamal deploy      # Deploy application
bin/kamal console     # Open Rails console on production
bin/kamal shell       # Open bash shell on production
bin/kamal logs        # Tail application logs
bin/kamal dbc         # Open database console
```

### Environment Variables

Required secrets (stored in `.kamal/secrets`):
* `RAILS_MASTER_KEY` - For encrypted credentials

Optional environment variables:
* `SOLID_QUEUE_IN_PUMA` - Run jobs in web process (default: true)
* `JOB_CONCURRENCY` - Number of job processes (default: 1)
* `WEB_CONCURRENCY` - Number of web processes (default: 1)
* `DB_HOST` - External database server (if not using SQLite)
* `RAILS_LOG_LEVEL` - Logging verbosity (default: info)

## Development Workflow

1. Make your changes
2. Run tests: `bin/rails test`
3. Check style: `bin/rubocop`
4. Run security checks: `bin/brakeman` and `bin/bundler-audit`
5. Commit your changes
6. Optionally run full CI: `bin/ci`

## Project Structure

```
app/
  ├── assets/         # CSS, images, and other assets
  ├── controllers/    # Request handlers
  ├── helpers/        # View helpers
  ├── javascript/     # Stimulus controllers and JavaScript
  ├── jobs/           # Background jobs
  ├── mailers/        # Email handling
  ├── models/         # Database models
  └── views/          # Templates

config/
  ├── environments/   # Environment-specific settings
  ├── initializers/   # App initialization code
  ├── application.rb  # Main application configuration
  ├── database.yml    # Database configuration
  ├── deploy.yml      # Kamal deployment settings
  ├── routes.rb       # URL routing
  └── ci.rb           # CI pipeline definition

db/
  ├── cable_schema.rb # Action Cable schema
  ├── cache_schema.rb # Solid Cache schema
  ├── queue_schema.rb # Solid Queue schema
  └── seeds.rb        # Seed data

test/
  ├── controllers/    # Controller tests
  ├── models/         # Model tests
  ├── integration/    # Integration tests
  └── system/         # Browser-based system tests
```

## Additional Resources

* [Rails Guides](https://guides.rubyonrails.org)
* [Hotwire Documentation](https://hotwired.dev)
* [Kamal Documentation](https://kamal-deploy.org)
* [Solid Queue](https://github.com/rails/solid_queue)
