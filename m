Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-3.cisco.com ([144.254.224.146]:26148 "EHLO
	ams-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755372Ab3HEI5s (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 5 Aug 2013 04:57:48 -0400
Received: from bwinther.cisco.com (dhcp-10-54-92-49.cisco.com [10.54.92.49])
	by ams-core-4.cisco.com (8.14.5/8.14.5) with ESMTP id r758vY7g001512
	for <linux-media@vger.kernel.org>; Mon, 5 Aug 2013 08:57:44 GMT
From: =?UTF-8?q?B=C3=A5rd=20Eirik=20Winther?= <bwinther@cisco.com>
To: linux-media@vger.kernel.org
Subject: [RFC PATCH 5/7] qv4l2: add video scaling for CaptureWin
Date: Mon,  5 Aug 2013 10:56:55 +0200
Message-Id: <3454d4e2556d327f89a52f30018282ec47d6d0f2.1375692973.git.bwinther@cisco.com>
In-Reply-To: <1375693017-6079-1-git-send-email-bwinther@cisco.com>
References: <1375693017-6079-1-git-send-email-bwinther@cisco.com>
In-Reply-To: <8be0aea2a33100972c3f9c74a8c981fca0e7a2aa.1375692973.git.bwinther@cisco.com>
References: <8be0aea2a33100972c3f9c74a8c981fca0e7a2aa.1375692973.git.bwinther@cisco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Bård Eirik Winther <bwinther@cisco.com>
---
 utils/qv4l2/capture-win-gl.cpp |  26 ++++++++--
 utils/qv4l2/capture-win-gl.h   |   8 ++++
 utils/qv4l2/capture-win-qt.cpp |  24 +++++++++-
 utils/qv4l2/capture-win-qt.h   |   5 ++
 utils/qv4l2/capture-win.cpp    | 106 +++++++++++++++++++++++++++++++----------
 utils/qv4l2/capture-win.h      |  18 +++++--
 utils/qv4l2/qv4l2.cpp          |  27 +++++++++--
 utils/qv4l2/qv4l2.h            |   4 ++
 8 files changed, 181 insertions(+), 37 deletions(-)

diff --git a/utils/qv4l2/capture-win-gl.cpp b/utils/qv4l2/capture-win-gl.cpp
index edae60f..628aaec 100644
--- a/utils/qv4l2/capture-win-gl.cpp
+++ b/utils/qv4l2/capture-win-gl.cpp
@@ -43,6 +43,15 @@ void CaptureWinGL::stop()
 #endif
 }
 
+void CaptureWinGL::resizeEvent(QResizeEvent *event)
+{
+	QSize margins = getMargins();
+#ifdef ENABLE_GL
+	m_videoSurface.setSize(width() - margins.width(), height() - margins.height());
+#endif
+	event->accept();
+}
+
 void CaptureWinGL::setFrame(int width, int height, __u32 format, unsigned char *data, const QString &info)
 {
 #ifdef ENABLE_GL
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
index 08e72b2..ef06d0b 100644
--- a/utils/qv4l2/capture-win-gl.h
+++ b/utils/qv4l2/capture-win-gl.h
@@ -21,6 +21,9 @@
 #include "qv4l2.h"
 #include "capture-win.h"
 
+#include <QBoxLayout>
+#include <QResizeEvent>
+
 #ifdef ENABLE_GL
 #define GL_GLEXT_PROTOTYPES
 #include <QGLWidget>
@@ -40,6 +43,7 @@ public:
 	void stop();
 	void setFrame(int width, int height, __u32 format, unsigned char *data);
 	bool hasNativeFormat(__u32 format);
+	void setSize(int width, int height);
 
 protected:
 	void paintGL();
@@ -88,6 +92,10 @@ public:
 	bool hasNativeFormat(__u32 format);
 	static bool isSupported();
 
+ protected:
+	void resizeEvent(QResizeEvent *event);
+
+private:
 #ifdef ENABLE_GL
 	CaptureWinGLEngine m_videoSurface;
 #endif
diff --git a/utils/qv4l2/capture-win-qt.cpp b/utils/qv4l2/capture-win-qt.cpp
index 63c77d5..0f6964b 100644
--- a/utils/qv4l2/capture-win-qt.cpp
+++ b/utils/qv4l2/capture-win-qt.cpp
@@ -22,8 +22,9 @@
 CaptureWinQt::CaptureWinQt() :
 	m_frame(new QImage(0, 0, QImage::Format_Invalid))
 {
-
 	CaptureWin::buildWindow(&m_videoSurface);
+	m_scaledFrame.setWidth(0);
+	m_scaledFrame.setHeight(0);
 }
 
 CaptureWinQt::~CaptureWinQt()
@@ -31,6 +32,19 @@ CaptureWinQt::~CaptureWinQt()
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
@@ -41,6 +55,8 @@ void CaptureWinQt::setFrame(int width, int height, __u32 format, unsigned char *
 	if (m_frame->width() != width || m_frame->height() != height || m_frame->format() != dstFmt) {
 		delete m_frame;
 		m_frame = new QImage(width, height, dstFmt);
+		m_scaledFrame = scaleFrameSize(QSize(m_videoSurface.width(), m_videoSurface.height()),
+					       QSize(m_frame->width(), m_frame->height()));
 	}
 
 	if (data == NULL || !supported)
@@ -49,7 +65,11 @@ void CaptureWinQt::setFrame(int width, int height, __u32 format, unsigned char *
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
index e583900..4c5dd57 100644
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
@@ -54,37 +61,88 @@ void CaptureWin::buildWindow(QWidget *videoSurface)
 	vbox->setSpacing(b);
 }
 
+void CaptureWin::resetSize()
+{
+	int w = m_curWidth;
+	int h = m_curHeight;
+	m_curWidth = -1;
+	m_curHeight = -1;
+	resize(w, h);
+}
+
 QSize CaptureWin::getMargins()
 {
- 	int l, t, r, b;
- 	layout()->getContentsMargins(&l, &t, &r, &b);
+	int l, t, r, b;
+	layout()->getContentsMargins(&l, &t, &r, &b);
 	return QSize(l + r, t + b + m_information.minimumSizeHint().height() + layout()->spacing());
 }
 
-void CaptureWin::setMinimumSize(int minw, int minh)
+void CaptureWin::enableScaling(bool enable)
 {
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
+{
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
index 6b72e00..eea0335 100644
--- a/utils/qv4l2/capture-win.h
+++ b/utils/qv4l2/capture-win.h
@@ -34,7 +34,7 @@ public:
 	CaptureWin();
 	~CaptureWin();
 
-	void setMinimumSize(int minw, int minh);
+	void resize(int minw, int minh);
 
 	/**
 	 * @brief Set a frame into the capture window.
@@ -75,12 +75,18 @@ public:
 	 */
 	static bool isSupported() { return false; }
 
+	void enableScaling(bool enable);
+	static QSize scaleFrameSize(QSize window, QSize frame);
+
+public slots:
+	void resetSize();
+
 protected:
 	void closeEvent(QCloseEvent *event);
 	void buildWindow(QWidget *videoSurface);
+	static int actualFrameWidth(int width);
 	QSize getMargins();
 
-
 	/**
 	 * @brief A label that can is used to display capture information.
 	 *
@@ -88,11 +94,17 @@ protected:
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
index fa1425d..6b64892 100644
--- a/utils/qv4l2/qv4l2.cpp
+++ b/utils/qv4l2/qv4l2.cpp
@@ -137,9 +137,20 @@ ApplicationWindow::ApplicationWindow() :
 	toolBar->addSeparator();
 	toolBar->addAction(quitAct);
 
+	m_scalingAct = new QAction("Enable Video Scaling", this);
+	m_scalingAct->setStatusTip("Scale video frames to match window size if set");
+	m_scalingAct->setCheckable(true);
+	m_scalingAct->setChecked(true);
+	connect(m_scalingAct, SIGNAL(toggled(bool)), this, SLOT(enableScaling(bool)));
+	m_resetScalingAct = new QAction("Resize to Frame Size", this);
+	m_resetScalingAct->setStatusTip("Resizes the capture window to match frame size");
+
 	QMenu *captureMenu = menuBar()->addMenu("&Capture");
 	captureMenu->addAction(m_capStartAct);
 	captureMenu->addAction(m_showFramesAct);
+	captureMenu->addAction(m_scalingAct);
+	captureMenu->addAction(m_resetScalingAct);
+
 
 	if (CaptureWinGL::isSupported()) {
 		m_renderMethod = QV4L2_RENDER_GL;
@@ -351,7 +362,9 @@ void ApplicationWindow::newCaptureWin()
 		break;
 	}
 
-	connect(m_capture, SIGNAL(close()), this, SLOT(closeCaptureWin()));
+	m_capture->enableScaling(m_scalingAct->isChecked());
+        connect(m_capture, SIGNAL(close()), this, SLOT(closeCaptureWin()));
+	connect(m_resetScalingAct, SIGNAL(triggered()), m_capture, SLOT(resetSize()));
 }
 
 void ApplicationWindow::capVbiFrame()
@@ -793,6 +806,12 @@ void ApplicationWindow::stopOutput()
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
 #ifdef ENABLE_ALSA
@@ -903,7 +922,7 @@ void ApplicationWindow::capStart(bool start)
 			m_vbiHeight = fmt.fmt.vbi.count[0] + fmt.fmt.vbi.count[1];
 		m_vbiSize = m_vbiWidth * m_vbiHeight;
 		m_frameData = new unsigned char[m_vbiSize];
-		m_capture->setMinimumSize(m_vbiWidth, m_vbiHeight);
+		m_capture->resize(m_vbiWidth, m_vbiHeight);
 		m_capImage = new QImage(m_vbiWidth, m_vbiHeight, dstFmt);
 		m_capImage->fill(0);
 		m_capture->setFrame(m_capImage->width(), m_capImage->height(),
@@ -933,8 +952,8 @@ void ApplicationWindow::capStart(bool start)
 		m_mustConvert = false;
 	} else {
 		m_mustConvert = true;
+		
 		v4l2_format copy = m_capSrcFormat;
-
 		v4lconvert_try_format(m_convertData, &m_capDestFormat, &m_capSrcFormat);
 		// v4lconvert_try_format sometimes modifies the source format if it thinks
 		// that there is a better format available. Restore our selected source
@@ -942,7 +961,7 @@ void ApplicationWindow::capStart(bool start)
 		m_capSrcFormat = copy;
 	}
 
-	m_capture->setMinimumSize(dstPix.width, dstPix.height);
+	m_capture->resize(dstPix.width, dstPix.height);
 	m_capImage = new QImage(dstPix.width, dstPix.height, dstFmt);
 	m_capImage->fill(0);
 	if (showFrames()) {
diff --git a/utils/qv4l2/qv4l2.h b/utils/qv4l2/qv4l2.h
index 92d6f25..3704ab1 100644
--- a/utils/qv4l2/qv4l2.h
+++ b/utils/qv4l2/qv4l2.h
@@ -130,6 +130,8 @@ private slots:
 	void openRawFile(const QString &s);
 	void rejectedRawFile();
 	void setAudioBufferSize();
+	void enableScaling(bool enable);
+
 
 	void about();
 
@@ -183,6 +185,8 @@ private:
 	QAction *m_useGLAct;
 	QAction *m_showAllAudioAct;
 	QAction *m_audioBufferAct;
+	QAction *m_scalingAct;
+	QAction *m_resetScalingAct;
 	QString m_filename;
 	QSignalMapper *m_sigMapper;
 	QTabWidget *m_tabs;
-- 
1.8.3.2

