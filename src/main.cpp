#include <iostream>
#include <opencv2/opencv.hpp>

using namespace std;

int main(){
    cout << "hello world" << endl;

    cv::Mat img = cv::imread("/workspace/src/image/test.png");
    if (img.empty()) {
        std::cerr << "Error: Could not load image!" << std::endl;
        return -1;
    }

    cv::imwrite("/workspace/src/output/test.jpg", img);
}