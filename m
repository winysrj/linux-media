Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-2.cisco.com ([144.254.224.141]:24357 "EHLO
	ams-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966169Ab3HIMMb (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 9 Aug 2013 08:12:31 -0400
From: =?UTF-8?q?B=C3=A5rd=20Eirik=20Winther?= <bwinther@cisco.com>
To: linux-media@vger.kernel.org
Cc: baard.e.winther@wintherstormer.no
Subject: [PATCH FINAL 1/6] qv4l2: change m_scaledFrame to m_scaledSize
Date: Fri,  9 Aug 2013 14:12:07 +0200
Message-Id: <42a47889f837e362abc7a527c1029329e62034b0.1376049957.git.bwinther@cisco.com>
In-Reply-To: <1376050332-27290-1-git-send-email-bwinther@cisco.com>
References: <1376050332-27290-1-git-send-email-bwinther@cisco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Bård Eirik Winther <bwinther@cisco.com>
---
 utils/qv4l2/capture-win-qt.cpp | 12 ++++++------
 utils/qv4l2/capture-win-qt.h   |  2 +-
 2 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/utils/qv4l2/capture-win-qt.cpp b/utils/qv4l2/capture-win-qt.cpp
index f746379..82c618c 100644
--- a/utils/qv4l2/capture-win-qt.cpp
+++ b/utils/qv4l2/capture-win-qt.cpp
@@ -24,8 +24,8 @@ CaptureWinQt::CaptureWinQt() :
 {
 
 	CaptureWin::buildWindow(&m_videoSurface);
-	m_scaledFrame.setWidth(0);
-	m_scaledFrame.setHeight(0);
+	m_scaledSize.setWidth(0);
+	m_scaledSize.setHeight(0);
 }
 
 CaptureWinQt::~CaptureWinQt()
@@ -39,9 +39,9 @@ void CaptureWinQt::resizeEvent(QResizeEvent *event)
 		return;
 
 	QPixmap img = QPixmap::fromImage(*m_frame);
-	m_scaledFrame = scaleFrameSize(QSize(m_videoSurface.width(), m_videoSurface.height()),
+	m_scaledSize = scaleFrameSize(QSize(m_videoSurface.width(), m_videoSurface.height()),
 				       QSize(m_frame->width(), m_frame->height()));
-	img = img.scaled(m_scaledFrame.width(), m_scaledFrame.height(), Qt::IgnoreAspectRatio);
+	img = img.scaled(m_scaledSize.width(), m_scaledSize.height(), Qt::IgnoreAspectRatio);
 	m_videoSurface.setPixmap(img);
 	QWidget::resizeEvent(event);
 }
@@ -56,7 +56,7 @@ void CaptureWinQt::setFrame(int width, int height, __u32 format, unsigned char *
 	if (m_frame->width() != width || m_frame->height() != height || m_frame->format() != dstFmt) {
 		delete m_frame;
 		m_frame = new QImage(width, height, dstFmt);
-		m_scaledFrame = scaleFrameSize(QSize(m_videoSurface.width(), m_videoSurface.height()),
+		m_scaledSize = scaleFrameSize(QSize(m_videoSurface.width(), m_videoSurface.height()),
 					       QSize(m_frame->width(), m_frame->height()));
 	}
 
@@ -68,7 +68,7 @@ void CaptureWinQt::setFrame(int width, int height, __u32 format, unsigned char *
 	m_information.setText(info);
 
 	QPixmap img = QPixmap::fromImage(*m_frame);
-	img = img.scaled(m_scaledFrame.width(), m_scaledFrame.height(), Qt::IgnoreAspectRatio);
+	img = img.scaled(m_scaledSize.width(), m_scaledSize.height(), Qt::IgnoreAspectRatio);
 
 	m_videoSurface.setPixmap(img);
 }
diff --git a/utils/qv4l2/capture-win-qt.h b/utils/qv4l2/capture-win-qt.h
index 6029109..9faa12f 100644
--- a/utils/qv4l2/capture-win-qt.h
+++ b/utils/qv4l2/capture-win-qt.h
@@ -48,6 +48,6 @@ private:
 
 	QImage *m_frame;
 	QLabel m_videoSurface;
-	QSize m_scaledFrame;
+	QSize m_scaledSize;
 };
 #endif
-- 
1.8.4.rc1

