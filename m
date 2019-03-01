Return-Path: <SRS0=+Qw+=RE=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1AD78C43381
	for <linux-media@archiver.kernel.org>; Fri,  1 Mar 2019 12:52:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D351120851
	for <linux-media@archiver.kernel.org>; Fri,  1 Mar 2019 12:52:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1551444748;
	bh=0yFgYnoMwV7PrNHmtbdrRSEUb+52I8W7RJWy906LhN8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=F77sdisigh5NnvHsly5Od8a1WNCMf8LnM05GUx7fvRw7CswgYnxQ6U7bFYpvmJ3Dr
	 iSvPawcHVeOvhOmbWn2teqSZ0Ke1OiiB9xOFIEz8q2EaAxjpp7UTQFa9Op0VTT0cOT
	 7r0PTe30P2CXZVdUyH/zHgsuMQ2SILqDb2WxxA+c=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728300AbfCAMw0 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 1 Mar 2019 07:52:26 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:40524 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727920AbfCAMwZ (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 1 Mar 2019 07:52:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Sender:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Reply-To:Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=ZQL9nvcw/a6aK+gKT6rbweNSeFBeJyzcGcYPj7/uASk=; b=C8i2SH2xonyzVFuYE6LyKJTXbU
        otexaGJuXyMAWpdcGcWFrsqp5+4c7eVewoV/vsy0flMJXix4V4UI1wX6eomY9PA3WHyTmOt9X7cK2
        OawWpfQIU5t85JrDAoh8pOoNMCFDFE+xVVctdkehpziciCj3Xb/r+oasr1ECdYrEW6klafZ20EBmI
        icesyhSZ6yRipl0E3q81wJwQq0W8Kx8Qale9H4+B2iC8yUyHy9BMLfj7y9/fZ3QVtNTO7KLOibNZ0
        pituAsc7ivhdVy4FuVf3CmwizG3W9KNjq++PXMQLJLIQ64SpGgMUbcKnm9fe2P6gRv052zHmzk99p
        XbL9dEhQ==;
Received: from 177.41.113.159.dynamic.adsl.gvt.net.br ([177.41.113.159] helo=bombadil.infradead.org)
        by bombadil.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1gzheK-0001Ae-Ek; Fri, 01 Mar 2019 12:52:24 +0000
Received: from mchehab by bombadil.infradead.org with local (Exim 4.92)
        (envelope-from <mchehab@bombadil.infradead.org>)
        id 1gzheH-0001q2-6d; Fri, 01 Mar 2019 09:52:21 -0300
From:   Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To:     Linux Media Mailing List <linux-media@vger.kernel.org>
Cc:     Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Ezequiel Garcia <ezequiel@collabora.com>
Subject: [PATCH 3/3] media: vim2m: add an horizontal scaler
Date:   Fri,  1 Mar 2019 09:52:20 -0300
Message-Id: <4f7af5730361937a48557822050005d707a3762c.1551444730.git.mchehab+samsung@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <8d53fe1c2d8305dda9a360ace275c63dfacc3b1f.1551444730.git.mchehab+samsung@kernel.org>
References: <8d53fe1c2d8305dda9a360ace275c63dfacc3b1f.1551444730.git.mchehab+samsung@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Add an horizontal linear scaler using Breseham algorithm in
order to speep up its calculus.

Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
---
 drivers/media/platform/vim2m.c | 95 ++++++++++++++++++++--------------
 1 file changed, 55 insertions(+), 40 deletions(-)

diff --git a/drivers/media/platform/vim2m.c b/drivers/media/platform/vim2m.c
index a0e52eb205e3..6bcc0c9f9910 100644
--- a/drivers/media/platform/vim2m.c
+++ b/drivers/media/platform/vim2m.c
@@ -290,12 +290,12 @@ static void fast_copy_two_pixels(struct vim2m_q_data *q_data_in,
 
 static void copy_two_pixels(struct vim2m_q_data *q_data_in,
 			    struct vim2m_q_data *q_data_out,
-			    u8 **src, u8 **dst, int ypos, bool reverse)
+			    u8 *src[2], u8 **dst, int ypos, bool reverse)
 {
 	struct vim2m_fmt *out = q_data_out->fmt;
 	struct vim2m_fmt *in = q_data_in->fmt;
 	u8 _r[2], _g[2], _b[2], *r, *g, *b;
-	int i, step;
+	int i;
 
 	/* Step 1: read two consecutive pixels from src pointer */
 
@@ -303,52 +303,39 @@ static void copy_two_pixels(struct vim2m_q_data *q_data_in,
 	g = _g;
 	b = _b;
 
-	if (reverse)
-		step = -1;
-	else
-		step = 1;
-
 	switch (in->fourcc) {
 	case V4L2_PIX_FMT_RGB565: /* rrrrrggg gggbbbbb */
 		for (i = 0; i < 2; i++) {
-			u16 pix = *(u16 *)*src;
+			u16 pix = *(u16 *)(src[i]);
 
 			*r++ = (u8)(((pix & 0xf800) >> 11) << 3) | 0x07;
 			*g++ = (u8)((((pix & 0x07e0) >> 5)) << 2) | 0x03;
 			*b++ = (u8)((pix & 0x1f) << 3) | 0x07;
-
-			*src += step << 1;
 		}
 		break;
 	case V4L2_PIX_FMT_RGB565X: /* gggbbbbb rrrrrggg */
 		for (i = 0; i < 2; i++) {
-			u16 pix = *(u16 *)*src;
+			u16 pix = *(u16 *)(src[i]);
 
 			*r++ = (u8)(((0x00f8 & pix) >> 3) << 3) | 0x07;
 			*g++ = (u8)(((pix & 0x7) << 2) |
 				    ((pix & 0xe000) >> 5)) | 0x03;
 			*b++ = (u8)(((pix & 0x1f00) >> 8) << 3) | 0x07;
-
-			*src += step << 1;
 		}
 		break;
 	default:
 	case V4L2_PIX_FMT_RGB24:
 		for (i = 0; i < 2; i++) {
-			*r++ = (*src)[0];
-			*g++ = (*src)[1];
-			*b++ = (*src)[2];
-
-			*src += step * 3;
+			*r++ = src[i][0];
+			*g++ = src[i][1];
+			*b++ = src[i][2];
 		}
 		break;
 	case V4L2_PIX_FMT_BGR24:
 		for (i = 0; i < 2; i++) {
-			*b++ = (*src)[0];
-			*g++ = (*src)[1];
-			*r++ = (*src)[2];
-
-			*src += step * 3;
+			*b++ = src[i][0];
+			*g++ = src[i][1];
+			*r++ = src[i][2];
 		}
 		break;
 	}
@@ -461,27 +448,24 @@ static int device_process(struct vim2m_ctx *ctx,
 {
 	struct vim2m_dev *dev = ctx->dev;
 	struct vim2m_q_data *q_data_in, *q_data_out;
-	u8 *p_in, *p, *p_out;
-	unsigned int width, height, bytesperline, bytesperline_out;
-	unsigned int x, y, y_in, y_out;
+	u8 *p_in, *p_line, *p_in_x[2], *p, *p_out;
+	unsigned int width, height, bytesperline, bytesperline_out, bytes_per_pixel;
+	unsigned int x, y, y_in, y_out, x_int, x_fract, x_err, x_offset;
 	int start, end, step;
 	struct vim2m_fmt *in, *out;
 
 	q_data_in = get_q_data(ctx, V4L2_BUF_TYPE_VIDEO_OUTPUT);
 	in = q_data_in->fmt;
 	bytesperline = (q_data_in->width * q_data_in->fmt->depth) >> 3;
+	bytes_per_pixel = q_data_in->fmt->depth >> 3;
 
 	q_data_out = get_q_data(ctx, V4L2_BUF_TYPE_VIDEO_CAPTURE);
 	bytesperline_out = (q_data_out->width * q_data_out->fmt->depth) >> 3;
 	out = q_data_out->fmt;
 
-	/* As we're doing vertical scaling use the out height here */
+	/* As we're doing scaling, use the output dimensions here */
 	height = q_data_out->height;
-
-	/* Crop to the limits of the destination image */
-	width = q_data_in->width;
-	if (width > q_data_out->width)
-		width = q_data_out->width;
+	width = q_data_out->width;
 
 	p_in = vb2_plane_vaddr(&in_vb->vb2_buf, 0);
 	p_out = vb2_plane_vaddr(&out_vb->vb2_buf, 0);
@@ -525,21 +509,52 @@ static int device_process(struct vim2m_ctx *ctx,
 	}
 
 	/* Slower algorithm with format conversion and scaler */
+
+	/* To speed scaler up, use Bresenham for X dimension */
+	x_int = q_data_in->width / q_data_out->width;
+	x_fract = q_data_in->width % q_data_out->width;
+
 	for (y = start; y != end; y += step, y_out++) {
 		y_in = (y * q_data_in->height) / q_data_out->height;
+		x_offset = 0;
+		x_err = 0;
 
-		p = p_in + (y_in * bytesperline);
+		p_line = p_in + (y_in * bytesperline);
 		if (ctx->mode & MEM2MEM_HFLIP)
-			p += bytesperline - (q_data_in->fmt->depth >> 3);
+			p_line += bytesperline - (q_data_in->fmt->depth >> 3);
+		p_in_x[0] = p_line;
 
-		for (x = 0; x < width >> 1; x++)
-			copy_two_pixels(q_data_in, q_data_out, &p, &p_out, y_out,
+		for (x = 0; x < width >> 1; x++) {
+			x_offset += x_int;
+			x_err += x_fract;
+			if (x_err > width) {
+				x_offset++;
+				x_err -= width;
+			}
+
+			if (ctx->mode & MEM2MEM_HFLIP)
+				p_in_x[1] = p_line - x_offset * bytes_per_pixel;
+			else
+				p_in_x[1] = p_line + x_offset * bytes_per_pixel;
+
+			copy_two_pixels(q_data_in, q_data_out,
+					p_in_x, &p_out, y_out,
 					ctx->mode & MEM2MEM_HFLIP);
 
-		/* Go to the next line at the out buffer */
-		if (width < q_data_out->width)
-			p_out += ((q_data_out->width - width)
-				  * q_data_out->fmt->depth) >> 3;
+			/* Calculate the next p_in_x0 */
+			x_offset += x_int;
+			x_err += x_fract;
+			if (x_err > width) {
+				x_offset++;
+				x_err -= width;
+			}
+
+			if (ctx->mode & MEM2MEM_HFLIP)
+				p_in_x[0] = p_line - x_offset * bytes_per_pixel;
+			else
+				p_in_x[0] = p_line + x_offset * bytes_per_pixel;
+		}
+
 	}
 
 	return 0;
-- 
2.20.1

