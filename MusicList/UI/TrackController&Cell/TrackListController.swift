//
//  TrackListController.swift
//  MusicList
//
//  Created by Владислав on 28.06.2021.
//

import UIKit

//MARK: - Контроллер для списка треов согласно выбранному айди альбома. Передаем айди прямо в ссылку для получения треков + к трекам подтягиваем цену/год/название/обложку альбома
class TrackListController: UIViewController {
    
    //MARK: вспомогательные переменные
    var track = [Track]()
    var album = [AlbumId]()
    var people = [People]()
    var trackInfo = [String]()
    
    //MARK: вспомогательная переменная для передачи изображения
    var imageToPlayer = UIImage()
    
    //MARK: Вспомогательная переменная для передачи айди альбома в ссылку получения данных карточки альбома
    var albumIdForTrack = String()
    
    //MARK: массив с треками mp3 (по условию использую его для плеера - так как линк на трек в задании не дается)
    var trackArrayForPlayer = ["track1", "track2", "track3", "track4", "track5", "track6","track7", "track8", "track9", "track10", "track11", "track12", "track13", "track14", "track15", "track16", "track17"]
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        activityIndicator.isHidden = true
        
        //MARK: настроки навигейшен контроллера
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        
        //MARK: вызываем метод получения карточки альбома
        fetchAlbumData()
    }
    
    //MARK: метод конфигруации ячейки списка треков
    func configTrackListCell(cell: CustomTrackCellTableViewCell, indexPath: IndexPath) {
        
        //MARK: выводим информацию по треку (название трека/год) согласно полученных данных + отдельно обложка альбома - все соотетсвует выбранному айди альбома)
        cell.trackName.text = track[indexPath.row].name
        cell.trackYear.text = track[indexPath.row].year
        
        //MARK: поскольку нам приходит идентичное наименование альбома для всех треков - можно обратиться к элементу по  индексу и подставить в ячейки одинаковые названия альбома
        cell.albumName.text = album[0].name
        
        //MARK: загружаем изображение по ссылке и присуждаем изображению в ячейке значение image
        guard let url = URL(string: album[0].coverUrl) else { return }
        let session = URLSession.shared
        session.dataTask(with: url) { (data, response, error) in
            
            if let data = data, let image = UIImage(data: data) {
                
                DispatchQueue.main.async {
                    self.imageToPlayer = image
                    cell.albumCover.image = image
                }
            }
        } .resume()
    }
}

// MARK:- Расширения для использования tableView
extension TrackListController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return track.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TrackCell") as! CustomTrackCellTableViewCell
        
        //MARK: Вызов метода конфигруации ячейки
        configTrackListCell(cell: cell, indexPath: indexPath)
        
        return cell
    }
    
    //MARK: передаем данные по нажатию на определенную ячейку
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let player = storyboard.instantiateViewController(withIdentifier: "PlayerController") as! PlayerController
        
        //MARK: присваиваем элементам в плеере значения при переходе
        player.albumPlayerImage = imageToPlayer
        player.albumPlayerName = album[0].name
        
        //MARK: передаю треки из по сути фейковых данных (всего треков скачано 17) передача происходит согласно условия: нажали на первую ячейку - первый трек из списка заиграл и так далее - в списке может быть больше чем 17 треков - тггда получаем вылет)
        player.trackForPlay = trackArrayForPlayer[indexPath.row] //так как я заранее не могу знать сколько треков придет (например в альбоме  619594: 1 страница 3 альбома) - 30 треков и мы получаем вылет при клике на ячейку 18 и так далее. Для демострации согласно тестового - будет ясно. В реальности - была бы передача линка. согласно нажатой ячейки
        
        //MARK: нам необходимо связать исполнителей и треки по совпадению айдишников. Не самый элегантный способ, но делаем терацию по массиву айдишников треков и сравниваем потом в итерации по массиву исполнителей - по итогу напоняем массив track.Info - Где буду лежать исполнители
        for x in track {
            trackInfo = x.peopleIds
            print(trackInfo)
        }
        
        for i in people {
            if trackInfo.contains(i.id) {
                trackInfo.remove(at: 0)
                trackInfo.append(i.name)
            }
            print("WHAT WE HAVE \(trackInfo)")
        }
        player.musicianForPalyer = trackInfo[indexPath.row]
        navigationController?.pushViewController(player, animated: true)
    }
}
