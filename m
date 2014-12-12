Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.22]:59317 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759274AbaLLS1H (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 12 Dec 2014 13:27:07 -0500
Received: from linux.local ([94.216.58.185]) by mail.gmx.com (mrgmx101) with
 ESMTPSA (Nemesis) id 0M3eDF-1XhpUG29Zp-00rHUw for
 <linux-media@vger.kernel.org>; Fri, 12 Dec 2014 19:27:05 +0100
From: Peter Seiderer <ps.report@gmx.net>
To: linux-media@vger.kernel.org
Subject: [PATCH] qv4l2: fix qmake project file
Date: Fri, 12 Dec 2014 19:27:04 +0100
Message-Id: <1418408824-4621-1-git-send-email-ps.report@gmx.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

- do not use private paths (as done by mistake)
- fix v4l-utils in place library paths

Signed-off-by: Peter Seiderer <ps.report@gmx.net>
---
 utils/qv4l2/qv4l2.pro | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/utils/qv4l2/qv4l2.pro b/utils/qv4l2/qv4l2.pro
index 19a046a..82500af 100644
--- a/utils/qv4l2/qv4l2.pro
+++ b/utils/qv4l2/qv4l2.pro
@@ -15,9 +15,9 @@ greaterThan(QT_MAJOR_VERSION, 4): QT += widgets
 # line and the line '#define HAVE_QTGL 1' from ../../config.h
 lessThan(QT_MAJOR_VERSION, 5): QT += opengl
 
-INCLUDEPATH += /home/seiderer/Work/v4l_utils/v4l-utils
-INCLUDEPATH += /home/seiderer/Work/v4l_utils/v4l-utils/utils/v4l2-ctl/
-INCLUDEPATH += /home/seiderer/Work/v4l_utils/v4l-utils/utils/v4l2-compliance
+INCLUDEPATH += $$PWD/../..
+INCLUDEPATH += $$PWD/../v4l2-ctl/
+INCLUDEPATH += $$PWD/../v4l2-compliance
 
 # Input
 HEADERS += alsa_stream.h
@@ -44,9 +44,9 @@ SOURCES += vbi-tab.cpp
 SOURCES += ../v4l2-ctl/vivid-tpg.c
 SOURCES += ../v4l2-ctl/vivid-tpg-colors.c
 
-LIBS += -L$$PWD/../../lib/libv4l2 -lv4l2
-LIBS += -L$$PWD/../../lib/libv4lconvert -lv4lconvert
-LIBS += -L$$PWD/../libv4l2util -lv4l2util 
+LIBS += -L$$PWD/../../lib/libv4l2/.libs -lv4l2
+LIBS += -L$$PWD/../../lib/libv4lconvert/.libs -lv4lconvert
+LIBS += -L$$PWD/../libv4l2util/.libs -lv4l2util 
 LIBS += -lrt -ldl -ljpeg
 
 RESOURCES += qv4l2.qrc
-- 
2.1.2

