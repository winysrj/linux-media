Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:44425 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752101AbaFMQJG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 13 Jun 2014 12:09:06 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Kamil Debski <k.debski@samsung.com>,
	Fabio Estevam <fabio.estevam@freescale.com>,
	kernel@pengutronix.de, Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH 07/30] [media] coda: add selection API support for h.264 decoder
Date: Fri, 13 Jun 2014 18:08:33 +0200
Message-Id: <1402675736-15379-8-git-send-email-p.zabel@pengutronix.de>
In-Reply-To: <1402675736-15379-1-git-send-email-p.zabel@pengutronix.de>
References: <1402675736-15379-1-git-send-email-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The h.264 decoder produces capture frames that are a multiple of the macroblock
size (16 pixels). To inform userspace about invalid pixel data at the edges,
use the active and padded composing rectangles on the capture queue.
The cropping information is obtained from the h.264 sequence parameter set.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/media/platform/coda.c | 87 +++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 87 insertions(+)

diff --git a/drivers/media/platform/coda.c b/drivers/media/platform/coda.c
index 10cc031..7e4df82 100644
--- a/drivers/media/platform/coda.c
+++ b/drivers/media/platform/coda.c
@@ -119,6 +119,7 @@ struct coda_q_data {
 	unsigned int		height;
 	unsigned int		sizeimage;
 	unsigned int		fourcc;
+	struct v4l2_rect	rect;
 };
 
 struct coda_aux_buf {
@@ -737,6 +738,10 @@ static int coda_s_fmt(struct coda_ctx *ctx, struct v4l2_format *f)
 	q_data->width = f->fmt.pix.width;
 	q_data->height = f->fmt.pix.height;
 	q_data->sizeimage = f->fmt.pix.sizeimage;
+	q_data->rect.left = 0;
+	q_data->rect.top = 0;
+	q_data->rect.width = f->fmt.pix.width;
+	q_data->rect.height = f->fmt.pix.height;
 
 	v4l2_dbg(1, coda_debug, &ctx->dev->v4l2_dev,
 		"Setting format for type %d, wxh: %dx%d, fmt: %d\n",
@@ -873,6 +878,43 @@ static int coda_streamoff(struct file *file, void *priv,
 	return ret;
 }
 
+static int coda_g_selection(struct file *file, void *fh,
+			    struct v4l2_selection *s)
+{
+	struct coda_ctx *ctx = fh_to_ctx(fh);
+	struct coda_q_data *q_data;
+
+	switch (s->target) {
+	case V4L2_SEL_TGT_CROP:
+		q_data = get_q_data(ctx, V4L2_BUF_TYPE_VIDEO_OUTPUT);
+		s->r = q_data->rect;
+		break;
+	case V4L2_SEL_TGT_CROP_DEFAULT:
+	case V4L2_SEL_TGT_CROP_BOUNDS:
+		q_data = get_q_data(ctx, V4L2_BUF_TYPE_VIDEO_OUTPUT);
+		s->r.left = 0;
+		s->r.top = 0;
+		s->r.width = q_data->width;
+		s->r.height = q_data->height;
+		break;
+	case V4L2_SEL_TGT_COMPOSE:
+	case V4L2_SEL_TGT_COMPOSE_DEFAULT:
+		q_data = get_q_data(ctx, V4L2_BUF_TYPE_VIDEO_CAPTURE);
+		s->r = q_data->rect;
+		break;
+	case V4L2_SEL_TGT_COMPOSE_BOUNDS:
+	case V4L2_SEL_TGT_COMPOSE_PADDED:
+		q_data = get_q_data(ctx, V4L2_BUF_TYPE_VIDEO_CAPTURE);
+		s->r.left = 0;
+		s->r.top = 0;
+		s->r.width = q_data->width;
+		s->r.height = q_data->height;
+		break;
+	}
+
+	return 0;
+}
+
 static int coda_try_decoder_cmd(struct file *file, void *fh,
 				struct v4l2_decoder_cmd *dc)
 {
@@ -951,6 +993,8 @@ static const struct v4l2_ioctl_ops coda_ioctl_ops = {
 	.vidioc_streamon	= coda_streamon,
 	.vidioc_streamoff	= coda_streamoff,
 
+	.vidioc_g_selection	= coda_g_selection,
+
 	.vidioc_try_decoder_cmd	= coda_try_decoder_cmd,
 	.vidioc_decoder_cmd	= coda_decoder_cmd,
 
@@ -1506,6 +1550,10 @@ static void set_default_params(struct coda_ctx *ctx)
 	ctx->q_data[V4L2_M2M_DST].width = max_w;
 	ctx->q_data[V4L2_M2M_DST].height = max_h;
 	ctx->q_data[V4L2_M2M_DST].sizeimage = CODA_MAX_FRAME_SIZE;
+	ctx->q_data[V4L2_M2M_SRC].rect.width = max_w;
+	ctx->q_data[V4L2_M2M_SRC].rect.height = max_h;
+	ctx->q_data[V4L2_M2M_DST].rect.width = max_w;
+	ctx->q_data[V4L2_M2M_DST].rect.height = max_h;
 
 	if (ctx->dev->devtype->product == CODA_960)
 		coda_set_tiled_map_type(ctx, GDI_LINEAR_FRAME_MAP);
@@ -2033,6 +2081,21 @@ static int coda_start_decoding(struct coda_ctx *ctx)
 		return -EINVAL;
 	}
 
+	if (src_fourcc == V4L2_PIX_FMT_H264) {
+		u32 left_right;
+		u32 top_bottom;
+
+		left_right = coda_read(dev, CODA_RET_DEC_SEQ_CROP_LEFT_RIGHT);
+		top_bottom = coda_read(dev, CODA_RET_DEC_SEQ_CROP_TOP_BOTTOM);
+
+		q_data_dst->rect.left = (left_right >> 10) & 0x3ff;
+		q_data_dst->rect.top = (top_bottom >> 10) & 0x3ff;
+		q_data_dst->rect.width = width - q_data_dst->rect.left -
+					 (left_right & 0x3ff);
+		q_data_dst->rect.height = height - q_data_dst->rect.top -
+					  (top_bottom & 0x3ff);
+	}
+
 	ret = coda_alloc_framebuffers(ctx, q_data_dst, src_fourcc);
 	if (ret < 0)
 		return ret;
@@ -2939,6 +3002,30 @@ static void coda_finish_decode(struct coda_ctx *ctx)
 
 	q_data_dst = get_q_data(ctx, V4L2_BUF_TYPE_VIDEO_CAPTURE);
 
+	/* frame crop information */
+	if (src_fourcc == V4L2_PIX_FMT_H264) {
+		u32 left_right;
+		u32 top_bottom;
+
+		left_right = coda_read(dev, CODA_RET_DEC_PIC_CROP_LEFT_RIGHT);
+		top_bottom = coda_read(dev, CODA_RET_DEC_PIC_CROP_TOP_BOTTOM);
+
+		if (left_right == 0xffffffff && top_bottom == 0xffffffff) {
+			/* Keep current crop information */
+		} else {
+			struct v4l2_rect *rect = &q_data_dst->rect;
+
+			rect->left = left_right >> 16 & 0xffff;
+			rect->top = top_bottom >> 16 & 0xffff;
+			rect->width = width - rect->left -
+				      (left_right & 0xffff);
+			rect->height = height - rect->top -
+				       (top_bottom & 0xffff);
+		}
+	} else {
+		/* no cropping */
+	}
+
 	val = coda_read(dev, CODA_RET_DEC_PIC_ERR_MB);
 	if (val > 0)
 		v4l2_err(&dev->v4l2_dev,
-- 
2.0.0.rc2

