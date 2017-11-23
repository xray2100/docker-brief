FROM openjdk:8-alpine
COPY auth.jar /
WORKDIR /
CMD ["java", "-XX:+UnlockExperimentalVMOptions", "-XX:+UseCGroupMemoryLimitForHeap", "-jar", "auth.jar"]