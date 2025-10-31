-- 테이블 전체 컬럼 조회
SELECT *
FROM employees;

-- 특정 컬럼만 지정해서 조회
SELECT
	name
	,birth
	,hire_at
FROM employees;

-- WHERE 절 : 특정 컬럼의 값과 일치한 데이터만 조회(필터링) 
SELECT *
FROM employees
WHERE
	emp_id = 5
;

SELECT *
FROM employees
WHERE
	NAME = '강영화'
;

-- 이름이 강영화이고, 성별이 남자인 사원 조회
SELECT *
FROM employees
WHERE
	NAME = '강영화'
	AND gender = 'M'
-- 	OR gender = 'M'
;
-- `또는`을 쓰려면 AND 대신 OR

-- 날짜를 필터링할 경우
SELECT *
FROM employees
WHERE
	hire_at >= '2023-01-01'
;

-- 아직 재직중인 사원들만 조회(Null 조회하는 법)
SELECT *
FROM employees
WHERE 
	fire_at IS NULL
-- 	fire_at IS NOT NULL
;
-- 퇴사한 사람을 검색하고 싶으면 `IS NULL` 대신 `IS NOT NULL`

-- WHERE절에서 AND, OR 복합 사용시 주의점
-- 입사일이 2025-01-01이후거나 2000-01-01이전이고, 이미 퇴사한 직원
SELECT *
FROM employees
WHERE
	(
		hire_at >= '2025-01-01'
		OR hire_at <= '2000-01-01'
	)
	AND fire_at IS NOT NULL
;

-- between 연산자 : 지정한 범위 내의 데이터를 조회
SELECT *
FROM employees
WHERE
	emp_id >= 10000
	AND emp_id <= 10010
;
SELECT *
FROM employees
WHERE 
	emp_id BETWEEN 10000 AND 10010
;

-- IN 연산자 : 지정한 값과 일치한 데이터를 조회
-- 사번이 5, 7, 9, 12인 사원 조회
SELECT *
FROM employees
WHERE
	emp_id = 5
	OR emp_id = 7
	OR emp_id = 9
	OR emp_id = 12
;
SELECT *
FROM employees
WHERE
	emp_id IN(5, 7, 9, 12)
-- IN 연산자는 괄호 안에 콤마로 구분 지어서 만듦
;

-- LIKE 연산자 : 문자열 내용을 조회할 때 사용
-- % : 글자수와 상관없이 조회를 함
-- 이름이 '태호'인 사원 조회
SELECT *
FROM employees
WHERE
	NAME LIKE '%태호' 
-- 태호란 글자 앞에는 어떤, 몇 글자가 와도 상관 없단 뜻
-- 태호로 끝나는 글자는 다 가져옴
-- 	NAME LIKE '호%'
-- 호로 시작하는 글자는 다 가져옴
-- 	NAME LIKE '%호%'
-- 호가 포함된 글자는 다 가져옴
;

-- _ : 언더바의 개수만큼이 글자의 개수
SELECT *
FROM employees
WHERE
	NAME LIKE '_호'
	OR NAME LIKE '__호'
	OR NAME LIKE '_호_'
	OR NAME LIKE '%호_'
-- %와 _ 조합도 가능
;

-- ORDER BY절 : 데이터를 정렬
-- 	ASC: 오름차순
-- 	DESC: 내림차순
SELECT *
FROM employees
ORDER BY NAME ASC, birth ASC
-- 콤마로 이어주면 첫번째 조건으로 정렬하고 똑같은 데이터에 한해서 두번째 조건으로 정렬
-- ORDER BY NAME DESC
;

-- 입사일이 2000년 이후인 사원을 이름, 생일 오름차순으로 정렬해서 조회
SELECT *
FROM employees
WHERE
	hire_at >= '2000-01-01'
ORDER BY
	NAME ASC
	,birth ASC
;

-- 여자 사원을 이름, 생일 오름차순으로 정렬
SELECT *
FROM employees
WHERE
	gender = 'F'
ORDER BY
	NAME ASC
	,birth ASC
;

-- DISTINCT 키워드 : 검색 결과에서 중복되는 레코드를 제거해주는 키워드
SELECT DISTINCT NAME
FROM employees
ORDER BY NAME ASC
;
/*
-- GROUP BY절 : 그룹으로 묶어서 조회
-- HAVING절 : GROUP BY절로 묶을 때 조건을 적는 절
	집계함수
		MAX() : 최대값
		MIN() : 최소값
		COUNT(): 개수
		AVG() : 평균
		SUM() : 합계
*/
-- 사원 별 최고 연봉을 조회
SELECT
	emp_id
	,MAX(salary) AS max_salary
-- 	컬럼 뒤에 AS (별칭) 으로 컬럼의 이름을 변경할 수 있음
-- 	AS는 생략 가능
FROM salaries
GROUP BY emp_id
;

-- HAVING 절: 그룹화한 집계치에 조건을 부여하고 싶을 때
-- 사원 별 최고 연봉이 5천만원 이상인 사원 조회
SELECT
	emp_id
	,MAX(salary) max_salary
FROM salaries
GROUP BY emp_id
	HAVING MAX(salary) >= 50000000
-- HAVING max_salary >= 50000000 AS로도 사용 가능
;

-- 성별 사원의 수를 조회해 주세요.
SELECT
	gender
	,COUNT(gender) count_gender
FROM employees
GROUP BY gender
;

-- 재직중인 성별 사원의 수를 조회해주세요.
	-- SELECT
	-- 	emp_id
	-- 	,gender
	-- 	,fire_at
	-- FROM employees
	-- WHERE
	-- 	fire_at IS NULL
	-- ;
	-- 재직중인 사람 조회를 먼저 하고,
SELECT
	gender
	,COUNT(gender) count_gender
FROM employees
WHERE
	fire_at IS null
-- 집계와 관련이 없기 때문에 HAVING 아니라 WHERE
GROUP BY gender
;
	-- 그룹화하기
	
-- LIMIT, OFFSET : 출력하는 데이터의 개수를 제한하는 키워드
-- 사원 번호로 오름차순 정렬해서 10개만 조회
SELECT *
FROM employees
ORDER BY emp_id ASC
LIMIT 10 OFFSET 10
-- LIMIT는 쿼리 순서에서 제일 마지막이라 가장 밑에 작성
-- OFFSET은 뒤에 적힌 숫자 다음 거를 가지고 온다고 보면 됨
;

-- 현재 받고 있는 급여 중 사원의 연봉 상위 5명 조회해주세요.
SELECT *
FROM salaries
WHERE
	end_at IS NULL
ORDER BY salary DESC
LIMIT 5
;