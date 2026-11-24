# "A에는 있고 B에는 없다" 패턴

## NOT EXISTS

```sql
SELECT ...
  FROM A a
 WHERE NOT EXISTS (
        SELECT 1
          FROM B b
         WHERE b.CTRT_ID = a.CTRT_ID
       );
```

안쪽 쿼리가 행을 하나라도 찾으면 거짓, 못 찾으면 참이다. `SELECT 1`의 값은 의미 없다.

## LEFT JOIN + IS NULL

```sql
SELECT ...
  FROM A a
  LEFT JOIN B b
    ON b.CTRT_ID = a.CTRT_ID
 WHERE b.CTRT_ID IS NULL;
```

LEFT JOIN은 짝이 없어도 왼쪽 행을 버리지 않고 오른쪽 컬럼을 NULL로 채운다.

## 주의

- B에 거는 조건(월, 코드 등)은 `ON`에 둔다. `WHERE`에 두면 NULL 행이 걸러져서 결과가 0건이 된다.
- NULL 비교는 `= NULL`이 아니라 `IS NULL`이다.
- 두 방법의 결과는 같다. 처음엔 NOT EXISTS가 읽기 쉽다.
