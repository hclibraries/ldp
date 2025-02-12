--ldp:function loan_count

SELECT
	ihi.title,
	ie.barcode,
	ie.effective_location_name,
	ie.effective_call_number,
	ie.volume,
	ie.enumeration,
	ie.item_hrid,
	status__name,
	status__date,
	ie.updated_date
FROM public.inventory_items AS ii
LEFT JOIN folio_reporting.items_holdings_instances AS ihi ON ii.id = ihi.item_id
LEFT JOIN folio_reporting.item_ext AS ie ON ii.id = ie.item_id
WHERE Status__name ~ '.*issing.*' OR Status__name ~ '.*ost.*'
