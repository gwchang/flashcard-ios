//
//  MySlideViewController.m
//  SlideViewController
//
//  Created by Andrew Carter on 12/18/11.
//  Modified by Gary Chang on 02/23/13.

#import "MySlideViewController.h"

#import "HomeViewController.h"
#import "SubjectViewController.h"
#import "SettingsViewController.h"

@implementation MySlideViewController

// _datasource is the mother container of all data in the app

@synthesize datasource = _datasource;

- (NSMutableDictionary *) initDictionaryForSubject:(NSString*)title
                                         withImage:(NSString*)image
                                          withName:(NSString*)name
                                         withCount:(NSString*)count {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:title
             forKey:kSlideViewControllerViewControllerTitleKey];
    [dict setObject:[SubjectViewController class]
             forKey:kSlideViewControllerViewControllerClassKey];
    [dict setObject:@"SubjectViewController"
             forKey:kSlideViewControllerViewControllerNibNameKey];
    [dict setObject:[UIImage imageNamed:image]
             forKey:kSlideViewControllerViewControllerIconKey];
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    [userInfo setObject:name forKey:@"name"];
    [userInfo setObject:count forKey:@"count"];
    [dict setObject:userInfo
             forKey:kSlideViewControllerViewControllerUserInfoKey];
    
    return [dict retain];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        
        //creating _searchDatasource for later use!
        _searchDatasource = [NSMutableArray new];
        
        NSMutableArray *datasource = [NSMutableArray array];
        
        /*
        Here's the fun part. What we need to do is creat a datasource array that uses this structure
         
         <Array>
            <Dictionary><!--represents a section in the table-->
                
                <!--This will be displayed as the text in section header. You could also use kSlideViewControllerSectionTitleNoTitle for the value-->
                <key>kSlideViewControllerSectionTitleKey</key>
                <value>My Section Header Text</value>
            
                <!--This will be the rows of that section.-->
                <key>kSlideViewControllerSectionViewControllersKey</key>
                <value>
                    <Array>
         
                        <Dictionary>
         
                            <!--this will be the title for the row-->
                            <key>kSlideViewControllerViewControllerTitleKey</key>
                            <value>My Text</value>
         
                            <!--This is the view controller class that should be created / displayed when this row is clicked-->
                            <key>kSlideViewControllerViewControllerClassKey</key>
                            <value>[MyViewControllerSubclass class]</value>
                            
                            <!--If you're using nibs, include the nib name in this key-->
                            <key>kSlideViewControllerViewControllerNibNameKey</key>
                            <value>MyViewControllerSubclass</value>
                            
                            <!--Include a UIImage with this key to have an icon for the row -->
                            <key>kSlideViewControllerViewControllerIconKey</key>
                            <value>*UIImage*</value>
         
                            <!--This gets passed along with the configureViewController:userInfo: method if you implement it-->
                            <key>kSlideViewControllerViewControllerUserInfoKey</key>
                            <value>anything you want</value>
         
                        </Dictionary>
         
                    </Array>
                </value>
         
            </Dictionary><!--end table section-->
         </Array>
        
         
         */
        // Section 1: HomeViewController
        NSMutableDictionary *sectionOne = [NSMutableDictionary dictionary];
        [sectionOne setObject:kSlideViewControllerSectionTitleNoTitle forKey:kSlideViewControllerSectionTitleKey];
        
        NSMutableDictionary *homeViewControllerDictionary = [NSMutableDictionary dictionary];
        [homeViewControllerDictionary setObject:@"Home" forKey:
            kSlideViewControllerViewControllerTitleKey];
        [homeViewControllerDictionary setObject:@"HomeViewController" forKey:kSlideViewControllerViewControllerNibNameKey];
        [homeViewControllerDictionary setObject:[HomeViewController class] forKey:kSlideViewControllerViewControllerClassKey];
        
        [sectionOne setObject:[NSArray arrayWithObject:homeViewControllerDictionary] forKey:kSlideViewControllerSectionViewControllersKey];
        
        [datasource addObject:sectionOne];
        
        // Section 2
        //   The userInfo dicationry is passed to configureViewController's userInfo
        NSMutableDictionary *sectionTwo = [NSMutableDictionary dictionary];
        [sectionTwo setObject:@"Subjects" forKey:kSlideViewControllerSectionTitleKey];

        // Subject 1
        NSMutableDictionary *subjectViewControllerOneDictionary =
        [self initDictionaryForSubject:@"Algebra 1"
                             withImage:@"gauss.jpg"
                              withName:@"Algebra 1"
                             withCount:@"25"];
        
        // Subject 2
        NSMutableDictionary *subjectViewControllerTwoDictionary =
        [self initDictionaryForSubject:@"Algebra 2"
                             withImage:@"gauss.jpg"
                              withName:@"Algebra 2"
                             withCount:@"25"];
        
        // Subject 3
        NSMutableDictionary *subjectViewControllerThreeDictionary =
        [self initDictionaryForSubject:@"Trigonometry"
                             withImage:@"gauss.jpg"
                              withName:@"Trigonometry"
                             withCount:@"25"];
        
        // Subject 4
        NSMutableDictionary *subjectViewControllerFourDictionary =
            [self initDictionaryForSubject:@"Geometry"
                                 withImage:@"gauss.jpg"
                                  withName:@"Geometry"
                                 withCount:@"25"];
        
        // Add all subjects to section 2
        [sectionTwo setObject:[NSArray arrayWithObjects:
            subjectViewControllerOneDictionary,
            subjectViewControllerTwoDictionary,
            subjectViewControllerThreeDictionary,
            subjectViewControllerFourDictionary, nil]
                    forKey:kSlideViewControllerSectionViewControllersKey];
        
        [datasource addObject:sectionTwo];
        
        
        // Section 3
        NSMutableDictionary *sectionThree = [NSMutableDictionary dictionary];
        [sectionThree setObject:@"" forKey:kSlideViewControllerSectionTitleKey];
        
        NSMutableDictionary *settingsViewControllerDictionary = [NSMutableDictionary  dictionary];
        [settingsViewControllerDictionary setObject:@"Settings" forKey:kSlideViewControllerViewControllerTitleKey];
        [settingsViewControllerDictionary setObject:[SettingsViewController class] forKey:kSlideViewControllerViewControllerClassKey];
        
        [sectionThree setObject:[NSArray arrayWithObject:settingsViewControllerDictionary] forKey:kSlideViewControllerSectionViewControllersKey];
        
        [datasource addObject:sectionThree];
        
        _datasource = [datasource retain];
        
    }
    
    return self;
}

- (void)dealloc {
    
    [_datasource release];
    [_searchDatasource release];
    
    [super dealloc];
    
}

- (UIViewController *)initialViewController {
    
    HomeViewController *homeViewController = [[HomeViewController alloc] initWithNibName:@"HomeViewController" bundle:nil];
    
    return [homeViewController autorelease];
    
}

- (NSIndexPath *)initialSelectedIndexPath {
    
    return [NSIndexPath indexPathForRow:0 inSection:0];
    
}

- (void)configureViewController:(UIViewController *)viewController
                       userInfo:(id)userInfo {
    
    // Check if UIViewController is of SubjectViewController class
    if ([viewController isKindOfClass:[SubjectViewController class]]) {
        
        // User info is a NSDictionary
        NSDictionary *info = (NSDictionary *)userInfo;
        SubjectViewController *subjectViewController = (SubjectViewController *)viewController;
        subjectViewController.name = [info objectForKey:@"name"];
        subjectViewController.age = [info objectForKey:@"count"];
        
        // Set navigationItem's title to name provided in userInfo
        subjectViewController.navigationItem.title = [info objectForKey:@"name"];
        
    }
    
}

- (void)configureSearchDatasourceWithString:(NSString *)string {

    NSArray *searchableControllers = [[[self datasource] objectAtIndex:1] objectForKey:kSlideViewControllerSectionViewControllersKey];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"slideViewControllerViewControllerTitle CONTAINS[cd] %@", string];
    [_searchDatasource setArray:[searchableControllers filteredArrayUsingPredicate:predicate]];
    
}

- (NSArray *)searchDatasource  {
    
    return _searchDatasource;
}


@end
