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
#import "DJInputWindow.h"
#import <InputMethodKit/InputMethodKit.h>

@implementation DJCandidatesController

extern IMKCandidates* candidates;

-(id)initWithController:(DJLipikaInputController *)aController {
    self = [super init];
    if (self == nil) {
        return self;
    }
    controller = aController;
    [candidates setDismissesAutomatically:NO];
    return self;
}

-(void)showWithInput:(NSString*)input candidates:(NSArray *)candidates attributes:(NSDictionary*)attributes frame:(NSRect)rect {
    /*
     {
     IMKBaseline = "NSPoint: {1097, 73}";
     IMKLineAscent = "12.56836";
     IMKLineHeight = 17;
     IMKTextOrientation = 1;
     NSFont = "\"LucidaGrande 13.00 pt. P [] (0x7fd29bc80640) fobj=0x7fd29bc2d8e0, spc=4.11\"";
     }
     */
    if (input == nil || attributes == nil) {
        [self hide];
        return;
    }
    if (!inputWindow) inputWindow = [DJInputWindow windowWithAttributes:attributes frame:rect];
    NSAttributedString* displayString = [[NSAttributedString alloc] initWithString:input attributes:[DJLipikaUserSettings inputAttributes]];
    rect.size = [displayString size];
    [inputWindow setFrame:rect display:NO];
    [[inputWindow inputField] setAttributedStringValue:displayString];
    [inputWindow orderFrontRegardless];
}

-(void)hide {
    [inputWindow orderOut:self];
    [candidates hide];
}

@end
