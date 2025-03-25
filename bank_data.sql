CREATE SCHEMA bank_Horsens;
SET SCHEMA 'bank_Horsens';

CREATE TYPE position_type AS ENUM(
    'nurse',
    'bioalytic',
    'intern'
);

CREATE TYPE blood_type AS ENUM(
    'O-',
    'O+',
    'B-',
    'B+',
    'A-',
    'A+',
    'AB-',
    'AB+'
);

CREATE TABLE donor(
    cpr VARCHAR(10) PRIMARY KEY,
    full_name VARCHAR(100),
    house_number SMALLINT,
    street VARCHAR(100),
    city VARCHAR(100),
    postal_code SMALLINT,
    phone SMALLINT,
    blood_type blood_type NOT NULL,
    last_reminder DATE
);

CREATE TABLE staff(
    initials CHAR(4) PRIMARY KEY,
    cpr VARCHAR(10) UNIQUE NOT NULL,
    full_name VARCHAR(100),
    house_number SMALLINT,
    street VARCHAR(100),
    city VARCHAR(100),
    postal_code SMALLINT,
    phone SMALLINT,
    hire_date DATE,
    position position_type NOT NULL
);

CREATE TABLE blood_donations(
    id SERIAL PRIMARY KEY,
    donor_cpr VARCHAR(10) REFERENCES donor(cpr),
    amount SMALLINT CHECK (amount BETWEEN 300 AND 600),
    blood_percent DECIMAL(3,1) CHECK (blood_percent BETWEEN 8.0 AND 11.0),
    donation_date DATE NOT NULL DEFAULT CURRENT_DATE
);

CREATE TABLE managed_by(
    collected_by_nurse_id CHAR(4) REFERENCES staff(initials),
    donation_id INTEGER REFERENCES blood_donations(id),
    verified_by_nurse_initials CHAR(4) REFERENCES staff(initials),
    PRIMARY KEY (donation_id),
    CHECK (collected_by_nurse_id <> verified_by_nurse_initials)
);

CREATE TABLE next_appointment(
    date DATE,
    time TIME,
    donor_cpr VARCHAR(10) REFERENCES donor(cpr),
    PRIMARY KEY(date, donor_cpr)
);

INSERT INTO donor (cpr, full_name, house_number, street, city, postal_code, phone, blood_type, last_reminder)
VALUES
        (1408096745, 'Luis Silva', 6, 'cais', 'Horsens', 4005, 5016841, 'O-', 2025/02/01),
        (1408096745, 'Luis Silva', 6, 'cais', 'Horsens', 4005, 5016841, 'O-', 2025/02/01);

INSERT INTO staff (initials, cpr, full_name, house_number, street, city, postal_code, phone, hire_date, position)
VALUES
    ('LF', '1506781234', 'Lucas Figueiredo', 12, 'Ikivej', 'Horsens', 4005, 12345678, '2018-05-15', 'nurse'),
    ('MS', '2304815678', 'Mateus Silva', 45, 'Likivej', 'Horsens', 4005, 87654321, '2020-02-10', 'bioalytic');

INSERT INTO blood_donations (amount, blood_percent, donor_cpr)
VALUES
    (450, 9.5, '1408096745'),
    (500, 10.2, '1408096746');

INSERT INTO managed_by (collected_by_nurse_id, donation_id, verified_by_nurse_initials)
VALUES
    ('LF', 1, 'MS'),
    ('MS', 2, 'LF');

INSERT INTO next_appointment (date, time, donor_cpr)
VALUES
    ('2023-12-15', '10:00:00', '1408096745'),
    ('2023-12-16', '11:30:00', '1408096745');



