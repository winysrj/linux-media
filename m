Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-2.cisco.com ([144.254.224.141]:45318 "EHLO
	ams-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755674Ab3HFKWc (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 6 Aug 2013 06:22:32 -0400
Received: from bwinther.cisco.com (dhcp-10-54-92-83.cisco.com [10.54.92.83])
	by ams-core-4.cisco.com (8.14.5/8.14.5) with ESMTP id r76AMGhL015841
	for <linux-media@vger.kernel.org>; Tue, 6 Aug 2013 10:22:28 GMT
From: =?UTF-8?q?B=C3=A5rd=20Eirik=20Winther?= <bwinther@cisco.com>
To: linux-media@vger.kernel.org
Subject: [PATCH 6/9] qv4l2: add video scaling for CaptureWin
Date: Tue,  6 Aug 2013 12:21:50 +0200
Message-Id: <b31d52f6b5e59a8c747489e594c988f88f968869.1375784415.git.bwinther@cisco.com>
In-Reply-To: <1375784513-18701-1-git-send-email-bwinther@cisco.com>
References: <1375784513-18701-1-git-send-email-bwinther@cisco.com>
In-Reply-To: <f8457ccfdceb6e73b7990efe95f9e3b61d973747.1375784415.git.bwinther@cisco.com>
References: <f8457ccfdceb6e73b7990efe95f9e3b61d973747.1375784415.git.bwinther@cisco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Bård Eirik Winther <bwinther@cisco.com>
---
 utils/qv4l2/capture-win-gl.cpp | 26 ++++++++++--
 utils/qv4l2/capture-win-gl.h   |  7 ++++
 utils/qv4l2/capture-win-qt.cpp | 23 ++++++++++-
 utils/qv4l2/capture-win-qt.h   |  5 +++
 utils/qv4l2/capture-win.cpp    | 93 ++++++++++++++++++++++++++++++++----------
 utils/qv4l2/capture-win.h      | 14 ++++++-
 utils/qv4l2/qv4l2.cpp          | 22 ++++++++--
 utils/qv4l2/qv4l2.h            |  2 +
 8 files changed, 159 insertions(+), 33 deletions(-)

diff --git a/utils/qv4l2/capture-win-gl.cpp b/utils/qv4l2/capture-win-gl.cpp
index c8238c5..27ff3d3 100644
--- a/utils/qv4l2/capture-win-gl.cpp
+++ b/utils/qv4l2/capture-win-gl.cpp
@@ -43,6 +43,15 @@ void CaptureWinGL::stop()
 #endif
 }
 
+void CaptureWinGL::resizeEvent(QResizeEvent *event)
+{
+#ifdef HAVE_QTGL
+	QSize margins = getMargins();
+	m_videoSurface.setSize(width() - margins.width(), height() - margins.height());
+#endif
+	event->accept();
+}
+
 void CaptureWinGL::setFrame(int width, int height, __u32 format, unsigned char *data, const QString &info)
 {
 #ifdef HAVE_QTGL
@@ -109,11 +118,22 @@ void CaptureWinGLEngine::initializeGL()
 	checkError("InitializeGL");
 }
 
+void CaptureWinGLEngine::setSize(int width, int height)
+{
+	QSize sizedFrame = CaptureWin::scaleFrameSize(QSize(width, height), QSize(m_frameWidth, m_frameHeight));
+
+	width = sizedFrame.width();
+	height = sizedFrame.height();
+
+	if (width > 0 && height > 0) {
+		setMaximumSize(width, height);
+		resizeGL(width, height);
+	}
+}
 
 void CaptureWinGLEngine::resizeGL(int width, int height)
 {
-	// Resizing is disabled by setting viewport equal to frame size
-	glViewport(0, 0, m_frameWidth, m_frameHeight);
+	glViewport(0, 0, width, height);
 }
 
 void CaptureWinGLEngine::setFrame(int width, int height, __u32 format, unsigned char *data)
@@ -123,8 +143,6 @@ void CaptureWinGLEngine::setFrame(int width, int height, __u32 format, unsigned
 		m_frameWidth = width;
 		m_frameHeight = height;
 		m_frameFormat = format;
-
-		QGLWidget::setMaximumSize(m_frameWidth, m_frameHeight);
 	}
 
 	m_frameData = data;
diff --git a/utils/qv4l2/capture-win-gl.h b/utils/qv4l2/capture-win-gl.h
index 6e64269..0c3ff8b 100644
--- a/utils/qv4l2/capture-win-gl.h
+++ b/utils/qv4l2/capture-win-gl.h
@@ -23,6 +23,8 @@
 #include "qv4l2.h"
 #include "capture-win.h"
 
+#include <QResizeEvent>
+
 #ifdef HAVE_QTGL
 #define GL_GLEXT_PROTOTYPES
 #include <QGLWidget>
@@ -42,6 +44,7 @@ public:
 	void stop();
 	void setFrame(int width, int height, __u32 format, unsigned char *data);
 	bool hasNativeFormat(__u32 format);
+	void setSize(int width, int height);
 
 protected:
 	void paintGL();
@@ -90,6 +93,10 @@ public:
 	bool hasNativeFormat(__u32 format);
 	static bool isSupported();
 
+protected:
+	void resizeEvent(QResizeEvent *event);
+
+private:
 #ifdef HAVE_QTGL
 	CaptureWinGLEngine m_videoSurface;
 #endif
diff --git a/utils/qv4l2/capture-win-qt.cpp b/utils/qv4l2/capture-win-qt.cpp
index 63c77d5..f746379 100644
--- a/utils/qv4l2/capture-win-qt.cpp
+++ b/utils/qv4l2/capture-win-qt.cpp
@@ -24,6 +24,8 @@ CaptureWinQt::CaptureWinQt() :
 {
 
 	CaptureWin::buildWindow(&m_videoSurface);
+	m_scaledFrame.setWidth(0);
+	m_scaledFrame.setHeight(0);
 }
 
 CaptureWinQt::~CaptureWinQt()
@@ -31,6 +33,19 @@ CaptureWinQt::~CaptureWinQt()
 	delete m_frame;
 }
 
+void CaptureWinQt::resizeEvent(QResizeEvent *event)
+{
+	if (m_frame->bits() == NULL)
+		return;
+
+	QPixmap img = QPixmap::fromImage(*m_frame);
+	m_scaledFrame = scaleFrameSize(QSize(m_videoSurface.width(), m_videoSurface.height()),
+				       QSize(m_frame->width(), m_frame->height()));
+	img = img.scaled(m_scaledFrame.width(), m_scaledFrame.height(), Qt::IgnoreAspectRatio);
+	m_videoSurface.setPixmap(img);
+	QWidget::resizeEvent(event);
+}
+
 void CaptureWinQt::setFrame(int width, int height, __u32 format, unsigned char *data, const QString &info)
 {
 	QImage::Format dstFmt;
@@ -41,6 +56,8 @@ void CaptureWinQt::setFrame(int width, int height, __u32 format, unsigned char *
 	if (m_frame->width() != width || m_frame->height() != height || m_frame->format() != dstFmt) {
 		delete m_frame;
 		m_frame = new QImage(width, height, dstFmt);
+		m_scaledFrame = scaleFrameSize(QSize(m_videoSurface.width(), m_videoSurface.height()),
+					       QSize(m_frame->width(), m_frame->height()));
 	}
 
 	if (data == NULL || !supported)
@@ -49,7 +66,11 @@ void CaptureWinQt::setFrame(int width, int height, __u32 format, unsigned char *
 		memcpy(m_frame->bits(), data, m_frame->numBytes());
 
 	m_information.setText(info);
-	m_videoSurface.setPixmap(QPixmap::fromImage(*m_frame));
+
+	QPixmap img = QPixmap::fromImage(*m_frame);
+	img = img.scaled(m_scaledFrame.width(), m_scaledFrame.height(), Qt::IgnoreAspectRatio);
+
+	m_videoSurface.setPixmap(img);
 }
 
 bool CaptureWinQt::hasNativeFormat(__u32 format)
diff --git a/utils/qv4l2/capture-win-qt.h b/utils/qv4l2/capture-win-qt.h
index d192045..6029109 100644
--- a/utils/qv4l2/capture-win-qt.h
+++ b/utils/qv4l2/capture-win-qt.h
@@ -25,6 +25,7 @@
 
 #include <QLabel>
 #include <QImage>
+#include <QResizeEvent>
 
 class CaptureWinQt : public CaptureWin
 {
@@ -39,10 +40,14 @@ public:
 	bool hasNativeFormat(__u32 format);
 	static bool isSupported() { return true; }
 
+protected:
+	void resizeEvent(QResizeEvent *event);
+
 private:
 	bool findNativeFormat(__u32 format, QImage::Format &dstFmt);
 
 	QImage *m_frame;
 	QLabel m_videoSurface;
+	QSize m_scaledFrame;
 };
 #endif
diff --git a/utils/qv4l2/capture-win.cpp b/utils/qv4l2/capture-win.cpp
index 8722066..33f7084 100644
--- a/utils/qv4l2/capture-win.cpp
+++ b/utils/qv4l2/capture-win.cpp
@@ -26,11 +26,18 @@
 #include <QApplication>
 #include <QDesktopWidget>
 
-CaptureWin::CaptureWin()
+#define MIN_WIN_SIZE_WIDTH 160
+#define MIN_WIN_SIZE_HEIGHT 120
+
+bool CaptureWin::m_enableScaling = true;
+
+CaptureWin::CaptureWin() :
+	m_curWidth(-1),
+	m_curHeight(-1)
 {
 	setWindowTitle("V4L2 Capture");
 	m_hotkeyClose = new QShortcut(Qt::CTRL+Qt::Key_W, this);
-	QObject::connect(m_hotkeyClose, SIGNAL(activated()), this, SLOT(close()));
+	connect(m_hotkeyClose, SIGNAL(activated()), this, SLOT(close()));
 }
 
 CaptureWin::~CaptureWin()
@@ -61,30 +68,72 @@ QSize CaptureWin::getMargins()
 	return QSize(l + r, t + b + m_information.minimumSizeHint().height() + layout()->spacing());
 }
 
-void CaptureWin::setMinimumSize(int minw, int minh)
+void CaptureWin::enableScaling(bool enable)
+{
+	if (!enable) {
+		QSize margins = getMargins();
+		QWidget::setMinimumSize(m_curWidth + margins.width(), m_curHeight + margins.height());
+	} else {
+		QWidget::setMinimumSize(MIN_WIN_SIZE_WIDTH, MIN_WIN_SIZE_HEIGHT);
+	}
+	m_enableScaling = enable;
+	QResizeEvent *event = new QResizeEvent(QSize(width(), height()), QSize(width(), height()));
+	QCoreApplication::sendEvent(this, event);
+	delete event;
+}
+
+void CaptureWin::resize(int width, int height)
 {
+	// Dont resize window if the frame size is the same in
+	// the event the window has been paused when beeing resized.
+	if (width == m_curWidth && height == m_curHeight)
+		return;
+
+	m_curWidth = width;
+	m_curHeight = height;
+
+	QSize margins = getMargins();
+	width += margins.width();
+	height += margins.height();
+
 	QDesktopWidget *screen = QApplication::desktop();
 	QRect resolution = screen->screenGeometry();
-	QSize maxSize = maximumSize();
 
-	QSize margins = getMargins();
-	minw += margins.width();
-	minh += margins.height();
-
-	if (minw > resolution.width())
-		minw = resolution.width();
-	if (minw < 150)
-		minw = 150;
-
-	if (minh > resolution.height())
-		minh = resolution.height();
-	if (minh < 100)
-		minh = 100;
-
-	QWidget::setMinimumSize(minw, minh);
-	QWidget::setMaximumSize(minw, minh);
-	updateGeometry();
-	QWidget::setMaximumSize(maxSize.width(), maxSize.height());
+	if (width > resolution.width())
+		width = resolution.width();
+	if (width < MIN_WIN_SIZE_WIDTH)
+		width = MIN_WIN_SIZE_WIDTH;
+
+	if (height > resolution.height())
+		height = resolution.height();
+	if (height < MIN_WIN_SIZE_HEIGHT)
+		height = MIN_WIN_SIZE_HEIGHT;
+
+	QWidget::setMinimumSize(MIN_WIN_SIZE_WIDTH, MIN_WIN_SIZE_HEIGHT);
+	QWidget::resize(width, height);
+}
+
+QSize CaptureWin::scaleFrameSize(QSize window, QSize frame)
+{
+	int actualFrameWidth = frame.width();;
+	int actualFrameHeight = frame.height();
+
+	if (!m_enableScaling) {
+		window.setWidth(frame.width());
+		window.setHeight(frame.height());
+	}
+
+	double newW, newH;
+	if (window.width() >= window.height()) {
+		newW = (double)window.width() / actualFrameWidth;
+		newH = (double)window.height() / actualFrameHeight;
+	} else {
+		newH = (double)window.width() / actualFrameWidth;
+		newW = (double)window.height() / actualFrameHeight;
+	}
+	double resized = std::min(newW, newH);
+
+	return QSize((int)(actualFrameWidth * resized), (int)(actualFrameHeight * resized));
 }
 
 void CaptureWin::closeEvent(QCloseEvent *event)
diff --git a/utils/qv4l2/capture-win.h b/utils/qv4l2/capture-win.h
index f662bd3..dd19f2d 100644
--- a/utils/qv4l2/capture-win.h
+++ b/utils/qv4l2/capture-win.h
@@ -34,7 +34,7 @@ public:
 	CaptureWin();
 	~CaptureWin();
 
-	void setMinimumSize(int minw, int minh);
+	void resize(int minw, int minh);
 
 	/**
 	 * @brief Set a frame into the capture window.
@@ -75,9 +75,13 @@ public:
 	 */
 	static bool isSupported() { return false; }
 
+	void enableScaling(bool enable);
+	static QSize scaleFrameSize(QSize window, QSize frame);
+
 protected:
 	void closeEvent(QCloseEvent *event);
 	void buildWindow(QWidget *videoSurface);
+	static int actualFrameWidth(int width);
 	QSize getMargins();
 
 	/**
@@ -87,11 +91,17 @@ protected:
 	 */
 	QLabel m_information;
 
+	/**
+	 * @brief Determines if scaling is to be applied to video frame.
+	 */
+	static bool m_enableScaling;
+
 signals:
 	void close();
 
 private:
 	QShortcut *m_hotkeyClose;
-
+	int m_curWidth;
+	int m_curHeight;
 };
 #endif
diff --git a/utils/qv4l2/qv4l2.cpp b/utils/qv4l2/qv4l2.cpp
index ee0c22d..50ba07a 100644
--- a/utils/qv4l2/qv4l2.cpp
+++ b/utils/qv4l2/qv4l2.cpp
@@ -137,9 +137,16 @@ ApplicationWindow::ApplicationWindow() :
 	toolBar->addSeparator();
 	toolBar->addAction(quitAct);
 
+	m_scalingAct = new QAction("Enable Video Scaling", this);
+	m_scalingAct->setStatusTip("Scale video frames to match window size if set");
+	m_scalingAct->setCheckable(true);
+	m_scalingAct->setChecked(true);
+	connect(m_scalingAct, SIGNAL(toggled(bool)), this, SLOT(enableScaling(bool)));
+
 	QMenu *captureMenu = menuBar()->addMenu("&Capture");
 	captureMenu->addAction(m_capStartAct);
 	captureMenu->addAction(m_showFramesAct);
+	captureMenu->addAction(m_scalingAct);
 
 	if (CaptureWinGL::isSupported()) {
 		m_renderMethod = QV4L2_RENDER_GL;
@@ -351,7 +358,8 @@ void ApplicationWindow::newCaptureWin()
 		break;
 	}
 
-	connect(m_capture, SIGNAL(close()), this, SLOT(closeCaptureWin()));
+	m_capture->enableScaling(m_scalingAct->isChecked());
+        connect(m_capture, SIGNAL(close()), this, SLOT(closeCaptureWin()));
 }
 
 void ApplicationWindow::capVbiFrame()
@@ -793,6 +801,12 @@ void ApplicationWindow::stopOutput()
 {
 }
 
+void ApplicationWindow::enableScaling(bool enable)
+{
+	if (m_capture != NULL)
+		m_capture->enableScaling(enable);
+}
+
 void ApplicationWindow::startAudio()
 {
 #ifdef HAVE_ALSA
@@ -903,7 +917,7 @@ void ApplicationWindow::capStart(bool start)
 			m_vbiHeight = fmt.fmt.vbi.count[0] + fmt.fmt.vbi.count[1];
 		m_vbiSize = m_vbiWidth * m_vbiHeight;
 		m_frameData = new unsigned char[m_vbiSize];
-		m_capture->setMinimumSize(m_vbiWidth, m_vbiHeight);
+		m_capture->resize(m_vbiWidth, m_vbiHeight);
 		m_capImage = new QImage(m_vbiWidth, m_vbiHeight, dstFmt);
 		m_capImage->fill(0);
 		m_capture->setFrame(m_capImage->width(), m_capImage->height(),
@@ -933,8 +947,8 @@ void ApplicationWindow::capStart(bool start)
 		m_mustConvert = false;
 	} else {
 		m_mustConvert = true;
-		v4l2_format copy = m_capSrcFormat;
 
+		v4l2_format copy = m_capSrcFormat;
 		v4lconvert_try_format(m_convertData, &m_capDestFormat, &m_capSrcFormat);
 		// v4lconvert_try_format sometimes modifies the source format if it thinks
 		// that there is a better format available. Restore our selected source
@@ -942,7 +956,7 @@ void ApplicationWindow::capStart(bool start)
 		m_capSrcFormat = copy;
 	}
 
-	m_capture->setMinimumSize(dstPix.width, dstPix.height);
+	m_capture->resize(dstPix.width, dstPix.height);
 	m_capImage = new QImage(dstPix.width, dstPix.height, dstFmt);
 	m_capImage->fill(0);
 	if (showFrames()) {
diff --git a/utils/qv4l2/qv4l2.h b/utils/qv4l2/qv4l2.h
index dd9db44..1402673 100644
--- a/utils/qv4l2/qv4l2.h
+++ b/utils/qv4l2/qv4l2.h
@@ -132,6 +132,7 @@ private slots:
 	void openRawFile(const QString &s);
 	void rejectedRawFile();
 	void setAudioBufferSize();
+	void enableScaling(bool enable);
 
 	void about();
 
@@ -185,6 +186,7 @@ private:
 	QAction *m_useGLAct;
 	QAction *m_showAllAudioAct;
 	QAction *m_audioBufferAct;
+	QAction *m_scalingAct;
 	QString m_filename;
 	QSignalMapper *m_sigMapper;
 	QTabWidget *m_tabs;
-- 
1.8.3.2

