Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:60803 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755574AbbAWQvj (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 23 Jan 2015 11:51:39 -0500
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Kamil Debski <k.debski@samsung.com>
Cc: linux-media@vger.kernel.org, Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH 06/21] [media] coda: fix job_ready debug reporting for bitstream decoding
Date: Fri, 23 Jan 2015 17:51:20 +0100
Message-Id: <1422031895-7740-7-git-send-email-p.zabel@pengutronix.de>
In-Reply-To: <1422031895-7740-1-git-send-email-p.zabel@pengutronix.de>
References: <1422031895-7740-1-git-send-email-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Clarify whether job_ready returns false because the context is on hold, waiting
for new input buffers, whether there are not enough input buffers to fill two
into the bitstream, or whether there is not enough data in the bitstream buffer
for the bitstream reader hardware to read a whole frame.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/media/platform/coda/coda-common.c | 46 +++++++++++++++++++++++++------
 1 file changed, 37 insertions(+), 9 deletions(-)

diff --git a/drivers/media/platform/coda/coda-common.c b/drivers/media/platform/coda/coda-common.c
index 9a0ee11..ea54337 100644
--- a/drivers/media/platform/coda/coda-common.c
+++ b/drivers/media/platform/coda/coda-common.c
@@ -939,15 +939,43 @@ static int coda_job_ready(void *m2m_priv)
 		return 0;
 	}
 
-	if (ctx->hold ||
-	    ((ctx->inst_type == CODA_INST_DECODER) &&
-	     !v4l2_m2m_num_src_bufs_ready(ctx->fh.m2m_ctx) &&
-	     (coda_get_bitstream_payload(ctx) < 512) &&
-	     !(ctx->bit_stream_param & CODA_BIT_STREAM_END_FLAG))) {
-		v4l2_dbg(1, coda_debug, &ctx->dev->v4l2_dev,
-			 "%d: not ready: not enough bitstream data.\n",
-			 ctx->idx);
-		return 0;
+	if (ctx->inst_type == CODA_INST_DECODER) {
+		struct list_head *meta;
+		bool stream_end;
+		int num_metas;
+		int src_bufs;
+
+		if (ctx->hold && !v4l2_m2m_num_src_bufs_ready(ctx->fh.m2m_ctx)) {
+			v4l2_dbg(1, coda_debug, &ctx->dev->v4l2_dev,
+				 "%d: not ready: on hold for more buffers.\n",
+				 ctx->idx);
+			return 0;
+		}
+
+		stream_end = ctx->bit_stream_param &
+			     CODA_BIT_STREAM_END_FLAG;
+
+		num_metas = 0;
+		list_for_each(meta, &ctx->buffer_meta_list)
+			num_metas++;
+
+		src_bufs = v4l2_m2m_num_src_bufs_ready(ctx->fh.m2m_ctx);
+
+		if (!stream_end && (num_metas + src_bufs) < 2) {
+			v4l2_dbg(1, coda_debug, &ctx->dev->v4l2_dev,
+				 "%d: not ready: need 2 buffers available (%d, %d)\n",
+				 ctx->idx, num_metas, src_bufs);
+			return 0;
+		}
+
+
+		if (!v4l2_m2m_num_src_bufs_ready(ctx->fh.m2m_ctx) &&
+		    !stream_end && (coda_get_bitstream_payload(ctx) < 512)) {
+			v4l2_dbg(1, coda_debug, &ctx->dev->v4l2_dev,
+				 "%d: not ready: not enough bitstream data (%d).\n",
+				 ctx->idx, coda_get_bitstream_payload(ctx));
+			return 0;
+		}
 	}
 
 	if (ctx->aborting) {
-- 
2.1.4

