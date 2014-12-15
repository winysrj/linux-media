Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:50204 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750857AbaLOVCX (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 15 Dec 2014 16:02:23 -0500
Received: from linux.local ([188.99.124.14]) by mail.gmx.com (mrgmx003) with
 ESMTPSA (Nemesis) id 0LvEZe-1XrNfj44nK-010Q6D for
 <linux-media@vger.kernel.org>; Mon, 15 Dec 2014 22:02:22 +0100
From: Peter Seiderer <ps.report@gmx.net>
To: linux-media@vger.kernel.org
Subject: [PATCH 2/2] qv4l2: fix qt5 opengl runtime errors
Date: Mon, 15 Dec 2014 22:02:20 +0100
Message-Id: <1418677340-8769-2-git-send-email-ps.report@gmx.net>
In-Reply-To: <1418677340-8769-1-git-send-email-ps.report@gmx.net>
References: <1418677340-8769-1-git-send-email-ps.report@gmx.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fix the following two runtime errors with qt-5.3.2:

- QOpenGLFunctions created with non-current context
  Program received signal SIGSEGV, Segmentation fault.
 #0  0x00007ffff62819f0 in QOpenGLContext::shareGroup() const () at /usr/lib64/libQt5Gui.so.5
 #1  0x00007ffff64ff470 in  () at /usr/lib64/libQt5Gui.so.5
 #2  0x00007ffff64ff64b in QOpenGLFunctions::initializeOpenGLFunctions() ()
     at /usr/lib64/libQt5Gui.so.5
 #3  0x00007ffff70c2e29 in  () at /usr/lib64/libQt5OpenGL.so.5
 #4  0x00007ffff70c2f7c in QGLFunctions::initializeGLFunctions(QGLContext const*) ()
     at /usr/lib64/libQt5OpenGL.so.5
 #5  0x000000000040fab7 in CaptureWinGLEngine::CaptureWinGLEngine() (this=0x7494f0)
     at ../qv4l2/capture-win-gl.cpp:149
 #6  0x000000000040f562 in CaptureWinGL::CaptureWinGL(ApplicationWindow*) (this=0x749420, aw=
     0x8bbda0) at ../qv4l2/capture-win-gl.cpp:28
 #7  0x000000000043c005 in ApplicationWindow::newCaptureWin() (this=0x8bbda0)
     at ../qv4l2/qv4l2.cpp:443
 #8  0x000000000043ab8e in ApplicationWindow::setDevice(QString const&, bool) (this=0x8bbda0, device=..., rawOpen=false) at ../qv4l2/qv4l2.cpp:257
 #9  0x0000000000444724 in main(int, char**) (argc=1, argv=0x7fffffffdcd8)
     at ../qv4l2/qv4l2.cpp:1774

   Solution: call QGLFunctions::initializeGLFunctions() later (in
   CaptureWinGLEngine::initializeGL()).

- Program received signal SIGSEGV, Segmentation fault.
 #0  0x00007ffff70c8cc0 in QGLShaderProgram::release() () at /usr/lib64/libQt5OpenGL.so.5
 #1  0x000000000040fe0f in CaptureWinGLEngine::clearShader() (this=0x6f0ae0)
     at ../qv4l2/capture-win-gl.cpp:241
 #2  0x000000000041016b in CaptureWinGLEngine::changeShader() (this=0x6f0ae0)
     at ../qv4l2/capture-win-gl.cpp:353
 #3  0x00000000004105db in CaptureWinGLEngine::paintGL() (this=0x6f0ae0)
     at ../qv4l2/capture-win-gl.cpp:438
 #4  0x00007ffff70bc2f4 in QGLWidget::glDraw() () at /usr/lib64/libQt5OpenGL.so.5
 #5  0x00007ffff70b9229 in QGLWidget::paintEvent(QPaintEvent*) ()
     at /usr/lib64/libQt5OpenGL.so.5
 #6  0x00007ffff69ec112 in QWidget::event(QEvent*) () at /usr/lib64/libQt5Widgets.so.5
 #7  0x00007ffff69b0cfc in QApplicationPrivate::notify_helper(QObject*, QEvent*) ()
     at /usr/lib64/libQt5Widgets.so.5
 #8  0x00007ffff69b5c36 in QApplication::notify(QObject*, QEvent*) ()
     at /usr/lib64/libQt5Widgets.so.5
 #9  0x00007ffff5d0fb35 in QCoreApplication::notifyInternal(QObject*, QEvent*) ()
     at /usr/lib64/libQt5Core.so.5
 #10 0x00007ffff69e6b25 in QWidgetPrivate::drawWidget(QPaintDevice*, QRegion const&, QPoint const&, int, QPainter*, QWidgetBackingStore*) () at /usr/lib64/libQt5Widgets.so.5
 #11 0x00007ffff69bd3a1 in QWidgetPrivate::repaint_sys(QRegion const&) ()
     at /usr/lib64/libQt5Widgets.so.5
 #12 0x00007ffff6a0b873 in  () at /usr/lib64/libQt5Widgets.so.5
 #13 0x00007ffff69b0cfc in QApplicationPrivate::notify_helper(QObject*, QEvent*) ()
     at /usr/lib64/libQt5Widgets.so.5
 #14 0x00007ffff69b5c36 in QApplication::notify(QObject*, QEvent*) ()
     at /usr/lib64/libQt5Widgets.so.5
 #15 0x00007ffff5d0fb35 in QCoreApplication::notifyInternal(QObject*, QEvent*) ()
     at /usr/lib64/libQt5Core.so.5
 #16 0x00007ffff6244fe6 in QGuiApplicationPrivate::processExposeEvent(QWindowSystemInterfacePrivate::ExposeEvent*) () at /usr/lib64/libQt5Gui.so.5
 #17 0x00007ffff6245b45 in QGuiApplicationPrivate::processWindowSystemEvent(QWindowSystemInterfacePrivate::WindowSystemEvent*) () at /usr/lib64/libQt5Gui.so.5
 #18 0x00007ffff622c5a8 in QWindowSystemInterface::sendWindowSystemEvents(QFlags<QEventLoop::ProcessEventsFlag>) () at /usr/lib64/libQt5Gui.so.5
 #19 0x00007fffeeb75f30 in  () at /usr/lib64/qt5/plugins/platforms/libqxcb.so
 #20 0x00007ffff42b1a04 in g_main_context_dispatch () at /usr/lib64/libglib-2.0.so.0
 #21 0x00007ffff42b1c48 in  () at /usr/lib64/libglib-2.0.so.0
 #22 0x00007ffff42b1cec in g_main_context_iteration () at /usr/lib64/libglib-2.0.so.0
 #23 0x00007ffff5d6689c in QEventDispatcherGlib::processEvents(QFlags<QEventLoop::ProcessEventsFlag>) () at /usr/lib64/libQt5Core.so.5
 #24 0x00007ffff5d0da4b in QEventLoop::exec(QFlags<QEventLoop::ProcessEventsFlag>) ()
     at /usr/lib64/libQt5Core.so.5
 #25 0x00007ffff5d150a6 in QCoreApplication::exec() () at /usr/lib64/libQt5Core.so.5
 #26 0x000000000044476d in main(int, char**) (argc=1, argv=0x7fffffffdcd8)
     at ../qv4l2/qv4l2.cpp:1777

  Solution: call QGLShaderProgram::release() only in case shader program
   is previously linked.

Signed-off-by: Peter Seiderer <ps.report@gmx.net>
---
 utils/qv4l2/capture-win-gl.cpp | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/utils/qv4l2/capture-win-gl.cpp b/utils/qv4l2/capture-win-gl.cpp
index f229866..5122d09 100644
--- a/utils/qv4l2/capture-win-gl.cpp
+++ b/utils/qv4l2/capture-win-gl.cpp
@@ -146,7 +146,7 @@ CaptureWinGLEngine::CaptureWinGLEngine() :
 	m_mag_filter(GL_NEAREST),
 	m_min_filter(GL_NEAREST)
 {
-	m_glfunction.initializeGLFunctions(context());
+
 }
 
 CaptureWinGLEngine::~CaptureWinGLEngine()
@@ -238,8 +238,10 @@ void CaptureWinGLEngine::setLinearFilter(bool enable)
 void CaptureWinGLEngine::clearShader()
 {
 	glDeleteTextures(m_screenTextureCount, m_screenTexture);
-	m_shaderProgram.release();
-	m_shaderProgram.removeAllShaders();
+	if (m_shaderProgram.isLinked()) {
+		m_shaderProgram.release();
+		m_shaderProgram.removeAllShaders();
+	}
 }
 
 void CaptureWinGLEngine::stop()
@@ -252,6 +254,8 @@ void CaptureWinGLEngine::stop()
 
 void CaptureWinGLEngine::initializeGL()
 {
+	m_glfunction.initializeGLFunctions(context());
+
 	glShadeModel(GL_FLAT);
 	glEnable(GL_TEXTURE_2D);
 	glEnable(GL_BLEND);
-- 
2.1.2

