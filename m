Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-4.cisco.com ([144.254.224.147]:35602 "EHLO
	ams-iport-4.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933500Ab3HHMbt (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 8 Aug 2013 08:31:49 -0400
Received: from bwinther.cisco.com (dhcp-10-54-92-90.cisco.com [10.54.92.90])
	by ams-core-2.cisco.com (8.14.5/8.14.5) with ESMTP id r78CVcja014622
	for <linux-media@vger.kernel.org>; Thu, 8 Aug 2013 12:31:46 GMT
From: =?UTF-8?q?B=C3=A5rd=20Eirik=20Winther?= <bwinther@cisco.com>
To: linux-media@vger.kernel.org
Subject: [PATCHv2 4/9] qv4l2: show frames option can be toggled during capture
Date: Thu,  8 Aug 2013 14:31:22 +0200
Message-Id: <085adf63bb06b7fd0875fd04d668d28ab1c332f4.1375964980.git.bwinther@cisco.com>
In-Reply-To: <1375965087-16318-1-git-send-email-bwinther@cisco.com>
References: <1375965087-16318-1-git-send-email-bwinther@cisco.com>
In-Reply-To: <cdb6d3a353ce89599cd716e763e85e704b92f79c.1375964980.git.bwinther@cisco.com>
References: <cdb6d3a353ce89599cd716e763e85e704b92f79c.1375964980.git.bwinther@cisco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Bård Eirik Winther <bwinther@cisco.com>
---
 utils/qv4l2/qv4l2.cpp | 84 +++++++++++++++++++++++++++------------------------
 utils/qv4l2/qv4l2.h   |  2 +-
 2 files changed, 46 insertions(+), 40 deletions(-)

diff --git a/utils/qv4l2/qv4l2.cpp b/utils/qv4l2/qv4l2.cpp
index 6f39726..e33254d 100644
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
 
@@ -491,7 +491,7 @@ void ApplicationWindow::capFrame()
 		if (m_saveRaw.openMode())
 			m_saveRaw.write((const char *)m_frameData, s);
 
-		if (!m_showFrames)
+		if (!showFrames())
 			break;
 		if (m_mustConvert)
 			err = v4lconvert_convert(m_convertData, &m_capSrcFormat, &m_capDestFormat,
@@ -515,7 +515,7 @@ void ApplicationWindow::capFrame()
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
@@ -590,10 +590,10 @@ void ApplicationWindow::capFrame()
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
 
@@ -776,6 +776,15 @@ void ApplicationWindow::stopCapture()
 	refresh();
 }
 
+bool ApplicationWindow::showFrames()
+{
+	if (m_showFramesAct->isChecked() && !m_capture->isVisible())
+		m_capture->show();
+	if (!m_showFramesAct->isChecked() && m_capture->isVisible())
+		m_capture->hide();
+	return m_showFramesAct->isChecked();
+}
+
 void ApplicationWindow::startOutput(unsigned)
 {
 }
@@ -849,7 +858,6 @@ void ApplicationWindow::capStart(bool start)
 		m_capImage = NULL;
 		return;
 	}
-	m_showFrames = m_showFramesAct->isChecked();
 	m_frame = m_lastFrame = m_fps = 0;
 	m_capMethod = m_genTab->capMethod();
 
@@ -857,7 +865,6 @@ void ApplicationWindow::capStart(bool start)
 		v4l2_format fmt;
 		v4l2_std_id std;
 
-		m_showFrames = false;
 		g_fmt_sliced_vbi(fmt);
 		g_std(std);
 		fmt.fmt.sliced.service_set = (std & V4L2_STD_625_50) ?
@@ -896,14 +903,14 @@ void ApplicationWindow::capStart(bool start)
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
@@ -917,33 +924,32 @@ void ApplicationWindow::capStart(bool start)
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
+	m_capDestFormat = m_capSrcFormat;
+	dstPix.pixelformat = V4L2_PIX_FMT_RGB24;
 
-		if (m_mustConvert) {
-			v4l2_format copy = m_capSrcFormat;
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
 
-			v4lconvert_try_format(m_convertData, &m_capDestFormat, &m_capSrcFormat);
-			// v4lconvert_try_format sometimes modifies the source format if it thinks
-			// that there is a better format available. Restore our selected source
-			// format since we do not want that happening.
-			m_capSrcFormat = copy;
-		}
+	m_capture->setMinimumSize(dstPix.width, dstPix.height);
+	// Ensure that the initial image is large enough for native 32 bit per pixel formats
+	if (dstPix.pixelformat == V4L2_PIX_FMT_RGB32 || dstPix.pixelformat == V4L2_PIX_FMT_BGR32)
+		dstFmt = QImage::Format_ARGB32;
+	m_capImage = new QImage(dstPix.width, dstPix.height, dstFmt);
+	m_capImage->fill(0);
 
-		m_capture->setMinimumSize(dstPix.width, dstPix.height);
-		// Ensure that the initial image is large enough for native 32 bit per pixel formats
-		if (dstPix.pixelformat == V4L2_PIX_FMT_RGB32 || dstPix.pixelformat == V4L2_PIX_FMT_BGR32)
-			dstFmt = QImage::Format_ARGB32;
-		m_capImage = new QImage(dstPix.width, dstPix.height, dstFmt);
-		m_capImage->fill(0);
+	if (showFrames()) {
 		m_capture->setFrame(m_capImage->width(), m_capImage->height(),
 				    m_capDestFormat.fmt.pix.pixelformat, m_capImage->bits(), "No frame");
 		m_capture->show();
diff --git a/utils/qv4l2/qv4l2.h b/utils/qv4l2/qv4l2.h
index 511a652..dd9db44 100644
--- a/utils/qv4l2/qv4l2.h
+++ b/utils/qv4l2/qv4l2.h
@@ -174,6 +174,7 @@ private:
 	void updateStandard();
 	void updateFreq();
 	void updateFreqChannel();
+	bool showFrames();
 
 	GeneralTab *m_genTab;
 	VbiTab *m_vbiTab;
@@ -195,7 +196,6 @@ private:
 	WidgetMap m_widgetMap;
 	ClassMap m_classMap;
 	bool m_haveExtendedUserCtrls;
-	bool m_showFrames;
 	int m_vbiSize;
 	unsigned m_vbiWidth;
 	unsigned m_vbiHeight;
-- 
1.8.4.rc1

