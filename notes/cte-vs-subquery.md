# CTE와 서브쿼리

| | 서브쿼리 | CTE |
|---|---|---|
| 형태 | 쿼리 안에 괄호로 끼워 넣음 | `WITH 이름 AS (...)`로 먼저 선언 |
| 읽는 방향 | 안쪽에서 바깥쪽 | 위에서 아래 |
| 같은 결과 재사용 | 같은 코드를 또 써야 함 | 이름으로 여러 번 호출 |

## 문법

```sql
WITH a AS (
    SELECT ... FROM ... GROUP BY ...
),
b AS (
    SELECT ... FROM a ...        -- 앞 CTE를 참조 가능
)
SELECT ... FROM a JOIN b ON ...;
```

- CTE 여러 개는 쉼표로 잇고, 마지막 CTE 뒤에는 쉼표를 쓰지 않는다.
- 괄호 안에 `;`를 쓰지 않는다.
- `WITH`는 쿼리 맨 앞에 온다.
- CTE가 서브쿼리보다 빠른 것은 아니다. 장점은 가독성과 재사용이다.

## 같은 결과를 두 번 쓸 때

```sql
WITH s AS (
    SELECT CTRT_ID, SUM(CHRG_AMT) AS AMT
      FROM CHARGE_TEMP
     WHERE BILL_YYMM = '202611' AND BILL_CYCLE = '01' AND SR_CD = 'SR001'
     GROUP BY CTRT_ID
)
SELECT CTRT_ID, AMT
  FROM s
 WHERE AMT > (SELECT AVG(AMT) FROM s);
```

서브쿼리로 쓰면 `s`의 내용을 두 번 적어야 한다.

## 언제 CTE를 쓰나

- 집계나 중복 제거를 먼저 하고 JOIN해야 할 때
- 같은 중간 결과를 두 번 이상 쓸 때
- 단계가 3개 이상이라 읽기 어려울 때
