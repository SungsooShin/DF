-- ■ 프로시저를 활용한 자동 적재문

DECLARE ORDERING INT64 DEFAULT 0;
DECLARE WORK_DATE STRING DEFAULT '20230101'   -- 적재 시작
DECLARE FINISH_DATE STRING DEFAULT '20230201' -- 적재 마침

LOOP
 IF FORMAT_DATE('%Y%m%d', DATE_ADD(PARSE_DATE('%Y%m%d', WORK_DATE), INTERVAL ORDERING DAY)) > FINISH_DATE 
 THEN LEAVE   -- 루프 빠져나오기
 END IF;
			SELECT DATE_ADD(PARSE_DATE('%Y%m%d', WORK_DATE), INTERVAL ORDERING DAY) AS WORKING_DATE
				,  ORDERING;  -- 실행중인적재파라미터, 적재순서 (결과보기용도)
/*------------------------------------------------------------------------------
  쿼리문 입력
  * 단, 파라미터를 WORKING_DATE으로 변경 
    WORKING_DATE => DATE_ADD(PARSE_DATE('%Y%m%d', WORK_DATE), INTERVAL ORDERING DAY)
	
-------------------------------------------------------------------------------*/
			SET ORDERING = ORDERING + 1;
END LOOP;
