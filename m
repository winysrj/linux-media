Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-3.cisco.com ([144.254.224.146]:20693 "EHLO
	ams-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755980Ab3GYN0J (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 25 Jul 2013 09:26:09 -0400
Received: from bwinther.cisco.com (dhcp-10-54-92-49.cisco.com [10.54.92.49])
	by ams-core-2.cisco.com (8.14.5/8.14.5) with ESMTP id r6PDPtGS025835
	for <linux-media@vger.kernel.org>; Thu, 25 Jul 2013 13:26:06 GMT
From: =?UTF-8?q?B=C3=A5rd=20Eirik=20Winther?= <bwinther@cisco.com>
To: linux-media@vger.kernel.org
Subject: [PATCHv2 5/5] qv4l2: add OpenGL video display and render
Date: Thu, 25 Jul 2013 15:25:24 +0200
Message-Id: <6e0f795b4c1fcbf578edc3f0d23918b2707dca25.1374758669.git.bwinther@cisco.com>
In-Reply-To: <1374758724-3058-1-git-send-email-bwinther@cisco.com>
References: <1374758724-3058-1-git-send-email-bwinther@cisco.com>
In-Reply-To: <0fd43d1af7343792f570f32251ad150735066f71.1374758669.git.bwinther@cisco.com>
References: <0fd43d1af7343792f570f32251ad150735066f71.1374758669.git.bwinther@cisco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Adds OpenGL-accelerated display of video for the qv4l2 test utility.
This allows for using the graphics card to render the video content to screen
and to perform color space conversion.

Signed-off-by: Bård Eirik Winther <bwinther@cisco.com>
---
 configure.ac                   |   8 +-
 utils/qv4l2/Makefile.am        |   8 +-
 utils/qv4l2/capture-win-gl.cpp | 556 +++++++++++++++++++++++++++++++++++++++++
 utils/qv4l2/capture-win-gl.h   | 103 ++++++++
 utils/qv4l2/qv4l2.cpp          |  52 +++-
 utils/qv4l2/qv4l2.h            |  10 +
 6 files changed, 733 insertions(+), 4 deletions(-)
 create mode 100644 utils/qv4l2/capture-win-gl.cpp
 create mode 100644 utils/qv4l2/capture-win-gl.h

diff --git a/configure.ac b/configure.ac
index e249546..d74da61 100644
--- a/configure.ac
+++ b/configure.ac
@@ -128,7 +128,12 @@ if test "x$qt_pkgconfig" = "xtrue"; then
    AC_SUBST(UIC)
    AC_SUBST(RCC)
 else
-   AC_MSG_WARN(Qt4 is not available)
+   AC_MSG_WARN(Qt4 or higher is not available)
+fi
+
+PKG_CHECK_MODULES(QTGL, [QtOpenGL >= 4.4 gl], [qt_pkgconfig_gl=true], [qt_pkgconfig_gl=false])
+if test "x$qt_pkgconfig_gl" = "xfalse"; then
+   AC_MSG_WARN(Qt4 OpenGL or higher is not available)
 fi
 
 AC_SUBST([JPEG_LIBS])
@@ -237,6 +242,7 @@ AM_CONDITIONAL([WITH_LIBDVBV5], [test x$enable_libdvbv5 = xyes])
 AM_CONDITIONAL([WITH_LIBV4L], [test x$enable_libv4l != xno])
 AM_CONDITIONAL([WITH_V4LUTILS], [test x$enable_v4lutils != xno])
 AM_CONDITIONAL([WITH_QV4L2], [test ${qt_pkgconfig} = true -a x$enable_qv4l2 != xno])
+AM_CONDITIONAL([WITH_QV4L2_GL], [test WITH_QV4L2 -a ${qt_pkgconfig_gl} = true])
 AM_CONDITIONAL([WITH_V4L_PLUGINS], [test x$enable_libv4l != xno -a x$enable_shared != xno])
 AM_CONDITIONAL([WITH_V4L_WRAPPERS], [test x$enable_libv4l != xno -a x$enable_shared != xno])
 
diff --git a/utils/qv4l2/Makefile.am b/utils/qv4l2/Makefile.am
index 9ef8149..22d4c17 100644
--- a/utils/qv4l2/Makefile.am
+++ b/utils/qv4l2/Makefile.am
@@ -1,12 +1,18 @@
 bin_PROGRAMS = qv4l2
 
 qv4l2_SOURCES = qv4l2.cpp general-tab.cpp ctrl-tab.cpp vbi-tab.cpp v4l2-api.cpp capture-win.cpp \
-  capture-win-qt.cpp capture-win-qt.h \
+  capture-win-qt.cpp capture-win-qt.h capture-win-gl.cpp capture-win-gl.h \
   raw2sliced.cpp qv4l2.h capture-win.h general-tab.h vbi-tab.h v4l2-api.h raw2sliced.h
 nodist_qv4l2_SOURCES = moc_qv4l2.cpp moc_general-tab.cpp moc_capture-win.cpp moc_vbi-tab.cpp qrc_qv4l2.cpp
 qv4l2_LDADD = ../../lib/libv4l2/libv4l2.la ../../lib/libv4lconvert/libv4lconvert.la ../libv4l2util/libv4l2util.la
+
+if WITH_QV4L2_GL
+qv4l2_CPPFLAGS = $(QTGL_CFLAGS) -DENABLE_GL
+qv4l2_LDFLAGS = $(QTGL_LIBS)
+else
 qv4l2_CPPFLAGS = $(QT_CFLAGS)
 qv4l2_LDFLAGS = $(QT_LIBS)
+endif
 
 EXTRA_DIST = exit.png fileopen.png qv4l2_24x24.png qv4l2_64x64.png qv4l2.png qv4l2.svg snapshot.png \
   video-television.png fileclose.png qv4l2_16x16.png qv4l2_32x32.png qv4l2.desktop qv4l2.qrc record.png \
diff --git a/utils/qv4l2/capture-win-gl.cpp b/utils/qv4l2/capture-win-gl.cpp
new file mode 100644
index 0000000..d5c1d54
--- /dev/null
+++ b/utils/qv4l2/capture-win-gl.cpp
@@ -0,0 +1,556 @@
+/*
+ * The YUY2 shader code was copied and simplified from face-responder. The code is under public domain:
+ * https://bitbucket.org/nateharward/face-responder/src/0c3b4b957039d9f4bf1da09b9471371942de2601/yuv42201_laplace.frag?at=master
+ *
+ * Copyright (C) 2012 Nathan Harward
+ *
+ * All other OpenGL code:
+ *
+ * Copyright 2012 Cisco Systems, Inc. and/or its affiliates. All rights reserved.
+ *
+ * This program is free software; you may redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; version 2 of the License.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
+ * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
+ * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
+ * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
+ * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
+ * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
+ * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
+ * SOFTWARE.
+ */
+
+#include "capture-win-gl.h"
+
+#include <stdio.h>
+
+CaptureWinGL::CaptureWinGL()
+{
+	CaptureWin::buildWindow(&m_videoSurface);
+	CaptureWin::setWindowTitle("V4L2 Capture (OpenGL)");
+}
+
+CaptureWinGL::~CaptureWinGL()
+{
+}
+
+void CaptureWinGL::stop()
+{
+#ifdef ENABLE_GL
+	m_videoSurface.stop();
+#endif
+}
+
+void CaptureWinGL::setFrame(int width, int height, __u32 format, unsigned char *data, const QString &info)
+{
+#ifdef ENABLE_GL
+	m_videoSurface.setFrame(width, height, format, data);
+#endif
+	m_information.setText(info);
+}
+
+bool CaptureWinGL::hasNativeFormat(__u32 format)
+{
+#ifdef ENABLE_GL
+	return m_videoSurface.hasNativeFormat(format);
+#else
+	return false;
+#endif
+}
+
+bool CaptureWinGL::isSupported()
+{
+#ifdef ENABLE_GL
+	return true;
+#else
+	return false;
+#endif
+}
+
+#ifdef ENABLE_GL
+CaptureWinGLEngine::CaptureWinGLEngine() :
+	m_frameHeight(0),
+	m_frameWidth(0),
+	m_screenTextureCount(0),
+	m_formatChange(false),
+	m_frameFormat(0),
+	m_frameData(NULL)
+{
+	m_glfunction.initializeGLFunctions(context());
+}
+
+CaptureWinGLEngine::~CaptureWinGLEngine()
+{
+	clearShader();
+}
+
+void CaptureWinGLEngine::clearShader()
+{
+	glDeleteTextures(m_screenTextureCount, m_screenTexture);
+	m_shaderProgram.release();
+	m_shaderProgram.removeAllShaders();
+}
+
+void CaptureWinGLEngine::stop()
+{
+	// Setting the m_frameData to NULL stops OpenGL
+	// from updating frames on repaint
+	m_frameData = NULL;
+}
+
+void CaptureWinGLEngine::initializeGL()
+{
+	glShadeModel(GL_FLAT);
+	glEnable(GL_TEXTURE_2D);
+
+	glClearColor(0.0f, 0.0f, 0.0f, 0.0f);
+	checkError("InitializeGL");
+}
+
+
+void CaptureWinGLEngine::resizeGL(int width, int height)
+{
+	// Resizing is disabled by setting viewport equal to frame size
+	glViewport(0, 0, m_frameWidth, m_frameHeight);
+}
+
+void CaptureWinGLEngine::setFrame(int width, int height, __u32 format, unsigned char *data)
+{
+	if (format != m_frameFormat || width != m_frameWidth || height != m_frameHeight) {
+		m_formatChange = true;
+		m_frameWidth = width;
+		m_frameHeight = height;
+		m_frameFormat = format;
+
+		QGLWidget::setMaximumSize(m_frameWidth, m_frameHeight);
+	}
+
+	m_frameData = data;
+	updateGL();
+}
+
+void CaptureWinGLEngine::checkError(const char *msg)
+{
+	int err = glGetError();
+	if (err) fprintf(stderr, "OpenGL Error 0x%x: %s.\n", err, msg);
+}
+
+bool CaptureWinGLEngine::hasNativeFormat(__u32 format)
+{
+	static const __u32 supported_fmts[] = {
+		V4L2_PIX_FMT_RGB32,
+		V4L2_PIX_FMT_BGR32,
+		V4L2_PIX_FMT_RGB24,
+		V4L2_PIX_FMT_BGR24,
+		V4L2_PIX_FMT_RGB565,
+		V4L2_PIX_FMT_RGB555,
+		V4L2_PIX_FMT_YUYV,
+		V4L2_PIX_FMT_YVYU,
+		V4L2_PIX_FMT_UYVY,
+		V4L2_PIX_FMT_VYUY,
+		V4L2_PIX_FMT_YVU420,
+		V4L2_PIX_FMT_YUV420,
+		0
+	};
+
+	for (int i = 0; supported_fmts[i]; i++)
+		if (supported_fmts[i] == format)
+			return true;
+
+	return false;
+}
+
+void CaptureWinGLEngine::changeShader()
+{
+	m_formatChange = false;
+	clearShader();
+
+	glMatrixMode(GL_PROJECTION);
+	glLoadIdentity();
+	glOrtho(0, m_frameWidth, m_frameHeight, 0, 0, 1);
+	resizeGL(QGLWidget::width(), QGLWidget::height());
+	checkError("Render settings.\n");
+
+	switch (m_frameFormat) {
+	case V4L2_PIX_FMT_YUYV:
+	case V4L2_PIX_FMT_YVYU:
+	case V4L2_PIX_FMT_UYVY:
+	case V4L2_PIX_FMT_VYUY:
+		shader_YUY2(m_frameFormat);
+		break;
+
+	case V4L2_PIX_FMT_YUV420:
+	case V4L2_PIX_FMT_YVU420:
+		shader_YUV();
+		break;
+
+	case V4L2_PIX_FMT_RGB32:
+		m_screenTextureCount = 1;
+		glActiveTexture(GL_TEXTURE0);
+		glGenTextures(m_screenTextureCount, m_screenTexture);
+		configureTexture(0);
+		glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA4, m_frameWidth, m_frameHeight, 0,
+			     GL_BGRA, GL_UNSIGNED_INT_8_8_8_8, NULL);
+		checkError("RGB32 shader");
+		break;
+
+	case V4L2_PIX_FMT_BGR32:
+		m_screenTextureCount = 1;
+		glActiveTexture(GL_TEXTURE0);
+		glGenTextures(m_screenTextureCount, m_screenTexture);
+		configureTexture(0);
+		glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA4, m_frameWidth, m_frameHeight, 0,
+			     GL_RGBA, GL_UNSIGNED_INT_8_8_8_8, NULL);
+		checkError("BGR32 shader");
+		break;
+
+	case V4L2_PIX_FMT_RGB555:
+		m_screenTextureCount = 1;
+		glActiveTexture(GL_TEXTURE0);
+		glGenTextures(m_screenTextureCount, m_screenTexture);
+		configureTexture(0);
+		glTexImage2D(GL_TEXTURE_2D, 0, GL_RGB5_A1, m_frameWidth, m_frameHeight, 0,
+			     GL_BGRA, GL_UNSIGNED_SHORT_1_5_5_5_REV, NULL);
+		checkError("RGB555 shader");
+		break;
+
+	case V4L2_PIX_FMT_RGB565:
+		m_screenTextureCount = 1;
+		glActiveTexture(GL_TEXTURE0);
+		glGenTextures(m_screenTextureCount, m_screenTexture);
+		configureTexture(0);
+		glTexImage2D(GL_TEXTURE_2D, 0, GL_RGB, m_frameWidth, m_frameHeight, 0,
+			     GL_RGB, GL_UNSIGNED_SHORT_5_6_5, NULL);
+		checkError("RGB565 shader");
+		break;
+	case V4L2_PIX_FMT_BGR24:
+		shader_BGR();
+		break;
+	case V4L2_PIX_FMT_RGB24:
+	default:
+		m_screenTextureCount = 1;
+		glActiveTexture(GL_TEXTURE0);
+		glGenTextures(m_screenTextureCount, m_screenTexture);
+		configureTexture(0);
+		glTexImage2D(GL_TEXTURE_2D, 0, GL_RGB, m_frameWidth, m_frameHeight, 0,
+			     GL_RGB, GL_UNSIGNED_BYTE, NULL);
+		checkError("Default shader");
+		break;
+	}
+}
+
+void CaptureWinGLEngine::paintGL()
+{
+	if (m_frameWidth < 1 || m_frameHeight < 1) {
+		glClear(GL_COLOR_BUFFER_BIT);
+		return;
+	}
+
+	if (m_formatChange)
+		changeShader();
+
+	
+	if (m_frameData == NULL) {
+		glClear(GL_COLOR_BUFFER_BIT);
+		return;
+	}
+
+	switch (m_frameFormat) {
+	case V4L2_PIX_FMT_YUYV:
+	case V4L2_PIX_FMT_YVYU:
+	case V4L2_PIX_FMT_UYVY:
+	case V4L2_PIX_FMT_VYUY:
+		render_YUY2();
+		break;
+
+	case V4L2_PIX_FMT_YUV420:
+	case V4L2_PIX_FMT_YVU420:
+		render_YUV(m_frameFormat);
+		break;
+
+	case V4L2_PIX_FMT_RGB32:
+		glTexSubImage2D(GL_TEXTURE_2D, 0, 0, 0, m_frameWidth, m_frameHeight,
+				GL_BGRA, GL_UNSIGNED_INT_8_8_8_8, m_frameData);
+		checkError("RGB32 paint");
+		break;
+
+	case V4L2_PIX_FMT_BGR32:
+		glTexSubImage2D(GL_TEXTURE_2D, 0, 0, 0, m_frameWidth, m_frameHeight,
+				GL_BGRA, GL_UNSIGNED_INT_8_8_8_8_REV, m_frameData);
+		checkError("BGR32 paint");
+		break;
+
+	case V4L2_PIX_FMT_RGB555:
+		glTexSubImage2D(GL_TEXTURE_2D, 0, 0, 0, m_frameWidth, m_frameHeight,
+				GL_BGRA, GL_UNSIGNED_SHORT_1_5_5_5_REV, m_frameData);
+		checkError("RGB555 paint");
+		break;
+
+	case V4L2_PIX_FMT_RGB565:
+		glTexSubImage2D(GL_TEXTURE_2D, 0, 0, 0, m_frameWidth, m_frameHeight,
+				GL_RGB, GL_UNSIGNED_SHORT_5_6_5, m_frameData);
+		checkError("RGB565 paint");
+		break;
+
+	case V4L2_PIX_FMT_BGR24:
+		render_BGR();
+		break;
+	case V4L2_PIX_FMT_RGB24:
+	default:
+		glActiveTexture(GL_TEXTURE0);
+		glBindTexture(GL_TEXTURE_2D, m_screenTexture[0]);
+		glTexSubImage2D(GL_TEXTURE_2D, 0, 0, 0, m_frameWidth, m_frameHeight,
+				GL_RGB, GL_UNSIGNED_BYTE, m_frameData);
+		checkError("Default paint");
+		break;
+	}
+
+	glBegin(GL_QUADS);
+	glTexCoord2f(0.0f, 0.0f); glVertex2f(0.0, 0);
+	glTexCoord2f(1.0f, 0.0f); glVertex2f(m_frameWidth, 0);
+	glTexCoord2f(1.0f, 1.0f); glVertex2f(m_frameWidth, m_frameHeight);
+	glTexCoord2f(0.0f, 1.0f); glVertex2f(0, m_frameHeight);
+	glEnd();
+}
+
+void CaptureWinGLEngine::configureTexture(size_t idx)
+{
+	glBindTexture(GL_TEXTURE_2D, m_screenTexture[idx]);
+	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST);
+	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_NEAREST);
+	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP);
+	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP);
+}
+
+void CaptureWinGLEngine::shader_YUV()
+{
+	m_screenTextureCount = 3;
+	glGenTextures(m_screenTextureCount, m_screenTexture);
+
+	glActiveTexture(GL_TEXTURE0);
+	configureTexture(0);
+	glTexImage2D(GL_TEXTURE_2D, 0, GL_LUMINANCE, m_frameWidth, m_frameHeight, 0,
+		     GL_LUMINANCE, GL_UNSIGNED_BYTE, NULL);
+	checkError("YUV shader texture 0");
+
+	glActiveTexture(GL_TEXTURE1);
+	configureTexture(1);
+	glTexImage2D(GL_TEXTURE_2D, 0, GL_LUMINANCE, m_frameWidth / 2, m_frameHeight / 2, 0,
+		     GL_LUMINANCE, GL_UNSIGNED_BYTE, NULL);
+	checkError("YUV shader texture 1");
+
+	glActiveTexture(GL_TEXTURE2);
+	configureTexture(2);
+	glTexImage2D(GL_TEXTURE_2D, 0, GL_LUMINANCE, m_frameWidth / 2, m_frameHeight / 2, 0,
+		     GL_LUMINANCE, GL_UNSIGNED_BYTE, NULL);
+	checkError("YUV shader texture 2");
+
+	bool src_c = m_shaderProgram.addShaderFromSourceCode(
+				QGLShader::Fragment,
+				"uniform sampler2D ytex;"
+				"uniform sampler2D utex;"
+				"uniform sampler2D vtex;"
+				"void main()"
+				"{"
+				"   vec2 xy = vec2(gl_TexCoord[0].xy);"
+				"   float y = 1.1640625 * (texture2D(ytex, xy).r - 0.0625);"
+				"   float u = texture2D(utex, xy).r - 0.5;"
+				"   float v = texture2D(vtex, xy).r - 0.5;"
+				"   float r = y + 1.59765625 * v;"
+				"   float g = y - 0.390625 * u - 0.8125 *v;"
+				"   float b = y + 2.015625 * u;"
+				"   gl_FragColor = vec4(r, g, b, 1.0);"
+				"}"
+				);
+
+	if (!src_c)
+		fprintf(stderr, "OpenGL Error: YUV shader compilation failed.\n");
+
+	m_shaderProgram.bind();
+}
+
+void CaptureWinGLEngine::render_YUV(__u32 format)
+{
+	int idxU;
+	int idxV;
+	if (format == V4L2_PIX_FMT_YUV420) {
+		idxU = m_frameWidth * m_frameHeight;
+		idxV = idxU + (idxU / 4);
+	} else {
+		idxV = m_frameWidth * m_frameHeight;
+		idxU = idxV + (idxV / 4);
+	}
+
+	glActiveTexture(GL_TEXTURE0);
+	glBindTexture(GL_TEXTURE_2D, m_screenTexture[0]);
+	GLint Y = m_glfunction.glGetUniformLocation(m_shaderProgram.programId(), "ytex");
+	glUniform1i(Y, 0);
+	glTexSubImage2D(GL_TEXTURE_2D, 0, 0, 0, m_frameWidth, m_frameHeight,
+			GL_LUMINANCE, GL_UNSIGNED_BYTE, m_frameData);
+	checkError("YUV paint ytex");
+
+	glActiveTexture(GL_TEXTURE1);
+	glBindTexture(GL_TEXTURE_2D, m_screenTexture[1]);
+	GLint U = m_glfunction.glGetUniformLocation(m_shaderProgram.programId(), "utex");
+	glUniform1i(U, 1);
+	glTexSubImage2D(GL_TEXTURE_2D, 0, 0, 0, m_frameWidth / 2, m_frameHeight / 2,
+			GL_LUMINANCE, GL_UNSIGNED_BYTE, m_frameData == NULL ? NULL : &m_frameData[idxU]);
+	checkError("YUV paint utex");
+
+	glActiveTexture(GL_TEXTURE2);
+	glBindTexture(GL_TEXTURE_2D, m_screenTexture[2]);
+	GLint V = m_glfunction.glGetUniformLocation(m_shaderProgram.programId(), "vtex");
+	glUniform1i(V, 2);
+	glTexSubImage2D(GL_TEXTURE_2D, 0, 0, 0, m_frameWidth / 2, m_frameHeight / 2,
+			GL_LUMINANCE, GL_UNSIGNED_BYTE, m_frameData == NULL ? NULL : &m_frameData[idxV]);
+	checkError("YUV paint vtex");
+}
+
+void CaptureWinGLEngine::shader_BGR()
+{
+	m_screenTextureCount = 1;
+	glGenTextures(m_screenTextureCount, m_screenTexture);
+	configureTexture(0);
+	glTexImage2D(GL_TEXTURE_2D, 0, GL_RGB, m_frameWidth, m_frameHeight, 0,
+		     GL_RGB, GL_UNSIGNED_BYTE, NULL);
+	checkError("BGR shader");
+
+	bool src_c = m_shaderProgram.addShaderFromSourceCode(
+				QGLShader::Fragment,
+				"uniform sampler2D tex;"
+				"void main()"
+				"{"
+				"   vec4 color = texture2D(tex, gl_TexCoord[0].xy);"
+				"   gl_FragColor = vec4(color.b, color.g, color.r, 1.0);"
+				"}"
+				);
+	if (!src_c)
+		fprintf(stderr, "OpenGL Error: BGR shader compilation failed.\n");
+
+	m_shaderProgram.bind();
+}
+
+void CaptureWinGLEngine::render_BGR()
+{
+	glActiveTexture(GL_TEXTURE0);
+	glBindTexture(GL_TEXTURE_2D, m_screenTexture[0]);
+	GLint Y = m_glfunction.glGetUniformLocation(m_shaderProgram.programId(), "tex");
+	glUniform1i(Y, 0);
+	glTexSubImage2D(GL_TEXTURE_2D, 0, 0, 0, m_frameWidth, m_frameHeight,
+			GL_RGB, GL_UNSIGNED_BYTE, m_frameData);
+	checkError("BGR paint");
+}
+
+QString CaptureWinGLEngine::shader_YUY2_invariant(__u32 format)
+{
+	switch (format) {
+	case V4L2_PIX_FMT_YUYV:
+		return QString("y = (luma_chroma.r - 0.0625) * 1.1643;"
+			       "if (mod(xcoord, 2.0) == 0.0) {"
+			       "   u = luma_chroma.a;"
+			       "   v = texture2D(tex, vec2(pixelx + texl_w, pixely)).a;"
+			       "} else {"
+			       "   v = luma_chroma.a;"
+			       "   u = texture2D(tex, vec2(pixelx - texl_w, pixely)).a;"
+			       "}"
+			       );
+
+	case V4L2_PIX_FMT_YVYU:
+		return QString("y = (luma_chroma.r - 0.0625) * 1.1643;"
+			       "if (mod(xcoord, 2.0) == 0.0) {"
+			       "   v = luma_chroma.a;"
+			       "   u = texture2D(tex, vec2(pixelx + texl_w, pixely)).a;"
+			       "} else {"
+			       "   u = luma_chroma.a;"
+			       "   v = texture2D(tex, vec2(pixelx - texl_w, pixely)).a;"
+			       "}"
+			       );
+
+	case V4L2_PIX_FMT_UYVY:
+		return QString("y = (luma_chroma.a - 0.0625) * 1.1643;"
+			       "if (mod(xcoord, 2.0) == 0.0) {"
+			       "   u = luma_chroma.r;"
+			       "   v = texture2D(tex, vec2(pixelx + texl_w, pixely)).r;"
+			       "} else {"
+			       "   v = luma_chroma.r;"
+			       "   u = texture2D(tex, vec2(pixelx - texl_w, pixely)).r;"
+			       "}"
+			       );
+
+	case V4L2_PIX_FMT_VYUY:
+		return QString("y = (luma_chroma.a - 0.0625) * 1.1643;"
+			       "if (mod(xcoord, 2.0) == 0.0) {"
+			       "   v = luma_chroma.r;"
+			       "   u = texture2D(tex, vec2(pixelx + texl_w, pixely)).r;"
+			       "} else {"
+			       "   u = luma_chroma.r;"
+			       "   v = texture2D(tex, vec2(pixelx - texl_w, pixely)).r;"
+			       "}"
+			       );
+
+	default:
+		return QString();
+	}
+}
+
+void CaptureWinGLEngine::shader_YUY2(__u32 format)
+{
+	m_screenTextureCount = 1;
+	glGenTextures(m_screenTextureCount, m_screenTexture);
+	configureTexture(0);
+	glTexImage2D(GL_TEXTURE_2D, 0, GL_LUMINANCE_ALPHA, m_frameWidth, m_frameHeight, 0,
+		     GL_LUMINANCE_ALPHA, GL_UNSIGNED_BYTE, NULL);
+	checkError("YUY2 shader");
+
+	QString codeHead = QString("uniform sampler2D tex;"
+				   "uniform float texl_w;"
+				   "uniform float tex_w;"
+				   "void main()"
+				   "{"
+				   "   float y, u, v;"
+				   "   float pixelx = gl_TexCoord[0].x;"
+				   "   float pixely = gl_TexCoord[0].y;"
+				   "   float xcoord = floor(pixelx * tex_w);"
+				   "   vec4 luma_chroma = texture2D(tex, vec2(pixelx, pixely));"
+				   );
+
+	QString codeBody = shader_YUY2_invariant(format);
+
+	QString codeTail = QString("   u = u - 0.5;"
+				   "   v = v - 0.5;"
+				   "   float r = y + 1.5958 * v;"
+				   "   float g = y - 0.39173 * u - 0.81290 * v;"
+				   "   float b = y + 2.017 * u;"
+				   "   gl_FragColor = vec4(r, g, b, 1.0);"
+				   "}"
+				   );
+
+	bool src_ok = m_shaderProgram.addShaderFromSourceCode(
+				QGLShader::Fragment, QString("%1%2%3").arg(codeHead, codeBody, codeTail)
+				);
+
+	if (!src_ok)
+		fprintf(stderr, "OpenGL Error: YUY2 shader compilation failed.\n");
+
+	m_shaderProgram.bind();
+}
+
+void CaptureWinGLEngine::render_YUY2()
+{
+	int idx;
+	idx = glGetUniformLocation(m_shaderProgram.programId(), "texl_w"); // Texel width
+	glUniform1f(idx, 1.0 / m_frameWidth);
+	idx = glGetUniformLocation(m_shaderProgram.programId(), "tex_w"); // Texture width
+	glUniform1f(idx, m_frameWidth);
+
+	glActiveTexture(GL_TEXTURE0);
+	glBindTexture(GL_TEXTURE_2D, m_screenTexture[0]);
+	GLint Y = m_glfunction.glGetUniformLocation(m_shaderProgram.programId(), "tex");
+	glUniform1i(Y, 0);
+	glTexSubImage2D(GL_TEXTURE_2D, 0, 0, 0, m_frameWidth, m_frameHeight,
+			GL_LUMINANCE_ALPHA, GL_UNSIGNED_BYTE, m_frameData);
+	checkError("YUY2 paint");
+}
+#endif
diff --git a/utils/qv4l2/capture-win-gl.h b/utils/qv4l2/capture-win-gl.h
new file mode 100644
index 0000000..daa5376
--- /dev/null
+++ b/utils/qv4l2/capture-win-gl.h
@@ -0,0 +1,103 @@
+/*
+ * The YUY2 shader code was copied and simplified from face-responder. The code is under public domain:
+ * https://bitbucket.org/nateharward/face-responder/src/0c3b4b957039d9f4bf1da09b9471371942de2601/yuv42201_laplace.frag?at=master
+ *
+ * Copyright (C) 2012 Nathan Harward
+ *
+ * All other OpenGL code:
+ *
+ * Copyright 2012 Cisco Systems, Inc. and/or its affiliates. All rights reserved.
+ *
+ * This program is free software; you may redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; version 2 of the License.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
+ * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
+ * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
+ * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
+ * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
+ * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
+ * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
+ * SOFTWARE.
+ */
+
+#ifndef CAPTURE_WIN_GL_H
+#define CAPTURE_WIN_GL_H
+
+#include "qv4l2.h"
+#include "capture-win.h"
+
+#ifdef ENABLE_GL
+#define GL_GLEXT_PROTOTYPES
+#include <QGLWidget>
+#include <QGLShader>
+#include <QGLShaderProgram>
+#include <QGLFunctions>
+
+// This must be equal to the max number of textures that any shader uses
+#define MAX_TEXTURES_NEEDED 3
+
+class CaptureWinGLEngine : public QGLWidget
+{
+public:
+	CaptureWinGLEngine();
+	~CaptureWinGLEngine();
+
+	void stop();
+	void setFrame(int width, int height, __u32 format, unsigned char *data);
+	bool hasNativeFormat(__u32 format);
+
+protected:
+	void paintGL();
+	void initializeGL();
+	void resizeGL(int width, int height);
+
+private:
+	// Colorspace conversion shaders
+	void shader_YUV();
+	void shader_BGR();
+	void shader_YUY2(__u32 format);
+	QString shader_YUY2_invariant(__u32 format);
+
+	// Colorspace conversion render
+	void render_BGR();
+	void render_YUY2();
+	void render_YUV(__u32 format);
+
+	void clearShader();
+	void changeShader();
+	void configureTexture(size_t idx);
+	void checkError(const char *msg);
+
+	int m_frameHeight;
+	int m_frameWidth;
+	int m_screenTextureCount;
+	bool m_formatChange;
+	__u32 m_frameFormat;
+	GLuint m_screenTexture[MAX_TEXTURES_NEEDED];
+	QGLFunctions m_glfunction;
+	unsigned char *m_frameData;
+	QGLShaderProgram m_shaderProgram;
+};
+
+#endif
+
+class CaptureWinGL : public CaptureWin
+{
+public:
+	CaptureWinGL();
+	~CaptureWinGL();
+
+	void setFrame(int width, int height, __u32 format,
+		      unsigned char *data, const QString &info);
+	void stop();
+	bool hasNativeFormat(__u32 format);
+	static bool isSupported();
+
+#ifdef ENABLE_GL
+	CaptureWinGLEngine m_videoSurface;
+#endif
+};
+
+#endif
diff --git a/utils/qv4l2/qv4l2.cpp b/utils/qv4l2/qv4l2.cpp
index 74099cb..18810d4 100644
--- a/utils/qv4l2/qv4l2.cpp
+++ b/utils/qv4l2/qv4l2.cpp
@@ -22,6 +22,7 @@
 #include "vbi-tab.h"
 #include "capture-win.h"
 #include "capture-win-qt.h"
+#include "capture-win-gl.h"
 
 #include <QToolBar>
 #include <QToolButton>
@@ -132,6 +133,19 @@ ApplicationWindow::ApplicationWindow() :
 	previewMenu->addAction(m_showFramesAct);
 	previewMenu->addSeparator();
 
+	if (CaptureWinGL::isSupported()) {
+		m_renderMethod = QV4L2_RENDER_GL;
+
+		m_useGLAct = new QAction("Use Open&GL Render", this);
+		m_useGLAct->setStatusTip("Use GPU with OpenGL for video capture if set.");
+		m_useGLAct->setCheckable(true);
+		m_useGLAct->setChecked(true);
+		connect(m_useGLAct, SIGNAL(triggered()), this, SLOT(setRenderMethod()));
+		previewMenu->addAction(m_useGLAct);
+	} else {
+		m_renderMethod = QV4L2_RENDER_QT;
+	}
+
 	QMenu *helpMenu = menuBar()->addMenu("&Help");
 	helpMenu->addAction("&About", this, SLOT(about()), Qt::Key_F1);
 
@@ -162,9 +176,9 @@ void ApplicationWindow::setDevice(const QString &device, bool rawOpen)
 	if (!open(device, !rawOpen))
 		return;
 
-	m_capture = new CaptureWinQt;
+	newCaptureWin();
+
 	m_capture->setMinimumSize(150, 50);
-	connect(m_capture, SIGNAL(close()), this, SLOT(closeCaptureWin()));
 
 	QWidget *w = new QWidget(m_tabs);
 	m_genTab = new GeneralTab(device, *this, 4, w);
@@ -207,6 +221,21 @@ void ApplicationWindow::openrawdev()
 		setDevice(d.selectedFiles().first(), true);
 }
 
+void ApplicationWindow::setRenderMethod()
+{
+	if (m_capStartAct->isChecked()) {
+		m_useGLAct->setChecked(m_renderMethod == QV4L2_RENDER_GL);
+		return;
+	}
+
+	if (m_useGLAct->isChecked())
+		m_renderMethod = QV4L2_RENDER_GL;
+	else
+		m_renderMethod = QV4L2_RENDER_QT;
+
+	newCaptureWin();
+}
+
 void ApplicationWindow::ctrlEvent()
 {
 	v4l2_event ev;
@@ -254,6 +283,25 @@ void ApplicationWindow::ctrlEvent()
 	}
 }
 
+void ApplicationWindow::newCaptureWin()
+{
+	if (m_capture != NULL) {
+		m_capture->stop();
+		delete m_capture;
+	}
+
+	switch (m_renderMethod) {
+	case QV4L2_RENDER_GL:
+		m_capture = new CaptureWinGL;
+		break;
+	default:
+		m_capture = new CaptureWinQt;
+		break;
+	}
+
+	connect(m_capture, SIGNAL(close()), this, SLOT(closeCaptureWin()));
+}
+
 void ApplicationWindow::capVbiFrame()
 {
 	__u32 buftype = m_genTab->bufType();
diff --git a/utils/qv4l2/qv4l2.h b/utils/qv4l2/qv4l2.h
index ccfc2f9..2921b16 100644
--- a/utils/qv4l2/qv4l2.h
+++ b/utils/qv4l2/qv4l2.h
@@ -60,6 +60,11 @@ enum CapMethod {
 	methodUser
 };
 
+enum RenderMethod {
+	QV4L2_RENDER_GL,
+	QV4L2_RENDER_QT
+};
+
 struct buffer {
 	void   *start;
 	size_t  length;
@@ -92,6 +97,8 @@ private:
 	void stopCapture();
 	void startOutput(unsigned buffer_size);
 	void stopOutput();
+	void newCaptureWin();
+
 	struct buffer *m_buffers;
 	struct v4l2_format m_capSrcFormat;
 	struct v4l2_format m_capDestFormat;
@@ -101,6 +108,7 @@ private:
 	bool m_mustConvert;
 	CapMethod m_capMethod;
 	bool m_makeSnapshot;
+	RenderMethod m_renderMethod;
 
 private slots:
 	void capStart(bool);
@@ -109,6 +117,7 @@ private slots:
 	void snapshot();
 	void capVbiFrame();
 	void saveRaw(bool);
+	void setRenderMethod();
 
 	// gui
 private slots:
@@ -166,6 +175,7 @@ private:
 	QAction *m_snapshotAct;
 	QAction *m_saveRawAct;
 	QAction *m_showFramesAct;
+	QAction *m_useGLAct;
 	QString m_filename;
 	QSignalMapper *m_sigMapper;
 	QTabWidget *m_tabs;
-- 
1.8.3.2

