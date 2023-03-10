#에어플로우 대그 생성

from airflow import DAG
from airflow.operators.dummy import DummyOperator
# from airflow.providers.gogole.cloud.operators.bigquery import BigqueryExecuteQueryOperator

from utils import config_module, date_module
from utils.bq_module import MartInitOperator
from utils.bq_module import MartSqlRunOperator
from utils.mysql_module import MartHistInsertOperator
from utils.mysql_module import MartHistUpdateOperator

config_name = "dag_month"
dag_id = "dag_month_mart_001_EFFORT_MMLY_S"

with DAG(
		 dag_id=dag_id,
		 max_active_runs=1,
		 default_args=config_module.get_default_args(config_name),
		 schedule_interval=config_module.get_schedule_interval(config_name),
		 start_date=config_module.get_start_date(config_name),
		 catchup=config_module.get_catchup(config_name),
		 tags=['mart','dag_mart_month','P_MAT'],
) as dag:

		# === EFFORT_MMLY_S - 노력월별집계 start ===
		# START
		task_mart_start_001_EFFORT_MMLY_S = DummyOperator(
				task_id = "task_mart_start_001_EFFORT_MMLY_S",
		)
		
	# HISTORY INSERT
		task_mart_hist_insert_001_EFFORT_MMLY_S = MartHistInsertOperator(
				task_id="task_mart_hist_insert_001_EFFORT_MMLY_S",
				mart_id="EFFORT_MMLY_S",
				start_task_id="task_mart_start_001_EFFORT_MMLY_S",
		date_delta=1,
				patn_opt="M",
		)
		
		# TABLE PARTITION INITIALIZATION
		task_mart_init_EFFORT_MMLY_S = MartInitOperator(
				task_id="task_mart_init_EFFORT_MMLY_S",
				dataset="SSS",
				table_name="EFFORT_MMLY_S",
				date_delta=1,
				patn_col="P_YYYYMM",
				patn_opt="M",
		)
		
		# SQL EXE
		task_mart_sql_EFFORT_MMLY_S = MartSqlRunOperator(
				task_id="task_mart_sql_EFFORT_MMLY_S",
				mart_id="EFFORT_MMLY_S",
				sql_id="EFFORT_MMLY_S",
				sql_path="05.SOURCE/001_EFFORT_MMLY_S",
				date_delta=1,
				status_max_tries=20,
				status_interval=30,
				task_currency=1,
		)
		
	# HIST UPDATE
		task_mart_hist_update_001_EFFORT_MMLY_S = MartHistUpdateOperator(
				task_id="task_mart_hist_update_001_EFFORT_MMLY_S",
		)
	
		#END
		task_mart_end_001_EFFORT_MMLY_S = DummyOperator(
				task_id="task_mart_end_001_EFFORT_MMLY_S"
		)

		#EXECUTE
		(
				task_mart_start_001_EFFORT_MMLY_S
				>> task_mart_hist_insert_001_EFFORT_MMLY_S
				>> task_mart_init_EFFORT_MMLY_S
				>> task_mart_sql_EFFORT_MMLY_S
				>> task_mart_hist_update_001_EFFORT_MMLY_S
				>> task_mart_end_001_EFFORT_MMLY_S
		)
		# === EFFORT_MMLY_S - 노력월별집계 end === 