Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-3.cisco.com ([144.254.224.146]:20693 "EHLO
	ams-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755930Ab3GYN0E (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 25 Jul 2013 09:26:04 -0400
Received: from bwinther.cisco.com (dhcp-10-54-92-49.cisco.com [10.54.92.49])
	by ams-core-2.cisco.com (8.14.5/8.14.5) with ESMTP id r6PDPtGQ025835
	for <linux-media@vger.kernel.org>; Thu, 25 Jul 2013 13:26:02 GMT
From: =?UTF-8?q?B=C3=A5rd=20Eirik=20Winther?= <bwinther@cisco.com>
To: linux-media@vger.kernel.org
Subject: [PATCHv2 3/5] qv4l2: fix minimum size in capture win to frame size
Date: Thu, 25 Jul 2013 15:25:22 +0200
Message-Id: <cfb296d4dcb6ccabea64936949bb50bd1bf7a19d.1374758669.git.bwinther@cisco.com>
In-Reply-To: <1374758724-3058-1-git-send-email-bwinther@cisco.com>
References: <1374758724-3058-1-git-send-email-bwinther@cisco.com>
In-Reply-To: <0fd43d1af7343792f570f32251ad150735066f71.1374758669.git.bwinther@cisco.com>
References: <0fd43d1af7343792f570f32251ad150735066f71.1374758669.git.bwinther@cisco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

CaptureWin's setMinimumSize() sets the minimum size for the video frame viewport
and not for the window itself. If the minimum size is larger than the monitor resolution,
it will reduce the minimum size to match this.

Signed-off-by: Bård Eirik Winther <bwinther@cisco.com>
---
 utils/qv4l2/capture-win.cpp | 29 +++++++++++++++++++++++++++++
 utils/qv4l2/capture-win.h   |  1 +
 2 files changed, 30 insertions(+)

diff --git a/utils/qv4l2/capture-win.cpp b/utils/qv4l2/capture-win.cpp
index a94c73d..68dc9ed 100644
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
@@ -45,6 +47,33 @@ CaptureWin::~CaptureWin()
 	delete hotkeyClose;
 }
 
+void CaptureWin::setMinimumSize(int minw, int minh)
+{
+	QDesktopWidget *screen = QApplication::desktop();
+	QRect resolution = screen->screenGeometry();
+	QSize maxSize = maximumSize();
+
+	int l, t, r, b;
+	layout()->getContentsMargins(&l, &t, &r, &b);
+	minw += l + r;
+	minh += t + b + m_msg->minimumSizeHint().height() + layout()->spacing();
+
+	if (minw > resolution.width())
+		minw = resolution.width();
+	if (minw < 150)
+		minw = 150;
+
+	if (minh > resolution.height())
+		minh = resolution.height();
+	if (minh < 100)
+		minh = 100;
+
+	QWidget::setMinimumSize(minw, minh);
+	QWidget::setMaximumSize(minw, minh);
+	updateGeometry();
+	QWidget::setMaximumSize(maxSize.width(), maxSize.height());
+}
+
 void CaptureWin::setImage(const QImage &image, const QString &status)
 {
 	m_label->setPixmap(QPixmap::fromImage(image));
diff --git a/utils/qv4l2/capture-win.h b/utils/qv4l2/capture-win.h
index 4115d56..3925757 100644
--- a/utils/qv4l2/capture-win.h
+++ b/utils/qv4l2/capture-win.h
@@ -35,6 +35,7 @@ public:
 	CaptureWin();
 	~CaptureWin();
 
+	void setMinimumSize(int minw, int minh);
 	void setImage(const QImage &image, const QString &status);
 
 protected:
-- 
1.8.3.2

