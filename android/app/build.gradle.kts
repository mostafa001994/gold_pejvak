plugins {
    id("com.android.application")
    id("kotlin-android")
    // Flutter plugin must come after Android and Kotlin plugins
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.codinex.pejvak"
    compileSdk = 34
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }


    splits {
        abi {
            isEnable = true
            isUniversalApk = false
            reset()
            include("armeabi-v7a", "arm64-v8a", "x86", "x86_64")
        }
    }


    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        applicationId = "com.codinex.pejvak"
        minSdk = 21
        targetSdk = 34
        versionCode = 1
        versionName = "1.0.1"
    }

    signingConfigs {
        create("release") {
            storeFile = file("my-release-key.jks")
            keyAlias = "my-key-alias"
            storePassword = project.findProperty("KEYSTORE_PASSWORD") as String
            keyPassword = project.findProperty("KEY_PASSWORD") as String
        }
    }

    buildTypes {
        getByName("release") {
            signingConfig = signingConfigs.getByName("release")
            isMinifyEnabled = true
            isShrinkResources = true
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                file("proguard-rules.pro")
            )
        }
    }
}

flutter {
    source = "../.."
}