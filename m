Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:51033 "EHLO
        relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751714AbeFFNWH (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 6 Jun 2018 09:22:07 -0400
From: Jacopo Mondi <jacopo+renesas@jmondi.org>
To: niklas.soderlund@ragnatech.se, laurent.pinchart@ideasonboard.com,
        kieran.bingham@ideasonboard.com
Cc: Jacopo Mondi <jacopo+renesas@jmondi.org>, mchehab@kernel.org,
        linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org
Subject: [PATCH] media: renesas-ceu: Add support for YUYV permutations
Date: Wed,  6 Jun 2018 15:21:53 +0200
Message-Id: <1528291313-20471-1-git-send-email-jacopo+renesas@jmondi.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add support for YUYV permutations, passing down to the subdevice the media bus
format with components ordering that reflect the output pixel format one.

Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
---
 drivers/media/platform/renesas-ceu.c | 91 ++++++++++++++++++++++++++++++------
 1 file changed, 78 insertions(+), 13 deletions(-)

diff --git a/drivers/media/platform/renesas-ceu.c b/drivers/media/platform/renesas-ceu.c
index fe4fe94..46b0639 100644
--- a/drivers/media/platform/renesas-ceu.c
+++ b/drivers/media/platform/renesas-ceu.c
@@ -254,6 +254,18 @@ static const struct ceu_fmt ceu_fmt_list[] = {
 		.fourcc	= V4L2_PIX_FMT_YUYV,
 		.bpp	= 16,
 	},
+	{
+		.fourcc	= V4L2_PIX_FMT_UYVY,
+		.bpp	= 16,
+	},
+	{
+		.fourcc	= V4L2_PIX_FMT_YVYU,
+		.bpp	= 16,
+	},
+	{
+		.fourcc	= V4L2_PIX_FMT_VYUY,
+		.bpp	= 16,
+	},
 };

 static const struct ceu_fmt *get_ceu_fmt_from_fourcc(unsigned int fourcc)
@@ -272,6 +284,9 @@ static bool ceu_fmt_mplane(struct v4l2_pix_format_mplane *pix)
 {
 	switch (pix->pixelformat) {
 	case V4L2_PIX_FMT_YUYV:
+	case V4L2_PIX_FMT_UYVY:
+	case V4L2_PIX_FMT_YVYU:
+	case V4L2_PIX_FMT_VYUY:
 		return false;
 	case V4L2_PIX_FMT_NV16:
 	case V4L2_PIX_FMT_NV61:
@@ -380,7 +395,9 @@ static int ceu_hw_config(struct ceu_device *ceudev)
 	switch (pix->pixelformat) {
 	/* Data fetch sync mode */
 	case V4L2_PIX_FMT_YUYV:
-		/* TODO: handle YUYV permutations through DTARY bits. */
+	case V4L2_PIX_FMT_YVYU:
+	case V4L2_PIX_FMT_UYVY:
+	case V4L2_PIX_FMT_VYUY:
 		camcr	= CEU_CAMCR_JPEG;
 		cdocr	|= CEU_CDOCR_NO_DOWSAMPLE;
 		cfzsr	= (pix->height << 16) | pix->width;
@@ -568,6 +585,9 @@ static void ceu_calc_plane_sizes(struct ceu_device *ceudev,

 	switch (pix->pixelformat) {
 	case V4L2_PIX_FMT_YUYV:
+	case V4L2_PIX_FMT_UYVY:
+	case V4L2_PIX_FMT_YVYU:
+	case V4L2_PIX_FMT_VYUY:
 		pix->num_planes	= 1;
 		bpl		= pix->width * ceu_fmt->bpp / 8;
 		szimage		= pix->height * bpl;
@@ -762,42 +782,59 @@ static const struct vb2_ops ceu_vb2_ops = {
 /* --- CEU image formats handling --- */

 /*
- * ceu_try_fmt() - test format on CEU and sensor
+ * __ceu_try_fmt() - test format on CEU and sensor
  * @ceudev: The CEU device.
  * @v4l2_fmt: format to test.
+ * @sd_mbus_code: the media bus code accepted by the subdevice; output param.
  *
  * Returns 0 for success, < 0 for errors.
  */
-static int ceu_try_fmt(struct ceu_device *ceudev, struct v4l2_format *v4l2_fmt)
+static int __ceu_try_fmt(struct ceu_device *ceudev, struct v4l2_format *v4l2_fmt,
+			 u32 *sd_mbus_code)
 {
 	struct ceu_subdev *ceu_sd = ceudev->sd;
 	struct v4l2_pix_format_mplane *pix = &v4l2_fmt->fmt.pix_mp;
 	struct v4l2_subdev *v4l2_sd = ceu_sd->v4l2_sd;
 	struct v4l2_subdev_pad_config pad_cfg;
 	const struct ceu_fmt *ceu_fmt;
+	u32 mbus_code_old;
+	u32 mbus_code;
 	int ret;

 	/*
 	 * Set format on sensor sub device: bus format used to produce memory
-	 * format is selected at initialization time.
+	 * format is selected depending on YUV component ordering or
+	 * at initialization time.
 	 */
 	struct v4l2_subdev_format sd_format = {
 		.which	= V4L2_SUBDEV_FORMAT_TRY,
-		.format	= {
-			.code = ceu_sd->mbus_fmt.mbus_code,
-		},
 	};

+	mbus_code_old = ceu_sd->mbus_fmt.mbus_code;
+
 	switch (pix->pixelformat) {
 	case V4L2_PIX_FMT_YUYV:
+		mbus_code = MEDIA_BUS_FMT_YUYV8_2X8;
+		break;
+	case V4L2_PIX_FMT_UYVY:
+		mbus_code = MEDIA_BUS_FMT_UYVY8_2X8;
+		break;
+	case V4L2_PIX_FMT_YVYU:
+		mbus_code = MEDIA_BUS_FMT_YVYU8_2X8;
+		break;
+	case V4L2_PIX_FMT_VYUY:
+		mbus_code = MEDIA_BUS_FMT_VYUY8_2X8;
+		break;
 	case V4L2_PIX_FMT_NV16:
 	case V4L2_PIX_FMT_NV61:
 	case V4L2_PIX_FMT_NV12:
 	case V4L2_PIX_FMT_NV21:
+		mbus_code = ceu_sd->mbus_fmt.mbus_code;
 		break;

 	default:
 		pix->pixelformat = V4L2_PIX_FMT_NV16;
+		mbus_code = ceu_sd->mbus_fmt.mbus_code;
 		break;
 	}

@@ -808,9 +845,25 @@ static int ceu_try_fmt(struct ceu_device *ceudev, struct v4l2_format *v4l2_fmt)
 			      &pix->height, 4, CEU_MAX_HEIGHT, 4, 0);

 	v4l2_fill_mbus_format_mplane(&sd_format.format, pix);
+
+	/*
+	 * Try with the mbus_code matching YUYV components ordering first,
+	 * if that one fails, fallback to default selected at initialization
+	 * time.
+	 */
+	sd_format.format.code = mbus_code;
 	ret = v4l2_subdev_call(v4l2_sd, pad, set_fmt, &pad_cfg, &sd_format);
-	if (ret)
-		return ret;
+	if (ret) {
+		if (ret == -EINVAL) {
+			/* fallback */
+			sd_format.format.code = mbus_code_old;
+			ret = v4l2_subdev_call(v4l2_sd, pad, set_fmt,
+					       &pad_cfg, &sd_format);
+		}
+
+		if (ret)
+			return ret;
+	}

 	/* Apply size returned by sensor as the CEU can't scale. */
 	v4l2_fill_pix_format_mplane(pix, &sd_format.format);
@@ -818,16 +871,30 @@ static int ceu_try_fmt(struct ceu_device *ceudev, struct v4l2_format *v4l2_fmt)
 	/* Calculate per-plane sizes based on image format. */
 	ceu_calc_plane_sizes(ceudev, ceu_fmt, pix);

+	/* Report to caller the configured mbus format. */
+	*sd_mbus_code = sd_format.format.code;
+
 	return 0;
 }

 /*
+ * ceu_try_fmt() - Wrapper for __ceu_try_fmt; discard configured mbus_fmt
+ */
+static int ceu_try_fmt(struct ceu_device *ceudev, struct v4l2_format *v4l2_fmt)
+{
+	u32 mbus_code;
+
+	return __ceu_try_fmt(ceudev, v4l2_fmt, &mbus_code);
+}
+
+/*
  * ceu_set_fmt() - Apply the supplied format to both sensor and CEU
  */
 static int ceu_set_fmt(struct ceu_device *ceudev, struct v4l2_format *v4l2_fmt)
 {
 	struct ceu_subdev *ceu_sd = ceudev->sd;
 	struct v4l2_subdev *v4l2_sd = ceu_sd->v4l2_sd;
+	u32 mbus_code;
 	int ret;

 	/*
@@ -836,15 +903,13 @@ static int ceu_set_fmt(struct ceu_device *ceudev, struct v4l2_format *v4l2_fmt)
 	 */
 	struct v4l2_subdev_format format = {
 		.which = V4L2_SUBDEV_FORMAT_ACTIVE,
-		.format	= {
-			.code = ceu_sd->mbus_fmt.mbus_code,
-		},
 	};

-	ret = ceu_try_fmt(ceudev, v4l2_fmt);
+	ret = __ceu_try_fmt(ceudev, v4l2_fmt, &mbus_code);
 	if (ret)
 		return ret;

+	format.format.code = mbus_code;
 	v4l2_fill_mbus_format_mplane(&format.format, &v4l2_fmt->fmt.pix_mp);
 	ret = v4l2_subdev_call(v4l2_sd, pad, set_fmt, NULL, &format);
 	if (ret)
--
2.7.4
