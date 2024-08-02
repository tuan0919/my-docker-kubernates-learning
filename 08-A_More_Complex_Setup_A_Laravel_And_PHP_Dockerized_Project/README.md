# Ghi chú cho bản thân

## Mục tiêu của section:

Mục tiêu của section này sẽ tập trung xây dựng một ứng dụng Laravel cần setup một cách phức tạp mà **không cần phải cài bất kì môi trường gì thêm trên host machine**.

## Ý tưởng:

#### Liệt kê các yêu cầu:

1. Host Machine của chúng ta sẽ chứa **Source Code Folder** của chương trình _(đây sẽ là folder mà chúng ta mở Editor lên để viết code)_.

2. **Source Code Folder** sẽ được expose ra cho một **PHP Interpreter Container** _(đây là container mà PHP enviroment được cài đặt)_, container này sẽ có quyền **biên dịch** (interpreter) source code của chúng ta và **generate response cho request**

3. Chúng ta cần thêm một container đóng vai trò là server, trong section này chúng ta sử dụng một container **Nginx Web Server**, là một web server của chương trình. "Server" này có nhiệm vụ **nhận incoming request** đi vào **PHP Interpreter Container** để Container đó **generate response code**. Sau đó **Nginx Web Server Container** send response trở lại phía client.

4. Về vấn đề lưu trữ Data, chúng ta sử dụng một **MySQL Database Container** đóng vai trò là database. _(Interpreter PHP Container cũng phải có thể giao tiếp được với database này)_

5. Ngoài ra, cần thêm một số Utility Container như **Composer**, Laravel sẽ dùng Composer để **cài đặt dependency**. Ngoài ra Laravel cần thêm một tool là **Laravel Artisan** và cuối cùng là **npm**.

#### Hình minh họa:

![Target Setup](/images/08_target_setup.png)

## Khi nào cần sử dụng Bind Mounts & COPY?

Về cơ bản, **Bind Mounts** đi ngược lại với ý tưởng của Docker, khi mà với Docker, chúng ta mong muốn tất cả những thứ cần thiết cho chương trình đều nằm trong container, độc lập hoàn toàn với Host Machine.

Bind Mounts chỉ giúp ích cho chúng ta trong giai đoạn phát triển chương trình, bởi vì với bind mount, những thay đổi trên source code chúng ta đang làm việc sẽ ngay lập tức ánh xạ đến container mà không cần phải build lại image.

Thế nên, sau khi đã phát triển xong ứng dụng, chúng ta cần thực hiện **copy SNAPSHOT** chứa latest code và latest configuration vào bên trong image. Điều này sẽ đảm bảo image của chúng ta luôn luôn chứa **latest SNAPSHOT**, và khi đem image đi deploy, nó sẽ chứa đầy đủ code cần thiết để có thể chạy độc lập mà không phụ thuộc vào bind mount của host machine.
