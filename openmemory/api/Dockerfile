FROM python:3.12-slim

LABEL org.opencontainers.image.name="mem0/openmemory-mcp"

WORKDIR /usr/src/openmemory

# Install PostgreSQL client for pgvector setup
RUN apt-get update && apt-get install -y postgresql-client && rm -rf /var/lib/apt/lists/*

# Copy requirements and install dependencies
COPY openmemory/api/requirements.txt .
RUN pip install -r requirements.txt

# Copy the API code
COPY openmemory/api/ .

# Make startup script executable
RUN chmod +x startup_render.sh

EXPOSE 8765

# Use startup script if on Render, otherwise default command
CMD if [ -n "$RENDER" ]; then ./startup_render.sh; else uvicorn main:app --host 0.0.0.0 --port 8765; fi
