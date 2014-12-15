Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.15]:63464 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750783AbaLOVCX (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 15 Dec 2014 16:02:23 -0500
Received: from linux.local ([188.99.124.14]) by mail.gmx.com (mrgmx003) with
 ESMTPSA (Nemesis) id 0MH0eg-1YDKMp2fAo-00DnaL for
 <linux-media@vger.kernel.org>; Mon, 15 Dec 2014 22:02:21 +0100
From: Peter Seiderer <ps.report@gmx.net>
To: linux-media@vger.kernel.org
Subject: [PATCH 1/2] qv4l2: enable qt5 opengl build
Date: Mon, 15 Dec 2014 22:02:19 +0100
Message-Id: <1418677340-8769-1-git-send-email-ps.report@gmx.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Peter Seiderer <ps.report@gmx.net>
---
 configure.ac          | 12 ++++++++++--
 utils/qv4l2/qv4l2.pro |  7 ++-----
 2 files changed, 12 insertions(+), 7 deletions(-)

diff --git a/configure.ac b/configure.ac
index 588dd9e..dce2848 100644
--- a/configure.ac
+++ b/configure.ac
@@ -143,8 +143,16 @@ if test "x$qt_pkgconfig" = "xtrue"; then
    AC_SUBST(MOC)
    AC_SUBST(UIC)
    AC_SUBST(RCC)
-# disable QTGL for qt5 because qv4l2 crash
-   qt_pkgconfig_gl=false
+   PKG_CHECK_MODULES(QT5GL, [Qt5OpenGL >= 5.0 gl], [qt_pkgconfig_gl=true], [qt_pkgconfig_gl=false])
+   if test "x$qt_pkgconfig_gl" = "xtrue"; then
+      QTGL_CFLAGS="$QT5GL_CFLAGS -fPIC"
+      QTGL_LIBS="$QT5GL_LIBS"
+      AC_SUBST(QT_CFLAGS)
+      AC_SUBST(QT_LIBS)
+      AC_DEFINE([HAVE_QTGL], [1], [qt has opengl support])
+   else
+      AC_MSG_WARN(Qt5 OpenGL is not available)
+    fi
 else
    PKG_CHECK_MODULES(QT, [QtCore >= 4.0 QtGui >= 4.0], [qt_pkgconfig=true], [qt_pkgconfig=false])
    if test "x$qt_pkgconfig" = "xtrue"; then
diff --git a/utils/qv4l2/qv4l2.pro b/utils/qv4l2/qv4l2.pro
index 82500af..a2106d0 100644
--- a/utils/qv4l2/qv4l2.pro
+++ b/utils/qv4l2/qv4l2.pro
@@ -8,12 +8,9 @@ CONFIG += debug
 
 greaterThan(QT_MAJOR_VERSION, 4): QT += widgets
 
-#
-# qt5: opengl support for disabled (will crash on startup)
-#
-# qt4: to disable opengl suppport comment out the following
+# opengl: to disable opengl suppport comment out the following
 # line and the line '#define HAVE_QTGL 1' from ../../config.h
-lessThan(QT_MAJOR_VERSION, 5): QT += opengl
+QT += opengl
 
 INCLUDEPATH += $$PWD/../..
 INCLUDEPATH += $$PWD/../v4l2-ctl/
-- 
2.1.2

