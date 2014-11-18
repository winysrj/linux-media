Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:46491 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750788AbaKRFkj (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 18 Nov 2014 00:40:39 -0500
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Cc: hans.verkuil@xs4all.nl
Subject: [REVIEW PATCH v2 2/5] v4l: Add V4L2_SEL_TGT_NATIVE_SIZE selection target
Date: Tue, 18 Nov 2014 07:40:17 +0200
Message-Id: <1416289220-32673-3-git-send-email-sakari.ailus@iki.fi>
In-Reply-To: <1416289220-32673-1-git-send-email-sakari.ailus@iki.fi>
References: <1416289220-32673-1-git-send-email-sakari.ailus@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The V4L2_SEL_TGT_NATIVE_SIZE target is used to denote e.g. the size of a
sensor's pixel array.

Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
---
 Documentation/DocBook/media/v4l/selections-common.xml |   10 ++++++++++
 include/uapi/linux/v4l2-common.h                      |    2 ++
 2 files changed, 12 insertions(+)

diff --git a/Documentation/DocBook/media/v4l/selections-common.xml b/Documentation/DocBook/media/v4l/selections-common.xml
index 7502f78..99c984c 100644
--- a/Documentation/DocBook/media/v4l/selections-common.xml
+++ b/Documentation/DocBook/media/v4l/selections-common.xml
@@ -63,6 +63,16 @@
 	    <entry>Yes</entry>
 	  </row>
 	  <row>
+	    <entry><constant>V4L2_SEL_TGT_NATIVE_SIZE</constant></entry>
+	    <entry>0x0003</entry>
+	    <entry>The native size of the device, e.g. a sensor's
+	    pixel array. <structfield>top</structfield> and
+	    <structfield>left</structfield> fields are zero for this target.
+	    </entry>
+	    <entry>Yes</entry>
+	    <entry>Yes</entry>
+	  </row>
+	  <row>
 	    <entry><constant>V4L2_SEL_TGT_COMPOSE</constant></entry>
 	    <entry>0x0100</entry>
 	    <entry>Compose rectangle. Used to configure scaling
diff --git a/include/uapi/linux/v4l2-common.h b/include/uapi/linux/v4l2-common.h
index 2f6f8ca..1527398 100644
--- a/include/uapi/linux/v4l2-common.h
+++ b/include/uapi/linux/v4l2-common.h
@@ -43,6 +43,8 @@
 #define V4L2_SEL_TGT_CROP_DEFAULT	0x0001
 /* Cropping bounds */
 #define V4L2_SEL_TGT_CROP_BOUNDS	0x0002
+/* Native frame size */
+#define V4L2_SEL_TGT_NATIVE_SIZE	0x0003
 /* Current composing area */
 #define V4L2_SEL_TGT_COMPOSE		0x0100
 /* Default composing area */
-- 
1.7.10.4

