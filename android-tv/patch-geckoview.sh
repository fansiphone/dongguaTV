#!/bin/bash
# Patch script for GeckoView Capacitor plugin
# This script applies necessary patches for AGP 8.x compatibility and multi-arch support

set -e


# Auto-detect plugin directories to avoid errors
PLUGIN_ROOT="./node_modules/@web-media/capacitor-geckoview"
if [ -d "$PLUGIN_ROOT/android" ]; then
    GECKOVIEW_DIR="$PLUGIN_ROOT/android"
elif [ -d "$PLUGIN_ROOT/capacitor" ]; then
    GECKOVIEW_DIR="$PLUGIN_ROOT/capacitor"
else
    echo "⚠️ GeckoView Android dir not found at standard paths. Searching..."
    FOUND=$(find "$PLUGIN_ROOT" -name "build.gradle" 2>/dev/null | head -n 1)
    if [ -n "$FOUND" ]; then
        GECKOVIEW_DIR=$(dirname "$FOUND")
    else
        echo "❌ Error: Cannot find build.gradle in $PLUGIN_ROOT"
        echo "Debug - Plugin directory listing:"
        ls -R "$PLUGIN_ROOT" 2>/dev/null || echo "Plugin dir does not exist"
        exit 1
    fi
fi
echo "✅ Resolved GeckoView Dir: $GECKOVIEW_DIR"

STATUSBAR_DIR="./node_modules/@capacitor/status-bar/android"

echo "🔧 Patching GeckoView Capacitor plugin..."

# Patch GeckoView build.gradle
cat > "$GECKOVIEW_DIR/build.gradle" << 'GRADLE_EOF'
ext {
    androidxActivityVersion = project.hasProperty('androidxActivityVersion') ? rootProject.ext.androidxActivityVersion : '1.4.0'
    androidxAppCompatVersion = project.hasProperty('androidxAppCompatVersion') ? rootProject.ext.androidxAppCompatVersion : '1.4.2'
    androidxCoordinatorLayoutVersion = project.hasProperty('androidxCoordinatorLayoutVersion') ? rootProject.ext.androidxCoordinatorLayoutVersion : '1.2.0'
    androidxCoreVersion = project.hasProperty('androidxCoreVersion') ? rootProject.ext.androidxCoreVersion : '1.8.0'
    androidxFragmentVersion = project.hasProperty('androidxFragmentVersion') ? rootProject.ext.androidxFragmentVersion : '1.4.1'
    androidxWebkitVersion = project.hasProperty('androidxWebkitVersion') ? rootProject.ext.androidxWebkitVersion : '1.4.0'
    junitVersion = project.hasProperty('junitVersion') ? rootProject.ext.junitVersion : '4.13.2'
    androidxJunitVersion = project.hasProperty('androidxJunitVersion') ? rootProject.ext.androidxJunitVersion : '1.1.3'
    androidxEspressoCoreVersion = project.hasProperty('androidxEspressoCoreVersion') ? rootProject.ext.androidxEspressoCoreVersion : '3.4.0'
    cordovaAndroidVersion = project.hasProperty('cordovaAndroidVersion') ? rootProject.ext.cordovaAndroidVersion : '10.1.1'
}

buildscript {
    repositories {
        google()
        mavenCentral()
        maven {
            url "https://plugins.gradle.org/m2/"
        }
        maven{
            url "https://maven.mozilla.org/maven2/"
        }
    }
    dependencies {
        classpath 'com.android.tools.build:gradle:8.5.0'

        if (System.getenv("CAP_PUBLISH") == "true") {
            classpath 'io.github.gradle-nexus:publish-plugin:1.1.0'
        }
    }
}

tasks.withType(Javadoc).all { enabled = false }

apply plugin: 'com.android.library'

if (System.getenv("CAP_PUBLISH") == "true") {
    apply plugin: 'io.github.gradle-nexus.publish-plugin'
    apply from: file('../scripts/publish-root.gradle')
    apply from: file('../scripts/publish-module.gradle')
}

android {
    namespace = "com.getcapacitor.android"
    compileSdk = project.hasProperty('compileSdkVersion') ? rootProject.ext.compileSdkVersion : 34
    defaultConfig {
        minSdk = project.hasProperty('minSdkVersion') ? rootProject.ext.minSdkVersion : 22
        targetSdk = project.hasProperty('targetSdkVersion') ? rootProject.ext.targetSdkVersion : 34
        versionCode 1
        versionName "1.0"
        testInstrumentationRunner "androidx.test.runner.AndroidJUnitRunner"
    }
    buildTypes {
        release {
            minifyEnabled false
            proguardFiles getDefaultProguardFile('proguard-android.txt'), 'proguard-rules.pro'
        }
    }
    lint {
        abortOnError true
        warningsAsErrors true
    }
    buildFeatures {
        buildConfig = true
    }
    compileOptions {
        sourceCompatibility JavaVersion.VERSION_11
        targetCompatibility JavaVersion.VERSION_11
    }
}

repositories {
    google()
    mavenCentral()
    maven{
        url "https://maven.mozilla.org/maven2/"
    }
}

dependencies {
    implementation fileTree(dir: 'libs', include: ['*.jar'])
    implementation"androidx.appcompat:appcompat:$androidxAppCompatVersion"
    implementation "androidx.core:core:$androidxCoreVersion"
    implementation "androidx.activity:activity:$androidxActivityVersion"
    implementation "androidx.fragment:fragment:$androidxFragmentVersion"

    implementation "androidx.coordinatorlayout:coordinatorlayout:$androidxCoordinatorLayoutVersion"
    implementation "androidx.webkit:webkit:$androidxWebkitVersion"
    testImplementation "junit:junit:$junitVersion"
    androidTestImplementation "androidx.test.ext:junit:$androidxJunitVersion"
    androidTestImplementation "androidx.test.espresso:espresso-core:$androidxEspressoCoreVersion"
    implementation "org.apache.cordova:framework:$cordovaAndroidVersion"
    testImplementation 'org.json:json:20140107'
    testImplementation 'org.mockito:mockito-inline:3.6.28'
    
    // GeckoView - All CPU architectures for TV box compatibility
    api "org.mozilla.geckoview:geckoview-arm64-v8a:106.0.20221019185550"
    api "org.mozilla.geckoview:geckoview-armeabi-v7a:106.0.20221019185550"
    api "org.mozilla.geckoview:geckoview-x86:106.0.20221019185550"
    api "org.mozilla.geckoview:geckoview-x86_64:106.0.20221019185550"
    
    implementation 'org.nanohttpd:nanohttpd-webserver:2.3.1'
}
GRADLE_EOF

# Patch GeckoView AndroidManifest.xml (remove package attribute)
cat > "$GECKOVIEW_DIR/src/main/AndroidManifest.xml" << 'XML_EOF'
<?xml version="1.0" encoding="utf-8"?>
<manifest xmlns:android="http://schemas.android.com/apk/res/android">
</manifest>
XML_EOF

# Patch status-bar build.gradle
cat > "$STATUSBAR_DIR/build.gradle" << 'GRADLE_EOF'
ext {
    capacitorVersion = System.getenv('CAPACITOR_VERSION')
    junitVersion = project.hasProperty('junitVersion') ? rootProject.ext.junitVersion : '4.13.2'
    androidxCoreVersion = project.hasProperty('androidxCoreVersion') ? rootProject.ext.androidxCoreVersion : '1.8.0'
    androidxAppCompatVersion = project.hasProperty('androidxAppCompatVersion') ? rootProject.ext.androidxAppCompatVersion : '1.4.2'
    androidxJunitVersion = project.hasProperty('androidxJunitVersion') ? rootProject.ext.androidxJunitVersion : '1.1.3'
    androidxEspressoCoreVersion = project.hasProperty('androidxEspressoCoreVersion') ? rootProject.ext.androidxEspressoCoreVersion : '3.4.0'
}

buildscript {
    repositories {
        google()
        mavenCentral()
        maven {
            url "https://plugins.gradle.org/m2/"
        }
    }
    dependencies {
        classpath 'com.android.tools.build:gradle:8.5.0'
        if (System.getenv("CAP_PLUGIN_PUBLISH") == "true") {
            classpath 'io.github.gradle-nexus:publish-plugin:1.1.0'
        }
    }
}

apply plugin: 'com.android.library'
if (System.getenv("CAP_PLUGIN_PUBLISH") == "true") {
    apply plugin: 'io.github.gradle-nexus.publish-plugin'
    apply from: file('../../scripts/android/publish-root.gradle')
    apply from: file('../../scripts/android/publish-module.gradle')
}

android {
    namespace = "com.capacitorjs.plugins.statusbar"
    compileSdk = project.hasProperty('compileSdkVersion') ? rootProject.ext.compileSdkVersion : 34
    defaultConfig {
        minSdk = project.hasProperty('minSdkVersion') ? rootProject.ext.minSdkVersion : 22
        targetSdk = project.hasProperty('targetSdkVersion') ? rootProject.ext.targetSdkVersion : 34
        versionCode 1
        versionName "1.0"
        testInstrumentationRunner "androidx.test.runner.AndroidJUnitRunner"
    }
    buildTypes {
        release {
            minifyEnabled false
            proguardFiles getDefaultProguardFile('proguard-android.txt'), 'proguard-rules.pro'
        }
    }
    lint {
        abortOnError false
    }
    compileOptions {
        sourceCompatibility JavaVersion.VERSION_11
        targetCompatibility JavaVersion.VERSION_11
    }
}

repositories {
    google()
    mavenCentral()
}


dependencies {
    implementation fileTree(dir: 'libs', include: ['*.jar'])

    if (System.getenv("CAP_PLUGIN_PUBLISH") == "true") {
        implementation "com.capacitorjs:core:$capacitorVersion"
    } else {
        implementation project(':capacitor-android')
    }

    implementation "androidx.core:core:$androidxCoreVersion"
    implementation "androidx.appcompat:appcompat:$androidxAppCompatVersion"
    testImplementation "junit:junit:$junitVersion"
    androidTestImplementation "androidx.test.ext:junit:$androidxJunitVersion"
    androidTestImplementation "androidx.test.espresso:espresso-core:$androidxEspressoCoreVersion"
}
GRADLE_EOF

# Patch status-bar AndroidManifest.xml
cat > "$STATUSBAR_DIR/src/main/AndroidManifest.xml" << 'XML_EOF'
<manifest xmlns:android="http://schemas.android.com/apk/res/android">
</manifest>
XML_EOF

echo "✅ All patches applied successfully!"
