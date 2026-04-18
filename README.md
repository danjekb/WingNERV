<h1 align="center">
  <img loading="lazy" src="readme-res/banner.png"/>
</h1>
<p align="center">
  <a href="https://github.com/vaultzie/NERV/blob/fun/LICENSE"><img loading="lazy" src="https://img.shields.io/github/license/vaultzie/NERV?style=for-the-badge&logo=github"/></a>
  <a href="https://github.com/vaultzie/NERV/commits/fun"><img loading="lazy" src="https://img.shields.io/github/last-commit/vaultzie/NERV/fun?style=for-the-badge"/></a>
  <a href="https://github.com/vaultzie/NERV/stargazers"><img loading="lazy" src="https://img.shields.io/github/stars/vaultzie/NERV?style=for-the-badge"/></a>
  <a href="https://github.com/vaultzie/NERV/graphs/contributors"><img loading="lazy" src="https://img.shields.io/github/contributors/vaultzie/NERV?style=for-the-badge"/></a>
  <a href="https://github.com/vaultzie/NERV/actions/workflows/build.yml"><img loading="lazy" src="https://img.shields.io/github/actions/workflow/status/vaultzie/NERV/build.yml?style=for-the-badge"/></a>
  <a href="https://crowdin.com/project/UN1CA"><img loading="lazy" src="https://img.shields.io/badge/Crowdin-263238?style=for-the-badge&logo=crowdin"/></a>
</p>
<p align="center">UN1CA <i>(/ˈu.ni.ka/)</i> is a work-in-progress custom firmware for Samsung Galaxy devices, and WingNERV is a fork of it aimed for JDM devices.</p>

# What is UN1CA?
UN1CA is a work-in-progress custom firmware for Samsung Galaxy devices. It's based on the latest and greatest iteration of Samsung's UX and it also includes additional features and tweaks to ensure the best possible experience out of the box.
Its build system allows to automatically download/extract the firmware, apply the required patches and generates a flashable zip/tar package for the specified device.

Any form of contribution, suggestions, bug report or feature request for the project will be welcome.

# What is ProjectNERV?
Since UN1CA is away for a while, I and some friends aiming for users to experience Samsung's newest One UI version with less features. This is a small project, and always will be like that.

# What is WingNERV?
> **WingNERV = Wing**tech + Project**NERV**
> 
> Wingtech is the JDM responsible for designing and manufacturing the Galaxy M55(s)/F55/C55 5G.

It's a fork of ProjectNERV (fun branch) with support for JDM devices thanks to being based on M55 firmware. I also plan to add MediaTek support by using XCover7 firmware as a base.

# Features
- Based on the latest Galaxy M55 One UI 7.0 firmware
- Galaxy AI support
- High end animations
- AOD clock transition support
- Picture remaster support
- Object, shadow and reflection eraser support
- Image clipper support
- Smart Suggestions widget
- Multi user support
- Camera privacy toggle support
- Debloated from useless system services/additional apps
- [BluetoothLibraryPatcher](https://github.com/3arthur6/BluetoothLibraryPatcher) included
- [FrameworkPatch](https://github.com/chiteroman/FrameworkPatch) implemented in system frameworks
- [KnoxPatch](https://github.com/salvogiangri/KnoxPatch) implemented in system frameworks

# Licensing
This project is licensed under the terms of the [GNU General Public License v3.0](LICENSE). External dependencies might be distributed under a different license, such as:
- [android-tools](https://github.com/nmeum/android-tools), licensed under the [Apache License 2.0](https://github.com/nmeum/android-tools/blob/master/LICENSE)
- [apktool](https://github.com/iBotPeaches/Apktool), licensed under the [Apache License 2.0](https://github.com/iBotPeaches/Apktool/blob/master/LICENSE.md)
- [erofs-utils](https://github.com/sekaiacg/erofs-utils/), dual license ([GPL-2.0](https://github.com/sekaiacg/erofs-utils/blob/dev/LICENSES/GPL-2.0), [Apache-2.0](https://github.com/sekaiacg/erofs-utils/blob/dev/LICENSES/Apache-2.0))
- [img2sdat](https://github.com/xpirt/img2sdat), licensed under the [MIT License](https://github.com/xpirt/img2sdat/blob/master/LICENSE)
- [platform_build](https://android.googlesource.com/platform/build/) (ext4_utils, f2fs_utils, signapk), licensed under the [Apache License 2.0](https://source.android.com/docs/setup/about/licenses)
- [smali](https://github.com/google/smali), [multiple licenses](https://github.com/google/smali/blob/main/third_party/NOTICE)

# Credits
A big thanks goes to the following for their invaluable contributions in no particular order:
- **[ShaDisNX255](https://github.com/ShaDisNX255)** for his help, time and for his [NcX ROM](https://github.com/ShaDisNX255/NcX_Stock) which inspired this project
- **[DavidArsene](https://github.com/DavidArsene)** for his help and time
- **[paulowesll](https://github.com/paulowesll)** for his help and support
- **[Simon1511](https://github.com/Simon1511)** for his support and some of the device-specific patches
- **[ananjaser1211](https://github.com/ananjaser1211)** for troubleshooting and his time
- **[iDrinkCoffee](https://github.com/iDrinkCoffee-TG)** and **[RisenID](https://github.com/RisenID)** for documentation revisioning
- **[LineageOS Team](https://www.lineageos.org/)** for their original [OTA updater implementation](https://github.com/LineageOS/android_packages_apps_Updater)
- **[Yagzie](https://github.com/yagzie)** and **[utkustnr](https://github.com/utkustnr)** for the original ProjectNERV
- *All the UN1CA project contributors and testers ❤️*

# Stargazers over time
[![Stargazers over time](https://starchart.cc/vaultzie/NERV.svg)](https://starchart.cc/vaultzie/NERV)
