# Một số note cho bản thân:

## Images & Containers

### Images:
<details>
  <summary>
    <strong>Khái niệm</strong>
  </summary>
  
Images là một trong hai block xây dựng cốt lõi mà Docker hướng đến (block còn lại là "Containers").

Images là các bản **blueprint** / **template** cho containers. Chúng chỉ có quyền đọc (read-only) và chứa ứng dụng cũng như môi trường ứng dụng cần thiết (hệ điều hành, runtime, công cụ, ...).

Images không tự chạy mà thay vào đó, chúng có thể được thực thi dưới dạng containers. Images có thể được **xây dựng sẵn** (ví dụ như các images chính thức ta có thể tìm thấy trên [DockerHub](https://hub.docker.com/)) hoặc ta có thể **tự xây dựng** image của mình bằng cách định nghĩa một Dockerfile. Dockerfiles chứa các **instruction** được thực hiện khi một image được xây dựng (`docker build .`).

Mỗi hướng dẫn sau đó tạo ra một **layer** trong image. Các layer được sử dụng để xây dựng lại và chia sẻ image một cách hiệu quả.

Lệnh `CMD` là một lệnh đặc biệt: Nó **không được thực thi khi image được xây dựng** mà khi một **container được tạo và khởi động** dựa trên image đó.
</details>

### Containers:

<details>
  <summary>
    <strong>Khái niệm</strong>
  </summary>
  
Containers là **block xây dựng cốt lõi khác** mà Docker hướng đến. Containers là **các instance đang chạy** của Images. Khi bạn tạo một container (qua lệnh `docker run`), một layer mỏng có quyền đọc-ghi (read-write) được thêm vào trên cùng của Image.

Do đó, **nhiều Containers có thể được khởi động dựa trên cùng một Image**. Tất cả các Containers chạy một cách **cô lập**, nghĩa là chúng không chia sẻ bất kỳ trạng thái ứng dụng hoặc dữ liệu nào đã ghi xuống.

Chúng ta cần tạo và khởi động một Container để bắt đầu ứng dụng bên trong Container. Vì vậy, Containers là những gì cuối cùng được thực thi - cả trong giai đoạn **development** và **production**.
</details>

### Command Docker:

<details>
  <summary>
    <strong>General</strong>
  </summary>
  <hr>
  
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

- `docker pull IMAGE`: **pull** (download) một image từ DockerHub (hoặc một registry khác) xuống máy - _lệnh này sẽ được tự động gọi khi dùng lệnh `docker run IMAGE` với điều kiện image chưa được pull về trước đó và không có local image nào có tên tương tự.
  
</details>

<details>
  <summary>
    <strong>Volumes & Bind mounts</strong>
  </summary>
  <hr>

  - `docker run -v /duong-dan/ben-trong/container IMAGE`: Tạo một **Anonymous Volume** bên trong container này.

  - `docker run -v ten:/duong-dan/ben-trong/container IMAGE`: Tạo một **Named Volume** (có tên `ten`) bên trong container này.

  - `docker run -v /duong-dan-tuyet-doi/ben-trong/host-machine:/duong-dan/ben-trong/container`: **Bind Mount** một tài nguyên có đường dẫn tuyệt đối `/duong-dan-tuyet-doi/ben-trong/host-machine` trên host machine đến tài nguyên có đường dẫn `/duong-dan/ben-trong/container` bên trong Container.

  - `docker volume ls`: Liệt kê ra toàn bộ volume **đang hoạt động / đang lưu trữ ** (của tất cả các container).

  - `docker volume create VOL_NAME`: **Tạo một volume mới (Named Volume)** có tên `VOL_NAME`. Thường thì không sử dụng đến vì Docker sẽ tự động tạo một Named Volume trong trường hợp Named Volume chúng ta định nghĩa ra ở lệnh `docker run` không tồn tại.

  - `docker volume rm VOL_NAME`: **Xóa một volume** có tên `VOL_NAME` hoặc id tương tự.

  - `docker volume prune`: **Xóa tất cả volume không dùng đến** (không được sử dụng đến bởi bất kì container nào, kể cả các container đang dừng).

</details>

## Data & Volumes

<details>
  <summary>
    <strong>Vấn đề với Container</strong>
  </summary>
  
  <div>
    <hr>
    <p>
      <strong>Image là chỉ đọc</strong> - một khi chúng được tạo ra, chúng không thể bị thay đổi (cần phải rebuild lại nếu cần cập nhật lại code).
    </p>
    <p>
      <strong>Container có thể đọc và viết (thay đổi)</strong> - chúng thêm một layer <strong>có quyền đọc & viết</strong> mỏng phía bên trên image, qua đó có thể thay đổi nội dung các file và thư mục bên trong một image mà không thật sự làm thay đổi image.
    </p>
    <p>
          Nhưng kể cả có quyền đọc viết đối với Container, <strong>có hai vấn đề lớn</strong> đối với các ứng dụng chạy trong Docker:
    </p>
    <ol>
      <li>
        <strong>Data được viết bên trong một container không được đảm bảo</strong>: Nếu container bị dừng lại và xóa, tất cả các data đã viết ở container sẽ biến mất.
      </li>
      <li>
        <strong>Container không tương tác được với file hệ thống</strong>: Nếu ta thay đổi gì đó trong project, những thay đổi này không được ánh xạ vào các container đang chạy, chúng ta cần phải rebuild lại một image mới trên project đã thay đổi, rồi sau đó start một container mới dựa trên image vừa build.
      </li>
    </ol>
    <p>
      <strong>Vấn đề 1</strong> có thể được xử lí nhờ vào một tính năng của Docker được gọi là "<strong>Volume</strong>", trong khi đó <strong>Vấn đề 2</strong> sẽ được xử lí nhờ vào "<strong>Bind mounts</strong>".
    </p>
  </div>
</details>

### Volumes

<details>
  <summary>Khái niệm</summary>
  <hr>
  <p>Volumes là các thư mục (file) trên host machine được kết nối với thư mục / file bên trong một docker container.</p>
<p>Có <b>hai loại Volumes</b>:</p>
  
  - **Anonymous Volumes**: được tạo bằng lệnh `-v /duong-dan/ben-trong/container` và sẽ **tự động bị xóa đi** khi mà một container bị xóa đi bởi flag `--rm` được thêm vào bên cạnh lệnh `docker run`

  - **Named Volumes**: được tạo bằng lệnh `-v ten-volume:/duong-dan/ben-trong/container` và sẽ **không tự động bị xóa** khi mà một container bị xóa.

Với Volumes, **data có thể được pass vào một container** (nếu folder volumes bên trong host machine không rỗng) và có thể lưu trữ được các data được viết bởi container (những thay đổi của container mà được ánh xạ đến folder tương ứng trên host machine).

*(lưu ý: volume về cơ bản vẫn là một folder bên trong host machine, chỉ là nó có thể bị hoặc không bị quản lí bởi Docker.)*

**Volumes được tạo ra và quản lí bởi Docker** - là developer, chúng ta không nhất thiết phải biết các volume này thực tế nằm ở đâu bên trong host machine. Bởi vì các volumes đó được mặc định hiểu là **không được tạo ra cho chúng ta tương tác trực tiếp với chúng** - Nếu thật sự cần, thì sử dụng "Bind mounts".

**Named Volumes** mặt khác, lại giúp chúng ta **duy trì data**. Bởi vì data không chỉ được viết trong container, mà còn ở trên host machine, **data sẽ tồn tại ngay cả khi container đó bị xóa** (do Named Volumes thì sẽ không bị xóa một cách tự động). Do vậy, chúng ta có thể sử dụng Named Volumes để duy trì data của container. (chẳng hạn log file, upload file, database file, vv...).

Anonymous Volumes có thể giúp ích trong trường hợp cần đảm bảo một số folder nội bộ trong container **không thể bị ghi đè** bởi "Bind mount".

Mặc định thì, **Anonymous Volumes sẽ bị xóa** nếu container được khởi động với flag `--rm` và dừng lại sau đó. Chúng sẽ **không bị xóa** nếu như container chỉ khởi động thông thường (không có option `--rm` rồi bị xóa.

**Named Volumes sẽ không bao giờ bị xóa**, chúng ta xóa nó một cách chủ động bằng lệnh `docker rm VOL_NAME`

</details>

### Bind Mounts

<details>
  <summary>
    <strong>Khái niệm</strong>
  </summary>
  <hr>
  
  Bind Mounts về cơ bản giống với Volumes - điểm khác biệt chính là chúng ta - developer, **chủ động set một đường dẫn đến tài nguyên nào đó trên host machine** sẽ được kết nối đến một đường dẫn tài nguyên nào đó trong container (*trong khi đó đối với Volumes thì Docker sẽ là bên quyết định điều này*)

  Chúng ta thực hiện điều này thông qua lệnh: `-v /duong-dan-tuyet-doi/ben-trong/host-machine:/duong-dan/ben-trong/container`.

  Đường dẫn phía trước dấu `:` phải là **đường dẫn tuyệt đối** trên host machine khi sử dụng flag `-v` với lệnh `docker run`.

  Bind Mounts hữu ích trong trường hợp cần **chia sẻ dữ liệu với Container** khi mà những dữ liệu này có thể bị thay đổi trong lúc Container đang chạy - chẳng hạn, source code nào đó mà chúng ta muốn chia sẽ với Container đang chạy trong quá trình xây dựng ứng dụng.

  **Không nên sử dụng bind mounts khi mà chỉ muốn duy trì dữ liệu** - Named Volumes được sinh ra để giải quyết vấn đề này (Ngoại trừ trường hợp chúng ta muốn xem thử dữ liệu sẽ được lưu xuống như thế nào trong quá trình phát triển ứng dụng).

  Về cơ bản, **Bind Mounts rất phù hợp trong quá trình phát triển ứng dụng** - chúng không được sinh ra để sử dụng trong giai đoạn production (bởi vì container nên được chạy độc lập với host machine của nó).
    
</details>
