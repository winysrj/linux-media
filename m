Return-Path: <SRS0=UobA=R6=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 248A5C43381
	for <linux-media@archiver.kernel.org>; Wed, 27 Mar 2019 15:21:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DC8942082F
	for <linux-media@archiver.kernel.org>; Wed, 27 Mar 2019 15:21:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729531AbfC0PSz (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 27 Mar 2019 11:18:55 -0400
Received: from bhuna.collabora.co.uk ([46.235.227.227]:48470 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725764AbfC0PSz (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 27 Mar 2019 11:18:55 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (Authenticated sender: tonyk)
        with ESMTPSA id 424A5281FF3
From:   =?UTF-8?q?Andr=C3=A9=20Almeida?= <andrealmeid@collabora.com>
To:     linux-media@vger.kernel.org
Cc:     mchehab@kernel.org, hverkuil@xs4all.nl, helen.koike@collabora.com,
        lucmaga@gmail.com, linux-kernel@vger.kernel.org,
        kernel@collabora.com, lkcamp@lists.libreplanetbr.org
Subject: [PATCH v2 01/15] media: Move sp2mp functions to v4l2-common
Date:   Wed, 27 Mar 2019 12:17:29 -0300
Message-Id: <20190327151743.18528-2-andrealmeid@collabora.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190327151743.18528-1-andrealmeid@collabora.com>
References: <20190327151743.18528-1-andrealmeid@collabora.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Move sp2mp functions from vivid code to v4l2-common as it will be reused
by vimc driver for multiplanar support.

Signed-off-by: André Almeida <andrealmeid@collabora.com>
---
Changes in v2:
- Fix indentation
- Change the style of comments. Functions now have a shorter title and a
better description bellow

 drivers/media/platform/vivid/vivid-vid-cap.c  |  6 +-
 .../media/platform/vivid/vivid-vid-common.c   | 59 ------------------
 .../media/platform/vivid/vivid-vid-common.h   |  9 ---
 drivers/media/platform/vivid/vivid-vid-out.c  |  6 +-
 drivers/media/v4l2-core/v4l2-common.c         | 62 +++++++++++++++++++
 include/media/v4l2-common.h                   | 37 +++++++++++
 6 files changed, 105 insertions(+), 74 deletions(-)

diff --git a/drivers/media/platform/vivid/vivid-vid-cap.c b/drivers/media/platform/vivid/vivid-vid-cap.c
index 52eeda624d7e..b5ad71bbf7bf 100644
--- a/drivers/media/platform/vivid/vivid-vid-cap.c
+++ b/drivers/media/platform/vivid/vivid-vid-cap.c
@@ -815,7 +815,7 @@ int vidioc_g_fmt_vid_cap(struct file *file, void *priv,
 
 	if (dev->multiplanar)
 		return -ENOTTY;
-	return fmt_sp2mp_func(file, priv, f, vivid_g_fmt_vid_cap);
+	return v4l2_fmt_sp2mp_func(file, priv, f, vivid_g_fmt_vid_cap);
 }
 
 int vidioc_try_fmt_vid_cap(struct file *file, void *priv,
@@ -825,7 +825,7 @@ int vidioc_try_fmt_vid_cap(struct file *file, void *priv,
 
 	if (dev->multiplanar)
 		return -ENOTTY;
-	return fmt_sp2mp_func(file, priv, f, vivid_try_fmt_vid_cap);
+	return v4l2_fmt_sp2mp_func(file, priv, f, vivid_try_fmt_vid_cap);
 }
 
 int vidioc_s_fmt_vid_cap(struct file *file, void *priv,
@@ -835,7 +835,7 @@ int vidioc_s_fmt_vid_cap(struct file *file, void *priv,
 
 	if (dev->multiplanar)
 		return -ENOTTY;
-	return fmt_sp2mp_func(file, priv, f, vivid_s_fmt_vid_cap);
+	return v4l2_fmt_sp2mp_func(file, priv, f, vivid_s_fmt_vid_cap);
 }
 
 int vivid_vid_cap_g_selection(struct file *file, void *priv,
diff --git a/drivers/media/platform/vivid/vivid-vid-common.c b/drivers/media/platform/vivid/vivid-vid-common.c
index 74b83bcc6119..3dd3a05d2e67 100644
--- a/drivers/media/platform/vivid/vivid-vid-common.c
+++ b/drivers/media/platform/vivid/vivid-vid-common.c
@@ -674,65 +674,6 @@ void vivid_send_source_change(struct vivid_dev *dev, unsigned type)
 	}
 }
 
-/*
- * Conversion function that converts a single-planar format to a
- * single-plane multiplanar format.
- */
-void fmt_sp2mp(const struct v4l2_format *sp_fmt, struct v4l2_format *mp_fmt)
-{
-	struct v4l2_pix_format_mplane *mp = &mp_fmt->fmt.pix_mp;
-	struct v4l2_plane_pix_format *ppix = &mp->plane_fmt[0];
-	const struct v4l2_pix_format *pix = &sp_fmt->fmt.pix;
-	bool is_out = sp_fmt->type == V4L2_BUF_TYPE_VIDEO_OUTPUT;
-
-	memset(mp->reserved, 0, sizeof(mp->reserved));
-	mp_fmt->type = is_out ? V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE :
-			   V4L2_CAP_VIDEO_CAPTURE_MPLANE;
-	mp->width = pix->width;
-	mp->height = pix->height;
-	mp->pixelformat = pix->pixelformat;
-	mp->field = pix->field;
-	mp->colorspace = pix->colorspace;
-	mp->xfer_func = pix->xfer_func;
-	/* Also copies hsv_enc */
-	mp->ycbcr_enc = pix->ycbcr_enc;
-	mp->quantization = pix->quantization;
-	mp->num_planes = 1;
-	mp->flags = pix->flags;
-	ppix->sizeimage = pix->sizeimage;
-	ppix->bytesperline = pix->bytesperline;
-	memset(ppix->reserved, 0, sizeof(ppix->reserved));
-}
-
-int fmt_sp2mp_func(struct file *file, void *priv,
-		struct v4l2_format *f, fmtfunc func)
-{
-	struct v4l2_format fmt;
-	struct v4l2_pix_format_mplane *mp = &fmt.fmt.pix_mp;
-	struct v4l2_plane_pix_format *ppix = &mp->plane_fmt[0];
-	struct v4l2_pix_format *pix = &f->fmt.pix;
-	int ret;
-
-	/* Converts to a mplane format */
-	fmt_sp2mp(f, &fmt);
-	/* Passes it to the generic mplane format function */
-	ret = func(file, priv, &fmt);
-	/* Copies back the mplane data to the single plane format */
-	pix->width = mp->width;
-	pix->height = mp->height;
-	pix->pixelformat = mp->pixelformat;
-	pix->field = mp->field;
-	pix->colorspace = mp->colorspace;
-	pix->xfer_func = mp->xfer_func;
-	/* Also copies hsv_enc */
-	pix->ycbcr_enc = mp->ycbcr_enc;
-	pix->quantization = mp->quantization;
-	pix->sizeimage = ppix->sizeimage;
-	pix->bytesperline = ppix->bytesperline;
-	pix->flags = mp->flags;
-	return ret;
-}
-
 int vivid_vid_adjust_sel(unsigned flags, struct v4l2_rect *r)
 {
 	unsigned w = r->width;
diff --git a/drivers/media/platform/vivid/vivid-vid-common.h b/drivers/media/platform/vivid/vivid-vid-common.h
index 29b6c0b40a1b..13adea56baa0 100644
--- a/drivers/media/platform/vivid/vivid-vid-common.h
+++ b/drivers/media/platform/vivid/vivid-vid-common.h
@@ -8,15 +8,6 @@
 #ifndef _VIVID_VID_COMMON_H_
 #define _VIVID_VID_COMMON_H_
 
-typedef int (*fmtfunc)(struct file *file, void *priv, struct v4l2_format *f);
-
-/*
- * Conversion function that converts a single-planar format to a
- * single-plane multiplanar format.
- */
-void fmt_sp2mp(const struct v4l2_format *sp_fmt, struct v4l2_format *mp_fmt);
-int fmt_sp2mp_func(struct file *file, void *priv,
-		struct v4l2_format *f, fmtfunc func);
 
 extern const struct v4l2_dv_timings_cap vivid_dv_timings_cap;
 
diff --git a/drivers/media/platform/vivid/vivid-vid-out.c b/drivers/media/platform/vivid/vivid-vid-out.c
index 9350ca65dd91..e9d68ccbcc5d 100644
--- a/drivers/media/platform/vivid/vivid-vid-out.c
+++ b/drivers/media/platform/vivid/vivid-vid-out.c
@@ -612,7 +612,7 @@ int vidioc_g_fmt_vid_out(struct file *file, void *priv,
 
 	if (dev->multiplanar)
 		return -ENOTTY;
-	return fmt_sp2mp_func(file, priv, f, vivid_g_fmt_vid_out);
+	return v4l2_fmt_sp2mp_func(file, priv, f, vivid_g_fmt_vid_out);
 }
 
 int vidioc_try_fmt_vid_out(struct file *file, void *priv,
@@ -622,7 +622,7 @@ int vidioc_try_fmt_vid_out(struct file *file, void *priv,
 
 	if (dev->multiplanar)
 		return -ENOTTY;
-	return fmt_sp2mp_func(file, priv, f, vivid_try_fmt_vid_out);
+	return v4l2_fmt_sp2mp_func(file, priv, f, vivid_try_fmt_vid_out);
 }
 
 int vidioc_s_fmt_vid_out(struct file *file, void *priv,
@@ -632,7 +632,7 @@ int vidioc_s_fmt_vid_out(struct file *file, void *priv,
 
 	if (dev->multiplanar)
 		return -ENOTTY;
-	return fmt_sp2mp_func(file, priv, f, vivid_s_fmt_vid_out);
+	return v4l2_fmt_sp2mp_func(file, priv, f, vivid_s_fmt_vid_out);
 }
 
 int vivid_vid_out_g_selection(struct file *file, void *priv,
diff --git a/drivers/media/v4l2-core/v4l2-common.c b/drivers/media/v4l2-core/v4l2-common.c
index 779e44d6db43..da294b812424 100644
--- a/drivers/media/v4l2-core/v4l2-common.c
+++ b/drivers/media/v4l2-core/v4l2-common.c
@@ -653,3 +653,65 @@ int v4l2_fill_pixfmt(struct v4l2_pix_format *pixfmt, int pixelformat, int width,
 	return 0;
 }
 EXPORT_SYMBOL_GPL(v4l2_fill_pixfmt);
+
+/*
+ * Conversion functions that convert a single-planar format to a
+ * multi-planar format.
+ */
+void v4l2_fmt_sp2mp(const struct v4l2_format *sp_fmt,
+		    struct v4l2_format *mp_fmt)
+{
+	struct v4l2_pix_format_mplane *mp = &mp_fmt->fmt.pix_mp;
+	struct v4l2_plane_pix_format *ppix = &mp->plane_fmt[0];
+	const struct v4l2_pix_format *pix = &sp_fmt->fmt.pix;
+	bool is_out = sp_fmt->type == V4L2_BUF_TYPE_VIDEO_OUTPUT;
+
+	memset(mp->reserved, 0, sizeof(mp->reserved));
+	mp_fmt->type = is_out ? V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE :
+			   V4L2_CAP_VIDEO_CAPTURE_MPLANE;
+	mp->width = pix->width;
+	mp->height = pix->height;
+	mp->pixelformat = pix->pixelformat;
+	mp->field = pix->field;
+	mp->colorspace = pix->colorspace;
+	mp->xfer_func = pix->xfer_func;
+	/* Also copies hsv_enc */
+	mp->ycbcr_enc = pix->ycbcr_enc;
+	mp->quantization = pix->quantization;
+	mp->num_planes = 1;
+	mp->flags = pix->flags;
+	ppix->sizeimage = pix->sizeimage;
+	ppix->bytesperline = pix->bytesperline;
+	memset(ppix->reserved, 0, sizeof(ppix->reserved));
+}
+EXPORT_SYMBOL_GPL(v4l2_fmt_sp2mp);
+
+int v4l2_fmt_sp2mp_func(struct file *file, void *priv, struct v4l2_format *f,
+			v4l2_fmtfunc func)
+{
+	struct v4l2_format fmt;
+	struct v4l2_pix_format_mplane *mp = &fmt.fmt.pix_mp;
+	struct v4l2_plane_pix_format *ppix = &mp->plane_fmt[0];
+	struct v4l2_pix_format *pix = &f->fmt.pix;
+	int ret;
+
+	/* Converts to a mplane format */
+	v4l2_fmt_sp2mp(f, &fmt);
+	/* Passes it to the generic mplane format function */
+	ret = func(file, priv, &fmt);
+	/* Copies back the mplane data to the single plane format */
+	pix->width = mp->width;
+	pix->height = mp->height;
+	pix->pixelformat = mp->pixelformat;
+	pix->field = mp->field;
+	pix->colorspace = mp->colorspace;
+	pix->xfer_func = mp->xfer_func;
+	/* Also copies hsv_enc */
+	pix->ycbcr_enc = mp->ycbcr_enc;
+	pix->quantization = mp->quantization;
+	pix->sizeimage = ppix->sizeimage;
+	pix->bytesperline = ppix->bytesperline;
+	pix->flags = mp->flags;
+	return ret;
+}
+EXPORT_SYMBOL_GPL(v4l2_fmt_sp2mp_func);
diff --git a/include/media/v4l2-common.h b/include/media/v4l2-common.h
index 937b74a946cd..c5be976ce49e 100644
--- a/include/media/v4l2-common.h
+++ b/include/media/v4l2-common.h
@@ -424,4 +424,41 @@ int v4l2_fill_pixfmt(struct v4l2_pix_format *pixfmt, int pixelformat,
 int v4l2_fill_pixfmt_mp(struct v4l2_pix_format_mplane *pixfmt, int pixelformat,
 			int width, int height);
 
+/**
+ * v4l2_fmtfunc - function pointer for v4l2_fmt_sp2mp()
+ *
+ * @file: device's descriptor file
+ * @priv: private data pointer
+ * @f: format that holds a mp pixel format
+ *
+ * Type to be passed as argument of v4l2_fmt_sp2mp() to be used by
+ * v4l2_fmt_sp2mp_func to pass the generic multi-planar function as argument.
+ */
+typedef int (*v4l2_fmtfunc)(struct file *file, void *priv,
+			    struct v4l2_format *f);
+
+/**
+ * v4l2_fmt_sp2mp - transforms a single-planar format struct into a multi-planar
+ * struct
+ *
+ * @sp_fmt: pointer to the single-planar format struct (in)
+ * @mp_fmt: pointer to the multi-planar format struct (out)
+ */
+void v4l2_fmt_sp2mp(const struct v4l2_format *sp_fmt,
+		    struct v4l2_format *mp_fmt);
+
+/**
+ * v4l2_fmt_sp2mp_func - handler for single-planar format functions
+ * @file: device's descriptor file
+ * @priv: private data pointer
+ * @f: format that holds a sp pixel format
+ * @func: generic mp function
+ *
+ * Handler to call a generic multi-planar format function using single-planar
+ * format. It converts the sp to a mp, calls the function and converts mp back
+ * to sp.
+ */
+int v4l2_fmt_sp2mp_func(struct file *file, void *priv, struct v4l2_format *f,
+			v4l2_fmtfunc func);
+
 #endif /* V4L2_COMMON_H_ */
-- 
2.21.0

