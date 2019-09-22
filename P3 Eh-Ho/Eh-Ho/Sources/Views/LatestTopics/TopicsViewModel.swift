//
//  TopicsViewModel.swift
//  Eh-Ho
//
//  Created by Ignacio Garcia Sainz on 16/07/2019.
//  Copyright © 2019 KeepCoding. All rights reserved.
//

import Foundation

class TopicsViewModel {
    
    private let mDataManager = DataManager()
    private var mUserPreferences = UserDefaultsPreferences()
    
    
    weak var view: TopicsViewControllerProtocol?
    let router: TopicsRouter
    let topicsRepository: TopicsRepository
    
    
    init(router: TopicsRouter,
         topicsRepository: TopicsRepository) {
        self.router = router
        self.topicsRepository = topicsRepository
    }
    
    func viewDidLoad() {
        
        fetchLatestTopics()
    }
    
    func updateTopics() {
       fetchLatestTopics()
    }
    
    func didTapInTopic(topicId: Int, catId: Int) {
        router.navigateToTopicDetail(topicId: topicId, catId: catId)
        
    }
    
    
    
    private func fetchLatestTopics() {
        
        let networkState = DetectNetwork()
        if networkState.connected() {
            print("HAY CONEXIÓN a internet, calculamos tiempo desde última petición a servidor")
            
            
            if (self.mUserPreferences.checkTimeIntervalLatestTopics() > maxTime.maxTimeLatestTopics) {
                print("____Tiempo en segundos: \(mUserPreferences.checkTimeIntervalLatestTopics()) ___obtenemos datos del SERVIDOR")
                
                topicsRepository.getLatestTopics { [weak self] result in
                    
                    //Guardar date de la petición
                    
                    let date = Date()
                    self?.mUserPreferences.saveDateLatestTopics(date: date)
                    
                    
                    switch result {
                    case .success(let value):
                        
                        //DeleteAllLatestTopics
                        self?.mDataManager.deleteAllLatestTopics()
                        
                        //SaveLatestTopics
                        for i in 0...(value.topicList.topics.count-1) {
                            self?.mDataManager.saveLatestTopics(response: value.topicList.topics[i])
                        }
                        //MostrarLatestTopics
                        self?.view?.showLatestTopics(topics: value.topicList.topics)
                        
                    case .failure:
                        self?.view?.showError(with: "Error")
                    default:
                        print("No ha sido exitosa la request")
                    }//switch
                }//getList
            } else { // Tiempo menor al permitido, cargamos datos de la BD
                print("___Tiempo en segundos: \(mUserPreferences.checkTimeIntervalLatestTopics()), obtenemos datos de la BD")
                
                //Cargamos los datos de la BD, en vez de lanzar la petición al servidor
                if !(self.mDataManager.loadResponseLatestTopics().isEmpty)  {
                    self.view?.showLatestTopics(topics: self.mDataManager.loadResponseLatestTopics())
                } else {
                    print("Error al intentar recuperar los topics de la BD => tabla vacía")
                }
                
                
            }//else tiempo
            
        }//if conexión a internet
        else { //No hay conexión a internet
            print("NO HAY CONEXIÓN a internet, tenemos que cargar datos desde la BD")
            //Cargamos los datos de la BD, en vez de lanzar la petición al servidor
            if !(self.mDataManager.loadResponseLatestTopics().isEmpty)  {
                self.view?.showLatestTopics(topics: self.mDataManager.loadResponseLatestTopics())
            } else {
                print("Error al intentar recuperar los topics de la BD => tabla vacía")
            }
            
        }//else no hay conexión a internet
        
    }
}
