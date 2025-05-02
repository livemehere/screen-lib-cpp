#import <AppKit/AppKit.h>
#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import "clipboard.h"

void copyCGImageToClipboardAsPNG(CGImageRef image) {
    if (!image) return;

    NSBitmapImageRep* bitmapRep = [[NSBitmapImageRep alloc] initWithCGImage:image];
    NSData* pngData = [bitmapRep representationUsingType:NSBitmapImageFileTypePNG properties:@{}];

    if (!pngData) return;

    NSPasteboard* pasteboard = [NSPasteboard generalPasteboard];
    [pasteboard clearContents];
    [pasteboard setData:pngData forType:NSPasteboardTypePNG];

    NSLog(@"✅ Image copied to clipboard as PNG.");
}
