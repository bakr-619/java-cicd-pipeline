FROM openjdk:11-jre-slim
WORKDIR /app
COPY target/java-cicd-pipeline-1.0.0.jar app.jar
CMD ["java", "-jar", "app.jar"]
