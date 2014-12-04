Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.21]:53183 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933215AbaLDX1L (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 4 Dec 2014 18:27:11 -0500
Received: from linux.local ([94.216.58.185]) by mail.gmx.com (mrgmx103) with
 ESMTPSA (Nemesis) id 0MGzwE-1YAPKJ2Uz4-00DpJe for
 <linux-media@vger.kernel.org>; Fri, 05 Dec 2014 00:27:09 +0100
From: Peter Seiderer <ps.report@gmx.net>
To: linux-media@vger.kernel.org
Subject: [PATCH 3/3] qv4l2: update qmake project file
Date: Fri,  5 Dec 2014 00:27:07 +0100
Message-Id: <1417735627-13945-3-git-send-email-ps.report@gmx.net>
In-Reply-To: <1417735627-13945-1-git-send-email-ps.report@gmx.net>
References: <1417735627-13945-1-git-send-email-ps.report@gmx.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Peter Seiderer <ps.report@gmx.net>
---
 utils/qv4l2/qv4l2.pro | 32 ++++++++++++++++++++++++++++++--
 1 file changed, 30 insertions(+), 2 deletions(-)

diff --git a/utils/qv4l2/qv4l2.pro b/utils/qv4l2/qv4l2.pro
index 7ab39cc..2c6c9c8 100644
--- a/utils/qv4l2/qv4l2.pro
+++ b/utils/qv4l2/qv4l2.pro
@@ -6,9 +6,37 @@ TEMPLATE = app
 INCLUDEPATH += . ../libv4l2util ../../lib/include ../../include
 CONFIG += debug
 
+greaterThan(QT_MAJOR_VERSION, 4): QT += widgets
+greaterThan(QT_MAJOR_VERSION, 4): QT += opengl
+
+INCLUDEPATH += /home/seiderer/Work/v4l_utils/v4l-utils
+INCLUDEPATH += /home/seiderer/Work/v4l_utils/v4l-utils/utils/v4l2-ctl/
+INCLUDEPATH += /home/seiderer/Work/v4l_utils/v4l-utils/utils/v4l2-compliance
+
 # Input
-HEADERS += qv4l2.h general-tab.h capture-win.h
-SOURCES += qv4l2.cpp general-tab.cpp ctrl-tab.cpp capture-win.cpp
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
 LIBS += -L../../lib/libv4l2 -lv4l2 -L../../lib/libv4lconvert -lv4lconvert -lrt -L../libv4l2util -lv4l2util -ldl -ljpeg
 
 RESOURCES += qv4l2.qrc
-- 
2.1.2

