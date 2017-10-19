//
//  ViewController.swift
//  ContactFirst
//
//  Created by Hoan Tran on 10/19/17.
//  Copyright © 2017 Hoan Tran. All rights reserved.
//

import UIKit

import Contacts
import ContactsUI


class ContactViewController: UIViewController, CNContactPickerDelegate {

  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.backgroundColor = UIColor.cyan
    navigationItem.title = "Exploring Contacts"
    
    let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped) )
    navigationItem.setRightBarButton(addButton, animated: true)
  }
  
  @objc func addButtonTapped() {
    print("tapped")
    let controller = CNContactPickerViewController()
    controller.delegate = self
    navigationController?.present(controller, animated: true, completion: nil)
  }

  func fetchContact(_ id: String) {
    requestContactAccess{ isAllowed in
      if isAllowed {
        let store = CNContactStore()
        let keysToFetch = [CNContactGivenNameKey, CNContactFamilyNameKey]
        do {
          let retrievedContact = try store.unifiedContact(withIdentifier: id, keysToFetch: keysToFetch as [CNKeyDescriptor])
          print("R[", retrievedContact.identifier, "]", retrievedContact.givenName, retrievedContact.familyName)
        } catch {
          print("exception")
        }
      } else {
        print("Not allowed to have contact access")
      }
    }
  }
  
  func contactPicker(_ picker: CNContactPickerViewController, didSelect contact: CNContact) {
    print("[", contact.identifier, "]", contact.givenName, contact.familyName)
    fetchContact(contact.identifier)
  }
  
  func requestContactAccess(completion: @escaping (Bool)->Void ) {
    let store = CNContactStore()
    
    switch CNContactStore.authorizationStatus(for: .contacts){
      case .authorized:
        completion(true)
      case .notDetermined:
        store.requestAccess(for: .contacts){succeeded, err in
          guard err == nil && succeeded else{
            completion(false)
            return
          }
          completion(true)
        }
      default:
        print("Not handled")
        completion(false)
      }
  }
  
  func contactPickerDidCancel(_ picker: CNContactPickerViewController) {
    print("picker canceled")
  }
  
//  - (void)contactPickerDidCancel:(CNContactPickerViewController *)picker;
//  - (void)contactPicker:(CNContactPickerViewController *)picker didSelectContact:(CNContact *)contact;
//  - (void)contactPicker:(CNContactPickerViewController *)picker didSelectContactProperty:(CNContactProperty *)contactProperty;
  
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }


}

