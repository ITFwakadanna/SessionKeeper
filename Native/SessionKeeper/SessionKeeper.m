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



FREObject saveCookie(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]) {
    //クッキー保存
    NSData *cookiesData = [NSKeyedArchiver archivedDataWithRootObject:
                           [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies]];
    [[NSUserDefaults standardUserDefaults] setObject:cookiesData
                                              forKey:SavedHTTPCookiesKey];
    return NULL;
}



FREObject readCookie(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[])
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
    return NULL;
}





void contextFinalizer(FREContext ctx)
{
    return;
}

void contextInitializer(void* extData, const uint8_t* ctxType, FREContext ctx, uint32_t* numFunctions, const FRENamedFunction** functions)
{
    

    *numFunctions = 2;
    FRENamedFunction*  func= (FRENamedFunction*) malloc(sizeof(FRENamedFunction) * (*numFunctions));
    
    func[0].name = (const uint8_t*) "saveCookie";
    func[0].functionData = NULL;
    func[0].function = &saveCookie;
    
    func[1].name = (const uint8_t*) "readCookie";
    func[1].functionData = NULL;
    func[1].function = &readCookie;
    
    
    *functions = func;
}


void initializer(void** extData, FREContextInitializer* ctxInitializer, FREContextFinalizer* ctxFinalizer)
{
    *ctxInitializer = &contextInitializer;
    *ctxFinalizer = &contextFinalizer;
    
}
void finalizer(void** extData)
{
    
}



@end
