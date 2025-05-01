select * from brands;
select * from products;

ALTER TABLE products ADD PRIMARY KEY (product_id);
ALTER TABLE brands ADD PRIMARY KEY (brand_id);


ALTER TABLE products
ADD CONSTRAINT fk_brand
FOREIGN KEY (brand_id)
REFERENCES brands(brand_id);


select * from products;
select * from categories;

alter table categories add primary key (category_id);

ALTER TABLE products
ADD CONSTRAINT fk_category
FOREIGN KEY (category_id)
REFERENCES categories(category_id);

select * from products;
select * from stocks;

ALTER TABLE stocks
ADD PRIMARY KEY (store_id, product_id);

-- Foreign key from stocks.product_id to products.product_id
ALTER TABLE stocks
ADD CONSTRAINT fk_stocks_product
FOREIGN KEY (product_id) REFERENCES products(product_id);

-- Foreign key from stocks.store_id to stores.store_id
ALTER TABLE stocks
ADD CONSTRAINT fk_stocks_store
FOREIGN KEY (store_id) REFERENCES stores(store_id);

-- orders.customer_id → customers.customer_id
ALTER TABLE orders
ADD CONSTRAINT fk_orders_customer
FOREIGN KEY (customer_id) REFERENCES customers(customer_id);

-- orders.staff_id → staffs.staff_id
ALTER TABLE orders
ADD CONSTRAINT fk_orders_staff
FOREIGN KEY (staff_id) REFERENCES staffs(staff_id);

-- orders.store_id → stores.store_id
ALTER TABLE orders
ADD CONSTRAINT fk_orders_store
FOREIGN KEY (store_id) REFERENCES stores(store_id);

-- order_items.order_id → orders.order_id
ALTER TABLE order_items
ADD CONSTRAINT fk_orderitems_order
FOREIGN KEY (order_id) REFERENCES orders(order_id);

-- order_items.product_id → products.product_id
ALTER TABLE order_items
ADD CONSTRAINT fk_orderitems_product
FOREIGN KEY (product_id) REFERENCES products(product_id);

-- products.category_id → categories.category_id
ALTER TABLE products
ADD CONSTRAINT fk_products_category
FOREIGN KEY (category_id) REFERENCES categories(category_id);

-- products.brand_id → brands.brand_id
ALTER TABLE products
ADD CONSTRAINT fk_products_brand
FOREIGN KEY (brand_id) REFERENCES brands(brand_id);


 
