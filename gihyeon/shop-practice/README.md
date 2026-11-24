# 쇼핑몰 운영 DB 실무 연습

- 출제: gihyeon
- DB: MySQL 8
- 대용량 데이터 버전 (회원 50 / 상품 32 / 주문 308 / 주문상세 562 / 로그인로그 361)

## 폴더

```
db/01_schema_data_problems.sql   테이블 생성 + 데이터 + 문제 (원본 그대로)
problems.txt                     문제 원문 Q1 ~ Q10
solutions/qNN.sql                풀이
```

## 공통 기준

- 유효 주문: status가 `CANCELED`, `REFUNDED`가 아닌 주문
- 매출 = SUM(quantity * unit_price) - discount_amount (배송비 제외)

## 테이블

| 테이블 | 설명 |
|---|---|
| users | 회원 (grade, status, 추천인 referrer_id) |
| categories | 카테고리 (parent_id로 대분류/소분류) |
| products | 상품 |
| orders | 주문 헤더 (할인액, 배송비) |
| order_items | 주문 상세 |
| login_logs | 로그인 로그 (같은 날 여러 번 가능) |

## 주의할 점

- 주문 헤더의 `discount_amount`를 주문 상세와 JOIN한 뒤 SUM하면 할인액이 중복 차감됩니다 (Q2).
- 대분류/소분류는 `categories` 자기 참조 JOIN이 필요합니다 (Q3).
