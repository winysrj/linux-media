Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-3.cisco.com ([144.254.224.146]:45035 "EHLO
	ams-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934211Ab3HHMbv (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 8 Aug 2013 08:31:51 -0400
Received: from bwinther.cisco.com (dhcp-10-54-92-90.cisco.com [10.54.92.90])
	by ams-core-2.cisco.com (8.14.5/8.14.5) with ESMTP id r78CVcjb014622
	for <linux-media@vger.kernel.org>; Thu, 8 Aug 2013 12:31:48 GMT
From: =?UTF-8?q?B=C3=A5rd=20Eirik=20Winther?= <bwinther@cisco.com>
To: linux-media@vger.kernel.org
Subject: [PATCHv2 5/9] qv4l2: create function getMargins
Date: Thu,  8 Aug 2013 14:31:23 +0200
Message-Id: <2b32e80e9b22855efe3fd4cc7d7cbd7d6bdeb041.1375964980.git.bwinther@cisco.com>
In-Reply-To: <1375965087-16318-1-git-send-email-bwinther@cisco.com>
References: <1375965087-16318-1-git-send-email-bwinther@cisco.com>
In-Reply-To: <cdb6d3a353ce89599cd716e763e85e704b92f79c.1375964980.git.bwinther@cisco.com>
References: <cdb6d3a353ce89599cd716e763e85e704b92f79c.1375964980.git.bwinther@cisco.com>
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
 utils/qv4l2/capture-win.h   |  1 +
 2 files changed, 11 insertions(+), 4 deletions(-)

diff --git a/utils/qv4l2/capture-win.cpp b/utils/qv4l2/capture-win.cpp
index 2d57909..8722066 100644
--- a/utils/qv4l2/capture-win.cpp
+++ b/utils/qv4l2/capture-win.cpp
@@ -54,16 +54,22 @@ void CaptureWin::buildWindow(QWidget *videoSurface)
 	vbox->setSpacing(b);
 }
 
+QSize CaptureWin::getMargins()
+{
+	int l, t, r, b;
+	layout()->getContentsMargins(&l, &t, &r, &b);
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
index ca60244..f662bd3 100644
--- a/utils/qv4l2/capture-win.h
+++ b/utils/qv4l2/capture-win.h
@@ -78,6 +78,7 @@ public:
 protected:
 	void closeEvent(QCloseEvent *event);
 	void buildWindow(QWidget *videoSurface);
+	QSize getMargins();
 
 	/**
 	 * @brief A label that can is used to display capture information.
-- 
1.8.4.rc1

