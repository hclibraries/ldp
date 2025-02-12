--ldp:function missing_items

DROP FUNCTION IF EXISTS missing_items;

CREATE FUNCTION missing_items(start_date DATE DEFAULT'2000-01-01', 
                              end_date DATE DEFAULT '2050-01-01')
RETURNS TABLE(
    title TEXT,
    barcode TEXT,
    effective_location_name TEXT,
    effective_call_number TEXT,
    volume TEXT,
    enumeration TEXT,
    item_hrid TEXT,
    status_name TEXT,
    status_date DATE,
    updated_date DATE
) AS
$$
SELECT
    ihi.title,
    ie.barcode,
    ie.effective_location_name,
    ie.effective_call_number,
    ie.volume,
    ie.enumeration,
    ie.item_hrid,
    ie.status_name AS status_name,
    ie.status_date::DATE AS status_date,
    ie.updated_date::DATE
FROM folio_reporting.items_holdings_instances AS ihi
LEFT JOIN folio_reporting.item_ext AS ie ON ihi.item_id = ie.item_id
WHERE ie.status_name ~* 'missing|lost'
AND ie.status_date BETWEEN start_date AND end_date
$$
LANGUAGE SQL
STABLE
PARALLEL SAFE;
