-- --------------
-- DML 문제
-- --------------
-- 1. 모든 직원의 이름과 입사일을 조회하세요.
SELECT
	`name`
	,hire_at
FROM employees
ORDER BY `name` ASC
;

-- 2. 'd005' 부서에 속한 모든 직원의 직원 ID를 조회하세요.
SELECT
	emp_id
FROM department_emps
WHERE
	dept_code = 'D005'
ORDER BY emp_id ASC
;

-- 3. 1995년 1월 1일 이후에 입사한 모든 직원의 정보를 입사일 순서대로 정렬하여 조회하세요.
SELECT *
FROM employees
WHERE
	hire_at >= 19950101
ORDER BY hire_at ASC
;

-- 4. 각 부서별로 몇 명의 직원이 있는지 계산하고, 직원 수가 많은 부서부터 순서대로 보여주세요.
SELECT
	dept.dept_name
	,COUNT(dept.dept_name) cnt_dept_name
FROM department_emps depte
	JOIN departments dept
		ON depte.dept_code = dept.dept_code
		AND depte.end_at IS NULL
GROUP BY dept.dept_name
ORDER BY COUNT(dept.dept_name) DESC
;

-- 5. 각 직원의 현재 연봉 정보를 조회하세요.
SELECT
	emp_id
	,salary
FROM salaries
WHERE
	end_at IS NULL
ORDER BY salary ASC
;

-- 6. 각 직원의 이름과 해당 직원의 현재 부서 이름을 함께 조회하세요.
SELECT
	emp.`name`
	,dept.dept_name
FROM employees emp
	JOIN department_emps depte
		ON emp.emp_id = depte.emp_id
		AND end_at IS NULL
	JOIN departments dept
		ON dept.dept_code = depte.dept_code
ORDER BY `name` ASC
;

-- 7. '마케팅부' 부서의 현재 매니저의 이름을 조회하세요.
SELECT
	emp.`name`
FROM employees emp
	JOIN department_managers deptm
		ON emp.emp_id = deptm.emp_id
		AND end_at IS NULL
	JOIN departments dept
		ON dept.dept_code = deptm.dept_code
		AND dept.dept_name = '마케팅부'
;

-- 8. 현재 재직 중인 각 직원의 이름, 성별, 직책(title)을 조회하세요.
SELECT
	emp.`name`
	,emp.gender
	,tit.title
FROM employees emp
	JOIN title_emps tite
		ON emp.emp_id = tite.emp_id
		AND end_at IS NULL
	JOIN titles tit
		ON tit.title_code = tite.title_code
ORDER BY `name` ASC
;

-- 9. 현재 가장 높은 연봉을 받는 상위 5명의 직원 ID와 연봉을 조회하세요.
SELECT
	emp_id
	,salary
FROM salaries
WHERE
	end_at IS NULL
ORDER BY salary DESC
LIMIT 5
;

-- 10. 각 부서의 현재 평균 연봉을 계산하고, 평균 연봉이 6000 이상인 부서만 조회하세요.
SELECT
	dept.dept_name
	,CEILING(AVG(sal.salary))
FROM department_emps depte
	JOIN salaries sal
		ON depte.emp_id = sal.emp_id
		AND depte.end_at IS NULL
		AND sal.end_at IS NULL
	JOIN departments dept
		ON dept.dept_code = depte.dept_code
GROUP BY dept.dept_name
	HAVING AVG(sal.salary) >= 60000000
ORDER BY dept.dept_name ASC
;
-- ---------
-- DDL 문제
-- ---------
-- 11. 아래 구조의 테이블을 작성하는 SQL을 작성해 주세요.
CREATE TABLE users(
	user_id INT UNSIGNED PRIMARY KEY AUTO_INCREMENT
	,user_name VARCHAR(30) NOT NULL
	,auto_flg	CHAR(1) DEFAULT '0'
	,birthday	DATE NOT NULL
	,created_at	DATETIME DEFAULT (CURRENT_DATE())
);

-- 12. [11.]에서 만든 테이블에 아래 데이터를 입력해 주세요.
-- 유저id : 자동증가
-- 유저 이름 : ‘그린’
-- AuthFlg : ‘0’
-- 생일 : 2024-01-26
-- 생성일 : 오늘 날짜
INSERT INTO users (
	user_name
	,auto_flg
	,birthday
	,created_at
)
VALUES (
	'그린'
	,'0'
	,'2024-01-26'
	,NOW()
);

-- 13. [12.]에서 만든 레코드를 아래 데이터로 갱신해 주세요.
-- 유저 이름 : ‘테스터’
-- AuthFlg : ‘1’
-- 생일 : 2007-03-01
UPDATE users
SET
	user_name = '테스터'
	,auto_flg = '1'
	,birthday = '2007-03-01'
WHERE
	user_id = 1
;

-- 14. [12.]에서 만든 레코드를 삭제해 주세요.
DELETE FROM users
WHERE
	user_id = 1
;

-- 15. [11.]에서 만든 테이블에 아래 Column을 추가해 주세요.
ALTER TABLE users
	ADD COLUMN addr VARCHAR(100) NOT NULL DEFAULT '-'
;

-- 16. [15.]에서 만든 테이블을 삭제해 주세요.
ALTER TABLE users
	DROP COLUMN addr
;

-- 17. 아래 테이블에서 유저명, 생일, 랭크명을 출력해 주세요.
SELECT
	users.user_name
	,users.birthday
	,rankm.rank_name
FROM users
	JOIN rankmanagement rankm
		ON rankm.user_id = users.user_id
;