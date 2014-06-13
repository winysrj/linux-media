Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:44462 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753406AbaFMQJJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 13 Jun 2014 12:09:09 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Kamil Debski <k.debski@samsung.com>,
	Fabio Estevam <fabio.estevam@freescale.com>,
	kernel@pengutronix.de, Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH 15/30] [media] coda: add h.264 min/max qp controls
Date: Fri, 13 Jun 2014 18:08:41 +0200
Message-Id: <1402675736-15379-16-git-send-email-p.zabel@pengutronix.de>
In-Reply-To: <1402675736-15379-1-git-send-email-p.zabel@pengutronix.de>
References: <1402675736-15379-1-git-send-email-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

If the bitrate control is set, the encoder works in CBR mode, dynamically
changing the quantization parameters to achieve a constant bitrate.
With the min/max QP controls the quantization parameters can be limited
to a given range.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/media/platform/coda.c | 27 +++++++++++++++++++++++++++
 1 file changed, 27 insertions(+)

diff --git a/drivers/media/platform/coda.c b/drivers/media/platform/coda.c
index b2e8e0e..fa7eafb 100644
--- a/drivers/media/platform/coda.c
+++ b/drivers/media/platform/coda.c
@@ -159,6 +159,8 @@ struct coda_params {
 	u8			rot_mode;
 	u8			h264_intra_qp;
 	u8			h264_inter_qp;
+	u8			h264_min_qp;
+	u8			h264_max_qp;
 	u8			mpeg4_intra_qp;
 	u8			mpeg4_inter_qp;
 	u8			gop_size;
@@ -2433,7 +2435,16 @@ static int coda_start_encoding(struct coda_ctx *ctx)
 		coda_write(dev, (gamma & CODA_GAMMA_MASK) << CODA_GAMMA_OFFSET,
 			   CODA_CMD_ENC_SEQ_RC_GAMMA);
 	}
+
+	if (ctx->params.h264_min_qp || ctx->params.h264_max_qp) {
+		coda_write(dev,
+			   ctx->params.h264_min_qp << CODA_QPMIN_OFFSET |
+			   ctx->params.h264_max_qp << CODA_QPMAX_OFFSET,
+			   CODA_CMD_ENC_SEQ_RC_QP_MIN_MAX);
+	}
 	if (dev->devtype->product == CODA_960) {
+		if (ctx->params.h264_max_qp)
+			value |= 1 << CODA9_OPTION_RCQPMAX_OFFSET;
 		if (CODA_DEFAULT_GAMMA > 0)
 			value |= 1 << CODA9_OPTION_GAMMA_OFFSET;
 	} else {
@@ -2443,6 +2454,10 @@ static int coda_start_encoding(struct coda_ctx *ctx)
 			else
 				value |= 1 << CODA7_OPTION_GAMMA_OFFSET;
 		}
+		if (ctx->params.h264_min_qp)
+			value |= 1 << CODA7_OPTION_RCQPMIN_OFFSET;
+		if (ctx->params.h264_max_qp)
+			value |= 1 << CODA7_OPTION_RCQPMAX_OFFSET;
 	}
 	coda_write(dev, value, CODA_CMD_ENC_SEQ_OPTION);
 
@@ -2670,6 +2685,12 @@ static int coda_s_ctrl(struct v4l2_ctrl *ctrl)
 	case V4L2_CID_MPEG_VIDEO_H264_P_FRAME_QP:
 		ctx->params.h264_inter_qp = ctrl->val;
 		break;
+	case V4L2_CID_MPEG_VIDEO_H264_MIN_QP:
+		ctx->params.h264_min_qp = ctrl->val;
+		break;
+	case V4L2_CID_MPEG_VIDEO_H264_MAX_QP:
+		ctx->params.h264_max_qp = ctrl->val;
+		break;
 	case V4L2_CID_MPEG_VIDEO_MPEG4_I_FRAME_QP:
 		ctx->params.mpeg4_intra_qp = ctrl->val;
 		break;
@@ -2717,6 +2738,12 @@ static int coda_ctrls_setup(struct coda_ctx *ctx)
 		V4L2_CID_MPEG_VIDEO_H264_I_FRAME_QP, 0, 51, 1, 25);
 	v4l2_ctrl_new_std(&ctx->ctrls, &coda_ctrl_ops,
 		V4L2_CID_MPEG_VIDEO_H264_P_FRAME_QP, 0, 51, 1, 25);
+	if (ctx->dev->devtype->product != CODA_960) {
+		v4l2_ctrl_new_std(&ctx->ctrls, &coda_ctrl_ops,
+			V4L2_CID_MPEG_VIDEO_H264_MIN_QP, 0, 51, 1, 12);
+	}
+	v4l2_ctrl_new_std(&ctx->ctrls, &coda_ctrl_ops,
+		V4L2_CID_MPEG_VIDEO_H264_MAX_QP, 0, 51, 1, 51);
 	v4l2_ctrl_new_std(&ctx->ctrls, &coda_ctrl_ops,
 		V4L2_CID_MPEG_VIDEO_MPEG4_I_FRAME_QP, 1, 31, 1, 2);
 	v4l2_ctrl_new_std(&ctx->ctrls, &coda_ctrl_ops,
-- 
2.0.0.rc2

