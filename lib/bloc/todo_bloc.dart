import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:todo_bloc/models/todo.dart';

part 'todo_event.dart';
part 'todo_state.dart';

class TodoBloc extends Bloc<TodoEvent, TodoState> {
  TodoBloc() : super(TodoState.initial()) {
    on<AddTodoEvent>((event, emit) {
      List<Todo> newTodoList = [...state.todoList, Todo(desc: event.desc)];
      emit(state.copyWith(todoList: newTodoList));
      print(state.todoList.length);
    });
    on<RemoveTodoEvent>((event, emit) {
      List<Todo> newTodoList =
          state.todoList.where((element) => element.id != event.id).toList();

      emit(state.copyWith(todoList: newTodoList));
      print(state.todoList.length);
    });
    on<ToggleTodoEvent>((event, emit) {
      List<Todo> newTodoList = state.todoList.map((element) {
        if (element.id != event.id) {
          return element;
        } else {
          return element.copyWith(isCompleted: !element.isCompleted);
        }
      }).toList();

      emit(state.copyWith(todoList: newTodoList));
      print(state.todoList.length);
    });
    on<EditTodoEvent>((event, emit) {
      List<Todo> newTodoList = state.todoList.map((element) {
        if (element.id != event.id) {
          return element;
        } else {
          return element.copyWith(desc: event.desc);
        }
      }).toList();

      emit(state.copyWith(todoList: newTodoList));
      print(state.todoList.length);
    });
    on<ChangeFilterTodoEvent>((event, emit) {
      emit(state.copyWith(filterStatus: event.newFilter));
    });
    on<ChangeSearchTermTodoEvent>((event, emit) {
      emit(state.copyWith(searchTerm: event.newTerm));
    });


    
  }
  int get getActiveCount {
    List<Todo> newTodoList = state.todoList
        .where((element) => element.isCompleted == false)
        .toList();

    print(state.todoList.length);

    return newTodoList.length;
  } 

  
  List<Todo> get searchedFilteredList {
    List<Todo> filteredTodoList = [];
    switch (state.filterStatus) {
      case FilterStatus.active:
        filteredTodoList = state.todoList
            .where((element) => element.isCompleted == false)
            .toList();
        break;
      case FilterStatus.complete:
        filteredTodoList = state.todoList
            .where((element) => element.isCompleted == true)
            .toList();
        break;

      default:
        filteredTodoList = state.todoList;
    }
    List<Todo> searchedFilteredTodoList = filteredTodoList
        .where(
            (element) => element.desc.toLowerCase().contains(state.searchTerm))
        .toList();
    return searchedFilteredTodoList;
  }

}
