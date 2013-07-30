Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-1.cisco.com ([144.254.224.140]:59847 "EHLO
	ams-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757976Ab3G3IPk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 30 Jul 2013 04:15:40 -0400
Received: from bwinther.cisco.com (dhcp-10-54-92-49.cisco.com [10.54.92.49])
	by ams-core-2.cisco.com (8.14.5/8.14.5) with ESMTP id r6U8FSuh022335
	for <linux-media@vger.kernel.org>; Tue, 30 Jul 2013 08:15:36 GMT
From: =?UTF-8?q?B=C3=A5rd=20Eirik=20Winther?= <bwinther@cisco.com>
To: linux-media@vger.kernel.org
Subject: [PATCHv2 FINAL 4/6] qv4l2: add Capture menu
Date: Tue, 30 Jul 2013 10:15:22 +0200
Message-Id: <871fbdba981d0f009b938f8cbdb931f952a2225b.1375172029.git.bwinther@cisco.com>
In-Reply-To: <1375172124-14439-1-git-send-email-bwinther@cisco.com>
References: <1375172124-14439-1-git-send-email-bwinther@cisco.com>
In-Reply-To: <fe355bb3e887a32d91640eb394ab9c069c8104a6.1375172029.git.bwinther@cisco.com>
References: <fe355bb3e887a32d91640eb394ab9c069c8104a6.1375172029.git.bwinther@cisco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Created a new Capture menu that contains both capture controls and audio/video settings for capture.

Signed-off-by: Bård Eirik Winther <bwinther@cisco.com>
---
 utils/qv4l2/qv4l2.cpp | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/utils/qv4l2/qv4l2.cpp b/utils/qv4l2/qv4l2.cpp
index bb1d84f..80937db 100644
--- a/utils/qv4l2/qv4l2.cpp
+++ b/utils/qv4l2/qv4l2.cpp
@@ -111,10 +111,8 @@ ApplicationWindow::ApplicationWindow() :
 	fileMenu->addAction(openAct);
 	fileMenu->addAction(openRawAct);
 	fileMenu->addAction(closeAct);
-	fileMenu->addAction(m_capStartAct);
 	fileMenu->addAction(m_snapshotAct);
 	fileMenu->addAction(m_saveRawAct);
-	fileMenu->addAction(m_showFramesAct);
 	fileMenu->addSeparator();
 	fileMenu->addAction(quitAct);
 
@@ -128,6 +126,10 @@ ApplicationWindow::ApplicationWindow() :
 	toolBar->addSeparator();
 	toolBar->addAction(quitAct);
 
+	QMenu *captureMenu = menuBar()->addMenu("&Capture");
+	captureMenu->addAction(m_capStartAct);
+	captureMenu->addAction(m_showFramesAct);
+
 	QMenu *helpMenu = menuBar()->addMenu("&Help");
 	helpMenu->addAction("&About", this, SLOT(about()), Qt::Key_F1);
 
-- 
1.8.3.2

