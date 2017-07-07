Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.4.pengutronix.de ([92.198.50.35]:58385 "EHLO
        metis.ext.4.pengutronix.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750883AbdGGJ6l (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 7 Jul 2017 05:58:41 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: kernel@pengutronix.de, Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH 1/5] [media] coda: extend GOP size range
Date: Fri,  7 Jul 2017 11:58:27 +0200
Message-Id: <20170707095831.9852-1-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

CodaDx6 only accepts GOP sizes up to 60 frames, but CODA960 can handle
up to 99 frames. If we disable automatic I frame generation altogether
by setting GOP size to 0, we can let an application produce arbitrarily
large I frame intervals using the V4L2_CID_MPEG_VIDEO_FORCE_KEY_FRAME
control.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/media/platform/coda/coda-bit.c    | 5 +++--
 drivers/media/platform/coda/coda-common.c | 4 +++-
 2 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/media/platform/coda/coda-bit.c b/drivers/media/platform/coda/coda-bit.c
index bba1eb43b5d83..50eed636830f8 100644
--- a/drivers/media/platform/coda/coda-bit.c
+++ b/drivers/media/platform/coda/coda-bit.c
@@ -1006,7 +1006,7 @@ static int coda_start_encoding(struct coda_ctx *ctx)
 			break;
 		}
 		coda_write(dev, value, CODA_CMD_ENC_SEQ_SLICE_MODE);
-		value = ctx->params.gop_size & CODA_GOP_SIZE_MASK;
+		value = ctx->params.gop_size;
 		coda_write(dev, value, CODA_CMD_ENC_SEQ_GOP_SIZE);
 	}
 
@@ -1250,7 +1250,8 @@ static int coda_prepare_encode(struct coda_ctx *ctx)
 	force_ipicture = ctx->params.force_ipicture;
 	if (force_ipicture)
 		ctx->params.force_ipicture = false;
-	else if ((src_buf->sequence % ctx->params.gop_size) == 0)
+	else if (ctx->params.gop_size != 0 &&
+		 (src_buf->sequence % ctx->params.gop_size) == 0)
 		force_ipicture = 1;
 
 	/*
diff --git a/drivers/media/platform/coda/coda-common.c b/drivers/media/platform/coda/coda-common.c
index 829c7895a98a2..218d778a9c45a 100644
--- a/drivers/media/platform/coda/coda-common.c
+++ b/drivers/media/platform/coda/coda-common.c
@@ -1734,10 +1734,12 @@ static const struct v4l2_ctrl_ops coda_ctrl_ops = {
 
 static void coda_encode_ctrls(struct coda_ctx *ctx)
 {
+	int max_gop_size = (ctx->dev->devtype->product == CODA_DX6) ? 60 : 99;
+
 	v4l2_ctrl_new_std(&ctx->ctrls, &coda_ctrl_ops,
 		V4L2_CID_MPEG_VIDEO_BITRATE, 0, 32767000, 1000, 0);
 	v4l2_ctrl_new_std(&ctx->ctrls, &coda_ctrl_ops,
-		V4L2_CID_MPEG_VIDEO_GOP_SIZE, 1, 60, 1, 16);
+		V4L2_CID_MPEG_VIDEO_GOP_SIZE, 0, max_gop_size, 1, 16);
 	v4l2_ctrl_new_std(&ctx->ctrls, &coda_ctrl_ops,
 		V4L2_CID_MPEG_VIDEO_H264_I_FRAME_QP, 0, 51, 1, 25);
 	v4l2_ctrl_new_std(&ctx->ctrls, &coda_ctrl_ops,
-- 
2.11.0
