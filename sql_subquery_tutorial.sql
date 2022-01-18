USE magist;

# Select all the products from the health_beauty or perfumery categories that
# have been paid by credit card with a payment amount of more than 1000$,
# from orders that were purchased during 2018 and have a ‘delivered’ status?
SELECT * FROM products p
WHERE p.product_id IN (SELECT oi.product_id FROM order_items oi
						WHERE oi.order_id IN (SELECT op.order_id FROM order_payments op
								JOIN orders o ON op.order_id = o.order_id
								WHERE op.payment_type = 'credit_card' AND op.payment_value >= 1000
								AND o.order_status = 'delivered' AND YEAR(o.order_purchase_timestamp) = 2018))
AND p.product_category_name IN
	(SELECT pcnt.product_category_name FROM product_category_name_translation pcnt
	WHERE pcnt.product_category_name_english IN ('health_beauty', 'perfumery'));
# For the products that you selected, get the following information:
# The average weight of those products
SELECT p.product_id, AVG(p.product_weight_g) FROM products p
WHERE p.product_id IN (SELECT oi.product_id FROM order_items oi
						WHERE oi.order_id IN (SELECT op.order_id FROM order_payments op
								JOIN orders o ON op.order_id = o.order_id
								WHERE op.payment_type = 'credit_card' AND op.payment_value >= 1000
								AND o.order_status = 'delivered' AND YEAR(o.order_purchase_timestamp) = 2018))
AND p.product_category_name IN
	(SELECT pcnt.product_category_name FROM product_category_name_translation pcnt
	WHERE pcnt.product_category_name_english IN ('health_beauty', 'perfumery'))
    GROUP BY p.product_id;
# The cities where there are sellers that sell those products
SELECT g.city FROM geo g
JOIN sellers s ON g.zip_code_prefix = s.seller_zip_code_prefix
WHERE seller_id IN
	(SELECT seller_id FROM order_items
	WHERE product_id IN
		(SELECT product_id FROM products p
		WHERE p.product_id IN (SELECT oi.product_id FROM order_items oi
								WHERE oi.order_id IN (SELECT op.order_id FROM order_payments op
										JOIN orders o ON op.order_id = o.order_id
										WHERE op.payment_type = 'credit_card' AND op.payment_value >= 1000
										AND o.order_status = 'delivered' AND YEAR(o.order_purchase_timestamp) = 2018))
		AND p.product_category_name IN
			(SELECT pcnt.product_category_name FROM product_category_name_translation pcnt
			WHERE pcnt.product_category_name_english IN ('health_beauty', 'perfumery'))));
# The cities where there are customers who bought products
SELECT g.city FROM geo g
JOIN customers c ON g.zip_code_prefix = c.customer_zip_code_prefix
WHERE c.customer_id IN
	(SELECT customer_id FROM orders
	WHERE order_id IN
		(SELECT order_id FROM order_items
        WHERE product_id IN
			(SELECT product_id FROM products p
			WHERE p.product_id IN (SELECT oi.product_id FROM order_items oi
									WHERE oi.order_id IN (SELECT op.order_id FROM order_payments op
											JOIN orders o ON op.order_id = o.order_id
											WHERE op.payment_type = 'credit_card' AND op.payment_value >= 1000
											AND o.order_status = 'delivered' AND YEAR(o.order_purchase_timestamp) = 2018))
			AND p.product_category_name IN
				(SELECT pcnt.product_category_name FROM product_category_name_translation pcnt
				WHERE pcnt.product_category_name_english IN ('health_beauty', 'perfumery')))));