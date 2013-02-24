//
//  SubjectViewController.h
//  SlideViewController
//
//  Created by Andrew Carter on 12/18/11.

#import <UIKit/UIKit.h>

@interface SubjectViewController : UIViewController {
    
    IBOutlet UILabel *_nameLabel;
    IBOutlet UILabel *_ageLabel;
    NSString *_name;
    NSString *_age;
}

@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *age;

- (IBAction)detailsButtonPressed:(id)sender;

@end
