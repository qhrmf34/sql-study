# 리브모바일 할인 검증 SQL 연습

- 출제: tomhoon
- DB: MariaDB 10.6+
- 비교월: 202610 / 202611

## 폴더

```
db/01_schema_and_data.sql   테이블 생성 + 연습 데이터 (먼저 실행)
db/tables.md                테이블 설명
problems.txt                문제 원문 10개
solutions/qNN.sql           풀이
```

## 실행 방법

```sql
SOURCE db/01_schema_and_data.sql;
```

`billing_practice` 데이터베이스가 만들어지고 8개 테이블에 연습 데이터가 들어갑니다. 연습용 가짜 데이터이므로 운영 DB에서는 실행하지 마세요.

## 풀이 검증값

| 문제 | 기대 결과 |
|---|---|
| Q01 | CNT = 203 |
| Q02 | 6건 (C0086 ~ C0091, 각 CNT = 2) |
| Q03 | PREV_CNT = 280, CURR_CNT = 203 |
| Q04 | 97건 (NEW 37 / PROD_CHG 25 / PORT_OUT 20 / TERMINATE 15) |
| Q05 | 62건 (Q04에서 TERMINATE, PORT_OUT 제외) |
