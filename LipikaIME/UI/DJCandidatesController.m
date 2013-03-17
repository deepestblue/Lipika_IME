/*
 * LipikaIME a user-configurable phonetic Input Method Engine for Mac OS X.
 * Copyright (C) 2013 Ranganath Atreya
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

#import "DJCandidatesController.h"
#import "DJLipikaUserSettings.h"

@implementation DJCandidatesController

-(id)initWithController:(DJLipikaInputController *)aController {
    self = [super init];
    if (self == nil) {
        return self;
    }
    controller = aController;
    return self;
}

-(NSWindow*)createWindowWithAttributes:(NSDictionary *)attributes frame:(NSRect)rect {
    rect.size.height = [[attributes valueForKey:@"IMKLineHeight"] doubleValue];
    rect.size.width = 100.0;
    NSWindow* mainWindow = [[NSWindow alloc] initWithContentRect:rect styleMask:NSBorderlessWindowMask backing:NSBackingStoreBuffered defer:NO];
    [mainWindow setBackgroundColor:[NSColor blueColor]];
    NSTextField* input = [[NSTextField alloc] initWithFrame:rect];
    [input setBordered:NO];
    [input setBezeled:NO];
    NSColor* background = [[DJLipikaUserSettings backgroundColor] colorWithAlphaComponent:[DJLipikaUserSettings opacity]];
    [input setBackgroundColor:background];
    [mainWindow setContentView:input];
    mainWindow.collectionBehavior = (NSWindowCollectionBehaviorTransient | NSWindowCollectionBehaviorIgnoresCycle);
    return mainWindow;
}

-(void)showWithInput:(NSString *)input candidates:(NSArray *)candidates attributes:(NSDictionary *)attributes frame:(NSRect)rect {
    /*
     {
     IMKBaseline = "NSPoint: {1097, 73}";
     IMKLineAscent = "12.56836";
     IMKLineHeight = 17;
     IMKTextOrientation = 1;
     NSFont = "\"LucidaGrande 13.00 pt. P [] (0x7fd29bc80640) fobj=0x7fd29bc2d8e0, spc=4.11\"";
     }
     */
    if (input == nil || attributes == nil) return;
    if (!inputWindow) inputWindow = [self createWindowWithAttributes:attributes frame:rect];
    [[inputWindow contentView] setStringValue:input];
    [inputWindow orderFrontRegardless];
    [inputWindow makeKeyWindow];
}

-(void)hide {
    
}

@end
