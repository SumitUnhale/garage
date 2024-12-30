--
-- PostgreSQL database dump
--

-- Dumped from database version 17.0
-- Dumped by pg_dump version 17.0

-- Started on 2024-12-27 17:44:47

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- TOC entry 6 (class 2615 OID 32768)
-- Name: garage; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA garage;


ALTER SCHEMA garage OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 227 (class 1259 OID 33004)
-- Name: bill; Type: TABLE; Schema: garage; Owner: postgres
--

CREATE TABLE garage.bill (
    bill_id integer NOT NULL,
    customer_id integer NOT NULL,
    service_id integer NOT NULL,
    total_amount numeric(10,2) NOT NULL,
    paid_flag boolean DEFAULT false NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    customer_name character varying(255)
);


ALTER TABLE garage.bill OWNER TO postgres;

--
-- TOC entry 226 (class 1259 OID 33003)
-- Name: bill_bill_id_seq; Type: SEQUENCE; Schema: garage; Owner: postgres
--

CREATE SEQUENCE garage.bill_bill_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE garage.bill_bill_id_seq OWNER TO postgres;

--
-- TOC entry 4912 (class 0 OID 0)
-- Dependencies: 226
-- Name: bill_bill_id_seq; Type: SEQUENCE OWNED BY; Schema: garage; Owner: postgres
--

ALTER SEQUENCE garage.bill_bill_id_seq OWNED BY garage.bill.bill_id;


--
-- TOC entry 219 (class 1259 OID 32780)
-- Name: customer; Type: TABLE; Schema: garage; Owner: postgres
--

CREATE TABLE garage.customer (
    customer_id integer NOT NULL,
    name character varying(255) NOT NULL,
    address text,
    mobile_number character varying(15),
    car_plate_number character varying(15),
    created_by character varying(255),
    created_time timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE garage.customer OWNER TO postgres;

--
-- TOC entry 218 (class 1259 OID 32779)
-- Name: customer_id_seq; Type: SEQUENCE; Schema: garage; Owner: postgres
--

CREATE SEQUENCE garage.customer_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE garage.customer_id_seq OWNER TO postgres;

--
-- TOC entry 4913 (class 0 OID 0)
-- Dependencies: 218
-- Name: customer_id_seq; Type: SEQUENCE OWNED BY; Schema: garage; Owner: postgres
--

ALTER SEQUENCE garage.customer_id_seq OWNED BY garage.customer.customer_id;


--
-- TOC entry 224 (class 1259 OID 32979)
-- Name: part; Type: TABLE; Schema: garage; Owner: postgres
--

CREATE TABLE garage.part (
    part_id integer NOT NULL,
    service_id integer NOT NULL,
    car_plate_num character varying(15) NOT NULL,
    part_name character varying(100) NOT NULL,
    quantity integer NOT NULL,
    rate numeric(10,2) NOT NULL,
    labour_charge numeric(10,2) NOT NULL,
    total_bill numeric(10,2) GENERATED ALWAYS AS ((((quantity)::numeric * rate) + labour_charge)) STORED
);


ALTER TABLE garage.part OWNER TO postgres;

--
-- TOC entry 223 (class 1259 OID 32978)
-- Name: part_part_id_seq; Type: SEQUENCE; Schema: garage; Owner: postgres
--

CREATE SEQUENCE garage.part_part_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE garage.part_part_id_seq OWNER TO postgres;

--
-- TOC entry 4914 (class 0 OID 0)
-- Dependencies: 223
-- Name: part_part_id_seq; Type: SEQUENCE OWNED BY; Schema: garage; Owner: postgres
--

ALTER SEQUENCE garage.part_part_id_seq OWNED BY garage.part.part_id;


--
-- TOC entry 222 (class 1259 OID 32873)
-- Name: service; Type: TABLE; Schema: garage; Owner: postgres
--

CREATE TABLE garage.service (
    service_id integer NOT NULL,
    customer_id integer NOT NULL,
    service_date timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    note text
);


ALTER TABLE garage.service OWNER TO postgres;

--
-- TOC entry 221 (class 1259 OID 32872)
-- Name: service_service_id_seq; Type: SEQUENCE; Schema: garage; Owner: postgres
--

CREATE SEQUENCE garage.service_service_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE garage.service_service_id_seq OWNER TO postgres;

--
-- TOC entry 4915 (class 0 OID 0)
-- Dependencies: 221
-- Name: service_service_id_seq; Type: SEQUENCE OWNED BY; Schema: garage; Owner: postgres
--

ALTER SEQUENCE garage.service_service_id_seq OWNED BY garage.service.service_id;


--
-- TOC entry 229 (class 1259 OID 33030)
-- Name: v_servicelist; Type: VIEW; Schema: garage; Owner: postgres
--

CREATE VIEW garage.v_servicelist AS
 SELECT s.service_id,
    s.customer_id,
    s.service_date,
    s.note,
    c.name,
    c.address,
    c.mobile_number,
    c.car_plate_number
   FROM (garage.service s
     RIGHT JOIN garage.customer c ON ((s.customer_id = c.customer_id)))
  WHERE (s.service_id IS NOT NULL)
  ORDER BY s.service_id;


ALTER VIEW garage.v_servicelist OWNER TO postgres;

--
-- TOC entry 220 (class 1259 OID 32790)
-- Name: vehicle; Type: TABLE; Schema: garage; Owner: postgres
--

CREATE TABLE garage.vehicle (
    car_plate_number character varying(15) NOT NULL,
    customer_id integer,
    vehicle_company character varying(255) NOT NULL,
    model_name character varying(255) NOT NULL,
    running_km integer NOT NULL
);


ALTER TABLE garage.vehicle OWNER TO postgres;

--
-- TOC entry 4731 (class 2604 OID 33007)
-- Name: bill bill_id; Type: DEFAULT; Schema: garage; Owner: postgres
--

ALTER TABLE ONLY garage.bill ALTER COLUMN bill_id SET DEFAULT nextval('garage.bill_bill_id_seq'::regclass);


--
-- TOC entry 4725 (class 2604 OID 32783)
-- Name: customer customer_id; Type: DEFAULT; Schema: garage; Owner: postgres
--

ALTER TABLE ONLY garage.customer ALTER COLUMN customer_id SET DEFAULT nextval('garage.customer_id_seq'::regclass);


--
-- TOC entry 4729 (class 2604 OID 32982)
-- Name: part part_id; Type: DEFAULT; Schema: garage; Owner: postgres
--

ALTER TABLE ONLY garage.part ALTER COLUMN part_id SET DEFAULT nextval('garage.part_part_id_seq'::regclass);


--
-- TOC entry 4727 (class 2604 OID 32876)
-- Name: service service_id; Type: DEFAULT; Schema: garage; Owner: postgres
--

ALTER TABLE ONLY garage.service ALTER COLUMN service_id SET DEFAULT nextval('garage.service_service_id_seq'::regclass);


--
-- TOC entry 4906 (class 0 OID 33004)
-- Dependencies: 227
-- Data for Name: bill; Type: TABLE DATA; Schema: garage; Owner: postgres
--

COPY garage.bill (bill_id, customer_id, service_id, total_amount, paid_flag, created_at, customer_name) FROM stdin;
2	22	22	5000.00	f	2024-12-14 10:55:47.230512	\N
\.


--
-- TOC entry 4899 (class 0 OID 32780)
-- Dependencies: 219
-- Data for Name: customer; Type: TABLE DATA; Schema: garage; Owner: postgres
--

COPY garage.customer (customer_id, name, address, mobile_number, car_plate_number, created_by, created_time) FROM stdin;
1	John Doe	123 Main St	123-456-7890	ABC1234	admin	2024-12-05 20:53:50.858566
\.


--
-- TOC entry 4904 (class 0 OID 32979)
-- Dependencies: 224
-- Data for Name: part; Type: TABLE DATA; Schema: garage; Owner: postgres
--

COPY garage.part (part_id, service_id, car_plate_num, part_name, quantity, rate, labour_charge) FROM stdin;
5	2	MH09AK6710	Oil Filter	2	10.00	5.00
\.


--
-- TOC entry 4902 (class 0 OID 32873)
-- Dependencies: 222
-- Data for Name: service; Type: TABLE DATA; Schema: garage; Owner: postgres
--

COPY garage.service (service_id, customer_id, service_date, note) FROM stdin;
2	1	2024-12-06 18:55:30.499168	general checkup
\.


--
-- TOC entry 4900 (class 0 OID 32790)
-- Dependencies: 220
-- Data for Name: vehicle; Type: TABLE DATA; Schema: garage; Owner: postgres
--

COPY garage.vehicle (car_plate_number, customer_id, vehicle_company, model_name, running_km) FROM stdin;
9456213122	1	maruti	brezza	1500
\.


--
-- TOC entry 4916 (class 0 OID 0)
-- Dependencies: 226
-- Name: bill_bill_id_seq; Type: SEQUENCE SET; Schema: garage; Owner: postgres
--

SELECT pg_catalog.setval('garage.bill_bill_id_seq', 44, true);


--
-- TOC entry 4917 (class 0 OID 0)
-- Dependencies: 218
-- Name: customer_id_seq; Type: SEQUENCE SET; Schema: garage; Owner: postgres
--

SELECT pg_catalog.setval('garage.customer_id_seq', 57, true);


--
-- TOC entry 4918 (class 0 OID 0)
-- Dependencies: 223
-- Name: part_part_id_seq; Type: SEQUENCE SET; Schema: garage; Owner: postgres
--

SELECT pg_catalog.setval('garage.part_part_id_seq', 116, true);


--
-- TOC entry 4919 (class 0 OID 0)
-- Dependencies: 221
-- Name: service_service_id_seq; Type: SEQUENCE SET; Schema: garage; Owner: postgres
--

SELECT pg_catalog.setval('garage.service_service_id_seq', 74, true);


--
-- TOC entry 4745 (class 2606 OID 33011)
-- Name: bill bill_pkey; Type: CONSTRAINT; Schema: garage; Owner: postgres
--

ALTER TABLE ONLY garage.bill
    ADD CONSTRAINT bill_pkey PRIMARY KEY (bill_id);


--
-- TOC entry 4735 (class 2606 OID 32787)
-- Name: customer customer_pkey; Type: CONSTRAINT; Schema: garage; Owner: postgres
--

ALTER TABLE ONLY garage.customer
    ADD CONSTRAINT customer_pkey PRIMARY KEY (customer_id);


--
-- TOC entry 4743 (class 2606 OID 32985)
-- Name: part part_pkey; Type: CONSTRAINT; Schema: garage; Owner: postgres
--

ALTER TABLE ONLY garage.part
    ADD CONSTRAINT part_pkey PRIMARY KEY (part_id);


--
-- TOC entry 4741 (class 2606 OID 32881)
-- Name: service service_pkey; Type: CONSTRAINT; Schema: garage; Owner: postgres
--

ALTER TABLE ONLY garage.service
    ADD CONSTRAINT service_pkey PRIMARY KEY (service_id);


--
-- TOC entry 4737 (class 2606 OID 32956)
-- Name: customer unique_car_plate_num; Type: CONSTRAINT; Schema: garage; Owner: postgres
--

ALTER TABLE ONLY garage.customer
    ADD CONSTRAINT unique_car_plate_num UNIQUE (car_plate_number);


--
-- TOC entry 4739 (class 2606 OID 32796)
-- Name: vehicle vehicle_pkey; Type: CONSTRAINT; Schema: garage; Owner: postgres
--

ALTER TABLE ONLY garage.vehicle
    ADD CONSTRAINT vehicle_pkey PRIMARY KEY (car_plate_number);


--
-- TOC entry 4749 (class 2606 OID 33012)
-- Name: bill fk_customer_id; Type: FK CONSTRAINT; Schema: garage; Owner: postgres
--

ALTER TABLE ONLY garage.bill
    ADD CONSTRAINT fk_customer_id FOREIGN KEY (customer_id) REFERENCES garage.customer(customer_id);


--
-- TOC entry 4750 (class 2606 OID 33017)
-- Name: bill fk_service_id; Type: FK CONSTRAINT; Schema: garage; Owner: postgres
--

ALTER TABLE ONLY garage.bill
    ADD CONSTRAINT fk_service_id FOREIGN KEY (service_id) REFERENCES garage.service(service_id);


--
-- TOC entry 4747 (class 2606 OID 32991)
-- Name: part part_car_plate_num_fkey; Type: FK CONSTRAINT; Schema: garage; Owner: postgres
--

ALTER TABLE ONLY garage.part
    ADD CONSTRAINT part_car_plate_num_fkey FOREIGN KEY (car_plate_num) REFERENCES garage.customer(car_plate_number) ON DELETE CASCADE;


--
-- TOC entry 4748 (class 2606 OID 32986)
-- Name: part part_service_id_fkey; Type: FK CONSTRAINT; Schema: garage; Owner: postgres
--

ALTER TABLE ONLY garage.part
    ADD CONSTRAINT part_service_id_fkey FOREIGN KEY (service_id) REFERENCES garage.service(service_id) ON DELETE CASCADE;


--
-- TOC entry 4746 (class 2606 OID 32882)
-- Name: service service_customer_id_fkey; Type: FK CONSTRAINT; Schema: garage; Owner: postgres
--

ALTER TABLE ONLY garage.service
    ADD CONSTRAINT service_customer_id_fkey FOREIGN KEY (customer_id) REFERENCES garage.customer(customer_id) ON DELETE CASCADE;


-- Completed on 2024-12-27 17:44:47

--
-- PostgreSQL database dump complete
--

