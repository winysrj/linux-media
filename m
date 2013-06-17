Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:42959 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751847Ab3FQO7Z (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 17 Jun 2013 10:59:25 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: Kamil Debski <k.debski@samsung.com>,
	Javier Martin <javier.martin@vista-silicon.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	=?UTF-8?q?Ga=C3=ABtan=20Carlier?= <gcembed@gmail.com>,
	Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH 8/8] [media] coda: add CODA7541 decoding support
Date: Mon, 17 Jun 2013 16:59:19 +0200
Message-Id: <1371481159-27412-9-git-send-email-p.zabel@pengutronix.de>
In-Reply-To: <1371481159-27412-1-git-send-email-p.zabel@pengutronix.de>
References: <1371481159-27412-1-git-send-email-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch enables decoding of h.264 and mpeg4 streams on CODA7541.
Queued output buffers are immediately copied into the bitstream
ringbuffer. A device_run can be scheduled whenever there is either
enough compressed bitstream data, or the CODA is in stream end mode.

Each successful device_run, data is read from the bitstream ringbuffer
and a frame is decoded into a free internal framebuffer. Depending on
reordering, a possibly previously decoded frame is marked as display
frame, and at the same time the display frame from the previous run
is copied out into a capture buffer by the rotator hardware.

The dequeued capture buffers are counted to send the EOS signal to
userspace with the last frame. When userspace sends the decoder stop
command or enqueues an empty output buffer, the stream end flag is
set to allow decoding the remaining frames in the bitstream
ringbuffer.

The enum_fmt/try_fmt functions return fixed capture buffer sizes
while the output queue is streaming, to allow better autonegotiation
in userspace.

A per-context buffer mutex is used to lock the picture run against
buffer dequeueing: if a job gets queued, then streamoff dequeues
the last buffer, and then device_run is called, bail out. For that
the interrupt handler has to be threaded.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/media/platform/coda.c | 785 ++++++++++++++++++++++++++++++++++++++----
 drivers/media/platform/coda.h |  84 +++++
 2 files changed, 811 insertions(+), 58 deletions(-)

diff --git a/drivers/media/platform/coda.c b/drivers/media/platform/coda.c
index e8b3708..16f1726 100644
--- a/drivers/media/platform/coda.c
+++ b/drivers/media/platform/coda.c
@@ -29,6 +29,7 @@
 
 #include <media/v4l2-ctrls.h>
 #include <media/v4l2-device.h>
+#include <media/v4l2-event.h>
 #include <media/v4l2-ioctl.h>
 #include <media/v4l2-mem2mem.h>
 #include <media/videobuf2-core.h>
@@ -47,9 +48,11 @@
 #define CODA_PARA_BUF_SIZE	(10 * 1024)
 #define CODA_ISRAM_SIZE	(2048 * 2)
 #define CODADX6_IRAM_SIZE	0xb000
-#define CODA7_IRAM_SIZE		0x14000 /* 81920 bytes */
+#define CODA7_IRAM_SIZE		0x14000
 
-#define CODA_MAX_FRAMEBUFFERS	2
+#define CODA7_PS_BUF_SIZE	0x28000
+
+#define CODA_MAX_FRAMEBUFFERS	8
 
 #define MAX_W		8192
 #define MAX_H		8192
@@ -178,12 +181,16 @@ struct coda_iram_info {
 
 struct coda_ctx {
 	struct coda_dev			*dev;
+	struct mutex			buffer_mutex;
 	struct list_head		list;
+	struct work_struct		skip_run;
 	int				aborting;
+	int				initialized;
 	int				streamon_out;
 	int				streamon_cap;
 	u32				isequence;
 	u32				qsequence;
+	u32				osequence;
 	struct coda_q_data		q_data[2];
 	enum coda_inst_type		inst_type;
 	struct coda_codec		*codec;
@@ -193,12 +200,16 @@ struct coda_ctx {
 	struct v4l2_ctrl_handler	ctrls;
 	struct v4l2_fh			fh;
 	int				gopcounter;
+	int				runcounter;
 	char				vpu_header[3][64];
 	int				vpu_header_size[3];
 	struct kfifo			bitstream_fifo;
 	struct mutex			bitstream_mutex;
 	struct coda_aux_buf		bitstream;
+	bool				prescan_failed;
 	struct coda_aux_buf		parabuf;
+	struct coda_aux_buf		psbuf;
+	struct coda_aux_buf		slicebuf;
 	struct coda_aux_buf		internal_frames[CODA_MAX_FRAMEBUFFERS];
 	struct coda_aux_buf		workbuf;
 	int				num_internal_frames;
@@ -206,6 +217,8 @@ struct coda_ctx {
 	int				reg_idx;
 	struct coda_iram_info		iram_info;
 	u32				bit_stream_param;
+	u32				frm_dis_flg;
+	int				display_idx;
 };
 
 static const u8 coda_filler_nal[14] = { 0x00, 0x00, 0x00, 0x01, 0x0c, 0xff,
@@ -257,6 +270,8 @@ static void coda_command_async(struct coda_ctx *ctx, int cmd)
 		/* Restore context related registers to CODA */
 		coda_write(dev, ctx->bit_stream_param,
 				CODA_REG_BIT_BIT_STREAM_PARAM);
+		coda_write(dev, ctx->frm_dis_flg,
+				CODA_REG_BIT_FRM_DIS_FLG(ctx->reg_idx));
 		coda_write(dev, ctx->workbuf.paddr, CODA_REG_BIT_WORK_BUF_ADDR);
 	}
 
@@ -331,6 +346,8 @@ static struct coda_codec codadx6_codecs[] = {
 static struct coda_codec coda7_codecs[] = {
 	CODA_CODEC(CODA7_MODE_ENCODE_H264, V4L2_PIX_FMT_YUV420, V4L2_PIX_FMT_H264,   1280, 720),
 	CODA_CODEC(CODA7_MODE_ENCODE_MP4,  V4L2_PIX_FMT_YUV420, V4L2_PIX_FMT_MPEG4,  1280, 720),
+	CODA_CODEC(CODA7_MODE_DECODE_H264, V4L2_PIX_FMT_H264,   V4L2_PIX_FMT_YUV420, 1920, 1080),
+	CODA_CODEC(CODA7_MODE_DECODE_MP4,  V4L2_PIX_FMT_MPEG4,  V4L2_PIX_FMT_YUV420, 1920, 1080),
 };
 
 static bool coda_format_is_yuv(u32 fourcc)
@@ -399,7 +416,7 @@ static int vidioc_querycap(struct file *file, void *priv,
 }
 
 static int enum_fmt(void *priv, struct v4l2_fmtdesc *f,
-			enum v4l2_buf_type type)
+			enum v4l2_buf_type type, int src_fourcc)
 {
 	struct coda_ctx *ctx = fh_to_ctx(priv);
 	struct coda_codec *codecs = ctx->dev->devtype->codecs;
@@ -411,7 +428,8 @@ static int enum_fmt(void *priv, struct v4l2_fmtdesc *f,
 
 	for (i = 0; i < num_formats; i++) {
 		/* Both uncompressed formats are always supported */
-		if (coda_format_is_yuv(formats[i].fourcc)) {
+		if (coda_format_is_yuv(formats[i].fourcc) &&
+		    !coda_format_is_yuv(src_fourcc)) {
 			if (num == f->index)
 				break;
 			++num;
@@ -419,8 +437,10 @@ static int enum_fmt(void *priv, struct v4l2_fmtdesc *f,
 		}
 		/* Compressed formats may be supported, check the codec list */
 		for (k = 0; k < num_codecs; k++) {
+			/* if src_fourcc is set, only consider matching codecs */
 			if (type == V4L2_BUF_TYPE_VIDEO_CAPTURE &&
-			    formats[i].fourcc == codecs[k].dst_fourcc)
+			    formats[i].fourcc == codecs[k].dst_fourcc &&
+			    (!src_fourcc || src_fourcc == codecs[k].src_fourcc))
 				break;
 			if (type == V4L2_BUF_TYPE_VIDEO_OUTPUT &&
 			    formats[i].fourcc == codecs[k].src_fourcc)
@@ -447,13 +467,26 @@ static int enum_fmt(void *priv, struct v4l2_fmtdesc *f,
 static int vidioc_enum_fmt_vid_cap(struct file *file, void *priv,
 				   struct v4l2_fmtdesc *f)
 {
-	return enum_fmt(priv, f, V4L2_BUF_TYPE_VIDEO_CAPTURE);
+	struct coda_ctx *ctx = fh_to_ctx(priv);
+	struct vb2_queue *src_vq;
+	struct coda_q_data *q_data_src;
+
+	/* If the source format is already fixed, only list matching formats */
+	src_vq = v4l2_m2m_get_vq(ctx->m2m_ctx, V4L2_BUF_TYPE_VIDEO_OUTPUT);
+	if (vb2_is_streaming(src_vq)) {
+		q_data_src = get_q_data(ctx, V4L2_BUF_TYPE_VIDEO_OUTPUT);
+
+		return enum_fmt(priv, f, V4L2_BUF_TYPE_VIDEO_CAPTURE,
+				q_data_src->fourcc);
+	}
+
+	return enum_fmt(priv, f, V4L2_BUF_TYPE_VIDEO_CAPTURE, 0);
 }
 
 static int vidioc_enum_fmt_vid_out(struct file *file, void *priv,
 				   struct v4l2_fmtdesc *f)
 {
-	return enum_fmt(priv, f, V4L2_BUF_TYPE_VIDEO_OUTPUT);
+	return enum_fmt(priv, f, V4L2_BUF_TYPE_VIDEO_OUTPUT, 0);
 }
 
 static int vidioc_g_fmt(struct file *file, void *priv, struct v4l2_format *f)
@@ -526,15 +559,45 @@ static int vidioc_try_fmt_vid_cap(struct file *file, void *priv,
 				  struct v4l2_format *f)
 {
 	struct coda_ctx *ctx = fh_to_ctx(priv);
-	struct coda_codec *codec = NULL;
+	struct coda_codec *codec;
+	struct vb2_queue *src_vq;
+	int ret;
+
+	/*
+	 * If the source format is already fixed, try to find a codec that
+	 * converts to the given destination format
+	 */
+	src_vq = v4l2_m2m_get_vq(ctx->m2m_ctx, V4L2_BUF_TYPE_VIDEO_OUTPUT);
+	if (vb2_is_streaming(src_vq)) {
+		struct coda_q_data *q_data_src;
 
-	/* Determine codec by the encoded format */
-	codec = coda_find_codec(ctx->dev, V4L2_PIX_FMT_YUV420,
-				f->fmt.pix.pixelformat);
+		q_data_src = get_q_data(ctx, V4L2_BUF_TYPE_VIDEO_OUTPUT);
+		codec = coda_find_codec(ctx->dev, q_data_src->fourcc,
+					f->fmt.pix.pixelformat);
+		if (!codec)
+			return -EINVAL;
+	} else {
+		/* Otherwise determine codec by encoded format, if possible */
+		codec = coda_find_codec(ctx->dev, V4L2_PIX_FMT_YUV420,
+					f->fmt.pix.pixelformat);
+	}
 
 	f->fmt.pix.colorspace = ctx->colorspace;
 
-	return vidioc_try_fmt(codec, f);
+	ret = vidioc_try_fmt(codec, f);
+	if (ret < 0)
+		return ret;
+
+	/* The h.264 decoder only returns complete 16x16 macroblocks */
+	if (codec && codec->src_fourcc == V4L2_PIX_FMT_H264) {
+		f->fmt.pix.width = round_up(f->fmt.pix.width, 16);
+		f->fmt.pix.height = round_up(f->fmt.pix.height, 16);
+		f->fmt.pix.bytesperline = f->fmt.pix.width;
+		f->fmt.pix.sizeimage = f->fmt.pix.bytesperline *
+				       f->fmt.pix.height * 3 / 2;
+	}
+
+	return 0;
 }
 
 static int vidioc_try_fmt_vid_out(struct file *file, void *priv,
@@ -644,11 +707,35 @@ static int vidioc_expbuf(struct file *file, void *priv,
 	return v4l2_m2m_expbuf(file, ctx->m2m_ctx, eb);
 }
 
+static bool coda_buf_is_end_of_stream(struct coda_ctx *ctx,
+				      struct v4l2_buffer *buf)
+{
+	struct vb2_queue *src_vq;
+
+	src_vq = v4l2_m2m_get_vq(ctx->m2m_ctx, V4L2_BUF_TYPE_VIDEO_OUTPUT);
+
+	return ((ctx->bit_stream_param & CODA_BIT_STREAM_END_FLAG) &&
+		(buf->sequence == (ctx->qsequence - 1)));
+}
+
 static int vidioc_dqbuf(struct file *file, void *priv, struct v4l2_buffer *buf)
 {
 	struct coda_ctx *ctx = fh_to_ctx(priv);
+	int ret;
+
+	ret = v4l2_m2m_dqbuf(file, ctx->m2m_ctx, buf);
 
-	return v4l2_m2m_dqbuf(file, ctx->m2m_ctx, buf);
+	/* If this is the last capture buffer, emit an end-of-stream event */
+	if (buf->type == V4L2_BUF_TYPE_VIDEO_CAPTURE &&
+	    coda_buf_is_end_of_stream(ctx, buf)) {
+		const struct v4l2_event eos_event = {
+			.type = V4L2_EVENT_EOS
+		};
+
+		v4l2_event_queue_fh(&ctx->fh, &eos_event);
+	}
+
+	return ret;
 }
 
 static int vidioc_streamon(struct file *file, void *priv,
@@ -663,8 +750,53 @@ static int vidioc_streamoff(struct file *file, void *priv,
 			    enum v4l2_buf_type type)
 {
 	struct coda_ctx *ctx = fh_to_ctx(priv);
+	int ret;
+
+	/*
+	 * This indirectly calls __vb2_queue_cancel, which dequeues all buffers.
+	 * We therefore have to lock it against running hardware in this context,
+	 * which still needs the buffers.
+	 */
+	mutex_lock(&ctx->buffer_mutex);
+	ret = v4l2_m2m_streamoff(file, ctx->m2m_ctx, type);
+	mutex_unlock(&ctx->buffer_mutex);
 
-	return v4l2_m2m_streamoff(file, ctx->m2m_ctx, type);
+	return ret;
+}
+
+static int vidioc_decoder_cmd(struct file *file, void *fh,
+			      struct v4l2_decoder_cmd *dc)
+{
+	struct coda_ctx *ctx = fh_to_ctx(fh);
+
+	if (dc->cmd != V4L2_DEC_CMD_STOP)
+		return -EINVAL;
+
+	if ((dc->flags & V4L2_DEC_CMD_STOP_TO_BLACK) ||
+	    (dc->flags & V4L2_DEC_CMD_STOP_IMMEDIATELY))
+		return -EINVAL;
+
+	if (dc->stop.pts != 0)
+		return -EINVAL;
+
+	if (ctx->inst_type != CODA_INST_DECODER)
+		return -EINVAL;
+
+	/* Set the strem-end flag on this context */
+	ctx->bit_stream_param |= CODA_BIT_STREAM_END_FLAG;
+
+	return 0;
+}
+
+static int vidioc_subscribe_event(struct v4l2_fh *fh,
+				  const struct v4l2_event_subscription *sub)
+{
+	switch (sub->type) {
+	case V4L2_EVENT_EOS:
+		return v4l2_event_subscribe(fh, sub, 0, NULL);
+	default:
+		return v4l2_ctrl_subscribe_event(fh, sub);
+	}
 }
 
 static const struct v4l2_ioctl_ops coda_ioctl_ops = {
@@ -689,8 +821,22 @@ static const struct v4l2_ioctl_ops coda_ioctl_ops = {
 
 	.vidioc_streamon	= vidioc_streamon,
 	.vidioc_streamoff	= vidioc_streamoff,
+
+	.vidioc_decoder_cmd	= vidioc_decoder_cmd,
+
+	.vidioc_subscribe_event = vidioc_subscribe_event,
+	.vidioc_unsubscribe_event = v4l2_event_unsubscribe,
 };
 
+static int coda_start_decoding(struct coda_ctx *ctx);
+
+static void coda_skip_run(struct work_struct *work)
+{
+	struct coda_ctx *ctx = container_of(work, struct coda_ctx, skip_run);
+
+	v4l2_m2m_job_finish(ctx->dev->m2m_dev, ctx->m2m_ctx);
+}
+
 static inline int coda_get_bitstream_payload(struct coda_ctx *ctx)
 {
 	return kfifo_len(&ctx->bitstream_fifo);
@@ -771,6 +917,8 @@ static bool coda_bitstream_try_queue(struct coda_ctx *ctx,
 	if (ctx == v4l2_m2m_get_curr_priv(ctx->dev->m2m_dev))
 		coda_kfifo_sync_to_device_write(ctx);
 
+	ctx->prescan_failed = false;
+
 	return true;
 }
 
@@ -793,6 +941,84 @@ static void coda_fill_bitstream(struct coda_ctx *ctx)
 /*
  * Mem-to-mem operations.
  */
+static int coda_prepare_decode(struct coda_ctx *ctx)
+{
+	struct vb2_buffer *dst_buf;
+	struct coda_dev *dev = ctx->dev;
+	struct coda_q_data *q_data_dst;
+	u32 stridey, height;
+	u32 picture_y, picture_cb, picture_cr;
+
+	dst_buf = v4l2_m2m_next_dst_buf(ctx->m2m_ctx);
+	q_data_dst = get_q_data(ctx, V4L2_BUF_TYPE_VIDEO_CAPTURE);
+
+	if (ctx->params.rot_mode & CODA_ROT_90) {
+		stridey = q_data_dst->height;
+		height = q_data_dst->width;
+	} else {
+		stridey = q_data_dst->width;
+		height = q_data_dst->height;
+	}
+
+	/* Try to copy source buffer contents into the bitstream ringbuffer */
+	mutex_lock(&ctx->bitstream_mutex);
+	coda_fill_bitstream(ctx);
+	mutex_unlock(&ctx->bitstream_mutex);
+
+	if (coda_get_bitstream_payload(ctx) < 512 &&
+	    (!(ctx->bit_stream_param & CODA_BIT_STREAM_END_FLAG))) {
+		v4l2_dbg(1, coda_debug, &dev->v4l2_dev,
+			 "bitstream payload: %d, skipping\n",
+			 coda_get_bitstream_payload(ctx));
+		schedule_work(&ctx->skip_run);
+		return -EAGAIN;
+	}
+
+	/* Run coda_start_decoding (again) if not yet initialized */
+	if (!ctx->initialized) {
+		int ret = coda_start_decoding(ctx);
+		if (ret < 0) {
+			v4l2_err(&dev->v4l2_dev, "failed to start decoding\n");
+			schedule_work(&ctx->skip_run);
+			return -EAGAIN;
+		} else {
+			ctx->initialized = 1;
+		}
+	}
+
+	/* Set rotator output */
+	picture_y = vb2_dma_contig_plane_dma_addr(dst_buf, 0);
+	if (q_data_dst->fourcc == V4L2_PIX_FMT_YVU420) {
+		/* Switch Cr and Cb for YVU420 format */
+		picture_cr = picture_y + stridey * height;
+		picture_cb = picture_cr + stridey / 2 * height / 2;
+	} else {
+		picture_cb = picture_y + stridey * height;
+		picture_cr = picture_cb + stridey / 2 * height / 2;
+	}
+	coda_write(dev, picture_y, CODA_CMD_DEC_PIC_ROT_ADDR_Y);
+	coda_write(dev, picture_cb, CODA_CMD_DEC_PIC_ROT_ADDR_CB);
+	coda_write(dev, picture_cr, CODA_CMD_DEC_PIC_ROT_ADDR_CR);
+	coda_write(dev, stridey, CODA_CMD_DEC_PIC_ROT_STRIDE);
+	coda_write(dev, CODA_ROT_MIR_ENABLE | ctx->params.rot_mode,
+			CODA_CMD_DEC_PIC_ROT_MODE);
+
+	switch (dev->devtype->product) {
+	case CODA_DX6:
+		/* TBD */
+	case CODA_7541:
+		coda_write(dev, CODA_PRE_SCAN_EN, CODA_CMD_DEC_PIC_OPTION);
+		break;
+	}
+
+	coda_write(dev, 0, CODA_CMD_DEC_PIC_SKIP_NUM);
+
+	coda_write(dev, 0, CODA_CMD_DEC_PIC_BB_START);
+	coda_write(dev, 0, CODA_CMD_DEC_PIC_START_BYTE);
+
+	return 0;
+}
+
 static void coda_prepare_encode(struct coda_ctx *ctx)
 {
 	struct coda_q_data *q_data_src, *q_data_dst;
@@ -810,9 +1036,9 @@ static void coda_prepare_encode(struct coda_ctx *ctx)
 	q_data_dst = get_q_data(ctx, V4L2_BUF_TYPE_VIDEO_CAPTURE);
 	dst_fourcc = q_data_dst->fourcc;
 
-	src_buf->v4l2_buf.sequence = ctx->isequence;
-	dst_buf->v4l2_buf.sequence = ctx->isequence;
-	ctx->isequence++;
+	src_buf->v4l2_buf.sequence = ctx->osequence;
+	dst_buf->v4l2_buf.sequence = ctx->osequence;
+	ctx->osequence++;
 
 	/*
 	 * Workaround coda firmware BUG that only marks the first
@@ -920,15 +1146,36 @@ static void coda_device_run(void *m2m_priv)
 {
 	struct coda_ctx *ctx = m2m_priv;
 	struct coda_dev *dev = ctx->dev;
+	int ret;
 
-	mutex_lock(&dev->coda_mutex);
+	mutex_lock(&ctx->buffer_mutex);
+
+	/*
+	 * If streamoff dequeued all buffers before we could get the lock,
+	 * just bail out immediately.
+	 */
+	if ((!v4l2_m2m_num_src_bufs_ready(ctx->m2m_ctx) &&
+	    ctx->inst_type != CODA_INST_DECODER) ||
+		!v4l2_m2m_num_dst_bufs_ready(ctx->m2m_ctx)) {
+		v4l2_dbg(1, coda_debug, &dev->v4l2_dev,
+			"%d: device_run without buffers\n", ctx->idx);
+		mutex_unlock(&ctx->buffer_mutex);
+		schedule_work(&ctx->skip_run);
+		return;
+	}
 
-	coda_prepare_encode(ctx);
+	mutex_lock(&dev->coda_mutex);
 
-	if (dev->devtype->product == CODA_7541) {
-		coda_write(dev, CODA7_USE_BIT_ENABLE | CODA7_USE_HOST_BIT_ENABLE |
-				CODA7_USE_ME_ENABLE | CODA7_USE_HOST_ME_ENABLE,
-				CODA7_REG_BIT_AXI_SRAM_USE);
+	if (ctx->inst_type == CODA_INST_DECODER) {
+		ret = coda_prepare_decode(ctx);
+		if (ret < 0) {
+			mutex_unlock(&dev->coda_mutex);
+			mutex_unlock(&ctx->buffer_mutex);
+			/* job_finish scheduled by prepare_decode */
+			return;
+		}
+	} else {
+		coda_prepare_encode(ctx);
 	}
 
 	if (dev->devtype->product != CODA_DX6)
@@ -938,6 +1185,8 @@ static void coda_device_run(void *m2m_priv)
 	/* 1 second timeout in case CODA locks up */
 	schedule_delayed_work(&dev->timeout, HZ);
 
+	if (ctx->inst_type == CODA_INST_DECODER)
+		coda_kfifo_sync_to_device_full(ctx);
 	coda_command_async(ctx, CODA_COMMAND_PIC_RUN);
 }
 
@@ -963,6 +1212,15 @@ static int coda_job_ready(void *m2m_priv)
 		return 0;
 	}
 
+	if (ctx->prescan_failed ||
+	    ((coda_get_bitstream_payload(ctx) < 512) &&
+	     !(ctx->bit_stream_param & CODA_BIT_STREAM_END_FLAG))) {
+		v4l2_dbg(1, coda_debug, &ctx->dev->v4l2_dev,
+			 "%d: not ready: not enough bitstream data.\n",
+			 ctx->idx);
+		return 0;
+	}
+
 	if (ctx->aborting) {
 		v4l2_dbg(1, coda_debug, &ctx->dev->v4l2_dev,
 			 "not ready: aborting\n");
@@ -1078,7 +1336,29 @@ static int coda_buf_prepare(struct vb2_buffer *vb)
 static void coda_buf_queue(struct vb2_buffer *vb)
 {
 	struct coda_ctx *ctx = vb2_get_drv_priv(vb->vb2_queue);
-	v4l2_m2m_buf_queue(ctx->m2m_ctx, vb);
+	struct coda_q_data *q_data;
+
+	q_data = get_q_data(ctx, vb->vb2_queue->type);
+
+	/*
+	 * In the decoder case, immediately try to copy the buffer into the
+	 * bitstream ringbuffer and mark it as ready to be dequeued.
+	 */
+	if (q_data->fourcc == V4L2_PIX_FMT_H264 &&
+	    vb->vb2_queue->type == V4L2_BUF_TYPE_VIDEO_OUTPUT) {
+		/*
+		 * For backwards compatiblity, queuing an empty buffer marks
+		 * the stream end
+		 */
+		if (vb2_get_plane_payload(vb, 0) == 0)
+			ctx->bit_stream_param |= CODA_BIT_STREAM_END_FLAG;
+		mutex_lock(&ctx->bitstream_mutex);
+		v4l2_m2m_buf_queue(ctx->m2m_ctx, vb);
+		coda_fill_bitstream(ctx);
+		mutex_unlock(&ctx->bitstream_mutex);
+	} else {
+		v4l2_m2m_buf_queue(ctx->m2m_ctx, vb);
+	}
 }
 
 static void coda_wait_prepare(struct vb2_queue *q)
@@ -1366,6 +1646,8 @@ static void coda_free_context_buffers(struct coda_ctx *ctx)
 {
 	struct coda_dev *dev = ctx->dev;
 
+	coda_free_aux_buf(dev, &ctx->slicebuf);
+	coda_free_aux_buf(dev, &ctx->psbuf);
 	if (dev->devtype->product != CODA_DX6)
 		coda_free_aux_buf(dev, &ctx->workbuf);
 }
@@ -1385,12 +1667,40 @@ static int coda_alloc_context_buffers(struct coda_ctx *ctx,
 		return 0;
 	}
 
+	if (ctx->psbuf.vaddr) {
+		v4l2_err(&dev->v4l2_dev, "psmembuf still allocated\n");
+		return -EBUSY;
+	}
+	if (ctx->slicebuf.vaddr) {
+		v4l2_err(&dev->v4l2_dev, "slicebuf still allocated\n");
+		return -EBUSY;
+	}
 	if (ctx->workbuf.vaddr) {
 		v4l2_err(&dev->v4l2_dev, "context buffer still allocated\n");
 		ret = -EBUSY;
 		return -ENOMEM;
 	}
 
+	if (q_data->fourcc == V4L2_PIX_FMT_H264) {
+		/* worst case slice size */
+		size = (DIV_ROUND_UP(q_data->width, 16) *
+			DIV_ROUND_UP(q_data->height, 16)) * 3200 / 8 + 512;
+		ret = coda_alloc_context_buf(ctx, &ctx->slicebuf, size);
+		if (ret < 0) {
+			v4l2_err(&dev->v4l2_dev, "failed to allocate %d byte slice buffer",
+				 ctx->slicebuf.size);
+			return ret;
+		}
+	}
+
+	if (dev->devtype->product == CODA_7541) {
+		ret = coda_alloc_context_buf(ctx, &ctx->psbuf, CODA7_PS_BUF_SIZE);
+		if (ret < 0) {
+			v4l2_err(&dev->v4l2_dev, "failed to allocate psmem buffer");
+			goto err;
+		}
+	}
+
 	ret = coda_alloc_context_buf(ctx, &ctx->workbuf, size);
 	if (ret < 0) {
 		v4l2_err(&dev->v4l2_dev, "failed to allocate %d byte context buffer",
@@ -1405,6 +1715,148 @@ err:
 	return ret;
 }
 
+static int coda_start_decoding(struct coda_ctx *ctx)
+{
+	struct coda_q_data *q_data_src, *q_data_dst;
+	u32 bitstream_buf, bitstream_size;
+	struct coda_dev *dev = ctx->dev;
+	int width, height;
+	u32 src_fourcc;
+	u32 val;
+	int ret;
+
+	/* Start decoding */
+	q_data_src = get_q_data(ctx, V4L2_BUF_TYPE_VIDEO_OUTPUT);
+	q_data_dst = get_q_data(ctx, V4L2_BUF_TYPE_VIDEO_CAPTURE);
+	bitstream_buf = ctx->bitstream.paddr;
+	bitstream_size = ctx->bitstream.size;
+	src_fourcc = q_data_src->fourcc;
+
+	coda_write(dev, ctx->parabuf.paddr, CODA_REG_BIT_PARA_BUF_ADDR);
+
+	/* Update coda bitstream read and write pointers from kfifo */
+	coda_kfifo_sync_to_device_full(ctx);
+
+	ctx->display_idx = -1;
+	ctx->frm_dis_flg = 0;
+	coda_write(dev, 0, CODA_REG_BIT_FRM_DIS_FLG(ctx->reg_idx));
+
+	coda_write(dev, CODA_BIT_DEC_SEQ_INIT_ESCAPE,
+			CODA_REG_BIT_BIT_STREAM_PARAM);
+
+	coda_write(dev, bitstream_buf, CODA_CMD_DEC_SEQ_BB_START);
+	coda_write(dev, bitstream_size / 1024, CODA_CMD_DEC_SEQ_BB_SIZE);
+	val = 0;
+	if (dev->devtype->product == CODA_7541)
+		val |= CODA_REORDER_ENABLE;
+	coda_write(dev, val, CODA_CMD_DEC_SEQ_OPTION);
+
+	ctx->params.codec_mode = ctx->codec->mode;
+	ctx->params.codec_mode_aux = 0;
+	if (src_fourcc == V4L2_PIX_FMT_H264) {
+		if (dev->devtype->product == CODA_7541) {
+			coda_write(dev, ctx->psbuf.paddr,
+					CODA_CMD_DEC_SEQ_PS_BB_START);
+			coda_write(dev, (CODA7_PS_BUF_SIZE / 1024),
+					CODA_CMD_DEC_SEQ_PS_BB_SIZE);
+		}
+	}
+
+	if (coda_command_sync(ctx, CODA_COMMAND_SEQ_INIT)) {
+		v4l2_err(&dev->v4l2_dev, "CODA_COMMAND_SEQ_INIT timeout\n");
+		coda_write(dev, 0, CODA_REG_BIT_BIT_STREAM_PARAM);
+		return -ETIMEDOUT;
+	}
+
+	/* Update kfifo out pointer from coda bitstream read pointer */
+	coda_kfifo_sync_from_device(ctx);
+
+	coda_write(dev, 0, CODA_REG_BIT_BIT_STREAM_PARAM);
+
+	if (coda_read(dev, CODA_RET_DEC_SEQ_SUCCESS) == 0) {
+		v4l2_err(&dev->v4l2_dev,
+			"CODA_COMMAND_SEQ_INIT failed, error code = %d\n",
+			coda_read(dev, CODA_RET_DEC_SEQ_ERR_REASON));
+		return -EAGAIN;
+	}
+
+	val = coda_read(dev, CODA_RET_DEC_SEQ_SRC_SIZE);
+	if (dev->devtype->product == CODA_DX6) {
+		width = (val >> CODADX6_PICWIDTH_OFFSET) & CODADX6_PICWIDTH_MASK;
+		height = val & CODADX6_PICHEIGHT_MASK;
+	} else {
+		width = (val >> CODA7_PICWIDTH_OFFSET) & CODA7_PICWIDTH_MASK;
+		height = val & CODA7_PICHEIGHT_MASK;
+	}
+
+	if (width > q_data_dst->width || height > q_data_dst->height) {
+		v4l2_err(&dev->v4l2_dev, "stream is %dx%d, not %dx%d\n",
+			 width, height, q_data_dst->width, q_data_dst->height);
+		return -EINVAL;
+	}
+
+	width = round_up(width, 16);
+	height = round_up(height, 16);
+
+	v4l2_dbg(1, coda_debug, &dev->v4l2_dev, "%s instance %d now: %dx%d\n",
+		 __func__, ctx->idx, width, height);
+
+	ctx->num_internal_frames = coda_read(dev, CODA_RET_DEC_SEQ_FRAME_NEED) + 1;
+	if (ctx->num_internal_frames > CODA_MAX_FRAMEBUFFERS) {
+		v4l2_err(&dev->v4l2_dev,
+			 "not enough framebuffers to decode (%d < %d)\n",
+			 CODA_MAX_FRAMEBUFFERS, ctx->num_internal_frames);
+		return -EINVAL;
+	}
+
+	ret = coda_alloc_framebuffers(ctx, q_data_dst, src_fourcc);
+	if (ret < 0)
+		return ret;
+
+	/* Tell the decoder how many frame buffers we allocated. */
+	coda_write(dev, ctx->num_internal_frames, CODA_CMD_SET_FRAME_BUF_NUM);
+	coda_write(dev, width, CODA_CMD_SET_FRAME_BUF_STRIDE);
+
+	if (dev->devtype->product != CODA_DX6) {
+		/* Set secondary AXI IRAM */
+		coda_setup_iram(ctx);
+
+		coda_write(dev, ctx->iram_info.buf_bit_use,
+				CODA7_CMD_SET_FRAME_AXI_BIT_ADDR);
+		coda_write(dev, ctx->iram_info.buf_ip_ac_dc_use,
+				CODA7_CMD_SET_FRAME_AXI_IPACDC_ADDR);
+		coda_write(dev, ctx->iram_info.buf_dbk_y_use,
+				CODA7_CMD_SET_FRAME_AXI_DBKY_ADDR);
+		coda_write(dev, ctx->iram_info.buf_dbk_c_use,
+				CODA7_CMD_SET_FRAME_AXI_DBKC_ADDR);
+		coda_write(dev, ctx->iram_info.buf_ovl_use,
+				CODA7_CMD_SET_FRAME_AXI_OVL_ADDR);
+	}
+
+	if (src_fourcc == V4L2_PIX_FMT_H264) {
+		coda_write(dev, ctx->slicebuf.paddr,
+				CODA_CMD_SET_FRAME_SLICE_BB_START);
+		coda_write(dev, ctx->slicebuf.size / 1024,
+				CODA_CMD_SET_FRAME_SLICE_BB_SIZE);
+	}
+
+	if (dev->devtype->product == CODA_7541) {
+		int max_mb_x = 1920 / 16;
+		int max_mb_y = 1088 / 16;
+		int max_mb_num = max_mb_x * max_mb_y;
+		coda_write(dev, max_mb_num << 16 | max_mb_x << 8 | max_mb_y,
+				CODA7_CMD_SET_FRAME_MAX_DEC_SIZE);
+	}
+
+	if (coda_command_sync(ctx, CODA_COMMAND_SET_FRAME_BUF)) {
+		v4l2_err(&ctx->dev->v4l2_dev,
+			 "CODA_COMMAND_SET_FRAME_BUF timeout\n");
+		return -ETIMEDOUT;
+	}
+
+	return 0;
+}
+
 static int coda_encode_header(struct coda_ctx *ctx, struct vb2_buffer *buf,
 			      int header_code, u8 *header, int *size)
 {
@@ -1439,26 +1891,36 @@ static int coda_start_streaming(struct vb2_queue *q, unsigned int count)
 	u32 value;
 	int ret = 0;
 
-	if (count < 1)
-		return -EINVAL;
+	q_data_src = get_q_data(ctx, V4L2_BUF_TYPE_VIDEO_OUTPUT);
+	if (q->type == V4L2_BUF_TYPE_VIDEO_OUTPUT) {
+		if (q_data_src->fourcc == V4L2_PIX_FMT_H264) {
+			if (coda_get_bitstream_payload(ctx) < 512)
+				return -EINVAL;
+		} else {
+			if (count < 1)
+				return -EINVAL;
+		}
 
-	if (q->type == V4L2_BUF_TYPE_VIDEO_OUTPUT)
 		ctx->streamon_out = 1;
-	else
-		ctx->streamon_cap = 1;
 
-	q_data_src = get_q_data(ctx, V4L2_BUF_TYPE_VIDEO_OUTPUT);
-	if (ctx->streamon_out) {
 		if (coda_format_is_yuv(q_data_src->fourcc))
 			ctx->inst_type = CODA_INST_ENCODER;
 		else
 			ctx->inst_type = CODA_INST_DECODER;
+	} else {
+		if (count < 1)
+			return -EINVAL;
+
+		ctx->streamon_cap = 1;
 	}
 
 	/* Don't start the coda unless both queues are on */
 	if (!(ctx->streamon_out & ctx->streamon_cap))
 		return 0;
 
+	/* Allow device_run with no buffers queued and after streamoff */
+	v4l2_m2m_set_src_buffered(ctx->m2m_ctx, true);
+
 	ctx->gopcounter = ctx->params.gop_size - 1;
 	buf = v4l2_m2m_next_dst_buf(ctx->m2m_ctx);
 	bitstream_buf = vb2_dma_contig_plane_dma_addr(buf, 0);
@@ -1478,6 +1940,20 @@ static int coda_start_streaming(struct vb2_queue *q, unsigned int count)
 	if (ret < 0)
 		return ret;
 
+	if (ctx->inst_type == CODA_INST_DECODER) {
+		mutex_lock(&dev->coda_mutex);
+		ret = coda_start_decoding(ctx);
+		mutex_unlock(&dev->coda_mutex);
+		if (ret == -EAGAIN) {
+			return 0;
+		} else if (ret < 0) {
+			return ret;
+		} else {
+			ctx->initialized = 1;
+			return 0;
+		}
+	}
+
 	if (!coda_is_initialized(dev)) {
 		v4l2_err(v4l2_dev, "coda is not initialized.\n");
 		return -EFAULT;
@@ -1619,6 +2095,9 @@ static int coda_start_streaming(struct vb2_queue *q, unsigned int count)
 
 	coda_write(dev, ctx->num_internal_frames, CODA_CMD_SET_FRAME_BUF_NUM);
 	coda_write(dev, round_up(q_data_src->width, 8), CODA_CMD_SET_FRAME_BUF_STRIDE);
+	if (dev->devtype->product == CODA_7541)
+		coda_write(dev, round_up(q_data_src->width, 8),
+				CODA7_CMD_SET_FRAME_SOURCE_BUF_STRIDE);
 	if (dev->devtype->product != CODA_DX6) {
 		coda_write(dev, ctx->iram_info.buf_bit_use,
 				CODA7_CMD_SET_FRAME_AXI_BIT_ADDR);
@@ -1710,32 +2189,26 @@ static int coda_stop_streaming(struct vb2_queue *q)
 	struct coda_dev *dev = ctx->dev;
 
 	if (q->type == V4L2_BUF_TYPE_VIDEO_OUTPUT) {
-		v4l2_dbg(1, coda_debug, &ctx->dev->v4l2_dev,
+		v4l2_dbg(1, coda_debug, &dev->v4l2_dev,
 			 "%s: output\n", __func__);
 		ctx->streamon_out = 0;
+
+		ctx->bit_stream_param |= CODA_BIT_STREAM_END_FLAG;
+
+		ctx->isequence = 0;
 	} else {
-		v4l2_dbg(1, coda_debug, &ctx->dev->v4l2_dev,
+		v4l2_dbg(1, coda_debug, &dev->v4l2_dev,
 			 "%s: capture\n", __func__);
 		ctx->streamon_cap = 0;
-	}
-
-	/* Don't stop the coda unless both queues are off */
-	if (ctx->streamon_out || ctx->streamon_cap)
-		return 0;
-
-	cancel_delayed_work(&dev->timeout);
 
-	mutex_lock(&dev->coda_mutex);
-	v4l2_dbg(1, coda_debug, &dev->v4l2_dev,
-		 "%s: sent command 'SEQ_END' to coda\n", __func__);
-	if (coda_command_sync(ctx, CODA_COMMAND_SEQ_END)) {
-		v4l2_err(&dev->v4l2_dev,
-			 "CODA_COMMAND_SEQ_END failed\n");
-		return -ETIMEDOUT;
+		ctx->osequence = 0;
 	}
-	mutex_unlock(&dev->coda_mutex);
 
-	coda_free_framebuffers(ctx);
+	if (!ctx->streamon_out && !ctx->streamon_cap) {
+		kfifo_init(&ctx->bitstream_fifo,
+			ctx->bitstream.vaddr, ctx->bitstream.size);
+		ctx->runcounter = 0;
+	}
 
 	return 0;
 }
@@ -1895,7 +2368,7 @@ static int coda_open(struct file *file)
 {
 	struct coda_dev *dev = video_drvdata(file);
 	struct coda_ctx *ctx = NULL;
-	int ret = 0;
+	int ret;
 	int idx;
 
 	idx = coda_next_free_instance(dev);
@@ -1907,6 +2380,7 @@ static int coda_open(struct file *file)
 	if (!ctx)
 		return -ENOMEM;
 
+	INIT_WORK(&ctx->skip_run, coda_skip_run);
 	v4l2_fh_init(&ctx->fh, video_devdata(file));
 	file->private_data = &ctx->fh;
 	v4l2_fh_add(&ctx->fh);
@@ -1954,6 +2428,7 @@ static int coda_open(struct file *file)
 	kfifo_init(&ctx->bitstream_fifo,
 		ctx->bitstream.vaddr, ctx->bitstream.size);
 	mutex_init(&ctx->bitstream_mutex);
+	mutex_init(&ctx->buffer_mutex);
 
 	coda_lock(ctx);
 	list_add(&ctx->list, &dev->instances);
@@ -1982,6 +2457,22 @@ static int coda_release(struct file *file)
 	v4l2_dbg(1, coda_debug, &dev->v4l2_dev, "Releasing instance %p\n",
 		 ctx);
 
+	/* If this instance is running, call .job_abort and wait for it to end */
+	v4l2_m2m_ctx_release(ctx->m2m_ctx);
+
+	/* In case the instance was not running, we still need to call SEQ_END */
+	mutex_lock(&dev->coda_mutex);
+	v4l2_dbg(1, coda_debug, &dev->v4l2_dev,
+		 "%s: sent command 'SEQ_END' to coda\n", __func__);
+	if (coda_command_sync(ctx, CODA_COMMAND_SEQ_END)) {
+		v4l2_err(&dev->v4l2_dev,
+			 "CODA_COMMAND_SEQ_END failed\n");
+		return -ETIMEDOUT;
+	}
+	mutex_unlock(&dev->coda_mutex);
+
+	coda_free_framebuffers(ctx);
+
 	coda_lock(ctx);
 	list_del(&ctx->list);
 	coda_unlock(ctx);
@@ -2032,7 +2523,159 @@ static const struct v4l2_file_operations coda_fops = {
 	.mmap		= coda_mmap,
 };
 
-static void coda_encode_finish(struct coda_ctx *ctx)
+static void coda_finish_decode(struct coda_ctx *ctx)
+{
+	struct coda_dev *dev = ctx->dev;
+	struct coda_q_data *q_data_src;
+	struct coda_q_data *q_data_dst;
+	struct vb2_buffer *dst_buf;
+	int width, height;
+	int decoded_idx;
+	int display_idx;
+	u32 src_fourcc;
+	int success;
+	u32 val;
+
+	dst_buf = v4l2_m2m_next_dst_buf(ctx->m2m_ctx);
+
+	/* Update kfifo out pointer from coda bitstream read pointer */
+	coda_kfifo_sync_from_device(ctx);
+
+	/*
+	 * in stream-end mode, the read pointer can overshoot the write pointer
+	 * by up to 512 bytes
+	 */
+	if (ctx->bit_stream_param & CODA_BIT_STREAM_END_FLAG) {
+		if (coda_get_bitstream_payload(ctx) >= 0x100000 - 512)
+			kfifo_init(&ctx->bitstream_fifo,
+				ctx->bitstream.vaddr, ctx->bitstream.size);
+	}
+
+	q_data_src = get_q_data(ctx, V4L2_BUF_TYPE_VIDEO_OUTPUT);
+	src_fourcc = q_data_src->fourcc;
+
+	val = coda_read(dev, CODA_RET_DEC_PIC_SUCCESS);
+	if (val != 1)
+		pr_err("DEC_PIC_SUCCESS = %d\n", val);
+
+	success = val & 0x1;
+	if (!success)
+		v4l2_err(&dev->v4l2_dev, "decode failed\n");
+
+	if (src_fourcc == V4L2_PIX_FMT_H264) {
+		if (val & (1 << 3))
+			v4l2_err(&dev->v4l2_dev,
+				 "insufficient PS buffer space (%d bytes)\n",
+				 ctx->psbuf.size);
+		if (val & (1 << 2))
+			v4l2_err(&dev->v4l2_dev,
+				 "insufficient slice buffer space (%d bytes)\n",
+				 ctx->slicebuf.size);
+	}
+
+	val = coda_read(dev, CODA_RET_DEC_PIC_SIZE);
+	width = (val >> 16) & 0xffff;
+	height = val & 0xffff;
+
+	q_data_dst = get_q_data(ctx, V4L2_BUF_TYPE_VIDEO_CAPTURE);
+
+	val = coda_read(dev, CODA_RET_DEC_PIC_TYPE);
+	if ((val & 0x7) == 0) {
+		dst_buf->v4l2_buf.flags |= V4L2_BUF_FLAG_KEYFRAME;
+		dst_buf->v4l2_buf.flags &= ~V4L2_BUF_FLAG_PFRAME;
+	} else {
+		dst_buf->v4l2_buf.flags |= V4L2_BUF_FLAG_PFRAME;
+		dst_buf->v4l2_buf.flags &= ~V4L2_BUF_FLAG_KEYFRAME;
+	}
+
+	val = coda_read(dev, CODA_RET_DEC_PIC_ERR_MB);
+	if (val > 0)
+		v4l2_err(&dev->v4l2_dev,
+			 "errors in %d macroblocks\n", val);
+
+	if (dev->devtype->product == CODA_7541) {
+		val = coda_read(dev, CODA_RET_DEC_PIC_OPTION);
+		if (val == 0) {
+			/* not enough bitstream data */
+			v4l2_dbg(1, coda_debug, &dev->v4l2_dev,
+				 "prescan failed: %d\n", val);
+			ctx->prescan_failed = true;
+			return;
+		}
+	}
+
+	ctx->frm_dis_flg = coda_read(dev, CODA_REG_BIT_FRM_DIS_FLG(ctx->reg_idx));
+
+	/*
+	 * The previous display frame was copied out by the rotator,
+	 * now it can be overwritten again
+	 */
+	if (ctx->display_idx >= 0 &&
+	    ctx->display_idx < ctx->num_internal_frames) {
+		ctx->frm_dis_flg &= ~(1 << ctx->display_idx);
+		coda_write(dev, ctx->frm_dis_flg,
+				CODA_REG_BIT_FRM_DIS_FLG(ctx->reg_idx));
+	}
+
+	/*
+	 * The index of the last decoded frame, not necessarily in
+	 * display order, and the index of the next display frame.
+	 * The latter could have been decoded in a previous run.
+	 */
+	decoded_idx = coda_read(dev, CODA_RET_DEC_PIC_CUR_IDX);
+	display_idx = coda_read(dev, CODA_RET_DEC_PIC_FRAME_IDX);
+
+	if (decoded_idx == -1) {
+		/* no frame was decoded, but we might have a display frame */
+		if (display_idx < 0 && ctx->display_idx < 0)
+			ctx->prescan_failed = true;
+	} else if (decoded_idx == -2) {
+		/* no frame was decoded, we still return the remaining buffers */
+	} else if (decoded_idx < 0 || decoded_idx >= ctx->num_internal_frames) {
+		v4l2_err(&dev->v4l2_dev,
+			 "decoded frame index out of range: %d\n", decoded_idx);
+	}
+
+	if (display_idx == -1) {
+		/*
+		 * no more frames to be decoded, but there could still
+		 * be rotator output to dequeue
+		 */
+		ctx->prescan_failed = true;
+	} else if (display_idx == -3) {
+		/* possibly prescan failure */
+	} else if (display_idx < 0 || display_idx >= ctx->num_internal_frames) {
+		v4l2_err(&dev->v4l2_dev,
+			 "presentation frame index out of range: %d\n",
+			 display_idx);
+	}
+
+	/* If a frame was copied out, return it */
+	if (ctx->display_idx >= 0 &&
+	    ctx->display_idx < ctx->num_internal_frames) {
+		dst_buf = v4l2_m2m_dst_buf_remove(ctx->m2m_ctx);
+		dst_buf->v4l2_buf.sequence = ctx->osequence++;
+
+		vb2_set_plane_payload(dst_buf, 0, width * height * 3 / 2);
+
+		v4l2_m2m_buf_done(dst_buf, success ? VB2_BUF_STATE_DONE :
+						     VB2_BUF_STATE_ERROR);
+
+		v4l2_dbg(1, coda_debug, &dev->v4l2_dev,
+			"job finished: decoding frame (%d) (%s)\n",
+			dst_buf->v4l2_buf.sequence,
+			(dst_buf->v4l2_buf.flags & V4L2_BUF_FLAG_KEYFRAME) ?
+			"KEYFRAME" : "PFRAME");
+	} else {
+		v4l2_dbg(1, coda_debug, &dev->v4l2_dev,
+			"job finished: no frame decoded\n");
+	}
+
+	/* The rotator will copy the current display frame next time */
+	ctx->display_idx = display_idx;
+}
+
+static void coda_finish_encode(struct coda_ctx *ctx)
 {
 	struct vb2_buffer *src_buf, *dst_buf;
 	struct coda_dev *dev = ctx->dev;
@@ -2109,8 +2752,7 @@ static irqreturn_t coda_irq_handler(int irq, void *data)
 	if (ctx->aborting) {
 		v4l2_dbg(1, coda_debug, &ctx->dev->v4l2_dev,
 			 "task has been aborted\n");
-		mutex_unlock(&dev->coda_mutex);
-		return IRQ_HANDLED;
+		goto out;
 	}
 
 	if (coda_isbusy(ctx->dev)) {
@@ -2119,9 +2761,29 @@ static irqreturn_t coda_irq_handler(int irq, void *data)
 		return IRQ_NONE;
 	}
 
-	coda_encode_finish(ctx);
+	if (ctx->inst_type == CODA_INST_DECODER)
+		coda_finish_decode(ctx);
+	else
+		coda_finish_encode(ctx);
+
+out:
+	if (ctx->aborting || (!ctx->streamon_cap && !ctx->streamon_out)) {
+		v4l2_dbg(1, coda_debug, &dev->v4l2_dev,
+			 "%s: sent command 'SEQ_END' to coda\n", __func__);
+		if (coda_command_sync(ctx, CODA_COMMAND_SEQ_END)) {
+			v4l2_err(&dev->v4l2_dev,
+				 "CODA_COMMAND_SEQ_END failed\n");
+		}
+
+		kfifo_init(&ctx->bitstream_fifo,
+			ctx->bitstream.vaddr, ctx->bitstream.size);
+
+		coda_free_framebuffers(ctx);
+		coda_free_context_buffers(ctx);
+	}
 
 	mutex_unlock(&dev->coda_mutex);
+	mutex_unlock(&ctx->buffer_mutex);
 
 	v4l2_m2m_job_finish(ctx->dev->m2m_dev, ctx->m2m_ctx);
 
@@ -2138,6 +2800,8 @@ static void coda_timeout(struct work_struct *work)
 
 	mutex_lock(&dev->dev_mutex);
 	list_for_each_entry(ctx, &dev->instances, list) {
+		if (mutex_is_locked(&ctx->buffer_mutex))
+			mutex_unlock(&ctx->buffer_mutex);
 		v4l2_m2m_streamoff(NULL, ctx->m2m_ctx, V4L2_BUF_TYPE_VIDEO_OUTPUT);
 		v4l2_m2m_streamoff(NULL, ctx->m2m_ctx, V4L2_BUF_TYPE_VIDEO_CAPTURE);
 	}
@@ -2218,6 +2882,7 @@ static int coda_hw_init(struct coda_dev *dev)
 	if (dev->devtype->product == CODA_7541) {
 		coda_write(dev, dev->tempbuf.paddr,
 				CODA_REG_BIT_TEMP_BUF_ADDR);
+		coda_write(dev, 0, CODA_REG_BIT_BIT_STREAM_PARAM);
 	} else {
 		coda_write(dev, dev->workbuf.paddr,
 			      CODA_REG_BIT_WORK_BUF_ADDR);
@@ -2462,8 +3127,8 @@ static int coda_probe(struct platform_device *pdev)
 		return -ENOENT;
 	}
 
-	if (devm_request_irq(&pdev->dev, irq, coda_irq_handler,
-		0, CODA_NAME, dev) < 0) {
+	if (devm_request_threaded_irq(&pdev->dev, irq, NULL, coda_irq_handler,
+		IRQF_ONESHOT, CODA_NAME, dev) < 0) {
 		dev_err(&pdev->dev, "failed to request irq\n");
 		return -ENOENT;
 	}
@@ -2521,10 +3186,14 @@ static int coda_probe(struct platform_device *pdev)
 		}
 	}
 
-	if (dev->devtype->product == CODA_DX6)
+	switch (dev->devtype->product) {
+	case CODA_DX6:
 		dev->iram_size = CODADX6_IRAM_SIZE;
-	else
+		break;
+	case CODA_7541:
 		dev->iram_size = CODA7_IRAM_SIZE;
+		break;
+	}
 	dev->iram_vaddr = gen_pool_alloc(dev->iram_pool, dev->iram_size);
 	if (!dev->iram_vaddr) {
 		dev_err(&pdev->dev, "unable to alloc iram\n");
diff --git a/drivers/media/platform/coda.h b/drivers/media/platform/coda.h
index 140eea5..4e32e2e 100644
--- a/drivers/media/platform/coda.h
+++ b/drivers/media/platform/coda.h
@@ -49,6 +49,7 @@
 #define CODA_REG_BIT_TEMP_BUF_ADDR		0x118
 #define CODA_REG_BIT_RD_PTR(x)			(0x120 + 8 * (x))
 #define CODA_REG_BIT_WR_PTR(x)			(0x124 + 8 * (x))
+#define CODA_REG_BIT_FRM_DIS_FLG(x)		(0x150 + 4 * (x))
 #define CODADX6_REG_BIT_SEARCH_RAM_BASE_ADDR	0x140
 #define CODA7_REG_BIT_AXI_SRAM_USE		0x140
 #define		CODA7_USE_HOST_ME_ENABLE	(1 << 11)
@@ -95,6 +96,7 @@
 #define 	CODA_MODE_INVALID		0xffff
 #define CODA_REG_BIT_INT_ENABLE		0x170
 #define		CODA_INT_INTERRUPT_ENABLE	(1 << 3)
+#define CODA_REG_BIT_INT_REASON			0x174
 #define CODA7_REG_BIT_RUN_AUX_STD		0x178
 #define		CODA_MP4_AUX_MPEG4		0
 #define		CODA_MP4_AUX_DIVX3		1
@@ -111,15 +113,89 @@
  * issued.
  */
 
+/* Decoder Sequence Initialization */
+#define CODA_CMD_DEC_SEQ_BB_START		0x180
+#define CODA_CMD_DEC_SEQ_BB_SIZE		0x184
+#define CODA_CMD_DEC_SEQ_OPTION			0x188
+#define		CODA_REORDER_ENABLE			(1 << 1)
+#define		CODADX6_QP_REPORT			(1 << 0)
+#define		CODA7_MP4_DEBLK_ENABLE			(1 << 0)
+#define CODA_CMD_DEC_SEQ_SRC_SIZE		0x18c
+#define CODA_CMD_DEC_SEQ_START_BYTE		0x190
+#define CODA_CMD_DEC_SEQ_PS_BB_START		0x194
+#define CODA_CMD_DEC_SEQ_PS_BB_SIZE		0x198
+#define CODA_CMD_DEC_SEQ_MP4_ASP_CLASS		0x19c
+#define CODA_CMD_DEC_SEQ_X264_MV_EN		0x19c
+#define CODA_CMD_DEC_SEQ_SPP_CHUNK_SIZE		0x1a0
+
+#define CODA7_RET_DEC_SEQ_ASPECT		0x1b0
+#define CODA_RET_DEC_SEQ_SUCCESS		0x1c0
+#define CODA_RET_DEC_SEQ_SRC_FMT		0x1c4 /* SRC_SIZE on CODA7 */
+#define CODA_RET_DEC_SEQ_SRC_SIZE		0x1c4
+#define CODA_RET_DEC_SEQ_SRC_F_RATE		0x1c8
+#define CODA9_RET_DEC_SEQ_ASPECT		0x1c8
+#define CODA_RET_DEC_SEQ_FRAME_NEED		0x1cc
+#define CODA_RET_DEC_SEQ_FRAME_DELAY		0x1d0
+#define CODA_RET_DEC_SEQ_INFO			0x1d4
+#define CODA_RET_DEC_SEQ_CROP_LEFT_RIGHT	0x1d8
+#define CODA_RET_DEC_SEQ_CROP_TOP_BOTTOM	0x1dc
+#define CODA_RET_DEC_SEQ_NEXT_FRAME_NUM		0x1e0
+#define CODA_RET_DEC_SEQ_ERR_REASON		0x1e0
+#define CODA_RET_DEC_SEQ_FRATE_NR		0x1e4
+#define CODA_RET_DEC_SEQ_FRATE_DR		0x1e8
+#define CODA_RET_DEC_SEQ_JPG_PARA		0x1e4
+#define CODA_RET_DEC_SEQ_JPG_THUMB_IND		0x1e8
+
+/* Decoder Picture Run */
+#define CODA_CMD_DEC_PIC_ROT_MODE		0x180
+#define CODA_CMD_DEC_PIC_ROT_ADDR_Y		0x184
+#define CODA_CMD_DEC_PIC_ROT_ADDR_CB		0x188
+#define CODA_CMD_DEC_PIC_ROT_ADDR_CR		0x18c
+#define CODA_CMD_DEC_PIC_ROT_STRIDE		0x190
+
+#define CODA_CMD_DEC_PIC_OPTION			0x194
+#define		CODA_PRE_SCAN_EN			(1 << 0)
+#define		CODA_PRE_SCAN_MODE_DECODE		(0 << 1)
+#define		CODA_PRE_SCAN_MODE_RETURN		(1 << 1)
+#define		CODA_IFRAME_SEARCH_EN			(1 << 2)
+#define		CODA_SKIP_FRAME_MODE			(0x3 << 3)
+#define CODA_CMD_DEC_PIC_SKIP_NUM		0x198
+#define CODA_CMD_DEC_PIC_CHUNK_SIZE		0x19c
+#define CODA_CMD_DEC_PIC_BB_START		0x1a0
+#define CODA_CMD_DEC_PIC_START_BYTE		0x1a4
+#define CODA_RET_DEC_PIC_SIZE			0x1bc
+#define CODA_RET_DEC_PIC_FRAME_NUM		0x1c0
+#define CODA_RET_DEC_PIC_FRAME_IDX		0x1c4
+#define CODA_RET_DEC_PIC_ERR_MB			0x1c8
+#define CODA_RET_DEC_PIC_TYPE			0x1cc
+#define		CODA_PIC_TYPE_MASK			0x7
+#define		CODA_PIC_TYPE_MASK_VC1			0x3f
+#define		CODA9_PIC_TYPE_FIRST_MASK		(0x7 << 3)
+#define		CODA9_PIC_TYPE_IDR_MASK			(0x3 << 6)
+#define		CODA7_PIC_TYPE_H264_NPF_MASK		(0x3 << 16)
+#define		CODA7_PIC_TYPE_INTERLACED		(1 << 18)
+#define CODA_RET_DEC_PIC_POST			0x1d0
+#define CODA_RET_DEC_PIC_MVC_REPORT		0x1d0
+#define CODA_RET_DEC_PIC_OPTION			0x1d4
+#define CODA_RET_DEC_PIC_SUCCESS		0x1d8
+#define CODA_RET_DEC_PIC_CUR_IDX		0x1dc
+#define CODA_RET_DEC_PIC_CROP_LEFT_RIGHT	0x1e0
+#define CODA_RET_DEC_PIC_CROP_TOP_BOTTOM	0x1e4
+#define CODA_RET_DEC_PIC_FRAME_NEED		0x1ec
+
 /* Encoder Sequence Initialization */
 #define CODA_CMD_ENC_SEQ_BB_START				0x180
 #define CODA_CMD_ENC_SEQ_BB_SIZE				0x184
 #define CODA_CMD_ENC_SEQ_OPTION				0x188
+#define		CODA7_OPTION_AVCINTRA16X16ONLY_OFFSET		9
 #define		CODA7_OPTION_GAMMA_OFFSET			8
+#define		CODA7_OPTION_RCQPMAX_OFFSET			7
 #define		CODADX6_OPTION_GAMMA_OFFSET			7
+#define		CODA7_OPTION_RCQPMIN_OFFSET			6
 #define		CODA_OPTION_LIMITQP_OFFSET			6
 #define		CODA_OPTION_RCINTRAQP_OFFSET			5
 #define		CODA_OPTION_FMO_OFFSET				4
+#define		CODA_OPTION_AVC_AUD_OFFSET			2
 #define		CODA_OPTION_SLICEREPORT_OFFSET			1
 #define CODA_CMD_ENC_SEQ_COD_STD				0x18c
 #define		CODA_STD_MPEG4					0
@@ -188,8 +264,10 @@
 #define		CODA_FMOPARAM_TYPE_MASK				1
 #define		CODA_FMOPARAM_SLICENUM_OFFSET			0
 #define		CODA_FMOPARAM_SLICENUM_MASK			0x0f
+#define CODADX6_CMD_ENC_SEQ_INTRA_QP				0x1bc
 #define CODA7_CMD_ENC_SEQ_SEARCH_BASE				0x1b8
 #define CODA7_CMD_ENC_SEQ_SEARCH_SIZE				0x1bc
+#define CODA7_CMD_ENC_SEQ_INTRA_QP				0x1c4
 #define CODA_CMD_ENC_SEQ_RC_QP_MAX				0x1c8
 #define		CODA_QPMAX_OFFSET				0
 #define		CODA_QPMAX_MASK					0x3f
@@ -216,18 +294,24 @@
 #define CODA_CMD_ENC_PIC_OPTION	0x194
 #define CODA_CMD_ENC_PIC_BB_START	0x198
 #define CODA_CMD_ENC_PIC_BB_SIZE	0x19c
+#define CODA_RET_ENC_FRAME_NUM		0x1c0
 #define CODA_RET_ENC_PIC_TYPE		0x1c4
+#define CODA_RET_ENC_PIC_FRAME_IDX	0x1c8
 #define CODA_RET_ENC_PIC_SLICE_NUM	0x1cc
 #define CODA_RET_ENC_PIC_FLAG		0x1d0
+#define CODA_RET_ENC_PIC_SUCCESS	0x1d8
 
 /* Set Frame Buffer */
 #define CODA_CMD_SET_FRAME_BUF_NUM		0x180
 #define CODA_CMD_SET_FRAME_BUF_STRIDE		0x184
+#define CODA_CMD_SET_FRAME_SLICE_BB_START	0x188
+#define CODA_CMD_SET_FRAME_SLICE_BB_SIZE	0x18c
 #define CODA7_CMD_SET_FRAME_AXI_BIT_ADDR	0x190
 #define CODA7_CMD_SET_FRAME_AXI_IPACDC_ADDR	0x194
 #define CODA7_CMD_SET_FRAME_AXI_DBKY_ADDR	0x198
 #define CODA7_CMD_SET_FRAME_AXI_DBKC_ADDR	0x19c
 #define CODA7_CMD_SET_FRAME_AXI_OVL_ADDR	0x1a0
+#define CODA7_CMD_SET_FRAME_MAX_DEC_SIZE	0x1a4
 #define CODA7_CMD_SET_FRAME_SOURCE_BUF_STRIDE	0x1a8
 
 /* Encoder Header */
-- 
1.8.3.1

