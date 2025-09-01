FROM eclipse-temurin:11-jre-alpine  
COPY target/myapp-0.0.1-SNAPSHOT.jar app.jar
ENTRYPOINT ["java", "-jar", "/app.jar"]
EXPOSE 8080