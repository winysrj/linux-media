Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-2.cisco.com ([144.254.224.141]:55761 "EHLO
	ams-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751795Ab3HFKTP (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 6 Aug 2013 06:19:15 -0400
Received: from bwinther.cisco.com (dhcp-10-54-92-83.cisco.com [10.54.92.83])
	by ams-core-2.cisco.com (8.14.5/8.14.5) with ESMTP id r76AJ9nG014605
	for <linux-media@vger.kernel.org>; Tue, 6 Aug 2013 10:19:11 GMT
From: =?UTF-8?q?B=C3=A5rd=20Eirik=20Winther?= <bwinther@cisco.com>
To: linux-media@vger.kernel.org
Subject: [PATCHv2 1/5] qv4l2: alter capture menu
Date: Tue,  6 Aug 2013 12:18:42 +0200
Message-Id: <1a734456df06299e284f793264ca843c98b0f18a.1375784295.git.bwinther@cisco.com>
In-Reply-To: <1375784326-18572-1-git-send-email-bwinther@cisco.com>
References: <1375784326-18572-1-git-send-email-bwinther@cisco.com>
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

