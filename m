Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.21]:59306 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933153AbaLDX1L (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 4 Dec 2014 18:27:11 -0500
Received: from linux.local ([94.216.58.185]) by mail.gmx.com (mrgmx103) with
 ESMTPSA (Nemesis) id 0LfTC1-1Xcz7F45Rx-00p50n for
 <linux-media@vger.kernel.org>; Fri, 05 Dec 2014 00:27:09 +0100
From: Peter Seiderer <ps.report@gmx.net>
To: linux-media@vger.kernel.org
Subject: [PATCH 1/3] configure.ac: add qt5 detection support
Date: Fri,  5 Dec 2014 00:27:05 +0100
Message-Id: <1417735627-13945-1-git-send-email-ps.report@gmx.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Disable QTGL for qt5 because of qv4l2 crash on startup.

Signed-off-by: Peter Seiderer <ps.report@gmx.net>
---
 configure.ac | 41 +++++++++++++++++++++++++++--------------
 1 file changed, 27 insertions(+), 14 deletions(-)

diff --git a/configure.ac b/configure.ac
index 7bf9bf6..245a409 100644
--- a/configure.ac
+++ b/configure.ac
@@ -131,29 +131,42 @@ AS_IF([test "x$with_jpeg" != xno],
 
 AM_CONDITIONAL([HAVE_JPEG], [$have_jpeg])
 
-PKG_CHECK_MODULES(QT, [QtCore >= 4.4 QtGui >= 4.4], [qt_pkgconfig=true], [qt_pkgconfig=false])
+PKG_CHECK_MODULES(QT, [Qt5Core >= 5.0 Qt5Gui >= 5.0 Qt5Widgets >= 5.0], [qt_pkgconfig=true], [qt_pkgconfig=false])
 if test "x$qt_pkgconfig" = "xtrue"; then
+   QT_CFLAGS="$QT_CFLAGS -fPIC"
    AC_SUBST(QT_CFLAGS)
    AC_SUBST(QT_LIBS)
-   MOC=`$PKG_CONFIG --variable=moc_location QtCore`
-   UIC=`$PKG_CONFIG --variable=uic_location QtCore`
-   RCC=`$PKG_CONFIG --variable=rcc_location QtCore`
-   if test -z "$RCC"; then
-      RCC="rcc"
-   fi
+   AC_CHECK_PROGS(MOC, [moc-qt5 moc])
+   AC_CHECK_PROGS(UIC, [uic-qt5 uic])
+   AC_CHECK_PROGS(RCC, [rcc-qt5 rcc])
    AC_SUBST(MOC)
    AC_SUBST(UIC)
    AC_SUBST(RCC)
+# disable QTGL for qt5 because qv4l2 crash
+   qt_pkgconfig_gl=false
 else
-   AC_MSG_WARN(Qt4 or higher is not available)
+   PKG_CHECK_MODULES(QT, [QtCore >= 4.0 QtGui >= 4.0], [qt_pkgconfig=true], [qt_pkgconfig=false])
+   if test "x$qt_pkgconfig" = "xtrue"; then
+      MOC=`$PKG_CONFIG --variable=moc_location Qt5Core`
+      UIC=`$PKG_CONFIG --variable=uic_location Qt5Core`
+      RCC=`$PKG_CONFIG --variable=rcc_location Qt5Core`
+      if test -z "$RCC"; then
+         RCC="rcc"
+      fi
+      AC_SUBST(MOC)
+      AC_SUBST(UIC)
+      AC_SUBST(RCC)
+      PKG_CHECK_MODULES(QTGL, [QtOpenGL >= 4.8 gl], [qt_pkgconfig_gl=true], [qt_pkgconfig_gl=false])
+      if test "x$qt_pkgconfig_gl" = "xtrue"; then
+         AC_DEFINE([HAVE_QTGL], [1], [qt has opengl support])
+      else
+         AC_MSG_WARN(Qt4 OpenGL is not available)
+      fi
+   else
+      AC_MSG_WARN(Qt4 or higher is not available)
+   fi
 fi
 
-PKG_CHECK_MODULES(QTGL, [QtOpenGL >= 4.8 gl], [qt_pkgconfig_gl=true], [qt_pkgconfig_gl=false])
-if test "x$qt_pkgconfig_gl" = "xtrue"; then
-   AC_DEFINE([HAVE_QTGL], [1], [qt has opengl support])
-else
-   AC_MSG_WARN(Qt4 OpenGL or higher is not available)
-fi
 
 PKG_CHECK_MODULES(ALSA, [alsa], [alsa_pkgconfig=true], [alsa_pkgconfig=false])
 if test "x$alsa_pkgconfig" = "xtrue"; then
-- 
2.1.2

