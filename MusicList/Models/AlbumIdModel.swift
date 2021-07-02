//
//  AlbumIdModel.swift
//  MusicList
//
//  Created by Владислав on 29.06.2021.
//

//MARK: структуры для получения айди альбомов (я разделил структуры по разным файлам чтобы не мешать все в кучу) - тут у нас общая ссылка где мы получаем альбомы и всю информацию по ним - отдельно хочу получить айдишники альбомов в таблицу
struct DataAll: Decodable {
    
    var response: Albums
    
    enum CodingKeys: String, CodingKey {
        case response
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        response = try container.decode(Albums.self, forKey: .response)
    }
}

struct Albums: Decodable {
    var albums: [String]
    
    enum CodingKeys: String, CodingKey {
        case albums
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        albums = try container.decode([String].self, forKey: .albums)
    }
}

