CREATE DATABASE `workupy`;

USE `workupy`;

CREATE TABLE `users` (
    `id` BIGINT PRIMARY KEY NOT NULL AUTO_INCREMENT,
    `name` VARCHAR(255) NOT NULL,
    `username` VARCHAR(255) UNIQUE NOT NULL,
    `email` VARCHAR(255) UNIQUE NOT NULL,
    `password` VARCHAR(255) NOT NULL
);

CREATE TABLE `projects` (
    `id` BIGINT PRIMARY KEY NOT NULL AUTO_INCREMENT,
    `user_id` BIGINT NOT NULL,
    `name` VARCHAR(255) NOT NULL,
    `slug` VARCHAR(255) UNIQUE NOT NULL
);

CREATE TABLE `pages` (
    `id` BIGINT PRIMARY KEY NOT NULL AUTO_INCREMENT,
    `project_id` BIGINT NOT NULL,
    `name` VARCHAR(255) NOT NULL,
    `title` VARCHAR(255) NOT NULL COMMENT 'Represents the HTML title tag',
    `path` VARCHAR(255) NOT NULL,
    `index` BOOLEAN NOT NULL COMMENT 'Determines if the page will represents the index (/)'
);

CREATE TABLE `elements` (
    `id` BIGINT PRIMARY KEY NOT NULL AUTO_INCREMENT,
    `uuid` BINARY(16) UNIQUE NOT NULL DEFAULT(UUID_TO_BIN(UUID())),
    `page_id` BIGINT NOT NULL,
    `parent_id` BIGINT,
    `name` VARCHAR(255) NOT NULL,
    `tag` VARCHAR(255) NOT NULL COMMENT 'Represents the HTML valid tags',
    `x` FLOAT NOT NULL,
    `y` FLOAT NOT NULL
);

CREATE TABLE `elements_attributes` (
    `id` BIGINT PRIMARY KEY NOT NULL AUTO_INCREMENT,
    `element_id` BIGINT NOT NULL,
    `attribute` VARCHAR(255) NOT NULL COMMENT 'Represents the HTML valid attributes',
    `value` VARCHAR(255) NOT NULL
);

CREATE TABLE `elements_style_props` (
    `id` BIGINT PRIMARY KEY NOT NULL AUTO_INCREMENT,
    `element_id` BIGINT NOT NULL,
    `property` VARCHAR(255) NOT NULL COMMENT 'Represents the CSS valid properties',
    `value` VARCHAR(255) NOT NULL,
    `unit` VARCHAR(255) COMMENT 'Represents the CSS valid units'
);

ALTER TABLE `projects`
ADD CONSTRAINT `user_projects_fk` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE `pages`
ADD CONSTRAINT `project_pages_fk` FOREIGN KEY (`project_id`) REFERENCES `projects` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE `elements`
ADD CONSTRAINT `page_elements_fk` FOREIGN KEY (`page_id`) REFERENCES `pages` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE `elements_attributes`
ADD CONSTRAINT `element_attributes_fk` FOREIGN KEY (`element_id`) REFERENCES `elements` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE `elements_style_props`
ADD CONSTRAINT `element_style_props_fk` FOREIGN KEY (`element_id`) REFERENCES `elements` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE `elements`
ADD CONSTRAINT `element_parent_fk` FOREIGN KEY (`parent_id`) REFERENCES `elements` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

INSERT INTO
    `users` (
        `name`,
        `username`,
        `email`,
        `password`
    )
VALUES (
        'User',
        'user',
        'test@workupy.com',
        '$2a$04$GsmJGbxyVnbJsMOO4.SVz.iZ57awk2l1GjntsyuCHqSadE/BNUbx2'
    );

INSERT INTO
    `projects` (`user_id`, `name`, `slug`)
VALUES (1, 'Store', 'my-store');

INSERT INTO
    `pages` (
        `project_id`,
        `name`,
        `title`,
        `path`,
        `index`
    )
VALUES (
        1,
        'Index',
        'Home',
        'home',
        true
    ),
    (
        1,
        'Products',
        'All Our Products',
        'products',
        false
    ),
    (
        1,
        'Support',
        'Support',
        'support',
        false
    );

INSERT INTO
    `elements` (
        `page_id`,
        `name`,
        `tag`,
        `x`,
        `y`
    )
VALUES (
        1,
        'footer',
        'ol',
        402.52,
        270.8
    ),
    (
        1,
        'sidebar',
        'p',
        8.23,
        306.18
    ),
    (
        1,
        'navigation',
        'ul',
        110.74,
        104.89
    ),
    (
        1,
        'content',
        'table',
        345.07,
        438.93
    ),
    (
        1,
        'content',
        'button',
        72.06,
        149.52
    ),
    (
        1,
        'sidebar',
        'img',
        426.39,
        146.43
    ),
    (
        1,
        'content',
        'div',
        439.71,
        490.64
    ),
    (
        1,
        'navigation',
        'button',
        17.85,
        476.22
    ),
    (
        1,
        'footer',
        'tr',
        496.16,
        455.49
    ),
    (
        1,
        'sidebar',
        'div',
        3.84,
        474.25
    );

INSERT INTO
    `elements` (
        `page_id`,
        `parent_id`,
        `name`,
        `tag`,
        `x`,
        `y`
    )
VALUES (
        1,
        2,
        'content',
        'ol',
        16.35,
        409.42
    ),
    (
        1,
        9,
        'sidebar',
        'h1',
        203.09,
        158.39
    ),
    (
        1,
        2,
        'footer',
        'h2',
        320.69,
        260.26
    ),
    (
        1,
        1,
        'sidebar',
        'h1',
        66.93,
        257.17
    ),
    (
        1,
        5,
        'sidebar',
        'td',
        404.03,
        411.93
    ),
    (
        1,
        5,
        'content',
        'a',
        247.32,
        352.27
    ),
    (
        1,
        4,
        'header',
        'button',
        45.73,
        494.13
    ),
    (
        1,
        4,
        'navigation',
        'div',
        190.0,
        472.0
    ),
    (
        1,
        8,
        'sidebar',
        'td',
        109.28,
        141.09
    ),
    (
        1,
        2,
        'navigation',
        'table',
        118.38,
        256.08
    ),
    (
        1,
        7,
        'navigation',
        'table',
        11.56,
        283.81
    ),
    (
        1,
        9,
        'navigation',
        'span',
        255.31,
        419.96
    ),
    (
        1,
        3,
        'header',
        'h3',
        167.33,
        134.14
    ),
    (
        1,
        5,
        'sidebar',
        'img',
        337.99,
        442.42
    ),
    (
        1,
        3,
        'navigation',
        'a',
        286.73,
        220.52
    ),
    (
        1,
        7,
        'header',
        'img',
        470.63,
        4.39
    ),
    (
        1,
        6,
        'content',
        'h1',
        50.33,
        185.41
    ),
    (
        1,
        4,
        'navigation',
        'a',
        393.9,
        48.31
    ),
    (
        1,
        5,
        'footer',
        'button',
        187.52,
        350.96
    ),
    (
        1,
        9,
        'header',
        'h2',
        96.01,
        138.19
    ),
    (
        1,
        1,
        'header',
        'h1',
        249.85,
        152.01
    ),
    (
        1,
        7,
        'header',
        'span',
        235.25,
        213.17
    ),
    (
        1,
        2,
        'footer',
        'h1',
        312.74,
        119.82
    ),
    (
        1,
        7,
        'sidebar',
        'table',
        7.46,
        343.79
    ),
    (
        1,
        1,
        'navigation',
        'p',
        121.42,
        347.26
    );

INSERT INTO
    `elements_attributes` (
        `element_id`,
        `attribute`,
        `value`
    )
VALUES (18, 'class', 'bl20I4'),
    (27, 'id', 'o8JvjG'),
    (19, 'title', 'Ps2Vhb'),
    (14, 'class', '2GaiJn'),
    (33, 'class', 'GZ3Phc'),
    (19, 'title', 'Mm8qUC'),
    (2, 'class', 'oRt68Y'),
    (17, 'src', '1u02l8'),
    (22, 'id', '5wcrL1'),
    (8, 'title', 'EK6IDW'),
    (8, 'src', 's5EsKs'),
    (1, 'width', 'XfqrMD'),
    (22, 'title', '7Zc3C4'),
    (34, 'alt', 'ycWMAw'),
    (16, 'width', 'nAh62N'),
    (9, 'title', 'SOL22v'),
    (28, 'height', 'Ps77ax'),
    (24, 'href', 'yWHe0r'),
    (6, 'id', 'zAx7r4'),
    (6, 'height', 'gvlqpu'),
    (27, 'id', 'n96ff3'),
    (5, 'alt', '4D8PzZ'),
    (18, 'class', 'SZ5kZ0'),
    (17, 'height', '3OhZC6'),
    (2, 'href', 'b6079X'),
    (10, 'width', 'GNg61J'),
    (27, 'height', 'W098ms'),
    (16, 'src', 'F6Pfsd'),
    (20, 'href', 'M9nA70'),
    (16, 'href', '37dous'),
    (13, 'class', '58F7vW'),
    (3, 'src', '672lc5'),
    (2, 'height', 'U6UIZc'),
    (1, 'title', 'lAAHN5'),
    (34, 'alt', '27L7Cc'),
    (8, 'title', 'ylYi53'),
    (18, 'href', 'iiB1nv'),
    (17, 'alt', '1ia38N'),
    (33, 'alt', '1Veac1'),
    (33, 'height', 'n91ISi'),
    (3, 'id', '6EzH67'),
    (20, 'class', 'Eh26ka'),
    (23, 'src', '8m6vcD'),
    (23, 'title', '8ulwzE'),
    (13, 'title', '6hDrym'),
    (31, 'title', 'I5JP6M'),
    (14, 'href', 'sFZF41'),
    (23, 'href', '1mHNm8'),
    (35, 'href', 'ye8cpj'),
    (20, 'src', 'ozqE1t');

INSERT INTO
    `elements_style_props` (
        `element_id`,
        `property`,
        `value`,
        `unit`
    )
VALUES (6, 'position', 'auto', 'em'),
    (
        33,
        'color',
        'capitalize',
        'px'
    ),
    (
        25,
        'background-color',
        'normal',
        null
    ),
    (28, 'font-size', '78', '%'),
    (27, 'margin', '42', 'px'),
    (31, 'position', '99', 'vh'),
    (
        14,
        'border-radius',
        '35',
        'vh'
    ),
    (33, 'display', '9', null),
    (33, 'display', '78', 'vw'),
    (
        7,
        'border-radius',
        'all',
        'vh'
    ),
    (13, 'position', '94', null),
    (11, 'padding', '71', null),
    (
        23,
        'font-size',
        'revert',
        'vh'
    ),
    (
        4,
        'padding',
        'break-word',
        null
    ),
    (
        15,
        'background-color',
        '42',
        'px'
    ),
    (8, 'position', '84', null),
    (8, 'color', 'inherit', 'rem'),
    (31, 'text-align', '42', null),
    (27, 'display', 'revert', '%'),
    (3, 'margin', '11', 'vh'),
    (16, 'font-size', '57', null),
    (18, 'text-align', '20', 'vw'),
    (
        16,
        'padding',
        'revert',
        'rem'
    ),
    (6, 'margin', '57', 'px'),
    (13, 'padding', '7', 'vw'),
    (33, 'padding', '76', 'em'),
    (14, 'padding', '7', 'px'),
    (
        17,
        'background-color',
        'initial',
        'px'
    ),
    (
        27,
        'text-align',
        'unset',
        'vw'
    ),
    (
        11,
        'position',
        'normal',
        null
    ),
    (21, 'padding', 'revert', 'vw'),
    (4, 'font-size', '94', 'px'),
    (26, 'padding', 'auto', 'rem'),
    (12, 'margin', 'normal', 'vw'),
    (
        18,
        'border-radius',
        'unset',
        'vw'
    ),
    (18, 'position', '9', 'px'),
    (3, 'font-size', 'all', 'vw'),
    (
        6,
        'border-radius',
        '70',
        null
    ),
    (
        34,
        'border-radius',
        'all',
        'rem'
    ),
    (20, 'padding', '7', 'em'),
    (
        9,
        'text-align',
        'inherit',
        null
    ),
    (35, 'position', '76', 'vw'),
    (
        21,
        'border-radius',
        'break-word',
        'vh'
    ),
    (3, 'position', '42', null),
    (7, 'margin', '70', '%'),
    (13, 'position', '21', '%'),
    (25, 'font-size', '21', 'vw'),
    (14, 'font-size', '11', 'em'),
    (2, 'color', '5', 'em'),
    (19, 'color', '7', 'px');
