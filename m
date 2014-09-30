Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:45500 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751068AbaI3J53 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 30 Sep 2014 05:57:29 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Kamil Debski <k.debski@samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	linux-media@vger.kernel.org, kernel@pengutronix.de,
	Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH 04/10] [media] coda: split out encoder control setup to specify controls per video device
Date: Tue, 30 Sep 2014 11:57:05 +0200
Message-Id: <1412071031-32016-5-git-send-email-p.zabel@pengutronix.de>
In-Reply-To: <1412071031-32016-1-git-send-email-p.zabel@pengutronix.de>
References: <1412071031-32016-1-git-send-email-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch splits the H.264/MPEG4 encoder specific controls out of the main
control setup function. This way each video device registers only relevant
controls.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/media/platform/coda/coda-common.c | 66 ++++++++++++++++++-------------
 1 file changed, 39 insertions(+), 27 deletions(-)

diff --git a/drivers/media/platform/coda/coda-common.c b/drivers/media/platform/coda/coda-common.c
index df950f2..4d627c6 100644
--- a/drivers/media/platform/coda/coda-common.c
+++ b/drivers/media/platform/coda/coda-common.c
@@ -1350,40 +1350,40 @@ static const struct v4l2_ctrl_ops coda_ctrl_ops = {
 	.s_ctrl = coda_s_ctrl,
 };
 
-static int coda_ctrls_setup(struct coda_ctx *ctx)
+static void coda_encode_ctrls(struct coda_ctx *ctx)
 {
-	v4l2_ctrl_handler_init(&ctx->ctrls, 9);
-
-	v4l2_ctrl_new_std(&ctx->ctrls, &coda_ctrl_ops,
-		V4L2_CID_HFLIP, 0, 1, 1, 0);
-	v4l2_ctrl_new_std(&ctx->ctrls, &coda_ctrl_ops,
-		V4L2_CID_VFLIP, 0, 1, 1, 0);
 	v4l2_ctrl_new_std(&ctx->ctrls, &coda_ctrl_ops,
 		V4L2_CID_MPEG_VIDEO_BITRATE, 0, 32767000, 1, 0);
 	v4l2_ctrl_new_std(&ctx->ctrls, &coda_ctrl_ops,
 		V4L2_CID_MPEG_VIDEO_GOP_SIZE, 1, 60, 1, 16);
-	v4l2_ctrl_new_std(&ctx->ctrls, &coda_ctrl_ops,
-		V4L2_CID_MPEG_VIDEO_H264_I_FRAME_QP, 0, 51, 1, 25);
-	v4l2_ctrl_new_std(&ctx->ctrls, &coda_ctrl_ops,
-		V4L2_CID_MPEG_VIDEO_H264_P_FRAME_QP, 0, 51, 1, 25);
-	if (ctx->dev->devtype->product != CODA_960) {
+	switch (ctx->cvd->dst_formats[0]) {
+	case V4L2_PIX_FMT_H264:
+		v4l2_ctrl_new_std(&ctx->ctrls, &coda_ctrl_ops,
+			V4L2_CID_MPEG_VIDEO_H264_I_FRAME_QP, 0, 51, 1, 25);
+		v4l2_ctrl_new_std(&ctx->ctrls, &coda_ctrl_ops,
+			V4L2_CID_MPEG_VIDEO_H264_P_FRAME_QP, 0, 51, 1, 25);
+		if (ctx->dev->devtype->product != CODA_960) {
+			v4l2_ctrl_new_std(&ctx->ctrls, &coda_ctrl_ops,
+				V4L2_CID_MPEG_VIDEO_H264_MIN_QP, 0, 51, 1, 12);
+		}
+		v4l2_ctrl_new_std(&ctx->ctrls, &coda_ctrl_ops,
+			V4L2_CID_MPEG_VIDEO_H264_MAX_QP, 0, 51, 1, 51);
+		v4l2_ctrl_new_std(&ctx->ctrls, &coda_ctrl_ops,
+			V4L2_CID_MPEG_VIDEO_H264_LOOP_FILTER_ALPHA, 0, 15, 1, 0);
+		v4l2_ctrl_new_std(&ctx->ctrls, &coda_ctrl_ops,
+			V4L2_CID_MPEG_VIDEO_H264_LOOP_FILTER_BETA, 0, 15, 1, 0);
+		v4l2_ctrl_new_std_menu(&ctx->ctrls, &coda_ctrl_ops,
+			V4L2_CID_MPEG_VIDEO_H264_LOOP_FILTER_MODE,
+			V4L2_MPEG_VIDEO_H264_LOOP_FILTER_MODE_DISABLED, 0x0,
+			V4L2_MPEG_VIDEO_H264_LOOP_FILTER_MODE_ENABLED);
+		break;
+	case V4L2_PIX_FMT_MPEG4:
 		v4l2_ctrl_new_std(&ctx->ctrls, &coda_ctrl_ops,
-			V4L2_CID_MPEG_VIDEO_H264_MIN_QP, 0, 51, 1, 12);
+			V4L2_CID_MPEG_VIDEO_MPEG4_I_FRAME_QP, 1, 31, 1, 2);
+		v4l2_ctrl_new_std(&ctx->ctrls, &coda_ctrl_ops,
+			V4L2_CID_MPEG_VIDEO_MPEG4_P_FRAME_QP, 1, 31, 1, 2);
+		break;
 	}
-	v4l2_ctrl_new_std(&ctx->ctrls, &coda_ctrl_ops,
-		V4L2_CID_MPEG_VIDEO_H264_MAX_QP, 0, 51, 1, 51);
-	v4l2_ctrl_new_std(&ctx->ctrls, &coda_ctrl_ops,
-		V4L2_CID_MPEG_VIDEO_H264_LOOP_FILTER_ALPHA, 0, 15, 1, 0);
-	v4l2_ctrl_new_std(&ctx->ctrls, &coda_ctrl_ops,
-		V4L2_CID_MPEG_VIDEO_H264_LOOP_FILTER_BETA, 0, 15, 1, 0);
-	v4l2_ctrl_new_std_menu(&ctx->ctrls, &coda_ctrl_ops,
-		V4L2_CID_MPEG_VIDEO_H264_LOOP_FILTER_MODE,
-		V4L2_MPEG_VIDEO_H264_LOOP_FILTER_MODE_DISABLED, 0x0,
-		V4L2_MPEG_VIDEO_H264_LOOP_FILTER_MODE_ENABLED);
-	v4l2_ctrl_new_std(&ctx->ctrls, &coda_ctrl_ops,
-		V4L2_CID_MPEG_VIDEO_MPEG4_I_FRAME_QP, 1, 31, 1, 2);
-	v4l2_ctrl_new_std(&ctx->ctrls, &coda_ctrl_ops,
-		V4L2_CID_MPEG_VIDEO_MPEG4_P_FRAME_QP, 1, 31, 1, 2);
 	v4l2_ctrl_new_std_menu(&ctx->ctrls, &coda_ctrl_ops,
 		V4L2_CID_MPEG_VIDEO_MULTI_SLICE_MODE,
 		V4L2_MPEG_VIDEO_MULTI_SICE_MODE_MAX_BYTES, 0x0,
@@ -1401,6 +1401,18 @@ static int coda_ctrls_setup(struct coda_ctx *ctx)
 	v4l2_ctrl_new_std(&ctx->ctrls, &coda_ctrl_ops,
 		V4L2_CID_MPEG_VIDEO_CYCLIC_INTRA_REFRESH_MB, 0,
 		1920 * 1088 / 256, 1, 0);
+}
+
+static int coda_ctrls_setup(struct coda_ctx *ctx)
+{
+	v4l2_ctrl_handler_init(&ctx->ctrls, 2);
+
+	v4l2_ctrl_new_std(&ctx->ctrls, &coda_ctrl_ops,
+		V4L2_CID_HFLIP, 0, 1, 1, 0);
+	v4l2_ctrl_new_std(&ctx->ctrls, &coda_ctrl_ops,
+		V4L2_CID_VFLIP, 0, 1, 1, 0);
+	if (ctx->inst_type == CODA_INST_ENCODER)
+		coda_encode_ctrls(ctx);
 
 	if (ctx->ctrls.error) {
 		v4l2_err(&ctx->dev->v4l2_dev,
-- 
2.1.0

