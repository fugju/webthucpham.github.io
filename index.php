<?php 
    
    session_start();

    if (!isset($_SESSION['mycart'])) {
        $_SESSION['mycart'] = [];
    }

    //nếu nút đăng xuất đc bấmn
    if (isset($_GET['logged_out'])) {
        // Hủy phiên đăng nhập
        session_destroy();
    
        // Chuyển hướng về trang index.php
        header("Location: index.php");
        exit();
    }
    
    include "model/pdo.php";
    include "model/sanpham.php";
    include "model/danhmuc.php";
    include "model/donhang.php";
    include "model/user.php";
    include "model/global.php";


    include("view/header.php");

    //danh mục
    $dssm = danhmuc_select_all();

    //sản phẩm 
    $dssp = get_dssp_all(25); // giá trị truyền vào là số lượng sp show ra 
    $dssp_new = get_dssp_new(6); 
    $dssp_best = get_dssp_best(6);
    $dssp_km = get_dssp_km(6);
    $dssp_view = get_dssp_view();


    $thongbao = "";  // Thông báo đăng ký
    $errors = array();  // Mảng chứa thông báo lỗi

    if(isset($_GET['act']) && ($_GET['act'] !="" )){
        $act = $_GET['act'];
        switch ($act) {

            case 'sanpham':
                if (isset($_POST['kyw']) && ($_POST['kyw'] != "")) {
                    $kyw = $_POST["kyw"];
                    // Sử dụng hàm sanpham_select_keyword để lấy sản phẩm theo từ khóa tìm kiếm
                    $dssp = sanpham_select_keyword($kyw);
                } else {
                    $kyw = "";
            
                    if (isset($_GET['id_danhmuc']) && is_numeric($_GET['id_danhmuc']) && ($_GET['id_danhmuc'] > 0)) {
                        $id_danhmuc = $_GET['id_danhmuc'];
                        // Sử dụng hàm sanpham_select_by_danhmuc để lấy sản phẩm theo id_danhmuc
                        $dssp = sanpham_select_by_danhmuc($id_danhmuc);
                    } else {
                        $id_danhmuc = 0;
                        // Nếu không có id_danhmuc được cung cấp, lấy tất cả sản phẩm
                        $dssp = get_dssp_all(30);
                    }
                }
            
                include "view/sanpham/sanpham.php";
                break;
                   
            case 'chitietsanpham':
                if(isset($_GET['id']) && ($_GET['id'] > 0)){
                    $id = $_GET['id'];
                    $dssp_one = sanpham_select_by_id($id);
                    // Kiểm tra xem có thông tin chi tiết sản phẩm hay khôông
                    if(isset($dssp_one[0]['iddm'])){
                        $iddm = $dssp_one[0]['iddm'];
                        $sp_cung_loai = sanpham_select_cungloai($id, $iddm);
                        include "view/sanpham/chitietsanpham.php";
                    } else {
                        // Hiển thị thông báo lỗi và thông tin debug
                        echo "Không tìm thấy thông tin chi tiết sản phẩm.";
                        var_dump($dssp_one); // In thông tin chi tiết sản phẩm để kiểm tra
                    }
                }else{
                    include("view/home.php");
                }
                break;

            case 'viewcart':
                include "view/cart/viewcart.php";
                break;

            case 'addtocart':
                if ($_SERVER['REQUEST_METHOD'] === 'POST') {
                    // Lấy giá trị từ mảng POST hoặc sử dụng giá trị mặc định là rỗng
                    $id = $_POST['id'] ?? '';
                    $tensanpham = $_POST['tensanpham'] ?? '';
                    $img = $_POST['img'] ?? '';
                    $giamoi = $_POST['giamoi'] ?? '';
                    $gia = $_POST['gia'] ?? ''; 
                    $soluong = $_POST['soluong'] ?? 1;
                    $sanphamkhuyenmai = $_POST['sanphamkhuyenmai'] ?? 0;
                    
                    // Kiểm tra nếu sản phẩm có khuyến mãi, thì sử dụng giá khuyến mãi, ngược lại sử dụng giá gốc
                    $gia_sanpham = ($sanphamkhuyenmai == 1) ? $giamoi : $gia;
                    
                    // Tính giá trị của biến thanhtien
                    $thanhtien = $soluong * $gia_sanpham;
                    
                    // Kiểm tra nếu giỏ hàng chưa được khởi tạo, thì khởi tạo nó là một mảng rỗng
                    if (!isset($_SESSION['mycart'])) {
                        $_SESSION['mycart'] = array();
                    }
            
                    //kiểm tra sản phẩm có tồn tại trong giỏ hàng chưa 
                    $fg = 0;
                    $i = 0;
                    foreach ($_SESSION['mycart'] as $item) {
                        if ($item['1'] === $tensanpham) {
                            $_SESSION['mycart'][$i][4] += $soluong; // Tăng số lượng
                            $_SESSION['mycart'][$i][5] += $thanhtien; // Cập nhật thành tiền
                            $fg = 1;
                            break;
                        }
                        $i++;
                    }
            
                    // Nếu sản phẩm chưa tồn tại trong giỏ hàng, thêm mới
                    if ($fg == 0) {
                        $spadd = [$id, $tensanpham, $img, $gia_sanpham, $soluong, $thanhtien];
                        array_push($_SESSION['mycart'], $spadd);
                    }
                    header("Location: index.php?act=viewcart");
                    exit();
                }
                //include "view/cart/viewcart.php";
                break;
            /* ----------------------------------- NEW ---------------------------------- */
            case 'updateCart':
                $id = $_GET["id"] ?? "";
                $ctrl = $_GET["ctrl"] ?? "";
                if(!empty($id) && !empty($ctrl)){
                    if(updateCartQuantity($id, $ctrl)){
                        header("Location: index.php?act=viewcart");
                    }
                }
                break;
            /* ----------------------------------- NEW ---------------------------------- */
            case 'delcart':
                if (isset($_GET['idcart'])) {
                    $idToDelete = $_GET['idcart'];
                    // Sử dụng unset để xóa phần tử tại vị trí cụ thể trong mảng
                    unset($_SESSION['mycart'][$idToDelete]);
                    // Sau đó, tái sắp xếp lại các chỉ số của mảng
                    $_SESSION['mycart'] = array_values($_SESSION['mycart']);
                } else {
                    // Nếu không có idcart, xóa toàn bộ giỏ hàng
                    $_SESSION['mycart'] = [];
                }
            
                header('location: index.php?act=viewcart');
                exit(); // Đảm bảo kết thúc việc thực thi sau khi chuyển hướng
                break;

            case 'bill':
                // Kiểm tra xem người dùng đã login chưa
                if (!isset($_SESSION['s_user'])) {
                    // Redirect or show a message to prompt the user to log in
                    header('location: index.php?act=dangnhap');
                    exit();
                }
                if (!isset($_SESSION['mycart']) || empty($_SESSION['mycart'])) {
                    echo "Không có sản phẩm trong giỏ hàng. Vui lòng thêm sản phẩm trước khi thanh toán.";
                } 
                // else {
                //     // Nếu có sản phẩm trong giỏ hàng, chuyển hướng đến trang thanh toán
                //     header("Location: index.php?act=bill");
                //     exit();
                // }
                include "view/cart/bill.php";
                break;
        

            case 'billcomfirm':
                if(isset($_POST['dongydathang']) && ($_POST['dongydathang'])){
                    if(isset($_SESSION['s_user'])) $iduser = $_SESSION['s_user']['id'];
                    else $id = 0;
                    $name = $_POST['name'];
                    $address = $_POST['address'];
                    $tel = $_POST['tel'];
                    $email = $_POST['email'];
                    $pttt = $_POST['pttt'];
                    // $ngaydathang = date('Y-m-d H:i:s');
                    // Kiểm tra nếu ngày đặt hàng đã được cập nhật từ trước
                    if (!isset($bill[0]['ngaydathang'])) {
                        // Lấy thời gian hiện tại
                        $current_time = new DateTime('now', new DateTimeZone('Asia/Ho_Chi_Minh'));
                        $current_formatted_time = $current_time->format('Y-m-d H:i:s');

                        // Cập nhật giá trị "ngaydathang" trong mảng $bill
                        $bill[0]['ngaydathang'] = $current_formatted_time;
                    }

                    $ngaydathang = $bill[0]['ngaydathang'];
                    $tongdonhang = tongdonhang();
                    $status = 0;

                    $idbill = bill_insert($iduser, $name, $address, $email, $tel, $pttt, $ngaydathang, $tongdonhang, $status);

                    foreach ($_SESSION['mycart'] as $cart) {
                        donhang_insert($_SESSION['s_user']['id'], $cart[0], $cart[2], $cart[1], $cart[3], $cart[4], $cart[5], $idbill);
                    }

                    $_SESSION['mycart'] = [];
                }
                
                $bill = loadOne_bill($idbill);
                $billct = loadAll_cart($idbill);
                
                // include "view/cart/billcomfirm.php";
                 include "view/cart/billcomfirm.php";

                echo '<script>
                        if (performance.navigation.type === 1) {
                            window.location.href = "index.php";
                        }
                    </script>';
                
                break;
                                                
            case 'mybill':
                $listbill = getOrderByUser($_SESSION['s_user']['id']);
                include "view/cart/mybill.php";
                break;


            case 'dangnhap':
                if(isset($_POST['dangnhap']) && ($_POST['dangnhap'])){
                    $name = "";
                    $address = "";
                    $email = "";
                    $tendangnhap = $_POST['tendangnhap'];
                    $pass = $_POST['password'];
                    $passHash = md5($pass);
                    $checktendangnhap = checkuser($tendangnhap, $passHash);
                    
                    if(is_array($checktendangnhap) > 0){
                        $_SESSION['s_user'] = $checktendangnhap;
                        // if($checktendangnhap['role'] == 1){
                        //     header('location: index.php');
                        // } else {
                        //     header('location: index.php');
                        // }
                        header('location: index.php');
                        exit();
                    }
                    else{
                        $thongbao = "Tài khoản không tồn tại hoặc thông tin đăng nhập sai!";
                        $_SESSION["tb_dangnhap"] = $thongbao;
                        header('location: index.php?act=dangnhap');
                    }
                }
                
                include "view/taikhoan/login.php";
                break;
                

            case 'dangky':
                $thongbao = "";
                if(isset($_POST['dangky']) && ($_POST['dangky'])){
                    $name = "";
                    $address = "";
                    $email = "";
                    $tendangnhap = $_POST['tendangnhap'];
                    $pass = $_POST['password'];
                    $passHash = md5($pass);
                    $confirm_password = $_POST['confirm_password'];
                    // Kiểm tra trường Tên đăng nhập
                    if (empty($tendangnhap)) {
                        $errors[] = "Vui lòng nhập Tên đăng nhập.";
                    }

                    // Kiểm tra xem tendangnhap đã tồn tại hay chưa
                    if (isTendangnhapExists($tendangnhap)) {
                        $errors[] = "Tên đăng nhập đã được sử dụng.";
                    }
                    
                    // Kiểm tra trường Mật khẩu
                    if (empty($pass)) {
                        $errors[] = "Vui lòng nhập Mật khẩu.";
                    }

                    // Kiểm tra trường Nhập lại mật khẩu
                    if (empty($confirm_password)) {
                        $errors[] = "Vui lòng nhập lại Mật khẩu.";
                    }

                    // Kiểm tra mật khẩu và nhập lại mật khẩu có khớp nhau không
                    if ($pass != $confirm_password) {
                        $errors[] = "Mật khẩu và Nhập lại mật khẩu không khớp.";
                    }
    
                    // Nếu không có lỗi, thêm vào CSDL
                    if (empty($errors)) {
                        user_insert($name, $address, $email, $tendangnhap, $passHash);

                        // Chuyển hướng đến trang login.php
                        header("Location: index.php?act=dangnhap");
                        exit(); 
                    }
                }
                include "view/taikhoan/register.php";
                break;

            case 'capnhatthongtintaikhoan':
                if(isset($_POST['capnhat']) && ($_POST['capnhat'])){
                    $id = $_POST['id'];
                    $name = $_POST['name'];
                    $email = $_POST['email'];
                    $address = $_POST['address'];
                    $tel = $_POST['tel'];
                    $role = 0;
                    user_update($name, $address, $email, $tel, $role, $id);

                    //Cập nhật dữ liệu lại cho $_SESSION['s_user']
                    $_SESSION['s_user']['name'] = $name;
                    $_SESSION['s_user']['address'] = $address;
                    $_SESSION['s_user']['email'] = $email;
                    $_SESSION['s_user']['tel'] = $tel;

                    include "view/taikhoan/thongtintaikhoan_confrim.php";
                }  
                break;

            case 'sanphamgiamgia':
                include "view/sanpham/sanphamgiamgia.php";
                break;


            case 'quantri':
                header('Location: quantri/index.php');
                // header('Location: admin/index.php');
                break;

            case 'thongtintaikhoan':
                if(isset($_SESSION['s_user']) && ($_SESSION['s_user'] > 0)){
                    include "view/taikhoan/thongtintaikhoan.php";
                }
                break;
            
            case 'quenmatkhau':
                if(isset($_SESSION['s_user']) && ($_SESSION['s_user'] > 0)){
                    include "view/taikhoan/doimatkhau.php";
                }
                break;

            case 'laymatkhau':
                if(isset($_SESSION['s_user']) && ($_SESSION['s_user'] > 0)){
                    include "view/taikhoan/doimatkhau_confrim.php";
                }
                break;

            case 'trolai':
                if(isset($_POST['trolai']) && ($_POST['trolai'])){
                    include "index.php";
                    break;
                }

            case 'thoat':
                if(isset($_SESSION['s_user']) && ($_SESSION['s_user'] > 0)){
                    unset($_SESSION['s_user']);
                }
                header('Location: index.php');
                break;
            
            case 'lienhe':
                // header('Location: view/lienhe/send_email.php');
                include("view/lienhe/send_email.php");
                break;
            

            default:
                include("view/home.php");
                break;

        }

    }else {
        include("view/home.php");
    }


    include("view/footer.php");

?>