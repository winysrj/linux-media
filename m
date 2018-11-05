Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([85.220.165.71]:35213 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729917AbeKFApj (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 5 Nov 2018 19:45:39 -0500
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>, kernel@pengutronix.de
Subject: [PATCH 04/15] media: coda: limit queueing into internal bitstream buffer
Date: Mon,  5 Nov 2018 16:25:02 +0100
Message-Id: <20181105152513.26345-4-p.zabel@pengutronix.de>
In-Reply-To: <20181105152513.26345-1-p.zabel@pengutronix.de>
References: <20181105152513.26345-1-p.zabel@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Lucas Stach <l.stach@pengutronix.de>

The ringbuffer used to hold the bitstream is very conservatively sized,
as keyframes can get very large and still need to fit into this buffer.
This means that the buffer is way oversized for the average stream to
the extend that it will hold a few hundred frames when the video data
is compressing well.

The current strategy of queueing as much bitstream data as possible
leads to large delays when draining the decoder. In order to keep the
drain latency to a reasonable bound, try to only queue a full reorder
window of buffers. We can't always hit this low target for very well
compressible video data, as we might end up with less than the minimum
amount of data that needs to be available to the bitstream prefetcher,
so we must take this into account and allow more buffers to be queued
in this case.

Signed-off-by: Lucas Stach <l.stach@pengutronix.de>
---
 drivers/media/platform/coda/coda-bit.c | 28 ++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

diff --git a/drivers/media/platform/coda/coda-bit.c b/drivers/media/platform/coda/coda-bit.c
index e5ce0bec8ec3..ee9d2a402ccd 100644
--- a/drivers/media/platform/coda/coda-bit.c
+++ b/drivers/media/platform/coda/coda-bit.c
@@ -269,6 +269,23 @@ void coda_fill_bitstream(struct coda_ctx *ctx, struct list_head *buffer_list)
 		    ctx->num_metas > 1)
 			break;
 
+		if (ctx->num_internal_frames &&
+		    ctx->num_metas >= ctx->num_internal_frames) {
+			meta = list_first_entry(&ctx->buffer_meta_list,
+						struct coda_buffer_meta, list);
+
+			/*
+			 * If we managed to fill in at least a full reorder
+			 * window of buffers (num_internal_frames is a
+			 * conservative estimate for this) and the bitstream
+			 * prefetcher has at least 2 256 bytes periods beyond
+			 * the first buffer to fetch, we can safely stop queuing
+			 * in order to limit the decoder drain latency.
+			 */
+			if (coda_bitstream_can_fetch_past(ctx, meta->end))
+				break;
+		}
+
 		src_buf = v4l2_m2m_next_src_buf(ctx->fh.m2m_ctx);
 
 		/* Drop frames that do not start/end with a SOI/EOI markers */
@@ -2252,6 +2269,17 @@ static void coda_finish_decode(struct coda_ctx *ctx)
 
 	/* The rotator will copy the current display frame next time */
 	ctx->display_idx = display_idx;
+
+	/*
+	 * The current decode run might have brought the bitstream fill level
+	 * below the size where we can start the next decode run. As userspace
+	 * might have filled the output queue completely and might thus be
+	 * blocked, we can't rely on the next qbuf to trigger the bitstream
+	 * refill. Check if we have data to refill the bitstream now.
+	 */
+	mutex_lock(&ctx->bitstream_mutex);
+	coda_fill_bitstream(ctx, NULL);
+	mutex_unlock(&ctx->bitstream_mutex);
 }
 
 static void coda_decode_timeout(struct coda_ctx *ctx)
-- 
2.19.1
