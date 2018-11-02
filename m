Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:35046 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726265AbeKCBAP (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 2 Nov 2018 21:00:15 -0400
From: Ezequiel Garcia <ezequiel@collabora.com>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>, kernel@collabora.com,
        Nicolas Dufresne <nicolas.dufresne@collabora.com>,
        Tomasz Figa <tfiga@chromium.org>,
        Ezequiel Garcia <ezequiel@collabora.com>
Subject: [PATCH v2 2/4] vicodec: Use pixel format helpers
Date: Fri,  2 Nov 2018 12:52:04 -0300
Message-Id: <20181102155206.13681-3-ezequiel@collabora.com>
In-Reply-To: <20181102155206.13681-1-ezequiel@collabora.com>
References: <20181102155206.13681-1-ezequiel@collabora.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Now that we've introduced the pixel format helpers, use them
in vicodec driver, and get rid of driver specific pixel
format specifiers.

Signed-off-by: Ezequiel Garcia <ezequiel@collabora.com>
---
 .../media/platform/vicodec/codec-v4l2-fwht.c  | 42 ++++----
 .../media/platform/vicodec/codec-v4l2-fwht.h  |  3 -
 drivers/media/platform/vicodec/vicodec-core.c | 95 ++++++-------------
 3 files changed, 48 insertions(+), 92 deletions(-)

diff --git a/drivers/media/platform/vicodec/codec-v4l2-fwht.c b/drivers/media/platform/vicodec/codec-v4l2-fwht.c
index e5b68fb38aac..42cf64dccaba 100644
--- a/drivers/media/platform/vicodec/codec-v4l2-fwht.c
+++ b/drivers/media/platform/vicodec/codec-v4l2-fwht.c
@@ -11,27 +11,27 @@
 #include "codec-v4l2-fwht.h"
 
 static const struct v4l2_fwht_pixfmt_info v4l2_fwht_pixfmts[] = {
-	{ V4L2_PIX_FMT_YUV420,  1, 3, 2, 1, 1, 2, 2 },
-	{ V4L2_PIX_FMT_YVU420,  1, 3, 2, 1, 1, 2, 2 },
-	{ V4L2_PIX_FMT_YUV422P, 1, 2, 1, 1, 1, 2, 1 },
-	{ V4L2_PIX_FMT_NV12,    1, 3, 2, 1, 2, 2, 2 },
-	{ V4L2_PIX_FMT_NV21,    1, 3, 2, 1, 2, 2, 2 },
-	{ V4L2_PIX_FMT_NV16,    1, 2, 1, 1, 2, 2, 1 },
-	{ V4L2_PIX_FMT_NV61,    1, 2, 1, 1, 2, 2, 1 },
-	{ V4L2_PIX_FMT_NV24,    1, 3, 1, 1, 2, 1, 1 },
-	{ V4L2_PIX_FMT_NV42,    1, 3, 1, 1, 2, 1, 1 },
-	{ V4L2_PIX_FMT_YUYV,    2, 2, 1, 2, 4, 2, 1 },
-	{ V4L2_PIX_FMT_YVYU,    2, 2, 1, 2, 4, 2, 1 },
-	{ V4L2_PIX_FMT_UYVY,    2, 2, 1, 2, 4, 2, 1 },
-	{ V4L2_PIX_FMT_VYUY,    2, 2, 1, 2, 4, 2, 1 },
-	{ V4L2_PIX_FMT_BGR24,   3, 3, 1, 3, 3, 1, 1 },
-	{ V4L2_PIX_FMT_RGB24,   3, 3, 1, 3, 3, 1, 1 },
-	{ V4L2_PIX_FMT_HSV24,   3, 3, 1, 3, 3, 1, 1 },
-	{ V4L2_PIX_FMT_BGR32,   4, 4, 1, 4, 4, 1, 1 },
-	{ V4L2_PIX_FMT_XBGR32,  4, 4, 1, 4, 4, 1, 1 },
-	{ V4L2_PIX_FMT_RGB32,   4, 4, 1, 4, 4, 1, 1 },
-	{ V4L2_PIX_FMT_XRGB32,  4, 4, 1, 4, 4, 1, 1 },
-	{ V4L2_PIX_FMT_HSV32,   4, 4, 1, 4, 4, 1, 1 },
+	{ V4L2_PIX_FMT_YUV420,  1, 1, 2, 2 },
+	{ V4L2_PIX_FMT_YVU420,  1, 1, 2, 2 },
+	{ V4L2_PIX_FMT_YUV422P, 1, 1, 2, 1 },
+	{ V4L2_PIX_FMT_NV12,    1, 2, 2, 2 },
+	{ V4L2_PIX_FMT_NV21,    1, 2, 2, 2 },
+	{ V4L2_PIX_FMT_NV16,    1, 2, 2, 1 },
+	{ V4L2_PIX_FMT_NV61,    1, 2, 2, 1 },
+	{ V4L2_PIX_FMT_NV24,    1, 2, 1, 1 },
+	{ V4L2_PIX_FMT_NV42,    1, 2, 1, 1 },
+	{ V4L2_PIX_FMT_YUYV,    2, 4, 2, 1 },
+	{ V4L2_PIX_FMT_YVYU,    2, 4, 2, 1 },
+	{ V4L2_PIX_FMT_UYVY,    2, 4, 2, 1 },
+	{ V4L2_PIX_FMT_VYUY,    2, 4, 2, 1 },
+	{ V4L2_PIX_FMT_BGR24,   3, 3, 1, 1 },
+	{ V4L2_PIX_FMT_RGB24,   3, 3, 1, 1 },
+	{ V4L2_PIX_FMT_HSV24,   3, 3, 1, 1 },
+	{ V4L2_PIX_FMT_BGR32,   4, 4, 1, 1 },
+	{ V4L2_PIX_FMT_XBGR32,  4, 4, 1, 1 },
+	{ V4L2_PIX_FMT_RGB32,   4, 4, 1, 1 },
+	{ V4L2_PIX_FMT_XRGB32,  4, 4, 1, 1 },
+	{ V4L2_PIX_FMT_HSV32,   4, 4, 1, 1 },
 };
 
 const struct v4l2_fwht_pixfmt_info *v4l2_fwht_find_pixfmt(u32 pixelformat)
diff --git a/drivers/media/platform/vicodec/codec-v4l2-fwht.h b/drivers/media/platform/vicodec/codec-v4l2-fwht.h
index 162465b78067..298a13732406 100644
--- a/drivers/media/platform/vicodec/codec-v4l2-fwht.h
+++ b/drivers/media/platform/vicodec/codec-v4l2-fwht.h
@@ -10,9 +10,6 @@
 
 struct v4l2_fwht_pixfmt_info {
 	u32 id;
-	unsigned int bytesperline_mult;
-	unsigned int sizeimage_mult;
-	unsigned int sizeimage_div;
 	unsigned int luma_step;
 	unsigned int chroma_step;
 	/* Chroma plane subsampling */
diff --git a/drivers/media/platform/vicodec/vicodec-core.c b/drivers/media/platform/vicodec/vicodec-core.c
index 1eb9132bfc85..dbc8b68894e7 100644
--- a/drivers/media/platform/vicodec/vicodec-core.c
+++ b/drivers/media/platform/vicodec/vicodec-core.c
@@ -43,25 +43,14 @@ MODULE_PARM_DESC(debug, " activates debug info");
 #define MIN_WIDTH		640U
 #define MAX_HEIGHT		2160U
 #define MIN_HEIGHT		480U
+#define DEF_WIDTH		1280U
+#define DEF_HEIGHT		720U
 
 #define dprintk(dev, fmt, arg...) \
 	v4l2_dbg(1, debug, &dev->v4l2_dev, "%s: " fmt, __func__, ## arg)
 
-
-struct pixfmt_info {
-	u32 id;
-	unsigned int bytesperline_mult;
-	unsigned int sizeimage_mult;
-	unsigned int sizeimage_div;
-	unsigned int luma_step;
-	unsigned int chroma_step;
-	/* Chroma plane subsampling */
-	unsigned int width_div;
-	unsigned int height_div;
-};
-
 static const struct v4l2_fwht_pixfmt_info pixfmt_fwht = {
-	V4L2_PIX_FMT_FWHT, 0, 3, 1, 1, 1, 1, 1
+	V4L2_PIX_FMT_FWHT, 1, 1, 1, 1
 };
 
 static void vicodec_dev_release(struct device *dev)
@@ -466,12 +455,8 @@ static int vidioc_g_fmt(struct vicodec_ctx *ctx, struct v4l2_format *f)
 		if (multiplanar)
 			return -EINVAL;
 		pix = &f->fmt.pix;
-		pix->width = q_data->width;
-		pix->height = q_data->height;
+		v4l2_fill_pixfmt(pix, info->id, q_data->width, q_data->height);
 		pix->field = V4L2_FIELD_NONE;
-		pix->pixelformat = info->id;
-		pix->bytesperline = q_data->width * info->bytesperline_mult;
-		pix->sizeimage = q_data->sizeimage;
 		pix->colorspace = ctx->state.colorspace;
 		pix->xfer_func = ctx->state.xfer_func;
 		pix->ycbcr_enc = ctx->state.ycbcr_enc;
@@ -483,14 +468,9 @@ static int vidioc_g_fmt(struct vicodec_ctx *ctx, struct v4l2_format *f)
 		if (!multiplanar)
 			return -EINVAL;
 		pix_mp = &f->fmt.pix_mp;
-		pix_mp->width = q_data->width;
-		pix_mp->height = q_data->height;
+
+		v4l2_fill_pixfmt_mp(pix_mp, info->id, q_data->width, q_data->height);
 		pix_mp->field = V4L2_FIELD_NONE;
-		pix_mp->pixelformat = info->id;
-		pix_mp->num_planes = 1;
-		pix_mp->plane_fmt[0].bytesperline =
-				q_data->width * info->bytesperline_mult;
-		pix_mp->plane_fmt[0].sizeimage = q_data->sizeimage;
 		pix_mp->colorspace = ctx->state.colorspace;
 		pix_mp->xfer_func = ctx->state.xfer_func;
 		pix_mp->ycbcr_enc = ctx->state.ycbcr_enc;
@@ -520,43 +500,26 @@ static int vidioc_g_fmt_vid_cap(struct file *file, void *priv,
 static int vidioc_try_fmt(struct vicodec_ctx *ctx, struct v4l2_format *f)
 {
 	struct v4l2_pix_format_mplane *pix_mp;
-	struct v4l2_pix_format *pix;
 	struct v4l2_plane_pix_format *plane;
-	const struct v4l2_fwht_pixfmt_info *info = &pixfmt_fwht;
+	struct v4l2_pix_format *pix;
+	unsigned int width, height;
 
 	switch (f->type) {
 	case V4L2_BUF_TYPE_VIDEO_CAPTURE:
 	case V4L2_BUF_TYPE_VIDEO_OUTPUT:
 		pix = &f->fmt.pix;
-		if (pix->pixelformat != V4L2_PIX_FMT_FWHT)
-			info = find_fmt(pix->pixelformat);
-		pix->width = clamp(pix->width, MIN_WIDTH, MAX_WIDTH) & ~7;
-		pix->height = clamp(pix->height, MIN_HEIGHT, MAX_HEIGHT) & ~7;
+		width = clamp(pix->width, MIN_WIDTH, MAX_WIDTH) & ~7;
+		height = clamp(pix->height, MIN_HEIGHT, MAX_HEIGHT) & ~7;
+		v4l2_fill_pixfmt(pix, pix->pixelformat, width, height);
 		pix->field = V4L2_FIELD_NONE;
-		pix->bytesperline =
-			pix->width * info->bytesperline_mult;
-		pix->sizeimage = pix->width * pix->height *
-			info->sizeimage_mult / info->sizeimage_div;
-		if (pix->pixelformat == V4L2_PIX_FMT_FWHT)
-			pix->sizeimage += sizeof(struct fwht_cframe_hdr);
 		break;
 	case V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE:
 	case V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE:
 		pix_mp = &f->fmt.pix_mp;
-		plane = pix_mp->plane_fmt;
-		if (pix_mp->pixelformat != V4L2_PIX_FMT_FWHT)
-			info = find_fmt(pix_mp->pixelformat);
-		pix_mp->num_planes = 1;
-		pix_mp->width = clamp(pix_mp->width, MIN_WIDTH, MAX_WIDTH) & ~7;
-		pix_mp->height =
-			clamp(pix_mp->height, MIN_HEIGHT, MAX_HEIGHT) & ~7;
+		width = clamp(pix_mp->width, MIN_WIDTH, MAX_WIDTH) & ~7;
+		height = clamp(pix_mp->height, MIN_HEIGHT, MAX_HEIGHT) & ~7;
+		v4l2_fill_pixfmt_mp(pix_mp, pix_mp->pixelformat, width, height);
 		pix_mp->field = V4L2_FIELD_NONE;
-		plane->bytesperline =
-			pix_mp->width * info->bytesperline_mult;
-		plane->sizeimage = pix_mp->width * pix_mp->height *
-			info->sizeimage_mult / info->sizeimage_div;
-		if (pix_mp->pixelformat == V4L2_PIX_FMT_FWHT)
-			plane->sizeimage += sizeof(struct fwht_cframe_hdr);
 		memset(pix_mp->reserved, 0, sizeof(pix_mp->reserved));
 		memset(plane->reserved, 0, sizeof(plane->reserved));
 		break;
@@ -1143,7 +1106,7 @@ static int vicodec_open(struct file *file)
 	struct vicodec_dev *dev = video_drvdata(file);
 	struct vicodec_ctx *ctx = NULL;
 	struct v4l2_ctrl_handler *hdl;
-	unsigned int size;
+	struct v4l2_pix_format pixfmt;
 	int rc = 0;
 
 	if (mutex_lock_interruptible(vfd->lock))
@@ -1177,25 +1140,21 @@ static int vicodec_open(struct file *file)
 
 	ctx->q_data[V4L2_M2M_SRC].info =
 		ctx->is_enc ? v4l2_fwht_get_pixfmt(0) : &pixfmt_fwht;
-	ctx->q_data[V4L2_M2M_SRC].width = 1280;
-	ctx->q_data[V4L2_M2M_SRC].height = 720;
-	size = 1280 * 720 * ctx->q_data[V4L2_M2M_SRC].info->sizeimage_mult /
-		ctx->q_data[V4L2_M2M_SRC].info->sizeimage_div;
-	if (ctx->is_enc)
-		ctx->q_data[V4L2_M2M_SRC].sizeimage = size;
-	else
-		ctx->q_data[V4L2_M2M_SRC].sizeimage =
-			size + sizeof(struct fwht_cframe_hdr);
+	v4l2_fill_pixfmt(&pixfmt, ctx->q_data[V4L2_M2M_SRC].info->id,
+			DEF_WIDTH, DEF_HEIGHT);
+	ctx->q_data[V4L2_M2M_SRC].width = DEF_WIDTH;
+	ctx->q_data[V4L2_M2M_SRC].height = DEF_HEIGHT;
+	ctx->q_data[V4L2_M2M_SRC].sizeimage = pixfmt.sizeimage;
+
 	ctx->q_data[V4L2_M2M_DST] = ctx->q_data[V4L2_M2M_SRC];
 	ctx->q_data[V4L2_M2M_DST].info =
 		ctx->is_enc ? &pixfmt_fwht : v4l2_fwht_get_pixfmt(0);
-	size = 1280 * 720 * ctx->q_data[V4L2_M2M_DST].info->sizeimage_mult /
-		ctx->q_data[V4L2_M2M_DST].info->sizeimage_div;
-	if (ctx->is_enc)
-		ctx->q_data[V4L2_M2M_DST].sizeimage =
-			size + sizeof(struct fwht_cframe_hdr);
-	else
-		ctx->q_data[V4L2_M2M_DST].sizeimage = size;
+	v4l2_fill_pixfmt(&pixfmt, ctx->q_data[V4L2_M2M_DST].info->id,
+			DEF_WIDTH, DEF_HEIGHT);
+	ctx->q_data[V4L2_M2M_SRC].width = DEF_WIDTH;
+	ctx->q_data[V4L2_M2M_SRC].height = DEF_HEIGHT;
+	ctx->q_data[V4L2_M2M_SRC].sizeimage = pixfmt.sizeimage;
+
 	ctx->state.colorspace = V4L2_COLORSPACE_REC709;
 
 	if (ctx->is_enc) {
-- 
2.19.1
