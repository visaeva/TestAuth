# TestAuth iOS Project

## Описание
Приложение демонстрирует авторизацию через **Google** и **Apple** с использованием **Firebase** и backend.  
После успешной авторизации пользователь сразу переходит в TabBarController.

---

## Инструкция по запуску

1. Клонируйте репозиторий
2. После запуска приложения авторизуйесь через Apple/ Google
3. При повторном запуске id token будет сохранен в Keychain и сразу отобразится HomeVC
4. Keychain очищается при необходимости через KeychainHelper.standard.clearAll()

## Архитектура MVVM

## Чтобы проект работал с Firebase:
1. Создать проект на Firebase Console.
2. Добавить iOS-приложение с Bundle ID вашего проекта.
3. Сгенерировать GoogleService-Info.plist
4. Добавить его в проект в Xcode
5. Включить Google Sign-In и Apple Sign-In в Firebase Authentication
6. Убедиться, что вызывается FirebaseApp.configure()

