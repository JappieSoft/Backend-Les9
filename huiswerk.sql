DROP TABLE IF EXISTS users CASCADE;
DROP TABLE IF EXISTS products CASCADE;
DROP TABLE IF EXISTS televisions CASCADE;
DROP TABLE IF EXISTS remoteControllers CASCADE;
DROP TABLE IF EXISTS ciModules CASCADE;
DROP TABLE IF EXISTS wallBrackets CASCADE;
DROP TABLE IF EXISTS televisions_ci_module CASCADE;
DROP TABLE IF EXISTS television_wall_brackets CASCADE;

CREATE TABLE users
(
    id            SERIAL PRIMARY KEY,
    username      VARCHAR(50),
    password      VARCHAR(50),
    adres         VARCHAR(255),
    functie       VARCHAR(50),
    loonschaal    INT,
    vakantiedagen INT
);

INSERT INTO users (username, password, adres, functie, loonschaal, vakantiedagen)
VALUES ('janedoe', 'pwd123', 'Kerkstraat 12, Amsterdam', 'Developer', 5, 25),
       ('pietjansen', 'pwd456', 'Dorpsweg 45, Rotterdam', 'Projectmanager', 7, 30),
       ('annavink', 'pwd789', 'Marktplein 8, Utrecht', 'Tester', 4, 20);

CREATE TABLE remoteControllers
(
    id          SERIAL PRIMARY KEY,
    smart       BOOL,
    batteryType VARCHAR(255)
);

INSERT INTO remoteControllers (smart, batteryType)
VALUES (true, 'Li-ion'),
       (false, 'Alkaline'),
       (true, 'NiMH');

CREATE TABLE ciModules
(
    id       SERIAL PRIMARY KEY,
    provider VARCHAR(100),
    encoding VARCHAR(255)
);

INSERT INTO ciModules (provider, encoding)
VALUES ('KPN', 'BENELUX'),
       ('ZIGGO', 'EUROPA'),
       ('ODIDO', 'NEDERLAND');

CREATE TABLE wallBrackets
(
    id                  SERIAL PRIMARY KEY,
    adjustable          BOOL,
    bevestigingsmethode VARCHAR(255),
    height              DECIMAL,
    width               DECIMAL
);

INSERT INTO wallBrackets (adjustable, bevestigingsmethode, height, width)
VALUES (true, 'schroeven', 40.5, 60.0),
       (false, 'pluggen en schroeven', 35.0, 55.5),
       (true, 'klembevestiging', 45.2, 65.3);

CREATE TABLE televisions
(
    id                INT PRIMARY KEY,
    height            DECIMAL,
    width             DECIMAL,
    schermKwaliteit   VARCHAR(100),
    schermType        VARCHAR(100),
    wifi              BOOL,
    smartTv           BOOL,
    voiceControl      BOOL,
    HDR               BOOL,
    remote_controller INT,
    ci_module         INT,
    wall_bracket      INT,
    CONSTRAINT fk_remote_control FOREIGN KEY (remote_controller) REFERENCES remoteControllers (id) ON DELETE CASCADE,
    CONSTRAINT fk_ci_module FOREIGN KEY (ci_module) REFERENCES ciModules (id) ON DELETE CASCADE,
    CONSTRAINT fk_wall_bracket FOREIGN KEY (wall_bracket) REFERENCES wallBrackets (id) ON DELETE CASCADE
);

INSERT INTO televisions (id, height, width, schermKwaliteit, schermType, wifi, smartTv, voiceControl, HDR,
                         remote_controller, ci_module, wall_bracket)
VALUES (1, 70.5, 120.3, '4K Ultra HD', 'LED', true, true, true, true, 1, 1, 1),
       (2, 55.0, 97.0, 'Full HD', 'OLED', true, false, false, false, 2, 1, 2),
       (3, 80.2, 140.8, '8K', 'QLED', true, true, true, true, 3, 2, 3);

CREATE TABLE products
(
    id                INT PRIMARY KEY,
    name              VARCHAR(100),
    brand             VARCHAR(100),
    price             DECIMAL,
    currentStock      INT,
    sold              INT,
    dateSold          DATE,
    type              VARCHAR(100),
    television_id     INT,
    remote_controller INT,
    ci_module         INT,
    wall_bracket      INT,
    CONSTRAINT fk_television_id FOREIGN KEY (television_id) REFERENCES televisions (id) ON DELETE CASCADE,
    CONSTRAINT fk_remote_control FOREIGN KEY (remote_controller) REFERENCES remoteControllers (id) ON DELETE CASCADE,
    CONSTRAINT fk_ci_module FOREIGN KEY (ci_module) REFERENCES ciModules (id) ON DELETE CASCADE,
    CONSTRAINT fk_wall_bracket FOREIGN KEY (wall_bracket) REFERENCES wallBrackets (id) ON DELETE CASCADE
);

INSERT INTO products (id, name, brand, price, currentStock, sold, dateSold, type, television_id, remote_controller,
                      ci_module, wall_bracket)
VALUES (1, 'Smart TV 55 inch', 'BrandA', 799.99, 50, 200, '2025-11-15', 'television', 1, 1, 1, 1),
       (2, 'Smart TV 45 inch', 'BrandB', 649.99, 150, 350, '2025-11-10', 'television', 2, 2, 3, 1),
       (3, 'Smart TV 35 inch', 'BrandC', 639.99, 80, 300, '2025-11-05', 'television', 3, 1, 2, 2);

CREATE TABLE televisions_ci_module
(
    id            SERIAL PRIMARY KEY,
    television_id INT,
    ci_module     INT,
    CONSTRAINT fk_television_id FOREIGN KEY (television_id) REFERENCES televisions (id) ON DELETE CASCADE,
    CONSTRAINT fk_ci_module FOREIGN KEY (ci_module) REFERENCES ciModules (id) ON DELETE CASCADE
);

INSERT INTO televisions_ci_module (television_id, ci_module)
VALUES (1, 1),
       (1, 2),
       (2, 2),
       (3, 1);

CREATE TABLE television_wall_brackets
(
    id            SERIAL PRIMARY KEY,
    television_id INT,
    wall_bracket  INT,
    CONSTRAINT fk_television_id FOREIGN KEY (television_id) REFERENCES televisions (id) ON DELETE CASCADE,
    CONSTRAINT fk_wall_bracket FOREIGN KEY (wall_bracket) REFERENCES wallBrackets (id) ON DELETE CASCADE
);

INSERT INTO television_wall_brackets (television_id, wall_bracket)
VALUES (1, 1),
       (2, 2),
       (3, 3);

SELECT *
FROM products p
         LEFT JOIN televisions t ON p.television_id = t.id
         LEFT JOIN remoteControllers rc ON p.remote_controller = rc.id
         LEFT JOIN ciModules c ON p.ci_module = c.id
         LEFT JOIN wallBrackets wb ON p.wall_bracket = wb.id
ORDER BY p.id;