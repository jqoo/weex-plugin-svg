//
//  WeexSVGComponent.m
//  weex-svg
//
//  Created by jqoo on 2019/11/26.
//

#import "WeexSVGComponent.h"
#import "SVGKFastImageView.h"
#import <WeexSDK/WeexSDK.h>
#import <WeexSDK/WXResourceLoader.h>
#import <WeexSDK/WXUtility.h>

@interface WeexSVGImageView : SVGKFastImageView

@property (nonatomic, strong) NSURL *url;

@end

@implementation WeexSVGImageView

- (instancetype)init {
    return [super initWithSVGKImage:nil];
}

- (NSString *)cacheDir {
    NSString *cacheRoot = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).firstObject;
    NSString *dir = [cacheRoot stringByAppendingPathComponent:@"wx_svg"];
    [[NSFileManager defaultManager] createDirectoryAtPath:dir withIntermediateDirectories:YES attributes:nil error:nil];
    return dir;
}

- (void)loadURL:(NSURL *)url completion:(void (^)(SVGKImage *))completion {
    if ([url isFileURL]) {
        [self loadSVGFromLocalURL:url completion:completion];
        return;
    }
    NSString *key = [WXUtility md5:[url absoluteString]];
    NSString *path = [[self cacheDir] stringByAppendingPathComponent:key];
    if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
        [self loadSVGFromLocalURL:[NSURL fileURLWithPath:path] completion:completion];
        return;
    }
    __weak typeof(self) weakSelf = self;
    WXResourceRequest * resourceRequest = [WXResourceRequest requestWithURL:url resourceType:WXResourceTypeLink referrer:@"" cachePolicy:NSURLRequestUseProtocolCachePolicy];
    WXResourceLoader * loader = [[WXResourceLoader alloc] initWithRequest:resourceRequest];
    loader.onFinished = ^(const WXResourceResponse * response, NSData * data) {
        NSError * error = nil;
        NSHTTPURLResponse * httpResponse = (NSHTTPURLResponse*)response;
        if (200 == httpResponse.statusCode) {
            if (error || !data) {
                WXLogError(@"convert json object failed with error: %@", error.description);
            }
            else {
                [data writeToFile:path atomically:YES];
                [weakSelf loadURL:[NSURL fileURLWithPath:path] completion:completion];
            }
        } else {
            WXLogError(@"server return with status code: %ld", httpResponse.statusCode);
        }
    };
    
    loader.onFailed = ^(NSError * error) {
        WXLogError(@"download src %@ failed with error: %@", url, error.description);
    };
    
    [loader start];
}

- (void)loadSVGFromLocalURL:(NSURL *)localURL completion:(void (^)(SVGKImage *))completion {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        SVGKImage *image = nil;
        if (localURL) {
            image = [SVGKImage imageWithContentsOfURL:localURL];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(image);
        });
    });
}

- (void)setUrl:(NSURL *)url {
    if (_url == url || [_url isEqual:url]) {
        return;
    }
    _url = url;
    self.image = nil;
    
    __weak typeof(self) weakSelf = self;
    [self loadURL:url completion:^(SVGKImage *image) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (strongSelf && [strongSelf->_url isEqual:url]) {
            strongSelf.image = image;
        }
    }];
}

@end

@implementation WeexSVGComponent

- (instancetype)initWithRef:(NSString *)ref type:(NSString *)type styles:(NSDictionary *)styles attributes:(NSDictionary *)attributes events:(NSArray *)events weexInstance:(WXSDKInstance *)weexInstance {
    self = [super initWithRef:ref type:type styles:styles attributes:attributes events:events weexInstance:weexInstance];
    if (self) {
        NSLog(@"");
    }
    return self;
}

- (UIView *)loadView {
    WeexSVGImageView *view = [[WeexSVGImageView alloc] init];
    view.translatesAutoresizingMaskIntoConstraints = NO;
    view.contentMode = UIViewContentModeScaleAspectFit;
    return view;
}

- (WeexSVGImageView *)imageView {
    return (WeexSVGImageView *)[self view];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self imageView].url = [NSURL URLWithString:self.attributes[@"src"]];
}

- (void)updateAttributes:(NSDictionary *)attributes {
    [super updateAttributes:attributes];
    
    if (attributes[@"src"]) {
        [self imageView].url = [NSURL URLWithString:attributes[@"src"]];
    }
}

@end
