Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:46393 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755512Ab3I3NfB (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 30 Sep 2013 09:35:01 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Kamil Debski <k.debski@samsung.com>,
	Javier Martin <javier.martin@vista-silicon.com>,
	Hans Verkuil <hans.verkuil@cisco.com>, kernel@pengutronix.de,
	Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH v2 08/10] [media] coda: v4l2-compliance fix: overwrite invalid pixel formats with the current setting
Date: Mon, 30 Sep 2013 15:34:51 +0200
Message-Id: <1380548093-22313-9-git-send-email-p.zabel@pengutronix.de>
In-Reply-To: <1380548093-22313-1-git-send-email-p.zabel@pengutronix.de>
References: <1380548093-22313-1-git-send-email-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch fixes the v4l2-compliance "TRY_FMT(G_FMT) != G_FMT" issue.

The driver now overwrites invalid formats with the current setting, using
coda_get_max_dimensions to find device specific max width/height.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/media/platform/coda.c | 72 +++++++++++++++++++++++++++++++++----------
 1 file changed, 56 insertions(+), 16 deletions(-)

diff --git a/drivers/media/platform/coda.c b/drivers/media/platform/coda.c
index 6286133..1572929 100644
--- a/drivers/media/platform/coda.c
+++ b/drivers/media/platform/coda.c
@@ -54,8 +54,6 @@
 
 #define CODA_MAX_FRAMEBUFFERS	8
 
-#define MAX_W		8192
-#define MAX_H		8192
 #define CODA_MAX_FRAME_SIZE	0x100000
 #define FMO_SLICE_SAVE_BUF_SIZE         (32)
 #define CODA_DEFAULT_GAMMA		4096
@@ -394,6 +392,31 @@ static struct coda_codec *coda_find_codec(struct coda_dev *dev, int src_fourcc,
 	return &codecs[k];
 }
 
+static void coda_get_max_dimensions(struct coda_dev *dev,
+				    struct coda_codec *codec,
+				    int *max_w, int *max_h)
+{
+	struct coda_codec *codecs = dev->devtype->codecs;
+	int num_codecs = dev->devtype->num_codecs;
+	unsigned int w, h;
+	int k;
+
+	if (codec) {
+		w = codec->max_w;
+		h = codec->max_h;
+	} else {
+		for (k = 0, w = 0, h = 0; k < num_codecs; k++) {
+			w = max(w, codecs[k].max_w);
+			h = max(h, codecs[k].max_h);
+		}
+	}
+
+	if (max_w)
+		*max_w = w;
+	if (max_h)
+		*max_h = h;
+}
+
 static char *coda_product_name(int product)
 {
 	static char buf[9];
@@ -537,8 +560,11 @@ static int coda_g_fmt(struct file *file, void *priv,
 	return 0;
 }
 
-static int coda_try_fmt(struct coda_codec *codec, struct v4l2_format *f)
+static int coda_try_fmt(struct coda_ctx *ctx, struct coda_codec *codec,
+			struct v4l2_format *f)
 {
+	struct coda_dev *dev = ctx->dev;
+	struct coda_q_data *q_data;
 	unsigned int max_w, max_h;
 	enum v4l2_field field;
 
@@ -552,25 +578,39 @@ static int coda_try_fmt(struct coda_codec *codec, struct v4l2_format *f)
 	 * if any of the dimensions is unsupported */
 	f->fmt.pix.field = field;
 
-	if (codec) {
-		max_w = codec->max_w;
-		max_h = codec->max_h;
-	} else {
-		max_w = MAX_W;
-		max_h = MAX_H;
+	coda_get_max_dimensions(dev, codec, &max_w, &max_h);
+	v4l_bound_align_image(&f->fmt.pix.width, MIN_W, max_w, W_ALIGN,
+			      &f->fmt.pix.height, MIN_H, max_h, H_ALIGN,
+			      S_ALIGN);
+
+	switch (f->fmt.pix.pixelformat) {
+	case V4L2_PIX_FMT_YUV420:
+	case V4L2_PIX_FMT_YVU420:
+	case V4L2_PIX_FMT_H264:
+	case V4L2_PIX_FMT_MPEG4:
+	case V4L2_PIX_FMT_JPEG:
+		break;
+	default:
+		q_data = get_q_data(ctx, f->type);
+		f->fmt.pix.pixelformat = q_data->fourcc;
 	}
-	v4l_bound_align_image(&f->fmt.pix.width, MIN_W, max_w,
-			      W_ALIGN, &f->fmt.pix.height,
-			      MIN_H, max_h, H_ALIGN, S_ALIGN);
 
-	if (coda_format_is_yuv(f->fmt.pix.pixelformat)) {
+	switch (f->fmt.pix.pixelformat) {
+	case V4L2_PIX_FMT_YUV420:
+	case V4L2_PIX_FMT_YVU420:
 		/* Frame stride must be multiple of 8 */
 		f->fmt.pix.bytesperline = round_up(f->fmt.pix.width, 8);
 		f->fmt.pix.sizeimage = f->fmt.pix.bytesperline *
 					f->fmt.pix.height * 3 / 2;
-	} else { /*encoded formats h.264/mpeg4 */
+		break;
+	case V4L2_PIX_FMT_H264:
+	case V4L2_PIX_FMT_MPEG4:
+	case V4L2_PIX_FMT_JPEG:
 		f->fmt.pix.bytesperline = 0;
 		f->fmt.pix.sizeimage = CODA_MAX_FRAME_SIZE;
+		break;
+	default:
+		BUG();
 	}
 
 	return 0;
@@ -605,7 +645,7 @@ static int coda_try_fmt_vid_cap(struct file *file, void *priv,
 
 	f->fmt.pix.colorspace = ctx->colorspace;
 
-	ret = coda_try_fmt(codec, f);
+	ret = coda_try_fmt(ctx, codec, f);
 	if (ret < 0)
 		return ret;
 
@@ -634,7 +674,7 @@ static int coda_try_fmt_vid_out(struct file *file, void *priv,
 	if (!f->fmt.pix.colorspace)
 		f->fmt.pix.colorspace = V4L2_COLORSPACE_REC709;
 
-	return coda_try_fmt(codec, f);
+	return coda_try_fmt(ctx, codec, f);
 }
 
 static int coda_s_fmt(struct coda_ctx *ctx, struct v4l2_format *f)
-- 
1.8.4.rc3

