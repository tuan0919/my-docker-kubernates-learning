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

*(lưu ý: volume về cơ bản vẫn là một tài nguyên bên trong host machine, chỉ là nó được quản lí bởi Docker chứ không phải chúng ta, và chúng ta cũng không nên can thiệp vào các tài nguyên này.)*

**Volumes được tạo ra và quản lí bởi Docker** - là developer, chúng ta không nhất thiết phải biết các volume này thực tế nằm ở đâu bên trong host machine. Bởi vì các volumes đó được mặc định hiểu là **không được tạo ra cho chúng ta tương tác trực tiếp với chúng** - Nếu thật sự cần, thì sử dụng "Bind mounts".

**Named Volumes** mặt khác, lại giúp chúng ta **duy trì data**. Bởi vì data không chỉ được viết trong container, mà còn ở trên host machine, **data sẽ tồn tại ngay cả khi container đó bị xóa** (do Named Volumes thì sẽ không bị xóa một cách tự động). Do vậy, chúng ta có thể sử dụng Named Volumes để duy trì data của container. (chẳng hạn log file, upload file, database file, vv...).

Anonymous Volumes có thể giúp ích trong trường hợp cần đảm bảo một số folder nội bộ trong container **không thể bị ghi đè** bởi "Bind mount".

Mặc định thì, **Anonymous Volumes sẽ bị xóa** nếu container được khởi động với flag `--rm` và dừng lại sau đó. Chúng sẽ **không bị xóa** nếu như container chỉ khởi động thông thường (không có option `--rm`) rồi bị xóa.

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

## Networks / Request

<details>
  <summary>
    <strong>Đặt vấn đề</strong>
  </summary>
  <hr>

  Trong nhiều chương trình, chúng ta cần nhiều hơn một container - vì hai lí do chính:

  1. Việc chia nhỏ công việc ra, đảm bảo mỗi container chỉ thực hiện một task duy nhất được xem là **good practice** (vd: một container chạy database, một container chạy front-end, một container chạy back-end).

  2. Rất khó để config nếu như một container làm quá nhiều việc (vd: một container chứa cả back-end, front-end và database).

  Multi-Container là một việc khá phổ biến, đặc biệt là đối với các "ứng dụng thực tế":

  Thông thường, các container cần giao tiếp thông qua:

  - Thông qua **world wide web** (Không cần bận tâm đến, vì trong trường hợp này container có thể giao tiếp bình thường).

  - Với **Host Machine**.

  - **Nội bộ các containers** với nhau.

</details>

<details>
  <summary>
    <strong>Container giao tiếp với Host Machine</strong>
  </summary>
  <hr>

 **Một lưu ý quan trọng:** *Nếu ta deploy container lên một server (một host machine khác), thì rất có thể chúng ta sẽ không phải giao tiếp với host machine đó. Giao tiếp giữa container với host machine thường chỉ là yêu cầu trong quá trình phát triển phần mềm chứ không phải là yêu cầu thực tế*

*ví dụ: giao tiếp với một database đang chạy trên chính host machine của containter, việc mà không hay diễn ra trên thực tế.*

  Xem xét đoạn mã này:
  
  ```js
  fetch('localhost:3000/demo').then(...)
  ```

  Đoạn mã trên đang gửi một `GET` request đến một web server đang chạy trên local host machine (tức là **bên ngoài** của Container, nhưng **không phải** là trên WWW).

  Trên localhost, đoạn mã trên sẽ hoạt động, nhưng bên trong một container, đoạn mã đó sẽ **không thể thực thi**. Bởi vì `localhost` bên trong đoạn mã đến ám chỉ đến chính bản thân Container, chứ **không phải là host machine đang chạy container** đó. Thế nhưng Docker đã cung cấp một giải pháp đơn giản cho vấn đề này.

  Cần chỉnh sửa đoạn mã lại như sau:

  ```js
 fetch('host.docker.internal:3000/demo').then(...)
  ```

  `host.docker.internal` là một address / định danh / tên miền đặc biệt mà sẽ được Docker translate sang địa chỉ IP của host machine đang chạy Container.

  **Lưu ý**: "translate" không có nghĩa là Docker sẽ modify lại source code của chúng ta hay tương tự, thay vào đó, nó chỉ phát hiện ra request đi ra bên ngoài Container và sẽ resolve IP cho request đó.
  
</details>

<details>
  <summary>
    <strong>Container giao tiếp với container khác</strong>
  </summary>
  <hr>

  Giao tiếp với container khác cũng khá đơn giản. Chúng ta có hai tùy chọn chính:
  
  1. Tìm thủ công địa chỉ IP của các container khác (tuy nhiên địa chỉ IP này có thể thay đổi)
    
  2. Sử dụng **Docker Network** và đặt các container vào cùng một **Network**.

  Cách giải quyết `1.` không quá tối ưu vì các địa chỉ IP có thể thay đổi mỗi theo thời gian.

  Cách giải quyết `2.` thì hoàn hảo. Với Docker chúng ta có thể tạo ra một Network với lệnh `docker network create SOME_NAME` rồi gắn các container vào chung một Network `SOME_NAME`.

  Ví dụ:
  ```docker
docker run -network SOME_NAME --name container_1 my-image
docker run -network SOME_NAME --name container_2 my-other-image
  ```

  Rồi sau đó, chúng ta có thể đơn giản sử dụng **container name** để cho phép các container giao tiếp với nhau - và lần nữa, Docker sẽ phát hiện ra request này và resolve IP cho chúng ta.

  Ví dụ:

  ```js
  fetch('container_1/my-data').then(...)
  ```
  
</details>
