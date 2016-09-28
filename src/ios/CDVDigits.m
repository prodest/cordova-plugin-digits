#import "CDVDigits.h"

#import <Cordova/CDV.h>
#import <Crashlytics/Crashlytics.h>
#import <DigitsKit/DigitsKit.h>
#import <Fabric/Fabric.h>

@implementation CDVDigits

+ (UIColor *)colorFromHexString:(NSString *)hexString {
  unsigned rgbValue = 0;

  NSScanner *scanner = [NSScanner scannerWithString:hexString];
  [scanner setScanLocation:1];
  [scanner scanHexInt:&rgbValue];

  return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16) / 255.0
                         green:((rgbValue & 0xFF00) >> 8) / 255.0
                          blue:(rgbValue & 0xFF) / 255.0
                         alpha:1.0];
}

#pragma mark - Plugin Initialization

- (void)pluginInitialize {
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(finishLaunching:) name:UIApplicationDidFinishLaunchingNotification object:nil];
}

- (void)finishLaunching:(NSNotification *)notification {
  [Fabric with:@[[Crashlytics class], [Digits class], [Answers class]]];
}

#pragma mark - Digits

- (void)authenticate:(CDVInvokedUrlCommand *)command {
  NSDictionary *options = [command argumentAtIndex:0];

  Digits *digits = [Digits sharedInstance];

  DGTAppearance *appearance;
  DGTAuthenticationConfiguration *configuration;

  appearance = [[DGTAppearance alloc] init];
  configuration = [[DGTAuthenticationConfiguration alloc] initWithAccountFields:DGTAccountFieldsDefaultOptionMask];
  configuration.appearance = appearance;

  if ([options objectForKey:@"backgroundColor"]) { appearance.accentColor = [CDVDigits colorFromHexString:[options objectForKey:@"backgroundColor"]]; }
  if ([options objectForKey:@"accentColor"]) { appearance.accentColor = [CDVDigits colorFromHexString:[options objectForKey:@"accentColor"]]; }

  [[Digits sharedInstance] authenticateWithViewController:nil
                                            configuration:configuration
                                               completion:^(DGTSession *session, NSError *error) {
    CDVPluginResult* pluginResult = nil;

    if (session) {
      DGTOAuthSigning *oauthSigning = [[DGTOAuthSigning alloc] initWithAuthConfig:digits.authConfig authSession:digits.session];
      NSDictionary *authHeaders = [oauthSigning OAuthEchoHeadersToVerifyCredentials];

      NSError *error;
      NSData *jsonData = [NSJSONSerialization dataWithJSONObject:authHeaders
                                                         options:NSJSONWritingPrettyPrinted
                                                           error:&error];
      NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];

      pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK
                                       messageAsString:jsonString];
    } else {
      pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR
                                       messageAsString:[error localizedDescription]];
    }

    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
  }];
}

- (void)logout:(CDVInvokedUrlCommand *)command {
  Digits *digits = [Digits sharedInstance];
  [digits logOut];
}

#pragma mark - Answers

-(void) sendPurchase:(CDVInvokedUrlCommand *)command {

    [self.commandDelegate runInBackground:^{

        NSNumber *priceNumber = [command argumentAtIndex:0 withDefault: nil andClass: [NSNumber class]];
        NSDecimalNumber *price = nil;

        if (priceNumber) {
            price = [NSDecimalNumber decimalNumberWithDecimal:[priceNumber decimalValue]];
        }

        [Answers logPurchaseWithPrice:price
                             currency:[command argumentAtIndex:1 withDefault: nil]
                              success:[command argumentAtIndex:2 withDefault: nil]
                             itemName:[command argumentAtIndex:3 withDefault: nil]
                             itemType:[command argumentAtIndex:4 withDefault: nil]
                               itemId:[command argumentAtIndex:5 withDefault: nil]
                     customAttributes:[command argumentAtIndex:6 withDefault: nil]];
    }];
}

-(void) sendAddToCart:(CDVInvokedUrlCommand *)command {

    NSNumber *priceNumber = [command argumentAtIndex:0 withDefault: nil andClass: [NSNumber class]];
    NSDecimalNumber *price = nil;
    
    if (priceNumber) {
        price = [NSDecimalNumber decimalNumberWithDecimal:[priceNumber decimalValue]];
    }
    
    [self.commandDelegate runInBackground:^{
        [Answers logAddToCartWithPrice:price
                              currency:[command argumentAtIndex:1 withDefault: nil]
                              itemName:[command argumentAtIndex:2 withDefault: nil]
                              itemType:[command argumentAtIndex:3 withDefault: nil]
                                itemId:[command argumentAtIndex:4 withDefault: nil]
                      customAttributes:[command argumentAtIndex:5 withDefault: nil]];
    }];
}

-(void) sendStartCheckout:(CDVInvokedUrlCommand *)command {

    NSNumber *priceNumber = [command argumentAtIndex:0 withDefault: nil andClass: [NSNumber class]];
    NSDecimalNumber *price = nil;
    
    if (priceNumber) {
        price = [NSDecimalNumber decimalNumberWithDecimal:[priceNumber decimalValue]];
    }
    
    [self.commandDelegate runInBackground:^{
        [Answers logStartCheckoutWithPrice:price
                                  currency:[command argumentAtIndex:1 withDefault: nil]
                                 itemCount:[command argumentAtIndex:2 withDefault: nil]
                          customAttributes:[command argumentAtIndex:3 withDefault: nil]];
    }];
}

-(void) sendSearch:(CDVInvokedUrlCommand *)command {
    
    [self.commandDelegate runInBackground:^{
        [Answers logSearchWithQuery:[command argumentAtIndex:0 withDefault: nil]
                   customAttributes:[command argumentAtIndex:1 withDefault: nil]];
    }];
}

-(void) sendShare:(CDVInvokedUrlCommand *)command {
    
    [self.commandDelegate runInBackground:^{
        [Answers logShareWithMethod:[command argumentAtIndex:0 withDefault: nil]
                        contentName:[command argumentAtIndex:1 withDefault: nil]
                        contentType:[command argumentAtIndex:2 withDefault: nil]
                          contentId:[command argumentAtIndex:3 withDefault: nil]
                   customAttributes:[command argumentAtIndex:4 withDefault: nil]];
    }];
}

-(void) sendRatedContent:(CDVInvokedUrlCommand *)command {
    
    [self.commandDelegate runInBackground:^{
        [Answers logRating:[command argumentAtIndex:0 withDefault: nil]
               contentName:[command argumentAtIndex:1 withDefault: nil]
               contentType:[command argumentAtIndex:2 withDefault: nil]
                 contentId:[command argumentAtIndex:3 withDefault: nil]
          customAttributes:[command argumentAtIndex:4 withDefault: nil]];
    }];
}

-(void) sendSignUp:(CDVInvokedUrlCommand *)command {
    
    [self.commandDelegate runInBackground:^{
        [Answers logSignUpWithMethod:[command argumentAtIndex:0 withDefault: nil]
                             success:[command argumentAtIndex:1 withDefault: nil]
                    customAttributes:[command argumentAtIndex:2 withDefault: nil]];
    }];
}

-(void) sendLogIn:(CDVInvokedUrlCommand *)command {
    
    [self.commandDelegate runInBackground:^{
        [Answers logLoginWithMethod:[command argumentAtIndex:0 withDefault: nil]
                            success:[command argumentAtIndex:1 withDefault: nil]
                   customAttributes:[command argumentAtIndex:2 withDefault: nil]];
    }];
}

-(void) sendInvite:(CDVInvokedUrlCommand *)command {
    
    [self.commandDelegate runInBackground:^{
        [Answers logInviteWithMethod:[command argumentAtIndex:0 withDefault: nil]
                    customAttributes:[command argumentAtIndex:1 withDefault: nil]];
    }];
}

-(void) sendLevelStart:(CDVInvokedUrlCommand *)command {
    
    [self.commandDelegate runInBackground:^{
        [Answers logLevelStart:[command argumentAtIndex:0 withDefault: nil]
              customAttributes:[command argumentAtIndex:1 withDefault: nil]];
    }];
}

-(void) sendLevelEnd:(CDVInvokedUrlCommand *)command {
    
    [self.commandDelegate runInBackground:^{
        [Answers logLevelEnd:[command argumentAtIndex:0 withDefault: nil]
                       score:[command argumentAtIndex:1 withDefault: nil]
                     success:[command argumentAtIndex:2 withDefault: nil]
            customAttributes:[command argumentAtIndex:3 withDefault: nil]];
    }];
}

-(void) sendContentView:(CDVInvokedUrlCommand *)command {

    [self.commandDelegate runInBackground:^{
        [Answers logContentViewWithName:[command argumentAtIndex:0 withDefault: nil]
                            contentType:[command argumentAtIndex:1 withDefault: nil]
                              contentId:[command argumentAtIndex:2 withDefault: nil]
                       customAttributes:[command argumentAtIndex:3 withDefault: nil]];
    }];
}

-(void) sendCustomEvent:(CDVInvokedUrlCommand *)command {

    [self.commandDelegate runInBackground:^{
        [Answers logCustomEventWithName:[command argumentAtIndex:0 withDefault: nil]
                       customAttributes:[command argumentAtIndex:1 withDefault: nil]];
    }];
}

#pragma mark - Crashlytics

- (void)addLog:(CDVInvokedUrlCommand*)command
{
    NSString *logMessage = [command argumentAtIndex:0 withDefault:@""];

    if(logMessage)
    {
        CLSNSLog(@"%@",logMessage);
    }
}

- (void)setUserIdentifier:(CDVInvokedUrlCommand*)command
{
    NSString *identifier = [command argumentAtIndex:0 withDefault:@""];

    if(identifier)
    {
        [[Crashlytics sharedInstance] setUserIdentifier:identifier];
    }
}

- (void)setUserName:(CDVInvokedUrlCommand*)command
{
    NSString *username = [command argumentAtIndex:0 withDefault:@""];

    if(username)
    {
        [[Crashlytics sharedInstance] setUserName:username];
    }
}

- (void)setUserEmail:(CDVInvokedUrlCommand*)command
{
    NSString *email = [command argumentAtIndex:0 withDefault:@""];

    if(email)
    {
        [[Crashlytics sharedInstance] setUserEmail:email];
    }
}

- (void)sendCrash:(CDVInvokedUrlCommand*)command
{
    [[Crashlytics sharedInstance] crash];
}

- (void)setStringValueForKey:(CDVInvokedUrlCommand*)command
{
    NSString *value = [command argumentAtIndex:0 withDefault:@""];
    NSString *key = [command argumentAtIndex:1 withDefault:@""];

    if(value && key)
    {
        [[Crashlytics sharedInstance] setObjectValue:value forKey:key];
    }
}

- (void)setIntValueForKey:(CDVInvokedUrlCommand*)command
{
    int value = [[command argumentAtIndex:0 withDefault:0] intValue];
    NSString *key = [command argumentAtIndex:1 withDefault:@""];

    if(key)
    {
        [[Crashlytics sharedInstance] setIntValue:value forKey:key];
    }
}

- (void)setBoolValueForKey:(CDVInvokedUrlCommand*)command
{
    BOOL value = [[command argumentAtIndex:0 withDefault:@(NO)] boolValue];
    NSString *key = [command argumentAtIndex:1 withDefault:@""];

    if(key)
    {
        [[Crashlytics sharedInstance] setBoolValue:value forKey:key];
    }
}

- (void)setFloatValueForKey:(CDVInvokedUrlCommand*)command
{
    float value = [[command argumentAtIndex:0 withDefault:0] floatValue];
    NSString *key = [command argumentAtIndex:1 withDefault:@""];

    if(key)
    {
        [[Crashlytics sharedInstance] setFloatValue:value forKey:key];
    }
}

- (void)recordError:(CDVInvokedUrlCommand*)command
{
    NSString *description = NSLocalizedString([command argumentAtIndex:0 withDefault:@"No Message Provided"], nil);
    NSDictionary *userInfo = @{ NSLocalizedDescriptionKey: description };
    
    NSNumber *defaultCode = [NSNumber numberWithInt:-1];
    int code = [[command argumentAtIndex:1 withDefault:defaultCode] intValue];
    
    NSString *domain = [[NSBundle mainBundle] bundleIdentifier];
    
    NSError *error = [NSError errorWithDomain: domain code: code userInfo: userInfo];
    
    [[Crashlytics sharedInstance] recordError:error];
}

- (void)sendNonFatalCrash:(CDVInvokedUrlCommand*)command
{
    [self recordError: command];
}

@end
