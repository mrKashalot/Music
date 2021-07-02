//
//  FetchDataTrackExtensions.swift
//  MusicList
//
//  Created by Владислав on 01.07.2021.
//

import UIKit

//MARK: Сделал экстеншен - чтобы не было каши в контроллере треков (контроллеры и так получились объемные)
extension TrackListController {
    
    //MARK: - метод получения карточки альбома по айди которй мы передаем в ссылку (выбрав в предыдущей таблице)
    func fetchAlbumData() {
        
        let request = NSMutableURLRequest(url: NSURL(string: "https://api.mobimusic.kz/?method=product.getCard&productId=\(albumIdForTrack)")! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)
        request.httpMethod = "GET"
        
        //MARK: добавляем индикатор загрузки
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        
        URLSession.shared.dataTask(with: request as URLRequest) { (data, response, error) in
            
            DispatchQueue.main.async { [self] in
                
                guard let data = data else { return }
                
                do {
                    
                    let albumData = try JSONDecoder().decode(AlbumData.self, from: data)
                    
                    //MARK: получаем данные из карточки альбома (информация по треку) - оставил принты для проверки
                    self.track = albumData.collection.track.map { return $0.value }
                    print("Массив трека \(self.track)")
                    print(self.track.count)
                    
                    
                    //MARK: получаем данные из карточки альбома (информация по альбому) - оставил принты для проверки
                    self.album = albumData.collection.album.map { return $0.value }
                    print("Массив альбома \(self.album)")
                    print(self.album.count)
                    
                    //MARK: получаем данные из карточки альбома (информация по исполнителям) - оставил принты для проверки
                    self.people = albumData.collection.people.map { return $0.value }
                    print("Массив исполнителей \(self.people)")
                    print(self.people.count)
                    
                    //MARK: обновляем данные в таблице
                    self.tableView.reloadData()
                    
                    //MARK: останавливаем анимацию индикатора и он автоматом спрячется (галочка в сториборд)
                    self.activityIndicator.stopAnimating()
                    
                } catch let error {
                    
                    print("Error serialization", error)
                }
            }
        }.resume()
    }
}
