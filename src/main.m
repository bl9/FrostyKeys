#import <Cocoa/Cocoa.h>
#import "NSAppDelegate.m"

int main(void) {
  NSApplication* app = [NSApplication sharedApplication];

    NSAppDelegate* appDelegate = [[NSAppDelegate alloc] init];
    [app setDelegate:appDelegate];
    [app run];
}
