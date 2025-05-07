# Datadog Agent Container

This repository contains a Docker configuration for running the Datadog agent in a containerized environment. It's designed to collect metrics, logs, and traces from your containerized applications.

## Features

- Container monitoring and metrics collection
- Log collection from syslog (both internal and external sources)
- DogStatsD support for custom metrics
- Trace agent for APM
- Python support for custom integrations

## Prerequisites

- Docker or Podman installed on your host machine
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

### Using Docker Compose (Recommended for Docker)

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

### Using Podman

#### Building with Podman

1. Create a `.env` file with your Datadog API key:
   ```bash
   echo "DD_API_KEY=your_api_key_here" > .env
   ```

2. Build the container:
   ```bash
   # Build the image with explicit base image
   podman build --build-arg BASE_IMAGE=docker.io/datadog/agent:latest -t datadog-agent .
   ```

If you encounter pull errors, try:
```bash
# Pull the base image explicitly first
podman pull docker.io/datadog/agent:latest

# Then build with the base image
podman build --build-arg BASE_IMAGE=docker.io/datadog/agent:latest -t datadog-agent .
```

#### Running with Podman

1. Create a Podman container:
   ```bash
   podman run -d \
     --name datadog-agent \
     --security-opt label=disable \
     -v /var/run/docker.sock:/var/run/docker.sock:ro \
     -v /proc/:/host/proc/:ro \
     -v /sys/fs/cgroup/:/host/sys/fs/cgroup:ro \
     -v /var/log/syslog:/var/log/syslog:ro \
     -e DD_API_KEY=your_api_key_here \
     -e DD_SITE=datadoghq.com \
     -e DD_LOGS_ENABLED=true \
     -e DD_LOGS_CONFIG_CONTAINER_COLLECT_ALL=true \
     -e DD_PROCESS_AGENT_ENABLED=true \
     -e DD_APM_ENABLED=true \
     -e DD_DOGSTATSD_NON_LOCAL_TRAFFIC=true \
     -p 8125:8125/udp \
     -p 8126:8126/tcp \
     --restart unless-stopped \
     datadog-agent
   ```

2. To run with Podman Compose:
   ```bash
   # First pull the base image
   podman pull docker.io/datadog/agent:latest
   
   # Then build with explicit base image
   podman build --build-arg BASE_IMAGE=docker.io/datadog/agent:latest -t datadog-agent .
   
   # Finally run with podman-compose
   podman-compose up -d
   ```

Note: When using Podman:
- The `--security-opt label=disable` flag is needed to allow mounting system directories
- Podman uses the same commands as Docker, so most Docker commands work with Podman
- Podman runs containers rootless by default, which is more secure
- If you need to run as root, use `sudo podman` instead of `podman`
- If you encounter permission issues, you might need to run:
  ```bash
  # Allow non-root users to use the Docker socket
  sudo chmod 666 /var/run/docker.sock
  ```
- If you encounter build issues, try:
  ```bash
  # Clean up any failed builds
  podman system prune -f
  
  # Rebuild with more verbose output
  podman build --log-level=debug --build-arg BASE_IMAGE=docker.io/datadog/agent:latest -t datadog-agent .
  ```
- If you encounter registry access issues, try:
  ```bash
  # Login to Docker Hub (if needed)
  podman login docker.io
  
  # Pull the base image explicitly
  podman pull docker.io/datadog/agent:latest
  ```

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
- When using Podman, consider running rootless for better security

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request 