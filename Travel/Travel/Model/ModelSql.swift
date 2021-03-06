//
//  ModelSql.swift
//  Travel
//
//  Created by admin on 05/01/2020.
//  Copyright © 2020 Studio. All rights reserved.
//

import Foundation

class ModelSql{
    
    var database: OpaquePointer? = nil
    
    init(){
        
        let dbFileName = "database2.db"
        if let dir = FileManager.default.urls(for: .documentDirectory, in:
            .userDomainMask).first{
            let path = dir.appendingPathComponent(dbFileName)
            if sqlite3_open(path.absoluteString, &database) != SQLITE_OK {
                print("Failed to open db file: \(path.absoluteString)")
                return
            }
        }
        create()
    }
    
    func create(){
        
        var errormsg: UnsafeMutablePointer<Int8>? = nil
        
        var res = sqlite3_exec(database, "CREATE TABLE IF NOT EXISTS POSTS (ST_ID TEXT PRIMARY KEY, TITLE TEXT,PLACE TEXT, DESCRIPTION TEXT, AVATAR TEXT)", nil, nil, &errormsg);
        if(res != 0){
            print("error creating table");
            return
        }
        
        
           res = sqlite3_exec(database, "CREATE TABLE IF NOT EXISTS LAST_UPADATE_DATE (NAME TEXT PRIMARY KEY, DATE DOUBLE)", nil, nil, &errormsg);
          if(res != 0){
              print("error creating table");
              return
          }
    }
    
    func addPost(post:Post){
        
        var sqlite3_stmt: OpaquePointer? = nil
        if (sqlite3_prepare_v2(database,"INSERT OR REPLACE INTO POSTS(ST_ID, TITLE, PLACE, DESCRIPTION, AVATAR) VALUES (?,?,?,?,?);",-1, &sqlite3_stmt,nil) == SQLITE_OK){
            let title = post.title.cString(using: .utf8)
            let place = post.place.cString(using: .utf8)
            let description = post.description.cString(using: .utf8)
            let avatar = post.avatar.cString(using: .utf8)
            
            sqlite3_bind_text(sqlite3_stmt, 1, title,-1,nil);
            sqlite3_bind_text(sqlite3_stmt, 2, place,-1,nil);
            sqlite3_bind_text(sqlite3_stmt, 3, description,-1,nil);
            sqlite3_bind_text(sqlite3_stmt, 4, avatar,-1,nil);
            
            if(sqlite3_step(sqlite3_stmt) == SQLITE_DONE){
                print("new row added succefully")
            }
        }
    }
    
    func getAllPosts()->[Post]{
        
        var sqlite3_stmt: OpaquePointer? = nil
        var data = [Post]()
        if (sqlite3_prepare_v2(database,"SELECT * from POSTS;",-1,&sqlite3_stmt,nil) == SQLITE_OK){
            while(sqlite3_step(sqlite3_stmt) == SQLITE_ROW){
                let title = String(cString:sqlite3_column_text(sqlite3_stmt,0)!)
                let place = String(cString:sqlite3_column_text(sqlite3_stmt,1)!)
                let description = String(cString:sqlite3_column_text(sqlite3_stmt,2)!)
                let avatar = String(cString:sqlite3_column_text(sqlite3_stmt,3)!)
                
                data.append(Post(title: title, place: place, description: description, avatar: avatar))
            }
        }
        sqlite3_finalize(sqlite3_stmt)
        return data
    }
    
    func setLastUpdate(name:String, lastUpdated:Int64){
           var sqlite3_stmt: OpaquePointer? = nil
           if (sqlite3_prepare_v2(database,"INSERT OR REPLACE INTO LAST_UPADATE_DATE( NAME, LUD) VALUES (?,?);",-1, &sqlite3_stmt,nil) == SQLITE_OK){

               sqlite3_bind_text(sqlite3_stmt, 1, name,-1,nil);
               sqlite3_bind_int64(sqlite3_stmt, 2, lastUpdated);
               if(sqlite3_step(sqlite3_stmt) == SQLITE_DONE){
                   print("new row added succefully")
               }
           }
           sqlite3_finalize(sqlite3_stmt)
       }
    
    func getLastUpdateDate(name:String)->Int64{
        var date:Int64 = 0;
        var sqlite3_stmt: OpaquePointer? = nil
        if (sqlite3_prepare_v2(database,"SELECT * from LAST_UPADATE_DATE where NAME = ?;",-1,&sqlite3_stmt,nil) == SQLITE_OK){
            sqlite3_bind_text(sqlite3_stmt, 1, name,-1,nil);

            if(sqlite3_step(sqlite3_stmt) == SQLITE_ROW){
                date = Int64(sqlite3_column_int64(sqlite3_stmt,1))
            }
        }
        sqlite3_finalize(sqlite3_stmt)
        return date
    }
}
