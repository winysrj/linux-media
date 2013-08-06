Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-1.cisco.com ([144.254.224.140]:16271 "EHLO
	ams-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755835Ab3HFKWd (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 6 Aug 2013 06:22:33 -0400
Received: from bwinther.cisco.com (dhcp-10-54-92-83.cisco.com [10.54.92.83])
	by ams-core-4.cisco.com (8.14.5/8.14.5) with ESMTP id r76AMGhM015841
	for <linux-media@vger.kernel.org>; Tue, 6 Aug 2013 10:22:30 GMT
From: =?UTF-8?q?B=C3=A5rd=20Eirik=20Winther?= <bwinther@cisco.com>
To: linux-media@vger.kernel.org
Subject: [PATCH 7/9] qv4l2: added resize to frame size in Capture menu
Date: Tue,  6 Aug 2013 12:21:51 +0200
Message-Id: <d9f5cc27bea0e06ef693e5a5e9ddd8922936c164.1375784415.git.bwinther@cisco.com>
In-Reply-To: <1375784513-18701-1-git-send-email-bwinther@cisco.com>
References: <1375784513-18701-1-git-send-email-bwinther@cisco.com>
In-Reply-To: <f8457ccfdceb6e73b7990efe95f9e3b61d973747.1375784415.git.bwinther@cisco.com>
References: <f8457ccfdceb6e73b7990efe95f9e3b61d973747.1375784415.git.bwinther@cisco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This will resize the CaptureWin to the original frame size.
It also works with maximized windows.

Signed-off-by: Bård Eirik Winther <bwinther@cisco.com>
---
 utils/qv4l2/capture-win.cpp | 12 ++++++++++++
 utils/qv4l2/capture-win.h   |  3 +++
 utils/qv4l2/qv4l2.cpp       |  6 ++++--
 utils/qv4l2/qv4l2.h         |  1 +
 4 files changed, 20 insertions(+), 2 deletions(-)

diff --git a/utils/qv4l2/capture-win.cpp b/utils/qv4l2/capture-win.cpp
index 33f7084..3bd6549 100644
--- a/utils/qv4l2/capture-win.cpp
+++ b/utils/qv4l2/capture-win.cpp
@@ -61,6 +61,18 @@ void CaptureWin::buildWindow(QWidget *videoSurface)
 	vbox->setSpacing(b);
 }
 
+void CaptureWin::resetSize()
+{
+	if (isMaximized())
+		showNormal();
+
+	int w = m_curWidth;
+	int h = m_curHeight;
+	m_curWidth = -1;
+	m_curHeight = -1;
+	resize(w, h);
+}
+
 QSize CaptureWin::getMargins()
 {
 	int l, t, r, b;
diff --git a/utils/qv4l2/capture-win.h b/utils/qv4l2/capture-win.h
index dd19f2d..eea0335 100644
--- a/utils/qv4l2/capture-win.h
+++ b/utils/qv4l2/capture-win.h
@@ -78,6 +78,9 @@ public:
 	void enableScaling(bool enable);
 	static QSize scaleFrameSize(QSize window, QSize frame);
 
+public slots:
+	void resetSize();
+
 protected:
 	void closeEvent(QCloseEvent *event);
 	void buildWindow(QWidget *videoSurface);
diff --git a/utils/qv4l2/qv4l2.cpp b/utils/qv4l2/qv4l2.cpp
index 50ba07a..1a476f0 100644
--- a/utils/qv4l2/qv4l2.cpp
+++ b/utils/qv4l2/qv4l2.cpp
@@ -142,11 +142,14 @@ ApplicationWindow::ApplicationWindow() :
 	m_scalingAct->setCheckable(true);
 	m_scalingAct->setChecked(true);
 	connect(m_scalingAct, SIGNAL(toggled(bool)), this, SLOT(enableScaling(bool)));
+	m_resetScalingAct = new QAction("Resize to Frame Size", this);
+	m_resetScalingAct->setStatusTip("Resizes the capture window to match frame size");
 
 	QMenu *captureMenu = menuBar()->addMenu("&Capture");
 	captureMenu->addAction(m_capStartAct);
 	captureMenu->addAction(m_showFramesAct);
 	captureMenu->addAction(m_scalingAct);
+	captureMenu->addAction(m_resetScalingAct);
 
 	if (CaptureWinGL::isSupported()) {
 		m_renderMethod = QV4L2_RENDER_GL;
@@ -211,8 +214,6 @@ void ApplicationWindow::setDevice(const QString &device, bool rawOpen)
 
 	newCaptureWin();
 
-	m_capture->setMinimumSize(150, 50);
-
 	QWidget *w = new QWidget(m_tabs);
 	m_genTab = new GeneralTab(device, *this, 4, w);
 
@@ -360,6 +361,7 @@ void ApplicationWindow::newCaptureWin()
 
 	m_capture->enableScaling(m_scalingAct->isChecked());
         connect(m_capture, SIGNAL(close()), this, SLOT(closeCaptureWin()));
+	connect(m_resetScalingAct, SIGNAL(triggered()), m_capture, SLOT(resetSize()));
 }
 
 void ApplicationWindow::capVbiFrame()
diff --git a/utils/qv4l2/qv4l2.h b/utils/qv4l2/qv4l2.h
index 1402673..179cecb 100644
--- a/utils/qv4l2/qv4l2.h
+++ b/utils/qv4l2/qv4l2.h
@@ -187,6 +187,7 @@ private:
 	QAction *m_showAllAudioAct;
 	QAction *m_audioBufferAct;
 	QAction *m_scalingAct;
+	QAction *m_resetScalingAct;
 	QString m_filename;
 	QSignalMapper *m_sigMapper;
 	QTabWidget *m_tabs;
-- 
1.8.3.2

