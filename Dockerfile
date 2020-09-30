FROM alpine/git:latest AS clone
ENV GITHUB_REPOSITORY=quiquedrin/spring-petclinic
ENV GITHUB_USER=quiquedrin
WORKDIR /${GITHUB_USER}
RUN git clone https://github.com/${GITHUB_REPOSITORY}
FROM maven:alpine AS build
ENV GITHUB_APP=spring-petclinic
WORKDIR /${GITHUB_REPOSITORY}
COPY --from=clone /${GITHUB_REPOSITORY} .
RUN ./mvnw package && mv target/${GITHUB_APP}-*.jar target/${GITHUB_APP}.jar
FROM openjdk:jre-alpine AS production
ENTRYPOINT ["java", "-jar"]
CMD ${GITHUB_APP}.jar
