part of 'todo_bloc.dart';


enum FilterStatus { all, active, complete }

class TodoState extends Equatable {
  final FilterStatus filterStatus;
  final String searchTerm;
  final List<Todo> todoList;
  const TodoState({
    required this.filterStatus,
    required this.searchTerm,
    required this.todoList,
  });

  @override
  List<Object> get props => [filterStatus, searchTerm, todoList];

  TodoState copyWith({
    FilterStatus? filterStatus,
    String? searchTerm,
    List<Todo>? todoList,
  }) {
    return TodoState(
      filterStatus: filterStatus ?? this.filterStatus,
      searchTerm: searchTerm ?? this.searchTerm,
      todoList: todoList ?? this.todoList,
    );
  }

  factory TodoState.initial() {
    return TodoState(filterStatus: FilterStatus.all, searchTerm: '', todoList: [
      Todo(desc: 'desc 01'),
      Todo(desc: 'desc 02'),
    ]);
  }

  @override
  String toString() =>
      'TodoState(filterStatus: $filterStatus, searchTerm: $searchTerm, todoList: $todoList)';
}
