FROM python:3.8-slim as build-poetry

RUN apt-get update && apt-get install -y \
    curl \
    git

RUN pip install --upgrade \
    pip

# Install Poetry

RUN curl -sSL -o get-poetry.py https://raw.githubusercontent.com/python-poetry/poetry/master/get-poetry.py

ENV POETRY_HOME=/etc/poetry
ENV PATH="${POETRY_HOME}/bin:${PATH}"

RUN python get-poetry.py

RUN rm get-poetry.py

RUN chmod a+x ${POETRY_HOME}/bin/poetry

ADD * /project/
WORKDIR /project

RUN poetry env use system
RUN poetry config virtualenvs.create false
RUN poetry build -n --format wheel

FROM python:3.8-slim
COPY --from=build-poetry /project/dist/*.whl /
RUN pip install /*.whl
