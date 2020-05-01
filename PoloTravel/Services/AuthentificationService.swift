//
//  AuthentificationService.swift
//  PoloTravel
//
//  Created by SOWA KILLIAN on 20/04/2020.
//  Copyright © 2020 PoloTeam. All rights reserved.
//

import FirebaseAuth
import FirebaseFirestore
import UIKit


class AuthentificationService {
    
    let db = Firestore.firestore()
    
    func createUser(email: String, password: String, firstname: String, completionBlock: @escaping (_ success: Bool) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) {(authResult, error) in
            if let user = authResult?.user {
               self.db.collection("pl_users").document(user.uid).setData([
                    "firstname": firstname,
                    "email": email,
                ])
                completionBlock(true)
            } else {
                completionBlock(false)
            }
        }
    }
    
    func signIn(email: String, pass: String, completionBlock: @escaping (_ success: Bool) -> Void) {
        Auth.auth().signIn(withEmail: email, password: pass) { (result, error) in
            if let error = error, let _ = AuthErrorCode(rawValue: error._code) {
                completionBlock(false)
            } else {
                completionBlock(true)
            }
        }
    }
    
    func currentUser() -> User? {
        let user = Auth.auth().currentUser
        var firstName: String?
        
        if let user = user {
          let uid = user.uid
          let email = user.email
          let photoURL = user.photoURL
          
          let docRef = db.collection("pl_users").document(user.uid)

          docRef.getDocument { (document, error) in
              if let document = document, document.exists {
                firstName = document.get("firstname") as? String
                print("firstName", firstName)
              } else {
                  print("User does'nt exist")
              }
          }
            
          return User(firstName: firstName, uid: uid, email: email, photoURL: photoURL)
            
        } else {
            
          return nil
        }
    }
    
}

