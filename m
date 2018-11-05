Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([85.220.165.71]:36355 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729871AbeKFApi (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 5 Nov 2018 19:45:38 -0500
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>, kernel@pengutronix.de
Subject: [PATCH 02/15] media: coda: store unmasked fifo position in meta
Date: Mon,  5 Nov 2018 16:25:00 +0100
Message-Id: <20181105152513.26345-2-p.zabel@pengutronix.de>
In-Reply-To: <20181105152513.26345-1-p.zabel@pengutronix.de>
References: <20181105152513.26345-1-p.zabel@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Storing the unmasked kfifo->in position as meta->start and ->end allows
to more easily compare a point past meta->end with the current
kfifo->in.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/media/platform/coda/coda-bit.c    |  9 +++------
 drivers/media/platform/coda/coda-common.c |  1 -
 drivers/media/platform/coda/coda.h        |  4 ++--
 drivers/media/platform/coda/trace.h       | 10 ++++++----
 4 files changed, 11 insertions(+), 13 deletions(-)

diff --git a/drivers/media/platform/coda/coda-bit.c b/drivers/media/platform/coda/coda-bit.c
index d26c2d85a009..e5ce0bec8ec3 100644
--- a/drivers/media/platform/coda/coda-bit.c
+++ b/drivers/media/platform/coda/coda-bit.c
@@ -299,8 +299,7 @@ void coda_fill_bitstream(struct coda_ctx *ctx, struct list_head *buffer_list)
 		}
 
 		/* Buffer start position */
-		start = ctx->bitstream_fifo.kfifo.in &
-			ctx->bitstream_fifo.kfifo.mask;
+		start = ctx->bitstream_fifo.kfifo.in;
 
 		if (coda_bitstream_try_queue(ctx, src_buf)) {
 			/*
@@ -315,8 +314,7 @@ void coda_fill_bitstream(struct coda_ctx *ctx, struct list_head *buffer_list)
 				meta->timecode = src_buf->timecode;
 				meta->timestamp = src_buf->vb2_buf.timestamp;
 				meta->start = start;
-				meta->end = ctx->bitstream_fifo.kfifo.in &
-					    ctx->bitstream_fifo.kfifo.mask;
+				meta->end = ctx->bitstream_fifo.kfifo.in;
 				spin_lock_irqsave(&ctx->buffer_meta_lock,
 						  flags);
 				list_add_tail(&meta->list,
@@ -1980,8 +1978,7 @@ static int coda_prepare_decode(struct coda_ctx *ctx)
 	if (meta && ctx->codec->src_fourcc == V4L2_PIX_FMT_JPEG) {
 
 		/* If this is the last buffer in the bitstream, add padding */
-		if (meta->end == (ctx->bitstream_fifo.kfifo.in &
-				  ctx->bitstream_fifo.kfifo.mask)) {
+		if (meta->end == ctx->bitstream_fifo.kfifo.in) {
 			static unsigned char buf[512];
 			unsigned int pad;
 
diff --git a/drivers/media/platform/coda/coda-common.c b/drivers/media/platform/coda/coda-common.c
index cbb59c2f3a82..c53ecc884e15 100644
--- a/drivers/media/platform/coda/coda-common.c
+++ b/drivers/media/platform/coda/coda-common.c
@@ -1297,7 +1297,6 @@ static int coda_job_ready(void *m2m_priv)
 			return 0;
 		}
 
-
 		if (!src_bufs && !stream_end &&
 		    (coda_get_bitstream_payload(ctx) < 512)) {
 			v4l2_dbg(1, coda_debug, &ctx->dev->v4l2_dev,
diff --git a/drivers/media/platform/coda/coda.h b/drivers/media/platform/coda/coda.h
index b6cd14ee91ea..00d0fa50bcd1 100644
--- a/drivers/media/platform/coda/coda.h
+++ b/drivers/media/platform/coda/coda.h
@@ -144,8 +144,8 @@ struct coda_buffer_meta {
 	u32			sequence;
 	struct v4l2_timecode	timecode;
 	u64			timestamp;
-	u32			start;
-	u32			end;
+	unsigned int		start;
+	unsigned int		end;
 };
 
 /* Per-queue, driver-specific private data */
diff --git a/drivers/media/platform/coda/trace.h b/drivers/media/platform/coda/trace.h
index ca671e315ad0..a672bfc4c6ba 100644
--- a/drivers/media/platform/coda/trace.h
+++ b/drivers/media/platform/coda/trace.h
@@ -97,8 +97,8 @@ DECLARE_EVENT_CLASS(coda_buf_meta_class,
 	TP_fast_assign(
 		__entry->minor = ctx->fh.vdev->minor;
 		__entry->index = buf->vb2_buf.index;
-		__entry->start = meta->start;
-		__entry->end = meta->end;
+		__entry->start = meta->start & ctx->bitstream_fifo.kfifo.mask;
+		__entry->end = meta->end & ctx->bitstream_fifo.kfifo.mask;
 		__entry->ctx = ctx->idx;
 	),
 
@@ -127,8 +127,10 @@ DECLARE_EVENT_CLASS(coda_meta_class,
 
 	TP_fast_assign(
 		__entry->minor = ctx->fh.vdev->minor;
-		__entry->start = meta ? meta->start : 0;
-		__entry->end = meta ? meta->end : 0;
+		__entry->start = meta ? (meta->start &
+					 ctx->bitstream_fifo.kfifo.mask) : 0;
+		__entry->end = meta ? (meta->end &
+				       ctx->bitstream_fifo.kfifo.mask) : 0;
 		__entry->ctx = ctx->idx;
 	),
 
-- 
2.19.1
