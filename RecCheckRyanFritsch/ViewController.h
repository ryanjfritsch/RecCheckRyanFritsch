//
//  ViewController.h
//  RecCheckRyanFritsch
//
//  Created by Ryan Fritsch on 1/6/16.
//  Copyright © 2016 Ryan Fritsch. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <MapKit/MapKit.h>

@interface ViewController : UIViewController <MKMapViewDelegate, CLLocationManagerDelegate>


@property (strong, nonatomic) MKMapView *mapView;

@property (strong, nonatomic) CLLocationManager *locMan;

@property (weak, nonatomic) IBOutlet UIButton *coordList;


@end

