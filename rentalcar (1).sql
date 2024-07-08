-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Jul 08, 2024 at 07:07 PM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `rentalcar`
--

DELIMITER $$
--
-- Procedures
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_display_car` ()   BEGIN
    DECLARE total_mobil INT;
    
    SELECT COUNT(*) INTO total_mobil FROM mobil;
   
    CASE
        WHEN total_mobil > 0 THEN
            SELECT * FROM mobil;
        WHEN total_mobil = 0 THEN
            SELECT 'Tidak ada mobil yang tersedia.' AS info;
        ELSE
            SELECT 'Terjadi kesalahan dalam menampilkan data mobil.' AS info;
    END CASE;
    
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_display_car_by_month_and_brand` (IN `p_bulan` INT, IN `p_brand` VARCHAR(100))   BEGIN
    DECLARE total_hari_sewa INT;
    SET total_hari_sewa = 0;

    SELECT SUM(DATEDIFF(transaksi.tanggal_selesai, transaksi.tanggal_mulai))
    INTO total_hari_sewa
    FROM transaksi
    JOIN mobil ON transaksi.car_id = mobil.id
    WHERE MONTH(transaksi.tanggal_mulai) = p_bulan
    AND mobil.nama_brand = p_brand;

    IF total_hari_sewa > 0 THEN
        SELECT 
            mobil.nama_seri,
            mobil.nama_brand,
            total_hari_sewa AS total_hari_sewa
        FROM transaksi
	join mobil on transaksi.car_id = mobil.id
        WHERE mobil.nama_brand = p_brand;
    ELSE
        SELECT 'Tidak ada transaksi untuk bulan dan merk mobil yang diberikan.' AS info;
    END IF;
END$$

--
-- Functions
--
CREATE DEFINER=`root`@`localhost` FUNCTION `f_total_profit` () RETURNS INT(11)  BEGIN 
    DECLARE profit INT;
    
    SELECT SUM(mobil.harga) INTO profit
    FROM transaksi
    JOIN mobil ON transaksi.car_id = mobil.id;
    
    RETURN profit;
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `f_total_profit_setiap_bulan_setiap_mobil` (`nama` VARCHAR(100), `bulan` INT) RETURNS INT(11)  BEGIN 
    DECLARE total_harga int;
    
    -- Hitung total harga transaksi berdasarkan nama dan bulan
    SELECT SUM(mobil.harga * DATEDIFF(transaksi.tanggal_selesai, transaksi.tanggal_mulai))
    INTO total_harga
    FROM transaksi
    JOIN mobil ON transaksi.car_id = mobil.id
    WHERE mobil.nama_seri = nama
      AND MONTH(transaksi.tanggal_mulai) = bulan;
    
    RETURN total_harga;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `akun`
--

CREATE TABLE `akun` (
  `id` int(11) NOT NULL,
  `username` varchar(25) NOT NULL,
  `email` varchar(100) NOT NULL,
  `PASSWORD` varchar(30) NOT NULL,
  `foto_profile` varchar(255) DEFAULT NULL,
  `role` enum('Admin','User') NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `akun`
--

INSERT INTO `akun` (`id`, `username`, `email`, `PASSWORD`, `foto_profile`, `role`) VALUES
(3, 'haidar', 'haidar44@gmail.com', 'h4id4r', 'user/gambar.jpg', 'User'),
(4, 'ari', 'ari55@gmail.com', 'arie44', 'user/gambar2.jpg', 'User'),
(5, 'irhab', 'irhabm33@gmail.com', 'irhabe23', 'user/gambar3.jpg', 'User'),
(6, 'admin1', 'adminrental@gmail.com', 'heizakmi123', 'admin/gambar.jpg', 'Admin'),
(7, 'lele', 'lele23@gmail.com', 'lelalole90#', 'user/gambar4.jpg', 'User'),
(8, 'nyker', 'nyres@gmail.com', 'serkale23@!', 'user/gambar5.jpg', 'User');

-- --------------------------------------------------------

--
-- Table structure for table `data_pengguna`
--

CREATE TABLE `data_pengguna` (
  `NIK` varchar(20) NOT NULL,
  `alamat` varchar(255) DEFAULT NULL,
  `no_telepon` varchar(15) DEFAULT NULL,
  `foto_ktp` varchar(255) DEFAULT NULL,
  `akun_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `data_pengguna`
--

INSERT INTO `data_pengguna` (`NIK`, `alamat`, `no_telepon`, `foto_ktp`, `akun_id`) VALUES
('3301084523452', 'Jakarta', '087542352312', 'user/gambarktp5.jpg', 8),
('330108453647285', 'Yogyakarta', '0877125345342', 'user/gambarktp2.jpg', 3),
('3301084543221134', 'Yogyakarta', '0815213675535', 'user/gambarktp1.jpg', 4),
('330108909020345', 'Yogyakarta', '085218361621', 'user/gambarktp3.jpg', 5),
('3301089234034', 'Bandung', '081232254523', 'user/gambarktp4.jpg', 7);

-- --------------------------------------------------------

--
-- Table structure for table `driver`
--

CREATE TABLE `driver` (
  `driver_id` int(11) NOT NULL,
  `nama` varchar(50) DEFAULT NULL,
  `gender` enum('laki-laki','perempuan') DEFAULT NULL,
  `no_hp` varchar(15) DEFAULT NULL,
  `tanggal_gabung` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `driver`
--

INSERT INTO `driver` (`driver_id`, `nama`, `gender`, `no_hp`, `tanggal_gabung`) VALUES
(1, 'Amin', 'laki-laki', '08742452355', '2024-07-08'),
(2, 'Geisha', 'perempuan', '08724325112', '2024-07-10'),
(3, 'Leonardo', 'laki-laki', '089214125674', '2024-07-08'),
(4, 'Kaizer', 'laki-laki', '08123525312', '2024-07-10'),
(5, 'Lala', 'perempuan', '08712341243', '2024-07-11'),
(7, 'andras', 'laki-laki', '08723742565', '2024-07-01');

--
-- Triggers `driver`
--
DELIMITER $$
CREATE TRIGGER `before_delete` BEFORE DELETE ON `driver` FOR EACH ROW BEGIN 
INSERT INTO driver_log (`nama`,`keterangan`,`tanggal_aktivitas`,`user_database`) VALUE (old.nama,'hapus',now(),USER()); 
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `driver_log`
--

CREATE TABLE `driver_log` (
  `id` int(11) NOT NULL,
  `nama` varchar(50) NOT NULL,
  `keterangan` varchar(100) NOT NULL,
  `tanggal_aktivitas` date NOT NULL,
  `user_database` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `driver_log`
--

INSERT INTO `driver_log` (`id`, `nama`, `keterangan`, `tanggal_aktivitas`, `user_database`) VALUES
(1, 'Lulu', 'hapus', '2024-07-08', 'root@localhost');

-- --------------------------------------------------------

--
-- Table structure for table `event_perusahaan`
--

CREATE TABLE `event_perusahaan` (
  `id` int(11) NOT NULL,
  `judul` varchar(50) NOT NULL,
  `isi` text NOT NULL,
  `gambar_event` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `event_perusahaan`
--

INSERT INTO `event_perusahaan` (`id`, `judul`, `isi`, `gambar_event`) VALUES
(1, 'Melakukan sosialisai tentang berkendara di lingkun', 'Keselamatan berkendara adalah hal yang sangat penting, terutama di lingkungan sekitar kita. Untuk meningkatkan kesadaran masyarakat, acara sosialisasi tentang berkendara dengan aman telah diselenggarakan pada [Tanggal dan waktu acara] di [Lokasi acara]. Acara ini bertujuan untuk mengedukasi masyarakat tentang pentingnya mematuhi aturan lalu lintas dan berperilaku baik saat berkendara.\r\n\r\nAcara dimulai dengan sambutan hangat dari Ketua Panitia yang menjelaskan tujuan dari sosialisasi ini. Dilanjutkan dengan materi utama yang mencakup beberapa poin penting, yaitu:\r\n\r\nPentingnya Keselamatan Berkendara:\r\n\r\nMemakai Helm dan Sabuk Pengaman: Memakai helm saat mengendarai sepeda motor dan sabuk pengaman saat mengendarai mobil dapat mengurangi risiko cedera serius saat terjadi kecelakaan.\r\nMematuhi Rambu-rambu Lalu Lintas: Mengikuti aturan lalu lintas tidak hanya melindungi diri sendiri tetapi juga orang lain di jalan.\r\nMenghindari Kecepatan Berlebihan: Mengemudi dengan kecepatan yang wajar dan sesuai dengan batas yang ditentukan membantu mencegah kecelakaan.\r\nPerilaku Berkendara yang Baik:\r\n\r\nMenghormati Pejalan Kaki dan Pengguna Jalan Lainnya: Selalu memberikan prioritas kepada pejalan kaki dan pengguna jalan lainnya.\r\nMenghindari Penggunaan Ponsel Saat Berkendara: Menggunakan ponsel saat mengemudi dapat mengalihkan perhatian dan meningkatkan risiko kecelakaan.\r\nTidak Berkendara dalam Keadaan Mabuk atau Lelah: Berkendara dalam kondisi mabuk atau lelah sangat berbahaya dan dapat menyebabkan kecelakaan fatal.\r\nAcara ini juga memberikan kesempatan bagi peserta untuk berdiskusi dan bertanya jawab mengenai berbagai masalah yang dihadapi saat berkendara di lingkungan sekitar. Diskusi ini diharapkan dapat membuka wawasan peserta mengenai pentingnya keselamatan berkendara.\r\n\r\nDi akhir acara, panitia menyimpulkan kegiatan sosialisasi dengan ajakan untuk selalu mempraktikkan keselamatan berkendara setiap hari. Dengan demikian, kita dapat menciptakan lingkungan yang lebih aman dan nyaman untuk semua pengguna jalan.\r\n\r\nMari kita semua berkontribusi dalam menciptakan jalan yang lebih aman dengan mematuhi aturan dan berperilaku baik saat berkendara. Ingat, keselamatan adalah tanggung jawab kita bersama!', 'event/gambar1.jpg'),
(2, 'Rental Mobil dapat Undian', 'Rental Mobil Dapat Undian: Kesempatan Menarik untuk Pelanggan Setia!\r\n\r\nSebagai bentuk apresiasi kepada pelanggan setia, [Nama Perusahaan Rental Mobil] dengan bangga mengumumkan acara \"Rental Mobil Dapat Undian\" yang berlangsung selama bulan [Bulan dan Tahun]. Acara ini bertujuan untuk memberikan pengalaman menyenangkan sekaligus kesempatan untuk memenangkan hadiah menarik bagi para pelanggan kami.\r\n\r\nCara Mengikuti Undian:\r\n\r\nSewa Mobil di [Nama Perusahaan Rental Mobil]: Setiap kali Anda menyewa mobil dari kami selama periode undian, Anda otomatis mendapatkan satu kupon undian.\r\nPendaftaran Kupon: Pastikan untuk mendaftarkan kupon undian Anda di website kami atau melalui aplikasi [Nama Perusahaan] agar dapat ikut serta dalam undian.\r\nPengundian Hadiah: Undian akan dilakukan secara acak di akhir periode undian dan pemenang akan diumumkan melalui website, aplikasi, dan media sosial kami.\r\nHadiah Menarik Menanti Anda!\r\n\r\nKami telah menyiapkan berbagai hadiah menarik yang dapat Anda menangkan, termasuk:\r\n\r\nVoucher Sewa Mobil Gratis: Nikmati perjalanan Anda berikutnya tanpa biaya sewa.\r\nDiskon Spesial: Dapatkan diskon khusus untuk penyewaan mobil Anda di masa mendatang.\r\nHadiah Utama: [Sebutkan hadiah utama yang sangat menarik, seperti gadget terbaru atau perjalanan liburan].\r\nMengapa Memilih [Nama Perusahaan Rental Mobil]?\r\n\r\nArmada Kendaraan Terbaik: Kami menawarkan berbagai pilihan mobil yang terawat dan siap digunakan untuk berbagai kebutuhan Anda.\r\nLayanan Pelanggan Unggulan: Tim kami selalu siap membantu Anda dengan layanan terbaik dan solusi cepat untuk kebutuhan rental Anda.\r\nKeamanan dan Kenyamanan: Kendaraan kami dilengkapi dengan fitur keamanan terkini untuk memastikan perjalanan Anda aman dan nyaman.\r\nJangan lewatkan kesempatan emas ini! Segera sewa mobil di [Nama Perusahaan Rental Mobil] selama periode undian dan menangkan berbagai hadiah menarik yang telah kami siapkan. Terus ikuti update dan pengumuman pemenang melalui website dan media sosial kami.\r\n\r\nTerima kasih atas kepercayaan Anda kepada [Nama Perusahaan Rental Mobil]. Kami selalu berkomitmen untuk memberikan layanan terbaik dan pengalaman berkendara yang tak terlupakan untuk Anda. Selamat mengikuti undian dan semoga Anda beruntung!', 'event/gambar2.jpg'),
(3, 'Pemeliharaan berkala terhadap mobil di rental', 'Di [Nama Perusahaan Rental Mobil], kami memahami betapa pentingnya keamanan dan kenyamanan bagi setiap pelanggan yang menggunakan layanan kami. Oleh karena itu, kami sangat memperhatikan pemeliharaan berkala terhadap seluruh armada mobil kami. Berikut adalah langkah-langkah yang kami lakukan untuk memastikan mobil-mobil kami selalu dalam kondisi prima:\r\n\r\n1. Pemeriksaan Mesin Secara Rutin\r\nSetiap mobil dalam armada kami menjalani pemeriksaan mesin secara berkala oleh teknisi ahli. Kami memeriksa dan memastikan semua komponen mesin berfungsi dengan baik, termasuk oli, filter, dan sistem pendingin.\r\n\r\n2. Perawatan Sistem Rem\r\nSistem rem yang baik adalah kunci utama untuk keselamatan. Kami melakukan pemeriksaan dan penggantian komponen rem seperti kampas, cakram, dan minyak rem sesuai dengan standar keamanan.\r\n\r\n3. Pengecekan Ban dan Keseimbangan Roda\r\nKami memastikan bahwa semua ban dalam kondisi baik dan memiliki tekanan yang sesuai. Selain itu, keseimbangan roda juga diperiksa untuk mencegah getaran yang tidak diinginkan saat berkendara.\r\n\r\n4. Penggantian Oli dan Filter\r\nSecara rutin, kami mengganti oli dan filter pada semua mobil untuk menjaga kinerja mesin tetap optimal dan memperpanjang umur kendaraan.\r\n\r\n5. Pemeriksaan Sistem Kelistrikan\r\nSistem kelistrikan seperti lampu, baterai, dan komponen elektronik lainnya diperiksa secara berkala untuk memastikan semuanya berfungsi dengan baik dan tidak ada masalah yang bisa mengganggu perjalanan Anda.\r\n\r\n6. Kebersihan Interior dan Eksterior\r\nKami menjaga kebersihan interior dan eksterior mobil untuk memberikan kenyamanan maksimal kepada pelanggan. Mobil-mobil kami selalu dibersihkan setelah setiap penggunaan.\r\n\r\n7. Uji Emisi\r\nKami melakukan uji emisi secara berkala untuk memastikan bahwa mobil-mobil kami ramah lingkungan dan memenuhi standar emisi yang ditetapkan.\r\n\r\nManfaat Pemeliharaan Berkala bagi Pelanggan\r\n\r\nKeamanan Terjamin: Dengan pemeliharaan rutin, kami memastikan mobil-mobil kami selalu dalam kondisi terbaik, sehingga perjalanan Anda aman dan bebas masalah.\r\nKenyamanan Maksimal: Mobil yang terawat dengan baik memberikan pengalaman berkendara yang lebih nyaman dan menyenangkan.\r\nKinerja Optimal: Performa mesin yang terjaga dengan baik memastikan mobil selalu siap digunakan tanpa kendala.\r\nKomitmen Kami\r\n\r\nDi [Nama Perusahaan Rental Mobil], kami berkomitmen untuk memberikan layanan terbaik kepada pelanggan kami. Pemeliharaan berkala adalah salah satu langkah penting yang kami lakukan untuk memastikan Anda mendapatkan pengalaman terbaik saat menggunakan layanan rental mobil kami. Kami percaya bahwa mobil yang terawat dengan baik tidak hanya memberikan keamanan dan kenyamanan, tetapi juga menunjukkan komitmen kami terhadap kualitas layanan.', 'evenet/gambar3.jpg'),
(4, 'Diskon untuk pengguna tetap', 'Sebagai bentuk apresiasi kepada pelanggan setia, [Nama Perusahaan Rental Mobil] dengan senang hati mengumumkan program diskon eksklusif untuk pengguna tetap. Kami berkomitmen untuk memberikan nilai lebih dan keuntungan istimewa bagi Anda yang terus mempercayai layanan kami untuk kebutuhan transportasi Anda.\r\n\r\nKeuntungan Program Diskon Pengguna Tetap\r\n\r\nPotongan Harga Langsung:\r\n\r\nPengguna tetap berhak mendapatkan potongan harga langsung hingga [persentase diskon] untuk setiap penyewaan mobil. Nikmati perjalanan dengan biaya yang lebih hemat setiap kali Anda menggunakan layanan kami.\r\nPoin Loyalitas:\r\n\r\nSetiap kali Anda menyewa mobil, Anda akan mendapatkan poin loyalitas yang bisa ditukarkan dengan berbagai keuntungan menarik, seperti sewa mobil gratis, upgrade kendaraan, atau diskon tambahan.\r\nPrioritas Reservasi:\r\n\r\nDapatkan prioritas dalam reservasi kendaraan, terutama pada musim liburan dan waktu-waktu sibuk. Pastikan Anda selalu mendapatkan mobil yang Anda butuhkan tanpa khawatir kehabisan.\r\nLayanan Khusus:\r\n\r\nPengguna tetap akan mendapatkan layanan khusus dari tim customer service kami, termasuk bantuan prioritas dan solusi cepat untuk setiap kebutuhan atau masalah yang mungkin Anda hadapi.\r\nCara Menjadi Pengguna Tetap\r\n\r\nBergabung dalam program pengguna tetap kami sangat mudah! Berikut langkah-langkahnya:\r\n\r\nDaftar sebagai Member:\r\n\r\nDaftarkan diri Anda sebagai member di website atau aplikasi [Nama Perusahaan Rental Mobil].\r\nSewa Mobil Secara Rutin:\r\n\r\nGunakan layanan rental mobil kami secara rutin untuk memenuhi kebutuhan transportasi Anda.\r\nKumpulkan Poin dan Nikmati Diskon:\r\n\r\nSetiap penyewaan akan menambah poin loyalitas Anda, yang bisa digunakan untuk mendapatkan berbagai keuntungan dan diskon.', 'event/gambar4.jpg'),
(5, 'merayakan ulang tahun ke 1 perusahaan kami', 'Kami dengan bangga mengumumkan bahwa [Nama Perusahaan Rental Mobil] telah mencapai tonggak penting dalam perjalanannya – ulang tahun pertama! Kami ingin mengucapkan terima kasih yang sebesar-besarnya kepada semua pelanggan, mitra, dan tim yang telah mendukung dan mempercayai kami sepanjang tahun ini.\r\n\r\nPerjalanan Kami Sejauh Ini\r\n\r\nSetahun yang lalu, [Nama Perusahaan Rental Mobil] didirikan dengan visi untuk menyediakan layanan rental mobil terbaik yang mengutamakan kualitas, keamanan, dan kenyamanan. Dalam waktu singkat, kami telah berhasil:\r\n\r\nMenambah Armada Kendaraan: Kami telah memperluas pilihan kendaraan kami, mulai dari mobil keluarga, mobil mewah, hingga kendaraan komersial, untuk memenuhi berbagai kebutuhan pelanggan.\r\nMemperluas Jangkauan Layanan: Kami kini melayani lebih banyak area dan terus bekerja untuk menjangkau lebih banyak pelanggan di berbagai lokasi.\r\nMeningkatkan Kualitas Layanan: Dengan fokus pada kepuasan pelanggan, kami telah memperbaiki dan meningkatkan berbagai aspek layanan kami, dari kemudahan reservasi hingga pelayanan pelanggan yang responsif.\r\nPromo Spesial Ulang Tahun\r\n\r\nSebagai tanda terima kasih dan untuk merayakan momen spesial ini, kami dengan senang hati mempersembahkan berbagai promo dan diskon spesial untuk Anda:\r\n\r\nDiskon 20% untuk Semua Penyewaan:\r\n\r\nNikmati potongan harga sebesar 20% untuk semua penyewaan mobil selama bulan perayaan ulang tahun kami.\r\nVoucher Sewa Gratis:\r\n\r\nDapatkan kesempatan memenangkan voucher sewa mobil gratis dengan mengikuti undian yang akan diadakan setiap minggu sepanjang bulan ini.\r\nHadiah Eksklusif untuk Pelanggan Setia:\r\n\r\nKami akan memberikan hadiah spesial untuk pelanggan yang telah setia menggunakan layanan kami selama setahun terakhir.\r\nAcara Perayaan\r\n\r\nKami juga mengundang Anda untuk bergabung dalam acara perayaan ulang tahun pertama kami yang akan diselenggarakan pada:\r\n\r\nTanggal: [Tanggal Acara]\r\nWaktu: [Waktu Acara]\r\nTempat: [Lokasi Acara]\r\nAcara ini akan diisi dengan berbagai kegiatan menarik, termasuk hiburan live, makan malam bersama, dan pengumuman pemenang undian. Ini adalah kesempatan bagi kami untuk bertemu langsung dengan pelanggan dan mitra kami serta merayakan pencapaian ini bersama-sama.', 'event/gambar5.jpg');

-- --------------------------------------------------------

--
-- Table structure for table `mobil`
--

CREATE TABLE `mobil` (
  `id` int(11) NOT NULL,
  `nama_seri` varchar(50) NOT NULL,
  `nama_brand` varchar(20) NOT NULL,
  `type` varchar(20) NOT NULL,
  `Jumlah_kursi` int(11) NOT NULL,
  `gambar_mobil` varchar(255) NOT NULL,
  `harga` int(11) NOT NULL,
  `stok_daily` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `mobil`
--

INSERT INTO `mobil` (`id`, `nama_seri`, `nama_brand`, `type`, `Jumlah_kursi`, `gambar_mobil`, `harga`, `stok_daily`) VALUES
(1, 'supra', 'toyota', 'jdm', 2, 'mobil/gambar1.jpg', 1000000, 1),
(2, 'fortuner', 'toyota', 'suv', 6, 'mobil/gambar2.jpg', 500000, 3),
(3, 'skyline r34', 'nissan', 'jdm', 2, 'mobil/gambar3.jpg', 900000, 2),
(4, 'huracan', 'lamborgini', 'sport', 2, 'mobil/gambar4.jpg', 3500000, 1),
(5, 'pajero', 'mitsubishi', 'suv', 6, 'mobil/gambar5.jpg', 450000, 4),
(10, 'CRV', 'HONDA', 'SUV', 0, '', 400000, 0),
(11, 'terios', 'DaihatsuU', 'SUV', 0, '', 250000, 0);

--
-- Triggers `mobil`
--
DELIMITER $$
CREATE TRIGGER `TAMBAHMOBIL` AFTER INSERT ON `mobil` FOR EACH ROW INSERT INTO mobil_log (car_id,nama_seri,nama_brand,harga,stok_daily,jenis_aktivitas,tanggal_aktivitas,user_database) VALUES (new.id,new.nama_seri,new.nama_brand,new.harga,new.stok_daily,'tambah',now(),USER())
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `after_delete` AFTER DELETE ON `mobil` FOR EACH ROW BEGIN 
INSERT INTO mobil_log (car_id,nama_seri,nama_brand,harga,stok_daily,jenis_aktivitas,tanggal_aktivitas,user_database) VALUE (old.id,old.nama_seri,old.nama_brand,old.harga,old.stok_daily,'hapus',now(),USER()); 
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `after_update` AFTER UPDATE ON `mobil` FOR EACH ROW BEGIN
    DECLARE harga_changed BOOL DEFAULT FALSE;
    DECLARE nama_seri_changed BOOL DEFAULT FALSE;
    DECLARE nama_brand_changed BOOL DEFAULT FALSE;

    -- Cek apakah harga berubah
    IF NEW.harga <> OLD.harga THEN
        SET harga_changed = TRUE;
    END IF;

    -- Cek apakah nama_seri berubah
    IF NEW.nama_seri <> OLD.nama_seri THEN
        SET nama_seri_changed = TRUE;
    END IF;

    -- Cek apakah deskripsi berubah
    IF NEW.nama_brand <> OLD.nama_brand THEN
        SET nama_brand_changed = TRUE;
    END IF;

    -- Memasukkan entri log jika ada perubahan yang terdeteksi
    IF harga_changed OR nama_seri_changed OR nama_brand_changed THEN
        INSERT INTO mobil_log_detail_edit (car_id, nama_seri_lama,nama_seri_baru, nama_brand_lama,nama_brand_baru,harga_lama,harga_baru,tanggal_aktivitas, user_database)
        VALUES (old.id,
                old.nama_seri,
                CASE WHEN nama_seri_changed THEN NEW.nama_seri ELSE null END,
                old.nama_brand,
                CASE WHEN nama_brand_changed THEN NEW.nama_brand ELSE null END,
                old.harga,
                CASE WHEN harga_changed THEN NEW.harga ELSE null END,
                NOW(),
                USER());
    END IF;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `before_insert_mobil` BEFORE INSERT ON `mobil` FOR EACH ROW BEGIN
    IF NEW.harga < 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'harga tidak bisa negatif';
    END IF;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `before_update` BEFORE UPDATE ON `mobil` FOR EACH ROW BEGIN
    DECLARE harga_changed BOOL DEFAULT FALSE;
    DECLARE nama_seri_changed BOOL DEFAULT FALSE;
    DECLARE nama_brand_changed BOOL DEFAULT FALSE;

    -- Cek apakah harga berubah
    IF NEW.harga <> OLD.harga THEN
        SET harga_changed = TRUE;
    END IF;

    -- Cek apakah nama_seri berubah
    IF NEW.nama_seri <> OLD.nama_seri THEN
        SET nama_seri_changed = TRUE;
    END IF;

    -- Cek apakah deskripsi berubah
    IF NEW.nama_brand <> OLD.nama_brand THEN
        SET nama_brand_changed = TRUE;
    END IF;

    -- Memasukkan entri log jika ada perubahan yang terdeteksi
    IF harga_changed OR nama_seri_changed OR nama_brand_changed THEN
        INSERT INTO mobil_log (car_id, nama_seri, nama_brand,harga,stok_daily,jenis_aktivitas, tanggal_aktivitas, user_database)
        VALUES (NEW.id,
                CASE WHEN nama_seri_changed THEN NEW.nama_seri ELSE old.nama_seri END,
                CASE WHEN nama_brand_changed THEN NEW.nama_brand ELSE old.nama_brand END,
                CASE WHEN harga_changed THEN NEW.harga ELSE old.harga END,
                old.stok_daily,
                'edit',
                NOW(),
                USER());
    END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `mobil_log`
--

CREATE TABLE `mobil_log` (
  `id` int(11) NOT NULL,
  `car_id` int(11) DEFAULT NULL,
  `nama_seri` varchar(50) DEFAULT NULL,
  `nama_brand` varchar(20) DEFAULT NULL,
  `harga` int(11) DEFAULT NULL,
  `stok_daily` int(11) DEFAULT NULL,
  `jenis_aktivitas` enum('tambah','edit','hapus') DEFAULT NULL,
  `tanggal_aktivitas` date DEFAULT NULL,
  `user_database` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `mobil_log`
--

INSERT INTO `mobil_log` (`id`, `car_id`, `nama_seri`, `nama_brand`, `harga`, `stok_daily`, `jenis_aktivitas`, `tanggal_aktivitas`, `user_database`) VALUES
(2, 7, 'veneno', 'lamborgini', 4000000, 1, 'tambah', '2024-07-08', 'root@localhost'),
(13, 2, 'fortuner', 'toyota', 500000, 3, 'edit', '2024-07-08', 'root@localhost'),
(14, NULL, 'veneno', 'lamborgini', 4000000, 1, 'hapus', '2024-07-08', 'root@localhost'),
(15, 9, 'veneno', 'lamborgini', 4000000, 1, 'tambah', '2024-07-08', 'root@localhost'),
(16, 9, 'veneno', 'lamborgini', 4000000, 1, 'hapus', '2024-07-08', 'root@localhost'),
(17, 10, 'CRV', 'HONDA', 450000, 0, 'tambah', '2024-07-08', 'root@localhost'),
(18, 10, 'CRV', 'HONDA', 400000, 0, 'edit', '2024-07-08', 'root@localhost'),
(19, 11, 'terios', 'daihatsu', 250000, 0, 'tambah', '2024-07-08', 'root@localhost'),
(20, 11, 'terios', 'DaihatsuU', 250000, 0, 'edit', '2024-07-08', 'root@localhost');

-- --------------------------------------------------------

--
-- Table structure for table `mobil_log_detail_edit`
--

CREATE TABLE `mobil_log_detail_edit` (
  `id` int(11) NOT NULL,
  `car_id` int(11) NOT NULL,
  `nama_seri_lama` varchar(50) NOT NULL,
  `nama_seri_baru` varchar(50) DEFAULT NULL,
  `nama_brand_lama` varchar(20) NOT NULL,
  `nama_brand_baru` varchar(20) DEFAULT NULL,
  `harga_lama` int(11) NOT NULL,
  `harga_baru` int(11) DEFAULT NULL,
  `tanggal_aktivitas` date NOT NULL,
  `user_database` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `mobil_log_detail_edit`
--

INSERT INTO `mobil_log_detail_edit` (`id`, `car_id`, `nama_seri_lama`, `nama_seri_baru`, `nama_brand_lama`, `nama_brand_baru`, `harga_lama`, `harga_baru`, `tanggal_aktivitas`, `user_database`) VALUES
(2, 2, 'fortunerr', 'fortuner', 'toyota', NULL, 500000, NULL, '2024-07-08', 'root@localhost'),
(3, 10, 'CRV', NULL, 'HONDA', NULL, 450000, 400000, '2024-07-08', 'root@localhost'),
(4, 11, 'terios', NULL, 'Daihatsu', 'DaihatsuU', 250000, NULL, '2024-07-08', 'root@localhost');

-- --------------------------------------------------------

--
-- Table structure for table `transaksi`
--

CREATE TABLE `transaksi` (
  `id` int(11) NOT NULL,
  `user_id` int(11) DEFAULT NULL,
  `car_id` int(11) DEFAULT NULL,
  `driver_id` int(11) DEFAULT NULL,
  `tanggal_mulai` date DEFAULT NULL,
  `tanggal_selesai` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `transaksi`
--

INSERT INTO `transaksi` (`id`, `user_id`, `car_id`, `driver_id`, `tanggal_mulai`, `tanggal_selesai`) VALUES
(1, 3, 4, NULL, '2024-07-22', '2024-07-23'),
(2, 3, 4, 4, '2024-07-30', '2024-07-31'),
(3, 4, 5, NULL, '2024-07-20', '2024-07-23'),
(4, 5, 3, 1, '2024-07-30', '2024-07-31'),
(5, 5, 1, NULL, '2024-07-24', '2024-07-25');

-- --------------------------------------------------------

--
-- Stand-in structure for view `v_driver`
-- (See below for the actual view)
--
CREATE TABLE `v_driver` (
`driver_id` int(11)
,`nama` varchar(50)
,`gender` enum('laki-laki','perempuan')
,`no_hp` varchar(15)
,`tanggal_gabung` date
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `v_mobil`
-- (See below for the actual view)
--
CREATE TABLE `v_mobil` (
`nama_seri` varchar(50)
,`nama_brand` varchar(20)
,`type` varchar(20)
,`harga` int(11)
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `v_mobil_suv`
-- (See below for the actual view)
--
CREATE TABLE `v_mobil_suv` (
`nama_seri` varchar(50)
,`nama_brand` varchar(20)
,`type` varchar(20)
,`harga` int(11)
);

-- --------------------------------------------------------

--
-- Table structure for table `wishlist`
--

CREATE TABLE `wishlist` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `car_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `wishlist`
--

INSERT INTO `wishlist` (`id`, `user_id`, `car_id`) VALUES
(1, 4, 5),
(2, 7, 4),
(3, 7, 3),
(4, 8, 4),
(5, 7, 1);

-- --------------------------------------------------------

--
-- Structure for view `v_driver`
--
DROP TABLE IF EXISTS `v_driver`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `v_driver`  AS SELECT `driver`.`driver_id` AS `driver_id`, `driver`.`nama` AS `nama`, `driver`.`gender` AS `gender`, `driver`.`no_hp` AS `no_hp`, `driver`.`tanggal_gabung` AS `tanggal_gabung` FROM `driver` ;

-- --------------------------------------------------------

--
-- Structure for view `v_mobil`
--
DROP TABLE IF EXISTS `v_mobil`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `v_mobil`  AS SELECT `mobil`.`nama_seri` AS `nama_seri`, `mobil`.`nama_brand` AS `nama_brand`, `mobil`.`type` AS `type`, `mobil`.`harga` AS `harga` FROM `mobil` ;

-- --------------------------------------------------------

--
-- Structure for view `v_mobil_suv`
--
DROP TABLE IF EXISTS `v_mobil_suv`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `v_mobil_suv`  AS SELECT `v_mobil`.`nama_seri` AS `nama_seri`, `v_mobil`.`nama_brand` AS `nama_brand`, `v_mobil`.`type` AS `type`, `v_mobil`.`harga` AS `harga` FROM `v_mobil` WHERE `v_mobil`.`type` = 'SUV'WITH LOCAL CHECK OPTION  ;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `akun`
--
ALTER TABLE `akun`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `data_pengguna`
--
ALTER TABLE `data_pengguna`
  ADD PRIMARY KEY (`NIK`),
  ADD KEY `akun_id` (`akun_id`);

--
-- Indexes for table `driver`
--
ALTER TABLE `driver`
  ADD PRIMARY KEY (`driver_id`),
  ADD KEY `idx_driver` (`nama`,`driver_id`);

--
-- Indexes for table `driver_log`
--
ALTER TABLE `driver_log`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `event_perusahaan`
--
ALTER TABLE `event_perusahaan`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_Judul_id` (`judul`,`id`);

--
-- Indexes for table `mobil`
--
ALTER TABLE `mobil`
  ADD PRIMARY KEY (`id`),
  ADD KEY `nama_seri` (`nama_seri`,`id`);

--
-- Indexes for table `mobil_log`
--
ALTER TABLE `mobil_log`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `mobil_log_detail_edit`
--
ALTER TABLE `mobil_log_detail_edit`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `transaksi`
--
ALTER TABLE `transaksi`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`),
  ADD KEY `car_id` (`car_id`),
  ADD KEY `transaksi_ibfk_3` (`driver_id`);

--
-- Indexes for table `wishlist`
--
ALTER TABLE `wishlist`
  ADD PRIMARY KEY (`id`),
  ADD KEY `car` (`car_id`),
  ADD KEY `akun` (`user_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `akun`
--
ALTER TABLE `akun`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT for table `driver`
--
ALTER TABLE `driver`
  MODIFY `driver_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT for table `driver_log`
--
ALTER TABLE `driver_log`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `event_perusahaan`
--
ALTER TABLE `event_perusahaan`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `mobil`
--
ALTER TABLE `mobil`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- AUTO_INCREMENT for table `mobil_log`
--
ALTER TABLE `mobil_log`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=21;

--
-- AUTO_INCREMENT for table `mobil_log_detail_edit`
--
ALTER TABLE `mobil_log_detail_edit`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `transaksi`
--
ALTER TABLE `transaksi`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `wishlist`
--
ALTER TABLE `wishlist`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `data_pengguna`
--
ALTER TABLE `data_pengguna`
  ADD CONSTRAINT `data_pengguna_ibfk_1` FOREIGN KEY (`akun_id`) REFERENCES `akun` (`id`);

--
-- Constraints for table `transaksi`
--
ALTER TABLE `transaksi`
  ADD CONSTRAINT `transaksi_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `akun` (`id`),
  ADD CONSTRAINT `transaksi_ibfk_2` FOREIGN KEY (`car_id`) REFERENCES `mobil` (`id`),
  ADD CONSTRAINT `transaksi_ibfk_3` FOREIGN KEY (`driver_id`) REFERENCES `driver` (`driver_id`);

--
-- Constraints for table `wishlist`
--
ALTER TABLE `wishlist`
  ADD CONSTRAINT `akun` FOREIGN KEY (`user_id`) REFERENCES `akun` (`id`),
  ADD CONSTRAINT `car` FOREIGN KEY (`car_id`) REFERENCES `mobil` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
