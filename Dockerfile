FROM centos

RUN yum update -y; yum clean all

RUN yum install -y kernel-headers kernel-devel
RUN yum groupinstall -y "Development tools"
RUN yum install -y elfutils-libelf-devel cmake3 git bison flex ncurses-devel python36

# LLVM
RUN curl -LO https://github.com/llvm/llvm-project/releases/download/llvmorg-9.0.1/llvm-9.0.1.src.tar.xz
RUN tar Jxvf llvm-9.0.1.src.tar.xz
RUN mkdir llvm-build && cd llvm-build && cmake3 -G "Unix Makefiles" -DLLVM_TARGETS_TO_BUILD="BPF;X86" \
      -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=/usr ../llvm-9.0.1.src && \
      make -j16 && \
      make install
RUN rm -rf llvm-build llvm-9.0.1.src llvm-9.0.1.src.tar.xz

# CLANG
RUN curl -LO https://github.com/llvm/llvm-project/releases/download/llvmorg-9.0.1/clang-9.0.1.src.tar.xz
RUN tar Jxvf clang-9.0.1.src.tar.xz
RUN mkdir clang-build && cd clang-build && cmake3 -G "Unix Makefiles" -DLLVM_TARGETS_TO_BUILD="BPF;X86" \
          -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=/usr ../clang-9.0.1.src && \
          make -j16 && \
          make install
RUN rm -rf clang-build clang-9.0.1.src clang-9.0.1.src.tar.xz

# BCC
RUN git clone https://github.com/iovisor/bcc.git
RUN mkdir bcc/build && \
    cd bcc/build && \
    cmake .. -DPYTHON_CMD=python3 -DCMAKE_INSTALL_PREFIX=/usr && \
    make && \
    make install clean
RUN rm -rf bcc

RUN ln -s /usr/bin/python3 /usr/bin/python

RUN yum clean all

ENV PATH="/usr/share/bcc/tools:${PATH}"
WORKDIR /usr/share/bcc/tools
