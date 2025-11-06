-- DB 생성하는 법
CREATE DATABASE mydb; -- <= DATABASE = 키워드

-- DB 선택하는 방법
USE mydb;

-- DB 삭제
DROP DATABASE mydb;

-- 스키마 : CREATE-생성, ALTER-수정, DROP-삭제

-- -----------
-- 테이블 생성
-- -----------
CREATE TABLE users( -- 소괄호 안에 테이블 지정
	id BIGINT UNSIGNED PRIMARY KEY AUTO_INCREMENT -- 컬럼명 /  데이터 타입(갈색) / 제약 조건(파란색)
-- UNSIGNED는 양수만 가능(1~)
	,`name` VARCHAR(50) NOT NULL COMMENT '이름'
-- COMMENT = 컬럼에 대한 설명을 적어둘 수 있음
	,gender CHAR(1) NOT NULL COMMENT 'F=여자, M=남자, N=선택 안함(대문자로 적을 것)'
	,created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP()
-- CURRENT_TIMESTAMP를 넣으면 레코드가 생성되는 시간을 현재 시간으로 자동으로 넣음
	,updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP()
	,deleted_at DATETIME
);

-- 게시글 테이블 만들기
-- 필요한 컬럼 : pk, 유저 번호, 제목, 내용, 작성일, 수정일, 삭제일
CREATE TABLE posts(
	id BIGINT UNSIGNED PRIMARY KEY AUTO_INCREMENT
	,user_id BIGINT UNSIGNED NOT NULL -- <= 참조할 테이블명에서 단수 형태로 접두에 붙임. 참조할 컬럼의 데이터 타입이랑 같아야 함.
	,title VARCHAR(50) NOT NULL
	,content VARCHAR(1000) NOT NULL
	,created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP()
	,updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP()
	,deleted_at DATETIME
);

-- -----------
-- 테이블 수정
-- -----------
-- posts의 user_id가 users의 id를 참조하고 있는 관계
-- 이럴 때 fk를 주면 이상한 데이터 생성을 막을 수 있음
/* FK 추가 방법
	ALTER TABLE [테이블명]
	ADD CONSTRAINT [Contraint명]
	FOREIGN KEY [Contraint 부여 컬럼명)
	REFERENCES 참조테이블명(참조테이블 컬럼명)
	[ON DELETE 동작/ ON UPDATE 동작];
*/
ALTER TABLE posts
	ADD CONSTRAINT fk_posts_user_id
-- ADD = 스키마 추가 / CONSTRAINT = 제약 조건 / fk_posts_user_id = 제약조건 종류_테이블명_컬럼명(키워드 아님, 관습적인 명령 규칙)
	FOREIGN KEY (user_id)
	REFERENCES users(id) -- <= 참조할 테이블명(컬럼명)
-- 	ON DELETE CASCADED <= users의 id가 삭제될 때 posts의 유저가 쓴 글도 같이 삭제
;
-- FK 삭제
ALTER TABLE posts
DROP CONSTRAINT fk_posts_user_id
-- 이름을 가져오기 때문에 이름 중요
;

-- ---------
-- 컬럼 추가
-- ---------
ALTER TABLE posts
	ADD COLUMN image VARCHAR(100)
-- 	이미지나 영상은 보통 외부에 원본을 저장해놓고 저장 경로를 문자열로 가져옴
;

-- 컬럼 제거
ALTER TABLE posts
DROP COLUMN image
;

-- 컬럼 수정
ALTER TABLE users
MODIFY COLUMN gender VARCHAR(10) NOT NULL COMMENT '남자, 여자, 선택 안함'
;

-- ----------------------
-- AUTO_INCREMENT 값 변경
-- ----------------------
ALTER TABLE users AUTO_INCREMENT = 10;

-- -----------
-- 테이블 삭제
-- -----------
DROP TABLE posts;
DROP TABLE users;

-- -------------------------
-- 테이블의 모든 데이터 삭제
-- -------------------------
TRUNCATE TABLE salaries;
