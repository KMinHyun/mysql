-- INSERT 문
-- 신규 데이터 저장하기 위해 사용하는 문법
INSERT INTO employees (
	`name`
	,birth
	,gender
	,hire_at
	,fire_at
	,sup_id
	,created_at
	,updated_at
	,deleted_at
)
VALUES (
	'김민현'
	,'2000-01-01'
	,'M'
	,'2025-10-31'
	,null
	,null
	,NOW()
	,NOW()
-- NOW() : MySQL 기능으로 현재시간을 가져옴
	,null
)
;

-- 내가 추가한 데이터 확인
	-- 생성일이 가장 최근인 것
	-- 내 이름으로 찾기
	-- 입사일이 오늘 기준
	-- 생일로 찾기
	-- 가장 큰 PK로 찾기
SELECT *
FROM employees
WHERE
	`name` = '김민현'
	AND birth = '2000-01-01'
	AND hire_at = '2025-10-31'
;

-- 자신의 연봉 데이터를 넣어 주세요.
INSERT INTO salaries (
	emp_id
	,salary
	,start_at
-- 	,end_at
-- 	,created_at
-- 	,updated_at
-- 	,deleted_at
)
VALUES (
	100005
	,30000000
	,'2025-10-31'
-- 	,null
-- 	,NOW()
-- 	,NOW()
-- 	,null
)
;

SELECT *
FROM salaries
WHERE
	emp_id = 100005
	AND salary = 30000000
	AND start_at = '2025-10-31'
;

-- SELECT INSERT 문법 : SELECT한 결과를 INSERT하는 방법
INSERT INTO salaries (
	emp_id
	,salary
	,start_at
)
SELECT 
	emp_id
	,30000000
	,created_at
FROM employees
WHERE
	`name` = '김민현'
	AND birth = '2000-01-01'
	AND hire_at = '2025-10-31'
;

