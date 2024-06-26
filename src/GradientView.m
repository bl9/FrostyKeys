#import "GradientView.h"

@implementation GradientView

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    NSColor *startingColor = [NSColor colorWithCalibratedRed:0.0 green:0.5 blue:1.0 alpha:1.0]; // Start color
    NSColor *endingColor = [NSColor colorWithCalibratedRed:0.0 green:0.0 blue:1.0 alpha:1.0]; // End color
    
    NSGradient *gradient = [[NSGradient alloc] initWithStartingColor:startingColor endingColor:endingColor];
    [gradient drawInRect:[self bounds] angle:90.0];
}

@end