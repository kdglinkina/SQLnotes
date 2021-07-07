CREATE TABLE author (
    author_id INT PRIMARY KEY AUTO_INCREMENT,
    name_author	VARCHAR(50)
)
INSERT INTO author (author_id, name_author)
VALUES
    (1, 'Булгаков М.А.'),
    (2, 'Достоевский Ф.М.'),
    (3, 'Есенин С.А.'),
    (4, 'Пастернак Б.Л.');

SELECT * FROM author

CREATE TABLE genre(
    genre_id INT PRIMARY KEY AUTO_INCREMENT,
    name_genre VARCHAR (30)
)

INSERT INTO genre(genre_id, name_genre)
VALUES
    (1, 'Роман'),
    (2, 'Поэзия');

SELECT * FROM genre


/*Создание таблицы с внешними ключами*/
CREATE TABLE book (
    book_id INT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(50),
    author_id INT NOT NULL,
    genre_id INT,
    price DECIMAL(8,2),
    amount INT,
    FOREIGN KEY (author_id)  REFERENCES author (author_id),
    FOREIGN KEY (genre_id)  REFERENCES genre (genre_id)
);

SELECT * FROM book

/*Действия при удалении записи главной таблицы*/
CREATE TABLE book (
    book_id INT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(50),
    author_id INT NOT NULL,
    genre_id INT,
    price DECIMAL(8,2),
    amount INT,
    FOREIGN KEY (author_id)  REFERENCES author (author_id) ON DELETE CASCADE,
    FOREIGN KEY (genre_id)  REFERENCES genre (genre_id) ON DELETE SET NULL
);

SELECT * FROM book


/*Заполнение таблицы с внешними ключами*/
INSERT INTO book(book_id, title, author_id, genre_id, price, amount)
VALUES
    (6, 'Стихотворения и поэмы', 3, 2, 650.00, 15),
    (7,	'Черный человек', 3, 2,	570.20,	6),
    (8, 'Лирика', 4, 2,	518.99,	2);

SELECT * FROM book

/*Запросы на выборку, соединение таблиц INNER JOIN*/
SELECT title, name_genre, price
FROM
    genre INNER JOIN book
    ON genre.genre_id = book.genre_id AND book.amount > 8
ORDER BY price DESC

/*Внешнее соединение LEFT и RIGHT OUTER JOIN*/
SELECT name_genre
FROM genre LEFT JOIN book
     ON genre.genre_id = book.genre_id
     WHERE  book.genre_id IS Null

/**/
CREATE TABLE city (
    city_id INT PRIMARY KEY AUTO_INCREMENT,
    name_city VARCHAR(50)

/*Перекрестное соединение CROSS JOIN
SELECT name_city, name_author,
      DATE_ADD('2020-01-01', INTERVAL FLOOR(RAND() * 365) DAY) AS Дата
FROM author CROSS JOIN city
ORDER BY name_city ASC, Дата DESC*/

/*Запросы на выборку из нескольких таблиц*/
SELECT name_genre, title, name_author
FROM
    genre
    INNER JOIN book ON genre.genre_id = book.genre_id
    INNER JOIN author ON book.author_id = author.author_id
WHERE name_genre = 'Роман'
ORDER BY title ASC

/*Запросы для нескольких таблиц с группировкой*/
SELECT name_author,SUM(amount) AS Количество
FROM
    author LEFT JOIN book
    ON book.author_id = author.author_id
GROUP BY name_author
HAVING Количество <10 OR Количество IS Null
ORDER BY Количество ASC

/*Запросы для нескольких таблиц со вложенными запросами*/
SELECT name_author
FROM
    genre
    INNER JOIN book ON genre.genre_id = book.genre_id
    INNER JOIN author ON book.author_id = author.author_id
GROUP BY name_author
HAVING COUNT(DISTINCT(name_genre))=1
ORDER BY name_author ASC

/*Вложенные запросы в операторах соединения*/
SELECT title, name_author, name_genre, price, amount
FROM
    author
    INNER JOIN book ON author.author_id = book.author_id
    INNER JOIN genre ON  book.genre_id = genre.genre_id
GROUP BY name_author, name_genre, genre.genre_id, title, price, amount
HAVING genre.genre_id IN
         (/* выбираем автора, если он пишет книги в самых популярных жанрах*/
          SELECT query_in_1.genre_id
          FROM
              ( /* выбираем код жанра и количество произведений, относящихся к нему */
                SELECT genre_id, SUM(amount) AS sum_amount
                FROM book
                GROUP BY genre_id
               )query_in_1
          INNER JOIN
              ( /* выбираем запись, в которой указан код жанр с максимальным количеством книг */
                SELECT genre_id, SUM(amount) AS sum_amount
                FROM book
                GROUP BY genre_id
                ORDER BY sum_amount DESC
                LIMIT 1
               ) query_in_2
          ON query_in_1.sum_amount= query_in_2.sum_amount
         )
ORDER BY title ASC

/*Операция соединение, использование USING()*/
SELECT book.title AS Название, name_author AS Автор, SUM(book.amount)+SUM(supply.amount) AS Количество
FROM
    author
    INNER JOIN book USING (author_id)
    INNER JOIN supply ON book.title = supply.title
                         AND author.name_author = supply.author
                         AND book.price = supply.price
GROUP BY book.title, Название, Автор


/*Запросы на обновление, связанные таблицы*/
UPDATE book
     INNER JOIN author ON author.author_id = book.author_id
     INNER JOIN supply ON book.title = supply.title
                         and supply.author = author.name_author
SET book.amount = book.amount + supply.amount,
    supply.amount = 0
WHERE book.price = supply.price;

SELECT * FROM book;

SELECT * FROM supply

/**/
UPDATE book
     INNER JOIN author ON author.author_id = book.author_id
     INNER JOIN supply ON book.title = supply.title
                         and supply.author = author.name_author
SET book.amount = book.amount + supply.amount,
    book.price = (book.price*book.amount+supply.price*supply.amount)/(book.amount+supply.amount),
    supply.amount = 0
WHERE book.price <> supply.price;

SELECT * FROM book;

SELECT * FROM supply;


/**/
INSERT INTO author(author_id, name_author)
SELECT author_id, supply.author
FROM
    author
    RIGHT JOIN supply on author.name_author = supply.author
WHERE name_author IS Null;

SELECT * FROM author


/**/
INSERT INTO book(title, author_id, price, amount)
SELECT title, author_id, price, amount
FROM
    author
    INNER JOIN supply ON author.name_author = supply.author
WHERE amount <> 0;

SELECT * FROM book


/**/
UPDATE book
SET genre_id =
      (
       SELECT genre_id
       FROM genre
       WHERE name_genre = 'Приключения'
      )
WHERE book_id = 11;

SELECT * FROM book;
/* или проще, если известно id
UPDATE book
SET genre_id = 3
WHERE book_id = 11;

SELECT * FROM book;
 */


/*Каскадное удаление записей связанных таблиц. у поля author_id задано DELETE ON CASCADE*/
DELETE FROM author
WHERE author_id IN(
    SELECT author_id
    FROM book
    GROUP BY author_id
    HAVING SUM(amount)<20
    );

SELECT * FROM author;

SELECT * FROM book;


/*Удаление записей главной таблицы с сохранением записей в зависимой. у поля genre_id задано  SET NULL*/
DELETE FROM genre
WHERE genre_id IN(
    SELECT genre_id
    FROM book
    GROUP BY genre_id
    HAVING COUNT(amount)<4
    );

SELECT * FROM genre;

SELECT * FROM book;


/*Удаление записей, использование связанных таблиц*/
DELETE FROM author
USING
    author
    INNER JOIN book ON author.author_id = book.author_id
    INNER JOIN genre ON book.genre_id = genre.genre_id
WHERE genre.name_genre = 'Поэзия';

SELECT * FROM author;

SELECT * FROM book;