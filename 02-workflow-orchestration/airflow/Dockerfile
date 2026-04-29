FROM apache/airflow:3.2.1-python3.10

ENV AIRFLOW_HOME=/opt/airflow

USER root

RUN apt-get update -qq && apt-get install -y --no-install-recommends \
    vim \
    curl \
    gcc \
    g++ \
    build-essential \
    python3-dev \
    apt-transport-https \
    ca-certificates \
    gnupg \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

USER airflow

COPY requirements.txt /requirements.txt

RUN pip install --no-cache-dir \
    --user \
    -r /requirements.txt \
    --constraint https://raw.githubusercontent.com/apache/airflow/constraints-3.2.1/constraints-3.10.txt

USER root

ARG CLOUD_SDK_VERSION=545.0.0
ENV GCLOUD_HOME=/opt/google-cloud-sdk
ENV PATH="${GCLOUD_HOME}/bin:${PATH}"

RUN curl -fsSL \
    https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-sdk-${CLOUD_SDK_VERSION}-linux-x86_64.tar.gz \
    -o /tmp/gcloud.tar.gz \
    && mkdir -p /opt \
    && tar -xzf /tmp/gcloud.tar.gz -C /opt \
    && /opt/google-cloud-sdk/install.sh \
        --quiet \
        --usage-reporting=false \
        --bash-completion=false \
        --path-update=false \
    && rm -f /tmp/gcloud.tar.gz \
    && /opt/google-cloud-sdk/bin/gcloud --version

WORKDIR ${AIRFLOW_HOME}

COPY scripts/ scripts/
RUN chmod +x scripts/

USER airflow