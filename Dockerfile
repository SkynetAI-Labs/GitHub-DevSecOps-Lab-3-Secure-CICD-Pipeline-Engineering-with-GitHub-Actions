FROM python:3.12-alpine3.23@sha256:3d0ca66b723a0ff2a7a6e424cc2d01443e1b7c75ffcc110145f75d0f4daf6d63

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

WORKDIR /app

RUN apk upgrade --no-cache \
    && addgroup -S -g 10001 appuser \
    && adduser -S -D -H -u 10001 -G appuser appuser

COPY --chown=appuser:appuser app/ ./app/

USER appuser

CMD ["python", "-c", "from app.health import health_status; print(health_status())"]
