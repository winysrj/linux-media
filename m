Return-Path: <SRS0=+Qw+=RE=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B449CC4360F
	for <linux-media@archiver.kernel.org>; Fri,  1 Mar 2019 13:24:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7E937218FD
	for <linux-media@archiver.kernel.org>; Fri,  1 Mar 2019 13:24:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1551446672;
	bh=aqxXa9HRB4lZGGDq04piP2v+OHO2/STyP3mLQ4Hz030=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=RYf5ce8tIpGqjS+7+tAqZ2mwodE2AALudb0fgOxxo2TB3COeu6jF5NA6c6NeQ2mY1
	 SDv7DvW9DGUlLaoLDMR72cyJHXCRkLu5L1ZFbWC25YnzHICrPD4ISKY+pa8o1fzFp9
	 Y0gUCCy9PpAvFXccksUdIL+Zv4pg/h98ofa2A6aY=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387578AbfCANYb (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 1 Mar 2019 08:24:31 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:50508 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727052AbfCANYa (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 1 Mar 2019 08:24:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Sender:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Reply-To:Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=aoUbFgYWIgUF7eB8YKn8uiGH24UX8J/20ex9NVexCc4=; b=lnqrMiqK6Ib2bjEwPgBT+aUS7f
        Za/qdxLY2aRBQVuUmtGW57DtUNJEY0cPSAVlc8CAL+tvfvZDNoL+FNXU0Yh+IZqqtbs4ejD6Txrbf
        2aMDqRFat9YmYuy+Xh6+a1lVuPf/kHVul/MLemWMjrs5Jxubjr8QNNo0zwI8OEED8OfUMoqJ2nvvC
        wDWQbN+UgqPA1HhFx0H3SUyOwwjDGOOpTVgLOkFw2NYKFPCiqvgmDBJbDJwDIhKAUQH3Ii1KTR3cG
        D2IZvmcfUpuTc484gnH71FgzopHs7VIUdbtFinMXzf+Eb5qWWoOD/pTwfOzqp+LGSnPDuvSsJKy8u
        cApyjiQQ==;
Received: from 177.41.113.159.dynamic.adsl.gvt.net.br ([177.41.113.159] helo=bombadil.infradead.org)
        by bombadil.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1gzi9N-0003xw-Qy; Fri, 01 Mar 2019 13:24:29 +0000
Received: from mchehab by bombadil.infradead.org with local (Exim 4.92)
        (envelope-from <mchehab@bombadil.infradead.org>)
        id 1gzi9L-0002N3-O5; Fri, 01 Mar 2019 10:24:27 -0300
From:   Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To:     Linux Media Mailing List <linux-media@vger.kernel.org>
Cc:     Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Ezequiel Garcia <ezequiel@collabora.com>
Subject: [PATCH 01/10] media: vim2m: add bayer capture formats
Date:   Fri,  1 Mar 2019 10:24:17 -0300
Message-Id: <06f1340a1d2e03f5500b160c80845e0867a0d8d0.1551446121.git.mchehab+samsung@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <cover.1551446121.git.mchehab+samsung@kernel.org>
References: <cover.1551446121.git.mchehab+samsung@kernel.org>
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

