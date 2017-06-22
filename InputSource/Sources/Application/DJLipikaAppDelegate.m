/*
 * LipikaIME is a user-configurable phonetic Input Method Engine for Mac OS X.
 * Copyright (C) 2013 Ranganath Atreya
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
 */

#import <InputMethodKit/InputMethodKit.h>
#import "DJLipikaAppDelegate.h"
#import "DJInputSchemeFactory.h"
#import "DJLipikaUserSettings.h"
#import "DJSchemeHelper.h"
#import "DJLogger.h"

@implementation DJLipikaAppDelegate

@synthesize mainMenu;

-(void)awakeFromNib {
    [self configureMenu];
    [self configureCandiates];
}

-(void)configureMenu {
    int runningTagId = 0;
    // Set selector for preferrence
    NSMenuItem *preferrence = [mainMenu itemWithTag:++runningTagId];
    if (preferrence) {
        [preferrence setAction:@selector(showPreferences:)];
    }
    // Add Convert file item
    NSMenuItem *convertFile = [[NSMenuItem alloc] initWithTitle:@"Convert file..." action:@selector(showPreferences:) keyEquivalent:@""];
    [convertFile setTag:++runningTagId];
    [mainMenu addItem:convertFile];
    enum DJSchemeType type = [DJLipikaUserSettings schemeType];
    NSString *defaultSchemeName = [DJLipikaUserSettings schemeName];
    // Add Scheme item to the mainMenu
    NSArray *schemeNames = [DJInputSchemeFactory availableSchemesForType:DJ_LIPIKA];
    NSArray *scriptNames = [DJInputSchemeFactory availableScriptsForType:DJ_LIPIKA];
    if (schemeNames.count > 0 && scriptNames.count > 0) {
        NSMenuItem *schemeSelectionItem = [[NSMenuItem alloc] initWithTitle:DJInputMenuItemTitle action:NULL keyEquivalent:@""];
        [schemeSelectionItem setTag:++runningTagId];
        [mainMenu addItem:schemeSelectionItem];
        // Create a schemes submenu
        NSMenu *schemeSubMenu = [[NSMenu alloc] initWithTitle:DJSchemeSubMenu];
        for (NSString *schemeName in schemeNames) {
            // Add add the schemes to the sub menu
            NSMenuItem *schemeItem = [[NSMenuItem alloc] initWithTitle:schemeName action:@selector(showPreferences:) keyEquivalent:@""];
            [schemeItem setTag:++runningTagId];
            if (type == DJ_LIPIKA && [defaultSchemeName isEqualToString:schemeName]) {
                [schemeItem setState:NSOnState];
            }
            [schemeSubMenu addItem:schemeItem];
        }
        [schemeSelectionItem setSubmenu:schemeSubMenu];
    }
    // Add Script item to the mainMenu
    if (schemeNames.count > 0 && scriptNames.count > 0) {
        NSMenuItem *scriptSelectionItem = [[NSMenuItem alloc] initWithTitle:DJOutputMenuItemTitle action:NULL keyEquivalent:@""];
        [scriptSelectionItem setTag:++runningTagId];
        [mainMenu addItem:scriptSelectionItem];
        // Create a scripts submenu
        NSMenu *scriptSubMenu = [[NSMenu alloc] initWithTitle:DJScriptSubMenu];
        NSString *defaultScriptName = [DJLipikaUserSettings scriptName];
        for (NSString *scriptName in scriptNames) {
            NSMenuItem *scriptItem = [[NSMenuItem alloc] initWithTitle:scriptName action:@selector(showPreferences:) keyEquivalent:@""];
            [scriptItem setTag:++runningTagId];
            if (type == DJ_LIPIKA && [defaultScriptName isEqualToString:scriptName]) {
                [scriptItem setState:NSOnState];
            }
            [scriptSubMenu addItem:scriptItem];
        }
        [scriptSelectionItem setSubmenu:scriptSubMenu];
    }
    // Create a custom schemes submenu if needed
    NSArray *googleSchemes = [DJInputSchemeFactory availableSchemesForType:DJ_GOOGLE];
    defaultSchemeName = [DJLipikaUserSettings customSchemeName];
    if (googleSchemes && googleSchemes.count > 0) {
        NSMenuItem *googleSchemeItem = [[NSMenuItem alloc] initWithTitle:DJCustomMenuItemTitle action:NULL keyEquivalent:@""];
        [googleSchemeItem setTag:++runningTagId];
        [mainMenu addItem:googleSchemeItem];
        NSMenu *googleSubMenu = [[NSMenu alloc] initWithTitle:DJGoogleSubMenu];
        for (NSString *googleScheme in googleSchemes) {
            // Add add the schemes to the sub menu
            NSMenuItem *schemeItem = [[NSMenuItem alloc] initWithTitle:googleScheme action:@selector(showPreferences:) keyEquivalent:@""];
            [schemeItem setTag:++runningTagId];
            if (type == DJ_GOOGLE && [defaultSchemeName isEqualToString:googleScheme]) {
                [schemeItem setState:NSOnState];
            }
            [googleSubMenu addItem:schemeItem];
        }
        [googleSchemeItem setSubmenu:googleSubMenu];
    }
}

-(void)configureCandiates {
    extern IMKCandidates *candidates;
    [candidates setPanelType:[[DJLipikaUserSettings candidatePanelType] intValue]];
    [candidates setDismissesAutomatically:NO];
    [candidates setAttributes:[DJLipikaUserSettings candidateWindowAttributes]];
}

-(void)clearAllOnStates:(NSMenu *)rootMenu {
    NSArray *peerItems = [rootMenu itemArray];
    [peerItems enumerateObjectsUsingBlock:^(NSMenuItem *obj, NSUInteger idx, BOOL *stop) {
        [obj setState:NSOffState];
        if ([obj hasSubmenu]) [self clearAllOnStates:[obj submenu]];
    }];
}

-(void)updateSchemeSelection {
    // Clear all existing selections
    [self clearAllOnStates:mainMenu];
    // Turn on state for the script and scheme
    if ([DJLipikaUserSettings schemeType] == DJ_GOOGLE) {
        [[[[mainMenu itemWithTitle:DJCustomMenuItemTitle] submenu] itemWithTitle:[DJLipikaUserSettings schemeName]] setState:NSOnState];
    }
    else {
        [[[[mainMenu itemWithTitle:DJInputMenuItemTitle] submenu] itemWithTitle:[DJLipikaUserSettings schemeName]] setState:NSOnState];
        [[[[mainMenu itemWithTitle:DJOutputMenuItemTitle] submenu] itemWithTitle:[DJLipikaUserSettings scriptName]] setState:NSOnState];
    }
}

@end
