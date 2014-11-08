Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:52940 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753463AbaKHXFR (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 8 Nov 2014 18:05:17 -0500
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Cc: hverkuil@xs4all.nl, Sakari Ailus <sakari.ailus@iki.fi>
Subject: [PATCH 2/3] v4l: Add V4L2_SEL_TGT_NATIVE_SIZE selection target
Date: Sun,  9 Nov 2014 01:04:31 +0200
Message-Id: <1415487872-27500-3-git-send-email-sakari.ailus@iki.fi>
In-Reply-To: <1415487872-27500-1-git-send-email-sakari.ailus@iki.fi>
References: <1415487872-27500-1-git-send-email-sakari.ailus@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The V4L2_SEL_TGT_NATIVE_SIZE target is used to denote e.g. the size of a
sensor's pixel array.

Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
---
 Documentation/DocBook/media/v4l/selections-common.xml |    8 ++++++++
 include/uapi/linux/v4l2-common.h                      |    2 ++
 2 files changed, 10 insertions(+)

diff --git a/Documentation/DocBook/media/v4l/selections-common.xml b/Documentation/DocBook/media/v4l/selections-common.xml
index 7502f78..5fc833a 100644
--- a/Documentation/DocBook/media/v4l/selections-common.xml
+++ b/Documentation/DocBook/media/v4l/selections-common.xml
@@ -63,6 +63,14 @@
 	    <entry>Yes</entry>
 	  </row>
 	  <row>
+	    <entry><constant>V4L2_SEL_TGT_NATIVE_SIZE</constant></entry>
+	    <entry>0x0003</entry>
+	    <entry>The native size of the device, e.g. a sensor's
+	    pixel array.</entry>
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

