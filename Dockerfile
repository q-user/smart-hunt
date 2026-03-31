FROM docker.io/library/python:3.14-slim

# Install uv
COPY --from=ghcr.io/astral-sh/uv:latest /uv /uvx /bin/

ENV UV_SYSTEM_PYTHON=1 \
    UV_COMPILE_BYTECODE=1 \
    PYTHONUNBUFFERED=1

WORKDIR /app

# Copy files
COPY pyproject.toml uv.lock ./
RUN uv pip install --no-cache -r pyproject.toml

COPY . .

RUN useradd -m appuser && chown -R appuser /app
USER appuser

CMD ["uvicorn", "presentation.api.main:app", "--host", "0.0.0.0", "--port", "8000"]
