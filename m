Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f68.google.com ([209.85.215.68]:35982 "EHLO
        mail-lf0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751194AbdIOJ2V (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 15 Sep 2017 05:28:21 -0400
Received: by mail-lf0-f68.google.com with SMTP id l196so902763lfl.3
        for <linux-media@vger.kernel.org>; Fri, 15 Sep 2017 02:28:20 -0700 (PDT)
From: Konstantin Oblaukhov <oblaukhov.konstantin@gmail.com>
To: linux-media@vger.kernel.org
Cc: Konstantin Oblaukhov <oblaukhov.konstantin@gmail.com>
Subject: [PATCH] util: qv4l2: fix discrete frame size selection.
Date: Fri, 15 Sep 2017 16:28:11 +0700
Message-Id: <20170915092811.22847-1-oblaukhov.konstantin@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

qv4l2 hasn't work correctly with discrete frame sizes. 
In case of capture device with discrete frame sizes, size combo-box wasn't shown.
In case of output device with discrete frame sizes, qv4l2 was segfaulting.
This patch fix discrete size combo-box both for capture and output devices.

Also Qt's project file got updated.

---
 utils/qv4l2/general-tab.cpp | 30 ++++++++++++++++++++++++++----
 utils/qv4l2/qv4l2.pro       |  5 ++++-
 2 files changed, 30 insertions(+), 5 deletions(-)

diff --git a/utils/qv4l2/general-tab.cpp b/utils/qv4l2/general-tab.cpp
index 9c1dbc7e..78c5cb2d 100644
--- a/utils/qv4l2/general-tab.cpp
+++ b/utils/qv4l2/general-tab.cpp
@@ -595,8 +595,11 @@ void GeneralTab::outputSection(v4l2_output vout)
 		return;
 
 	QWidget *wFrameWH = new QWidget();
+	QWidget *wFrameSR = new QWidget();
 	QGridLayout *m_wh = new QGridLayout(wFrameWH);
+	QGridLayout *m_sr = new QGridLayout(wFrameSR);
 	m_grids.append(m_wh);
+	m_grids.append(m_sr);
 
 	m_wh->addWidget(new QLabel("Frame Width", parentWidget()), 0, 0, Qt::AlignLeft);
 	m_frameWidth = new QSpinBox(parentWidget());
@@ -608,7 +611,18 @@ void GeneralTab::outputSection(v4l2_output vout)
 	m_wh->addWidget(m_frameHeight, 0, 3, Qt::AlignLeft);
 	connect(m_frameHeight, SIGNAL(editingFinished()), SLOT(frameHeightChanged()));
 
+	m_sr->addWidget(new QLabel("Frame Size", parentWidget()), 0, 0, Qt::AlignLeft);
+	m_frameSize = new QComboBox(parentWidget());
+	m_sr->addWidget(m_frameSize, 0, 1, Qt::AlignLeft);
+	connect(m_frameSize, SIGNAL(activated(int)), SLOT(frameSizeChanged(int)));
+
+	m_sr->addWidget(new QLabel("Frame Rate", parentWidget()), 0, 2, Qt::AlignLeft);
+	m_frameInterval = new QComboBox(parentWidget());
+	m_sr->addWidget(m_frameInterval, 0, 3, Qt::AlignLeft);
+	connect(m_frameInterval, SIGNAL(activated(int)), SLOT(frameIntervalChanged(int)));
+
 	m_stackedFrameSettings->addWidget(wFrameWH);
+	m_stackedFrameSettings->addWidget(wFrameSR);
 
 	QGridLayout::addWidget(m_stackedFrameSettings, m_row, 0, 1, m_cols, Qt::AlignVCenter);
 	m_row++;
@@ -1184,7 +1198,7 @@ void GeneralTab::updateGUIInput(__u32 input)
 		m_stackedStandards->show();
 		m_stackedFrequency->hide();
 	} else if (in.capabilities & V4L2_IN_CAP_DV_TIMINGS) {
-		m_stackedFrameSettings->setCurrentIndex(0);
+		m_stackedFrameSettings->setCurrentIndex(m_discreteSizes ? 1 : 0);
 		m_stackedFrameSettings->show();
 		m_stackedStandards->setCurrentIndex(1);
 		m_stackedStandards->show();
@@ -1216,8 +1230,8 @@ void GeneralTab::updateGUIOutput(__u32 output)
 		m_stackedStandards->setCurrentIndex(0);
 		m_stackedStandards->show();
 		m_stackedFrequency->hide();
-	} else if (out.capabilities & V4L2_OUT_CAP_DV_TIMINGS) {
-		m_stackedFrameSettings->setCurrentIndex(0);
+	} else if (out.capabilities & V4L2_OUT_CAP_DV_TIMINGS) {
+		m_stackedFrameSettings->setCurrentIndex(m_discreteSizes ? 1 : 0);
 		m_stackedFrameSettings->show();
 		m_stackedStandards->setCurrentIndex(1);
 		m_stackedStandards->show();
@@ -2157,7 +2171,12 @@ void GeneralTab::updateFrameSize()
 				m_frameSize->setCurrentIndex(frmsize.index);
 		} while (!enum_framesizes(frmsize));
 
+
 		m_discreteSizes = true;
+		if (m_frameSize)
+			m_frameSize->setEnabled(true);
+		m_stackedFrameSettings->setCurrentIndex(1);
+
 		m_frameWidth->setEnabled(false);
 		m_frameWidth->blockSignals(true);
 		m_frameWidth->setMinimum(m_width);
@@ -2171,7 +2190,9 @@ void GeneralTab::updateFrameSize()
 		m_frameHeight->setMaximum(m_height);
 		m_frameHeight->setValue(m_height);
 		m_frameHeight->blockSignals(false);
-		m_frameSize->setEnabled(!m_haveBuffers);
+        m_frameSize->setEnabled(!m_haveBuffers);
+
+
 		updateFrameInterval();
 		return;
 	}
@@ -2186,6 +2207,7 @@ void GeneralTab::updateFrameSize()
 	m_discreteSizes = false;
 	if (m_frameSize)
 		m_frameSize->setEnabled(false);
+	m_stackedFrameSettings->setCurrentIndex(0);
 	if (!m_frameWidth) {
 		updateFrameInterval();
 		return;
diff --git a/utils/qv4l2/qv4l2.pro b/utils/qv4l2/qv4l2.pro
index 6420fa24..be59dced 100644
--- a/utils/qv4l2/qv4l2.pro
+++ b/utils/qv4l2/qv4l2.pro
@@ -26,6 +26,7 @@ HEADERS += general-tab.h
 HEADERS += qv4l2.h
 HEADERS += raw2sliced.h
 HEADERS += vbi-tab.h
+HEADERS += alsa_stream.h
 HEADERS += ../common/v4l2-tpg.h
 HEADERS += ../common/v4l2-tpg-colors.h
 HEADERS += ../../config.h
@@ -39,12 +40,14 @@ SOURCES += qv4l2.cpp
 SOURCES += raw2sliced.cpp
 SOURCES += tpg-tab.cpp
 SOURCES += vbi-tab.cpp
+SOURCES += alsa_stream.c
 SOURCES += ../v4l2-ctl/v4l2-tpg-core.c
 SOURCES += ../v4l2-ctl/v4l2-tpg-colors.c
 
 LIBS += -L$$PWD/../../lib/libv4l2/.libs -lv4l2
 LIBS += -L$$PWD/../../lib/libv4lconvert/.libs -lv4lconvert
 LIBS += -L$$PWD/../libv4l2util/.libs -lv4l2util 
-LIBS += -lrt -ldl -ljpeg
+LIBS += -L$$PWD/../libmedia_dev/.libs -lmedia_dev
+LIBS += -lrt -ldl -ljpeg -lasound
 
 RESOURCES += qv4l2.qrc
-- 
2.14.1
