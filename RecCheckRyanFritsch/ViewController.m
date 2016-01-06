//
//  ViewController.m
//  RecCheckRyanFritsch
//
//  Created by Ryan Fritsch on 1/6/16.
//  Copyright © 2016 Ryan Fritsch. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end




@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.locMan = [[CLLocationManager alloc] init];
    self.locMan.delegate = self;
    
    self.started = 0;
    
    self.mapView = [[MKMapView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    
    [self.locMan requestWhenInUseAuthorization];
    [self.mapView setShowsUserLocation:YES];
    [self.mapView setDelegate:self];
    [self.mapView setMapType:MKMapTypeHybrid];
    [self.view addSubview:self.mapView];
    
    
    UILongPressGestureRecognizer *tapR = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(handleLongPress:)];
    tapR.minimumPressDuration = 0.1;
    [self.mapView addGestureRecognizer:tapR];
    //[tapR release];
    
    
    
}




#pragma mark - MKMapViewDelegate Methods

-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation{
    
    if(self.started == 0) //only moves region at initial map loading
    {
        //animated region centering
        [self.mapView setRegion:MKCoordinateRegionMake(userLocation.coordinate, MKCoordinateSpanMake(0.1f, 0.1f)) animated:YES];
    }
    
    self.started = 1;
    
}



- (void)handleLongPress:(UIGestureRecognizer *)gestureRecognizer
{
    
    if (gestureRecognizer.state != UIGestureRecognizerStateBegan)
        return;
    
    [self clearPins];
    
    CGPoint touchPoint = [gestureRecognizer locationInView:self.mapView];
    CLLocationCoordinate2D touchMapCoordinate = [self.mapView convertPoint:touchPoint toCoordinateFromView:self.mapView];
    
    
    MKPlacemark *placeM = [[MKPlacemark alloc] initWithCoordinate:touchMapCoordinate addressDictionary:nil];
    MKMapItem *mapItem = [[MKMapItem alloc] initWithPlacemark:placeM];
    
    CLPlacemark *newP = [[CLPlacemark alloc] initWithPlacemark:placeM];
    
    MapPin *pin = [[MapPin alloc] init];
    pin.coordinate = touchMapCoordinate;
    
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




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
