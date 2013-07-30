Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-3.cisco.com ([144.254.224.146]:14332 "EHLO
	ams-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754524Ab3G3IPm (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 30 Jul 2013 04:15:42 -0400
Received: from bwinther.cisco.com (dhcp-10-54-92-49.cisco.com [10.54.92.49])
	by ams-core-2.cisco.com (8.14.5/8.14.5) with ESMTP id r6U8FSui022335
	for <linux-media@vger.kernel.org>; Tue, 30 Jul 2013 08:15:38 GMT
From: =?UTF-8?q?B=C3=A5rd=20Eirik=20Winther?= <bwinther@cisco.com>
To: linux-media@vger.kernel.org
Subject: [PATCHv2 FINAL 5/6] qv4l2: new modular capture window design
Date: Tue, 30 Jul 2013 10:15:23 +0200
Message-Id: <1b19fe3d1ed8903a2071c21243dae904e35e0214.1375172029.git.bwinther@cisco.com>
In-Reply-To: <1375172124-14439-1-git-send-email-bwinther@cisco.com>
References: <1375172124-14439-1-git-send-email-bwinther@cisco.com>
In-Reply-To: <fe355bb3e887a32d91640eb394ab9c069c8104a6.1375172029.git.bwinther@cisco.com>
References: <fe355bb3e887a32d91640eb394ab9c069c8104a6.1375172029.git.bwinther@cisco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The display of video has been divided into classes to
easier implement other ways to render frames on screen.

Signed-off-by: Bård Eirik Winther <bwinther@cisco.com>
---
 utils/qv4l2/Makefile.am        |  4 +-
 utils/qv4l2/capture-win-qt.cpp | 89 +++++++++++++++++++++++++++++++++++++++
 utils/qv4l2/capture-win-qt.h   | 47 +++++++++++++++++++++
 utils/qv4l2/capture-win.cpp    | 45 ++++++++++----------
 utils/qv4l2/capture-win.h      | 24 ++++++-----
 utils/qv4l2/qv4l2.cpp          | 94 +++++++++++++++++++-----------------------
 utils/qv4l2/qv4l2.h            |  1 +
 7 files changed, 219 insertions(+), 85 deletions(-)
 create mode 100644 utils/qv4l2/capture-win-qt.cpp
 create mode 100644 utils/qv4l2/capture-win-qt.h

diff --git a/utils/qv4l2/Makefile.am b/utils/qv4l2/Makefile.am
index 1f5a49f..9ef8149 100644
--- a/utils/qv4l2/Makefile.am
+++ b/utils/qv4l2/Makefile.am
@@ -1,6 +1,7 @@
 bin_PROGRAMS = qv4l2
 
 qv4l2_SOURCES = qv4l2.cpp general-tab.cpp ctrl-tab.cpp vbi-tab.cpp v4l2-api.cpp capture-win.cpp \
+  capture-win-qt.cpp capture-win-qt.h \
   raw2sliced.cpp qv4l2.h capture-win.h general-tab.h vbi-tab.h v4l2-api.h raw2sliced.h
 nodist_qv4l2_SOURCES = moc_qv4l2.cpp moc_general-tab.cpp moc_capture-win.cpp moc_vbi-tab.cpp qrc_qv4l2.cpp
 qv4l2_LDADD = ../../lib/libv4l2/libv4l2.la ../../lib/libv4lconvert/libv4lconvert.la ../libv4l2util/libv4l2util.la
@@ -37,5 +38,4 @@ install-data-local:
 	$(INSTALL_DATA) -D -p "$(srcdir)/qv4l2_24x24.png" "$(DESTDIR)$(datadir)/icons/hicolor/24x24/apps/qv4l2.png"
 	$(INSTALL_DATA) -D -p "$(srcdir)/qv4l2_32x32.png" "$(DESTDIR)$(datadir)/icons/hicolor/32x32/apps/qv4l2.png"
 	$(INSTALL_DATA) -D -p "$(srcdir)/qv4l2_64x64.png" "$(DESTDIR)$(datadir)/icons/hicolor/64x64/apps/qv4l2.png"
-	$(INSTALL_DATA) -D -p "$(srcdir)/qv4l2.svg"       "$(DESTDIR)$(datadir)/icons/hicolor/scalable/apps/qv4l2.svg"
-
+	$(INSTALL_DATA) -D -p "$(srcdir)/qv4l2.svg"       "$(DESTDIR)$(datadir)/icons/hicolor/scalable/apps/qv4l2.svg"
\ No newline at end of file
diff --git a/utils/qv4l2/capture-win-qt.cpp b/utils/qv4l2/capture-win-qt.cpp
new file mode 100644
index 0000000..63c77d5
--- /dev/null
+++ b/utils/qv4l2/capture-win-qt.cpp
@@ -0,0 +1,89 @@
+/* qv4l2: a control panel controlling v4l2 devices.
+ *
+ * Copyright (C) 2006 Hans Verkuil <hverkuil@xs4all.nl>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version 2
+ * of the License, or (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
+ */
+
+#include "capture-win-qt.h"
+
+CaptureWinQt::CaptureWinQt() :
+	m_frame(new QImage(0, 0, QImage::Format_Invalid))
+{
+
+	CaptureWin::buildWindow(&m_videoSurface);
+}
+
+CaptureWinQt::~CaptureWinQt()
+{
+	delete m_frame;
+}
+
+void CaptureWinQt::setFrame(int width, int height, __u32 format, unsigned char *data, const QString &info)
+{
+	QImage::Format dstFmt;
+	bool supported = findNativeFormat(format, dstFmt);
+	if (!supported)
+		dstFmt = QImage::Format_RGB888;
+
+	if (m_frame->width() != width || m_frame->height() != height || m_frame->format() != dstFmt) {
+		delete m_frame;
+		m_frame = new QImage(width, height, dstFmt);
+	}
+
+	if (data == NULL || !supported)
+		m_frame->fill(0);
+	else
+		memcpy(m_frame->bits(), data, m_frame->numBytes());
+
+	m_information.setText(info);
+	m_videoSurface.setPixmap(QPixmap::fromImage(*m_frame));
+}
+
+bool CaptureWinQt::hasNativeFormat(__u32 format)
+{
+	QImage::Format fmt;
+	return findNativeFormat(format, fmt);
+}
+
+bool CaptureWinQt::findNativeFormat(__u32 format, QImage::Format &dstFmt)
+{
+	static const struct {
+		__u32 v4l2_pixfmt;
+		QImage::Format qt_pixfmt;
+	} supported_fmts[] = {
+#if Q_BYTE_ORDER == Q_BIG_ENDIAN
+		{ V4L2_PIX_FMT_RGB32, QImage::Format_RGB32 },
+		{ V4L2_PIX_FMT_RGB24, QImage::Format_RGB888 },
+		{ V4L2_PIX_FMT_RGB565X, QImage::Format_RGB16 },
+		{ V4L2_PIX_FMT_RGB555X, QImage::Format_RGB555 },
+#else
+		{ V4L2_PIX_FMT_BGR32, QImage::Format_RGB32 },
+		{ V4L2_PIX_FMT_RGB24, QImage::Format_RGB888 },
+		{ V4L2_PIX_FMT_RGB565, QImage::Format_RGB16 },
+		{ V4L2_PIX_FMT_RGB555, QImage::Format_RGB555 },
+		{ V4L2_PIX_FMT_RGB444, QImage::Format_RGB444 },
+#endif
+		{ 0, QImage::Format_Invalid }
+	};
+
+	for (int i = 0; supported_fmts[i].v4l2_pixfmt; i++) {
+		if (supported_fmts[i].v4l2_pixfmt == format) {
+			dstFmt = supported_fmts[i].qt_pixfmt;
+			return true;
+		}
+	}
+	return false;
+}
diff --git a/utils/qv4l2/capture-win-qt.h b/utils/qv4l2/capture-win-qt.h
new file mode 100644
index 0000000..d3b4fe8
--- /dev/null
+++ b/utils/qv4l2/capture-win-qt.h
@@ -0,0 +1,47 @@
+/* qv4l2: a control panel controlling v4l2 devices.
+ *
+ * Copyright (C) 2006 Hans Verkuil <hverkuil@xs4all.nl>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version 2
+ * of the License, or (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
+ */
+
+#ifndef CAPTURE_WIN_QT_H
+#define CAPTURE_WIN_QT_H
+
+#include "qv4l2.h"
+#include "capture-win.h"
+
+#include <QLabel>
+#include <QImage>
+
+class CaptureWinQt : public CaptureWin
+{
+public:
+	CaptureWinQt();
+	~CaptureWinQt();
+
+	void setFrame(int width, int height, __u32 format,
+		      unsigned char *data, const QString &info);
+
+	bool hasNativeFormat(__u32 format);
+	static bool isSupported() { return true; }
+
+private:
+	bool findNativeFormat(__u32 format, QImage::Format &dstFmt);
+
+	QImage *m_frame;
+	QLabel m_videoSurface;
+};
+#endif
diff --git a/utils/qv4l2/capture-win.cpp b/utils/qv4l2/capture-win.cpp
index 68dc9ed..2d57909 100644
--- a/utils/qv4l2/capture-win.cpp
+++ b/utils/qv4l2/capture-win.cpp
@@ -16,35 +16,42 @@
  * along with this program; if not, write to the Free Software
  * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
  */
-#include <stdio.h>
+
+#include "capture-win.h"
+
+#include <QCloseEvent>
 #include <QLabel>
 #include <QImage>
 #include <QVBoxLayout>
-#include <QCloseEvent>
 #include <QApplication>
 #include <QDesktopWidget>
 
-#include "qv4l2.h"
-#include "capture-win.h"
-
 CaptureWin::CaptureWin()
 {
-	QVBoxLayout *vbox = new QVBoxLayout(this);
-
 	setWindowTitle("V4L2 Capture");
-	m_label = new QLabel();
-	m_msg = new QLabel("No frame");
+	m_hotkeyClose = new QShortcut(Qt::CTRL+Qt::Key_W, this);
+	QObject::connect(m_hotkeyClose, SIGNAL(activated()), this, SLOT(close()));
+}
 
-	vbox->addWidget(m_label);
-	vbox->addWidget(m_msg);
+CaptureWin::~CaptureWin()
+{
+	if (layout() == NULL)
+		return;
 
-	hotkeyClose = new QShortcut(Qt::CTRL+Qt::Key_W, this);
-	QObject::connect(hotkeyClose, SIGNAL(activated()), this, SLOT(close()));
+	layout()->removeWidget(this);
+	delete layout();
+	delete m_hotkeyClose;
 }
 
-CaptureWin::~CaptureWin()
+void CaptureWin::buildWindow(QWidget *videoSurface)
 {
-	delete hotkeyClose;
+	int l, t, r, b;
+	QVBoxLayout *vbox = new QVBoxLayout(this);
+	m_information.setText("No Frame");
+	vbox->addWidget(videoSurface, 2000);
+	vbox->addWidget(&m_information, 1, Qt::AlignBottom);
+	vbox->getContentsMargins(&l, &t, &r, &b);
+	vbox->setSpacing(b);
 }
 
 void CaptureWin::setMinimumSize(int minw, int minh)
@@ -56,7 +63,7 @@ void CaptureWin::setMinimumSize(int minw, int minh)
 	int l, t, r, b;
 	layout()->getContentsMargins(&l, &t, &r, &b);
 	minw += l + r;
-	minh += t + b + m_msg->minimumSizeHint().height() + layout()->spacing();
+	minh += t + b + m_information.minimumSizeHint().height() + layout()->spacing();
 
 	if (minw > resolution.width())
 		minw = resolution.width();
@@ -74,12 +81,6 @@ void CaptureWin::setMinimumSize(int minw, int minh)
 	QWidget::setMaximumSize(maxSize.width(), maxSize.height());
 }
 
-void CaptureWin::setImage(const QImage &image, const QString &status)
-{
-	m_label->setPixmap(QPixmap::fromImage(image));
-	m_msg->setText(status);
-}
-
 void CaptureWin::closeEvent(QCloseEvent *event)
 {
 	QWidget::closeEvent(event);
diff --git a/utils/qv4l2/capture-win.h b/utils/qv4l2/capture-win.h
index 3925757..c3b7d98 100644
--- a/utils/qv4l2/capture-win.h
+++ b/utils/qv4l2/capture-win.h
@@ -20,12 +20,11 @@
 #ifndef CAPTURE_WIN_H
 #define CAPTURE_WIN_H
 
+#include "qv4l2.h"
+
 #include <QWidget>
 #include <QShortcut>
-#include <sys/time.h>
-
-class QImage;
-class QLabel;
+#include <QLabel>
 
 class CaptureWin : public QWidget
 {
@@ -36,18 +35,23 @@ public:
 	~CaptureWin();
 
 	void setMinimumSize(int minw, int minh);
-	void setImage(const QImage &image, const QString &status);
+	virtual void setFrame(int width, int height, __u32 format,
+			      unsigned char *data, const QString &info) = 0;
+
+	virtual bool hasNativeFormat(__u32 format) = 0;
+	static bool isSupported() { return false; }
 
 protected:
-	virtual void closeEvent(QCloseEvent *event);
+	void closeEvent(QCloseEvent *event);
+	void buildWindow(QWidget *videoSurface);
+
+	QLabel m_information;
 
 signals:
 	void close();
 
 private:
-	QLabel *m_label;
-	QLabel *m_msg;
-	QShortcut *hotkeyClose;
-};
+	QShortcut *m_hotkeyClose;
 
+};
 #endif
diff --git a/utils/qv4l2/qv4l2.cpp b/utils/qv4l2/qv4l2.cpp
index 80937db..0c9b74c 100644
--- a/utils/qv4l2/qv4l2.cpp
+++ b/utils/qv4l2/qv4l2.cpp
@@ -21,6 +21,7 @@
 #include "general-tab.h"
 #include "vbi-tab.h"
 #include "capture-win.h"
+#include "capture-win-qt.h"
 
 #include <QToolBar>
 #include <QToolButton>
@@ -160,7 +161,7 @@ void ApplicationWindow::setDevice(const QString &device, bool rawOpen)
 	if (!open(device, !rawOpen))
 		return;
 
-	m_capture = new CaptureWin;
+	m_capture = new CaptureWinQt;
 	m_capture->setMinimumSize(150, 50);
 	connect(m_capture, SIGNAL(close()), this, SLOT(closeCaptureWin()));
 
@@ -347,7 +348,9 @@ void ApplicationWindow::capVbiFrame()
 	}
 	status = QString("Frame: %1 Fps: %2").arg(++m_frame).arg(m_fps);
 	if (m_showFrames)
-		m_capture->setImage(*m_capImage, status);
+		m_capture->setFrame(m_capImage->width(), m_capImage->height(),
+				    m_capDestFormat.fmt.pix.pixelformat, m_capImage->bits(), status);
+
 	curStatus = statusBar()->currentMessage();
 	if (curStatus.isEmpty() || curStatus.startsWith("Frame: "))
 		statusBar()->showMessage(status);
@@ -363,6 +366,8 @@ void ApplicationWindow::capFrame()
 	int err = 0;
 	bool again;
 
+	unsigned char *displaybuf = NULL;
+
 	switch (m_capMethod) {
 	case methodRead:
 		s = read(m_frameData, m_capSrcFormat.fmt.pix.sizeimage);
@@ -382,10 +387,12 @@ void ApplicationWindow::capFrame()
 			break;
 		if (m_mustConvert)
 			err = v4lconvert_convert(m_convertData, &m_capSrcFormat, &m_capDestFormat,
-				m_frameData, s,
-				m_capImage->bits(), m_capDestFormat.fmt.pix.sizeimage);
-		if (!m_mustConvert || err < 0)
-			memcpy(m_capImage->bits(), m_frameData, std::min(s, m_capImage->numBytes()));
+						 m_frameData, s,
+						 m_capImage->bits(), m_capDestFormat.fmt.pix.sizeimage);
+		if (m_mustConvert && err != -1)
+			displaybuf = m_capImage->bits();
+		if (!m_mustConvert)
+			displaybuf = m_frameData;
 		break;
 
 	case methodMmap:
@@ -399,21 +406,19 @@ void ApplicationWindow::capFrame()
 
 		if (m_showFrames) {
 			if (m_mustConvert)
-				err = v4lconvert_convert(m_convertData,
-					&m_capSrcFormat, &m_capDestFormat,
-					(unsigned char *)m_buffers[buf.index].start, buf.bytesused,
-					m_capImage->bits(), m_capDestFormat.fmt.pix.sizeimage);
-			if (!m_mustConvert || err < 0)
-				memcpy(m_capImage->bits(),
-				       (unsigned char *)m_buffers[buf.index].start,
-				       std::min(buf.bytesused, (unsigned)m_capImage->numBytes()));
+				err = v4lconvert_convert(m_convertData, &m_capSrcFormat, &m_capDestFormat,
+							 (unsigned char *)m_buffers[buf.index].start, buf.bytesused,
+							 m_capImage->bits(), m_capDestFormat.fmt.pix.sizeimage);
+			if (m_mustConvert && err != -1)
+				displaybuf = m_capImage->bits();
+			if (!m_mustConvert)
+				displaybuf = (unsigned char *)m_buffers[buf.index].start;
 		}
 		if (m_makeSnapshot)
 			makeSnapshot((unsigned char *)m_buffers[buf.index].start, buf.bytesused);
 		if (m_saveRaw.openMode())
 			m_saveRaw.write((const char *)m_buffers[buf.index].start, buf.bytesused);
 
-		qbuf(buf);
 		break;
 
 	case methodUser:
@@ -427,20 +432,19 @@ void ApplicationWindow::capFrame()
 
 		if (m_showFrames) {
 			if (m_mustConvert)
-				err = v4lconvert_convert(m_convertData,
-					&m_capSrcFormat, &m_capDestFormat,
-					(unsigned char *)buf.m.userptr, buf.bytesused,
-					m_capImage->bits(), m_capDestFormat.fmt.pix.sizeimage);
-			if (!m_mustConvert || err < 0)
-				memcpy(m_capImage->bits(), (unsigned char *)buf.m.userptr,
-				       std::min(buf.bytesused, (unsigned)m_capImage->numBytes()));
+				err = v4lconvert_convert(m_convertData, &m_capSrcFormat, &m_capDestFormat,
+							 (unsigned char *)buf.m.userptr, buf.bytesused,
+							 m_capImage->bits(), m_capDestFormat.fmt.pix.sizeimage);
+			if (m_mustConvert && err != -1)
+				displaybuf = m_capImage->bits();
+			if (!m_mustConvert)
+				displaybuf = (unsigned char *)buf.m.userptr;
 		}
 		if (m_makeSnapshot)
 			makeSnapshot((unsigned char *)buf.m.userptr, buf.bytesused);
 		if (m_saveRaw.openMode())
 			m_saveRaw.write((const char *)buf.m.userptr, buf.bytesused);
 
-		qbuf(buf);
 		break;
 	}
 	if (err == -1 && m_frame == 0)
@@ -460,8 +464,15 @@ void ApplicationWindow::capFrame()
 		m_tv = tv;
 	}
 	status = QString("Frame: %1 Fps: %2").arg(++m_frame).arg(m_fps);
+	if (displaybuf == NULL && m_showFrames)
+		status.append(" Error: Unsupported format.");
 	if (m_showFrames)
-		m_capture->setImage(*m_capImage, status);
+		m_capture->setFrame(m_capImage->width(), m_capImage->height(),
+				    m_capDestFormat.fmt.pix.pixelformat, displaybuf, status);
+
+	if (m_capMethod == methodMmap || m_capMethod == methodUser)
+		qbuf(buf);
+
 	curStatus = statusBar()->currentMessage();
 	if (curStatus.isEmpty() || curStatus.startsWith("Frame: "))
 		statusBar()->showMessage(status);
@@ -642,24 +653,6 @@ void ApplicationWindow::closeCaptureWin()
 
 void ApplicationWindow::capStart(bool start)
 {
-	static const struct {
-		__u32 v4l2_pixfmt;
-		QImage::Format qt_pixfmt;
-	} supported_fmts[] = {
-#if Q_BYTE_ORDER == Q_BIG_ENDIAN
-		{ V4L2_PIX_FMT_RGB32, QImage::Format_RGB32 },
-		{ V4L2_PIX_FMT_RGB24, QImage::Format_RGB888 },
-		{ V4L2_PIX_FMT_RGB565X, QImage::Format_RGB16 },
-		{ V4L2_PIX_FMT_RGB555X, QImage::Format_RGB555 },
-#else
-		{ V4L2_PIX_FMT_BGR32, QImage::Format_RGB32 },
-		{ V4L2_PIX_FMT_RGB24, QImage::Format_RGB888 },
-		{ V4L2_PIX_FMT_RGB565, QImage::Format_RGB16 },
-		{ V4L2_PIX_FMT_RGB555, QImage::Format_RGB555 },
-		{ V4L2_PIX_FMT_RGB444, QImage::Format_RGB444 },
-#endif
-		{ 0, QImage::Format_Invalid }
-	};
 	QImage::Format dstFmt = QImage::Format_RGB888;
 	struct v4l2_fract interval;
 	v4l2_pix_format &srcPix = m_capSrcFormat.fmt.pix;
@@ -724,7 +717,8 @@ void ApplicationWindow::capStart(bool start)
 			m_capture->setMinimumSize(m_vbiWidth, m_vbiHeight);
 			m_capImage = new QImage(m_vbiWidth, m_vbiHeight, dstFmt);
 			m_capImage->fill(0);
-			m_capture->setImage(*m_capImage, "No frame");
+			m_capture->setFrame(m_capImage->width(), m_capImage->height(),
+					    m_capDestFormat.fmt.pix.pixelformat, m_capImage->bits(), "No frame");
 			m_capture->show();
 		}
 		statusBar()->showMessage("No frame");
@@ -746,14 +740,11 @@ void ApplicationWindow::capStart(bool start)
 		m_capDestFormat = m_capSrcFormat;
 		dstPix.pixelformat = V4L2_PIX_FMT_RGB24;
 
-		for (int i = 0; supported_fmts[i].v4l2_pixfmt; i++) {
-			if (supported_fmts[i].v4l2_pixfmt == srcPix.pixelformat) {
-				dstPix.pixelformat = supported_fmts[i].v4l2_pixfmt;
-				dstFmt = supported_fmts[i].qt_pixfmt;
-				m_mustConvert = false;
-				break;
-			}
+		if (m_capture->hasNativeFormat(srcPix.pixelformat)) {
+			dstPix.pixelformat = srcPix.pixelformat;
+			m_mustConvert = false;
 		}
+
 		if (m_mustConvert) {
 			v4l2_format copy = m_capSrcFormat;
 
@@ -767,7 +758,8 @@ void ApplicationWindow::capStart(bool start)
 		m_capture->setMinimumSize(dstPix.width, dstPix.height);
 		m_capImage = new QImage(dstPix.width, dstPix.height, dstFmt);
 		m_capImage->fill(0);
-		m_capture->setImage(*m_capImage, "No frame");
+		m_capture->setFrame(m_capImage->width(), m_capImage->height(),
+				    m_capDestFormat.fmt.pix.pixelformat, m_capImage->bits(), "No frame");
 		m_capture->show();
 	}
 
diff --git a/utils/qv4l2/qv4l2.h b/utils/qv4l2/qv4l2.h
index 8634948..ccfc2f9 100644
--- a/utils/qv4l2/qv4l2.h
+++ b/utils/qv4l2/qv4l2.h
@@ -33,6 +33,7 @@
 
 #include "v4l2-api.h"
 #include "raw2sliced.h"
+#include "capture-win.h"
 
 class QComboBox;
 class QSpinBox;
-- 
1.8.3.2

