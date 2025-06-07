# Deploying OpenMemory MCP to Render

This guide will help you deploy OpenMemory MCP to your Render account using PostgreSQL with pgvector for vector storage.

## Prerequisites

1. A Render account (already authenticated with CLI)
2. Your OpenAI API key
3. Your forked and cloned mem0 repository

## Deployment Steps

### 1. Deploy to Render

From the root of your mem0 repository, deploy via the Render Dashboard (see instructions below)

When prompted:
- Select "Web Service" 
- Choose a name for your service (e.g., "openmemory-mcp")
- Select the region closest to you

### 2. Set Environment Variables

After deployment, go to your Render dashboard and add these environment variables:

1. **OPENAI_API_KEY**: Your OpenAI API key (required)
2. **API_KEY**: Same as OPENAI_API_KEY (required)
3. **USER**: Your desired user ID (optional, defaults to "default-user")

### 3. Wait for Deployment

The first deployment will:
1. Create a PostgreSQL database
2. Install the pgvector extension automatically
3. Build and start the OpenMemory MCP server

This may take 5-10 minutes.

### 4. Verify Deployment

Once deployed, you can access:
- API endpoint: `https://your-service-name.onrender.com`
- API documentation: `https://your-service-name.onrender.com/docs`

### 5. Test the Deployment

You can test your deployment with:

```bash
curl -X GET https://your-service-name.onrender.com/memories \
  -H "Content-Type: application/json"
```

## Configuration Details

The deployment uses:
- **Database**: PostgreSQL with pgvector extension (automatically configured)
- **Vector Store**: pgvector (integrated with PostgreSQL)
- **LLM**: OpenAI GPT-4o-mini
- **Embeddings**: OpenAI text-embedding-3-small

## Troubleshooting

### If pgvector extension fails to install:
1. Go to your Render PostgreSQL database settings
2. Run this SQL command in the query console:
   ```sql
   CREATE EXTENSION IF NOT EXISTS vector;
   ```

### To check logs:
```bash
render logs --service openmemory-mcp
```

### To update environment variables:
```bash
render env:set OPENAI_API_KEY=your-key --service openmemory-mcp
```

## Alternative: Using Qdrant Cloud

If you prefer to use Qdrant instead of pgvector:

1. Sign up for [Qdrant Cloud](https://cloud.qdrant.io/)
2. Create a cluster
3. Update the `render.yaml` in the repository root to use the original Qdrant configuration
4. Set these environment variables in Render:
   - `QDRANT_HOST`: Your Qdrant cluster URL (without https://)
   - `QDRANT_API_KEY`: Your Qdrant API key

## Next Steps

1. Deploy the OpenMemory UI (optional)
2. Configure custom instructions for memory extraction
3. Integrate with your applications using the MCP protocol

For more information, see the [OpenMemory documentation](../README.md). 