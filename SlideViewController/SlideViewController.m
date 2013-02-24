//
//  SlideViewController.m
//  SlideViewController
//
//  Created by Andrew Carter on 12/18/11.
/*
 Copyright (c) 2011 Andrew Carter
 
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

#import "SlideViewController.h"
#import <QuartzCore/QuartzCore.h>

#define kSVCLeftAnchorX                 100.0f
#define kSVCRightAnchorX                190.0f
#define kSVCSwipeNavigationBarOnly      YES

//******************************************************************************
// SlideViewNavigationBar
//******************************************************************************
@interface SlideViewNavigationBar : UINavigationBar {
@private
    
    id <SlideViewNavigationBarDelegate> _slideViewNavigationBarDelegate;
    
}

@property (nonatomic, assign) id <SlideViewNavigationBarDelegate> slideViewNavigationBarDelegate;

@end

@implementation SlideViewNavigationBar

@synthesize slideViewNavigationBarDelegate = _slideViewNavigationBarDelegate;

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    [super touchesBegan:touches withEvent:event];
    
    [self.slideViewNavigationBarDelegate slideViewNavigationBar:self touchesBegan:touches withEvent:event];
    
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    
    [super touchesMoved:touches withEvent:event];
    
    [self.slideViewNavigationBarDelegate slideViewNavigationBar:self touchesMoved:touches withEvent:event];

}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
    [super touchesEnded:touches withEvent:event];
    
    [self.slideViewNavigationBarDelegate slideViewNavigationBar:self touchesEnded:touches withEvent:event];
    
}

@end

//******************************************************************************
// SlideViewTableCell
//******************************************************************************

@interface SlideViewTableCell : UITableViewCell {
@private
    
}
@end

@implementation SlideViewTableCell 

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        UIImageView *background = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 44.0f)];
        [background setImage:[[UIImage imageNamed:@"cell_background"] stretchableImageWithLeftCapWidth:0.0f topCapHeight:0.0f]];
        self.backgroundView = background;
        [background release];
        
        UIImageView *selectedBackground = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 44.0f)];
        [selectedBackground setImage:[[UIImage imageNamed:@"cell_selected_background"] stretchableImageWithLeftCapWidth:0.0f topCapHeight:0.0f]];
        self.selectedBackgroundView = selectedBackground;
        [selectedBackground release];
        
        self.textLabel.textColor = [UIColor colorWithRed:190.0f/255.0f green:197.0f/255.0f blue:212.0f/255.0f alpha:1.0f];
        self.textLabel.highlightedTextColor = self.textLabel.textColor;
        self.textLabel.shadowColor = [UIColor colorWithRed:33.0f/255.0f green:38.0f/255.0f blue:49.0f/255.0f alpha:1.0f];
        self.textLabel.shadowOffset = CGSizeMake(0.0f, 1.0f);
        self.textLabel.backgroundColor = [UIColor clearColor];
        self.textLabel.font = [UIFont fontWithName:@"Helvetica" size:16.0f];
        
        self.imageView.clipsToBounds = YES;
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
        
    }
    
    return self;
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    self.imageView.frame = CGRectMake(5.0f, 5.0f, 34.0f, 34.0f);
    
}

@end

//******************************************************************************
// SlideViewController
//******************************************************************************

@implementation SlideViewController

@synthesize delegate = _delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:@"SlideViewController" bundle:nil];
    if (self) {
                
        _touchView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 44.0f)];
        _touchView.exclusiveTouch = NO;
        
        _overlayView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 44.0f, 320.0f, 416.0f)];
        
        _slideNavigationControllerState = kSlideNavigationControllerStateNormal;
        
    }
    return self;
}

- (void)dealloc {
    
    [_touchView release];
    [_overlayView release];
    [_slideNavigationController release];
    
    [super dealloc];
    
}

#pragma mark - View Lifecycle

- (void)viewDidLoad {
    
    if (![self.delegate respondsToSelector:@selector(configureSearchDatasourceWithString:)] || ![self.delegate respondsToSelector:@selector(searchDatasource)]) {
        _searchBar.hidden = YES;
        _tableView.frame = CGRectMake(0.0f, 0.0f, 320.0f, 460.0f);
    }
    
    // Initialize UINavigationController* _slideNavigationController
    _slideNavigationController.view.layer.shadowColor = [[UIColor blackColor] CGColor];
    _slideNavigationController.view.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
    _slideNavigationController.view.layer.shadowRadius = 4.0f;
    _slideNavigationController.view.layer.shadowOpacity = 0.75f;
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:_slideNavigationController.view.bounds cornerRadius:4.0];
    _slideNavigationController.view.layer.shadowPath = path.CGPath;
    
    // Initialize navigationBar
    [(SlideViewNavigationBar *)_slideNavigationController.navigationBar setSlideViewNavigationBarDelegate:self];
    
    // Initialize searchBar
    UIImage *searchBarBackground = [UIImage imageNamed:@"search_bar_background"];
    [_searchBar setBackgroundImage:[searchBarBackground stretchableImageWithLeftCapWidth:0 topCapHeight:0]];
    
    // Initialize initial view controller
    UIViewController *initalViewController = [self.delegate initialViewController];
    
    // Initialize menu button, hookup, and add to navigationItem
    [self configureViewController:initalViewController];
    
    // Set navigation controller view controllers to initial view controller
    [_slideNavigationController setViewControllers:[NSArray arrayWithObject:initalViewController] animated:NO];
    
    [self addChildViewController:_slideNavigationController];
    
    // Add current navigation controllers' view as subview of current view
    [self.view addSubview:_slideNavigationController.view];
    
    if ([self.delegate respondsToSelector:@selector(initialSelectedIndexPath)])
        [_tableView selectRowAtIndexPath:[self.delegate initialSelectedIndexPath] animated:NO scrollPosition:UITableViewScrollPositionTop];
    
}

#pragma mark - Instance Methods

- (void)configureViewController:(UIViewController *)viewController {
    
    // This is where the "Menu" button is instantiated and
    // hooked up to "menuBarButtonItemPressed"
    // and set as the left bar button item in the "viewController"'s nagivationItem
    
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc]
        initWithTitle:@"Menu"
        style:UIBarButtonItemStylePlain
        target:self
        action:@selector(menuBarButtonItemPressed:)];
    viewController.navigationItem.leftBarButtonItem = [barButtonItem autorelease];
    
}

// --------------------------------------------------------------------
// Menu Bar Button Pressed
// --------------------------------------------------------------------
// - This methods is hooked up as the callback of barButtonItem in menuBarButtonItemPressed
// - slideIn
// - slideOut
// 

- (void)menuBarButtonItemPressed:(id)sender {
    
    // If PEEKING, then SLIDE-IN
    if (_slideNavigationControllerState == kSlideNavigationControllerStatePeeking) {
        
        [self slideInSlideNavigationControllerView];
        return;
        
    }
    
    // Get current view controller fro _slideNavigationController.viewControllers array
    UIViewController *currentViewController = [[_slideNavigationController viewControllers] objectAtIndex:0];
    
    // If not PEEKING, then SLIDE-OUT
    if ([currentViewController conformsToProtocol:@protocol(SlideViewControllerSlideDelegate)] && [currentViewController respondsToSelector:@selector(shouldSlideOut)]) {
        
        // Current view controller implements (shouldSlideOut), so we only SLIDE-OUT if that
        // method returns TRUE
        if ([(id <SlideViewControllerSlideDelegate>)currentViewController shouldSlideOut]) {
            
            [self slideOutSlideNavigationControllerView];
            
        }
        
    } else {
        // Current view controller does NOT implement (shouldSlideOut), so we SLIDE-OUT
        [self slideOutSlideNavigationControllerView];
        
    }
    
}

// --------------------------------------------------------------------
// Slide Out SlideNavigationControllerView
// --------------------------------------------------------------------
//
- (void)slideOutSlideNavigationControllerView {
    
    // Set state to PEEKING
    _slideNavigationControllerState = kSlideNavigationControllerStatePeeking;

    [UIView animateWithDuration:0.2 delay:0.0f options:UIViewAnimationOptionCurveEaseInOut  | UIViewAnimationOptionBeginFromCurrentState animations:^{
        
        // Slide animation
        _slideNavigationController.view.transform = CGAffineTransformMakeTranslation(260.0f, 0.0f);
        
    } completion:^(BOOL finished) {
        
        // Add overlay view as subview of navigation controller view
        [_slideNavigationController.view addSubview:_overlayView];
        
    }];
    
}

// --------------------------------------------------------------------
// Slide In SlideNavigationControllerView
// --------------------------------------------------------------------
//
- (void)slideInSlideNavigationControllerView {
            
    [UIView animateWithDuration:0.2 delay:0.0f options:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionBeginFromCurrentState animations:^{
        
        // Slide animation
        _slideNavigationController.view.transform = CGAffineTransformIdentity;
        
    } completion:^(BOOL finished) {
        
        // Cancel searching
        [self cancelSearching];
        
        // Set state to NORMAL
        _slideNavigationControllerState = kSlideNavigationControllerStateNormal;
        
        // Remove overlay view from super view
        [_overlayView removeFromSuperview];
        
    }];
    
}

// --------------------------------------------------------------------
// Slide Off Screen SlideNavigationControllerView
// --------------------------------------------------------------------
// - Transition to SEARCH state
// - Used only in searchBarTextDidBeginEditing
// 
- (void)slideSlideNavigationControllerViewOffScreen {
    
    // Set state to SEARCH
    _slideNavigationControllerState = kSlideNavigationControllerStateSearching;

    [UIView animateWithDuration:0.2 delay:0.0f options:UIViewAnimationOptionCurveEaseInOut  | UIViewAnimationOptionBeginFromCurrentState animations:^{
        
        _slideNavigationController.view.transform = CGAffineTransformMakeTranslation(320.0f, 0.0f);
        
    } completion:^(BOOL finished) {
        
        // Add overlay view as subview to navigation controller's view
        [_slideNavigationController.view addSubview:_overlayView];
        
    }];
    
}

#pragma mark UITouch Logic

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {

    NSLog(@"touchesBegan");
    
    if (_slideNavigationControllerState == kSlideNavigationControllerStateDrilledDown || _slideNavigationControllerState == kSlideNavigationControllerStateSearching)
        return;
    
    UITouch *touch = [touches anyObject];
    
    _startingDragPoint = [touch locationInView:self.view];
    NSLog(@"startingDragPoint: %f", _startingDragPoint.y);
    
    if ((CGRectContainsPoint(_slideNavigationController.view.frame, _startingDragPoint)) && _slideNavigationControllerState == kSlideNavigationControllerStatePeeking) {
        
        _slideNavigationControllerState = kSlideNavigationControllerStateDragging;
        _startingDragTransformTx = _slideNavigationController.view.transform.tx;
    }
    
    // we only trigger a swipe if either navigationBarOnly is deactivated
    // or we swiped in the navigationBar
    if (!kSVCSwipeNavigationBarOnly || _startingDragPoint.y <= 44.0f) {
        
        _slideNavigationControllerState = kSlideNavigationControllerStateDragging;
        _startingDragTransformTx = _slideNavigationController.view.transform.tx;

    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    
    if (_slideNavigationControllerState != kSlideNavigationControllerStateDragging)
        return;
    
    UITouch *touch = [touches anyObject];
    
    CGPoint location = [touch locationInView:self.view];
  
    [UIView animateWithDuration:0.05f delay:0.0f options:UIViewAnimationOptionCurveLinear | UIViewAnimationOptionBeginFromCurrentState animations:^{

        _slideNavigationController.view.transform = CGAffineTransformMakeTranslation(MAX(_startingDragTransformTx + (location.x - _startingDragPoint.x), 0.0f), 0.0f);

    } completion:^(BOOL finished) {
        
    }];
    
      
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
    if (_slideNavigationControllerState == kSlideNavigationControllerStateDragging) {
        UITouch *touch = [touches anyObject];
        CGPoint endPoint = [touch locationInView:self.view];
        
        // Check in which direction we were dragging
        if (endPoint.x < _startingDragPoint.x) {
            if (_slideNavigationController.view.transform.tx <= kSVCRightAnchorX) {
                [self slideInSlideNavigationControllerView];
            } else {
                [self slideOutSlideNavigationControllerView]; 
            }
        } else {
            if (_slideNavigationController.view.transform.tx >= kSVCLeftAnchorX) {
                [self slideOutSlideNavigationControllerView];
            } else {
                [self slideInSlideNavigationControllerView];
            }
        }
    }
    
}

- (void)cancelSearching {
    
    if (_slideNavigationControllerState == kSlideNavigationControllerStateSearching) {
        [_searchBar resignFirstResponder];
        
        // Set state to NORMAL
        _slideNavigationControllerState = kSlideNavigationControllerStateNormal;
        
        // Empty search bar text
        _searchBar.text = @"";
        
        // Reload data in table view
        [_tableView reloadData];
    }
    
}

#pragma mark SlideViewNavigationBarDelegate Methods

- (void)slideViewNavigationBar:(SlideViewNavigationBar *)navigationBar touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    [self touchesBegan:touches withEvent:event];
    
}

- (void)slideViewNavigationBar:(SlideViewNavigationBar *)navigationBar touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    
    [self touchesMoved:touches withEvent:event];
    
}

- (void)slideViewNavigationBar:(SlideViewNavigationBar *)navigationBar touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
    [self touchesEnded:touches withEvent:event];
    
}

#pragma mark UINavigationControlerDelgate Methods 
// --------------------------------------------------------------------
// navigationController
// --------------------------------------------------------------------
//
- (void)navigationController:(UINavigationController *)navigationController
       didShowViewController:(UIViewController *)viewController
                    animated:(BOOL)animated {
    
    [self cancelSearching];
    
    if ([[navigationController viewControllers] count] > 1) {
        
        _slideNavigationControllerState = kSlideNavigationControllerStateDrilledDown;
        
    } else {
        
        _slideNavigationControllerState = kSlideNavigationControllerStateNormal;
        
    }
    
}

#pragma mark UITableViewDelegate / UITableViewDatasource Methods
// --------------------------------------------------------------------
// tableView
// --------------------------------------------------------------------
// - numberOfRowsInSection
// 
- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {

    if (_slideNavigationControllerState == kSlideNavigationControllerStateSearching) {
        return [[self.delegate searchDatasource] count];
    } else {
        return [[[[self.delegate datasource] objectAtIndex:section] objectForKey:kSlideViewControllerSectionViewControllersKey] count];        
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    if (_slideNavigationControllerState == kSlideNavigationControllerStateSearching) {
        return 1;
    } else {
        return [[self.delegate datasource] count];
    }
}

// --------------------------------------------------------------------
// tableView:cellForRowAtIndexPath
// --------------------------------------------------------------------
// 
- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    static NSString *resuseIdentifier = @"SlideViewControllerTableCell";
    
    // SlideViewTableCell implements UITableCellView
    //   - We pull a UITableCellView from a queue in UITableView
    SlideViewTableCell *cell = [tableView dequeueReusableCellWithIdentifier:resuseIdentifier];
    
    if (!cell) {
        
        cell = [[[SlideViewTableCell alloc] initWithStyle:UITableViewCellStyleDefault
                                          reuseIdentifier:resuseIdentifier] autorelease];
    
    }

    // Get DATA SOURCE
    // This dictionary is the data source of the data that we will display in the cell
    NSDictionary *viewControllerDictionary = nil;
    
    if (_slideNavigationControllerState == kSlideNavigationControllerStateSearching) {
        
        // If controller state is SEARCHING, then we use "searchDatasource"
        
        viewControllerDictionary = [[self.delegate searchDatasource] objectAtIndex:indexPath.row];
    } else {
        
        // If controller state is non-SEARCHING, then we use "datasource"
        
        viewControllerDictionary = [[[[self.delegate datasource] objectAtIndex:indexPath.section] objectForKey:kSlideViewControllerSectionViewControllersKey] objectAtIndex:indexPath.row];
    }
    
    cell.textLabel.text = [viewControllerDictionary objectForKey:kSlideViewControllerViewControllerTitleKey];
    
    id icon = [viewControllerDictionary objectForKey:kSlideViewControllerViewControllerIconKey];
    if ([icon isKindOfClass:[UIImage class]]) {
        cell.imageView.image = icon;
    } else {
        cell.imageView.image = nil;
    }
    
    return cell;
    
}

// --------------------------------------------------------------------
// tableView:titleForHeaderInSection
// --------------------------------------------------------------------
// Used in
//   - tableView:viewForHeaderInSection
//   - tableView:heightForHeaderInSection
//

- (NSString *)tableView:(UITableView *)tableView
titleForHeaderInSection:(NSInteger)section {
    
    // If current state is SEARCHING, return nil
    if (_slideNavigationControllerState == kSlideNavigationControllerStateSearching)
        return nil;
    
    // Get DATA SOURCE
    NSDictionary *sectionDictionary = [[self.delegate datasource] objectAtIndex:section];
    
    id title = [sectionDictionary objectForKey:kSlideViewControllerSectionTitleKey];
    if (title) {
        
        NSString *sectionTitle = title;
        
        if ([sectionTitle isEqualToString:kSlideViewControllerSectionTitleNoTitle]) {
            return nil;
        } else {
            return sectionTitle;
        }
    } else {
        return nil;
    }
    
}

// --------------------------------------------------------------------
// tableView:viewForHeaderInSection
// --------------------------------------------------------------------
//
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    // If current state is SEARCHING, return nil
    if (_slideNavigationControllerState == kSlideNavigationControllerStateSearching)
        return nil;
    
    NSString *titleString = [self tableView:tableView titleForHeaderInSection:section];
    
    // If we don't have title, return nil
    if (!titleString)
        return nil;
    
    // UIImageView
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 22.0f)];
    imageView.image = [[UIImage imageNamed:@"section_background"]
                       stretchableImageWithLeftCapWidth:0.0f
                       topCapHeight:0.0f];
    
    // UILabel
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectInset(imageView.frame, 10.0f, 0.0f)];
    titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:12.0f];
    titleLabel.textAlignment = UITextAlignmentLeft;
    
    titleLabel.textColor = [UIColor colorWithRed:125.0f/255.0f green:129.0f/255.0f blue:146.0f/255.0f alpha:1.0f];
    titleLabel.shadowColor = [UIColor colorWithRed:40.0f/255.0f green:45.0f/255.0f blue:57.0f/255.0f alpha:1.0f];
    /*
    titleLabel.textColor = [UIColor redColor];
    titleLabel.shadowColor = [UIColor darkGrayColor];
    */
    
    titleLabel.shadowOffset = CGSizeMake(0.0f, 1.0f);
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.text = titleString;      // Set titleLabel.text to titleString
    [imageView addSubview:titleLabel];  // Add titleLabel to imageView
    [titleLabel release];

    // Return imageView
    return [imageView autorelease];
}

// --------------------------------------------------------------------
// tableView:heightForHeaderInSection
// --------------------------------------------------------------------
//
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if (_slideNavigationControllerState == kSlideNavigationControllerStateSearching) {
        return 0.0f;
    }
    else if ([self tableView:tableView titleForHeaderInSection:section]) {
        return 22.0f;
    } else {
        return 0.0f;
    }
}

// --------------------------------------------------------------------
// tableView:didSelectRowAtIndexPath
// --------------------------------------------------------------------
//
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSLog(@"tableView:didSelectRowAtIndexPath:%@", indexPath);
    
    // Get DATASOURCE dictionary at the indexpath for the appropriate (non) SEARCHING state.
    NSDictionary *viewControllerDictionary = nil;
    
    if (_slideNavigationControllerState == kSlideNavigationControllerStateSearching) {
        viewControllerDictionary = [[self.delegate searchDatasource] objectAtIndex:indexPath.row];
    } else {
        viewControllerDictionary = [[[[self.delegate datasource] objectAtIndex:indexPath.section] objectForKey:kSlideViewControllerSectionViewControllersKey] objectAtIndex:indexPath.row];
    }
    
    // Get viewControllerClass
    Class viewControllerClass = [viewControllerDictionary objectForKey:kSlideViewControllerViewControllerClassKey];
    NSString *nibNameOrNil = [viewControllerDictionary objectForKey:kSlideViewControllerViewControllerNibNameKey];
    UIViewController *viewController = [[viewControllerClass alloc] initWithNibName:nibNameOrNil bundle:nil];
    
    // Call configureViewController on delegate with viewControllerDictionary
    if ([self.delegate respondsToSelector:@selector(configureViewController:userInfo:)])
    {
        id userInfo = [viewControllerDictionary objectForKey:kSlideViewControllerViewControllerUserInfoKey];
        
        // Configure view controller if it's a SubjectViewController
        [self.delegate configureViewController:viewController
                                      userInfo:userInfo];
    }
    
    // Call configureViewController on self
    //   - Instantiate menu button, hookup callbacks, and add to navigationItem
    [self configureViewController:viewController];
    
    [_slideNavigationController setViewControllers:[NSArray arrayWithObject:viewController] animated:NO];
    [viewController release];
    
    [self slideInSlideNavigationControllerView];
    
}

#pragma mark UISearchBarDelegate Methods

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
        
    if ([self.delegate respondsToSelector:@selector(configureSearchDatasourceWithString:)]) {
    
        // Slide controller view off screen, for searches only
        [self slideSlideNavigationControllerViewOffScreen];
        
        [self.delegate configureSearchDatasourceWithString:searchBar.text];
        
        [_tableView reloadData];

    }
    
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    
    if ([self.delegate respondsToSelector:@selector(configureSearchDatasourceWithString:)]) {
        
        [self.delegate configureSearchDatasourceWithString:searchBar.text];
     
        [_tableView reloadData];

    }    

}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    
    [self cancelSearching];
    
    [self slideOutSlideNavigationControllerView];
    
    [_tableView reloadData];
    
}

@end
