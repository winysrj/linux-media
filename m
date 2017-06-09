Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:45202 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751623AbdFINYV (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 9 Jun 2017 09:24:21 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: mchehab@s-opensource.com
Subject: [PATCH v2 1/2] v4l: ctrls: Add a control for digital gain
Date: Fri,  9 Jun 2017 16:21:46 +0300
Message-Id: <1497014507-1835-2-git-send-email-sakari.ailus@linux.intel.com>
In-Reply-To: <1497014507-1835-1-git-send-email-sakari.ailus@linux.intel.com>
References: <1497014507-1835-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add V4L2_CID_DIGITAL_GAIN to control explicitly digital gain.

We already have analogue gain control which the digital gain control
complements. Typically higher quality images are obtained using analogue
gain only as the digital gain does not add information to the image
(rather it may remove it).

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 Documentation/media/uapi/v4l/extended-controls.rst | 7 +++++++
 drivers/media/v4l2-core/v4l2-ctrls.c               | 1 +
 include/uapi/linux/v4l2-controls.h                 | 2 +-
 3 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/Documentation/media/uapi/v4l/extended-controls.rst b/Documentation/media/uapi/v4l/extended-controls.rst
index 76c5b1a..9acc9cad 100644
--- a/Documentation/media/uapi/v4l/extended-controls.rst
+++ b/Documentation/media/uapi/v4l/extended-controls.rst
@@ -3021,6 +3021,13 @@ Image Process Control IDs
     The video deinterlacing mode (such as Bob, Weave, ...). The menu items are
     driver specific and are documented in :ref:`v4l-drivers`.
 
+``V4L2_CID_DIGITAL_GAIN (integer)``
+    Digital gain is the value by which all colour components
+    are multiplied by. Typically the digital gain applied is the
+    control value divided by e.g. 0x100, meaning that to get no
+    digital gain the control value needs to be 0x100. The no-gain
+    configuration is also typically the default.
+
 
 .. _dv-controls:
 
diff --git a/drivers/media/v4l2-core/v4l2-ctrls.c b/drivers/media/v4l2-core/v4l2-ctrls.c
index 5aed7bd..36eede3 100644
--- a/drivers/media/v4l2-core/v4l2-ctrls.c
+++ b/drivers/media/v4l2-core/v4l2-ctrls.c
@@ -886,6 +886,7 @@ const char *v4l2_ctrl_get_name(u32 id)
 	case V4L2_CID_PIXEL_RATE:		return "Pixel Rate";
 	case V4L2_CID_TEST_PATTERN:		return "Test Pattern";
 	case V4L2_CID_DEINTERLACING_MODE:	return "Deinterlacing Mode";
+	case V4L2_CID_DIGITAL_GAIN:		return "Digital Gain";
 
 	/* DV controls */
 	/* Keep the order of the 'case's the same as in v4l2-controls.h! */
diff --git a/include/uapi/linux/v4l2-controls.h b/include/uapi/linux/v4l2-controls.h
index 0d2e1e0..0cdb8eb 100644
--- a/include/uapi/linux/v4l2-controls.h
+++ b/include/uapi/linux/v4l2-controls.h
@@ -893,7 +893,7 @@ enum v4l2_jpeg_chroma_subsampling {
 #define V4L2_CID_PIXEL_RATE			(V4L2_CID_IMAGE_PROC_CLASS_BASE + 2)
 #define V4L2_CID_TEST_PATTERN			(V4L2_CID_IMAGE_PROC_CLASS_BASE + 3)
 #define V4L2_CID_DEINTERLACING_MODE		(V4L2_CID_IMAGE_PROC_CLASS_BASE + 4)
-
+#define V4L2_CID_DIGITAL_GAIN			(V4L2_CID_IMAGE_PROC_CLASS_BASE + 5)
 
 /*  DV-class control IDs defined by V4L2 */
 #define V4L2_CID_DV_CLASS_BASE			(V4L2_CTRL_CLASS_DV | 0x900)
-- 
2.7.4
