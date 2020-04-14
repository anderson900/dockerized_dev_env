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

FROM build-poetry

# Run as a non-root user

ARG USERNAME
ARG USER_UID
ARG USER_GID=$USER_UID

# Create the user

RUN groupadd --gid $USER_GID $USERNAME \
 && useradd --uid $USER_UID --gid $USER_GID -m $USERNAME

# Create paths for vscode-specific volume mounts

RUN mkdir -p \
    /home/$USERNAME/.vscode-server/extensions \
    /home/$USERNAME/.vscode-server-insiders/extensions \
 && chown -R $USERNAME \
    /home/$USERNAME/.vscode-server \
    /home/$USERNAME/.vscode-server-insiders

# Enable bash history to be persisted between container runs

RUN SNIPPET="export PROMPT_COMMAND='history -a' && export HISTFILE=/commandhistory/.bash_history" \
 && echo $SNIPPET >> "/root/.bashrc" \
 && mkdir /commandhistory \
 && touch /commandhistory/.bash_history \
 && chown -R $USERNAME /commandhistory \
 && echo $SNIPPET >> "/home/$USERNAME/.bashrc" \

USER $USERNAME

# Configure Poetry

RUN mkdir -p /home/$USERNAME/.config/pypoetry \
 && echo [virtualenvs]\\nin-project = true >> /home/$USERNAME/.config/pypoetry/config.toml \
 && chown -R $USERNAME /home/$USERNAME/.config
ENV VIRTUAL_ENV=/workspace/.venv
ENV PATH="${VIRTUAL_ENV}/bin:${PATH}"
