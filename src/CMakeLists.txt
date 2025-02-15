cmake_minimum_required(VERSION 3.10)

project(ObjectDetection)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED True)

find_package(OpenCV REQUIRED)
message(STATUS "OpenCV version: ${OpenCV_VERSION}")

add_executable(main main.cpp)
target_link_libraries(main ${OpenCV_LIBS})
