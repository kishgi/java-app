# Use official OpenJDK 17 base image
FROM openjdk:17-jdk-slim

# Install Maven, Git, curl, and Docker CLI dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    maven \
    git \
    curl \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# Install Docker CLI (only the client, no daemon)
RUN DOCKER_VERSION="24.0.5" && \
    curl -fsSL https://download.docker.com/linux/static/stable/x86_64/docker-${DOCKER_VERSION}.tgz | tar -xz -C /usr/local/bin --strip-components=1 docker/docker && \
    chmod +x /usr/local/bin/docker

# Set working directory (optional)
WORKDIR /workspace

# Use root user to avoid permission issues with mounted docker.sock
USER root

# Set MAVEN_OPTS to avoid warnings (optional)
ENV MAVEN_OPTS="-Dmaven.repo.local=/root/.m2/repository"

# Default command (override in Jenkinsfile)
CMD ["bash"]
