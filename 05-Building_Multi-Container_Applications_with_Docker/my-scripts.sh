# Tạo network goal-network
docker network create goal-network

# Tải & chạy image cho mongodb, add image này vào goal-network
docker run -d --name mongodb --network goal-network mongo

# Build Image cho backend
cd 05-Building_Multi-Container_Applications_with_Docker\backend
docker build -t goal-node:latest .
# Run container backend
#   - bind mount thư mục logs backend (access.log)
#   - bind mount app.js
docker run -p 80:80 --rm -d --network goal-network --name goal-backend -v "C:\Users\Tuan\Desktop\my-docker-kubernates-learning\05-Building_Multi-Container_Applications_with_Docker\backendapp" goal-node:latest
docker logs goal-backend