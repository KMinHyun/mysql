-- UPDATE 문
UPDATE employees
SET
	fire_at = NOW()
	,deleted_at = NOW()
-- 여러 개의 컬럼 수정 가능(단, UPDATE에 적힌 테이블만)
WHERE
	emp_id = 100005
-- 조건이 없으면 세팅한 컬럼의 데이터 모두 업데이트
-- 해당 로우의 pk 번호로 조건 설정하면 됨
;

UPDATE salaries
SET
	salary = 35000000
WHERE
	emp_id = 100005
-- salaries의 emp_id는 하나가 아니므로 내가 원하는 데이터만 수정하고 있는지 잘 체크해야 함
-- 명확하게 데이터를 갱신하고 있는지 면밀히 체크가 필요
-- 지금 같은 경우는 sal_id로 갱신하는 게 올바름
;

SELECT *
FROM salaries
WHERE
	emp_id = 100000
	AND end_at IS NULL
;
-- PK를 찾기 어려운 경우 특정하는 법