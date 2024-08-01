# Một số note cho bản thân:

## Images & Containers

### Images:

Images là một trong hai block xây dựng cốt lõi mà Docker hướng đến (block còn lại là "Containers").

Images là các bản **blueprint** / **template** cho containers. Chúng chỉ có quyền đọc (read-only) và chứa ứng dụng cũng như môi trường ứng dụng cần thiết (hệ điều hành, runtime, công cụ, ...).

Images không tự chạy mà thay vào đó, chúng có thể được thực thi dưới dạng containers. Images có thể được **xây dựng sẵn** (ví dụ như các images chính thức ta có thể tìm thấy trên [DockerHub](https://hub.docker.com/)) hoặc ta có thể **tự xây dựng** image của mình bằng cách định nghĩa một Dockerfile. Dockerfiles chứa các **instruction** được thực hiện khi một image được xây dựng (`docker build .`).

Mỗi hướng dẫn sau đó tạo ra một **layer** trong image. Các layer được sử dụng để xây dựng lại và chia sẻ image một cách hiệu quả.

Lệnh `CMD` là một lệnh đặc biệt: Nó **không được thực thi khi image được xây dựng** mà khi một **container được tạo và khởi động** dựa trên image đó.

### Containers:

Containers là **block xây dựng cốt lõi khác** mà Docker hướng đến. Containers là **các instance đang chạy** của Images. Khi bạn tạo một container (qua lệnh `docker run`), một layer mỏng có quyền đọc-ghi (read-write) được thêm vào trên cùng của Image.

Do đó, **nhiều Containers có thể được khởi động dựa trên cùng một Image**. Tất cả các Containers chạy một cách **cô lập**, nghĩa là chúng không chia sẻ bất kỳ trạng thái ứng dụng hoặc dữ liệu nào đã ghi xuống.

Chúng ta cần tạo và khởi động một Container để bắt đầu ứng dụng bên trong Container. Vì vậy, Containers là những gì cuối cùng được thực thi - cả trong giai đoạn **development** và **production**.

### Command Docker cơ bản:

- `docker build .`: build một Dokerfile và tạo ra một Image dựa vào file đó.

  - `t NAME:TAG`: gán `NAME` và `TAG` cho một Image.

- `docker run IMAGE_NAME`: Tạo và start một container mới dựa trên image `IMAGE_NAME` (có thể sử dụng image id)

  - `--name NAME`: gán `NAME` vào container. `NAME` có thể dùng để dừng, xóa, vv...

  - `-d`: chạy container này ở **detach mode** - output được in ra bởi container này sẽ không được hiển thị trên màn hình.

  - `-it`: chạy container ở **interactive mode** - container / chương trình khi đó sẽ sẵn sàng để nhận input thông qua command prompt / terminal. Có thể dừng container với phím tắt `CTRL + C` khi sử dụng `-it`.

  - `--rm`: **tự động xóa** container này khi nó dừng lại.

- `docker ps`: Liệt kê tất cả các container **đang chạy**.

  - `-a`: Liệt kê tất cả các container **đang chạy** và **đang dừng**.

- `docker images`: Liệt kê tất cả các **local images** đang có.

- `docker rm CONTAINER_NAME`: **xóa** một container có tên `CONTAINER_NAME` hoặc có id tương tự.

- `docker rmi IMAGE`: **xóa** image có tên `IMAGE` hoặc có id tương tự.

- `docker container prune`: **xóa tất cả** các container **đang dừng**.

- `docker image prune`: **xóa tất cả** các image **không được sử dụng** (untagged images)

  - `-a`: **xóa tất cả** các **local images**.

- `docker push IMAGE`: **push** một image lên DockerHub (hoặc một registry khác) - image name/tag phải bao gồm repository name/url.

- `docker pull IMAGE`: **pull** (download) một image từ DockerHub (hoặc một registry khác) xuống máy - _lệnh này sẽ được tự động gọi khi dùng lệnh `docker run IMAGE` với điều kiện image chưa được pull về trước đó và không có local image nào có tên tương tự._
