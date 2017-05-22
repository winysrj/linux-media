Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.4.pengutronix.de ([92.198.50.35]:53217 "EHLO
        metis.ext.4.pengutronix.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1758051AbdEVQfC (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 22 May 2017 12:35:02 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: Marek Vasut <marex@denx.de>,
        Steve Longerbeam <slongerbeam@gmail.com>,
        Hans Verkuil <hans.verkuil@cisco.com>, kernel@pengutronix.de,
        Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH] [media] coda: improve colorimetry handling
Date: Mon, 22 May 2017 18:34:48 +0200
Message-Id: <20170522163448.14210-1-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The hardware codec is not colorspace aware. We should trust userspace to
set the correct colorimetry information on the OUTPUT queue and mirror
the exact same setting on the CAPTURE queue.

There is no reason to restrict colorspace to JPEG or REC709 only. Also,
set the default colorspace, as returned by calling VIDIOC_TRY/S_FMT with
V4L2_COLORSPACE_DEFAULT, initially.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/media/platform/coda/coda-common.c | 51 ++++++++++++++++++++++---------
 drivers/media/platform/coda/coda.h        |  3 ++
 2 files changed, 39 insertions(+), 15 deletions(-)

diff --git a/drivers/media/platform/coda/coda-common.c b/drivers/media/platform/coda/coda-common.c
index d523e990d5093..506003eb9a01c 100644
--- a/drivers/media/platform/coda/coda-common.c
+++ b/drivers/media/platform/coda/coda-common.c
@@ -430,10 +430,10 @@ static int coda_g_fmt(struct file *file, void *priv,
 	f->fmt.pix.bytesperline = q_data->bytesperline;
 
 	f->fmt.pix.sizeimage	= q_data->sizeimage;
-	if (f->fmt.pix.pixelformat == V4L2_PIX_FMT_JPEG)
-		f->fmt.pix.colorspace = V4L2_COLORSPACE_JPEG;
-	else
-		f->fmt.pix.colorspace = ctx->colorspace;
+	f->fmt.pix.colorspace	= ctx->colorspace;
+	f->fmt.pix.xfer_func	= ctx->xfer_func;
+	f->fmt.pix.ycbcr_enc	= ctx->ycbcr_enc;
+	f->fmt.pix.quantization	= ctx->quantization;
 
 	return 0;
 }
@@ -599,6 +599,9 @@ static int coda_try_fmt_vid_cap(struct file *file, void *priv,
 	}
 
 	f->fmt.pix.colorspace = ctx->colorspace;
+	f->fmt.pix.xfer_func = ctx->xfer_func;
+	f->fmt.pix.ycbcr_enc = ctx->ycbcr_enc;
+	f->fmt.pix.quantization = ctx->quantization;
 
 	q_data_src = get_q_data(ctx, V4L2_BUF_TYPE_VIDEO_OUTPUT);
 	codec = coda_find_codec(ctx->dev, q_data_src->fourcc,
@@ -635,6 +638,23 @@ static int coda_try_fmt_vid_cap(struct file *file, void *priv,
 	return 0;
 }
 
+static void coda_set_default_colorspace(struct v4l2_pix_format *fmt)
+{
+	enum v4l2_colorspace colorspace;
+
+	if (fmt->pixelformat == V4L2_PIX_FMT_JPEG)
+		colorspace = V4L2_COLORSPACE_JPEG;
+	else if (fmt->width <= 720 && fmt->height <= 576)
+		colorspace = V4L2_COLORSPACE_SMPTE170M;
+	else
+		colorspace = V4L2_COLORSPACE_REC709;
+
+	fmt->colorspace = colorspace;
+	fmt->xfer_func = V4L2_XFER_FUNC_DEFAULT;
+	fmt->ycbcr_enc = V4L2_YCBCR_ENC_DEFAULT;
+	fmt->quantization = V4L2_QUANTIZATION_DEFAULT;
+}
+
 static int coda_try_fmt_vid_out(struct file *file, void *priv,
 				struct v4l2_format *f)
 {
@@ -648,16 +668,8 @@ static int coda_try_fmt_vid_out(struct file *file, void *priv,
 	if (ret < 0)
 		return ret;
 
-	switch (f->fmt.pix.colorspace) {
-	case V4L2_COLORSPACE_REC709:
-	case V4L2_COLORSPACE_JPEG:
-		break;
-	default:
-		if (f->fmt.pix.pixelformat == V4L2_PIX_FMT_JPEG)
-			f->fmt.pix.colorspace = V4L2_COLORSPACE_JPEG;
-		else
-			f->fmt.pix.colorspace = V4L2_COLORSPACE_REC709;
-	}
+	if (f->fmt.pix.colorspace == V4L2_COLORSPACE_DEFAULT)
+		coda_set_default_colorspace(&f->fmt.pix);
 
 	q_data_dst = get_q_data(ctx, V4L2_BUF_TYPE_VIDEO_CAPTURE);
 	codec = coda_find_codec(dev, f->fmt.pix.pixelformat, q_data_dst->fourcc);
@@ -772,6 +784,9 @@ static int coda_s_fmt_vid_out(struct file *file, void *priv,
 		return ret;
 
 	ctx->colorspace = f->fmt.pix.colorspace;
+	ctx->xfer_func = f->fmt.pix.xfer_func;
+	ctx->ycbcr_enc = f->fmt.pix.ycbcr_enc;
+	ctx->quantization = f->fmt.pix.quantization;
 
 	memset(&f_cap, 0, sizeof(f_cap));
 	f_cap.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
@@ -1282,7 +1297,13 @@ static void set_default_params(struct coda_ctx *ctx)
 	csize = coda_estimate_sizeimage(ctx, usize, max_w, max_h);
 
 	ctx->params.codec_mode = ctx->codec->mode;
-	ctx->colorspace = V4L2_COLORSPACE_REC709;
+	if (ctx->cvd->src_formats[0] == V4L2_PIX_FMT_JPEG)
+		ctx->colorspace = V4L2_COLORSPACE_JPEG;
+	else
+		ctx->colorspace = V4L2_COLORSPACE_REC709;
+	ctx->xfer_func = V4L2_XFER_FUNC_DEFAULT;
+	ctx->ycbcr_enc = V4L2_YCBCR_ENC_DEFAULT;
+	ctx->quantization = V4L2_QUANTIZATION_DEFAULT;
 	ctx->params.framerate = 30;
 
 	/* Default formats for output and input queues */
diff --git a/drivers/media/platform/coda/coda.h b/drivers/media/platform/coda/coda.h
index 20222befb9b2f..308116d855e6f 100644
--- a/drivers/media/platform/coda/coda.h
+++ b/drivers/media/platform/coda/coda.h
@@ -206,6 +206,9 @@ struct coda_ctx {
 	enum coda_inst_type		inst_type;
 	const struct coda_codec		*codec;
 	enum v4l2_colorspace		colorspace;
+	enum v4l2_xfer_func		xfer_func;
+	enum v4l2_ycbcr_encoding	ycbcr_enc;
+	enum v4l2_quantization		quantization;
 	struct coda_params		params;
 	struct v4l2_ctrl_handler	ctrls;
 	struct v4l2_fh			fh;
-- 
2.11.0
