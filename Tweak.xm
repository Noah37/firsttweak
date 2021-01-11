/* How to Hook with Logos
Hooks are written with syntax similar to that of an Objective-C @implementation.
You don't need to #include <substrate.h>, it will be done automatically, as will
the generation of a class list and an automatic constructor.

%hook ClassName

// Hooking a class method
+ (id)sharedInstance {
	return %orig;
}

// Hooking an instance method with an argument.
- (void)messageName:(int)argument {
	%log; // Write a message about this call, including its class, name and arguments, to the system log.

	%orig; // Call through to the original function with its original arguments.
	%orig(nil); // Call through to the original function with a custom argument.

	// If you use %orig(), you MUST supply all arguments (except for self and _cmd, the automatically generated ones.)
}

// Hooking an instance method with no arguments.
- (id)noArguments {
	%log;
	id awesome = %orig;
	[awesome doSomethingElse];

	return awesome;
}

// Always make sure you clean up after yourself; Not doing so could have grave consequences!
%end
*/

#import <UIKit/UIKit.h>

@interface FirstTweakViewController: UIViewController

- (void)showAlert;

@end
%hook FirstTweakViewController

- (void)showAlert {
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"提醒" message:@"这是hook后的提醒" preferredStyle:(UIAlertControllerStyleActionSheet)];
    UIAlertAction * cancel = [UIAlertAction actionWithTitle:@"Cancel" style:(UIAlertActionStyleCancel) handler:nil];
    UIAlertAction * confirm = [UIAlertAction actionWithTitle:@"Confirm" style:(UIAlertActionStyleDestructive) handler:nil];
    [alert addAction:cancel];
    [alert addAction:confirm];
    [self presentViewController:alert animated:YES completion:nil];
}

%end
