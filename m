Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-4.cisco.com ([144.254.224.147]:30482 "EHLO
	ams-iport-4.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754684Ab3GPLeK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 16 Jul 2013 07:34:10 -0400
From: =?UTF-8?q?B=C3=A5rd=20Eirik=20Winther?= <bwinther@cisco.com>
To: linux-media@vger.kernel.org
Cc: hansverk@cisco.com
Subject: [PATCH 4/4] qv4l2: add OpenGL video render
Date: Tue, 16 Jul 2013 13:24:08 +0200
Message-Id: <5eb7b2d7de462e820ceb0698f6aa431c3eca414c.1373973770.git.bwinther@cisco.com>
In-Reply-To: <1373973848-4084-1-git-send-email-bwinther@cisco.com>
References: <1373973848-4084-1-git-send-email-bwinther@cisco.com>
In-Reply-To: <61608db2b5b388a50c91730739479dccf76c046d.1373973770.git.bwinther@cisco.com>
References: <61608db2b5b388a50c91730739479dccf76c046d.1373973770.git.bwinther@cisco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The qv4l2 test utility now supports OpenGL-accelerated display of video.
This allows for using the graphics card to render the video content to screen
and to performing color space conversion.

Signed-off-by: Bård Eirik Winther <bwinther@cisco.com>
---
 configure.ac                |   8 +-
 utils/qv4l2/Makefile.am     |   9 +-
 utils/qv4l2/capture-win.cpp | 559 ++++++++++++++++++++++++++++++++++++++++++--
 utils/qv4l2/capture-win.h   |  81 ++++++-
 utils/qv4l2/qv4l2.cpp       | 173 +++++++++++---
 utils/qv4l2/qv4l2.h         |   8 +
 6 files changed, 782 insertions(+), 56 deletions(-)

diff --git a/configure.ac b/configure.ac
index e249546..97a0dfc 100644
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
+PKG_CHECK_MODULES(QTOGL, [QtOpenGL >= 4.4 gl], [qt_pkgconfig_ogl=true], [qt_pkgconfig_ogl=false])
+if test "x$qt_pkgconfig_ogl" = "xfalse"; then
+   AC_MSG_WARN(Qt4 OpenGL or higher is not available)
 fi
 
 AC_SUBST([JPEG_LIBS])
@@ -237,6 +242,7 @@ AM_CONDITIONAL([WITH_LIBDVBV5], [test x$enable_libdvbv5 = xyes])
 AM_CONDITIONAL([WITH_LIBV4L], [test x$enable_libv4l != xno])
 AM_CONDITIONAL([WITH_V4LUTILS], [test x$enable_v4lutils != xno])
 AM_CONDITIONAL([WITH_QV4L2], [test ${qt_pkgconfig} = true -a x$enable_qv4l2 != xno])
+AM_CONDITIONAL([WITH_QV4L2_OGL_COMPILE], [test WITH_QV4L2 -a ${qt_pkgconfig_ogl} = true])
 AM_CONDITIONAL([WITH_V4L_PLUGINS], [test x$enable_libv4l != xno -a x$enable_shared != xno])
 AM_CONDITIONAL([WITH_V4L_WRAPPERS], [test x$enable_libv4l != xno -a x$enable_shared != xno])
 
diff --git a/utils/qv4l2/Makefile.am b/utils/qv4l2/Makefile.am
index 1f5a49f..86bf786 100644
--- a/utils/qv4l2/Makefile.am
+++ b/utils/qv4l2/Makefile.am
@@ -4,8 +4,14 @@ qv4l2_SOURCES = qv4l2.cpp general-tab.cpp ctrl-tab.cpp vbi-tab.cpp v4l2-api.cpp
   raw2sliced.cpp qv4l2.h capture-win.h general-tab.h vbi-tab.h v4l2-api.h raw2sliced.h
 nodist_qv4l2_SOURCES = moc_qv4l2.cpp moc_general-tab.cpp moc_capture-win.cpp moc_vbi-tab.cpp qrc_qv4l2.cpp
 qv4l2_LDADD = ../../lib/libv4l2/libv4l2.la ../../lib/libv4lconvert/libv4lconvert.la ../libv4l2util/libv4l2util.la
+
+if WITH_QV4L2_OGL_COMPILE
+qv4l2_CPPFLAGS = $(QTOGL_CFLAGS) -DENABLE_OGL
+qv4l2_LDFLAGS = $(QTOGL_LIBS)
+else
 qv4l2_CPPFLAGS = $(QT_CFLAGS)
 qv4l2_LDFLAGS = $(QT_LIBS)
+endif
 
 EXTRA_DIST = exit.png fileopen.png qv4l2_24x24.png qv4l2_64x64.png qv4l2.png qv4l2.svg snapshot.png \
   video-television.png fileclose.png qv4l2_16x16.png qv4l2_32x32.png qv4l2.desktop qv4l2.qrc record.png \
@@ -37,5 +43,4 @@ install-data-local:
 	$(INSTALL_DATA) -D -p "$(srcdir)/qv4l2_24x24.png" "$(DESTDIR)$(datadir)/icons/hicolor/24x24/apps/qv4l2.png"
 	$(INSTALL_DATA) -D -p "$(srcdir)/qv4l2_32x32.png" "$(DESTDIR)$(datadir)/icons/hicolor/32x32/apps/qv4l2.png"
 	$(INSTALL_DATA) -D -p "$(srcdir)/qv4l2_64x64.png" "$(DESTDIR)$(datadir)/icons/hicolor/64x64/apps/qv4l2.png"
-	$(INSTALL_DATA) -D -p "$(srcdir)/qv4l2.svg"       "$(DESTDIR)$(datadir)/icons/hicolor/scalable/apps/qv4l2.svg"
-
+	$(INSTALL_DATA) -D -p "$(srcdir)/qv4l2.svg"       "$(DESTDIR)$(datadir)/icons/hicolor/scalable/apps/qv4l2.svg"
\ No newline at end of file
diff --git a/utils/qv4l2/capture-win.cpp b/utils/qv4l2/capture-win.cpp
index 7ac3fa1..132d23d 100644
--- a/utils/qv4l2/capture-win.cpp
+++ b/utils/qv4l2/capture-win.cpp
@@ -16,6 +16,7 @@
  * along with this program; if not, write to the Free Software
  * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
  */
+
 #include <stdio.h>
 #include <QLabel>
 #include <QImage>
@@ -24,23 +25,12 @@
 #include <QApplication>
 #include <QDesktopWidget>
 
-#include "qv4l2.h"
 #include "capture-win.h"
 
-CaptureWin::CaptureWin()
+CaptureWin::CaptureWin(bool useOGL)
 {
-	QVBoxLayout *vbox = new QVBoxLayout(this);
-
-	setWindowTitle("V4L2 Capture");
-	m_label = new QLabel();
-	m_msg = new QLabel("No frame");
-
-	vbox->addWidget(m_label);
-	vbox->addWidget(m_msg);
-
-	int l, t, r, b;
-	vbox->getContentsMargins(&l, &t, &r, &b);
-	vbox->setSpacing(b);
+	m_enableOGL = useOGL;
+	buildCanvas();
 
 	hotkeyClose = new QShortcut(Qt::CTRL+Qt::Key_W, this);
 	QObject::connect(hotkeyClose, SIGNAL(activated()), this, SLOT(close()));
@@ -49,6 +39,48 @@ CaptureWin::CaptureWin()
 CaptureWin::~CaptureWin()
 {
 	delete hotkeyClose;
+	clearCanvas();
+}
+
+void CaptureWin::clearCanvas()
+{
+	if (layout() != NULL) {
+		if (m_enableOGL) {
+#ifdef ENABLE_OGL
+			delete m_canvas;
+#endif
+		} else {
+			delete m_videoSurface;
+		}
+
+		delete m_information;
+		layout()->removeWidget(this);
+		delete layout();
+
+	}
+}
+
+void CaptureWin::buildCanvas()
+{
+	QVBoxLayout *vbox = new QVBoxLayout(this);
+
+	if (m_enableOGL) {
+		setWindowTitle("V4L2 Preview (OpenGL)");
+#if ENABLE_OGL
+		m_canvas = new CaptureCanvas();
+		vbox->addWidget(m_canvas, 2000);
+#endif
+	} else {
+		setWindowTitle("V4L2 Preview");
+		m_videoSurface = new QLabel();
+		vbox->addWidget(m_videoSurface, 2000);
+	}
+
+	int l, t, r, b;
+	m_information = new QLabel("No Frame");
+	vbox->addWidget(m_information, 1, Qt::AlignBottom);
+	vbox->getContentsMargins(&l, &t, &r, &b);
+	vbox->setSpacing(b);
 }
 
 void CaptureWin::setMinimumSize(int minw, int minh)
@@ -59,7 +91,7 @@ void CaptureWin::setMinimumSize(int minw, int minh)
 	int l, t, r, b;
 	layout()->getContentsMargins(&l, &t, &r, &b);
 	minw += l + r;
-	minh += t + b + m_msg->minimumSizeHint().height() + layout()->spacing();
+	minh += t + b + m_information->minimumSizeHint().height() + layout()->spacing();
 
 	if (minw > resolution.width())
 		minw = resolution.width();
@@ -71,10 +103,43 @@ void CaptureWin::setMinimumSize(int minw, int minh)
 	resize(minw, minh);
 }
 
-void CaptureWin::setImage(const QImage &image, const QString &status)
+void CaptureWin::setFrameCPU(const QImage &image, const QString &status)
+{
+	m_videoSurface->setPixmap(QPixmap::fromImage(image));
+	m_information->setText(status);
+}
+
+void CaptureWin::setFrameOGL(int width, int height, __u32 format,
+			     unsigned char *data, const QString &status)
+{
+#if ENABLE_OGL
+	m_canvas->setFrame(width, height, format, data);
+#endif
+	m_information->setText(status);
+}
+
+void CaptureWin::stop()
+{
+#if ENABLE_OGL
+	if (m_enableOGL)
+		m_canvas->stop();
+#endif
+}
+
+void CaptureWin::setEnableOGL(bool enable)
+{
+#ifdef ENABLE_OGL
+	if (m_enableOGL != enable) {
+		clearCanvas();
+		m_enableOGL = enable;
+		buildCanvas();
+	}
+#endif
+}
+
+bool CaptureWin::isEnableOGL()
 {
-	m_label->setPixmap(QPixmap::fromImage(image));
-	m_msg->setText(status);
+	return m_enableOGL;
 }
 
 void CaptureWin::closeEvent(QCloseEvent *event)
@@ -82,3 +147,461 @@ void CaptureWin::closeEvent(QCloseEvent *event)
 	QWidget::closeEvent(event);
 	emit close();
 }
+
+#if ENABLE_OGL
+CaptureCanvas::CaptureCanvas() :
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
+CaptureCanvas::~CaptureCanvas()
+{
+	clearShader();
+}
+
+void CaptureCanvas::clearShader()
+{
+	glDeleteTextures(m_screenTextureCount, m_screenTexture);
+	m_shaderProgram.release();
+	m_shaderProgram.removeAllShaders();
+}
+
+void CaptureCanvas::stop()
+{
+	// Setting the m_frameData to NULL stops OpenGL
+	// from updating frames on repaint
+	m_frameData = NULL;
+}
+
+void CaptureCanvas::initializeGL()
+{
+	glShadeModel(GL_FLAT);
+	glEnable(GL_TEXTURE_2D);
+
+	glClearColor(0.0f, 0.0f, 0.0f, 0.0f);
+	checkError("InitializeGL");
+}
+
+
+void CaptureCanvas::resizeGL(int width, int height)
+{
+	// Resizing is disabled by setting viewport equal to frame size
+	glViewport(0, 0, m_frameWidth, m_frameHeight);
+}
+
+void CaptureCanvas::setFrame(int width, int height, __u32 format, unsigned char *data)
+{
+	if (format != m_frameFormat || width != m_frameWidth || height != m_frameHeight) {
+		m_formatChange = true;
+		m_frameWidth = width;
+		m_frameHeight = height;
+		m_frameFormat = format;
+
+		setMaximumSize(m_frameWidth, m_frameHeight);
+		showFullScreen();
+	}
+
+	m_frameData = data;
+	updateGL();
+}
+
+void CaptureCanvas::checkError(const char *msg)
+{
+	int err = glGetError();
+	if (err) fprintf(stderr, "OpenGL Error 0x%x: %s.\n", err, msg);
+}
+
+void CaptureCanvas::changeShader()
+{
+	m_formatChange = false;
+	clearShader();
+
+	glMatrixMode(GL_PROJECTION);
+	glLoadIdentity();
+	glOrtho(0, m_frameWidth, m_frameHeight, 0, 0, 1);
+	resizeGL(width(), height());
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
+void CaptureCanvas::paintGL()
+{
+	if (m_frameWidth < 1 || m_frameHeight < 1) {
+		glClear(GL_COLOR_BUFFER_BIT);
+		return;
+	}
+
+	if (m_formatChange)
+		changeShader();
+
+	glClear(GL_COLOR_BUFFER_BIT);
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
+void CaptureCanvas::configureTexture(size_t idx)
+{
+	glBindTexture(GL_TEXTURE_2D, m_screenTexture[idx]);
+	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST);
+	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_NEAREST);
+	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP);
+	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP);
+}
+
+void CaptureCanvas::shader_YUV()
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
+void CaptureCanvas::render_YUV(__u32 format)
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
+void CaptureCanvas::shader_BGR()
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
+void CaptureCanvas::render_BGR()
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
+QString CaptureCanvas::shader_YUY2_invariant(__u32 format)
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
+void CaptureCanvas::shader_YUY2(__u32 format)
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
+void CaptureCanvas::render_YUY2()
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
diff --git a/utils/qv4l2/capture-win.h b/utils/qv4l2/capture-win.h
index 3de3447..4d6f04c 100644
--- a/utils/qv4l2/capture-win.h
+++ b/utils/qv4l2/capture-win.h
@@ -24,19 +24,83 @@
 #include <QShortcut>
 #include <sys/time.h>
 
+#ifdef ENABLE_OGL
+#define GL_GLEXT_PROTOTYPES
+#include <QGLWidget>
+#include <QGLShader>
+#include <QGLShaderProgram>
+#include <QGLFunctions>
+#endif
+
+#include "qv4l2.h"
+
 class QImage;
 class QLabel;
 
+#ifdef ENABLE_OGL
+class CaptureCanvas : public QGLWidget
+{
+public:
+	CaptureCanvas();
+	~CaptureCanvas();
+
+	void setFrame(int width, int height, __u32 format, unsigned char *bufptr);
+	void stop();
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
+	GLuint m_screenTexture[3]; // This must be equal to the max number of textures that any shader uses
+	QGLFunctions m_glfunction;
+	unsigned char *m_frameData;
+	QGLShaderProgram m_shaderProgram;
+
+};
+#endif /* OGL_COMPILE */
+
+
+
+
 class CaptureWin : public QWidget
 {
 	Q_OBJECT
 
 public:
-	CaptureWin();
+	CaptureWin(bool useOGL);
 	~CaptureWin();
 
 	virtual void setMinimumSize(int minw, int minh);
-	void setImage(const QImage &image, const QString &status);
+	void setFrameCPU(const QImage &image, const QString &status);
+	void setFrameOGL(int width, int height, __u32 format,
+			 unsigned char *data, const QString &status);
+	void setEnableOGL(bool enable);
+	bool isEnableOGL();
+	void stop();
 
 protected:
 	virtual void closeEvent(QCloseEvent *event);
@@ -45,9 +109,16 @@ signals:
 	void close();
 
 private:
-	QLabel *m_label;
-	QLabel *m_msg;
+	void buildCanvas();
+	void clearCanvas();
+
+	bool m_enableOGL;
+	QLabel *m_videoSurface;
+	QLabel *m_information;
 	QShortcut *hotkeyClose;
+#if ENABLE_OGL
+	CaptureCanvas *m_canvas;
+#endif
 };
 
-#endif
+#endif /* CAPTURE_WIN_H */
diff --git a/utils/qv4l2/qv4l2.cpp b/utils/qv4l2/qv4l2.cpp
index bb1d84f..22f93f1 100644
--- a/utils/qv4l2/qv4l2.cpp
+++ b/utils/qv4l2/qv4l2.cpp
@@ -107,6 +107,15 @@ ApplicationWindow::ApplicationWindow() :
 	quitAct->setShortcut(Qt::CTRL+Qt::Key_Q);
 	connect(quitAct, SIGNAL(triggered()), this, SLOT(close()));
 
+#ifdef ENABLE_OGL
+	m_previewAct = new QAction("Use Open&GL", this);
+	m_previewAct->setStatusTip("Use the GPU for video capture preview if set.");
+	m_previewAct->setCheckable(true);
+	m_previewAct->setChecked(true);
+	m_previewAct->setEnabled(true);
+	connect(m_previewAct, SIGNAL(triggered()), this, SLOT(setPreviewMode()));
+#endif
+
 	QMenu *fileMenu = menuBar()->addMenu("&File");
 	fileMenu->addAction(openAct);
 	fileMenu->addAction(openRawAct);
@@ -114,7 +123,6 @@ ApplicationWindow::ApplicationWindow() :
 	fileMenu->addAction(m_capStartAct);
 	fileMenu->addAction(m_snapshotAct);
 	fileMenu->addAction(m_saveRawAct);
-	fileMenu->addAction(m_showFramesAct);
 	fileMenu->addSeparator();
 	fileMenu->addAction(quitAct);
 
@@ -128,6 +136,13 @@ ApplicationWindow::ApplicationWindow() :
 	toolBar->addSeparator();
 	toolBar->addAction(quitAct);
 
+	QMenu *previewMenu = menuBar()->addMenu("&Preview");
+	previewMenu->addAction(m_showFramesAct);
+#ifdef ENABLE_OGL
+	previewMenu->addSeparator();
+	previewMenu->addAction(m_previewAct);
+#endif
+
 	QMenu *helpMenu = menuBar()->addMenu("&Help");
 	helpMenu->addAction("&About", this, SLOT(about()), Qt::Key_F1);
 
@@ -151,6 +166,15 @@ ApplicationWindow::~ApplicationWindow()
 
 void ApplicationWindow::setDevice(const QString &device, bool rawOpen)
 {
+	bool useOGL;
+#ifdef ENABLE_OGL
+	useOGL = true;
+#else
+	useOGL = false;
+#endif
+	if (m_capture != NULL)
+		useOGL = m_capture->isEnableOGL();
+
 	closeDevice();
 	m_sigMapper = new QSignalMapper(this);
 	connect(m_sigMapper, SIGNAL(mapped(int)), this, SLOT(ctrlAction(int)));
@@ -158,9 +182,12 @@ void ApplicationWindow::setDevice(const QString &device, bool rawOpen)
 	if (!open(device, !rawOpen))
 		return;
 
-	m_capture = new CaptureWin;
+	m_capture = new CaptureWin(useOGL);
 	m_capture->setMinimumSize(150, 50);
 	connect(m_capture, SIGNAL(close()), this, SLOT(closeCaptureWin()));
+#ifdef ENABLE_OGL
+	m_previewAct->setChecked(useOGL);
+#endif
 
 	QWidget *w = new QWidget(m_tabs);
 	m_genTab = new GeneralTab(device, *this, 4, w);
@@ -203,6 +230,18 @@ void ApplicationWindow::openrawdev()
 		setDevice(d.selectedFiles().first(), true);
 }
 
+void ApplicationWindow::setPreviewMode()
+{
+	if (m_capStartAct->isChecked()) {
+#ifdef ENABLE_OGL
+		m_previewAct->setChecked(m_capture->isEnableOGL());
+#endif
+		return;
+	}
+
+	m_capture->setEnableOGL(m_previewAct->isChecked());
+}
+
 void ApplicationWindow::ctrlEvent()
 {
 	v4l2_event ev;
@@ -344,8 +383,15 @@ void ApplicationWindow::capVbiFrame()
 		m_tv = tv;
 	}
 	status = QString("Frame: %1 Fps: %2").arg(++m_frame).arg(m_fps);
-	if (m_showFrames)
-		m_capture->setImage(*m_capImage, status);
+	if (m_showFrames) {
+		if (m_capture->isEnableOGL())
+			m_capture->setFrameOGL(m_capImage->width(), m_capImage->height(),
+					       m_capSrcFormat.fmt.pix.pixelformat, m_capImage->bits(), "No frame");
+		else
+			m_capture->setFrameCPU(*m_capImage, "No frame");
+
+		m_capture->setFrameCPU(*m_capImage, status);
+	}
 	curStatus = statusBar()->currentMessage();
 	if (curStatus.isEmpty() || curStatus.startsWith("Frame: "))
 		statusBar()->showMessage(status);
@@ -361,6 +407,9 @@ void ApplicationWindow::capFrame()
 	int err = 0;
 	bool again;
 
+	unsigned char *displaybuf = NULL;
+	bool ogl_use = m_capture->isEnableOGL();
+
 	switch (m_capMethod) {
 	case methodRead:
 		s = read(m_frameData, m_capSrcFormat.fmt.pix.sizeimage);
@@ -380,9 +429,13 @@ void ApplicationWindow::capFrame()
 			break;
 		if (m_mustConvert)
 			err = v4lconvert_convert(m_convertData, &m_capSrcFormat, &m_capDestFormat,
-				m_frameData, s,
-				m_capImage->bits(), m_capDestFormat.fmt.pix.sizeimage);
-		if (!m_mustConvert || err < 0)
+						 m_frameData, s,
+						 m_capImage->bits(), m_capDestFormat.fmt.pix.sizeimage);
+		if (ogl_use && m_mustConvert && err != -1)
+			displaybuf = m_capImage->bits();
+		if (ogl_use && !m_mustConvert)
+			displaybuf = m_frameData;
+		if (!ogl_use && !m_mustConvert)
 			memcpy(m_capImage->bits(), m_frameData, std::min(s, m_capImage->numBytes()));
 		break;
 
@@ -397,11 +450,14 @@ void ApplicationWindow::capFrame()
 
 		if (m_showFrames) {
 			if (m_mustConvert)
-				err = v4lconvert_convert(m_convertData,
-					&m_capSrcFormat, &m_capDestFormat,
-					(unsigned char *)m_buffers[buf.index].start, buf.bytesused,
-					m_capImage->bits(), m_capDestFormat.fmt.pix.sizeimage);
-			if (!m_mustConvert || err < 0)
+				err = v4lconvert_convert(m_convertData, &m_capSrcFormat, &m_capDestFormat,
+							 (unsigned char *)m_buffers[buf.index].start, buf.bytesused,
+							 m_capImage->bits(), m_capDestFormat.fmt.pix.sizeimage);
+			if (ogl_use && m_mustConvert && err != -1)
+				displaybuf = m_capImage->bits();
+			if (ogl_use && !m_mustConvert)
+				displaybuf = (unsigned char *)m_buffers[buf.index].start;
+			if (!ogl_use && !m_mustConvert)
 				memcpy(m_capImage->bits(),
 				       (unsigned char *)m_buffers[buf.index].start,
 				       std::min(buf.bytesused, (unsigned)m_capImage->numBytes()));
@@ -425,11 +481,14 @@ void ApplicationWindow::capFrame()
 
 		if (m_showFrames) {
 			if (m_mustConvert)
-				err = v4lconvert_convert(m_convertData,
-					&m_capSrcFormat, &m_capDestFormat,
-					(unsigned char *)buf.m.userptr, buf.bytesused,
-					m_capImage->bits(), m_capDestFormat.fmt.pix.sizeimage);
-			if (!m_mustConvert || err < 0)
+				err = v4lconvert_convert(m_convertData, &m_capSrcFormat, &m_capDestFormat,
+							 (unsigned char *)buf.m.userptr, buf.bytesused,
+							 m_capImage->bits(), m_capDestFormat.fmt.pix.sizeimage);
+			if (ogl_use && m_mustConvert && err != -1)
+				displaybuf = m_capImage->bits();
+			if (ogl_use && !m_mustConvert)
+				displaybuf = (unsigned char *)buf.m.userptr;
+			if (!ogl_use && !m_mustConvert)
 				memcpy(m_capImage->bits(), (unsigned char *)buf.m.userptr,
 				       std::min(buf.bytesused, (unsigned)m_capImage->numBytes()));
 		}
@@ -458,8 +517,13 @@ void ApplicationWindow::capFrame()
 		m_tv = tv;
 	}
 	status = QString("Frame: %1 Fps: %2").arg(++m_frame).arg(m_fps);
-	if (m_showFrames)
-		m_capture->setImage(*m_capImage, status);
+	if (m_showFrames) {
+		if (ogl_use)
+			m_capture->setFrameOGL(m_capImage->width(), m_capImage->height(),
+					       m_capSrcFormat.fmt.pix.pixelformat, displaybuf, status);
+		else
+			m_capture->setFrameCPU(*m_capImage, status);
+	}
 	curStatus = statusBar()->currentMessage();
 	if (curStatus.isEmpty() || curStatus.startsWith("Frame: "))
 		statusBar()->showMessage(status);
@@ -589,6 +653,7 @@ void ApplicationWindow::stopCapture()
 	v4l2_encoder_cmd cmd;
 	unsigned i;
 
+	m_capture->stop();
 	m_snapshotAct->setDisabled(true);
 	switch (m_capMethod) {
 	case methodRead:
@@ -638,7 +703,7 @@ void ApplicationWindow::closeCaptureWin()
 	m_capStartAct->setChecked(false);
 }
 
-void ApplicationWindow::capStart(bool start)
+bool ApplicationWindow::isSupportedFormatCPU(v4l2_pix_format &format, QImage::Format &dstFmt)
 {
 	static const struct {
 		__u32 v4l2_pixfmt;
@@ -658,8 +723,46 @@ void ApplicationWindow::capStart(bool start)
 #endif
 		{ 0, QImage::Format_Invalid }
 	};
+
+	for (int i = 0; supported_fmts[i].v4l2_pixfmt; i++) {
+		if (supported_fmts[i].v4l2_pixfmt == format.pixelformat) {
+			dstFmt = supported_fmts[i].qt_pixfmt;
+			return true;
+		}
+	}
+	return false;
+}
+
+bool ApplicationWindow::isSupportedFormatOGL(v4l2_pix_format &format)
+{
+	__u32 supported_fmts[] = {
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
+		if (supported_fmts[i] == format.pixelformat)
+			return true;
+
+	return false;
+}
+
+void ApplicationWindow::capStart(bool start)
+{
 	QImage::Format dstFmt = QImage::Format_RGB888;
 	struct v4l2_fract interval;
+	bool ogl_use = m_capture->isEnableOGL();
 	v4l2_pix_format &srcPix = m_capSrcFormat.fmt.pix;
 	v4l2_pix_format &dstPix = m_capDestFormat.fmt.pix;
 
@@ -722,7 +825,11 @@ void ApplicationWindow::capStart(bool start)
 			m_capture->setMinimumSize(m_vbiWidth, m_vbiHeight);
 			m_capImage = new QImage(m_vbiWidth, m_vbiHeight, dstFmt);
 			m_capImage->fill(0);
-			m_capture->setImage(*m_capImage, "No frame");
+			if (ogl_use)
+				m_capture->setFrameOGL(m_capImage->width(), m_capImage->height(),
+						       m_capSrcFormat.fmt.pix.pixelformat, m_capImage->bits(), "No frame");
+			else
+				m_capture->setFrameCPU(*m_capImage, "No frame");
 			m_capture->show();
 		}
 		statusBar()->showMessage("No frame");
@@ -744,14 +851,16 @@ void ApplicationWindow::capStart(bool start)
 		m_capDestFormat = m_capSrcFormat;
 		dstPix.pixelformat = V4L2_PIX_FMT_RGB24;
 
-		for (int i = 0; supported_fmts[i].v4l2_pixfmt; i++) {
-			if (supported_fmts[i].v4l2_pixfmt == srcPix.pixelformat) {
-				dstPix.pixelformat = supported_fmts[i].v4l2_pixfmt;
-				dstFmt = supported_fmts[i].qt_pixfmt;
-				m_mustConvert = false;
-				break;
-			}
+		if (!ogl_use && isSupportedFormatCPU(srcPix, dstFmt)) {
+			dstPix.pixelformat = srcPix.pixelformat;
+			m_mustConvert = false;
+		}
+
+		if (ogl_use && isSupportedFormatOGL(srcPix)) {
+			dstPix.pixelformat = srcPix.pixelformat;
+			m_mustConvert = false;
 		}
+
 		if (m_mustConvert) {
 			v4l2_format copy = m_capSrcFormat;
 
@@ -765,7 +874,11 @@ void ApplicationWindow::capStart(bool start)
 		m_capture->setMinimumSize(dstPix.width, dstPix.height);
 		m_capImage = new QImage(dstPix.width, dstPix.height, dstFmt);
 		m_capImage->fill(0);
-		m_capture->setImage(*m_capImage, "No frame");
+		if (ogl_use)
+			m_capture->setFrameOGL(m_capImage->width(), m_capImage->height(),
+					       m_capSrcFormat.fmt.pix.pixelformat, m_capImage->bits(), "No frame");
+		else
+			m_capture->setFrameCPU(*m_capImage, "No frame");
 		m_capture->show();
 	}
 
@@ -890,7 +1003,7 @@ void ApplicationWindow::saveRaw(bool checked)
 void ApplicationWindow::about()
 {
 	QMessageBox::about(this, "V4L2 Test Bench",
-			"This program allows easy experimenting with video4linux devices.");
+			   "This program allows easy experimenting with video4linux devices.");
 }
 
 void ApplicationWindow::error(const QString &error)
diff --git a/utils/qv4l2/qv4l2.h b/utils/qv4l2/qv4l2.h
index 8634948..27cb72d 100644
--- a/utils/qv4l2/qv4l2.h
+++ b/utils/qv4l2/qv4l2.h
@@ -91,6 +91,9 @@ private:
 	void stopCapture();
 	void startOutput(unsigned buffer_size);
 	void stopOutput();
+	bool isSupportedFormatCPU(v4l2_pix_format &format, QImage::Format &dstFmt);
+	bool isSupportedFormatOGL(v4l2_pix_format &format);
+
 	struct buffer *m_buffers;
 	struct v4l2_format m_capSrcFormat;
 	struct v4l2_format m_capDestFormat;
@@ -108,6 +111,7 @@ private slots:
 	void snapshot();
 	void capVbiFrame();
 	void saveRaw(bool);
+	void setPreviewMode();
 
 	// gui
 private slots:
@@ -186,6 +190,10 @@ private:
 	unsigned m_fps;
 	struct timeval m_tv;
 	QFile m_saveRaw;
+#ifdef ENABLE_OGL
+	QAction *m_previewAct;
+#endif
+
 };
 
 extern ApplicationWindow *g_mw;
-- 
1.8.3.2

