import 'dart:io';
import 'package:sqljocky/sqljocky.dart';
import 'package:sqljocky/utils.dart';
import 'package:options_file/options_file.dart';
import 'package:shelf/shelf.dart' ;
import 'package:shelf/shelf_io.dart' as io;
import 'package:shelf_route/shelf_route.dart';
import 'package:json_object/json_object.dart';
import 'dart:async';

/* A simple web server that responds to **ALL** GET requests by returning
 * the contents of data.json file, and responds to ALL **POST** requests
 * by overwriting the contents of the data.json file
 *
 * Browse to it using http://localhost:4042
 *
 * Provides CORS headers, so can be accessed from any other page
 */

Map<String, String> data = new Map();
//final pool = new ConnectionPool(host:"localhost" , port: 3306, user: 'test', password: '111111', db: 'student', max: 5);
final _headers={"Access-Control-Allow-Origin":"*",
  "Access-Control-Allow-Methods": "POST, GET, OPTIONS",
  "Access-Control-Allow-Headers":"Origin, X-Requested-With, Content-Type, Accept",
  "Content-Type":"text/html"
};




Future main() async{
  //杜谦
  var myRouter = router()
    ..get('/stu/id',stuID)
    ..get('/stu/faculty',stuFaculty)
    ..get('/stu/course',stuCourse)
    ..get('/stu/submitHomework',stuSubHomwork)
    ..get('/teacher/id',teacherID)
  //吴怡雯
    ..get('/stu/comment/',getComment)//评论区在某同学第几条作业下获取已有评论
    ..get('/signin/getid/',getID)//登录获取身份信息
    ..get('/stu/getScore/{id}/{number}/',getScore)//评论区在某同学第几条作业下获取分数
    ..post('/stu/postComment/{id}/{number}/',stuPostComment)//评论区在某同学第几条作业下提交学生的评论
    ..post('/signin/postid/',postID)//登录提交身份信息


  //李志伟
    ..get('/tea/gethprojectlist/{schoolnumber}/',getprojectlist)//获取老师发布的作业列表
    ..get('/tea/gethprojectlist/{schoolnumber}/gethomeworklist',gethomeworklist)//获取老师收到的学生的作业列表
    ..get('/tea/rojectlist/{schoolnumber}/gethomeworklist/gethomeworkdetail',gethomeworkdetail)//获取学生提交的一份作业的具体信息
    ..post('/tea/postjudge/{teaschoolnumber}/{stuschoolnumber}/{id}/',postjudge)//提交教师的评价
    ..get('/{name}{?age}', myHandler);
  io.serve(myRouter.handler, '127.0.0.1', 3320);
}

/**
 * Handle GET requests by reading the contents of data.json
 * and returning it to the client
 */
//杜谦

//todo:获取学生的姓名
stuID(request) async{
  //连接我的数据库,将取出的数据存入到一个列表中
  var singledata=new Map<String,String>();
  var info_stulist=new List();
  var finalinfo_stulist=new Map<String,String>();
  final pool = new ConnectionPool(host:"localhost" , port: 3306, user: 'root',  db: 'stu_sql', max: 5);
  var result=await pool.query('select Number_stu,Name_stu,Faculty_stu from stu_sql');
  await result.forEach((row) {
    singledata={
      '"number_stu"':'"${row.Number_stu}"',
      '" name_stu"':'"${row.Name_stu}"',
      '"faculty_stu"':'"${row.Faculty_stu}"'
    };
    info_stulist.add(singledata);//将该数据加入数组中

  });
  finalinfo_stulist={'"STU_SQL"':info_stulist};
  return (new Response.ok(finalinfo_stulist.toString(),headers: _headers));
}



//todo:把从数据库取出的数据连接到客户端，并在客户端上显示出来
myHandler(request) {
  var name = getPathParameter(request, 'name');
  var age = getPathParameter(request, 'age');
  return new Response.ok("Hello $name of age $age");
}
teacherID(request){
  ///todo:获取老师的姓名
}
stuFaculty(request) {
//todo:获取学生的专业
  var name = getPathParameter(request, 'name');
  var faculty = getPathParameter(request, 'faculty');
  return new Response.ok("Hello $name of faculty $faculty");
}
stuCourse(request) {
  ///todo:获取学生的所选课程
  var name = getPathParameter(request, 'name');
  var course = getPathParameter(request, 'course');
  return new Response.ok("Hello $name of course $course");
}
scanComputer(request) {
  ///todo:实现浏览本地电脑文件的功能
  var name = getPathParameter(request, 'name');
  var scanComputer = getPathParameter(request, 'scanComputer');
  return new Response.ok("Hello $name of scanComputer $scanComputer");
}

stuSubHomwork(request) {
  ///todo:实现提交作业的功能
  var name = getPathParameter(request, 'name');
  var submitHomework = getPathParameter(request, 'submitHomework');
  return new Response.ok("Hello $name of submitHomework $submitHomework");
}


responseRoot(request){
  ///todo:获取老师的用户名，显示在页头
  return new Response.ok("Hello teacher!");


}

getComment(request) async{
  ///todo 在某同学第几条作业下获取已有评论
  //连接我的数据库
  var singledata = new Map<String, String>(); //存放单个用户数据
 // var userdata = new List(); //存放所有用户的数据
 // var comment=new Map<String,String>();//存放最终的用户数据
//  new ResponseFormatter formatter = new ResponseFormatter();
//  FormatResult result = formatter.formatResponse(request, {'"comment"':'"${row.comment}"'});
//  print(result.body);
//  print(result.contentType);
  final pool = new ConnectionPool(host:"localhost" , port: 3306, user: 'test', password: '111111', db: 'student', max: 5);
  var data = await pool.query('select id,comment from comment'); //取数据库中的数据

  await data.forEach((row) {
     singledata =
    {"ID":"${row.id}", "comment":"${row.comment}"}; //按照这个格式存放单条数据map
//    userdata.add(singledata); //将该数据加入数组中
  });
  //将用户数据存入数组中
  //comment={'"comment"':singledata};
  String jsonData = JSON.encode(singledata);//convert map to String
  return (new Response.ok(jsonData));//string
//可能是map无法转成String
//也可能是singledata数据错误
}

getID(request){
  //todo 获取身份信息
}
stuPostComment(request){
  ///todo 在某同学第几条作业下提交学生的评论
}
postID(request){
  //todo 提交身份信息
}
getScore(request){
  //todo 在某同学第几条作业下获取分数
}
//李志伟
getprojectlist(request){
  //todo 取老师发布的作业列表
}
gethomeworklist(request){
  //todo 获取老师收到的学生的作业列表
}
gethomeworkdetail(request){
  //todo 获取学生提交的一份作业的具体信息
}
postjudge(request){
//todo 提交教师的评价
}