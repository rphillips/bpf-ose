FROM centos

RUN yum update -y; yum clean all

RUN yum install -y kernel-headers kernel-devel
RUN yum groupinstall -y "Development tools"
RUN yum install -y elfutils-libelf-devel cmake3 git bison flex ncurses-devel python36

# LLVM
RUN curl -LO https://github.com/llvm/llvm-project/releases/download/llvmorg-10.0.0/llvm-10.0.0.src.tar.xz
RUN tar Jxvf llvm-10.0.0.src.tar.xz
RUN mkdir llvm-build && cd llvm-build && cmake3 -G "Unix Makefiles" -DLLVM_TARGETS_TO_BUILD="BPF;X86" \
      -DCMAKE_BUILD_TYPE=Release -DLLVM_ENABLE_RTTI=ON -DCMAKE_INSTALL_PREFIX=/usr ../llvm-10.0.0.src && \
      make -j16 && \
      make install
RUN rm -rf llvm-build llvm-10.0.0.src llvm-10.0.0.src.tar.xz

# CLANG
RUN curl -LO https://github.com/llvm/llvm-project/releases/download/llvmorg-10.0.0/clang-10.0.0.src.tar.xz
RUN tar Jxvf clang-10.0.0.src.tar.xz
RUN mkdir clang-build && cd clang-build && cmake3 -G "Unix Makefiles" -DLLVM_TARGETS_TO_BUILD="BPF;X86" \
          -DCMAKE_BUILD_TYPE=Release -DLLVM_ENABLE_RTTI=ON -DCMAKE_INSTALL_PREFIX=/usr ../clang-10.0.0.src && \
          make -j16 && \
          make install
RUN rm -rf clang-build clang-10.0.0.src clang-10.0.0.src.tar.xz

# BCC
RUN git clone https://github.com/iovisor/bcc.git
RUN mkdir bcc/build && \
    cd bcc/build && \
    cmake .. -DPYTHON_CMD=python3 -DCMAKE_INSTALL_PREFIX=/usr && \
    make && \
    make install clean
RUN rm -rf bcc

RUN ln -s /usr/bin/python3 /usr/bin/python
RUN ldconfig

RUN git clone https://github.com/iovisor/bpftrace
RUN cd bpftrace && \
    mkdir build && cd build && \
    cmake -DCMAKE_BUILD_TYPE="$2" -DWARNINGS_AS_ERRORS:BOOL=$WARNINGS_AS_ERRORS \
      -DSTATIC_LINKING:BOOL=$STATIC_LINKING -DSTATIC_LIBC:BOOL=$STATIC_LIBC \
      -DEMBED_LLVM:BOOL=$EMBED_LLVM -DEMBED_CLANG:BOOL=$EMBED_CLANG \
      -DEMBED_LIBCLANG_ONLY:BOOL=$EMBED_LIBCLANG_ONLY \
      -DLLVM_VERSION=$LLVM_VERSION "${CMAKE_EXTRA_FLAGS}" .. && \
      make && cp src/bpftrace /usr/bin
RUN cd bpftrace && cp -r tools /
RUN rm -rf bpftrace

RUN yum clean all

COPY scripts /scripts

ENV PATH="/usr/share/bcc/tools:${PATH}"
WORKDIR /usr/share/bcc/tools
