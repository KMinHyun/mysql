-- 1. 사원의 사원번호, 이름, 직급코드를 출력해 주세요.
SELECT
	emp.emp_id
	,emp.`name`
	,tit_e.title_code
FROM employees emp
	JOIN title_emps tit_e
		ON emp.emp_id = tit_e.emp_id
		AND tit_e.end_at IS NULL
ORDER BY emp.emp_id ASC
;
-- 2. 사원의 사원번호, 성별, 현재 연봉을 출력해 주세요.
SELECT
	emp.emp_id
	,emp.gender
	,sal.salary
FROM employees emp
	JOIN salaries sal
		ON emp.emp_id = sal.emp_id
		AND sal.end_at IS NULL
;
-- 3. 10010 사원의 이름과 과거부터 현재까지 연봉 이력을 출력해 주세요.
SELECT
	emp.`name`
	,sal.start_at
	,sal.end_at
	,sal.salary
FROM employees emp
	JOIN salaries sal
		ON emp.emp_id = sal.emp_id
-- 		AND emp.emp_id <= sal보단 emp의 emp_id로 하는 게
-- 		레코드가 더 적게 잡힘
WHERE
	sal.emp_id = 10010
ORDER BY sal.start_at ASC
;
-- 4. 사원의 사원번호, 이름, 소속부서명을 출력해 주세요.
SELECT
	emp.emp_id
	,emp.`name`
	,dept.dept_name
FROM employees emp
	JOIN department_emps dept_e
		ON emp.emp_id = dept_e.emp_id
		AND dept_e.end_at IS NULL -- <= 놓친 부분
	JOIN departments dept
		ON dept_e.dept_code = dept.dept_code
;
-- 5. 현재 연봉의 상위 10위까지 사원의 사번, 이름, 연봉을 출력해 주세요.
SELECT
	emp.emp_id
	,emp.`name`
	,sal.salary
FROM employees emp
	JOIN salaries sal
		ON emp.emp_id = sal.emp_id
		AND sal.end_at IS NULL -- <= 현재 받고 있는 연봉
		AND emp.fire_at IS NULL -- <= 놓친 부분
-- 			퇴사자 중에서도 end_at이 null일 수도 있어서
-- 			fire_at IS NULL을 써주면 안정성을 높여줌
ORDER BY sal.salary DESC
LIMIT 10
;
-- ⇊ 서브 쿼리를 이용해서 최적화
SELECT
	emp.emp_id
	,emp.`name`
	,sal.salary
FROM employees emp
	JOIN ( -- 레코드 수를 줄이기 위해 서브쿼리 이용
		SELECT
			sal.emp_id
			,sal.salary
		FROM salaries sal
		WHERE
			sal.end_at IS NULL
		ORDER BY sal.salary DESC
		LIMIT 10
	) tmp_sal
		ON emp.emp_id = tmp_sal.emp_id
ORDER BY tmp_sal.salary DESC
-- 퇴사 날짜가 업데이트가 안 된 경우의 대비가 안 됨
-- 이런 경우는 비즈니스 로직 관리를 철저히 해야 함
-- 다만 그건 프로그래밍단의 역할
;
-- 6. 현재 각 부서의 부서장의 부서명, 이름, 입사일을 출력해 주세요.
SELECT
	emp.`name`
	,emp.hire_at
	,dept.dept_name
FROM department_managers dept_m
	JOIN departments dept
		ON	dept_m.dept_code = dept.dept_code
		AND dept_m.end_at IS NULL -- <= 놓친 부분
	JOIN employees emp
		ON dept_m.emp_id = emp.emp_id
		AND emp.fire_at IS NULL -- <= 데이터 오류로 인한 보강
ORDER BY dept.dept_code ASC -- <= 넣어주는 게 좋음
;
-- 7. 현재 직급이 "부장"인 사원들의 연봉 평균을 출력해 주세요.
SELECT
	CEILING(AVG(sal.salary)) avg_sal
FROM titles tit
	JOIN title_emps tit_e
		ON tit.title_code = tit_e.title_code
		AND tit.title = '부장'
		AND tit_e.end_at IS NULL
	JOIN salaries sal
		ON tit_e.emp_id = sal.emp_id
		AND sal.end_at IS NULL
ORDER BY avg_sal ASC
;
-- 현재 각 부장별 이름, 연봉평균
SELECT
	emp.`name`
	,CEILING(AVG(sal.salary)) avg_sal
FROM titles tit
	JOIN title_emps tit_e
		ON tit.title_code = tit_e.title_code
		AND tit.title = '부장'
		AND tit_e.end_at IS NULL
	JOIN employees emp
		ON emp.emp_id = tit_e.emp_id
		AND emp.fire_at IS NULL
	JOIN salaries sal
		ON emp.emp_id = sal.emp_id
GROUP BY sal.emp_id, emp.`name`
-- GROUP BY를 여러 개로 묶을 땐 중복되는 게 없는지 체크해야 함
;
-- ⇊ 다른 패턴
SELECT
	emp.`name`
	,CEILING(sub_salaries.avg_sal)
FROM employees emp
	JOIN (
		SELECT
			sal.emp_id
			,AVG(sal.salary) avg_sal
		FROM title_emps tit_e
			JOIN titles tit
				ON tit_e.title_code = tit.title_code
				AND tit.title = '부장'
				AND tit_e.end_at IS NULL
			JOIN salaries sal
				ON sal.emp_id = tit_e.emp_id
		GROUP BY sal.emp_id
	) sub_salaries -- <= 부장들의 평균 급여와 emp_id를
-- 		반환하는 임시 테이블 생성
	ON emp.emp_id = sub_salaries.emp_id
	AND emp.fire_at IS NULL
;
-- 8. 부서장직을 역임했던 모든 사원의 이름과
-- 입사일, 사번, 부서번호를 출력해 주세요.
SELECT
	emp.`name`
	,emp.hire_at
	,emp.emp_id
	,dept_m.dept_code
FROM department_managers dept_m
	JOIN employees emp
		ON	dept_m.emp_id = emp.emp_id
;
/* 부서 이동을 해서 부서장을 2번 역임한 경우와 같이, 중복 데이터도 나올 수 있음.
이럴 경우, 서브 쿼리를 이용해서 EXISTS로 있는지 없는지만 체크하는 식으로
해결해 볼 수 있음.*/

-- 9. 현재 각 직급별 평균연봉 중 60,000,000이상인 직급의 
-- 직급명, 평균연봉(정수)를을 평균연봉 내림차순으로 출력해 주세요.
SELECT
	tit.title
	,CEILING(AVG(sal.salary)) avg_sal	
FROM salaries sal
	JOIN title_emps tit_e
		ON sal.emp_id = tit_e.emp_id
		AND sal.end_at IS NULL
		AND tit_e.end_at IS NULL
	JOIN titles tit
		ON tit_e.title_code = tit.title_code
GROUP BY tit.title
	HAVING avg_sal >= 60000000
ORDER BY avg_sal DESC
;
-- 10. 성별이 여자인 사원들의 직급별 사원수를 출력해 주세요.
SELECT
	tit_e.title_code
	,COUNT(*) cnt_f_emp
FROM employees emp
	JOIN title_emps tit_e
		ON emp.emp_id = tit_e.emp_id
		AND emp.fire_at IS NULL
		AND tit_e.end_at IS NULL
		AND emp.gender = 'F'
GROUP BY tit_e.title_code
ORDER BY tit_e.title_code ASC
;
-- ▽ 성별 사원 수 출력.
SELECT
	tit_e.title_code
	,emp.gender
	,COUNT(*) cnt_emp
FROM employees emp
	JOIN title_emps tit_e
		ON emp.emp_id = tit_e.emp_id
		AND emp.fire_at IS NULL
		AND tit_e.end_at IS NULL
GROUP BY tit_e.title_code, emp.gender
ORDER BY tit_e.title_code ASC, emp.gender ASC
;