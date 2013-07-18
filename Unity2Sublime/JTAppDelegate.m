//
//  JTAppDelegate.m
//  Unity2Sublime
//
//  Created by Jonas Thiel on 18.07.13.
//  Copyright (c) 2013 Jonas Thiel. All rights reserved.
//

#import "JTAppDelegate.h"

typedef struct
{
    int16_t unused1;      // 0 (not used)
    int16_t lineNum;      // line to select (< 0 to specify range)
    int32_t startRange;   // start of selection range (if line < 0)
    int32_t endRange;     // end of selection range (if line < 0)
    int32_t unused2;      // 0 (not used)
    int32_t theDate;      // modification date/time
    
}__attribute__((packed)) SelectionRange;

NSString *const BUNDLE_ID = @"com.sublimetext.2";


@implementation JTAppDelegate


- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    
}



- (BOOL)application:(NSApplication *)sender openFile:(NSString* )filename
{
    NSAppleEventDescriptor *desc = [[[NSAppleEventManager sharedAppleEventManager] currentAppleEvent] paramDescriptorForKeyword:keyAEPosition];
    NSUInteger line = 0;
    
    if(desc != nil) {
        //NSRange range;
        NSData *data = [desc data];
        NSUInteger len = [data length];
        
        if(len == sizeof(SelectionRange)) {
            SelectionRange *sr = (SelectionRange*)[data bytes];
            
            if(sr->lineNum >= 0) {
                line = sr->lineNum + 1;
                filename = [NSString stringWithFormat:@"%@:%ld", filename, (unsigned long)line];
            }
        }
    }
    
    NSTask *task = [[NSTask alloc] init];
    [task setLaunchPath:@"/usr/local/bin/subl"];
    
    NSArray *arguments = [NSArray arrayWithObject:filename];
    [task setArguments:arguments];
    
    [task launch];
    
    [NSApp terminate:nil];
    
    return TRUE;
}
@end
