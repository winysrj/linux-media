Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud3.xs4all.net ([194.109.24.22]:40401 "EHLO
	lb1-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750916AbbCTRFy (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 20 Mar 2015 13:05:54 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 5/5] vivid: use V4L2_DV_FL_IS_CE_VIDEO instead of V4L2_DV_BT_STD_CEA861.
Date: Fri, 20 Mar 2015 18:05:06 +0100
Message-Id: <1426871106-31914-6-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1426871106-31914-1-git-send-email-hverkuil@xs4all.nl>
References: <1426871106-31914-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Don't rely on V4L2_DV_BT_STD_CEA861 since that include the
640x480p format, which is an IT format, not CE.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/platform/vivid/vivid-ctrls.c   | 2 +-
 drivers/media/platform/vivid/vivid-vid-cap.c | 4 ++--
 drivers/media/platform/vivid/vivid-vid-out.c | 4 ++--
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/media/platform/vivid/vivid-ctrls.c b/drivers/media/platform/vivid/vivid-ctrls.c
index 32a798f..2b90700 100644
--- a/drivers/media/platform/vivid/vivid-ctrls.c
+++ b/drivers/media/platform/vivid/vivid-ctrls.c
@@ -818,7 +818,7 @@ static int vivid_vid_out_s_ctrl(struct v4l2_ctrl *ctrl)
 		dev->dvi_d_out = ctrl->val == V4L2_DV_TX_MODE_DVI_D;
 		if (!vivid_is_hdmi_out(dev))
 			break;
-		if (!dev->dvi_d_out && (bt->standards & V4L2_DV_BT_STD_CEA861)) {
+		if (!dev->dvi_d_out && (bt->flags & V4L2_DV_FL_IS_CE_VIDEO)) {
 			if (bt->width == 720 && bt->height <= 576)
 				dev->colorspace_out = V4L2_COLORSPACE_SMPTE170M;
 			else
diff --git a/drivers/media/platform/vivid/vivid-vid-cap.c b/drivers/media/platform/vivid/vivid-vid-cap.c
index 867a29a..0a91fd5 100644
--- a/drivers/media/platform/vivid/vivid-vid-cap.c
+++ b/drivers/media/platform/vivid/vivid-vid-cap.c
@@ -441,7 +441,7 @@ void vivid_update_format_cap(struct vivid_dev *dev, bool keep_controls)
 		 */
 		if (keep_controls || !dev->colorspace)
 			break;
-		if (bt->standards & V4L2_DV_BT_STD_CEA861) {
+		if (bt->flags & V4L2_DV_FL_IS_CE_VIDEO) {
 			if (bt->width == 720 && bt->height <= 576)
 				v4l2_ctrl_s_ctrl(dev->colorspace, VIVID_CS_170M);
 			else
@@ -1332,7 +1332,7 @@ int vidioc_s_input(struct file *file, void *priv, unsigned i)
 			v4l2_ctrl_s_ctrl(dev->colorspace, VIVID_CS_170M);
 			break;
 		case HDMI:
-			if (bt->standards & V4L2_DV_BT_STD_CEA861) {
+			if (bt->flags & V4L2_DV_FL_IS_CE_VIDEO) {
 				if (dev->src_rect.width == 720 && dev->src_rect.height <= 576)
 					v4l2_ctrl_s_ctrl(dev->colorspace, VIVID_CS_170M);
 				else
diff --git a/drivers/media/platform/vivid/vivid-vid-out.c b/drivers/media/platform/vivid/vivid-vid-out.c
index 39ff79f..2833741 100644
--- a/drivers/media/platform/vivid/vivid-vid-out.c
+++ b/drivers/media/platform/vivid/vivid-vid-out.c
@@ -249,7 +249,7 @@ void vivid_update_format_out(struct vivid_dev *dev)
 			dev->field_out = V4L2_FIELD_ALTERNATE;
 		else
 			dev->field_out = V4L2_FIELD_NONE;
-		if (!dev->dvi_d_out && (bt->standards & V4L2_DV_BT_STD_CEA861)) {
+		if (!dev->dvi_d_out && (bt->flags & V4L2_DV_FL_IS_CE_VIDEO)) {
 			if (bt->width == 720 && bt->height <= 576)
 				dev->colorspace_out = V4L2_COLORSPACE_SMPTE170M;
 			else
@@ -402,7 +402,7 @@ int vivid_try_fmt_vid_out(struct file *file, void *priv,
 	mp->quantization = V4L2_QUANTIZATION_DEFAULT;
 	if (vivid_is_svid_out(dev)) {
 		mp->colorspace = V4L2_COLORSPACE_SMPTE170M;
-	} else if (dev->dvi_d_out || !(bt->standards & V4L2_DV_BT_STD_CEA861)) {
+	} else if (dev->dvi_d_out || !(bt->flags & V4L2_DV_FL_IS_CE_VIDEO)) {
 		mp->colorspace = V4L2_COLORSPACE_SRGB;
 		if (dev->dvi_d_out)
 			mp->quantization = V4L2_QUANTIZATION_LIM_RANGE;
-- 
2.1.4

