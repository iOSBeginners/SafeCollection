//
//  PreProcessorMacros.m
//  SafeCollection
//
//  Created by machaabani on 29/11/2015.
//  Copyright © 2015 ThinkRight. All rights reserved.
//

#import "PreProcessorMacros.h"

@implementation PreProcessorMacros

#ifdef DEBUG
BOOL const DEBUG_BUILD = YES;
#else
BOOL const DEBUG_BUILD = NO;
#endif

@end
