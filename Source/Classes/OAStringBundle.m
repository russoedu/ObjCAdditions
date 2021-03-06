//
//  OAStringBundle.m
//  ObjCAdditions
//
// Copyright 2011 A25 SIA
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

#import "OAStringBundle.h"
#import "SynthesizeSingleton.h"


NSString * const OAStringBundleDidReloadStringsNotification = @"OAStringBundleDidReloadStringsNotification";


@interface OAStringBundle ()

- (NSString *)preferredLocalization;
- (void)loadLocalization:(NSString *)localization;

@end


@implementation OAStringBundle

- (NSString *)localization
{
	return localization;
}

- (NSString *)localizedStringForKey:(NSString *)key {
	NSString *string = [strings objectForKey:key];
	return string ? string : key;
}

- (NSString *)preferredLocalization {
	for (NSString *curLocalization in [[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"]) {
		if ([[[NSBundle mainBundle] localizations] containsObject:curLocalization]) {
			return curLocalization;
		}
	}
	return @"en";
}

- (void)loadLocalization:(NSString *)newLocalization {
	if (![newLocalization isEqualToString:localization]) {
		NSString *path = [[NSBundle mainBundle] pathForResource:@"Localizable" ofType:@"strings" inDirectory:nil forLocalization:newLocalization];
		NSDictionary *tmpStrings = [NSDictionary dictionaryWithContentsOfFile:path];
		if (tmpStrings) {
			[strings autorelease];
			strings = [tmpStrings retain];;
			[localization autorelease];
			localization = [newLocalization retain];
		}
	}
}

- (void)reloadStrings {
	[self loadLocalization:[self preferredLocalization]];
	[[NSNotificationCenter defaultCenter] postNotificationName:OAStringBundleDidReloadStringsNotification object:self];
}

SYNTHESIZE_SINGLETON_FOR_CLASS_SHARED_NAME(OAStringBundle,bundle)

@end
