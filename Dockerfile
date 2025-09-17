# ---------- Build Stage ----------
FROM maven:3.9.9-eclipse-temurin-21 AS build
WORKDIR /app

# Copy Maven descriptor first (to leverage caching)
COPY pom.xml .
RUN mvn dependency:go-offline

# Copy source and build
COPY src ./src
RUN mvn clean package -DskipTests

# ---------- Runtime Stage ----------
FROM eclipse-temurin:21-jdk-alpine
WORKDIR /app
COPY --from=build /app/target/*.jar app.jar

EXPOSE 8082
ENTRYPOINT ["java","-jar","app.jar"]
