Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([85.220.165.71]:34207 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729874AbeKFApi (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 5 Nov 2018 19:45:38 -0500
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>, kernel@pengutronix.de
Subject: [PATCH 03/15] media: coda: always hold back decoder jobs until we have enough bitstream payload
Date: Mon,  5 Nov 2018 16:25:01 +0100
Message-Id: <20181105152513.26345-3-p.zabel@pengutronix.de>
In-Reply-To: <20181105152513.26345-1-p.zabel@pengutronix.de>
References: <20181105152513.26345-1-p.zabel@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The bitstream prefetch unit reads data in 256 byte blocks with some kind
of queueing. For the decoder to see data up to a desired position in the
next run, the bitstream has to be filled for 2 256 byte blocks past that
position aligned up to the next 256 byte boundary.
This should make sure we never run into a buffer underrun condition if
userspace does not supply new input buffers fast enough.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/media/platform/coda/coda-common.c | 13 ++++++++-----
 drivers/media/platform/coda/coda.h        | 12 ++++++++++++
 2 files changed, 20 insertions(+), 5 deletions(-)

diff --git a/drivers/media/platform/coda/coda-common.c b/drivers/media/platform/coda/coda-common.c
index c53ecc884e15..c7a274c60ff9 100644
--- a/drivers/media/platform/coda/coda-common.c
+++ b/drivers/media/platform/coda/coda-common.c
@@ -1272,6 +1272,7 @@ static int coda_job_ready(void *m2m_priv)
 		bool stream_end = ctx->bit_stream_param &
 				  CODA_BIT_STREAM_END_FLAG;
 		int num_metas = ctx->num_metas;
+		struct coda_buffer_meta *meta;
 		unsigned int count;
 
 		count = hweight32(ctx->frm_dis_flg);
@@ -1292,16 +1293,18 @@ static int coda_job_ready(void *m2m_priv)
 
 		if (!stream_end && (num_metas + src_bufs) < 2) {
 			v4l2_dbg(1, coda_debug, &ctx->dev->v4l2_dev,
-				 "%d: not ready: need 2 buffers available (%d, %d)\n",
+				 "%d: not ready: need 2 buffers available (queue:%d + bitstream:%d)\n",
 				 ctx->idx, num_metas, src_bufs);
 			return 0;
 		}
 
-		if (!src_bufs && !stream_end &&
-		    (coda_get_bitstream_payload(ctx) < 512)) {
+		meta = list_first_entry(&ctx->buffer_meta_list,
+					struct coda_buffer_meta, list);
+		if (!coda_bitstream_can_fetch_past(ctx, meta->end) &&
+		    !stream_end) {
 			v4l2_dbg(1, coda_debug, &ctx->dev->v4l2_dev,
-				 "%d: not ready: not enough bitstream data (%d).\n",
-				 ctx->idx, coda_get_bitstream_payload(ctx));
+				 "not ready: not enough bitstream data to read past %u (%u)\n",
+				 meta->end, ctx->bitstream_fifo.kfifo.in);
 			return 0;
 		}
 	}
diff --git a/drivers/media/platform/coda/coda.h b/drivers/media/platform/coda/coda.h
index 00d0fa50bcd1..6cb19f47cbed 100644
--- a/drivers/media/platform/coda/coda.h
+++ b/drivers/media/platform/coda/coda.h
@@ -295,6 +295,18 @@ static inline unsigned int coda_get_bitstream_payload(struct coda_ctx *ctx)
 	return kfifo_len(&ctx->bitstream_fifo);
 }
 
+/*
+ * The bitstream prefetcher needs to read at least 2 256 byte periods past
+ * the desired bitstream position for all data to reach the decoder.
+ */
+static inline bool coda_bitstream_can_fetch_past(struct coda_ctx *ctx,
+						 unsigned int pos)
+{
+	return (int)(ctx->bitstream_fifo.kfifo.in - ALIGN(pos, 256)) > 512;
+}
+
+bool coda_bitstream_can_fetch_past(struct coda_ctx *ctx, unsigned int pos);
+
 void coda_bit_stream_end_flag(struct coda_ctx *ctx);
 
 void coda_m2m_buf_done(struct coda_ctx *ctx, struct vb2_v4l2_buffer *buf,
-- 
2.19.1
