Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr5.xs4all.nl ([194.109.24.25]:3479 "EHLO
	smtp-vbr5.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755588Ab2EKHzd (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 11 May 2012 03:55:33 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Michael Hunold <hunold@linuxtv.org>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv1 PATCH 03/16] vivi: add the alpha component control.
Date: Fri, 11 May 2012 09:54:57 +0200
Message-Id: <fc82954aaf35a4d1813bae66c83f51b029d97e75.1336722502.git.hans.verkuil@cisco.com>
In-Reply-To: <1336722910-31733-1-git-send-email-hverkuil@xs4all.nl>
References: <1336722910-31733-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <09c2b1c7ef8bbb53930311b9fdeeb89f877fdaa9.1336722502.git.hans.verkuil@cisco.com>
References: <09c2b1c7ef8bbb53930311b9fdeeb89f877fdaa9.1336722502.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Useful to set the alpha component for the pixel formats with an alpha channel.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/video/vivi.c |   29 +++++++++++++++++++++--------
 1 file changed, 21 insertions(+), 8 deletions(-)

diff --git a/drivers/media/video/vivi.c b/drivers/media/video/vivi.c
index 2a0198f..1ac34b0d 100644
--- a/drivers/media/video/vivi.c
+++ b/drivers/media/video/vivi.c
@@ -200,6 +200,7 @@ struct vivi_dev {
 		struct v4l2_ctrl	   *gain;
 	};
 	struct v4l2_ctrl	   *volume;
+	struct v4l2_ctrl	   *alpha;
 	struct v4l2_ctrl	   *button;
 	struct v4l2_ctrl	   *boolean;
 	struct v4l2_ctrl	   *int32;
@@ -237,6 +238,7 @@ struct vivi_dev {
 	u8			   bars[9][3];
 	u8			   line[MAX_WIDTH * 8];
 	unsigned int		   pixelsize;
+	u8			   alpha_component;
 };
 
 /* ------------------------------------------------------------------
@@ -359,6 +361,7 @@ static void precalculate_bars(struct vivi_dev *dev)
 static void gen_twopix(struct vivi_dev *dev, u8 *buf, int colorpos, bool odd)
 {
 	u8 r_y, g_u, b_v;
+	u8 alpha = dev->alpha_component;
 	int color;
 	u8 *p;
 
@@ -436,14 +439,14 @@ static void gen_twopix(struct vivi_dev *dev, u8 *buf, int colorpos, bool odd)
 				*p = (g_u << 5) | b_v;
 				break;
 			case 1:
-				*p = (r_y << 2) | (g_u >> 3);
+				*p = (alpha & 0x80) | (r_y << 2) | (g_u >> 3);
 				break;
 			}
 			break;
 		case V4L2_PIX_FMT_RGB555X:
 			switch (color) {
 			case 0:
-				*p = (r_y << 2) | (g_u >> 3);
+				*p = (alpha & 0x80) | (r_y << 2) | (g_u >> 3);
 				break;
 			case 1:
 				*p = (g_u << 5) | b_v;
@@ -479,7 +482,7 @@ static void gen_twopix(struct vivi_dev *dev, u8 *buf, int colorpos, bool odd)
 		case V4L2_PIX_FMT_RGB32:
 			switch (color) {
 			case 0:
-				*p = 0;
+				*p = alpha;
 				break;
 			case 1:
 				*p = r_y;
@@ -504,7 +507,7 @@ static void gen_twopix(struct vivi_dev *dev, u8 *buf, int colorpos, bool odd)
 				*p = r_y;
 				break;
 			case 3:
-				*p = 0;
+				*p = alpha;
 				break;
 			}
 			break;
@@ -595,8 +598,9 @@ static void vivi_fillbuff(struct vivi_dev *dev, struct vivi_buffer *buf)
 			dev->saturation->cur.val,
 			dev->hue->cur.val);
 	gen_text(dev, vbuf, line++ * 16, 16, str);
-	snprintf(str, sizeof(str), " autogain %d, gain %3d, volume %3d ",
-			dev->autogain->cur.val, gain, dev->volume->cur.val);
+	snprintf(str, sizeof(str), " autogain %d, gain %3d, volume %3d, alpha 0x%02x ",
+			dev->autogain->cur.val, gain, dev->volume->cur.val,
+			dev->alpha->cur.val);
 	gen_text(dev, vbuf, line++ * 16, 16, str);
 	snprintf(str, sizeof(str), " int32 %d, int64 %lld, bitmask %08x ",
 			dev->int32->cur.val,
@@ -1125,8 +1129,15 @@ static int vivi_s_ctrl(struct v4l2_ctrl *ctrl)
 {
 	struct vivi_dev *dev = container_of(ctrl->handler, struct vivi_dev, ctrl_handler);
 
-	if (ctrl == dev->button)
-		dev->button_pressed = 30;
+	switch (ctrl->id) {
+	case V4L2_CID_ALPHA_COMPONENT:
+		dev->alpha_component = ctrl->val;
+		break;
+	default:
+		if (ctrl == dev->button)
+			dev->button_pressed = 30;
+		break;
+	}
 	return 0;
 }
 
@@ -1387,6 +1398,8 @@ static int __init vivi_create_instance(int inst)
 			V4L2_CID_AUTOGAIN, 0, 1, 1, 1);
 	dev->gain = v4l2_ctrl_new_std(hdl, &vivi_ctrl_ops,
 			V4L2_CID_GAIN, 0, 255, 1, 100);
+	dev->alpha = v4l2_ctrl_new_std(hdl, &vivi_ctrl_ops,
+			V4L2_CID_ALPHA_COMPONENT, 0, 255, 1, 0);
 	dev->button = v4l2_ctrl_new_custom(hdl, &vivi_ctrl_button, NULL);
 	dev->int32 = v4l2_ctrl_new_custom(hdl, &vivi_ctrl_int32, NULL);
 	dev->int64 = v4l2_ctrl_new_custom(hdl, &vivi_ctrl_int64, NULL);
-- 
1.7.10

