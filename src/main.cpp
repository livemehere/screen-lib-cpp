#include <iostream>
#include <CoreGraphics/CoreGraphics.h> // -framework ApplicationServices

int main()
{
    const uint32_t maxDisplays = 10; // ? constexpr vs const
    CGDirectDisplayID displays[maxDisplays];
    uint32_t displayCount = 0; // ? uint32_t vs int vs size_t

    CGError err = CGGetOnlineDisplayList(maxDisplays, displays, &displayCount);
    if (err != kCGErrorSuccess)
    {
        std::cerr << "Error getting display list: " << err << std::endl;
        return -1;
    }

    std::cout << "Number of displays: " << displayCount << std::endl;

    return 0;
}