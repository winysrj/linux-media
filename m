Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud3.xs4all.net ([194.109.24.26]:34696 "EHLO
	lb2-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751398AbcGRLAZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 18 Jul 2016 07:00:25 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by tschai.lan (Postfix) with ESMTPSA id 3911E18010E
	for <linux-media@vger.kernel.org>; Mon, 18 Jul 2016 13:00:20 +0200 (CEST)
To: Linux Media Mailing List <linux-media@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH] vim2m: copy the other colorspace-related fields as well
Message-ID: <09e430e5-6cd2-102b-8762-a8d2bfc566f1@xs4all.nl>
Date: Mon, 18 Jul 2016 13:00:20 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The xfer_func, ycbcr_enc and quantization fields should also be copied from
output to capture format.

Since this driver serves as example code it is important that this is handled
correctly.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>

diff --git a/drivers/media/platform/vim2m.c b/drivers/media/platform/vim2m.c
index 6b17015..cd0ff4a 100644
--- a/drivers/media/platform/vim2m.c
+++ b/drivers/media/platform/vim2m.c
@@ -171,6 +171,9 @@ struct vim2m_ctx {
 	int			mode;

 	enum v4l2_colorspace	colorspace;
+	enum v4l2_ycbcr_encoding ycbcr_enc;
+	enum v4l2_xfer_func	xfer_func;
+	enum v4l2_quantization	quant;

 	/* Source and destination queue data */
 	struct vim2m_q_data   q_data[2];
@@ -493,6 +496,9 @@ static int vidioc_g_fmt(struct vim2m_ctx *ctx, struct v4l2_format *f)
 	f->fmt.pix.bytesperline	= (q_data->width * q_data->fmt->depth) >> 3;
 	f->fmt.pix.sizeimage	= q_data->sizeimage;
 	f->fmt.pix.colorspace	= ctx->colorspace;
+	f->fmt.pix.xfer_func	= ctx->xfer_func;
+	f->fmt.pix.ycbcr_enc	= ctx->ycbcr_enc;
+	f->fmt.pix.quantization	= ctx->quant;

 	return 0;
 }
@@ -549,6 +555,9 @@ static int vidioc_try_fmt_vid_cap(struct file *file, void *priv,
 		return -EINVAL;
 	}
 	f->fmt.pix.colorspace = ctx->colorspace;
+	f->fmt.pix.xfer_func = ctx->xfer_func;
+	f->fmt.pix.ycbcr_enc = ctx->ycbcr_enc;
+	f->fmt.pix.quantization = ctx->quant;

 	return vidioc_try_fmt(f, fmt);
 }
@@ -630,8 +639,12 @@ static int vidioc_s_fmt_vid_out(struct file *file, void *priv,
 		return ret;

 	ret = vidioc_s_fmt(file2ctx(file), f);
-	if (!ret)
+	if (!ret) {
 		ctx->colorspace = f->fmt.pix.colorspace;
+		ctx->xfer_func = f->fmt.pix.xfer_func;
+		ctx->ycbcr_enc = f->fmt.pix.ycbcr_enc;
+		ctx->quant = f->fmt.pix.quantization;
+	}
 	return ret;
 }

