import 'Utils.dart';

class User {
  int id;
  String movie;
  String photo;
  String director;

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      columnId: id,
      columnMovie: movie,
      columnPhoto: photo,
      columnDirector: director
    };
    return map;
  }

  User();

  User.fromMap(Map<String, dynamic> map) {
    id = map[columnId];
    movie = map[columnMovie];
    photo = map[columnPhoto];
    director = map[columnDirector];
  }
}