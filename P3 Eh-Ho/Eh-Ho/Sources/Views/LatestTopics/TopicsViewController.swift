//
//  TopicsViewController.swift
//  Eh-Ho
//
//  Created by Ignacio Garcia Sainz on 16/07/2019.
//  Copyright © 2019 KeepCoding. All rights reserved.
//

import UIKit

class TopicsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
       private var mUserPreferences = UserDefaultsPreferences()
    
    let viewModel: TopicsViewModel
    var topics: [Topic] = []
  
    lazy var refreshControl:UIRefreshControl = {
        
        let refresControl = UIRefreshControl()
        refresControl.attributedTitle = NSAttributedString(string: "Looking for new topics...")
        refresControl.addTarget(self, action: #selector(TopicsViewController.refreshLatestTopics(_ :)), for: .valueChanged)
        refresControl.tintColor = UIColor.blue
        return refresControl
        
    }()
    
    init(topicsViewModel: TopicsViewModel) {
        self.viewModel = topicsViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.addSubview(self.refreshControl)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 60
       
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: UITableViewCell.identifier)
        
       // mUserPreferences.saveDateLatestTopics(date: Date())
        
        viewModel.viewDidLoad()
    }
    
    @objc func refreshLatestTopics(_ refresControl: UIRefreshControl) {
        print("Refresh Latest Topics")
        viewModel.viewDidLoad()
        self.tableView.reloadData()
        refresControl.endRefreshing()
        
       
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return topics.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: UITableViewCell.identifier, for: indexPath)
        cell.textLabel?.text = topics[indexPath.row].title
        
        //cell.textLabel?.text = "Topic dummy \(indexPath.row)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let topicId = topics[indexPath.row].id
        let catId = topics[indexPath.row].categoryID
        
        viewModel.didTapInTopic(topicId: topicId, catId: catId)
    }
    
}


// MARK: - ViewModel Communication
protocol TopicsViewControllerProtocol: class {
    func showLatestTopics(topics: [Topic])
    func showError(with message: String)
    func updateTopics()
    
}

extension TopicsViewController: TopicsViewControllerProtocol {
    func showLatestTopics(topics: [Topic]) {
        self.topics = topics
        self.tableView.reloadData()
    }
    
    func showError(with message: String) {
        //AQUI ENSEÑAMOS ALERTA
        print("ERROR")
    }
    
    func updateTopics() {
        showLatestTopics(topics: topics)
        self.tableView.reloadData()
    }
    
}
