INSERT INTO addresesses (country, city, street, house)
VALUES
    ('Россия', 'Уфа', 'Менделеева', '132'),
    ('Казахстан', 'Алматы', 'Казахстанская', '11'),
    ('Россия', 'Москва', 'Константина Царёва', '12');

INSERT INTO phones (number, type)
VALUES
    ('89998887700', 'рабочий'),
    ('89998887701', 'личный'),
    ('89998887702', 'рабочий'),
    ('89998887703', 'личный'),
    ('89998887704', 'рабочий'),
    ('89998887705', 'личный'),
    ('89998887706', 'рабочий'),
    ('89998887707', 'личный'),
    ('89998887708', 'рабочий'),
    ('89998887709', 'личный'),
    ('89998887711', 'рабочий'),
    ('89998887712', 'личный'),
    ('89998887713', 'рабочий'),
    ('89998887714', 'личный'),
    ('89998887715', 'рабочий'),
    ('89998887716', 'личный'),
    ('89998887717', 'рабочий');


INSERT INTO clients (name, age, idphone, idadresesses)
VALUES
    ('Владислав А.В.', 19, 1, 1),
    ('Антон С.Е.', 60, 2, 2),
    ('Петр Л.B.', 33, 3, 3),
    ('Василий A.B.', 23, 4, 1),
    ('Константин Н.Н.', 29, 5, 2),
    ('Григорий Е.Ф.', 30, 6, 3),
    ('Павел A.Л.', 44, 7, 2),
    ('Алексей И.B.', 47, 8, 1),
    ('Михаил С.С.', 31, 9, 2),
    ('Леонид Л.B.', 25, 10, 3);


INSERT INTO branchs (square, countempl, country)
VALUES
    (6000, 0, 'Россия'),
    (10000, 0, 'Германия'),
    (8000, 0, 'Китай'),
    (5000, 0, 'Испания');



INSERT INTO employees_type (name)
VALUES
    ('Начальник отдела кадров'),
    ('Аналитик'),
    ('Бухгалтер'),
    ('Инженер'),
    ('Менеджер'),
    ('Техник');


INSERT INTO employees (name, idemployees_type, idbranchs, idphones, idadresesses)
VALUES
    ('Джамиль', 1, 1, 11, 1),
    ('Игорь', 2, 1, 12, 2),
    ('Глеб', 3, 2, 13, 3),
    ('Виталий', 4, 3, 14, 3),
    ('Илья', 5, 4, 15, 2),
    ('Лев', 6, 3, 16, 1),
    ('Александр', 6, 4, 17, 1);


INSERT INTO product_type (name, description)
VALUES
    ('Холодильник', 'техника используемая в ванной комнате'),
    ('Стиральные машина', 'техника используемая в кухонной комнате'),
    ('Кофемашины', 'техника нужная для бытовой жизни'),
    ('Газовые варочные панели', 'техника нужная для бытовой жизни');


INSERT INTO product (name, count, cost, idproduct_type)
VALUES
    ('Serie | 6 VitaFresh Plus', 25, 100000, 1),
    ('NatureCool KGV39XK2AR', 20, 63000, 1),
    ('Serie | 4', 15, 82000, 2),
    ('Serie | 6', 18, 65000, 2),
    ('VeroCup 100', 30, 59000, 3),
    ('VeroCafe Latte Pro', 50, 18000, 3),
    ('NeoKlassik', 15, 20000, 4),
    ('Domino', 10, 54000, 4);



INSERT INTO sparepart_type(name)
VALUES
    ('Электрические части'),
    ('Механические части');


INSERT INTO sparepart(name, whosedetail, idsparepart_type)
VALUES
    ('Тахогенератор', 'своё производство', 1),
    ('Датчик температуры', 'своё производство', 1),
    ('Электродвигатель', 'поставляют', 1),
    ('Амортизатор', 'своё производство', 2),
    ('Пружина', 'поставляют', 2),
    ('Резиновая манжета', 'своё производство', 2);

-- INSERT INTO sales (idclient, idproduct ,idbranch, count)
-- VALUES
--     (1, 1, 1, 5);

INSERT INTO sales (idclient, idproduct ,idbranch, count, date)
VALUES
    (1, 1, 1, 5, '2023-11-11'),
    (1, 2, 2, 10, '2021-01-10'),
    (2, 3, 3, 4, '2020-02-02'),
    (3, 4, 4, 20, '2021-02-25'),
    (4, 5, 1, 10, '2022-03-11'),
    (5, 6, 2, 6, '2022-06-05'),
    (6, 7, 3, 8, '2021-06-19'),
    (7, 8, 4, 5, '2019-09-24'),
    (8, 1, 1, 2, '2020-10-11'),
    (9, 2, 2, 9, '2021-11-16'),
    (9, 3, 3, 10, '2022-12-12');

insert into branchs_sparepart(idbranch, idsparepart)
values
    (1, 1),
    (1, 6),
    (2, 2),
    (2, 3),
    (3, 2),
    (3, 4),
    (4, 5);