FROM python:3.11-slim

# Environment variables (correct format)
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

WORKDIR /app

# System dependencies for psycopg2
RUN apt-get update && apt-get install -y --no-install-recommends \
    dnsutils \
    libpq-dev \
    python3-dev \
    gcc \
    build-essential \
 && rm -rf /var/lib/apt/lists/*

# Upgrade pip safely
RUN python -m pip install --upgrade pip

# Install Python dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy application code
COPY . .

EXPOSE 8000

# Move to Django project directory
WORKDIR /app/pygoat

# Run server (migrations should be run separately)
CMD ["gunicorn", "--bind", "0.0.0.0:8000", "--workers", "6", "pygoat.wsgi"]
