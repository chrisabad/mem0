#!/bin/bash
set -e

echo "Starting OpenMemory MCP on Render..."

# Try to enable pgvector extension using DATABASE_URL directly
if [ -n "$DATABASE_URL" ] && [ "$VECTOR_STORE_PROVIDER" = "pgvector" ]; then
    echo "Attempting to enable pgvector extension..."
    psql "$DATABASE_URL" -c "CREATE EXTENSION IF NOT EXISTS vector;" || true
    echo "pgvector setup complete"
fi

# Start the application
echo "Starting uvicorn..."
exec uvicorn main:app --host 0.0.0.0 --port ${PORT:-8765} --workers 4 