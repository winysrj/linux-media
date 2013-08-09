Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-4.cisco.com ([144.254.224.147]:51835 "EHLO
	ams-iport-4.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966169Ab3HIMMe (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 9 Aug 2013 08:12:34 -0400
From: =?UTF-8?q?B=C3=A5rd=20Eirik=20Winther?= <bwinther@cisco.com>
To: linux-media@vger.kernel.org
Cc: baard.e.winther@wintherstormer.no
Subject: [PATCH FINAL 2/6] qv4l2: add cropping to CaptureWin and Qt render
Date: Fri,  9 Aug 2013 14:12:08 +0200
Message-Id: <9713b77d34996381ee863c50d538345732b09bad.1376049957.git.bwinther@cisco.com>
In-Reply-To: <1376050332-27290-1-git-send-email-bwinther@cisco.com>
References: <1376050332-27290-1-git-send-email-bwinther@cisco.com>
In-Reply-To: <42a47889f837e362abc7a527c1029329e62034b0.1376049957.git.bwinther@cisco.com>
References: <42a47889f837e362abc7a527c1029329e62034b0.1376049957.git.bwinther@cisco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Allows for removal of letterboxes from common video formats.
The Qt renderer has been rewritten to increase performance required
when applying cropping. No longer uses memcpy.

Signed-off-by: Bård Eirik Winther <bwinther@cisco.com>
---
 utils/qv4l2/capture-win-gl.cpp | 27 +++++++------
 utils/qv4l2/capture-win-gl.h   |  1 +
 utils/qv4l2/capture-win-qt.cpp | 89 ++++++++++++++++++++++++++++++++----------
 utils/qv4l2/capture-win-qt.h   | 15 ++++++-
 utils/qv4l2/capture-win.cpp    | 57 ++++++++++++++++++++++-----
 utils/qv4l2/capture-win.h      | 73 +++++++++++++++++++++++++++++-----
 utils/qv4l2/general-tab.cpp    | 63 +++++++++++++++++++++++-------
 utils/qv4l2/general-tab.h      |  5 +++
 utils/qv4l2/qv4l2.cpp          |  7 ++++
 utils/qv4l2/qv4l2.h            |  1 +
 10 files changed, 270 insertions(+), 68 deletions(-)

diff --git a/utils/qv4l2/capture-win-gl.cpp b/utils/qv4l2/capture-win-gl.cpp
index 27ff3d3..d1828cf 100644
--- a/utils/qv4l2/capture-win-gl.cpp
+++ b/utils/qv4l2/capture-win-gl.cpp
@@ -261,6 +261,18 @@ void CaptureWinGLEngine::changeShader()
 	glClear(GL_COLOR_BUFFER_BIT);
 }
 
+void CaptureWinGLEngine::paintFrame()
+{
+	float crop = (float)CaptureWin::cropHeight(m_frameWidth, m_frameHeight) / m_frameHeight;
+
+	glBegin(GL_QUADS);
+	glTexCoord2f(0.0f, crop); glVertex2f(0.0, 0);
+	glTexCoord2f(1.0f, crop); glVertex2f(m_frameWidth, 0);
+	glTexCoord2f(1.0f, 1.0f - crop); glVertex2f(m_frameWidth, m_frameHeight);
+	glTexCoord2f(0.0f, 1.0f - crop); glVertex2f(0, m_frameHeight);
+	glEnd();
+}
+
 void CaptureWinGLEngine::paintGL()
 {
 	if (m_frameWidth < 1 || m_frameHeight < 1) {
@@ -271,12 +283,7 @@ void CaptureWinGLEngine::paintGL()
 		changeShader();
 
 	if (m_frameData == NULL) {
-		glBegin(GL_QUADS);
-		glTexCoord2f(0.0f, 0.0f); glVertex2f(0.0, 0);
-		glTexCoord2f(1.0f, 0.0f); glVertex2f(m_frameWidth, 0);
-		glTexCoord2f(1.0f, 1.0f); glVertex2f(m_frameWidth, m_frameHeight);
-		glTexCoord2f(0.0f, 1.0f); glVertex2f(0, m_frameHeight);
-		glEnd();
+		paintFrame();
 		return;
 	}
 
@@ -329,13 +336,7 @@ void CaptureWinGLEngine::paintGL()
 		checkError("Default paint");
 		break;
 	}
-
-	glBegin(GL_QUADS);
-	glTexCoord2f(0.0f, 0.0f); glVertex2f(0.0, 0);
-	glTexCoord2f(1.0f, 0.0f); glVertex2f(m_frameWidth, 0);
-	glTexCoord2f(1.0f, 1.0f); glVertex2f(m_frameWidth, m_frameHeight);
-	glTexCoord2f(0.0f, 1.0f); glVertex2f(0, m_frameHeight);
-	glEnd();
+	paintFrame();
 }
 
 void CaptureWinGLEngine::configureTexture(size_t idx)
diff --git a/utils/qv4l2/capture-win-gl.h b/utils/qv4l2/capture-win-gl.h
index 0c3ff8b..5a7fb3d 100644
--- a/utils/qv4l2/capture-win-gl.h
+++ b/utils/qv4l2/capture-win-gl.h
@@ -65,6 +65,7 @@ private:
 
 	void clearShader();
 	void changeShader();
+	void paintFrame();
 	void configureTexture(size_t idx);
 	void checkError(const char *msg);
 
diff --git a/utils/qv4l2/capture-win-qt.cpp b/utils/qv4l2/capture-win-qt.cpp
index 82c618c..d70f317 100644
--- a/utils/qv4l2/capture-win-qt.cpp
+++ b/utils/qv4l2/capture-win-qt.cpp
@@ -20,12 +20,19 @@
 #include "capture-win-qt.h"
 
 CaptureWinQt::CaptureWinQt() :
-	m_frame(new QImage(0, 0, QImage::Format_Invalid))
+	m_frame(new QImage(0, 0, QImage::Format_Invalid)),
+	m_data(NULL),
+	m_supportedFormat(false),
+	m_filled(false)
 {
 
 	CaptureWin::buildWindow(&m_videoSurface);
 	m_scaledSize.setWidth(0);
 	m_scaledSize.setHeight(0);
+	m_crop.crop = 0;
+	m_crop.height = 0;
+	m_crop.offset = 0;
+	m_crop.bytes = 0;
 }
 
 CaptureWinQt::~CaptureWinQt()
@@ -33,46 +40,88 @@ CaptureWinQt::~CaptureWinQt()
 	delete m_frame;
 }
 
-void CaptureWinQt::resizeEvent(QResizeEvent *event)
+void CaptureWinQt::resizeScaleCrop()
 {
-	if (m_frame->bits() == NULL)
-		return;
-
-	QPixmap img = QPixmap::fromImage(*m_frame);
 	m_scaledSize = scaleFrameSize(QSize(m_videoSurface.width(), m_videoSurface.height()),
-				       QSize(m_frame->width(), m_frame->height()));
-	img = img.scaled(m_scaledSize.width(), m_scaledSize.height(), Qt::IgnoreAspectRatio);
-	m_videoSurface.setPixmap(img);
-	QWidget::resizeEvent(event);
+				      QSize(m_frame->width(), m_frame->height()));
+
+	if (!m_crop.bytes || m_crop.crop != cropHeight(m_frame->width(), m_frame->height())) {
+		m_crop.crop = cropHeight(m_frame->width(), m_frame->height());
+		m_crop.height = m_frame->height() - (m_crop.crop * 2);
+		m_crop.offset = m_crop.crop * (m_frame->depth() / 8) * m_frame->width();
+
+		// Even though the values above can be valid, it might be that there is no
+		// data at all. This makes sure that it is.
+		m_crop.bytes = m_crop.height * m_frame->width() * (m_frame->depth() / 8);
+	}
+}
+
+void CaptureWinQt::resizeEvent(QResizeEvent *event)
+{
+	resizeScaleCrop();
+	paintFrame();
 }
 
 void CaptureWinQt::setFrame(int width, int height, __u32 format, unsigned char *data, const QString &info)
 {
+	m_data = data;
+
 	QImage::Format dstFmt;
-	bool supported = findNativeFormat(format, dstFmt);
-	if (!supported)
+	m_supportedFormat = findNativeFormat(format, dstFmt);
+	if (!m_supportedFormat)
 		dstFmt = QImage::Format_RGB888;
 
-	if (m_frame->width() != width || m_frame->height() != height || m_frame->format() != dstFmt) {
+	if (m_frame->width() != width
+	    || m_frame->height() != height
+	    || m_frame->format() != dstFmt) {
 		delete m_frame;
 		m_frame = new QImage(width, height, dstFmt);
-		m_scaledSize = scaleFrameSize(QSize(m_videoSurface.width(), m_videoSurface.height()),
-					       QSize(m_frame->width(), m_frame->height()));
+
+		resizeScaleCrop();
 	}
 
-	if (data == NULL || !supported)
-		m_frame->fill(0);
+	m_information.setText(info);
+	paintFrame();
+}
+
+void CaptureWinQt::paintFrame()
+{
+	if (!m_supportedFormat || !m_crop.bytes) {
+		if (!m_filled) {
+			m_filled = true;
+			m_frame->fill(0);
+			QPixmap img = QPixmap::fromImage(*m_frame);
+			m_videoSurface.setPixmap(img);
+		}
+		return;
+	}
+	m_filled = false;
+
+	unsigned char *data;
+
+	if (m_data == NULL)
+		data = m_frame->bits();
 	else
-		memcpy(m_frame->bits(), data, m_frame->numBytes());
+		data = m_data;
 
-	m_information.setText(info);
+	QImage displayFrame(&data[m_crop.offset], m_frame->width(), m_crop.height,
+			    m_frame->numBytes()/m_frame->height(), m_frame->format());
+
+	QPixmap img = QPixmap::fromImage(displayFrame);
 
-	QPixmap img = QPixmap::fromImage(*m_frame);
+	// No scaling is performed by scaled() if the scaled size is equal to original size
 	img = img.scaled(m_scaledSize.width(), m_scaledSize.height(), Qt::IgnoreAspectRatio);
 
 	m_videoSurface.setPixmap(img);
 }
 
+void CaptureWinQt::stop()
+{
+	if (m_data != NULL)
+		memcpy(m_frame->bits(), m_data, m_frame->numBytes());
+	m_data = NULL;
+}
+
 bool CaptureWinQt::hasNativeFormat(__u32 format)
 {
 	QImage::Format fmt;
diff --git a/utils/qv4l2/capture-win-qt.h b/utils/qv4l2/capture-win-qt.h
index 9faa12f..cfc2a9d 100644
--- a/utils/qv4l2/capture-win-qt.h
+++ b/utils/qv4l2/capture-win-qt.h
@@ -27,6 +27,13 @@
 #include <QImage>
 #include <QResizeEvent>
 
+struct CropInfo {
+	int crop;
+	int height;
+	int offset;
+	int bytes;
+};
+
 class CaptureWinQt : public CaptureWin
 {
 public:
@@ -36,7 +43,7 @@ public:
 	void setFrame(int width, int height, __u32 format,
 		      unsigned char *data, const QString &info);
 
-	void stop(){}
+	void stop();
 	bool hasNativeFormat(__u32 format);
 	static bool isSupported() { return true; }
 
@@ -45,9 +52,15 @@ protected:
 
 private:
 	bool findNativeFormat(__u32 format, QImage::Format &dstFmt);
+	void paintFrame();
+	void resizeScaleCrop();
 
 	QImage *m_frame;
+	struct CropInfo m_crop;
+	unsigned char *m_data;
 	QLabel m_videoSurface;
 	QSize m_scaledSize;
+	bool m_supportedFormat;
+	bool m_filled;
 };
 #endif
diff --git a/utils/qv4l2/capture-win.cpp b/utils/qv4l2/capture-win.cpp
index 7538756..c8e183b 100644
--- a/utils/qv4l2/capture-win.cpp
+++ b/utils/qv4l2/capture-win.cpp
@@ -31,6 +31,7 @@
 
 bool CaptureWin::m_enableScaling = true;
 double CaptureWin::m_pixelAspectRatio = 1.0;
+CropMethod CaptureWin::m_cropMethod = QV4L2_CROP_NONE;
 
 CaptureWin::CaptureWin() :
 	m_curWidth(-1),
@@ -77,10 +78,48 @@ void CaptureWin::resetSize()
 	resize(w, h);
 }
 
+int CaptureWin::cropHeight(int width, int height)
+{
+	int validHeight;
+	switch (m_cropMethod) {
+	case QV4L2_CROP_W149:
+		validHeight = (int)(width / 1.57);
+		break;
+	case QV4L2_CROP_W169:
+		validHeight = (int)(width / 1.78);
+		break;
+	case QV4L2_CROP_C185:
+		validHeight = (int)(width / 1.85);
+		break;
+	case QV4L2_CROP_C239:
+		validHeight = (int)(width / 2.39);
+		break;
+	case QV4L2_CROP_TB:
+		validHeight = height - 2;
+		break;
+	default:
+		validHeight = 0;
+		break;
+	}
+
+	if (validHeight < MIN_WIN_SIZE_HEIGHT || validHeight >= height)
+		return 0;
+
+	return (height - validHeight) / 2;
+}
+
+
+void CaptureWin::setCropMethod(CropMethod crop)
+{
+	m_cropMethod = crop;
+	QResizeEvent event (QSize(width(), height()), QSize(width(), height()));
+	QCoreApplication::sendEvent(this, &event);
+}
+
 int CaptureWin::actualFrameWidth(int width)
 {
 	if (m_enableScaling)
-		return (int)((double)width * m_pixelAspectRatio);
+		return width * m_pixelAspectRatio;
 
 	return width;
 }
@@ -101,9 +140,8 @@ void CaptureWin::enableScaling(bool enable)
 		QWidget::setMinimumSize(MIN_WIN_SIZE_WIDTH, MIN_WIN_SIZE_HEIGHT);
 	}
 	m_enableScaling = enable;
-	QResizeEvent *event = new QResizeEvent(QSize(width(), height()), QSize(width(), height()));
-	QCoreApplication::sendEvent(this, event);
-	delete event;
+	QResizeEvent event (QSize(width(), height()), QSize(width(), height()));
+	QCoreApplication::sendEvent(this, &event);
 }
 
 void CaptureWin::resize(int width, int height)
@@ -117,8 +155,8 @@ void CaptureWin::resize(int width, int height)
 	m_curHeight = height;
 
 	QSize margins = getMargins();
-	width = actualFrameWidth(width) + margins.width();
-	height += margins.height();
+	height = height + margins.height() - cropHeight(width, height) * 2;
+	width = margins.width() + actualFrameWidth(width);
 
 	QDesktopWidget *screen = QApplication::desktop();
 	QRect resolution = screen->screenGeometry();
@@ -140,7 +178,7 @@ void CaptureWin::resize(int width, int height)
 QSize CaptureWin::scaleFrameSize(QSize window, QSize frame)
 {
 	int actualWidth;
-	int actualHeight = frame.height();
+	int actualHeight = frame.height() - cropHeight(frame.width(), frame.height()) * 2;
 
 	if (!m_enableScaling) {
 		window.setWidth(frame.width());
@@ -166,9 +204,8 @@ QSize CaptureWin::scaleFrameSize(QSize window, QSize frame)
 void CaptureWin::setPixelAspectRatio(double ratio)
 {
 	m_pixelAspectRatio = ratio;
-	QResizeEvent *event = new QResizeEvent(QSize(width(), height()), QSize(width(), height()));
-	QCoreApplication::sendEvent(this, event);
-	delete event;
+	QResizeEvent event(QSize(width(), height()), QSize(width(), height()));
+	QCoreApplication::sendEvent(this, &event);
 }
 
 void CaptureWin::closeEvent(QCloseEvent *event)
diff --git a/utils/qv4l2/capture-win.h b/utils/qv4l2/capture-win.h
index e8f0ada..596da13 100644
--- a/utils/qv4l2/capture-win.h
+++ b/utils/qv4l2/capture-win.h
@@ -26,6 +26,15 @@
 #include <QShortcut>
 #include <QLabel>
 
+enum CropMethod {
+	QV4L2_CROP_NONE,
+	QV4L2_CROP_W149,
+	QV4L2_CROP_W169,
+	QV4L2_CROP_C185,
+	QV4L2_CROP_C239,
+	QV4L2_CROP_TB
+};
+
 class CaptureWin : public QWidget
 {
 	Q_OBJECT
@@ -35,6 +44,9 @@ public:
 	~CaptureWin();
 
 	void resize(int minw, int minh);
+	void enableScaling(bool enable);
+	void setPixelAspectRatio(double ratio);
+	void setCropMethod(CropMethod crop);
 
 	/**
 	 * @brief Set a frame into the capture window.
@@ -75,20 +87,66 @@ public:
 	 */
 	static bool isSupported() { return false; }
 
-	void enableScaling(bool enable);
-	void setPixelAspectRatio(double ratio);
+	/**
+	 * @brief Return the scaled size.
+	 *
+	 * Scales a frame to fit inside a given window. Preseves aspect ratio.
+	 *
+	 * @param window The window the frame shall scale into
+	 * @param frame The frame to scale
+	 * @return The scaledsizes to use for the frame
+	 */
 	static QSize scaleFrameSize(QSize window, QSize frame);
 
+	/**
+	 * @brief Get the number of pixels to crop.
+	 *
+	 * When cropping is applied this gives the number of pixels to
+	 * remove from top and bottom. To get total multiply the return
+	 * value by 2.
+	 *
+	 * @param width Frame width
+	 * @param height Frame height
+	 * @return The pixels to remove when cropping height
+	 *
+	 * @note The width and height must be original frame size
+	 *       to ensure that the cropping is done correctly.
+	 */
+	static int cropHeight(int width, int height);
+
+	/**
+	 * @brief Get the frame width when aspect ratio is applied.
+	 *
+	 * @param width The original frame width.
+	 * @return The width with aspect ratio correctio (scaling must be enabled).
+	 */
+	static int actualFrameWidth(int width);
+
 public slots:
 	void resetSize();
 
 protected:
 	void closeEvent(QCloseEvent *event);
-	void buildWindow(QWidget *videoSurface);
-	static int actualFrameWidth(int width);
+
+	/**
+	 * @brief Get the amout of space outside the video frame.
+	 *
+	 * The margins are that of the window that encloses the displaying
+	 * video frame. The sizes are total in both width and height.
+	 *
+	 * @return The margins around the video frame.
+	 */
 	QSize getMargins();
 
 	/**
+	 * @brief Creates the content of the window.
+	 *
+	 * Construct the new window layout and adds the video display surface.
+	 * @param videoSurface The widget that contains the renderer.
+	 */
+	void buildWindow(QWidget *videoSurface);
+
+	/**
 	 * @brief A label that can is used to display capture information.
 	 *
 	 * @note This must be set in the derived class' setFrame() function.
@@ -100,15 +158,12 @@ protected:
 	 */
 	static bool m_enableScaling;
 
-	/**
-	 * @note Aspect ratio it taken care of by scaling, frame size is for square pixels only!
-	 */
-	static double m_pixelAspectRatio;
-
 signals:
 	void close();
 
 private:
+	static double m_pixelAspectRatio;
+	static CropMethod m_cropMethod;
 	QShortcut *m_hotkeyClose;
 	QShortcut *m_hotkeyScaleReset;
 	int m_curWidth;
diff --git a/utils/qv4l2/general-tab.cpp b/utils/qv4l2/general-tab.cpp
index c404a3b..3855296 100644
--- a/utils/qv4l2/general-tab.cpp
+++ b/utils/qv4l2/general-tab.cpp
@@ -54,6 +54,7 @@ GeneralTab::GeneralTab(const QString &device, v4l2 &fd, int n, QWidget *parent)
 	m_qryStandard(NULL),
 	m_videoTimings(NULL),
 	m_pixelAspectRatio(NULL),
+	m_crop(NULL),
 	m_qryTimings(NULL),
 	m_freq(NULL),
 	m_vidCapFormats(NULL),
@@ -226,6 +227,18 @@ GeneralTab::GeneralTab(const QString &device, v4l2 &fd, int n, QWidget *parent)
 		addLabel("Pixel Aspect Ratio");
 		addWidget(m_pixelAspectRatio);
 		connect(m_pixelAspectRatio, SIGNAL(activated(int)), SLOT(changePixelAspectRatio()));
+
+		m_crop = new QComboBox(parent);
+		m_crop->addItem("None");
+		m_crop->addItem("Top and Bottom Line");
+		m_crop->addItem("Widescreen 14:9");
+		m_crop->addItem("Widescreen 16:9");
+		m_crop->addItem("Cinema 1.85:1");
+		m_crop->addItem("Cinema 2.39:1");
+
+		addLabel("Cropping");
+		addWidget(m_crop);
+		connect(m_crop, SIGNAL(activated(int)), SIGNAL(cropChanged()));
 	}
 
 	if (m_tuner.capability) {
@@ -1123,6 +1136,24 @@ void GeneralTab::updateFrameSize()
 	updateFrameInterval();
 }
 
+CropMethod GeneralTab::getCropMethod()
+{
+	switch (m_crop->currentIndex()) {
+	case 1:
+		return QV4L2_CROP_TB;
+	case 2:
+		return QV4L2_CROP_W149;
+	case 3:
+		return QV4L2_CROP_W169;
+	case 4:
+		return QV4L2_CROP_C185;
+	case 5:
+		return QV4L2_CROP_C239;
+	default:
+		return QV4L2_CROP_NONE;
+	}
+}
+
 void GeneralTab::changePixelAspectRatio()
 {
 	// Update hints by calling a get
@@ -1133,6 +1164,7 @@ void GeneralTab::changePixelAspectRatio()
 
 double GeneralTab::getPixelAspectRatio()
 {
+	double pixelRatio;
 	switch (m_pixelAspectRatio->currentIndex()) {
 	case 0:
 		v4l2_cropcap ratio;
@@ -1140,37 +1172,38 @@ double GeneralTab::getPixelAspectRatio()
 		if (ioctl(VIDIOC_CROPCAP, &ratio) < 0) {
 			m_pixelAspectRatio->setStatusTip("Pixel Aspect Ratio 1:1");
 			m_pixelAspectRatio->setWhatsThis("Pixel Aspect Ratio 1:1");
-			return 1.0;
+			pixelRatio = 1.0;
 		}
 
-		m_pixelAspectRatio->setStatusTip(QString("Pixel Aspect Ratio %1:%2")
-						 .arg(ratio.pixelaspect.denominator)
-						 .arg(ratio.pixelaspect.numerator));
 		m_pixelAspectRatio->setWhatsThis(QString("Pixel Aspect Ratio %1:%2")
 						 .arg(ratio.pixelaspect.denominator)
 						 .arg(ratio.pixelaspect.numerator));
-		return (double)ratio.pixelaspect.denominator / ratio.pixelaspect.numerator;
+		pixelRatio = (double)ratio.pixelaspect.denominator / ratio.pixelaspect.numerator;
+		break;
 	case 2:
-		m_pixelAspectRatio->setStatusTip("Pixel Aspect Ratio 10:11");
 		m_pixelAspectRatio->setWhatsThis("Pixel Aspect Ratio 10:11");
-		return 10.0 / 11.0;
+		pixelRatio = 10.0 / 11.0;
+		break;
 	case 3:
-		m_pixelAspectRatio->setStatusTip("Pixel Aspect Ratio 40:33");
 		m_pixelAspectRatio->setWhatsThis("Pixel Aspect Ratio 40:33");
-		return 40.0 / 33.0;
+		pixelRatio = 40.0 / 33.0;
+		break;
 	case 4:
-		m_pixelAspectRatio->setStatusTip("Pixel Aspect Ratio 12:11");
 		m_pixelAspectRatio->setWhatsThis("Pixel Aspect Ratio 12:11");
-		return 12.0 / 11.0;
+		pixelRatio = 12.0 / 11.0;
+		break;
 	case 5:
-		m_pixelAspectRatio->setStatusTip("Pixel Aspect Ratio 16:11");
 		m_pixelAspectRatio->setWhatsThis("Pixel Aspect Ratio 16:11");
-		return 16.0 / 11.0;
+		pixelRatio = 16.0 / 11.0;
+		break;
 	default:
-		m_pixelAspectRatio->setStatusTip("Pixel Aspect Ratio 1:1");
 		m_pixelAspectRatio->setWhatsThis("Pixel Aspect Ratio 1:1");
-		return 1.0;
+		pixelRatio = 1.0;
+		break;
 	}
+
+	m_pixelAspectRatio->setStatusTip(m_pixelAspectRatio->whatsThis());
+	return pixelRatio;
 }
 
 void GeneralTab::updateFrameInterval()
diff --git a/utils/qv4l2/general-tab.h b/utils/qv4l2/general-tab.h
index 4540e1f..6632046 100644
--- a/utils/qv4l2/general-tab.h
+++ b/utils/qv4l2/general-tab.h
@@ -27,8 +27,10 @@
 #include <sys/time.h>
 #include <linux/videodev2.h>
 #include <map>
+
 #include "qv4l2.h"
 #include "v4l2-api.h"
+#include "capture-win.h"
 
 #ifdef HAVE_ALSA
 extern "C" {
@@ -58,6 +60,7 @@ public:
 	int getAudioDeviceBufferSize();
 	bool hasAlsaAudio();
 	double getPixelAspectRatio();
+	CropMethod getCropMethod();
 	bool get_interval(struct v4l2_fract &interval);
 	int width() const { return m_width; }
 	int height() const { return m_height; }
@@ -92,6 +95,7 @@ public slots:
 signals:
 	void audioDeviceChanged();
 	void pixelAspectRatioChanged();
+	void cropChanged();
 
 private slots:
 	void inputChanged(int);
@@ -186,6 +190,7 @@ private:
 	QPushButton *m_qryStandard;
 	QComboBox *m_videoTimings;
 	QComboBox *m_pixelAspectRatio;
+	QComboBox *m_crop;
 	QPushButton *m_qryTimings;
 	QLineEdit *m_freq;
 	QComboBox *m_freqTable;
diff --git a/utils/qv4l2/qv4l2.cpp b/utils/qv4l2/qv4l2.cpp
index fa4c3d5..7e2dba0 100644
--- a/utils/qv4l2/qv4l2.cpp
+++ b/utils/qv4l2/qv4l2.cpp
@@ -230,6 +230,7 @@ void ApplicationWindow::setDevice(const QString &device, bool rawOpen)
 	}
 #endif
 	connect(m_genTab, SIGNAL(pixelAspectRatioChanged()), this, SLOT(updatePixelAspectRatio()));
+	connect(m_genTab, SIGNAL(cropChanged()), this, SLOT(updateCropping()));
 	m_tabs->addTab(w, "General");
 	addTabs();
 	if (caps() & (V4L2_CAP_VBI_CAPTURE | V4L2_CAP_SLICED_VBI_CAPTURE)) {
@@ -817,6 +818,12 @@ void ApplicationWindow::updatePixelAspectRatio()
 		m_capture->setPixelAspectRatio(m_genTab->getPixelAspectRatio());
 }
 
+void ApplicationWindow::updateCropping()
+{
+	if (m_capture != NULL)
+		m_capture->setCropMethod(m_genTab->getCropMethod());
+}
+
 void ApplicationWindow::startAudio()
 {
 #ifdef HAVE_ALSA
diff --git a/utils/qv4l2/qv4l2.h b/utils/qv4l2/qv4l2.h
index 970a0e1..b8cc3b8 100644
--- a/utils/qv4l2/qv4l2.h
+++ b/utils/qv4l2/qv4l2.h
@@ -134,6 +134,7 @@ private slots:
 	void setAudioBufferSize();
 	void enableScaling(bool enable);
 	void updatePixelAspectRatio();
+	void updateCropping();
 
 	void about();
 
-- 
1.8.4.rc1

