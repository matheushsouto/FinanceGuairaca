
# Título do Projeto

Uma breve descrição sobre o que esse projeto faz e para quem ele é

# FinanceGuairaca

Aplicativo Flutter para gerenciamento financeiro.

> ⚠️ Observação: atualmente, **somente a versão Web** está configurada com Firebase.
> Android e iOS possuem placeholders e precisam ser configurados manualmente para funcionar.

---

## Tecnologias

* Flutter 3.9+
* Firebase (Web: Authentication + Firestore)
* Provider (state management)
* RxDart
* intl
* cupertino_icons

---

## Passo a passo para rodar o projeto

### 1) Clonar o repositório

```bash
git clone https://github.com/matheushsouto/FinanceGuairaca.git
cd FinanceGuairaca
```

---

### 2) Instalar dependências

```bash
flutter pub get
```

---

### 3) Configurar Firebase (somente Web)

No arquivo `lib/firebase_options.dart`, altere **apenas** o bloco da Web (`kIsWeb`) para:

```dart
if (kIsWeb) {
  return const FirebaseOptions(
    apiKey: "Axxxxxxxxx",
    authDomain: "financing-app-4c4d5.firebaseapp.com",
    projectId: "financing-app-4c4d5",
    storageBucket: "financing-app-4c4d5.firebasestorage.app",
    messagingSenderId: "891273066809",
    appId: "1xxxxxxxxxxxxxxxxxxxxx",
  );
}
```

> **Importante:** Android e iOS permanecem com placeholders (`SUA API KEY`, `SEU APP ID`, etc.).

---

### 4) Inicialização do Firebase

No `main.dart`:

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}
```

---

### 5) Rodar o app

#### Web

```bash
flutter run -d chrome
```

O app abrirá no navegador e a versão Web já terá Firebase funcional.

#### Android/iOS (opcional)

```bash
flutter run -d <id_do_dispositivo>
```

* Ainda não terão Firebase funcional até você preencher as credenciais das plataformas.

---

### 6) Futuras configurações para Android/iOS

* Android:

  * `google-services.json` no diretório `android/app/`
  * `applicationId` correto no `build.gradle`
  * `minSdkVersion >= 21`
  * Plugin Google Services aplicado no Gradle

* iOS:

  * `GoogleService-Info.plist` no `ios/Runner/`
  * Bundle ID correto
  * Podfile com plataforma mínima adequada
  * Rodar `pod install` em `ios/`

---

### 7) Dicas

* Se algum plugin Firebase reclamar, rode:

```bash
flutter clean
flutter pub get
```

* Apenas a **Web** está funcional até Android/iOS serem configurados.
* Regras de Firestore e autenticação já estão configuradas para a Web.

---

### 8) Contato

Desenvolvedor: Matheus Souto
GitHub: [https://github.com/matheushsouto](https://github.com/matheushsouto)
