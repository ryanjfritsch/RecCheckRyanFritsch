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



- (void)handleTapPress:(UIGestureRecognizer *)gestureRecognizer
{
    
    //if (gestureRecognizer.state != UIGestureRecognizerStateBegan)
        //return;
    
    [self clearPins];
    
    CGPoint touchPoint = [gestureRecognizer locationInView:self.mapView];
    CLLocationCoordinate2D touchMapCoordinate = [self.mapView convertPoint:touchPoint toCoordinateFromView:self.mapView];
    
    //MKPlacemark *placeM = [[MKPlacemark alloc] initWithCoordinate:touchMapCoordinate addressDictionary:nil];
    
    MapPin *pin = [[MapPin alloc] init];
    pin.coordinate = touchMapCoordinate;
    
    self.longit = pin.coordinate.longitude;
    self.latit = pin.coordinate.latitude;
    
    [self.mapView addAnnotation:pin]; //adds pin to map
    
    
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
        
        NSLog(@"NO PINS");
        
    }
    
    else{
        
        UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"Name Pin" message:@"Please name the location of the pin you would like to save:" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"Save" style:UIAlertActionStyleDefault
                                                   handler:^(UIAlertAction * action) {
                                                       
                                                        self.pinName = alert.textFields.firstObject.text;
                                                       
                                                       PFObject *sPin = [PFObject objectWithClassName:@"SavedPin"];
                                                       PFGeoPoint *point = [PFGeoPoint geoPointWithLatitude:self.latit longitude:self.longit];
                                                       
                                                       sPin[@"location"] = point;
                                                       sPin[@"name"] = self.pinName;
                                                       
                                                       [sPin saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                                                           if (succeeded) {
                                                               [self clearPins];
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

        
        NSLog(@"PIN SAVED");
        
        
        /*
        PFObject *sPin = [PFObject objectWithClassName:@"SavedPin"];
        PFGeoPoint *point = [PFGeoPoint geoPointWithLatitude:self.latit longitude:self.longit];
        
        sPin[@"location"] = point;
        sPin[@"name"] = self.pinName;
        
        [sPin saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (succeeded) {
                // The object has been saved.
            } else {
                // There was a problem, check error.description
            }
        }];
         */

        
        
    }
    
    
    /*
    PFObject *sPin = [PFObject objectWithClassName:@"SavedPin"];
    
    PFGeoPoint *point = [PFGeoPoint geoPointWithLatitude:40.0 longitude:-30.0];
    
    sPin[@"location"] = point;
    
    //sPin[@"time"] = @1337;
    //sPin[@"playerName"] = @"Sean Plott";
    //sPin[@"cheatMode"] = @NO;
    
    [sPin saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            // The object has been saved.
        } else {
            // There was a problem, check error.description
        }
    }];

    */
    
    
    
}








- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
