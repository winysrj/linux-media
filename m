Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-2.cisco.com ([144.254.224.141]:27498 "EHLO
	ams-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755909Ab3GYN0D (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 25 Jul 2013 09:26:03 -0400
Received: from bwinther.cisco.com (dhcp-10-54-92-49.cisco.com [10.54.92.49])
	by ams-core-2.cisco.com (8.14.5/8.14.5) with ESMTP id r6PDPtGP025835
	for <linux-media@vger.kernel.org>; Thu, 25 Jul 2013 13:26:00 GMT
From: =?UTF-8?q?B=C3=A5rd=20Eirik=20Winther?= <bwinther@cisco.com>
To: linux-media@vger.kernel.org
Subject: [PATCHv2 2/5] qv4l2: add hotkeys for common operations
Date: Thu, 25 Jul 2013 15:25:21 +0200
Message-Id: <8413c415251ff1c37330a3e02b1e653ed1c4910c.1374758669.git.bwinther@cisco.com>
In-Reply-To: <1374758724-3058-1-git-send-email-bwinther@cisco.com>
References: <1374758724-3058-1-git-send-email-bwinther@cisco.com>
In-Reply-To: <0fd43d1af7343792f570f32251ad150735066f71.1374758669.git.bwinther@cisco.com>
References: <0fd43d1af7343792f570f32251ad150735066f71.1374758669.git.bwinther@cisco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

CTRL + V : When main window is selected start capture.
           This gives an option other than the button to start recording,
           as this is a frequent operation when using the utility.
CTRL + W : When CaptureWin is selected close capture window
           It makes it easier to deal with high resolutions video on
           small screen, especially when the window close button may
           be outside the monitor when repositioning the window.

Signed-off-by: Bård Eirik Winther <bwinther@cisco.com>
---
 utils/qv4l2/capture-win.cpp | 8 ++++++++
 utils/qv4l2/capture-win.h   | 4 +++-
 utils/qv4l2/qv4l2.cpp       | 1 +
 3 files changed, 12 insertions(+), 1 deletion(-)

diff --git a/utils/qv4l2/capture-win.cpp b/utils/qv4l2/capture-win.cpp
index 6798252..a94c73d 100644
--- a/utils/qv4l2/capture-win.cpp
+++ b/utils/qv4l2/capture-win.cpp
@@ -35,6 +35,14 @@ CaptureWin::CaptureWin()
 
 	vbox->addWidget(m_label);
 	vbox->addWidget(m_msg);
+
+	hotkeyClose = new QShortcut(Qt::CTRL+Qt::Key_W, this);
+	QObject::connect(hotkeyClose, SIGNAL(activated()), this, SLOT(close()));
+}
+
+CaptureWin::~CaptureWin()
+{
+	delete hotkeyClose;
 }
 
 void CaptureWin::setImage(const QImage &image, const QString &status)
diff --git a/utils/qv4l2/capture-win.h b/utils/qv4l2/capture-win.h
index e861b12..4115d56 100644
--- a/utils/qv4l2/capture-win.h
+++ b/utils/qv4l2/capture-win.h
@@ -21,6 +21,7 @@
 #define CAPTURE_WIN_H
 
 #include <QWidget>
+#include <QShortcut>
 #include <sys/time.h>
 
 class QImage;
@@ -32,7 +33,7 @@ class CaptureWin : public QWidget
 
 public:
 	CaptureWin();
-	virtual ~CaptureWin() {}
+	~CaptureWin();
 
 	void setImage(const QImage &image, const QString &status);
 
@@ -45,6 +46,7 @@ signals:
 private:
 	QLabel *m_label;
 	QLabel *m_msg;
+	QShortcut *hotkeyClose;
 };
 
 #endif
diff --git a/utils/qv4l2/qv4l2.cpp b/utils/qv4l2/qv4l2.cpp
index a8fcc65..bb1d84f 100644
--- a/utils/qv4l2/qv4l2.cpp
+++ b/utils/qv4l2/qv4l2.cpp
@@ -78,6 +78,7 @@ ApplicationWindow::ApplicationWindow() :
 	m_capStartAct->setStatusTip("Start capturing");
 	m_capStartAct->setCheckable(true);
 	m_capStartAct->setDisabled(true);
+	m_capStartAct->setShortcut(Qt::CTRL+Qt::Key_V);
 	connect(m_capStartAct, SIGNAL(toggled(bool)), this, SLOT(capStart(bool)));
 
 	m_snapshotAct = new QAction(QIcon(":/snapshot.png"), "&Make Snapshot", this);
-- 
1.8.3.2

