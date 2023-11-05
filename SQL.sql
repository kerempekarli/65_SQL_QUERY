26. Stokta bulunmayan ürünlerin ürün listesiyle birlikte tedarikçilerin ismi ve iletişim numarasını (`ProductID`, `ProductName`, `CompanyName`, `Phone`) almak için bir sorgu yazın.
select p.product_id, p.product_name, s.company_name, s.phone from products p inner join suppliers s on p.supplier_id = s.supplier_id where p.units_in_stock = 0

27. 1998 yılı mart ayındaki siparişlerimin adresi, siparişi alan çalışanın adı, çalışanın soyadı

SELECT * FROM orders o join shippers s on s.shipper_id = o.ship_via WHERE date_part('year', o.order_date) = 1998 and date_part('month', o.order_date) = 03

28. 1997 yılı şubat ayında kaç siparişim var?

SELECT COUNT(*) FROM orders o
WHERE DATE_PART('year', o.order_date) = 1997
AND DATE_PART('month', o.order_date) = 2;

29. London şehrinden 1998 yılında kaç siparişim var?

SELECT COUNT(*) FROM orders o
WHERE DATE_PART('year', o.order_date) = 1998
AND o.ship_city = 'London'

30. 1997 yılında sipariş veren müşterilerimin contactname ve telefon numarası

SELECT c.contact_name, c.phone FROM orders o
join customers c on o.customer_id = c.customer_id
WHERE DATE_PART('year', o.order_date) = 1997

31. Taşıma ücreti 40 üzeri olan siparişlerim

select * from orders o where  o.freight > 40

32. Taşıma ücreti 40 ve üzeri olan siparişlerimin şehri, müşterisinin adı

select c.contact_name, o.ship_city from orders o join customers c on c.customer_id = o.customer_id where  o.freight > 40


33. 1997 yılında verilen siparişlerin tarihi, şehri, çalışan adı -soyadı ( ad soyad birleşik olacak ve büyük harf),

select o.order_date, o.ship_city,UPPER( e.first_name || ' ' || e.last_name)  from orders o join employees e on e.employee_id = o.employee_id
where date_part('year', o.order_date) = 1997

34. 1997 yılında sipariş veren müşterilerin contactname i, ve telefon numaraları ( telefon formatı 2223322 gibi olmalı )

SELECT c.contact_name, 
       regexp_replace(c.phone, '\D', '', 'g') AS formatted_phone
FROM orders o
JOIN customers c ON c.customer_id = o.customer_id
WHERE date_part('year', o.order_date) = 1997;


35. Sipariş tarihi, müşteri contact name, çalışan ad, çalışan soyad
SELECT o.order_date, c.contact_name, e.first_name AS employee_first_name, e.last_name AS employee_last_name
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
JOIN employees e ON o.employee_id = e.employee_id;


36. Geciken siparişlerim?
select * from orders o where o.required_date < o.shipped_date

37. Geciken siparişlerimin tarihi, müşterisinin adı
select c.contact_name, o.order_date from orders o join customers c on o.customer_id = c.customer_id where o.required_date < o.shipped_date

38. 10248 nolu siparişte satılan ürünlerin adı, kategorisinin adı, adedi

select c.category_name, s.* from orders o join order_details od on o.order_id = od.order_id
join products p on p.product_id = od.product_id
join categories c on p.category_id = c.category_id
join suppliers s on s.supplier_id = p.supplier_id
where o.order_id = 10248

39. 10248 nolu siparişin ürünlerinin adı , tedarikçi adı

select c.category_name, s.* from orders o join order_details od on o.order_id = od.order_id
join products p on p.product_id = od.product_id
join categories c on p.category_id = c.category_id
join suppliers s on s.supplier_id = p.supplier_id
where o.order_id = 10248

40. 3 numaralı ID ye sahip çalışanın 1997 yılında sattığı ürünlerin adı ve adeti

select od.product_id, p.product_name, sum(od.quantity) as total from orders o 
join order_details od 
on o.order_id = od.order_id 
join products p 
on p.product_id = od.product_id
where o.employee_id = 3 and EXTRACT(Year from o.order_date) = 1997 
group by od.product_id, p.product_name
order by total desc 

41. 1997 yılında bir defasinda en çok satış yapan çalışanımın ID,Ad soyad


select e.employee_id, e.first_name || ' ' || e.last_name as ad_soyad from employees e where e.employee_id = (select o.employee_id from orders o join order_details od on o.order_id = od.order_id
 where EXTRACT(YEAR FROM o.order_date) = 1997
group by o.order_id order by sum(od.quantity * od.unit_price ) desc limit 1)




42. 1997 yılında en çok satış yapan çalışanımın ID,Ad soyad ****

SELECT e.employee_id, e.first_name, e.last_name, e.title, e.hire_date,
       SUM(od.quantity * od.unit_price) AS total_sales
FROM employees e
JOIN orders o ON e.employee_id = o.employee_id
JOIN order_details od ON o.order_id = od.order_id
WHERE date_part('year', o.order_date) = 1997
GROUP BY e.employee_id, e.first_name, e.last_name, e.title, e.hire_date
ORDER BY total_sales DESC
LIMIT 1;


43. En pahalı ürünümün adı,fiyatı ve kategorisin adı nedir?

select p.product_name, c.category_name, p.unit_price from products p join categories c on p.category_id = c.category_id
order by unit_price desc limit 1 

44. Siparişi alan personelin adı,soyadı, sipariş tarihi, sipariş ID. Sıralama sipariş tarihine göre

SELECT e.first_name, e.last_name, o.order_date, o.order_id
FROM employees e
JOIN orders o ON e.employee_id = o.employee_id
ORDER BY o.order_date;



45. SON 5 siparişimin ortalama fiyatı ve orderid nedir?
SELECT o.order_id, AVG(od.unit_price * od.quantity) AS average_price
FROM orders o
JOIN order_details od ON o.order_id = od.order_id
GROUP BY o.order_id
ORDER BY o.order_date DESC
LIMIT 5;

46. Ocak ayında satılan ürünlerimin adı ve kategorisinin adı ve toplam satış miktarı nedir?
SELECT p.product_name, c.category_name, SUM(od.quantity) AS total_sales
FROM products p
JOIN categories c ON p.category_id = c.category_id
JOIN order_details od ON p.product_id = od.product_id
JOIN orders o ON od.order_id = o.order_id
WHERE EXTRACT(MONTH FROM o.order_date) = 1
GROUP BY p.product_name, c.category_name;

47. Ortalama satış miktarımın üzerindeki satışlarım nelerdir?

SELECT o.order_id, round(od.unit_price * od.quantity) AS total_sales
FROM order_details od
JOIN orders o ON od.order_id = o.order_id
GROUP BY o.order_id, total_sales
having round(od.unit_price * od.quantity) > (SELECT AVG(od2.unit_price * od2.quantity) FROM order_details od2)
order by total_sales desc;


48. En çok satılan ürünümün(adet bazında) adı, kategorisinin adı ve tedarikçisinin adı

select p.product_name,c.category_name, s.contact_name from products p join categories c on c.category_id = p.category_id
join suppliers s on s.supplier_id = p.supplier_id 
where p.product_id = (select od.product_id as sales_count from order_details od
group by od.product_id order by sales_count desc limit 1)

49. Kaç ülkeden müşterim var

SELECT COUNT(DISTINCT country) AS customer_count
FROM customers;

50. 3 numaralı ID ye sahip çalışan (employee) son Ocak ayından BUGÜNE toplamda ne kadarlık ürün sattı?

-- 2023 ocak ayı için veri olmadığından dolayı default bir başlangıç tarihi verdim.

SELECT e.employee_id, round(SUM(od.unit_price * od.quantity)) AS total_sales
FROM employees e
JOIN orders o ON e.employee_id = o.employee_id
JOIN order_details od ON o.order_id = od.order_id
WHERE e.employee_id = 3
  AND o.order_date >= '1093-01-01' 
  AND o.order_date <=  CURRENT_DATE
GROUP BY e.employee_id;




51. 10248 nolu siparişte satılan ürünlerin adı, kategorisinin adı, adedi

SELECT p.product_name, c.category_name, od.quantity
FROM order_details od
JOIN products p ON od.product_id = p.product_id
JOIN categories c ON p.category_id = c.category_id
WHERE od.order_id = 10248;


52. 10248 nolu siparişin ürünlerinin adı , tedarikçi adı
SELECT p.product_name, s.supplier_name
FROM order_details od
JOIN products p ON od.product_id = p.product_id
JOIN suppliers s ON p.supplier_id = s.supplier_id
WHERE od.order_id = 10248;

53. 3 numaralı ID ye sahip çalışanın 1997 yılında sattığı ürünlerin adı ve adeti

SELECT p.product_name, od.quantity
FROM employees e
JOIN orders o ON e.employee_id = o.employee_id
JOIN order_details od ON o.order_id = od.order_id
JOIN products p ON od.product_id = p.product_id
WHERE e.employee_id = 3
  AND EXTRACT(YEAR FROM o.order_date) = 1997;


54. 1997 yılında bir defasinda en çok satış yapan çalışanımın ID,Ad soyad

select e.employee_id, e.first_name || ' ' || e.last_name from orders o 
join employees e on o.employee_id = e.employee_id
where o.order_id =
(select o.order_id from orders o join order_details od on o.order_id = od.order_id
join employees e on e.employee_id = o.employee_id
where EXTRACT(YEAR from o.order_date ) = 1997
group by o.order_id
order by sum(quantity*unit_price) desc 
limit 1

)


55. 1997 yılında en çok satış yapan çalışanımın ID,Ad soyad ****

SELECT e.employee_id, e.first_name, e.last_name
FROM employees e
WHERE e.employee_id = (
  SELECT o.employee_id
  FROM orders o
  JOIN order_details od ON o.order_id = od.order_id
  WHERE EXTRACT(YEAR FROM o.order_date) = 1997
  GROUP BY o.employee_id
  ORDER BY SUM(od.quantity * od.unit_price) DESC
  LIMIT 1
);


56. En pahalı ürünümün adı,fiyatı ve kategorisin adı nedir?

SELECT p.product_name, p.unit_price, c.category_name
FROM products p
JOIN categories c ON p.category_id = c.category_id
ORDER BY p.unit_price DESC
LIMIT 1;

57. Siparişi alan personelin adı,soyadı, sipariş tarihi, sipariş ID. Sıralama sipariş tarihine göre

SELECT e.first_name, e.last_name, o.order_date, o.order_id
FROM employees e
JOIN orders o ON e.employee_id = o.employee_id
ORDER BY o.order_date;


58. SON 5 siparişimin ortalama fiyatı ve orderid nedir?

SELECT o.order_id, AVG(od.unit_price * od.quantity) AS average_price
FROM orders o
JOIN order_details od ON o.order_id = od.order_id
GROUP BY o.order_id
ORDER BY o.order_date DESC
LIMIT 5;



59. Ocak ayında satılan ürünlerimin adı ve kategorisinin adı ve toplam satış miktarı nedir?

SELECT p.product_name, c.category_name, SUM(od.quantity) AS total_sales
FROM products p
JOIN categories c ON p.category_id = c.category_id
JOIN order_details od ON p.product_id = od.product_id
JOIN orders o ON od.order_id = o.order_id
WHERE EXTRACT(MONTH FROM o.order_date) = 1
GROUP BY p.product_name, c.category_name;

60. Ortalama satış miktarımın üzerindeki satışlarım nelerdir?

SELECT o.order_id, od.unit_price * od.quantity AS total_sales
FROM order_details od
JOIN orders o ON od.order_id = o.order_id
WHERE od.unit_price * od.quantity > (
  SELECT AVG(od2.unit_price * od2.quantity) 
  FROM order_details od2
);


61. En çok satılan ürünümün(adet bazında) adı, kategorisinin adı ve tedarikçisinin adı

SELECT p.product_name, c.category_name, s.contact_name
FROM products p
JOIN categories c ON p.category_id = c.category_id
JOIN suppliers s ON p.supplier_id = s.supplier_id
JOIN order_details od ON p.product_id = od.product_id
GROUP BY p.product_name, c.category_name, s.contact_name
ORDER BY SUM(od.quantity) DESC
LIMIT 1;


62. Kaç ülkeden müşterim var

SELECT COUNT(DISTINCT country) AS customer_count
FROM customers;


63. Hangi ülkeden kaç müşterimiz var

SELECT country, COUNT(customer_id) AS customer_count
FROM customers
GROUP BY country
ORDER BY customer_count DESC;


64. 3 numaralı ID ye sahip çalışan (employee) son Ocak ayından BUGÜNE toplamda ne kadarlık ürün sattı?

SELECT e.employee_id, SUM(od.unit_price * od.quantity) AS total_sales
FROM employees e
JOIN orders o ON e.employee_id = o.employee_id
JOIN order_details od ON o.order_id = od.order_id
WHERE e.employee_id = 3
  AND o.order_date >= '1996-01-01' -- Ocak ayının ilk gününü geçerli tarihe güncelleyin
  AND o.order_date <=  CURRENT_DATE
GROUP BY e.employee_id;

65. 10 numaralı ID ye sahip ürünümden son 3 ayda ne kadarlık ciro sağladım?

SELECT SUM(od.unit_price * od.quantity) AS total_revenue
FROM order_details od
JOIN orders o ON od.order_id = o.order_id
WHERE od.product_id = 10
  AND o.order_date >= CURRENT_DATE - INTERVAL '3 months';


66. Hangi çalışan şimdiye kadar toplam kaç sipariş almış..?

select e.employee_id, e.first_name ||' '|| e.last_name, count(o.order_id)  from orders o join employees e on e.employee_id = o.employee_id
join order_details od on od.order_id = o.order_id
group by o.employee_id, e.employee_id

67. 91 müşterim var. Sadece 89’u sipariş vermiş. Sipariş vermeyen 2 kişiyi bulun


select c.customer_id, c.contact_name from orders o right join customers c on c.customer_id = o.customer_id where order_id is null

68. Brazil’de bulunan müşterilerin Şirket Adı, TemsilciAdi, Adres, Şehir, Ülke bilgileri

select c.company_name,c.contact_name,c.city,c.country,c.address  from customers c where c.country = 'Brazil'

69. Brezilya’da olmayan müşteriler

SELECT *
FROM customers
WHERE country <> 'Brazıl';


70. Ülkesi (Country) YA Spain, Ya France, Ya da Germany olan müşteriler

SELECT *
FROM customers
WHERE country IN ('Spain', 'France', 'Germany');

71. Faks numarasını bilmediğim müşteriler

SELECT *
FROM customers
WHERE fax IS NULL;


72. Londra’da ya da Paris’de bulunan müşterilerim

SELECT *
FROM customers
WHERE city IN ('London', 'Paris');


73. Hem Mexico D.F’da ikamet eden HEM DE ContactTitle bilgisi ‘owner’ olan müşteriler

SELECT *
FROM customers
WHERE city LIKE 'México D.F.' and contact_title ilike 'owner';



74. C ile başlayan ürünlerimin isimleri ve fiyatları

SELECT product_name, unit_price
FROM products
WHERE product_name ILIKE 'c%';


75. Adı (FirstName) ‘A’ harfiyle başlayan çalışanların (Employees); Ad, Soyad ve Doğum Tarihleri

SELECT first_name, last_name, birth_date
FROM employees
WHERE first_name ILIKE 'A%';


76. İsminde ‘RESTAURANT’ geçen müşterilerimin şirket adları

SELECT company_name
FROM customers
WHERE company_name ILIKE '%RESTAURANT%';

77. 50$ ile 100$ arasında bulunan tüm ürünlerin adları ve fiyatları

SELECT product_name, unit_price
FROM products
WHERE unit_price BETWEEN 50 AND 100;

78. 1 temmuz 1996 ile 31 Aralık 1996 tarihleri arasındaki siparişlerin (Orders), SiparişID (OrderID) ve SiparişTarihi (OrderDate) bilgileri

SELECT order_id, order_date
FROM orders
WHERE order_date BETWEEN '1996-07-01' AND '1996-12-31';

79. Ülkesi (Country) YA Spain, Ya France, Ya da Germany olan müşteriler
SELECT *
FROM customers
WHERE country IN ('Spain', 'France', 'Germany');

80. Faks numarasını bilmediğim müşteriler

SELECT *
FROM customers
WHERE fax IS NULL;

81. Müşterilerimi ülkeye göre sıralıyorum:

SELECT *
FROM customers
ORDER BY country;


82. Ürünlerimi en pahalıdan en ucuza doğru sıralama, sonuç olarak ürün adı ve fiyatını istiyoruz

SELECT product_name, unit_price
FROM products
ORDER BY unit_price DESC;

83. Ürünlerimi en pahalıdan en ucuza doğru sıralasın, ama stoklarını küçükten-büyüğe doğru göstersin sonuç olarak ürün adı ve fiyatını istiyoruz

SELECT product_name, unit_price
FROM products
ORDER BY unit_price DESC, units_in_stock;

84. 1 Numaralı kategoride kaç ürün vardır..?

SELECT COUNT(*) AS product_count
FROM products
WHERE category_id = 1;

85. Kaç farklı ülkeye ihracat yapıyorum..?

SELECT COUNT(DISTINCT country) AS country_count
FROM customers;
