/*
 * LipikaIME is a user-configurable phonetic Input Method Engine for Mac OS X.
 * Copyright (C) 2013 Ranganath Atreya
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
 */

#import <Foundation/Foundation.h>
#import "DJInputMethodScheme.h"
#import "DJParseTreeNode.h"
#import "DJParseOutput.h"

@interface DJInputMethodEngine : NSObject {
    DJInputMethodScheme* scheme;
    DJParseTreeNode* currentNode;
    NSMutableArray* inputsSinceRoot;
    unsigned long lastOutputIndex;
}

@property DJInputMethodScheme* scheme;

-(id)initWithScheme:(DJInputMethodScheme*)inputScheme;
-(NSArray*)executeWithInput:(NSString*)input;
-(NSArray*)inputsSinceLastOutput;
-(BOOL)isAtRoot;
-(BOOL)hasDeletable;
-(void)reset;

@end
