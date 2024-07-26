# Tạo network goal-network
docker network create goal-network

# Tải & chạy image cho mongodb, add image này vào goal-network
docker run -d --name mongodb --network goal-network -p 27017:27017 mongo

# Build Image cho backend
cd 05-Building_Multi-Container_Applications_with_Docker\backend
docker build -t goal-node:latest .
# Run container backend
docker run -p 80:80 -d --network goal-network --name goal-backend -v "C:\Users\Tuan\Desktop\my-docker-kubernates-learning\05-Building_Multi-Container_Applications_with_Docker\backend:/app" goal-node:latest
docker logs goal-backend

# Build Image cho front end
cd 05-Building_Multi-Container_Applications_with_Docker\frontend
docker build -t goal-react:latest .
# Run container frontend
docker run -p 3000:3000 --rm -d --network goal-network --name goal-frontend -v "C:\Users\Tuan\Desktop\my-docker-kubernates-learning\05-Building_Multi-Container_Applications_with_Docker\frontend:/app" goal-react:latest
docker logs goal-frontend