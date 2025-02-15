#!/bin/bash

# 更新系统并安装依赖
echo "Updating system and installing dependencies..."
sudo apt update && sudo apt install -y \
    build-essential cmake git libgtk-3-dev \
    libcanberra-gtk3-dev libtiff-dev zlib1g-dev libjpeg-dev libpng-dev \
    libavcodec-dev libavformat-dev libswscale-dev libv4l-dev \
    libxvidcore-dev libx264-dev libopenblas-dev liblapack-dev \
    gfortran libhdf5-dev libatlas-base-dev

# 创建工作目录
WORKDIR="$HOME/opencv_build"
mkdir -p $WORKDIR && cd $WORKDIR

# 克隆 OpenCV 和 contrib 源码
echo "Cloning OpenCV and contrib repositories..."
if [ ! -d "opencv" ]; then
    git clone https://github.com/opencv/opencv.git
else
    echo "OpenCV repository already exists, skipping clone."
fi

if [ ! -d "opencv_contrib" ]; then
    git clone https://github.com/opencv/opencv_contrib.git
else
    echo "OpenCV contrib repository already exists, skipping clone."
fi

# 创建构建目录
BUILD_DIR="$WORKDIR/build"
mkdir -p $BUILD_DIR && cd $BUILD_DIR

# 运行 CMake 配置
echo "Configuring OpenCV build with CMake..."
cmake -D CMAKE_BUILD_TYPE=Release \
      -D CMAKE_INSTALL_PREFIX=/usr/local \
      -D OPENCV_EXTRA_MODULES_PATH=$WORKDIR/opencv_contrib/modules \
      -D WITH_CUDA=ON \
      -D WITH_CUDNN=ON \
      -D ENABLE_FAST_MATH=ON \
      -D CUDA_FAST_MATH=ON \
      -D WITH_CUBLAS=ON \
      -D BUILD_EXAMPLES=OFF \
      -D BUILD_TESTS=OFF \
      -D BUILD_PERF_TESTS=OFF \
      -D BUILD_opencv_dnn=ON \
      -D BUILD_SHARED_LIBS=ON \
      -D BUILD_opencv_apps=OFF \
      -D OPENCV_ENABLE_NONFREE=ON \
      ../opencv

# 开始编译
echo "Building OpenCV..."
make -j$(nproc)

# 安装 OpenCV
echo "Installing OpenCV..."
sudo make install
sudo ldconfig

# 验证安装
echo "Validating OpenCV installation..."
PKG_CONFIG_PATH=$(pkg-config --modversion opencv4 2>/dev/null)
if [ -z "$PKG_CONFIG_PATH" ]; then
    echo "OpenCV installation failed or not detected by pkg-config."
else
    echo "OpenCV $PKG_CONFIG_PATH installed successfully in /usr/local!"
fi

# 结束
echo "OpenCV build and installation process completed!"
