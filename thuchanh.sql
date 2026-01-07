create database session08_th2;
use session08_th2;

create table customers(
	customer_id int auto_increment primary key,
    customer_name varchar(100) not null,
    email varchar(100) not null unique,
    phone varchar(10) not null unique
);

create table categories(
	category_id int auto_increment primary key,
    category_name varchar(255) not null
);

create table products(
	product_id int auto_increment primary key,
    product_name varchar(255) not null unique,
    price decimal(10,2) check (price > 0),
	category_id int not null,
    foreign key (category_id) references categories(category_id)
);

create table orders(
	order_id int auto_increment primary key,
    customer_id int not null,
    order_date datetime default (current_date()),
    status enum('Pending', 'Completed', 'Cancelled') default 'Pending',
    foreign key (customer_id) references customers(customer_id)
);

create table order_items(
	order_item_id int auto_increment primary key,
    order_id int not null,
    product_id int not null,
    quantity int not null check (quantity > 0),
    foreign key (order_id) references orders(order_id),
    foreign key (product_id) references products(product_id)
);

insert into customers (customer_name, email, phone) values
('Nguyễn Văn A', 'a@gmail.com', '0900000001'),
('Trần Thị B', 'b@gmail.com', '0900000002'),
('Lê Văn C', 'c@gmail.com', '0900000003'),
('Phạm Thị D', 'd@gmail.com', '0900000004'),
('Hoàng Văn E', 'e@gmail.com', '0900000005'),
('Vũ Thị F', 'f@gmail.com', '0900000006'),
('Đặng Văn G', 'g@gmail.com', '0900000007'),
('Bùi Thị H', 'h@gmail.com', '0900000008'),
('Đỗ Văn I', 'i@gmail.com', '0900000009'),
('Ngô Thị K', 'k@gmail.com', '0900000010');

insert into categories (category_name) values
('Điện thoại'),
('Laptop'),
('Phụ kiện'),
('Thiết bị gia dụng'),
('Thời trang');


insert into products (product_name, price, category_id) values
('iPhone 15', 25000000, 1),
('Samsung Galaxy S23', 22000000, 1),
('MacBook Air M2', 28000000, 2),
('Dell XPS 13', 26000000, 2),
('Tai nghe AirPods', 4500000, 3),
('Chuột Logitech', 1200000, 3),
('Máy hút bụi', 3500000, 4),
('Nồi chiên không dầu', 4200000, 4),
('Áo thun nam', 300000, 5),
('Giày sneaker', 1500000, 5);

insert into orders (customer_id, order_date, status) values
(1, '2025-01-01', 'Completed'),
(2, '2025-01-02', 'Completed'),
(3, '2025-01-03', 'Pending'),
(4, '2025-01-04', 'Cancelled'),
(5, '2025-01-05', 'Completed'),
(6, '2025-01-06', 'Pending'),
(7, '2025-01-07', 'Completed'),
(8, '2025-01-08', 'Completed'),
(9, '2025-01-09', 'Pending'),
(10,'2025-01-10', 'Completed');

insert into order_items (order_id, product_id, quantity) values
(1, 1, 1),
(2, 3, 1),
(3, 5, 2),
(4, 2, 1),
(5, 4, 1),
(6, 6, 3),
(7, 7, 1),
(8, 8, 2),
(9, 9, 4),
(10,10, 1);

-- PHẦN A – TRUY VẤN DỮ LIỆU CƠ BẢN
-- Lấy danh sách tất cả danh mục sản phẩm trong hệ thống.

select category_name from categories;

-- Lấy danh sách đơn hàng có trạng thái là COMPLETED

select * from orders where status = 'completed';

-- Lấy danh sách sản phẩm và sắp xếp theo giá giảm dần

select * from products order by price desc;

-- Lấy 5 sản phẩm có giá cao nhất, bỏ qua 2 sản phẩm đầu tiên

select * from products order by price desc limit 5 offset 2;

-- PHẦN B – TRUY VẤN NÂNG CAO
-- Lấy danh sách sản phẩm kèm tên danh mục

select p.product_id, p.product_name, p.price, c.category_name from products p 
join categories c on p.category_id = c.category_id;

-- Lấy danh sách đơn hàng gồm:
-- order_id
-- order_date
-- customer_name
-- status

select o.order_id, o.order_date,c.customer_name, o.status from orders o
join customers c on o.customer_id = c.customer_id;

-- Tính tổng số lượng sản phẩm trong từng đơn hàng

select o.customer_id, o.customer_id, o.order_date, o.status, ot.quantity from orders o
join order_items ot on o.order_id = ot.order_id;

-- Thống kê số đơn hàng của mỗi khách hàng

select c.customer_id, c.customer_name, c.email, c.phone, count(o.order_id) as total_orders from customers c
join orders o on c.customer_id = o.customer_id
group by customer_id;

-- Lấy danh sách khách hàng có tổng số đơn hàng ≥ 2

select c.customer_id, c.customer_name, c.email, c.phone, count(o.order_id) as total_orders from customers c
join orders o on c.customer_id = o.customer_id
group by customer_id
having count(o.order_id) >= 2;

-- Thống kê giá trung bình, thấp nhất và cao nhất của sản phẩm theo danh mục

select c.category_name, avg(p.price) as avg, min(p.price) as min, max(p.price) as max from categories c
join products p on c.category_id = p.category_id
group by c.category_id;

-- PHẦN C – TRUY VẤN LỒNG (SUBQUERY)
-- Lấy danh sách sản phẩm có giá cao hơn giá trung bình của tất cả sản phẩm

select product_id, product_name, price, category_id from products
where price > (select avg(price) from products);

-- Lấy danh sách khách hàng đã từng đặt ít nhất một đơn hàng

select * from customers 
where customer_id in (select customer_id from orders);

-- Lấy đơn hàng có tổng số lượng sản phẩm lớn nhất.

select * from orders
where order_id in
(select order_id from order_items
group by order_id 
having sum(quantity) =
(select max(total_items) from
(select sum(quantity) as total_items from order_items 
group by order_id) as total_items));


-- Lấy tên khách hàng đã mua sản phẩm thuộc danh mục có giá trung bình cao nhất

select customer_name from customers 
where customer_id in
(select customer_id from orders 
where order_id in
(select order_id from order_items
where product_id in
(select product_id from products 
where category_id in
(select category_id from products
group by category_id
having avg(price) =
(select max(avg_price) from
(select avg(price) as avg_price from products
group by category_id) as max_avg)))));

-- Từ bảng tạm (subquery), thống kê tổng số lượng sản phẩm đã mua của từng khách hàng

select c.customer_id, c.customer_name, c.email, c.phone,
(select IFNULL(SUM(quantity), 0) from order_items
where order_id in 
(select order_id from orders
where customer_id = c.customer_id)) as total_items
from customers c;

-- Viết lại truy vấn lấy sản phẩm có giá cao nhất, đảm bảo:
-- Subquery chỉ trả về một giá trị
-- Không gây lỗi “Subquery returns more than 1 row”

select * from products where price =
(select max(price) from products);
