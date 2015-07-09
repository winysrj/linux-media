Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:34802 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752343AbbGIKKg (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 9 Jul 2015 06:10:36 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Kamil Debski <kamil@wypas.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	linux-media@vger.kernel.org, kernel@pengutronix.de,
	Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH 08/10] [media] coda: use event class to deduplicate v4l2 trace events
Date: Thu,  9 Jul 2015 12:10:19 +0200
Message-Id: <1436436621-12291-8-git-send-email-p.zabel@pengutronix.de>
In-Reply-To: <1436436621-12291-1-git-send-email-p.zabel@pengutronix.de>
References: <1436436621-12291-1-git-send-email-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Trace events with exactly the same parameters and trace output, such as
coda_enc_pic_run and coda_enc_pic_done, are supposed to use the
DECLARE_EVENT_CLASS and DEFINE_EVENT macros instead of duplicated
TRACE_EVENT macro calls.
This patch changes the order of parameters to coda_dec_rot_done and adds
a timestamp so it can share an event class with coda_bit_queue.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/media/platform/coda/coda-bit.c |  2 +-
 drivers/media/platform/coda/trace.h    | 89 ++++++++++------------------------
 2 files changed, 26 insertions(+), 65 deletions(-)

diff --git a/drivers/media/platform/coda/coda-bit.c b/drivers/media/platform/coda/coda-bit.c
index ac4dcb1..226ce4a 100644
--- a/drivers/media/platform/coda/coda-bit.c
+++ b/drivers/media/platform/coda/coda-bit.c
@@ -1978,7 +1978,7 @@ static void coda_finish_decode(struct coda_ctx *ctx)
 		dst_buf->v4l2_buf.timecode = meta->timecode;
 		dst_buf->v4l2_buf.timestamp = meta->timestamp;
 
-		trace_coda_dec_rot_done(ctx, meta, dst_buf);
+		trace_coda_dec_rot_done(ctx, dst_buf, meta);
 
 		switch (q_data_dst->fourcc) {
 		case V4L2_PIX_FMT_YUV420:
diff --git a/drivers/media/platform/coda/trace.h b/drivers/media/platform/coda/trace.h
index 781bf72..d9099a0 100644
--- a/drivers/media/platform/coda/trace.h
+++ b/drivers/media/platform/coda/trace.h
@@ -48,7 +48,7 @@ TRACE_EVENT(coda_bit_done,
 	TP_printk("minor = %d, ctx = %d", __entry->minor, __entry->ctx)
 );
 
-TRACE_EVENT(coda_enc_pic_run,
+DECLARE_EVENT_CLASS(coda_buf_class,
 	TP_PROTO(struct coda_ctx *ctx, struct vb2_buffer *buf),
 
 	TP_ARGS(ctx, buf),
@@ -69,28 +69,17 @@ TRACE_EVENT(coda_enc_pic_run,
 		  __entry->minor, __entry->index, __entry->ctx)
 );
 
-TRACE_EVENT(coda_enc_pic_done,
+DEFINE_EVENT(coda_buf_class, coda_enc_pic_run,
 	TP_PROTO(struct coda_ctx *ctx, struct vb2_buffer *buf),
+	TP_ARGS(ctx, buf)
+);
 
-	TP_ARGS(ctx, buf),
-
-	TP_STRUCT__entry(
-		__field(int, minor)
-		__field(int, index)
-		__field(int, ctx)
-	),
-
-	TP_fast_assign(
-		__entry->minor = ctx->fh.vdev->minor;
-		__entry->index = buf->v4l2_buf.index;
-		__entry->ctx = ctx->idx;
-	),
-
-	TP_printk("minor = %d, index = %d, ctx = %d",
-		  __entry->minor, __entry->index, __entry->ctx)
+DEFINE_EVENT(coda_buf_class, coda_enc_pic_done,
+	TP_PROTO(struct coda_ctx *ctx, struct vb2_buffer *buf),
+	TP_ARGS(ctx, buf)
 );
 
-TRACE_EVENT(coda_bit_queue,
+DECLARE_EVENT_CLASS(coda_buf_meta_class,
 	TP_PROTO(struct coda_ctx *ctx, struct vb2_buffer *buf,
 		 struct coda_buffer_meta *meta),
 
@@ -117,7 +106,13 @@ TRACE_EVENT(coda_bit_queue,
 		  __entry->ctx)
 );
 
-TRACE_EVENT(coda_dec_pic_run,
+DEFINE_EVENT(coda_buf_meta_class, coda_bit_queue,
+	TP_PROTO(struct coda_ctx *ctx, struct vb2_buffer *buf,
+		 struct coda_buffer_meta *meta),
+	TP_ARGS(ctx, buf, meta)
+);
+
+DECLARE_EVENT_CLASS(coda_meta_class,
 	TP_PROTO(struct coda_ctx *ctx, struct coda_buffer_meta *meta),
 
 	TP_ARGS(ctx, meta),
@@ -140,54 +135,20 @@ TRACE_EVENT(coda_dec_pic_run,
 		  __entry->minor, __entry->start, __entry->end, __entry->ctx)
 );
 
-TRACE_EVENT(coda_dec_pic_done,
+DEFINE_EVENT(coda_meta_class, coda_dec_pic_run,
 	TP_PROTO(struct coda_ctx *ctx, struct coda_buffer_meta *meta),
-
-	TP_ARGS(ctx, meta),
-
-	TP_STRUCT__entry(
-		__field(int, minor)
-		__field(int, start)
-		__field(int, end)
-		__field(int, ctx)
-	),
-
-	TP_fast_assign(
-		__entry->minor = ctx->fh.vdev->minor;
-		__entry->start = meta->start;
-		__entry->end = meta->end;
-		__entry->ctx = ctx->idx;
-	),
-
-	TP_printk("minor = %d, start = 0x%x, end = 0x%x, ctx = %d",
-		  __entry->minor, __entry->start, __entry->end, __entry->ctx)
+	TP_ARGS(ctx, meta)
 );
 
-TRACE_EVENT(coda_dec_rot_done,
-	TP_PROTO(struct coda_ctx *ctx, struct coda_buffer_meta *meta,
-		 struct vb2_buffer *buf),
-
-	TP_ARGS(ctx, meta, buf),
-
-	TP_STRUCT__entry(
-		__field(int, minor)
-		__field(int, start)
-		__field(int, end)
-		__field(int, index)
-		__field(int, ctx)
-	),
-
-	TP_fast_assign(
-		__entry->minor = ctx->fh.vdev->minor;
-		__entry->start = meta->start;
-		__entry->end = meta->end;
-		__entry->index = buf->v4l2_buf.index;
-		__entry->ctx = ctx->idx;
-	),
+DEFINE_EVENT(coda_meta_class, coda_dec_pic_done,
+	TP_PROTO(struct coda_ctx *ctx, struct coda_buffer_meta *meta),
+	TP_ARGS(ctx, meta)
+);
 
-	TP_printk("minor = %d, start = 0x%x, end = 0x%x, index = %d, ctx = %d",
-		  __entry->minor, __entry->start, __entry->end, __entry->index,
-		  __entry->ctx)
+DEFINE_EVENT(coda_buf_meta_class, coda_dec_rot_done,
+	TP_PROTO(struct coda_ctx *ctx, struct vb2_buffer *buf,
+		 struct coda_buffer_meta *meta),
+	TP_ARGS(ctx, buf, meta)
 );
 
 #endif /* __CODA_TRACE_H__ */
-- 
2.1.4

