Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr12.xs4all.nl ([194.109.24.32]:4202 "EHLO
	smtp-vbr12.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759356Ab0CMWc5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 13 Mar 2010 17:32:57 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Subject: [PATCH for v4l-utils] qv4l2: fix UVC support
Date: Sat, 13 Mar 2010 23:33:16 +0100
Cc: Hans de Goede <j.w.r.degoede@hhs.nl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Message-Id: <201003132333.16618.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hans,

Can you apply this to v4l-utils?

Thanks!

	Hans

>From 977eb253a3e7a5257a2051da240314e2dac385bf Mon Sep 17 00:00:00 2001
From: Hans Verkuil <hverkuil@xs4all.nl>
Date: Sat, 13 Mar 2010 23:19:48 +0100
Subject: [PATCH] qv4l2: fix UVC support

The workaround for drivers using videobuf broke the UVC support.
Fix this.

Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
---
 utils/qv4l2-qt4/general-tab.cpp |   18 +++++++++++++++---
 utils/qv4l2-qt4/qv4l2.cpp       |    4 +++-
 2 files changed, 18 insertions(+), 4 deletions(-)

diff --git a/utils/qv4l2-qt4/general-tab.cpp b/utils/qv4l2-qt4/general-tab.cpp
index 50a3edc..706b15d 100644
--- a/utils/qv4l2-qt4/general-tab.cpp
+++ b/utils/qv4l2-qt4/general-tab.cpp
@@ -198,11 +198,23 @@ GeneralTab::GeneralTab(const QString &device, v4l2 &fd, int n, QWidget *parent)
 	if (m_querycap.capabilities & V4L2_CAP_STREAMING) {
 		v4l2_requestbuffers reqbuf;
 
-		if (reqbufs_user_cap(reqbuf, 1))
+		// Yuck. The videobuf framework does not accept a count of 0.
+		// This is out-of-spec, but it means that the only way to test which
+		// method is supported is to give it a non-zero count. But non-videobuf
+		// drivers like uvc do not allow e.g. S_FMT calls after a REQBUFS call
+		// with non-zero counts unless there is a REQBUFS call with count == 0
+		// in between. This is actual proper behavior, although somewhat
+		// unexpected. So the only way at the moment to do this that works
+		// everywhere is to call REQBUFS with a count of 1, and then again with
+	       	// a count of 0.
+		if (reqbufs_user_cap(reqbuf, 1)) {
 			m_capMethods->addItem("User pointer I/O", QVariant(methodUser));
-
-		if (reqbufs_mmap_cap(reqbuf, 1))
+			reqbufs_user_cap(reqbuf, 0);
+		}
+		if (reqbufs_mmap_cap(reqbuf, 1)) {
 			m_capMethods->addItem("Memory mapped I/O", QVariant(methodMmap));
+			reqbufs_mmap_cap(reqbuf, 0);
+		}
 	}
 	if (m_querycap.capabilities & V4L2_CAP_READWRITE) {
 		m_capMethods->addItem("read()", QVariant(methodRead));
diff --git a/utils/qv4l2-qt4/qv4l2.cpp b/utils/qv4l2-qt4/qv4l2.cpp
index 96cb4d7..63881be 100644
--- a/utils/qv4l2-qt4/qv4l2.cpp
+++ b/utils/qv4l2-qt4/qv4l2.cpp
@@ -352,7 +352,7 @@ void ApplicationWindow::stopCapture()
 			if (-1 == munmap(m_buffers[i].start, m_buffers[i].length))
 				perror("munmap");
 		// Free all buffers.
-		reqbufs_mmap_out(reqbufs, 0);
+		reqbufs_mmap_cap(reqbufs, 0);
 		break;
 
 	case methodUser:
@@ -360,6 +360,8 @@ void ApplicationWindow::stopCapture()
 			perror("VIDIOC_STREAMOFF");
 		for (i = 0; i < m_nbuffers; ++i)
 			free(m_buffers[i].start);
+		// Free all buffers.
+		reqbufs_user_cap(reqbufs, 0);
 		break;
 	}
 	free(m_buffers);
-- 
1.6.4.2


-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG
