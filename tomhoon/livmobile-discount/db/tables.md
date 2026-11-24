# 테이블 설명

통신사 요금 계산에서 "할인을 받아야 할 사람이 빠짐없이 할인을 받았는가"를 검증하는 구조입니다.
모든 테이블은 `CTRT_ID`(계약 번호)로 연결됩니다.

## 한눈에 보기

| 테이블 | 쉽게 말하면 | 건수 | 쓰는 문제 |
|---|---|---|---|
| CTRT_INFO | 계약자 명부 (계약 1건 = 1행) | 300 | 04, 05, 10 |
| PRODUCT_INFO | 요금제 목록 | 6 | - |
| DISCOUNT_POLICY | 할인 종류 목록 | 5 | - |
| CTRT_CHANGE_HIST | 계약 변경 기록 (상품변경, 해지 등) | 60 | 06, 10 |
| KB_DISCOUNT_INFO | 월별 할인 대상 명단 | - | 01~06, 08, 10 |
| DISCOUNT_RESULT | 할인 실제 계산 결과 | 약 480 | 08, 09 |
| CHARGE_TEMP | 가매출(미리보기)과 정기청구 | 약 2,040 | 07 |
| BILL | 최종 청구서 | 약 1,490 | 09 |

## 주요 컬럼

### CTRT_INFO

| 컬럼 | 의미 | 값 |
|---|---|---|
| CTRT_ID | 계약 번호 (PK) | C0001 |
| PROD_CD | 현재 요금제 | 1088 |
| ORDER_TP | 마지막 처리 유형 | NEW 신규 / PROD_CHG 상품변경 / TERMINATE 해지 / PORT_OUT 포트아웃 |
| CTRT_STATUS | 현재 상태 | ACTIVE / CLOSED |

### CTRT_CHANGE_HIST

| 컬럼 | 의미 |
|---|---|
| CTRT_ID | 계약 번호 (한 계약에 여러 행 가능) |
| CHANGE_DT | 변경일 |
| ORDER_TP | PROD_CHG / TERMINATE / PORT_OUT |
| BEFORE_PROD_CD, AFTER_PROD_CD | 변경 전후 요금제 |

### KB_DISCOUNT_INFO

| 컬럼 | 의미 |
|---|---|
| CTRT_ID | 계약 번호 |
| BILL_YYMM | 대상 월 (202610, 202611) |
| FTCR_CD | 할인코드 (FT_STAR 등) |

같은 계약이 같은 달에 여러 행일 수 있습니다. 할인이 여러 개이거나 같은 행이 중복 적재된 경우입니다.
계약 수를 셀 때는 `COUNT(DISTINCT CTRT_ID)`를 써야 합니다.

### CHARGE_TEMP

| 컬럼 | 의미 | 값 |
|---|---|---|
| BILL_CYCLE | 청구 종류 | 02 가매출 / 01 정기청구 |
| SR_CD | 요금 항목 | SR001 기본료 / SR_DISC 할인 / SR_USAGE 사용료 |
| CHRG_AMT | 금액 | SR_DISC는 음수 |

### DISCOUNT_RESULT

| 컬럼 | 의미 |
|---|---|
| DISC_AMT | 계산된 할인액 (양수) |
| CALC_STATUS | 계산 상태 (전부 SUCCESS) |

### BILL

| 컬럼 | 의미 |
|---|---|
| SR_CD | SR001 / SR_DISC / SR_USAGE |
| BILL_AMT | 금액 (SR_DISC는 음수) |

문제 09에서 `DISCOUNT_RESULT.DISC_AMT`(양수)와 `BILL.BILL_AMT`(음수)를 비교할 때 부호를 맞춰야 합니다.

## 연결 관계

```
CTRT_INFO (CTRT_ID) ─┬─ CTRT_CHANGE_HIST
                     ├─ KB_DISCOUNT_INFO
                     ├─ DISCOUNT_RESULT
                     ├─ CHARGE_TEMP
                     └─ BILL

PRODUCT_INFO.PROD_CD    <- CTRT_INFO.PROD_CD
DISCOUNT_POLICY.FTCR_CD <- KB_DISCOUNT_INFO / DISCOUNT_RESULT 의 FTCR_CD
```

## 월 업무 흐름

1. 할인 대상 등록: KB_DISCOUNT_INFO
2. 할인액 계산: DISCOUNT_RESULT
3. 가매출과 정기청구 생성: CHARGE_TEMP
4. 최종 청구서 발행: BILL

각 단계에서 값이 맞는지 확인하는 것이 이 문제 세트의 목적입니다.
