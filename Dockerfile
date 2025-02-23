
FROM python:3.11-buster as builder
WORKDIR /app


RUN pip install --upgrade pip && pip install poetry


COPY pyproject.toml poetry.lock ./


RUN poetry config virtualenvs.create false \
    && poetry install --no-root --no-interaction --no-ansi


COPY . .


FROM python:3.11-buster
WORKDIR /app


COPY --from=builder /usr/local /usr/local


COPY --from=builder /app /app


ENV PATH="/usr/local/bin:$PATH"


EXPOSE 8000


COPY entrypoint.sh /app/entrypoint.sh
RUN chmod +x /app/entrypoint.sh
ENTRYPOINT ["/app/entrypoint.sh"]


CMD ["uvicorn", "cc_compose.server:app", "--host", "0.0.0.0", "--port", "8000"]

