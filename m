Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.4.pengutronix.de ([92.198.50.35]:47601 "EHLO
        metis.ext.4.pengutronix.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751454AbdFFP7V (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 6 Jun 2017 11:59:21 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: kernel@pengutronix.de, Nicolas Dufresne <nicolas@ndufresne.ca>,
        Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH 1/2] [media] coda: implement forced key frames
Date: Tue,  6 Jun 2017 17:59:01 +0200
Message-Id: <20170606155902.3703-1-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Implement the V4L2_CID_MPEG_VIDEO_FORCE_KEY_FRAME control to force IDR
frames. This is useful to implement VFU (Video Fast Update) on RTP
transmissions.
We already force an IDR frame at the beginning of each GOP to work
around a firmware bug on i.MX27, use the same mechanism to service IDR
requests from userspace.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/media/platform/coda/coda-bit.c    | 12 ++++++++----
 drivers/media/platform/coda/coda-common.c |  3 +++
 drivers/media/platform/coda/coda.h        |  1 +
 3 files changed, 12 insertions(+), 4 deletions(-)

diff --git a/drivers/media/platform/coda/coda-bit.c b/drivers/media/platform/coda/coda-bit.c
index 403214e00e954..22e4630f36711 100644
--- a/drivers/media/platform/coda/coda-bit.c
+++ b/drivers/media/platform/coda/coda-bit.c
@@ -1247,12 +1247,18 @@ static int coda_prepare_encode(struct coda_ctx *ctx)
 	dst_buf->sequence = ctx->osequence;
 	ctx->osequence++;
 
+	force_ipicture = ctx->params.force_ipicture;
+	if (force_ipicture)
+		ctx->params.force_ipicture = false;
+	else if ((src_buf->sequence % ctx->params.gop_size) == 0)
+		force_ipicture = 1;
+
 	/*
 	 * Workaround coda firmware BUG that only marks the first
 	 * frame as IDR. This is a problem for some decoders that can't
 	 * recover when a frame is lost.
 	 */
-	if (src_buf->sequence % ctx->params.gop_size) {
+	if (!force_ipicture) {
 		src_buf->flags |= V4L2_BUF_FLAG_PFRAME;
 		src_buf->flags &= ~V4L2_BUF_FLAG_KEYFRAME;
 	} else {
@@ -1291,8 +1297,7 @@ static int coda_prepare_encode(struct coda_ctx *ctx)
 		pic_stream_buffer_size = q_data_dst->sizeimage;
 	}
 
-	if (src_buf->flags & V4L2_BUF_FLAG_KEYFRAME) {
-		force_ipicture = 1;
+	if (force_ipicture) {
 		switch (dst_fourcc) {
 		case V4L2_PIX_FMT_H264:
 			quant_param = ctx->params.h264_intra_qp;
@@ -1309,7 +1314,6 @@ static int coda_prepare_encode(struct coda_ctx *ctx)
 			break;
 		}
 	} else {
-		force_ipicture = 0;
 		switch (dst_fourcc) {
 		case V4L2_PIX_FMT_H264:
 			quant_param = ctx->params.h264_inter_qp;
diff --git a/drivers/media/platform/coda/coda-common.c b/drivers/media/platform/coda/coda-common.c
index d523e990d5093..f3fe4adf21a7e 100644
--- a/drivers/media/platform/coda/coda-common.c
+++ b/drivers/media/platform/coda/coda-common.c
@@ -1680,6 +1680,9 @@ static int coda_s_ctrl(struct v4l2_ctrl *ctrl)
 	case V4L2_CID_MPEG_VIDEO_CYCLIC_INTRA_REFRESH_MB:
 		ctx->params.intra_refresh = ctrl->val;
 		break;
+	case V4L2_CID_MPEG_VIDEO_FORCE_KEY_FRAME:
+		ctx->params.force_ipicture = true;
+		break;
 	case V4L2_CID_JPEG_COMPRESSION_QUALITY:
 		coda_set_jpeg_compression_quality(ctx, ctrl->val);
 		break;
diff --git a/drivers/media/platform/coda/coda.h b/drivers/media/platform/coda/coda.h
index 20222befb9b2f..dccb105a1a384 100644
--- a/drivers/media/platform/coda/coda.h
+++ b/drivers/media/platform/coda/coda.h
@@ -135,6 +135,7 @@ struct coda_params {
 	u32			vbv_size;
 	u32			slice_max_bits;
 	u32			slice_max_mb;
+	bool			force_ipicture;
 };
 
 struct coda_buffer_meta {
-- 
2.11.0
