
-- занести нового клиента в бд
INSERT INTO phones (number, type) VALUES ('89279275919', 'work');
INSERT INTO addresesses (country, city, street, house) VALUES ('Россия', 'Уфа', 'Менделеева', '132');


INSERT INTO clients (name, age, idphone, idadresesses)
VALUES ('Владислав A.B.', 19, 1, 1);

SELECT * FROM clients;


-- занести нового работника в бд
INSERT INTO employees_type (name) values ('Кассир');

INSERT INTO employees (name, idemployees_type, idbranchs, idphones, idadresesses)
VALUES ('Джамиль', 1, 1, 11, 1);

-- открыть новый филлиал
INSERT INTO branchs (square, countempl, country) VALUES (6000, 0, 'Россия');

-- добавить новый поставляемый продукт, создать новый тип поставляемого продукта
INSERT INTO product_type (name, description) VALUES ('выключатель', 'высоковольтный выключатель');
INSERT INTO product (count, cost, idproduct_type) VALUES (10, 4000000, 1);

-- добавить новый производимый продукт, создать новый тип производимого продукта
INSERT INTO sparepart_type (name) VALUES ('Электроника');
INSERT INTO sparepart (name, whosedetail, idsparepart_type) VALUES ('Электромагнитный привод', 'своя', 1);

-- удалить продукт
DELETE FROM product_type WHERE name = 'выключатель';

-- добавить новую покупку клиенту
INSERT INTO sales (idclient, idproduct, count, date) VALUES (1, 1, 1, '2003-11-11');

-- удалить покупку клиента
DELETE FROM sales WHERE idclient = 1; --????????

-- обновить информацию о клиенте
UPDATE clients SET name = 'Влад';

-- обновить инормацию о филлиале
UPDATE branchs SET square = 6500;

-- посмотреть всех клиентов
SELECT name, age FROM clients;

-- посмотреть покупки клиента
select clients.name, p.name, pt.name, s.count, s.date from clients
join sales s on clients.id = s.idclient
join clients c on c.id = s.idclient
join product p on p.id = s.idproduct
join product_type pt on pt.id = p.idproduct_type
where clients.age < 30;

-- посмотреть покупки в данном филлиале
SELECT branchs.id, country, c.name, p.name, s.count
FROM branchs
join sales s on branchs.id = s.idbranch
join clients c on c.id = s.idclient
join product p on p.id = s.idproduct;

-- посмотреть продукты имеющийся в филлиале
SELECT product.name, count, cost, pt.name FROM product
join product_type pt on product.idproduct_type = pt.id
where count IS NOT NULL;




-- view

-- представление по клиентам и их покупкам
create view clients_view as
select clients.name as client, age, s.count, p.name, p.count as inStock, pt.name as typeProduct
FROM clients
join sales s on clients.id = s.idclient
join product p on p.id = s.idproduct
join product_type pt on pt.id = p.idproduct_type;

select * from clients_view;

-- представление по филлиалам и их сотрудникам
CREATE VIEW branchs_view AS
    SELECT country, square, employees.name as employees, employees_type.name as employees_type
    FROM branchs
    JOIN employees on branchs.id = employees.idbranchs
    JOIN employees_type on employees_type.id = employees.idemployees_type;

select * from branchs_view;

SELECT square, country, employees.name, employees_type.name
    FROM branchs
    JOIN employees on branchs.id = employees.idbranchs
    JOIN employees_type on employees_type.id = employees.idemployees_type;

-- triggers:

INSERT INTO sales (idclient, idproduct ,idbranch, count, date)
VALUES (1, 1, 1, 20, '2022-11-11');

select count from product;
-- при добавление продажи проверять есть ли такое количество продукта, если да, то уменьшение количества продукта на count
CREATE OR REPLACE FUNCTION count_of_prod_1()
    RETURNS TRIGGER AS $$
    DECLARE count_prod INTEGER;
    BEGIN
        count_prod = (SELECT count FROM product WHERE product.id = NEW.idproduct);
        IF(count_prod - NEW.count < 0) THEN
            RAISE EXCEPTION 'Too many products';
        END IF;
        RETURN NEW;
    END;
$$ language plpgsql;

CREATE TRIGGER count_of_prod_t_1 BEFORE
    INSERT ON sales FOR EACH ROW EXECUTE PROCEDURE count_of_prod_1();

CREATE OR REPLACE FUNCTION count_of_prod_2()
    RETURNS TRIGGER AS $$
    DECLARE count_prod INTEGER;
    BEGIN
        count_prod = (SELECT count FROM product WHERE product.id = NEW.idproduct);
        IF(count_prod - NEW.count > 0) THEN
            UPDATE product SET count = count - NEW.count;
        END IF;
        RETURN NEW;
    END;
$$ language plpgsql;

CREATE TRIGGER count_of_prod_t_2 AFTER
    INSERT ON sales FOR EACH ROW EXECUTE PROCEDURE count_of_prod_2();





-- при добавление сорудника, увеличивать количество сотрудников на филиале
CREATE OR REPLACE FUNCTION count_of_empl()
    RETURNS TRIGGER AS $$
    BEGIN
        UPDATE branchs SET countempl = countempl + 1 WHERE branchs.id = NEW.idbranchs;
        RETURN NEW;
    END;
$$ language plpgsql;

CREATE TRIGGER count_of_empl_t AFTER
    INSERT ON employees FOR EACH ROW EXECUTE PROCEDURE count_of_empl();

select * from branchs;

INSERT INTO employees (name, idemployees_type, idbranchs, idphones, idadresesses)
VALUES ('Джамиль', 1, 1, 11, 1), ('Игорь', 2, 1, 12, 2);

-- при добавлении продажи, если дата не указана вставить текущую
CREATE OR REPLACE FUNCTION current_data()
    RETURNS TRIGGER AS $$
    BEGIN
        if NEW.date is null then
            NEW.date = current_date;
        end if;
        RETURN NEW;
    END;
$$ language plpgsql;

CREATE TRIGGER current_data_t BEFORE
    INSERT ON sales FOR EACH ROW EXECUTE PROCEDURE current_data();


-- при добавлении клиента, если ему не исполнилось 18 лет, откатить
CREATE OR REPLACE FUNCTION coming_of_age()
    RETURNS TRIGGER AS $$
    BEGIN
        IF (NEW.age < 18) THEN
           RAISE EXCEPTION 'Age < 18';
        END IF;
        RETURN new;
    END;
$$ language plpgsql;

CREATE TRIGGER coming_of_age_t BEFORE
    INSERT ON clients FOR EACH ROW EXECUTE PROCEDURE coming_of_age();

INSERT INTO clients (name, age, idphone, idadresesses)
VALUES ('Владислав А.В.', 17, 1, 1);

-- при добавлении новой покупки, если количество товара меньше чем 2, откатить
CREATE OR REPLACE FUNCTION few_prod()
    RETURNS TRIGGER AS $$
    BEGIN
        IF(NEW.count < 2) THEN
            RAISE EXCEPTION 'Too few products';
        END IF;
        RETURN NEW;
    END
$$ language plpgsql;

CREATE TRIGGER few_prod_t BEFORE
    INSERT ON sales FOR EACH ROW EXECUTE PROCEDURE few_prod();

SELECT c.name, b.country, p.name, p.cost, sales.count, date FROM sales
join product p on p.id = sales.idproduct
join branchs b on b.id = sales.idbranch
join clients c on c.id = sales.idclient;

SELECT clients.name, p.name, pt.name, s.count, s.date from clients
join sales s on clients.id = s.idclient
join clients c on c.id = s.idclient
join product p on p.id = s.idproduct
join product_type pt on pt.id = p.idproduct_type;


INSERT INTO employees (name, idemployees_type, idbranchs, idphones)
VALUES
    ('Джамиль', 1, 2, 11);