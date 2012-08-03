/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#import <UIKit/UIKit.h>

@class BrowserIDViewController;

@protocol BrowserIDViewControllerDelegate <NSObject>

- (void) browserIDViewController: (BrowserIDViewController*) browserIDViewController didFailWithReason: (NSString*) reason;
- (void) browserIDViewController: (BrowserIDViewController*) browserIDViewController didSucceedWithAssertion: (NSString*) assertion;
- (void) browserIDViewControllerDidCancel: (BrowserIDViewController*) browserIDViewController;

@end

@interface BrowserIDViewController : UIViewController <UIWebViewDelegate> {
  @private
	UIWebView* _webView;
  @private
    id<BrowserIDViewControllerDelegate> _delegate;
	NSString* _origin;
}

@property (nonatomic,assign) IBOutlet UIWebView* webView;

@property (nonatomic,assign) id<BrowserIDViewControllerDelegate> delegate;
@property (nonatomic,retain) NSString* origin;

@end
