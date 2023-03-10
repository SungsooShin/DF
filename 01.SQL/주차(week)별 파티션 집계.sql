
-- ■ 주차별 실적 현황을 구현
-- 트러블슈팅 : 일별로 당주 당일까지의 최신(누적) 현황이 업데이트 되도록 마트/배치 스케쥴 설계. (주차배치가 아닌 일배치로 구현)


-- STEP1. 해당 주차의 파티션 제거
DELETE FROM PROJECT.DATASET.TEMP_TABLE  -- ※ 적재 배치가 돌기 전, 해당 주차의 데이터 삭제하기 위함 (적재할때 현재일 까지의 해당주차 실적 재적재)
WHERE P_WNO = CAST(FORMAT_DATE('%G%V', PARSE_DATE('%Y%m%d', CAST(#YYYYMMDD# AS STRING))) AS INT) -- P_WNO : 월요일 시작 주차 파티션 (파라미터 타입은 정수) 


-- STEP2. 해당 주차 실적 적재
INSERT INTO PROJECT.DATASET.TEMP_TABLE 
SELECT *
FROM PROJECT.DATASET.SOURCE_TABLE
WHERE 1=1
AND P_YYYYMMDD BETWEEN DATE_ADD(DATE_TRUNC(DATE_SUB(PARSE_DATE('%Y%m%d', CAST(#YYYYMMDD# AS STRING)), INTERVAL 1 DAY), WEEK), INTERVAL 1DAY) /*해당주 월요일*/
				   AND DATE_ADD(DATE_TRUNC(DATE_SUB(PARSE_DATE('%Y%m%d', CAST(#YYYYMMDD# AS STRING)), INTERVAL 1 DAY), WEEK), INTERVAL 7DAY) /*해당주 일요일*/
				   -- ※ DATE_TRUNC 함수의 경우, 일요일 시작 주차로 반환해주기 때문에, DATE_SUB / ADD 함수를 통해 월요일 주차로 반환 
				   
				   