--
-- PostgreSQL database dump
--

\restrict xUSS9IOhylmVWGlmSDhYOdi8htaCtHpsvHIxOP9nYpFBSolRwB2cqba2YwInbzX

-- Dumped from database version 18.4 (eaf151e)
-- Dumped by pg_dump version 18.1

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
-- Name: aktifkan_akses_buku(); Type: FUNCTION; Schema: public; Owner: neondb_owner
--

CREATE FUNCTION public.aktifkan_akses_buku() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN

    UPDATE akses_buku
    SET status = 'Aktif'
    WHERE id_pelanggan = NEW.id_pelanggan
    AND id_buku = NEW.id_buku;

    RETURN NEW;

END;
$$;


ALTER FUNCTION public.aktifkan_akses_buku() OWNER TO neondb_owner;

--
-- Name: hitung_total_download(integer); Type: FUNCTION; Schema: public; Owner: neondb_owner
--

CREATE FUNCTION public.hitung_total_download(p_id_pelanggan integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
    total INT;
BEGIN
    SELECT COUNT(*) INTO total
    FROM riwayat_download
    WHERE id_pelanggan = p_id_pelanggan;
    
    RETURN total;
END;
$$;


ALTER FUNCTION public.hitung_total_download(p_id_pelanggan integer) OWNER TO neondb_owner;

--
-- Name: log_download_baru(); Type: FUNCTION; Schema: public; Owner: neondb_owner
--

CREATE FUNCTION public.log_download_baru() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    INSERT INTO log_aktivitas (jenis_aktivitas, id_pelanggan, id_buku, keterangan)
    VALUES (
        'DOWNLOAD',
        NEW.id_pelanggan,
        NEW.id_buku,
        'Pelanggan ' || NEW.id_pelanggan || ' download buku ' || NEW.id_buku
    );
    RETURN NEW;
END;
$$;


ALTER FUNCTION public.log_download_baru() OWNER TO neondb_owner;

--
-- Name: log_keranjang_baru(); Type: FUNCTION; Schema: public; Owner: neondb_owner
--

CREATE FUNCTION public.log_keranjang_baru() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    INSERT INTO log_aktivitas_toko (aksi_sistem, id_user, id_produk, catatan)
    VALUES (
        'TAMBAH_KERANJANG',
        NEW.id_user,
        NEW.id_produk,
        'User ' || NEW.id_user || ' menambahkan produk ' || NEW.id_produk || ' sebanyak ' || NEW.jumlah || ' pcs.'
    );
    RETURN NEW;
END;
$$;


ALTER FUNCTION public.log_keranjang_baru() OWNER TO neondb_owner;

--
-- Name: potong_stok_otomatis(); Type: FUNCTION; Schema: public; Owner: neondb_owner
--

CREATE FUNCTION public.potong_stok_otomatis() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    UPDATE data_buku
    SET stok_tersedia = stok_tersedia - NEW.jumlah_beli
    WHERE id_buku = NEW.id_buku;
    
    RETURN NEW;
END;
$$;


ALTER FUNCTION public.potong_stok_otomatis() OWNER TO neondb_owner;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: akses_buku; Type: TABLE; Schema: public; Owner: neondb_owner
--

CREATE TABLE public.akses_buku (
    id_akses integer NOT NULL,
    id_pelanggan integer NOT NULL,
    id_buku integer NOT NULL,
    tanggal_mulai date,
    tanggal_berakhir date,
    status character varying(20) DEFAULT NULL::character varying,
    token_akses character varying(255) DEFAULT NULL::character varying,
    CONSTRAINT akses_buku_status_check CHECK (((status)::text = ANY ((ARRAY['Aktif'::character varying, 'Nonaktif'::character varying])::text[])))
);


ALTER TABLE public.akses_buku OWNER TO neondb_owner;

--
-- Name: akses_buku_id_akses_seq; Type: SEQUENCE; Schema: public; Owner: neondb_owner
--

CREATE SEQUENCE public.akses_buku_id_akses_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.akses_buku_id_akses_seq OWNER TO neondb_owner;

--
-- Name: akses_buku_id_akses_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: neondb_owner
--

ALTER SEQUENCE public.akses_buku_id_akses_seq OWNED BY public.akses_buku.id_akses;


--
-- Name: buku; Type: TABLE; Schema: public; Owner: neondb_owner
--

CREATE TABLE public.buku (
    id_buku integer NOT NULL,
    judul character varying(200) NOT NULL,
    penulis character varying(100) NOT NULL,
    penerbit character varying(100) NOT NULL,
    tahun_terbit integer,
    file_url text,
    id_kategori integer
);


ALTER TABLE public.buku OWNER TO neondb_owner;

--
-- Name: data_buku; Type: TABLE; Schema: public; Owner: neondb_owner
--

CREATE TABLE public.data_buku (
    id_buku integer NOT NULL,
    judul_buku character varying(100),
    stok_tersedia integer
);


ALTER TABLE public.data_buku OWNER TO neondb_owner;

--
-- Name: data_buku_id_buku_seq; Type: SEQUENCE; Schema: public; Owner: neondb_owner
--

CREATE SEQUENCE public.data_buku_id_buku_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.data_buku_id_buku_seq OWNER TO neondb_owner;

--
-- Name: data_buku_id_buku_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: neondb_owner
--

ALTER SEQUENCE public.data_buku_id_buku_seq OWNED BY public.data_buku.id_buku;


--
-- Name: kategori; Type: TABLE; Schema: public; Owner: neondb_owner
--

CREATE TABLE public.kategori (
    id_kategori integer NOT NULL,
    nama_kategori character varying(100) NOT NULL
);


ALTER TABLE public.kategori OWNER TO neondb_owner;

--
-- Name: log_aktivitas; Type: TABLE; Schema: public; Owner: neondb_owner
--

CREATE TABLE public.log_aktivitas (
    id_log integer NOT NULL,
    jenis_aktivitas character varying(50),
    id_pelanggan integer,
    id_buku integer,
    keterangan text,
    waktu_aktivitas timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.log_aktivitas OWNER TO neondb_owner;

--
-- Name: log_aktivitas_id_log_seq; Type: SEQUENCE; Schema: public; Owner: neondb_owner
--

CREATE SEQUENCE public.log_aktivitas_id_log_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.log_aktivitas_id_log_seq OWNER TO neondb_owner;

--
-- Name: log_aktivitas_id_log_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: neondb_owner
--

ALTER SEQUENCE public.log_aktivitas_id_log_seq OWNED BY public.log_aktivitas.id_log;


--
-- Name: log_aktivitas_toko; Type: TABLE; Schema: public; Owner: neondb_owner
--

CREATE TABLE public.log_aktivitas_toko (
    id_log integer NOT NULL,
    aksi_sistem character varying(50),
    id_user integer,
    id_produk integer,
    catatan text,
    waktu_kejadian timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.log_aktivitas_toko OWNER TO neondb_owner;

--
-- Name: log_aktivitas_toko_id_log_seq; Type: SEQUENCE; Schema: public; Owner: neondb_owner
--

CREATE SEQUENCE public.log_aktivitas_toko_id_log_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.log_aktivitas_toko_id_log_seq OWNER TO neondb_owner;

--
-- Name: log_aktivitas_toko_id_log_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: neondb_owner
--

ALTER SEQUENCE public.log_aktivitas_toko_id_log_seq OWNED BY public.log_aktivitas_toko.id_log;


--
-- Name: riwayat_download; Type: TABLE; Schema: public; Owner: neondb_owner
--

CREATE TABLE public.riwayat_download (
    id_download integer NOT NULL,
    id_pelanggan integer NOT NULL,
    id_buku integer NOT NULL,
    tanggal_download timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.riwayat_download OWNER TO neondb_owner;

--
-- Name: ulasan; Type: TABLE; Schema: public; Owner: neondb_owner
--

CREATE TABLE public.ulasan (
    id_ulasan integer NOT NULL,
    id_pelanggan integer NOT NULL,
    id_buku integer NOT NULL,
    rating integer,
    komentar text,
    tanggal_ulasan date,
    CONSTRAINT ulasan_rating_check CHECK (((rating >= 1) AND (rating <= 5)))
);


ALTER TABLE public.ulasan OWNER TO neondb_owner;

--
-- Name: mv_buku_populer; Type: MATERIALIZED VIEW; Schema: public; Owner: neondb_owner
--

CREATE MATERIALIZED VIEW public.mv_buku_populer AS
 SELECT b.id_buku,
    b.judul,
    b.penulis,
    k.nama_kategori,
    count(DISTINCT r.id_download) AS total_download,
    count(DISTINCT u.id_ulasan) AS total_ulasan,
    round(avg(u.rating), 2) AS avg_rating
   FROM (((public.buku b
     LEFT JOIN public.kategori k ON ((b.id_kategori = k.id_kategori)))
     LEFT JOIN public.riwayat_download r ON ((b.id_buku = r.id_buku)))
     LEFT JOIN public.ulasan u ON ((b.id_buku = u.id_buku)))
  GROUP BY b.id_buku, b.judul, b.penulis, k.nama_kategori
 HAVING (count(DISTINCT r.id_download) > 2)
  WITH NO DATA;


ALTER MATERIALIZED VIEW public.mv_buku_populer OWNER TO neondb_owner;

--
-- Name: pelanggan; Type: TABLE; Schema: public; Owner: neondb_owner
--

CREATE TABLE public.pelanggan (
    id_pelanggan integer NOT NULL,
    nama character varying(100) NOT NULL,
    email character varying(100) NOT NULL,
    no_hp character varying(20) DEFAULT NULL::character varying,
    alamat text
);


ALTER TABLE public.pelanggan OWNER TO neondb_owner;

--
-- Name: transaksi_buku; Type: TABLE; Schema: public; Owner: neondb_owner
--

CREATE TABLE public.transaksi_buku (
    id_transaksi integer NOT NULL,
    id_pelanggan integer,
    id_buku integer,
    jumlah_beli integer,
    waktu_transaksi timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.transaksi_buku OWNER TO neondb_owner;

--
-- Name: transaksi_buku_id_transaksi_seq; Type: SEQUENCE; Schema: public; Owner: neondb_owner
--

CREATE SEQUENCE public.transaksi_buku_id_transaksi_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.transaksi_buku_id_transaksi_seq OWNER TO neondb_owner;

--
-- Name: transaksi_buku_id_transaksi_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: neondb_owner
--

ALTER SEQUENCE public.transaksi_buku_id_transaksi_seq OWNED BY public.transaksi_buku.id_transaksi;


--
-- Name: view_statistik_buku; Type: VIEW; Schema: public; Owner: neondb_owner
--

CREATE VIEW public.view_statistik_buku AS
 SELECT b.id_buku,
    b.judul,
    b.penulis,
    k.nama_kategori,
    count(DISTINCT u.id_ulasan) AS jumlah_ulasan,
    round(avg(u.rating), 2) AS rata_rating,
    count(DISTINCT r.id_download) AS jumlah_download
   FROM (((public.buku b
     LEFT JOIN public.kategori k ON ((b.id_kategori = k.id_kategori)))
     LEFT JOIN public.ulasan u ON ((b.id_buku = u.id_buku)))
     LEFT JOIN public.riwayat_download r ON ((b.id_buku = r.id_buku)))
  GROUP BY b.id_buku, b.judul, b.penulis, k.nama_kategori;


ALTER VIEW public.view_statistik_buku OWNER TO neondb_owner;

--
-- Name: wishlist; Type: TABLE; Schema: public; Owner: neondb_owner
--

CREATE TABLE public.wishlist (
    id_wishlist integer NOT NULL,
    id_pelanggan integer NOT NULL,
    id_buku integer NOT NULL,
    tanggal_ditambahkan timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    catatan text
);


ALTER TABLE public.wishlist OWNER TO neondb_owner;

--
-- Name: wishlist_id_wishlist_seq; Type: SEQUENCE; Schema: public; Owner: neondb_owner
--

CREATE SEQUENCE public.wishlist_id_wishlist_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.wishlist_id_wishlist_seq OWNER TO neondb_owner;

--
-- Name: wishlist_id_wishlist_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: neondb_owner
--

ALTER SEQUENCE public.wishlist_id_wishlist_seq OWNED BY public.wishlist.id_wishlist;


--
-- Name: akses_buku id_akses; Type: DEFAULT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.akses_buku ALTER COLUMN id_akses SET DEFAULT nextval('public.akses_buku_id_akses_seq'::regclass);


--
-- Name: data_buku id_buku; Type: DEFAULT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.data_buku ALTER COLUMN id_buku SET DEFAULT nextval('public.data_buku_id_buku_seq'::regclass);


--
-- Name: log_aktivitas id_log; Type: DEFAULT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.log_aktivitas ALTER COLUMN id_log SET DEFAULT nextval('public.log_aktivitas_id_log_seq'::regclass);


--
-- Name: log_aktivitas_toko id_log; Type: DEFAULT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.log_aktivitas_toko ALTER COLUMN id_log SET DEFAULT nextval('public.log_aktivitas_toko_id_log_seq'::regclass);


--
-- Name: transaksi_buku id_transaksi; Type: DEFAULT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.transaksi_buku ALTER COLUMN id_transaksi SET DEFAULT nextval('public.transaksi_buku_id_transaksi_seq'::regclass);


--
-- Name: wishlist id_wishlist; Type: DEFAULT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.wishlist ALTER COLUMN id_wishlist SET DEFAULT nextval('public.wishlist_id_wishlist_seq'::regclass);


--
-- Data for Name: akses_buku; Type: TABLE DATA; Schema: public; Owner: neondb_owner
--

COPY public.akses_buku (id_akses, id_pelanggan, id_buku, tanggal_mulai, tanggal_berakhir, status, token_akses) FROM stdin;
2	26001	1003	2026-06-01	2026-12-31	Aktif	TOKEN-A1-003
3	26001	1006	2026-06-01	2026-12-31	Aktif	TOKEN-A1-006
4	26001	1010	2026-06-01	2026-12-31	Aktif	TOKEN-A1-010
5	26001	1023	2026-06-01	2026-12-31	Aktif	TOKEN-A1-023
6	26002	1002	2026-05-15	2026-11-15	Aktif	TOKEN-S2-002
7	26002	1005	2026-05-15	2026-11-15	Aktif	TOKEN-S2-005
8	26002	1012	2026-05-15	2026-11-15	Aktif	TOKEN-S2-012
9	26003	1006	2026-04-01	2026-10-01	Aktif	TOKEN-B3-006
10	26003	1007	2026-04-01	2026-10-01	Aktif	TOKEN-B3-007
11	26003	1020	2026-01-01	2026-06-01	Nonaktif	TOKEN-B3-020
12	26003	1021	2026-04-01	2026-10-01	Aktif	TOKEN-B3-021
13	26004	1003	2026-06-10	2026-12-10	Aktif	TOKEN-D4-003
14	26004	1004	2026-06-10	2026-12-10	Aktif	TOKEN-D4-004
15	26004	1008	2026-06-10	2026-12-10	Aktif	TOKEN-D4-008
16	26004	1010	2026-06-10	2026-12-10	Aktif	TOKEN-D4-010
17	26004	1011	2026-06-10	2026-12-10	Aktif	TOKEN-D4-011
18	26004	1024	2026-06-10	2026-12-10	Aktif	TOKEN-D4-024
19	26005	1006	2026-05-01	2026-11-01	Aktif	TOKEN-R5-006
20	26005	1007	2026-05-01	2026-11-01	Aktif	TOKEN-R5-007
21	26005	1013	2026-05-01	2026-11-01	Aktif	TOKEN-R5-013
22	26006	1016	2026-06-05	2026-12-05	Aktif	TOKEN-L6-016
23	26006	1017	2026-06-05	2026-12-05	Aktif	TOKEN-L6-017
24	26007	1021	2026-05-20	2026-11-20	Aktif	TOKEN-A7-021
25	26007	1022	2026-05-20	2026-11-20	Aktif	TOKEN-A7-022
26	26008	1001	2026-06-15	2026-12-15	Aktif	TOKEN-M8-001
27	26009	1005	2026-06-01	2026-12-01	Aktif	TOKEN-H9-005
28	26010	1020	2026-05-10	2026-11-10	Aktif	TOKEN-P10-020
1	26001	1001	2026-06-01	2026-12-31	Aktif	TOKEN-A1-001
\.


--
-- Data for Name: buku; Type: TABLE DATA; Schema: public; Owner: neondb_owner
--

COPY public.buku (id_buku, judul, penulis, penerbit, tahun_terbit, file_url, id_kategori) FROM stdin;
1001	Laskar Pelangi	Andrea Hirata	Bentang Pustaka	2005	https://storage.perpusdigital.com/laskar-pelangi.pdf	9
1002	Bumi Manusia	Pramoedya Ananta Toer	Hasta Mitra	1980	https://storage.perpusdigital.com/bumi-manusia.pdf	9
1003	Atomic Habits	James Clear	Avery	2018	https://storage.perpusdigital.com/atomic-habits.pdf	8
1004	The Psychology of Money	Morgan Housel	Harriman House	2020	https://storage.perpusdigital.com/psychology-money.pdf	4
1005	Sapiens	Yuval Noah Harari	Harper	2011	https://storage.perpusdigital.com/sapiens.pdf	5
1006	Clean Code	Robert C. Martin	Prentice Hall	2008	https://storage.perpusdigital.com/clean-code.pdf	3
1007	Design Patterns	Gang of Four	Addison-Wesley	1994	https://storage.perpusdigital.com/design-patterns.pdf	3
1008	Steve Jobs	Walter Isaacson	Simon & Schuster	2011	https://storage.perpusdigital.com/steve-jobs.pdf	7
1009	Elon Musk	Ashlee Vance	Ecco	2015	https://storage.perpusdigital.com/elon-musk.pdf	7
1010	Rich Dad Poor Dad	Robert Kiyosaki	Warner Books	1997	https://storage.perpusdigital.com/rich-dad-poor-dad.pdf	4
1011	The Lean Startup	Eric Ries	Crown Business	2011	https://storage.perpusdigital.com/lean-startup.pdf	4
1012	Thinking Fast and Slow	Daniel Kahneman	Farrar Straus Giroux	2011	https://storage.perpusdigital.com/thinking-fast-slow.pdf	2
1013	A Brief History of Time	Stephen Hawking	Bantam Books	1988	https://storage.perpusdigital.com/brief-history-time.pdf	6
1014	Cosmos	Carl Sagan	Random House	1980	https://storage.perpusdigital.com/cosmos.pdf	6
1015	The Art of War	Sun Tzu	Various	2000	https://storage.perpusdigital.com/art-of-war.pdf	5
1016	1984	George Orwell	Secker & Warburg	1949	https://storage.perpusdigital.com/1984.pdf	1
1017	Animal Farm	George Orwell	Secker & Warburg	1945	https://storage.perpusdigital.com/animal-farm.pdf	1
1018	To Kill a Mockingbird	Harper Lee	J.B. Lippincott	1960	https://storage.perpusdigital.com/mockingbird.pdf	1
1019	The Great Gatsby	F. Scott Fitzgerald	Scribner	1925	https://storage.perpusdigital.com/great-gatsby.pdf	1
1020	Harry Potter and the Philosophers Stone	J.K. Rowling	Bloomsbury	1997	https://storage.perpusdigital.com/harry-potter-1.pdf	1
1021	Naruto Vol 1	Masashi Kishimoto	Shueisha	1999	https://storage.perpusdigital.com/naruto-1.pdf	10
1022	One Piece Vol 1	Eiichiro Oda	Shueisha	1997	https://storage.perpusdigital.com/onepiece-1.pdf	10
1023	Deep Work	Cal Newport	Grand Central Publishing	2016	https://storage.perpusdigital.com/deep-work.pdf	8
1024	The 7 Habits of Highly Effective People	Stephen Covey	Free Press	1989	https://storage.perpusdigital.com/7-habits.pdf	8
1025	Good to Great	Jim Collins	Harper Business	2001	https://storage.perpusdigital.com/good-to-great.pdf	4
\.


--
-- Data for Name: data_buku; Type: TABLE DATA; Schema: public; Owner: neondb_owner
--

COPY public.data_buku (id_buku, judul_buku, stok_tersedia) FROM stdin;
701	Belajar PostgreSQL dalam Semalam	7
\.


--
-- Data for Name: kategori; Type: TABLE DATA; Schema: public; Owner: neondb_owner
--

COPY public.kategori (id_kategori, nama_kategori) FROM stdin;
1	Fiksi
2	Non-Fiksi
3	Teknologi
4	Bisnis
5	Sejarah
6	Sains
7	Biografi
8	Self-Improvement
9	Novel
10	Komik
\.


--
-- Data for Name: log_aktivitas; Type: TABLE DATA; Schema: public; Owner: neondb_owner
--

COPY public.log_aktivitas (id_log, jenis_aktivitas, id_pelanggan, id_buku, keterangan, waktu_aktivitas) FROM stdin;
1	REGISTRASI	26016	\N	Pelanggan baru mendaftar dan menambahkan 2 buku ke wishlist	2026-06-24 06:58:47.651743
2	DOWNLOAD	26001	1001	Pelanggan 26001 download buku 1001	2026-06-24 11:16:42.376467
\.


--
-- Data for Name: log_aktivitas_toko; Type: TABLE DATA; Schema: public; Owner: neondb_owner
--

COPY public.log_aktivitas_toko (id_log, aksi_sistem, id_user, id_produk, catatan, waktu_kejadian) FROM stdin;
\.


--
-- Data for Name: pelanggan; Type: TABLE DATA; Schema: public; Owner: neondb_owner
--

COPY public.pelanggan (id_pelanggan, nama, email, no_hp, alamat) FROM stdin;
26001	Ahmad Fauzi	ahmad.fauzi@email.com	081234567890	Jl. Merdeka No. 10, Jakarta
26002	Siti Nurhaliza	siti.nur@email.com	081234567891	Jl. Sudirman No. 25, Bandung
26003	Budi Santoso	budi.santoso@email.com	081234567892	Jl. Gatot Subroto No. 15, Surabaya
26004	Dewi Lestari	dewi.lestari@email.com	081234567893	Jl. Thamrin No. 5, Jakarta
26005	Rizky Pratama	rizky.pratama@email.com	081234567894	Jl. Asia Afrika No. 30, Bandung
26006	Linda Wijaya	linda.wijaya@email.com	081234567895	Jl. Pemuda No. 12, Semarang
26007	Andi Kurniawan	andi.kurniawan@email.com	081234567896	Jl. Diponegoro No. 8, Yogyakarta
26008	Maya Sari	maya.sari@email.com	081234567897	Jl. Gajah Mada No. 20, Malang
26009	Hendra Gunawan	hendra.gunawan@email.com	081234567898	Jl. Ahmad Yani No. 17, Medan
26010	Putri Ayu	putri.ayu@email.com	081234567899	Jl. Kartini No. 22, Denpasar
26011	Fajar Ramadhan	fajar.ramadhan@email.com	081234567800	Jl. Pahlawan No. 11, Makassar
26012	Tina Marlina	tina.marlina@email.com	081234567801	Jl. Veteran No. 9, Palembang
26013	Doni Setiawan	doni.setiawan@email.com	081234567802	Jl. Hayam Wuruk No. 14, Jakarta
26014	Rina Kusuma	rina.kusuma@email.com	081234567803	Jl. Raya Bogor No. 45, Bogor
26015	Agus Wijaya	agus.wijaya@email.com	081234567804	Jl. Cihampelas No. 100, Bandung
26016	Rudi Hermawan	rudi.hermawan@email.com	081234567805	Jl. Merdeka No. 50, Jakarta
26017	Rudi Hermawan	rudi2@email.com	081234567806	Jl. Merdeka No. 50, Jakarta
\.


--
-- Data for Name: riwayat_download; Type: TABLE DATA; Schema: public; Owner: neondb_owner
--

COPY public.riwayat_download (id_download, id_pelanggan, id_buku, tanggal_download) FROM stdin;
77001	26001	1001	2026-06-02 10:30:00
77002	26001	1003	2026-06-05 14:20:00
77003	26001	1006	2026-06-08 09:15:00
77004	26001	1001	2026-06-12 16:45:00
77005	26001	1010	2026-06-15 11:30:00
77006	26001	1023	2026-06-18 13:20:00
77007	26001	1003	2026-06-20 10:00:00
77008	26001	1006	2026-06-21 15:30:00
77009	26002	1002	2026-05-16 09:00:00
77010	26002	1005	2026-05-20 14:30:00
77011	26002	1012	2026-06-01 10:15:00
77012	26002	1002	2026-06-10 16:20:00
77013	26003	1006	2026-04-05 11:00:00
77014	26003	1007	2026-04-10 13:45:00
77015	26003	1006	2026-05-15 10:30:00
77016	26003	1021	2026-06-01 14:00:00
77017	26003	1007	2026-06-15 09:20:00
77018	26004	1003	2026-06-11 08:30:00
77019	26004	1004	2026-06-12 10:00:00
77020	26004	1008	2026-06-13 14:15:00
77021	26004	1010	2026-06-14 09:45:00
77022	26004	1011	2026-06-15 11:20:00
77023	26004	1024	2026-06-16 13:30:00
77024	26004	1003	2026-06-18 10:15:00
77025	26004	1004	2026-06-19 15:00:00
77026	26004	1008	2026-06-20 09:30:00
77027	26004	1010	2026-06-21 14:45:00
77028	26005	1006	2026-05-05 10:00:00
77029	26005	1007	2026-05-20 14:30:00
77030	26005	1013	2026-06-10 11:15:00
77031	26006	1016	2026-06-06 09:30:00
77032	26006	1017	2026-06-12 14:00:00
77033	26007	1021	2026-05-22 10:45:00
77034	26007	1022	2026-06-05 13:20:00
77035	26008	1001	2026-06-16 11:00:00
77036	26009	1005	2026-06-02 15:30:00
77037	26010	1020	2026-05-12 10:20:00
77038	26001	1001	2026-06-24 11:16:42.376467
\.


--
-- Data for Name: transaksi_buku; Type: TABLE DATA; Schema: public; Owner: neondb_owner
--

COPY public.transaksi_buku (id_transaksi, id_pelanggan, id_buku, jumlah_beli, waktu_transaksi) FROM stdin;
1	202	701	3	2026-06-24 06:57:15.863782
2	202	701	3	2026-06-24 06:57:34.003811
3	202	701	3	2026-06-24 07:04:41.422038
\.


--
-- Data for Name: ulasan; Type: TABLE DATA; Schema: public; Owner: neondb_owner
--

COPY public.ulasan (id_ulasan, id_pelanggan, id_buku, rating, komentar, tanggal_ulasan) FROM stdin;
88001	26001	1001	5	Sangat menginspirasi! Cerita tentang perjuangan pendidikan di Belitung sangat menyentuh.	2026-06-03
88002	26008	1001	5	Novel terbaik yang pernah saya baca. Recommended!	2026-06-17
88003	26002	1002	5	Masterpiece karya Pramoedya. Wajib dibaca untuk memahami sejarah Indonesia.	2026-05-17
88004	26001	1003	5	Buku self-improvement terbaik. Praktis dan mudah diterapkan.	2026-06-06
88005	26004	1003	4	Konsep atomic habits sangat membantu dalam membentuk kebiasaan baik.	2026-06-12
88006	26004	1004	5	Mengubah cara pandang saya tentang uang dan investasi.	2026-06-13
88007	26002	1005	5	Sapiens membuka wawasan tentang sejarah umat manusia. Mind-blowing!	2026-05-21
88008	26009	1005	4	Buku yang sangat informatif dan well-researched.	2026-06-03
88009	26001	1006	5	Must-read untuk programmer. Clean code adalah seni!	2026-06-09
88010	26003	1006	5	Standar emas untuk penulisan kode yang berkualitas.	2026-04-06
88011	26005	1006	4	Sangat berguna untuk meningkatkan skill programming.	2026-05-06
88012	26003	1007	4	Design patterns explained dengan contoh yang jelas.	2026-04-11
88013	26005	1007	5	Referensi wajib untuk software engineer.	2026-05-21
88014	26004	1008	5	Biografi Steve Jobs yang sangat detail dan inspiratif.	2026-06-14
88015	26001	1010	4	Perspektif baru tentang financial literacy.	2026-06-16
88016	26004	1010	5	Buku yang mengubah mindset saya tentang keuangan.	2026-06-15
88017	26004	1011	4	Metodologi lean startup sangat applicable untuk bisnis apapun.	2026-06-16
88018	26002	1012	5	Daniel Kahneman menjelaskan behavioral economics dengan brilliant.	2026-06-02
88019	26005	1013	4	Stephen Hawking menulis fisika dengan cara yang accessible.	2026-06-11
88020	26006	1016	5	1984 masih sangat relevan di era digital ini.	2026-06-07
88021	26006	1017	4	Alegori politik yang powerful.	2026-06-13
88022	26010	1020	5	Harry Potter tidak pernah mengecewakan!	2026-05-13
88023	26007	1021	5	Naruto adalah manga terbaik sepanjang masa!	2026-05-23
88024	26007	1022	5	One Piece memiliki world-building yang luar biasa.	2026-06-06
88025	26001	1023	5	Deep Work mengajarkan fokus di era distraksi.	2026-06-19
88026	26004	1024	4	7 Habits adalah fondasi personal development.	2026-06-17
\.


--
-- Data for Name: wishlist; Type: TABLE DATA; Schema: public; Owner: neondb_owner
--

COPY public.wishlist (id_wishlist, id_pelanggan, id_buku, tanggal_ditambahkan, catatan) FROM stdin;
1	26001	1002	2026-06-20 10:00:00	Ingin baca karya Pramoedya
2	26001	1005	2026-06-21 14:30:00	Tertarik dengan sejarah manusia
3	26002	1006	2026-06-15 09:00:00	Butuh untuk belajar programming
4	26002	1020	2026-06-16 11:30:00	Pengen nostalgia Harry Potter
5	26003	1003	2026-06-10 08:45:00	Mau improve habits
6	26003	1004	2026-06-10 08:50:00	Belajar financial literacy
7	26005	1001	2026-06-18 15:20:00	Laskar Pelangi wajib baca
8	26005	1021	2026-06-19 16:00:00	Pengen baca Naruto dari awal
9	26005	1022	2026-06-19 16:05:00	One Piece juga!
10	26006	1003	2026-06-12 10:30:00	\N
11	26006	1004	2026-06-12 10:35:00	\N
12	26007	1006	2026-06-08 13:00:00	Clean code untuk upgrade skill
13	26008	1005	2026-06-17 09:30:00	\N
14	26009	1006	2026-06-05 14:00:00	Recommended oleh teman
15	26010	1003	2026-06-14 11:00:00	Habit formation
18	26016	1001	2026-06-24 06:58:47.651743	Ingin baca Laskar Pelangi
19	26016	1003	2026-06-24 06:58:47.651743	Atomic Habits untuk self improvement
20	26017	1001	2026-06-24 11:23:30.608577	Ingin membaca Laskar Pelangi
21	26017	1003	2026-06-24 11:23:30.608577	Atomic Habits untuk self improvement
\.


--
-- Name: akses_buku_id_akses_seq; Type: SEQUENCE SET; Schema: public; Owner: neondb_owner
--

SELECT pg_catalog.setval('public.akses_buku_id_akses_seq', 28, true);


--
-- Name: data_buku_id_buku_seq; Type: SEQUENCE SET; Schema: public; Owner: neondb_owner
--

SELECT pg_catalog.setval('public.data_buku_id_buku_seq', 1, false);


--
-- Name: log_aktivitas_id_log_seq; Type: SEQUENCE SET; Schema: public; Owner: neondb_owner
--

SELECT pg_catalog.setval('public.log_aktivitas_id_log_seq', 2, true);


--
-- Name: log_aktivitas_toko_id_log_seq; Type: SEQUENCE SET; Schema: public; Owner: neondb_owner
--

SELECT pg_catalog.setval('public.log_aktivitas_toko_id_log_seq', 1, false);


--
-- Name: transaksi_buku_id_transaksi_seq; Type: SEQUENCE SET; Schema: public; Owner: neondb_owner
--

SELECT pg_catalog.setval('public.transaksi_buku_id_transaksi_seq', 3, true);


--
-- Name: wishlist_id_wishlist_seq; Type: SEQUENCE SET; Schema: public; Owner: neondb_owner
--

SELECT pg_catalog.setval('public.wishlist_id_wishlist_seq', 21, true);


--
-- Name: akses_buku akses_buku_pkey; Type: CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.akses_buku
    ADD CONSTRAINT akses_buku_pkey PRIMARY KEY (id_akses);


--
-- Name: buku buku_pkey; Type: CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.buku
    ADD CONSTRAINT buku_pkey PRIMARY KEY (id_buku);


--
-- Name: data_buku data_buku_pkey; Type: CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.data_buku
    ADD CONSTRAINT data_buku_pkey PRIMARY KEY (id_buku);


--
-- Name: kategori kategori_pkey; Type: CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.kategori
    ADD CONSTRAINT kategori_pkey PRIMARY KEY (id_kategori);


--
-- Name: log_aktivitas log_aktivitas_pkey; Type: CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.log_aktivitas
    ADD CONSTRAINT log_aktivitas_pkey PRIMARY KEY (id_log);


--
-- Name: log_aktivitas_toko log_aktivitas_toko_pkey; Type: CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.log_aktivitas_toko
    ADD CONSTRAINT log_aktivitas_toko_pkey PRIMARY KEY (id_log);


--
-- Name: pelanggan pelanggan_email_key; Type: CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.pelanggan
    ADD CONSTRAINT pelanggan_email_key UNIQUE (email);


--
-- Name: pelanggan pelanggan_pkey; Type: CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.pelanggan
    ADD CONSTRAINT pelanggan_pkey PRIMARY KEY (id_pelanggan);


--
-- Name: riwayat_download riwayat_download_pkey; Type: CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.riwayat_download
    ADD CONSTRAINT riwayat_download_pkey PRIMARY KEY (id_download);


--
-- Name: transaksi_buku transaksi_buku_pkey; Type: CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.transaksi_buku
    ADD CONSTRAINT transaksi_buku_pkey PRIMARY KEY (id_transaksi);


--
-- Name: ulasan ulasan_pkey; Type: CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.ulasan
    ADD CONSTRAINT ulasan_pkey PRIMARY KEY (id_ulasan);


--
-- Name: wishlist wishlist_id_pelanggan_id_buku_key; Type: CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.wishlist
    ADD CONSTRAINT wishlist_id_pelanggan_id_buku_key UNIQUE (id_pelanggan, id_buku);


--
-- Name: wishlist wishlist_pkey; Type: CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.wishlist
    ADD CONSTRAINT wishlist_pkey PRIMARY KEY (id_wishlist);


--
-- Name: riwayat_download trigger_aktifkan_akses; Type: TRIGGER; Schema: public; Owner: neondb_owner
--

CREATE TRIGGER trigger_aktifkan_akses AFTER INSERT ON public.riwayat_download FOR EACH ROW EXECUTE FUNCTION public.aktifkan_akses_buku();


--
-- Name: transaksi_buku trigger_kurang_stok; Type: TRIGGER; Schema: public; Owner: neondb_owner
--

CREATE TRIGGER trigger_kurang_stok AFTER INSERT ON public.transaksi_buku FOR EACH ROW EXECUTE FUNCTION public.potong_stok_otomatis();


--
-- Name: riwayat_download trigger_log_download; Type: TRIGGER; Schema: public; Owner: neondb_owner
--

CREATE TRIGGER trigger_log_download AFTER INSERT ON public.riwayat_download FOR EACH ROW EXECUTE FUNCTION public.log_download_baru();


--
-- Name: akses_buku akses_buku_id_buku_fkey; Type: FK CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.akses_buku
    ADD CONSTRAINT akses_buku_id_buku_fkey FOREIGN KEY (id_buku) REFERENCES public.buku(id_buku) ON DELETE CASCADE;


--
-- Name: akses_buku akses_buku_id_pelanggan_fkey; Type: FK CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.akses_buku
    ADD CONSTRAINT akses_buku_id_pelanggan_fkey FOREIGN KEY (id_pelanggan) REFERENCES public.pelanggan(id_pelanggan) ON DELETE CASCADE;


--
-- Name: buku buku_id_kategori_fkey; Type: FK CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.buku
    ADD CONSTRAINT buku_id_kategori_fkey FOREIGN KEY (id_kategori) REFERENCES public.kategori(id_kategori) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: riwayat_download riwayat_download_id_buku_fkey; Type: FK CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.riwayat_download
    ADD CONSTRAINT riwayat_download_id_buku_fkey FOREIGN KEY (id_buku) REFERENCES public.buku(id_buku) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: riwayat_download riwayat_download_id_pelanggan_fkey; Type: FK CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.riwayat_download
    ADD CONSTRAINT riwayat_download_id_pelanggan_fkey FOREIGN KEY (id_pelanggan) REFERENCES public.pelanggan(id_pelanggan) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: ulasan ulasan_id_buku_fkey; Type: FK CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.ulasan
    ADD CONSTRAINT ulasan_id_buku_fkey FOREIGN KEY (id_buku) REFERENCES public.buku(id_buku) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: ulasan ulasan_id_pelanggan_fkey; Type: FK CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.ulasan
    ADD CONSTRAINT ulasan_id_pelanggan_fkey FOREIGN KEY (id_pelanggan) REFERENCES public.pelanggan(id_pelanggan) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: wishlist wishlist_id_buku_fkey; Type: FK CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.wishlist
    ADD CONSTRAINT wishlist_id_buku_fkey FOREIGN KEY (id_buku) REFERENCES public.buku(id_buku) ON DELETE CASCADE;


--
-- Name: wishlist wishlist_id_pelanggan_fkey; Type: FK CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.wishlist
    ADD CONSTRAINT wishlist_id_pelanggan_fkey FOREIGN KEY (id_pelanggan) REFERENCES public.pelanggan(id_pelanggan) ON DELETE CASCADE;


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: public; Owner: cloud_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE cloud_admin IN SCHEMA public GRANT ALL ON SEQUENCES TO neon_superuser WITH GRANT OPTION;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: public; Owner: cloud_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE cloud_admin IN SCHEMA public GRANT ALL ON TABLES TO neon_superuser WITH GRANT OPTION;


--
-- Name: mv_buku_populer; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: neondb_owner
--

REFRESH MATERIALIZED VIEW public.mv_buku_populer;


--
-- PostgreSQL database dump complete
--

\unrestrict xUSS9IOhylmVWGlmSDhYOdi8htaCtHpsvHIxOP9nYpFBSolRwB2cqba2YwInbzX

