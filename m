Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-4.cisco.com ([144.254.224.147]:22359 "EHLO
	ams-iport-4.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752048Ab3HFKWV (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 6 Aug 2013 06:22:21 -0400
Received: from bwinther.cisco.com (dhcp-10-54-92-83.cisco.com [10.54.92.83])
	by ams-core-4.cisco.com (8.14.5/8.14.5) with ESMTP id r76AMGhG015841
	for <linux-media@vger.kernel.org>; Tue, 6 Aug 2013 10:22:18 GMT
From: =?UTF-8?q?B=C3=A5rd=20Eirik=20Winther?= <bwinther@cisco.com>
To: linux-media@vger.kernel.org
Subject: [PATCH 1/9] qv4l2: generalized opengl include guards
Date: Tue,  6 Aug 2013 12:21:45 +0200
Message-Id: <f8457ccfdceb6e73b7990efe95f9e3b61d973747.1375784415.git.bwinther@cisco.com>
In-Reply-To: <1375784513-18701-1-git-send-email-bwinther@cisco.com>
References: <1375784513-18701-1-git-send-email-bwinther@cisco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Created a general QtGL makefile condition and using config.h
to check in code if QtGL is present.

Signed-off-by: Bård Eirik Winther <bwinther@cisco.com>
---
 configure.ac                   |  6 ++++--
 utils/qv4l2/Makefile.am        |  4 ++--
 utils/qv4l2/capture-win-gl.cpp | 12 ++++++------
 utils/qv4l2/capture-win-gl.h   |  6 ++++--
 4 files changed, 16 insertions(+), 12 deletions(-)

diff --git a/configure.ac b/configure.ac
index 5a0bb5f..e83baa4 100644
--- a/configure.ac
+++ b/configure.ac
@@ -132,7 +132,9 @@ else
 fi
 
 PKG_CHECK_MODULES(QTGL, [QtOpenGL >= 4.4 gl], [qt_pkgconfig_gl=true], [qt_pkgconfig_gl=false])
-if test "x$qt_pkgconfig_gl" = "xfalse"; then
+if test "x$qt_pkgconfig_gl" = "xtrue"; then
+   AC_DEFINE([HAVE_QTGL], [1], [qt has opengl support])
+else
    AC_MSG_WARN(Qt4 OpenGL or higher is not available)
 fi
 
@@ -249,9 +251,9 @@ AM_CONDITIONAL([WITH_LIBDVBV5], [test x$enable_libdvbv5 = xyes])
 AM_CONDITIONAL([WITH_LIBV4L], [test x$enable_libv4l != xno])
 AM_CONDITIONAL([WITH_V4LUTILS], [test x$enable_v4lutils != xno])
 AM_CONDITIONAL([WITH_QV4L2], [test ${qt_pkgconfig} = true -a x$enable_qv4l2 != xno])
-AM_CONDITIONAL([WITH_QV4L2_GL], [test WITH_QV4L2 -a ${qt_pkgconfig_gl} = true])
 AM_CONDITIONAL([WITH_V4L_PLUGINS], [test x$enable_libv4l != xno -a x$enable_shared != xno])
 AM_CONDITIONAL([WITH_V4L_WRAPPERS], [test x$enable_libv4l != xno -a x$enable_shared != xno])
+AM_CONDITIONAL([WITH_QTGL], [test ${qt_pkgconfig_gl} = true])
 
 # append -static to libtool compile and link command to enforce static libs
 AS_IF([test x$enable_libdvbv5 != xyes], [AC_SUBST([ENFORCE_LIBDVBV5_STATIC], ["-static"])])
diff --git a/utils/qv4l2/Makefile.am b/utils/qv4l2/Makefile.am
index 3aed18c..58ac097 100644
--- a/utils/qv4l2/Makefile.am
+++ b/utils/qv4l2/Makefile.am
@@ -7,8 +7,8 @@ nodist_qv4l2_SOURCES = moc_qv4l2.cpp moc_general-tab.cpp moc_capture-win.cpp moc
 qv4l2_LDADD = ../../lib/libv4l2/libv4l2.la ../../lib/libv4lconvert/libv4lconvert.la ../libv4l2util/libv4l2util.la \
   ../libmedia_dev/libmedia_dev.la
 
-if WITH_QV4L2_GL
-qv4l2_CPPFLAGS = $(QTGL_CFLAGS) -DENABLE_GL
+if WITH_QTGL
+qv4l2_CPPFLAGS = $(QTGL_CFLAGS)
 qv4l2_LDFLAGS = $(QTGL_LIBS)
 else
 qv4l2_CPPFLAGS = $(QT_CFLAGS)
diff --git a/utils/qv4l2/capture-win-gl.cpp b/utils/qv4l2/capture-win-gl.cpp
index 52412c7..c499f1f 100644
--- a/utils/qv4l2/capture-win-gl.cpp
+++ b/utils/qv4l2/capture-win-gl.cpp
@@ -26,7 +26,7 @@
 
 CaptureWinGL::CaptureWinGL()
 {
-#ifdef ENABLE_GL
+#ifdef HAVE_QTGL
 	CaptureWin::buildWindow(&m_videoSurface);
 #endif
 	CaptureWin::setWindowTitle("V4L2 Capture (OpenGL)");
@@ -38,14 +38,14 @@ CaptureWinGL::~CaptureWinGL()
 
 void CaptureWinGL::stop()
 {
-#ifdef ENABLE_GL
+#ifdef HAVE_QTGL
 	m_videoSurface.stop();
 #endif
 }
 
 void CaptureWinGL::setFrame(int width, int height, __u32 format, unsigned char *data, const QString &info)
 {
-#ifdef ENABLE_GL
+#ifdef HAVE_QTGL
 	m_videoSurface.setFrame(width, height, format, data);
 #endif
 	m_information.setText(info);
@@ -53,7 +53,7 @@ void CaptureWinGL::setFrame(int width, int height, __u32 format, unsigned char *
 
 bool CaptureWinGL::hasNativeFormat(__u32 format)
 {
-#ifdef ENABLE_GL
+#ifdef HAVE_QTGL
 	return m_videoSurface.hasNativeFormat(format);
 #else
 	return false;
@@ -62,14 +62,14 @@ bool CaptureWinGL::hasNativeFormat(__u32 format)
 
 bool CaptureWinGL::isSupported()
 {
-#ifdef ENABLE_GL
+#ifdef HAVE_QTGL
 	return true;
 #else
 	return false;
 #endif
 }
 
-#ifdef ENABLE_GL
+#ifdef HAVE_QTGL
 CaptureWinGLEngine::CaptureWinGLEngine() :
 	m_frameHeight(0),
 	m_frameWidth(0),
diff --git a/utils/qv4l2/capture-win-gl.h b/utils/qv4l2/capture-win-gl.h
index 08e72b2..6e64269 100644
--- a/utils/qv4l2/capture-win-gl.h
+++ b/utils/qv4l2/capture-win-gl.h
@@ -18,10 +18,12 @@
 #ifndef CAPTURE_WIN_GL_H
 #define CAPTURE_WIN_GL_H
 
+#include <config.h>
+
 #include "qv4l2.h"
 #include "capture-win.h"
 
-#ifdef ENABLE_GL
+#ifdef HAVE_QTGL
 #define GL_GLEXT_PROTOTYPES
 #include <QGLWidget>
 #include <QGLShader>
@@ -88,7 +90,7 @@ public:
 	bool hasNativeFormat(__u32 format);
 	static bool isSupported();
 
-#ifdef ENABLE_GL
+#ifdef HAVE_QTGL
 	CaptureWinGLEngine m_videoSurface;
 #endif
 };
-- 
1.8.3.2

