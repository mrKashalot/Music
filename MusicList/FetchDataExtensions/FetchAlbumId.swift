//
//  FetchAlbumId.swift
//  MusicList
//
//  Created by Владислав on 01.07.2021.
//
import UIKit

//MARK: Сделал экстеншен - чтобы не было каши в контроллере альбомов (контроллеры и так получились объемные)
extension ViewController {
    //MARK: - метод получения данных Айди альбомов
    func fetchMusicData() {
        
        let request = NSMutableURLRequest(url: NSURL(string: "https://api.mobimusic.kz/?method=product.getNews&page=\(pageNumber)&limit=\(albumCount)")! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)
        request.httpMethod = "GET"
        
        //MARK: показываем индикатор загрузки и анимируем
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        
        URLSession.shared.dataTask(with: request as URLRequest) { (data, response, error) in
            
            DispatchQueue.main.async { [self] in
                
                guard let data = data else { return }
                
                do {
                    
                    let musicData = try JSONDecoder().decode(DataAll.self, from: data)
                    
                    albumIdArray = musicData.response.albums
                    
                    //MARK: обновляем данные в таблице
                    tableView.reloadData()
                    
                    //MARK: прекращаем анимацию (в storyboard уже заявлено что прячется после остановки анимации)
                    activityIndicator.stopAnimating()
                    
                } catch let error {
                    
                    print("Error serialization", error)
                }
            }
        }.resume()
    }
}

