#!/bin/bash
set -e

echo "Starting OpenMemory MCP on Render..."

# Parse DATABASE_URL to extract components for pgvector extension setup
if [ -n "$DATABASE_URL" ] && [ "$VECTOR_STORE_PROVIDER" = "pgvector" ]; then
    # Extract components using regex
    export DB_USER=$(echo $DATABASE_URL | sed -n 's/.*:\/\/\([^:]*\):.*/\1/p')
    export DB_PASSWORD=$(echo $DATABASE_URL | sed -n 's/.*:\/\/[^:]*:\([^@]*\)@.*/\1/p')
    export DB_HOST=$(echo $DATABASE_URL | sed -n 's/.*@\([^:]*\):.*/\1/p')
    export DB_PORT=$(echo $DATABASE_URL | sed -n 's/.*:\([0-9]*\)\/.*/\1/p')
    export DB_NAME=$(echo $DATABASE_URL | sed -n 's/.*\/\([^?]*\).*/\1/p')
    
    echo "Attempting to enable pgvector extension..."
    PGPASSWORD=$DB_PASSWORD psql -h $DB_HOST -p $DB_PORT -U $DB_USER -d $DB_NAME -c "CREATE EXTENSION IF NOT EXISTS vector;" || true
    echo "pgvector setup complete"
fi

# Start the application
echo "Starting uvicorn..."
exec uvicorn main:app --host 0.0.0.0 --port ${PORT:-8765} --workers 4 