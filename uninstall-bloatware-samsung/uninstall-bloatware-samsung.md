# Uninstall Bloatware on samsung.

-----

# Step:
```
1. get adb: download for windows > extract >  open cmd
2. conncet phone > enable 'Developer option' > if launch via cmd, get the name of device is success
3. uninstall app in the list below
4. restart phone
```

-----


## Get ADB
    https://developer.android.com/tools/releases/platform-tools?hl=vi
download then extract, open cmd at the same folder

![image](https://github.com/user-attachments/assets/b2a2775e-8cae-4b99-b366-48d50ccfae7f)


## Launch PowerShell with the path of the ‘platform-tools‘ folder as described above.


Connect your Android device to the computer and execute the following command.

    > adb shell

To uninstall an app with its data

    pm uninstall --user 0 <package-name>

    
To uninstall an app but keep its data

    pm uninstall -k --user 0 <package-name>

## Safe to remove 
```
pm uninstall --user 0 com.android.bookmarkprovider  # Bookmark Provider
pm uninstall --user 0 com.android.dreams.basic  # Basic Screensaver (Daydream)
pm uninstall --user 0 com.android.dreams.phototable  # Photo Screensaver (Daydream)
pm uninstall --user 0 com.android.egg  # Android Easter Egg
pm uninstall --user 0 com.android.hotwordenrollment.okgoogle  # OK Google Enrollment
pm uninstall --user 0 com.android.hotwordenrollment.xgoogle  # Google Assistant Enrollment
pm uninstall --user 0 com.android.providers.partnerbookmarks  # Partner Bookmarks Provider
pm uninstall --user 0 com.google.mainline.adservices  # Google Ad Services
pm uninstall --user 0 com.google.android.adservices.api  # Google Ad Services API
pm uninstall --user 0 com.google.android.apps.photos  # Google Photos
pm uninstall --user 0 com.google.android.apps.tachyon  # Google Duo (Meet)
pm uninstall --user 0 com.google.android.feedback  # Google Feedback
pm uninstall --user 0 com.google.android.googlequicksearchbox  # Google Search / Assistant
pm uninstall --user 0 com.google.android.marvin.talkback  # Google TalkBack (Accessibility)
pm uninstall --user 0 com.google.android.printservice.recommendation  # Default Print Service
pm uninstall --user 0 com.google.android.syncadapters.calendar  # Google Calendar Sync
pm uninstall --user 0 com.google.android.tts  # Google Text-to-Speech
pm uninstall --user 0 com.google.android.apps.youtube.music  # YouTube Music
pm uninstall --user 0 com.google.ar.core  # Google ARCore
pm uninstall --user 0 com.sec.android.app.shealth  # Samsung Health
pm uninstall --user 0 com.samsung.android.arzone  # AR Zone
pm uninstall --user 0 com.sec.android.app.samsungapps  # Galaxy Store
pm uninstall --user 0 com.samsung.android.tvplus  # Samsung TV Plus
pm uninstall --user 0 com.samsung.android.app.watchmanagerstub  # Samsung Watch Manager Stub
pm uninstall --user 0 com.samsung.android.app.watchmanager  # Samsung Watch Manager
pm uninstall --user 0 com.samsung.android.waterplugin  # Water Plugin (Edge Panel)
pm uninstall --user 0 com.samsung.android.accessibility.talkback  # Samsung TalkBack
pm uninstall --user 0 com.sec.android.app.sbrowser  # Samsung Internet Browser
pm uninstall --user 0 com.sec.android.easyMover.Agent  # Samsung Smart Switch
pm uninstall --user 0 com.samsung.android.oneconnect  # SmartThings
pm uninstall --user 0 com.samsung.android.voc  # Samsung Members (Customer Support)
pm uninstall --user 0 com.samsung.android.scloud  # Samsung Cloud
pm uninstall --user 0 com.samsung.android.sdk.handwriting  # Samsung Handwriting SDK
pm uninstall --user 0 com.samsung.android.universalswitch  # Universal Switch (Accessibility)
pm uninstall --user 0 com.samsung.safetyinformation  # Samsung Safety Information
pm uninstall --user 0 com.samsung.storyservice  # Samsung Story Service
pm uninstall --user 0 com.samsung.android.service.aircommand  # Air Command (S Pen Feature)
pm uninstall --user 0 com.samsung.android.service.peoplestripe  # People Edge (Edge Panel)
pm uninstall --user 0 com.samsung.android.app.appsedge  # Apps Edge (Edge Panel)
pm uninstall --user 0 com.sec.android.dexsystemui  # Samsung DeX System UI
pm uninstall --user 0 com.sec.android.desktopmode.uiservice  # Samsung DeX Mode Service
pm uninstall --user 0 com.sec.android.app.desktoplauncher  # Samsung DeX Launcher
pm uninstall --user 0 com.samsung.android.bixby.agent  # Bixby Voice
pm uninstall --user 0 com.facebook.appmanager  # Facebook App Manager
pm uninstall --user 0 com.google.android.projection.gearhead
pm uninstall --user 0 com.samsung.android.app.simplesharing
pm uninstall --user 0 com.samsung.android.scloud
pm uninstall --user 0 com.sec.android.app.samsungapps
pm uninstall --user 0 com.samsung.android.avatar.avatarprovider
pm uninstall --user 0 com.sec.android.mimage.avatarstickers
pm uninstall --user 0 com.samsung.android.kidsinstaller
pm uninstall --user 0 com.samsung.android.kidsmode
pm uninstall --user 0 com.samsung.android.samsungpass
pm uninstall --user 0 com.samsung.android.spay
pm uninstall --user 0 com.samsung.android.app.camera.sticker.stamp.preload
pm uninstall --user 0 com.sec.android.app.billing
pm uninstall --user 0 com.sec.android.app.kidshome
pm uninstall --user 0 com.samsung.android.spayfw
pm uninstall --user 0 com.samsung.android.app.camera.sticker.facearavatar.preload
pm uninstall --user 0 com.samsung.android.stickercenter
```

## Can remove but not recommend 
```
// VPN, necessary when using thirtparty vpn app 
pm uninstall --user 0 com.android.vpndialogs  # VPN Dialogs
cmd package install-existing com.android.vpndialogs # Cài lại

// Wallpaper setting, allow android to set wallpaper, auto swich lock screen
pm uninstall --user 0 com.samsung.android.dynamiclock  # Dynamic Lock Screen
pm uninstall --user 0 com.android.wallpaper.livepicker  # Live Wallpaper Picker
```

## in case get uninstall for all user:

    try replace '--user 0' with '--user all'
