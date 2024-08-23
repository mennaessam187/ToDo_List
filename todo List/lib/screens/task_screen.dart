import 'package:betakty/cubit/cubit.dart';
import 'package:betakty/widgets/reusable_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
//import 'package:todo_app/cubit/cubit.dart';
//import 'package:todo_app/widgets/reusable_widgets.dart';

import '../cubit/states.dart';

class TasksScreen extends StatelessWidget {
  const TasksScreen({
    super.key,
  });
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
        builder: (context, state) =>
            buildListUi(context, tasks: AppCubit.get(context).tasks),
        listener: (context, state) {});
  }
}
