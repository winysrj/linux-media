Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-2.cisco.com ([144.254.224.141]:6998 "EHLO
	ams-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751821Ab3HBMGD (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 2 Aug 2013 08:06:03 -0400
Received: from bwinther.cisco.com (dhcp-10-54-92-49.cisco.com [10.54.92.49])
	by ams-core-3.cisco.com (8.14.5/8.14.5) with ESMTP id r72C5nZA017931
	for <linux-media@vger.kernel.org>; Fri, 2 Aug 2013 12:05:59 GMT
From: =?UTF-8?q?B=C3=A5rd=20Eirik=20Winther?= <bwinther@cisco.com>
To: linux-media@vger.kernel.org
Subject: [PATCH 5/5] qv4l2: add ALSA audio playback
Date: Fri,  2 Aug 2013 14:05:37 +0200
Message-Id: <93cc539727d0caff1010e875d3c6065a435b7a2e.1375445112.git.bwinther@cisco.com>
In-Reply-To: <1375445137-19443-1-git-send-email-bwinther@cisco.com>
References: <1375445137-19443-1-git-send-email-bwinther@cisco.com>
In-Reply-To: <1a734456df06299e284f793264ca843c98b0f18a.1375445112.git.bwinther@cisco.com>
References: <1a734456df06299e284f793264ca843c98b0f18a.1375445112.git.bwinther@cisco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The qv4l2 test utility now supports ALSA playback of audio.
This allows for PCM playback during capture for supported devices.

Signed-off-by: Bård Eirik Winther <bwinther@cisco.com>
---
 utils/qv4l2/general-tab.cpp | 296 +++++++++++++++++++++++++++++++++++++++++++-
 utils/qv4l2/general-tab.h   |  36 ++++++
 utils/qv4l2/qv4l2.cpp       | 143 ++++++++++++++++++++-
 utils/qv4l2/qv4l2.h         |   7 ++
 4 files changed, 478 insertions(+), 4 deletions(-)

diff --git a/utils/qv4l2/general-tab.cpp b/utils/qv4l2/general-tab.cpp
index 10b14ca..5996c03 100644
--- a/utils/qv4l2/general-tab.cpp
+++ b/utils/qv4l2/general-tab.cpp
@@ -30,6 +30,16 @@
 
 #include <stdio.h>
 #include <errno.h>
+#include <QRegExp>
+
+bool GeneralTab::m_fullAudioName = false;
+
+enum audioDeviceAdd {
+	AUDIO_ADD_NO,
+	AUDIO_ADD_READ,
+	AUDIO_ADD_WRITE,
+	AUDIO_ADD_READWRITE
+};
 
 GeneralTab::GeneralTab(const QString &device, v4l2 &fd, int n, QWidget *parent) :
 	QGridLayout(parent),
@@ -48,12 +58,16 @@ GeneralTab::GeneralTab(const QString &device, v4l2 &fd, int n, QWidget *parent)
 	m_vidCapFormats(NULL),
 	m_frameSize(NULL),
 	m_vidOutFormats(NULL),
-	m_vbiMethods(NULL)
+	m_vbiMethods(NULL),
+	m_audioInDevice(NULL),
+	m_audioOutDevice(NULL)
 {
+	m_device.append(device);
 	setSpacing(3);
 
 	setSizeConstraint(QLayout::SetMinimumSize);
 
+
 	if (querycap(m_querycap)) {
 		addLabel("Device:");
 		addLabel(device + (useWrapper() ? " (wrapped)" : ""), Qt::AlignLeft);
@@ -132,6 +146,42 @@ GeneralTab::GeneralTab(const QString &device, v4l2 &fd, int n, QWidget *parent)
 		updateAudioOutput();
 	}
 
+	if (hasAlsaAudio()) {
+		m_audioInDevice = new QComboBox(parent);
+		m_audioOutDevice = new QComboBox(parent);
+		m_audioInDevice->setSizeAdjustPolicy(QComboBox::AdjustToContents);
+		m_audioOutDevice->setSizeAdjustPolicy(QComboBox::AdjustToContents);
+
+		if (createAudioDeviceList()) {
+			addLabel("Audio Input Device");
+			connect(m_audioInDevice, SIGNAL(activated(int)), SLOT(changeAudioDevice()));
+			addWidget(m_audioInDevice);
+
+			addLabel("Audio Output Device");
+			connect(m_audioOutDevice, SIGNAL(activated(int)), SLOT(changeAudioDevice()));
+			addWidget(m_audioOutDevice);
+
+			if (isRadio()) {
+				setAudioDeviceBufferSize(75);
+			} else {
+				v4l2_fract fract;
+				if (!v4l2::get_interval(fract)) {
+					// Default values are for 30 FPS
+					fract.numerator = 33;
+					fract.denominator = 1000;
+				}
+				// Standard capacity is two frames
+				setAudioDeviceBufferSize((fract.numerator * 2000) / fract.denominator);
+			}
+		} else {
+			fprintf(stderr, "BANNA\n");
+			delete m_audioInDevice;
+			delete m_audioOutDevice;
+			m_audioInDevice = NULL;
+			m_audioOutDevice = NULL;
+		}
+	}
+
 	if (needsStd) {
 		v4l2_std_id tmp;
 
@@ -370,6 +420,180 @@ done:
 	setRowStretch(rowCount() - 1, 1);
 }
 
+void GeneralTab::showAllAudioDevices(bool use)
+{
+	QString oldIn(m_audioInDevice->currentText());
+	QString oldOut(m_audioOutDevice->currentText());
+
+	m_fullAudioName = use;
+	if (oldIn == NULL || oldOut == NULL || !createAudioDeviceList())
+		return;
+
+	// Select a similar device as before the listings method change
+	// check by comparing old selection with any matching in the new list
+	bool setIn = false, setOut = false;
+	int listSize = std::max(m_audioInDevice->count(), m_audioOutDevice->count());
+
+	for (int i = 0; i < listSize; i++) {
+		QString oldInCmp(oldIn.left(std::min(m_audioInDevice->itemText(i).length(), oldIn.length())));
+		QString oldOutCmp(oldOut.left(std::min(m_audioOutDevice->itemText(i).length(), oldOut.length())));
+
+		if (!setIn && i < m_audioInDevice->count()
+		    && m_audioInDevice->itemText(i).startsWith(oldInCmp)) {
+			setIn = true;
+			m_audioInDevice->setCurrentIndex(i);
+		}
+
+		if (!setOut && i < m_audioOutDevice->count()
+		    && m_audioOutDevice->itemText(i).startsWith(oldOutCmp)) {
+			setOut = true;
+			m_audioOutDevice->setCurrentIndex(i);
+		}
+	}
+}
+
+bool GeneralTab::filterAudioInDevice(QString &deviceName)
+{
+	// Removes S/PDIF, front speakers and surround from input devices
+	// as they are output devices, not input
+	if (deviceName.contains("surround")
+	    || deviceName.contains("front")
+	    || deviceName.contains("iec958"))
+		return false;
+
+	// Removes sysdefault too if not full audio mode listings
+	if (!m_fullAudioName && deviceName.contains("sysdefault"))
+		return false;
+
+	return true;
+}
+
+bool GeneralTab::filterAudioOutDevice(QString &deviceName)
+{
+	// Removes advanced options if not full audio mode listings
+	if (!m_fullAudioName && (deviceName.contains("surround")
+				 || deviceName.contains("front")
+				 || deviceName.contains("iec958")
+				 || deviceName.contains("sysdefault"))) {
+		return false;
+	}
+
+	return true;
+}
+
+int GeneralTab::addAudioDevice(void *hint, int deviceNum)
+{
+	int added = 0;
+#ifdef ENABLE_ALSA
+	char *name;
+	char *iotype;
+	QString deviceName;
+	QString listName;
+	QStringList deviceType;
+	iotype = snd_device_name_get_hint(hint, "IOID");
+	name = snd_device_name_get_hint(hint, "NAME");
+	deviceName.append(name);
+
+	snd_card_get_name(deviceNum, &name);
+	listName.append(name);
+
+	deviceType = deviceName.split(":");
+
+	// Add device io capability to list name
+	if (m_fullAudioName) {
+		listName.append(" ");
+
+		// Makes the surround name more readable
+		if (deviceName.contains("surround"))
+			listName.append(QString("surround %1.%2")
+					.arg(deviceType.value(0)[8]).arg(deviceType.value(0)[9]));
+		else
+			listName.append(deviceType.value(0));
+
+	} else if (!deviceType.value(0).contains("default")) {
+		listName.append(" ").append(deviceType.value(0));
+	}
+
+	// Add device number if it is not 0
+	if (deviceName.contains("DEV=")) {
+		int devNo;
+		QStringList deviceNo = deviceName.split("DEV=");
+		devNo = deviceNo.value(1).toInt();
+		if (devNo)
+			listName.append(QString(" %1").arg(devNo));
+	}
+
+	if ((iotype == NULL || strncmp(iotype, "Input", 5) == 0) && filterAudioInDevice(deviceName)) {
+		m_audioInDevice->addItem(listName);
+		m_audioInDeviceMap[listName] = snd_device_name_get_hint(hint, "NAME");
+		added += AUDIO_ADD_READ;
+	}
+
+	if ((iotype == NULL || strncmp(iotype, "Output", 6) == 0)  && filterAudioOutDevice(deviceName)) {
+		m_audioOutDevice->addItem(listName);
+		m_audioOutDeviceMap[listName] = snd_device_name_get_hint(hint, "NAME");
+		added += AUDIO_ADD_WRITE;
+	}
+#endif
+	return added;
+}
+
+bool GeneralTab::createAudioDeviceList()
+{
+#ifdef ENABLE_ALSA
+	if (m_audioInDevice == NULL || m_audioOutDevice == NULL)
+		return false;
+
+	m_audioInDevice->clear();
+	m_audioOutDevice->clear();
+	m_audioInDeviceMap.clear();
+	m_audioOutDeviceMap.clear();
+
+	m_audioInDevice->addItem("None");
+	m_audioOutDevice->addItem("Default");
+	m_audioInDeviceMap["None"] = "None";
+	m_audioOutDeviceMap["Default"] = "default";
+
+	int deviceNum = -1;
+	int audioDevices = 0;
+	int matchDevice = matchAudioDevice();
+	int indexDevice = -1;
+	int indexCount = 0;
+
+	while (snd_card_next(&deviceNum) >= 0) {
+		if (deviceNum == -1)
+			break;
+
+		audioDevices++;
+		if (deviceNum == matchDevice && indexDevice == -1)
+			indexDevice = indexCount;
+
+		void **hint;
+
+		snd_device_name_hint(deviceNum, "pcm", &hint);
+		for (int i = 0; hint[i] != NULL; i++) {
+			int addAs = addAudioDevice(hint[i], deviceNum);
+			if (addAs == AUDIO_ADD_READ || addAs == AUDIO_ADD_READWRITE)
+				indexCount++;
+		}
+		snd_device_name_free_hint(hint);
+	}
+
+	snd_config_update_free_global();
+	m_audioInDevice->setCurrentIndex(indexDevice + 1);
+	changeAudioDevice();
+	return m_audioInDeviceMap.size() > 1 && m_audioOutDeviceMap.size() > 1 && audioDevices > 1;
+#else
+	return false;
+#endif
+}
+
+void GeneralTab::changeAudioDevice()
+{
+	m_audioOutDevice->setEnabled(getAudioInDevice() != NULL ? getAudioInDevice().compare("None") : false);
+	emit audioDeviceChanged();
+}
+
 void GeneralTab::addWidget(QWidget *w, Qt::Alignment align)
 {
 	QGridLayout::addWidget(w, m_row, m_col, align | Qt::AlignVCenter);
@@ -932,3 +1156,73 @@ bool GeneralTab::get_interval(struct v4l2_fract &interval)
 
 	return m_has_interval;
 }
+
+QString GeneralTab::getAudioInDevice()
+{
+	if (m_audioInDevice == NULL)
+		return NULL;
+
+	return m_audioInDeviceMap[m_audioInDevice->currentText()];
+}
+
+QString GeneralTab::getAudioOutDevice()
+{
+	if (m_audioOutDevice == NULL)
+		return NULL;
+
+	return m_audioOutDeviceMap[m_audioOutDevice->currentText()];
+}
+
+void GeneralTab::setAudioDeviceBufferSize(int size)
+{
+	m_audioDeviceBufferSize = size;
+}
+
+int GeneralTab::getAudioDeviceBufferSize()
+{
+	return m_audioDeviceBufferSize;
+}
+
+#ifdef ENABLE_ALSA
+int GeneralTab::checkMatchAudioDevice(void *md, const char *vid, const enum device_type type)
+{
+	const char *devname = NULL;
+
+	while ((devname = get_associated_device(md, devname, type, vid, MEDIA_V4L_VIDEO)) != NULL) {
+		if (type == MEDIA_SND_CAP) {
+			QStringList devAddr = QString(devname).split(QRegExp("[:,]"));
+			return devAddr.value(1).toInt();
+		}
+	}
+	return -1;
+}
+
+int GeneralTab::matchAudioDevice()
+{
+	QStringList devPath = m_device.split("/");
+	QString curDev = devPath.value(devPath.count() - 1);
+
+	void *media;
+	const char *video = NULL;
+	int match;
+
+	media = discover_media_devices();
+
+	while ((video = get_associated_device(media, video, MEDIA_V4L_VIDEO, NULL, NONE)) != NULL)
+		if (curDev.compare(video) == 0)
+			for (int i = 0; i <= MEDIA_SND_HW; i++)
+				if ((match = checkMatchAudioDevice(media, video, static_cast<device_type>(i))) != -1)
+					return match;
+
+	return -1;
+}
+#endif
+
+bool GeneralTab::hasAlsaAudio()
+{
+#ifdef ENABLE_ALSA
+	return !isVbi();
+#else
+	return false;
+#endif
+}
diff --git a/utils/qv4l2/general-tab.h b/utils/qv4l2/general-tab.h
index 5903ed8..c83368a 100644
--- a/utils/qv4l2/general-tab.h
+++ b/utils/qv4l2/general-tab.h
@@ -24,9 +24,18 @@
 #include <QSpinBox>
 #include <sys/time.h>
 #include <linux/videodev2.h>
+#include <map>
 #include "qv4l2.h"
 #include "v4l2-api.h"
 
+#ifdef ENABLE_ALSA
+extern "C" {
+#include "../libmedia_dev/get_media_devices.h"
+#include "alsa_stream.h"
+}
+#include <alsa/asoundlib.h>
+#endif
+
 class QComboBox;
 class QCheckBox;
 class QSpinBox;
@@ -41,6 +50,11 @@ public:
 	virtual ~GeneralTab() {}
 
 	CapMethod capMethod();
+	QString getAudioInDevice();
+	QString getAudioOutDevice();
+	void setAudioDeviceBufferSize(int size);
+	int getAudioDeviceBufferSize();
+	bool hasAlsaAudio();
 	bool get_interval(struct v4l2_fract &interval);
 	int width() const { return m_width; }
 	int height() const { return m_height; }
@@ -69,6 +83,12 @@ public:
 	inline bool streamon() { return v4l2::streamon(m_buftype); }
 	inline bool streamoff() { return v4l2::streamoff(m_buftype); }
 
+public slots:
+	void showAllAudioDevices(bool use);
+
+signals:
+	void audioDeviceChanged();
+
 private slots:
 	void inputChanged(int);
 	void outputChanged(int);
@@ -92,6 +112,7 @@ private slots:
 	void frameIntervalChanged(int);
 	void vidOutFormatChanged(int);
 	void vbiMethodsChanged(int);
+	void changeAudioDevice();
 
 private:
 	void updateVideoInput();
@@ -108,6 +129,14 @@ private:
 	void updateFrameSize();
 	void updateFrameInterval();
 	void updateVidOutFormat();
+	int addAudioDevice(void *hint, int deviceNum);
+	bool filterAudioInDevice(QString &deviceName);
+	bool filterAudioOutDevice(QString &deviceName);
+	bool createAudioDeviceList();
+#ifdef ENABLE_ALSA
+	int matchAudioDevice();
+	int checkMatchAudioDevice(void *md, const char *vid, const enum device_type type);
+#endif
 
 	void addWidget(QWidget *w, Qt::Alignment align = Qt::AlignLeft);
 	void addLabel(const QString &text, Qt::Alignment align = Qt::AlignRight)
@@ -130,6 +159,7 @@ private:
 	bool m_isVbi;
 	__u32 m_buftype;
 	__u32 m_audioModes[5];
+	QString m_device;
 	struct v4l2_tuner m_tuner;
 	struct v4l2_modulator m_modulator;
 	struct v4l2_capability m_querycap;
@@ -137,6 +167,10 @@ private:
 	__u32 m_width, m_height;
 	struct v4l2_fract m_interval;
 	bool m_has_interval;
+	int m_audioDeviceBufferSize;
+	static bool m_fullAudioName;
+	std::map<QString, QString> m_audioInDeviceMap;
+	std::map<QString, QString> m_audioOutDeviceMap;
 
 	// General tab
 	QComboBox *m_videoInput;
@@ -163,6 +197,8 @@ private:
 	QComboBox *m_vidOutFormats;
 	QComboBox *m_capMethods;
 	QComboBox *m_vbiMethods;
+	QComboBox *m_audioInDevice;
+	QComboBox *m_audioOutDevice;
 };
 
 #endif
diff --git a/utils/qv4l2/qv4l2.cpp b/utils/qv4l2/qv4l2.cpp
index 275b399..e078e91 100644
--- a/utils/qv4l2/qv4l2.cpp
+++ b/utils/qv4l2/qv4l2.cpp
@@ -24,6 +24,12 @@
 #include "capture-win-qt.h"
 #include "capture-win-gl.h"
 
+#ifdef ENABLE_ASLA
+extern "C" {
+#include "alsa_stream.h"
+}
+#endif
+
 #include <QToolBar>
 #include <QToolButton>
 #include <QMenuBar>
@@ -45,15 +51,18 @@
 #include <QWhatsThis>
 #include <QThread>
 #include <QCloseEvent>
+#include <QInputDialog>
 
 #include <assert.h>
 #include <sys/mman.h>
+#include <sys/time.h>
 #include <errno.h>
 #include <dirent.h>
 #include <libv4l2.h>
 
 ApplicationWindow::ApplicationWindow() :
 	m_capture(NULL),
+	m_genTab(NULL),
 	m_sigMapper(NULL)
 {
 	setAttribute(Qt::WA_DeleteOnClose, true);
@@ -76,7 +85,7 @@ ApplicationWindow::ApplicationWindow() :
 	openRawAct->setShortcut(Qt::CTRL+Qt::Key_R);
 	connect(openRawAct, SIGNAL(triggered()), this, SLOT(openrawdev()));
 
-	m_capStartAct = new QAction(QIcon(":/record.png"), "&Start Capturing", this);
+	m_capStartAct = new QAction(QIcon(":/record.png"), "Start &Capturing", this);
 	m_capStartAct->setStatusTip("Start capturing");
 	m_capStartAct->setCheckable(true);
 	m_capStartAct->setDisabled(true);
@@ -145,6 +154,21 @@ ApplicationWindow::ApplicationWindow() :
 		m_renderMethod = QV4L2_RENDER_QT;
 	}
 
+#ifdef ENABLE_ALSA
+	captureMenu->addSeparator();
+
+	m_showAllAudioAct = new QAction("Show All Audio Devices", this);
+	m_showAllAudioAct->setStatusTip("Show all audio input and output devices if set");
+	m_showAllAudioAct->setCheckable(true);
+	m_showAllAudioAct->setChecked(false);
+	captureMenu->addAction(m_showAllAudioAct);
+
+	m_audioBufferAct = new QAction("Set Audio Buffer Size...", this);
+	m_audioBufferAct->setStatusTip("Set audio buffer capacity in amout of ms than can be stored");
+	connect(m_audioBufferAct, SIGNAL(triggered()), this, SLOT(setAudioBufferSize()));
+	captureMenu->addAction(m_audioBufferAct);
+#endif
+
 	QMenu *helpMenu = menuBar()->addMenu("&Help");
 	helpMenu->addAction("&About", this, SLOT(about()), Qt::Key_F1);
 
@@ -172,8 +196,11 @@ void ApplicationWindow::setDevice(const QString &device, bool rawOpen)
 	m_sigMapper = new QSignalMapper(this);
 	connect(m_sigMapper, SIGNAL(mapped(int)), this, SLOT(ctrlAction(int)));
 
-	if (!open(device, !rawOpen))
+	if (!open(device, !rawOpen)) {
+		m_showAllAudioAct->setEnabled(false);
+		m_audioBufferAct->setEnabled(false);
 		return;
+	}
 
 	newCaptureWin();
 
@@ -181,6 +208,19 @@ void ApplicationWindow::setDevice(const QString &device, bool rawOpen)
 
 	QWidget *w = new QWidget(m_tabs);
 	m_genTab = new GeneralTab(device, *this, 4, w);
+
+#ifdef ENABLE_ALSA
+	if (m_genTab->hasAlsaAudio()) {
+		connect(m_showAllAudioAct, SIGNAL(toggled(bool)), m_genTab, SLOT(showAllAudioDevices(bool)));
+		connect(m_genTab, SIGNAL(audioDeviceChanged()), this, SLOT(changeAudioDevice()));
+		m_showAllAudioAct->setEnabled(true);
+		m_audioBufferAct->setEnabled(true);
+	} else {
+		m_showAllAudioAct->setEnabled(false);
+		m_audioBufferAct->setEnabled(false);
+	}
+#endif
+
 	m_tabs->addTab(w, "General");
 	addTabs();
 	if (caps() & (V4L2_CAP_VBI_CAPTURE | V4L2_CAP_SLICED_VBI_CAPTURE)) {
@@ -195,7 +235,7 @@ void ApplicationWindow::setDevice(const QString &device, bool rawOpen)
 	m_tabs->show();
 	m_tabs->setFocus();
 	m_convertData = v4lconvert_create(fd());
-	m_capStartAct->setEnabled(fd() >= 0 && !m_genTab->isRadio());
+	m_capStartAct->setEnabled(fd() >= 0);
 	m_ctrlNotifier = new QSocketNotifier(fd(), QSocketNotifier::Exception, m_tabs);
 	connect(m_ctrlNotifier, SIGNAL(activated(int)), this, SLOT(ctrlEvent()));
 }
@@ -235,6 +275,19 @@ void ApplicationWindow::setRenderMethod()
 	newCaptureWin();
 }
 
+void ApplicationWindow::setAudioBufferSize()
+{
+	bool ok;
+	int buffer = QInputDialog::getInt(this, "Audio Device Buffer Size", "Capacity in ms:",
+					   m_genTab->getAudioDeviceBufferSize(), 1, 65535, 1, &ok);
+
+	if (ok) {
+		m_genTab->setAudioDeviceBufferSize(buffer);
+		changeAudioDevice();
+	}
+}
+
+
 void ApplicationWindow::ctrlEvent()
 {
 	v4l2_event ev;
@@ -413,12 +466,18 @@ void ApplicationWindow::capFrame()
 	int s = 0;
 	int err = 0;
 	bool again;
+#ifdef ENABLE_ALSA
+	struct timeval tv_alsa;
+#endif
 
 	unsigned char *displaybuf = NULL;
 
 	switch (m_capMethod) {
 	case methodRead:
 		s = read(m_frameData, m_capSrcFormat.fmt.pix.sizeimage);
+#ifdef ENABLE_ALSA
+		alsa_thread_timestamp(&tv_alsa);
+#endif
 		if (s < 0) {
 			if (errno != EAGAIN) {
 				error("read");
@@ -449,6 +508,9 @@ void ApplicationWindow::capFrame()
 			m_capStartAct->setChecked(false);
 			return;
 		}
+#ifdef ENABLE_ALSA
+		alsa_thread_timestamp(&tv_alsa);
+#endif
 		if (again)
 			return;
 
@@ -475,6 +537,10 @@ void ApplicationWindow::capFrame()
 			m_capStartAct->setChecked(false);
 			return;
 		}
+#ifdef ENABLE_ALSA
+		alsa_thread_timestamp(&tv_alsa);
+#endif
+
 		if (again)
 			return;
 
@@ -511,9 +577,24 @@ void ApplicationWindow::capFrame()
 		m_lastFrame = m_frame;
 		m_tv = tv;
 	}
+
+
 	status = QString("Frame: %1 Fps: %2").arg(++m_frame).arg(m_fps);
+#ifdef ENABLE_ALSA
+	if (alsa_thread_is_running()) {
+		if (tv_alsa.tv_sec || tv_alsa.tv_usec) {
+			m_totalAudioLatency.tv_sec += buf.timestamp.tv_sec - tv_alsa.tv_sec;
+			m_totalAudioLatency.tv_usec += buf.timestamp.tv_usec - tv_alsa.tv_usec;
+		}
+		//m_totalAudioLatency.tv_sec = tv_alsa.tv_sec;
+		//m_totalAudioLatency.tv_usec = tv_alsa.tv_usec;
+		status.append(QString(" Average A-V: %3 ms")
+			      .arg((m_totalAudioLatency.tv_sec * 1000 + m_totalAudioLatency.tv_usec / 1000) / m_frame));
+	}
+#endif
 	if (displaybuf == NULL && m_showFrames)
 		status.append(" Error: Unsupported format.");
+
 	if (m_showFrames)
 		m_capture->setFrame(m_capImage->width(), m_capImage->height(),
 				    m_capDestFormat.fmt.pix.pixelformat, displaybuf, status);
@@ -530,6 +611,11 @@ void ApplicationWindow::capFrame()
 
 bool ApplicationWindow::startCapture(unsigned buffer_size)
 {
+	startAudio();
+
+	if (m_genTab->isRadio())
+		return true;
+
 	__u32 buftype = m_genTab->bufType();
 	v4l2_requestbuffers req;
 	unsigned int i;
@@ -645,6 +731,11 @@ error:
 
 void ApplicationWindow::stopCapture()
 {
+	stopAudio();
+
+	if (m_genTab->isRadio())
+		return;
+
 	__u32 buftype = m_genTab->bufType();
 	v4l2_requestbuffers reqbufs;
 	v4l2_encoder_cmd cmd;
@@ -695,6 +786,42 @@ void ApplicationWindow::stopOutput()
 {
 }
 
+void ApplicationWindow::startAudio()
+{
+#ifdef ENABLE_ALSA
+	m_totalAudioLatency.tv_sec = 0;
+	m_totalAudioLatency.tv_usec = 0;
+
+	QString audIn = m_genTab->getAudioInDevice();
+	QString audOut = m_genTab->getAudioOutDevice();
+
+	if (audIn != NULL && audOut != NULL && audIn.compare("None") && audIn.compare(audOut) != 0) {
+		alsa_thread_startup(audOut.toAscii().data(), audIn.toAscii().data(),
+				    m_genTab->getAudioDeviceBufferSize(), NULL, 0);
+
+		if (m_genTab->isRadio())
+			statusBar()->showMessage("Capturing audio");
+	}
+#endif
+}
+
+void ApplicationWindow::stopAudio()
+{
+#ifdef ENABLE_ALSA
+	if (m_genTab != NULL && m_genTab->isRadio())
+		statusBar()->showMessage("");
+	alsa_thread_stop();
+#endif
+}
+
+void ApplicationWindow::changeAudioDevice()
+{
+	stopAudio();
+	if (m_capStartAct->isChecked()) {
+		startAudio();
+	}
+}
+
 void ApplicationWindow::closeCaptureWin()
 {
 	m_capStartAct->setChecked(false);
@@ -702,6 +829,15 @@ void ApplicationWindow::closeCaptureWin()
 
 void ApplicationWindow::capStart(bool start)
 {
+	if (m_genTab->isRadio()) {
+		if (start)
+			startCapture(0);
+		else
+			stopCapture();
+
+		return;
+	}
+
 	QImage::Format dstFmt = QImage::Format_RGB888;
 	struct v4l2_fract interval;
 	v4l2_pix_format &srcPix = m_capSrcFormat.fmt.pix;
@@ -821,6 +957,7 @@ void ApplicationWindow::capStart(bool start)
 
 void ApplicationWindow::closeDevice()
 {
+	stopAudio();
 	delete m_sigMapper;
 	m_sigMapper = NULL;
 	m_capStartAct->setEnabled(false);
diff --git a/utils/qv4l2/qv4l2.h b/utils/qv4l2/qv4l2.h
index 2921b16..223db75 100644
--- a/utils/qv4l2/qv4l2.h
+++ b/utils/qv4l2/qv4l2.h
@@ -98,6 +98,8 @@ private:
 	void startOutput(unsigned buffer_size);
 	void stopOutput();
 	void newCaptureWin();
+	void startAudio();
+	void stopAudio();
 
 	struct buffer *m_buffers;
 	struct v4l2_format m_capSrcFormat;
@@ -118,6 +120,7 @@ private slots:
 	void capVbiFrame();
 	void saveRaw(bool);
 	void setRenderMethod();
+	void changeAudioDevice();
 
 	// gui
 private slots:
@@ -126,6 +129,7 @@ private slots:
 	void ctrlAction(int);
 	void openRawFile(const QString &s);
 	void rejectedRawFile();
+	void setAudioBufferSize();
 
 	void about();
 
@@ -176,6 +180,8 @@ private:
 	QAction *m_saveRawAct;
 	QAction *m_showFramesAct;
 	QAction *m_useGLAct;
+	QAction *m_showAllAudioAct;
+	QAction *m_audioBufferAct;
 	QString m_filename;
 	QSignalMapper *m_sigMapper;
 	QTabWidget *m_tabs;
@@ -196,6 +202,7 @@ private:
 	unsigned m_lastFrame;
 	unsigned m_fps;
 	struct timeval m_tv;
+	struct timeval m_totalAudioLatency;
 	QFile m_saveRaw;
 };
 
-- 
1.8.3.2

