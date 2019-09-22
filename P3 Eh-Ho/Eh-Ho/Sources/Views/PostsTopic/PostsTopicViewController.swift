//
//  PostTopicViewController.swift
//  Eh-Ho
//
//  Created by Monica Sanmartin on 25/07/2019.
//  Copyright © 2019 KeepCoding. All rights reserved.
//

import UIKit

class PostsTopicViewController: UIViewController {
    
    //Definir IBOutlet tableView
    
  
  
    @IBOutlet weak var tableView: UITableView!
    
    let viewModel: PostsTopicViewModel
    var posts: [Post] = []
    let topicId: Int
    
    init(topicId: Int, postsTopicViewModel: PostsTopicViewModel) {
        self.viewModel = postsTopicViewModel
        self.topicId = topicId
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupButton()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 60
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: UITableViewCell.identifier)
       
        
        viewModel.viewDidLoad()
       
    }
    
    
    
}

extension PostsTopicViewController {
    
private func deleteTopic() {
        let newDeleteTopicButton = UIBarButtonItem(
            title: "Delete topic",
            style: .plain,
            target: self,
            action: #selector(borrarTopic)
        )
        
        // Lo añado a la navigation bar
 
       // navigationItem.leftBarButtonItems = [newDeleteTopicButton]
    }
    
    @objc private func borrarTopic(topicId: Int) {
        print("Pulsado botón borrar topic")
        
        
    }
    
 private func setupButton() {
        // Creo mi botón
        let newPostButton = UIBarButtonItem(
            title: "Create New Post",
            style: .plain,
            target: self,
            action: #selector(addNewPost)
        )
        
        
        // Lo añado a la navigation bar
            navigationItem.rightBarButtonItems = [newPostButton]
    }

    

    
    @objc private func addNewPost() {
    
          var titlePost: UITextField?
        //Bloque fechas
        

        
        let alerta = UIAlertController(title: "Vas a postear en este topic...",
                                       message: "... introduce tu post",
                                       preferredStyle: UIAlertController.Style.alert)
        
        alerta.addTextField(configurationHandler: {(textField: UITextField!) in
            textField.placeholder = "texto de tu post"
            textField.borderStyle = .line
            
            //textField.isSecureTextEntry = true
            textField.textColor = .red
           titlePost = textField
        })
        
        let sendAction = UIAlertAction(title: "Enviar",
                                    style: UIAlertAction.Style.default) { _ in
                                        alerta.dismiss(animated: true, completion: nil)
                                        
                                
                                        
                                        if (titlePost?.text != nil) && (titlePost?.text != "") {
                                            self.viewModel.createNewPost(topicId: self.topicId, raw: titlePost!.text!)
                                            
                                        } else {
                                            print("El título del nuevo post no puede estar vacío")
                                            self.showAlertError(title: "El título del post no puede estar vacío", vc: self)
                                            

                                        }
                                       
                                        
        }
        
        alerta.addAction(sendAction)
        
        
        self.present(alerta, animated: true, completion: nil)
        
       
        
    }
    
}

extension PostsTopicViewController {
    
    func showAlertError(title: String, vc: PostsTopicViewController) {
        
        let alert = UIAlertController(title: "Error...", message: title, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default) {_ in alert.dismiss(animated: true, completion: nil)}
        alert.addAction(action)
        vc.present(alert, animated: true, completion: nil)
        
    }
    
}

extension PostsTopicViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: UITableViewCell.identifier, for: indexPath)
        
        cell.textLabel?.text = "\(posts[indexPath.row].username) \( "=>" ) \(posts[indexPath.row].cooked)"
//cell.detailTextLabel?.text = "Visitas: \(topics[indexPath.row].views)"
        return cell
    }
    
    
}

extension PostsTopicViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let id = posts[indexPath.row].id
        //print("DidSelectRow at en PostsVC: pulsado el post id:\(id)")
      
    }
}

// MARK: - ViewModel Communication
protocol PostsTopicViewControllerProtocol: class {
    func showListOfPosts(posts: [Post])
    func showError(with message: String)
}

extension PostsTopicViewController: PostsTopicViewControllerProtocol {
    func showListOfPosts(posts: [Post]) {
        self.posts = posts
        self.title = "Posts en topic id: \(topicId)"
        self.tableView.reloadData()
    }
    
    func showError(with message: String) {
        //AQUI ENSEÑAMOS ALERTA
        print("ERROR")
    }
}
