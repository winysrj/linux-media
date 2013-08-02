Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-3.cisco.com ([144.254.224.146]:20013 "EHLO
	ams-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751821Ab3HBMFy (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 2 Aug 2013 08:05:54 -0400
Received: from bwinther.cisco.com (dhcp-10-54-92-49.cisco.com [10.54.92.49])
	by ams-core-3.cisco.com (8.14.5/8.14.5) with ESMTP id r72C5nZ6017931
	for <linux-media@vger.kernel.org>; Fri, 2 Aug 2013 12:05:51 GMT
From: =?UTF-8?q?B=C3=A5rd=20Eirik=20Winther?= <bwinther@cisco.com>
To: linux-media@vger.kernel.org
Subject: [PATCH 1/5] qv4l2: alter capture menu
Date: Fri,  2 Aug 2013 14:05:33 +0200
Message-Id: <1a734456df06299e284f793264ca843c98b0f18a.1375445112.git.bwinther@cisco.com>
In-Reply-To: <1375445137-19443-1-git-send-email-bwinther@cisco.com>
References: <1375445137-19443-1-git-send-email-bwinther@cisco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Corrected Use OpenGL Render to Rendering and removed the separation line.

Signed-off-by: Bård Eirik Winther <bwinther@cisco.com>
---
 utils/qv4l2/qv4l2.cpp | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/utils/qv4l2/qv4l2.cpp b/utils/qv4l2/qv4l2.cpp
index 4dc5a3e..275b399 100644
--- a/utils/qv4l2/qv4l2.cpp
+++ b/utils/qv4l2/qv4l2.cpp
@@ -131,12 +131,11 @@ ApplicationWindow::ApplicationWindow() :
 	QMenu *captureMenu = menuBar()->addMenu("&Capture");
 	captureMenu->addAction(m_capStartAct);
 	captureMenu->addAction(m_showFramesAct);
-	captureMenu->addSeparator();
 
 	if (CaptureWinGL::isSupported()) {
 		m_renderMethod = QV4L2_RENDER_GL;
 
-		m_useGLAct = new QAction("Use Open&GL Render", this);
+		m_useGLAct = new QAction("Use Open&GL Rendering", this);
 		m_useGLAct->setStatusTip("Use GPU with OpenGL for video capture if set.");
 		m_useGLAct->setCheckable(true);
 		m_useGLAct->setChecked(true);
-- 
1.8.3.2

