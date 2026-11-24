-- ==================================================
-- [문제 07] 가매출과 정기청구 금액 비교 (중급)
-- ==================================================

-- 2026년 11월 가매출과 정기청구의
-- 기본료 금액이 일치하지 않는 계약을 찾아라.

-- 사용 테이블:
-- - CHARGE_TEMP

-- 조건:
-- 1. BILL_YYMM = '202611'
-- 2. BILL_CYCLE = '02'는 가매출
-- 3. BILL_CYCLE = '01'은 정기청구
-- 4. 기본료 SR001 대상
-- 5. 계약별 금액 합산 후 비교
-- 6. 두 주기의 데이터가 모두 존재하는 계약만 비교
-- 7. 금액이 다른 계약만 출력

-- 출력:
-- CTRT_ID, TEMP_AMT, REG_AMT, DIFF_AMT

-- DIFF_AMT = REG_AMT - TEMP_AMT

WITH A AS (
	SELECT 
		   CTRT_ID
		 , BILL_CYCLE
		 , CHRG_AMT
      FROM CHARGE_TEMP
     WHERE BILL_YYMM = '202611'
       AND SR_CD = 'SR001'
),
A01 AS (
	SELECT 
		   CTRT_ID
		 , SUM(CHRG_AMT) REG_AMT
      FROM A
     WHERE BILL_CYCLE = '01'
     GROUP BY CTRT_ID
),
A02 AS (
	SELECT 
		   CTRT_ID
		 , SUM(CHRG_AMT) TEMP_AMT
      FROM A
     WHERE BILL_CYCLE = '02'
     GROUP BY CTRT_ID
)
SELECT
	   A01.CTRT_ID
	 , A02.TEMP_AMT
	 , A01.REG_AMT
	 , (A01.REG_AMT-A02.TEMP_AMT) DIFF_AMT
  FROM A01
  JOIN A02
    ON A01.CTRT_ID = A02.CTRT_ID
 WHERE A01.REG_AMT != A02.TEMP_AMT;