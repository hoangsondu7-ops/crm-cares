# CRM Care — Hệ thống CRM chăm sóc khách hàng

Dự án mẫu hoàn chỉnh theo đề **Hệ thống CRM Chăm sóc Khách hàng**. Stack sử dụng Node.js + Express, PostgreSQL, pgAdmin, Nginx reverse proxy, Prometheus, Grafana, Loki và Promtail.

## 1. Chức năng

- **Khách hàng:** thêm, xem, tìm kiếm, sửa, xóa; lưu công ty, email, điện thoại, ghi chú và trạng thái (tiềm năng/đang hoạt động/ngừng hoạt động).
- **Liên hệ:** quản lý người phụ trách, chức vụ, email, điện thoại; liên kết với khách hàng.
- **Lịch sử tương tác:** ghi nhận cuộc gọi, email, cuộc họp hoặc ghi chú, thời gian, người liên hệ, tóm tắt và chi tiết.
- **Đăng nhập:** JWT có thời hạn 4 giờ; giới hạn 10 lần đăng nhập trong 15 phút.
- **Quan sát hệ thống:** endpoint `/metrics` cho Prometheus; Grafana được cấu hình sẵn dashboard; Winston ghi log JSON và Promtail chuyển log tới Loki.
- **Cơ sở dữ liệu:** PostgreSQL với ràng buộc khóa ngoại, trạng thái hợp lệ và chỉ mục tìm kiếm; pgAdmin dùng để quản trị DB.
- **Triển khai:** Docker Compose, Nginx reverse proxy, health check và GitHub Actions CI.

## 2. Yêu cầu

Cài **Docker Desktop** (Windows/macOS) hoặc Docker Engine + Docker Compose v2 (Linux). Chạy lệnh từ thư mục chứa `docker-compose.yml`. Không cần cài Node.js hoặc PostgreSQL riêng khi chạy bằng Docker.

## 3. Cài đặt và chạy local

1. Giải nén ZIP và mở terminal tại thư mục `crm-customer-care`.
2. Tạo file môi trường:
   - Windows PowerShell: `Copy-Item .env.example .env`
   - macOS/Linux: `cp .env.example .env`
3. Mở `.env` và đổi các mật khẩu. Với môi trường local, có thể giữ `NODE_ENV=development`; trước khi triển khai thật, đổi `NODE_ENV=production`, đặt `JWT_SECRET` ngẫu nhiên dài ít nhất 32 ký tự và đặt lại mọi mật khẩu mẫu.
4. Khởi động toàn bộ stack:

   ```bash
   docker compose up -d --build
   ```

5. Xem trạng thái và log:

   ```bash
   docker compose ps
   docker compose logs -f app
   ```

6. Mở các địa chỉ trên cùng máy:

   | Dịch vụ | Địa chỉ local | Ghi chú |
   |---|---|---|
   | CRM Care (kết nối trực tiếp app) | http://localhost:3000 | Giao diện quản lý; chỉ truy cập trên máy local |
   | CRM Care (qua Nginx) | http://localhost:8081 | Giao diện qua reverse proxy |
   | pgAdmin | http://localhost:5050 | Quản trị PostgreSQL |
   | Prometheus | http://localhost:9091 | Truy vấn metrics |
   | Grafana | http://localhost:3001 | Dashboard vận hành |
   | Loki | Không public port | Truy cập qua datasource Grafana |

   Các cổng có thể đổi trong `.env` (`APP_PORT`, `PGADMIN_PORT`, `PROMETHEUS_PORT`, `GRAFANA_PORT`). Các cổng quản trị được bind vào `127.0.0.1` để tránh công khai trên mạng.

## 4. Tài khoản mặc định khi chưa chỉnh `.env`

Nếu chạy trực tiếp mà **chưa tạo file `.env`**, giá trị mặc định của ứng dụng là:

- CRM: `admin` / `Admin123!`
- pgAdmin: `admin@example.com` / `ChangeThis_pgAdmin_Password`
- Grafana: `admin` / `ChangeThis_Grafana_Password`
- PostgreSQL: database `crmdb`, user `crmuser`, password `ChangeThis_DB_Password_2026`

Đây chỉ là thông tin tiện chạy thử local, **không dùng các mật khẩu này trên hệ thống thật**. Nếu bạn đã sao chép `.env.example` thành `.env`, tài khoản CRM mặc định trong file mẫu là `admin` / `ChangeThis_CRM_Password`; hãy xem các biến `CRM_ADMIN_USER` và `CRM_ADMIN_PASSWORD` nếu đã chỉnh. Các mật khẩu pgAdmin, Grafana và PostgreSQL cũng lấy từ `.env`. Không gửi hoặc commit file `.env` lên GitHub.

### Kết nối PostgreSQL từ pgAdmin

Trong pgAdmin, tạo server mới với:

- **Name:** CRM Local
- **Host name/address:** `db`
- **Port:** `5432`
- **Maintenance database:** giá trị `POSTGRES_DB` (mặc định `crmdb`)
- **Username:** giá trị `POSTGRES_USER` (mặc định `crmuser`)
- **Password:** giá trị `POSTGRES_PASSWORD` trong `.env`

Tên host `db` chỉ dùng trong mạng Docker Compose. Từ ứng dụng quản lý DB trên máy host, không có cổng PostgreSQL public được mở mặc định.

### Truy vấn log Loki

Trong Grafana, mở **Explore**, chọn datasource **Loki** rồi chạy các truy vấn LogQL:

**1. Tìm log HTTP có mã trạng thái 5xx từ Nginx**

```logql
{job="crm-backend"} |~ "(?i)(ERROR|Exception|Failed)"
```

**2. Tìm log lỗi ứng dụng**

```logql
{job="crm-backend", level="error"}
```

Các truy vấn này yêu cầu log được gắn nhãn `job="nginx"` và `job="webapp"`. Cấu hình Promtail hiện tại của dự án chỉ thu thập log backend với nhãn `job="crm-backend"`; để truy vấn log hiện có, dùng `{job="crm-backend"} |~ "(?i)(ERROR|Exception|Failed)"`. Nginx chưa được cấu hình để chuyển log vào Loki.

## 5. Dashboard và log

- Grafana tự provision datasource **Prometheus**, **Loki** và dashboard **CRM Care - Tổng quan vận hành**.
- Dashboard gồm lưu lượng HTTP, tỷ lệ lỗi 5xx, độ trễ p50/p95, bộ nhớ heap Node.js và log ứng dụng.
- Log JSON được ghi vào volume dùng chung giữa ứng dụng và Promtail. Promtail chuyển log tới Loki.
- Nếu dashboard chưa có dữ liệu ngay sau khi khởi động, chờ 30–60 giây rồi tải lại. Tạo một vài thao tác trong CRM để phát sinh metrics và log.
- Chạy `docker compose logs -f app promtail loki` để chẩn đoán nếu log không xuất hiện.

## 6. Bảo mật đã áp dụng

- Helmet security headers, CSP hạn chế script/style từ nguồn lạ, chống nhúng iframe.
- Nginx ẩn phiên bản, giới hạn kích thước request, timeout và giới hạn tốc độ.
- JWT cho các API nghiệp vụ; giới hạn thử đăng nhập và so sánh thông tin đăng nhập theo cách giảm rò rỉ thời gian.
- Kiểm tra dữ liệu ở server và truy vấn SQL có tham số; không nối chuỗi dữ liệu người dùng vào SQL.
- `express.json` giới hạn body 100 KB; rate limit cho thao tác ghi.
- Hạn chế công khai cổng database và công cụ giám sát; các cổng quản trị mặc định chỉ bind localhost.
- Container backend bỏ Linux capabilities không cần thiết, dùng `no-new-privileges`; ứng dụng chạy non-root và filesystem read-only, ngoại trừ volume log và `/tmp`.

**Lưu ý triển khai thực tế:** cấu hình Nginx đi kèm phục vụ HTTP cho demo local. Trước khi đưa ra Internet, cần đặt Nginx sau TLS/HTTPS (ví dụ load balancer hoặc reverse proxy có chứng thư), thay toàn bộ mật khẩu mẫu, dùng secret manager, đặt quy trình backup PostgreSQL và kiểm tra phân quyền người dùng. CRM hiện dùng một tài khoản quản trị chung trong biến môi trường, phù hợp bài tập/demo; hệ thống nhiều người dùng cần bảng tài khoản, mật khẩu băm, phân quyền và quản lý phiên riêng.

## 7. GitHub

1. Tạo repository GitHub mới.
2. Giải nén dự án và chạy `git init`, `git add .`, `git commit -m "Initial CRM Care project"`.
3. Thêm remote repo và `git push -u origin main`.
4. GitHub Actions tại `.github/workflows/ci.yml` tự kiểm tra cú pháp JS và build Docker image trên mỗi lần push/PR.

Không thêm `.env`, mật khẩu thật hay token vào repository. File `.gitignore` đã loại trừ `.env` và log runtime.

## 8. Một số lệnh hữu ích

```bash
# Kiểm tra dịch vụ

docker compose ps

# Theo dõi log toàn bộ stack

docker compose logs -f

# Dừng nhưng giữ dữ liệu

docker compose down

# Dựng lại backend sau khi sửa source

docker compose up -d --build app

# Xóa stack VÀ toàn bộ dữ liệu database/metrics/log đã lưu
# Chỉ chạy nếu chủ ý muốn bắt đầu lại từ đầu!
docker compose down -v
```

`db/init.sql` chỉ chạy tự động khi PostgreSQL khởi tạo volume dữ liệu lần đầu. Nếu sửa schema sau khi đã tạo volume, hãy dùng migration SQL mới hoặc thực hiện migration thủ công; không xóa volume đang chứa dữ liệu thật chỉ để chạy lại init script.

## 9. Cấu trúc thư mục

```text
crm-customer-care/
├── server.js                       # Express API, JWT, validation, metrics, logging
├── public/                         # Giao diện web CRM
├── db/init.sql                     # Schema, indexes, dữ liệu demo
├── nginx/default.conf              # Reverse proxy và hardening headers
├── prometheus/prometheus.yml       # Scrape cấu hình metrics
├── grafana/                        # Datasource provisioning + dashboard
├── loki/config.yml                 # Lưu trữ và truy vấn log
├── promtail/config.yml             # Đọc file log, chuyển vào Loki
├── docker-compose.yml              # Toàn bộ service và network
├── Dockerfile                      # Image Node.js non-root
├── API.md                          # API endpoint và payload
└── .github/workflows/ci.yml        # CI cho GitHub Actions
```
{job="crm-backend"} |~ "(?i)(ERROR|Exception|Failed)"{job="crm-backend"} |~ "(?i)(ERROR|Exception|Failed)"