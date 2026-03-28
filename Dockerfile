# Dockerfile
FROM python:3.14-slim AS builder

ENV UV_SYSTEM_PYTHON=1 \
    UV_COMPILE_BYTECODE=1

# Установка uv
COPY --from=ghcr.io/astral-sh/uv:latest /uv /uvx /bin/

WORKDIR /app
COPY pyproject.toml uv.lock ./

# Установка зависимостей в системный Python (для slim образа это ок)
RUN uv pip install -r pyproject.toml

# --- Финальный образ ---
FROM python:3.14-slim

WORKDIR /app
# Копируем только установленные пакеты из билдера
COPY --from=builder /usr/local/lib/python3.14/site-packages /usr/local/lib/python3.14/site-packages
COPY --from=builder /usr/local/bin /usr/local/bin

COPY . .

# Ограничение логов и ресурсов внутри приложения
RUN useradd -m appuser && chown -R appuser /app
USER appuser

CMD ["uvicorn", "presentation.api.main:app", "--host", "0.0.0.0", "--port", "8000"]