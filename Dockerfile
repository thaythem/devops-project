FROM openjdk:11-jre-slim
VOLUME /tmp
COPY target/eventsProject-1.0.0 app.jar
ENTRYPOINT ["java","-jar","/app.jar"]
