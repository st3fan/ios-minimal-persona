//
//  ViewController.m
//  MinimalPersona
//
//  Created by Stefan Arentz on 2012-08-03.
//
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController
@synthesize resultTextView;

- (void) startBrowserIDWithOrigin: (NSString*) origin
{
    BrowserIDViewController* browserIDViewController = [[BrowserIDViewController new] autorelease];
    if (browserIDViewController != nil)
    {
        browserIDViewController.origin = origin;
        browserIDViewController.delegate = self;
        
        UINavigationController* navigationController = [[[UINavigationController alloc] initWithRootViewController: browserIDViewController] autorelease];
        if (navigationController != nil)
        {
            navigationController.modalPresentationStyle = UIModalPresentationFullScreen;
            [self presentModalViewController: navigationController animated: YES];
        }
    }
}

- (void) browserIDViewController:(BrowserIDViewController *)browserIDViewController didSucceedWithAssertion:(NSString *)assertion
{
	[browserIDViewController dismissModalViewControllerAnimated: YES];
	self.resultTextView.text = assertion;
}

- (void) browserIDViewController:(BrowserIDViewController *)browserIDViewController didFailWithReason:(NSString *)reason
{
	self.resultTextView.text = @"Fail";
	[browserIDViewController dismissModalViewControllerAnimated: YES];
}

- (void) browserIDViewControllerDidCancel: (BrowserIDViewController*) browserIDViewController
{
	self.resultTextView.text = @"Cancelled";
	[browserIDViewController dismissModalViewControllerAnimated: YES];
}

#pragma mark -

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload
{
    [self setResultTextView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

- (IBAction)clearCaches:(id)sender
{
	self.resultTextView.text = @"";

    [[NSURLCache sharedURLCache] removeAllCachedResponses];

    for(NSHTTPCookie *cookie in [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies]) {
        [[NSHTTPCookieStorage sharedHTTPCookieStorage] deleteCookie: cookie];
    }
}

- (IBAction)startPersonaFlow:(id)sender
{
    [self startBrowserIDWithOrigin: @"http://myfavoritebeer.org"];
}

- (void)dealloc {
    [resultTextView release];
    [super dealloc];
}
@end
