Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-4.cisco.com ([144.254.224.147]:23517 "EHLO
	ams-iport-4.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755385Ab3HEI5v (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 5 Aug 2013 04:57:51 -0400
Received: from bwinther.cisco.com (dhcp-10-54-92-49.cisco.com [10.54.92.49])
	by ams-core-4.cisco.com (8.14.5/8.14.5) with ESMTP id r758vY7i001512
	for <linux-media@vger.kernel.org>; Mon, 5 Aug 2013 08:57:48 GMT
From: =?UTF-8?q?B=C3=A5rd=20Eirik=20Winther?= <bwinther@cisco.com>
To: linux-media@vger.kernel.org
Subject: [RFC PATCH 7/7] qv4l2: add aspect ratio support
Date: Mon,  5 Aug 2013 10:56:57 +0200
Message-Id: <1f361d3a48848e8b4918666cf80e4745efab8c0d.1375692973.git.bwinther@cisco.com>
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
 utils/qv4l2/capture-win.cpp | 24 ++++++++++++++++++++++--
 utils/qv4l2/capture-win.h   |  8 +++++++-
 utils/qv4l2/general-tab.cpp | 36 ++++++++++++++++++++++++++++++++++++
 utils/qv4l2/general-tab.h   |  3 +++
 utils/qv4l2/qv4l2.cpp       | 22 +++++++++++++++-------
 utils/qv4l2/qv4l2.h         |  2 +-
 6 files changed, 84 insertions(+), 11 deletions(-)

diff --git a/utils/qv4l2/capture-win.cpp b/utils/qv4l2/capture-win.cpp
index 435c19b..415829a 100644
--- a/utils/qv4l2/capture-win.cpp
+++ b/utils/qv4l2/capture-win.cpp
@@ -30,6 +30,7 @@
 #define MIN_WIN_SIZE_HEIGHT 120
 
 bool CaptureWin::m_enableScaling = true;
+double CaptureWin::m_pixelAspectRatio = 1.0;
 
 CaptureWin::CaptureWin() :
 	m_curWidth(-1),
@@ -73,6 +74,14 @@ void CaptureWin::resetSize()
 	resize(w, h);
 }
 
+int CaptureWin::actualFrameWidth(int width)
+{
+	if (m_enableScaling)
+		return (int)((double)width * m_pixelAspectRatio);
+	else
+		return width;
+}
+
 QSize CaptureWin::getMargins()
 {
 	int l, t, r, b;
@@ -94,6 +103,14 @@ void CaptureWin::enableScaling(bool enable)
 	delete event;
 }
 
+void CaptureWin::setPixelAspectRatio(double ratio)
+{
+	m_pixelAspectRatio = ratio;
+	QResizeEvent *event = new QResizeEvent(QSize(width(), height()), QSize(width(), height()));
+	QCoreApplication::sendEvent(this, event);
+	delete event;
+}
+
 void CaptureWin::resize(int width, int height)
 {
 	// Dont resize window if the frame size is the same in
@@ -105,7 +122,7 @@ void CaptureWin::resize(int width, int height)
 	m_curHeight = height;
 
 	QSize margins = getMargins();
-	width += margins.width();
+	width = actualFrameWidth(width) + margins.width();
 	height += margins.height();
 
 	QDesktopWidget *screen = QApplication::desktop();
@@ -127,12 +144,15 @@ void CaptureWin::resize(int width, int height)
 
 QSize CaptureWin::scaleFrameSize(QSize window, QSize frame)
 {
-	int actualFrameWidth = frame.width();;
+	int actualFrameWidth;
 	int actualFrameHeight = frame.height();
 
 	if (!m_enableScaling) {
 		window.setWidth(frame.width());
 		window.setHeight(frame.height());
+		actualFrameWidth = frame.width();
+	} else {
+		actualFrameWidth = CaptureWin::actualFrameWidth(frame.width());
 	}
 
 	double newW, newH;
diff --git a/utils/qv4l2/capture-win.h b/utils/qv4l2/capture-win.h
index 1bfb1e1..eded9e0 100644
--- a/utils/qv4l2/capture-win.h
+++ b/utils/qv4l2/capture-win.h
@@ -76,9 +76,10 @@ public:
 	static bool isSupported() { return false; }
 
 	void enableScaling(bool enable);
+	void setPixelAspectRatio(double ratio);
 	static QSize scaleFrameSize(QSize window, QSize frame);
 
-public slots:
+	public slots:
 	void resetSize();
 
 protected:
@@ -99,6 +100,11 @@ protected:
 	 */
 	static bool m_enableScaling;
 
+	/**
+	 * @note Aspect ratio it taken care of by scaling, frame size is for square pixels only!
+	 */
+	static double m_pixelAspectRatio;
+
 signals:
 	void close();
 
diff --git a/utils/qv4l2/general-tab.cpp b/utils/qv4l2/general-tab.cpp
index 5996c03..53b7e36 100644
--- a/utils/qv4l2/general-tab.cpp
+++ b/utils/qv4l2/general-tab.cpp
@@ -53,6 +53,7 @@ GeneralTab::GeneralTab(const QString &device, v4l2 &fd, int n, QWidget *parent)
 	m_tvStandard(NULL),
 	m_qryStandard(NULL),
 	m_videoTimings(NULL),
+	m_pixelAspectRatio(NULL),
 	m_qryTimings(NULL),
 	m_freq(NULL),
 	m_vidCapFormats(NULL),
@@ -210,6 +211,20 @@ GeneralTab::GeneralTab(const QString &device, v4l2 &fd, int n, QWidget *parent)
 		connect(m_qryTimings, SIGNAL(clicked()), SLOT(qryTimingsClicked()));
 	}
 
+	if (!isRadio() && !isVbi()) {
+		m_pixelAspectRatio = new QComboBox(parent);
+		m_pixelAspectRatio->addItem("Autodetect");
+		m_pixelAspectRatio->addItem("Square");
+		m_pixelAspectRatio->addItem("NTSC/PAL-M/PAL-60");
+		m_pixelAspectRatio->addItem("NTSC/PAL-M/PAL-60, Anamorphic");
+		m_pixelAspectRatio->addItem("PAL/SECAM");
+		m_pixelAspectRatio->addItem("PAL/SECAM, Anamorphic");
+
+		addLabel("Pixel Aspect Ratio");
+		addWidget(m_pixelAspectRatio);
+		connect(m_pixelAspectRatio, SIGNAL(activated(int)), SIGNAL(pixelAspectRatioChanged()));
+	}
+
 	if (m_tuner.capability) {
 		QDoubleValidator *val;
 		double factor = (m_tuner.capability & V4L2_TUNER_CAP_LOW) ? 16 : 16000;
@@ -1105,6 +1120,27 @@ void GeneralTab::updateFrameSize()
 	updateFrameInterval();
 }
 
+double GeneralTab::getPixelAspectRatio()
+{
+	if (m_pixelAspectRatio->currentText().compare("Autodetect") == 0) {
+		v4l2_cropcap ratio;
+		ratio.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
+		if (ioctl(VIDIOC_CROPCAP, &ratio) < 0)
+			return 1.0;
+
+		return (double)ratio.pixelaspect.denominator / ratio.pixelaspect.numerator;
+	}
+	if (m_pixelAspectRatio->currentText().compare("NTSC/PAL-M/PAL-60") == 0)
+		return 10.0/11.0;
+	if (m_pixelAspectRatio->currentText().compare("NTSC/PAL-M/PAL-60, Anamorphic") == 0)
+		return 40.0/33.0;
+	if (m_pixelAspectRatio->currentText().compare("PAL/SECAM") == 0)
+		return 12.0/11.0;
+	if (m_pixelAspectRatio->currentText().compare("PAL/SECAM, Anamorphic") == 0)
+		return 16.0/11.0;
+	return 1.0;
+}
+
 void GeneralTab::updateFrameInterval()
 {
 	v4l2_frmivalenum frmival;
diff --git a/utils/qv4l2/general-tab.h b/utils/qv4l2/general-tab.h
index c83368a..73e7a88 100644
--- a/utils/qv4l2/general-tab.h
+++ b/utils/qv4l2/general-tab.h
@@ -55,6 +55,7 @@ public:
 	void setAudioDeviceBufferSize(int size);
 	int getAudioDeviceBufferSize();
 	bool hasAlsaAudio();
+	double getPixelAspectRatio();
 	bool get_interval(struct v4l2_fract &interval);
 	int width() const { return m_width; }
 	int height() const { return m_height; }
@@ -88,6 +89,7 @@ public slots:
 
 signals:
 	void audioDeviceChanged();
+	void pixelAspectRatioChanged();
 
 private slots:
 	void inputChanged(int);
@@ -180,6 +182,7 @@ private:
 	QComboBox *m_tvStandard;
 	QPushButton *m_qryStandard;
 	QComboBox *m_videoTimings;
+	QComboBox *m_pixelAspectRatio;
 	QPushButton *m_qryTimings;
 	QLineEdit *m_freq;
 	QComboBox *m_freqTable;
diff --git a/utils/qv4l2/qv4l2.cpp b/utils/qv4l2/qv4l2.cpp
index 92a415f..0ce3cd7 100644
--- a/utils/qv4l2/qv4l2.cpp
+++ b/utils/qv4l2/qv4l2.cpp
@@ -103,7 +103,7 @@ ApplicationWindow::ApplicationWindow() :
 	m_saveRawAct->setChecked(false);
 	connect(m_saveRawAct, SIGNAL(toggled(bool)), this, SLOT(saveRaw(bool)));
 
-	m_showFramesAct = new QAction(QIcon(":/video-television.png"), "Show &Frames", this);
+	m_showFramesAct = new QAction(QIcon(":/video-television.png"), "&Show Frames", this);
 	m_showFramesAct->setStatusTip("Only show captured frames if set.");
 	m_showFramesAct->setCheckable(true);
 	m_showFramesAct->setChecked(true);
@@ -137,12 +137,12 @@ ApplicationWindow::ApplicationWindow() :
 	toolBar->addSeparator();
 	toolBar->addAction(quitAct);
 
-	m_scalingAct = new QAction("Enable Video Scaling", this);
+	m_scalingAct = new QAction("&Enable Video Scaling", this);
 	m_scalingAct->setStatusTip("Scale video frames to match window size if set");
 	m_scalingAct->setCheckable(true);
 	m_scalingAct->setChecked(true);
 	connect(m_scalingAct, SIGNAL(toggled(bool)), this, SLOT(enableScaling(bool)));
-	m_resetScalingAct = new QAction("Resize to Frame Size", this);
+	m_resetScalingAct = new QAction("Resize to &Frame Size", this);
 	m_resetScalingAct->setStatusTip("Resizes the capture window to match frame size");
 	m_resetScalingAct->setShortcut(Qt::CTRL+Qt::Key_F);
 
@@ -169,13 +169,13 @@ ApplicationWindow::ApplicationWindow() :
 #ifdef ENABLE_ALSA
 	captureMenu->addSeparator();
 
-	m_showAllAudioAct = new QAction("Show All Audio Devices", this);
+	m_showAllAudioAct = new QAction("Show All Audio &Devices", this);
 	m_showAllAudioAct->setStatusTip("Show all audio input and output devices if set");
 	m_showAllAudioAct->setCheckable(true);
 	m_showAllAudioAct->setChecked(false);
 	captureMenu->addAction(m_showAllAudioAct);
 
-	m_audioBufferAct = new QAction("Set Audio Buffer Size...", this);
+	m_audioBufferAct = new QAction("Set Audio &Buffer Size...", this);
 	m_audioBufferAct->setStatusTip("Set audio buffer capacity in amout of ms than can be stored");
 	connect(m_audioBufferAct, SIGNAL(triggered()), this, SLOT(setAudioBufferSize()));
 	captureMenu->addAction(m_audioBufferAct);
@@ -216,8 +216,6 @@ void ApplicationWindow::setDevice(const QString &device, bool rawOpen)
 
 	newCaptureWin();
 
-	m_capture->setMinimumSize(150, 50);
-
 	QWidget *w = new QWidget(m_tabs);
 	m_genTab = new GeneralTab(device, *this, 4, w);
 
@@ -233,6 +231,7 @@ void ApplicationWindow::setDevice(const QString &device, bool rawOpen)
 	}
 #endif
 
+	connect(m_genTab, SIGNAL(pixelAspectRatioChanged()), this, SLOT(updatePixelAspectRatio()));
 	m_tabs->addTab(w, "General");
 	addTabs();
 	if (caps() & (V4L2_CAP_VBI_CAPTURE | V4L2_CAP_SLICED_VBI_CAPTURE)) {
@@ -363,6 +362,7 @@ void ApplicationWindow::newCaptureWin()
 		break;
 	}
 
+	m_capture->setPixelAspectRatio(1.0);
 	m_capture->enableScaling(m_scalingAct->isChecked());
         connect(m_capture, SIGNAL(close()), this, SLOT(closeCaptureWin()));
 	connect(m_resetScalingAct, SIGNAL(triggered()), m_capture, SLOT(resetSize()));
@@ -813,6 +813,12 @@ void ApplicationWindow::enableScaling(bool enable)
 		m_capture->enableScaling(enable);
 }
 
+void ApplicationWindow::updatePixelAspectRatio()
+{
+	if (m_capture != NULL && m_genTab != NULL)
+		m_capture->setPixelAspectRatio(m_genTab->getPixelAspectRatio());
+}
+
 void ApplicationWindow::startAudio()
 {
 #ifdef ENABLE_ALSA
@@ -894,6 +900,7 @@ void ApplicationWindow::capStart(bool start)
 		m_vbiTab->slicedFormat(fmt.fmt.sliced);
 		m_vbiSize = fmt.fmt.sliced.io_size;
 		m_frameData = new unsigned char[m_vbiSize];
+		updatePixelAspectRatio();
 		if (startCapture(m_vbiSize)) {
 			m_capNotifier = new QSocketNotifier(fd(), QSocketNotifier::Read, m_tabs);
 			connect(m_capNotifier, SIGNAL(activated(int)), this, SLOT(capVbiFrame()));
@@ -962,6 +969,7 @@ void ApplicationWindow::capStart(bool start)
 		m_capSrcFormat = copy;
 	}
 
+	updatePixelAspectRatio();
 	m_capture->resize(dstPix.width, dstPix.height);
 	m_capImage = new QImage(dstPix.width, dstPix.height, dstFmt);
 	m_capImage->fill(0);
diff --git a/utils/qv4l2/qv4l2.h b/utils/qv4l2/qv4l2.h
index 3704ab1..859113a 100644
--- a/utils/qv4l2/qv4l2.h
+++ b/utils/qv4l2/qv4l2.h
@@ -131,7 +131,7 @@ private slots:
 	void rejectedRawFile();
 	void setAudioBufferSize();
 	void enableScaling(bool enable);
-
+	void updatePixelAspectRatio();
 
 	void about();
 
-- 
1.8.3.2

