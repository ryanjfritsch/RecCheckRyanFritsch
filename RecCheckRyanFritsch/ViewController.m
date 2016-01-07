//
//  ViewController.m
//  RecCheckRyanFritsch
//
//  Created by Ryan Fritsch on 1/6/16.
//  Copyright © 2016 Ryan Fritsch. All rights reserved.
//

#import "ViewController.h"
#import <Parse/Parse.h>
#import <Addressbook/Addressbook.h>

@interface ViewController ()

@end




@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.locMan = [[CLLocationManager alloc] init];
    self.locMan.delegate = self;
    
    self.started = 0;
    self.longit = 0;
    self.latit = 0;
    
    self.animating = false;
    
    self.mapView = [[MKMapView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    
    //self.geocode = [[CLGeocoder alloc] init];
    
    [self.locMan requestWhenInUseAuthorization];
    [self.mapView setShowsUserLocation:YES];
    [self.mapView setDelegate:self];
    [self.mapView setMapType:MKMapTypeHybrid];
    [self.view addSubview:self.mapView];
    
    
    UITapGestureRecognizer *tapR = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleTapPress:)];
    [self.mapView addGestureRecognizer:tapR];
    //[tapR release];
    
    
    
}




#pragma mark - MKMapViewDelegate Methods

-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation{
    
    if(self.started == 0) //only moves region at initial map loading
    {
        //animated region centering
        [self.mapView setRegion:MKCoordinateRegionMake(userLocation.coordinate, MKCoordinateSpanMake(0.1f, 0.1f)) animated:NO];
    }
    
    self.started = 1;
    
}


-(IBAction)unwindToMapVC:(UIStoryboardSegue *)unwindSegue{


}



- (void)handleTapPress:(UIGestureRecognizer *)gestureRecognizer
{
    //create a new pin
    
    [self clearPins];
    
    CGPoint touchPoint = [gestureRecognizer locationInView:self.mapView];
    CLLocationCoordinate2D touchMapCoordinate = [self.mapView convertPoint:touchPoint toCoordinateFromView:self.mapView];
    
    //MapPin *pin = [[MapPin alloc] init];
    //pin.coordinate = touchMapCoordinate;
    
    self.longit = touchMapCoordinate.longitude;
    self.latit = touchMapCoordinate.latitude;
    
    if (!self.animating) {
        [self.savePin setImage:[UIImage imageNamed:@"uploadBlue2.png"] forState:UIControlStateNormal];
    }
    
    [self getAddressInformation];
    
    //pin.title = self.pinAddressString;

    //[self.mapView addAnnotation:pin]; //adds pin to map
    
}



-(void)setPinToMap{
    
    CLLocationCoordinate2D temp = CLLocationCoordinate2DMake(self.latit, self.longit);
    
    MapPin *pin = [[MapPin alloc] init];
    pin.coordinate = temp;
    
    pin.title = self.pinAddressString;
    
    [self.mapView addAnnotation:pin]; //adds pin to map


}






- (void)getAddressInformation
{
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    CLLocation *location = [[CLLocation alloc] initWithLatitude:self.latit longitude:self.longit];
    
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        if (error){
            NSLog(@"Geocode failed with error: %@", error);
            return;
        }
        
        if(placemarks && placemarks.count > 0)
        {
            CLPlacemark *topResult = [placemarks objectAtIndex:0];
            
            self.pinAddressString = [NSString stringWithFormat:@"%@ %@, %@ %@",
                                    [topResult subThoroughfare],[topResult thoroughfare],
                                    [topResult locality], [topResult administrativeArea]];
        }
        
        //print address info
        //NSLog(@"%@", self.pinAddressString);
        
        [self setPinToMap];
        
     }];
    
}


- (void)clearPins    //when user adds new pin, clear old pins
{
    id userLocation = [self.mapView userLocation];
    NSMutableArray *pins = [[NSMutableArray alloc] initWithArray:[self.mapView annotations]];
    if ( userLocation != nil ) {
        [pins removeObject:userLocation]; // avoid removing user location off the map
    }
    
    [self.mapView removeAnnotations:pins];
    pins = nil;
}


- (IBAction)savedPin:(UIButton *)sender {
    
    if(self.mapView.annotations.count == 1){
        
        UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"No Pins Placed" message:@"To place a pin, tap anywhere on the map. Once a pin is placed, it may be saved." preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault
                                                   handler:^(UIAlertAction * action) {
                                                       [alert dismissViewControllerAnimated:YES completion:nil];
                                                   }];

        [alert addAction:ok];
        [self presentViewController:alert animated:YES completion:nil];
        
    }
    
    else{
        
        //[self.savePin setImage:[UIImage imageNamed:@"uploadGrey2.png"] forState:UIControlStateNormal];
        
        UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"Name Pin" message:@"Please name the location of the pin you would like to save:" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"Save" style:UIAlertActionStyleDefault
                                                   handler:^(UIAlertAction * action) {
                                                       
                                                        self.pinName = alert.textFields.firstObject.text;
                                                       
                                                       PFObject *sPin = [PFObject objectWithClassName:@"SavedPin"];
                                                       PFGeoPoint *point = [PFGeoPoint geoPointWithLatitude:self.latit longitude:self.longit];
                                                       
                                                       sPin[@"location"] = point;
                                                       sPin[@"name"] = self.pinName;
                                                       sPin[@"street"] = self.pinAddressString;
                                                       
                                                       [sPin saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                                                           if (succeeded) {
                                                               [self.view endEditing:YES];
                                                               [self clearPins];
                                                               [self.savePin setImage:[UIImage imageNamed:@"uploadGreen2.png"] forState:UIControlStateNormal];
                                                               [self fadeSaveButton];
                                                               
                                                           } else {
                                                               // There was a problem, check error.description
                                                           }
                                                       }];
                                                       
                                                       

                                                       
                                                       [alert dismissViewControllerAnimated:YES completion:nil];
                                                       
                                                       
                                                   }];
        UIAlertAction* cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault
                                                       handler:^(UIAlertAction * action) {
                                                           [alert dismissViewControllerAnimated:YES completion:nil];
                                                       }];
        
        [alert addAction:ok];
        [alert addAction:cancel];
        
        [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
            textField.placeholder = @"Location name";
            textField.keyboardType = UIKeyboardTypeDefault;
            
        }];
        
        [self presentViewController:alert animated:YES completion:nil];

        
        
    }
    
    
    
}


- (void)fadeSaveButton {
    
    self.animating = true;
    
    [self.savePin setImage:[UIImage imageNamed:@"uploadBlue2.png"] forState:UIControlStateNormal];
    
    //fade in and out three times
    [UIView animateWithDuration:0.4 animations:^{
        self.savePin.alpha = 0.2;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.4 animations:^{
            self.savePin.alpha = 1.0;
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.4 animations:^{
                self.savePin.alpha = 0.2;
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:0.4 animations:^{
                    self.savePin.alpha = 1.0;
                } completion:^(BOOL finished) {
                    [UIView animateWithDuration:0.4 animations:^{
                        self.savePin.alpha = 0.2;
                    } completion:^(BOOL finished) {
                        
                        //show green as saved
                        [self.savePin setImage:[UIImage imageNamed:@"saved.png"] forState:UIControlStateNormal];
                        
                        [UIView animateWithDuration:0.4 animations:^{
                            self.savePin.alpha = 1.0;
                        } completion:^(BOOL finished) {
                        
                            [UIView animateWithDuration:0.4 delay:2.0 options:UIViewAnimationCurveEaseOut animations:^{
                                self.savePin.alpha = 0.2;
                            } completion:^(BOOL finished) {
                                
                                if(self.mapView.annotations.count == 1){
                                    [self.savePin setImage:[UIImage imageNamed:@"uploadGrey2.png"] forState:UIControlStateNormal];
                                }
                                else{
                                    [self.savePin setImage:[UIImage imageNamed:@"uploadBlue2.png"] forState:UIControlStateNormal];
                                }
                                
                                [UIView animateWithDuration:0.4 animations:^{
                                    self.savePin.alpha = 1.0;
                                } completion:^(BOOL finished) {
                                    self.animating = false;
                                }
                                 ];
                            }];
                        }
                         ];
                    }
                     ];
                }
                 ];
            }
             ];
        }
         ];
    }
    ];
    

    
    
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
