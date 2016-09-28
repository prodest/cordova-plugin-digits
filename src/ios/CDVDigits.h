#import <Cordova/CDV.h>

@interface CDVDigits : CDVPlugin

//Digits
- (void)authenticate:(CDVInvokedUrlCommand*)command;
- (void)logout:(CDVInvokedUrlCommand*)command;

// Crashlytics
- (void)addLog:(CDVInvokedUrlCommand*)command;
- (void)setUserIdentifier:(CDVInvokedUrlCommand*)command;
- (void)setUserName:(CDVInvokedUrlCommand*)command;
- (void)setUserEmail:(CDVInvokedUrlCommand*)command;
- (void)sendCrash:(CDVInvokedUrlCommand*)command;
- (void)setStringValueForKey:(CDVInvokedUrlCommand*)command;
- (void)setIntValueForKey:(CDVInvokedUrlCommand*)command;
- (void)setBoolValueForKey:(CDVInvokedUrlCommand*)command;
- (void)setFloatValueForKey:(CDVInvokedUrlCommand*)command;
- (void)recordError:(CDVInvokedUrlCommand*)command;
- (void)sendNonFatalCrash:(CDVInvokedUrlCommand*)command;

// Answers
- (void)sendPurchase:(CDVInvokedUrlCommand*)command;
- (void)sendAddToCart:(CDVInvokedUrlCommand*)command;
- (void)sendStartCheckout:(CDVInvokedUrlCommand*)command;
- (void)sendSearch:(CDVInvokedUrlCommand*)command;
- (void)sendShare:(CDVInvokedUrlCommand*)command;
- (void)sendRatedContent:(CDVInvokedUrlCommand*)command;
- (void)sendSignUp:(CDVInvokedUrlCommand*)command;
- (void)sendLogIn:(CDVInvokedUrlCommand*)command;
- (void)sendInvite:(CDVInvokedUrlCommand*)command;
- (void)sendLevelStart:(CDVInvokedUrlCommand*)command;
- (void)sendLevelEnd:(CDVInvokedUrlCommand*)command;
- (void)sendContentView:(CDVInvokedUrlCommand*)command;
- (void)sendCustomEvent:(CDVInvokedUrlCommand*)command;

@end
