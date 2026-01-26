pluginManagement {
    repositories {
        google()
        mavenCentral()
        gradlePluginPortal()
    }
}

dependencyResolutionManagement {
    repositoriesMode.set(RepositoriesMode.FAIL_ON_PROJECT_REPOS)
    repositories {
        google()
        mavenCentral()
        // Chaquopy 需要的仓库
        maven { url = uri("https://chaquo.com/maven") }
    }
}

rootProject.name = "HBC-Tool-Android"
include(":app")
