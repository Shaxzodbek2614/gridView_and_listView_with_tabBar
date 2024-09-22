import 'package:flutter/material.dart';

void main(){
  runApp(MyApp());
}

class MyApp extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
    );
  }

}

class HomePage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _HomePageState();

}

class _HomePageState extends State<HomePage>{
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 1,
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue,
          title: Center(child: const Text("Tab Bar", style:TextStyle(color: Colors.white),)),
          bottom: TabBar(tabs: [
            Tab(text:"ListView",),
            Tab(text:"GridView",)
          ],
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white54,),
        ),
        body: TabBarView(children: [
          ListTileSelectedExample(),
          GridViewExample()
        ]),
      ),
    );
  }
}



class ListTileSelectedExample extends StatefulWidget{
  const ListTileSelectedExample({super.key});

  @override
  State<StatefulWidget> createState() => _ListTitle();
}

class _ListTitle extends State<ListTileSelectedExample>{
  bool isSelectionMode = false;
  final listLength = 30;
  late List<bool> _selectedList ;
  bool _selectAll = false;
  bool _isGridMode = false;

  @override
  void initState(){
    super.initState();
    initializeSelection();
  }

  void initializeSelection(){
    _selectedList = List<bool>.generate(listLength,(_)=> false);
  }

  @override
  void diponse(){
    _selectedList.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text("ListTile selection", style: TextStyle(color: Colors.black),)),
        leading: isSelectionMode
          ?IconButton(
          icon: const Icon(Icons.close),
          onPressed: (){
            setState(() {
              isSelectionMode = false;
            });
            initializeSelection();
          },
        )
            :const SizedBox(),
        actions: [
          if(_isGridMode)
            IconButton(
              icon: Icon(Icons.grid_on),
              onPressed: (){
                setState(() {
                  _isGridMode = false;
                });
              },
            )
          else
            IconButton(onPressed: (){
              setState(() {
                _isGridMode = true;
              });
            },
                icon: Icon(Icons.list)),
          if(isSelectionMode)
            TextButton(
              child: !_selectAll?
                  const Text("select all",style: TextStyle(color: Colors.black),)
                  :const Text("unselect all",style: TextStyle(color: Colors.black),),
              onPressed: (){
                _selectAll = !_selectAll;
                setState(() {
                  _selectedList = List<bool>.generate(listLength,(_)=> _selectAll);
                });
              }
            )
        ],
      ),
      body: _isGridMode
      ?GridBuilder(
          selectedList: _selectedList,
          isSelectionMode: isSelectionMode,
          onSelectionChange: (bool x){
            setState(() {
              isSelectionMode = x;
            });
          },
      )
          :ListBuilder(
          selectedList: _selectedList,
          isSelectionMode: isSelectionMode,
          onSelectionChange: (bool x){
            setState(() {
              isSelectionMode = x;
            });
          }
      )

    );
  }
}

class GridBuilder extends StatefulWidget{
  const GridBuilder({
    super.key,
    required this.selectedList,
    required this.isSelectionMode,
    required this.onSelectionChange,
});
  final bool isSelectionMode;
  final ValueChanged<bool>? onSelectionChange;
  final List<bool> selectedList;


  @override
  State<StatefulWidget> createState() => GridBuilderState();

}

class GridBuilderState extends State<GridBuilder>{
  void _toggle(int index){
    if(widget.isSelectionMode){
      setState(() {
        widget.selectedList[index] = !widget.selectedList[index];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
        gridDelegate:const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
        itemBuilder: (_,index){
          return InkWell(
            onTap:() => _toggle(index),
            onLongPress: (){
              if(!widget.isSelectionMode){
                setState(() {
                  widget.selectedList[index] = true;
                });
                widget.onSelectionChange!(true);
              }
            },
            child: GridTile(
                child: Container(
                  child: widget.isSelectionMode
                  ?Checkbox(
                      onChanged: (bool? x)=>_toggle(index),
                      value: widget.selectedList[index])
                      :const Icon(Icons.image),
                )
            ),
          );
        }
    );
  }
}

class ListBuilder extends StatefulWidget{
  const ListBuilder({
    super.key,
    required this.selectedList,
    required this.isSelectionMode,
    required this.onSelectionChange
});
  final bool isSelectionMode;
  final List<bool> selectedList;
  final ValueChanged<bool>? onSelectionChange;

  @override
  State<StatefulWidget> createState() => _ListBuilderState();
}

class _ListBuilderState extends State<ListBuilder>{
  void _toggle(int index){
    setState(() {
      if(widget.isSelectionMode){
        setState(() {
          widget.selectedList[index] = !widget.selectedList[index];
        });
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.selectedList.length,
        itemBuilder: (_,int index){
        return ListTile(
          onTap: ()=>_toggle(index),
          onLongPress: (){
            if(!widget.isSelectionMode){
              setState(() {
                widget.selectedList[index] = true;
              });
              widget.onSelectionChange!(true);
            }
          },
          trailing: widget.isSelectionMode
          ?Checkbox(value: widget.selectedList[index],
              onChanged: (bool? x) => _toggle(index),)
          :const SizedBox.shrink(),
          title: Text("item $index"),
        );
        }
    );
  }
}

class GridViewExample extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _GridViewExampleState();
  
}

class _GridViewExampleState extends State<GridViewExample>{
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,  // 2 ta ustunli grid
          crossAxisSpacing: 10.0, // ustunlar orasidagi masofa
          mainAxisSpacing: 10.0,  // qatorlar orasidagi masofa
          ),
          itemCount: 30,
          itemBuilder: (BuildContext context, int index){
            return Card(
            color: Colors.blue,
            child: Image.network(
              'assets/Downloads/flutter.png',
              fit: BoxFit.cover,
            )
            );
      },
      ),
    );
  }
}