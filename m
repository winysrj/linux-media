Return-Path: <SRS0=kVnX=P5=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D060C7113B
	for <linux-media@archiver.kernel.org>; Mon, 21 Jan 2019 11:46:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BB51F2085A
	for <linux-media@archiver.kernel.org>; Mon, 21 Jan 2019 11:46:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FQS1DbeH"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728034AbfAULqm (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 21 Jan 2019 06:46:42 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:54011 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727931AbfAULqm (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 21 Jan 2019 06:46:42 -0500
Received: by mail-wm1-f68.google.com with SMTP id d15so10457465wmb.3
        for <linux-media@vger.kernel.org>; Mon, 21 Jan 2019 03:46:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=fPnFndWzn2FeO43akODcHNNqJlFLgNKx/1UAUIBgeM0=;
        b=FQS1DbeHtt+1zEkiZzuSoGdv4dlCcBYebiPOXNvwFlF/VZeUkoDBU8LdBrVbhX5h85
         DazOHw1/9qKRNztusePobfxy4DYh3Kbw3TOeM4lavh79cOS4dT7NcoPMS2wcMIz5dK4Z
         NqyABd5MQytASKyyLeqHKKlEtTSIwknbOmfaHoxRC1wImXU0A92ltYeyi/WtQ9W+dADb
         fM5p+9FSiPI25rUZAIpQ1HG1Xu+svPIGhLOgIODxdW7IEPbOg+CfcSvVqGef8velcYA4
         KDz2ROWzq9MADnq2scNxMtuvU8pxy72xX9SHFwG/2FNwJ7jUUSAmF/Yc7zJipLKg7Nxd
         nX/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=fPnFndWzn2FeO43akODcHNNqJlFLgNKx/1UAUIBgeM0=;
        b=kgyS5DrcQ409Wkh9VVr6YQrdL7GFCPun+rQqob6m0RAQUBjx6e0DrzdfPy5G4r16I0
         Of9lE7A9G8kjl6j2tKXA3UuKxgvt+j3cw/+YLuuKs6xxbJef9BFidyJ1SjWtoSKXsLPM
         8TA5SatrjEAgTWxbtajqP9lMifAF+JeXgysJI4zVu7yc8a8Nxn9x0fKRgU+eHeD6CkFA
         syTKwagtWQyplfZP1H97QpOgxT5BwJJkckKPcETXXpWLRN8LThesnxYB570XJS4jurOg
         X39Lrvgs+S6VUNdKLSzBd+MRLsYx+i8PB8wX1zK7oFBF+caObcND7GrijdRSljGSWpme
         qA+A==
X-Gm-Message-State: AJcUukd1AKHWD8hlhmEastL86hbjzMGhHFfdOfRsBMe+fjYO8Cy8cC++
        xcNsUBoMYYHTTscKmXvT70kXq+Y3pqo=
X-Google-Smtp-Source: ALg8bN44Pj4XRPoEqbRmZ26IOAMFE+XSVHtQ0zcyjE5ktP/ymkt+apA+E32cC5vBpL64+4Ys/lnwIg==
X-Received: by 2002:a1c:e18a:: with SMTP id y132mr26102078wmg.48.1548071198886;
        Mon, 21 Jan 2019 03:46:38 -0800 (PST)
Received: from localhost.localdomain ([87.70.46.65])
        by smtp.gmail.com with ESMTPSA id z7sm83189584wrw.22.2019.01.21.03.46.37
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 21 Jan 2019 03:46:38 -0800 (PST)
From:   Dafna Hirschfeld <dafna3@gmail.com>
To:     linux-media@vger.kernel.org
Cc:     hverkuil@xs4all.nl, helen.koike@collabora.com,
        Dafna Hirschfeld <dafna3@gmail.com>
Subject: [PATCH v6 3/5] media: vicodec: Add pixel encoding flags to fwht header
Date:   Mon, 21 Jan 2019 03:46:16 -0800
Message-Id: <20190121114618.115282-4-dafna3@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190121114618.115282-1-dafna3@gmail.com>
References: <20190121114618.115282-1-dafna3@gmail.com>
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Add flags indicating the pixel encoding - yuv/rgb/hsv to
fwht header and to the pixel info. Use it to enumerate
the supported pixel formats.

Signed-off-by: Dafna Hirschfeld <dafna3@gmail.com>
---
 drivers/media/platform/vicodec/codec-fwht.h   |  6 ++
 .../media/platform/vicodec/codec-v4l2-fwht.c  | 77 +++++++++++++------
 .../media/platform/vicodec/codec-v4l2-fwht.h  |  6 ++
 drivers/media/platform/vicodec/vicodec-core.c | 19 +++--
 4 files changed, 78 insertions(+), 30 deletions(-)

diff --git a/drivers/media/platform/vicodec/codec-fwht.h b/drivers/media/platform/vicodec/codec-fwht.h
index 2984dc772515..ad8cfc60a152 100644
--- a/drivers/media/platform/vicodec/codec-fwht.h
+++ b/drivers/media/platform/vicodec/codec-fwht.h
@@ -81,6 +81,12 @@
 #define FWHT_FL_COMPONENTS_NUM_MSK	GENMASK(18, 16)
 #define FWHT_FL_COMPONENTS_NUM_OFFSET	16
 
+#define FWHT_FL_PIXENC_MSK	GENMASK(20, 19)
+#define FWHT_FL_PIXENC_OFFSET	19
+#define FWHT_FL_PIXENC_YUV	(1 << FWHT_FL_PIXENC_OFFSET)
+#define FWHT_FL_PIXENC_RGB	(2 << FWHT_FL_PIXENC_OFFSET)
+#define FWHT_FL_PIXENC_HSV	(3 << FWHT_FL_PIXENC_OFFSET)
+
 /*
  * A macro to calculate the needed padding in order to make sure
  * both luma and chroma components resolutions are rounded up to
diff --git a/drivers/media/platform/vicodec/codec-v4l2-fwht.c b/drivers/media/platform/vicodec/codec-v4l2-fwht.c
index e9c522d209ab..71ae19062b15 100644
--- a/drivers/media/platform/vicodec/codec-v4l2-fwht.c
+++ b/drivers/media/platform/vicodec/codec-v4l2-fwht.c
@@ -11,32 +11,53 @@
 #include "codec-v4l2-fwht.h"
 
 static const struct v4l2_fwht_pixfmt_info v4l2_fwht_pixfmts[] = {
-	{ V4L2_PIX_FMT_YUV420,  1, 3, 2, 1, 1, 2, 2, 3, 3},
-	{ V4L2_PIX_FMT_YVU420,  1, 3, 2, 1, 1, 2, 2, 3, 3},
-	{ V4L2_PIX_FMT_YUV422P, 1, 2, 1, 1, 1, 2, 1, 3, 3},
-	{ V4L2_PIX_FMT_NV12,    1, 3, 2, 1, 2, 2, 2, 3, 2},
-	{ V4L2_PIX_FMT_NV21,    1, 3, 2, 1, 2, 2, 2, 3, 2},
-	{ V4L2_PIX_FMT_NV16,    1, 2, 1, 1, 2, 2, 1, 3, 2},
-	{ V4L2_PIX_FMT_NV61,    1, 2, 1, 1, 2, 2, 1, 3, 2},
-	{ V4L2_PIX_FMT_NV24,    1, 3, 1, 1, 2, 1, 1, 3, 2},
-	{ V4L2_PIX_FMT_NV42,    1, 3, 1, 1, 2, 1, 1, 3, 2},
-	{ V4L2_PIX_FMT_YUYV,    2, 2, 1, 2, 4, 2, 1, 3, 1},
-	{ V4L2_PIX_FMT_YVYU,    2, 2, 1, 2, 4, 2, 1, 3, 1},
-	{ V4L2_PIX_FMT_UYVY,    2, 2, 1, 2, 4, 2, 1, 3, 1},
-	{ V4L2_PIX_FMT_VYUY,    2, 2, 1, 2, 4, 2, 1, 3, 1},
-	{ V4L2_PIX_FMT_BGR24,   3, 3, 1, 3, 3, 1, 1, 3, 1},
-	{ V4L2_PIX_FMT_RGB24,   3, 3, 1, 3, 3, 1, 1, 3, 1},
-	{ V4L2_PIX_FMT_HSV24,   3, 3, 1, 3, 3, 1, 1, 3, 1},
-	{ V4L2_PIX_FMT_BGR32,   4, 4, 1, 4, 4, 1, 1, 3, 1},
-	{ V4L2_PIX_FMT_XBGR32,  4, 4, 1, 4, 4, 1, 1, 3, 1},
-	{ V4L2_PIX_FMT_RGB32,   4, 4, 1, 4, 4, 1, 1, 3, 1},
-	{ V4L2_PIX_FMT_XRGB32,  4, 4, 1, 4, 4, 1, 1, 3, 1},
-	{ V4L2_PIX_FMT_HSV32,   4, 4, 1, 4, 4, 1, 1, 3, 1},
-	{ V4L2_PIX_FMT_ARGB32,  4, 4, 1, 4, 4, 1, 1, 4, 1},
-	{ V4L2_PIX_FMT_ABGR32,  4, 4, 1, 4, 4, 1, 1, 4, 1},
-	{ V4L2_PIX_FMT_GREY,    1, 1, 1, 1, 0, 1, 1, 1, 1},
+	{ V4L2_PIX_FMT_YUV420,  1, 3, 2, 1, 1, 2, 2, 3, 3, FWHT_FL_PIXENC_YUV},
+	{ V4L2_PIX_FMT_YVU420,  1, 3, 2, 1, 1, 2, 2, 3, 3, FWHT_FL_PIXENC_YUV},
+	{ V4L2_PIX_FMT_YUV422P, 1, 2, 1, 1, 1, 2, 1, 3, 3, FWHT_FL_PIXENC_YUV},
+	{ V4L2_PIX_FMT_NV12,    1, 3, 2, 1, 2, 2, 2, 3, 2, FWHT_FL_PIXENC_YUV},
+	{ V4L2_PIX_FMT_NV21,    1, 3, 2, 1, 2, 2, 2, 3, 2, FWHT_FL_PIXENC_YUV},
+	{ V4L2_PIX_FMT_NV16,    1, 2, 1, 1, 2, 2, 1, 3, 2, FWHT_FL_PIXENC_YUV},
+	{ V4L2_PIX_FMT_NV61,    1, 2, 1, 1, 2, 2, 1, 3, 2, FWHT_FL_PIXENC_YUV},
+	{ V4L2_PIX_FMT_NV24,    1, 3, 1, 1, 2, 1, 1, 3, 2, FWHT_FL_PIXENC_YUV},
+	{ V4L2_PIX_FMT_NV42,    1, 3, 1, 1, 2, 1, 1, 3, 2, FWHT_FL_PIXENC_YUV},
+	{ V4L2_PIX_FMT_YUYV,    2, 2, 1, 2, 4, 2, 1, 3, 1, FWHT_FL_PIXENC_YUV},
+	{ V4L2_PIX_FMT_YVYU,    2, 2, 1, 2, 4, 2, 1, 3, 1, FWHT_FL_PIXENC_YUV},
+	{ V4L2_PIX_FMT_UYVY,    2, 2, 1, 2, 4, 2, 1, 3, 1, FWHT_FL_PIXENC_YUV},
+	{ V4L2_PIX_FMT_VYUY,    2, 2, 1, 2, 4, 2, 1, 3, 1, FWHT_FL_PIXENC_YUV},
+	{ V4L2_PIX_FMT_BGR24,   3, 3, 1, 3, 3, 1, 1, 3, 1, FWHT_FL_PIXENC_RGB},
+	{ V4L2_PIX_FMT_RGB24,   3, 3, 1, 3, 3, 1, 1, 3, 1, FWHT_FL_PIXENC_RGB},
+	{ V4L2_PIX_FMT_HSV24,   3, 3, 1, 3, 3, 1, 1, 3, 1, FWHT_FL_PIXENC_HSV},
+	{ V4L2_PIX_FMT_BGR32,   4, 4, 1, 4, 4, 1, 1, 3, 1, FWHT_FL_PIXENC_RGB},
+	{ V4L2_PIX_FMT_XBGR32,  4, 4, 1, 4, 4, 1, 1, 3, 1, FWHT_FL_PIXENC_RGB},
+	{ V4L2_PIX_FMT_RGB32,   4, 4, 1, 4, 4, 1, 1, 3, 1, FWHT_FL_PIXENC_RGB},
+	{ V4L2_PIX_FMT_XRGB32,  4, 4, 1, 4, 4, 1, 1, 3, 1, FWHT_FL_PIXENC_RGB},
+	{ V4L2_PIX_FMT_HSV32,   4, 4, 1, 4, 4, 1, 1, 3, 1, FWHT_FL_PIXENC_HSV},
+	{ V4L2_PIX_FMT_ARGB32,  4, 4, 1, 4, 4, 1, 1, 4, 1, FWHT_FL_PIXENC_RGB},
+	{ V4L2_PIX_FMT_ABGR32,  4, 4, 1, 4, 4, 1, 1, 4, 1, FWHT_FL_PIXENC_RGB},
+	{ V4L2_PIX_FMT_GREY,    1, 1, 1, 1, 0, 1, 1, 1, 1, FWHT_FL_PIXENC_RGB},
 };
 
+const struct v4l2_fwht_pixfmt_info *v4l2_fwht_default_fmt(u32 width_div,
+							  u32 height_div,
+							  u32 components_num,
+							  u32 pixenc,
+							  unsigned int start_idx)
+{
+	unsigned int i;
+
+	for (i = 0; i < ARRAY_SIZE(v4l2_fwht_pixfmts); i++) {
+		if (v4l2_fwht_pixfmts[i].width_div == width_div &&
+		    v4l2_fwht_pixfmts[i].height_div == height_div &&
+		    (!pixenc || v4l2_fwht_pixfmts[i].pixenc == pixenc) &&
+		    v4l2_fwht_pixfmts[i].components_num == components_num) {
+			if (start_idx == 0)
+				return v4l2_fwht_pixfmts + i;
+			start_idx--;
+		}
+	}
+	return NULL;
+}
+
 const struct v4l2_fwht_pixfmt_info *v4l2_fwht_find_pixfmt(u32 pixelformat)
 {
 	unsigned int i;
@@ -188,6 +209,7 @@ int v4l2_fwht_encode(struct v4l2_fwht_state *state, u8 *p_in, u8 *p_out)
 	p_hdr->width = htonl(state->visible_width);
 	p_hdr->height = htonl(state->visible_height);
 	flags |= (info->components_num - 1) << FWHT_FL_COMPONENTS_NUM_OFFSET;
+	flags |= info->pixenc;
 	if (encoding & FWHT_LUMA_UNENCODED)
 		flags |= FWHT_FL_LUMA_IS_UNCOMPRESSED;
 	if (encoding & FWHT_CB_UNENCODED)
@@ -246,10 +268,15 @@ int v4l2_fwht_decode(struct v4l2_fwht_state *state, u8 *p_in, u8 *p_out)
 	flags = ntohl(p_hdr->flags);
 
 	if (version == FWHT_VERSION) {
+		if ((flags & FWHT_FL_PIXENC_MSK) != info->pixenc)
+			return -EINVAL;
 		components_num = 1 + ((flags & FWHT_FL_COMPONENTS_NUM_MSK) >>
-			FWHT_FL_COMPONENTS_NUM_OFFSET);
+				FWHT_FL_COMPONENTS_NUM_OFFSET);
 	}
 
+	if (components_num != info->components_num)
+		return -EINVAL;
+
 	state->colorspace = ntohl(p_hdr->colorspace);
 	state->xfer_func = ntohl(p_hdr->xfer_func);
 	state->ycbcr_enc = ntohl(p_hdr->ycbcr_enc);
diff --git a/drivers/media/platform/vicodec/codec-v4l2-fwht.h b/drivers/media/platform/vicodec/codec-v4l2-fwht.h
index 203c45d98905..18ac25978829 100644
--- a/drivers/media/platform/vicodec/codec-v4l2-fwht.h
+++ b/drivers/media/platform/vicodec/codec-v4l2-fwht.h
@@ -20,6 +20,7 @@ struct v4l2_fwht_pixfmt_info {
 	unsigned int height_div;
 	unsigned int components_num;
 	unsigned int planes_num;
+	unsigned int pixenc;
 };
 
 struct v4l2_fwht_state {
@@ -45,6 +46,11 @@ struct v4l2_fwht_state {
 
 const struct v4l2_fwht_pixfmt_info *v4l2_fwht_find_pixfmt(u32 pixelformat);
 const struct v4l2_fwht_pixfmt_info *v4l2_fwht_get_pixfmt(u32 idx);
+const struct v4l2_fwht_pixfmt_info *v4l2_fwht_default_fmt(u32 width_div,
+							  u32 height_div,
+							  u32 components_num,
+							  u32 pixenc,
+							  unsigned int start_idx);
 
 int v4l2_fwht_encode(struct v4l2_fwht_state *state, u8 *p_in, u8 *p_out);
 int v4l2_fwht_decode(struct v4l2_fwht_state *state, u8 *p_in, u8 *p_out);
diff --git a/drivers/media/platform/vicodec/vicodec-core.c b/drivers/media/platform/vicodec/vicodec-core.c
index 840e78c2cbe8..413b6bca91e5 100644
--- a/drivers/media/platform/vicodec/vicodec-core.c
+++ b/drivers/media/platform/vicodec/vicodec-core.c
@@ -395,9 +395,10 @@ static int vidioc_querycap(struct file *file, void *priv,
 	return 0;
 }
 
-static int enum_fmt(struct v4l2_fmtdesc *f, bool is_enc, bool is_out)
+static int enum_fmt(struct v4l2_fmtdesc *f, struct vicodec_ctx *ctx,
+		    bool is_out)
 {
-	bool is_uncomp = (is_enc && is_out) || (!is_enc && !is_out);
+	bool is_uncomp = (ctx->is_enc && is_out) || (!ctx->is_enc && !is_out);
 
 	if (V4L2_TYPE_IS_MULTIPLANAR(f->type) && !multiplanar)
 		return -EINVAL;
@@ -406,8 +407,16 @@ static int enum_fmt(struct v4l2_fmtdesc *f, bool is_enc, bool is_out)
 
 	if (is_uncomp) {
 		const struct v4l2_fwht_pixfmt_info *info =
-			v4l2_fwht_get_pixfmt(f->index);
+					get_q_data(ctx, f->type)->info;
 
+		if (ctx->is_enc)
+			info = v4l2_fwht_get_pixfmt(f->index);
+		else
+			info = v4l2_fwht_default_fmt(info->width_div,
+						     info->height_div,
+						     info->components_num,
+						     info->pixenc,
+						     f->index);
 		if (!info)
 			return -EINVAL;
 		f->pixelformat = info->id;
@@ -424,7 +433,7 @@ static int vidioc_enum_fmt_vid_cap(struct file *file, void *priv,
 {
 	struct vicodec_ctx *ctx = file2ctx(file);
 
-	return enum_fmt(f, ctx->is_enc, false);
+	return enum_fmt(f, ctx, false);
 }
 
 static int vidioc_enum_fmt_vid_out(struct file *file, void *priv,
@@ -432,7 +441,7 @@ static int vidioc_enum_fmt_vid_out(struct file *file, void *priv,
 {
 	struct vicodec_ctx *ctx = file2ctx(file);
 
-	return enum_fmt(f, ctx->is_enc, true);
+	return enum_fmt(f, ctx, true);
 }
 
 static int vidioc_g_fmt(struct vicodec_ctx *ctx, struct v4l2_format *f)
-- 
2.17.1

