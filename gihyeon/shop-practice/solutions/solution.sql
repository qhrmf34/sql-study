/* ==========================================================
   SQL 실무 연습 문제 - 쇼핑몰 운영 DB
   기준 DB : MySQL 8 (다른 DB는 날짜 함수 등만 조금 수정)
   사용법  : 1) 아래 [1. 테이블 생성] ~ [2. 데이터 입력]을 먼저 실행
             2) [3. 문제]를 보고 쿼리 작성

   공통 기준
   - "유효 주문" = status 가 'CANCELED', 'REFUNDED' 가 아닌 주문
   - 별도 언급이 없으면
       매출 = SUM(quantity * unit_price) - discount_amount
       (배송비 shipping_fee 는 매출에서 제외)
   ========================================================== */


/* ==========================================================
   1. 테이블 생성
   ========================================================== */
show
databases;
use
liv;
DROP TABLE IF EXISTS login_logs;
DROP TABLE IF EXISTS order_items;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS categories;
DROP TABLE IF EXISTS users;

-- 회원
CREATE TABLE users
(
    user_id     INT         NOT NULL PRIMARY KEY,
    user_name   VARCHAR(50) NOT NULL,
    grade       VARCHAR(10) NOT NULL, -- VIP / GOLD / SILVER
    signup_date DATE        NOT NULL,
    status      VARCHAR(10) NOT NULL, -- ACTIVE / DORMANT / WITHDRAWN
    referrer_id INT NULL,             -- 추천인 user_id
    FOREIGN KEY (referrer_id) REFERENCES users (user_id)
);

-- 카테고리 (parent_id 로 대분류 - 소분류 구조)
CREATE TABLE categories
(
    category_id   INT         NOT NULL PRIMARY KEY,
    category_name VARCHAR(50) NOT NULL,
    parent_id     INT NULL,
    FOREIGN KEY (parent_id) REFERENCES categories (category_id)
);

-- 상품
CREATE TABLE products
(
    product_id   INT          NOT NULL PRIMARY KEY,
    product_name VARCHAR(100) NOT NULL,
    category_id  INT          NOT NULL,
    price        INT          NOT NULL,
    stock        INT          NOT NULL,
    is_active    CHAR(1)      NOT NULL, -- Y / N
    FOREIGN KEY (category_id) REFERENCES categories (category_id)
);

-- 주문 (헤더)
CREATE TABLE orders
(
    order_id        INT         NOT NULL PRIMARY KEY,
    user_id         INT         NOT NULL,
    order_date      DATETIME    NOT NULL,
    status          VARCHAR(10) NOT NULL,           -- PAID / SHIPPED / DELIVERED / CANCELED / REFUNDED
    coupon_id       INT NULL,                       -- NULL 이 아니면 쿠폰 사용
    discount_amount INT         NOT NULL DEFAULT 0, -- 주문 단위 할인액
    shipping_fee    INT         NOT NULL DEFAULT 0,
    FOREIGN KEY (user_id) REFERENCES users (user_id)
);

-- 주문 상세
CREATE TABLE order_items
(
    order_id   INT NOT NULL,
    product_id INT NOT NULL,
    quantity   INT NOT NULL,
    unit_price INT NOT NULL, -- 구매 시점 단가
    PRIMARY KEY (order_id, product_id),
    FOREIGN KEY (order_id) REFERENCES orders (order_id),
    FOREIGN KEY (product_id) REFERENCES products (product_id)
);

-- 로그인 로그 (같은 날 여러 번 로그인 가능)
CREATE TABLE login_logs
(
    log_id   INT      NOT NULL PRIMARY KEY,
    user_id  INT      NOT NULL,
    login_at DATETIME NOT NULL,
    FOREIGN KEY (user_id) REFERENCES users (user_id)
);


/* ==========================================================
   2. 데이터 입력
   ========================================================== */

INSERT INTO users (user_id, user_name, grade, signup_date, status, referrer_id)
VALUES (1, '김지훈', 'VIP', '2024-01-10', 'ACTIVE', NULL),
       (2, '이수진', 'GOLD', '2024-02-15', 'ACTIVE', 1),
       (3, '박준영', 'SILVER', '2024-05-03', 'ACTIVE', 1),
       (4, '최민아', 'SILVER', '2024-08-21', 'DORMANT', 2),
       (5, '정우성', 'GOLD', '2025-01-09', 'ACTIVE', 3),
       (6, '한예슬', 'SILVER', '2025-02-14', 'WITHDRAWN', NULL);

INSERT INTO categories (category_id, category_name, parent_id)
VALUES (1, '전자기기', NULL),
       (2, '노트북', 1),
       (3, '액세서리', 1),
       (4, '생활용품', NULL);

INSERT INTO products (product_id, product_name, category_id, price, stock, is_active)
VALUES (101, '게이밍 노트북', 2, 1500000, 12, 'Y'),
       (102, '사무용 노트북', 2, 900000, 0, 'Y'),
       (103, '무선 마우스', 3, 35000, 150, 'Y'),
       (104, '기계식 키보드', 3, 120000, 40, 'Y'),
       (105, '텀블러', 4, 18000, 300, 'Y'),
       (106, '단종 모니터', 1, 300000, 5, 'N');

INSERT INTO orders (order_id, user_id, order_date, status, coupon_id, discount_amount, shipping_fee)
VALUES (5001, 1, '2025-01-12 10:20:00', 'DELIVERED', NULL, 0, 0),
       (5002, 2, '2025-01-25 14:05:00', 'DELIVERED', 1, 5000, 3000),
       (5003, 1, '2025-02-03 09:40:00', 'REFUNDED', NULL, 0, 0),
       (5004, 3, '2025-02-14 20:11:00', 'DELIVERED', NULL, 0, 3000),
       (5005, 2, '2025-02-28 23:50:00', 'CANCELED', NULL, 0, 3000),
       (5006, 5, '2025-03-02 11:30:00', 'DELIVERED', 1, 5000, 0),
       (5007, 1, '2025-03-15 16:45:00', 'SHIPPED', NULL, 0, 0),
       (5008, 2, '2025-03-20 13:00:00', 'PAID', NULL, 0, 3000);

INSERT INTO order_items (order_id, product_id, quantity, unit_price)
VALUES (5001, 101, 1, 1500000),
       (5001, 103, 1, 35000),
       (5002, 105, 3, 18000),
       (5002, 103, 2, 35000),
       (5003, 104, 1, 120000),
       (5004, 103, 1, 35000),
       (5004, 105, 2, 18000),
       (5005, 102, 1, 900000),
       (5006, 104, 2, 120000),
       (5006, 105, 1, 18000),
       (5007, 101, 1, 1500000),
       (5008, 103, 1, 35000);

INSERT INTO login_logs (log_id, user_id, login_at)
VALUES (1, 1, '2025-03-01 09:00:00'),
       (2, 1, '2025-03-01 18:30:00'),
       (3, 1, '2025-03-02 09:10:00'),
       (4, 1, '2025-03-03 08:55:00'),
       (5, 2, '2025-03-01 10:00:00'),
       (6, 2, '2025-03-03 10:05:00'),
       (7, 3, '2025-03-02 21:00:00'),
       (8, 5, '2025-03-01 12:00:00'),
       (9, 5, '2025-03-02 12:10:00'),
       (10, 5, '2025-03-03 12:20:00'),
       (11, 5, '2025-03-04 12:30:00');


/* ==========================================================
   3. 문제 (아래에 쿼리를 직접 작성해보세요)
   ========================================================== */

/* ----------------------------------------------------------
   Q1. [CRM팀] 휴면 전환 예정 회원 추출
   "ACTIVE 회원 중 마지막 로그인이 2025-03-03 이전이거나,
    로그인 기록이 아예 없는 회원을 뽑아주세요.
    회원명과 마지막 로그인 일시(없으면 NULL)가 필요합니다."
   ---------------------------------------------------------- */
select u.user_name
     , MAX(ll.login_at)
from users u
         left join login_logs ll
                   on u.user_id = ll.user_id
                       and u.status = 'ACTIVE'
where 1 = 1
  AND (ll.user_id is null
    OR login_at <= '2025-03-03')
group by user_name
;

/* ----------------------------------------------------------
   Q2. [재무팀] 월별 순매출 리포트
   "유효 주문 기준으로 월별(YYYY-MM) 주문 건수와 순매출을 뽑아주세요."
   (힌트: 헤더의 discount_amount 를 상세와 조인한 뒤 SUM 하면
          할인액이 중복 차감됩니다. 이 함정을 피해야 합니다.)
   ---------------------------------------------------------- */
select DATE_FORMAT(order_date, '%Y%m') as '월'
     , SUM(unit_price * quantity - discount_amount) as '순매출'
     , COUNT(1) as '주문건수'
from orders o
         join order_items oi
              on o.order_id = oi.order_id
group by DATE_FORMAT(order_date, '%Y%m')
;

select *
from order_items;

select *
from categories;

select *
from products;


/* ----------------------------------------------------------
   Q3. [상품팀] 대분류 카테고리별 판매 현황
   "소분류가 아니라 대분류(전자기기, 생활용품) 기준으로
    유효 주문의 판매 수량과 매출(수량 x 단가)을 보여주세요.
    소분류 없이 대분류에 직접 걸린 상품도 포함해야 합니다."
   ---------------------------------------------------------- */
select *
from order_items;
select *
from products;
select *
from categories;

select c1.category_id
     , CASE WHEN c1.parent_id IS NOT NULL THEN c2.category_name ELSE c1.category_name END as categroy_name
from categories c1
         left join categories c2
                   on c1.parent_id = c2.category_id
;

with t_categories as (select c1.category_id
                           , CASE
                                 WHEN c1.parent_id IS NOT NULL THEN c2.category_name
                                 ELSE c1.category_name END as category_name
                      from categories c1
                               left join categories c2
                                         on c1.parent_id = c2.category_id)
select c.category_name as '대분류명'
     , sum(oi.quantity) as '판매수량'
     , sum(oi.unit_price * oi.quantity) as '매출'
from orders o
         join order_items oi on o.order_id = oi.order_id
         join products p on oi.product_id = p.product_id
         join t_categories c on p.category_id = c.category_id
where 1 = 1
  and o.status not in ('CANCELED', 'REFUNDED')
  and p.is_active = 'Y'
  and p.stock > 0
group by c.category_name
;

select *
from categories;

select *
from products;


/* ----------------------------------------------------------
   Q4. [MD팀] 판매 이력이 없는 활성 상품
   "판매 중(is_active='Y')인데 유효 주문 기준으로 한 번도
    팔리지 않은 상품을 찾아주세요.
    취소된 주문에만 있던 상품도 '안 팔린 것'으로 봅니다."
   ---------------------------------------------------------- */
select *
from order_items;
select *
from products p
         left join order_items oi on p.product_id = oi.product_id
         left join orders o on oi.order_id = o.order_id
where true
  and p.is_active = 'Y'
  and (oi.product_id is null or o.status = 'CANCELED')
;

/* ----------------------------------------------------------
   Q5. [CRM팀] 회원별 첫 구매 정보
   "유효 주문이 있는 회원별로 첫 구매일, 첫 구매 주문번호,
    그 주문의 상품금액 합계를 뽑아주세요."
   ---------------------------------------------------------- */
with t_summary as (
    select u.user_id
    , u.user_name
    , min(o.order_date) as '첫 구매일'
    , min(o.order_id) as '첫 구매 주문번호'
    , SUM(oi.unit_price * oi.quantity) as '상품금액 합계'
    , ROW_NUMBER() over (
        partition by u.user_id
        order by o.order_id
    ) as rn
    from order_items oi
            join orders o on oi.order_id = o.order_id
            join products p on oi.product_id = p.product_id
            join users u on o.user_id = u.user_id
    where true
    and p.is_active = 'Y'
    group by u.user_id, o.order_id
)
select *
from t_summary
where rn = 1
;
select o.*
from order_items oi
            join orders o on oi.order_id = o.order_id
            join products p on oi.product_id = p.product_id
            join users u on o.user_id = u.user_id
    where true
    and p.is_active = 'Y'
    and o.status != 'CANCELED'
;
/* ----------------------------------------------------------
   Q6. [마케팅팀] 재구매율
   "유효 주문이 1건 이상인 회원 중 2건 이상인 회원의 비율(%)을
    소수점 첫째 자리까지 구해주세요."
   ---------------------------------------------------------- */
with t_over2 as (select distinct u.user_id
                 from order_items oi
                          join orders o on oi.order_id = o.order_id
                          join users u on o.user_id = u.user_id
                          join products p on oi.product_id = p.product_id
                 group by u.user_id
                 having count(o.order_id) > 2)
   , t_over1 as (select distinct u.user_id
                 from order_items oi
                          join orders o on oi.order_id = o.order_id
                          join users u on o.user_id = u.user_id
                          join products p on oi.product_id = p.product_id
                 where true
                   and p.is_active = 'Y'
                   and o.status NOT IN ('CANCELED', 'REFUNDED'))
select (select count(*) from t_over2) / (select count(*) from t_over1) * 100
;
;



/* ----------------------------------------------------------
   Q7. [경영지원] 월별 매출 전월 대비 증감률
   "Q2 결과에 전월 순매출과 전월 대비 증감률(%)을 붙여주세요.
    첫 달은 전월이 없으니 NULL 이어도 됩니다."
   ---------------------------------------------------------- */


/* ----------------------------------------------------------
   Q8. [그로스팀] 3일 이상 연속 로그인 회원
   "서로 다른 날짜 기준으로 3일 이상 연속 로그인한 회원과
    최대 연속 일수를 알려주세요.
    하루에 여러 번 로그인한 건은 1일로 칩니다."
   ---------------------------------------------------------- */


/* ----------------------------------------------------------
   Q9. [마케팅팀] 추천인 성과 분석
   "추천인별로 추천 가입자 수, 그중 유효 주문이 있는
    가입자 수를 뽑아주세요.
    추천 실적이 있는 추천인만 나오게 하고,
    추천 가입자 수가 많은 순으로 정렬해주세요."
   ---------------------------------------------------------- */


/* ----------------------------------------------------------
   Q10. [운영팀] 월별 주문 상태 현황 (피벗)
   "월별로 PAID, SHIPPED, DELIVERED, CANCELED, REFUNDED 건수를
    가로 컬럼으로 펼치고, 마지막에
    (CANCELED + REFUNDED) / 전체 건수로 계산한 이탈률(%)도 붙여주세요."
   ---------------------------------------------------------- */
select date_format(o.order_date, '%Y%m')
     , SUM(
        CASE WHEN o.status = 'PAID' THEN 1 ELSE 0 END
       )                  as PAID
     , SUM(
        CASE WHEN o.status = 'SHIPPED' THEN 1 ELSE 0 END
       )                  as SHIPPED
     , SUM(
        CASE WHEN o.status = 'DELIVERED' THEN 1 ELSE 0 END
       )                  as DELIVERED
     , SUM(
        CASE WHEN o.status = 'CANCELED' THEN 1 ELSE 0 END
       )                  as CANCELED
     , SUM(
        CASE WHEN o.status = 'REFUNDED' THEN 1 ELSE 0 END
       )                  as REFUNDED
     , SUM(
               CASE WHEN o.status IN ('CANCELED', 'REFUNDED') THEN 1 ELSE 0 END
       ) / COUNT(*) * 100 as 이탈률
from orders o
group by date_format(o.order_date, '%Y%m')
;

;


