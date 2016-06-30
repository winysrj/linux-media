Return-path: <linux-media-owner@vger.kernel.org>
Received: from resqmta-po-09v.sys.comcast.net ([96.114.154.168]:57501 "EHLO
	resqmta-po-09v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751487AbcF3VfG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 30 Jun 2016 17:35:06 -0400
From: Shuah Khan <shuahkh@osg.samsung.com>
To: kyungmin.park@samsung.com, k.debski@samsung.com,
	jtp.park@samsung.com, mchehab@kernel.org, hverkuil@xs4all.nl,
	javier@osg.samsung.com
Cc: Shuah Khan <shuahkh@osg.samsung.com>,
	linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [RFC PATCH] media: s5p-mfc - remove vidioc_g_crop
Date: Thu, 30 Jun 2016 15:35:02 -0600
Message-Id: <1467322502-11180-1-git-send-email-shuahkh@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Remove vidioc_g_crop() from s5p-mfc decoder. Without its s_crop counterpart
g_crop is not useful. Delete it.

Signed-off-by: Shuah Khan <shuahkh@osg.samsung.com>
---
 drivers/media/platform/s5p-mfc/s5p_mfc_dec.c | 42 ----------------------------
 1 file changed, 42 deletions(-)

diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c b/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c
index a01a373..ee7b189 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c
@@ -766,47 +766,6 @@ static const struct v4l2_ctrl_ops s5p_mfc_dec_ctrl_ops = {
 	.g_volatile_ctrl = s5p_mfc_dec_g_v_ctrl,
 };
 
-/* Get cropping information */
-static int vidioc_g_crop(struct file *file, void *priv,
-		struct v4l2_crop *cr)
-{
-	struct s5p_mfc_ctx *ctx = fh_to_ctx(priv);
-	struct s5p_mfc_dev *dev = ctx->dev;
-	u32 left, right, top, bottom;
-
-	if (ctx->state != MFCINST_HEAD_PARSED &&
-	ctx->state != MFCINST_RUNNING && ctx->state != MFCINST_FINISHING
-					&& ctx->state != MFCINST_FINISHED) {
-			mfc_err("Cannont set crop\n");
-			return -EINVAL;
-		}
-	if (ctx->src_fmt->fourcc == V4L2_PIX_FMT_H264) {
-		left = s5p_mfc_hw_call(dev->mfc_ops, get_crop_info_h, ctx);
-		right = left >> S5P_FIMV_SHARED_CROP_RIGHT_SHIFT;
-		left = left & S5P_FIMV_SHARED_CROP_LEFT_MASK;
-		top = s5p_mfc_hw_call(dev->mfc_ops, get_crop_info_v, ctx);
-		bottom = top >> S5P_FIMV_SHARED_CROP_BOTTOM_SHIFT;
-		top = top & S5P_FIMV_SHARED_CROP_TOP_MASK;
-		cr->c.left = left;
-		cr->c.top = top;
-		cr->c.width = ctx->img_width - left - right;
-		cr->c.height = ctx->img_height - top - bottom;
-		mfc_debug(2, "Cropping info [h264]: l=%d t=%d "
-			"w=%d h=%d (r=%d b=%d fw=%d fh=%d\n", left, top,
-			cr->c.width, cr->c.height, right, bottom,
-			ctx->buf_width, ctx->buf_height);
-	} else {
-		cr->c.left = 0;
-		cr->c.top = 0;
-		cr->c.width = ctx->img_width;
-		cr->c.height = ctx->img_height;
-		mfc_debug(2, "Cropping info: w=%d h=%d fw=%d "
-			"fh=%d\n", cr->c.width,	cr->c.height, ctx->buf_width,
-							ctx->buf_height);
-	}
-	return 0;
-}
-
 static int vidioc_decoder_cmd(struct file *file, void *priv,
 			      struct v4l2_decoder_cmd *cmd)
 {
@@ -880,7 +839,6 @@ static const struct v4l2_ioctl_ops s5p_mfc_dec_ioctl_ops = {
 	.vidioc_expbuf = vidioc_expbuf,
 	.vidioc_streamon = vidioc_streamon,
 	.vidioc_streamoff = vidioc_streamoff,
-	.vidioc_g_crop = vidioc_g_crop,
 	.vidioc_decoder_cmd = vidioc_decoder_cmd,
 	.vidioc_subscribe_event = vidioc_subscribe_event,
 	.vidioc_unsubscribe_event = v4l2_event_unsubscribe,
-- 
2.7.4

