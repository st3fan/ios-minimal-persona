/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#import "BrowserIDViewController.h"

static NSString* kBrowserIDSignInURL = @"https://login.persona.org/sign_in#NATIVE";

@implementation BrowserIDViewController

@synthesize webView = _webView;
@synthesize delegate = _delegate;
@synthesize origin = _origin;

- (void) viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Mozilla Persona";
        
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle: @"Cancel"
        style: UIBarButtonItemStylePlain target: self action: @selector(cancel)] autorelease];

    _webView.delegate = self;
}

- (void) viewWillAppear:(BOOL)animated
{
    [_webView loadRequest: [NSURLRequest requestWithURL: [NSURL URLWithString: kBrowserIDSignInURL]]];
}

- (void) viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL) shouldAutorotateToInterfaceOrientation: (UIInterfaceOrientation) interfaceOrientation
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation == UIInterfaceOrientationPortrait);
    } else {
        return YES;
    }
}

#pragma mark -

- (IBAction) cancel
{
    [_webView stopLoading];
    [_delegate browserIDViewControllerDidCancel: self];
}

#pragma mark -

- (BOOL) webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
	NSURL* url = [request URL];
    
	// The JavaScript side (the code injected in viewDidLoad will make callbacks to this native code by requesting
	// a BrowserIDViewController://callbackname/callback?data=foo style URL. So we capture those here and relay
	// them to our delegate.
	
	if ([[[url scheme] lowercaseString] isEqualToString: @"browseridviewcontroller"])
	{	
		if ([[url host] isEqualToString: @"assertionReady"]) {
			[_delegate browserIDViewController: self didSucceedWithAssertion: [[url query] substringFromIndex: [@"data=" length]]];
		}
		
		else if ([[url host] isEqualToString: @"assertionFailure"]) {
			[_delegate browserIDViewController: self didFailWithReason: [[url query] substringFromIndex: [@"data=" length]]];
		}
	
		return NO;
	}
    	
	return YES;
}

- (void) webViewDidFinishLoad:(UIWebView *)webView
{
    NSLog(@"MOO %@", [webView.request.URL absoluteString]);

	// Insert the code that will setup and handle the BrowserID callback.

	NSString* injectedCodePath = [[NSBundle mainBundle] pathForResource: @"BrowserIDViewController" ofType: @"js"];
	NSString* injectedCodeTemplate = [NSString stringWithContentsOfFile: injectedCodePath encoding:NSUTF8StringEncoding error: nil];
	NSString* injectedCode = [NSString stringWithFormat: injectedCodeTemplate, _origin];

	[_webView stringByEvaluatingJavaScriptFromString: injectedCode];
}

@end
