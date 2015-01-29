Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:49470 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754248AbbA2RgI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 29 Jan 2015 12:36:08 -0500
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Kamil Debski <k.debski@samsung.com>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	linux-media@vger.kernel.org, kernel@pengutronix.de,
	Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH] [media] coda: Add tracing support
Date: Thu, 29 Jan 2015 18:36:00 +0100
Message-Id: <1422552960-18851-1-git-send-email-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch adds tracepoints to the coda driver that can be used together
with the v4l2:v4l2_qbuf and v4l2:v4l2_dqbuf tracepoints to to follow video
frames through the mem2mem device.

For encoding with the BIT processor:
    coda:coda_enc_pic_run
    coda:coda_enc_pic_done

For decoding with the BIT processor:
    coda:coda_bit_queue
    coda:coda_dec_pic_run
    coda:coda_dec_pic_done
    coda:coda_dec_rot_done

Additionally, two low level tracepoints register whenever the BIT processor
is started and returns:
    coda:coda_bit_run
    coda:coda_bit_done

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/media/platform/coda/Makefile    |   2 +
 drivers/media/platform/coda/coda-bit.c  |  24 +++-
 drivers/media/platform/coda/coda-jpeg.c |   1 +
 drivers/media/platform/coda/coda.h      |   5 +
 drivers/media/platform/coda/trace.h     | 203 ++++++++++++++++++++++++++++++++
 5 files changed, 234 insertions(+), 1 deletion(-)
 create mode 100644 drivers/media/platform/coda/trace.h

diff --git a/drivers/media/platform/coda/Makefile b/drivers/media/platform/coda/Makefile
index 25ce155..834e504 100644
--- a/drivers/media/platform/coda/Makefile
+++ b/drivers/media/platform/coda/Makefile
@@ -1,3 +1,5 @@
+ccflags-y += -I$(src)
+
 coda-objs := coda-common.o coda-bit.o coda-h264.o coda-jpeg.o
 
 obj-$(CONFIG_VIDEO_CODA) += coda.o
diff --git a/drivers/media/platform/coda/coda-bit.c b/drivers/media/platform/coda/coda-bit.c
index 856b542..494cf59 100644
--- a/drivers/media/platform/coda/coda-bit.c
+++ b/drivers/media/platform/coda/coda-bit.c
@@ -29,6 +29,8 @@
 #include <media/videobuf2-vmalloc.h>
 
 #include "coda.h"
+#define CREATE_TRACE_POINTS
+#include "trace.h"
 
 #define CODA7_PS_BUF_SIZE	0x28000
 #define CODA9_PS_SAVE_SIZE	(512 * 1024)
@@ -84,15 +86,21 @@ static void coda_command_async(struct coda_ctx *ctx, int cmd)
 	coda_write(dev, ctx->params.codec_mode, CODA_REG_BIT_RUN_COD_STD);
 	coda_write(dev, ctx->params.codec_mode_aux, CODA7_REG_BIT_RUN_AUX_STD);
 
+	trace_coda_bit_run(ctx, cmd);
+
 	coda_write(dev, cmd, CODA_REG_BIT_RUN_COMMAND);
 }
 
 static int coda_command_sync(struct coda_ctx *ctx, int cmd)
 {
 	struct coda_dev *dev = ctx->dev;
+	int ret;
 
 	coda_command_async(ctx, cmd);
-	return coda_wait_timeout(dev);
+	ret = coda_wait_timeout(dev);
+	trace_coda_bit_done(ctx);
+
+	return ret;
 }
 
 int coda_hw_reset(struct coda_ctx *ctx)
@@ -262,6 +270,8 @@ void coda_fill_bitstream(struct coda_ctx *ctx)
 					    ctx->bitstream_fifo.kfifo.mask;
 				list_add_tail(&meta->list,
 					      &ctx->buffer_meta_list);
+
+				trace_coda_bit_queue(ctx, src_buf, meta);
 			}
 
 			v4l2_m2m_buf_done(src_buf, VB2_BUF_STATE_DONE);
@@ -1227,6 +1237,8 @@ static int coda_prepare_encode(struct coda_ctx *ctx)
 		coda_write(dev, ctx->iram_info.axi_sram_use,
 				CODA7_REG_BIT_AXI_SRAM_USE);
 
+	trace_coda_enc_pic_run(ctx, src_buf);
+
 	coda_command_async(ctx, CODA_COMMAND_PIC_RUN);
 
 	return 0;
@@ -1241,6 +1253,8 @@ static void coda_finish_encode(struct coda_ctx *ctx)
 	src_buf = v4l2_m2m_src_buf_remove(ctx->fh.m2m_ctx);
 	dst_buf = v4l2_m2m_next_dst_buf(ctx->fh.m2m_ctx);
 
+	trace_coda_enc_pic_done(ctx, dst_buf);
+
 	/* Get results from the coda */
 	start_ptr = coda_read(dev, CODA_CMD_ENC_PIC_BB_START);
 	wr_ptr = coda_read(dev, CODA_REG_BIT_WR_PTR(ctx->reg_idx));
@@ -1675,6 +1689,8 @@ static int coda_prepare_decode(struct coda_ctx *ctx)
 	/* Clear decode success flag */
 	coda_write(dev, 0, CODA_RET_DEC_PIC_SUCCESS);
 
+	trace_coda_dec_pic_run(ctx, meta);
+
 	coda_command_async(ctx, CODA_COMMAND_PIC_RUN);
 
 	return 0;
@@ -1835,6 +1851,8 @@ static void coda_finish_decode(struct coda_ctx *ctx)
 		}
 		mutex_unlock(&ctx->bitstream_mutex);
 
+		trace_coda_dec_pic_done(ctx, &ctx->frame_metas[decoded_idx]);
+
 		val = coda_read(dev, CODA_RET_DEC_PIC_TYPE) & 0x7;
 		if (val == 0)
 			ctx->frame_types[decoded_idx] = V4L2_BUF_FLAG_KEYFRAME;
@@ -1874,6 +1892,8 @@ static void coda_finish_decode(struct coda_ctx *ctx)
 		dst_buf->v4l2_buf.timecode = meta->timecode;
 		dst_buf->v4l2_buf.timestamp = meta->timestamp;
 
+		trace_coda_dec_rot_done(ctx, meta, dst_buf);
+
 		switch (q_data_dst->fourcc) {
 		case V4L2_PIX_FMT_YUV420:
 		case V4L2_PIX_FMT_YVU420:
@@ -1931,6 +1951,8 @@ irqreturn_t coda_irq_handler(int irq, void *data)
 		return IRQ_HANDLED;
 	}
 
+	trace_coda_bit_done(ctx);
+
 	if (ctx->aborting) {
 		v4l2_dbg(1, coda_debug, &ctx->dev->v4l2_dev,
 			 "task has been aborted\n");
diff --git a/drivers/media/platform/coda/coda-jpeg.c b/drivers/media/platform/coda/coda-jpeg.c
index 8fa3e35..11e734b 100644
--- a/drivers/media/platform/coda/coda-jpeg.c
+++ b/drivers/media/platform/coda/coda-jpeg.c
@@ -13,6 +13,7 @@
 #include <linux/swab.h>
 
 #include "coda.h"
+#include "trace.h"
 
 #define SOI_MARKER	0xffd8
 #define EOI_MARKER	0xffd9
diff --git a/drivers/media/platform/coda/coda.h b/drivers/media/platform/coda/coda.h
index 0c35cd5..bdc558b 100644
--- a/drivers/media/platform/coda/coda.h
+++ b/drivers/media/platform/coda/coda.h
@@ -12,6 +12,9 @@
  * (at your option) any later version.
  */
 
+#ifndef __CODA_H__
+#define __CODA_H__
+
 #include <linux/debugfs.h>
 #include <linux/irqreturn.h>
 #include <linux/mutex.h>
@@ -301,3 +304,5 @@ extern const struct coda_context_ops coda_bit_encode_ops;
 extern const struct coda_context_ops coda_bit_decode_ops;
 
 irqreturn_t coda_irq_handler(int irq, void *data);
+
+#endif /* __CODA_H__ */
diff --git a/drivers/media/platform/coda/trace.h b/drivers/media/platform/coda/trace.h
new file mode 100644
index 0000000..d1d06cb
--- /dev/null
+++ b/drivers/media/platform/coda/trace.h
@@ -0,0 +1,203 @@
+#undef TRACE_SYSTEM
+#define TRACE_SYSTEM coda
+
+#if !defined(__CODA_TRACE_H__) || defined(TRACE_HEADER_MULTI_READ)
+#define __CODA_TRACE_H__
+
+#include <linux/tracepoint.h>
+#include <media/videobuf2-core.h>
+
+#include "coda.h"
+
+#define TRACE_SYSTEM_STRING __stringify(TRACE_SYSTEM)
+
+TRACE_EVENT(coda_bit_run,
+	TP_PROTO(struct coda_ctx *ctx, int cmd),
+
+	TP_ARGS(ctx, cmd),
+
+	TP_STRUCT__entry(
+		__field(int, minor)
+		__field(int, ctx)
+		__field(int, cmd)
+	),
+
+	TP_fast_assign(
+		__entry->minor = ctx->fh.vdev->minor;
+		__entry->ctx = ctx->idx;
+		__entry->cmd = cmd;
+	),
+
+	TP_printk("minor = %d, ctx = %d, cmd = %d",
+		  __entry->minor, __entry->ctx, __entry->cmd)
+);
+
+TRACE_EVENT(coda_bit_done,
+	TP_PROTO(struct coda_ctx *ctx),
+
+	TP_ARGS(ctx),
+
+	TP_STRUCT__entry(
+		__field(int, minor)
+		__field(int, ctx)
+	),
+
+	TP_fast_assign(
+		__entry->minor = ctx->fh.vdev->minor;
+		__entry->ctx = ctx->idx;
+	),
+
+	TP_printk("minor = %d, ctx = %d", __entry->minor, __entry->ctx)
+);
+
+TRACE_EVENT(coda_enc_pic_run,
+	TP_PROTO(struct coda_ctx *ctx, struct vb2_buffer *buf),
+
+	TP_ARGS(ctx, buf),
+
+	TP_STRUCT__entry(
+		__field(int, minor)
+		__field(int, index)
+		__field(int, ctx)
+	),
+
+	TP_fast_assign(
+		__entry->minor = ctx->fh.vdev->minor;
+		__entry->index = buf->v4l2_buf.index;
+		__entry->ctx = ctx->idx;
+	),
+
+	TP_printk("minor = %d, index = %d, ctx = %d",
+		  __entry->minor, __entry->index, __entry->ctx)
+);
+
+TRACE_EVENT(coda_enc_pic_done,
+	TP_PROTO(struct coda_ctx *ctx, struct vb2_buffer *buf),
+
+	TP_ARGS(ctx, buf),
+
+	TP_STRUCT__entry(
+		__field(int, minor)
+		__field(int, index)
+		__field(int, ctx)
+	),
+
+	TP_fast_assign(
+		__entry->minor = ctx->fh.vdev->minor;
+		__entry->index = buf->v4l2_buf.index;
+		__entry->ctx = ctx->idx;
+	),
+
+	TP_printk("minor = %d, index = %d, ctx = %d",
+		  __entry->minor, __entry->index, __entry->ctx)
+);
+
+TRACE_EVENT(coda_bit_queue,
+	TP_PROTO(struct coda_ctx *ctx, struct vb2_buffer *buf,
+		 struct coda_buffer_meta *meta),
+
+	TP_ARGS(ctx, buf, meta),
+
+	TP_STRUCT__entry(
+		__field(int, minor)
+		__field(int, index)
+		__field(int, start)
+		__field(int, end)
+		__field(int, ctx)
+	),
+
+	TP_fast_assign(
+		__entry->minor = ctx->fh.vdev->minor;
+		__entry->index = buf->v4l2_buf.index;
+		__entry->start = meta->start;
+		__entry->end = meta->end;
+		__entry->ctx = ctx->idx;
+	),
+
+	TP_printk("minor = %d, index = %d, start = 0x%x, end = 0x%x, ctx = %d",
+		  __entry->minor, __entry->index, __entry->start, __entry->end,
+		  __entry->ctx)
+);
+
+TRACE_EVENT(coda_dec_pic_run,
+	TP_PROTO(struct coda_ctx *ctx, struct coda_buffer_meta *meta),
+
+	TP_ARGS(ctx, meta),
+
+	TP_STRUCT__entry(
+		__field(int, minor)
+		__field(int, start)
+		__field(int, end)
+		__field(int, ctx)
+	),
+
+	TP_fast_assign(
+		__entry->minor = ctx->fh.vdev->minor;
+		__entry->start = meta ? meta->start : 0;
+		__entry->end = meta ? meta->end : 0;
+		__entry->ctx = ctx->idx;
+	),
+
+	TP_printk("minor = %d, start = 0x%x, end = 0x%x, ctx = %d",
+		  __entry->minor, __entry->start, __entry->end, __entry->ctx)
+);
+
+TRACE_EVENT(coda_dec_pic_done,
+	TP_PROTO(struct coda_ctx *ctx, struct coda_buffer_meta *meta),
+
+	TP_ARGS(ctx, meta),
+
+	TP_STRUCT__entry(
+		__field(int, minor)
+		__field(int, start)
+		__field(int, end)
+		__field(int, ctx)
+	),
+
+	TP_fast_assign(
+		__entry->minor = ctx->fh.vdev->minor;
+		__entry->start = meta->start;
+		__entry->end = meta->end;
+		__entry->ctx = ctx->idx;
+	),
+
+	TP_printk("minor = %d, start = 0x%x, end = 0x%x, ctx = %d",
+		  __entry->minor, __entry->start, __entry->end, __entry->ctx)
+);
+
+TRACE_EVENT(coda_dec_rot_done,
+	TP_PROTO(struct coda_ctx *ctx, struct coda_buffer_meta *meta,
+		 struct vb2_buffer *buf),
+
+	TP_ARGS(ctx, meta, buf),
+
+	TP_STRUCT__entry(
+		__field(int, minor)
+		__field(int, start)
+		__field(int, end)
+		__field(int, index)
+		__field(int, ctx)
+	),
+
+	TP_fast_assign(
+		__entry->minor = ctx->fh.vdev->minor;
+		__entry->start = meta->start;
+		__entry->end = meta->end;
+		__entry->index = buf->v4l2_buf.index;
+		__entry->ctx = ctx->idx;
+	),
+
+	TP_printk("minor = %d, start = 0x%x, end = 0x%x, index = %d, ctx = %d",
+		  __entry->minor, __entry->start, __entry->end, __entry->index,
+		  __entry->ctx)
+);
+
+#endif /* __CODA_TRACE_H__ */
+
+#undef TRACE_INCLUDE_PATH
+#define TRACE_INCLUDE_PATH .
+#undef TRACE_INCLUDE_FILE
+#define TRACE_INCLUDE_FILE trace
+
+/* This part must be outside protection */
+#include <trace/define_trace.h>
-- 
2.1.4

