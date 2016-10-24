Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:52726 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S936515AbcJXJDo (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 24 Oct 2016 05:03:44 -0400
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: linux-renesas-soc@vger.kernel.org,
        Kieran Bingham <kieran@ksquared.org.uk>
Subject: [PATCH v4 1/4] v4l: ctrls: Add deinterlacing mode control
Date: Mon, 24 Oct 2016 12:03:35 +0300
Message-Id: <1477299818-31935-2-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
In-Reply-To: <1477299818-31935-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
References: <1477299818-31935-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The menu control selects the operation mode of a video deinterlacer. The
menu entries are driver specific.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Reviewed-by: Kieran Bingham <kieran@bingham.xyz>
Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
---
Changes since v3:

- Link the deinterlacing mode control to driver-specific documentation
---
 Documentation/media/uapi/v4l/extended-controls.rst | 4 ++++
 Documentation/media/v4l-drivers/index.rst          | 2 ++
 drivers/media/v4l2-core/v4l2-ctrls.c               | 2 ++
 include/uapi/linux/v4l2-controls.h                 | 1 +
 4 files changed, 9 insertions(+)

diff --git a/Documentation/media/uapi/v4l/extended-controls.rst b/Documentation/media/uapi/v4l/extended-controls.rst
index 7725c33d8b69..40071ea5d90e 100644
--- a/Documentation/media/uapi/v4l/extended-controls.rst
+++ b/Documentation/media/uapi/v4l/extended-controls.rst
@@ -3017,6 +3017,10 @@ Image Process Control IDs
     test pattern images. These hardware specific test patterns can be
     used to test if a device is working properly.
 
+``V4L2_CID_DEINTERLACING_MODE (menu)``
+    The video deinterlacing mode (such as Bob, Weave, ...). The menu items are
+    driver specific and are documented in :ref:`v4l-drivers`.
+
 
 .. _dv-controls:
 
diff --git a/Documentation/media/v4l-drivers/index.rst b/Documentation/media/v4l-drivers/index.rst
index aac566f88833..acde3ed7860f 100644
--- a/Documentation/media/v4l-drivers/index.rst
+++ b/Documentation/media/v4l-drivers/index.rst
@@ -2,6 +2,8 @@
 
 .. include:: <isonum.txt>
 
+.. _v4l-drivers:
+
 ################################################
 Video4Linux (V4L)  driver-specific documentation
 ################################################
diff --git a/drivers/media/v4l2-core/v4l2-ctrls.c b/drivers/media/v4l2-core/v4l2-ctrls.c
index adc2147fcff7..47001e25fd9e 100644
--- a/drivers/media/v4l2-core/v4l2-ctrls.c
+++ b/drivers/media/v4l2-core/v4l2-ctrls.c
@@ -885,6 +885,7 @@ const char *v4l2_ctrl_get_name(u32 id)
 	case V4L2_CID_LINK_FREQ:		return "Link Frequency";
 	case V4L2_CID_PIXEL_RATE:		return "Pixel Rate";
 	case V4L2_CID_TEST_PATTERN:		return "Test Pattern";
+	case V4L2_CID_DEINTERLACING_MODE:	return "Deinterlacing Mode";
 
 	/* DV controls */
 	/* Keep the order of the 'case's the same as in v4l2-controls.h! */
@@ -1058,6 +1059,7 @@ void v4l2_ctrl_fill(u32 id, const char **name, enum v4l2_ctrl_type *type,
 	case V4L2_CID_DV_RX_RGB_RANGE:
 	case V4L2_CID_DV_RX_IT_CONTENT_TYPE:
 	case V4L2_CID_TEST_PATTERN:
+	case V4L2_CID_DEINTERLACING_MODE:
 	case V4L2_CID_TUNE_DEEMPHASIS:
 	case V4L2_CID_MPEG_VIDEO_VPX_GOLDEN_FRAME_SEL:
 	case V4L2_CID_DETECT_MD_MODE:
diff --git a/include/uapi/linux/v4l2-controls.h b/include/uapi/linux/v4l2-controls.h
index b6a357a5f053..0d2e1e01fbd5 100644
--- a/include/uapi/linux/v4l2-controls.h
+++ b/include/uapi/linux/v4l2-controls.h
@@ -892,6 +892,7 @@ enum v4l2_jpeg_chroma_subsampling {
 #define V4L2_CID_LINK_FREQ			(V4L2_CID_IMAGE_PROC_CLASS_BASE + 1)
 #define V4L2_CID_PIXEL_RATE			(V4L2_CID_IMAGE_PROC_CLASS_BASE + 2)
 #define V4L2_CID_TEST_PATTERN			(V4L2_CID_IMAGE_PROC_CLASS_BASE + 3)
+#define V4L2_CID_DEINTERLACING_MODE		(V4L2_CID_IMAGE_PROC_CLASS_BASE + 4)
 
 
 /*  DV-class control IDs defined by V4L2 */
-- 
Regards,

Laurent Pinchart

