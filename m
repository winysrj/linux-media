Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:33022 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751595AbcBOVUM (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 15 Feb 2016 16:20:12 -0500
Received: from int-mx09.intmail.prod.int.phx2.redhat.com (int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (Postfix) with ESMTPS id 262C58DFEB
	for <linux-media@vger.kernel.org>; Mon, 15 Feb 2016 21:20:12 +0000 (UTC)
From: Hans de Goede <hdegoede@redhat.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH xawtv3 3/3] Add desktop and appdata files for xawtv, motv and mtt
Date: Mon, 15 Feb 2016 22:20:02 +0100
Message-Id: <1455571202-5189-3-git-send-email-hdegoede@redhat.com>
In-Reply-To: <1455571202-5189-1-git-send-email-hdegoede@redhat.com>
References: <1455571202-5189-1-git-send-email-hdegoede@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
---
 contrib/motv.desktop      | 10 ++++++++++
 contrib/motv.metainfo.xml | 11 +++++++++++
 contrib/mtt.desktop       | 10 ++++++++++
 contrib/mtt.metainfo.xml  | 11 +++++++++++
 contrib/xawtv.appdata.xml | 33 +++++++++++++++++++++++++++++++++
 contrib/xawtv.desktop     | 10 ++++++++++
 6 files changed, 85 insertions(+)
 create mode 100644 contrib/motv.desktop
 create mode 100644 contrib/motv.metainfo.xml
 create mode 100644 contrib/mtt.desktop
 create mode 100644 contrib/mtt.metainfo.xml
 create mode 100644 contrib/xawtv.appdata.xml
 create mode 100644 contrib/xawtv.desktop

diff --git a/contrib/motv.desktop b/contrib/motv.desktop
new file mode 100644
index 0000000..37093d4
--- /dev/null
+++ b/contrib/motv.desktop
@@ -0,0 +1,10 @@
+[Desktop Entry]
+Comment=Analog TV viewing application
+Icon=xawtv
+Exec=motv
+Name=MoTV Television Viewer
+Terminal=false
+StartupNotify=false
+Type=Application
+Categories=AudioVideo;Video;
+Keywords=video;tv;viewer;v4l;v4l2;video4linux;
diff --git a/contrib/motv.metainfo.xml b/contrib/motv.metainfo.xml
new file mode 100644
index 0000000..7d3bc31
--- /dev/null
+++ b/contrib/motv.metainfo.xml
@@ -0,0 +1,11 @@
+<?xml version="1.0" encoding="utf-8"?>
+<component type="addon">
+  <id>motv.desktop</id>
+  <extends>xawtv.desktop</extends>
+  <metadata_license>CC0-1.0</metadata_license>
+  <project_license>GPL-2.0+</project_license>
+  <name>MoTV Television Viewer</name>
+  <summary>Motif UI version of xawtv</summary>
+  <url type="homepage">http://linuxtv.org/wiki/index.php/Xawtv</url>
+  <updatecontact>jwrdegoede_at_fedoraproject.org</updatecontact>
+</component>
diff --git a/contrib/mtt.desktop b/contrib/mtt.desktop
new file mode 100644
index 0000000..f04c29a
--- /dev/null
+++ b/contrib/mtt.desktop
@@ -0,0 +1,10 @@
+[Desktop Entry]
+Comment=Analog TV Teletext viewing application
+Icon=xawtv
+Exec=mtt
+Name=MTT Teletext Viewer
+Terminal=false
+StartupNotify=false
+Type=Application
+Categories=AudioVideo;Video;
+Keywords=video;tv;viewer;v4l;v4l2;video4linux;teletext;
diff --git a/contrib/mtt.metainfo.xml b/contrib/mtt.metainfo.xml
new file mode 100644
index 0000000..28f5c84
--- /dev/null
+++ b/contrib/mtt.metainfo.xml
@@ -0,0 +1,11 @@
+<?xml version="1.0" encoding="utf-8"?>
+<component type="addon">
+  <id>mtt.desktop</id>
+  <extends>xawtv.desktop</extends>
+  <metadata_license>CC0-1.0</metadata_license>
+  <project_license>GPL-2.0+</project_license>
+  <name>MTT Teletext Viewer</name>
+  <summary>Easy to use Teletext GUI</summary>
+  <url type="homepage">http://linuxtv.org/wiki/index.php/Xawtv</url>
+  <updatecontact>jwrdegoede_at_fedoraproject.org</updatecontact>
+</component>
diff --git a/contrib/xawtv.appdata.xml b/contrib/xawtv.appdata.xml
new file mode 100644
index 0000000..92959d2
--- /dev/null
+++ b/contrib/xawtv.appdata.xml
@@ -0,0 +1,33 @@
+<?xml version="1.0" encoding="utf-8"?>
+<component type="desktop">
+  <id>xawtv.desktop</id>
+  <metadata_license>CC0-1.0</metadata_license>
+  <project_license>GPL-2.0+</project_license>
+  <name>xawtv</name>
+  <summary>Analog TV viewing application</summary>
+  <description>
+    <p>
+      xawtv was originally just an analog TV viewing application for Bttv
+      devices (bt848, bt878) using the Athena widgets, but evolved into a
+      small suite of X11 applications for V4L devices.
+    </p>
+    <p>
+      The xawtv package includes a number of useful console commandline
+      utilities:
+    </p>
+    <ul>
+      <li>alevtd - a http deamon for use with analogue TV teletext</li>
+      <li>radio -- a console radio listening app </li>
+      <li>scantv -- an analogue TV frequency scanner</li>
+      <li>v4l-conf -- current video mode (size and color depth)</li>
+      <li>v4lctl -- used to control a v4l device and set varying image parameters</li>
+      <li>webcam -- capture images from a webcam </li>
+    </ul>
+  </description>
+  <url type="homepage">http://linuxtv.org/wiki/index.php/Xawtv</url>
+  <screenshots>
+    <screenshot type="default">http://www.easylinux.de/Artikel/ausgabe/2004/01/036-xawtv/tv_8.png</screenshot>
+    <screenshot>http://www.easylinux.de/Artikel/ausgabe/2004/01/036-xawtv/xawtv1.png</screenshot>
+  </screenshots>
+  <updatecontact>jwrdegoede_at_fedoraproject.org</updatecontact>
+</component>
diff --git a/contrib/xawtv.desktop b/contrib/xawtv.desktop
new file mode 100644
index 0000000..349394d
--- /dev/null
+++ b/contrib/xawtv.desktop
@@ -0,0 +1,10 @@
+[Desktop Entry]
+Comment=Analog TV viewing application
+Icon=xawtv
+Exec=xawtv
+Name=XawTV Television Viewer
+Terminal=false
+StartupNotify=false
+Type=Application
+Categories=AudioVideo;Video;
+Keywords=video;tv;viewer;v4l;v4l2;video4linux;
-- 
2.7.1

