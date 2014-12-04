Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.22]:59216 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933203AbaLDX1L (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 4 Dec 2014 18:27:11 -0500
Received: from linux.local ([94.216.58.185]) by mail.gmx.com (mrgmx103) with
 ESMTPSA (Nemesis) id 0Lk81O-1XQ54R1C9q-00cCq6 for
 <linux-media@vger.kernel.org>; Fri, 05 Dec 2014 00:27:09 +0100
From: Peter Seiderer <ps.report@gmx.net>
To: linux-media@vger.kernel.org
Subject: [PATCH 2/3] qv4l2: fix qt5 compile
Date: Fri,  5 Dec 2014 00:27:06 +0100
Message-Id: <1417735627-13945-2-git-send-email-ps.report@gmx.net>
In-Reply-To: <1417735627-13945-1-git-send-email-ps.report@gmx.net>
References: <1417735627-13945-1-git-send-email-ps.report@gmx.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Peter Seiderer <ps.report@gmx.net>
---
 utils/qv4l2/capture-win-qt.cpp |  4 ++++
 utils/qv4l2/qv4l2.cpp          | 21 +++++++++++++++++++++
 2 files changed, 25 insertions(+)

diff --git a/utils/qv4l2/capture-win-qt.cpp b/utils/qv4l2/capture-win-qt.cpp
index db85cd2..9c849a0 100644
--- a/utils/qv4l2/capture-win-qt.cpp
+++ b/utils/qv4l2/capture-win-qt.cpp
@@ -117,7 +117,11 @@ void CaptureWinQt::paintFrame()
 void CaptureWinQt::stop()
 {
 	if (m_data != NULL)
+#if QT_VERSION >= 0x050000
+		memcpy(m_image->bits(), m_data, m_image->byteCount());
+#else
 		memcpy(m_image->bits(), m_data, m_image->numBytes());
+#endif
 	m_data = NULL;
 }
 
diff --git a/utils/qv4l2/qv4l2.cpp b/utils/qv4l2/qv4l2.cpp
index 0784a15..8329cbd 100644
--- a/utils/qv4l2/qv4l2.cpp
+++ b/utils/qv4l2/qv4l2.cpp
@@ -1084,8 +1084,13 @@ void ApplicationWindow::startAudio()
 	QString audOut = m_genTab->getAudioOutDevice();
 
 	if (audIn != NULL && audOut != NULL && audIn.compare("None") && audIn.compare(audOut) != 0) {
+#if QT_VERSION >= 0x050000
+		alsa_thread_startup(audOut.toLatin1().data(), audIn.toLatin1().data(),
+				    m_genTab->getAudioDeviceBufferSize(), NULL, 0);
+#else
 		alsa_thread_startup(audOut.toAscii().data(), audIn.toAscii().data(),
 				    m_genTab->getAudioDeviceBufferSize(), NULL, 0);
+#endif
 
 		if (m_genTab->isRadio())
 			statusBar()->showMessage("Capturing audio");
@@ -1582,7 +1587,11 @@ void ApplicationWindow::error(const QString &error)
 {
 	statusBar()->showMessage(error, 20000);
 	if (!error.isEmpty())
+#if QT_VERSION >= 0x050000
+		fprintf(stderr, "%s\n", error.toLatin1().data());
+#else
 		fprintf(stderr, "%s\n", error.toAscii().data());
+#endif
 }
 
 void ApplicationWindow::error(int err)
@@ -1657,7 +1666,11 @@ static bool processShortOption(const QStringList &args, int &i, QString &dev)
 		return false;
 	if (args[i].length() == 2) {
 		if (i + 1 >= args.size()) {
+#if QT_VERSION >= 0x050000
+			usageError(args[i].toLatin1());
+#else
 			usageError(args[i].toAscii());
+#endif
 			return false;
 		}
 		dev = args[++i];
@@ -1680,7 +1693,11 @@ static bool processLongOption(const QStringList &args, int &i, QString &dev)
 		return true;
 	}
 	if (i + 1 >= args.size()) {
+#if QT_VERSION >= 0x050000
+		usageError(args[i].toLatin1());
+#else
 		usageError(args[i].toAscii());
+#endif
 		return false;
 	}
 	dev = args[++i];
@@ -1734,7 +1751,11 @@ int main(int argc, char **argv)
 		} else if (args[i] == "-R" || args[i] == "--raw") {
 			raw = true;
 		} else {
+#if QT_VERSION >= 0x050000
+			printf("Invalid argument %s\n", args[i].toLatin1().data());
+#else
 			printf("Invalid argument %s\n", args[i].toAscii().data());
+#endif
 			return 0;
 		}
 	}
-- 
2.1.2

