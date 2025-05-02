// overlay.mm
#import <AppKit/AppKit.h>
#import "overlay.h"

@interface SelectionWindow : NSWindow
@end

@interface SelectionView : NSView
@property NSPoint startPoint;
@property NSPoint currentPoint;
@property BOOL isDragging;
@end

CGRect g_selectedRect = CGRectZero;

@implementation SelectionWindow
- (BOOL)canBecomeKeyWindow { return YES; }
- (BOOL)canBecomeMainWindow { return YES; }
@end

@implementation SelectionView
- (void)mouseDown:(NSEvent *)event {
    self.startPoint = [event locationInWindow];
    self.isDragging = YES;
}

- (void)mouseDragged:(NSEvent *)event {
    self.currentPoint = [event locationInWindow];
    [self setNeedsDisplay:YES];
}

- (void)mouseUp:(NSEvent *)event {
    self.currentPoint = [event locationInWindow];
    self.isDragging = NO;

    CGFloat x = MIN(self.startPoint.x, self.currentPoint.x);
    CGFloat y = MIN(self.startPoint.y, self.currentPoint.y);
    CGFloat w = fabs(self.startPoint.x - self.currentPoint.x);
    CGFloat h = fabs(self.startPoint.y - self.currentPoint.y);

    NSRect screenFrame = [[NSScreen mainScreen] frame];
    g_selectedRect = CGRectMake(x, screenFrame.size.height - y - h, w, h);

    [NSApp stop:nil];
}

- (void)drawRect:(NSRect)dirtyRect {
    if (self.isDragging) {
        NSBezierPath* path = [NSBezierPath bezierPathWithRect:
            NSMakeRect(MIN(self.startPoint.x, self.currentPoint.x),
                       MIN(self.startPoint.y, self.currentPoint.y),
                       fabs(self.currentPoint.x - self.startPoint.x),
                       fabs(self.currentPoint.y - self.startPoint.y))];
        [[NSColor colorWithCalibratedRed:0 green:0.5 blue:1 alpha:0.3] setFill];
        [path fill];
    }
}
@end

CGRect getUserSelectedRect() {
    [NSApplication sharedApplication];

    SelectionWindow* win = [[SelectionWindow alloc]
        initWithContentRect:[[NSScreen mainScreen] frame]
                  styleMask:NSWindowStyleMaskBorderless
                    backing:NSBackingStoreBuffered
                      defer:NO];

    [win setLevel:NSStatusWindowLevel + 1];
    [win setOpaque:NO];
    [win setBackgroundColor:[NSColor clearColor]];
    [win setIgnoresMouseEvents:NO];
    [win setAlphaValue:1.0];

    SelectionView* view = [[SelectionView alloc] initWithFrame:[win contentRectForFrameRect:win.frame]];
    [win setContentView:view];
    [win makeKeyAndOrderFront:nil];

    [NSApp run];

    return g_selectedRect;
}