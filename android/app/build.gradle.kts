// Top-level version constants (update these for each release)
val VERSION_CODE = 1
val VERSION_NAME = "1.0.0"

plugins {
    id("com.android.application")
    id("org.jetbrains.kotlin.android")
    // The Flutter plugin must be applied after Android and Kotlin plugins
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.yourapp" // TODO: use your app’s actual application ID
    compileSdk = 34  // Compile with Android 14 (API level 34) – highest available API

    defaultConfig {
        // Unique identifier for your app on Google Play
        applicationId = "com.example.yourapp" // TODO: change to your application ID
        
        // Minimum Android version supported (Android 4.4, API 19)
        minSdk = 19
        
        // Target the latest Android API (required: API 34 for new apps:contentReference[oaicite:0]{index=0})
        targetSdk = 34
        
        // Versioning: use top-level constants for easy update per release
        versionCode = VERSION_CODE
        versionName = VERSION_NAME
        
        testInstrumentationRunner = "androidx.test.runner.AndroidJUnitRunner"
    }

    signingConfigs {
        create("release") {
            // TODO: Configure your release keystore here (via key.properties or directly)
            // For now, this is a placeholder until you generate a real keystore.
        }
    }

    buildTypes {
        getByName("debug") {
            // Debug build: uses default debug keystore (no changes needed)
        }
        create("release") {
            // Release build: disable code shrinking/obfuscation (ProGuard/R8) for now
            isMinifyEnabled = false
            isShrinkResources = false
            
            // Use debug signing config temporarily so that flutter run --release works
            signingConfig = signingConfigs.getByName("debug")
            // TODO: Once a release keystore exists, switch to:
            // signingConfig = signingConfigs.getByName("release")
        }
    }

    // Java/Kotlin compatibility (optional, adjust if your project differs)
    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }
    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
    }
}

// Flutter Gradle plugin must remain last in the plugins block (preserves plugin order)
