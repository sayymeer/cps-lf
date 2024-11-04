# Base image has Java 17, sbt and scala.
FROM sbtscala/scala-sbt:eclipse-temurin-17.0.4_1.7.1_3.2.0

# Timezone
ENV TZ=Asia/Kolkata
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Install dependencies.
RUN apt-get update \
    && apt-get install -y \
        ca-certificates \
        curl \
        git \
        openssh-client \
        sudo \
        tar \
        unzip \
        wget \
        zip \
        vim \
        tmux \
        cmake \
        protobuf-compiler \
    && apt-get clean

# Install Lingua Franca.
RUN curl -Ls https://install.lf-lang.org | bash -s cli --prefix=/root/lingua-franca
ENV PATH="${PATH}:/root/lingua-franca/bin/"

# Install Z3 and Uclid5.
RUN git clone https://github.com/uclid-org/uclid.git && \
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

# Configure JVM
ENV _JAVA_OPTIONS="-Xmx12G -Xss4m"
#
# Run bash upon entry.
ENTRYPOINT ["/bin/bash"]
