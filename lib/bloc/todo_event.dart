part of 'todo_bloc.dart';

abstract class TodoEvent extends Equatable {
  const TodoEvent();

  @override
  List<Object> get props => [];
}

class AddTodoEvent extends TodoEvent {
  final String desc;
  const AddTodoEvent(this.desc);

  @override
  List<Object> get props => [desc];
}

class RemoveTodoEvent extends TodoEvent {
  final String id;
  const RemoveTodoEvent(this.id);

  @override
  List<Object> get props => [id];
}

class ToggleTodoEvent extends TodoEvent {
  final String id;
  const ToggleTodoEvent(this.id);

  @override
  List<Object> get props => [id];
}

class EditTodoEvent extends TodoEvent {
  final String id;
  final String desc;
  const EditTodoEvent(this.id, this.desc);

  @override
  List<Object> get props => [id, desc];
}

class ChangeFilterTodoEvent extends TodoEvent {
  final FilterStatus newFilter;
  const ChangeFilterTodoEvent(this.newFilter);

  @override
  List<Object> get props => [newFilter];
}

class ChangeSearchTermTodoEvent extends TodoEvent {
  final String newTerm;
  const ChangeSearchTermTodoEvent(this.newTerm);

  @override
  List<Object> get props => [newTerm];
}
