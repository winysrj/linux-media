Return-Path: <SRS0=+Qw+=RE=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 097BBC4360F
	for <linux-media@archiver.kernel.org>; Fri,  1 Mar 2019 13:24:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C7F522085A
	for <linux-media@archiver.kernel.org>; Fri,  1 Mar 2019 13:24:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1551446675;
	bh=1OjGx7ZX8XzXjFj2+0UyYCZAQKY3hmPW+RiPMx9WfWA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=V19Hzu8DehAOVJ37t818AgJagNU9aK1hTZ49H6MoZCJ3tdQbI8OUAJLdyNt7b19VP
	 utfSjn6D3rcANv10uOvt71EUnLf6EGB10nd5WoKs7y1Cgf6SgZFgVrid+P5yYnfgCS
	 sWwjU+D/nmIGWuvkfbkKRQr04BSV5WFiZ/+ooJJ8=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387620AbfCANYe (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 1 Mar 2019 08:24:34 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:50524 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728320AbfCANYb (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 1 Mar 2019 08:24:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Sender:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Reply-To:Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=DBRD7UTN1XhladlTOP+IXaVBu2F0f0sqVvhVFqagqm0=; b=aeRgaycchxPqFH7O7fd94OWgAi
        DKyp10vJt21Gw+NnunWZ889CbB40ZoNEtGxLWAAJSLUQZ7Yqx5Dw7qVb/GAqw0IupSTXpyoSjZXT2
        iv5csGA8kWX+ozbBzoHYVw2JlX6MR4+0QE3OK8W2gt4+BGHpvzp/j1tXIN1y3vx1yjatpfCRQLxeW
        9cQWNW6v1pKdDnVcosyLnRrqR1zaCuDefHXk+m/tCKJlpHztC14vTzLhi+kNj1/VqO0shqZnduwl/
        zJYeCsNARtGCTr7kRFTcTmgsl9dGmueWaKnOWROvzS0p7SFCRKk9hqWxivR8aV182lzwZQZxwIAwl
        93sMBh8w==;
Received: from 177.41.113.159.dynamic.adsl.gvt.net.br ([177.41.113.159] helo=bombadil.infradead.org)
        by bombadil.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1gzi9N-0003y2-Ub; Fri, 01 Mar 2019 13:24:29 +0000
Received: from mchehab by bombadil.infradead.org with local (Exim 4.92)
        (envelope-from <mchehab@bombadil.infradead.org>)
        id 1gzi9L-0002NX-T0; Fri, 01 Mar 2019 10:24:27 -0300
From:   Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To:     Linux Media Mailing List <linux-media@vger.kernel.org>
Cc:     Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Ezequiel Garcia <ezequiel@collabora.com>
Subject: [PATCH 07/10] media: vim2m: add vertical linear scaler
Date:   Fri,  1 Mar 2019 10:24:23 -0300
Message-Id: <8d53fe1c2d8305dda9a360ace275c63dfacc3b1f.1551446121.git.mchehab+samsung@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <cover.1551446121.git.mchehab+samsung@kernel.org>
References: <cover.1551446121.git.mchehab+samsung@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

When resolutions are different, the expected behavior is to
scale the image. Implement a vertical scaler as the first step.

Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
---
 drivers/media/platform/vim2m.c | 65 +++++++++++++++++-----------------
 1 file changed, 32 insertions(+), 33 deletions(-)

diff --git a/drivers/media/platform/vim2m.c b/drivers/media/platform/vim2m.c
index ec177de144b6..1708becbaa9d 100644
--- a/drivers/media/platform/vim2m.c
+++ b/drivers/media/platform/vim2m.c
@@ -267,23 +267,17 @@ static const char *type_name(enum v4l2_buf_type type)
 #define CLIP(__color) \
 	(u8)(((__color) > 0xff) ? 0xff : (((__color) < 0) ? 0 : (__color)))
 
-static int fast_copy_two_pixels(struct vim2m_q_data *q_data_in,
+static void fast_copy_two_pixels(struct vim2m_q_data *q_data_in,
 				 struct vim2m_q_data *q_data_out,
-				 u8 **src, u8 **dst, int ypos, bool reverse)
+				 u8 **src, u8 **dst, bool reverse)
 {
 	int depth = q_data_out->fmt->depth >> 3;
 
-	/* Only do fast copy when format and resolution are identical */
-	if (q_data_in->fmt->fourcc != q_data_out->fmt->fourcc ||
-	    q_data_in->width != q_data_out->width ||
-	    q_data_in->height != q_data_out->height)
-		return 0;
-
 	if (!reverse) {
 		memcpy(*dst, *src, depth << 1);
 		*src += depth << 1;
 		*dst += depth << 1;
-		return 1;
+		return;
 	}
 
 	/* Copy line at reverse order - YUYV format */
@@ -303,7 +297,7 @@ static int fast_copy_two_pixels(struct vim2m_q_data *q_data_in,
 		*(*dst)++ = u;
 		*(*dst)++ = y1;
 		*(*dst)++ = v;
-		return 1;
+		return;
 	}
 
 	/* copy RGB formats in reverse order */
@@ -311,7 +305,7 @@ static int fast_copy_two_pixels(struct vim2m_q_data *q_data_in,
 	memcpy(*dst + depth, *src - depth, depth);
 	*src -= depth << 1;
 	*dst += depth << 1;
-	return 1;
+	return;
 }
 
 static void copy_two_pixels(struct vim2m_q_data *q_data_in,
@@ -323,11 +317,6 @@ static void copy_two_pixels(struct vim2m_q_data *q_data_in,
 	u8 _r[2], _g[2], _b[2], *r, *g, *b;
 	int i, step;
 
-	// If format is the same just copy the data, respecting the width
-	if (fast_copy_two_pixels(q_data_in, q_data_out,
-				 src, dst, ypos, reverse))
-	  return;
-
 	/* Step 1: read two consecutive pixels from src pointer */
 
 	r = _r;
@@ -527,25 +516,25 @@ static int device_process(struct vim2m_ctx *ctx,
 	struct vim2m_q_data *q_data_in, *q_data_out;
 	u8 *p_in, *p, *p_out;
 	unsigned int width, height, bytesperline, bytesperline_out;
-	unsigned int x, y, y_out;
+	unsigned int x, y, y_in, y_out;
 	int start, end, step;
 	struct vim2m_fmt *in, *out;
 
 	q_data_in = get_q_data(ctx, V4L2_BUF_TYPE_VIDEO_OUTPUT);
 	in = q_data_in->fmt;
-	width = q_data_in->width;
-	height = q_data_in->height;
 	bytesperline = (q_data_in->width * q_data_in->fmt->depth) >> 3;
 
 	q_data_out = get_q_data(ctx, V4L2_BUF_TYPE_VIDEO_CAPTURE);
 	bytesperline_out = (q_data_out->width * q_data_out->fmt->depth) >> 3;
 	out = q_data_out->fmt;
 
+	/* As we're doing vertical scaling use the out height here */
+	height = q_data_out->height;
+
 	/* Crop to the limits of the destination image */
+	width = q_data_in->width;
 	if (width > q_data_out->width)
 		width = q_data_out->width;
-	if (height > q_data_out->height)
-		height = q_data_out->height;
 
 	p_in = vb2_plane_vaddr(&in_vb->vb2_buf, 0);
 	p_out = vb2_plane_vaddr(&out_vb->vb2_buf, 0);
@@ -555,17 +544,6 @@ static int device_process(struct vim2m_ctx *ctx,
 		return -EFAULT;
 	}
 
-	/*
-	 * FIXME: instead of cropping the image and zeroing any
-	 * extra data, the proper behavior is to either scale the
-	 * data or report that scale is not supported (with depends
-	 * on some API for such purpose).
-	 */
-
-	/* Image size is different. Zero buffer first */
-	if (q_data_in->width  != q_data_out->width ||
-	    q_data_in->height != q_data_out->height)
-		memset(p_out, 0, q_data_out->sizeimage);
 	out_vb->sequence = get_q_data(ctx,
 				      V4L2_BUF_TYPE_VIDEO_CAPTURE)->sequence++;
 	in_vb->sequence = q_data_in->sequence++;
@@ -581,8 +559,29 @@ static int device_process(struct vim2m_ctx *ctx,
 		step = 1;
 	}
 	y_out = 0;
+
+	/* Faster copy logic,  when format and resolution are identical */
+	if (q_data_in->fmt->fourcc == q_data_out->fmt->fourcc &&
+	    q_data_in->width == q_data_out->width &&
+	    q_data_in->height == q_data_out->height) {
+		for (y = start; y != end; y += step, y_out++) {
+			p = p_in + (y * bytesperline);
+			if (ctx->mode & MEM2MEM_HFLIP)
+				p += bytesperline - (q_data_in->fmt->depth >> 3);
+
+			for (x = 0; x < width >> 1; x++)
+				fast_copy_two_pixels(q_data_in, q_data_out,
+						     &p, &p_out,
+						     ctx->mode & MEM2MEM_HFLIP);
+		}
+		return 0;
+	}
+
+	/* Slower algorithm with format conversion and scaler */
 	for (y = start; y != end; y += step, y_out++) {
-		p = p_in + (y * bytesperline);
+		y_in = (y * q_data_in->height) / q_data_out->height;
+
+		p = p_in + (y_in * bytesperline);
 		if (ctx->mode & MEM2MEM_HFLIP)
 			p += bytesperline - (q_data_in->fmt->depth >> 3);
 
-- 
2.20.1

