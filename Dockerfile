FROM docker.io/library/python:3.13-slim

# 1. Install uv
COPY --from=ghcr.io/astral-sh/uv:latest /uv /uvx /bin/

ENV UV_SYSTEM_PYTHON=1 \
    UV_COMPILE_BYTECODE=1 \
    PYTHONUNBUFFERED=1

WORKDIR /app

# 2. Create user FIRST (avoiding a heavy chown layer later)
RUN useradd -m appuser && chown appuser /app
USER appuser

# 3. Copy files as the user
COPY --user=appuser pyproject.toml uv.lock ./

# 4. Install dependencies (no-cache is CRITICAL here)
RUN uv pip install --no-cache -r pyproject.toml

# 5. Copy code as the user
COPY --chown=appuser:appuser . .

CMD ["uvicorn", "src.presentation.api.main:app", "--host", "0.0.0.0", "--port", "8000"]
