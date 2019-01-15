Return-Path: <SRS0=Ztfs=PX=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A357DC43444
	for <linux-media@archiver.kernel.org>; Tue, 15 Jan 2019 09:31:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 56B942085A
	for <linux-media@archiver.kernel.org>; Tue, 15 Jan 2019 09:31:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MOw04wUz"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728638AbfAOJbQ (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 15 Jan 2019 04:31:16 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:51757 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728545AbfAOJbQ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 15 Jan 2019 04:31:16 -0500
Received: by mail-wm1-f68.google.com with SMTP id b11so2535946wmj.1
        for <linux-media@vger.kernel.org>; Tue, 15 Jan 2019 01:31:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=Ob0L3GFBfg+8xlUAnIE8ztAE3pOWJuWxXecMRtorQes=;
        b=MOw04wUzt5O1cy+Y/VRBfImwcM1Hr5neCHhhtwgfB+eem5qpmvmI+sOD68qJB5hVFQ
         3TwTeERnhbeK0nunDroDHrzyXaHOFl+z9M613fu/La99uOZQVDTUBkjqNzVrC65luVGi
         sCmemxeXYKYxtyUDCXfUaZL+bHCCtTAwuVPqI5Vy0OCdIRDmqEmsq8sCNLaGVx0vUEG0
         XqshNJF1WP5bpvxLrNGhT5HmjEd5XPyMxmxls8eagCpwxRJsJw9/74NsPbuHzJRCu70X
         8rNxCTjwTAGrbb5doAtwJLyZazP3+KfDO2L4wYSzAO+ORb/QSREDFbP9GQsHh6c4JtaT
         wqJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=Ob0L3GFBfg+8xlUAnIE8ztAE3pOWJuWxXecMRtorQes=;
        b=fElpVFiXkzzSUW1l0mZm9vyhjh3fzd2F0cbAywdix8ahOjtspcO+HQ1reORnscDxRF
         JsYKtGTjv9EoazVIpgy+ewatzQ12hH+Fw71xH0JhoK56u8tumuFkUkkxZpaUy65IjFrF
         I+EfVmq9YeJ1aHn5sE5bf7WrCh99wfA+w3VYSBd4dgiDecvA2yHEYL06UXNWfhR3DhaQ
         8R9WVAhJGZTt9mHU8XFjD0KYJ/vhAp6h6d9phJKQ2RuCe2BEOJ0fl6Xw/B2Q74jOR1/X
         rV/G45uvTrBOuD/6j2tWpWQimuTYAKBE/FF6HZD4tQSDzp3MlOHPZbh5eQLZcf49D4OD
         opIQ==
X-Gm-Message-State: AJcUukcoL6K9QzE2qiKwf6x5dUhFODvYkGxTH5i7cUCWc35s6sO7JMzq
        VvMrd/yjReoxF3lXSFBMlsV4/B8/m+E=
X-Google-Smtp-Source: ALg8bN4qOHOw/O++neL0S6aOF+V6gdoS4XzoNqS89a994JlTec5p1QIvWkFcUHujJuzMcZW19b6jvw==
X-Received: by 2002:a1c:8b44:: with SMTP id n65mr2642073wmd.104.1547544671756;
        Tue, 15 Jan 2019 01:31:11 -0800 (PST)
Received: from localhost.localdomain ([87.71.12.187])
        by smtp.gmail.com with ESMTPSA id m193sm32998098wmb.26.2019.01.15.01.31.10
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 15 Jan 2019 01:31:11 -0800 (PST)
From:   Dafna Hirschfeld <dafna3@gmail.com>
To:     linux-media@vger.kernel.org
Cc:     hverkuil@xs4all.nl, helen.koike@collabora.com,
        Dafna Hirschfeld <dafna3@gmail.com>
Subject: [PATCH 4/4] media: vicodec: Add support for dynamic resolution change
Date:   Tue, 15 Jan 2019 01:30:39 -0800
Message-Id: <20190115093039.70584-4-dafna3@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190115093039.70584-1-dafna3@gmail.com>
References: <20190115093039.70584-1-dafna3@gmail.com>
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

The decoder gets the resolution information from the
headers of the compressed frames and starts a
'Dynamic Resolution Change' according to the decoder spec

Signed-off-by: Dafna Hirschfeld <dafna3@gmail.com>
---
 drivers/media/platform/vicodec/codec-fwht.h   |   5 +
 .../media/platform/vicodec/codec-v4l2-fwht.c  |  97 +++-
 .../media/platform/vicodec/codec-v4l2-fwht.h  |  14 +
 drivers/media/platform/vicodec/vicodec-core.c | 477 +++++++++++++-----
 4 files changed, 456 insertions(+), 137 deletions(-)

diff --git a/drivers/media/platform/vicodec/codec-fwht.h b/drivers/media/platform/vicodec/codec-fwht.h
index 6d230f5e9d60..881a05b48dfb 100644
--- a/drivers/media/platform/vicodec/codec-fwht.h
+++ b/drivers/media/platform/vicodec/codec-fwht.h
@@ -79,6 +79,11 @@
 
 /* A 4-values flag - the number of components - 1 */
 #define FWHT_FL_COMPONENTS_NUM_MSK	GENMASK(17, 16)
+#define FWHT_FL_PIXFMT_MSK	GENMASK(19, 18)
+#define FWHT_FL_PIXFMT_YUV	0UL
+#define FWHT_FL_PIXFMT_RGB	BIT(18)
+#define FWHT_FL_PIXFMT_HSV	(BIT(18) | BIT(19))
+
 #define FWHT_FL_COMPONENTS_NUM_OFFSET	16
 
 /*
diff --git a/drivers/media/platform/vicodec/codec-v4l2-fwht.c b/drivers/media/platform/vicodec/codec-v4l2-fwht.c
index 143af8c587b3..b147554a0a2a 100644
--- a/drivers/media/platform/vicodec/codec-v4l2-fwht.c
+++ b/drivers/media/platform/vicodec/codec-v4l2-fwht.c
@@ -11,32 +11,75 @@
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
+	{ V4L2_PIX_FMT_YUV420,  1, 3, 2, 1, 1, 2, 2, 3, 3, pixfmt_yuv},
+	{ V4L2_PIX_FMT_YVU420,  1, 3, 2, 1, 1, 2, 2, 3, 3, pixfmt_yuv},
+	{ V4L2_PIX_FMT_YUV422P, 1, 2, 1, 1, 1, 2, 1, 3, 3, pixfmt_yuv},
+	{ V4L2_PIX_FMT_NV12,    1, 3, 2, 1, 2, 2, 2, 3, 2, pixfmt_yuv},
+	{ V4L2_PIX_FMT_NV21,    1, 3, 2, 1, 2, 2, 2, 3, 2, pixfmt_yuv},
+	{ V4L2_PIX_FMT_NV16,    1, 2, 1, 1, 2, 2, 1, 3, 2, pixfmt_yuv},
+	{ V4L2_PIX_FMT_NV61,    1, 2, 1, 1, 2, 2, 1, 3, 2, pixfmt_yuv},
+	{ V4L2_PIX_FMT_NV24,    1, 3, 1, 1, 2, 1, 1, 3, 2, pixfmt_yuv},
+	{ V4L2_PIX_FMT_NV42,    1, 3, 1, 1, 2, 1, 1, 3, 2, pixfmt_yuv},
+	{ V4L2_PIX_FMT_YUYV,    2, 2, 1, 2, 4, 2, 1, 3, 1, pixfmt_yuv},
+	{ V4L2_PIX_FMT_YVYU,    2, 2, 1, 2, 4, 2, 1, 3, 1, pixfmt_yuv},
+	{ V4L2_PIX_FMT_UYVY,    2, 2, 1, 2, 4, 2, 1, 3, 1, pixfmt_yuv},
+	{ V4L2_PIX_FMT_VYUY,    2, 2, 1, 2, 4, 2, 1, 3, 1, pixfmt_yuv},
+	{ V4L2_PIX_FMT_BGR24,   3, 3, 1, 3, 3, 1, 1, 3, 1, pixfmt_rgb},
+	{ V4L2_PIX_FMT_RGB24,   3, 3, 1, 3, 3, 1, 1, 3, 1, pixfmt_rgb},
+	{ V4L2_PIX_FMT_HSV24,   3, 3, 1, 3, 3, 1, 1, 3, 1, pixfmt_hsv},
+	{ V4L2_PIX_FMT_BGR32,   4, 4, 1, 4, 4, 1, 1, 3, 1, pixfmt_rgb},
+	{ V4L2_PIX_FMT_XBGR32,  4, 4, 1, 4, 4, 1, 1, 3, 1, pixfmt_rgb},
+	{ V4L2_PIX_FMT_RGB32,   4, 4, 1, 4, 4, 1, 1, 3, 1, pixfmt_rgb},
+	{ V4L2_PIX_FMT_XRGB32,  4, 4, 1, 4, 4, 1, 1, 3, 1, pixfmt_rgb},
+	{ V4L2_PIX_FMT_HSV32,   4, 4, 1, 4, 4, 1, 1, 3, 1, pixfmt_hsv},
+	{ V4L2_PIX_FMT_ARGB32,  4, 4, 1, 4, 4, 1, 1, 4, 1, pixfmt_rgb},
+	{ V4L2_PIX_FMT_ABGR32,  4, 4, 1, 4, 4, 1, 1, 4, 1, pixfmt_rgb},
+	{ V4L2_PIX_FMT_GREY,    1, 1, 1, 1, 0, 1, 1, 1, 1, pixfmt_rgb},
 };
 
+int pixfmt_mask_to_family(u32 msk)
+{
+	if (msk == FWHT_FL_PIXFMT_YUV)
+		return pixfmt_yuv;
+	if (msk == FWHT_FL_PIXFMT_RGB)
+		return pixfmt_rgb;
+	if (msk == FWHT_FL_PIXFMT_HSV)
+		return pixfmt_hsv;
+	return -1;
+}
+
+int pixfmt_family_to_mask(enum pixfmt p)
+{
+	if (p == pixfmt_yuv)
+		return FWHT_FL_PIXFMT_YUV;
+	if (p == pixfmt_rgb)
+		return FWHT_FL_PIXFMT_RGB;
+	if (p == pixfmt_hsv)
+		return FWHT_FL_PIXFMT_HSV;
+	return -1;
+}
+
+const struct v4l2_fwht_pixfmt_info *v4l2_fwht_default_fmt(u32 width_div, u32 height_div,
+							  u32 components_num,
+							  int pixfmt_family,
+							  unsigned int start_idx)
+{
+	unsigned int i;
+
+	for (i = 0; i < ARRAY_SIZE(v4l2_fwht_pixfmts); i++)
+		if (v4l2_fwht_pixfmts[i].width_div == width_div &&
+		    v4l2_fwht_pixfmts[i].height_div == height_div &&
+		    (pixfmt_family == -1 ||
+		     v4l2_fwht_pixfmts[i].pixfmt_family == pixfmt_family) &&
+		    (!components_num ||
+		     v4l2_fwht_pixfmts[i].components_num == components_num)) {
+			if (start_idx == 0)
+				return v4l2_fwht_pixfmts + i;
+			start_idx--;
+		}
+	return NULL;
+}
+
 const struct v4l2_fwht_pixfmt_info *v4l2_fwht_find_pixfmt(u32 pixelformat)
 {
 	unsigned int i;
@@ -187,6 +230,7 @@ int v4l2_fwht_encode(struct v4l2_fwht_state *state, u8 *p_in, u8 *p_out)
 	p_hdr->width = htonl(state->visible_width);
 	p_hdr->height = htonl(state->visible_height);
 	flags |= (info->components_num - 1) << FWHT_FL_COMPONENTS_NUM_OFFSET;
+	flags |= pixfmt_family_to_mask(info->pixfmt_family);
 	if (encoding & FWHT_LUMA_UNENCODED)
 		flags |= FWHT_FL_LUMA_IS_UNCOMPRESSED;
 	if (encoding & FWHT_CB_UNENCODED)
@@ -219,6 +263,7 @@ int v4l2_fwht_decode(struct v4l2_fwht_state *state, u8 *p_in, u8 *p_out)
 	unsigned int version;
 	const struct v4l2_fwht_pixfmt_info *info;
 	unsigned int hdr_width_div, hdr_height_div;
+	int pixfmt_family = -1;
 
 	if (!state->info)
 		return -EINVAL;
@@ -247,6 +292,10 @@ int v4l2_fwht_decode(struct v4l2_fwht_state *state, u8 *p_in, u8 *p_out)
 	if (version == FWHT_VERSION) {
 		components_num = 1 + ((flags & FWHT_FL_COMPONENTS_NUM_MSK) >>
 			FWHT_FL_COMPONENTS_NUM_OFFSET);
+		pixfmt_family = pixfmt_mask_to_family(flags & FWHT_FL_PIXFMT_MSK);
+		if (components_num != info->components_num ||
+		    pixfmt_family != info->pixfmt_family)
+			return -EINVAL;
 	}
 
 	state->colorspace = ntohl(p_hdr->colorspace);
diff --git a/drivers/media/platform/vicodec/codec-v4l2-fwht.h b/drivers/media/platform/vicodec/codec-v4l2-fwht.h
index 203c45d98905..dd8e524d8188 100644
--- a/drivers/media/platform/vicodec/codec-v4l2-fwht.h
+++ b/drivers/media/platform/vicodec/codec-v4l2-fwht.h
@@ -8,6 +8,12 @@
 
 #include "codec-fwht.h"
 
+enum pixfmt {
+	pixfmt_rgb,
+	pixfmt_yuv,
+	pixfmt_hsv
+};
+
 struct v4l2_fwht_pixfmt_info {
 	u32 id;
 	unsigned int bytesperline_mult;
@@ -20,6 +26,7 @@ struct v4l2_fwht_pixfmt_info {
 	unsigned int height_div;
 	unsigned int components_num;
 	unsigned int planes_num;
+	enum pixfmt pixfmt_family;
 };
 
 struct v4l2_fwht_state {
@@ -43,8 +50,15 @@ struct v4l2_fwht_state {
 	u8 *compressed_frame;
 };
 
+int pixfmt_mask_to_family(u32 msk);
+int pixfmt_family_to_mask(u32 msk);
 const struct v4l2_fwht_pixfmt_info *v4l2_fwht_find_pixfmt(u32 pixelformat);
 const struct v4l2_fwht_pixfmt_info *v4l2_fwht_get_pixfmt(u32 idx);
+const struct v4l2_fwht_pixfmt_info *v4l2_fwht_default_fmt(u32 width_div,
+							  u32 height_div,
+							  u32 components_num,
+							  int pixfmt_family,
+							  unsigned int start_idx);
 
 int v4l2_fwht_encode(struct v4l2_fwht_state *state, u8 *p_in, u8 *p_out);
 int v4l2_fwht_decode(struct v4l2_fwht_state *state, u8 *p_in, u8 *p_out);
diff --git a/drivers/media/platform/vicodec/vicodec-core.c b/drivers/media/platform/vicodec/vicodec-core.c
index 51053d5d630a..a14c08a7ad1f 100644
--- a/drivers/media/platform/vicodec/vicodec-core.c
+++ b/drivers/media/platform/vicodec/vicodec-core.c
@@ -128,6 +128,9 @@ struct vicodec_ctx {
 	u32			comp_frame_size;
 	bool			comp_has_frame;
 	bool			comp_has_next_frame;
+	struct fwht_cframe_hdr	first_header;
+	bool			first_source_change_sent;
+	bool			source_changed;
 };
 
 static inline struct vicodec_ctx *file2ctx(struct file *file)
@@ -265,30 +268,95 @@ static void job_remove_src_buf(struct vicodec_ctx *ctx, u32 state)
 	spin_unlock(ctx->lock);
 }
 
-static int job_ready(void *priv)
+static const struct v4l2_fwht_pixfmt_info *info_from_header(struct fwht_cframe_hdr p_hdr)
+{
+	unsigned int flags = ntohl(p_hdr.flags);
+	unsigned int width_div = (flags & FWHT_FL_CHROMA_FULL_WIDTH) ? 1 : 2;
+	unsigned int height_div = (flags & FWHT_FL_CHROMA_FULL_HEIGHT) ? 1 : 2;
+	unsigned int components_num = 3;
+	int pixfmt_family = -1;
+	unsigned int version = ntohl(p_hdr.version);
+
+	if (version == FWHT_VERSION) {
+		components_num = 1 + ((flags & FWHT_FL_COMPONENTS_NUM_MSK) >>
+				FWHT_FL_COMPONENTS_NUM_OFFSET);
+		pixfmt_family =
+			pixfmt_mask_to_family(flags & FWHT_FL_PIXFMT_MSK);
+	}
+	return v4l2_fwht_default_fmt(width_div, height_div,
+				     components_num, pixfmt_family, 0);
+}
+
+static bool is_header_valid(struct fwht_cframe_hdr p_hdr)
+{
+	const struct v4l2_fwht_pixfmt_info *info;
+	unsigned int w = ntohl(p_hdr.width);
+	unsigned int h = ntohl(p_hdr.height);
+	unsigned int version = ntohl(p_hdr.version);
+	unsigned int flags = ntohl(p_hdr.flags);
+
+	if (p_hdr.magic1 != FWHT_MAGIC1 || p_hdr.magic2 != FWHT_MAGIC2)
+		return false;
+
+	if (!version || version > FWHT_VERSION)
+		return false;
+
+	if (w < MIN_WIDTH || w > MAX_WIDTH || h < MIN_HEIGHT || h > MAX_HEIGHT)
+		return false;
+
+	if (version == FWHT_VERSION) {
+		unsigned int components_num = 1 +
+			((flags & FWHT_FL_COMPONENTS_NUM_MSK) >>
+			FWHT_FL_COMPONENTS_NUM_OFFSET);
+		int pixfmt_family =
+			pixfmt_mask_to_family(flags & FWHT_FL_PIXFMT_MSK);
+
+		if (components_num == 0 || components_num > 4 ||
+		    pixfmt_family == -1)
+			return false;
+	}
+
+	info = info_from_header(p_hdr);
+	if (!info)
+		return false;
+	return true;
+}
+
+static void update_capture_data_from_header(struct vicodec_ctx *ctx,
+					    struct fwht_cframe_hdr p_hdr)
+{
+	struct vicodec_q_data *q_dst = get_q_data(ctx,
+						  V4L2_BUF_TYPE_VIDEO_CAPTURE);
+	const struct v4l2_fwht_pixfmt_info *info = info_from_header(p_hdr);
+	unsigned int flags = ntohl(p_hdr.flags);
+	unsigned int hdr_width_div = (flags & FWHT_FL_CHROMA_FULL_WIDTH) ? 1 : 2;
+	unsigned int hdr_height_div = (flags & FWHT_FL_CHROMA_FULL_HEIGHT) ? 1 : 2;
+
+	q_dst->info = info;
+	q_dst->visible_width = ntohl(p_hdr.width);
+	q_dst->visible_height = ntohl(p_hdr.height);
+	q_dst->coded_width = vic_round_dim(q_dst->visible_width, hdr_width_div);
+	q_dst->coded_height = vic_round_dim(q_dst->visible_height,
+					    hdr_height_div);
+
+	q_dst->sizeimage = q_dst->coded_width * q_dst->coded_height *
+		q_dst->info->sizeimage_mult / q_dst->info->sizeimage_div;
+	ctx->state.colorspace = ntohl(p_hdr.colorspace);
+
+	ctx->state.xfer_func = ntohl(p_hdr.xfer_func);
+	ctx->state.ycbcr_enc = ntohl(p_hdr.ycbcr_enc);
+	ctx->state.quantization = ntohl(p_hdr.quantization);
+}
+
+enum vb2_buffer_state get_next_header(struct vicodec_ctx *ctx, u8 *p_src,
+				      u32 sz, u8 *header, u8 **pp)
 {
 	static const u8 magic[] = {
 		0x4f, 0x4f, 0x4f, 0x4f, 0xff, 0xff, 0xff, 0xff
 	};
-	struct vicodec_ctx *ctx = priv;
-	struct vb2_v4l2_buffer *src_buf;
-	u8 *p_src;
-	u8 *p;
-	u32 sz;
+	u8 *p = *pp;
 	u32 state;
 
-	if (ctx->is_enc || ctx->comp_has_frame)
-		return 1;
-
-restart:
-	ctx->comp_has_next_frame = false;
-	src_buf = v4l2_m2m_next_src_buf(ctx->fh.m2m_ctx);
-	if (!src_buf)
-		return 0;
-	p_src = vb2_plane_vaddr(&src_buf->vb2_buf, 0);
-	sz = vb2_get_plane_payload(&src_buf->vb2_buf, 0);
-	p = p_src + ctx->cur_buf_offset;
-
 	state = VB2_BUF_STATE_DONE;
 
 	if (!ctx->comp_size) {
@@ -297,7 +365,7 @@ static int job_ready(void *priv)
 			u32 copy;
 
 			p = memchr(p, magic[ctx->comp_magic_cnt],
-				   p_src + sz - p);
+					p_src + sz - p);
 			if (!p) {
 				ctx->comp_magic_cnt = 0;
 				break;
@@ -306,11 +374,9 @@ static int job_ready(void *priv)
 			if (p_src + sz - p < copy)
 				copy = p_src + sz - p;
 
-			memcpy(ctx->state.compressed_frame + ctx->comp_magic_cnt,
-			       p, copy);
+			memcpy(header + ctx->comp_magic_cnt, p, copy);
 			ctx->comp_magic_cnt += copy;
-			if (!memcmp(ctx->state.compressed_frame, magic,
-				    ctx->comp_magic_cnt)) {
+			if (!memcmp(header, magic, ctx->comp_magic_cnt)) {
 				p += copy;
 				state = VB2_BUF_STATE_DONE;
 				break;
@@ -318,32 +384,106 @@ static int job_ready(void *priv)
 			ctx->comp_magic_cnt = 0;
 		}
 		if (ctx->comp_magic_cnt < sizeof(magic)) {
-			job_remove_src_buf(ctx, state);
-			goto restart;
+			*pp = p;
+			return state;
 		}
 		ctx->comp_size = sizeof(magic);
 	}
+
 	if (ctx->comp_size < sizeof(struct fwht_cframe_hdr)) {
-		struct fwht_cframe_hdr *p_hdr =
-			(struct fwht_cframe_hdr *)ctx->state.compressed_frame;
 		u32 copy = sizeof(struct fwht_cframe_hdr) - ctx->comp_size;
 
 		if (copy > p_src + sz - p)
 			copy = p_src + sz - p;
-		memcpy(ctx->state.compressed_frame + ctx->comp_size,
-		       p, copy);
+
+		memcpy(header + ctx->comp_size, p, copy);
 		p += copy;
 		ctx->comp_size += copy;
-		if (ctx->comp_size < sizeof(struct fwht_cframe_hdr)) {
-			job_remove_src_buf(ctx, state);
-			goto restart;
-		}
-		ctx->comp_frame_size = ntohl(p_hdr->size) + sizeof(*p_hdr);
-		if (ctx->comp_frame_size > ctx->comp_max_size)
-			ctx->comp_frame_size = ctx->comp_max_size;
 	}
-	if (ctx->comp_size < ctx->comp_frame_size) {
-		u32 copy = ctx->comp_frame_size - ctx->comp_size;
+	*pp = p;
+	return state;
+}
+
+static void set_last_buffer(struct vb2_v4l2_buffer *dst_buf,
+			    struct vb2_v4l2_buffer *src_buf,
+			    struct vicodec_ctx *ctx)
+{
+	struct vicodec_q_data *q_dst = get_q_data(ctx,
+						  V4L2_BUF_TYPE_VIDEO_CAPTURE);
+
+	vb2_set_plane_payload(&dst_buf->vb2_buf, 0, 0);
+	dst_buf->sequence = q_dst->sequence++;
+	dst_buf->vb2_buf.timestamp = src_buf->vb2_buf.timestamp;
+
+	if (src_buf->flags & V4L2_BUF_FLAG_TIMECODE)
+		dst_buf->timecode = src_buf->timecode;
+	dst_buf->field = src_buf->field;
+	dst_buf->flags |= src_buf->flags &
+		(V4L2_BUF_FLAG_TIMECODE |
+		 V4L2_BUF_FLAG_KEYFRAME |
+		 V4L2_BUF_FLAG_PFRAME |
+		 V4L2_BUF_FLAG_BFRAME |
+		 V4L2_BUF_FLAG_TSTAMP_SRC_MASK);
+	dst_buf->flags |= V4L2_BUF_FLAG_LAST;
+	v4l2_m2m_buf_done(dst_buf, VB2_BUF_STATE_DONE);
+}
+
+static int job_ready(void *priv)
+{
+	static const u8 magic[] = {
+		0x4f, 0x4f, 0x4f, 0x4f, 0xff, 0xff, 0xff, 0xff
+	};
+	struct vicodec_ctx *ctx = priv;
+	struct vb2_v4l2_buffer *src_buf;
+	u8 *p_src;
+	u8 *p;
+	u32 sz;
+	u32 state;
+	struct fwht_cframe_hdr *p_hdr;
+	struct vicodec_q_data *q_dst = get_q_data(ctx,
+						  V4L2_BUF_TYPE_VIDEO_CAPTURE);
+	unsigned int flags;
+	unsigned int hdr_width_div;
+	unsigned int hdr_height_div;
+	unsigned int max_to_copy;
+
+	if (ctx->source_changed)
+		return 0;
+	if (ctx->is_enc || ctx->comp_has_frame)
+		return 1;
+
+restart:
+	ctx->comp_has_next_frame = false;
+	src_buf = v4l2_m2m_next_src_buf(ctx->fh.m2m_ctx);
+	if (!src_buf)
+		return 0;
+	p_src = vb2_plane_vaddr(&src_buf->vb2_buf, 0);
+	sz = vb2_get_plane_payload(&src_buf->vb2_buf, 0);
+	p = p_src + ctx->cur_buf_offset;
+
+	state = VB2_BUF_STATE_DONE;
+
+	if (ctx->comp_size < sizeof(struct fwht_cframe_hdr))
+		state = get_next_header(ctx, p_src, sz,
+					ctx->state.compressed_frame, &p);
+	if (ctx->comp_size < sizeof(struct fwht_cframe_hdr)) {
+		job_remove_src_buf(ctx, state);
+		goto restart;
+	}
+	p_hdr = (struct fwht_cframe_hdr *)ctx->state.compressed_frame;
+	ctx->comp_frame_size = ntohl(p_hdr->size) + sizeof(*p_hdr);
+
+	/*
+	 * The current scanned frame might be the first frame of a new
+	 * resolution so its size might be larger than ctx->comp_max_size.
+	 * In that case it is copied up to the current buffer capacity and
+	 * the copy will continue after allocating new larg enough buffer when
+	 * restreaming
+	 */
+	max_to_copy = min(ctx->comp_frame_size, ctx->comp_max_size);
+
+	if (ctx->comp_size < max_to_copy) {
+		u32 copy = max_to_copy - ctx->comp_size;
 
 		if (copy > p_src + sz - p)
 			copy = p_src + sz - p;
@@ -352,13 +492,14 @@ static int job_ready(void *priv)
 		       p, copy);
 		p += copy;
 		ctx->comp_size += copy;
-		if (ctx->comp_size < ctx->comp_frame_size) {
+		if (ctx->comp_size < max_to_copy) {
 			job_remove_src_buf(ctx, state);
 			goto restart;
 		}
 	}
 	ctx->cur_buf_offset = p - p_src;
-	ctx->comp_has_frame = true;
+	if (ctx->comp_size == ctx->comp_frame_size)
+		ctx->comp_has_frame = true;
 	ctx->comp_has_next_frame = false;
 	if (sz - ctx->cur_buf_offset >= sizeof(struct fwht_cframe_hdr)) {
 		struct fwht_cframe_hdr *p_hdr = (struct fwht_cframe_hdr *)p;
@@ -368,6 +509,35 @@ static int job_ready(void *priv)
 		if (!memcmp(p, magic, sizeof(magic)))
 			ctx->comp_has_next_frame = remaining >= frame_size;
 	}
+	/*
+	 * if the header is invalid the device_run will just drop the frame
+	 * with an error
+	 */
+	if (!is_header_valid(*p_hdr) && ctx->comp_has_frame)
+		return 1;
+	flags = ntohl(p_hdr->flags);
+	hdr_width_div = (flags & FWHT_FL_CHROMA_FULL_WIDTH) ? 1 : 2;
+	hdr_height_div = (flags & FWHT_FL_CHROMA_FULL_HEIGHT) ? 1 : 2;
+	if (ntohl(p_hdr->width) != q_dst->visible_width ||
+	    ntohl(p_hdr->height) != q_dst->visible_height ||
+	    !q_dst->info ||
+	    hdr_width_div != q_dst->info->width_div ||
+	    hdr_height_div != q_dst->info->height_div) {
+		static const struct v4l2_event rs_event = {
+			.type = V4L2_EVENT_SOURCE_CHANGE,
+			.u.src_change.changes = V4L2_EVENT_SRC_CH_RESOLUTION,
+		};
+
+		struct vb2_v4l2_buffer *dst_buf =
+			v4l2_m2m_dst_buf_remove(ctx->fh.m2m_ctx);
+
+		update_capture_data_from_header(ctx, *p_hdr);
+		ctx->first_source_change_sent = true;
+		v4l2_event_queue_fh(&ctx->fh, &rs_event);
+		set_last_buffer(dst_buf, src_buf, ctx);
+		ctx->source_changed = true;
+		return 0;
+	}
 	return 1;
 }
 
@@ -395,9 +565,9 @@ static int vidioc_querycap(struct file *file, void *priv,
 	return 0;
 }
 
-static int enum_fmt(struct v4l2_fmtdesc *f, bool is_enc, bool is_out)
+static int enum_fmt(struct v4l2_fmtdesc *f, struct vicodec_ctx *ctx, bool is_out)
 {
-	bool is_uncomp = (is_enc && is_out) || (!is_enc && !is_out);
+	bool is_uncomp = (ctx->is_enc && is_out) || (!ctx->is_enc && !is_out);
 
 	if (V4L2_TYPE_IS_MULTIPLANAR(f->type) && !multiplanar)
 		return -EINVAL;
@@ -405,9 +575,16 @@ static int enum_fmt(struct v4l2_fmtdesc *f, bool is_enc, bool is_out)
 		return -EINVAL;
 
 	if (is_uncomp) {
-		const struct v4l2_fwht_pixfmt_info *info =
-			v4l2_fwht_get_pixfmt(f->index);
+		const struct v4l2_fwht_pixfmt_info *info = get_q_data(ctx, f->type)->info;
 
+		if (!info || ctx->is_enc)
+			info = v4l2_fwht_get_pixfmt(f->index);
+		else
+			info = v4l2_fwht_default_fmt(info->width_div,
+						     info->height_div,
+						     info->components_num,
+						     info->pixfmt_family,
+						     f->index);
 		if (!info)
 			return -EINVAL;
 		f->pixelformat = info->id;
@@ -424,7 +601,7 @@ static int vidioc_enum_fmt_vid_cap(struct file *file, void *priv,
 {
 	struct vicodec_ctx *ctx = file2ctx(file);
 
-	return enum_fmt(f, ctx->is_enc, false);
+	return enum_fmt(f, ctx, false);
 }
 
 static int vidioc_enum_fmt_vid_out(struct file *file, void *priv,
@@ -432,7 +609,7 @@ static int vidioc_enum_fmt_vid_out(struct file *file, void *priv,
 {
 	struct vicodec_ctx *ctx = file2ctx(file);
 
-	return enum_fmt(f, ctx->is_enc, true);
+	return enum_fmt(f, ctx, true);
 }
 
 static int vidioc_g_fmt(struct vicodec_ctx *ctx, struct v4l2_format *f)
@@ -450,6 +627,9 @@ static int vidioc_g_fmt(struct vicodec_ctx *ctx, struct v4l2_format *f)
 	q_data = get_q_data(ctx, f->type);
 	info = q_data->info;
 
+	if (!info)
+		info = v4l2_fwht_get_pixfmt(0);
+
 	switch (f->type) {
 	case V4L2_BUF_TYPE_VIDEO_CAPTURE:
 	case V4L2_BUF_TYPE_VIDEO_OUTPUT:
@@ -648,6 +828,7 @@ static int vidioc_s_fmt(struct vicodec_ctx *ctx, struct v4l2_format *f)
 		pix = &f->fmt.pix;
 		if (ctx->is_enc && V4L2_TYPE_IS_OUTPUT(f->type))
 			fmt_changed =
+				!q_data->info ||
 				q_data->info->id != pix->pixelformat ||
 				q_data->coded_width != pix->width ||
 				q_data->coded_height != pix->height;
@@ -668,6 +849,7 @@ static int vidioc_s_fmt(struct vicodec_ctx *ctx, struct v4l2_format *f)
 		pix_mp = &f->fmt.pix_mp;
 		if (ctx->is_enc && V4L2_TYPE_IS_OUTPUT(f->type))
 			fmt_changed =
+				!q_data->info ||
 				q_data->info->id != pix_mp->pixelformat ||
 				q_data->coded_width != pix_mp->width ||
 				q_data->coded_height != pix_mp->height;
@@ -923,6 +1105,7 @@ static int vicodec_subscribe_event(struct v4l2_fh *fh,
 {
 	switch (sub->type) {
 	case V4L2_EVENT_EOS:
+	case V4L2_EVENT_SOURCE_CHANGE:
 		return v4l2_event_subscribe(fh, sub, 0, NULL);
 	default:
 		return v4l2_ctrl_subscribe_event(fh, sub);
@@ -1031,7 +1214,56 @@ static void vicodec_buf_queue(struct vb2_buffer *vb)
 {
 	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
 	struct vicodec_ctx *ctx = vb2_get_drv_priv(vb->vb2_queue);
+	unsigned int sz = vb2_get_plane_payload(&vbuf->vb2_buf, 0);
+	u8 *p_src = vb2_plane_vaddr(&vbuf->vb2_buf, 0);
+	u8 *p = p_src;
+	struct vb2_queue *vq_out = v4l2_m2m_get_vq(ctx->fh.m2m_ctx,
+						   V4L2_BUF_TYPE_VIDEO_OUTPUT);
+	struct vb2_queue *vq_cap = v4l2_m2m_get_vq(ctx->fh.m2m_ctx,
+						   V4L2_BUF_TYPE_VIDEO_CAPTURE);
+
+	if (ctx->first_source_change_sent ||
+	    (vb2_is_streaming(vq_out) && vb2_is_streaming(vq_cap))) {
+		v4l2_m2m_buf_queue(ctx->fh.m2m_ctx, vbuf);
+		return;
+	}
 
+	if (!ctx->is_enc && V4L2_TYPE_IS_OUTPUT(vb->vb2_queue->type)) {
+		bool header_valid = false;
+		static const struct v4l2_event rs_event = {
+			.type = V4L2_EVENT_SOURCE_CHANGE,
+			.u.src_change.changes = V4L2_EVENT_SRC_CH_RESOLUTION,
+		};
+
+		do {
+			enum vb2_buffer_state state = get_next_header(ctx, p_src, sz,
+								      (u8 *)&ctx->first_header,
+								      &p);
+
+			if (ctx->comp_size < sizeof(struct fwht_cframe_hdr)) {
+				v4l2_m2m_buf_done(vbuf, state);
+				return;
+			}
+			header_valid = is_header_valid(ctx->first_header);
+			/*
+			 * p points right after the end of the header in the
+			 * buffer. If the header is invalid we set p to point
+			 * to the next byte after the start of the header
+			 */
+			if (!header_valid) {
+				p = p - sizeof(struct fwht_cframe_hdr) + 1;
+				ctx->comp_size = 0;
+				ctx->comp_magic_cnt = 0;
+			}
+
+		} while (!header_valid);
+		if (p < p_src + sz)
+			ctx->cur_buf_offset = p - p_src;
+
+		update_capture_data_from_header(ctx, ctx->first_header);
+		ctx->first_source_change_sent = true;
+		v4l2_event_queue_fh(&ctx->fh, &rs_event);
+	}
 	v4l2_m2m_buf_queue(ctx->fh.m2m_ctx, vbuf);
 }
 
@@ -1060,72 +1292,81 @@ static int vicodec_start_streaming(struct vb2_queue *q,
 	struct vicodec_q_data *q_data = get_q_data(ctx, q->type);
 	struct v4l2_fwht_state *state = &ctx->state;
 	const struct v4l2_fwht_pixfmt_info *info = q_data->info;
-	unsigned int size = q_data->coded_width * q_data->coded_height;
-	unsigned int chroma_div = info->width_div * info->height_div;
-	unsigned int total_planes_size;
 
-	/*
-	 * we don't know ahead how many components are in the encoding type
-	 * V4L2_PIX_FMT_FWHT, so we will allocate space for 4 planes.
-	 */
-	if (info->id == V4L2_PIX_FMT_FWHT || info->components_num == 4)
-		total_planes_size = 2 * size + 2 * (size / chroma_div);
-	else if (info->components_num == 3)
-		total_planes_size = size + 2 * (size / chroma_div);
-	else
-		total_planes_size = size;
+	if (!info)
+		return -EINVAL;
 
 	q_data->sequence = 0;
+	ctx->last_dst_buf = NULL;
+	state->gop_cnt = 0;
 
-	if (!V4L2_TYPE_IS_OUTPUT(q->type)) {
-		if (!ctx->is_enc) {
-			state->visible_width = q_data->visible_width;
-			state->visible_height = q_data->visible_height;
-			state->coded_width = q_data->coded_width;
-			state->coded_height = q_data->coded_height;
-			state->stride = q_data->coded_width * info->bytesperline_mult;
+	if ((!V4L2_TYPE_IS_OUTPUT(q->type) && !ctx->is_enc) ||
+	    (V4L2_TYPE_IS_OUTPUT(q->type) && ctx->is_enc)) {
+		unsigned int size = q_data->coded_width * q_data->coded_height;
+		unsigned int chroma_div = info->width_div * info->height_div;
+		unsigned int total_planes_size;
+		u8 *new_comp_frame;
+
+		if (!info || info->id == V4L2_PIX_FMT_FWHT) {
+			vicodec_return_bufs(q, VB2_BUF_STATE_QUEUED);
+			return -EINVAL;
 		}
-		return 0;
-	}
+		if (info->components_num == 4)
+			total_planes_size = 2 * size + 2 * (size / chroma_div);
+		else if (info->components_num == 3)
+			total_planes_size = size + 2 * (size / chroma_div);
+		else
+			total_planes_size = size;
 
-	if (ctx->is_enc) {
 		state->visible_width = q_data->visible_width;
 		state->visible_height = q_data->visible_height;
 		state->coded_width = q_data->coded_width;
 		state->coded_height = q_data->coded_height;
 		state->stride = q_data->coded_width * info->bytesperline_mult;
-	}
-	state->ref_frame.luma = kvmalloc(total_planes_size, GFP_KERNEL);
-	ctx->comp_max_size = total_planes_size + sizeof(struct fwht_cframe_hdr);
-	state->compressed_frame = kvmalloc(ctx->comp_max_size, GFP_KERNEL);
-	if (!state->ref_frame.luma || !state->compressed_frame) {
-		kvfree(state->ref_frame.luma);
-		kvfree(state->compressed_frame);
-		vicodec_return_bufs(q, VB2_BUF_STATE_QUEUED);
-		return -ENOMEM;
-	}
-	if (info->id == V4L2_PIX_FMT_FWHT || info->components_num >= 3) {
-		state->ref_frame.cb = state->ref_frame.luma + size;
-		state->ref_frame.cr = state->ref_frame.cb + size / chroma_div;
-	} else {
-		state->ref_frame.cb = NULL;
-		state->ref_frame.cr = NULL;
-	}
 
-	if (info->id == V4L2_PIX_FMT_FWHT || info->components_num == 4)
-		state->ref_frame.alpha =
-			state->ref_frame.cr + size / chroma_div;
-	else
-		state->ref_frame.alpha = NULL;
+		state->ref_frame.luma = kvmalloc(total_planes_size, GFP_KERNEL);
+		ctx->comp_max_size = total_planes_size + sizeof(struct fwht_cframe_hdr);
+		new_comp_frame = kvmalloc(ctx->comp_max_size, GFP_KERNEL);
 
-	ctx->last_src_buf = NULL;
-	ctx->last_dst_buf = NULL;
-	state->gop_cnt = 0;
-	ctx->cur_buf_offset = 0;
-	ctx->comp_size = 0;
-	ctx->comp_magic_cnt = 0;
-	ctx->comp_has_frame = false;
+		if (!state->ref_frame.luma || !new_comp_frame) {
+			kvfree(state->ref_frame.luma);
+			kvfree(new_comp_frame);
+			vicodec_return_bufs(q, VB2_BUF_STATE_QUEUED);
+			return -ENOMEM;
+		}
+		/*
+		 * if state->compressed_frame was already allocated then
+		 * it contain data of the first frame of the new resolution
+		 */
+		if (state->compressed_frame) {
+			if (ctx->comp_size > ctx->comp_max_size) {
+				ctx->comp_size = ctx->comp_max_size;
+				ctx->comp_frame_size = ctx->comp_max_size;
+			}
+			memcpy(new_comp_frame,
+			       state->compressed_frame, ctx->comp_size);
+		} else {
+			memcpy(new_comp_frame, &ctx->first_header,
+			       sizeof(struct fwht_cframe_hdr));
+		}
 
+		kvfree(state->compressed_frame);
+		state->compressed_frame = new_comp_frame;
+
+		if (info->components_num >= 3) {
+			state->ref_frame.cb = state->ref_frame.luma + size;
+			state->ref_frame.cr = state->ref_frame.cb + size / chroma_div;
+		} else {
+			state->ref_frame.cb = NULL;
+			state->ref_frame.cr = NULL;
+		}
+
+		if (info->components_num == 4)
+			state->ref_frame.alpha =
+				state->ref_frame.cr + size / chroma_div;
+		else
+			state->ref_frame.alpha = NULL;
+	}
 	return 0;
 }
 
@@ -1135,11 +1376,20 @@ static void vicodec_stop_streaming(struct vb2_queue *q)
 
 	vicodec_return_bufs(q, VB2_BUF_STATE_ERROR);
 
-	if (!V4L2_TYPE_IS_OUTPUT(q->type))
-		return;
-
-	kvfree(ctx->state.ref_frame.luma);
-	kvfree(ctx->state.compressed_frame);
+	if ((!V4L2_TYPE_IS_OUTPUT(q->type) && !ctx->is_enc) ||
+	    (V4L2_TYPE_IS_OUTPUT(q->type) && ctx->is_enc)) {
+		kvfree(ctx->state.ref_frame.luma);
+		ctx->source_changed = false;
+	}
+	if (V4L2_TYPE_IS_OUTPUT(q->type) && !ctx->is_enc) {
+		ctx->cur_buf_offset = 0;
+		ctx->comp_max_size = 0;
+		ctx->comp_size = 0;
+		ctx->comp_magic_cnt = 0;
+		ctx->comp_frame_size = 0;
+		ctx->comp_has_frame = 0;
+		ctx->comp_has_next_frame = 0;
+	}
 }
 
 static const struct vb2_ops vicodec_qops = {
@@ -1291,16 +1541,17 @@ static int vicodec_open(struct file *file)
 	else
 		ctx->q_data[V4L2_M2M_SRC].sizeimage =
 			size + sizeof(struct fwht_cframe_hdr);
-	ctx->q_data[V4L2_M2M_DST] = ctx->q_data[V4L2_M2M_SRC];
-	ctx->q_data[V4L2_M2M_DST].info =
-		ctx->is_enc ? &pixfmt_fwht : v4l2_fwht_get_pixfmt(0);
-	size = 1280 * 720 * ctx->q_data[V4L2_M2M_DST].info->sizeimage_mult /
-		ctx->q_data[V4L2_M2M_DST].info->sizeimage_div;
-	if (ctx->is_enc)
-		ctx->q_data[V4L2_M2M_DST].sizeimage =
-			size + sizeof(struct fwht_cframe_hdr);
-	else
-		ctx->q_data[V4L2_M2M_DST].sizeimage = size;
+	if (ctx->is_enc) {
+		ctx->q_data[V4L2_M2M_DST] = ctx->q_data[V4L2_M2M_SRC];
+		ctx->q_data[V4L2_M2M_DST].info = &pixfmt_fwht;
+		ctx->q_data[V4L2_M2M_DST].sizeimage = 1280 * 720 *
+			ctx->q_data[V4L2_M2M_DST].info->sizeimage_mult /
+			ctx->q_data[V4L2_M2M_DST].info->sizeimage_div +
+			sizeof(struct fwht_cframe_hdr);
+	} else {
+		ctx->q_data[V4L2_M2M_DST].info = NULL;
+	}
+
 	ctx->state.colorspace = V4L2_COLORSPACE_REC709;
 
 	if (ctx->is_enc) {
-- 
2.17.1

