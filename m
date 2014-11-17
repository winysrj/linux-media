Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud2.xs4all.net ([194.109.24.21]:60534 "EHLO
	lb1-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753093AbaKQORV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 17 Nov 2014 09:17:21 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv1 PATCH 7/8] vivid: add new colorspaces
Date: Mon, 17 Nov 2014 15:16:53 +0100
Message-Id: <1416233814-40579-8-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1416233814-40579-1-git-send-email-hverkuil@xs4all.nl>
References: <1416233814-40579-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Add AdobeRGB and BT.2020 support.

The colorspace control now orders the colorspaces according to how often
they are used. So rarely used colorspaces are moved to the end. This makes
it more logical when testing colorspace support.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/platform/vivid/vivid-core.h    | 11 +++++++++++
 drivers/media/platform/vivid/vivid-ctrls.c   | 27 +++++++++++++++++----------
 drivers/media/platform/vivid/vivid-vid-cap.c | 16 ++++++++--------
 3 files changed, 36 insertions(+), 18 deletions(-)

diff --git a/drivers/media/platform/vivid/vivid-core.h b/drivers/media/platform/vivid/vivid-core.h
index 811c286..834e425 100644
--- a/drivers/media/platform/vivid/vivid-core.h
+++ b/drivers/media/platform/vivid/vivid-core.h
@@ -116,6 +116,17 @@ enum vivid_signal_mode {
 	CUSTOM_DV_TIMINGS,
 };
 
+enum vivid_colorspace {
+	VIVID_CS_170M,
+	VIVID_CS_709,
+	VIVID_CS_SRGB,
+	VIVID_CS_ADOBERGB,
+	VIVID_CS_2020,
+	VIVID_CS_240M,
+	VIVID_CS_SYS_M,
+	VIVID_CS_SYS_BG,
+};
+
 #define VIVID_INVALID_SIGNAL(mode) \
 	((mode) == NO_SIGNAL || (mode) == NO_LOCK || (mode) == OUT_OF_RANGE)
 
diff --git a/drivers/media/platform/vivid/vivid-ctrls.c b/drivers/media/platform/vivid/vivid-ctrls.c
index ad8df5c..dcb912d 100644
--- a/drivers/media/platform/vivid/vivid-ctrls.c
+++ b/drivers/media/platform/vivid/vivid-ctrls.c
@@ -333,6 +333,16 @@ static const struct v4l2_ctrl_ops vivid_user_vid_ctrl_ops = {
 
 static int vivid_vid_cap_s_ctrl(struct v4l2_ctrl *ctrl)
 {
+	static const u32 colorspaces[] = {
+		V4L2_COLORSPACE_SMPTE170M,
+		V4L2_COLORSPACE_REC709,
+		V4L2_COLORSPACE_SRGB,
+		V4L2_COLORSPACE_ADOBERGB,
+		V4L2_COLORSPACE_BT2020,
+		V4L2_COLORSPACE_SMPTE240M,
+		V4L2_COLORSPACE_470_SYSTEM_M,
+		V4L2_COLORSPACE_470_SYSTEM_BG,
+	};
 	struct vivid_dev *dev = container_of(ctrl->handler, struct vivid_dev, ctrl_hdl_vid_cap);
 	unsigned i;
 
@@ -342,7 +352,7 @@ static int vivid_vid_cap_s_ctrl(struct v4l2_ctrl *ctrl)
 		tpg_s_pattern(&dev->tpg, ctrl->val);
 		break;
 	case VIVID_CID_COLORSPACE:
-		tpg_s_colorspace(&dev->tpg, ctrl->val);
+		tpg_s_colorspace(&dev->tpg, colorspaces[ctrl->val]);
 		vivid_send_source_change(dev, TV);
 		vivid_send_source_change(dev, SVID);
 		vivid_send_source_change(dev, HDMI);
@@ -662,15 +672,14 @@ static const struct v4l2_ctrl_config vivid_ctrl_max_edid_blocks = {
 };
 
 static const char * const vivid_ctrl_colorspace_strings[] = {
-	"",
 	"SMPTE 170M",
-	"SMPTE 240M",
 	"REC 709",
-	"", /* Skip Bt878 entry */
+	"sRGB",
+	"AdobeRGB",
+	"BT.2020",
+	"SMPTE 240M",
 	"470 System M",
 	"470 System BG",
-	"", /* Skip JPEG entry */
-	"sRGB",
 	NULL,
 };
 
@@ -679,10 +688,8 @@ static const struct v4l2_ctrl_config vivid_ctrl_colorspace = {
 	.id = VIVID_CID_COLORSPACE,
 	.name = "Colorspace",
 	.type = V4L2_CTRL_TYPE_MENU,
-	.min = 1,
-	.max = 8,
-	.menu_skip_mask = (1 << 4) | (1 << 7),
-	.def = 8,
+	.max = 7,
+	.def = 2,
 	.qmenu = vivid_ctrl_colorspace_strings,
 };
 
diff --git a/drivers/media/platform/vivid/vivid-vid-cap.c b/drivers/media/platform/vivid/vivid-vid-cap.c
index 331c544..5caf912 100644
--- a/drivers/media/platform/vivid/vivid-vid-cap.c
+++ b/drivers/media/platform/vivid/vivid-vid-cap.c
@@ -443,12 +443,12 @@ void vivid_update_format_cap(struct vivid_dev *dev, bool keep_controls)
 			break;
 		if (bt->standards & V4L2_DV_BT_STD_CEA861) {
 			if (bt->width == 720 && bt->height <= 576)
-				v4l2_ctrl_s_ctrl(dev->colorspace, V4L2_COLORSPACE_SMPTE170M);
+				v4l2_ctrl_s_ctrl(dev->colorspace, VIVID_CS_170M);
 			else
-				v4l2_ctrl_s_ctrl(dev->colorspace, V4L2_COLORSPACE_REC709);
+				v4l2_ctrl_s_ctrl(dev->colorspace, VIVID_CS_709);
 			v4l2_ctrl_s_ctrl(dev->real_rgb_range_cap, 1);
 		} else {
-			v4l2_ctrl_s_ctrl(dev->colorspace, V4L2_COLORSPACE_SRGB);
+			v4l2_ctrl_s_ctrl(dev->colorspace, VIVID_CS_SRGB);
 			v4l2_ctrl_s_ctrl(dev->real_rgb_range_cap, 0);
 		}
 		tpg_s_rgb_range(&dev->tpg, v4l2_ctrl_g_ctrl(dev->rgb_range_cap));
@@ -1307,20 +1307,20 @@ int vidioc_s_input(struct file *file, void *priv, unsigned i)
 	if (dev->colorspace) {
 		switch (dev->input_type[i]) {
 		case WEBCAM:
-			v4l2_ctrl_s_ctrl(dev->colorspace, V4L2_COLORSPACE_SRGB);
+			v4l2_ctrl_s_ctrl(dev->colorspace, VIVID_CS_SRGB);
 			break;
 		case TV:
 		case SVID:
-			v4l2_ctrl_s_ctrl(dev->colorspace, V4L2_COLORSPACE_SMPTE170M);
+			v4l2_ctrl_s_ctrl(dev->colorspace, VIVID_CS_170M);
 			break;
 		case HDMI:
 			if (bt->standards & V4L2_DV_BT_STD_CEA861) {
 				if (dev->src_rect.width == 720 && dev->src_rect.height <= 576)
-					v4l2_ctrl_s_ctrl(dev->colorspace, V4L2_COLORSPACE_SMPTE170M);
+					v4l2_ctrl_s_ctrl(dev->colorspace, VIVID_CS_170M);
 				else
-					v4l2_ctrl_s_ctrl(dev->colorspace, V4L2_COLORSPACE_REC709);
+					v4l2_ctrl_s_ctrl(dev->colorspace, VIVID_CS_709);
 			} else {
-				v4l2_ctrl_s_ctrl(dev->colorspace, V4L2_COLORSPACE_SRGB);
+				v4l2_ctrl_s_ctrl(dev->colorspace, VIVID_CS_SRGB);
 			}
 			break;
 		}
-- 
2.1.1

