-- Q02. 계약별 할인코드 중복 확인
-- 핵심: WHERE(묶기 전 행 거르기) -> GROUP BY -> HAVING(묶은 뒤 그룹 거르기) -> ORDER BY
-- 검증: 같은 계약이 11월에 2행 이상인 계약만 나옴 (CNT = 2)

SELECT CTRT_ID
     , COUNT(*) AS CNT
  FROM KB_DISCOUNT_INFO
 WHERE BILL_YYMM = '202611'
 GROUP BY CTRT_ID
HAVING COUNT(*) >= 2
 ORDER BY CNT DESC;
