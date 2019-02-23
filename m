Return-Path: <SRS0=tcVs=Q6=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.2 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25A80C43381
	for <linux-media@archiver.kernel.org>; Sat, 23 Feb 2019 12:16:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D5605206BA
	for <linux-media@archiver.kernel.org>; Sat, 23 Feb 2019 12:16:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1550924182;
	bh=1xdgsfDJJQHUDzOE2vw39H9X8aQ0VvQwUUd0FqGf5JM=;
	h=From:To:Cc:Subject:Date:List-ID:From;
	b=bn66tnysCBX31QM0faFj6Caf8UEf0VTCt3djybcL6zGcqrHK4My51m8j8IBwthIjx
	 Ca7nvqecGE1YvKaco4ElP2qQYWxknVwaE9tUbYVMSccR6vdK9ZgVGER165KOYgQJCC
	 VFNq1yGzQkqXwsmp08MpAQlpF+QkTgHB0TaD762c=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727773AbfBWMQV (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Sat, 23 Feb 2019 07:16:21 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:57466 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726269AbfBWMQU (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 23 Feb 2019 07:16:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Sender:Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:Cc:To:From:Reply-To:Content-Type:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=l/CkGaTJdNgiMUIpjkj9fxk5dW9kDEAqczGy6ilCCTk=; b=HIJYisae+iGhzFgOpYoMSMKp/
        t+1Qsw19lNb7UxlGa/SkUcP4Vapwq0gAojXZRHOLN8y9gIxkrusEooYfhPJu2gmsgbbQdQrT3rpHB
        CnfegJD5M4GTdomRADjCz7+Tp16RudRedLwGkdtDT6wMqpHJdHZO7hJk67R+9MWNLa1z1C79bOrZy
        st8SBc9nEZyVsjIhV0ERwuXDDNEGnTJ+4tW5EGchqJYme3bUjId/Cg2DwP7eHuRZEy8g2c8CkObAu
        f+wqgtekWm8yN75VkHCTxYJGyzPZwWEtV0iHC9ha2CbAvZTJe1HCP0/+AZ8hiRevlDzZK/X/2jfTw
        KVQXHmH9Q==;
Received: from [179.95.8.21] (helo=bombadil.infradead.org)
        by bombadil.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1gxWE6-00075U-LE; Sat, 23 Feb 2019 12:16:18 +0000
Received: from mchehab by bombadil.infradead.org with local (Exim 4.92)
        (envelope-from <mchehab@bombadil.infradead.org>)
        id 1gxWE3-0005YF-F3; Sat, 23 Feb 2019 09:16:15 -0300
From:   Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To:     Linux Media Mailing List <linux-media@vger.kernel.org>
Cc:     Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Ezequiel Garcia <ezequiel@collabora.com>
Subject: [PATCH] media: vim2m: add bayer capture formats
Date:   Sat, 23 Feb 2019 09:16:14 -0300
Message-Id: <7b07e2a4574837d45f44889d2c9d2f98936a93c0.1550923944.git.mchehab+samsung@kernel.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

The vim2m device is interesting to simulate a webcam. As most
sensors are arranged using bayer formats, the best is to support
to output data using those formats.

So, add support for them.

All 4 8-bit bayer formats tested with:

	$ qvidcap -p &
	$ v4l2-ctl --stream-mmap --stream-out-mmap --stream-to-host localhost --stream-lossless --stream-out-hor-speed 1 -v pixelformat=RGGB

It was tested also with GStreamer with:

	$ gst-validate-1.0 filesrc location=some_video.mp4 ! qtdemux ! avdec_h264 ! videoconvert ! videoscale ! v4l2convert disable-passthrough=1 extra-controls="s,horizontal_flip=0,vertical_flip=0" ! bayer2rgb ! videoconvert ! xvimagesink

For all possible HFLIP/VFLIP values.

Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
---

In order to be able to test it with GStreamer, the gst-plugins-good should be
compiled with --enable-v4l2-probe.

Also, two patches from my tree are needed:
	https://github.com/mchehab/gst-plugins-good/commits/master

The first one considers Bayer formats as possible formats for codecs and M2M devices.
    https://github.com/mchehab/gst-plugins-good/commit/6b15e127219a82551a75de039dba0cc358575d4b
The second one fixes a bug at the logic with handles with transform caps.
The logic there should be inverted, as expected by gst base plugin transform_caps
method.
    https://github.com/mchehab/gst-plugins-good/commit/701349eb3058682dc854837537119fbe7a5dfbae

 drivers/media/platform/vim2m.c | 102 ++++++++++++++++++++++++++++++---
 1 file changed, 95 insertions(+), 7 deletions(-)

diff --git a/drivers/media/platform/vim2m.c b/drivers/media/platform/vim2m.c
index a27d3052bb62..d95a905bdfc5 100644
--- a/drivers/media/platform/vim2m.c
+++ b/drivers/media/platform/vim2m.c
@@ -82,24 +82,47 @@ static struct platform_device vim2m_pdev = {
 struct vim2m_fmt {
 	u32	fourcc;
 	int	depth;
+	/* Types the format can be used for */
+	u32     types;
 };
 
 static struct vim2m_fmt formats[] = {
 	{
 		.fourcc	= V4L2_PIX_FMT_RGB565,  /* rrrrrggg gggbbbbb */
 		.depth	= 16,
+		.types  = MEM2MEM_CAPTURE | MEM2MEM_OUTPUT,
 	}, {
 		.fourcc	= V4L2_PIX_FMT_RGB565X, /* gggbbbbb rrrrrggg */
 		.depth	= 16,
+		.types  = MEM2MEM_CAPTURE | MEM2MEM_OUTPUT,
 	}, {
 		.fourcc	= V4L2_PIX_FMT_RGB24,
 		.depth	= 24,
+		.types  = MEM2MEM_CAPTURE | MEM2MEM_OUTPUT,
 	}, {
 		.fourcc	= V4L2_PIX_FMT_BGR24,
 		.depth	= 24,
+		.types  = MEM2MEM_CAPTURE | MEM2MEM_OUTPUT,
 	}, {
 		.fourcc	= V4L2_PIX_FMT_YUYV,
 		.depth	= 16,
+		.types  = MEM2MEM_CAPTURE | MEM2MEM_OUTPUT,
+	}, {
+		.fourcc	= V4L2_PIX_FMT_SBGGR8,
+		.depth	= 8,
+		.types  = MEM2MEM_CAPTURE,
+	}, {
+		.fourcc	= V4L2_PIX_FMT_SGBRG8,
+		.depth	= 8,
+		.types  = MEM2MEM_CAPTURE,
+	}, {
+		.fourcc	= V4L2_PIX_FMT_SGRBG8,
+		.depth	= 8,
+		.types  = MEM2MEM_CAPTURE,
+	}, {
+		.fourcc	= V4L2_PIX_FMT_SRGGB8,
+		.depth	= 8,
+		.types  = MEM2MEM_CAPTURE,
 	},
 };
 
@@ -208,7 +231,7 @@ static struct vim2m_q_data *get_q_data(struct vim2m_ctx *ctx,
 	(u8)(((__color) > 0xff) ? 0xff : (((__color) < 0) ? 0 : (__color)))
 
 static void copy_two_pixels(struct vim2m_fmt *in, struct vim2m_fmt *out,
-			    u8 **src, u8 **dst, bool reverse)
+			    u8 **src, u8 **dst, int ypos, bool reverse)
 {
 	u8 _r[2], _g[2], _b[2], *r, *g, *b;
 	int i, step;
@@ -379,7 +402,8 @@ static void copy_two_pixels(struct vim2m_fmt *in, struct vim2m_fmt *out,
 			*(*dst)++ = *r++;
 		}
 		return;
-	default: /* V4L2_PIX_FMT_YUYV */
+	case V4L2_PIX_FMT_YUYV:
+	default:
 	{
 		u8 y, y1, u, v;
 
@@ -399,6 +423,42 @@ static void copy_two_pixels(struct vim2m_fmt *in, struct vim2m_fmt *out,
 		*(*dst)++ = v;
 		return;
 	}
+	case V4L2_PIX_FMT_SBGGR8:
+		if (!(ypos & 1)) {
+			*(*dst)++ = *b;
+			*(*dst)++ = *++g;
+		} else {
+			*(*dst)++ = *g;
+			*(*dst)++ = *++r;
+		}
+		return;
+	case V4L2_PIX_FMT_SGBRG8:
+		if (!(ypos & 1)) {
+			*(*dst)++ = *g;
+			*(*dst)++ = *++b;
+		} else {
+			*(*dst)++ = *r;
+			*(*dst)++ = *++g;
+		}
+		return;
+	case V4L2_PIX_FMT_SGRBG8:
+		if (!(ypos & 1)) {
+			*(*dst)++ = *g;
+			*(*dst)++ = *++r;
+		} else {
+			*(*dst)++ = *b;
+			*(*dst)++ = *++g;
+		}
+		return;
+	case V4L2_PIX_FMT_SRGGB8:
+		if (!(ypos & 1)) {
+			*(*dst)++ = *r;
+			*(*dst)++ = *++g;
+		} else {
+			*(*dst)++ = *g;
+			*(*dst)++ = *++b;
+		}
+		return;
 	}
 }
 
@@ -409,7 +469,7 @@ static int device_process(struct vim2m_ctx *ctx,
 	struct vim2m_dev *dev = ctx->dev;
 	struct vim2m_q_data *q_data_in, *q_data_out;
 	u8 *p_in, *p, *p_out;
-	int width, height, bytesperline, x, y, start, end, step;
+	int width, height, bytesperline, x, y, y_out, start, end, step;
 	struct vim2m_fmt *in, *out;
 
 	q_data_in = get_q_data(ctx, V4L2_BUF_TYPE_VIDEO_OUTPUT);
@@ -443,13 +503,14 @@ static int device_process(struct vim2m_ctx *ctx,
 		end = height;
 		step = 1;
 	}
-	for (y = start; y != end; y += step) {
+	y_out = 0;
+	for (y = start; y != end; y += step, y_out++) {
 		p = p_in + (y * bytesperline);
 		if (ctx->mode & MEM2MEM_HFLIP)
 			p += bytesperline - (q_data_in->fmt->depth >> 3);
 
 		for (x = 0; x < width >> 1; x++)
-			copy_two_pixels(in, out, &p, &p_out,
+			copy_two_pixels(in, out, &p, &p_out, y_out,
 					ctx->mode & MEM2MEM_HFLIP);
 	}
 
@@ -563,11 +624,25 @@ static int vidioc_querycap(struct file *file, void *priv,
 
 static int enum_fmt(struct v4l2_fmtdesc *f, u32 type)
 {
+	int i, num;
 	struct vim2m_fmt *fmt;
 
-	if (f->index < NUM_FORMATS) {
+	num = 0;
+
+	for (i = 0; i < NUM_FORMATS; ++i) {
+		if (formats[i].types & type) {
+			/* index-th format of type type found ? */
+			if (num == f->index)
+				break;
+			/* Correct type but haven't reached our index yet,
+			 * just increment per-type index */
+			++num;
+		}
+	}
+
+	if (i < NUM_FORMATS) {
 		/* Format found */
-		fmt = &formats[f->index];
+		fmt = &formats[i];
 		f->pixelformat = fmt->fourcc;
 		return 0;
 	}
@@ -658,6 +733,12 @@ static int vidioc_try_fmt_vid_cap(struct file *file, void *priv,
 		f->fmt.pix.pixelformat = formats[0].fourcc;
 		fmt = find_format(f);
 	}
+	if (!(fmt->types & MEM2MEM_CAPTURE)) {
+		v4l2_err(&ctx->dev->v4l2_dev,
+			 "Fourcc format (0x%08x) invalid.\n",
+			 f->fmt.pix.pixelformat);
+		return -EINVAL;
+	}
 	f->fmt.pix.colorspace = ctx->colorspace;
 	f->fmt.pix.xfer_func = ctx->xfer_func;
 	f->fmt.pix.ycbcr_enc = ctx->ycbcr_enc;
@@ -670,12 +751,19 @@ static int vidioc_try_fmt_vid_out(struct file *file, void *priv,
 				  struct v4l2_format *f)
 {
 	struct vim2m_fmt *fmt;
+	struct vim2m_ctx *ctx = file2ctx(file);
 
 	fmt = find_format(f);
 	if (!fmt) {
 		f->fmt.pix.pixelformat = formats[0].fourcc;
 		fmt = find_format(f);
 	}
+	if (!(fmt->types & MEM2MEM_OUTPUT)) {
+		v4l2_err(&ctx->dev->v4l2_dev,
+			 "Fourcc format (0x%08x) invalid.\n",
+			 f->fmt.pix.pixelformat);
+		return -EINVAL;
+	}
 	if (!f->fmt.pix.colorspace)
 		f->fmt.pix.colorspace = V4L2_COLORSPACE_REC709;
 
-- 
2.20.1


