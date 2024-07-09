USE e_commerce;

CREATE TABLE brands(
	id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(50) NOT NULL UNIQUE
);

INSERT INTO brands (name) values("Adidas"),("Nike"),("PUMA"),("Skechers");

ALTER TABLE brands ADD COLUMN status boolean default true;

CREATE TABLE  shipment(
	id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(50) NOT NULL UNIQUE,
    shipping_fee DECIMAL(4,2) DEFAULT 0
);

INSERT INTO shipment (name) values ("Aras Kargo"), ("Yurtiçi Kargo");
INSERT INTO shipment (name) values ("Hepsijet");
ALTER TABLE shipment ADD COLUMN status boolean default true;
ALTER TABLE shipment rename to shipments;

CREATE TABLE order_status(
	id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(30) NOT NULL UNIQUE
);

INSERT INTO order_status (name) VALUES 
									("ONAYLANDI"),
									("HAZIRLANIYOR"),
									("KARGOYA VERİLDİ"),
									("TAMAMLANDI"),
									("İPTAL EDİLDİ");
                                    
CREATE TABLE pay_types(
	id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(30) NOT NULL,
    status BOOLEAN DEFAULT TRUE
);

INSERT INTO order_status (name) VALUES 
									("KAPIDA ÖDEME"),
									("KREDİ KARTI"),
									("HAVALE/EFT");

CREATE TABLE categories(
	id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(50) NOT NULL UNIQUE,
    slug_name VARCHAR(50) NOT NULL UNIQUE,
    parent_id INT,
    status BOOLEAN DEFAULT FALSE,
	FOREIGN KEY (parent_id) REFERENCES categories(id)
);

ALTER TABLE categories DROP COLUMN slug_name;
ALTER TABLE categories ADD COLUMN slug_name VARCHAR(50) NOT NULL UNIQUE;
INSERT INTO categories (name,slug_name) VALUES 
									("Ayakkabı","ayakkabi"),						
									("Terlik","terlik"),						
									("Spor Ayakkabı","spor-ayakkabi"),						
									("Trekking", "trekking"),						
									("Casual Ayakkabı","casual-ayakkabi"),						
									("Ev Terliği", "ev-terliği"),						
									("Plaj Terliği","plaj-terliği");

CREATE TABLE PRODUCTS(
	id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    slug_name VARCHAR(120) NOT NULL UNIQUE,
    brand_id INT,
    status BOOLEAN DEFAULT FALSE
);
ALTER TABLE PRODUCTS RENAME TO products;
ALTER TABLE products ADD COLUMN category_id INT;
INSERT INTO categories (name, slug_name) VALUES 
									("Ürün1","urun1"),
									("Ürün2","urun2"),
									("Ürün3","urun3" ),
									("Ürün4","urun4"),
									("Ürün5","urun5" ),
									("Ürün6","urun6"),
									("Ürün7","urun7" ),
									("Ürün8","urun8" );
SELECT * FROM brands;                                    
SHOW ENGINE INNODB STATUS;                                   

CREATE TABLE product_details(
	id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    short_description VARCHAR(100),
    description TEXT,
    stock INT DEFAULT 0,
    price DECIMAL(6,2) default 0,
    discount_rate DOUBLE,
    final_price decimal(6,2) DEFAULT (price),
    product_id INT NOT NULL,
    FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE
);

INSERT INTO product_details (short_description,description, stock, price, discount_rate, final_price, product_id) VALUES 
									("short_description1","description1", 10, 349.90, 10 ,200,1 ),
									("short_description2","description2", 15, 500.00, 10 ,400,2 ),
									("short_description3","description3", 15, 700.00, 10 ,500,3 ),
									("short_description4","description4", 15, 100.00, 10 ,90,3 ),
									("short_description5","description5", 15, 600.00, 10 ,500,3 ),
									("short_description6","description6", 15, 400.00, 10 ,300,3 ),
									("short_description7","description7", 15, 200.00, 10 ,100,3 ),
									("short_description8","description8", 15, 100.00, 10 ,50,3 );
                                    
CREATE TABLE members(
	id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(50) NOT NULL,
    surname VARCHAR(50) NOT NULL,
    phone_number VARCHAR (11) UNIQUE,
    email VARCHAR(100) UNIQUE,
    password VARCHAR(40) NOT NULL,
    status BOOLEAN DEFAULT TRUE
);

CREATE TABLE member_details(
	id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    identity_number VARCHAR(11) UNIQUE NOT NULL,
    gender BOOLEAN,
    birthdate DATE,
    member_id INT,
    FOREIGN KEY (members_id) REFERENCES members(id) ON DELETE CASCADE
);
INSERT INTO members (name,surname, phone_number, email, password) VALUES 
									("Ayşe","Türk", "05555555555", "ayse@hotmail.com","123456"),
									("Hıdır","Türk", "05555555552", "hıdır@hotmail.com","1234568");

INSERT INTO member_details(identity_number, gender, birthdate, member_id) VALUES 
									("11111111111","2", "2001-10-06", 1),
									("11111111112","1", "1969-06-01", 2);

CREATE TABLE member_address(
	id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    country VARCHAR(10),
    province VARCHAR(10),
    address VARCHAR(255),
    member_id INT,
    default_status BOOLEAN DEFAULT 0,
    FOREIGN KEY (member_id) REFERENCES member(id) ON DELETE CASCADE
);
INSERT INTO member_address(country,province, address,member_id) VALUES
								("TÜRKİYE","İSTANBUL","ANADOLU YAKASI",1,1),
								("TÜRKİYE","İSTANBUL","AVRUPA YAKASI",1,0),
								("TÜRKİYE","ANKARA","KEÇİÖREN",2,1),
								("TÜRKİYE","İSTANBUL","MAMAK",2,0);

CREATE TABLE discount(
	id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    code VARCHAR(18) UNIQUE,
    name VARCHAR(75),
    amount INT DEFAULT 0,
    start_date DATE,
    end_date DATE,
    rate INT DEFAULT 0,
    cash DECIMAL(5,2) DEFAULT 0,
    product_id INT,
    category_id INT,
    status BOOLEAN DEFAULT TRUE
);
INSERT INTO discount values
           (null, "spor100","Spor ayakkabılarda 100TL İndirim",10,2023-02-10, 2023-02-17, 0,100,NULL,3,1);  
           
ALTER TABLE discount ADD COLUMN amount_remaining INT DEFAULT 0 AFTER amount;

CREATE TABLE shopping_card(
	id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    discount_id int,
    member_id int,
    is_completed BOOLEAN DEFAULT 0,
    created_date DATE,
    FOREIGN KEY (member_id) REFERENCES member(id) ON DELETE CASCADE
);

INSERT INTO shopping_card(member_id, created_date) VALUES
                   (1, "2023-02-12"),
                   (2, "2023-02-12");

INSERT INTO shopping_card(member_id, created_date,discount_id,is_completed) VALUES
                   (1, "2023-02-12",null,0),
                   (2, "2023-02-12",null,0),
                   (1, "2023-01-10",null,1),
                   (2, "2023-01-03",null,1);
                   