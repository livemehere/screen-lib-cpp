#include <iostream>
#include <vector>
#include <CoreGraphics/CoreGraphics.h> // -framework ApplicationServices

#include <ImageIO/ImageIO.h>
#include <CoreFoundation/CoreFoundation.h>
#include <string>

#include <ApplicationServices/ApplicationServices.h>

#include "clipboard.h"

#ifndef kUTTypePNG
#define kUTTypePNG CFSTR("public.png")
#endif

std::vector<CGDirectDisplayID> getDisplayIds()
{
    constexpr uint32_t maxDisplays = 10;
    std::vector<CGDirectDisplayID> displayIds(maxDisplays);
    uint32_t displayCount = 0;

    CGError err = CGGetOnlineDisplayList(maxDisplays, displayIds.data(), &displayCount); // Use displays.data() to pass the pointer
    if (err != kCGErrorSuccess)
    {
        std::cerr << "Error getting display list: " << err << std::endl;
        return {};
    }
    displayIds.resize(displayCount);
    return displayIds;
}

CGImageRef getDisplayImage(CGDirectDisplayID display, CGRect rect)
{
    CGRect screenRect = CGDisplayBounds(display);
    CGImageRef img = CGDisplayCreateImage(display);
    CGImageRef croppedImg = CGImageCreateWithImageInRect(img, rect);
    return croppedImg;
}

void saveImage(CGImageRef img, const std::string &path)
{
    CFURLRef url = CFURLCreateFromFileSystemRepresentation(
        kCFAllocatorDefault,
        reinterpret_cast<const UInt8 *>(path.c_str()),
        path.length(),
        false);
    CGImageDestinationRef dest = CGImageDestinationCreateWithURL(url, kUTTypePNG, 1, nullptr);
    CGImageDestinationAddImage(dest, img, nullptr);
    CFRelease(dest);
    CFRelease(url);
}

int main()
{

    std::vector<CGDirectDisplayID> displayIds = getDisplayIds();

    std::cout << "Number of displays: " << displayIds.size() << std::endl;
    for (uint32_t i = 0; i < displayIds.size(); i++)
    {
        CGDirectDisplayID display = displayIds[i];
        CGRect cropRect = CGRectMake(0, 0, 300, 300);

        CGImageRef croppedImg = getDisplayImage(display, cropRect);

        size_t width = CGImageGetWidth(croppedImg);
        size_t height = CGImageGetHeight(croppedImg);

        // std::string filePath = "./Display_" + std::to_string(display) + ".png";
        // saveImage(croppedImg, filePath);

        copyCGImageToClipboardAsPNG(croppedImg);

        CFRelease(croppedImg);
    }

    return 0;
}
