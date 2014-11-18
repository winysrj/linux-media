Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:55439 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753300AbaKRVIS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 18 Nov 2014 16:08:18 -0500
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Cc: hans.verkuil@xs4all.nl
Subject: [REVIEW PATCH v2.1 2/5] v4l: Add V4L2_SEL_TGT_NATIVE_SIZE selection target
Date: Tue, 18 Nov 2014 23:08:10 +0200
Message-Id: <1416344890-28142-1-git-send-email-sakari.ailus@iki.fi>
In-Reply-To: <1416289220-32673-3-git-send-email-sakari.ailus@iki.fi>
References: <1416289220-32673-3-git-send-email-sakari.ailus@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The V4L2_SEL_TGT_NATIVE_SIZE target is used to denote e.g. the size of a
sensor's pixel array.

Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
---
since v2:
- Add a note on s_selection support for native selection target on mem2mem
  devices only.
- Reverse the order or left and top fields, i.e. make it the same as in
  struct v4l2_rect.

 Documentation/DocBook/media/v4l/selections-common.xml |   16 ++++++++++++++++
 include/uapi/linux/v4l2-common.h                      |    2 ++
 2 files changed, 18 insertions(+)

diff --git a/Documentation/DocBook/media/v4l/selections-common.xml b/Documentation/DocBook/media/v4l/selections-common.xml
index 7502f78..d6d56fb 100644
--- a/Documentation/DocBook/media/v4l/selections-common.xml
+++ b/Documentation/DocBook/media/v4l/selections-common.xml
@@ -63,6 +63,22 @@
 	    <entry>Yes</entry>
 	  </row>
 	  <row>
+	    <entry><constant>V4L2_SEL_TGT_NATIVE_SIZE</constant></entry>
+	    <entry>0x0003</entry>
+	    <entry>The native size of the device, e.g. a sensor's
+	    pixel array. <structfield>left</structfield> and
+	    <structfield>top</structfield> fields are zero for this
+	    target. Setting the native size will generally only make
+	    sense for memory to memory devices where the software can
+	    create a canvas of a given size in which for example a
+	    video frame can be composed. In that case
+	    V4L2_SEL_TGT_NATIVE_SIZE can be used to configure the size
+	    of that canvas.
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

