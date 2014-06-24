Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:57642 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753803AbaFXO42 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 24 Jun 2014 10:56:28 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Kamil Debski <k.debski@samsung.com>,
	Fabio Estevam <fabio.estevam@freescale.com>,
	kernel@pengutronix.de, Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH v2 16/29] [media] coda: add h.264 deblocking filter controls
Date: Tue, 24 Jun 2014 16:55:58 +0200
Message-Id: <1403621771-11636-17-git-send-email-p.zabel@pengutronix.de>
In-Reply-To: <1403621771-11636-1-git-send-email-p.zabel@pengutronix.de>
References: <1403621771-11636-1-git-send-email-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This adds controls for the h.264 deblocking loop filter.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/media/platform/coda.c | 33 ++++++++++++++++++++++++++++++++-
 1 file changed, 32 insertions(+), 1 deletion(-)

diff --git a/drivers/media/platform/coda.c b/drivers/media/platform/coda.c
index 3697a17..9ac8c9a 100644
--- a/drivers/media/platform/coda.c
+++ b/drivers/media/platform/coda.c
@@ -161,6 +161,9 @@ struct coda_params {
 	u8			h264_inter_qp;
 	u8			h264_min_qp;
 	u8			h264_max_qp;
+	u8			h264_deblk_enabled;
+	u8			h264_deblk_alpha;
+	u8			h264_deblk_beta;
 	u8			mpeg4_intra_qp;
 	u8			mpeg4_inter_qp;
 	u8			gop_size;
@@ -2326,7 +2329,17 @@ static int coda_start_encoding(struct coda_ctx *ctx)
 			coda_write(dev, CODA9_STD_H264, CODA_CMD_ENC_SEQ_COD_STD);
 		else
 			coda_write(dev, CODA_STD_H264, CODA_CMD_ENC_SEQ_COD_STD);
-		coda_write(dev, 0, CODA_CMD_ENC_SEQ_264_PARA);
+		if (ctx->params.h264_deblk_enabled) {
+			value = ((ctx->params.h264_deblk_alpha &
+				  CODA_264PARAM_DEBLKFILTEROFFSETALPHA_MASK) <<
+				 CODA_264PARAM_DEBLKFILTEROFFSETALPHA_OFFSET) |
+				((ctx->params.h264_deblk_beta &
+				  CODA_264PARAM_DEBLKFILTEROFFSETBETA_MASK) <<
+				 CODA_264PARAM_DEBLKFILTEROFFSETBETA_OFFSET);
+		} else {
+			value = 1 << CODA_264PARAM_DISABLEDEBLK_OFFSET;
+		}
+		coda_write(dev, value, CODA_CMD_ENC_SEQ_264_PARA);
 		break;
 	default:
 		v4l2_err(v4l2_dev,
@@ -2637,6 +2650,16 @@ static int coda_s_ctrl(struct v4l2_ctrl *ctrl)
 	case V4L2_CID_MPEG_VIDEO_H264_MAX_QP:
 		ctx->params.h264_max_qp = ctrl->val;
 		break;
+	case V4L2_CID_MPEG_VIDEO_H264_LOOP_FILTER_ALPHA:
+		ctx->params.h264_deblk_alpha = ctrl->val;
+		break;
+	case V4L2_CID_MPEG_VIDEO_H264_LOOP_FILTER_BETA:
+		ctx->params.h264_deblk_beta = ctrl->val;
+		break;
+	case V4L2_CID_MPEG_VIDEO_H264_LOOP_FILTER_MODE:
+		ctx->params.h264_deblk_enabled = (ctrl->val ==
+				V4L2_MPEG_VIDEO_H264_LOOP_FILTER_MODE_ENABLED);
+		break;
 	case V4L2_CID_MPEG_VIDEO_MPEG4_I_FRAME_QP:
 		ctx->params.mpeg4_intra_qp = ctrl->val;
 		break;
@@ -2691,6 +2714,14 @@ static int coda_ctrls_setup(struct coda_ctx *ctx)
 	v4l2_ctrl_new_std(&ctx->ctrls, &coda_ctrl_ops,
 		V4L2_CID_MPEG_VIDEO_H264_MAX_QP, 0, 51, 1, 51);
 	v4l2_ctrl_new_std(&ctx->ctrls, &coda_ctrl_ops,
+		V4L2_CID_MPEG_VIDEO_H264_LOOP_FILTER_ALPHA, 0, 15, 1, 0);
+	v4l2_ctrl_new_std(&ctx->ctrls, &coda_ctrl_ops,
+		V4L2_CID_MPEG_VIDEO_H264_LOOP_FILTER_BETA, 0, 15, 1, 0);
+	v4l2_ctrl_new_std_menu(&ctx->ctrls, &coda_ctrl_ops,
+		V4L2_CID_MPEG_VIDEO_H264_LOOP_FILTER_MODE,
+		V4L2_MPEG_VIDEO_H264_LOOP_FILTER_MODE_DISABLED, 0x0,
+		V4L2_MPEG_VIDEO_H264_LOOP_FILTER_MODE_ENABLED);
+	v4l2_ctrl_new_std(&ctx->ctrls, &coda_ctrl_ops,
 		V4L2_CID_MPEG_VIDEO_MPEG4_I_FRAME_QP, 1, 31, 1, 2);
 	v4l2_ctrl_new_std(&ctx->ctrls, &coda_ctrl_ops,
 		V4L2_CID_MPEG_VIDEO_MPEG4_P_FRAME_QP, 1, 31, 1, 2);
-- 
2.0.0

