Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:56038 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932251AbbGJNhy (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 10 Jul 2015 09:37:54 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Kamil Debski <kamil@wypas.org>
Cc: linux-media@vger.kernel.org, kernel@pengutronix.de,
	Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH] [media] coda: implement VBV delay and buffer size controls
Date: Fri, 10 Jul 2015 15:37:52 +0200
Message-Id: <1436535472-6687-1-git-send-email-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The encoder allows to specify the VBV model reference decoder's initial
delay and buffer size. Export the corresponding V4L2 controls.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/media/platform/coda/coda-bit.c    |  5 ++++-
 drivers/media/platform/coda/coda-common.c | 14 ++++++++++++++
 drivers/media/platform/coda/coda.h        |  2 ++
 3 files changed, 20 insertions(+), 1 deletion(-)

diff --git a/drivers/media/platform/coda/coda-bit.c b/drivers/media/platform/coda/coda-bit.c
index bcb9911..b14affc 100644
--- a/drivers/media/platform/coda/coda-bit.c
+++ b/drivers/media/platform/coda/coda-bit.c
@@ -922,6 +922,9 @@ static int coda_start_encoding(struct coda_ctx *ctx)
 		value = (ctx->params.bitrate & CODA_RATECONTROL_BITRATE_MASK)
 			<< CODA_RATECONTROL_BITRATE_OFFSET;
 		value |=  1 & CODA_RATECONTROL_ENABLE_MASK;
+		value |= (ctx->params.vbv_delay &
+			  CODA_RATECONTROL_INITIALDELAY_MASK)
+			 << CODA_RATECONTROL_INITIALDELAY_OFFSET;
 		if (dev->devtype->product == CODA_960)
 			value |= BIT(31); /* disable autoskip */
 	} else {
@@ -929,7 +932,7 @@ static int coda_start_encoding(struct coda_ctx *ctx)
 	}
 	coda_write(dev, value, CODA_CMD_ENC_SEQ_RC_PARA);
 
-	coda_write(dev, 0, CODA_CMD_ENC_SEQ_RC_BUF_SIZE);
+	coda_write(dev, ctx->params.vbv_size, CODA_CMD_ENC_SEQ_RC_BUF_SIZE);
 	coda_write(dev, ctx->params.intra_refresh,
 		   CODA_CMD_ENC_SEQ_INTRA_REFRESH);
 
diff --git a/drivers/media/platform/coda/coda-common.c b/drivers/media/platform/coda/coda-common.c
index 351b4124..913dba9 100644
--- a/drivers/media/platform/coda/coda-common.c
+++ b/drivers/media/platform/coda/coda-common.c
@@ -1502,6 +1502,12 @@ static int coda_s_ctrl(struct v4l2_ctrl *ctrl)
 	case V4L2_CID_JPEG_RESTART_INTERVAL:
 		ctx->params.jpeg_restart_interval = ctrl->val;
 		break;
+	case V4L2_CID_MPEG_VIDEO_VBV_DELAY:
+		ctx->params.vbv_delay = ctrl->val;
+		break;
+	case V4L2_CID_MPEG_VIDEO_VBV_SIZE:
+		ctx->params.vbv_size = min(ctrl->val * 8192, 0x7fffffff);
+		break;
 	default:
 		v4l2_dbg(1, coda_debug, &ctx->dev->v4l2_dev,
 			"Invalid control, id=%d, val=%d\n",
@@ -1561,6 +1567,14 @@ static void coda_encode_ctrls(struct coda_ctx *ctx)
 	v4l2_ctrl_new_std(&ctx->ctrls, &coda_ctrl_ops,
 		V4L2_CID_MPEG_VIDEO_CYCLIC_INTRA_REFRESH_MB, 0,
 		1920 * 1088 / 256, 1, 0);
+	v4l2_ctrl_new_std(&ctx->ctrls, &coda_ctrl_ops,
+		V4L2_CID_MPEG_VIDEO_VBV_DELAY, 0, 0x7fff, 1, 0);
+	/*
+	 * The maximum VBV size value is 0x7fffffff bits,
+	 * one bit less than 262144 KiB
+	 */
+	v4l2_ctrl_new_std(&ctx->ctrls, &coda_ctrl_ops,
+		V4L2_CID_MPEG_VIDEO_VBV_SIZE, 0, 262144, 1, 0);
 }
 
 static void coda_jpeg_encode_ctrls(struct coda_ctx *ctx)
diff --git a/drivers/media/platform/coda/coda.h b/drivers/media/platform/coda/coda.h
index a3d70cc..26c9c4b 100644
--- a/drivers/media/platform/coda/coda.h
+++ b/drivers/media/platform/coda/coda.h
@@ -128,6 +128,8 @@ struct coda_params {
 	enum v4l2_mpeg_video_multi_slice_mode slice_mode;
 	u32			framerate;
 	u16			bitrate;
+	u16			vbv_delay;
+	u32			vbv_size;
 	u32			slice_max_bits;
 	u32			slice_max_mb;
 };
-- 
2.1.4

