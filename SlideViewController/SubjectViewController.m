//
//  SubjectViewController.m
//  SlideViewController
//
//  Created by Andrew Carter on 12/18/11.

#import "SubjectViewController.h"

#import "SubjectDetailsViewController.h"

@implementation SubjectViewController

@synthesize name = _name;
@synthesize age = _age;

- (void)dealloc {
    
    [_name release];
    [_age release];
    
    [super dealloc];
    
}

- (void)viewDidLoad {
    // Set the text property of the name/age labels to the name/age self properties
    _nameLabel.text = self.name;
    _ageLabel.text = self.age;
    
}

- (void)viewWillAppear:(BOOL)animated {    
    
} 

- (IBAction)detailsButtonPressed:(id)sender {
    // Push subject details view controller on navigation controller
    
    SubjectDetailsViewController *subjectDetailsViewController = [[SubjectDetailsViewController alloc] initWithNibName:@"SubjectDetailsViewController"
        bundle:nil];
    [self.navigationController pushViewController:subjectDetailsViewController animated:YES];
    [subjectDetailsViewController release];
    
}

@end
