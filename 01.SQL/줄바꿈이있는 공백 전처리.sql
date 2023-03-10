-- ■ 데이터 중복 방어로직 (줄바꿈이 있는 공백)
-- 트러블슈팅 : 데이터 검증 중, Distinct 하게 값을 추출했으나 행 중복이 발생 (예시 : "무한 도전")

-- 줄바꿈이있는공백 확인쿼리
SELECT DISTINCT BYTE_LENGTH(SUBSTR(col,3,1)) --"무한" 다음 공백을 Byte_length로 조회시, 줄바꿍이 있는 공백은 2byte, 일반 공백은 1byte인것을 확인 
FROM project.dataset.TB 

-- 방어로직
SELECT REPLACE(SUBSTR(col,3,1),'\xa0' , ' ') -- 줄바꿈이있는공백 : '\xa0'로 인식

