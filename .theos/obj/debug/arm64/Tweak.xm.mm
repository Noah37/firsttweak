#line 1 "Tweak.xm"



































#import <UIKit/UIKit.h>


#include <substrate.h>
#if defined(__clang__)
#if __has_feature(objc_arc)
#define _LOGOS_SELF_TYPE_NORMAL __unsafe_unretained
#define _LOGOS_SELF_TYPE_INIT __attribute__((ns_consumed))
#define _LOGOS_SELF_CONST const
#define _LOGOS_RETURN_RETAINED __attribute__((ns_returns_retained))
#else
#define _LOGOS_SELF_TYPE_NORMAL
#define _LOGOS_SELF_TYPE_INIT
#define _LOGOS_SELF_CONST
#define _LOGOS_RETURN_RETAINED
#endif
#else
#define _LOGOS_SELF_TYPE_NORMAL
#define _LOGOS_SELF_TYPE_INIT
#define _LOGOS_SELF_CONST
#define _LOGOS_RETURN_RETAINED
#endif

@class FirstTweakViewController; 
static void (*_logos_orig$_ungrouped$FirstTweakViewController$showAlert)(_LOGOS_SELF_TYPE_NORMAL FirstTweakViewController* _LOGOS_SELF_CONST, SEL); static void _logos_method$_ungrouped$FirstTweakViewController$showAlert(_LOGOS_SELF_TYPE_NORMAL FirstTweakViewController* _LOGOS_SELF_CONST, SEL); 

#line 38 "Tweak.xm"
@interface FirstTweakViewController: UIViewController

- (void)showAlert;

@end


static void _logos_method$_ungrouped$FirstTweakViewController$showAlert(_LOGOS_SELF_TYPE_NORMAL FirstTweakViewController* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd) {
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"提醒" message:@"这是hook后的提醒" preferredStyle:(UIAlertControllerStyleActionSheet)];
    UIAlertAction * cancel = [UIAlertAction actionWithTitle:@"Cancel" style:(UIAlertActionStyleCancel) handler:nil];
    UIAlertAction * confirm = [UIAlertAction actionWithTitle:@"Confirm" style:(UIAlertActionStyleDestructive) handler:nil];
    [alert addAction:cancel];
    [alert addAction:confirm];
    [self presentViewController:alert animated:YES completion:nil];
}


static __attribute__((constructor)) void _logosLocalInit() {
{Class _logos_class$_ungrouped$FirstTweakViewController = objc_getClass("FirstTweakViewController"); MSHookMessageEx(_logos_class$_ungrouped$FirstTweakViewController, @selector(showAlert), (IMP)&_logos_method$_ungrouped$FirstTweakViewController$showAlert, (IMP*)&_logos_orig$_ungrouped$FirstTweakViewController$showAlert);} }
#line 55 "Tweak.xm"
