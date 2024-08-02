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
