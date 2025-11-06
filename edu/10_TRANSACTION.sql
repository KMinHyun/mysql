-- TRANSACTION

-- 트랜잭션 시작
START TRANSACTION;

-- INSERT
INSERT INTO employees (`name`, birth, gender, hire_at)
VALUES ('김민현', '2000-01-01', 'M', DATE(NOW()))
;

-- SELECT
SELECT * FROM employees WHERE `name` = '김민현';

-- ROLLBACK(실패 트랜잭션 종료)
ROLLBACK;

-- COMMIT(성공 트랜잭션 종료)
COMMIT;