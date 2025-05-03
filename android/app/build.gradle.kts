// File: android/app/build.gradle.kts

import java.util.Properties
import java.io.FileInputStream

plugins {
    id("com.android.application")
    id("org.jetbrains.kotlin.android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.sfl"            
    compileSdk = 34                         // ✅ Update: target API 34 for Play Store compliance

    defaultConfig {
        applicationId = "com.example.sfl"   // ✅ Update: your real app ID
        minSdk = 19                         // ✅ Minimum SDK version (Android 4.4+)
        targetSdk = 34                      // ✅ Update: target API 34 for new apps
        versionCode = 1                     // ✅ Update per release
        versionName = "2.0.2"               // ✅ Update per release

        testInstrumentationRunner = "androidx.test.runner.AndroidJUnitRunner"
    }

    // ─── Load keystore properties (NEW) ───
    val keystorePropsFile = rootProject.file("key.properties")
    val keystoreProps = Properties().apply {
        if (keystorePropsFile.exists()) {
            load(FileInputStream(keystorePropsFile))
        }
    }

    signingConfigs {
        create("release") {
            // ✅ Update: use values from key.properties to sign release builds
            keyAlias = keystoreProps["keyAlias"] as String
            keyPassword = keystoreProps["keyPassword"] as String
            storeFile = file(keystoreProps["storeFile"] as String)
            storePassword = keystoreProps["storePassword"] as String
        }
    }

    buildTypes {
        getByName("debug") {
            // No changes for debug build
        }
        create("release") {
            isMinifyEnabled = false            // ✅ Keep code shrinking disabled
            isShrinkResources = false          // ✅ Keep resource shrinking disabled

            // ✅ Use the real release keystore instead of debug
            signingConfig = signingConfigs.getByName("release")
        }
    }

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }
    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
    }
}

// Flutter plugin must be applied last
