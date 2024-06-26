#import "NSAppDelegate.h"
#import "GradientView.h"

@implementation NSAppDelegate

-(instancetype)init {
    self = [super init];
    NSRect mainFrame = [[NSScreen mainScreen] frame];
    self.window = [[NSWindow alloc] initWithContentRect:mainFrame
                                                styleMask:(NSWindowStyleMaskTitled |
                                                            NSWindowStyleMaskClosable |
                                                            NSWindowStyleMaskResizable)
                                                backing:NSBackingStoreBuffered
                                                    defer:NO];

    [self.window setTitle:@"Frosty Keys"];
    [self.window setLevel:NSNormalWindowLevel];

    GradientView *gradientView = [[GradientView alloc] initWithFrame:self.window.contentView.bounds];
    gradientView.autoresizingMask = NSViewWidthSizable | NSViewHeightSizable;

    [self.window setContentView:gradientView];
    [self.window makeKeyAndOrderFront:nil];

    NSRect mainLabelFrame = NSMakeRect(0, mainFrame.size.height / 2, mainFrame.size.width, 0);
    NSText* mainLabel = [[NSText alloc] initWithFrame:mainLabelFrame];
    [mainLabel setAlignment:NSTextAlignmentCenter];
    [mainLabel setFont:[NSFont systemFontOfSize:55.0]];
    [mainLabel setBackgroundColor:[NSColor clearColor]];
    [mainLabel setTextColor:[NSColor whiteColor]];
    [mainLabel setString:@"You can clean your keyboard now!"];
    [mainLabel setSelectable:FALSE];

    NSRect exitFrame = NSMakeRect(0, 50, mainFrame.size.width, 0);
    NSText* exitLabel = [[NSText alloc] initWithFrame:exitFrame];
    [exitLabel setAlignment:NSTextAlignmentCenter];
    [exitLabel setFont:[NSFont systemFontOfSize:85.0]];
    [exitLabel setBackgroundColor:[NSColor clearColor]];
    [exitLabel setTextColor:[NSColor yellowColor]];
    [exitLabel setString:@"Left click to exit"];
    [exitLabel setSelectable:FALSE];

    [[self.window contentView] addSubview:mainLabel];
    [[self.window contentView] addSubview:exitLabel];
    return self;
}

CGEventRef eventTapCB(CGEventTapProxy proxy, CGEventType type, CGEventRef event, void* refcon) {
    if (CGEventGetType(event) == kCGEventLeftMouseUp) {
        exit(0);
    }
    return nil;
}

// event tap
-(void)eventTap {
    CGEventMask mask = kCGEventMaskForAllEvents;
    // Mach Port used to communicate with the kernel and listen to messages
    // We need to create a runloop for that
    CFMachPortRef eventTap = CGEventTapCreate(kCGHIDEventTap, kCGHeadInsertEventTap,
        kCGEventTapOptionDefault, mask, eventTapCB, NULL);

    if (!eventTap) {
        [NSApp setActivationPolicy:NSApplicationActivationPolicyRegular];
        [self.window setBackgroundColor:[NSColor whiteColor]];
        [self.window setHasShadow:TRUE];
        [self.window setContentSize:NSMakeSize(500, 500)];
        [self.window setStyleMask:NSWindowStyleMaskTitled];
        // The window appears in only one space at a time.
        [self.window setCollectionBehavior:NSWindowCollectionBehaviorDefault];
        [self.window center];
        [NSCursor unhide];

        NSAlert* alert = [[NSAlert alloc] init];
        [alert addButtonWithTitle:@"OK"];
        [alert setMessageText:@"Error Creating Event Tap"];
        [alert setInformativeText:@"You need to grant this app (Frosty Keys) accessibility access."];
        [alert setAlertStyle:NSAlertStyleCritical];
        [alert beginSheetModalForWindow:self.window completionHandler:^(NSModalResponse returnCode) {
            exit(1);
        }];

        return;
    }

    // pass the event tap to the runloop
    CFRunLoopSourceRef runLoopSource = CFMachPortCreateRunLoopSource(kCFAllocatorDefault, eventTap, 0);
    CFRunLoopAddSource(CFRunLoopGetCurrent(), runLoopSource, kCFRunLoopCommonModes);
    CGEventTapEnable(eventTap, true);

    CFRelease(eventTap);
    CFRelease(runLoopSource);
}

-(void)applicationDidFinishLaunching:(NSNotification*)notification {
    [self.window makeKeyAndOrderFront:nil];
    [[NSApplication sharedApplication] activateIgnoringOtherApps:YES];
    [self eventTap];
}

@end
