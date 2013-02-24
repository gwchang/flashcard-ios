//
//  MySlideViewController.h
//  SlideViewController
//
//  Created by Andrew Carter on 12/18/11.

#import "SlideViewController.h"

@interface MySlideViewController : SlideViewController <SlideViewControllerDelegate> {
    
    // There are only 2 datasources in this app.
    //   2. datasource (subjects, settings ,etc)
    //   3. search datasource
    NSArray *_datasource;               // Initialized inside initWithNibName
    NSMutableArray *_searchDatasource;
    
}

/*
 
 @protocol SlideViewControllerDelegate <NSObject>
 @optional
 - (void)configureViewController:(UIViewController *)viewController userInfo:(id)userInfo;
 - (NSIndexPath *)initialSelectedIndexPath;
 - (void)configureSearchDatasourceWithString:(NSString *)string;
 - (NSArray *)searchDatasource;
 @required
 - (UIViewController *)initialViewController;
 - (NSArray *)datasource;
 @end
 
*/

@property (nonatomic, readonly) NSArray *datasource;

- (NSMutableDictionary *) initDictionaryForSubject:(NSString*)title
                                         withImage:(NSString*)image
                                          withName:(NSString*)name
                                         withCount:(NSString*)count;


@end
