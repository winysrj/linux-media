Return-Path: <SRS0=EV+/=QI=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39866C282D8
	for <linux-media@archiver.kernel.org>; Fri,  1 Feb 2019 14:19:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F383B218AC
	for <linux-media@archiver.kernel.org>; Fri,  1 Feb 2019 14:19:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1549030780;
	bh=NXulhhCvguzr9TXQbCPn2hXksTFyTMiIKd/Jm3b3+no=;
	h=From:To:Cc:Subject:Date:List-ID:From;
	b=jyKfIiMfOpWKUc6laFV3M5PpOBgOt+D+d0+imy4QS+z6QAp5LVBbA8Pn5z1qmCxJN
	 itH6FW0ogBNVMX+GKYKUpLBAjCfMu0SxOHis1kmMqw6vQkqQb1rgD4Wyk9zjF7lLys
	 KY9MBRiFaVoyI2IlV7Hml/hhx3re3TO1EYL4q3Zk=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727042AbfBAOTj (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 1 Feb 2019 09:19:39 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:52088 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725817AbfBAOTj (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 1 Feb 2019 09:19:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Sender:Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:Cc:To:From:Reply-To:Content-Type:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=ivSoliHjZWxVwS1NysO7e9tbKT+uKVwKJJqrcFCTkuU=; b=QRIH+VP1CPiTUGkcMTSqknxtS
        KqjGxzyWZuGPz2bHM3nT9qWariqIJLpDy5QbVYPVo+w2nR2/E4ZWBHH0y7I17PBVtCOcD34V4duRK
        pyKLidLOvtmeh0XZsMVC/cE7UMUuK+j/0iv3qb5ABQIaBPbtP4eIVPSvMrguX545YjLOEHrYMYU7w
        xUyHPsCwtJoEGAnMOcWn1iblAbIbhbOOQ3MD+JfA4xY6kFWlznPubVQx/Q3iayc5fMFcW2FwyWijJ
        dJbJvEo5DzCPgefTMb+pvhBqNDnBG2Md7SDXGwLbEDukUpeJxEIjWJm7cEDH+qplT8aTcr40QwBKr
        +Ocdss22Q==;
Received: from 179.187.106.61.dynamic.adsl.gvt.net.br ([179.187.106.61] helo=bombadil.infradead.org)
        by bombadil.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1gpZfN-00038D-U3; Fri, 01 Feb 2019 14:19:37 +0000
Received: from mchehab by bombadil.infradead.org with local (Exim 4.91)
        (envelope-from <mchehab@bombadil.infradead.org>)
        id 1gpYyu-0006VM-Ou; Fri, 01 Feb 2019 11:35:44 -0200
From:   Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To:     Linux Media Mailing List <linux-media@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>
Cc:     Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Ezequiel Garcia <ezequiel@collabora.com>,
        Anton Leontiev <scileont@gmail.com>,
        Tomasz Figa <tfiga@chromium.org>
Subject: [PATCH] media: vim2m: add bayer capture formats
Date:   Fri,  1 Feb 2019 11:35:43 -0200
Message-Id: <7fd6ccf110b7c167a2304ffd482e6c04252c4909.1549028130.git.mchehab+samsung@kernel.org>
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

Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
---
 drivers/media/platform/vim2m.c | 97 ++++++++++++++++++++++++++++++++--
 1 file changed, 92 insertions(+), 5 deletions(-)

diff --git a/drivers/media/platform/vim2m.c b/drivers/media/platform/vim2m.c
index e31c14c7d37f..6240878def80 100644
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
+			    u8 **src, u8 **dst, int y, bool reverse)
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
+		if (!(y & 1)) {
+			*(*dst)++ = *b;
+			*(*dst)++ = *++g;
+		} else {
+			*(*dst)++ = *g;
+			*(*dst)++ = *++r;
+		}
+		return;
+	case V4L2_PIX_FMT_SGBRG8:
+		if (!(y & 1)) {
+			*(*dst)++ = *g;
+			*(*dst)++ = *++b;
+		} else {
+			*(*dst)++ = *r;
+			*(*dst)++ = *++g;
+		}
+		return;
+	case V4L2_PIX_FMT_SGRBG8:
+		if (!(y & 1)) {
+			*(*dst)++ = *g;
+			*(*dst)++ = *++r;
+		} else {
+			*(*dst)++ = *b;
+			*(*dst)++ = *++g;
+		}
+		return;
+	case V4L2_PIX_FMT_SRGGB8:
+		if (!(y & 1)) {
+			*(*dst)++ = *r;
+			*(*dst)++ = *++g;
+		} else {
+			*(*dst)++ = *g;
+			*(*dst)++ = *++b;
+		}
+		return;
 	}
 }
 
@@ -449,7 +509,7 @@ static int device_process(struct vim2m_ctx *ctx,
 			p += bytesperline - (q_data_in->fmt->depth >> 3);
 
 		for (x = 0; x < width >> 1; x++)
-			copy_two_pixels(in, out, &p, &p_out,
+			copy_two_pixels(in, out, &p, &p_out, y,
 					ctx->mode & MEM2MEM_HFLIP);
 	}
 
@@ -562,11 +622,25 @@ static int vidioc_querycap(struct file *file, void *priv,
 
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
@@ -657,6 +731,12 @@ static int vidioc_try_fmt_vid_cap(struct file *file, void *priv,
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
@@ -669,12 +749,19 @@ static int vidioc_try_fmt_vid_out(struct file *file, void *priv,
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

