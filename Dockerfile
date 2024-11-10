# Base image has Java 17, sbt and scala.
FROM sbtscala/scala-sbt:eclipse-temurin-17.0.4_1.7.1_3.2.0

# Install dependencies.
RUN apt-get update
RUN apt-get install -y ca-certificates curl git sudo tar unzip wget vim cmake protobuf-compiler
RUN apt-get clean

# Install Lingua Franca.
RUN curl -Ls https://install.lf-lang.org | bash -s cli --prefix=/root/.local/lingua-franca
ENV PATH="${PATH}:/root/.local/lingua-franca/bin/"

# Increasing git buffer size to clone uclid
RUN git config --global http.postBuffer 524288000

# # Install Z3 and Uclid5.
RUN git clone --progress https://github.com/uclid-org/uclid.git && \
    cd uclid && \
    git checkout 4fd5e566c5f87b052f92e9b23723a85e1c4d8c1c && \
    ./get-z3-linux.sh
ENV PATH="${PATH}:/root/uclid/z3/bin"
ENV LD_LIBRARY_PATH="${LD_LIBRARY_PATH}:/root/uclid/z3/bin"
RUN z3 --version
RUN cd uclid && \
    sbt update clean compile && \
    sbt universal:packageBin && \
    cd target/universal/ && \
    unzip uclid-0.9.5.zip
ENV PATH="${PATH}:/root/uclid/target/universal/uclid-0.9.5/bin/"
#
# Configure JVM
ENV _JAVA_OPTIONS="-Xmx12G -Xss4m"

WORKDIR /cps
COPY src/ /cps/src/ 

# Run bash upon entry.
ENTRYPOINT ["/bin/bash"]
