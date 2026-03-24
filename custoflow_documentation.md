# CustoFlow - Full Documentation

## 1. Project Overview

- Application name: `custoflow`.
- CustoFlow is a Flutter application for automated customer feedback onboarding and management. In the current codebase, users can create an account, log in, create departments, view basic feedback analytics, and generate/copy integration code snippets.
- The app purpose shown in UI text: "Automate Customer Feedback" / "Automated Customer Feedback".
- Target users visible in code: company admins managing feedback setup for their organization.
- Platform: Flutter app configured for web, Android, iOS, Linux, macOS, and Windows.

## 2. Tech Stack

- Framework: Flutter + Dart.
- Dart SDK constraint (`pubspec.yaml`): `^3.10.7`.
- Lockfile SDK ranges (`pubspec.lock`): Dart `>=3.10.7 <4.0.0`, Flutter `>=3.35.0`.
- Flutter channel/revision (`.metadata`): `stable`, revision `8b872868494e429d94fa06dca855c306438b22c0`.

### Flutter dependencies declared in `pubspec.yaml`

- `flutter` (sdk)
- `firebase_core: ^3.6.0`
- `firebase_auth: ^5.3.1`
- `firebase_auth_web: ^5.13.2`
- `cloud_firestore: ^5.4.4`
- `http: ^1.2.0`
- `provider: ^6.0.5`
- `google_sign_in: ^6.1.0`
- `fluttertoast: ^8.2.1`
- `shared_preferences: ^2.1.1`
- `cupertino_icons: ^1.0.8`
- Dev dependencies:
  - `flutter_test` (sdk)
  - `flutter_lints: ^6.0.0`

### Direct dependency versions resolved in `pubspec.lock`

- `cloud_firestore: 5.6.12`
- `firebase_auth: 5.7.0`
- `firebase_auth_web: 5.15.3`
- `firebase_core: 3.15.2`
- `http: 1.6.0`
- `provider: 6.1.5+1`
- `google_sign_in: 6.3.0`
- `fluttertoast: 8.2.14`
- `shared_preferences: 2.5.4`
- `cupertino_icons: 1.0.8`
- `flutter_lints: 6.0.0`

### JavaScript dependencies

- `package.json`: `firebase: ^12.8.0`
- `package-lock.json` present with full `node_modules` lock graph.

### Firebase services used in first-party Dart code

- Firebase Core (`Firebase.initializeApp`)
- Firebase Authentication (signup/login/reset/signout)
- Cloud Firestore (company/departments/feedback reads and writes)

### Third-party package usage in first-party Dart code

- Used: `firebase_core`, `firebase_auth`, `cloud_firestore`, `http`.
- Declared but not used in current first-party Dart files: `provider`, `google_sign_in`, `fluttertoast`, `shared_preferences`.

## 3. App Architecture

- Entry file: `lib/main.dart`.
- App is organized by page files under `lib/`.
- Architecture style: route-driven UI with local state (`StatefulWidget` + `setState`).
- No dedicated service/repository/model folders were found.
- No central state manager wiring is present (despite `provider` dependency declaration).

### Folder and file structure

The complete workspace file inventory (including `node_modules`, generated files, and build artifacts) is appended below this section as captured from `rg --files` output.

```text

node_modules\firebase\functions\dist\installations\index.d.ts
node_modules\firebase\functions\dist\messaging\index.d.ts
node_modules\firebase\functions\dist\messaging\sw\index.d.ts
node_modules\firebase\functions\dist\performance\index.d.ts
node_modules\firebase\functions\dist\remote-config\index.d.ts
node_modules\firebase\functions\dist\storage\index.d.ts
node_modules\firebase\installations\package.json
node_modules\firebase\installations\dist\index.cjs.js
node_modules\firebase\installations\dist\index.cjs.js.map
node_modules\firebase\installations\dist\index.mjs
node_modules\firebase\installations\dist\index.mjs.map
node_modules\firebase\installations\dist\ai\index.d.ts
node_modules\firebase\installations\dist\analytics\index.d.ts
node_modules\firebase\installations\dist\app\index.cdn.d.ts
node_modules\firebase\installations\dist\app\index.d.ts
node_modules\firebase\installations\dist\app-check\index.d.ts
node_modules\firebase\installations\dist\auth\index.d.ts
node_modules\firebase\installations\dist\auth\cordova\index.d.ts
node_modules\firebase\installations\dist\auth\web-extension\index.d.ts
node_modules\firebase\installations\dist\compat\index.cdn.d.ts
node_modules\firebase\installations\dist\compat\index.d.ts
node_modules\firebase\installations\dist\compat\index.node.d.ts
node_modules\firebase\installations\dist\compat\index.perf.d.ts
node_modules\firebase\installations\dist\compat\index.rn.d.ts
node_modules\firebase\installations\dist\compat\analytics\index.d.ts
node_modules\firebase\installations\dist\compat\app\index.cdn.d.ts
node_modules\firebase\installations\dist\compat\app\index.d.ts
node_modules\firebase\installations\dist\compat\app-check\index.d.ts
node_modules\firebase\installations\dist\compat\auth\index.d.ts
node_modules\firebase\installations\dist\compat\database\index.d.ts
node_modules\firebase\installations\dist\compat\firestore\index.d.ts
node_modules\firebase\installations\dist\compat\functions\index.d.ts
node_modules\firebase\installations\dist\compat\installations\index.d.ts
node_modules\firebase\installations\dist\compat\messaging\index.d.ts
node_modules\firebase\installations\dist\compat\performance\index.d.ts
node_modules\firebase\installations\dist\compat\remote-config\index.d.ts
node_modules\firebase\installations\dist\compat\storage\index.d.ts
node_modules\firebase\installations\dist\data-connect\index.d.ts
node_modules\firebase\installations\dist\database\index.d.ts
node_modules\firebase\installations\dist\esm\index.esm.js
node_modules\firebase\installations\dist\esm\index.esm.js.map
node_modules\firebase\installations\dist\esm\package.json
node_modules\firebase\installations\dist\esm\ai\index.d.ts
node_modules\firebase\installations\dist\esm\analytics\index.d.ts
node_modules\firebase\installations\dist\esm\app\index.cdn.d.ts
node_modules\firebase\installations\dist\esm\app\index.d.ts
node_modules\firebase\installations\dist\esm\app-check\index.d.ts
node_modules\firebase\installations\dist\esm\auth\index.d.ts
node_modules\firebase\installations\dist\esm\auth\cordova\index.d.ts
node_modules\firebase\installations\dist\esm\auth\web-extension\index.d.ts
node_modules\firebase\installations\dist\esm\compat\index.cdn.d.ts
node_modules\firebase\installations\dist\esm\compat\index.d.ts
node_modules\firebase\installations\dist\esm\compat\index.node.d.ts
node_modules\firebase\installations\dist\esm\compat\index.perf.d.ts
node_modules\firebase\installations\dist\esm\compat\index.rn.d.ts
node_modules\firebase\installations\dist\esm\compat\analytics\index.d.ts
node_modules\firebase\installations\dist\esm\compat\app\index.cdn.d.ts
node_modules\firebase\installations\dist\esm\compat\app\index.d.ts
node_modules\firebase\installations\dist\esm\compat\app-check\index.d.ts
node_modules\firebase\installations\dist\esm\compat\auth\index.d.ts
node_modules\firebase\installations\dist\esm\compat\database\index.d.ts
node_modules\firebase\installations\dist\esm\compat\firestore\index.d.ts
node_modules\firebase\installations\dist\esm\compat\functions\index.d.ts
node_modules\firebase\installations\dist\esm\compat\installations\index.d.ts
node_modules\firebase\installations\dist\esm\compat\messaging\index.d.ts
node_modules\firebase\installations\dist\esm\compat\performance\index.d.ts
node_modules\firebase\installations\dist\esm\compat\remote-config\index.d.ts
node_modules\firebase\installations\dist\esm\compat\storage\index.d.ts
node_modules\firebase\installations\dist\esm\data-connect\index.d.ts
node_modules\firebase\installations\dist\esm\database\index.d.ts
node_modules\firebase\installations\dist\esm\firestore\index.d.ts
node_modules\firebase\installations\dist\esm\firestore\lite\index.d.ts
node_modules\firebase\installations\dist\esm\firestore\lite\pipelines\index.d.ts
node_modules\firebase\installations\dist\esm\firestore\pipelines\index.cdn.d.ts
node_modules\firebase\installations\dist\esm\firestore\pipelines\index.d.ts
node_modules\firebase\installations\dist\esm\functions\index.d.ts
node_modules\firebase\installations\dist\esm\installations\index.d.ts
node_modules\firebase\installations\dist\esm\messaging\index.d.ts
node_modules\firebase\installations\dist\esm\messaging\sw\index.d.ts
node_modules\firebase\installations\dist\esm\performance\index.d.ts
node_modules\firebase\installations\dist\esm\remote-config\index.d.ts
node_modules\firebase\installations\dist\esm\storage\index.d.ts
node_modules\firebase\installations\dist\firestore\index.d.ts
node_modules\firebase\installations\dist\firestore\lite\index.d.ts
node_modules\firebase\installations\dist\firestore\lite\pipelines\index.d.ts
node_modules\firebase\installations\dist\firestore\pipelines\index.cdn.d.ts
node_modules\firebase\installations\dist\firestore\pipelines\index.d.ts
node_modules\firebase\installations\dist\functions\index.d.ts
node_modules\firebase\installations\dist\installations\index.d.ts
node_modules\firebase\installations\dist\messaging\index.d.ts
node_modules\firebase\installations\dist\messaging\sw\index.d.ts
node_modules\firebase\installations\dist\performance\index.d.ts
node_modules\firebase\installations\dist\remote-config\index.d.ts
node_modules\firebase\installations\dist\storage\index.d.ts
node_modules\firebase\messaging\package.json
node_modules\firebase\messaging\dist\index.cjs.js
node_modules\firebase\messaging\dist\index.cjs.js.map
node_modules\firebase\messaging\dist\index.mjs
node_modules\firebase\messaging\dist\index.mjs.map
node_modules\firebase\messaging\dist\ai\index.d.ts
node_modules\firebase\messaging\dist\analytics\index.d.ts
node_modules\firebase\messaging\dist\app\index.cdn.d.ts
node_modules\firebase\messaging\dist\app\index.d.ts
node_modules\firebase\messaging\dist\app-check\index.d.ts
node_modules\firebase\messaging\dist\auth\index.d.ts
node_modules\firebase\messaging\dist\auth\cordova\index.d.ts
node_modules\firebase\messaging\dist\auth\web-extension\index.d.ts
node_modules\firebase\messaging\dist\compat\index.cdn.d.ts
node_modules\firebase\messaging\dist\compat\index.d.ts
node_modules\firebase\messaging\dist\compat\index.node.d.ts
node_modules\firebase\messaging\dist\compat\index.perf.d.ts
node_modules\firebase\messaging\dist\compat\index.rn.d.ts
node_modules\firebase\messaging\dist\compat\analytics\index.d.ts
node_modules\firebase\messaging\dist\compat\app\index.cdn.d.ts
node_modules\firebase\messaging\dist\compat\app\index.d.ts
node_modules\firebase\messaging\dist\compat\app-check\index.d.ts
node_modules\firebase\messaging\dist\compat\auth\index.d.ts
node_modules\firebase\messaging\dist\compat\database\index.d.ts
node_modules\firebase\messaging\dist\compat\firestore\index.d.ts
node_modules\firebase\messaging\dist\compat\functions\index.d.ts
node_modules\firebase\messaging\dist\compat\installations\index.d.ts
node_modules\firebase\messaging\dist\compat\messaging\index.d.ts
node_modules\firebase\messaging\dist\compat\performance\index.d.ts
node_modules\firebase\messaging\dist\compat\remote-config\index.d.ts
node_modules\firebase\messaging\dist\compat\storage\index.d.ts
node_modules\firebase\messaging\dist\data-connect\index.d.ts
node_modules\firebase\messaging\dist\database\index.d.ts
node_modules\firebase\messaging\dist\esm\index.esm.js
node_modules\firebase\messaging\dist\esm\index.esm.js.map
node_modules\firebase\messaging\dist\esm\package.json
node_modules\firebase\messaging\dist\esm\ai\index.d.ts
node_modules\firebase\messaging\dist\esm\analytics\index.d.ts
node_modules\firebase\messaging\dist\esm\app\index.cdn.d.ts
node_modules\firebase\messaging\dist\esm\app\index.d.ts
node_modules\firebase\messaging\dist\esm\app-check\index.d.ts
node_modules\firebase\messaging\dist\esm\auth\index.d.ts
node_modules\firebase\messaging\dist\esm\auth\cordova\index.d.ts
node_modules\firebase\messaging\dist\esm\auth\web-extension\index.d.ts
node_modules\firebase\messaging\dist\esm\compat\index.cdn.d.ts
node_modules\firebase\messaging\dist\esm\compat\index.d.ts
node_modules\firebase\messaging\dist\esm\compat\index.node.d.ts
node_modules\firebase\messaging\dist\esm\compat\index.perf.d.ts
node_modules\firebase\messaging\dist\esm\compat\index.rn.d.ts
node_modules\firebase\messaging\dist\esm\compat\analytics\index.d.ts
node_modules\firebase\messaging\dist\esm\compat\app\index.cdn.d.ts
node_modules\firebase\messaging\dist\esm\compat\app\index.d.ts
node_modules\firebase\messaging\dist\esm\compat\app-check\index.d.ts
node_modules\firebase\messaging\dist\esm\compat\auth\index.d.ts
node_modules\firebase\messaging\dist\esm\compat\database\index.d.ts
node_modules\firebase\messaging\dist\esm\compat\firestore\index.d.ts
node_modules\firebase\messaging\dist\esm\compat\functions\index.d.ts
node_modules\firebase\messaging\dist\esm\compat\installations\index.d.ts
node_modules\firebase\messaging\dist\esm\compat\messaging\index.d.ts
node_modules\firebase\messaging\dist\esm\compat\performance\index.d.ts
node_modules\firebase\messaging\dist\esm\compat\remote-config\index.d.ts
node_modules\firebase\messaging\dist\esm\compat\storage\index.d.ts
node_modules\firebase\messaging\dist\esm\data-connect\index.d.ts
node_modules\firebase\messaging\dist\esm\database\index.d.ts
node_modules\firebase\messaging\dist\esm\firestore\index.d.ts
node_modules\firebase\messaging\dist\esm\firestore\lite\index.d.ts
node_modules\firebase\messaging\dist\esm\firestore\lite\pipelines\index.d.ts
node_modules\firebase\messaging\dist\esm\firestore\pipelines\index.cdn.d.ts
node_modules\firebase\messaging\dist\esm\firestore\pipelines\index.d.ts
node_modules\firebase\messaging\dist\esm\functions\index.d.ts
node_modules\firebase\messaging\dist\esm\installations\index.d.ts
node_modules\firebase\messaging\dist\esm\messaging\index.d.ts
node_modules\firebase\messaging\dist\esm\messaging\sw\index.d.ts
node_modules\firebase\messaging\dist\esm\performance\index.d.ts
node_modules\firebase\messaging\dist\esm\remote-config\index.d.ts
node_modules\firebase\messaging\dist\esm\storage\index.d.ts
node_modules\firebase\messaging\dist\firestore\index.d.ts
node_modules\firebase\messaging\dist\firestore\lite\index.d.ts
node_modules\firebase\messaging\dist\firestore\lite\pipelines\index.d.ts
node_modules\firebase\messaging\dist\firestore\pipelines\index.cdn.d.ts
node_modules\firebase\messaging\dist\firestore\pipelines\index.d.ts
node_modules\firebase\messaging\dist\functions\index.d.ts
node_modules\firebase\messaging\dist\installations\index.d.ts
node_modules\firebase\messaging\dist\messaging\index.d.ts
node_modules\firebase\messaging\dist\messaging\sw\index.d.ts
node_modules\firebase\messaging\dist\performance\index.d.ts
node_modules\firebase\messaging\dist\remote-config\index.d.ts
node_modules\firebase\messaging\dist\storage\index.d.ts
node_modules\firebase\messaging\sw\package.json
node_modules\firebase\messaging\sw\dist\index.cjs.js
node_modules\firebase\messaging\sw\dist\index.cjs.js.map
node_modules\firebase\messaging\sw\dist\index.mjs
node_modules\firebase\messaging\sw\dist\index.mjs.map
node_modules\firebase\messaging\sw\dist\ai\index.d.ts
node_modules\firebase\messaging\sw\dist\analytics\index.d.ts
node_modules\firebase\messaging\sw\dist\app\index.cdn.d.ts
node_modules\firebase\messaging\sw\dist\app\index.d.ts
node_modules\firebase\messaging\sw\dist\app-check\index.d.ts
node_modules\firebase\messaging\sw\dist\auth\index.d.ts
node_modules\firebase\messaging\sw\dist\auth\cordova\index.d.ts
node_modules\firebase\messaging\sw\dist\auth\web-extension\index.d.ts
node_modules\firebase\messaging\sw\dist\compat\index.cdn.d.ts
node_modules\firebase\messaging\sw\dist\compat\index.d.ts
node_modules\firebase\messaging\sw\dist\compat\index.node.d.ts
node_modules\firebase\messaging\sw\dist\compat\index.perf.d.ts
node_modules\firebase\messaging\sw\dist\compat\index.rn.d.ts
node_modules\firebase\messaging\sw\dist\compat\analytics\index.d.ts
node_modules\firebase\messaging\sw\dist\compat\app\index.cdn.d.ts
node_modules\firebase\messaging\sw\dist\compat\app\index.d.ts
node_modules\firebase\messaging\sw\dist\compat\app-check\index.d.ts
node_modules\firebase\messaging\sw\dist\compat\auth\index.d.ts
node_modules\firebase\messaging\sw\dist\compat\database\index.d.ts
node_modules\firebase\messaging\sw\dist\compat\firestore\index.d.ts
node_modules\firebase\messaging\sw\dist\compat\functions\index.d.ts
node_modules\firebase\messaging\sw\dist\compat\installations\index.d.ts
node_modules\firebase\messaging\sw\dist\compat\messaging\index.d.ts
node_modules\firebase\messaging\sw\dist\compat\performance\index.d.ts
node_modules\firebase\messaging\sw\dist\compat\remote-config\index.d.ts
node_modules\firebase\messaging\sw\dist\compat\storage\index.d.ts
node_modules\firebase\messaging\sw\dist\data-connect\index.d.ts
node_modules\firebase\messaging\sw\dist\database\index.d.ts
node_modules\firebase\messaging\sw\dist\esm\index.esm.js
node_modules\firebase\messaging\sw\dist\esm\index.esm.js.map
node_modules\firebase\messaging\sw\dist\esm\package.json
node_modules\firebase\messaging\sw\dist\esm\ai\index.d.ts
node_modules\firebase\messaging\sw\dist\esm\analytics\index.d.ts
node_modules\firebase\messaging\sw\dist\esm\app\index.cdn.d.ts
node_modules\firebase\messaging\sw\dist\esm\app\index.d.ts
node_modules\firebase\messaging\sw\dist\esm\app-check\index.d.ts
node_modules\firebase\messaging\sw\dist\esm\auth\index.d.ts
node_modules\firebase\messaging\sw\dist\esm\auth\cordova\index.d.ts
node_modules\firebase\messaging\sw\dist\esm\auth\web-extension\index.d.ts
node_modules\firebase\messaging\sw\dist\esm\compat\index.cdn.d.ts
node_modules\firebase\messaging\sw\dist\esm\compat\index.d.ts
node_modules\firebase\messaging\sw\dist\esm\compat\index.node.d.ts
node_modules\firebase\messaging\sw\dist\esm\compat\index.perf.d.ts
node_modules\firebase\messaging\sw\dist\esm\compat\index.rn.d.ts
node_modules\firebase\messaging\sw\dist\esm\compat\analytics\index.d.ts
node_modules\firebase\messaging\sw\dist\esm\compat\app\index.cdn.d.ts
node_modules\firebase\messaging\sw\dist\esm\compat\app\index.d.ts
node_modules\firebase\messaging\sw\dist\esm\compat\app-check\index.d.ts
node_modules\firebase\messaging\sw\dist\esm\compat\auth\index.d.ts
node_modules\firebase\messaging\sw\dist\esm\compat\database\index.d.ts
node_modules\firebase\messaging\sw\dist\esm\compat\firestore\index.d.ts
node_modules\firebase\messaging\sw\dist\esm\compat\functions\index.d.ts
node_modules\firebase\messaging\sw\dist\esm\compat\installations\index.d.ts
node_modules\firebase\messaging\sw\dist\esm\compat\messaging\index.d.ts
node_modules\firebase\messaging\sw\dist\esm\compat\performance\index.d.ts
node_modules\firebase\messaging\sw\dist\esm\compat\remote-config\index.d.ts
node_modules\firebase\messaging\sw\dist\esm\compat\storage\index.d.ts
node_modules\firebase\messaging\sw\dist\esm\data-connect\index.d.ts
node_modules\firebase\messaging\sw\dist\esm\database\index.d.ts
node_modules\firebase\messaging\sw\dist\esm\firestore\index.d.ts
node_modules\firebase\messaging\sw\dist\esm\firestore\lite\index.d.ts
node_modules\firebase\messaging\sw\dist\esm\firestore\lite\pipelines\index.d.ts
node_modules\firebase\messaging\sw\dist\esm\firestore\pipelines\index.cdn.d.ts
node_modules\firebase\messaging\sw\dist\esm\firestore\pipelines\index.d.ts
node_modules\firebase\messaging\sw\dist\esm\functions\index.d.ts
node_modules\firebase\messaging\sw\dist\esm\installations\index.d.ts
node_modules\firebase\messaging\sw\dist\esm\messaging\index.d.ts
node_modules\firebase\messaging\sw\dist\esm\messaging\sw\index.d.ts
node_modules\firebase\messaging\sw\dist\esm\performance\index.d.ts
node_modules\firebase\messaging\sw\dist\esm\remote-config\index.d.ts
node_modules\firebase\messaging\sw\dist\esm\storage\index.d.ts
node_modules\firebase\messaging\sw\dist\firestore\index.d.ts
node_modules\firebase\messaging\sw\dist\firestore\lite\index.d.ts
node_modules\firebase\messaging\sw\dist\firestore\lite\pipelines\index.d.ts
node_modules\firebase\messaging\sw\dist\firestore\pipelines\index.cdn.d.ts
node_modules\firebase\messaging\sw\dist\firestore\pipelines\index.d.ts
node_modules\firebase\messaging\sw\dist\functions\index.d.ts
node_modules\firebase\messaging\sw\dist\installations\index.d.ts
node_modules\firebase\messaging\sw\dist\messaging\index.d.ts
node_modules\firebase\messaging\sw\dist\messaging\sw\index.d.ts
node_modules\firebase\messaging\sw\dist\performance\index.d.ts
node_modules\firebase\messaging\sw\dist\remote-config\index.d.ts
node_modules\firebase\messaging\sw\dist\storage\index.d.ts
node_modules\firebase\performance\package.json
node_modules\firebase\performance\dist\index.cjs.js
node_modules\firebase\performance\dist\index.cjs.js.map
node_modules\firebase\performance\dist\index.mjs
node_modules\firebase\performance\dist\index.mjs.map
node_modules\firebase\performance\dist\ai\index.d.ts
node_modules\firebase\performance\dist\analytics\index.d.ts
node_modules\firebase\performance\dist\app\index.cdn.d.ts
node_modules\firebase\performance\dist\app\index.d.ts
node_modules\firebase\performance\dist\app-check\index.d.ts
node_modules\firebase\performance\dist\auth\index.d.ts
node_modules\firebase\performance\dist\auth\cordova\index.d.ts
node_modules\firebase\performance\dist\auth\web-extension\index.d.ts
node_modules\firebase\performance\dist\compat\index.cdn.d.ts
node_modules\firebase\performance\dist\compat\index.d.ts
node_modules\firebase\performance\dist\compat\index.node.d.ts
node_modules\firebase\performance\dist\compat\index.perf.d.ts
node_modules\firebase\performance\dist\compat\index.rn.d.ts
node_modules\firebase\performance\dist\compat\analytics\index.d.ts
node_modules\firebase\performance\dist\compat\app\index.cdn.d.ts
node_modules\firebase\performance\dist\compat\app\index.d.ts
node_modules\firebase\performance\dist\compat\app-check\index.d.ts
node_modules\firebase\performance\dist\compat\auth\index.d.ts
node_modules\firebase\performance\dist\compat\database\index.d.ts
node_modules\firebase\performance\dist\compat\firestore\index.d.ts
node_modules\firebase\performance\dist\compat\functions\index.d.ts
node_modules\firebase\performance\dist\compat\installations\index.d.ts
node_modules\firebase\performance\dist\compat\messaging\index.d.ts
node_modules\firebase\performance\dist\compat\performance\index.d.ts
node_modules\firebase\performance\dist\compat\remote-config\index.d.ts
node_modules\firebase\performance\dist\compat\storage\index.d.ts
node_modules\firebase\performance\dist\data-connect\index.d.ts
node_modules\firebase\performance\dist\database\index.d.ts
node_modules\firebase\performance\dist\esm\index.esm.js
node_modules\firebase\performance\dist\esm\index.esm.js.map
node_modules\firebase\performance\dist\esm\package.json
node_modules\firebase\performance\dist\esm\ai\index.d.ts
node_modules\firebase\performance\dist\esm\analytics\index.d.ts
node_modules\firebase\performance\dist\esm\app\index.cdn.d.ts
node_modules\firebase\performance\dist\esm\app\index.d.ts
node_modules\firebase\performance\dist\esm\app-check\index.d.ts
node_modules\firebase\performance\dist\esm\auth\index.d.ts
node_modules\firebase\performance\dist\esm\auth\cordova\index.d.ts
node_modules\firebase\performance\dist\esm\auth\web-extension\index.d.ts
node_modules\firebase\performance\dist\esm\compat\index.cdn.d.ts
node_modules\firebase\performance\dist\esm\compat\index.d.ts
node_modules\firebase\performance\dist\esm\compat\index.node.d.ts
node_modules\firebase\performance\dist\esm\compat\index.perf.d.ts
node_modules\firebase\performance\dist\esm\compat\index.rn.d.ts
node_modules\firebase\performance\dist\esm\compat\analytics\index.d.ts
node_modules\firebase\performance\dist\esm\compat\app\index.cdn.d.ts
node_modules\firebase\performance\dist\esm\compat\app\index.d.ts
node_modules\firebase\performance\dist\esm\compat\app-check\index.d.ts
node_modules\firebase\performance\dist\esm\compat\auth\index.d.ts
node_modules\firebase\performance\dist\esm\compat\database\index.d.ts
node_modules\firebase\performance\dist\esm\compat\firestore\index.d.ts
node_modules\firebase\performance\dist\esm\compat\functions\index.d.ts
node_modules\firebase\performance\dist\esm\compat\installations\index.d.ts
node_modules\firebase\performance\dist\esm\compat\messaging\index.d.ts
node_modules\firebase\performance\dist\esm\compat\performance\index.d.ts
node_modules\firebase\performance\dist\esm\compat\remote-config\index.d.ts
node_modules\firebase\performance\dist\esm\compat\storage\index.d.ts
node_modules\firebase\performance\dist\esm\data-connect\index.d.ts
node_modules\firebase\performance\dist\esm\database\index.d.ts
node_modules\firebase\performance\dist\esm\firestore\index.d.ts
node_modules\firebase\performance\dist\esm\firestore\lite\index.d.ts
node_modules\firebase\performance\dist\esm\firestore\lite\pipelines\index.d.ts
node_modules\firebase\performance\dist\esm\firestore\pipelines\index.cdn.d.ts
node_modules\firebase\performance\dist\esm\firestore\pipelines\index.d.ts
node_modules\firebase\performance\dist\esm\functions\index.d.ts
node_modules\firebase\performance\dist\esm\installations\index.d.ts
node_modules\firebase\performance\dist\esm\messaging\index.d.ts
node_modules\firebase\performance\dist\esm\messaging\sw\index.d.ts
node_modules\firebase\performance\dist\esm\performance\index.d.ts
node_modules\firebase\performance\dist\esm\remote-config\index.d.ts
node_modules\firebase\performance\dist\esm\storage\index.d.ts
node_modules\firebase\performance\dist\firestore\index.d.ts
node_modules\firebase\performance\dist\firestore\lite\index.d.ts
node_modules\firebase\performance\dist\firestore\lite\pipelines\index.d.ts
node_modules\firebase\performance\dist\firestore\pipelines\index.cdn.d.ts
node_modules\firebase\performance\dist\firestore\pipelines\index.d.ts
node_modules\firebase\performance\dist\functions\index.d.ts
node_modules\firebase\performance\dist\installations\index.d.ts
node_modules\firebase\performance\dist\messaging\index.d.ts
node_modules\firebase\performance\dist\messaging\sw\index.d.ts
node_modules\firebase\performance\dist\performance\index.d.ts
node_modules\firebase\performance\dist\remote-config\index.d.ts
node_modules\firebase\performance\dist\storage\index.d.ts
node_modules\firebase\remote-config\package.json
node_modules\firebase\remote-config\dist\index.cjs.js
node_modules\firebase\remote-config\dist\index.cjs.js.map
node_modules\firebase\remote-config\dist\index.mjs
node_modules\firebase\remote-config\dist\index.mjs.map
node_modules\firebase\remote-config\dist\ai\index.d.ts
node_modules\firebase\remote-config\dist\analytics\index.d.ts
node_modules\firebase\remote-config\dist\app\index.cdn.d.ts
node_modules\firebase\remote-config\dist\app\index.d.ts
node_modules\firebase\remote-config\dist\app-check\index.d.ts
node_modules\firebase\remote-config\dist\auth\index.d.ts
node_modules\firebase\remote-config\dist\auth\cordova\index.d.ts
node_modules\firebase\remote-config\dist\auth\web-extension\index.d.ts
node_modules\firebase\remote-config\dist\compat\index.cdn.d.ts
node_modules\firebase\remote-config\dist\compat\index.d.ts
node_modules\firebase\remote-config\dist\compat\index.node.d.ts
node_modules\firebase\remote-config\dist\compat\index.perf.d.ts
node_modules\firebase\remote-config\dist\compat\index.rn.d.ts
node_modules\firebase\remote-config\dist\compat\analytics\index.d.ts
node_modules\firebase\remote-config\dist\compat\app\index.cdn.d.ts
node_modules\firebase\remote-config\dist\compat\app\index.d.ts
node_modules\firebase\remote-config\dist\compat\app-check\index.d.ts
node_modules\firebase\remote-config\dist\compat\auth\index.d.ts
node_modules\firebase\remote-config\dist\compat\database\index.d.ts
node_modules\firebase\remote-config\dist\compat\firestore\index.d.ts
node_modules\firebase\remote-config\dist\compat\functions\index.d.ts
node_modules\firebase\remote-config\dist\compat\installations\index.d.ts
node_modules\firebase\remote-config\dist\compat\messaging\index.d.ts
node_modules\firebase\remote-config\dist\compat\performance\index.d.ts
node_modules\firebase\remote-config\dist\compat\remote-config\index.d.ts
node_modules\firebase\remote-config\dist\compat\storage\index.d.ts
node_modules\firebase\remote-config\dist\data-connect\index.d.ts
node_modules\firebase\remote-config\dist\database\index.d.ts
node_modules\firebase\remote-config\dist\esm\index.esm.js
node_modules\firebase\remote-config\dist\esm\index.esm.js.map
node_modules\firebase\remote-config\dist\esm\package.json
node_modules\firebase\remote-config\dist\esm\ai\index.d.ts
node_modules\firebase\remote-config\dist\esm\analytics\index.d.ts
node_modules\firebase\remote-config\dist\esm\app\index.cdn.d.ts
node_modules\firebase\remote-config\dist\esm\app\index.d.ts
node_modules\firebase\remote-config\dist\esm\app-check\index.d.ts
node_modules\firebase\remote-config\dist\esm\auth\index.d.ts
node_modules\firebase\remote-config\dist\esm\auth\cordova\index.d.ts
node_modules\firebase\remote-config\dist\esm\auth\web-extension\index.d.ts
node_modules\firebase\remote-config\dist\esm\compat\index.cdn.d.ts
node_modules\firebase\remote-config\dist\esm\compat\index.d.ts
node_modules\firebase\remote-config\dist\esm\compat\index.node.d.ts
node_modules\firebase\remote-config\dist\esm\compat\index.perf.d.ts
node_modules\firebase\remote-config\dist\esm\compat\index.rn.d.ts
node_modules\firebase\remote-config\dist\esm\compat\analytics\index.d.ts
node_modules\firebase\remote-config\dist\esm\compat\app\index.cdn.d.ts
node_modules\firebase\remote-config\dist\esm\compat\app\index.d.ts
node_modules\firebase\remote-config\dist\esm\compat\app-check\index.d.ts
node_modules\firebase\remote-config\dist\esm\compat\auth\index.d.ts
node_modules\firebase\remote-config\dist\esm\compat\database\index.d.ts
node_modules\firebase\remote-config\dist\esm\compat\firestore\index.d.ts
node_modules\firebase\remote-config\dist\esm\compat\functions\index.d.ts
node_modules\firebase\remote-config\dist\esm\compat\installations\index.d.ts
node_modules\firebase\remote-config\dist\esm\compat\messaging\index.d.ts
node_modules\firebase\remote-config\dist\esm\compat\performance\index.d.ts
node_modules\firebase\remote-config\dist\esm\compat\remote-config\index.d.ts
node_modules\firebase\remote-config\dist\esm\compat\storage\index.d.ts
node_modules\firebase\remote-config\dist\esm\data-connect\index.d.ts
node_modules\firebase\remote-config\dist\esm\database\index.d.ts
node_modules\firebase\remote-config\dist\esm\firestore\index.d.ts
node_modules\firebase\remote-config\dist\esm\firestore\lite\index.d.ts
node_modules\firebase\remote-config\dist\esm\firestore\lite\pipelines\index.d.ts
node_modules\firebase\remote-config\dist\esm\firestore\pipelines\index.cdn.d.ts
node_modules\firebase\remote-config\dist\esm\firestore\pipelines\index.d.ts
node_modules\firebase\remote-config\dist\esm\functions\index.d.ts
node_modules\firebase\remote-config\dist\esm\installations\index.d.ts
node_modules\firebase\remote-config\dist\esm\messaging\index.d.ts
node_modules\firebase\remote-config\dist\esm\messaging\sw\index.d.ts
node_modules\firebase\remote-config\dist\esm\performance\index.d.ts
node_modules\firebase\remote-config\dist\esm\remote-config\index.d.ts
node_modules\firebase\remote-config\dist\esm\storage\index.d.ts
node_modules\firebase\remote-config\dist\firestore\index.d.ts
node_modules\firebase\remote-config\dist\firestore\lite\index.d.ts
node_modules\firebase\remote-config\dist\firestore\lite\pipelines\index.d.ts
node_modules\firebase\remote-config\dist\firestore\pipelines\index.cdn.d.ts
node_modules\firebase\remote-config\dist\firestore\pipelines\index.d.ts
node_modules\firebase\remote-config\dist\functions\index.d.ts
node_modules\firebase\remote-config\dist\installations\index.d.ts
node_modules\firebase\remote-config\dist\messaging\index.d.ts
node_modules\firebase\remote-config\dist\messaging\sw\index.d.ts
node_modules\firebase\remote-config\dist\performance\index.d.ts
node_modules\firebase\remote-config\dist\remote-config\index.d.ts
node_modules\firebase\remote-config\dist\storage\index.d.ts
node_modules\firebase\storage\package.json
node_modules\firebase\storage\dist\index.cjs.js
node_modules\firebase\storage\dist\index.cjs.js.map
node_modules\firebase\storage\dist\index.mjs
node_modules\firebase\storage\dist\index.mjs.map
node_modules\firebase\storage\dist\ai\index.d.ts
node_modules\firebase\storage\dist\analytics\index.d.ts
node_modules\firebase\storage\dist\app\index.cdn.d.ts
node_modules\firebase\storage\dist\app\index.d.ts
node_modules\firebase\storage\dist\app-check\index.d.ts
node_modules\firebase\storage\dist\auth\index.d.ts
node_modules\firebase\storage\dist\auth\cordova\index.d.ts
node_modules\firebase\storage\dist\auth\web-extension\index.d.ts
node_modules\firebase\storage\dist\compat\index.cdn.d.ts
node_modules\firebase\storage\dist\compat\index.d.ts
node_modules\firebase\storage\dist\compat\index.node.d.ts
node_modules\firebase\storage\dist\compat\index.perf.d.ts
node_modules\firebase\storage\dist\compat\index.rn.d.ts
node_modules\firebase\storage\dist\compat\analytics\index.d.ts
node_modules\firebase\storage\dist\compat\app\index.cdn.d.ts
node_modules\firebase\storage\dist\compat\app\index.d.ts
node_modules\firebase\storage\dist\compat\app-check\index.d.ts
node_modules\firebase\storage\dist\compat\auth\index.d.ts
node_modules\firebase\storage\dist\compat\database\index.d.ts
node_modules\firebase\storage\dist\compat\firestore\index.d.ts
node_modules\firebase\storage\dist\compat\functions\index.d.ts
node_modules\firebase\storage\dist\compat\installations\index.d.ts
node_modules\firebase\storage\dist\compat\messaging\index.d.ts
node_modules\firebase\storage\dist\compat\performance\index.d.ts
node_modules\firebase\storage\dist\compat\remote-config\index.d.ts
node_modules\firebase\storage\dist\compat\storage\index.d.ts
node_modules\firebase\storage\dist\data-connect\index.d.ts
node_modules\firebase\storage\dist\database\index.d.ts
node_modules\firebase\storage\dist\esm\index.esm.js
node_modules\firebase\storage\dist\esm\index.esm.js.map
node_modules\firebase\storage\dist\esm\package.json
node_modules\firebase\storage\dist\esm\ai\index.d.ts
node_modules\firebase\storage\dist\esm\analytics\index.d.ts
node_modules\firebase\storage\dist\esm\app\index.cdn.d.ts
node_modules\firebase\storage\dist\esm\app\index.d.ts
node_modules\firebase\storage\dist\esm\app-check\index.d.ts
node_modules\firebase\storage\dist\esm\auth\index.d.ts
node_modules\firebase\storage\dist\esm\auth\cordova\index.d.ts
node_modules\firebase\storage\dist\esm\auth\web-extension\index.d.ts
node_modules\firebase\storage\dist\esm\compat\index.cdn.d.ts
node_modules\firebase\storage\dist\esm\compat\index.d.ts
node_modules\firebase\storage\dist\esm\compat\index.node.d.ts
node_modules\firebase\storage\dist\esm\compat\index.perf.d.ts
node_modules\firebase\storage\dist\esm\compat\index.rn.d.ts
node_modules\firebase\storage\dist\esm\compat\analytics\index.d.ts
node_modules\firebase\storage\dist\esm\compat\app\index.cdn.d.ts
node_modules\firebase\storage\dist\esm\compat\app\index.d.ts
node_modules\firebase\storage\dist\esm\compat\app-check\index.d.ts
node_modules\firebase\storage\dist\esm\compat\auth\index.d.ts
node_modules\firebase\storage\dist\esm\compat\database\index.d.ts
node_modules\firebase\storage\dist\esm\compat\firestore\index.d.ts
node_modules\firebase\storage\dist\esm\compat\functions\index.d.ts
node_modules\firebase\storage\dist\esm\compat\installations\index.d.ts
node_modules\firebase\storage\dist\esm\compat\messaging\index.d.ts
node_modules\firebase\storage\dist\esm\compat\performance\index.d.ts
node_modules\firebase\storage\dist\esm\compat\remote-config\index.d.ts
node_modules\firebase\storage\dist\esm\compat\storage\index.d.ts
node_modules\firebase\storage\dist\esm\data-connect\index.d.ts
node_modules\firebase\storage\dist\esm\database\index.d.ts
node_modules\firebase\storage\dist\esm\firestore\index.d.ts
node_modules\firebase\storage\dist\esm\firestore\lite\index.d.ts
node_modules\firebase\storage\dist\esm\firestore\lite\pipelines\index.d.ts
node_modules\firebase\storage\dist\esm\firestore\pipelines\index.cdn.d.ts
node_modules\firebase\storage\dist\esm\firestore\pipelines\index.d.ts
node_modules\firebase\storage\dist\esm\functions\index.d.ts
node_modules\firebase\storage\dist\esm\installations\index.d.ts
node_modules\firebase\storage\dist\esm\messaging\index.d.ts
node_modules\firebase\storage\dist\esm\messaging\sw\index.d.ts
node_modules\firebase\storage\dist\esm\performance\index.d.ts
node_modules\firebase\storage\dist\esm\remote-config\index.d.ts
node_modules\firebase\storage\dist\esm\storage\index.d.ts
node_modules\firebase\storage\dist\firestore\index.d.ts
node_modules\firebase\storage\dist\firestore\lite\index.d.ts
node_modules\firebase\storage\dist\firestore\lite\pipelines\index.d.ts
node_modules\firebase\storage\dist\firestore\pipelines\index.cdn.d.ts
node_modules\firebase\storage\dist\firestore\pipelines\index.d.ts
node_modules\firebase\storage\dist\functions\index.d.ts
node_modules\firebase\storage\dist\installations\index.d.ts
node_modules\firebase\storage\dist\messaging\index.d.ts
node_modules\firebase\storage\dist\messaging\sw\index.d.ts
node_modules\firebase\storage\dist\performance\index.d.ts
node_modules\firebase\storage\dist\remote-config\index.d.ts
node_modules\firebase\storage\dist\storage\index.d.ts
node_modules\get-caller-file\index.d.ts
node_modules\get-caller-file\index.js
node_modules\get-caller-file\index.js.map
node_modules\get-caller-file\LICENSE.md
node_modules\get-caller-file\package.json
node_modules\get-caller-file\README.md
node_modules\http-parser-js\http-parser.d.ts
node_modules\http-parser-js\http-parser.js
node_modules\http-parser-js\LICENSE.md
node_modules\http-parser-js\package.json
node_modules\http-parser-js\README.md
node_modules\idb\CHANGELOG.md
node_modules\idb\LICENSE
node_modules\idb\package.json
node_modules\idb\README.md
node_modules\idb\with-async-ittr.cjs
node_modules\idb\with-async-ittr.d.ts
node_modules\idb\with-async-ittr.js
node_modules\idb\build\async-iterators.cjs
node_modules\idb\build\async-iterators.d.ts
node_modules\idb\build\async-iterators.js
node_modules\idb\build\database-extras.d.ts
node_modules\idb\build\entry.d.ts
node_modules\idb\build\index.cjs
node_modules\idb\build\index.d.ts
node_modules\idb\build\index.js
node_modules\idb\build\umd-with-async-ittr.js
node_modules\idb\build\umd.js
node_modules\idb\build\util.d.ts
node_modules\idb\build\wrap-idb-value.cjs
node_modules\idb\build\wrap-idb-value.d.ts
node_modules\idb\build\wrap-idb-value.js
node_modules\is-fullwidth-code-point\index.d.ts
node_modules\is-fullwidth-code-point\index.js
node_modules\is-fullwidth-code-point\license
node_modules\is-fullwidth-code-point\package.json
node_modules\is-fullwidth-code-point\readme.md
node_modules\lodash.camelcase\index.js
node_modules\lodash.camelcase\LICENSE
node_modules\lodash.camelcase\package.json
node_modules\lodash.camelcase\README.md
node_modules\long\index.d.ts
node_modules\long\index.js
node_modules\long\LICENSE
node_modules\long\package.json
node_modules\long\README.md
node_modules\long\types.d.ts
node_modules\long\umd\index.d.ts
node_modules\long\umd\index.js
node_modules\long\umd\package.json
node_modules\long\umd\types.d.ts
node_modules\protobufjs\index.d.ts
node_modules\protobufjs\index.js
node_modules\protobufjs\LICENSE
node_modules\protobufjs\light.d.ts
node_modules\protobufjs\light.js
node_modules\protobufjs\minimal.d.ts
node_modules\protobufjs\minimal.js
node_modules\protobufjs\package.json
node_modules\protobufjs\README.md
node_modules\protobufjs\tsconfig.json
node_modules\protobufjs\dist\protobuf.js
node_modules\protobufjs\dist\protobuf.js.map
node_modules\protobufjs\dist\protobuf.min.js
node_modules\protobufjs\dist\protobuf.min.js.map
node_modules\protobufjs\dist\light\protobuf.js
node_modules\protobufjs\dist\light\protobuf.js.map
node_modules\protobufjs\dist\light\protobuf.min.js
node_modules\protobufjs\dist\light\protobuf.min.js.map
node_modules\protobufjs\dist\minimal\protobuf.js
node_modules\protobufjs\dist\minimal\protobuf.js.map
node_modules\protobufjs\dist\minimal\protobuf.min.js
node_modules\protobufjs\dist\minimal\protobuf.min.js.map
node_modules\protobufjs\ext\debug\index.js
node_modules\protobufjs\ext\debug\README.md
node_modules\protobufjs\ext\descriptor\index.d.ts
node_modules\protobufjs\ext\descriptor\index.js
node_modules\protobufjs\ext\descriptor\README.md
node_modules\protobufjs\ext\descriptor\test.js
node_modules\protobufjs\google\LICENSE
node_modules\protobufjs\google\README.md
node_modules\protobufjs\google\api\annotations.json
node_modules\protobufjs\google\api\annotations.proto
node_modules\protobufjs\google\api\http.json
node_modules\protobufjs\google\api\http.proto
node_modules\protobufjs\google\protobuf\api.json
node_modules\protobufjs\google\protobuf\api.proto
node_modules\protobufjs\google\protobuf\descriptor.json
node_modules\protobufjs\google\protobuf\descriptor.proto
node_modules\protobufjs\google\protobuf\source_context.json
node_modules\protobufjs\google\protobuf\source_context.proto
node_modules\protobufjs\google\protobuf\type.json
node_modules\protobufjs\google\protobuf\type.proto
node_modules\protobufjs\scripts\postinstall.js
node_modules\protobufjs\src\common.js
node_modules\protobufjs\src\converter.js
node_modules\protobufjs\src\decoder.js
node_modules\protobufjs\src\encoder.js
node_modules\protobufjs\src\enum.js
node_modules\protobufjs\src\field.js
node_modules\protobufjs\src\index-light.js
node_modules\protobufjs\src\index-minimal.js
node_modules\protobufjs\src\index.js
node_modules\protobufjs\src\mapfield.js
node_modules\protobufjs\src\message.js
node_modules\protobufjs\src\method.js
node_modules\protobufjs\src\namespace.js
node_modules\protobufjs\src\object.js
node_modules\protobufjs\src\oneof.js
node_modules\protobufjs\src\parse.js
node_modules\protobufjs\src\reader.js
node_modules\protobufjs\src\reader_buffer.js
node_modules\protobufjs\src\root.js
node_modules\protobufjs\src\roots.js
node_modules\protobufjs\src\rpc.js
node_modules\protobufjs\src\service.js
node_modules\protobufjs\src\tokenize.js
node_modules\protobufjs\src\type.js
node_modules\protobufjs\src\types.js
node_modules\protobufjs\src\typescript.jsdoc
node_modules\protobufjs\src\util.js
node_modules\protobufjs\src\verifier.js
node_modules\protobufjs\src\wrappers.js
node_modules\protobufjs\src\writer.js
node_modules\protobufjs\src\writer_buffer.js
node_modules\protobufjs\src\rpc\service.js
node_modules\protobufjs\src\util\longbits.js
node_modules\protobufjs\src\util\minimal.js
node_modules\require-directory\.jshintrc
node_modules\require-directory\.npmignore
node_modules\require-directory\.travis.yml
node_modules\require-directory\index.js
node_modules\require-directory\LICENSE
node_modules\require-directory\package.json
node_modules\require-directory\README.markdown
node_modules\safe-buffer\index.d.ts
node_modules\safe-buffer\index.js
node_modules\safe-buffer\LICENSE
node_modules\safe-buffer\package.json
node_modules\safe-buffer\README.md
node_modules\string-width\index.d.ts
node_modules\string-width\index.js
node_modules\string-width\license
node_modules\string-width\package.json
node_modules\string-width\readme.md
node_modules\strip-ansi\index.d.ts
node_modules\strip-ansi\index.js
node_modules\strip-ansi\license
node_modules\strip-ansi\package.json
node_modules\strip-ansi\readme.md
node_modules\tslib\CopyrightNotice.txt
node_modules\tslib\LICENSE.txt
node_modules\tslib\package.json
node_modules\tslib\README.md
node_modules\tslib\SECURITY.md
node_modules\tslib\tslib.d.ts
node_modules\tslib\tslib.es6.html
node_modules\tslib\tslib.es6.js
node_modules\tslib\tslib.es6.mjs
node_modules\tslib\tslib.html
node_modules\tslib\tslib.js
node_modules\tslib\modules\index.d.ts
node_modules\tslib\modules\index.js
node_modules\tslib\modules\package.json
node_modules\undici-types\agent.d.ts
node_modules\undici-types\api.d.ts
node_modules\undici-types\balanced-pool.d.ts
node_modules\undici-types\cache-interceptor.d.ts
node_modules\undici-types\cache.d.ts
node_modules\undici-types\client-stats.d.ts
node_modules\undici-types\client.d.ts
node_modules\undici-types\connector.d.ts
node_modules\undici-types\content-type.d.ts
node_modules\undici-types\cookies.d.ts
node_modules\undici-types\diagnostics-channel.d.ts
node_modules\undici-types\dispatcher.d.ts
node_modules\undici-types\env-http-proxy-agent.d.ts
node_modules\undici-types\errors.d.ts
node_modules\undici-types\eventsource.d.ts
node_modules\undici-types\fetch.d.ts
node_modules\undici-types\formdata.d.ts
node_modules\undici-types\global-dispatcher.d.ts
node_modules\undici-types\global-origin.d.ts
node_modules\undici-types\h2c-client.d.ts
node_modules\undici-types\handlers.d.ts
node_modules\undici-types\header.d.ts
node_modules\undici-types\index.d.ts
node_modules\undici-types\interceptors.d.ts
node_modules\undici-types\LICENSE
node_modules\undici-types\mock-agent.d.ts
node_modules\undici-types\mock-call-history.d.ts
node_modules\undici-types\mock-client.d.ts
node_modules\undici-types\mock-errors.d.ts
node_modules\undici-types\mock-interceptor.d.ts
node_modules\undici-types\mock-pool.d.ts
node_modules\undici-types\package.json
node_modules\undici-types\patch.d.ts
node_modules\undici-types\pool-stats.d.ts
node_modules\undici-types\pool.d.ts
node_modules\undici-types\proxy-agent.d.ts
node_modules\undici-types\readable.d.ts
node_modules\undici-types\README.md
node_modules\undici-types\retry-agent.d.ts
node_modules\undici-types\retry-handler.d.ts
node_modules\undici-types\snapshot-agent.d.ts
node_modules\undici-types\util.d.ts
node_modules\undici-types\utility.d.ts
node_modules\undici-types\webidl.d.ts
node_modules\undici-types\websocket.d.ts
node_modules\web-vitals\attribution.d.ts
node_modules\web-vitals\attribution.js
node_modules\web-vitals\LICENSE
node_modules\web-vitals\package.json
node_modules\web-vitals\README.md
node_modules\web-vitals\dist\web-vitals.attribution.iife.js
node_modules\web-vitals\dist\web-vitals.attribution.js
node_modules\web-vitals\dist\web-vitals.attribution.umd.cjs
node_modules\web-vitals\dist\web-vitals.iife.js
node_modules\web-vitals\dist\web-vitals.js
node_modules\web-vitals\dist\web-vitals.umd.cjs
node_modules\web-vitals\dist\modules\deprecated.d.ts
node_modules\web-vitals\dist\modules\deprecated.js
node_modules\web-vitals\dist\modules\index.d.ts
node_modules\web-vitals\dist\modules\index.js
node_modules\web-vitals\dist\modules\onCLS.d.ts
node_modules\web-vitals\dist\modules\onCLS.js
node_modules\web-vitals\dist\modules\onFCP.d.ts
node_modules\web-vitals\dist\modules\onFCP.js
node_modules\web-vitals\dist\modules\onFID.d.ts
node_modules\web-vitals\dist\modules\onFID.js
node_modules\web-vitals\dist\modules\onINP.d.ts
node_modules\web-vitals\dist\modules\onINP.js
node_modules\web-vitals\dist\modules\onLCP.d.ts
node_modules\web-vitals\dist\modules\onLCP.js
node_modules\web-vitals\dist\modules\onTTFB.d.ts
node_modules\web-vitals\dist\modules\onTTFB.js
node_modules\web-vitals\dist\modules\types.d.ts
node_modules\web-vitals\dist\modules\types.js
node_modules\web-vitals\dist\modules\attribution\deprecated.d.ts
node_modules\web-vitals\dist\modules\attribution\deprecated.js
node_modules\web-vitals\dist\modules\attribution\index.d.ts
node_modules\web-vitals\dist\modules\attribution\index.js
node_modules\web-vitals\dist\modules\attribution\onCLS.d.ts
node_modules\web-vitals\dist\modules\attribution\onCLS.js
node_modules\web-vitals\dist\modules\attribution\onFCP.d.ts
node_modules\web-vitals\dist\modules\attribution\onFCP.js
node_modules\web-vitals\dist\modules\attribution\onFID.d.ts
node_modules\web-vitals\dist\modules\attribution\onFID.js
node_modules\web-vitals\dist\modules\attribution\onINP.d.ts
node_modules\web-vitals\dist\modules\attribution\onINP.js
node_modules\web-vitals\dist\modules\attribution\onLCP.d.ts
node_modules\web-vitals\dist\modules\attribution\onLCP.js
node_modules\web-vitals\dist\modules\attribution\onTTFB.d.ts
node_modules\web-vitals\dist\modules\attribution\onTTFB.js
node_modules\web-vitals\dist\modules\lib\bfcache.d.ts
node_modules\web-vitals\dist\modules\lib\bfcache.js
node_modules\web-vitals\dist\modules\lib\bindReporter.d.ts
node_modules\web-vitals\dist\modules\lib\bindReporter.js
node_modules\web-vitals\dist\modules\lib\doubleRAF.d.ts
node_modules\web-vitals\dist\modules\lib\doubleRAF.js
node_modules\web-vitals\dist\modules\lib\generateUniqueID.d.ts
node_modules\web-vitals\dist\modules\lib\generateUniqueID.js
node_modules\web-vitals\dist\modules\lib\getActivationStart.d.ts
node_modules\web-vitals\dist\modules\lib\getActivationStart.js
node_modules\web-vitals\dist\modules\lib\getLoadState.d.ts
node_modules\web-vitals\dist\modules\lib\getLoadState.js
node_modules\web-vitals\dist\modules\lib\getNavigationEntry.d.ts
node_modules\web-vitals\dist\modules\lib\getNavigationEntry.js
node_modules\web-vitals\dist\modules\lib\getSelector.d.ts
node_modules\web-vitals\dist\modules\lib\getSelector.js
node_modules\web-vitals\dist\modules\lib\getVisibilityWatcher.d.ts
node_modules\web-vitals\dist\modules\lib\getVisibilityWatcher.js
node_modules\web-vitals\dist\modules\lib\initMetric.d.ts
node_modules\web-vitals\dist\modules\lib\initMetric.js
node_modules\web-vitals\dist\modules\lib\interactions.d.ts
node_modules\web-vitals\dist\modules\lib\interactions.js
node_modules\web-vitals\dist\modules\lib\observe.d.ts
node_modules\web-vitals\dist\modules\lib\observe.js
node_modules\web-vitals\dist\modules\lib\onHidden.d.ts
node_modules\web-vitals\dist\modules\lib\onHidden.js
node_modules\web-vitals\dist\modules\lib\runOnce.d.ts
node_modules\web-vitals\dist\modules\lib\runOnce.js
node_modules\web-vitals\dist\modules\lib\whenActivated.d.ts
node_modules\web-vitals\dist\modules\lib\whenActivated.js
node_modules\web-vitals\dist\modules\lib\whenIdle.d.ts
node_modules\web-vitals\dist\modules\lib\whenIdle.js
node_modules\web-vitals\dist\modules\lib\polyfills\firstInputPolyfill.d.ts
node_modules\web-vitals\dist\modules\lib\polyfills\firstInputPolyfill.js
node_modules\web-vitals\dist\modules\lib\polyfills\getFirstHiddenTimePolyfill.d.
ts                                                                              node_modules\web-vitals\dist\modules\lib\polyfills\getFirstHiddenTimePolyfill.js
node_modules\web-vitals\dist\modules\lib\polyfills\interactionCountPolyfill.d.ts
node_modules\web-vitals\dist\modules\lib\polyfills\interactionCountPolyfill.js
node_modules\web-vitals\dist\modules\types\base.d.ts
node_modules\web-vitals\dist\modules\types\base.js
node_modules\web-vitals\dist\modules\types\cls.d.ts
node_modules\web-vitals\dist\modules\types\cls.js
node_modules\web-vitals\dist\modules\types\fcp.d.ts
node_modules\web-vitals\dist\modules\types\fcp.js
node_modules\web-vitals\dist\modules\types\fid.d.ts
node_modules\web-vitals\dist\modules\types\fid.js
node_modules\web-vitals\dist\modules\types\inp.d.ts
node_modules\web-vitals\dist\modules\types\inp.js
node_modules\web-vitals\dist\modules\types\lcp.d.ts
node_modules\web-vitals\dist\modules\types\lcp.js
node_modules\web-vitals\dist\modules\types\polyfills.d.ts
node_modules\web-vitals\dist\modules\types\polyfills.js
node_modules\web-vitals\dist\modules\types\ttfb.d.ts
node_modules\web-vitals\dist\modules\types\ttfb.js
node_modules\web-vitals\src\deprecated.ts
node_modules\web-vitals\src\index.ts
node_modules\web-vitals\src\onCLS.ts
node_modules\web-vitals\src\onFCP.ts
node_modules\web-vitals\src\onFID.ts
node_modules\web-vitals\src\onINP.ts
node_modules\web-vitals\src\onLCP.ts
node_modules\web-vitals\src\onTTFB.ts
node_modules\web-vitals\src\types.ts
node_modules\web-vitals\src\attribution\deprecated.ts
node_modules\web-vitals\src\attribution\index.ts
node_modules\web-vitals\src\attribution\onCLS.ts
node_modules\web-vitals\src\attribution\onFCP.ts
node_modules\web-vitals\src\attribution\onFID.ts
node_modules\web-vitals\src\attribution\onINP.ts
node_modules\web-vitals\src\attribution\onLCP.ts
node_modules\web-vitals\src\attribution\onTTFB.ts
node_modules\web-vitals\src\lib\bfcache.ts
node_modules\web-vitals\src\lib\bindReporter.ts
node_modules\web-vitals\src\lib\doubleRAF.ts
node_modules\web-vitals\src\lib\generateUniqueID.ts
node_modules\web-vitals\src\lib\getActivationStart.ts
node_modules\web-vitals\src\lib\getLoadState.ts
node_modules\web-vitals\src\lib\getNavigationEntry.ts
node_modules\web-vitals\src\lib\getSelector.ts
node_modules\web-vitals\src\lib\getVisibilityWatcher.ts
node_modules\web-vitals\src\lib\initMetric.ts
node_modules\web-vitals\src\lib\interactions.ts
node_modules\web-vitals\src\lib\observe.ts
node_modules\web-vitals\src\lib\onHidden.ts
node_modules\web-vitals\src\lib\runOnce.ts
node_modules\web-vitals\src\lib\whenActivated.ts
node_modules\web-vitals\src\lib\whenIdle.ts
node_modules\web-vitals\src\lib\polyfills\firstInputPolyfill.ts
node_modules\web-vitals\src\lib\polyfills\getFirstHiddenTimePolyfill.ts
node_modules\web-vitals\src\lib\polyfills\interactionCountPolyfill.ts
node_modules\web-vitals\src\types\base.ts
node_modules\web-vitals\src\types\cls.ts
node_modules\web-vitals\src\types\fcp.ts
node_modules\web-vitals\src\types\fid.ts
node_modules\web-vitals\src\types\inp.ts
node_modules\web-vitals\src\types\lcp.ts
node_modules\web-vitals\src\types\polyfills.ts
node_modules\web-vitals\src\types\ttfb.ts
node_modules\websocket-driver\CHANGELOG.md
node_modules\websocket-driver\LICENSE.md
node_modules\websocket-driver\package.json
node_modules\websocket-driver\README.md
node_modules\websocket-driver\lib\websocket\driver.js
node_modules\websocket-driver\lib\websocket\http_parser.js
node_modules\websocket-driver\lib\websocket\streams.js
node_modules\websocket-driver\lib\websocket\driver\base.js
node_modules\websocket-driver\lib\websocket\driver\client.js
node_modules\websocket-driver\lib\websocket\driver\draft75.js
node_modules\websocket-driver\lib\websocket\driver\draft76.js
node_modules\websocket-driver\lib\websocket\driver\headers.js
node_modules\websocket-driver\lib\websocket\driver\hybi.js
node_modules\websocket-driver\lib\websocket\driver\proxy.js
node_modules\websocket-driver\lib\websocket\driver\server.js
node_modules\websocket-driver\lib\websocket\driver\stream_reader.js
node_modules\websocket-driver\lib\websocket\driver\hybi\frame.js
node_modules\websocket-driver\lib\websocket\driver\hybi\message.js
node_modules\websocket-extensions\CHANGELOG.md
node_modules\websocket-extensions\LICENSE.md
node_modules\websocket-extensions\package.json
node_modules\websocket-extensions\README.md
node_modules\websocket-extensions\lib\parser.js
node_modules\websocket-extensions\lib\websocket_extensions.js
node_modules\websocket-extensions\lib\pipeline\cell.js
node_modules\websocket-extensions\lib\pipeline\functor.js
node_modules\websocket-extensions\lib\pipeline\index.js
node_modules\websocket-extensions\lib\pipeline\pledge.js
node_modules\websocket-extensions\lib\pipeline\README.md
node_modules\websocket-extensions\lib\pipeline\ring_buffer.js
node_modules\wrap-ansi\index.js
node_modules\wrap-ansi\license
node_modules\wrap-ansi\package.json
node_modules\wrap-ansi\readme.md
node_modules\y18n\CHANGELOG.md
node_modules\y18n\index.mjs
node_modules\y18n\LICENSE
node_modules\y18n\package.json
node_modules\y18n\README.md
node_modules\y18n\build\index.cjs
node_modules\y18n\build\lib\cjs.js
node_modules\y18n\build\lib\index.js
node_modules\y18n\build\lib\platform-shims\node.js
node_modules\yargs\browser.d.ts
node_modules\yargs\browser.mjs
node_modules\yargs\index.cjs
node_modules\yargs\index.mjs
node_modules\yargs\LICENSE
node_modules\yargs\package.json
node_modules\yargs\README.md
node_modules\yargs\yargs
node_modules\yargs\yargs.mjs
node_modules\yargs\build\index.cjs
node_modules\yargs\build\lib\argsert.js
node_modules\yargs\build\lib\command.js
node_modules\yargs\build\lib\completion-templates.js
node_modules\yargs\build\lib\completion.js
node_modules\yargs\build\lib\middleware.js
node_modules\yargs\build\lib\parse-command.js
node_modules\yargs\build\lib\usage.js
node_modules\yargs\build\lib\validation.js
node_modules\yargs\build\lib\yargs-factory.js
node_modules\yargs\build\lib\yerror.js
node_modules\yargs\build\lib\typings\common-types.js
node_modules\yargs\build\lib\typings\yargs-parser-types.js
node_modules\yargs\build\lib\utils\apply-extends.js
node_modules\yargs\build\lib\utils\is-promise.js
node_modules\yargs\build\lib\utils\levenshtein.js
node_modules\yargs\build\lib\utils\maybe-async-result.js
node_modules\yargs\build\lib\utils\obj-filter.js
node_modules\yargs\build\lib\utils\process-argv.js
node_modules\yargs\build\lib\utils\set-blocking.js
node_modules\yargs\build\lib\utils\which-module.js
node_modules\yargs\helpers\helpers.mjs
node_modules\yargs\helpers\index.js
node_modules\yargs\helpers\package.json
node_modules\yargs\lib\platform-shims\browser.mjs
node_modules\yargs\lib\platform-shims\esm.mjs
node_modules\yargs\locales\be.json
node_modules\yargs\locales\cs.json
node_modules\yargs\locales\de.json
node_modules\yargs\locales\en.json
node_modules\yargs\locales\es.json
node_modules\yargs\locales\fi.json
node_modules\yargs\locales\fr.json
node_modules\yargs\locales\hi.json
node_modules\yargs\locales\hu.json
node_modules\yargs\locales\id.json
node_modules\yargs\locales\it.json
node_modules\yargs\locales\ja.json
node_modules\yargs\locales\ko.json
node_modules\yargs\locales\nb.json
node_modules\yargs\locales\nl.json
node_modules\yargs\locales\nn.json
node_modules\yargs\locales\pirate.json
node_modules\yargs\locales\pl.json
node_modules\yargs\locales\pt.json
node_modules\yargs\locales\pt_BR.json
node_modules\yargs\locales\ru.json
node_modules\yargs\locales\th.json
node_modules\yargs\locales\tr.json
node_modules\yargs\locales\uk_UA.json
node_modules\yargs\locales\uz.json
node_modules\yargs\locales\zh_CN.json
node_modules\yargs\locales\zh_TW.json
node_modules\yargs-parser\browser.js
node_modules\yargs-parser\CHANGELOG.md
node_modules\yargs-parser\LICENSE.txt
node_modules\yargs-parser\package.json
node_modules\yargs-parser\README.md
node_modules\yargs-parser\build\index.cjs
node_modules\yargs-parser\build\lib\index.js
node_modules\yargs-parser\build\lib\string-utils.js
node_modules\yargs-parser\build\lib\tokenize-arg-string.js
node_modules\yargs-parser\build\lib\yargs-parser-types.js
node_modules\yargs-parser\build\lib\yargs-parser.js
test\widget_test.dart
web\favicon.png
web\index.html
web\manifest.json
web\icons\Icon-192.png
web\icons\Icon-512.png
web\icons\Icon-maskable-192.png
web\icons\Icon-maskable-512.png
windows\.gitignore
windows\CMakeLists.txt
windows\flutter\CMakeLists.txt
windows\flutter\generated_plugins.cmake
windows\flutter\generated_plugin_registrant.cc
windows\flutter\generated_plugin_registrant.h
windows\runner\CMakeLists.txt
windows\runner\flutter_window.cpp
windows\runner\flutter_window.h
windows\runner\main.cpp
windows\runner\resource.h
windows\runner\runner.exe.manifest
windows\runner\Runner.rc
windows\runner\utils.cpp
windows\runner\utils.h
windows\runner\win32_window.cpp
windows\runner\win32_window.h
windows\runner\resources\app_icon.ico
```

## 4. Features & Pages

### 4.1 `LandingPage` - `lib/landinpage.dart`

- Purpose:
  - Marketing/landing experience.
  - Highlights features and flow.
  - CTA navigation to auth flow.
- Business logic:
  - Responsive breakpoints (`mobile=600`, `tablet=1024`).
  - `AnimationController` + `FadeTransition` hero animation.
  - `navigateToAuth(bool isSignUp)` using named route `/auth` with args.
- Data:
  - Static arrays for feature cards and workflow steps.
  - No backend reads/writes.
- Widgets used (file-wide):
  - `Scaffold`, `Drawer`, `Container`, `SafeArea`, `SingleChildScrollView`, `Column`, `Row`, `Padding`, `Icon`, `Text`, `Divider`, `ListTile`, `TextButton`, `ElevatedButton`, `IconButton`, `SizedBox`, `FadeTransition`, `LayoutBuilder`, `GridView.builder`, `SliverGridDelegateWithFixedCrossAxisCount`, `Wrap`, `Center`.

### 4.2 `AuthPage` - `lib/auth_page.dart`

- Purpose:
  - Sign up/login tabs.
  - Forgot password.
  - Firestore company profile creation.
  - Webhook post after signup.
- Business logic methods:
  - `_generateApiKey()`
  - `_sendToN8NWebhook(Map<String, dynamic>)`
  - `handleSignUp()`
  - `handleLogin()`
  - `handleForgotPassword()`
  - `_showForgotPasswordDialog()`
  - `_getPasswordStrength()` / `_getPasswordStrengthColor()`
- Data reads/writes:
  - Writes `companies/{uid}` document with fields:
    - `id` (string)
    - `name` (string)
    - `adminEmail` (string)
    - `apiKey` (string)
    - `webhookUrl` (string)
    - `createdAt` (Firestore `Timestamp`)
    - `departmentIds` (array)
  - Reads `companies/{uid}` during login.
  - Sends webhook JSON with `companyId`, `companyName`, `adminEmail`, `apiKey`, `webhookUrl`, `timestamp`, `eventType`.
- Widgets used (file-wide):
  - `Scaffold`, `Stack`, `Container`, `SafeArea`, `Center`, `SingleChildScrollView`, `Card`, `Padding`, `Column`, `Icon`, `Text`, `SizedBox`, `TabBar`, `TabBarView`, `Tab`, `Form`, `ListView`, `TextFormField`, `InputDecoration`, `OutlineInputBorder`, `IconButton`, `Row`, `Align`, `TextButton`, `ElevatedButton`, `AlertDialog`, `CircularProgressIndicator`, `SnackBar`.

### 4.3 `DashboardPage` - `lib/dashboard_page.dart`

- Purpose:
  - Authenticated admin dashboard.
  - Show company profile/API key.
  - Department creation/list.
  - Feedback analytics summary.
  - Integration guide and generated HTML snippet.
- Business logic methods:
  - `_initializeDashboard()`
  - `_loadCompanyData()`
  - `_loadDepartments()`
  - `_loadAnalytics()`
  - `_showOnboardingDialog()`
  - `_showCreateDepartmentDialog()`
  - `_createDepartment(String name)`
  - `_signOut()`
  - `_showIntegrationGuide()`
  - `_generateIntegrationHtml()`
- Data reads/writes:
  - Reads `companies/{uid}`.
  - Reads `companies/{uid}/departments`.
  - Adds new document in `companies/{uid}/departments` with:
    - `name` (string)
    - `createdAt` (`Timestamp.now()`)
    - `webhookUrl` (string)
  - Reads `companies/{uid}/feedback` and counts `sentiment` values (`positive`/`negative`).
- Widgets used (file-wide):
  - `Scaffold`, `AppBar`, `IconButton`, `Container`, `SingleChildScrollView`, `Column`, `Card`, `Padding`, `Row`, `Icon`, `Text`, `Expanded`, `Divider`, `GridView.count`, `ListView.builder`, `ListTile`, `SnackBar`, `AlertDialog`, `Form`, `TextFormField`, `InputDecoration`, `OutlineInputBorder`, `TextButton`, `ElevatedButton`, `Dialog`, `Flexible`, `SelectableText`, `FloatingActionButton`, `Center`, `CircularProgressIndicator`, `BoxConstraints`.

### 4.4 `HtmlCodePage` - `lib/html_code_page.dart`

- Purpose:
  - Displays generated HTML code.
  - Copy-to-clipboard action.
- Data:
  - Input param `htmlCode` string.
  - No backend writes.
- Widgets used:
  - `Scaffold`, `AppBar`, `Text`, `IconButton`, `Container`, `Padding`, `SingleChildScrollView`, `SelectableText`, `FloatingActionButton`, `SnackBar`, `Row`, `Icon`, `SizedBox`.

### 4.5 `NotFoundPage` - `lib/main.dart`

- Purpose:
  - 404-style fallback for unknown routes.
- Data:
  - Displays route name.
- Widgets used:
  - `Scaffold`, `Container`, `Center`, `Column`, `Icon`, `SizedBox`, `Text`, `ElevatedButton`.

## 5. Authentication System

- Sign up:
  - `createUserWithEmailAndPassword` in `AuthPage.handleSignUp`.
  - Creates company document in Firestore after auth account creation.
  - Starts webhook call asynchronously.
  - Redirects to dashboard with `isFirstTimeSetup: true`.
- Sign in:
  - `signInWithEmailAndPassword` in `AuthPage.handleLogin`.
  - Reads company data from Firestore and redirects to dashboard.
- Sign out:
  - `_auth.signOut()` in `DashboardPage._signOut`.
  - Redirects to landing route.
- Roles/user types:
  - No explicit role model implemented.
  - Effective user type is company admin account tied to UID.
- Firebase Auth config details:
  - Config hardcoded in `lib/main.dart` (`apiKey`, `authDomain`, `projectId`, `storageBucket`, `messagingSenderId`, `appId`).

## 6. Firestore Database Structure

### Collections in code

- `companies`
- `companies/{uid}/departments`
- `companies/{uid}/feedback`

### Fields and data types observed in code writes

- `companies/{uid}` write (`AuthPage.handleSignUp`):
  - `id: String`
  - `name: String`
  - `adminEmail: String`
  - `apiKey: String`
  - `webhookUrl: String`
  - `createdAt: Timestamp`
  - `departmentIds: List<dynamic>`
- `companies/{uid}/departments/{autoId}` write (`DashboardPage._createDepartment`):
  - `name: String`
  - `createdAt: Timestamp`
  - `webhookUrl: String`

### Feedback fields observed in app code

- The app reads `sentiment` from `companies/{uid}/feedback/*` for analytics.
- No feedback write is implemented in first-party Flutter code.

### Feedback schema documented in repository docs (`FIREBASE_SETUP.md`)

- `sentiment: string`
- `message: string`
- `createdAt: timestamp`
- `departmentId: string`

### Data flow and query patterns

- Signup -> write company doc.
- Login -> read company doc.
- Dashboard -> read company/departments/feedback.
- Create department -> add departments subcollection doc.
- Query/filter/order usage:
  - Uses `.get()` reads only.
  - No `where`, `orderBy`, pagination, transaction, or batch writes found.

## 7. Navigation & Routing

### Named routes defined (`lib/main.dart`)

- `Routes.landing = '/'`
- `Routes.auth = '/auth'`
- `Routes.dashboard = '/dashboard'`
- `Routes.htmlCode = '/html-code'`
- `Routes.notFound = '/404'` (constant only)

### Route destinations

- `/` -> `LandingPage`
- `/auth` -> `AuthPage` (uses `isSignUp` route arg)
- `/dashboard` -> `DashboardPage` (uses `companyData`, `isFirstTimeSetup` args)
- `/html-code` -> `HtmlCodePage` (uses `htmlCode` arg)

### Navigation behavior

- Landing -> Auth: `Navigator.pushNamed('/auth', arguments: {'isSignUp': ...})`
- Auth -> Dashboard: `Navigator.pushReplacementNamed(Routes.dashboard, arguments: ...)`
- Dashboard -> Landing on signout: `Navigator.pushReplacementNamed(Routes.landing)`
- Unknown route -> `NotFoundPage` via `onGenerateRoute`

### Route guards / conditional navigation

- No global route guards.
- Conditional navigation exists in page logic (signup/login outcomes, onboarding flag handling).

## 8. UI & Design

### Color scheme

Explicit hex colors in first-party Dart files:

- `#667EEA` (`Color(0xFF667eea)`)
- `#764BA2` (`Color(0xFF764ba2)`)

Additional explicit web theme colors:

- `#0175C2` (`web/manifest.json` background and theme)

Named/material colors heavily used:

- `Colors.white`, `Colors.black54`, `Colors.grey` with shades, `Colors.blue` with shades, `Colors.green`, `Colors.red`, `Colors.orange`, `Colors.amber` with shades, `Colors.indigo`, `Colors.purple.shade400`.

### Fonts and text styles

- App theme sets `fontFamily: 'Inter'` (`lib/main.dart`).
- Monospace-style displays:
  - `fontFamily: 'monospace'` for API key/code text.
  - `fontFamily: 'Courier'` in integration/copy sections.
- No custom font asset declarations in `pubspec.yaml`.

### Reusable components

- No separate reusable widget files.
- Reusable UI built as private widget-builder methods within each page class.

### Responsive design approach

- Repeated breakpoint constants in pages:
  - Mobile `<600`
  - Tablet `600-1024`
  - Desktop `>=1024`
- Responsive adaptations include drawer/navbar switching, padding/font-size scaling, and grid layout changes.

### Overall look and feel

- Gradient-heavy visual style with rounded cards/buttons and onboarding dialog UX.
- Landing page is long-form marketing layout; auth/dashboard are utility-focused.

## 9. Known Limitations & TODOs

### Hardcoded or placeholder values

- Firebase credentials are hardcoded in `lib/main.dart`.
- Webhook URLs are hardcoded localhost endpoints in `auth_page.dart` and `dashboard_page.dart`.
- Project template/default text still exists in `README.md` and web metadata (`description: A new Flutter project.`).
- `test/widget_test.dart` is default counter template test and does not align with current app UI behavior.

### TODO/FIXME comments found

- `android/app/build.gradle.kts`
  - TODO: unique Application ID
  - TODO: release signing config
  - TODO: add Firebase product dependencies
- `windows/flutter/CMakeLists.txt`
  - TODO: move content to ephemeral files
- `linux/flutter/CMakeLists.txt`
  - TODO: move content to ephemeral files

### Incomplete features visible from code

- Feedback write path from frontend form into Firestore is not implemented in first-party Flutter code.
- `provider`, `google_sign_in`, `shared_preferences`, `fluttertoast` are declared but unused in app code.
- `_testWebhook()` method exists but is not invoked by normal flow.

## 10. Setup & Running Instructions

1. Install Flutter SDK and platform toolchains.

- Local sample values present in `android/local.properties`:
  - `flutter.sdk=C:\\flutter\\flutter`
  - `sdk.dir=C:\\Users\\RICHARD\\AppData\\Local\\Android\\sdk`

2. Get Flutter packages.

- Run: `flutter pub get`

3. (Optional for root JS dependency) install npm dependency.

- Run: `npm install`

4. Firebase setup.

- Ensure Firebase project values are valid for your environment in `lib/main.dart`.
- Android Firebase config file exists: `android/app/google-services.json`.
- Enable Email/Password Authentication and Firestore in Firebase console.
- Apply Firestore security rules (example rules provided in `FIREBASE_SETUP.md`).

5. Run app locally.

- Web: `flutter run -d chrome`
- Device/emulator: `flutter run`

6. Validate project.

- Static analysis: `flutter analyze`
- Tests: `flutter test`

7. Build system notes from codebase.

- Android Gradle wrapper distribution: `gradle-8.14` (`android/gradle/wrapper/gradle-wrapper.properties`).
- Android plugin versions in `android/settings.gradle.kts`:
  - Android application plugin `8.11.1`
  - Kotlin Android plugin `2.2.20`
- Google services plugin declared in `android/build.gradle.kts`: `4.4.4` (apply false at root; applied in app module).
