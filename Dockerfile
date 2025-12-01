FROM python:3.11-slim

# Переменные окружения для Python (не писать .pyc файлы, буферизация логов)
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

WORKDIR /app

# Установка системных зависимостей (если нужны для psycopg2)
RUN apt-get update && apt-get install -y libpq-dev gcc && rm -rf /var/lib/apt/lists/*

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

# Собираем статику (нужна заглушка DB или настройки, чтобы collectstatic не лез в БД)
# В Django < 4.2 иногда требовались хаки, но попробуем так:
RUN python manage.py collectstatic --noinput

EXPOSE 8000

CMD ["gunicorn", "--bind", "0.0.0.0:8000", "--workers", "3", "django_app.wsgi:application"]
