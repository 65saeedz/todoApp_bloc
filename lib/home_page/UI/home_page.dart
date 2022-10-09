import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_bloc/bloc/todo_bloc.dart';
import 'package:todo_bloc/models/todo.dart';

class MyHomePage extends StatelessWidget {
  const MyHomePage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: ListView(
              children: <Widget>[
                a_header(context),
                const Divider(),
                b_addTodo(context),
                const Divider(),
                c_searchTodo(context),
                Todo_Filter_Row(),
                ListView.separated(
                  primary: false,
                  shrinkWrap: true,
                  separatorBuilder: (context, index) => const Divider(),
                  itemCount:
                      context.read<TodoBloc>().searchedFilteredList.length,
                  itemBuilder: ((context, index) {
                    return ToDoItem(
                      todo:
                          context.read<TodoBloc>().searchedFilteredList[index],
                    );
                  }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Row a_header(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'TODO',
          style: TextStyle(fontSize: 28, fontWeight: FontWeight.w600),
        ),
        Text(
          '${context.watch<TodoBloc>().getActiveCount} items left',
          style: TextStyle(fontSize: 16, color: Colors.red),
        ),
      ],
    );
  }
}

TextField b_addTodo(BuildContext context) {
  return TextField(
    onSubmitted: (value) => context.read<TodoBloc>().add(AddTodoEvent(value)),
    decoration: const InputDecoration(
      border: InputBorder.none,
      focusedBorder: InputBorder.none,
      enabledBorder: InputBorder.none,
      errorBorder: InputBorder.none,
      disabledBorder: InputBorder.none,
      hintText: 'What to do?',
      hintStyle: TextStyle(
        color: Colors.grey,
      ),
    ),
  );
}

Container c_searchTodo(BuildContext context) {
  return Container(
    decoration: BoxDecoration(color: Colors.grey.shade200),
    child: TextField(
      onChanged: (value) {
        context.read<TodoBloc>().add(ChangeSearchTermTodoEvent(value));
      },
      decoration: InputDecoration(
        border: InputBorder.none,
        focusedBorder: InputBorder.none,
        enabledBorder: InputBorder.none,
        errorBorder: InputBorder.none,
        disabledBorder: InputBorder.none,
        prefixIcon: const Icon(
          Icons.search,
        ),
        hintText: 'Search Todos',
        hintStyle: TextStyle(
          color: Colors.grey.shade600,
        ),
      ),
    ),
  );
}

class Todo_Filter_Row extends StatefulWidget {
  const Todo_Filter_Row({Key? key}) : super(key: key);

  @override
  State<Todo_Filter_Row> createState() => _Todo_Filter_RowState();
}

class _Todo_Filter_RowState extends State<Todo_Filter_Row> {
  var selectedTab = 'All';

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          TextButton(
            onPressed: () {
              setState(() {
                context
                    .read<TodoBloc>()
                    .add(ChangeFilterTodoEvent(FilterStatus.all));
                selectedTab = 'All';
              });
            },
            child: Text(
              'All',
              style: TextStyle(
                  fontSize: selectedTab == 'All' ? 23 : 19,
                  fontWeight: selectedTab == 'All'
                      ? FontWeight.w800
                      : FontWeight.normal,
                  color: selectedTab == 'All' ? Colors.blue : Colors.grey),
            ),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                context
                    .read<TodoBloc>()
                    .add(ChangeFilterTodoEvent(FilterStatus.active));
                selectedTab = 'Active';
              });
            },
            child: Text(
              'Active',
              style: TextStyle(
                  fontSize: selectedTab == 'Active' ? 23 : 19,
                  fontWeight: selectedTab == 'Active'
                      ? FontWeight.w800
                      : FontWeight.normal,
                  color: selectedTab == 'Active' ? Colors.blue : Colors.grey),
            ),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                context
                    .read<TodoBloc>()
                    .add(ChangeFilterTodoEvent(FilterStatus.complete));
                selectedTab = 'Completed';
              });
            },
            child: Text(
              'Completed',
              style: TextStyle(
                  fontSize: selectedTab == 'Completed' ? 23 : 19,
                  fontWeight: selectedTab == 'Completed'
                      ? FontWeight.w800
                      : FontWeight.normal,
                  color:
                      selectedTab == 'Completed' ? Colors.blue : Colors.grey),
            ),
          ),
        ],
      ),
    );
  }
}

class ToDoItem extends StatefulWidget {
  late final Todo todo;
  ToDoItem({
    Key? key,
    required this.todo,
  }) : super(key: key);

  @override
  State<ToDoItem> createState() => _ToDoItemState();
}

class _ToDoItemState extends State<ToDoItem> {
  late final TextEditingController txtCtrl;

  @override
  void initState() {
    txtCtrl = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      onDismissed: (_) {
        context.read<TodoBloc>().add(RemoveTodoEvent(widget.todo.id));
      },
      background: Container(
        color: Colors.pink[200],
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            Icon(
              Icons.delete,
              color: Colors.red,
            ),
            Icon(
              Icons.delete,
              color: Colors.red,
            ),
          ],
        ),
      ),
      key: ValueKey(widget.todo.id),
      child: ListTile(
        leading: Checkbox(
            value: widget.todo.isCompleted,
            onChanged: (_) {
              context.read<TodoBloc>().add(ToggleTodoEvent(widget.todo.id));
            }),
        title: Text(widget.todo.desc),
        onTap: () {
          showDialog(
              context: context,
              builder: (context) {
                txtCtrl.text = widget.todo.desc;
                return AlertDialog(
                  title: const Text('edit todo'),
                  actions: <Widget>[
                    TextButton(
                        child: const Text('Cancel'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        }),
                    TextButton(
                        child: const Text('edit'),
                        onPressed: () {
                          context
                              .read<TodoBloc>()
                              .add(EditTodoEvent(widget.todo.id, txtCtrl.text));

                          Navigator.of(context).pop();
                        })
                  ],
                  backgroundColor: Colors.grey[300],
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                  content: Container(
                    constraints: const BoxConstraints(
                      minHeight: 250,
                      minWidth: 250,
                      maxHeight: 250,
                      maxWidth: 250,
                    ),
                    child: TextField(
                      controller: txtCtrl,
                      decoration: const InputDecoration(
                          hintText: 'Edit todo description'),
                    ),
                  ),
                );
              });
        },
      ),
    );
  }
}
