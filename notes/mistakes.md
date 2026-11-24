# 틀렸던 것 모음

## 1. COUNT(*)와 COUNT(DISTINCT 컬럼)

- `COUNT(*)`는 행 수, `COUNT(DISTINCT CTRT_ID)`는 계약 수다.
- 같은 계약이 여러 행이면 둘이 다르다. (11월 기준 209 대 203)
- 문제에 "계약은 1건으로"라는 말이 있으면 DISTINCT를 쓴다.

## 2. WHERE와 HAVING

- 작성 순서: `SELECT -> FROM -> WHERE -> GROUP BY -> HAVING -> ORDER BY`
- `WHERE`는 묶기 전 행을 거르고, `HAVING`은 묶은 뒤 그룹을 거른다.
- 월 조건 같은 행 조건은 `WHERE`에 쓴다. `HAVING` 뒤에 `WHERE`를 쓰면 에러다.

## 3. 세미콜론

- `;`는 쿼리 맨 끝에만 쓴다.
- `HAVING ...;` 뒤에 `ORDER BY`를 쓰면 별개 문장이 되어 에러가 난다.
- CTE 괄호 안에도 `;`를 쓰지 않는다.

## 4. 정렬 방향

- `ORDER BY CNT`는 오름차순이다. 내림차순은 `DESC`를 붙인다.

## 5. 월을 컬럼으로 펼칠 때

- 한 행에 월별 값을 나란히 보려면 `GROUP BY BILL_YYMM`이 아니라 `COUNT(DISTINCT CASE WHEN ...)`을 쓴다.
- `GROUP BY`가 없으면 전체가 한 그룹이라 1행이 나온다.
- `CASE WHEN`은 `ELSE`를 생략하면 NULL이고, `COUNT`는 NULL을 세지 않는다.
- MariaDB/MySQL의 `IF(조건, 값, NULL)`도 가능하지만 다른 DB에서는 안 된다.

## 6. CTE 문법

- CTE 마지막 `)` 뒤에 쉼표를 쓰지 않는다. 쉼표는 CTE 여러 개를 이을 때만 쓴다.
- `JOIN`에는 `ON`이 필요하다.

## 7. "없다"를 표현할 때

- JOIN만으로는 "없다"를 표현할 수 없다. `NOT EXISTS` 또는 `LEFT JOIN ... IS NULL`을 쓴다.
- LEFT JOIN한 쪽의 조건은 `ON`에 둔다.

## 8. DISTINCT의 범위

- `SELECT DISTINCT a, b`는 a 하나가 아니라 (a, b) 조합 전체에 적용된다.
