//
//  ViewController.h
//  MinimalPersona
//
//  Created by Stefan Arentz on 2012-08-03.
//
//

#import <UIKit/UIKit.h>
#import "BrowserIDViewController.h"

@interface ViewController : UIViewController <BrowserIDViewControllerDelegate>

@property (retain, nonatomic) IBOutlet UITextView *resultTextView;

- (IBAction)clearCaches:(id)sender;
- (IBAction)startPersonaFlow:(id)sender;

@end
