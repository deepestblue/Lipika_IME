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

#import "DJCandidateWindow.h"
#import "DJLipikaUserSettings.h"

@implementation DJCandidateWindow

-(id)init {
    // This rect does not matter as the window is invisible at this point
    NSRect rect = NSMakeRect(0, 0, 10, 10);
    self = [super initWithContentRect:rect styleMask:NSBorderlessWindowMask backing:NSBackingStoreBuffered defer:NO];
    [self setOpaque:NO];
    [self setBackgroundColor:[NSColor clearColor]];
    candidate = [[NSTextView alloc] initWithFrame:rect];
    [candidate setEditable:NO];
    [candidate setDrawsBackground:NO];
    [self setContentView:candidate];
    return self;
}

-(void)setCandidateData:(NSAttributedString*)candidateData {
    // Set background color and alpha value
    NSRange range = NSMakeRange(0, 0);
    NSColor* background = [candidateData attribute:NSBackgroundColorDocumentAttribute atIndex:0 effectiveRange:&range];
    if (background) {
        NSColor* effective = [background colorWithAlphaComponent:[DJLipikaUserSettings opacity]];
        [self setBackgroundColor:effective];
        [candidate setBackgroundColor:effective];
    }
    /*
     * Figure out the delta; delete old and insert new
     * Fontd is so bad that if we don't do deltas, the window will flicker as you type
     */
    NSString* old = [candidate string];
    NSString* new = [candidateData string];
    int i = 0;
    for (; i < old.length && i < new.length; i++) {
        if ([old characterAtIndex:i] != [new characterAtIndex:i]) break;
    }
    [candidate setEditable:YES];
    [candidate insertText:[new substringFromIndex:i] replacementRange:NSMakeRange(i, old.length)];
    [candidate setEditable:NO];
}

-(void)show {
    [self orderFrontRegardless];
}

-(void)hide {
    [super orderOut:self];
}

@end
