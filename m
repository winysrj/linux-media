Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:33359 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753771Ab2ILPCs (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 12 Sep 2012 11:02:48 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: Javier Martin <javier.martin@vista-silicon.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Richard Zhao <richard.zhao@freescale.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>, kernel@pengutronix.de,
	Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH v5 04/13] media: coda: allocate internal framebuffers separately from v4l2 buffers
Date: Wed, 12 Sep 2012 17:02:29 +0200
Message-Id: <1347462158-20417-5-git-send-email-p.zabel@pengutronix.de>
In-Reply-To: <1347462158-20417-1-git-send-email-p.zabel@pengutronix.de>
References: <1347462158-20417-1-git-send-email-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Some codecs running on CODA need internal framebuffers for reference and
reconstructed frames. Allocate them separately, and do not use the input
vb2_buffers: those will be handed off to userspace regularly, and there
is no way to signal to the CODA which of the registered framebuffers are
off limits. As a consequence, userspace is now free to choose the number
of v4l2 buffers.
This patch also includes the code to set up the parameter buffer for
CODA7 and above with 64-bit AXI bus width.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
Reviewed-by: Javier Martin <javier.martin@vista-silicon.com>
Tested-by: Javier Martin <javier.martin@vista-silicon.com>
---
 drivers/media/platform/coda.c |  141 +++++++++++++++++++++++++----------------
 1 file changed, 86 insertions(+), 55 deletions(-)

diff --git a/drivers/media/platform/coda.c b/drivers/media/platform/coda.c
index 5f4bd7c..f4b4a6f 100644
--- a/drivers/media/platform/coda.c
+++ b/drivers/media/platform/coda.c
@@ -45,8 +45,7 @@
 #define CODA_ISRAM_SIZE	(2048 * 2)
 #define CODA7_IRAM_SIZE		0x14000 /* 81920 bytes */
 
-#define CODA_OUTPUT_BUFS	4
-#define CODA_CAPTURE_BUFS	2
+#define CODA_MAX_FRAMEBUFFERS	2
 
 #define MAX_W		720
 #define MAX_H		576
@@ -164,11 +163,12 @@ struct coda_ctx {
 	struct v4l2_m2m_ctx		*m2m_ctx;
 	struct v4l2_ctrl_handler	ctrls;
 	struct v4l2_fh			fh;
-	struct vb2_buffer		*reference;
 	int				gopcounter;
 	char				vpu_header[3][64];
 	int				vpu_header_size[3];
 	struct coda_aux_buf		parabuf;
+	struct coda_aux_buf		internal_frames[CODA_MAX_FRAMEBUFFERS];
+	int				num_internal_frames;
 	int				idx;
 };
 
@@ -738,14 +738,6 @@ static int coda_job_ready(void *m2m_priv)
 		return 0;
 	}
 
-	/* For P frames a reference picture is needed too */
-	if ((ctx->gopcounter != (ctx->params.gop_size - 1)) &&
-	   !ctx->reference) {
-		v4l2_dbg(1, coda_debug, &ctx->dev->v4l2_dev,
-			 "not ready: reference picture not available.\n");
-		return 0;
-	}
-
 	if (coda_isbusy(ctx->dev)) {
 		v4l2_dbg(1, coda_debug, &ctx->dev->v4l2_dev,
 			 "not ready: coda is still busy.\n");
@@ -799,7 +791,6 @@ static void set_default_params(struct coda_ctx *ctx)
 	ctx->params.codec_mode = CODA_MODE_INVALID;
 	ctx->colorspace = V4L2_COLORSPACE_REC709;
 	ctx->params.framerate = 30;
-	ctx->reference = NULL;
 	ctx->aborting = 0;
 
 	/* Default formats for output and input queues */
@@ -825,7 +816,6 @@ static int coda_queue_setup(struct vb2_queue *vq,
 	unsigned int size;
 
 	if (vq->type == V4L2_BUF_TYPE_VIDEO_OUTPUT) {
-		*nbuffers = CODA_OUTPUT_BUFS;
 		if (fmt)
 			size = fmt->fmt.pix.width *
 				fmt->fmt.pix.height * 3 / 2;
@@ -833,7 +823,6 @@ static int coda_queue_setup(struct vb2_queue *vq,
 			size = MAX_W *
 				MAX_H * 3 / 2;
 	} else {
-		*nbuffers = CODA_CAPTURE_BUFS;
 		size = CODA_MAX_FRAME_SIZE;
 	}
 
@@ -886,6 +875,77 @@ static void coda_wait_finish(struct vb2_queue *q)
 	coda_lock(ctx);
 }
 
+static void coda_free_framebuffers(struct coda_ctx *ctx)
+{
+	int i;
+
+	for (i = 0; i < CODA_MAX_FRAMEBUFFERS; i++) {
+		if (ctx->internal_frames[i].vaddr) {
+			dma_free_coherent(&ctx->dev->plat_dev->dev,
+				ctx->internal_frames[i].size,
+				ctx->internal_frames[i].vaddr,
+				ctx->internal_frames[i].paddr);
+			ctx->internal_frames[i].vaddr = NULL;
+		}
+	}
+}
+
+static int coda_alloc_framebuffers(struct coda_ctx *ctx, struct coda_q_data *q_data, u32 fourcc)
+{
+	struct coda_dev *dev = ctx->dev;
+
+	int height = q_data->height;
+	int width = q_data->width;
+	u32 *p;
+	int i;
+
+	/* Allocate frame buffers */
+	ctx->num_internal_frames = CODA_MAX_FRAMEBUFFERS;
+	for (i = 0; i < ctx->num_internal_frames; i++) {
+		ctx->internal_frames[i].size = q_data->sizeimage;
+		if (fourcc == V4L2_PIX_FMT_H264 && dev->devtype->product != CODA_DX6)
+			ctx->internal_frames[i].size += width / 2 * height / 2;
+		ctx->internal_frames[i].vaddr = dma_alloc_coherent(
+				&dev->plat_dev->dev, ctx->internal_frames[i].size,
+				&ctx->internal_frames[i].paddr, GFP_KERNEL);
+		if (!ctx->internal_frames[i].vaddr) {
+			coda_free_framebuffers(ctx);
+			return -ENOMEM;
+		}
+	}
+
+	/* Register frame buffers in the parameter buffer */
+	p = ctx->parabuf.vaddr;
+
+	if (dev->devtype->product == CODA_DX6) {
+		for (i = 0; i < ctx->num_internal_frames; i++) {
+			p[i * 3] = ctx->internal_frames[i].paddr; /* Y */
+			p[i * 3 + 1] = p[i * 3] + width * height; /* Cb */
+			p[i * 3 + 2] = p[i * 3 + 1] + width / 2 * height / 2; /* Cr */
+		}
+	} else {
+		for (i = 0; i < ctx->num_internal_frames; i += 2) {
+			p[i * 3 + 1] = ctx->internal_frames[i].paddr; /* Y */
+			p[i * 3] = p[i * 3 + 1] + width * height; /* Cb */
+			p[i * 3 + 3] = p[i * 3] + (width / 2) * (height / 2); /* Cr */
+
+			if (fourcc == V4L2_PIX_FMT_H264)
+				p[96 + i + 1] = p[i * 3 + 3] + (width / 2) * (height / 2);
+
+			if (i + 1 < ctx->num_internal_frames) {
+				p[i * 3 + 2] = ctx->internal_frames[i+1].paddr; /* Y */
+				p[i * 3 + 5] = p[i * 3 + 2] + width * height ; /* Cb */
+				p[i * 3 + 4] = p[i * 3 + 5] + (width / 2) * (height / 2); /* Cr */
+
+				if (fourcc == V4L2_PIX_FMT_H264)
+					p[96 + i] = p[i * 3 + 4] + (width / 2) * (height / 2);
+			}
+		}
+	}
+
+	return 0;
+}
+
 static int coda_start_streaming(struct vb2_queue *q, unsigned int count)
 {
 	struct coda_ctx *ctx = vb2_get_drv_priv(q);
@@ -893,11 +953,10 @@ static int coda_start_streaming(struct vb2_queue *q, unsigned int count)
 	u32 bitstream_buf, bitstream_size;
 	struct coda_dev *dev = ctx->dev;
 	struct coda_q_data *q_data_src, *q_data_dst;
-	u32 dst_fourcc;
 	struct vb2_buffer *buf;
-	struct vb2_queue *src_vq;
+	u32 dst_fourcc;
 	u32 value;
-	int i = 0;
+	int ret;
 
 	if (count < 1)
 		return -EINVAL;
@@ -1045,25 +1104,11 @@ static int coda_start_streaming(struct vb2_queue *q, unsigned int count)
 	if (coda_read(dev, CODA_RET_ENC_SEQ_SUCCESS) == 0)
 		return -EFAULT;
 
-	/*
-	 * Walk the src buffer list and let the codec know the
-	 * addresses of the pictures.
-	 */
-	src_vq = v4l2_m2m_get_vq(ctx->m2m_ctx, V4L2_BUF_TYPE_VIDEO_OUTPUT);
-	for (i = 0; i < src_vq->num_buffers; i++) {
-		u32 *p;
-
-		buf = src_vq->bufs[i];
-		p = ctx->parabuf.vaddr;
-
-		p[i * 3] = vb2_dma_contig_plane_dma_addr(buf, 0);
-		p[i * 3 + 1] = p[i * 3] + q_data_src->width *
-				q_data_src->height;
-		p[i * 3 + 2] = p[i * 3 + 1] + q_data_src->width / 2 *
-				q_data_src->height / 2;
-	}
+	ret = coda_alloc_framebuffers(ctx, q_data_src, dst_fourcc);
+	if (ret < 0)
+		return ret;
 
-	coda_write(dev, src_vq->num_buffers, CODA_CMD_SET_FRAME_BUF_NUM);
+	coda_write(dev, ctx->num_internal_frames, CODA_CMD_SET_FRAME_BUF_NUM);
 	coda_write(dev, round_up(q_data_src->width, 8), CODA_CMD_SET_FRAME_BUF_STRIDE);
 	if (dev->devtype->product != CODA_DX6) {
 		coda_write(dev, round_up(q_data_src->width, 8), CODA7_CMD_SET_FRAME_SOURCE_BUF_STRIDE);
@@ -1186,6 +1231,8 @@ static int coda_stop_streaming(struct vb2_queue *q)
 				 "CODA_COMMAND_SEQ_END failed\n");
 			return -ETIMEDOUT;
 		}
+
+		coda_free_framebuffers(ctx);
 	}
 
 	return 0;
@@ -1434,7 +1481,7 @@ static const struct v4l2_file_operations coda_fops = {
 
 static irqreturn_t coda_irq_handler(int irq, void *data)
 {
-	struct vb2_buffer *src_buf, *dst_buf, *tmp_buf;
+	struct vb2_buffer *src_buf, *dst_buf;
 	struct coda_dev *dev = data;
 	u32 wr_ptr, start_ptr;
 	struct coda_ctx *ctx;
@@ -1462,8 +1509,8 @@ static irqreturn_t coda_irq_handler(int irq, void *data)
 		return IRQ_NONE;
 	}
 
-	src_buf = v4l2_m2m_next_src_buf(ctx->m2m_ctx);
-	dst_buf = v4l2_m2m_next_dst_buf(ctx->m2m_ctx);
+	src_buf = v4l2_m2m_src_buf_remove(ctx->m2m_ctx);
+	dst_buf = v4l2_m2m_dst_buf_remove(ctx->m2m_ctx);
 
 	/* Get results from the coda */
 	coda_read(dev, CODA_RET_ENC_PIC_TYPE);
@@ -1493,23 +1540,7 @@ static irqreturn_t coda_irq_handler(int irq, void *data)
 		dst_buf->v4l2_buf.flags &= ~V4L2_BUF_FLAG_KEYFRAME;
 	}
 
-	/* Free previous reference picture if available */
-	if (ctx->reference) {
-		v4l2_m2m_buf_done(ctx->reference, VB2_BUF_STATE_DONE);
-		ctx->reference = NULL;
-	}
-
-	/*
-	 * For the last frame of the gop we don't need to save
-	 * a reference picture.
-	 */
-	v4l2_m2m_dst_buf_remove(ctx->m2m_ctx);
-	tmp_buf = v4l2_m2m_src_buf_remove(ctx->m2m_ctx);
-	if (ctx->gopcounter == 0)
-		v4l2_m2m_buf_done(src_buf, VB2_BUF_STATE_DONE);
-	else
-		ctx->reference = tmp_buf;
-
+	v4l2_m2m_buf_done(src_buf, VB2_BUF_STATE_DONE);
 	v4l2_m2m_buf_done(dst_buf, VB2_BUF_STATE_DONE);
 
 	ctx->gopcounter--;
-- 
1.7.10.4

