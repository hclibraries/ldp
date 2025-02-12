--ldp:function missing_lost_items

DROP FUNCTION IF EXISTS missing_lost_items;

CREATE FUNCTION missing_lost_items()
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
FROM public.inventory_items AS ii
LEFT JOIN folio_reporting.items_holdings_instances AS ihi ON ii.id = ihi.item_id
LEFT JOIN folio_reporting.item_ext AS ie ON ii.id = ie.item_id
WHERE ie.status__name ~ '.*issing.*' OR ie.status__name ~ '.*ost.*'
$$
LANGUAGE SQL
STABLE
PARALLEL SAFE;
