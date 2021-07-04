/*Создаём таблицу:задаём атрибуты и типы данных*/
CREATE TABLE book(
    book_id INT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(50),
    author VARCHAR(30),
    price DECIMAL(8, 2),
    amount INT
);

/*Добавляем записи в таблицу: ключ-значение*/
INSERT INTO book(book_id, title, author, price, amount) VALUES (2, 'Белая гвардия', 'Булгаков М.А.', 540.50, 5);
INSERT INTO book(book_id, title, author, price, amount) VALUES (3, 'Идиот', 'Достоевский Ф.М.', 460.00, 10);
INSERT INTO book(book_id, title, author, price, amount) VALUES (4, 'Братья Карамазовы', 'Достоевский Ф.М.', 799.01, 2);
/*или*/
INSERT INTO book (title, author, price, amount)
VALUES
    ('Война и мир','Толстой Л.Н.', 1070.20, 2),
    ('Анна Каренина', 'Толстой Л.Н.', 599.90, 3);

/*Выводим таблицу*/
SELECT * FROM book

/*Выборка определённых столбцов*/
SELECT author, title, price
FROM book;

/*выборка с переименованием столбцов*/
SELECT title AS Название, author AS Автор
FROM book;

/*выборка с созданием столбцов*/
SELECT title, author, price, amount,
    price * amount AS total -- можно использовать числа
FROM book;

/*выборка с добавлением столбца дисконта*/
SELECT title, author, amount,
    ROUND((price*70/100),2) AS new_price
FROM book;

/*выборка с добавлением столбца по условию IF*/
SELECT author, title,
    ROUND(IF(author = 'Булгаков М.А.', price * 1.1, IF(author = 'Есенин С.А.', price * 1.05, price * 1)), 2) AS new_price
FROM book;

/*выборка по условию WHERE и логическими операторами*/
SELECT title, author, price, amount
FROM book
WHERE (price > 500 OR price < 600) AND amount * price >= 5000;

/*выборка по условию WHERE и операторами диапазона*/
SELECT title, author
FROM book
WHERE (price BETWEEN 540.50 AND 800) AND amount IN (2, 3, 5, 7)

/*Выборка данных с сортировкой*/
SELECT author, title
FROM book
WHERE amount BETWEEN 2 AND 14
ORDER BY author DESC, title;

/*Выборка данных с оператором LIKE*/
SELECT title, author
FROM book
WHERE title LIKE "_% _%" AND author LIKE "%С.%"
ORDER BY title ASC


/*task*/
SELECT author, title, amount,
    ROUND(IF(amount > 5, price * 0.7, IF(price BETWEEN 600 AND 800, price * 0.8, price * 1 )),2) AS sale_price
FROM book
ORDER BY amount DESC

/*Выборка уникальных данных столбца*/
SELECT DISTINCT amount
FROM book
/*или
SELECT amount
FROM book
GROUP BY amount*/

/*Выборка группированием COUNT\SUM*/
SELECT author AS Автор,
       COUNT(title) AS Различных_книг,
       SUM(amount) AS Количество_экземпляров
FROM book
GROUP BY author

/*Выборка групповыми функциями MIN, MAX и AVG*/
SELECT author,
       MIN(price) AS Минимальная_цена,
       MAX(price) AS Максимальная_цена,
       AVG(price) AS Средняя_цена
FROM book
GROUP BY author

/*Выборка данных с вычислениями*/
SELECT author,
       ROUND(SUM(price * amount), 2) AS Стоимость,
       ROUND(SUM(price * amount) * 0.18/ 1.18, 2) AS НДС,
       ROUND(SUM(price * amount)/ 1.18,2) AS Стоимость_без_НДС
FROM book
GROUP BY author

/*Вычисления по таблице целиком*/
SELECT MIN(price) AS Минимальная_цена,
       MAX(price) AS Максимальная_цена,
       ROUND(AVG(price), 2) AS Средняя_цена
FROM book

/*Выборка данных с вычислениями*/
SELECT ROUND(AVG(price), 2) AS Средняя_цена,
       ROUND(SUM(price * amount), 2) AS Стоимость
FROM book
WHERE amount BETWEEN 5 AND 14

/*Выборка данных по условию, групповые функции, WHERE и HAVING
  порядок выполнения  SQL запроса на выборку на СЕРВЕРЕ:
FROM
WHERE
GROUP BY
HAVING
SELECT
ORDER BY*/
SELECT author,
       SUM(price * amount) AS Стоимость
FROM book
WHERE title <> 'Идиот' AND title <> 'Белая гвардия'
GROUP BY author
HAVING SUM(price * amount) > 5000
ORDER BY Стоимость DESC

/*task*/
SELECT author,
    SUM(price * amount) AS Стоимость
FROM book
WHERE author <> 'Есенин С.А.'
GROUP BY author
HAVING SUM(amount) > 5 AND SUM(price * amount) > 1000
ORDER BY author ASC

/*Вложенный запрос, возвращающий 1 значение*/
SELECT author, title, price
FROM book
    WHERE price <= (
        SELECT AVG(price)
        FROM book
        )
ORDER BY price DESC

/*Использование вложенного запроса в выражении*/
SELECT author, title, price
FROM book
    WHERE price - (SELECT MIN(price) FROM book) <= 150
ORDER BY price ASC

/*Вложенный запрос, оператор IN*/
SELECT author, title, amount
FROM book
    WHERE amount IN (
        SELECT amount
        FROM book
        GROUP BY amount
        HAVING COUNT(amount) = 1
        )

/*Вложенный запрос, операторы ANY и ALL*/
SELECT author, title, price
FROM book
    WHERE price < ANY (
        SELECT MIN(price)
        FROM book
        GROUP BY author
        )

/*Вложенный запрос после SELECT*/
SELECT title, author, amount,
       (
        (SELECT MAX(amount)
        FROM book) - amount
        ) AS  Заказ
FROM book
WHERE (SELECT MAX(amount) FROM book) - amount > 0

/*Создание пустой таблицы*/
CREATE TABLE supply(
    supply_id INT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(50),
    author VARCHAR(30),
    price DECIMAL(8,2),
    amount INT
)
/*Добавление записей в таблицу*/
INSERT INTO supply(supply_id, title, author, price, amount)
    VALUES
        (1, 'Лирика', 'Пастернак Б.Л.', 518.99, 2),
        (2, 'Черный человек', 'Есенин С.А.', 570.20, 6),
        (3, 'Белая гвардия', 'Булгаков М.А.', 540.50, 7),
        (4, 'Идиот', 'Достоевский Ф.М.', 360.80, 3)

/*Добавление записей из другой таблицы*/
INSERT INTO book (title, author, price, amount)
SELECT title, author, price, amount
FROM supply
    WHERE author <> 'Булгаков М.А.' AND author <> 'Достоевский Ф.М.';

SELECT * FROM book

/*Добавление записей, вложенные запросы*/
INSERT INTO book (title, author, price, amount)
SELECT title, author, price, amount
FROM supply
WHERE author NOT IN(
    SELECT author
    FROM book
    );

SELECT * FROM book

/*Запросы на обновление*/
UPDATE book
SET price = 0.9 * price
WHERE amount BETWEEN  5 AND 10;

SELECT * FROM book

/*Запросы на обновление нескольких столбцов*/
UPDATE book
SET buy = IF(buy > amount, amount, buy),
    price = IF(buy = 0, price * 0.9, price);

SELECT * FROM book

/*Запросы на обновление нескольких таблиц*/
UPDATE book, supply
SET book.amount = book.amount + supply.amount,
    book.price = (book.price + supply.price)/2
WHERE book.title = supply.title AND book.author = supply.author;

SELECT * FROM book

/*Запросы на удаление*/
DELETE FROM supply
WHERE author IN (
        SELECT author
        FROM book
        GROUP BY author
        HAVING SUM(amount) > 10
        );

SELECT * FROM supply

/*Запросы на создание таблицы*/
CREATE TABLE ordering AS
SELECT author, title,
       (SELECT AVG(amount)
        FROM book
       ) AS amount
FROM book
WHERE amount < (SELECT AVG(amount)FROM book);

SELECT * FROM ordering

/*"Командировки", запросы на выборку*/
SELECT name, city, per_diem, date_first, date_last
FROM trip
WHERE name LIKE "%а %"
ORDER BY date_last DESC

/**/
SELECT name
FROM trip
WHERE city = 'Москва'
GROUP BY name
ORDER BY name ASC

/**/
SELECT city, COUNT(city) AS 'Количество'
FROM trip
GROUP BY city
ORDER BY city ASC

/**/
SELECT city, COUNT(city) AS 'Количество'
FROM trip
GROUP BY city
ORDER BY Количество DESC
LIMIT 2

/**/
SELECT name, city, (DATEDIFF(date_last, date_first) + 1) AS Длительность
FROM trip
    WHERE city <> 'Москва' AND <> city 'Санкт-Петербург'
ORDER BY Длительность DESC, city DESC

/**/
SELECT name, city, date_first, date_last
FROM trip
    WHERE DATEDIFF(date_last, date_first) IN(
        SELECT MIN(DATEDIFF(date_last, date_first))
        FROM trip
        ORDER BY DATEDIFF(date_last, date_first)
        )

/**/
SELECT name, city, date_first, date_last
FROM trip
    WHERE MONTH(date_first) = MONTH(date_last)
ORDER BY city ASC, name ASC

/**/
SELECT MONTHNAME(date_first) AS Месяц, COUNT(MONTHNAME(date_first)) AS Количество
FROM trip
GROUP BY Месяц
ORDER BY Количество DESC, Месяц ASC

/**/
SELECT name, city, date_first, ((DATEDIFF(date_last, date_first)+1)*per_diem) AS Сумма
FROM trip
    WHERE YEAR(date_first) = 2020 AND (MONTH(date_first) = 2 OR MONTH(date_first)= 3)
ORDER BY name ASC, Сумма DESC

/**/
SELECT name, SUM((DATEDIFF(date_last, date_first)+1)*per_diem) AS Сумма
FROM trip
GROUP BY name
HAVING COUNT(name) > 3
ORDER BY Сумма DESC

/*Таблица "Нарушения ПДД"*/
CREATE TABLE fine(
    fine_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(30),
    number_plate VARCHAR(6),
    violation VARCHAR(50),
    sum_fine DECIMAL(8, 2),
    date_violation DATE,
    date_payment DATE
)

/**/
INSERT INTO fine(fine_id, name, number_plate, violation, sum_fine, date_violation, date_payment)
VALUES
    (6,	'Баранов П.Е.', 'Р523ВТ', 'Превышение скорости(от 40 до 60)', Null, '2020-02-14', Null),
    (7, 'Абрамова К.А.', 'О111АВ', 'Проезд на запрещающий сигнал', Null, '2020-02-23', Null),
    (8, 'Яковлев Г.Р.',	'Т330ТТ', 'Проезд на запрещающий сигнал', Null, '2020-03-03', Null);

SELECT * FROM fine

/*Использование временного имени таблицы (алиаса)*/
UPDATE fine AS f, traffic_violation AS tv
SET f.sum_fine = tv.sum_fine
WHERE f.sum_fine IS Null AND f.violation = tv.violation;

SELECT * FROM fine

/*Группировка данных по нескольким столбцам*/
SELECT name, number_plate, violation
FROM fine
GROUP BY name, number_plate, violation
HAVING COUNT(violation)>1
ORDER BY name, number_plate, violation;

SELECT * FROM fine

/**/
UPDATE fine AS f,
    (
     SELECT name, number_plate, violation
     FROM fine
     GROUP BY name, number_plate, violation
     HAVING COUNT(violation)>1
     ORDER BY name, number_plate, violation
    ) AS query_in
SET sum_fine=sum_fine*2
WHERE date_payment IS NULL
    AND f.name = query_in.name
    AND f.number_plate = query_in.number_plate;

SELECT * FROM fine

/**/
UPDATE fine AS f, payment AS p
SET f.date_payment = p.date_payment,
    f.sum_fine = IF((f.date_payment - f.date_violation)<21, f.sum_fine/2, f.sum_fine)
WHERE f.date_payment IS NULL
    AND f.name = p.name
    AND f.number_plate = p.number_plate;

SELECT * FROM fine

/**/
CREATE TABLE back_payment AS
SELECT name, number_plate, violation, sum_fine, date_violation
FROM fine
    WHERE date_payment IS Null;

SELECT * FROM back_payment

/**/
DELETE FROM fine
WHERE MONTH(date_violation) < 2;

SELECT * FROM fine