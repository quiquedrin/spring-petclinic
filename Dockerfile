FROM alpine/git:latest AS clone
ARG GITHUB_REPOSITORY=quiquedrin/spring-petclinic
ARG GITHUB_USER=quiquedrin
WORKDIR /${GITHUB_USER}
RUN git clone https://github.com/${GITHUB_REPOSITORY}

FROM maven:alpine AS build
ARG GITHUB_APP=spring-petclinic
ARG GITHUB_REPOSITORY=quiquedrin/spring-petclinic
WORKDIR /${GITHUB_REPOSITORY}
COPY --from=clone /${GITHUB_REPOSITORY} .
RUN ./mvnw package && mv target/${GITHUB_APP}-*.jar target/${GITHUB_APP}.jar

FROM openjdk:jre-alpine AS production
ARG GITHUB_APP=spring-petclinic
ARG GITHUB_REPOSITORY=quiquedrin/spring-petclinic
WORKDIR /${GITHUB_REPOSITORY}
COPY --from=build /${GITHUB_REPOSITORY}/target/${GITHUB_APP}.jar .
ENTRYPOINT ["java", "-jar"]
CMD ${GITHUB_APP}.jar
