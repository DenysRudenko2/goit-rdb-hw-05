-- =====================================================
-- ЗАВДАННЯ 1: Вкладений запит в операторі SELECT
-- =====================================================
-- Мета: Відобразити таблицю order_details та додати поле customer_id 
-- з таблиці orders за допомогою вкладеного запиту в SELECT
-- Принцип: Для кожного рядка order_details знаходимо відповідний customer_id

SELECT 
    od.*,
    (SELECT o.customer_id 
     FROM orders o 
     WHERE o.id = od.order_id) AS customer_id
FROM order_details od;

-- =====================================================
-- ЗАВДАННЯ 2: Вкладений запит в операторі WHERE
-- =====================================================
-- Мета: Відфільтрувати таблицю order_details за умовою shipper_id = 3
-- з таблиці orders за допомогою вкладеного запиту в WHERE
-- Принцип: Залишаємо тільки ті записи, які належать замовленням з shipper_id = 3

SELECT od.*
FROM order_details od
WHERE od.order_id IN (
    SELECT o.id 
    FROM orders o 
    WHERE o.shipper_id = 3
);

-- =====================================================
-- ЗАВДАННЯ 3: Вкладений запит в операторі FROM
-- =====================================================
-- Мета: Використати вкладений запит в FROM для фільтрації quantity > 10
-- та знайти середнє значення quantity, згрупувавши за order_id
-- Принцип: Створюємо підзапит як віртуальну таблицю, потім групуємо дані

SELECT 
    order_id,
    AVG(quantity) AS average_quantity
FROM (
    SELECT order_id, quantity
    FROM order_details
    WHERE quantity > 10
) AS filtered_orders
GROUP BY order_id;

-- =====================================================
-- ЗАВДАННЯ 4: Використання оператора WITH (CTE)
-- =====================================================
-- Мета: Розв'язати завдання 3 за допомогою оператора WITH
-- для створення тимчасової таблиці temp
-- Принцип: WITH створює іменовану тимчасову таблицю, яку можна використати в основному запиті

WITH temp AS (
    SELECT order_id, quantity
    FROM order_details
    WHERE quantity > 10
)
SELECT 
    order_id,
    AVG(quantity) AS average_quantity
FROM temp
GROUP BY order_id;

-- =====================================================
-- ЗАВДАННЯ 5: Створення та використання функції
-- =====================================================
-- Мета: Створити функцію з двома параметрами типу FLOAT для ділення
-- першого параметра на другий та застосувати її до поля quantity
-- Принцип: Створюємо користувацьку функцію з захистом від ділення на нуль

-- Видалення функції, якщо вона існує
DROP FUNCTION IF EXISTS divide_numbers;

-- Створення функції
DELIMITER //
CREATE FUNCTION divide_numbers(num1 FLOAT, num2 FLOAT)
RETURNS FLOAT
DETERMINISTIC
BEGIN
    IF num2 = 0 THEN
        RETURN NULL; -- Захист від ділення на нуль
    ELSE
        RETURN num1 / num2;
    END IF;
END //
DELIMITER ;

-- Застосування функції до атрибута quantity
SELECT 
    id,
    order_id,
    product_id,
    quantity,
    divide_numbers(quantity, 2.5) AS divided_quantity
FROM order_details;