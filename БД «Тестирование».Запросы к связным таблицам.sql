create database online_test;
use online_test;

CREATE TABLE subject (
    subject_id INT PRIMARY KEY AUTO_INCREMENT,
    name_subject varchar(30)
);

INSERT INTO subject (subject_id,name_subject) VALUES
    (1,'Основы SQL'),
    (2,'Основы баз данных'),
    (3,'Физика');

CREATE TABLE student (
    student_id INT PRIMARY KEY AUTO_INCREMENT,
    name_student varchar(50)
);

INSERT INTO student (student_id,name_student) VALUES
    (1,'Баранов Павел'),
    (2,'Абрамова Катя'),
    (3,'Семенов Иван'),
    (4,'Яковлева Галина');

CREATE TABLE attempt (
    attempt_id INT PRIMARY KEY AUTO_INCREMENT,
    student_id INT,
    subject_id INT,
    date_attempt date,
    result INT,
    FOREIGN KEY (student_id) REFERENCES student (student_id) ON DELETE CASCADE,
    FOREIGN KEY (subject_id) REFERENCES subject (subject_id) ON DELETE CASCADE
);

INSERT INTO attempt (attempt_id,student_id,subject_id,date_attempt,result) VALUES
    (1,1,2,'2020-03-23',67),
    (2,3,1,'2020-03-23',100),
    (3,4,2,'2020-03-26',0),
    (4,1,1,'2020-04-15',33),
    (5,3,1,'2020-04-15',67),
    (6,4,2,'2020-04-21',100),
    (7,3,1,'2020-05-17',33);

CREATE TABLE question (
    question_id INT PRIMARY KEY AUTO_INCREMENT,
    name_question varchar(100),
    subject_id INT,
    FOREIGN KEY (subject_id) REFERENCES subject (subject_id) ON DELETE CASCADE
);

INSERT INTO question (question_id,name_question,subject_id) VALUES
    (1,'Запрос на выборку начинается с ключевого слова:',1),
    (2,'Условие, по которому отбираются записи, задается после ключевого слова:',1),
    (3,'Для сортировки используется:',1),
    (4,'Какой запрос выбирает все записи из таблицы student:',1),
    (5,'Для внутреннего соединения таблиц используется оператор:',1),
    (6,'База данных - это:',2),
    (7,'Отношение - это:',2),
    (8,'Концептуальная модель используется для',2),
    (9,'Какой тип данных не допустим в реляционной таблице?',2);

CREATE TABLE answer (
    answer_id INT PRIMARY KEY AUTO_INCREMENT,
    name_answer varchar(100),
    question_id INT,
    is_correct BOOLEAN,
    CONSTRAINT answer_ibfk_1 FOREIGN KEY (question_id) REFERENCES question (question_id) ON DELETE CASCADE
);

INSERT INTO answer (answer_id,name_answer,question_id,is_correct) VALUES
    (1,'UPDATE',1,FALSE),
    (2,'SELECT',1,TRUE),
    (3,'INSERT',1,FALSE),
    (4,'GROUP BY',2,FALSE),
    (5,'FROM',2,FALSE),
    (6,'WHERE',2,TRUE),
    (7,'SELECT',2,FALSE),
    (8,'SORT',3,FALSE),
    (9,'ORDER BY',3,TRUE),
    (10,'RANG BY',3,FALSE),
    (11,'SELECT * FROM student',4,TRUE),
    (12,'SELECT student',4,FALSE),
    (13,'INNER JOIN',5,TRUE),
    (14,'LEFT JOIN',5,FALSE),
    (15,'RIGHT JOIN',5,FALSE),
    (16,'CROSS JOIN',5,FALSE),
    (17,'совокупность данных, организованных по определенным правилам',6,TRUE),
    (18,'совокупность программ для хранения и обработки больших массивов информации',6,FALSE),
    (19,'строка',7,FALSE),
    (20,'столбец',7,FALSE),
    (21,'таблица',7,TRUE),
    (22,'обобщенное представление пользователей о данных',8,TRUE),
    (23,'описание представления данных в памяти компьютера',8,FALSE),
    (24,'база данных',8,FALSE),
    (25,'file',9,TRUE),
    (26,'INT',9,FALSE),
    (27,'VARCHAR',9,FALSE),
    (28,'DATE',9,FALSE);

CREATE TABLE testing (
    testing_id INT PRIMARY KEY AUTO_INCREMENT,
    attempt_id INT,
    question_id INT,
    answer_id INT,
    FOREIGN KEY (attempt_id) REFERENCES attempt (attempt_id) ON DELETE CASCADE
);

INSERT INTO testing (testing_id,attempt_id,question_id,answer_id) VALUES
    (1,1,9,25),
    (2,1,7,19),
    (3,1,6,17),
    (4,2,3,9),
    (5,2,1,2),
    (6,2,4,11),
    (7,3,6,18),
    (8,3,8,24),
    (9,3,9,28),
    (10,4,1,2),
    (11,4,5,16),
    (12,4,3,10),
    (13,5,2,6),
    (14,5,1,2),
    (15,5,4,12),
    (16,6,6,17),
    (17,6,8,22),
    (18,6,7,21),
    (19,7,1,3),
    (20,7,4,11),
    (21,7,5,16)


/*Вывести студентов, которые сдавали дисциплину «Основы баз данных», указать дату попытки и результат.
  Информацию вывести по убыванию результатов тестирования.*/
SELECT name_student, date_attempt, result
FROM subject sub
JOIN attempt a on sub.subject_id = a.subject_id
JOIN student s on s.student_id = a.student_id
WHERE name_subject = 'Основы баз данных'
ORDER BY result DESC


/*Вывести, сколько попыток сделали студенты по каждой дисциплине, а также средний результат попыток, который округлить до 2 знаков после запятой.
Под результатом попытки понимается процент правильных ответов на вопросы теста, который занесен в столбец result.
В результат включить название дисциплины, а также вычисляемые столбцы Количество и Среднее.
Информацию вывести по убыванию средних результатов.*/
SELECT name_subject, COUNT(attempt_id) AS Количество, ROUND(AVG(result),2) AS Среднее
FROM subject sub
LEFT OUTER JOIN attempt a on sub.subject_id = a.subject_id /*left- внутреннее соединение+невошедшие с знач null*/
GROUP BY name_subject
ORDER BY Среднее DESC


/*Вывести студентов (различных студентов), имеющих максимальные результаты попыток.
Информацию отсортировать в алфавитном порядке по фамилии студента.*/
SELECT name_student, result
FROM student s
JOIN attempt a on s.student_id = a.student_id
WHERE result = (
    SELECT MAX(result)
    FROM attempt
    )
ORDER BY name_student


/*Если студент совершал несколько попыток по одной и той же дисциплине, то вывести разницу в днях между первой и последней попыткой.
В результат включить фамилию и имя студента, название дисциплины и вычисляемый столбец Интервал.
Информацию вывести по возрастанию разницы.
Студентов, сделавших одну попытку по дисциплине, не учитывать.*/
SELECT name_student, name_subject, DATEDIFF(MAX(date_attempt),MIN(date_attempt)) AS Интервал
FROM subject sub
JOIN attempt a on sub.subject_id = a.subject_id
JOIN student s on s.student_id = a.student_id
GROUP BY name_student, name_subject
HAVING Интервал > 1
ORDER BY Интервал


/*Вывести дисциплину и количество уникальных студентов, которые по ней проходили тестирование .
В результат включить и дисциплины, тестирование по которым студенты еще не проходили, указав кол-во 0*/
SELECT name_subject, COUNT(DISTINCT student_id) AS Количество
FROM subject sub
LEFT JOIN attempt a on sub.subject_id = a.subject_id
GROUP BY name_subject
HAVING Количество >= 0
ORDER BY Количество DESC, name_subject


/*Случайным образом отберите 3 вопроса по дисциплине «Основы баз данных».*/
SELECT question_id, name_question
FROM subject sub
JOIN question USING (subject_id)
WHERE name_subject = 'Основы баз данных'
ORDER BY RAND() /*Для случайной сортировки используйте RAND() без параметров*/
LIMIT 3


/*Вывести вопросы, которые были включены в тест для Семенова Ивана по дисциплине «Основы SQL» 2020-05-17 (attempt_id = 7).
  Указать, какой ответ дал студент и правильный он или нет*/
SELECT name_question, name_answer, IF(is_correct='false', 'Неверно', 'Верно') AS Результат
FROM answer a
JOIN question q on q.question_id = a.question_id
JOIN testing t on a.answer_id = t.answer_id
WHERE attempt_id = 7


/*Посчитать результаты тестирования.
Результат попытки вычислить как кол-во правильных ответов, деленное на 3 (кол-во вопросов в каждой попытке) и умноженное на 100.
Результат округлить до двух знаков после запятой.
Вывести фамилию студента, название предмета, дату и результат.*/
SELECT name_student, name_subject, date_attempt, ROUND(SUM(is_correct)/3*100,0) AS Результат
FROM subject sub
JOIN attempt a on sub.subject_id = a.subject_id
JOIN student s on s.student_id = a.student_id
JOIN testing t on a.attempt_id = t.attempt_id
LEFT JOIN answer ans on t.answer_id = ans.answer_id
GROUP BY name_student, name_subject, date_attempt
ORDER BY name_student, date_attempt DESC


/*Для каждого вопроса вывести процент успешных решений,
  то есть отношение количества верных ответов к общему количеству ответов, значение округлить до 2-х знаков после запятой.
Также вывести название предмета, к которому относится вопрос, и общее количество ответов на этот вопрос*/
SELECT name_subject, CONCAT(LEFT(name_question, 30),'...') AS Вопрос, COUNT(answer_id) AS Всего_ответов, ROUND(SUM(answer.is_correct)*100/ COUNT(answer_id),2) AS Успешность
FROM subject
JOIN question USING(subject_id)
JOIN testing USING(question_id)
LEFT JOIN answer USING(answer_id)
GROUP BY name_subject, Вопрос
ORDER BY name_subject, Успешность DESC, Вопрос ASC


/*В таблицу attempt включить новую попытку для студента Баранова Павла по дисциплине «Основы баз данных».
Установить текущую дату в качестве даты выполнения попытки.*/
INSERT INTO attempt (student_id, subject_id,date_attempt)
SELECT student_id, subject_id, now()
FROM attempt
JOIN student USING(student_id)
JOIN subject USING(subject_id)

WHERE name_student='Баранов Павел' AND name_subject = 'Основы баз данных';
SELECT * FROM attempt


/*Случайным образом выбрать три вопроса по дисциплине,
тестирование по которой собирается проходить студент, занесенный в таблицу attempt последним*/
INSERT INTO testing (attempt_id, question_id)
SELECT a.attempt_id, question.question_id
FROM attempt a
JOIN question on a.subject_id = question.subject_id
WHERE attempt_id = (
    SELECT MAX(attempt_id)
    FROM attempt)
ORDER BY rand()
LIMIT 3;

SELECT* FROM testing


/*Студент прошел тестирование,
далее необходимо вычислить результат и занести его в таблицу attempt для соответствующей попытки.
Результат попытки вычислить как количество правильных ответов, деленное на 3 и умноженное на 100.
Результат округлить до целого. Будем считать, что мы знаем id попытки = 8.*/
UPDATE attempt
SET result = (SELECT ROUND(SUM(is_correct)/3*100)
                FROM answer
                JOIN testing USING(answer_id)
                WHERE attempt_id = 8)
WHERE attempt_id = 8;

SELECT*FROM attempt


/*Удалить из таблицы attempt все попытки, выполненные раньше 1 мая 2020 года.
Также удалить и все соответствующие этим попыткам вопросы из таблицы testing*/
DELETE FROM attempt
WHERE date_attempt < '2020-05-01';

SELECT*FROM attempt

