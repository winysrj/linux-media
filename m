Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-4.cisco.com ([144.254.224.147]:23517 "EHLO
	ams-iport-4.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755172Ab3HEI5n (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 5 Aug 2013 04:57:43 -0400
Received: from bwinther.cisco.com (dhcp-10-54-92-49.cisco.com [10.54.92.49])
	by ams-core-4.cisco.com (8.14.5/8.14.5) with ESMTP id r758vY7e001512
	for <linux-media@vger.kernel.org>; Mon, 5 Aug 2013 08:57:40 GMT
From: =?UTF-8?q?B=C3=A5rd=20Eirik=20Winther?= <bwinther@cisco.com>
To: linux-media@vger.kernel.org
Subject: [RFC PATCH 3/7] qv4l2: show frames option can be toggled during capture
Date: Mon,  5 Aug 2013 10:56:53 +0200
Message-Id: <e6cb8149fda41edf59a3fddf3dadd00430d40e0c.1375692973.git.bwinther@cisco.com>
In-Reply-To: <1375693017-6079-1-git-send-email-bwinther@cisco.com>
References: <1375693017-6079-1-git-send-email-bwinther@cisco.com>
In-Reply-To: <8be0aea2a33100972c3f9c74a8c981fca0e7a2aa.1375692973.git.bwinther@cisco.com>
References: <8be0aea2a33100972c3f9c74a8c981fca0e7a2aa.1375692973.git.bwinther@cisco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Bård Eirik Winther <bwinther@cisco.com>
---
 utils/qv4l2/qv4l2.cpp | 77 ++++++++++++++++++++++++++-------------------------
 utils/qv4l2/qv4l2.h   |  2 +-
 2 files changed, 41 insertions(+), 38 deletions(-)

diff --git a/utils/qv4l2/qv4l2.cpp b/utils/qv4l2/qv4l2.cpp
index e078e91..fa1425d 100644
--- a/utils/qv4l2/qv4l2.cpp
+++ b/utils/qv4l2/qv4l2.cpp
@@ -404,7 +404,7 @@ void ApplicationWindow::capVbiFrame()
 		m_capStartAct->setChecked(false);
 		return;
 	}
-	if (m_showFrames) {
+	if (showFrames()) {
 		for (unsigned y = 0; y < m_vbiHeight; y++) {
 			__u8 *p = data + y * m_vbiWidth;
 			__u8 *q = m_capImage->bits() + y * m_capImage->bytesPerLine();
@@ -448,7 +448,7 @@ void ApplicationWindow::capVbiFrame()
 		m_tv = tv;
 	}
 	status = QString("Frame: %1 Fps: %2").arg(++m_frame).arg(m_fps);
-	if (m_showFrames)
+	if (showFrames())
 		m_capture->setFrame(m_capImage->width(), m_capImage->height(),
 				    m_capDestFormat.fmt.pix.pixelformat, m_capImage->bits(), status);
 
@@ -490,7 +490,7 @@ void ApplicationWindow::capFrame()
 		if (m_saveRaw.openMode())
 			m_saveRaw.write((const char *)m_frameData, s);
 
-		if (!m_showFrames)
+		if (!showFrames())
 			break;
 		if (m_mustConvert)
 			err = v4lconvert_convert(m_convertData, &m_capSrcFormat, &m_capDestFormat,
@@ -514,7 +514,7 @@ void ApplicationWindow::capFrame()
 		if (again)
 			return;
 
-		if (m_showFrames) {
+		if (showFrames()) {
 			if (m_mustConvert)
 				err = v4lconvert_convert(m_convertData, &m_capSrcFormat, &m_capDestFormat,
 							 (unsigned char *)m_buffers[buf.index].start, buf.bytesused,
@@ -544,7 +544,7 @@ void ApplicationWindow::capFrame()
 		if (again)
 			return;
 
-		if (m_showFrames) {
+		if (showFrames()) {
 			if (m_mustConvert)
 				err = v4lconvert_convert(m_convertData, &m_capSrcFormat, &m_capDestFormat,
 							 (unsigned char *)buf.m.userptr, buf.bytesused,
@@ -592,10 +592,10 @@ void ApplicationWindow::capFrame()
 			      .arg((m_totalAudioLatency.tv_sec * 1000 + m_totalAudioLatency.tv_usec / 1000) / m_frame));
 	}
 #endif
-	if (displaybuf == NULL && m_showFrames)
+	if (displaybuf == NULL && showFrames())
 		status.append(" Error: Unsupported format.");
 
-	if (m_showFrames)
+	if (showFrames())
 		m_capture->setFrame(m_capImage->width(), m_capImage->height(),
 				    m_capDestFormat.fmt.pix.pixelformat, displaybuf, status);
 
@@ -778,6 +778,13 @@ void ApplicationWindow::stopCapture()
 	refresh();
 }
 
+bool ApplicationWindow::showFrames()
+{
+	if (m_showFramesAct->isChecked() && !m_capture->isVisible())
+		m_capture->show();
+	return m_showFramesAct->isChecked();
+}
+
 void ApplicationWindow::startOutput(unsigned)
 {
 }
@@ -851,7 +858,6 @@ void ApplicationWindow::capStart(bool start)
 		m_capImage = NULL;
 		return;
 	}
-	m_showFrames = m_showFramesAct->isChecked();
 	m_frame = m_lastFrame = m_fps = 0;
 	m_capMethod = m_genTab->capMethod();
 
@@ -859,7 +865,6 @@ void ApplicationWindow::capStart(bool start)
 		v4l2_format fmt;
 		v4l2_std_id std;
 
-		m_showFrames = false;
 		g_fmt_sliced_vbi(fmt);
 		g_std(std);
 		fmt.fmt.sliced.service_set = (std & V4L2_STD_625_50) ?
@@ -898,14 +903,14 @@ void ApplicationWindow::capStart(bool start)
 			m_vbiHeight = fmt.fmt.vbi.count[0] + fmt.fmt.vbi.count[1];
 		m_vbiSize = m_vbiWidth * m_vbiHeight;
 		m_frameData = new unsigned char[m_vbiSize];
-		if (m_showFrames) {
-			m_capture->setMinimumSize(m_vbiWidth, m_vbiHeight);
-			m_capImage = new QImage(m_vbiWidth, m_vbiHeight, dstFmt);
-			m_capImage->fill(0);
-			m_capture->setFrame(m_capImage->width(), m_capImage->height(),
-					    m_capDestFormat.fmt.pix.pixelformat, m_capImage->bits(), "No frame");
+		m_capture->setMinimumSize(m_vbiWidth, m_vbiHeight);
+		m_capImage = new QImage(m_vbiWidth, m_vbiHeight, dstFmt);
+		m_capImage->fill(0);
+		m_capture->setFrame(m_capImage->width(), m_capImage->height(),
+				    m_capDestFormat.fmt.pix.pixelformat, m_capImage->bits(), "No frame");
+		if (showFrames())
 			m_capture->show();
-		}
+
 		statusBar()->showMessage("No frame");
 		if (startCapture(m_vbiSize)) {
 			m_capNotifier = new QSocketNotifier(fd(), QSocketNotifier::Read, m_tabs);
@@ -919,30 +924,28 @@ void ApplicationWindow::capStart(bool start)
 	if (m_genTab->get_interval(interval))
 		set_interval(interval);
 
-	m_mustConvert = m_showFrames;
 	m_frameData = new unsigned char[srcPix.sizeimage];
-	if (m_showFrames) {
-		m_capDestFormat = m_capSrcFormat;
-		dstPix.pixelformat = V4L2_PIX_FMT_RGB24;
-
-		if (m_capture->hasNativeFormat(srcPix.pixelformat)) {
-			dstPix.pixelformat = srcPix.pixelformat;
-			m_mustConvert = false;
-		}
-
-		if (m_mustConvert) {
-			v4l2_format copy = m_capSrcFormat;
+	m_capDestFormat = m_capSrcFormat;
+	dstPix.pixelformat = V4L2_PIX_FMT_RGB24;
 
-			v4lconvert_try_format(m_convertData, &m_capDestFormat, &m_capSrcFormat);
-			// v4lconvert_try_format sometimes modifies the source format if it thinks
-			// that there is a better format available. Restore our selected source
-			// format since we do not want that happening.
-			m_capSrcFormat = copy;
-		}
+	if (m_capture->hasNativeFormat(srcPix.pixelformat)) {
+		dstPix.pixelformat = srcPix.pixelformat;
+		m_mustConvert = false;
+	} else {
+		m_mustConvert = true;
+		v4l2_format copy = m_capSrcFormat;
+
+		v4lconvert_try_format(m_convertData, &m_capDestFormat, &m_capSrcFormat);
+		// v4lconvert_try_format sometimes modifies the source format if it thinks
+		// that there is a better format available. Restore our selected source
+		// format since we do not want that happening.
+		m_capSrcFormat = copy;
+	}
 
-		m_capture->setMinimumSize(dstPix.width, dstPix.height);
-		m_capImage = new QImage(dstPix.width, dstPix.height, dstFmt);
-		m_capImage->fill(0);
+	m_capture->setMinimumSize(dstPix.width, dstPix.height);
+	m_capImage = new QImage(dstPix.width, dstPix.height, dstFmt);
+	m_capImage->fill(0);
+	if (showFrames()) {
 		m_capture->setFrame(m_capImage->width(), m_capImage->height(),
 				    m_capDestFormat.fmt.pix.pixelformat, m_capImage->bits(), "No frame");
 		m_capture->show();
diff --git a/utils/qv4l2/qv4l2.h b/utils/qv4l2/qv4l2.h
index 223db75..92d6f25 100644
--- a/utils/qv4l2/qv4l2.h
+++ b/utils/qv4l2/qv4l2.h
@@ -172,6 +172,7 @@ private:
 	void updateStandard();
 	void updateFreq();
 	void updateFreqChannel();
+	bool showFrames();
 
 	GeneralTab *m_genTab;
 	VbiTab *m_vbiTab;
@@ -193,7 +194,6 @@ private:
 	WidgetMap m_widgetMap;
 	ClassMap m_classMap;
 	bool m_haveExtendedUserCtrls;
-	bool m_showFrames;
 	int m_vbiSize;
 	unsigned m_vbiWidth;
 	unsigned m_vbiHeight;
-- 
1.8.3.2

