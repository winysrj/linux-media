Return-path: <linux-media-owner@vger.kernel.org>
Received: from arroyo.ext.ti.com ([192.94.94.40]:50737 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753004AbZDFMkx (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 6 Apr 2009 08:40:53 -0400
From: Hardik Shah <hardik.shah@ti.com>
To: linux-media@vger.kernel.org
Cc: linux-omap@vger.kernel.org, Hardik Shah <hardik.shah@ti.com>,
	Brijesh Jadav <brijesh.j@ti.com>,
	Vaibhav Hiremath <hvaibhav@ti.com>
Subject: [PATCH 2/3] New V4L2 CIDs for OMAP class of Devices.
Date: Mon,  6 Apr 2009 18:10:44 +0530
Message-Id: <1239021644-16337-1-git-send-email-hardik.shah@ti.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Added V4L2_CID_BG_COLOR for background color setting.
Added V4L2_CID_ROTATION for rotation setting.
Above two ioclts are indepth discussed. Posting
again with the driver usage.

V4L2 supports chroma keying added new flags for the
source chroma keying which is exactly opposite of the
chorma keying supported by V4L2.

In current implementation framebuffer pixels with
the chromakey color are replaced by video pixels.

While for the source chroma keying video pixels with
the chromakey color are replaced by the framebuffer
pixels.

Both are exactly opposite and so are mutually exclusive

Community Comments fixed in this post
1. Replaced V4L2_CID_ROTATION by V4L2_CID_ROTATE.
2. Initilize min and max values for V4L2_CID_BG_COLOR
control id.
3. Other minor comments fixed

Signed-off-by: Brijesh Jadav <brijesh.j@ti.com>
Signed-off-by: Hardik Shah <hardik.shah@ti.com>
Signed-off-by: Vaibhav Hiremath <hvaibhav@ti.com>
---
 linux/drivers/media/video/v4l2-common.c |    9 +++++++++
 linux/include/linux/videodev2.h         |    6 +++++-
 2 files changed, 14 insertions(+), 1 deletions(-)

diff --git a/linux/drivers/media/video/v4l2-common.c b/linux/drivers/media/video/v4l2-common.c
index d75d89c..e44b432 100644
--- a/linux/drivers/media/video/v4l2-common.c
+++ b/linux/drivers/media/video/v4l2-common.c
@@ -422,6 +422,8 @@ const char *v4l2_ctrl_get_name(u32 id)
 	case V4L2_CID_CHROMA_AGC:		return "Chroma AGC";
 	case V4L2_CID_COLOR_KILLER:		return "Color Killer";
 	case V4L2_CID_COLORFX:			return "Color Effects";
+	case V4L2_CID_ROTATE:	                return "Rotate";
+	case V4L2_CID_BG_COLOR:                 return "Background color";

 	/* MPEG controls */
 	case V4L2_CID_MPEG_CLASS: 		return "MPEG Encoder Controls";
@@ -547,6 +549,13 @@ int v4l2_ctrl_query_fill(struct v4l2_queryctrl *qctrl, s32 min, s32 max, s32 ste
 		qctrl->flags |= V4L2_CTRL_FLAG_READ_ONLY;
 		min = max = step = def = 0;
 		break;
+	case V4L2_CID_BG_COLOR:
+		 qctrl->type = V4L2_CTRL_TYPE_INTEGER;
+		 step = 1;
+		 min = 0;
+		 /* Max is calculated as RGB888 that is 2^12*/
+		 max = 0xFFFFFF;
+		 break;
 	default:
 		qctrl->type = V4L2_CTRL_TYPE_INTEGER;
 		break;
diff --git a/linux/include/linux/videodev2.h b/linux/include/linux/videodev2.h
index 82f9e72..f4cd39b 100644
--- a/linux/include/linux/videodev2.h
+++ b/linux/include/linux/videodev2.h
@@ -549,6 +549,7 @@ struct v4l2_framebuffer {
 #define V4L2_FBUF_CAP_LOCAL_ALPHA	0x0010
 #define V4L2_FBUF_CAP_GLOBAL_ALPHA	0x0020
 #define V4L2_FBUF_CAP_LOCAL_INV_ALPHA	0x0040
+#define V4L2_FBUF_CAP_SRC_CHROMAKEY	0x0080
 /*  Flags for the 'flags' field. */
 #define V4L2_FBUF_FLAG_PRIMARY		0x0001
 #define V4L2_FBUF_FLAG_OVERLAY		0x0002
@@ -556,6 +557,7 @@ struct v4l2_framebuffer {
 #define V4L2_FBUF_FLAG_LOCAL_ALPHA	0x0008
 #define V4L2_FBUF_FLAG_GLOBAL_ALPHA	0x0010
 #define V4L2_FBUF_FLAG_LOCAL_INV_ALPHA	0x0020
+#define V4L2_FBUF_FLAG_SRC_CHROMAKEY	0x0040

 struct v4l2_clip {
 	struct v4l2_rect        c;
@@ -888,6 +890,8 @@ enum v4l2_power_line_frequency {
 #define V4L2_CID_CHROMA_AGC                     (V4L2_CID_BASE+29)
 #define V4L2_CID_COLOR_KILLER                   (V4L2_CID_BASE+30)
 #define V4L2_CID_COLORFX			(V4L2_CID_BASE+31)
+#define V4L2_CID_ROTATE                     	(V4L2_CID_BASE+32)
+#define V4L2_CID_BG_COLOR                       (V4L2_CID_BASE+33)
 enum v4l2_colorfx {
 	V4L2_COLORFX_NONE	= 0,
 	V4L2_COLORFX_BW		= 1,
@@ -895,7 +899,7 @@ enum v4l2_colorfx {
 };

 /* last CID + 1 */
-#define V4L2_CID_LASTP1                         (V4L2_CID_BASE+32)
+#define V4L2_CID_LASTP1                         (V4L2_CID_BASE+34)

 /*  MPEG-class control IDs defined by V4L2 */
 #define V4L2_CID_MPEG_BASE 			(V4L2_CTRL_CLASS_MPEG | 0x900)
--
1.6.0.3

