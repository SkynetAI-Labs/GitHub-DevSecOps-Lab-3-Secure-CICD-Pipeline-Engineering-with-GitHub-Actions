FROM python:3.12-slim

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

WORKDIR /app

RUN groupadd --gid 10001 appuser \
    && useradd --uid 10001 --gid appuser --no-create-home appuser

COPY --chown=appuser:appuser app/ ./app/

USER appuser

CMD ["python", "-c", "from app.health import health_status; print(health_status())"]
