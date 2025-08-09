# Build stage
FROM maven:3.9.5-eclipse-temurin-17 as build
WORKDIR /workspace
COPY pom.xml .
COPY src ./src
RUN mvn -B -DskipTests clean package

# Run stage
FROM eclipse-temurin:17-jre-alpine
WORKDIR /app
COPY --from=build /workspace/target/*.jar /app/app.jar
ENTRYPOINT ["java","-jar","/app/app.jar"]
