#import <UIKit/UIKit.h>

static NSString *plistPath = @"/var/mobile/Library/Preferences/xyz.henryli17.alwayslandscape.plist";

%group Tweak
	%hook UIDevice
	-(void)setOrientation:(long long)arg1 {
		NSMutableDictionary *plistDict = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];

		BOOL rotateRight = [[plistDict objectForKey:@"RotateOption"] integerValue] == 1;
		if (rotateRight) {
			%orig(UIInterfaceOrientationLandscapeRight);
		} else {
			%orig(UIInterfaceOrientationLandscapeLeft);
		}
	}

	-(void)setOrientation:(long long)arg1 animated:(BOOL)arg2 {
		NSMutableDictionary *plistDict = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];

		BOOL rotateRight = [[plistDict objectForKey:@"RotateOption"] integerValue] == 1;
		if (rotateRight) {
			%orig(UIInterfaceOrientationLandscapeRight, arg2);
		} else {
			%orig(UIInterfaceOrientationLandscapeLeft, arg2);
		}
	}
	%end
%end

%ctor {
	NSString *identifier = [[NSBundle mainBundle] bundleIdentifier];
	NSMutableDictionary *plistDict = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];

	if (identifier != nil && plistDict != nil) {
		if ([[plistDict objectForKey:[@"Settings-" stringByAppendingString:identifier]] boolValue]) {
			%init(Tweak);
		};
	}
}
