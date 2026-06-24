CREATE TABLE kategori (
    id_kategori INT NOT NULL,
    nama_kategori VARCHAR(100) NOT NULL,
    PRIMARY KEY (id_kategori)
);

CREATE TABLE pelanggan (
    id_pelanggan INT NOT NULL,
    nama VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    no_hp VARCHAR(20) DEFAULT NULL,
    alamat TEXT DEFAULT NULL,
    PRIMARY KEY (id_pelanggan)
);

CREATE TABLE buku (
    id_buku INT NOT NULL,
    judul VARCHAR(200) NOT NULL,
    penulis VARCHAR(100) NOT NULL,
    penerbit VARCHAR(100) NOT NULL,
    tahun_terbit INT DEFAULT NULL,
    file_url TEXT DEFAULT NULL,
    id_kategori INT DEFAULT NULL,
    PRIMARY KEY (id_buku),
    FOREIGN KEY (id_kategori) REFERENCES kategori(id_kategori) ON DELETE SET NULL ON UPDATE CASCADE
);

CREATE TABLE akses_buku (
    id_akses SERIAL PRIMARY KEY,
    id_pelanggan INT NOT NULL,
    id_buku INT NOT NULL,
    tanggal_mulai DATE DEFAULT NULL,
    tanggal_berakhir DATE DEFAULT NULL,
    status VARCHAR(20) DEFAULT NULL CHECK (status IN ('Aktif', 'Nonaktif')),
    token_akses VARCHAR(255) DEFAULT NULL,
    FOREIGN KEY (id_pelanggan) REFERENCES pelanggan(id_pelanggan) ON DELETE CASCADE,
    FOREIGN KEY (id_buku) REFERENCES buku(id_buku) ON DELETE CASCADE
);

CREATE TABLE riwayat_download (
    id_download INT NOT NULL,
    id_pelanggan INT NOT NULL,
    id_buku INT NOT NULL,
    tanggal_download TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id_download),
    FOREIGN KEY (id_pelanggan) REFERENCES pelanggan(id_pelanggan) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (id_buku) REFERENCES buku(id_buku) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE ulasan (
    id_ulasan INT NOT NULL,
    id_pelanggan INT NOT NULL,
    id_buku INT NOT NULL,
    rating INT DEFAULT NULL CHECK (rating BETWEEN 1 AND 5),
    komentar TEXT DEFAULT NULL,
    tanggal_ulasan DATE DEFAULT NULL,
    PRIMARY KEY (id_ulasan),
    FOREIGN KEY (id_pelanggan) REFERENCES pelanggan(id_pelanggan) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (id_buku) REFERENCES buku(id_buku) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE wishlist (
    id_wishlist SERIAL PRIMARY KEY,
    id_pelanggan INT NOT NULL,
    id_buku INT NOT NULL,
    tanggal_ditambahkan TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    catatan TEXT DEFAULT NULL,
    FOREIGN KEY (id_pelanggan) REFERENCES pelanggan(id_pelanggan) ON DELETE CASCADE,
    FOREIGN KEY (id_buku) REFERENCES buku(id_buku) ON DELETE CASCADE,
    UNIQUE(id_pelanggan, id_buku)
);

INSERT INTO kategori (id_kategori, nama_kategori) VALUES
(1, 'Fiksi'),
(2, 'Non-Fiksi'),
(3, 'Teknologi'),
(4, 'Bisnis'),
(5, 'Sejarah'),
(6, 'Sains'),
(7, 'Biografi'),
(8, 'Self-Improvement'),
(9, 'Novel'),
(10, 'Komik');
SELECT * FROM KATEGORI;

INSERT INTO pelanggan (id_pelanggan, nama, email, no_hp, alamat) VALUES
(26001, 'Ahmad Fauzi', 'ahmad.fauzi@email.com', '081234567890', 'Jl. Merdeka No. 10, Jakarta'),
(26002, 'Siti Nurhaliza', 'siti.nur@email.com', '081234567891', 'Jl. Sudirman No. 25, Bandung'),
(26003, 'Budi Santoso', 'budi.santoso@email.com', '081234567892', 'Jl. Gatot Subroto No. 15, Surabaya'),
(26004, 'Dewi Lestari', 'dewi.lestari@email.com', '081234567893', 'Jl. Thamrin No. 5, Jakarta'),
(26005, 'Rizky Pratama', 'rizky.pratama@email.com', '081234567894', 'Jl. Asia Afrika No. 30, Bandung'),
(26006, 'Linda Wijaya', 'linda.wijaya@email.com', '081234567895', 'Jl. Pemuda No. 12, Semarang'),
(26007, 'Andi Kurniawan', 'andi.kurniawan@email.com', '081234567896', 'Jl. Diponegoro No. 8, Yogyakarta'),
(26008, 'Maya Sari', 'maya.sari@email.com', '081234567897', 'Jl. Gajah Mada No. 20, Malang'),
(26009, 'Hendra Gunawan', 'hendra.gunawan@email.com', '081234567898', 'Jl. Ahmad Yani No. 17, Medan'),
(26010, 'Putri Ayu', 'putri.ayu@email.com', '081234567899', 'Jl. Kartini No. 22, Denpasar'),
(26011, 'Fajar Ramadhan', 'fajar.ramadhan@email.com', '081234567800', 'Jl. Pahlawan No. 11, Makassar'),
(26012, 'Tina Marlina', 'tina.marlina@email.com', '081234567801', 'Jl. Veteran No. 9, Palembang'),
(26013, 'Doni Setiawan', 'doni.setiawan@email.com', '081234567802', 'Jl. Hayam Wuruk No. 14, Jakarta'),
(26014, 'Rina Kusuma', 'rina.kusuma@email.com', '081234567803', 'Jl. Raya Bogor No. 45, Bogor'),
(26015, 'Agus Wijaya', 'agus.wijaya@email.com', '081234567804', 'Jl. Cihampelas No. 100, Bandung');
SELECT*FROM PELANGGAN;

INSERT INTO buku (id_buku, judul, penulis, penerbit, tahun_terbit, file_url, id_kategori) VALUES
(1001, 'Laskar Pelangi', 'Andrea Hirata', 'Bentang Pustaka', 2005, 'https://storage.perpusdigital.com/laskar-pelangi.pdf', 9),
(1002, 'Bumi Manusia', 'Pramoedya Ananta Toer', 'Hasta Mitra', 1980, 'https://storage.perpusdigital.com/bumi-manusia.pdf', 9),
(1003, 'Atomic Habits', 'James Clear', 'Avery', 2018, 'https://storage.perpusdigital.com/atomic-habits.pdf', 8),
(1004, 'The Psychology of Money', 'Morgan Housel', 'Harriman House', 2020, 'https://storage.perpusdigital.com/psychology-money.pdf', 4),
(1005, 'Sapiens', 'Yuval Noah Harari', 'Harper', 2011, 'https://storage.perpusdigital.com/sapiens.pdf', 5),
(1006, 'Clean Code', 'Robert C. Martin', 'Prentice Hall', 2008, 'https://storage.perpusdigital.com/clean-code.pdf', 3),
(1007, 'Design Patterns', 'Gang of Four', 'Addison-Wesley', 1994, 'https://storage.perpusdigital.com/design-patterns.pdf', 3),
(1008, 'Steve Jobs', 'Walter Isaacson', 'Simon & Schuster', 2011, 'https://storage.perpusdigital.com/steve-jobs.pdf', 7),
(1009, 'Elon Musk', 'Ashlee Vance', 'Ecco', 2015, 'https://storage.perpusdigital.com/elon-musk.pdf', 7),
(1010, 'Rich Dad Poor Dad', 'Robert Kiyosaki', 'Warner Books', 1997, 'https://storage.perpusdigital.com/rich-dad-poor-dad.pdf', 4),
(1011, 'The Lean Startup', 'Eric Ries', 'Crown Business', 2011, 'https://storage.perpusdigital.com/lean-startup.pdf', 4),
(1012, 'Thinking Fast and Slow', 'Daniel Kahneman', 'Farrar Straus Giroux', 2011, 'https://storage.perpusdigital.com/thinking-fast-slow.pdf', 2),
(1013, 'A Brief History of Time', 'Stephen Hawking', 'Bantam Books', 1988, 'https://storage.perpusdigital.com/brief-history-time.pdf', 6),
(1014, 'Cosmos', 'Carl Sagan', 'Random House', 1980, 'https://storage.perpusdigital.com/cosmos.pdf', 6),
(1015, 'The Art of War', 'Sun Tzu', 'Various', 2000, 'https://storage.perpusdigital.com/art-of-war.pdf', 5),
(1016, '1984', 'George Orwell', 'Secker & Warburg', 1949, 'https://storage.perpusdigital.com/1984.pdf', 1),
(1017, 'Animal Farm', 'George Orwell', 'Secker & Warburg', 1945, 'https://storage.perpusdigital.com/animal-farm.pdf', 1),
(1018, 'To Kill a Mockingbird', 'Harper Lee', 'J.B. Lippincott', 1960, 'https://storage.perpusdigital.com/mockingbird.pdf', 1),
(1019, 'The Great Gatsby', 'F. Scott Fitzgerald', 'Scribner', 1925, 'https://storage.perpusdigital.com/great-gatsby.pdf', 1),
(1020, 'Harry Potter and the Philosophers Stone', 'J.K. Rowling', 'Bloomsbury', 1997, 'https://storage.perpusdigital.com/harry-potter-1.pdf', 1),
(1021, 'Naruto Vol 1', 'Masashi Kishimoto', 'Shueisha', 1999, 'https://storage.perpusdigital.com/naruto-1.pdf', 10),
(1022, 'One Piece Vol 1', 'Eiichiro Oda', 'Shueisha', 1997, 'https://storage.perpusdigital.com/onepiece-1.pdf', 10),
(1023, 'Deep Work', 'Cal Newport', 'Grand Central Publishing', 2016, 'https://storage.perpusdigital.com/deep-work.pdf', 8),
(1024, 'The 7 Habits of Highly Effective People', 'Stephen Covey', 'Free Press', 1989, 'https://storage.perpusdigital.com/7-habits.pdf', 8),
(1025, 'Good to Great', 'Jim Collins', 'Harper Business', 2001, 'https://storage.perpusdigital.com/good-to-great.pdf', 4);
SELECT * FROM BUKU;

INSERT INTO akses_buku (id_pelanggan, id_buku, tanggal_mulai, tanggal_berakhir, status, token_akses) VALUES
(26001, 1001, '2026-06-01', '2026-12-31', 'Aktif', 'TOKEN-A1-001'),
(26001, 1003, '2026-06-01', '2026-12-31', 'Aktif', 'TOKEN-A1-003'),
(26001, 1006, '2026-06-01', '2026-12-31', 'Aktif', 'TOKEN-A1-006'),
(26001, 1010, '2026-06-01', '2026-12-31', 'Aktif', 'TOKEN-A1-010'),
(26001, 1023, '2026-06-01', '2026-12-31', 'Aktif', 'TOKEN-A1-023'),

(26002, 1002, '2026-05-15', '2026-11-15', 'Aktif', 'TOKEN-S2-002'),
(26002, 1005, '2026-05-15', '2026-11-15', 'Aktif', 'TOKEN-S2-005'),
(26002, 1012, '2026-05-15', '2026-11-15', 'Aktif', 'TOKEN-S2-012'),

(26003, 1006, '2026-04-01', '2026-10-01', 'Aktif', 'TOKEN-B3-006'),
(26003, 1007, '2026-04-01', '2026-10-01', 'Aktif', 'TOKEN-B3-007'),
(26003, 1020, '2026-01-01', '2026-06-01', 'Nonaktif', 'TOKEN-B3-020'),
(26003, 1021, '2026-04-01', '2026-10-01', 'Aktif', 'TOKEN-B3-021'),

(26004, 1003, '2026-06-10', '2026-12-10', 'Aktif', 'TOKEN-D4-003'),
(26004, 1004, '2026-06-10', '2026-12-10', 'Aktif', 'TOKEN-D4-004'),
(26004, 1008, '2026-06-10', '2026-12-10', 'Aktif', 'TOKEN-D4-008'),
(26004, 1010, '2026-06-10', '2026-12-10', 'Aktif', 'TOKEN-D4-010'),
(26004, 1011, '2026-06-10', '2026-12-10', 'Aktif', 'TOKEN-D4-011'),
(26004, 1024, '2026-06-10', '2026-12-10', 'Aktif', 'TOKEN-D4-024'),

(26005, 1006, '2026-05-01', '2026-11-01', 'Aktif', 'TOKEN-R5-006'),
(26005, 1007, '2026-05-01', '2026-11-01', 'Aktif', 'TOKEN-R5-007'),
(26005, 1013, '2026-05-01', '2026-11-01', 'Aktif', 'TOKEN-R5-013'),

(26006, 1016, '2026-06-05', '2026-12-05', 'Aktif', 'TOKEN-L6-016'),
(26006, 1017, '2026-06-05', '2026-12-05', 'Aktif', 'TOKEN-L6-017'),
(26007, 1021, '2026-05-20', '2026-11-20', 'Aktif', 'TOKEN-A7-021'),
(26007, 1022, '2026-05-20', '2026-11-20', 'Aktif', 'TOKEN-A7-022'),
(26008, 1001, '2026-06-15', '2026-12-15', 'Aktif', 'TOKEN-M8-001'),
(26009, 1005, '2026-06-01', '2026-12-01', 'Aktif', 'TOKEN-H9-005'),
(26010, 1020, '2026-05-10', '2026-11-10', 'Aktif', 'TOKEN-P10-020');

SELECT * FROM AKSES_BUKU;

INSERT INTO riwayat_download (id_download, id_pelanggan, id_buku, tanggal_download) VALUES
(77001, 26001, 1001, '2026-06-02 10:30:00'),
(77002, 26001, 1003, '2026-06-05 14:20:00'),
(77003, 26001, 1006, '2026-06-08 09:15:00'),
(77004, 26001, 1001, '2026-06-12 16:45:00'),
(77005, 26001, 1010, '2026-06-15 11:30:00'),
(77006, 26001, 1023, '2026-06-18 13:20:00'),
(77007, 26001, 1003, '2026-06-20 10:00:00'),
(77008, 26001, 1006, '2026-06-21 15:30:00'),

(77009, 26002, 1002, '2026-05-16 09:00:00'),
(77010, 26002, 1005, '2026-05-20 14:30:00'),
(77011, 26002, 1012, '2026-06-01 10:15:00'),
(77012, 26002, 1002, '2026-06-10 16:20:00'),

(77013, 26003, 1006, '2026-04-05 11:00:00'),
(77014, 26003, 1007, '2026-04-10 13:45:00'),
(77015, 26003, 1006, '2026-05-15 10:30:00'),
(77016, 26003, 1021, '2026-06-01 14:00:00'),
(77017, 26003, 1007, '2026-06-15 09:20:00'),

(77018, 26004, 1003, '2026-06-11 08:30:00'),
(77019, 26004, 1004, '2026-06-12 10:00:00'),
(77020, 26004, 1008, '2026-06-13 14:15:00'),
(77021, 26004, 1010, '2026-06-14 09:45:00'),
(77022, 26004, 1011, '2026-06-15 11:20:00'),
(77023, 26004, 1024, '2026-06-16 13:30:00'),
(77024, 26004, 1003, '2026-06-18 10:15:00'),
(77025, 26004, 1004, '2026-06-19 15:00:00'),
(77026, 26004, 1008, '2026-06-20 09:30:00'),
(77027, 26004, 1010, '2026-06-21 14:45:00'),

(77028, 26005, 1006, '2026-05-05 10:00:00'),
(77029, 26005, 1007, '2026-05-20 14:30:00'),
(77030, 26005, 1013, '2026-06-10 11:15:00'),

(77031, 26006, 1016, '2026-06-06 09:30:00'),
(77032, 26006, 1017, '2026-06-12 14:00:00'),

(77033, 26007, 1021, '2026-05-22 10:45:00'),
(77034, 26007, 1022, '2026-06-05 13:20:00'),

(77035, 26008, 1001, '2026-06-16 11:00:00'),

(77036, 26009, 1005, '2026-06-02 15:30:00'),

(77037, 26010, 1020, '2026-05-12 10:20:00');

SELECT * FROM RIWAYAT_DOWNLOAD;

INSERT INTO ulasan (id_ulasan, id_pelanggan, id_buku, rating, komentar, tanggal_ulasan) VALUES
(88001, 26001, 1001, 5, 'Sangat menginspirasi! Cerita tentang perjuangan pendidikan di Belitung sangat menyentuh.', '2026-06-03'),
(88002, 26008, 1001, 5, 'Novel terbaik yang pernah saya baca. Recommended!', '2026-06-17'),
(88003, 26002, 1002, 5, 'Masterpiece karya Pramoedya. Wajib dibaca untuk memahami sejarah Indonesia.', '2026-05-17'),
(88004, 26001, 1003, 5, 'Buku self-improvement terbaik. Praktis dan mudah diterapkan.', '2026-06-06'),
(88005, 26004, 1003, 4, 'Konsep atomic habits sangat membantu dalam membentuk kebiasaan baik.', '2026-06-12'),
(88006, 26004, 1004, 5, 'Mengubah cara pandang saya tentang uang dan investasi.', '2026-06-13'),
(88007, 26002, 1005, 5, 'Sapiens membuka wawasan tentang sejarah umat manusia. Mind-blowing!', '2026-05-21'),
(88008, 26009, 1005, 4, 'Buku yang sangat informatif dan well-researched.', '2026-06-03'),
(88009, 26001, 1006, 5, 'Must-read untuk programmer. Clean code adalah seni!', '2026-06-09'),
(88010, 26003, 1006, 5, 'Standar emas untuk penulisan kode yang berkualitas.', '2026-04-06'),
(88011, 26005, 1006, 4, 'Sangat berguna untuk meningkatkan skill programming.', '2026-05-06'),
(88012, 26003, 1007, 4, 'Design patterns explained dengan contoh yang jelas.', '2026-04-11'),
(88013, 26005, 1007, 5, 'Referensi wajib untuk software engineer.', '2026-05-21'),
(88014, 26004, 1008, 5, 'Biografi Steve Jobs yang sangat detail dan inspiratif.', '2026-06-14'),
(88015, 26001, 1010, 4, 'Perspektif baru tentang financial literacy.', '2026-06-16'),
(88016, 26004, 1010, 5, 'Buku yang mengubah mindset saya tentang keuangan.', '2026-06-15'),
(88017, 26004, 1011, 4, 'Metodologi lean startup sangat applicable untuk bisnis apapun.', '2026-06-16'),
(88018, 26002, 1012, 5, 'Daniel Kahneman menjelaskan behavioral economics dengan brilliant.', '2026-06-02'),
(88019, 26005, 1013, 4, 'Stephen Hawking menulis fisika dengan cara yang accessible.', '2026-06-11'),
(88020, 26006, 1016, 5, '1984 masih sangat relevan di era digital ini.', '2026-06-07'),
(88021, 26006, 1017, 4, 'Alegori politik yang powerful.', '2026-06-13'),
(88022, 26010, 1020, 5, 'Harry Potter tidak pernah mengecewakan!', '2026-05-13'),
(88023, 26007, 1021, 5, 'Naruto adalah manga terbaik sepanjang masa!', '2026-05-23'),
(88024, 26007, 1022, 5, 'One Piece memiliki world-building yang luar biasa.', '2026-06-06'),
(88025, 26001, 1023, 5, 'Deep Work mengajarkan fokus di era distraksi.', '2026-06-19'),
(88026, 26004, 1024, 4, '7 Habits adalah fondasi personal development.', '2026-06-17');
SELECT*FROM ULASAN;



SELECT * FROM WISHLIST;

SELECT id_kategori, id_buku, judul, file_url FROM buku;

SELECT 
    nama AS "Nama Lengkap", 
    email AS "Alamat Email",
    no_hp AS "Nomor Telepon"
FROM pelanggan;

SELECT DISTINCT id_ulasan, rating FROM ulasan;

SELECT 
    token_akses AS "Token Asli",
    LOWER(token_akses) AS "token_kecil",  -- Fungsi LOWER untuk lowercase
    CONCAT('PLG:', id_pelanggan, ' -> BK:', id_buku) AS "Log Relasi",  -- Fungsi CONCAT
    (tanggal_berakhir - tanggal_mulai) AS "Durasi Pinjam (Hari)",  -- Operasi tanggal
    CAST((tanggal_berakhir - tanggal_mulai) AS TEXT) AS "Durasi String",  -- CAST type conversion
    LENGTH(token_akses) AS "Panjang Token"  -- Fungsi LENGTH
FROM akses_buku;

SELECT id_buku, judul, penulis 
FROM buku 
WHERE judul ILIKE 'the%';

SELECT id_buku, judul, penerbit, tahun_terbit, id_kategori
FROM buku
WHERE penerbit = 'Shueisha'   
  AND tahun_terbit > 1995    
  AND id_kategori >= 5;

SELECT id_ulasan, rating, komentar 
FROM ulasan 
WHERE komentar ILIKE '%terbaik%';

SELECT id_buku, judul, penulis 
FROM buku 
WHERE judul ~* '^[a-g]';

SELECT id_buku, judul, tahun_terbit 
FROM buku 
WHERE tahun_terbit BETWEEN 2000 AND 2015;

SELECT id_buku, judul, penerbit, tahun_terbit 
FROM buku 
ORDER BY penerbit ASC, tahun_terbit DESC NULLS LAST;

SELECT id_buku, judul, tahun_terbit
FROM buku
ORDER BY tahun_terbit DESC NULLS LAST
OFFSET 3 
LIMIT 3;  

SELECT u.id_ulasan,
       p.nama AS nama_pelanggan,
       u.rating
FROM ulasan u
INNER JOIN pelanggan p ON u.id_pelanggan = p.id_pelanggan;

SELECT 
    p.nama AS "Nama Pelanggan",
    COUNT(r.id_download) AS "Total Download"
FROM pelanggan p
LEFT JOIN riwayat_download r ON p.id_pelanggan = r.id_pelanggan
GROUP BY p.id_pelanggan, p.nama
ORDER BY "Total Download" DESC;

SELECT 
    b.judul AS "Judul Buku",
    k.nama_kategori AS "Kategori",
    p.nama AS "Nama Reviewer",
    u.rating,
    u.komentar
FROM buku b
INNER JOIN kategori k ON b.id_kategori = k.id_kategori
INNER JOIN ulasan u ON b.id_buku = u.id_buku
INNER JOIN pelanggan p ON u.id_pelanggan = p.id_pelanggan
WHERE u.rating >= 4
ORDER BY b.judul, u.rating DESC;

SELECT 
    COUNT(*) AS total_ulasan,
    ROUND(AVG(rating), 2) AS "Rata2 Rating",
    MAX(rating) AS "Rating Tertinggi",
    MIN(rating) AS "Rating Terendah",
    PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY rating) AS "Median Rating"
FROM ulasan;

SELECT
    b.judul AS "Judul Buku",
    COUNT(*) FILTER (WHERE u.rating = 5) AS "Ulasan Bintang 5"
FROM buku b
LEFT JOIN ulasan u ON b.id_buku = u.id_buku
GROUP BY b.id_buku, b.judul
HAVING COUNT(*) FILTER (WHERE u.rating = 5) > 0  -- HAVING untuk filter hasil agregasi
ORDER BY "Ulasan Bintang 5" DESC;

WITH rata_tahun AS (
    SELECT AVG(tahun_terbit) AS rata
    FROM buku
)
SELECT 
    b.judul,
    b.tahun_terbit,
    ROUND(r.rata, 1) AS "Rata-rata Tahun Global"
FROM buku b, rata_tahun r
WHERE b.tahun_terbit > r.rata;

WITH rata_rating AS (
    SELECT AVG(rating) AS rata
    FROM ulasan
)
SELECT 
    u.id_ulasan,
    u.id_buku,
    u.rating,
    ROUND(r.rata, 2) AS "Rata-rata Rating Global"
FROM ulasan u, rata_rating r
WHERE u.rating > r.rata;

SELECT 
    token_akses,
    id_buku,
    (tanggal_berakhir - tanggal_mulai) AS durasi_hari,
    
    ROW_NUMBER() OVER (
        PARTITION BY id_buku 
        ORDER BY (tanggal_berakhir - tanggal_mulai) DESC
    ) AS urutan_baris,
    
    RANK() OVER (
        PARTITION BY id_buku 
        ORDER BY (tanggal_berakhir - tanggal_mulai) DESC
    ) AS rank_lompat,
    
    DENSE_RANK() OVER (
        PARTITION BY id_buku 
        ORDER BY (tanggal_berakhir - tanggal_mulai) DESC
    ) AS rank_rapat
FROM akses_buku;

SELECT 
    token_akses AS "Token Asli",
    LOWER(token_akses) AS "token_kecil",
    CONCAT('PLG:', id_pelanggan, ' -> BK:', id_buku) AS "Log Relasi",
    (tanggal_berakhir - tanggal_mulai) AS "Durasi Pinjam (Hari)",
    CAST((tanggal_berakhir - tanggal_mulai) AS TEXT) AS "Durasi String",
    LENGTH(token_akses) AS "Panjang Token"
FROM akses_buku;


CREATE OR REPLACE VIEW view_statistik_buku AS
SELECT 
    b.id_buku,
    b.judul,
    b.penulis,
    k.nama_kategori,
    COUNT(DISTINCT u.id_ulasan) AS jumlah_ulasan,
    ROUND(AVG(u.rating), 2) AS rata_rating,
    COUNT(DISTINCT r.id_download) AS jumlah_download
FROM buku b
LEFT JOIN kategori k ON b.id_kategori = k.id_kategori
LEFT JOIN ulasan u ON b.id_buku = u.id_buku
LEFT JOIN riwayat_download r ON b.id_buku = r.id_buku
GROUP BY b.id_buku, b.judul, b.penulis, k.nama_kategori;

SELECT * FROM view_statistik_buku 
WHERE rata_rating >= 4.5 
ORDER BY jumlah_download DESC;



CREATE MATERIALIZED VIEW mv_buku_populer AS
SELECT 
    b.id_buku,
    b.judul,
    b.penulis,
    k.nama_kategori,
    COUNT(DISTINCT r.id_download) AS total_download,
    COUNT(DISTINCT u.id_ulasan) AS total_ulasan,
    ROUND(AVG(u.rating), 2) AS avg_rating
FROM buku b
LEFT JOIN kategori k ON b.id_kategori = k.id_kategori
LEFT JOIN riwayat_download r ON b.id_buku = r.id_buku
LEFT JOIN ulasan u ON b.id_buku = u.id_buku
GROUP BY b.id_buku, b.judul, b.penulis, k.nama_kategori
HAVING COUNT(DISTINCT r.id_download) > 2;

SELECT * FROM mv_buku_populer ORDER BY total_download DESC;

CREATE OR REPLACE FUNCTION hitung_total_download(p_id_pelanggan INT)
RETURNS INT AS $$
DECLARE
    total INT;
BEGIN
    SELECT COUNT(*) INTO total
    FROM riwayat_download
    WHERE id_pelanggan = p_id_pelanggan;
    
    RETURN total;
END;
$$ LANGUAGE plpgsql;

SELECT 
    nama, 
    email, 
    hitung_total_download(id_pelanggan) AS "Total Download"
FROM pelanggan
ORDER BY hitung_total_download(id_pelanggan) DESC
LIMIT 5;

CREATE OR REPLACE FUNCTION aktifkan_akses_buku()
RETURNS TRIGGER AS $$
BEGIN

    UPDATE akses_buku
    SET status = 'Aktif'
    WHERE id_pelanggan = NEW.id_pelanggan
    AND id_buku = NEW.id_buku;

    RETURN NEW;

END;
$$ LANGUAGE plpgsql;



CREATE TRIGGER trigger_aktifkan_akses
AFTER INSERT ON riwayat_download
FOR EACH ROW
EXECUTE FUNCTION aktifkan_akses_buku();



-- simulasi download baru
INSERT INTO riwayat_download
(
    id_download,
    id_pelanggan,
    id_buku
)
VALUES
(
    77038,
    26001,
    1001
);



-- cek hasil perubahan
SELECT 
id_pelanggan,
id_buku,
status
FROM akses_buku
WHERE id_pelanggan = 26001
AND id_buku = 1001;

BEGIN;

INSERT INTO pelanggan
(
    id_pelanggan,
    nama,
    email,
    no_hp,
    alamat
)
VALUES
(
    26017,
    'Rudi Hermawan',
    'rudi2@email.com',
    '081234567806',
    'Jl. Merdeka No. 50, Jakarta'
);


INSERT INTO wishlist
(
    id_pelanggan,
    id_buku,
    tanggal_ditambahkan,
    catatan
)
VALUES
(
    26017,
    1001,
    CURRENT_TIMESTAMP,
    'Ingin membaca Laskar Pelangi'
),
(
    26017,
    1003,
    CURRENT_TIMESTAMP,
    'Atomic Habits untuk self improvement'
);


COMMIT;

SELECT 
    b.judul,
    k.nama_kategori,
    COUNT(r.id_download) AS total_download
FROM buku b
INNER JOIN kategori k ON b.id_kategori = k.id_kategori
LEFT JOIN riwayat_download r ON b.id_buku = r.id_buku
GROUP BY b.id_buku, b.judul, k.nama_kategori;


SELECT 
    p.nama AS "Nama Pelanggan",
    b.judul AS "Judul Buku",
    u.rating,
    u.komentar
FROM pelanggan p
INNER JOIN ulasan u ON p.id_pelanggan = u.id_pelanggan
INNER JOIN buku b ON u.id_buku = b.id_buku
WHERE u.rating >= 4
ORDER BY u.rating DESC, p.nama;

EXPLAIN
SELECT 
    b.judul,
    k.nama_kategori,
    COUNT(r.id_download) AS total_download
FROM buku b
INNER JOIN kategori k 
ON b.id_kategori = k.id_kategori
LEFT JOIN riwayat_download r
ON b.id_buku = r.id_buku
GROUP BY b.id_buku, b.judul, k.nama_kategori;

EXPLAIN ANALYZE
SELECT 
    p.nama,
    COUNT(r.id_download) AS total_download
FROM pelanggan p
LEFT JOIN riwayat_download r
ON p.id_pelanggan = r.id_pelanggan
GROUP BY p.id_pelanggan, p.nama;