# sql-study

SQL 연습 문제와 풀이 기록 저장소입니다.

## 구성

| 폴더 | 내용 | DB | 출제 |
|---|---|---|---|
| [tomhoon/livmobile-discount](tomhoon/livmobile-discount) | 리브모바일 할인 검증 문제 10개 | MariaDB 10.6+ | tomhoon |
| [gihyeon/shop-practice](gihyeon/shop-practice) | 쇼핑몰 운영 DB 실무 문제 10개 | MySQL 8 | gihyeon |
| [notes](notes) | 개념 정리와 틀렸던 것 모음 | - | - |

## 사용 방법

1. 문제 폴더의 `db/` 아래 SQL 파일을 먼저 실행해서 테이블과 데이터를 만듭니다.
2. `problems.txt`를 보고 직접 풀어 봅니다.
3. 풀이는 `solutions/qNN.sql`에 저장합니다.

## 진행 현황

### tomhoon / livmobile-discount

| 문제 | 상태 | 핵심 개념 |
|---|---|---|
| Q01 | 완료 | COUNT(DISTINCT) |
| Q02 | 완료 | GROUP BY, HAVING |
| Q03 | 완료 | 조건부 집계 (CASE WHEN) |
| Q04 | 완료 | CTE, NOT EXISTS / LEFT JOIN IS NULL |
| Q05 | 예정 | |
| Q06 | 예정 | |
| Q07 | 예정 | |
| Q08 | 예정 | |
| Q09 | 예정 | |
| Q10 | 예정 | |

### gihyeon / shop-practice

| 문제 | 상태 |
|---|---|
| Q1 ~ Q10 | 예정 |

## 커밋 규칙

문제 하나를 풀 때마다 커밋합니다. 예: `Q03 풀이: 조건부 집계로 한 행 출력`
