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

#import "DJInputWindow.h"
#import "DJLipikaUserSettings.h"

@implementation DJInputWindow

+(DJInputWindow*)windowWithAttributes:(NSDictionary*)attributes frame:(NSRect)rect {
    DJInputWindow* mainWindow = [[DJInputWindow alloc] initWithContentRect:rect styleMask:NSBorderlessWindowMask backing:NSBackingStoreBuffered defer:NO];
    [mainWindow setOpaque:NO];
    [mainWindow setBackgroundColor:[NSColor clearColor]];
    NSTextField* input = [[NSTextField alloc] initWithFrame:rect];
    [input setBordered:NO];
    [input setBezeled:NO];
    [input setEditable:YES];
    [mainWindow setInputField:input];
    return mainWindow;
}

-(BOOL)canBecomeKeyWindow {
    return YES;
}

-(NSTextField*)inputField {
    return inputField;
}

-(void)setInputField:(NSTextField *)aInputField {
    inputField = aInputField;
    [self setContentView:inputField];
}

@end
