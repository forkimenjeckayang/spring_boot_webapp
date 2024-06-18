# # Start with a base image containing Ubuntu
# FROM ubuntu:latest

# # Set the working directory in the container
# WORKDIR /app

# # Install OpenJDK 17
# RUN apt-get update && \
#     apt-get install -y openjdk-17-jdk && \
#     apt-get clean

# # Copy the executable JAR file into the container
# COPY target/bookStore-0.0.1-SNAPSHOT.jar app.jar

# # Expose the port your Spring Boot application listens on
# EXPOSE 8080

# # Set the environment variables for the PostgreSQL connection
# ENV SPRING_DATASOURCE_URL=jdbc:postgresql://postgres_db:5430/postgres
# ENV SPRING_DATASOURCE_USERNAME=postgres
# ENV SPRING_DATASOURCE_PASSWORD=${DB_PASSWORD}

# # Run the Spring Boot application when the container starts
# ENTRYPOINT ["java", "-jar", "app.jar"]

# Use a base image with OpenJDK 11 installed
FROM ubuntu:latest

# Install OpenJDK 17
RUN apt-get update && \
    apt-get install -y openjdk-17-jdk && \
    apt-get clean

# Set the working directory in the container
WORKDIR /app

# Copy the packaged JAR file into the container
COPY target/bookStore-0.0.1-SNAPSHOT.jar app.jar

# Expose the port that your Spring Boot application runs on (default is 8080)
EXPOSE 8080

# Command to run the Spring Boot application when the container starts
CMD ["java", "-jar", "app.jar"]

