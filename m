Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:51519 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752942AbaGKJg7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 11 Jul 2014 05:36:59 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Kamil Debski <k.debski@samsung.com>,
	Fabio Estevam <fabio.estevam@freescale.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	kernel@pengutronix.de, Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH v3 17/32] [media] coda: add cyclic intra refresh control
Date: Fri, 11 Jul 2014 11:36:28 +0200
Message-Id: <1405071403-1859-18-git-send-email-p.zabel@pengutronix.de>
In-Reply-To: <1405071403-1859-1-git-send-email-p.zabel@pengutronix.de>
References: <1405071403-1859-1-git-send-email-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Allow userspace to enable cyclic intra refresh by setting the number of
intra macroblocks per frame to a non-zero value.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/media/platform/coda.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/media/platform/coda.c b/drivers/media/platform/coda.c
index 839aa36..2e94d95 100644
--- a/drivers/media/platform/coda.c
+++ b/drivers/media/platform/coda.c
@@ -167,6 +167,7 @@ struct coda_params {
 	u8			mpeg4_intra_qp;
 	u8			mpeg4_inter_qp;
 	u8			gop_size;
+	int			intra_refresh;
 	int			codec_mode;
 	int			codec_mode_aux;
 	enum v4l2_mpeg_video_multi_slice_mode slice_mode;
@@ -2381,7 +2382,8 @@ static int coda_start_encoding(struct coda_ctx *ctx)
 	coda_write(dev, value, CODA_CMD_ENC_SEQ_RC_PARA);
 
 	coda_write(dev, 0, CODA_CMD_ENC_SEQ_RC_BUF_SIZE);
-	coda_write(dev, 0, CODA_CMD_ENC_SEQ_INTRA_REFRESH);
+	coda_write(dev, ctx->params.intra_refresh,
+		   CODA_CMD_ENC_SEQ_INTRA_REFRESH);
 
 	coda_write(dev, bitstream_buf, CODA_CMD_ENC_SEQ_BB_START);
 	coda_write(dev, bitstream_size / 1024, CODA_CMD_ENC_SEQ_BB_SIZE);
@@ -2680,6 +2682,9 @@ static int coda_s_ctrl(struct v4l2_ctrl *ctrl)
 		break;
 	case V4L2_CID_MPEG_VIDEO_HEADER_MODE:
 		break;
+	case V4L2_CID_MPEG_VIDEO_CYCLIC_INTRA_REFRESH_MB:
+		ctx->params.intra_refresh = ctrl->val;
+		break;
 	default:
 		v4l2_dbg(1, coda_debug, &ctx->dev->v4l2_dev,
 			"Invalid control, id=%d, val=%d\n",
@@ -2741,6 +2746,8 @@ static int coda_ctrls_setup(struct coda_ctx *ctx)
 		V4L2_MPEG_VIDEO_HEADER_MODE_JOINED_WITH_1ST_FRAME,
 		(1 << V4L2_MPEG_VIDEO_HEADER_MODE_SEPARATE),
 		V4L2_MPEG_VIDEO_HEADER_MODE_JOINED_WITH_1ST_FRAME);
+	v4l2_ctrl_new_std(&ctx->ctrls, &coda_ctrl_ops,
+		V4L2_CID_MPEG_VIDEO_CYCLIC_INTRA_REFRESH_MB, 0, 1920 * 1088 / 256, 1, 0);
 
 	if (ctx->ctrls.error) {
 		v4l2_err(&ctx->dev->v4l2_dev, "control initialization error (%d)",
-- 
2.0.0

