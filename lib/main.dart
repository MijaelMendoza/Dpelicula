import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:go_router/go_router.dart';
import 'package:dpeliculas/cubit/money_cubit.dart';
import 'package:dpeliculas/cubit/movies_cubit.dart';
import 'package:dpeliculas/models/utils.dart';
import 'package:dpeliculas/pages/detail_page.dart';
import 'package:dpeliculas/pages/profile_edit_page.dart';
import 'package:dpeliculas/pages/profile_page.dart';
import 'package:dpeliculas/pages/ticket_page.dart';
import 'package:dpeliculas/pages/history_page.dart';
import 'package:dpeliculas/pages/home_page.dart';
import 'package:dpeliculas/pages/login_page.dart';
import 'package:dpeliculas/pages/register_page.dart';
import 'package:dpeliculas/pages/seats_page.dart';
import 'package:dpeliculas/pages/topup_page.dart';
import 'package:dpeliculas/firebase_options.dart'; // Asegúrate de usar la ruta correcta al archivo

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform, // Utiliza las opciones configuradas
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  final GoRouter router = GoRouter(routes: [
    GoRoute(
      path: '/home',
      name: 'home',
      pageBuilder: (context, state) {
        return CustomTransitionPage(
          key: state.pageKey,
          child: const HomePage(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity:
                  CurveTween(curve: Curves.easeInOutCirc).animate(animation),
              child: child,
            );
          },
        );
      },
      routes: [
        GoRoute(
          path: 'detail/:id',
          name: 'detail',
          builder: (context, state) {
            return DetailPage(
              id: int.parse(state.pathParameters['id']!),
            );
          },
        ),
        GoRoute(
          path: 'seats/:id',
          name: 'seats',
          builder: (context, state) {
            return SeatsPage(id: int.parse(state.pathParameters['id']!));
          },
        ),
      ],
      redirect: (context, state) {
        if (FirebaseAuth.instance.currentUser == null) return '/login';

        return null;
      },
    ),
    GoRoute(
        path: '/history',
        name: 'history',
        pageBuilder: (context, state) {
          return CustomTransitionPage(
            key: state.pageKey,
            child: HistoryPage(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              return FadeTransition(
                opacity:
                    CurveTween(curve: Curves.easeInOutCirc).animate(animation),
                child: child,
              );
            },
          );
        },
        routes: [
          GoRoute(
            path: 'ticket/:id',
            name: 'ticket',
            builder: (context, state) {
              return TicketPage(id: state.pathParameters['id']!);
            },
          )
        ]),
    GoRoute(
        path: '/profile',
        name: 'profile',
        pageBuilder: (context, state) {
          return CustomTransitionPage(
            key: state.pageKey,
            child: ProfilePage(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              return FadeTransition(
                opacity:
                    CurveTween(curve: Curves.easeInOutCirc).animate(animation),
                child: child,
              );
            },
          );
        },
        routes: [
          GoRoute(
            path: 'topup',
            name: 'topup',
            builder: (context, state) {
              return const TopupPage();
            },
          ),
          GoRoute(
            path: 'edit',
            name: 'edit',
            builder: (context, state) {
              return const ProfileEditPage();
            },
          ),
        ]),
    GoRoute(
      path: '/login',
      name: 'login',
      builder: (context, state) {
        return const LoginPage();
      },
    ),
    GoRoute(
      path: '/register',
      name: 'register',
      builder: (context, state) {
        return const RegisterPage();
      },
    ),
  ], initialLocation: '/login');

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<MoviesCubit>(
          create: (context) => MoviesCubit(),
        ),
        BlocProvider<MoneyCubit>(
          create: (context) => MoneyCubit(),
        )
      ],
      child: MaterialApp.router(
        theme: ThemeData(
            primaryColor: const Color(0xfff4b33c),
            scaffoldBackgroundColor: const Color(0xff1C1C27),
            iconTheme: const IconThemeData(color: Color(0xffa6a6a6), size: 36),
            elevatedButtonTheme: ElevatedButtonThemeData(
                style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(const Color(0xfff4b33c)),
                    foregroundColor:
                        MaterialStateProperty.all(const Color(0xff222222)),
                    shape: MaterialStateProperty.all(const StadiumBorder()))),
            textTheme: Theme.of(context)
                .textTheme
                .apply(bodyColor: Colors.white, fontFamily: 'Inter')),
        debugShowCheckedModeBanner: false,
        routeInformationParser: router.routeInformationParser,
        routeInformationProvider: router.routeInformationProvider,
        routerDelegate: router.routerDelegate,
        scaffoldMessengerKey: Utils.messengerKey,
      ),
    );
  }
}
