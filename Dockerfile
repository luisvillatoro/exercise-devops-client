FROM node:14-alpine as build
# Set the working directory to /app
WORKDIR /app
# Copy the package.json to the container
COPY src/ /app/src
COPY package.json /app/
# Install dependencies
RUN npm install
# Copy the rest of the application code to the container
COPY . .
# Build the React app
RUN npm run build
# Use an official Nginx runtime as a parent image
FROM nginx:1.21.0-alpine
# Copy the nginx.conf to the container
COPY nginx/nginx.conf /etc/nginx/conf.d/default.conf
# Copy the React app build files to the container
COPY --from=build /app/build /usr/share/nginx/html
COPY public/ /usr/share/nginx/html/public
# Expose port 80 for Nginx
EXPOSE 80
# Start Nginx when the container starts
CMD ["nginx", "-g", "daemon off;"]