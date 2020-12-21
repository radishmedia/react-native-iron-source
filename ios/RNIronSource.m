#import "RNIronSource.h"

@implementation RNIronSource {
    RCTResponseSenderBlock _requestRewardedVideoCallback;
}

- (dispatch_queue_t)methodQueue
{
    return dispatch_get_main_queue();
}

RCT_EXPORT_MODULE()

// Initialize IronSource before showing the Rewarded Video
RCT_EXPORT_METHOD(initializeIronSource:(NSString *)appId
                  userId:(NSString *)userId
                  options:(NSDictionary *)options
                  resolver:(RCTPromiseResolveBlock)resolve
                  rejector:(RCTPromiseRejectBlock)reject)
{
    NSLog(@"initializeIronSource called!! with key %@ and user id %@", appId, userId);
    [IronSource setUserId:userId];
    [IronSource initWithAppKey:appId];

    BOOL validateIntegration = [RCTConvert BOOL:options[@"validateIntegration"]];
    if (validateIntegration) {
        [ISIntegrationHelper validateIntegration];
    }
    resolve(nil);
}

RCT_EXPORT_METHOD(setConsent:(BOOL)consent)
{
    [IronSource setConsent:consent];
}

RCT_EXPORT_METHOD(getAdvertiserId:(RCTPromiseResolveBlock)resolve reject:(RCTPromiseRejectBlock)reject)
{
    @try {
        resolve([IronSource advertiserId]);
    }
    @catch (NSException *exception) {
        resolve(nil);
    }
}

RCT_EXPORT_METHOD(setMetaData:(NSString *)key keyValue:(NSString *)keyValue)
{
    [IronSource setMetaDataWithKey:key value:keyValue];
}

@end

