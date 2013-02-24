//
//  SettingsViewController.m
//  SlideViewController
//
//  Created by Andrew Carter on 12/18/11.

#import "SettingsViewController.h"

@implementation SettingsViewController

- (void)loadView {
    // Initializes UIView object
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 460.0f)];
    
    // Sets background color of UIView object
    view.backgroundColor = [UIColor darkGrayColor];
    
    // Sets view object to private view object
    self.view = [view autorelease];
    
}

- (void)viewDidLoad {
    // Sets navigation item title as "Settings"
    self.navigationItem.title = @"Settings";
    
    // Initializes UILabel object, width is 20points narrower than view (300 vs 320),
    //    starts 10 points right of edge.
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10.0f, 0.0f, 300.f, 460.0f)];
    
    // Sets UILabel properties, number of lines, alignment, and text
    label.backgroundColor = [UIColor lightGrayColor];
    label.numberOfLines = 0;
    label.textAlignment = UITextAlignmentCenter;
    label.text = @"This UIViewController was loaded without a nib";
    
    // Add lable as subview of view object
    [self.view addSubview:label];
    [label release];
    
}

@end
