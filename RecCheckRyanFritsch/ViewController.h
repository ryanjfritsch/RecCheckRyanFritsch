//
//  ViewController.h
//  RecCheckRyanFritsch
//
//  Created by Ryan Fritsch on 1/6/16.
//  Copyright © 2016 Ryan Fritsch. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <Addressbook/Addressbook.h>

#import "MapPin.h"

@interface ViewController : UIViewController <MKMapViewDelegate, CLLocationManagerDelegate>

@property (strong, nonatomic) MKMapView *mapView;
@property (strong, nonatomic) CLLocationManager *locMan;
@property (weak, nonatomic) IBOutlet UIButton *coordList;
@property (weak, nonatomic) IBOutlet UIButton *savePin;
//@property (strong, nonatomic) CLGeocoder *geocode;
@property (nonatomic) int started;
@property (nonatomic) NSString* pinName;
@property (nonatomic) float longit;
@property (nonatomic) float latit;

@property (nonatomic) BOOL animating;

@property (nonatomic) MapPin* pin;


-(IBAction)savedPin:(UIButton *)sender;


@end

