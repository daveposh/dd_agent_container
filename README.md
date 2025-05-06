# Datadog Agent Container

This repository contains a Docker configuration for running the Datadog agent in a containerized environment. It's designed to collect metrics, logs, and traces from your containerized applications.

## Features

- Container monitoring and metrics collection
- Log collection from syslog (both internal and external sources)
- DogStatsD support for custom metrics
- Trace agent for APM
- Python support for custom integrations

## Prerequisites

- Docker installed on your host machine
- A valid Datadog API key
- Access to the Datadog platform
- (Optional) External syslog file to monitor

## Configuration

Before building the container, you need to:

1. Replace the placeholder API key in the Dockerfile:
   ```dockerfile
   ENV DD_API_KEY=your_api_key_here
   ```

2. Optionally modify the Datadog site if you're not using the default:
   ```dockerfile
   ENV DD_SITE=datadoghq.com
   ```

## Building and Running

### Using Docker Compose (Recommended)

1. Create a `.env` file with your Datadog API key:
   ```bash
   echo "DD_API_KEY=your_api_key_here" > .env
   ```

2. Start the container:
   ```bash
   docker-compose up -d
   ```

The `docker-compose.yml` file includes:
- All necessary volume mounts
- Environment variables configuration
- Port mappings for DogStatsD and APM
- Health checks
- Automatic restart policy

### Using Docker Directly

#### Basic Setup
```bash
docker run -d \
  --name datadog-agent \
  -v /var/run/docker.sock:/var/run/docker.sock:ro \
  -v /proc/:/host/proc/:ro \
  -v /sys/fs/cgroup/:/host/sys/fs/cgroup:ro \
  -e DD_API_KEY=your_api_key_here \
  -e DD_SITE=datadoghq.com \
  datadog-agent
```

#### With External Syslog File
To monitor an external syslog file, you'll need to:

1. Create a directory for your syslog file on the host:
   ```bash
   mkdir -p /path/to/your/syslog/directory
   ```

2. Run the container with the additional volume mount:
   ```bash
   docker run -d \
     --name datadog-agent \
     -v /var/run/docker.sock:/var/run/docker.sock:ro \
     -v /proc/:/host/proc/:ro \
     -v /sys/fs/cgroup/:/host/sys/fs/cgroup:ro \
     -v /path/to/your/syslog/directory:/var/log/syslog:ro \
     -e DD_API_KEY=your_api_key_here \
     -e DD_SITE=datadoghq.com \
     datadog-agent
   ```

3. Ensure your syslog file has the correct permissions:
   ```bash
   chmod 644 /path/to/your/syslog/directory/syslog.log
   ```

The container will automatically monitor the syslog file at `/var/log/syslog/syslog.log` inside the container, which maps to your external file.

## Configuration Files

- `datadog.yaml`: Main Datadog agent configuration
- `conf.d/syslog.d/conf.yaml`: Syslog collection configuration
- `docker-compose.yml`: Docker Compose configuration with all necessary settings

## Ports

- `8125/udp`: DogStatsD for custom metrics
- `8126/tcp`: Trace agent for APM

## Security Considerations

- Never commit your actual API key to the repository
- Use environment variables or secrets management for sensitive data
- The container runs with read-only access to host system files
- When mounting external syslog files, use read-only mounts (`:ro`) for security

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request 