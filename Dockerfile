FROM adoptopenjdk/openjdk11:alpine-jre

# Simply the artifact path
ARG artifact=target/java-app.jar

WORKDIR /opt/app

COPY ${artifact} app.jar

ENTRYPOINT ["java","-jar","app.jar"]