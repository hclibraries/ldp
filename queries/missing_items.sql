--ldp:function missing_items

DROP FUNCTION IF EXISTS missing_items;

CREATE FUNCTION missing_items()
RETURNS TABLE(
    title TEXT,
    barcode TEXT,
    effective_location_name TEXT,
    effective_call_number TEXT,
    volume TEXT,
    enumeration TEXT,
    item_hrid TEXT,
    status_name TEXT,
    status_date TIMESTAMP,
    updated_date TIMESTAMP
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
    ie.status__name AS status_name,
    ie.status__date AS status_date,
    ie.updated_date
FROM folio_reporting.items_holdings_instances AS ihi
LEFT JOIN folio_reporting.item_ext AS ie ON ihi.item_id = ie.item_id
WHERE ie.status__name ~* 'missing|lost'
$$
LANGUAGE SQL
STABLE
PARALLEL SAFE;
