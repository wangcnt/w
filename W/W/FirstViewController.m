//
//  FirstViewController.m
//  W
//
//  Created by WangQiang on 2017/12/5.
//  Copyright © 2017年 WangQiang. All rights reserved.
//

#import "FirstViewController.h"

#import <WebKit/WebKit.h>

@interface FirstViewController ()
<WKURLSchemeHandler, WKScriptMessageHandler, WKUIDelegate, WKNavigationDelegate>
@property (nonatomic, strong) WKWebView *webView;
@end

@implementation FirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
    if (@available(iOS 11.0, *)) {
        [configuration setURLSchemeHandler:self forURLScheme:@"myscheme"];
    } else {
        // Fallback on earlier versions
    }
    
    WKUserContentController *controller = [[WKUserContentController alloc] init];
    [controller addScriptMessageHandler:self name:@"myScript"];
    configuration.userContentController = controller;
    
    _webView = [[WKWebView alloc] initWithFrame:self.view.bounds configuration:configuration];
    _webView.UIDelegate = self;
    _webView.navigationDelegate = self;
    [self.view addSubview:_webView];
    
    NSString *h = html;
    [_webView loadHTMLString:h baseURL:nil];
}

- (void)dealloc {
    [_webView.configuration.userContentController removeScriptMessageHandlerForName:@"myScript"];
}

#pragma mark WKNavigationDelegate
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    if(decisionHandler) {
        decisionHandler(WKNavigationActionPolicyAllow);
    }
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler {
    if(decisionHandler) {
        decisionHandler(WKNavigationResponsePolicyAllow);
    }
}

- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    ;
}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    ;
}

#pragma mark WKUIDelegate
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler {
    UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if(completionHandler) {
            completionHandler();
        }
    }];
    [controller addAction:okAction];
    [self presentViewController:controller animated:YES completion:^{
    }];
}

- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL))completionHandler {
    UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if(completionHandler) {
            completionHandler(YES);
        }
    }];
    UIAlertAction *nothingAction = [UIAlertAction actionWithTitle:@"Nothing" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        if(completionHandler) {
            completionHandler(NO);
        }
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        if(completionHandler) {
            completionHandler(NO);
        }
    }];
    [controller addAction:okAction];
    [controller addAction:nothingAction];
    [controller addAction:cancelAction];
    [self presentViewController:controller animated:YES completion:^{
    }];
}

- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * _Nullable))completionHandler {
    UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"提示" message:prompt preferredStyle:UIAlertControllerStyleAlert];
    __block UITextField *usernameField = nil;
    __block UITextField *passwordField = nil;
    [controller addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        usernameField = textField;
        usernameField.text = defaultText;
    }];
    [controller addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        passwordField = textField;
        passwordField.text = defaultText;
    }];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if(completionHandler) {
            completionHandler([NSString stringWithFormat:@"username : %@, password : %@", usernameField.text, passwordField.text]);
        }
    }];
    UIAlertAction *nothingAction = [UIAlertAction actionWithTitle:@"Nothing" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"nothing happened.");
        if(completionHandler) {
            completionHandler(@"nothing happened");
        }
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        if(completionHandler) {
            completionHandler(nil);
        }
    }];
    [controller addAction:okAction];
    [controller addAction:nothingAction];
    [controller addAction:cancelAction];
    [self presentViewController:controller animated:YES completion:^{
    }];
}

#pragma mark WKURLSchemeHandler
- (void)webView:(WKWebView *)webView startURLSchemeTask:(id<WKURLSchemeTask>)task {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSString *path = [[NSBundle mainBundle] pathForResource:@"IMG_0876" ofType:@"JPG"];
        NSData *data = [NSData dataWithContentsOfFile:path];
        NSURLResponse *response = [[NSURLResponse alloc] initWithURL:task.request.URL MIMEType:@"image/jpg" expectedContentLength:NSURLResponseUnknownLength textEncodingName:nil];
        [task didReceiveResponse:response];
        [task didReceiveData:data];
        [task didFinish];
    });
}

- (void)webView:(WKWebView *)webView stopURLSchemeTask:(id<WKURLSchemeTask>)task {
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark WKScriptMessageHandler
- (void)userContentController:(nonnull WKUserContentController *)userContentController didReceiveScriptMessage:(nonnull WKScriptMessage *)message {
    NSLog(@"messgae.body-->%@", message.body);
}

#pragma mark accessories
- (BOOL)canBecomeFirstResponder {
    return YES;
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    if(@selector(copy:) == action
       || @selector(paste:) == action
       || @selector(select:) == action
       || @selector(cut:) == action) {
        return [super canPerformAction:action withSender:sender];
    }
    return NO;
}

static NSString *const html = @""
"<html>"
"   <head>"
"       <script>"
"           function postMyMessage() {"
"               var message = { 'message' : 'Hello, World!', 'numbers' : [ 1, 2, 3 ] };"
"               window.webkit.messageHandlers.myScript.postMessage(message);"
"           }\n\n"
""
"           function postMyMessage1() {"
"               var message = { 'message' : 'Hello, World!', 'numbers' : [ 1, 2, 3 ] };"
"               window.webkit.messageHandlers.myScript.postMessage(message);"
"           }\n\n"
""
"           function show_alert() {"
"               var a = 1;"
"               alert('第' + a + '行');"
"           }\n\n"
""
"           function show_confirm() {"
"               var result = confirm('是否删除！');"
"               if(result) {"
"                   alert('删除成功！');"
"               } else {"
"                   alert('不删除！');"
"               }"
"           }\n\n"
""
"           function show_prompt() {"
"               var value = prompt('输入你的名字：', '默认名字');"
"               if(value == null) {"
"                   alert('你取消了输入！');"
"               } else if(value == '') {"
"                   alert('姓名输入为空，请重新输入！');"
"                   show_prompt();"
"               } else {"
"                   alert('你好，'+ value);"
"               }"
"           }\n\n"
"       </script>"
"   </head>"
"   <body>"
"       aaaaaa"
"       <br/><br/>"

"       <a href='https://www.baidu.com'>https://www.baidu.com</a> <br/><br/>"
""
"       <a href='#' onclick='postMyMessage();'>Post my message to WKWebView</a> <br/><br/>"
""
"       <input id='alert_button' type='button' value='alert' onclick='show_alert();'/> <br/>"
"       <input id='confirm_button' type='button' value='confirm' onclick='show_confirm();'/> <br/>"
"       <input id='prompt_button' type='button' value='prompt' onclick='show_prompt();'/>  <br/><br/>"
""
"       <div contenteditable='true'"
"           aaaaaaaaaaaaaaaaaaaaaaaaaa<br>"
"           bbbbbbbbbbbbbbbbbbbbbbbbbb<br>"
"           cccccccccccccccccccccccccc<br>"
"           dddddddddddddddddddddddddd<br>"
"           <img src='myscheme://gaga' alt='上海鲜花港 - 郁金香'/> <br/><br/>"
"           aaaaaaaaaaaaaaaaaaaaaaaaaa<br>"
"           bbbbbbbbbbbbbbbbbbbbbbbbbb<br>"
"           上海鲜花港郁金香<br>"
"           我们是包装设计接班人<br>"
"           cccccccccccccccccccccccccc<br>"
"           dddddddddddddddddddddddddd<br>"
"       </div>"
""
"   </body>"
"</html>";



@end
