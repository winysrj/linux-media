Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-2.cisco.com ([144.254.224.141]:14942 "EHLO
	ams-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934211Ab3HHMb5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 8 Aug 2013 08:31:57 -0400
Received: from bwinther.cisco.com (dhcp-10-54-92-90.cisco.com [10.54.92.90])
	by ams-core-2.cisco.com (8.14.5/8.14.5) with ESMTP id r78CVcje014622
	for <linux-media@vger.kernel.org>; Thu, 8 Aug 2013 12:31:54 GMT
From: =?UTF-8?q?B=C3=A5rd=20Eirik=20Winther?= <bwinther@cisco.com>
To: linux-media@vger.kernel.org
Subject: [PATCHv2 8/9] qv4l2: add hotkey for reset scaling to frame size
Date: Thu,  8 Aug 2013 14:31:26 +0200
Message-Id: <3ea04c381f8e5cd143a4e127bc72f5c97775212e.1375964980.git.bwinther@cisco.com>
In-Reply-To: <1375965087-16318-1-git-send-email-bwinther@cisco.com>
References: <1375965087-16318-1-git-send-email-bwinther@cisco.com>
In-Reply-To: <cdb6d3a353ce89599cd716e763e85e704b92f79c.1375964980.git.bwinther@cisco.com>
References: <cdb6d3a353ce89599cd716e763e85e704b92f79c.1375964980.git.bwinther@cisco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Adds hotkey CTRL + F for both CaptureWin and main Capture menu.
Resets the scaling of CaptureWin to fit frame size.

Signed-off-by: Bård Eirik Winther <bwinther@cisco.com>
---
 utils/qv4l2/capture-win.cpp | 3 +++
 utils/qv4l2/capture-win.h   | 1 +
 utils/qv4l2/qv4l2.cpp       | 1 +
 3 files changed, 5 insertions(+)

diff --git a/utils/qv4l2/capture-win.cpp b/utils/qv4l2/capture-win.cpp
index 3bd6549..3abb6cb 100644
--- a/utils/qv4l2/capture-win.cpp
+++ b/utils/qv4l2/capture-win.cpp
@@ -38,6 +38,8 @@ CaptureWin::CaptureWin() :
 	setWindowTitle("V4L2 Capture");
 	m_hotkeyClose = new QShortcut(Qt::CTRL+Qt::Key_W, this);
 	connect(m_hotkeyClose, SIGNAL(activated()), this, SLOT(close()));
+	m_hotkeyScaleReset = new QShortcut(Qt::CTRL+Qt::Key_F, this);
+	connect(m_hotkeyScaleReset, SIGNAL(activated()), this, SLOT(resetSize()));
 }
 
 CaptureWin::~CaptureWin()
@@ -48,6 +50,7 @@ CaptureWin::~CaptureWin()
 	layout()->removeWidget(this);
 	delete layout();
 	delete m_hotkeyClose;
+	delete m_hotkeyScaleReset;
 }
 
 void CaptureWin::buildWindow(QWidget *videoSurface)
diff --git a/utils/qv4l2/capture-win.h b/utils/qv4l2/capture-win.h
index eea0335..1bfb1e1 100644
--- a/utils/qv4l2/capture-win.h
+++ b/utils/qv4l2/capture-win.h
@@ -104,6 +104,7 @@ signals:
 
 private:
 	QShortcut *m_hotkeyClose;
+	QShortcut *m_hotkeyScaleReset;
 	int m_curWidth;
 	int m_curHeight;
 };
diff --git a/utils/qv4l2/qv4l2.cpp b/utils/qv4l2/qv4l2.cpp
index 3da99da..7be9f1a 100644
--- a/utils/qv4l2/qv4l2.cpp
+++ b/utils/qv4l2/qv4l2.cpp
@@ -144,6 +144,7 @@ ApplicationWindow::ApplicationWindow() :
 	connect(m_scalingAct, SIGNAL(toggled(bool)), this, SLOT(enableScaling(bool)));
 	m_resetScalingAct = new QAction("Resize to Frame Size", this);
 	m_resetScalingAct->setStatusTip("Resizes the capture window to match frame size");
+	m_resetScalingAct->setShortcut(Qt::CTRL+Qt::Key_F);
 
 	QMenu *captureMenu = menuBar()->addMenu("&Capture");
 	captureMenu->addAction(m_capStartAct);
-- 
1.8.4.rc1

