-- SubQuery

-- ----------------
-- WHERE절에서 사용
-- ----------------
-- D001 부서장의 사번과 이름을 출력
SELECT
	employees.emp_id
	,employees.`name`
FROM employees
WHERE
	employees.emp_id = (
--	단일 비교 연산자일 땐 서브 쿼리의 결과가 하나여야 함
		SELECT depm.emp_id
		FROM department_managers depm
		WHERE depm.dept_code = 'D001'
		AND depm.end_at IS NULL
	)
;
-- 테이블에 별칭을 줘서 컬럼명 앞에 붙여 어떤 테이블의 컬럼인지를 명확하게 해야 함
-- 	별칭 대신 그대로 써도 됨

-- 다중 행 서브쿼리
-- 서브쿼리 결과값이 2건 이상일 때
-- 반드시 다중 행 비교 연산자(IN, ALL, ANY, SOME, EXISTS 등)을 사용
-- 현재 부서장인 사원의 사번과 이름을 출력
SELECT
	employees.emp_id
	,employees.`name`
FROM employees
WHERE
	employees.emp_id IN (
-- IN은 원래 여러 값을 가져와 비교하는 연산자
		SELECT depm.emp_id
		FROM department_managers depm
		WHERE
			depm.end_at IS NULL
	)
;

-- 다중 열 서브쿼리
-- 서브쿼리의 결과가 복수의 컬럼을 반환할 경우,
-- 메인 쿼리의 조건과 동시 비교를 하기 위해 사용
-- 현재 D002의 부서장이 해당 부서에 소속된 날짜 출력
SELECT
	department_emps.*
FROM department_emps
WHERE
	(department_emps.emp_id, department_emps.dept_code) IN (
		SELECT
			department_managers.emp_id
			,department_managers.dept_code
		FROM department_managers
		WHERE
			department_managers.dept_code = 'D002'
			AND department_managers.end_at IS NULL
	)
;
-- 서브 쿼리에서 가져온 결과의 컬럼 순서와 메인 쿼리의 컬럼 순서 맞추기

-- 연관 서브쿼리
-- 서브쿼리 내에서 메인 쿼리의 컬럼이 사용된 서브쿼리
-- 부서장 직을 지냈던 경력이 있는 사원의 정보 출력
SELECT
	employees.*
FROM employees
WHERE
	employees.emp_id IN(
		SELECT department_managers.emp_id
		FROM department_managers
		WHERE
			department_managers.emp_id = employees.emp_id
	)
;