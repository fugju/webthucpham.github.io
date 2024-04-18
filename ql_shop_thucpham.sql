-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Máy chủ: 127.0.0.1
-- Thời gian đã tạo: Th4 12, 2024 lúc 10:20 AM
-- Phiên bản máy phục vụ: 10.4.28-MariaDB
-- Phiên bản PHP: 8.2.4

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Cơ sở dữ liệu: `ql_shop_thucpham`
--

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `bill`
--

CREATE TABLE `bill` (
  `id` int(4) NOT NULL,
  `iduser` int(10) NOT NULL,
  `name` varchar(50) NOT NULL,
  `address` varchar(255) NOT NULL,
  `email` varchar(100) NOT NULL,
  `tel` int(11) NOT NULL,
  `pttt` tinyint(1) NOT NULL DEFAULT 1 COMMENT '1. Thanh toán trực tiếp 2.Chuyển khoản 3. Thanh toán online',
  `ngaydathang` datetime NOT NULL,
  `total` float(10,0) NOT NULL,
  `status` tinyint(4) NOT NULL DEFAULT 0 COMMENT '0. Đơn hàng mới 1. Đang xác nhận đơn hàng 2.Chờ giao hàng 3. Đã giao hàng',
  `receive_name` varchar(50) DEFAULT NULL,
  `receive_address` varchar(255) DEFAULT NULL,
  `receive_tel` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `danhmuc`
--

CREATE TABLE `danhmuc` (
  `id` int(4) NOT NULL,
  `tendanhmuc` varchar(50) NOT NULL,
  `home` tinyint(1) DEFAULT 0,
  `stt` tinyint(1) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Đang đổ dữ liệu cho bảng `danhmuc`
--

INSERT INTO `danhmuc` (`id`, `tendanhmuc`, `home`, `stt`) VALUES
(1, 'Thực phẩm nông sản', 0, 1),
(2, 'Thực phẩm tươi sống', 0, 2),
(3, 'Thực phẩm đóng hộp', 0, 3),
(4, 'Thực phẩm khô', 0, 4),
(5, 'Hàng nhập khẩu', 0, 5),
(6, 'Gia vị', 0, 6),
(7, 'Nước giải khác', 0, 7),
(8, 'Sữa', 0, 8);

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `donhang`
--

CREATE TABLE `donhang` (
  `id` int(4) NOT NULL,
  `iduser` int(4) NOT NULL,
  `idsanpham` int(4) NOT NULL,
  `img` varchar(500) DEFAULT NULL,
  `name` varchar(50) DEFAULT NULL,
  `price` double(10,0) NOT NULL DEFAULT 0,
  `soluong` int(10) NOT NULL,
  `thanhtien` int(10) NOT NULL,
  `idbill` int(4) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `nguon_goc`
--

CREATE TABLE `nguon_goc` (
  `id` int(4) NOT NULL,
  `mota` varchar(500) NOT NULL,
  `muavu` varchar(50) NOT NULL,
  `luuy` varchar(500) NOT NULL,
  `hansudung` varchar(50) NOT NULL,
  `huongdansudung` varchar(500) NOT NULL,
  `huongdanbaoquan` varchar(500) NOT NULL,
  `giaohang` varchar(100) NOT NULL,
  `iddm` int(4) NOT NULL,
  `idsanpham` int(4) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `sanpham`
--

CREATE TABLE `sanpham` (
  `id` int(10) NOT NULL,
  `iddm` int(4) NOT NULL,
  `tensanpham` varchar(255) NOT NULL,
  `img` varchar(500) NOT NULL,
  `gia` double(10,0) NOT NULL,
  `giakhuyenmai` double(10,0) DEFAULT NULL,
  `sanphamkhuyenmai` tinyint(1) NOT NULL DEFAULT 0 COMMENT '	0. sản phẩm không khuyến mãi 1. sản phẩm khuyến mãi	',
  `bestseller` tinyint(1) NOT NULL DEFAULT 0,
  `daban` int(10) NOT NULL DEFAULT 0,
  `view` int(10) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Đang đổ dữ liệu cho bảng `sanpham`
--

INSERT INTO `sanpham` (`id`, `iddm`, `tensanpham`, `img`, `gia`, `giakhuyenmai`, `sanphamkhuyenmai`, `bestseller`, `daban`, `view`) VALUES
(1, 1, 'Rau Muống', '../uploads/rau_muong.jpg', 15000, 13500, 0, 0, 500, 100),
(2, 1, 'Rau Thơm - Ngò Rí', '../uploads/rau_mui.jpg', 5000, NULL, 0, 0, 350, 50),
(3, 1, 'Rau Xà Lách', '../uploads/rau_xalach.png', 13000, 11500, 0, 0, 550, 200),
(4, 1, 'Rau Mồng Tơi', '../uploads/rau_mongtoi.jpeg', 8000, 5500, 1, 0, 350, 250),
(5, 2, 'Tôm Càng Xanh', '../uploads/haisan_tomcangxanh.jpg', 250000, 235000, 1, 1, 12000, 1000),
(6, 3, 'Cá Ngừ Ngâm Dầu', '../uploads/donghop_cangungamdau.jpg', 40000, 37000, 1, 1, 600, 800),
(18, 1, 'Bông hẹ', '../uploads/rau_bonghe.jpg', 18000, 15500, 1, 0, 0, 0),
(19, 1, 'Cải Bẹ ', '../uploads/rau_caibe.jpg', 9000, 0, 0, 0, 0, 0),
(20, 1, 'Cải Bẹ Xanh', '../uploads/rau_caibexanh.jpg', 15700, 0, 0, 0, 0, 0),
(21, 7, 'Bia Tiger Lon', '../uploads/bia_tiger.jpg', 32000, 30700, 1, 1, 0, 0),
(22, 7, '7 Up Chai', '../uploads/7up.jpg', 12000, 11000, 1, 0, 0, 0),
(23, 5, 'Nho Xanh Nhập Khẩu', '../uploads/nhoxanh.jpg', 190000, 185000, 1, 0, 0, 0),
(24, 1, 'Cải Ngọt', '../uploads/rau_caingot.jpg', 13000, 0, 0, 0, 0, 0),
(25, 1, 'Cải Thìa', '../uploads/rau_caithia.jpg', 7000, 0, 0, 0, 0, 0),
(26, 1, 'Cần Nước', '../uploads/rau_cannuoc.jpg', 7600, 0, 0, 0, 0, 0),
(27, 1, 'Rau Đắng', '../uploads/rau_dang.jpg', 8500, 0, 0, 0, 0, 0),
(28, 1, 'Rau Dền', '../uploads/rau_den.jpg', 11300, 0, 0, 0, 0, 0),
(29, 1, 'Giá Sống', '../uploads/rau_giasong.jpg', 5500, 0, 0, 0, 0, 0),
(30, 1, 'Hành Lá', '../uploads/rau_hanhla.jpg', 13000, 0, 0, 0, 0, 0),
(31, 1, 'Rau Húng Cây', '../uploads/rau_hungcay.jpg', 22000, 0, 0, 0, 0, 0),
(32, 1, 'Lá Dứa', '../uploads/rau_ladua.jpg', 30000, 0, 0, 0, 0, 0),
(33, 1, 'Lá Giang', '../uploads/rau_lagiang.jpg', 24500, 0, 0, 0, 0, 0),
(34, 1, 'Rau Lang', '../uploads/rau_lang.jpg', 32300, 0, 0, 0, 0, 0),
(35, 1, 'Rau Má', '../uploads/rau_ma.jpg', 16700, 0, 0, 0, 0, 0),
(36, 1, 'Nấm Đùi Gà', '../uploads/rau_namduiga.jpg', 42000, 0, 0, 0, 0, 0),
(37, 1, 'Ngò Rí', '../uploads/rau_ngori.jpg', 16000, 0, 0, 0, 0, 0),
(38, 1, 'Rau Ngót', '../uploads/rau_ngot.jpg', 13500, 0, 0, 0, 0, 0),
(39, 1, 'Rau Nhiếp Cá', '../uploads/rau_nhiepca.jpg', 32000, 0, 0, 0, 0, 0),
(40, 1, 'Rau Răm', '../uploads/rau_ram.jpg', 14200, 0, 0, 0, 0, 0),
(41, 1, 'Rau Thơm Các Loại', '../uploads/rau_thomcacloai.jpg', 8000, 0, 0, 0, 0, 0),
(42, 1, 'Xà Lách Búp Mỹ', '../uploads/rau_xalach_bupmo.jpg', 27500, 0, 0, 0, 0, 0),
(43, 1, 'Xà Lách Lô Tô', '../uploads/rau_xalach_loto.jpg', 26000, 0, 0, 0, 0, 0),
(44, 1, 'Xà Lách Thủy Tin', '../uploads/rau_xalachthuytinh.jpg', 34000, 0, 0, 0, 0, 0),
(45, 2, 'Cá Bạc Má', '../uploads/haisan_cabacma.jpg', 130000, 0, 0, 0, 0, 0),
(46, 2, 'Cá Bống', '../uploads/haisan_cabong.jpg', 190000, 0, 0, 0, 0, 0),
(47, 2, 'Cá Bớp', '../uploads/haisan_cabop.jpg', 330000, 0, 0, 0, 0, 0);

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `user`
--

CREATE TABLE `user` (
  `id` int(4) NOT NULL,
  `name` varchar(50) DEFAULT NULL,
  `address` varchar(255) DEFAULT NULL,
  `email` varchar(50) DEFAULT NULL,
  `tel` varchar(11) DEFAULT NULL,
  `tendangnhap` varchar(20) NOT NULL,
  `pass` varchar(35) NOT NULL,
  `role` tinyint(1) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Đang đổ dữ liệu cho bảng `user`
--

INSERT INTO `user` (`id`, `name`, `address`, `email`, `tel`, `tendangnhap`, `pass`, `role`) VALUES
(1, 'admin', 'Hồ Chí Minh', 'admin@gmail.com', '999888777', 'admin', 'c4055e3a20b6b3af3d10590ea446ef6c', 1),
(2, 'user', 'Đà Nẵng', 'user@gmail.com', '666555444', 'user', 'c4055e3a20b6b3af3d10590ea446ef6c', 0),
(12, '', '', '', NULL, 'test', 'dcddb75469b4b4875094e14561e573d8', 0);

--
-- Chỉ mục cho các bảng đã đổ
--

--
-- Chỉ mục cho bảng `bill`
--
ALTER TABLE `bill`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_bill_user` (`iduser`);

--
-- Chỉ mục cho bảng `danhmuc`
--
ALTER TABLE `danhmuc`
  ADD PRIMARY KEY (`id`);

--
-- Chỉ mục cho bảng `donhang`
--
ALTER TABLE `donhang`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_donhang_user` (`iduser`),
  ADD KEY `fk_donhang_bill` (`idbill`),
  ADD KEY `fk_donhang_sanpham` (`idsanpham`);

--
-- Chỉ mục cho bảng `nguon_goc`
--
ALTER TABLE `nguon_goc`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_sanpham_nguongoc` (`idsanpham`),
  ADD KEY `fk_nguongoc_danhmuc` (`iddm`);

--
-- Chỉ mục cho bảng `sanpham`
--
ALTER TABLE `sanpham`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_sanpham_danhmuc` (`iddm`);

--
-- Chỉ mục cho bảng `user`
--
ALTER TABLE `user`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT cho các bảng đã đổ
--

--
-- AUTO_INCREMENT cho bảng `bill`
--
ALTER TABLE `bill`
  MODIFY `id` int(4) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=59;

--
-- AUTO_INCREMENT cho bảng `danhmuc`
--
ALTER TABLE `danhmuc`
  MODIFY `id` int(4) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=15;

--
-- AUTO_INCREMENT cho bảng `donhang`
--
ALTER TABLE `donhang`
  MODIFY `id` int(4) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=57;

--
-- AUTO_INCREMENT cho bảng `nguon_goc`
--
ALTER TABLE `nguon_goc`
  MODIFY `id` int(4) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT cho bảng `sanpham`
--
ALTER TABLE `sanpham`
  MODIFY `id` int(10) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=48;

--
-- AUTO_INCREMENT cho bảng `user`
--
ALTER TABLE `user`
  MODIFY `id` int(4) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- Các ràng buộc cho các bảng đã đổ
--

--
-- Các ràng buộc cho bảng `bill`
--
ALTER TABLE `bill`
  ADD CONSTRAINT `fk_bill_user` FOREIGN KEY (`iduser`) REFERENCES `user` (`id`);

--
-- Các ràng buộc cho bảng `donhang`
--
ALTER TABLE `donhang`
  ADD CONSTRAINT `fk_donhang_bill` FOREIGN KEY (`idbill`) REFERENCES `bill` (`id`),
  ADD CONSTRAINT `fk_donhang_sanpham` FOREIGN KEY (`idsanpham`) REFERENCES `sanpham` (`id`),
  ADD CONSTRAINT `fk_donhang_user` FOREIGN KEY (`iduser`) REFERENCES `user` (`id`);

--
-- Các ràng buộc cho bảng `nguon_goc`
--
ALTER TABLE `nguon_goc`
  ADD CONSTRAINT `fk_nguongoc_danhmuc` FOREIGN KEY (`iddm`) REFERENCES `danhmuc` (`id`),
  ADD CONSTRAINT `fk_sanpham_nguongoc` FOREIGN KEY (`idsanpham`) REFERENCES `nguon_goc` (`id`);

--
-- Các ràng buộc cho bảng `sanpham`
--
ALTER TABLE `sanpham`
  ADD CONSTRAINT `fk_sanpham_danhmuc` FOREIGN KEY (`iddm`) REFERENCES `danhmuc` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
