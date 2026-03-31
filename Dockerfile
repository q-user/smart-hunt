FROM docker.io/library/python:3.13-slim # Use 3.13 (Stable) instead of 3.14 (Alpha)

# Install uv
COPY --from=ghcr.io/astral-sh/uv:latest /uv /uvx /bin/

ENV UV_SYSTEM_PYTHON=1 \
    UV_COMPILE_BYTECODE=1 \
    PYTHONUNBUFFERED=1

WORKDIR /app

# Copy dependency files first (better caching)
COPY pyproject.toml uv.lock ./

# Install dependencies (no-cache saves 100MB+ of SSD space!)
RUN uv pip install --no-cache -r pyproject.toml

# Copy source code
COPY . .

# Security and clean up
RUN useradd -m appuser && chown -R appuser /app
USER appuser

CMD ["uvicorn", "presentation.api.main:app", "--host", "0.0.0.0", "--port", "8000"]
