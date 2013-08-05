Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-1.cisco.com ([144.254.224.140]:23962 "EHLO
	ams-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755372Ab3HEI5p (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 5 Aug 2013 04:57:45 -0400
Received: from bwinther.cisco.com (dhcp-10-54-92-49.cisco.com [10.54.92.49])
	by ams-core-4.cisco.com (8.14.5/8.14.5) with ESMTP id r758vY7f001512
	for <linux-media@vger.kernel.org>; Mon, 5 Aug 2013 08:57:42 GMT
From: =?UTF-8?q?B=C3=A5rd=20Eirik=20Winther?= <bwinther@cisco.com>
To: linux-media@vger.kernel.org
Subject: [RFC PATCH 4/7] qv4l2: add function getMargins
Date: Mon,  5 Aug 2013 10:56:54 +0200
Message-Id: <3286fb62051d996612608c660c909fd3e4127dc1.1375692973.git.bwinther@cisco.com>
In-Reply-To: <1375693017-6079-1-git-send-email-bwinther@cisco.com>
References: <1375693017-6079-1-git-send-email-bwinther@cisco.com>
In-Reply-To: <8be0aea2a33100972c3f9c74a8c981fca0e7a2aa.1375692973.git.bwinther@cisco.com>
References: <8be0aea2a33100972c3f9c74a8c981fca0e7a2aa.1375692973.git.bwinther@cisco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Created a function to get the total margins (window frame) in pixels
outside the actual video frame beeing displayed.

Signed-off-by: Bård Eirik Winther <bwinther@cisco.com>
---
 utils/qv4l2/capture-win.cpp | 14 ++++++++++----
 utils/qv4l2/capture-win.h   |  2 ++
 2 files changed, 12 insertions(+), 4 deletions(-)

diff --git a/utils/qv4l2/capture-win.cpp b/utils/qv4l2/capture-win.cpp
index 2d57909..e583900 100644
--- a/utils/qv4l2/capture-win.cpp
+++ b/utils/qv4l2/capture-win.cpp
@@ -54,16 +54,22 @@ void CaptureWin::buildWindow(QWidget *videoSurface)
 	vbox->setSpacing(b);
 }
 
+QSize CaptureWin::getMargins()
+{
+ 	int l, t, r, b;
+ 	layout()->getContentsMargins(&l, &t, &r, &b);
+	return QSize(l + r, t + b + m_information.minimumSizeHint().height() + layout()->spacing());
+}
+
 void CaptureWin::setMinimumSize(int minw, int minh)
 {
 	QDesktopWidget *screen = QApplication::desktop();
 	QRect resolution = screen->screenGeometry();
 	QSize maxSize = maximumSize();
 
-	int l, t, r, b;
-	layout()->getContentsMargins(&l, &t, &r, &b);
-	minw += l + r;
-	minh += t + b + m_information.minimumSizeHint().height() + layout()->spacing();
+	QSize margins = getMargins();
+	minw += margins.width();
+	minh += margins.height();
 
 	if (minw > resolution.width())
 		minw = resolution.width();
diff --git a/utils/qv4l2/capture-win.h b/utils/qv4l2/capture-win.h
index ca60244..6b72e00 100644
--- a/utils/qv4l2/capture-win.h
+++ b/utils/qv4l2/capture-win.h
@@ -78,6 +78,8 @@ public:
 protected:
 	void closeEvent(QCloseEvent *event);
 	void buildWindow(QWidget *videoSurface);
+	QSize getMargins();
+
 
 	/**
 	 * @brief A label that can is used to display capture information.
-- 
1.8.3.2

