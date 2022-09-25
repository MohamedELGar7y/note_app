import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';

import '../cubit/cubit.dart';

Widget defaultButton({
  double width = double.infinity,
  Color background = Colors.blue,
  required Function function,
  required String text,
  bool isUpperCase = true,
  double radius = 0.0,
}) =>
    Container(
      width: width,
      child: MaterialButton(
        onPressed: (){
          function();
        },
        child: Text(
          isUpperCase ? text.toUpperCase() : text,
          style: const TextStyle(color: Colors.white),
        ),
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        color: background,
      ),
    );

Widget defaultFormFailed({
  required TextEditingController controller,
  required TextInputType type,
  required Function validate,
  Function? onSubmit,
  Function? onChanged,
  required String label,
  required IconData prefix,
  IconData? suffix,
  bool isPassword = false,
  Function? suffixPressed,
  Function? onTap,
  bool isClickable = true,
}) =>
    TextFormField(
      controller: controller,
      enabled: isClickable,
      keyboardType: type,
      obscureText: isPassword,
      onFieldSubmitted: (s)
      {
        onSubmit!();
      },
      onChanged: (s)
      {
        onChanged!(s);
      },
      validator: (s)
      {
        validate;
      },
      onTap: ()
      {
        onTap!();
      },
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        prefixIcon: Icon(
          prefix,
        ),
        suffixIcon: IconButton(
          onPressed: (){
            suffixPressed!();
            },
          icon: Icon(
            suffix,
          ),
        ),
      ),
    );

Widget buildTaskItem(Map model, context) => Dismissible(
  key:Key(model['id'].toString()),
  child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 40.0,
              child: Text(
                '${model['time']}',
              ),
            ),
            const SizedBox(
              width: 10.0,
            ),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${model['title']}',
                    style: const TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '${model['date']}',
                    style: const TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              width: 10.0,
            ),
            IconButton(
              icon: const Icon(
                Icons.check_circle,
                color: Colors.green,
              ),
              onPressed: () {
                AppCubit.get(context).updateData(
                  status: 'done',
                  id: model['id'],
                );
              },
            ),
            IconButton(
              icon: const Icon(
                Icons.archive,
                color: Colors.black54,
              ),
              onPressed: () {
                AppCubit.get(context).updateData(
                  status: 'archive',
                  id: model['id'],
                );
              },
            ),
          ],
        ),
      ),
  onDismissed: (direction)
  {
    AppCubit.get(context).deleteData(id: model['id'],);
  },
    );

Widget tasksBuilder({
  required List<Map>tasks,
})=>ConditionalBuilder(
  condition: tasks.isNotEmpty,
  builder:(context)=>ListView.separated(
    itemBuilder:(context,index)=>buildTaskItem(tasks[index],context),
    separatorBuilder: (context,index)=>Container(
      width: double.infinity,
      height: 1.0,
      color: Colors.grey[300],
    ),
    itemCount: tasks.length,
  ),
  fallback:(context)=>Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: const [
        Icon(
          Icons.menu,
          color: Colors.grey,
          size: 100.0,
        ),
        Text(
          'No Tasks Yet, Please Add Some Tasks',
          style: TextStyle(
            color: Colors.grey,
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    ),
  ),

);




