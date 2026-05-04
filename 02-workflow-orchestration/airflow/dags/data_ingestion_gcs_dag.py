import os
import logging
from datetime import datetime

from airflow import DAG
from airflow.operators.python import PythonOperator
from airflow.operators.bash import BashOperator

from google.cloud import storage

PROJECT_ID = os.environ.get("GCP_PROJECT_ID")
BUCKET = os.environ.get("GCP_GCS_BUCKET")

BASE_URL = "https://github.com/DataTalksClub/nyc-tlc-data/releases/download"

MONTHS = [f"{m:02d}" for m in range(1, 8)]
TYPES = ["yellow", "green"]
YEAR = "2021"

local_path = "/tmp"


def upload_to_gcs(file_path, gcs_path):
    client = storage.Client()
    bucket = client.bucket(BUCKET)
    blob = bucket.blob(gcs_path)
    blob.upload_from_filename(file_path)
    logging.info(f"Uploaded {gcs_path}")


def process(**context):
    for t in TYPES:
        for m in MONTHS:
            file_name = f"{t}_tripdata_{YEAR}-{m}.csv.gz"
            url = f"{BASE_URL}/{t}/{file_name}"

            local_file = f"{local_path}/{file_name}"

            # download
            os.system(f"curl -sSL {url} -o {local_file}")

            if not os.path.exists(local_file):
                logging.warning(f"Missing: {url}")
                continue

            gcs_path = f"raw/{t}/{YEAR}/{file_name}"

            upload_to_gcs(local_file, gcs_path)


default_args = {
    "owner": "airflow",
    "start_date": datetime(2021, 1, 1),
}

with DAG(
    dag_id="taxi_2021_fixed_dag",
    schedule=None,
    catchup=False,
    default_args=default_args,
) as dag:

    run = PythonOperator(
        task_id="run_pipeline",
        python_callable=process,
    )