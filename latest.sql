--
-- PostgreSQL database dump
--

-- Dumped from database version 17.5
-- Dumped by pg_dump version 17.5

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
-- Name: check_num(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.check_num(n integer) RETURNS text
    LANGUAGE plpgsql
    AS $$
BEGIN
IF n>0 THEN 
     RETURN 'positive';
ELSEIF n<0 THEN
     RETURN 'NEGATIVE';
ELSE
  RETURN 'ZERO';

END IF;

END;
$$;


ALTER FUNCTION public.check_num(n integer) OWNER TO postgres;

--
-- Name: even_1_50(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.even_1_50() RETURNS SETOF integer
    LANGUAGE plpgsql
    AS $$
DECLARE
i INT;
BEGIN 
FOR i IN 1..50 LOOP
    IF i%2=0 THEN
	   RETURN NEXT i;
	 END IF;
END LOOP;
END;
$$;


ALTER FUNCTION public.even_1_50() OWNER TO postgres;

--
-- Name: min_max_three(integer, integer, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.min_max_three(a integer, b integer, c integer) RETURNS text
    LANGUAGE plpgsql
    AS $$ 
BEGIN 
RETURN CONCAT('MAX=',GREATEST(a,b,c),'MIN=',LEAST(a,b,c));
END;
$$;


ALTER FUNCTION public.min_max_three(a integer, b integer, c integer) OWNER TO postgres;

--
-- Name: min_max_two(integer, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.min_max_two(a integer, b integer) RETURNS text
    LANGUAGE plpgsql
    AS $$
DECLARE
result TEXT;

	BEGIN
 IF a>b THEN 
   result := CONCAT('max=', a, 'min=',b);
ELSE 
   result :=CONCAT('MAX=',b,'MIN=',a);

END IF;

RETURN result;

END;
$$;


ALTER FUNCTION public.min_max_two(a integer, b integer) OWNER TO postgres;

--
-- Name: search_range(integer, integer, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.search_range(num integer, m integer, n integer) RETURNS text
    LANGUAGE plpgsql
    AS $$
BEGIN 
IF num 	 BETWEEN m AND  n THEN
   RETURN 'FOUND IN RANGE';

ELSE
    RETURN 'NOT IN  RANGE' ;
END IF;
END;
$$;


ALTER FUNCTION public.search_range(num integer, m integer, n integer) OWNER TO postgres;

--
-- Name: sum_20(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.sum_20() RETURNS integer
    LANGUAGE plpgsql
    AS $$ 
DECLARE
i INT:=1;
S int :=0;
BEGIN
LOOP
     s:=s+i;
	 i:=i+1;
  EXIT WHEN i >20;
   END LOOP ;

 RETURN s;
 END;
 $$;


ALTER FUNCTION public.sum_20() OWNER TO postgres;

--
-- Name: sum_avg(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.sum_avg(n integer) RETURNS text
    LANGUAGE plpgsql
    AS $$
DECLARE 
i INT := 1;
s INT:= 0;
avg NUMERIC ;
BEGIN 
WHILE i<=n LOOP
    s:=s+i;
	i:=i+1;
END LOOP ;

avg:=s/n;

RETURN 'sum='||s||'AVG='||avg;
END;
$$;


ALTER FUNCTION public.sum_avg(n integer) OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: order_items; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.order_items (
    id integer NOT NULL,
    order_id integer,
    product_id integer,
    quantity integer NOT NULL,
    subtotal numeric(10,2)
);


ALTER TABLE public.order_items OWNER TO postgres;

--
-- Name: order_items_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.order_items_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.order_items_id_seq OWNER TO postgres;

--
-- Name: order_items_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.order_items_id_seq OWNED BY public.order_items.id;


--
-- Name: orders; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.orders (
    id integer NOT NULL,
    user_id integer,
    total_amount numeric(10,2),
    payment_status character varying(20) DEFAULT 'Pending'::character varying,
    delivery_address text,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.orders OWNER TO postgres;

--
-- Name: orders_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.orders_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.orders_id_seq OWNER TO postgres;

--
-- Name: orders_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.orders_id_seq OWNED BY public.orders.id;


--
-- Name: products; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.products (
    id integer NOT NULL,
    name character varying(150) NOT NULL,
    description text,
    price numeric(10,2) NOT NULL,
    category character varying(50),
    image_url text,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.products OWNER TO postgres;

--
-- Name: products_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.products_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.products_id_seq OWNER TO postgres;

--
-- Name: products_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.products_id_seq OWNED BY public.products.id;


--
-- Name: userid; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.userid (
    id integer NOT NULL,
    user_id character varying(10),
    name character varying(100),
    email character varying(100),
    password character varying(100),
    phone character varying(15)
);


ALTER TABLE public.userid OWNER TO postgres;

--
-- Name: userid_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.userid_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.userid_id_seq OWNER TO postgres;

--
-- Name: userid_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.userid_id_seq OWNED BY public.userid.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.users (
    id integer NOT NULL,
    name character varying(100) NOT NULL,
    email character varying(150) NOT NULL,
    password character varying(255) NOT NULL,
    phone character varying(15),
    address text,
    pincode character varying(10),
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.users OWNER TO postgres;

--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.users_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.users_id_seq OWNER TO postgres;

--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- Name: order_items id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_items ALTER COLUMN id SET DEFAULT nextval('public.order_items_id_seq'::regclass);


--
-- Name: orders id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.orders ALTER COLUMN id SET DEFAULT nextval('public.orders_id_seq'::regclass);


--
-- Name: products id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.products ALTER COLUMN id SET DEFAULT nextval('public.products_id_seq'::regclass);


--
-- Name: userid id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.userid ALTER COLUMN id SET DEFAULT nextval('public.userid_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- Data for Name: order_items; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.order_items (id, order_id, product_id, quantity, subtotal) FROM stdin;
\.


--
-- Data for Name: orders; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.orders (id, user_id, total_amount, payment_status, delivery_address, created_at) FROM stdin;
\.


--
-- Data for Name: products; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.products (id, name, description, price, category, image_url, created_at) FROM stdin;
91	Shahi Paneer	Creamy rich paneer cooked in royal gravy	269.00	Veg	shahi-paneer.jpg	2026-03-03 00:33:24.694926
92	Kadai Paneer	Spicy paneer with capsicum and onion	249.00	Veg	kadai-paneer.jpg	2026-03-03 00:33:24.694926
93	Malai Kofta	Soft dumplings in creamy white gravy	259.00	Veg	malai-kofta.jpg	2026-03-03 00:33:24.694926
94	Chole Bhature	Spicy chickpeas served with fluffy bhature	189.00	Veg	chole-bhature.jpg	2026-03-03 00:33:24.694926
95	Paneer Tikka	Grilled paneer cubes with spices	229.00	Veg	paneer-tikka.jpg	2026-03-03 00:33:24.694926
96	Veg Kolhapuri	Spicy mixed vegetable curry	219.00	Veg	veg-kolhapuri.jpg	2026-03-03 00:33:24.694926
97	Aloo Gobi	Potato and cauliflower cooked with spices	179.00	Veg	aloo-gobi.jpg	2026-03-03 00:33:24.694926
98	Bhindi Masala	Stir fried okra with onion masala	189.00	Veg	bhindi-masala.jpg	2026-03-03 00:33:24.694926
99	Dal Makhani	Slow cooked black lentils with butter	209.00	Veg	dal-makhani.jpg	2026-03-03 00:33:24.694926
100	Rajma Masala	Kidney beans cooked in thick gravy	199.00	Veg	rajma.jpg	2026-03-03 00:33:24.694926
101	Veg Pulao	Mildly spiced vegetable rice	179.00	Veg	veg-pulao.jpg	2026-03-03 00:33:24.694926
102	Jeera Rice	Basmati rice tempered with cumin	149.00	Veg	jeera-rice.jpg	2026-03-03 00:33:24.694926
103	Tandoori Roti	Clay oven baked roti	29.00	Veg	tandoori-roti.jpg	2026-03-03 00:33:24.694926
104	Butter Naan	Soft naan brushed with butter	49.00	Veg	butter-naan.jpg	2026-03-03 00:33:24.694926
105	Veg Hakka Noodles	Stir fried noodles with vegetables	189.00	Veg	veg-noodles.jpg	2026-03-03 00:33:24.694926
106	Chicken Handi	Traditional chicken curry cooked in handi	299.00	Non-Veg	chicken-handi.jpg	2026-03-03 00:33:59.04398
107	Butter Chicken	Creamy tomato gravy with tender chicken	319.00	Non-Veg	butter-chicken.jpg	2026-03-03 00:33:59.04398
108	Chicken Tikka	Spicy grilled chicken cubes	249.00	Non-Veg	chicken-tikka.jpg	2026-03-03 00:33:59.04398
109	Chicken Biryani	Authentic dum style chicken biryani	299.00	Non-Veg	chicken-biryani.jpg	2026-03-03 00:33:59.04398
110	Mutton Rogan Josh	Kashmiri style mutton curry	379.00	Non-Veg	mutton-rogan.jpg	2026-03-03 00:33:59.04398
111	Mutton Biryani	Slow cooked basmati rice with mutton	349.00	Non-Veg	mutton-biryani.jpg	2026-03-03 00:33:59.04398
112	Fish Fry	Crispy shallow fried spicy fish	289.00	Non-Veg	fish-fry.jpg	2026-03-03 00:33:59.04398
113	Chicken Lollipop	Crispy fried drumettes	229.00	Non-Veg	chicken-lollipop.jpg	2026-03-03 00:33:59.04398
114	Chicken Seekh Kebab	Minced chicken grilled on skewers	249.00	Non-Veg	seekh-kebab.jpg	2026-03-03 00:33:59.04398
115	Egg Curry	Boiled eggs cooked in spicy gravy	199.00	Non-Veg	egg-curry.jpg	2026-03-03 00:33:59.04398
116	Chicken Afghani	Creamy grilled chicken with mild spices	329.00	Non-Veg	chicken-afghani.jpg	2026-03-03 00:33:59.04398
117	Chicken Hakka Noodles	Stir fried noodles with chicken	239.00	Non-Veg	chicken-noodles.jpg	2026-03-03 00:33:59.04398
118	Prawn Masala	Spicy prawn curry cooked with herbs	359.00	Non-Veg	prawn-masala.jpg	2026-03-03 00:33:59.04398
119	Chicken 65	Deep fried spicy chicken bites	249.00	Non-Veg	chicken-65.jpg	2026-03-03 00:33:59.04398
120	Grilled Chicken Steak	Juicy grilled chicken with herbs	329.00	Non-Veg	chicken-steak.jpg	2026-03-03 00:33:59.04398
121	Veg Burger	Crispy veg patty with fresh lettuce	149.00	Fast Food	veg-burger.jpg	2026-03-03 00:34:41.773384
122	Chicken Burger	Juicy crispy chicken patty	169.00	Fast Food	chicken-burger.jpg	2026-03-03 00:34:41.773384
123	Veg Supreme Pizza	Loaded pizza with capsicum and cheese	299.00	Fast Food	veg-pizza.jpg	2026-03-03 00:34:41.773384
124	Chicken Supreme Pizza	Loaded chicken pizza with cheese	349.00	Fast Food	chicken-pizza.jpg	2026-03-03 00:34:41.773384
125	French Fries	Crispy salted potato fries	99.00	Fast Food	fries.jpg	2026-03-03 00:34:41.773384
126	Peri Peri Fries	Spicy peri peri fries	119.00	Fast Food	peri-fries.jpg	2026-03-03 00:34:41.773384
127	Chicken Nuggets	Crispy golden fried chicken bites	179.00	Fast Food	nuggets.jpg	2026-03-03 00:34:41.773384
128	Garlic Bread	Toasted garlic bread with herbs	119.00	Fast Food	garlic-bread.jpg	2026-03-03 00:34:41.773384
129	Chicken Wrap	Spicy chicken wrapped in tortilla	189.00	Fast Food	chicken-wrap.jpg	2026-03-03 00:34:41.773384
130	Paneer Wrap	Spicy paneer wrap with sauce	179.00	Fast Food	paneer-wrap.jpg	2026-03-03 00:34:41.773384
131	Green Apple Mojito	Green apple syrup with mint and soda	149.00	Mocktail	green-apple-mojito.jpg	2026-03-03 00:35:14.301891
132	Berry Blast	Mixed berry refreshing drink	169.00	Mocktail	berry-blast.jpg	2026-03-03 00:35:14.301891
133	Litchi Sparkler	Sweet litchi soda cooler	159.00	Mocktail	litchi-sparkler.jpg	2026-03-03 00:35:14.301891
134	Kiwi Cooler	Fresh kiwi mint cooler	149.00	Mocktail	kiwi-cooler.jpg	2026-03-03 00:35:14.301891
135	Mango Magic	Sweet mango mint refreshment	159.00	Mocktail	mango-magic.jpg	2026-03-03 00:35:14.301891
136	Coca Cola	Chilled refreshing cola	49.00	Cold Drink	coca-cola.jpg	2026-03-03 00:35:37.637519
137	Pepsi	Classic carbonated soft drink	49.00	Cold Drink	pepsi.jpg	2026-03-03 00:35:37.637519
138	Sprite	Lemon flavored soda	49.00	Cold Drink	sprite.jpg	2026-03-03 00:35:37.637519
139	Fanta	Orange sparkling drink	49.00	Cold Drink	fanta.jpg	2026-03-03 00:35:37.637519
140	Thumbs Up	Strong cola flavored drink	55.00	Cold Drink	thumbs-up.jpg	2026-03-03 00:35:37.637519
141	Packaged Water	Pure mineral water bottle	20.00	Cold Drink	water.jpg	2026-03-03 00:35:37.637519
142	Mini Veg Thali	Dal, 2 sabzi, rice, 2 roti, salad and sweet	249.00	Thali	mini-veg-thali.jpg	2026-03-03 13:42:46.13565
143	Special Veg Thali	Paneer curry, mix veg, dal, rice, roti, papad, sweet	299.00	Thali	special-veg-thali.jpg	2026-03-03 13:42:46.13565
144	Punjabi Veg Thali	Shahi paneer, dal makhani, jeera rice, butter naan	349.00	Thali	punjabi-veg-thali.jpg	2026-03-03 13:42:46.13565
145	South Indian Veg Thali	Sambar, rasam, poriyal, curd rice, papad	279.00	Thali	south-veg-thali.jpg	2026-03-03 13:42:46.13565
146	Royal Veg Thali	Paneer butter masala, malai kofta, pulao, naan, dessert	399.00	Thali	royal-veg-thali.jpg	2026-03-03 13:42:46.13565
147	Mini Chicken Thali	Chicken curry, dal, rice, roti, salad	299.00	Thali	mini-chicken-thali.jpg	2026-03-03 13:42:46.13565
148	Special Chicken Thali	Butter chicken, jeera rice, naan, salad, sweet	349.00	Thali	special-chicken-thali.jpg	2026-03-03 13:42:46.13565
149	Mutton Thali	Mutton curry, rice, roti, dal, salad	399.00	Thali	mutton-thali.jpg	2026-03-03 13:42:46.13565
150	Fish Thali	Fish curry, steamed rice, solkadhi, salad	379.00	Thali	fish-thali.jpg	2026-03-03 13:42:46.13565
151	Royal Non-Veg Thali	Chicken curry, mutton masala, rice, naan, dessert	449.00	Thali	royal-nonveg-thali.jpg	2026-03-03 13:42:46.13565
185	Paneer Tikka	Grilled paneer cubes with spices	249.00	Starter	paneer-tikka.jpg	2026-03-25 23:23:12.97878
187	Veg Spring Roll	Crunchy rolls filled with veggies	199.00	Starter	spring-roll.jpg	2026-03-25 23:23:12.97878
188	Gobi Manchurian	Crispy cauliflower in spicy sauce	219.00	Starter	gobi.jpg	2026-03-25 23:23:12.97878
189	Chicken 65	Spicy deep fried chicken	279.00	Starter	chicken-65.jpg	2026-03-25 23:23:12.97878
190	Paneer Chilli	Indo-Chinese paneer starter	259.00	Starter	paneer-chilli.jpg	2026-03-25 23:23:12.97878
191	Fish Fry	Crispy fried fish fillet	299.00	Starter	fish-fry.jpg	2026-03-25 23:23:12.97878
192	Cheese Balls	Fried cheese filled balls	229.00	Starter	cheese-balls.jpg	2026-03-25 23:23:12.97878
193	Corn Cheese Nuggets	Corn & cheese crispy bites	179.00	Starter	corn-nuggets.jpg	2026-03-25 23:23:12.97878
194	Tandoori Mushroom	Grilled spicy mushroom starter	239.00	Starter	mushroom.jpg	2026-03-25 23:23:12.97878
206	Urban Lava Paneer Stack	Layered grilled paneer with molten cheese core, served with smoky sauce drizzle	399.00	Signature	lava-paneer.jpg	2026-03-25 23:38:12.999498
207	Street King Loaded Chicken Bowl	Spicy chicken, cheesy fries, rice & signature sauces in one ultimate power bowl	449.00	Signature	chicken-bowl.jpg	2026-03-25 23:38:12.999498
208	Midnight Craving Box	Curated combo of mini burger, fries, nuggets & dip – perfect late-night feast	499.00	Signature	craving-box.jpg	2026-03-25 23:38:12.999498
210	Chicken Tikka	Spicy grilled chicken cubes marinated in Indian spices	249.00	Starter	chicken-tikka.jpg	2026-03-26 18:09:15.542008
211	Chicken Kebab	Juicy charcoal roasted kebabs served hot & fresh	199.00	Starter	chicken-kebab.jpg	2026-03-26 18:09:15.542008
212	Chicken Roll	Soft wrap filled with spicy chicken and fresh veggies	149.00	Starter	chicken-roll.jpg	2026-03-26 18:09:15.542008
186	Chicken Lollipop	Crispy fried chicken lollipops tossed in spicy masala sauce	229.00	Starter	chicken-lollipop.jpg	2026-03-25 23:23:12.97878
\.


--
-- Data for Name: userid; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.userid (id, user_id, name, email, password, phone) FROM stdin;
1	U6569	Siddhant	test@gmail.com	1234	9876543210
2	U7602	Siddhant	jhasiddhant339@gmail.com	root	9518783795
5	U3165	Siddhant	hiteshjha394@gmail.com	bhai	8446049402
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.users (id, name, email, password, phone, address, pincode, created_at) FROM stdin;
\.


--
-- Name: order_items_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.order_items_id_seq', 1, false);


--
-- Name: orders_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.orders_id_seq', 1, false);


--
-- Name: products_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.products_id_seq', 233, true);


--
-- Name: userid_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.userid_id_seq', 6, true);


--
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.users_id_seq', 1, false);


--
-- Name: order_items order_items_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_items
    ADD CONSTRAINT order_items_pkey PRIMARY KEY (id);


--
-- Name: orders orders_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_pkey PRIMARY KEY (id);


--
-- Name: products products_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.products
    ADD CONSTRAINT products_pkey PRIMARY KEY (id);


--
-- Name: products unique_product; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.products
    ADD CONSTRAINT unique_product UNIQUE (name, category);


--
-- Name: userid userid_email_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.userid
    ADD CONSTRAINT userid_email_key UNIQUE (email);


--
-- Name: userid userid_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.userid
    ADD CONSTRAINT userid_pkey PRIMARY KEY (id);


--
-- Name: userid userid_user_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.userid
    ADD CONSTRAINT userid_user_id_key UNIQUE (user_id);


--
-- Name: users users_email_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key UNIQUE (email);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: order_items order_items_order_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_items
    ADD CONSTRAINT order_items_order_id_fkey FOREIGN KEY (order_id) REFERENCES public.orders(id) ON DELETE CASCADE;


--
-- Name: order_items order_items_product_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_items
    ADD CONSTRAINT order_items_product_id_fkey FOREIGN KEY (product_id) REFERENCES public.products(id);


--
-- Name: orders orders_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

