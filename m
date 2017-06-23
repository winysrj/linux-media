Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.4.pengutronix.de ([92.198.50.35]:56111 "EHLO
        metis.ext.4.pengutronix.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754059AbdFWJzr (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 23 Jun 2017 05:55:47 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: kernel@pengutronix.de, Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH] [media] coda: add h264 and mpeg4 profile and level controls
Date: Fri, 23 Jun 2017 11:55:29 +0200
Message-Id: <20170623095529.6135-1-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

CODA7541 supports H.264 BP level 3/3.1 and MPEG-4 SP level 5/6.
CODA960 supports H.264 BP level 4.0 and MPEG-4 SP level 5/6.

Implement the necessary profile and level controls to let userspace know
this.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/media/platform/coda/coda-common.c | 47 +++++++++++++++++++++++++++++++
 1 file changed, 47 insertions(+)

diff --git a/drivers/media/platform/coda/coda-common.c b/drivers/media/platform/coda/coda-common.c
index 829c7895a98a2..d119b47773282 100644
--- a/drivers/media/platform/coda/coda-common.c
+++ b/drivers/media/platform/coda/coda-common.c
@@ -1683,12 +1683,23 @@ static int coda_s_ctrl(struct v4l2_ctrl *ctrl)
 		ctx->params.h264_deblk_enabled = (ctrl->val ==
 				V4L2_MPEG_VIDEO_H264_LOOP_FILTER_MODE_ENABLED);
 		break;
+	case V4L2_CID_MPEG_VIDEO_H264_PROFILE:
+		/* TODO: switch between baseline and constrained baseline */
+		ctx->params.h264_profile_idc = 66;
+		break;
+	case V4L2_CID_MPEG_VIDEO_H264_LEVEL:
+		/* nothing to do, this is set by the encoder */
+		break;
 	case V4L2_CID_MPEG_VIDEO_MPEG4_I_FRAME_QP:
 		ctx->params.mpeg4_intra_qp = ctrl->val;
 		break;
 	case V4L2_CID_MPEG_VIDEO_MPEG4_P_FRAME_QP:
 		ctx->params.mpeg4_inter_qp = ctrl->val;
 		break;
+	case V4L2_CID_MPEG_VIDEO_MPEG4_PROFILE:
+	case V4L2_CID_MPEG_VIDEO_MPEG4_LEVEL:
+		/* nothing to do, these are fixed */
+		break;
 	case V4L2_CID_MPEG_VIDEO_MULTI_SLICE_MODE:
 		ctx->params.slice_mode = ctrl->val;
 		break;
@@ -1756,11 +1767,47 @@ static void coda_encode_ctrls(struct coda_ctx *ctx)
 		V4L2_CID_MPEG_VIDEO_H264_LOOP_FILTER_MODE,
 		V4L2_MPEG_VIDEO_H264_LOOP_FILTER_MODE_DISABLED, 0x0,
 		V4L2_MPEG_VIDEO_H264_LOOP_FILTER_MODE_ENABLED);
+	v4l2_ctrl_new_std_menu(&ctx->ctrls, &coda_ctrl_ops,
+		V4L2_CID_MPEG_VIDEO_H264_PROFILE,
+		V4L2_MPEG_VIDEO_H264_PROFILE_BASELINE, 0x0,
+		V4L2_MPEG_VIDEO_H264_PROFILE_BASELINE);
+	if (ctx->dev->devtype->product == CODA_7541) {
+		v4l2_ctrl_new_std_menu(&ctx->ctrls, &coda_ctrl_ops,
+			V4L2_CID_MPEG_VIDEO_H264_LEVEL,
+			V4L2_MPEG_VIDEO_H264_LEVEL_3_1,
+			~((1 << V4L2_MPEG_VIDEO_H264_LEVEL_2_0) |
+			  (1 << V4L2_MPEG_VIDEO_H264_LEVEL_3_0) |
+			  (1 << V4L2_MPEG_VIDEO_H264_LEVEL_3_1)),
+			V4L2_MPEG_VIDEO_H264_LEVEL_3_1);
+	}
+	if (ctx->dev->devtype->product == CODA_960) {
+		v4l2_ctrl_new_std_menu(&ctx->ctrls, &coda_ctrl_ops,
+			V4L2_CID_MPEG_VIDEO_H264_LEVEL,
+			V4L2_MPEG_VIDEO_H264_LEVEL_4_0,
+			~((1 << V4L2_MPEG_VIDEO_H264_LEVEL_2_0) |
+			  (1 << V4L2_MPEG_VIDEO_H264_LEVEL_3_0) |
+			  (1 << V4L2_MPEG_VIDEO_H264_LEVEL_3_1) |
+			  (1 << V4L2_MPEG_VIDEO_H264_LEVEL_3_2) |
+			  (1 << V4L2_MPEG_VIDEO_H264_LEVEL_4_0)),
+			V4L2_MPEG_VIDEO_H264_LEVEL_4_0);
+	}
 	v4l2_ctrl_new_std(&ctx->ctrls, &coda_ctrl_ops,
 		V4L2_CID_MPEG_VIDEO_MPEG4_I_FRAME_QP, 1, 31, 1, 2);
 	v4l2_ctrl_new_std(&ctx->ctrls, &coda_ctrl_ops,
 		V4L2_CID_MPEG_VIDEO_MPEG4_P_FRAME_QP, 1, 31, 1, 2);
 	v4l2_ctrl_new_std_menu(&ctx->ctrls, &coda_ctrl_ops,
+		V4L2_CID_MPEG_VIDEO_MPEG4_PROFILE,
+		V4L2_MPEG_VIDEO_MPEG4_PROFILE_SIMPLE, 0x0,
+		V4L2_MPEG_VIDEO_MPEG4_PROFILE_SIMPLE);
+	if (ctx->dev->devtype->product == CODA_7541 ||
+	    ctx->dev->devtype->product == CODA_960) {
+		v4l2_ctrl_new_std_menu(&ctx->ctrls, &coda_ctrl_ops,
+			V4L2_CID_MPEG_VIDEO_MPEG4_LEVEL,
+			V4L2_MPEG_VIDEO_MPEG4_LEVEL_5,
+			~(1 << V4L2_MPEG_VIDEO_MPEG4_LEVEL_5),
+			V4L2_MPEG_VIDEO_MPEG4_LEVEL_5);
+	}
+	v4l2_ctrl_new_std_menu(&ctx->ctrls, &coda_ctrl_ops,
 		V4L2_CID_MPEG_VIDEO_MULTI_SLICE_MODE,
 		V4L2_MPEG_VIDEO_MULTI_SICE_MODE_MAX_BYTES, 0x0,
 		V4L2_MPEG_VIDEO_MULTI_SLICE_MODE_SINGLE);
-- 
2.11.0
