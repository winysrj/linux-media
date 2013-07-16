Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-1.cisco.com ([144.254.224.140]:3196 "EHLO
	ams-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754981Ab3GPLeK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 16 Jul 2013 07:34:10 -0400
From: =?UTF-8?q?B=C3=A5rd=20Eirik=20Winther?= <bwinther@cisco.com>
To: linux-media@vger.kernel.org
Cc: hansverk@cisco.com
Subject: [PATCH 2/4] qv4l2: add hotkeys for common operations
Date: Tue, 16 Jul 2013 13:24:06 +0200
Message-Id: <b7e21e4446fdad85f6f6a5ceab269d96a90d4cd0.1373973770.git.bwinther@cisco.com>
In-Reply-To: <1373973848-4084-1-git-send-email-bwinther@cisco.com>
References: <1373973848-4084-1-git-send-email-bwinther@cisco.com>
In-Reply-To: <61608db2b5b388a50c91730739479dccf76c046d.1373973770.git.bwinther@cisco.com>
References: <61608db2b5b388a50c91730739479dccf76c046d.1373973770.git.bwinther@cisco.com>
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

