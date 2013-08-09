Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-2.cisco.com ([144.254.224.141]:57427 "EHLO
	ams-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966869Ab3HIMMl (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 9 Aug 2013 08:12:41 -0400
From: =?UTF-8?q?B=C3=A5rd=20Eirik=20Winther?= <bwinther@cisco.com>
To: linux-media@vger.kernel.org
Cc: baard.e.winther@wintherstormer.no
Subject: [PATCH FINAL 6/6] qv4l2: updated about window
Date: Fri,  9 Aug 2013 14:12:12 +0200
Message-Id: <c3afbe91f8b2590274fc8a6e60b065eb82c5324a.1376049957.git.bwinther@cisco.com>
In-Reply-To: <1376050332-27290-1-git-send-email-bwinther@cisco.com>
References: <1376050332-27290-1-git-send-email-bwinther@cisco.com>
In-Reply-To: <42a47889f837e362abc7a527c1029329e62034b0.1376049957.git.bwinther@cisco.com>
References: <42a47889f837e362abc7a527c1029329e62034b0.1376049957.git.bwinther@cisco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Bård Eirik Winther <bwinther@cisco.com>
---
 utils/qv4l2/qv4l2.cpp | 18 +++++++++++++++++-
 1 file changed, 17 insertions(+), 1 deletion(-)

diff --git a/utils/qv4l2/qv4l2.cpp b/utils/qv4l2/qv4l2.cpp
index a0f21cd..056e15d 100644
--- a/utils/qv4l2/qv4l2.cpp
+++ b/utils/qv4l2/qv4l2.cpp
@@ -1110,8 +1110,24 @@ void ApplicationWindow::saveRaw(bool checked)
 
 void ApplicationWindow::about()
 {
+#ifdef HAVE_ALSA
+	bool alsa = true;
+#else
+	bool alsa = false;
+#endif
+#ifdef HAVE_QTGL
+	bool gl = true;
+#else
+	bool gl = false;
+#endif
+
 	QMessageBox::about(this, "V4L2 Test Bench",
-			"This program allows easy experimenting with video4linux devices.");
+			   QString("This program allows easy experimenting with video4linux devices.\n"
+				   "v. %1\n\nALSA support : %2\nOpenGL support : %3")
+			   .arg(V4L_UTILS_VERSION)
+			   .arg(alsa ? "Present" : "Not Available")
+			   .arg(gl ? "Present" : "Not Available")
+			   );
 }
 
 void ApplicationWindow::error(const QString &error)
-- 
1.8.4.rc1

