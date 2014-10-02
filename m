Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:34088 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752613AbaJBRIx (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 2 Oct 2014 13:08:53 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Kamil Debski <k.debski@samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	linux-media@vger.kernel.org, kernel@pengutronix.de,
	Philipp Zabel <p.zabel@pengutronix.de>,
	Lucas Stach <l.stach@pengutronix.de>
Subject: [PATCH v2 06/10] [media] coda: add CODA7541 JPEG support
Date: Thu,  2 Oct 2014 19:08:31 +0200
Message-Id: <1412269715-28388-7-git-send-email-p.zabel@pengutronix.de>
In-Reply-To: <1412269715-28388-1-git-send-email-p.zabel@pengutronix.de>
References: <1412269715-28388-1-git-send-email-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch adds JPEG encoding and decoding support for CODA7541,
using the BIT processor. Separate JPEG encoder and decoder video
devices are created due to different streaming behaviour and
different supported pixel formats.
The hardware can not change subsampling on the fly, but encode
and decode 4:2:2 subsampled JPEG images from and into this format.

The CODA7541 JPEG decoder uses the bitstream buffer and thus can run
without new buffers queued if there is a buffer in the bitstream.

Since there is no standard way to store the colorspace used in
JPEGs, and to make v4l2-compliance happy, the JPEG format always
reports V4L2_COLORSPACE_JPEG.

Signed-off-by: Lucas Stach <l.stach@pengutronix.de>
Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/media/platform/coda/Makefile      |   2 +-
 drivers/media/platform/coda/coda-bit.c    | 103 +++++++++-----
 drivers/media/platform/coda/coda-common.c | 112 ++++++++++++---
 drivers/media/platform/coda/coda-jpeg.c   | 225 ++++++++++++++++++++++++++++++
 drivers/media/platform/coda/coda.h        |   8 +-
 5 files changed, 398 insertions(+), 52 deletions(-)
 create mode 100644 drivers/media/platform/coda/coda-jpeg.c

diff --git a/drivers/media/platform/coda/Makefile b/drivers/media/platform/coda/Makefile
index 3543291..25ce155 100644
--- a/drivers/media/platform/coda/Makefile
+++ b/drivers/media/platform/coda/Makefile
@@ -1,3 +1,3 @@
-coda-objs := coda-common.o coda-bit.o coda-h264.o
+coda-objs := coda-common.o coda-bit.o coda-h264.o coda-jpeg.o
 
 obj-$(CONFIG_VIDEO_CODA) += coda.o
diff --git a/drivers/media/platform/coda/coda-bit.c b/drivers/media/platform/coda/coda-bit.c
index 746a615..931248d 100644
--- a/drivers/media/platform/coda/coda-bit.c
+++ b/drivers/media/platform/coda/coda-bit.c
@@ -691,6 +691,7 @@ static int coda_start_encoding(struct coda_ctx *ctx)
 	struct vb2_buffer *buf;
 	int gamma, ret, value;
 	u32 dst_fourcc;
+	u32 stride;
 
 	q_data_src = get_q_data(ctx, V4L2_BUF_TYPE_VIDEO_OUTPUT);
 	q_data_dst = get_q_data(ctx, V4L2_BUF_TYPE_VIDEO_CAPTURE);
@@ -710,6 +711,14 @@ static int coda_start_encoding(struct coda_ctx *ctx)
 		return -EFAULT;
 	}
 
+	if (dst_fourcc == V4L2_PIX_FMT_JPEG) {
+		if (!ctx->params.jpeg_qmat_tab[0])
+			ctx->params.jpeg_qmat_tab[0] = kmalloc(64, GFP_KERNEL);
+		if (!ctx->params.jpeg_qmat_tab[1])
+			ctx->params.jpeg_qmat_tab[1] = kmalloc(64, GFP_KERNEL);
+		coda_set_jpeg_compression_quality(ctx, ctx->params.jpeg_quality);
+	}
+
 	mutex_lock(&dev->coda_mutex);
 
 	coda_write(dev, ctx->parabuf.paddr, CODA_REG_BIT_PARA_BUF_ADDR);
@@ -765,6 +774,8 @@ static int coda_start_encoding(struct coda_ctx *ctx)
 			 << CODA_PICHEIGHT_OFFSET;
 	}
 	coda_write(dev, value, CODA_CMD_ENC_SEQ_SRC_SIZE);
+	if (dst_fourcc == V4L2_PIX_FMT_JPEG)
+		ctx->params.framerate = 0;
 	coda_write(dev, ctx->params.framerate,
 		   CODA_CMD_ENC_SEQ_SRC_F_RATE);
 
@@ -798,6 +809,16 @@ static int coda_start_encoding(struct coda_ctx *ctx)
 		}
 		coda_write(dev, value, CODA_CMD_ENC_SEQ_264_PARA);
 		break;
+	case V4L2_PIX_FMT_JPEG:
+		coda_write(dev, 0, CODA_CMD_ENC_SEQ_JPG_PARA);
+		coda_write(dev, ctx->params.jpeg_restart_interval,
+				CODA_CMD_ENC_SEQ_JPG_RST_INTERVAL);
+		coda_write(dev, 0, CODA_CMD_ENC_SEQ_JPG_THUMB_EN);
+		coda_write(dev, 0, CODA_CMD_ENC_SEQ_JPG_THUMB_SIZE);
+		coda_write(dev, 0, CODA_CMD_ENC_SEQ_JPG_THUMB_OFFSET);
+
+		coda_jpeg_write_tables(ctx);
+		break;
 	default:
 		v4l2_err(v4l2_dev,
 			 "dst format (0x%08x) invalid.\n", dst_fourcc);
@@ -805,28 +826,36 @@ static int coda_start_encoding(struct coda_ctx *ctx)
 		goto out;
 	}
 
-	switch (ctx->params.slice_mode) {
-	case V4L2_MPEG_VIDEO_MULTI_SLICE_MODE_SINGLE:
-		value = 0;
-		break;
-	case V4L2_MPEG_VIDEO_MULTI_SICE_MODE_MAX_MB:
-		value  = (ctx->params.slice_max_mb & CODA_SLICING_SIZE_MASK)
-			 << CODA_SLICING_SIZE_OFFSET;
-		value |= (1 & CODA_SLICING_UNIT_MASK)
-			 << CODA_SLICING_UNIT_OFFSET;
-		value |=  1 & CODA_SLICING_MODE_MASK;
-		break;
-	case V4L2_MPEG_VIDEO_MULTI_SICE_MODE_MAX_BYTES:
-		value  = (ctx->params.slice_max_bits & CODA_SLICING_SIZE_MASK)
-			 << CODA_SLICING_SIZE_OFFSET;
-		value |= (0 & CODA_SLICING_UNIT_MASK)
-			 << CODA_SLICING_UNIT_OFFSET;
-		value |=  1 & CODA_SLICING_MODE_MASK;
-		break;
+	/*
+	 * slice mode and GOP size registers are used for thumb size/offset
+	 * in JPEG mode
+	 */
+	if (dst_fourcc != V4L2_PIX_FMT_JPEG) {
+		switch (ctx->params.slice_mode) {
+		case V4L2_MPEG_VIDEO_MULTI_SLICE_MODE_SINGLE:
+			value = 0;
+			break;
+		case V4L2_MPEG_VIDEO_MULTI_SICE_MODE_MAX_MB:
+			value  = (ctx->params.slice_max_mb &
+				  CODA_SLICING_SIZE_MASK)
+				 << CODA_SLICING_SIZE_OFFSET;
+			value |= (1 & CODA_SLICING_UNIT_MASK)
+				 << CODA_SLICING_UNIT_OFFSET;
+			value |=  1 & CODA_SLICING_MODE_MASK;
+			break;
+		case V4L2_MPEG_VIDEO_MULTI_SICE_MODE_MAX_BYTES:
+			value  = (ctx->params.slice_max_bits &
+				  CODA_SLICING_SIZE_MASK)
+				 << CODA_SLICING_SIZE_OFFSET;
+			value |= (0 & CODA_SLICING_UNIT_MASK)
+				 << CODA_SLICING_UNIT_OFFSET;
+			value |=  1 & CODA_SLICING_MODE_MASK;
+			break;
+		}
+		coda_write(dev, value, CODA_CMD_ENC_SEQ_SLICE_MODE);
+		value = ctx->params.gop_size & CODA_GOP_SIZE_MASK;
+		coda_write(dev, value, CODA_CMD_ENC_SEQ_GOP_SIZE);
 	}
-	coda_write(dev, value, CODA_CMD_ENC_SEQ_SLICE_MODE);
-	value = ctx->params.gop_size & CODA_GOP_SIZE_MASK;
-	coda_write(dev, value, CODA_CMD_ENC_SEQ_GOP_SIZE);
 
 	if (ctx->params.bitrate) {
 		/* Rate control enabled */
@@ -917,19 +946,24 @@ static int coda_start_encoding(struct coda_ctx *ctx)
 		goto out;
 	}
 
-	if (dev->devtype->product == CODA_960)
-		ctx->num_internal_frames = 4;
-	else
-		ctx->num_internal_frames = 2;
-	ret = coda_alloc_framebuffers(ctx, q_data_src, dst_fourcc);
-	if (ret < 0) {
-		v4l2_err(v4l2_dev, "failed to allocate framebuffers\n");
-		goto out;
+	if (dst_fourcc != V4L2_PIX_FMT_JPEG) {
+		if (dev->devtype->product == CODA_960)
+			ctx->num_internal_frames = 4;
+		else
+			ctx->num_internal_frames = 2;
+		ret = coda_alloc_framebuffers(ctx, q_data_src, dst_fourcc);
+		if (ret < 0) {
+			v4l2_err(v4l2_dev, "failed to allocate framebuffers\n");
+			goto out;
+		}
+		stride = q_data_src->bytesperline;
+	} else {
+		ctx->num_internal_frames = 0;
+		stride = 0;
 	}
-
 	coda_write(dev, ctx->num_internal_frames, CODA_CMD_SET_FRAME_BUF_NUM);
-	coda_write(dev, q_data_src->bytesperline,
-			CODA_CMD_SET_FRAME_BUF_STRIDE);
+	coda_write(dev, stride, CODA_CMD_SET_FRAME_BUF_STRIDE);
+
 	if (dev->devtype->product == CODA_7541) {
 		coda_write(dev, q_data_src->bytesperline,
 				CODA7_CMD_SET_FRAME_SOURCE_BUF_STRIDE);
@@ -1104,6 +1138,9 @@ static int coda_prepare_encode(struct coda_ctx *ctx)
 		case V4L2_PIX_FMT_MPEG4:
 			quant_param = ctx->params.mpeg4_intra_qp;
 			break;
+		case V4L2_PIX_FMT_JPEG:
+			quant_param = 30;
+			break;
 		default:
 			v4l2_warn(&ctx->dev->v4l2_dev,
 				"cannot set intra qp, fmt not supported\n");
@@ -1315,6 +1352,8 @@ static int __coda_start_decoding(struct coda_ctx *ctx)
 	if ((dev->devtype->product == CODA_7541) ||
 	    (dev->devtype->product == CODA_960))
 		val |= CODA_REORDER_ENABLE;
+	if (ctx->codec->src_fourcc == V4L2_PIX_FMT_JPEG)
+		val |= CODA_NO_INT_ENABLE;
 	coda_write(dev, val, CODA_CMD_DEC_SEQ_OPTION);
 
 	ctx->params.codec_mode = ctx->codec->mode;
diff --git a/drivers/media/platform/coda/coda-common.c b/drivers/media/platform/coda/coda-common.c
index 7fc0dc0..76b80d2 100644
--- a/drivers/media/platform/coda/coda-common.c
+++ b/drivers/media/platform/coda/coda-common.c
@@ -139,6 +139,10 @@ static const struct coda_fmt coda_formats[] = {
 		.name = "MPEG4 Encoded Stream",
 		.fourcc = V4L2_PIX_FMT_MPEG4,
 	},
+	{
+		.name = "JPEG Encoded Images",
+		.fourcc = V4L2_PIX_FMT_JPEG,
+	},
 };
 
 #define CODA_CODEC(mode, src_fourcc, dst_fourcc, max_w, max_h) \
@@ -159,8 +163,10 @@ static const struct coda_codec codadx6_codecs[] = {
 static const struct coda_codec coda7_codecs[] = {
 	CODA_CODEC(CODA7_MODE_ENCODE_H264, V4L2_PIX_FMT_YUV420, V4L2_PIX_FMT_H264,   1280, 720),
 	CODA_CODEC(CODA7_MODE_ENCODE_MP4,  V4L2_PIX_FMT_YUV420, V4L2_PIX_FMT_MPEG4,  1280, 720),
+	CODA_CODEC(CODA7_MODE_ENCODE_MJPG, V4L2_PIX_FMT_YUV420, V4L2_PIX_FMT_JPEG,   8192, 8192),
 	CODA_CODEC(CODA7_MODE_DECODE_H264, V4L2_PIX_FMT_H264,   V4L2_PIX_FMT_YUV420, 1920, 1088),
 	CODA_CODEC(CODA7_MODE_DECODE_MP4,  V4L2_PIX_FMT_MPEG4,  V4L2_PIX_FMT_YUV420, 1920, 1088),
+	CODA_CODEC(CODA7_MODE_DECODE_MJPG, V4L2_PIX_FMT_JPEG,   V4L2_PIX_FMT_YUV420, 8192, 8192),
 };
 
 static const struct coda_codec coda9_codecs[] = {
@@ -193,6 +199,21 @@ static const struct coda_video_device coda_bit_encoder = {
 	},
 };
 
+static const struct coda_video_device coda_bit_jpeg_encoder = {
+	.name = "coda-jpeg-encoder",
+	.type = CODA_INST_ENCODER,
+	.ops = &coda_bit_encode_ops,
+	.src_formats = {
+		V4L2_PIX_FMT_YUV420,
+		V4L2_PIX_FMT_YVU420,
+		V4L2_PIX_FMT_NV12,
+		V4L2_PIX_FMT_YUV422P,
+	},
+	.dst_formats = {
+		V4L2_PIX_FMT_JPEG,
+	},
+};
+
 static const struct coda_video_device coda_bit_decoder = {
 	.name = "coda-decoder",
 	.type = CODA_INST_DECODER,
@@ -208,11 +229,28 @@ static const struct coda_video_device coda_bit_decoder = {
 	},
 };
 
+static const struct coda_video_device coda_bit_jpeg_decoder = {
+	.name = "coda-jpeg-decoder",
+	.type = CODA_INST_DECODER,
+	.ops = &coda_bit_decode_ops,
+	.src_formats = {
+		V4L2_PIX_FMT_JPEG,
+	},
+	.dst_formats = {
+		V4L2_PIX_FMT_YUV420,
+		V4L2_PIX_FMT_YVU420,
+		V4L2_PIX_FMT_NV12,
+		V4L2_PIX_FMT_YUV422P,
+	},
+};
+
 static const struct coda_video_device *codadx6_video_devices[] = {
 	&coda_bit_encoder,
 };
 
 static const struct coda_video_device *coda7_video_devices[] = {
+	&coda_bit_jpeg_encoder,
+	&coda_bit_jpeg_decoder,
 	&coda_bit_encoder,
 	&coda_bit_decoder,
 };
@@ -395,7 +433,10 @@ static int coda_g_fmt(struct file *file, void *priv,
 	f->fmt.pix.bytesperline = q_data->bytesperline;
 
 	f->fmt.pix.sizeimage	= q_data->sizeimage;
-	f->fmt.pix.colorspace	= ctx->colorspace;
+	if (f->fmt.pix.pixelformat == V4L2_PIX_FMT_JPEG)
+		f->fmt.pix.colorspace = V4L2_COLORSPACE_JPEG;
+	else
+		f->fmt.pix.colorspace = ctx->colorspace;
 
 	return 0;
 }
@@ -453,7 +494,10 @@ static int coda_try_fmt(struct coda_ctx *ctx, const struct coda_codec *codec,
 	case V4L2_PIX_FMT_YUV420:
 	case V4L2_PIX_FMT_YVU420:
 	case V4L2_PIX_FMT_NV12:
-		/* Frame stride must be multiple of 8, but 16 for h.264 */
+		/*
+		 * Frame stride must be at least multiple of 8,
+		 * but multiple of 16 for h.264 or JPEG 4:2:x
+		 */
 		f->fmt.pix.bytesperline = round_up(f->fmt.pix.width, 16);
 		f->fmt.pix.sizeimage = f->fmt.pix.bytesperline *
 					f->fmt.pix.height * 3 / 2;
@@ -463,9 +507,11 @@ static int coda_try_fmt(struct coda_ctx *ctx, const struct coda_codec *codec,
 		f->fmt.pix.sizeimage = f->fmt.pix.bytesperline *
 					f->fmt.pix.height * 2;
 		break;
+	case V4L2_PIX_FMT_JPEG:
+		f->fmt.pix.colorspace = V4L2_COLORSPACE_JPEG;
+		/* fallthrough */
 	case V4L2_PIX_FMT_H264:
 	case V4L2_PIX_FMT_MPEG4:
-	case V4L2_PIX_FMT_JPEG:
 		f->fmt.pix.bytesperline = 0;
 		f->fmt.pix.sizeimage = CODA_MAX_FRAME_SIZE;
 		break;
@@ -538,8 +584,12 @@ static int coda_try_fmt_vid_out(struct file *file, void *priv,
 	if (ret < 0)
 		return ret;
 
-	if (!f->fmt.pix.colorspace)
-		f->fmt.pix.colorspace = V4L2_COLORSPACE_REC709;
+	if (!f->fmt.pix.colorspace) {
+		if (f->fmt.pix.pixelformat == V4L2_PIX_FMT_JPEG)
+			f->fmt.pix.colorspace = V4L2_COLORSPACE_JPEG;
+		else
+			f->fmt.pix.colorspace = V4L2_COLORSPACE_REC709;
+	}
 
 	q_data_dst = get_q_data(ctx, V4L2_BUF_TYPE_VIDEO_CAPTURE);
 	codec = coda_find_codec(dev, f->fmt.pix.pixelformat, q_data_dst->fourcc);
@@ -883,6 +933,7 @@ static int coda_job_ready(void *m2m_priv)
 
 	if (ctx->hold ||
 	    ((ctx->inst_type == CODA_INST_DECODER) &&
+	     !v4l2_m2m_num_src_bufs_ready(ctx->fh.m2m_ctx) &&
 	     (coda_get_bitstream_payload(ctx) < 512) &&
 	     !(ctx->bit_stream_param & CODA_BIT_STREAM_END_FLAG))) {
 		v4l2_dbg(1, coda_debug, &ctx->dev->v4l2_dev,
@@ -1057,7 +1108,7 @@ static void coda_buf_queue(struct vb2_buffer *vb)
 	 * In the decoder case, immediately try to copy the buffer into the
 	 * bitstream ringbuffer and mark it as ready to be dequeued.
 	 */
-	if (q_data->fourcc == V4L2_PIX_FMT_H264 &&
+	if (ctx->inst_type == CODA_INST_DECODER &&
 	    vb->vb2_queue->type == V4L2_BUF_TYPE_VIDEO_OUTPUT) {
 		/*
 		 * For backwards compatibility, queuing an empty buffer marks
@@ -1120,12 +1171,13 @@ static int coda_start_streaming(struct vb2_queue *q, unsigned int count)
 	struct v4l2_device *v4l2_dev = &ctx->dev->v4l2_dev;
 	struct coda_q_data *q_data_src, *q_data_dst;
 	struct vb2_buffer *buf;
-	u32 dst_fourcc;
 	int ret = 0;
 
 	q_data_src = get_q_data(ctx, V4L2_BUF_TYPE_VIDEO_OUTPUT);
 	if (q->type == V4L2_BUF_TYPE_VIDEO_OUTPUT) {
-		if (q_data_src->fourcc == V4L2_PIX_FMT_H264) {
+		if (q_data_src->fourcc == V4L2_PIX_FMT_H264 ||
+		    (q_data_src->fourcc == V4L2_PIX_FMT_JPEG &&
+		     ctx->dev->devtype->product == CODA_7541)) {
 			/* copy the buffers that where queued before streamon */
 			mutex_lock(&ctx->bitstream_mutex);
 			coda_fill_bitstream(ctx);
@@ -1156,13 +1208,12 @@ static int coda_start_streaming(struct vb2_queue *q, unsigned int count)
 	if (!(ctx->streamon_out & ctx->streamon_cap))
 		return 0;
 
-	/* Allow decoder device_run with no new buffers queued */
+	/* Allow BIT decoder device_run with no new buffers queued */
 	if (ctx->inst_type == CODA_INST_DECODER)
 		v4l2_m2m_set_src_buffered(ctx->fh.m2m_ctx, true);
 
 	ctx->gopcounter = ctx->params.gop_size - 1;
 	q_data_dst = get_q_data(ctx, V4L2_BUF_TYPE_VIDEO_CAPTURE);
-	dst_fourcc = q_data_dst->fourcc;
 
 	ctx->codec = coda_find_codec(ctx->dev, q_data_src->fourcc,
 				     q_data_dst->fourcc);
@@ -1172,6 +1223,10 @@ static int coda_start_streaming(struct vb2_queue *q, unsigned int count)
 		goto err;
 	}
 
+	if (q_data_dst->fourcc == V4L2_PIX_FMT_JPEG)
+		ctx->params.gop_size = 1;
+	ctx->gopcounter = ctx->params.gop_size - 1;
+
 	ret = ctx->ops->start_streaming(ctx);
 	if (ctx->inst_type == CODA_INST_DECODER) {
 		if (ret == -EAGAIN)
@@ -1320,6 +1375,12 @@ static int coda_s_ctrl(struct v4l2_ctrl *ctrl)
 	case V4L2_CID_MPEG_VIDEO_CYCLIC_INTRA_REFRESH_MB:
 		ctx->params.intra_refresh = ctrl->val;
 		break;
+	case V4L2_CID_JPEG_COMPRESSION_QUALITY:
+		coda_set_jpeg_compression_quality(ctx, ctrl->val);
+		break;
+	case V4L2_CID_JPEG_RESTART_INTERVAL:
+		ctx->params.jpeg_restart_interval = ctrl->val;
+		break;
 	default:
 		v4l2_dbg(1, coda_debug, &ctx->dev->v4l2_dev,
 			"Invalid control, id=%d, val=%d\n",
@@ -1381,6 +1442,14 @@ static void coda_encode_ctrls(struct coda_ctx *ctx)
 		1920 * 1088 / 256, 1, 0);
 }
 
+static void coda_jpeg_encode_ctrls(struct coda_ctx *ctx)
+{
+	v4l2_ctrl_new_std(&ctx->ctrls, &coda_ctrl_ops,
+		V4L2_CID_JPEG_COMPRESSION_QUALITY, 5, 100, 1, 50);
+	v4l2_ctrl_new_std(&ctx->ctrls, &coda_ctrl_ops,
+		V4L2_CID_JPEG_RESTART_INTERVAL, 0, 100, 1, 0);
+}
+
 static int coda_ctrls_setup(struct coda_ctx *ctx)
 {
 	v4l2_ctrl_handler_init(&ctx->ctrls, 2);
@@ -1389,8 +1458,12 @@ static int coda_ctrls_setup(struct coda_ctx *ctx)
 		V4L2_CID_HFLIP, 0, 1, 1, 0);
 	v4l2_ctrl_new_std(&ctx->ctrls, &coda_ctrl_ops,
 		V4L2_CID_VFLIP, 0, 1, 1, 0);
-	if (ctx->inst_type == CODA_INST_ENCODER)
-		coda_encode_ctrls(ctx);
+	if (ctx->inst_type == CODA_INST_ENCODER) {
+		if (ctx->cvd->dst_formats[0] == V4L2_PIX_FMT_JPEG)
+			coda_jpeg_encode_ctrls(ctx);
+		else
+			coda_encode_ctrls(ctx);
+	}
 
 	if (ctx->ctrls.error) {
 		v4l2_err(&ctx->dev->v4l2_dev,
@@ -1548,16 +1621,17 @@ static int coda_open(struct file *file)
 
 	ctx->fh.ctrl_handler = &ctx->ctrls;
 
-	ret = coda_alloc_context_buf(ctx, &ctx->parabuf, CODA_PARA_BUF_SIZE,
-				     "parabuf");
+	ret = coda_alloc_context_buf(ctx, &ctx->parabuf,
+				     CODA_PARA_BUF_SIZE, "parabuf");
 	if (ret < 0) {
 		v4l2_err(&dev->v4l2_dev, "failed to allocate parabuf");
 		goto err_dma_alloc;
 	}
 
 	ctx->bitstream.size = CODA_MAX_FRAME_SIZE;
-	ctx->bitstream.vaddr = dma_alloc_writecombine(&dev->plat_dev->dev,
-			ctx->bitstream.size, &ctx->bitstream.paddr, GFP_KERNEL);
+	ctx->bitstream.vaddr = dma_alloc_writecombine(
+			&dev->plat_dev->dev, ctx->bitstream.size,
+			&ctx->bitstream.paddr, GFP_KERNEL);
 	if (!ctx->bitstream.vaddr) {
 		v4l2_err(&dev->v4l2_dev,
 			 "failed to allocate bitstream ringbuffer");
@@ -1625,8 +1699,10 @@ static int coda_release(struct file *file)
 	list_del(&ctx->list);
 	coda_unlock(ctx);
 
-	dma_free_writecombine(&dev->plat_dev->dev, ctx->bitstream.size,
-		ctx->bitstream.vaddr, ctx->bitstream.paddr);
+	if (ctx->bitstream.vaddr) {
+		dma_free_writecombine(&dev->plat_dev->dev, ctx->bitstream.size,
+			ctx->bitstream.vaddr, ctx->bitstream.paddr);
+	}
 	if (ctx->dev->devtype->product == CODA_DX6)
 		coda_free_aux_buf(dev, &ctx->workbuf);
 
diff --git a/drivers/media/platform/coda/coda-jpeg.c b/drivers/media/platform/coda/coda-jpeg.c
new file mode 100644
index 0000000..967b015
--- /dev/null
+++ b/drivers/media/platform/coda/coda-jpeg.c
@@ -0,0 +1,225 @@
+/*
+ * Coda multi-standard codec IP - JPEG support functions
+ *
+ * Copyright (C) 2014 Philipp Zabel, Pengutronix
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+#include <linux/kernel.h>
+#include <linux/swab.h>
+
+#include "coda.h"
+
+/*
+ * Typical Huffman tables for 8-bit precision luminance and
+ * chrominance from JPEG ITU-T.81 (ISO/IEC 10918-1) Annex K.3
+ */
+
+static const unsigned char luma_dc_bits[16] = {
+	0x00, 0x01, 0x05, 0x01, 0x01, 0x01, 0x01, 0x01,
+	0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+};
+
+static const unsigned char luma_dc_value[12] = {
+	0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07,
+	0x08, 0x09, 0x0a, 0x0b,
+};
+
+static const unsigned char chroma_dc_bits[16] = {
+	0x00, 0x03, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01,
+	0x01, 0x01, 0x01, 0x00, 0x00, 0x00, 0x00, 0x00,
+};
+
+static const unsigned char chroma_dc_value[12] = {
+	0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07,
+	0x08, 0x09, 0x0a, 0x0b,
+};
+
+static const unsigned char luma_ac_bits[16] = {
+	0x00, 0x02, 0x01, 0x03, 0x03, 0x02, 0x04, 0x03,
+	0x05, 0x05, 0x04, 0x04, 0x00, 0x00, 0x01, 0x7d,
+};
+
+static const unsigned char luma_ac_value[162 + 2] = {
+	0x01, 0x02, 0x03, 0x00, 0x04, 0x11, 0x05, 0x12,
+	0x21, 0x31, 0x41, 0x06, 0x13, 0x51, 0x61, 0x07,
+	0x22, 0x71, 0x14, 0x32, 0x81, 0x91, 0xa1, 0x08,
+	0x23, 0x42, 0xb1, 0xc1, 0x15, 0x52, 0xd1, 0xf0,
+	0x24, 0x33, 0x62, 0x72, 0x82, 0x09, 0x0a, 0x16,
+	0x17, 0x18, 0x19, 0x1a, 0x25, 0x26, 0x27, 0x28,
+	0x29, 0x2a, 0x34, 0x35, 0x36, 0x37, 0x38, 0x39,
+	0x3a, 0x43, 0x44, 0x45, 0x46, 0x47, 0x48, 0x49,
+	0x4a, 0x53, 0x54, 0x55, 0x56, 0x57, 0x58, 0x59,
+	0x5a, 0x63, 0x64, 0x65, 0x66, 0x67, 0x68, 0x69,
+	0x6a, 0x73, 0x74, 0x75, 0x76, 0x77, 0x78, 0x79,
+	0x7a, 0x83, 0x84, 0x85, 0x86, 0x87, 0x88, 0x89,
+	0x8a, 0x92, 0x93, 0x94, 0x95, 0x96, 0x97, 0x98,
+	0x99, 0x9a, 0xa2, 0xa3, 0xa4, 0xa5, 0xa6, 0xa7,
+	0xa8, 0xa9, 0xaa, 0xb2, 0xb3, 0xb4, 0xb5, 0xb6,
+	0xb7, 0xb8, 0xb9, 0xba, 0xc2, 0xc3, 0xc4, 0xc5,
+	0xc6, 0xc7, 0xc8, 0xc9, 0xca, 0xd2, 0xd3, 0xd4,
+	0xd5, 0xd6, 0xd7, 0xd8, 0xd9, 0xda, 0xe1, 0xe2,
+	0xe3, 0xe4, 0xe5, 0xe6, 0xe7, 0xe8, 0xe9, 0xea,
+	0xf1, 0xf2, 0xf3, 0xf4, 0xf5, 0xf6, 0xf7, 0xf8,
+	0xf9, 0xfa, /* padded to 32-bit */
+};
+
+static const unsigned char chroma_ac_bits[16] = {
+	0x00, 0x02, 0x01, 0x02, 0x04, 0x04, 0x03, 0x04,
+	0x07, 0x05, 0x04, 0x04, 0x00, 0x01, 0x02, 0x77,
+};
+
+static const unsigned char chroma_ac_value[162 + 2] = {
+	0x00, 0x01, 0x02, 0x03, 0x11, 0x04, 0x05, 0x21,
+	0x31, 0x06, 0x12, 0x41, 0x51, 0x07, 0x61, 0x71,
+	0x13, 0x22, 0x32, 0x81, 0x08, 0x14, 0x42, 0x91,
+	0xa1, 0xb1, 0xc1, 0x09, 0x23, 0x33, 0x52, 0xf0,
+	0x15, 0x62, 0x72, 0xd1, 0x0a, 0x16, 0x24, 0x34,
+	0xe1, 0x25, 0xf1, 0x17, 0x18, 0x19, 0x1a, 0x26,
+	0x27, 0x28, 0x29, 0x2a, 0x35, 0x36, 0x37, 0x38,
+	0x39, 0x3a, 0x43, 0x44, 0x45, 0x46, 0x47, 0x48,
+	0x49, 0x4a, 0x53, 0x54, 0x55, 0x56, 0x57, 0x58,
+	0x59, 0x5a, 0x63, 0x64, 0x65, 0x66, 0x67, 0x68,
+	0x69, 0x6a, 0x73, 0x74, 0x75, 0x76, 0x77, 0x78,
+	0x79, 0x7a, 0x82, 0x83, 0x84, 0x85, 0x86, 0x87,
+	0x88, 0x89, 0x8a, 0x92, 0x93, 0x94, 0x95, 0x96,
+	0x97, 0x98, 0x99, 0x9a, 0xa2, 0xa3, 0xa4, 0xa5,
+	0xa6, 0xa7, 0xa8, 0xa9, 0xaa, 0xb2, 0xb3, 0xb4,
+	0xb5, 0xb6, 0xb7, 0xb8, 0xb9, 0xba, 0xc2, 0xc3,
+	0xc4, 0xc5, 0xc6, 0xc7, 0xc8, 0xc9, 0xca, 0xd2,
+	0xd3, 0xd4, 0xd5, 0xd6, 0xd7, 0xd8, 0xd9, 0xda,
+	0xe2, 0xe3, 0xe4, 0xe5, 0xe6, 0xe7, 0xe8, 0xe9,
+	0xea, 0xf2, 0xf3, 0xf4, 0xf5, 0xf6, 0xf7, 0xf8,
+	0xf9, 0xfa, /* padded to 32-bit */
+};
+
+/*
+ * Quantization tables for luminance and chrominance components in
+ * zig-zag scan order from the Freescale i.MX VPU libaries
+ */
+
+static unsigned char luma_q[64] = {
+	0x06, 0x04, 0x04, 0x04, 0x05, 0x04, 0x06, 0x05,
+	0x05, 0x06, 0x09, 0x06, 0x05, 0x06, 0x09, 0x0b,
+	0x08, 0x06, 0x06, 0x08, 0x0b, 0x0c, 0x0a, 0x0a,
+	0x0b, 0x0a, 0x0a, 0x0c, 0x10, 0x0c, 0x0c, 0x0c,
+	0x0c, 0x0c, 0x0c, 0x10, 0x0c, 0x0c, 0x0c, 0x0c,
+	0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c,
+	0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c,
+	0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c,
+};
+
+static unsigned char chroma_q[64] = {
+	0x07, 0x07, 0x07, 0x0d, 0x0c, 0x0d, 0x18, 0x10,
+	0x10, 0x18, 0x14, 0x0e, 0x0e, 0x0e, 0x14, 0x14,
+	0x0e, 0x0e, 0x0e, 0x0e, 0x14, 0x11, 0x0c, 0x0c,
+	0x0c, 0x0c, 0x0c, 0x11, 0x11, 0x0c, 0x0c, 0x0c,
+	0x0c, 0x0c, 0x0c, 0x11, 0x0c, 0x0c, 0x0c, 0x0c,
+	0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c,
+	0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c,
+	0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c,
+};
+
+struct coda_memcpy_desc {
+	int offset;
+	const void *src;
+	size_t len;
+};
+
+static void coda_memcpy_parabuf(void *parabuf,
+				const struct coda_memcpy_desc *desc)
+{
+	u32 *dst = parabuf + desc->offset;
+	const u32 *src = desc->src;
+	int len = desc->len / 4;
+	int i;
+
+	for (i = 0; i < len; i += 2) {
+		dst[i + 1] = swab32(src[i]);
+		dst[i] = swab32(src[i + 1]);
+	}
+}
+
+int coda_jpeg_write_tables(struct coda_ctx *ctx)
+{
+	int i;
+	static const struct coda_memcpy_desc huff[8] = {
+		{ 0,   luma_dc_bits,    sizeof(luma_dc_bits)    },
+		{ 16,  luma_dc_value,   sizeof(luma_dc_value)   },
+		{ 32,  luma_ac_bits,    sizeof(luma_ac_bits)    },
+		{ 48,  luma_ac_value,   sizeof(luma_ac_value)   },
+		{ 216, chroma_dc_bits,  sizeof(chroma_dc_bits)  },
+		{ 232, chroma_dc_value, sizeof(chroma_dc_value) },
+		{ 248, chroma_ac_bits,  sizeof(chroma_ac_bits)  },
+		{ 264, chroma_ac_value, sizeof(chroma_ac_value) },
+	};
+	struct coda_memcpy_desc qmat[3] = {
+		{ 512, ctx->params.jpeg_qmat_tab[0], 64 },
+		{ 576, ctx->params.jpeg_qmat_tab[1], 64 },
+		{ 640, ctx->params.jpeg_qmat_tab[1], 64 },
+	};
+
+	/* Write huffman tables to parameter memory */
+	for (i = 0; i < ARRAY_SIZE(huff); i++)
+		coda_memcpy_parabuf(ctx->parabuf.vaddr, huff + i);
+
+	/* Write Q-matrix to parameter memory */
+	for (i = 0; i < ARRAY_SIZE(qmat); i++)
+		coda_memcpy_parabuf(ctx->parabuf.vaddr, qmat + i);
+
+	return 0;
+}
+
+/*
+ * Scale quantization table using nonlinear scaling factor
+ * u8 qtab[64], scale [50,190]
+ */
+static void coda_scale_quant_table(u8 *q_tab, int scale)
+{
+	unsigned int temp;
+	int i;
+
+	for (i = 0; i < 64; i++) {
+		temp = DIV_ROUND_CLOSEST((unsigned int)q_tab[i] * scale, 100);
+		if (temp <= 0)
+			temp = 1;
+		if (temp > 255)
+			temp = 255;
+		q_tab[i] = (unsigned char)temp;
+	}
+}
+
+void coda_set_jpeg_compression_quality(struct coda_ctx *ctx, int quality)
+{
+	unsigned int scale;
+
+	ctx->params.jpeg_quality = quality;
+
+	/* Clip quality setting to [5,100] interval */
+	if (quality > 100)
+		quality = 100;
+	if (quality < 5)
+		quality = 5;
+
+	/*
+	 * Non-linear scaling factor:
+	 * [5,50] -> [1000..100], [51,100] -> [98..0]
+	 */
+	if (quality < 50)
+		scale = 5000 / quality;
+	else
+		scale = 200 - 2 * quality;
+
+	if (ctx->params.jpeg_qmat_tab[0]) {
+		memcpy(ctx->params.jpeg_qmat_tab[0], luma_q, 64);
+		coda_scale_quant_table(ctx->params.jpeg_qmat_tab[0], scale);
+	}
+	if (ctx->params.jpeg_qmat_tab[1]) {
+		memcpy(ctx->params.jpeg_qmat_tab[1], chroma_q, 64);
+		coda_scale_quant_table(ctx->params.jpeg_qmat_tab[1], scale);
+	}
+}
diff --git a/drivers/media/platform/coda/coda.h b/drivers/media/platform/coda/coda.h
index 07eaf58..c14dee8 100644
--- a/drivers/media/platform/coda/coda.h
+++ b/drivers/media/platform/coda/coda.h
@@ -69,7 +69,7 @@ struct coda_aux_buf {
 
 struct coda_dev {
 	struct v4l2_device	v4l2_dev;
-	struct video_device	vfd[3];
+	struct video_device	vfd[5];
 	struct platform_device	*plat_dev;
 	const struct coda_devtype *devtype;
 
@@ -118,6 +118,9 @@ struct coda_params {
 	u8			mpeg4_inter_qp;
 	u8			gop_size;
 	int			intra_refresh;
+	u8			jpeg_quality;
+	u8			jpeg_restart_interval;
+	u8			*jpeg_qmat_tab[3];
 	int			codec_mode;
 	int			codec_mode_aux;
 	enum v4l2_mpeg_video_multi_slice_mode slice_mode;
@@ -288,6 +291,9 @@ void coda_bit_stream_end_flag(struct coda_ctx *ctx);
 
 int coda_h264_padding(int size, char *p);
 
+int coda_jpeg_write_tables(struct coda_ctx *ctx);
+void coda_set_jpeg_compression_quality(struct coda_ctx *ctx, int quality);
+
 extern const struct coda_context_ops coda_bit_encode_ops;
 extern const struct coda_context_ops coda_bit_decode_ops;
 
-- 
2.1.0

