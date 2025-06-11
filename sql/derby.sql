-- phpMyAdmin SQL Dump
-- version 4.6.6
-- https://www.phpmyadmin.net/
--
-- Anamakine: localhost
-- Üretim Zamanı: 02 Haz 2022, 22:25:33
-- Sunucu sürümü: 5.7.17-log
-- PHP Sürümü: 5.6.30

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Veritabanı: `derby`
--

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `oyuncular`
--

CREATE TABLE `oyuncular` (
  `id` int(11) NOT NULL,
  `AdminLevel` int(11) NOT NULL DEFAULT '0',
  `Nick` char(25) NOT NULL DEFAULT 'NULL',
  `Password` char(64) NOT NULL DEFAULT 'HASHLENMIS SIFRE GEREKIR',
  `Date` int(11) NOT NULL DEFAULT '1111111111',
  `Cash` int(11) NOT NULL DEFAULT '0',
  `ban` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dökümü yapılmış tablolar için indeksler
--

--
-- Tablo için indeksler `oyuncular`
--
ALTER TABLE `oyuncular`
  ADD PRIMARY KEY (`id`);

--
-- Dökümü yapılmış tablolar için AUTO_INCREMENT değeri
--

--
-- Tablo için AUTO_INCREMENT değeri `oyuncular`
--
ALTER TABLE `oyuncular`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;


-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `bans`
--

CREATE TABLE `bans` (
  `Ad` varchar(24) NOT NULL DEFAULT 'Yok',
  `IP` varchar(30) NOT NULL DEFAULT '0.0.0.0',
  `hddserial` varchar(75) NOT NULL,
  `BanlanmaTarihi` varchar(30) NOT NULL,
  `Banlayan` varchar(24) NOT NULL,
  `Sure` int(11) NOT NULL,
  `Sebep` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin5 COLLATE=latin5_turkish_ci ROW_FORMAT=DYNAMIC;

-- --------------------------------------------------------