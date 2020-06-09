//
//  MapViewController.swift
//  PoloTravel
//
//  Created by Nael Messaoudene on 03/05/2020.
//  Copyright © 2020 PoloTeam. All rights reserved.
//

import UIKit
import Mapbox
import MapboxDirections
import MapboxCoreNavigation
import MapboxNavigation

class MapViewController: UIViewController, MGLMapViewDelegate {

    var alertService = AlertService()
    var mapView: NavigationMapView!
    var navigateButton: BasicButton!
    var directionsRoute: Route?
    let apparitionDelay = 2.5
    var polobtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        
        mapView = NavigationMapView(frame: view.bounds, styleURL: MGLStyle.lightStyleURL)
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        view.addSubview(mapView)
        
        mapView.delegate = self
        mapView.showsUserLocation = true
        mapView.setUserTrackingMode(.follow, animated: true)
        customNavigateButton()
        poloButton()
        
        TravelService().currentTravel(){result  in
            
            if let user = result {
                //print(user.daysDatas[0].morningActivity.localization[0])
            
                
                
                let numberDays = user.daysDatas.count
                for currentTravel in user.daysDatas{
                    print("start")
                   // print(currentTravel)
                    
            
                    for item in currentTravel.items{
                        let header:String? = item.value(forKey: "header") as? String
                        
                        if let head = header{
                            print(head)
                        }
                    }
                    
                    //print(type(of: currentTravel.morningActivity.localization))
                    
                    //print(currentTravel.morningActivity.localization)
                    print("end")
                }
                print(numberDays)
            }
        }
        
        displayAsyncPopUp()
        
        // Do any additional setup after loading the view.
    }
    
    public typealias GeoPoint = CLLocationCoordinate2D

    
    func displayAsyncPopUp(){

        DispatchQueue.main.asyncAfter(deadline: .now() + apparitionDelay ){

            self.present(Alert.alert, animated: true)
            Alert.alert.actionButton.addTarget(self, action: #selector(self.switchText), for: .touchUpInside)
            Alert.alert.ratingStackView.isHidden = true
        }

    }
    
    var counter = 0
    var countItems = 0
    
    @objc func switchText(sender: BasicButton!){

        counter += 1

        switch counter {
        case 1:
            Alert.body?.text = "Laisse ton téléphone de côté et on se retrouve après."
            Alert.title?.text = "Profite de ton activité"
            Alert.button?.setTitle("Activité est fini", for: .normal)
        case 2:
            Alert.body?.text = "Ton activité est terminée !"
            Alert.title?.text = "Comment l'as tu trouvé ?"
            Alert.alert.ratingStackView.isHidden = false
            Alert.alert.actionButton.isHidden = true
            counter = 0
        default:
           break
        }
        
        print(counter)
        
        }
    
    func poloButton(){
        polobtn = UIButton(type: .custom)
        polobtn.frame = CGRect(x:(view.frame.width / 8) , y: view.frame.height - 180, width: 60, height:60 )
        
        if let image = UIImage(named: "polo-tete"){
            polobtn.setImage(image, for: .normal)
        }

        polobtn.addTarget(self, action: #selector(launchPoloTravel(_:)), for: .touchUpInside)
        view.addSubview(polobtn)
    }
    
    @objc func launchPoloTravel(_ sender: UIButton){
        
        
        self.counter += 1
        self.countItems += 1

        
        print(counter)
        
        TravelService().currentTravel(){result  in
                   
            if let user = result {
                
               // let totalDay = user.daysDatas.count
                //let toalItems = user.daysDatas[self.counter].items.count
                
//                if self.counter < totalDay {
//                    print(user.daysDatas[self.counter])
//                }
//                else{
//                    return
//                }
              
                switch self.counter {
                case 1..<5:
                    print(user.daysDatas[0])
                    print(user.daysDatas[0].items.count)
                    
                    print(user.daysDatas[0].items[self.countItems-1])
                    
                    
                    let header:String? = user.daysDatas[0].items[self.countItems-1].value(forKey: "header") as? String
                    let localizations = user.daysDatas[0].items[self.countItems-1].value(forKey: "localization")

                    if let localization = localizations{
                         print(localization)
                        
                        localization
                        
                     }
                    if let head = header{
                         print(head)
                        //Alert.body?.text = "Laisse ton téléphone de côté et on se retrouve après."
                                   Alert.title?.text = head
                     }
                
                    if self.countItems == user.daysDatas[0].items.count{
                        print(" COUNTER EST EGALE A 0 MAINTENANT --------")
                        self.countItems = 0
                    }
                case 5..<9:
                    print(user.daysDatas[1])
                    print(user.daysDatas[1].items.count)
                    
                    print(user.daysDatas[1].items[self.countItems-1])
                    
                    
                    
                    let header:String? = user.daysDatas[0].items[self.countItems-1].value(forKey: "header") as? String
                    let localizations:String? = user.daysDatas[0].items[self.countItems-1].value(forKey: "localization") as? String

                    if let localization = localizations{
                         print(localization)
                        
                        
                     }
                    if let head = header{
                         print(head)
                     }
                    
                      if self.countItems == user.daysDatas[1].items.count{
                          print(" COUNTER EST EGALE A 0 MAINTENANT ////  --------")
                          self.countItems = 0
                      }

                case 9..<14:
                    print(user.daysDatas[2])
                    print(user.daysDatas[2].items.count)

                    print(user.daysDatas[2].items[self.countItems-1])
                         if self.countItems == user.daysDatas[2].items.count{
                             print(" COUNTER EST EGALE A 0 MAINTENANT :: --------")
                             self.countItems = 0
                         }
                case 14..<18:
                    print(user.daysDatas[3])
                    print(user.daysDatas[3].items.count)

                    print(user.daysDatas[3].items[self.countItems-1])
                         if self.countItems == user.daysDatas[3].items.count{
                             print("COUNTER EST EGALE A 0 MAINTENANT ! --------")
                             self.countItems = 0
                         }
                default:
                   break
                }
   
            }
        }
        
          print("kkkkkkk")
      }
    func customNavigateButton(){
        navigateButton = BasicButton(frame: CGRect(x:(view.frame.width/2 ) - 100, y: view.frame.height - 350, width: 200, height:50 ))
        navigateButton.setDarkButton()
        navigateButton.setTitle("NAVIGATE", for: .normal)
        navigateButton.layer.zPosition  = 9
        navigateButton.addTarget(self, action: #selector(navigateButtonPressed(_:)), for: .touchUpInside)
        view.addSubview(navigateButton)
    }
    
  
    
    @objc func navigateButtonPressed(_ sender: BasicButton){
        mapView.setUserTrackingMode(.none, animated: true)

                    
        TravelService().currentTravel(){ result  in
                   
           if let user = result {
          
            let MorningCoord = CLLocationCoordinate2D(latitude: 0.5, longitude: 0.5)
                
                let annotation = MGLPointAnnotation()
                annotation.coordinate = MorningCoord
                annotation.title = "Start Navigation"
                self.mapView.addAnnotation(annotation)
                                    
                self.calculateRoute(from: (self.mapView.userLocation!.coordinate), to: MorningCoord) { (route, error) in
                   if error != nil{
                       print("error getting route")
                    }
                }
            }
        }
    }
    
    
    func calculateRoute(from originCoord:CLLocationCoordinate2D, to destinationCoord: CLLocationCoordinate2D, completion:@escaping (Route?, Error?)-> Void){
        
        let origin = Waypoint(coordinate: originCoord, coordinateAccuracy: -1, name: "Start")
        let destination = Waypoint(coordinate: destinationCoord, coordinateAccuracy: -1, name: "Finish")
        
        let navigationOptions = NavigationRouteOptions(waypoints: [origin,destination], profileIdentifier: .automobileAvoidingTraffic)
        _ = Directions.shared.calculate(navigationOptions, completionHandler: {(waypoints, routes, error) in
            
            self.directionsRoute = routes?.first
            self.drawRoute(route: self.directionsRoute!)
            var coordinateBounce = MGLCoordinateBounds(sw: destinationCoord, ne: originCoord)
            let insets = UIEdgeInsets(top: 50, left: 50, bottom: 50, right: 50)
            let routeCam = self.mapView.cameraThatFitsCoordinateBounds(coordinateBounce, edgePadding: insets)
            
            self.mapView.setCamera(routeCam, animated: true)
            
            print(coordinateBounce)
            
        })
    }
    
    
    func drawRoute(route:Route){
    
        guard route.coordinateCount > 0 else{return}
        
        var routeCoordinates = route.coordinates!
        let polyline = MGLPolylineFeature(coordinates: &routeCoordinates, count: route.coordinateCount)

        if let source = mapView.style?.source(withIdentifier: "route-source") as? MGLShapeSource{
            source.shape = polyline
        } else{
            let source = MGLShapeSource(identifier: "route-source", features: [polyline], options: nil)
            let lineStyle = MGLLineStyleLayer(identifier: "route-style", source: source)
            
            lineStyle.lineColor = NSExpression(forConstantValue: UIColor.red)
            lineStyle.lineWidth = NSExpression(format: "mgl_interpolate:withCurveType:parameters:stops:($zoomLevel, 'linear', nil, %@)",
            [14: 2, 18: 20])
            
            mapView.style?.addSource(source)
            mapView.style?.addLayer(lineStyle)
        }
    }
    
    func mapView(_ mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool {
        return true
    }
    
    func mapView(_ mapView: MGLMapView, tapOnCalloutFor annotation: MGLAnnotation) {
        let navigationVC = NavigationViewController(for: directionsRoute!)
    
        present(navigationVC,animated: true,completion: nil)
        
    }
    
    func mapView(_ mapView: MGLMapView, viewFor annotation: MGLAnnotation) -> MGLAnnotationView? {
    // Substitute our custom view for the user location annotation. This custom view is defined below.
        if annotation is MGLUserLocation && mapView.userLocation != nil {
            return CustomUserLocationAnnotationView()
        }
        return nil
    }

}

