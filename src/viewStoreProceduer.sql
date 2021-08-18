create database quanlykho;
use quanlykho;

create table vattu(
    vattu_id int not null auto_increment primary key ,
    ma_vattu varchar(50) not null ,
    ten_vattu varchar(50) not null ,
    dv_tinh varchar(50) not null ,
    gia_vattu double not null
);

create table tonkho(
    tonkho_id int not null auto_increment primary key ,
    vattu_id int,
    soluong_bandau int not null ,
    tong_soluong_nhap int not null ,
    tong_soluong_xuat int not null ,
    foreign key (vattu_id) references vattu (vattu_id)
);

create table nhacungcap(
    nhacungcap_id int not null auto_increment primary key ,
    ma_nhacungcap varchar(50) not null ,
    ten_nhacungcap varchar(50) not null ,
    diachi_nhacungcap varchar(255) not null ,
    sodienthoai int not null
);

create table dondathang(
    dondathang_id int not null auto_increment primary key ,
    nhacungcap_id int,
    ma_dondathang varchar(50) not null ,
    ngay_dathang datetime not null ,
    foreign key (nhacungcap_id) references nhacungcap(nhacungcap_id)
);

create table phieunhap(
    phieunhap_id int not null auto_increment primary key ,
    dondathang_id int,
    ma_phieunhap varchar(50) not null ,
    ngay_nhaphang datetime not null ,
    foreign key (dondathang_id) references dondathang(dondathang_id)
);

create table phieuxuat(
    phieuxuat_id int not null auto_increment primary key ,
    ma_phieuxuat varchar(50) not null ,
    ngay_xuathang datetime not null ,
    ten_khachhang varchar(50) not null
);

create table chitietdonhang(
    chitietdonhang_id int not null auto_increment primary key ,
    dondathang_id int,
    vattu_id int,
    soluong_dathang int not null ,
    foreign key (dondathang_id) references dondathang(dondathang_id),
    foreign key (vattu_id) references vattu(vattu_id)
);

create table chitietphieunhap(
    chitietphieunhap_id int not null auto_increment primary key ,
    phieunhap_id int,
    vattu_id int,
    soluong_nhaphang int not null ,
    dongia_nhaphang double not null ,
    ghichu_nhaphang varchar(255),
    foreign key (phieunhap_id) references phieunhap(phieunhap_id),
    foreign key (vattu_id) references  vattu(vattu_id)
);

create table chitietphieuxuat(
    chitietphieuxuat_id int not null auto_increment primary key ,
    phieuxuat_id int,
    vattu_id int,
    soluong_xuathang int not null ,
    dongia_xuathang double not null ,
    ghichu_xuathang varchar(255),
    foreign key (phieuxuat_id) references phieuxuat(phieuxuat_id),
    foreign key (vattu_id) references  vattu(vattu_id)
);

#Câu 1. Tạo view có tên vw_CTPNHAP bao gồm các thông tin sau:
# số phiếu nhập hàng, mã vật tư, số lượng nhập, đơn giá nhập, thành tiền nhập.

create view vw_CTPNHAP as select ma_phieunhap 'So phieu nhap hang', ma_vattu, soluong_nhaphang, dongia_nhaphang,
                                 sum(dongia_nhaphang*soluong_nhaphang)'Thanh Tien'
from chitietphieunhap join vattu v on v.vattu_id = chitietphieunhap.vattu_id
    join phieunhap p on p.phieunhap_id = chitietphieunhap.phieunhap_id group by chitietphieunhap_id;

#Câu 2. Tạo view có tên vw_CTPNHAP_VT bao gồm các thông tin sau:
# số phiếu nhập hàng, mã vật tư, tên vật tư, số lượng nhập, đơn giá nhập, thành tiền nhập.

create view vw_CTPNHAP_VT as select ma_phieunhap 'So phieu nhap hang', ma_vattu, ten_vattu, soluong_nhaphang, dongia_nhaphang,
sum(dongia_nhaphang*soluong_nhaphang)'Thanh Tien'from chitietphieunhap join vattu v on v.vattu_id = chitietphieunhap.vattu_id
    join phieunhap p on p.phieunhap_id = chitietphieunhap.phieunhap_id group by chitietphieunhap_id;

#Câu 3. Tạo view có tên vw_CTPNHAP_VT_PN bao gồm các thông tin sau:
# số phiếu nhập hàng, ngày nhập hàng, số đơn đặt hàng, mã vật tư, tên vật tư, số lượng nhập, đơn giá nhập, thành tiền nhập.

create view vw_CTPNHAP_VT_PN as select ma_phieunhap 'So phieu nhap hang', ngay_nhaphang, soluong_dathang, ma_vattu, soluong_nhaphang,
dongia_nhaphang, sum(dongia_nhaphang*soluong_nhaphang)'Thanh Tien' from chitietphieunhap
    join phieunhap p on p.phieunhap_id = chitietphieunhap.phieunhap_id join vattu v on v.vattu_id = chitietphieunhap.vattu_id
    join dondathang d on d.dondathang_id = p.dondathang_id join chitietdonhang c on chitietphieunhap.vattu_id = c.vattu_id
group by chitietphieunhap_id;

#Câu 4. Tạo view có tên vw_CTPNHAP_VT_PN_DH bao gồm các thông tin sau: số phiếu nhập hàng, ngày nhập hàng, số đơn đặt hàng,
# mã nhà cung cấp, mã vật tư, tên vật tư, số lượng nhập, đơn giá nhập, thành tiền nhập.

create view vw_CTPNHAP_VT_PN_DH as select ma_phieunhap 'So phieu nhap hang', ngay_nhaphang,soluong_dathang, ma_nhacungcap, ma_vattu, ten_vattu,
soluong_nhaphang, dongia_nhaphang, sum(dongia_nhaphang*soluong_nhaphang)'Thanh Tien' from chitietphieunhap
join phieunhap p on p.phieunhap_id = chitietphieunhap.phieunhap_id join dondathang d on d.dondathang_id = p.dondathang_id join vattu v on v.vattu_id = chitietphieunhap.vattu_id
join nhacungcap n on n.nhacungcap_id = d.nhacungcap_id join chitietdonhang c on chitietphieunhap.vattu_id = c.vattu_id group by chitietphieunhap_id;

#Câu 5. Tạo view có tên vw_CTPNHAP_loc  bao gồm các thông tin sau:
# số phiếu nhập hàng, mã vật tư, số lượng nhập, đơn giá nhập, thành tiền nhập. Và chỉ liệt kê các chi tiết nhập có số lượng nhập > 5.

create view vw_CTPNHAP_loc as select ma_phieunhap 'So phieu nhap hang', ma_vattu, soluong_nhaphang, dongia_nhaphang,
sum(dongia_nhaphang*soluong_nhaphang)'Thanh Tien' from chitietphieunhap join vattu v on v.vattu_id = chitietphieunhap.vattu_id
    join phieunhap p on p.phieunhap_id = chitietphieunhap.phieunhap_id join dondathang d on d.dondathang_id = p.dondathang_id
    join nhacungcap n on n.nhacungcap_id = d.nhacungcap_id group by chitietphieunhap_id having count(soluong_nhaphang) > 0;

#Câu 6. Tạo view có tên vw_CTPNHAP_VT_loc bao gồm các thông tin sau:
# số phiếu nhập hàng, mã vật tư, tên vật tư, số lượng nhập, đơn giá nhập, thành tiền nhập.
# Và chỉ liệt kê các chi tiết nhập vật tư có đơn vị tính là Bộ. (USD)

create view vw_CTPNHAP_VT_loc as select ma_phieunhap 'So phieu nhap hang', ma_vattu, ten_vattu, soluong_nhaphang, dongia_nhaphang,
sum(dongia_nhaphang*soluong_nhaphang)'Thanh Tien' from chitietphieunhap join phieunhap p on p.phieunhap_id = chitietphieunhap.phieunhap_id
join dondathang d on d.dondathang_id = p.dondathang_id join nhacungcap n on n.nhacungcap_id = d.nhacungcap_id join vattu v on v.vattu_id = chitietphieunhap.vattu_id
group by chitietphieunhap_id having count(dv_tinh) = 'USD';

#Câu 7. Tạo view có tên vw_CTPXUAT bao gồm các thông tin sau: số phiếu xuất hàng, mã vật tư, số lượng xuất, đơn giá xuất, thành tiền xuất.
create view vw_CTPXUAT as select ma_phieuxuat 'So phieu xuat hang', ma_vattu, soluong_xuathang, dongia_xuathang, sum(soluong_xuathang*dongia_xuathang) 'Thanh Tien'
from chitietphieuxuat join phieuxuat p on p.phieuxuat_id = chitietphieuxuat.phieuxuat_id join vattu v on v.vattu_id = chitietphieuxuat.vattu_id
group by chitietphieuxuat_id;

#Câu 8. Tạo view có tên vw_CTPXUAT_VT bao gồm các thông tin sau: số phiếu xuất hàng, mã vật tư, tên vật tư, số lượng xuất, đơn giá xuất.

create view vw_CTPXUAT_VT as select ma_phieuxuat 'So phieu xuat hang', ma_vattu, soluong_xuathang, dongia_xuathang from chitietphieuxuat
join vattu v on v.vattu_id = chitietphieuxuat.vattu_id join phieuxuat p on p.phieuxuat_id = chitietphieuxuat.phieuxuat_id
group by chitietphieuxuat_id;


#Câu 9. Tạo view có tên vw_CTPXUAT_VT_PX bao gồm các thông tin sau: số phiếu xuất hàng, tên khách hàng, mã vật tư, tên vật tư, số lượng xuất, đơn giá xuất

create view vw_CTPXUAT_VT_PX as select ma_phieuxuat 'So phieu xuat hang', ten_khachhang, ma_vattu, ten_vattu, soluong_xuathang, dongia_xuathang from chitietphieuxuat
join phieuxuat p on p.phieuxuat_id = chitietphieuxuat.phieuxuat_id join vattu v on v.vattu_id = chitietphieuxuat.vattu_id group by chitietphieuxuat_id;

#Tạo các stored procedure sau

#Câu 1. Tạo Stored procedure (SP) cho biết tổng số lượng cuối của vật tư với mã vật tư là tham số vào.

create procedure SP_mavattu (in ma_vattus varchar(50))
BEGIN
    select ma_vattu, tonkho.soluong_bandau + tong_soluong_nhap - tong_soluong_xuat as soluong_conlai
    from tonkho
             join vattu v on tonkho.vattu_id = v.vattu_id
    where ma_vattu = ma_vattus;
end;

call SP_mavattu('APP02');

#Câu 2. Tạo SP cho biết tổng tiền xuất của vật tư với mã vật tư là tham số vào.

create procedure TongTienXuat (in ma_vattu1 varchar(50))
BEGIN
    select ma_vattu, soluong_xuathang * gia_vattu, ngay_xuathang
        from chitietphieuxuat join vattu v on v.vattu_id = chitietphieuxuat.vattu_id
            join phieuxuat p on p.phieuxuat_id = chitietphieuxuat.phieuxuat_id
    where ma_vattu = ma_vattu1;
end;

call TongTienXuat('APP01');

#Câu 3. Tạo SP cho biết tổng số lượng đặt theo số đơn hàng với số đơn hàng là tham số vào.

#Câu 4. Tạo SP dùng để thêm một đơn đặt hàng.

#Câu 5. Tạo SP dùng để thêm một chi tiết đơn đặt hàng.
