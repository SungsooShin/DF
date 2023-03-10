-- ■ 프로시저를 활용한 재귀함수 

-- TB  : PROJECT.DATASET.TREETABLE  : 조직 마스터테이블
-- DDL : BR_CD, UP_BR_CD, BR_NM


WITH RECURSIVE TREE
AS ( -- 고정 (첫번째 루프에서만 실행됨 : 최상위 Level)
	SELECT 1 AS LEVEL	-- 계층
		,  BR_CD	 	-- 조직코드
		,  UP_BR_CD 	-- 상위조직코드
		,  BR_NM 		-- 조직명
		,  CAST(BR_CD AS STRING) AS CD_FLOW -- 조직코드흐름
		, CAST(BR_NM AS STRING)  AS NM_FLOW -- 조직명흐름
	FROM PROJECT.DATASET.TREETABLE 
	WHERE UP_BR_CD = '000000001' -- 마스터노드 코드값입력
 UNION ALL
		-- Recursive 시작 (호출 할 때마다 행의 위치가 기억되고, 다음행으로 이동하여 쿼리문 실행)
	SELECT LEVEL + 1 AS LEVEL
		, B.BR_CD
		, B.UP_BR_CD
		, CONCAT(C.SORT, '>', B.BR_CD) AS CD_FLOW
		, CONCAT(C.NM_FLOW , '>', B.BR_NM) AS NM_FLOW 
	FROM PROJECT.DATASET.TREETABLE B
	INNER JOIN TREE C 
	ON B.UP_BR_CD = C.BR_CD
--  WHERE B.LEVEL < 100 -- 반복문 종료조건
	)
SELECT *
FROM TREE
ORDER BY CD_FLOW