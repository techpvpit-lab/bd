-- Можно выполнять в PostgreSQL

DROP TABLE IF EXISTS orderproducts CASCADE;
DROP TABLE IF EXISTS orders CASCADE;
DROP TABLE IF EXISTS users CASCADE;
DROP TABLE IF EXISTS products CASCADE;
DROP TABLE IF EXISTS category CASCADE;
DROP TABLE IF EXISTS deliverypoints CASCADE;
DROP TABLE IF EXISTS manufacturer CASCADE;
DROP TABLE IF EXISTS roles CASCADE;
DROP TABLE IF EXISTS supplier CASCADE;

-- Категории товаров
CREATE TABLE category (
    id SERIAL PRIMARY KEY,
    categoryname TEXT
);

-- Пункты выдачи
CREATE TABLE deliverypoints (
    id SERIAL PRIMARY KEY,
    pointname TEXT
);

-- Производители
CREATE TABLE manufacturer (
    id SERIAL PRIMARY KEY,
    manufacturername TEXT
);

-- Роли пользователей
CREATE TABLE roles (
    id SERIAL PRIMARY KEY,
    rolename TEXT
);

-- Поставщики
CREATE TABLE supplier (
    id SERIAL PRIMARY KEY,
    suppliername TEXT
);

-- Товары
CREATE TABLE products (
    id SERIAL PRIMARY KEY,
    article TEXT NOT NULL,
    productname TEXT NOT NULL,
    unit TEXT NOT NULL,
    cost NUMERIC(10, 2) NOT NULL,
    supplierid INTEGER,
    manufacturerid INTEGER,
    categoryid INTEGER,
    discount INTEGER NOT NULL,
    ountinstock INTEGER NOT NULL,
    description TEXT NOT NULL,
    image TEXT,

    CONSTRAINT products_supplierid_fkey
        FOREIGN KEY (supplierid)
        REFERENCES supplier(id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,

    CONSTRAINT products_manufacturerid_fkey
        FOREIGN KEY (manufacturerid)
        REFERENCES manufacturer(id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,

    CONSTRAINT products_categoryid_fkey
        FOREIGN KEY (categoryid)
        REFERENCES category(id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

-- Пользователи
CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    roleid INTEGER,
    fullname TEXT,
    login TEXT,
    password TEXT,

    CONSTRAINT users_roleid_fkey
        FOREIGN KEY (roleid)
        REFERENCES roles(id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

-- Заказы
CREATE TABLE orders (
    id SERIAL PRIMARY KEY,
    orderdate DATE,
    deliverydate DATE,
    pointid INTEGER,
    userid INTEGER,
    code TEXT,
    status TEXT,

    CONSTRAINT orders_pointid_fkey
        FOREIGN KEY (pointid)
        REFERENCES deliverypoints(id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,

    CONSTRAINT orders_userid_fkey
        FOREIGN KEY (userid)
        REFERENCES users(id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

-- Товары в заказе
CREATE TABLE orderproducts (
    id SERIAL PRIMARY KEY,
    orderid INTEGER,
    productid INTEGER,

    CONSTRAINT orderproducts_orderid_fkey
        FOREIGN KEY (orderid)
        REFERENCES orders(id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,

    CONSTRAINT orderproducts_productid_fkey
        FOREIGN KEY (productid)
        REFERENCES products(id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);
