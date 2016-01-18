Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f68.google.com ([209.85.220.68]:33899 "EHLO
	mail-pa0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754724AbcARMWj (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 18 Jan 2016 07:22:39 -0500
Received: by mail-pa0-f68.google.com with SMTP id yy13so32554284pab.1
        for <linux-media@vger.kernel.org>; Mon, 18 Jan 2016 04:22:39 -0800 (PST)
From: Josh Wu <rainyfeeling@gmail.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>,
	linux-arm-kernel@lists.infradead.org,
	Ludovic Desroches <ludovic.desroches@atmel.com>,
	Songjun Wu <songjun.wu@atmel.com>, Josh Wu <josh.wu@atmel.com>,
	Josh Wu <rainyfeeling@gmail.com>
Subject: [PATCH 01/13] atmel-isi: use try_or_set_fmt() for both set_fmt() and try_fmt()
Date: Mon, 18 Jan 2016 20:21:37 +0800
Message-Id: <1453119709-20940-2-git-send-email-rainyfeeling@gmail.com>
In-Reply-To: <1453119709-20940-1-git-send-email-rainyfeeling@gmail.com>
References: <1453119709-20940-1-git-send-email-rainyfeeling@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Josh Wu <josh.wu@atmel.com>

Since atmel-isi has similar set_fmt() and try_fmt() functions. So this
patch will add a new function which can be called by set_fmt() and
try_fmt().

That can increase the reusability.

Signed-off-by: Josh Wu <rainyfeeling@gmail.com>
---

 drivers/media/platform/soc_camera/atmel-isi.c | 105 ++++++++++----------------
 1 file changed, 41 insertions(+), 64 deletions(-)

diff --git a/drivers/media/platform/soc_camera/atmel-isi.c b/drivers/media/platform/soc_camera/atmel-isi.c
index c398b28..dc81df3 100644
--- a/drivers/media/platform/soc_camera/atmel-isi.c
+++ b/drivers/media/platform/soc_camera/atmel-isi.c
@@ -571,16 +571,16 @@ static int isi_camera_init_videobuf(struct vb2_queue *q,
 	return vb2_queue_init(q);
 }
 
-static int isi_camera_set_fmt(struct soc_camera_device *icd,
-			      struct v4l2_format *f)
+static int try_or_set_fmt(struct soc_camera_device *icd,
+		   struct v4l2_format *f,
+		   struct v4l2_subdev_format *format)
 {
-	struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
-	const struct soc_camera_format_xlate *xlate;
 	struct v4l2_pix_format *pix = &f->fmt.pix;
-	struct v4l2_subdev_format format = {
-		.which = V4L2_SUBDEV_FORMAT_ACTIVE,
-	};
-	struct v4l2_mbus_framefmt *mf = &format.format;
+	const struct soc_camera_format_xlate *xlate;
+	struct v4l2_subdev_pad_config pad_cfg;
+
+	struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
+	struct v4l2_mbus_framefmt *mf = &format->format;
 	int ret;
 
 	/* check with atmel-isi support format, if not support use YUYV */
@@ -594,8 +594,11 @@ static int isi_camera_set_fmt(struct soc_camera_device *icd,
 		return -EINVAL;
 	}
 
-	dev_dbg(icd->parent, "Plan to set format %dx%d\n",
-			pix->width, pix->height);
+	/* limit to Atmel ISI hardware capabilities */
+	if (pix->height > MAX_SUPPORT_HEIGHT)
+		pix->height = MAX_SUPPORT_HEIGHT;
+	if (pix->width > MAX_SUPPORT_WIDTH)
+		pix->width = MAX_SUPPORT_WIDTH;
 
 	mf->width	= pix->width;
 	mf->height	= pix->height;
@@ -603,7 +606,11 @@ static int isi_camera_set_fmt(struct soc_camera_device *icd,
 	mf->colorspace	= pix->colorspace;
 	mf->code	= xlate->code;
 
-	ret = v4l2_subdev_call(sd, pad, set_fmt, NULL, &format);
+	if (format->which == V4L2_SUBDEV_FORMAT_ACTIVE)
+		ret = v4l2_subdev_call(sd, pad, set_fmt, NULL, format);
+	else
+		ret = v4l2_subdev_call(sd, pad, set_fmt, &pad_cfg, format);
+
 	if (ret < 0)
 		return ret;
 
@@ -614,64 +621,14 @@ static int isi_camera_set_fmt(struct soc_camera_device *icd,
 	pix->height		= mf->height;
 	pix->field		= mf->field;
 	pix->colorspace		= mf->colorspace;
-	icd->current_fmt	= xlate;
-
-	dev_dbg(icd->parent, "Finally set format %dx%d\n",
-		pix->width, pix->height);
-
-	return ret;
-}
-
-static int isi_camera_try_fmt(struct soc_camera_device *icd,
-			      struct v4l2_format *f)
-{
-	struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
-	const struct soc_camera_format_xlate *xlate;
-	struct v4l2_pix_format *pix = &f->fmt.pix;
-	struct v4l2_subdev_pad_config pad_cfg;
-	struct v4l2_subdev_format format = {
-		.which = V4L2_SUBDEV_FORMAT_TRY,
-	};
-	struct v4l2_mbus_framefmt *mf = &format.format;
-	u32 pixfmt = pix->pixelformat;
-	int ret;
-
-	/* check with atmel-isi support format, if not support use YUYV */
-	if (!is_supported(icd, pix->pixelformat))
-		pix->pixelformat = V4L2_PIX_FMT_YUYV;
-
-	xlate = soc_camera_xlate_by_fourcc(icd, pixfmt);
-	if (pixfmt && !xlate) {
-		dev_warn(icd->parent, "Format %x not found\n", pixfmt);
-		return -EINVAL;
-	}
 
-	/* limit to Atmel ISI hardware capabilities */
-	if (pix->height > MAX_SUPPORT_HEIGHT)
-		pix->height = MAX_SUPPORT_HEIGHT;
-	if (pix->width > MAX_SUPPORT_WIDTH)
-		pix->width = MAX_SUPPORT_WIDTH;
-
-	/* limit to sensor capabilities */
-	mf->width	= pix->width;
-	mf->height	= pix->height;
-	mf->field	= pix->field;
-	mf->colorspace	= pix->colorspace;
-	mf->code	= xlate->code;
-
-	ret = v4l2_subdev_call(sd, pad, set_fmt, &pad_cfg, &format);
-	if (ret < 0)
-		return ret;
-
-	pix->width	= mf->width;
-	pix->height	= mf->height;
-	pix->colorspace	= mf->colorspace;
+	if (format->which == V4L2_SUBDEV_FORMAT_ACTIVE)
+		icd->current_fmt = xlate;
 
 	switch (mf->field) {
 	case V4L2_FIELD_ANY:
-		pix->field = V4L2_FIELD_NONE;
-		break;
 	case V4L2_FIELD_NONE:
+		pix->field = V4L2_FIELD_NONE;
 		break;
 	default:
 		dev_err(icd->parent, "Field type %d unsupported.\n",
@@ -682,6 +639,26 @@ static int isi_camera_try_fmt(struct soc_camera_device *icd,
 	return ret;
 }
 
+static int isi_camera_set_fmt(struct soc_camera_device *icd,
+			      struct v4l2_format *f)
+{
+	struct v4l2_subdev_format format = {
+		.which = V4L2_SUBDEV_FORMAT_ACTIVE,
+	};
+
+	return try_or_set_fmt(icd, f, &format);
+}
+
+static int isi_camera_try_fmt(struct soc_camera_device *icd,
+			      struct v4l2_format *f)
+{
+	struct v4l2_subdev_format format = {
+		.which = V4L2_SUBDEV_FORMAT_TRY,
+	};
+
+	return try_or_set_fmt(icd, f, &format);
+}
+
 static const struct soc_mbus_pixelfmt isi_camera_formats[] = {
 	{
 		.fourcc			= V4L2_PIX_FMT_YUYV,
-- 
1.9.1

