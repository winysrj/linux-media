Return-Path: <SRS0=4gsG=RD=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68A58C43381
	for <linux-media@archiver.kernel.org>; Thu, 28 Feb 2019 17:59:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3052E20863
	for <linux-media@archiver.kernel.org>; Thu, 28 Feb 2019 17:59:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1551376767;
	bh=xwpYbd1VAeIw8f2t8NT+rVG6P6x7aIKR5g4S4hmWRn8=;
	h=From:To:Cc:Subject:Date:List-ID:From;
	b=2Z5UXPYheaDqWzoJ6Pl1eVwA9Blk5ebZbcTPu+GJ12KO3nbGl3PFknjJK5ULZGvge
	 SP8Ncnosk+pBLpf2oGKa/h5agOtD/m2LE9AaeLEiSuyqCWeYtn9eZPKPvH/82vLY62
	 ZyPfhsK7neoJ7+qSAN/svX8VnwdEybLq6JfvUutE=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388070AbfB1R70 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 28 Feb 2019 12:59:26 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:37972 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726214AbfB1R70 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 28 Feb 2019 12:59:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Sender:Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:Cc:To:From:Reply-To:Content-Type:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=+Yrla9i62aR2PutBWBrotKbj5OE3pJYPR/cdAlWisXU=; b=fnDuvmkFGeeeNT4LmB7VvnNfz
        EpjLTrL8JJAiW5HqF2J5JrqvwS6ctUXUdFMPCOtU8eD8bu/EWzKG46F8sYSrj5r9DyXcFxlvimoy0
        O6wWVfhaX6+qSrSZv8uugixW6BVRWOWpKfIHeXD6ngLO7qQfXqXl095etZefSS/G2SpGHrXdKVqF1
        SN6C7oAsm/augfE+bB+Mhd/2MRIyw931n71oWzBw7SRsfMcZTOW4Q7kkvYYJsEfvrNWwAabP+1pK5
        NHNViAU07GCR5b23uvpvN215HWmjQ0Hn3vfZfogEwN0g3Zgvw3ToGJ4Hs7yjX+lNiwR07xNpHAIz8
        uoSb2O6aw==;
Received: from 177.41.113.159.dynamic.adsl.gvt.net.br ([177.41.113.159] helo=bombadil.infradead.org)
        by bombadil.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1gzPxt-0008TA-IV; Thu, 28 Feb 2019 17:59:25 +0000
Received: from mchehab by bombadil.infradead.org with local (Exim 4.92)
        (envelope-from <mchehab@bombadil.infradead.org>)
        id 1gzPxq-0005Sw-DS; Thu, 28 Feb 2019 14:59:22 -0300
From:   Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To:     Linux Media Mailing List <linux-media@vger.kernel.org>
Cc:     Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Ezequiel Garcia <ezequiel@collabora.com>
Subject: [PATCH v3] media: vim2m: better handle cap/out buffers with different sizes
Date:   Thu, 28 Feb 2019 14:59:21 -0300
Message-Id: <2636657c4de4fcd32ab41a50c7b70445345c8561.1551376758.git.mchehab+samsung@kernel.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

The vim2m driver doesn't enforce that the capture and output
buffers would have the same size. Do the right thing if the
buffers are different, zeroing the buffer before writing,
ensuring that lines will be aligned and it won't write past
the buffer area.

This is a temporary fix.

A proper fix is to either implement a simple scaler at vim2m,
or to better define the behaviour of M2M transform drivers
at V4L2 API with regards to its capability of scaling the
image or not.

In any case, such changes would deserve a separate patch
anyway, as it would imply on some behavoral change.

Also, as we have an actual bug of writing data at wrong
places, let's fix this here, and add a mental note that
we need to properly address it.

Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
---
 drivers/media/platform/vim2m.c | 117 +++++++++++++++++++++++----------
 1 file changed, 81 insertions(+), 36 deletions(-)

diff --git a/drivers/media/platform/vim2m.c b/drivers/media/platform/vim2m.c
index 5157a59aeb58..1c55c47b151a 100644
--- a/drivers/media/platform/vim2m.c
+++ b/drivers/media/platform/vim2m.c
@@ -267,46 +267,66 @@ static const char *type_name(enum v4l2_buf_type type)
 #define CLIP(__color) \
 	(u8)(((__color) > 0xff) ? 0xff : (((__color) < 0) ? 0 : (__color)))
 
-static void copy_two_pixels(struct vim2m_fmt *in, struct vim2m_fmt *out,
+static int fast_copy_two_pixels(struct vim2m_q_data *q_data_in,
+				 struct vim2m_q_data *q_data_out,
+				 u8 **src, u8 **dst, int ypos, bool reverse)
+{
+	int depth = q_data_out->fmt->depth >> 3;
+
+	/* Only do fast copy when format and resolution are identical */
+	if (q_data_in->fmt->fourcc != q_data_out->fmt->fourcc ||
+	    q_data_in->width != q_data_out->width ||
+	    q_data_in->height != q_data_out->height)
+		return 0;
+
+	if (!reverse) {
+		memcpy(*dst, *src, depth << 1);
+		*src += depth << 1;
+		*dst += depth << 1;
+		return 1;
+	}
+
+	/* Copy line at reverse order - YUYV format */
+	if (q_data_in->fmt->fourcc == V4L2_PIX_FMT_YUYV) {
+		int u, v, y, y1;
+
+		*src -= 2;
+
+		y1 = (*src)[0]; /* copy as second point */
+		u  = (*src)[1];
+		y  = (*src)[2]; /* copy as first point */
+		v  = (*src)[3];
+
+		*src -= 2;
+
+		*(*dst)++ = y;
+		*(*dst)++ = u;
+		*(*dst)++ = y1;
+		*(*dst)++ = v;
+		return 1;
+	}
+
+	/* copy RGB formats in reverse order */
+	memcpy(*dst, *src, depth);
+	memcpy(*dst + depth, *src - depth, depth);
+	*src -= depth << 1;
+	*dst += depth << 1;
+	return 1;
+}
+
+static void copy_two_pixels(struct vim2m_q_data *q_data_in,
+			    struct vim2m_q_data *q_data_out,
 			    u8 **src, u8 **dst, int ypos, bool reverse)
 {
+	struct vim2m_fmt *out = q_data_out->fmt;
+	struct vim2m_fmt *in = q_data_in->fmt;
 	u8 _r[2], _g[2], _b[2], *r, *g, *b;
 	int i, step;
 
 	// If format is the same just copy the data, respecting the width
-	if (in->fourcc == out->fourcc) {
-		int depth = out->depth >> 3;
-
-		if (reverse) {
-			if (in->fourcc == V4L2_PIX_FMT_YUYV) {
-				int u, v, y, y1;
-
-				*src -= 2;
-
-				y1 = (*src)[0]; /* copy as second point */
-				u  = (*src)[1];
-				y  = (*src)[2]; /* copy as first point */
-				v  = (*src)[3];
-
-				*src -= 2;
-
-				*(*dst)++ = y;
-				*(*dst)++ = u;
-				*(*dst)++ = y1;
-				*(*dst)++ = v;
-				return;
-			}
-
-			memcpy(*dst, *src, depth);
-			memcpy(*dst + depth, *src - depth, depth);
-			*src -= depth << 1;
-		} else {
-			memcpy(*dst, *src, depth << 1);
-			*src += depth << 1;
-		}
-		*dst += depth << 1;
-		return;
-	}
+	if (fast_copy_two_pixels(q_data_in, q_data_out,
+				 src, dst, ypos, reverse))
+	  return;
 
 	/* Step 1: read two consecutive pixels from src pointer */
 
@@ -506,7 +526,9 @@ static int device_process(struct vim2m_ctx *ctx,
 	struct vim2m_dev *dev = ctx->dev;
 	struct vim2m_q_data *q_data_in, *q_data_out;
 	u8 *p_in, *p, *p_out;
-	int width, height, bytesperline, x, y, y_out, start, end, step;
+	unsigned int width, height, bytesperline, bytesperline_out;
+	unsigned int x, y, y_out;
+	int start, end, step;
 	struct vim2m_fmt *in, *out;
 
 	q_data_in = get_q_data(ctx, V4L2_BUF_TYPE_VIDEO_OUTPUT);
@@ -516,8 +538,15 @@ static int device_process(struct vim2m_ctx *ctx,
 	bytesperline = (q_data_in->width * q_data_in->fmt->depth) >> 3;
 
 	q_data_out = get_q_data(ctx, V4L2_BUF_TYPE_VIDEO_CAPTURE);
+	bytesperline_out = (q_data_out->width * q_data_out->fmt->depth) >> 3;
 	out = q_data_out->fmt;
 
+	/* Crop to the limits of the destination image */
+	if (width > q_data_out->width)
+		width = q_data_out->width;
+	if (height > q_data_out->height)
+		height = q_data_out->height;
+
 	p_in = vb2_plane_vaddr(&in_vb->vb2_buf, 0);
 	p_out = vb2_plane_vaddr(&out_vb->vb2_buf, 0);
 	if (!p_in || !p_out) {
@@ -526,6 +555,17 @@ static int device_process(struct vim2m_ctx *ctx,
 		return -EFAULT;
 	}
 
+	/*
+	 * FIXME: instead of cropping the image and zeroing any
+	 * extra data, the proper behavior is to either scale the
+	 * data or report that scale is not supported (with depends
+	 * on some API for such purpose).
+	 */
+
+	/* Image size is different. Zero buffer first */
+	if (q_data_in->width  != q_data_out->width ||
+	    q_data_in->height != q_data_out->height)
+		memset(p_out, 0, q_data_out->sizeimage);
 	out_vb->sequence = get_q_data(ctx,
 				      V4L2_BUF_TYPE_VIDEO_CAPTURE)->sequence++;
 	in_vb->sequence = q_data_in->sequence++;
@@ -547,8 +587,13 @@ static int device_process(struct vim2m_ctx *ctx,
 			p += bytesperline - (q_data_in->fmt->depth >> 3);
 
 		for (x = 0; x < width >> 1; x++)
-			copy_two_pixels(in, out, &p, &p_out, y_out,
+			copy_two_pixels(q_data_in, q_data_out, &p, &p_out, y_out,
 					ctx->mode & MEM2MEM_HFLIP);
+
+		/* Go to the next line at the out buffer*/
+		if (width < q_data_out->width)
+			p_out += ((q_data_out->width - width)
+				  * q_data_out->fmt->depth) >> 3;
 	}
 
 	return 0;
-- 
2.20.1

