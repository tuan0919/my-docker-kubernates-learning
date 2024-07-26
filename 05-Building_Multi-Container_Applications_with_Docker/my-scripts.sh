# Tạo network goal-network
docker network create goal-network

# Tải & chạy image cho mongodb, add image này vào goal-network
cd 05-Building_Multi-Container_Applications_with_Docker
docker run --env-file ./var.env --rm --name mongodb -v data:/data/db --network goal-network mongo

# Build Image cho backend
cd 05-Building_Multi-Container_Applications_with_Docker\backend
docker build -t goal-node:latest .
# Run container backend
docker run -p 80:80 --rm --env-file ../var.env --network goal-network --name goal-backend -v app/node_modules -v "C:\Users\Tuan\Desktop\my-docker-kubernates-learning\05-Building_Multi-Container_Applications_with_Docker\backend:/app" goal-node:latest

# Build Image cho front end
cd 05-Building_Multi-Container_Applications_with_Docker\frontend
docker build -t goal-react:latest .
# Run container frontend
docker run -p 3000:3000 -it --name goal-frontend -v app/node_modules -v "C:\Users\Tuan\Desktop\my-docker-kubernates-learning\05-Building_Multi-Container_Applications_with_Docker\frontend:/app" goal-react:latest