Return-Path: <SRS0=OvUS=QF=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE628C282C7
	for <linux-media@archiver.kernel.org>; Tue, 29 Jan 2019 16:00:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7C46621852
	for <linux-media@archiver.kernel.org>; Tue, 29 Jan 2019 16:00:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1548777629;
	bh=80hEpeGQ0Np4eYfJ7Jpx6E2FKTxG7WTlVf4lhDcJtjs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=K0Qkwsw/NVvZt4kfg5nmNdPsU2ClTSp+Kp1DwOHBuEB9z58FLUm04dGxuM+hRlk+E
	 AME7LsobFbVVzYNQ8ESwSKsYzqpJYGyY4EToc3vlvoj8TuSrBg62hLvwN/i99HplJs
	 faNseEAXubLDgTwaFsmkbJGR1bDK+FyiH8rc/j3Q=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727299AbfA2QA2 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 29 Jan 2019 11:00:28 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:53880 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726298AbfA2QA1 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 29 Jan 2019 11:00:27 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Sender:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Reply-To:Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=MmO116YSY43u3JuMDwQHaXqu0FMK2mvLPKKeT4bAye0=; b=rXZgT+gefwHfr2a6M7WPopYfcP
        shu8fw5rT4xbHIKc5OnaERPCKp5MI2NsCz0IF9TYXvFQUEpS2vDou1ZNp0qKwAHSxpPQl2x2yMsg5
        OybBinCdCgqR4PwoIj+e5lNgDhbz0CD8ihrFvWTA0sqXiM72qPn/Z3klxbvIu9pKcjMdL9kTAqqYS
        mXOLDha+bGBkRY39LDpSMWBuOn36E2HTcB7WzkArqBCNLZ8Vi8mj3+O7Q1rvIF3O3UH8ULwf/K+Eh
        U3goEdFm8Fij4XE6+EapC3eq273ns9yxQEWLJaX8Hoq3Oym1uNNXVRq9w1NFufGhlKihE/fk14T0z
        4IlwIUlg==;
Received: from 177.43.31.175.dynamic.adsl.gvt.net.br ([177.43.31.175] helo=bombadil.infradead.org)
        by bombadil.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1goVoI-0006o6-Mf; Tue, 29 Jan 2019 16:00:27 +0000
Received: from mchehab by bombadil.infradead.org with local (Exim 4.91)
        (envelope-from <mchehab@bombadil.infradead.org>)
        id 1goVoD-0006UN-A8; Tue, 29 Jan 2019 14:00:21 -0200
From:   Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To:     Linux Media Mailing List <linux-media@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>
Cc:     Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Ezequiel Garcia <ezequiel@collabora.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Tomasz Figa <tfiga@chromium.org>,
        Anton Leontiev <scileont@gmail.com>
Subject: [PATCH 1/3] media: vim2m: fix driver for it to handle different fourcc formats
Date:   Tue, 29 Jan 2019 14:00:15 -0200
Message-Id: <37cc686c2cce58142a5c36c6e66e2b74b907bd61.1548776693.git.mchehab+samsung@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <cover.1548776693.git.mchehab+samsung@kernel.org>
References: <cover.1548776693.git.mchehab+samsung@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Despite vim2m is reporting that it supports RGB565BE and YUYV,
that's not true.

Right now, it just says that it supports both format, but it
doesn't actually support them.

Also, horizontal flip is not properly implemented. It sounds
that it was designed to do a pseudo-horizontal flip using 8
tiles. Yet, as it doesn't do format conversion, the result
is a mess.

I suspect that it was done this way in order to save CPU time,
at the time of OMAP2 days.

That's messy and doesn't really help if someone wants to
use vim2m to test a pipeline.

Worse than that, the unique RGB format it says it supports is
RGB565BE, with is not supported by Gstreamer. That prevents
practical usage of it, even for tests.

So, instead, properly implement fourcc format conversions,
adding a few more RGB formats:

	- RGB and BGR with 24 bits
	- RGB565LE (known as RGB16 at gstreamer)

Also allows using any of the 5 supported formats as either
capture or output.

Note: The YUYV conversion routines are based on the conversion code
written by Hans de Goede inside libv4lconvert (part of v4l-utils),
released under LGPGL 2.1 (GPL 2.0 compatible).

Tested all possible format combinations except for RGB565BE,
as Gstreamer currently doesn't support it.

Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
---
 drivers/media/platform/vim2m.c | 380 +++++++++++++++++++++------------
 1 file changed, 240 insertions(+), 140 deletions(-)

diff --git a/drivers/media/platform/vim2m.c b/drivers/media/platform/vim2m.c
index a7a152fb3075..ccd0576c766e 100644
--- a/drivers/media/platform/vim2m.c
+++ b/drivers/media/platform/vim2m.c
@@ -60,8 +60,6 @@ MODULE_PARM_DESC(debug, "activates debug info");
 
 /* Default transaction time in msec */
 #define MEM2MEM_DEF_TRANSTIME	40
-#define MEM2MEM_COLOR_STEP	(0xff >> 4)
-#define MEM2MEM_NUM_TILES	8
 
 /* Flags that indicate processing mode */
 #define MEM2MEM_HFLIP	(1 << 0)
@@ -82,22 +80,24 @@ static struct platform_device vim2m_pdev = {
 struct vim2m_fmt {
 	u32	fourcc;
 	int	depth;
-	/* Types the format can be used for */
-	u32	types;
 };
 
 static struct vim2m_fmt formats[] = {
 	{
-		.fourcc	= V4L2_PIX_FMT_RGB565X, /* rrrrrggg gggbbbbb */
+		.fourcc	= V4L2_PIX_FMT_RGB565,  /* rrrrrggg gggbbbbb */
 		.depth	= 16,
-		/* Both capture and output format */
-		.types	= MEM2MEM_CAPTURE | MEM2MEM_OUTPUT,
-	},
-	{
+	}, {
+		.fourcc	= V4L2_PIX_FMT_RGB565X, /* gggbbbbb rrrrrggg */
+		.depth	= 16,
+	}, {
+		.fourcc	= V4L2_PIX_FMT_RGB24,
+		.depth	= 24,
+	}, {
+		.fourcc	= V4L2_PIX_FMT_BGR24,
+		.depth	= 24,
+	}, {
 		.fourcc	= V4L2_PIX_FMT_YUYV,
 		.depth	= 16,
-		/* Output-only format */
-		.types	= MEM2MEM_OUTPUT,
 	},
 };
 
@@ -201,23 +201,222 @@ static struct vim2m_q_data *get_q_data(struct vim2m_ctx *ctx,
 	return NULL;
 }
 
+#define CLIP(color) \
+	(u8)(((color) > 0xFF) ? 0xff : (((color) < 0) ? 0 : (color)))
+
+static void copy_two_pixels(struct vim2m_fmt *in, struct vim2m_fmt *out,
+			    u8 **src, u8 **dst, bool reverse)
+{
+	u8 _r[2], _g[2], _b[2], *r, *g, *b;
+	int i, step;
+
+	// If format is the same just copy the data, respecting the width
+	if (in->fourcc == out->fourcc) {
+		int depth = out->depth >> 3;
+
+		if (reverse) {
+			if (in->fourcc == V4L2_PIX_FMT_YUYV) {
+				int u, v, y, y1;
+
+				*src -= 2;
+
+				y1 = (*src)[0]; /* copy as second point */
+				u  = (*src)[1];
+				y  = (*src)[2]; /* copy as first point */
+				v  = (*src)[3];
+
+				*src -= 2;
+
+				*(*dst)++ = y;
+				*(*dst)++ = u;
+				*(*dst)++ = y1;
+				*(*dst)++ = v;
+				return;
+			}
+
+			memcpy(*dst, *src, depth);
+			memcpy(*dst + depth, *src - depth, depth);
+			*src -= depth << 1;
+		} else {
+			memcpy(*dst, *src, depth << 1);
+			*src += depth << 1;
+		}
+		*dst += depth << 1;
+		return;
+	}
+
+	/* Step 1: read two consecutive pixels from src pointer */
+
+	r = _r;
+	g = _g;
+	b = _b;
+
+	if (reverse)
+		step = -1;
+	else
+		step = 1;
+
+	switch (in->fourcc) {
+	case V4L2_PIX_FMT_RGB565: /* rrrrrggg gggbbbbb */
+		for (i = 0; i < 2; i++) {
+			u16 pix = *(u16 *)*src;
+
+			*r++ = (u8)(((pix & 0xf800) >> 11) << 3) | 0x07;
+			*g++ = (u8)((((pix & 0x07e0) >> 5)) << 2) | 0x03;
+			*b++ = (u8)((pix & 0x1f) << 3) | 0x07;
+
+			*src += step << 1;
+		}
+		break;
+	case V4L2_PIX_FMT_RGB565X: /* gggbbbbb rrrrrggg */
+		for (i = 0; i < 2; i++) {
+			u16 pix = *(u16 *)*src;
+
+			*r++ = (u8)(((0x00f8 & pix) >> 3) << 3) | 0x07;
+			*g++ = (u8)(((pix & 0x7) << 2) |
+				    ((pix & 0xe000) >> 5)) | 0x03;
+			*b++ = (u8)(((pix & 0x1f00) >> 8) << 3) | 0x07;
+
+			*src += step << 1;
+		}
+		break;
+	case V4L2_PIX_FMT_RGB24:
+		for (i = 0; i < 2; i++) {
+			*r++ = (*src)[0];
+			*g++ = (*src)[1];
+			*b++ = (*src)[2];
+
+			*src += step * 3;
+		}
+		break;
+	case V4L2_PIX_FMT_BGR24:
+		for (i = 0; i < 2; i++) {
+			*b++ = (*src)[0];
+			*g++ = (*src)[1];
+			*r++ = (*src)[2];
+
+			*src += step * 3;
+		}
+		break;
+	default: /* V4L2_PIX_FMT_YUYV */
+	{
+		int u, v, y, y1, u1, v1, tmp;
+
+		if (reverse) {
+			*src -= 2;
+
+			y1 = (*src)[0]; /* copy as second point */
+			u  = (*src)[1];
+			y  = (*src)[2]; /* copy as first point */
+			v  = (*src)[3];
+
+			*src -= 2;
+		} else {
+			y  = *(*src)++;
+			u  = *(*src)++;
+			y1 = *(*src)++;
+			v  = *(*src)++;
+		}
+
+		u1 = (((u - 128) << 7) +  (u - 128)) >> 6;
+		tmp = (((u - 128) << 1) + (u - 128) +
+		       ((v - 128) << 2) + ((v - 128) << 1)) >> 3;
+		v1 = (((v - 128) << 1) +  (v - 128)) >> 1;
+
+		*r++ = CLIP(y + v1);
+		*g++ = CLIP(y - tmp);
+		*b++ = CLIP(y + u1);
+
+		*r = CLIP(y1 + v1);
+		*g = CLIP(y1 - tmp);
+		*b = CLIP(y1 + u1);
+		break;
+	}
+	}
+
+	/* Step 2: store two consecutive points, reversing them if needed */
+
+	r = _r;
+	g = _g;
+	b = _b;
+
+	switch (out->fourcc) {
+	case V4L2_PIX_FMT_RGB565: /* rrrrrggg gggbbbbb */
+		for (i = 0; i < 2; i++) {
+			u16 *pix = (u16 *) *dst;
+
+			*pix = ((*r << 8) & 0xf800) | ((*g << 3) & 0x07e0) |
+			       (*b >> 3);
+
+			*dst += 2;
+		}
+		return;
+	case V4L2_PIX_FMT_RGB565X: /* gggbbbbb rrrrrggg */
+		for (i = 0; i < 2; i++) {
+			u16 *pix = (u16 *) *dst;
+			u8 green = *g++ >> 2;
+
+			*pix = ((green << 8) & 0xe000) | (green & 0x07) |
+			       ((*b++ << 5) & 0x1f00) | ((*r++ & 0xf8));
+
+			*dst += 2;
+		}
+		return;
+	case V4L2_PIX_FMT_RGB24:
+		for (i = 0; i < 2; i++) {
+			*(*dst)++ = *r++;
+			*(*dst)++ = *g++;
+			*(*dst)++ = *b++;
+		}
+		return;
+	case V4L2_PIX_FMT_BGR24:
+		for (i = 0; i < 2; i++) {
+			*(*dst)++ = *b++;
+			*(*dst)++ = *g++;
+			*(*dst)++ = *r++;
+		}
+		return;
+	default: /* V4L2_PIX_FMT_YUYV */
+	{
+		u8 y, y1, u, v;
+
+		y = ((8453  * (*r) + 16594 * (*g) +  3223 * (*b)
+		     + 524288) >> 15);
+		u = ((-4878 * (*r) - 9578  * (*g) + 14456 * (*b)
+		     + 4210688) >> 15);
+		v = ((14456 * (*r++) - 12105 * (*g++) - 2351 * (*b++)
+		     + 4210688) >> 15);
+		y1 = ((8453 * (*r) + 16594 * (*g) +  3223 * (*b)
+		     + 524288) >> 15);
+
+		*(*dst)++ = y;
+		*(*dst)++ = u;
+
+		*(*dst)++ = y1;
+		*(*dst)++ = v;
+		return;
+	}
+	}
+}
 
 static int device_process(struct vim2m_ctx *ctx,
 			  struct vb2_v4l2_buffer *in_vb,
 			  struct vb2_v4l2_buffer *out_vb)
 {
 	struct vim2m_dev *dev = ctx->dev;
-	struct vim2m_q_data *q_data;
-	u8 *p_in, *p_out;
-	int x, y, t, w;
-	int tile_w, bytes_left;
-	int width, height, bytesperline;
+	struct vim2m_q_data *q_data_in, *q_data_out;
+	u8 *p_in, *p, *p_out;
+	int width, height, bytesperline, x, y, start, end, step;
+	struct vim2m_fmt *in, *out;
 
-	q_data = get_q_data(ctx, V4L2_BUF_TYPE_VIDEO_OUTPUT);
+	q_data_in = get_q_data(ctx, V4L2_BUF_TYPE_VIDEO_OUTPUT);
+	in = q_data_in->fmt;
+	width = q_data_in->width;
+	height = q_data_in->height;
+	bytesperline = (q_data_in->width * q_data_in->fmt->depth) >> 3;
 
-	width	= q_data->width;
-	height	= q_data->height;
-	bytesperline	= (q_data->width * q_data->fmt->depth) >> 3;
+	q_data_out = get_q_data(ctx, V4L2_BUF_TYPE_VIDEO_CAPTURE);
+	out = q_data_out->fmt;
 
 	p_in = vb2_plane_vaddr(&in_vb->vb2_buf, 0);
 	p_out = vb2_plane_vaddr(&out_vb->vb2_buf, 0);
@@ -227,100 +426,28 @@ static int device_process(struct vim2m_ctx *ctx,
 		return -EFAULT;
 	}
 
-	if (vb2_plane_size(&in_vb->vb2_buf, 0) >
-			vb2_plane_size(&out_vb->vb2_buf, 0)) {
-		v4l2_err(&dev->v4l2_dev, "Output buffer is too small\n");
-		return -EINVAL;
-	}
-
-	tile_w = (width * (q_data[V4L2_M2M_DST].fmt->depth >> 3))
-		/ MEM2MEM_NUM_TILES;
-	bytes_left = bytesperline - tile_w * MEM2MEM_NUM_TILES;
-	w = 0;
-
-	out_vb->sequence =
-		get_q_data(ctx, V4L2_BUF_TYPE_VIDEO_CAPTURE)->sequence++;
-	in_vb->sequence = q_data->sequence++;
+	out_vb->sequence = get_q_data(ctx,
+				      V4L2_BUF_TYPE_VIDEO_CAPTURE)->sequence++;
+	in_vb->sequence = q_data_in->sequence++;
 	v4l2_m2m_buf_copy_data(in_vb, out_vb, true);
 
-	switch (ctx->mode) {
-	case MEM2MEM_HFLIP | MEM2MEM_VFLIP:
-		p_out += bytesperline * height - bytes_left;
-		for (y = 0; y < height; ++y) {
-			for (t = 0; t < MEM2MEM_NUM_TILES; ++t) {
-				if (w & 0x1) {
-					for (x = 0; x < tile_w; ++x)
-						*--p_out = *p_in++ +
-							MEM2MEM_COLOR_STEP;
-				} else {
-					for (x = 0; x < tile_w; ++x)
-						*--p_out = *p_in++ -
-							MEM2MEM_COLOR_STEP;
-				}
-				++w;
-			}
-			p_in += bytes_left;
-			p_out -= bytes_left;
-		}
-		break;
+	if (ctx->mode & MEM2MEM_VFLIP) {
+		start = height - 1;
+		end = -1;
+		step = -1;
+	} else {
+		start = 0;
+		end = height;
+		step = 1;
+	}
+	for (y = start; y != end; y += step) {
+		p = p_in + (y * bytesperline);
+		if (ctx->mode & MEM2MEM_HFLIP)
+			p += bytesperline - (q_data_in->fmt->depth >> 3);
 
-	case MEM2MEM_HFLIP:
-		for (y = 0; y < height; ++y) {
-			p_out += MEM2MEM_NUM_TILES * tile_w;
-			for (t = 0; t < MEM2MEM_NUM_TILES; ++t) {
-				if (w & 0x01) {
-					for (x = 0; x < tile_w; ++x)
-						*--p_out = *p_in++ +
-							MEM2MEM_COLOR_STEP;
-				} else {
-					for (x = 0; x < tile_w; ++x)
-						*--p_out = *p_in++ -
-							MEM2MEM_COLOR_STEP;
-				}
-				++w;
-			}
-			p_in += bytes_left;
-			p_out += bytesperline;
-		}
-		break;
-
-	case MEM2MEM_VFLIP:
-		p_out += bytesperline * (height - 1);
-		for (y = 0; y < height; ++y) {
-			for (t = 0; t < MEM2MEM_NUM_TILES; ++t) {
-				if (w & 0x1) {
-					for (x = 0; x < tile_w; ++x)
-						*p_out++ = *p_in++ +
-							MEM2MEM_COLOR_STEP;
-				} else {
-					for (x = 0; x < tile_w; ++x)
-						*p_out++ = *p_in++ -
-							MEM2MEM_COLOR_STEP;
-				}
-				++w;
-			}
-			p_in += bytes_left;
-			p_out += bytes_left - 2 * bytesperline;
-		}
-		break;
-
-	default:
-		for (y = 0; y < height; ++y) {
-			for (t = 0; t < MEM2MEM_NUM_TILES; ++t) {
-				if (w & 0x1) {
-					for (x = 0; x < tile_w; ++x)
-						*p_out++ = *p_in++ +
-							MEM2MEM_COLOR_STEP;
-				} else {
-					for (x = 0; x < tile_w; ++x)
-						*p_out++ = *p_in++ -
-							MEM2MEM_COLOR_STEP;
-				}
-				++w;
-			}
-			p_in += bytes_left;
-			p_out += bytes_left;
-		}
+		for (x = 0; x < width >> 1; x++)
+			copy_two_pixels(in, out, &p, &p_out,
+					ctx->mode & MEM2MEM_HFLIP);
 	}
 
 	return 0;
@@ -433,25 +560,11 @@ static int vidioc_querycap(struct file *file, void *priv,
 
 static int enum_fmt(struct v4l2_fmtdesc *f, u32 type)
 {
-	int i, num;
 	struct vim2m_fmt *fmt;
 
-	num = 0;
-
-	for (i = 0; i < NUM_FORMATS; ++i) {
-		if (formats[i].types & type) {
-			/* index-th format of type type found ? */
-			if (num == f->index)
-				break;
-			/* Correct type but haven't reached our index yet,
-			 * just increment per-type index */
-			++num;
-		}
-	}
-
-	if (i < NUM_FORMATS) {
+	if (f->index < NUM_FORMATS) {
 		/* Format found */
-		fmt = &formats[i];
+		fmt = &formats[f->index];
 		f->pixelformat = fmt->fourcc;
 		return 0;
 	}
@@ -542,12 +655,6 @@ static int vidioc_try_fmt_vid_cap(struct file *file, void *priv,
 		f->fmt.pix.pixelformat = formats[0].fourcc;
 		fmt = find_format(f);
 	}
-	if (!(fmt->types & MEM2MEM_CAPTURE)) {
-		v4l2_err(&ctx->dev->v4l2_dev,
-			 "Fourcc format (0x%08x) invalid.\n",
-			 f->fmt.pix.pixelformat);
-		return -EINVAL;
-	}
 	f->fmt.pix.colorspace = ctx->colorspace;
 	f->fmt.pix.xfer_func = ctx->xfer_func;
 	f->fmt.pix.ycbcr_enc = ctx->ycbcr_enc;
@@ -560,19 +667,12 @@ static int vidioc_try_fmt_vid_out(struct file *file, void *priv,
 				  struct v4l2_format *f)
 {
 	struct vim2m_fmt *fmt;
-	struct vim2m_ctx *ctx = file2ctx(file);
 
 	fmt = find_format(f);
 	if (!fmt) {
 		f->fmt.pix.pixelformat = formats[0].fourcc;
 		fmt = find_format(f);
 	}
-	if (!(fmt->types & MEM2MEM_OUTPUT)) {
-		v4l2_err(&ctx->dev->v4l2_dev,
-			 "Fourcc format (0x%08x) invalid.\n",
-			 f->fmt.pix.pixelformat);
-		return -EINVAL;
-	}
 	if (!f->fmt.pix.colorspace)
 		f->fmt.pix.colorspace = V4L2_COLORSPACE_REC709;
 
-- 
2.20.1

