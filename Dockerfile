FROM ubuntu:24.04 AS build

RUN apt-get update && apt-get install -y cmake g++ make git && rm -rf /var/lib/apt/lists/*

WORKDIR /src
COPY CMakeLists.txt .
COPY src/ src/
RUN cmake -B build . && cmake --build build

FROM ubuntu:24.04

RUN apt-get update && apt-get install -y python3 && rm -rf /var/lib/apt/lists/*

COPY --from=build /src/build/pagepp /usr/local/bin/pagepp

WORKDIR /site
EXPOSE 8000

ENTRYPOINT ["pagepp"]
CMD ["serve", "--port", "8000"]
