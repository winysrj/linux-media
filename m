Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.21]:61147 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751221AbaLEUR3 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 5 Dec 2014 15:17:29 -0500
Received: from linux.local ([94.216.58.185]) by mail.gmx.com (mrgmx103) with
 ESMTPSA (Nemesis) id 0MN1Gu-1Y3ZxG3ey8-006iVZ for
 <linux-media@vger.kernel.org>; Fri, 05 Dec 2014 21:17:26 +0100
From: Peter Seiderer <ps.report@gmx.net>
To: linux-media@vger.kernel.org
Subject: [PATCH v2 3/3] qv4l2: update qmake project file
Date: Fri,  5 Dec 2014 21:17:25 +0100
Message-Id: <1417810645-21753-3-git-send-email-ps.report@gmx.net>
In-Reply-To: <1417810645-21753-1-git-send-email-ps.report@gmx.net>
References: <1417810645-21753-1-git-send-email-ps.report@gmx.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Peter Seiderer <ps.report@gmx.net>
---
Changes v1 -> v2:
  - fix out of tree qmake build (add PWD to library paths)
  - fix opengl support (qt4 only) and add disabling hint
---
 utils/qv4l2/qv4l2.pro | 46 ++++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 42 insertions(+), 4 deletions(-)

diff --git a/utils/qv4l2/qv4l2.pro b/utils/qv4l2/qv4l2.pro
index 7ab39cc..19a046a 100644
--- a/utils/qv4l2/qv4l2.pro
+++ b/utils/qv4l2/qv4l2.pro
@@ -1,14 +1,52 @@
 ######################################################################
-# Automatically generated by qmake (1.07a) Sat Jun 17 12:35:16 2006
+# qmake project file for qv4l2
 ######################################################################
 
 TEMPLATE = app
 INCLUDEPATH += . ../libv4l2util ../../lib/include ../../include
 CONFIG += debug
 
+greaterThan(QT_MAJOR_VERSION, 4): QT += widgets
+
+#
+# qt5: opengl support for disabled (will crash on startup)
+#
+# qt4: to disable opengl suppport comment out the following
+# line and the line '#define HAVE_QTGL 1' from ../../config.h
+lessThan(QT_MAJOR_VERSION, 5): QT += opengl
+
+INCLUDEPATH += /home/seiderer/Work/v4l_utils/v4l-utils
+INCLUDEPATH += /home/seiderer/Work/v4l_utils/v4l-utils/utils/v4l2-ctl/
+INCLUDEPATH += /home/seiderer/Work/v4l_utils/v4l-utils/utils/v4l2-compliance
+
 # Input
-HEADERS += qv4l2.h general-tab.h capture-win.h
-SOURCES += qv4l2.cpp general-tab.cpp ctrl-tab.cpp capture-win.cpp
-LIBS += -L../../lib/libv4l2 -lv4l2 -L../../lib/libv4lconvert -lv4lconvert -lrt -L../libv4l2util -lv4l2util -ldl -ljpeg
+HEADERS += alsa_stream.h
+HEADERS += capture-win-gl.h
+HEADERS += capture-win.h
+HEADERS += capture-win-qt.h
+HEADERS += general-tab.h
+HEADERS += qv4l2.h
+HEADERS += raw2sliced.h
+HEADERS += vbi-tab.h
+HEADERS += ../v4l2-ctl/vivid-tpg.h
+HEADERS += ../v4l2-ctl/vivid-tpg-colors.h
+HEADERS += ../../config.h
+
+SOURCES += capture-win.cpp
+SOURCES += capture-win-gl.cpp
+SOURCES += capture-win-qt.cpp
+SOURCES += ctrl-tab.cpp
+SOURCES += general-tab.cpp
+SOURCES += qv4l2.cpp
+SOURCES += raw2sliced.cpp
+SOURCES += tpg-tab.cpp
+SOURCES += vbi-tab.cpp
+SOURCES += ../v4l2-ctl/vivid-tpg.c
+SOURCES += ../v4l2-ctl/vivid-tpg-colors.c
+
+LIBS += -L$$PWD/../../lib/libv4l2 -lv4l2
+LIBS += -L$$PWD/../../lib/libv4lconvert -lv4lconvert
+LIBS += -L$$PWD/../libv4l2util -lv4l2util 
+LIBS += -lrt -ldl -ljpeg
 
 RESOURCES += qv4l2.qrc
-- 
2.1.2

