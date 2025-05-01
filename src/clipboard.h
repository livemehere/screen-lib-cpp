#pragma once
#ifdef __cplusplus
extern "C"
{
#endif

#include <CoreGraphics/CoreGraphics.h> // CGImageRef 정의 포함

    void copyCGImageToClipboardAsPNG(CGImageRef image);

#ifdef __cplusplus
}
#endif