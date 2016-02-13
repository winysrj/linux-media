Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:52311 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751083AbcBMSsR (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 13 Feb 2016 13:48:17 -0500
Received: from int-mx10.intmail.prod.int.phx2.redhat.com (int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (Postfix) with ESMTPS id BC33B8535A
	for <linux-media@vger.kernel.org>; Sat, 13 Feb 2016 18:48:17 +0000 (UTC)
From: Hans de Goede <hdegoede@redhat.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH tvtime 17/17] Add an appdata file
Date: Sat, 13 Feb 2016 19:47:38 +0100
Message-Id: <1455389258-13470-17-git-send-email-hdegoede@redhat.com>
In-Reply-To: <1455389258-13470-1-git-send-email-hdegoede@redhat.com>
References: <1455389258-13470-1-git-send-email-hdegoede@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add an appdata file for use with new appstream using software-installers
in various Linux distros.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
---
 docs/tvtime.appdata.xml | 27 +++++++++++++++++++++++++++
 1 file changed, 27 insertions(+)
 create mode 100644 docs/tvtime.appdata.xml

diff --git a/docs/tvtime.appdata.xml b/docs/tvtime.appdata.xml
new file mode 100644
index 0000000..0c216ab
--- /dev/null
+++ b/docs/tvtime.appdata.xml
@@ -0,0 +1,27 @@
+<?xml version="1.0" encoding="utf-8"?>
+<component type="desktop">
+  <id>tvtime.desktop</id>
+  <metadata_license>CC0-1.0</metadata_license>
+  <project_license>GPL-2.0+</project_license>
+  <name>TVtime Television Viewer</name>
+  <summary>High quality video deinterlacer</summary>
+  <description>
+    <p>
+      TVtime is a high quality television application for use with analog
+      video capture cards on Linux systems. TVtime processes the input from a
+      capture card and displays it on a computer monitor or projector.
+    </p>
+    <p>Features:</p>
+    <ul>
+     <li>Smooth motion: Experience the full framerate of the video signal. Every field is deinterlaced to a unique frame for television quality and beyond.</li>
+     <li>Quality picture: Highest quality picture of any Linux TV viewer. Uses the best deinterlacers from DScaler for the ultimate experience.</li>
+     <li>Slick On-Screen-Display: Gorgeously rendered text composited in realtime on the live video signal.</li>
+    </ul>
+  </description>
+  <url type="homepage">http://tvtime.sourceforge.net/</url>
+  <screenshots>
+    <screenshot type="default">http://tvtime.sourceforge.net/screenshot-small.jpg</screenshot>
+    <screenshot>http://tvtime.sourceforge.net/screenshots/15-sep-03-shot3.jpg</screenshot>
+  </screenshots>
+  <updatecontact>jwrdegoede_at_fedoraproject.org</updatecontact>
+</component>
-- 
2.5.0

