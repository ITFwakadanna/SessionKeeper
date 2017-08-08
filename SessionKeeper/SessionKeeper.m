//
//  SessionKeeper.m
//  SessionKeeper
//
//  Created by Yo on 2017/08/07.
//  Copyright © 2017年 Yo. All rights reserved.
//

#import "SessionKeeper.h"
#import <objc/message.h>
#import <UIKit/UIKit.h>
#define SavedHTTPCookiesKey @"SavedHTTPCookies"



@implementation SessionKeeper
- (void)applicationDidEnterBackground:(UIApplication *)application {}
- (void)applicationDidBecomeActive:(UIApplication *)application {}
@end


void applicationDidEnterBackground2(UIApplication* application)
{
    //クッキー保存
    NSData *cookiesData = [NSKeyedArchiver archivedDataWithRootObject:
                           [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies]];
    [[NSUserDefaults standardUserDefaults] setObject:cookiesData
                                              forKey:SavedHTTPCookiesKey];
}
void applicationDidBecomeActive2(UIApplication* application)
{
    //クッキー読み込み
    NSData *cookiesData = [[NSUserDefaults standardUserDefaults]
                           objectForKey:SavedHTTPCookiesKey];
    if (cookiesData) {
        NSLog(@"load cookies");
        NSArray *cookies = [NSKeyedUnarchiver unarchiveObjectWithData:cookiesData];
        for (NSHTTPCookie *cookie in cookies)
            [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookie];
    }
}

void SessionKeeper_injectDelegates(id delegate)
{
    Class objectClass = object_getClass(delegate);
    
    NSString *newClassName = [NSString stringWithFormat:@"CustomDel_%@", NSStringFromClass(objectClass)];
    Class modDelegate = NSClassFromString(newClassName);
    if (modDelegate == nil) {
        modDelegate = objc_allocateClassPair(objectClass, [newClassName UTF8String], 0);
        SEL selectorToOverride = @selector(applicationDidEnterBackground:);
        SEL selectorToOverride2 = @selector(applicationDidBecomeActive:);

        Method m = class_getInstanceMethod(objectClass, selectorToOverride);
        class_addMethod(modDelegate, selectorToOverride, (IMP)applicationDidEnterBackground2, method_getTypeEncoding(m));
        class_addMethod(modDelegate, selectorToOverride2, (IMP)applicationDidBecomeActive2, method_getTypeEncoding(m));
        objc_registerClassPair(modDelegate);
    }
    object_setClass(delegate, modDelegate);
}



void ContextInitializer(void* extData, const uint8_t* ctxType, FREContext ctx, uint32_t* numFunctionsToTest, const FRENamedFunction** functionsToSet)
{
    NSLog(@"Entering ContextInitializer()");
    
    
    /* The following code describes the functions that are exposed by this native extension to the ActionScript code.
     * As a sample, the function isSupported is being provided.
     */

    SessionKeeper_injectDelegates([[UIApplication sharedApplication] delegate]);
    
    NSLog(@"Exiting ContextInitializer()");
}

/* ContextFinalizer()
 * The context finalizer is called when the extension's ActionScript code
 * calls the ExtensionContext instance's dispose() method.
 * If the AIR runtime garbage collector disposes of the ExtensionContext instance, the runtime also calls ContextFinalizer().
 */
void ContextFinalizer(FREContext ctx)
{
    NSLog(@"Entering ContextFinalizer()");
    
    // Nothing to clean up.
    NSLog(@"Exiting ContextFinalizer()");
    return;
}
