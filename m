Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:54026 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751971AbcIGWYo (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 7 Sep 2016 18:24:44 -0400
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: linux-renesas-soc@vger.kernel.org,
        Kieran Bingham <kieran@ksquared.org.uk>
Subject: [PATCH v3 02/10] v4l: ctrls: Add deinterlacing mode control
Date: Thu,  8 Sep 2016 01:25:02 +0300
Message-Id: <1473287110-780-3-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
In-Reply-To: <1473287110-780-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
References: <1473287110-780-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The menu control selects the operation mode of a video deinterlacer. The
menu entries are driver specific.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---
 Documentation/media/uapi/v4l/extended-controls.rst | 4 ++++
 drivers/media/v4l2-core/v4l2-ctrls.c               | 2 ++
 include/uapi/linux/v4l2-controls.h                 | 1 +
 3 files changed, 7 insertions(+)

diff --git a/Documentation/media/uapi/v4l/extended-controls.rst b/Documentation/media/uapi/v4l/extended-controls.rst
index 1f1518e4859d..8e6314e23cd3 100644
--- a/Documentation/media/uapi/v4l/extended-controls.rst
+++ b/Documentation/media/uapi/v4l/extended-controls.rst
@@ -4250,6 +4250,10 @@ Image Process Control IDs
     test pattern images. These hardware specific test patterns can be
     used to test if a device is working properly.
 
+``V4L2_CID_DEINTERLACING_MODE (menu)``
+    The video deinterlacing mode (such as Bob, Weave, ...). The menu items are
+    driver specific.
+
 
 .. _dv-controls:
 
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

