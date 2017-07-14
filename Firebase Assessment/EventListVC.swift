//
//  ViewController.swift
//  Firebase Assessment
//
//  Created by David Kleyman on 7/13/17.
//  Copyright © 2017 David Kleyman. All rights reserved.
//

import UIKit

class EventListVC: UIViewController, UITableViewDelegate, UITableViewDataSource, DataEditingDelegate {

    //declaration of variables
    @IBOutlet weak var tableView: UITableView!
    var events = [Event]()
    var desiredEventToBeUpdated: Event? = nil
    var myIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        let nib = UINib(nibName: "EventTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "EventCell")
        tableView.reloadData()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    func userDidInputData(event: Event) {
        events.append(event)
    }
    
    func configureEventsDatabase() {
        self.events.removeAll()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as? AddEventVC
        destination?.delegate = self
        destination?.myIndex = myIndex
        
        if segue.identifier == "segue"{
            destination?.identifier = segue.identifier
            destination?.name = events[myIndex].name
            destination?.address = events[myIndex].address
            destination?.price = events[myIndex].price
            destination?.image = events[myIndex].image
            destination?.dateAndTime = events[myIndex].time
            destination?.desiredEventToBeUpdated = desiredEventToBeUpdated
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EventCell", for: indexPath) as? EventTableViewCell
        cell?.configureCell(event: events[indexPath.row])
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        myIndex = indexPath.row
        desiredEventToBeUpdated = events[indexPath.row]
        performSegue(withIdentifier: "segue", sender: events[indexPath.row])
    }
    
}

