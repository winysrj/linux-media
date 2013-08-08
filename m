Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-1.cisco.com ([144.254.224.140]:20237 "EHLO
	ams-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934234Ab3HHMcA (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 8 Aug 2013 08:32:00 -0400
Received: from bwinther.cisco.com (dhcp-10-54-92-90.cisco.com [10.54.92.90])
	by ams-core-2.cisco.com (8.14.5/8.14.5) with ESMTP id r78CVcjf014622
	for <linux-media@vger.kernel.org>; Thu, 8 Aug 2013 12:31:56 GMT
From: =?UTF-8?q?B=C3=A5rd=20Eirik=20Winther?= <bwinther@cisco.com>
To: linux-media@vger.kernel.org
Subject: [PATCHv2 9/9] qv4l2: add pixel aspect ratio support for CaptureWin
Date: Thu,  8 Aug 2013 14:31:27 +0200
Message-Id: <0a5b1843424fa14c0ec30b8ed86da271f752101b.1375964980.git.bwinther@cisco.com>
In-Reply-To: <1375965087-16318-1-git-send-email-bwinther@cisco.com>
References: <1375965087-16318-1-git-send-email-bwinther@cisco.com>
In-Reply-To: <cdb6d3a353ce89599cd716e763e85e704b92f79c.1375964980.git.bwinther@cisco.com>
References: <cdb6d3a353ce89599cd716e763e85e704b92f79c.1375964980.git.bwinther@cisco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Bård Eirik Winther <bwinther@cisco.com>
---
 utils/qv4l2/capture-win.cpp | 36 ++++++++++++++++++------
 utils/qv4l2/capture-win.h   |  6 ++++
 utils/qv4l2/general-tab.cpp | 68 +++++++++++++++++++++++++++++++++++++++++++++
 utils/qv4l2/general-tab.h   |  4 +++
 utils/qv4l2/qv4l2.cpp       | 22 +++++++++++----
 utils/qv4l2/qv4l2.h         |  1 +
 6 files changed, 123 insertions(+), 14 deletions(-)

diff --git a/utils/qv4l2/capture-win.cpp b/utils/qv4l2/capture-win.cpp
index 3abb6cb..7538756 100644
--- a/utils/qv4l2/capture-win.cpp
+++ b/utils/qv4l2/capture-win.cpp
@@ -30,6 +30,7 @@
 #define MIN_WIN_SIZE_HEIGHT 120
 
 bool CaptureWin::m_enableScaling = true;
+double CaptureWin::m_pixelAspectRatio = 1.0;
 
 CaptureWin::CaptureWin() :
 	m_curWidth(-1),
@@ -76,6 +77,14 @@ void CaptureWin::resetSize()
 	resize(w, h);
 }
 
+int CaptureWin::actualFrameWidth(int width)
+{
+	if (m_enableScaling)
+		return (int)((double)width * m_pixelAspectRatio);
+
+	return width;
+}
+
 QSize CaptureWin::getMargins()
 {
 	int l, t, r, b;
@@ -108,7 +117,7 @@ void CaptureWin::resize(int width, int height)
 	m_curHeight = height;
 
 	QSize margins = getMargins();
-	width += margins.width();
+	width = actualFrameWidth(width) + margins.width();
 	height += margins.height();
 
 	QDesktopWidget *screen = QApplication::desktop();
@@ -130,25 +139,36 @@ void CaptureWin::resize(int width, int height)
 
 QSize CaptureWin::scaleFrameSize(QSize window, QSize frame)
 {
-	int actualFrameWidth = frame.width();;
-	int actualFrameHeight = frame.height();
+	int actualWidth;
+	int actualHeight = frame.height();
 
 	if (!m_enableScaling) {
 		window.setWidth(frame.width());
 		window.setHeight(frame.height());
+		actualWidth = frame.width();
+	} else {
+		actualWidth = CaptureWin::actualFrameWidth(frame.width());
 	}
 
 	double newW, newH;
 	if (window.width() >= window.height()) {
-		newW = (double)window.width() / actualFrameWidth;
-		newH = (double)window.height() / actualFrameHeight;
+		newW = (double)window.width() / actualWidth;
+		newH = (double)window.height() / actualHeight;
 	} else {
-		newH = (double)window.width() / actualFrameWidth;
-		newW = (double)window.height() / actualFrameHeight;
+		newH = (double)window.width() / actualWidth;
+		newW = (double)window.height() / actualHeight;
 	}
 	double resized = std::min(newW, newH);
 
-	return QSize((int)(actualFrameWidth * resized), (int)(actualFrameHeight * resized));
+	return QSize((int)(actualWidth * resized), (int)(actualHeight * resized));
+}
+
+void CaptureWin::setPixelAspectRatio(double ratio)
+{
+	m_pixelAspectRatio = ratio;
+	QResizeEvent *event = new QResizeEvent(QSize(width(), height()), QSize(width(), height()));
+	QCoreApplication::sendEvent(this, event);
+	delete event;
 }
 
 void CaptureWin::closeEvent(QCloseEvent *event)
diff --git a/utils/qv4l2/capture-win.h b/utils/qv4l2/capture-win.h
index 1bfb1e1..e8f0ada 100644
--- a/utils/qv4l2/capture-win.h
+++ b/utils/qv4l2/capture-win.h
@@ -76,6 +76,7 @@ public:
 	static bool isSupported() { return false; }
 
 	void enableScaling(bool enable);
+	void setPixelAspectRatio(double ratio);
 	static QSize scaleFrameSize(QSize window, QSize frame);
 
 public slots:
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
index 5cfaf07..c404a3b 100644
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
@@ -210,6 +211,23 @@ GeneralTab::GeneralTab(const QString &device, v4l2 &fd, int n, QWidget *parent)
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
+		// Update hints by calling a get
+		getPixelAspectRatio();
+
+		addLabel("Pixel Aspect Ratio");
+		addWidget(m_pixelAspectRatio);
+		connect(m_pixelAspectRatio, SIGNAL(activated(int)), SLOT(changePixelAspectRatio()));
+	}
+
 	if (m_tuner.capability) {
 		QDoubleValidator *val;
 		double factor = (m_tuner.capability & V4L2_TUNER_CAP_LOW) ? 16 : 16000;
@@ -1105,6 +1123,56 @@ void GeneralTab::updateFrameSize()
 	updateFrameInterval();
 }
 
+void GeneralTab::changePixelAspectRatio()
+{
+	// Update hints by calling a get
+	getPixelAspectRatio();
+	info("");
+	emit pixelAspectRatioChanged();
+}
+
+double GeneralTab::getPixelAspectRatio()
+{
+	switch (m_pixelAspectRatio->currentIndex()) {
+	case 0:
+		v4l2_cropcap ratio;
+		ratio.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
+		if (ioctl(VIDIOC_CROPCAP, &ratio) < 0) {
+			m_pixelAspectRatio->setStatusTip("Pixel Aspect Ratio 1:1");
+			m_pixelAspectRatio->setWhatsThis("Pixel Aspect Ratio 1:1");
+			return 1.0;
+		}
+
+		m_pixelAspectRatio->setStatusTip(QString("Pixel Aspect Ratio %1:%2")
+						 .arg(ratio.pixelaspect.denominator)
+						 .arg(ratio.pixelaspect.numerator));
+		m_pixelAspectRatio->setWhatsThis(QString("Pixel Aspect Ratio %1:%2")
+						 .arg(ratio.pixelaspect.denominator)
+						 .arg(ratio.pixelaspect.numerator));
+		return (double)ratio.pixelaspect.denominator / ratio.pixelaspect.numerator;
+	case 2:
+		m_pixelAspectRatio->setStatusTip("Pixel Aspect Ratio 10:11");
+		m_pixelAspectRatio->setWhatsThis("Pixel Aspect Ratio 10:11");
+		return 10.0 / 11.0;
+	case 3:
+		m_pixelAspectRatio->setStatusTip("Pixel Aspect Ratio 40:33");
+		m_pixelAspectRatio->setWhatsThis("Pixel Aspect Ratio 40:33");
+		return 40.0 / 33.0;
+	case 4:
+		m_pixelAspectRatio->setStatusTip("Pixel Aspect Ratio 12:11");
+		m_pixelAspectRatio->setWhatsThis("Pixel Aspect Ratio 12:11");
+		return 12.0 / 11.0;
+	case 5:
+		m_pixelAspectRatio->setStatusTip("Pixel Aspect Ratio 16:11");
+		m_pixelAspectRatio->setWhatsThis("Pixel Aspect Ratio 16:11");
+		return 16.0 / 11.0;
+	default:
+		m_pixelAspectRatio->setStatusTip("Pixel Aspect Ratio 1:1");
+		m_pixelAspectRatio->setWhatsThis("Pixel Aspect Ratio 1:1");
+		return 1.0;
+	}
+}
+
 void GeneralTab::updateFrameInterval()
 {
 	v4l2_frmivalenum frmival;
diff --git a/utils/qv4l2/general-tab.h b/utils/qv4l2/general-tab.h
index 6c51016..4540e1f 100644
--- a/utils/qv4l2/general-tab.h
+++ b/utils/qv4l2/general-tab.h
@@ -57,6 +57,7 @@ public:
 	void setAudioDeviceBufferSize(int size);
 	int getAudioDeviceBufferSize();
 	bool hasAlsaAudio();
+	double getPixelAspectRatio();
 	bool get_interval(struct v4l2_fract &interval);
 	int width() const { return m_width; }
 	int height() const { return m_height; }
@@ -90,6 +91,7 @@ public slots:
 
 signals:
 	void audioDeviceChanged();
+	void pixelAspectRatioChanged();
 
 private slots:
 	void inputChanged(int);
@@ -115,6 +117,7 @@ private slots:
 	void vidOutFormatChanged(int);
 	void vbiMethodsChanged(int);
 	void changeAudioDevice();
+	void changePixelAspectRatio();
 
 private:
 	void updateVideoInput();
@@ -182,6 +185,7 @@ private:
 	QComboBox *m_tvStandard;
 	QPushButton *m_qryStandard;
 	QComboBox *m_videoTimings;
+	QComboBox *m_pixelAspectRatio;
 	QPushButton *m_qryTimings;
 	QLineEdit *m_freq;
 	QComboBox *m_freqTable;
diff --git a/utils/qv4l2/qv4l2.cpp b/utils/qv4l2/qv4l2.cpp
index 7be9f1a..fa4c3d5 100644
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
 
@@ -168,13 +168,13 @@ ApplicationWindow::ApplicationWindow() :
 #ifdef HAVE_ALSA
 	captureMenu->addSeparator();
 
-	m_showAllAudioAct = new QAction("Show All Audio Devices", this);
+	m_showAllAudioAct = new QAction("Show All Audio &Devices", this);
 	m_showAllAudioAct->setStatusTip("Show all audio input and output devices if set");
 	m_showAllAudioAct->setCheckable(true);
 	m_showAllAudioAct->setChecked(false);
 	captureMenu->addAction(m_showAllAudioAct);
 
-	m_audioBufferAct = new QAction("Set Audio Buffer Capacity...", this);
+	m_audioBufferAct = new QAction("Set Audio &Buffer Capacity...", this);
 	m_audioBufferAct->setStatusTip("Set audio buffer capacity in amout of ms than can be stored");
 	connect(m_audioBufferAct, SIGNAL(triggered()), this, SLOT(setAudioBufferSize()));
 	captureMenu->addAction(m_audioBufferAct);
@@ -229,7 +229,7 @@ void ApplicationWindow::setDevice(const QString &device, bool rawOpen)
 		m_audioBufferAct->setEnabled(false);
 	}
 #endif
-
+	connect(m_genTab, SIGNAL(pixelAspectRatioChanged()), this, SLOT(updatePixelAspectRatio()));
 	m_tabs->addTab(w, "General");
 	addTabs();
 	if (caps() & (V4L2_CAP_VBI_CAPTURE | V4L2_CAP_SLICED_VBI_CAPTURE)) {
@@ -360,6 +360,7 @@ void ApplicationWindow::newCaptureWin()
 		break;
 	}
 
+	m_capture->setPixelAspectRatio(1.0);
 	m_capture->enableScaling(m_scalingAct->isChecked());
         connect(m_capture, SIGNAL(close()), this, SLOT(closeCaptureWin()));
 	connect(m_resetScalingAct, SIGNAL(triggered()), m_capture, SLOT(resetSize()));
@@ -810,6 +811,12 @@ void ApplicationWindow::enableScaling(bool enable)
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
 #ifdef HAVE_ALSA
@@ -891,6 +898,7 @@ void ApplicationWindow::capStart(bool start)
 		m_vbiTab->slicedFormat(fmt.fmt.sliced);
 		m_vbiSize = fmt.fmt.sliced.io_size;
 		m_frameData = new unsigned char[m_vbiSize];
+		updatePixelAspectRatio();
 		if (startCapture(m_vbiSize)) {
 			m_capNotifier = new QSocketNotifier(fd(), QSocketNotifier::Read, m_tabs);
 			connect(m_capNotifier, SIGNAL(activated(int)), this, SLOT(capVbiFrame()));
@@ -964,6 +972,8 @@ void ApplicationWindow::capStart(bool start)
 		dstFmt = QImage::Format_ARGB32;
 	m_capImage = new QImage(dstPix.width, dstPix.height, dstFmt);
 	m_capImage->fill(0);
+	
+	updatePixelAspectRatio();
 	m_capture->resize(dstPix.width, dstPix.height);
 	
 	if (showFrames()) {
diff --git a/utils/qv4l2/qv4l2.h b/utils/qv4l2/qv4l2.h
index 179cecb..970a0e1 100644
--- a/utils/qv4l2/qv4l2.h
+++ b/utils/qv4l2/qv4l2.h
@@ -133,6 +133,7 @@ private slots:
 	void rejectedRawFile();
 	void setAudioBufferSize();
 	void enableScaling(bool enable);
+	void updatePixelAspectRatio();
 
 	void about();
 
-- 
1.8.4.rc1

