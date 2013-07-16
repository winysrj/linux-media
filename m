Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-2.cisco.com ([144.254.224.141]:36808 "EHLO
	ams-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932086Ab3GPLYd (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 16 Jul 2013 07:24:33 -0400
From: =?UTF-8?q?B=C3=A5rd=20Eirik=20Winther?= <bwinther@cisco.com>
To: linux-media@vger.kernel.org
Cc: hansverk@cisco.com
Subject: [PATCH 3/4] qv4l2: fix CaptureWin mimimum size to match video fram size
Date: Tue, 16 Jul 2013 13:24:07 +0200
Message-Id: <16222291c1d1fd6b515f5c84926587aae8f132e3.1373973770.git.bwinther@cisco.com>
In-Reply-To: <1373973848-4084-1-git-send-email-bwinther@cisco.com>
References: <1373973848-4084-1-git-send-email-bwinther@cisco.com>
In-Reply-To: <61608db2b5b388a50c91730739479dccf76c046d.1373973770.git.bwinther@cisco.com>
References: <61608db2b5b388a50c91730739479dccf76c046d.1373973770.git.bwinther@cisco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

CaptureWin's setMinimumSize() sets the minimum size for the
video frame viewport and not for the window itself.
If the minimum size is larger than the monitor resolution,
it will reduce the minimum size to match this.

Signed-off-by: Bård Eirik Winther <bwinther@cisco.com>
---
 utils/qv4l2/capture-win.cpp | 26 ++++++++++++++++++++++++++
 utils/qv4l2/capture-win.h   |  1 +
 2 files changed, 27 insertions(+)

diff --git a/utils/qv4l2/capture-win.cpp b/utils/qv4l2/capture-win.cpp
index a94c73d..7ac3fa1 100644
--- a/utils/qv4l2/capture-win.cpp
+++ b/utils/qv4l2/capture-win.cpp
@@ -21,6 +21,8 @@
 #include <QImage>
 #include <QVBoxLayout>
 #include <QCloseEvent>
+#include <QApplication>
+#include <QDesktopWidget>
 
 #include "qv4l2.h"
 #include "capture-win.h"
@@ -36,6 +38,10 @@ CaptureWin::CaptureWin()
 	vbox->addWidget(m_label);
 	vbox->addWidget(m_msg);
 
+	int l, t, r, b;
+	vbox->getContentsMargins(&l, &t, &r, &b);
+	vbox->setSpacing(b);
+
 	hotkeyClose = new QShortcut(Qt::CTRL+Qt::Key_W, this);
 	QObject::connect(hotkeyClose, SIGNAL(activated()), this, SLOT(close()));
 }
@@ -45,6 +51,26 @@ CaptureWin::~CaptureWin()
 	delete hotkeyClose;
 }
 
+void CaptureWin::setMinimumSize(int minw, int minh)
+{
+	QDesktopWidget *screen = QApplication::desktop();
+	QRect resolution = screen->screenGeometry();
+
+	int l, t, r, b;
+	layout()->getContentsMargins(&l, &t, &r, &b);
+	minw += l + r;
+	minh += t + b + m_msg->minimumSizeHint().height() + layout()->spacing();
+
+	if (minw > resolution.width())
+		minw = resolution.width();
+
+	if (minh > resolution.height())
+		minh = resolution.height();
+
+	QWidget::setMinimumSize(minw, minh);
+	resize(minw, minh);
+}
+
 void CaptureWin::setImage(const QImage &image, const QString &status)
 {
 	m_label->setPixmap(QPixmap::fromImage(image));
diff --git a/utils/qv4l2/capture-win.h b/utils/qv4l2/capture-win.h
index 4115d56..3de3447 100644
--- a/utils/qv4l2/capture-win.h
+++ b/utils/qv4l2/capture-win.h
@@ -35,6 +35,7 @@ public:
 	CaptureWin();
 	~CaptureWin();
 
+	virtual void setMinimumSize(int minw, int minh);
 	void setImage(const QImage &image, const QString &status);
 
 protected:
-- 
1.8.3.2

