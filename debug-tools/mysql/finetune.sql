explain select stock_id, exchange_date, close, trade_shares from daily_closes
where exchange_date >= '20231120' and exchange_date < '20240522' and stock_id IN ('2331','2476','2812','4938','6190','2464','6706','2393','5876','6229','2105','6191','1402','4915','2883','2886','2881','2392','2007','6147','3014','2359','6415','1815','3450','2845','3711','2312','9105','2892','2887','2615','3260','3042','2303','2330','5608','2891','2354','9921','4127','3037','4904','6209','2880','2362','3045','3714','2609','6117','2376','2328','2365','2313','5880','5483','6005','1560','2889','2882','2454','2888','1216','2353','2605','2412','3540') order by stock_id, exchange_date desc;

CREATE INDEX idx_stock_id_exchange_date_desc ON daily_closes (stock_id, exchange_date DESC);


explain WITH RankedCloses AS (
  SELECT
    stock_id,
    close,
    exchange_date,
    ROW_NUMBER() OVER (
    PARTITION BY stock_id ORDER BY exchange_date DESC) AS rn
    FROM
      daily_closes
    WHERE
      stock_id IN ('2603','2449','2363','2609','1609','5009')                       
 )                                         
 SELECT
    stock_id,
    close,
    exchange_date
  FROM
    RankedCloses
  WHERE
    rn = 1;

CREATE INDEX idx_covering ON daily_closes (stock_id, exchange_date, close);


explain select stock_id, max(high) as high from daily_closes where exchange_date >= '20231120' and exchange_date < '20240313' and stock_id IN ('1102','1104','1216','1319','1402','1455','1503','1504','1524','1605','1608','1616','2009','2025','2105','2204','2241','2303','2313','2316','2317','2323','2347','2379','2382','2385','2471','2486','2501','2504','2515','2606','2611','2637','2801','2812','2855','2867','2880','2881','2883','2884','2885','2886','2889','2890','2891','3014','3042','3050','3207','3264','3413','3548','3563','3564','3596','3706','4766','4909','4915','4938','4961','5347','5443','5515','5876','6005','6016','6026','6147','6176','6190','6223','6230','6239','6257','6285','6288','6462','6668','8016','8069','8086','8150','8996','9904') group by stock_id;

CREATE INDEX idx_covering_high ON daily_closes (stock_id, exchange_date, high);

