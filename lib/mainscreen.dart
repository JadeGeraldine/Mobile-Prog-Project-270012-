import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'about.dart';
import 'login.dart';
import 'mycart.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Mainscreen extends StatefulWidget 
  {@override
   _MainscreenState createState() => _MainscreenState();
  }

class _MainscreenState extends State<Mainscreen> 
  {List _itemList = [];
   double screenHeight, screenWidth;
   SharedPreferences pref;
   TextEditingController _searchController = new TextEditingController();
   
   @override
   void initState() 
    {super.initState();
     _loadItem(_searchController.text);
     _searchItem(_searchController.text);
    }

   @override
   Widget build(BuildContext context) 
    {screenHeight = MediaQuery.of(context).size.height;
     screenWidth = MediaQuery.of(context).size.width;
     return Container
      (decoration: new BoxDecoration
        (gradient: new LinearGradient
          (begin: Alignment.topLeft,
           end: Alignment.bottomRight,
           stops: [0.3,1],
           colors: [Colors.green[200],
                    Colors.red[200]
                   ],
          ),
        ),
     child: Scaffold
      (backgroundColor: Colors.transparent,
       appBar: AppBar
        (centerTitle: true,
         title: Text
          ('DIPS',
           style:TextStyle(fontFamily: 'Fredoka_One',
           fontSize:30)),
         backgroundColor: Colors.green[900]
        ),
       drawer: Theme
        (data: Theme.of(context).copyWith(
          canvasColor: Colors.red[100],),
         child: Drawer
        (child: ListView
          (children: 
            [DrawerHeader
              (child: Align
                (alignment: Alignment.center,
                 child: Text
                  ("MENU",
                   textAlign: TextAlign.center,  
                   style: TextStyle(fontFamily: 'Fredoka_One',
                   fontSize:60)),
                ),
               decoration: BoxDecoration
                (color: Colors.green[100])
              ),
             SizedBox(height:40),
             ListTile
              (title: Text("Dips",
                  style: TextStyle(fontFamily: 'Varela_Round',
                  fontSize:35)
                  ),
               onTap: ()
                {Navigator.push
                  (context, MaterialPageRoute(builder:(content)=>Mainscreen()));
                }
              ),
             SizedBox(height:40),
             ListTile
              (title: Text("My Cart",
                  style: TextStyle(fontFamily: 'Varela_Round',
                  fontSize:35)
                  ),
               onTap: ()
                {Navigator.push
                  (context, MaterialPageRoute(builder:(content)=>Mycart()));
                }
              ),
             SizedBox(height:40),
             ListTile
              (title: Text("About",
                  style: TextStyle(fontFamily: 'Varela_Round',
                  fontSize:35)
                  ),
               onTap: ()
                {Navigator.push
                  (context, MaterialPageRoute(builder:(content)=>About()));
                }
              ),
             SizedBox(height:40),
             ListTile
              (title: Text("Log Out",
                  style: TextStyle(fontFamily: 'Varela_Round',
                  fontSize:35)
                  ),
               onTap: ()
                {Navigator.push
                  (context, MaterialPageRoute(builder:(content)=>Login()));
                }
              )
            ],
          )
        ),
        ),
       body: Center
        (child: Container
          (margin: const EdgeInsets.fromLTRB(30,20,30,10),
           child: Column
            (children: 
              [TextFormField
                (controller: _searchController,
                 decoration: InputDecoration
                  (filled: true,
                   fillColor: Colors.white60,
                   hintText: "Search",
                   suffixIcon: IconButton
                    (onPressed: () => _searchItem(_searchController.text),
                     icon: Icon(Icons.search),
                    ),
                   border: OutlineInputBorder
                    (borderRadius: BorderRadius.all(Radius.circular(50.0))
                    ),
                  ),
                ),
               _itemList == null
               ? Flexible(child: Center(child: Text("Empty")))
               :Flexible
                (child: Center
                  (child: ListView
                    (children:List.generate(_itemList.length, (index) 
                      {return Padding
                        (padding: EdgeInsets.all(5),
                         child: Card
                          (shape: RoundedRectangleBorder
                            (borderRadius: BorderRadius.circular(50),
                            ),
                           color: Colors.white70,
                           child: Column
                            (children: 
                              [Container
                                (child: ClipRRect
                                  (borderRadius: BorderRadius.circular(50),
                                   child: Image.network(_itemList[index]['image'])
                                  ),
                                ),
                               SizedBox(height: 10),
                               Text
                                (_itemList[index]['name'],
                                 style: TextStyle
                                  (fontSize: 16,
                                   fontFamily: 'Comfortaa',
                                   fontWeight: FontWeight.bold),
                                ),
                               SizedBox(height: 10),
                               Text
                                ("Price: RM " + _itemList[index]['price'],
                                 style: TextStyle
                                  (fontSize: 18,
                                   fontFamily: 'Comfortaa'),
                                ),
                               SizedBox(height: 10),
                               Container
                                (child: ElevatedButton
                                  (onPressed: () => {_addCart(index)},
                                   child: Text("ADD TO CART", style: TextStyle
                                        (fontFamily: 'Fredoka_One', 
                                         fontSize:14,
                                         color: Colors.white)
                                        ),
                                   style: ElevatedButton.styleFrom
                                    (primary: Colors.green,
                                    ),
                                  ),
                                ),
                               SizedBox(height: 10),
                              ],
                            ),
                          ),
                        );
                      }
                    ),
                    ),
                  ),
                ),
              ],
            )
          ),
        ),
        ),
      );
    }

 void _loadItem(String text) 
  {http.post(Uri.parse("https://crimsonwebs.com/s270012/ArtisanalDips/php/loaditem.php"),
   body: {"item": text}).then((response) 
    {print(response.body);
      if (response.body == "failed") 
        {Text("Empty");
         return;
        } 
      else 
        {var jsondata = json.decode(response.body);
         _itemList = jsondata["item"];

        }
     setState(() {});
     print(response.body);
    }
   );
  }

 void _searchItem(String text) 
  {http.post(Uri.parse("https://crimsonwebs.com/s270012/ArtisanalDips/php/searchitem.php"),
    body: {"name":text}).then((response) 
      {if (response.body == "failed") 
        {Text("No item with that name.");
         _itemList = [];
         return;
        }
       else 
        {var jsondata = json.decode(response.body);
         print(jsondata);
         _itemList = jsondata["item"];
        }
     setState(() {});
    });
  }

 void _addCart(int index) async
  {await Future.delayed(Duration(seconds: 1));
   String id = _itemList[index]['id'];
   http.post(Uri.parse("https://crimsonwebs.com/s270012/ArtisanalDips/php/addcart.php"),
    body: {"id": id}).then((response) 
      {print(response.body);
       if (response.body == "failed") 
        {Fluttertoast.showToast
          (msg: "Failed",
           toastLength: Toast.LENGTH_SHORT,
           gravity: ToastGravity.CENTER,
           timeInSecForIosWeb: 1,
           backgroundColor: Colors.red,
           textColor: Colors.white,
           fontSize: 16.0
           );
        }
       else 
        {Fluttertoast.showToast
          (msg: "Successfully Added.",
           toastLength: Toast.LENGTH_SHORT,
           gravity: ToastGravity.CENTER,
           timeInSecForIosWeb: 1,
           backgroundColor: Colors.green,
           textColor: Colors.white,
           fontSize: 16.0
          );
        }
      }
    );
  }
}