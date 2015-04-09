Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud3.xs4all.net ([194.109.24.26]:57486 "EHLO
	lb2-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933699AbbDIKWV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 9 Apr 2015 06:22:21 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Scott Jiang <scott.jiang.linux@gmail.com>,
	Jonathan Corbet <corbet@lwn.net>
Subject: [PATCH 5/7] v4l2: replace try_mbus_fmt by set_fmt in bridge drivers
Date: Thu,  9 Apr 2015 12:21:26 +0200
Message-Id: <1428574888-46407-6-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1428574888-46407-1-git-send-email-hverkuil@xs4all.nl>
References: <1428574888-46407-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Replace all calls to try_mbus_fmt in bridge drivers by calls to the
set_fmt pad op.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Scott Jiang <scott.jiang.linux@gmail.com>
Cc: Jonathan Corbet <corbet@lwn.net>
---
 drivers/media/pci/saa7134/saa7134-empress.c        | 11 +++---
 drivers/media/platform/blackfin/bfin_capture.c     | 15 ++++----
 drivers/media/platform/marvell-ccic/mcam-core.c    | 11 +++---
 drivers/media/platform/soc_camera/atmel-isi.c      | 28 ++++++++-------
 drivers/media/platform/soc_camera/mx2_camera.c     | 38 +++++++++++---------
 drivers/media/platform/soc_camera/mx3_camera.c     | 28 ++++++++-------
 drivers/media/platform/soc_camera/omap1_camera.c   | 26 ++++++++------
 drivers/media/platform/soc_camera/pxa_camera.c     | 28 ++++++++-------
 drivers/media/platform/soc_camera/rcar_vin.c       | 42 ++++++++++++----------
 .../platform/soc_camera/sh_mobile_ceu_camera.c     | 38 +++++++++++---------
 drivers/media/platform/via-camera.c                | 11 +++---
 11 files changed, 158 insertions(+), 118 deletions(-)

diff --git a/drivers/media/pci/saa7134/saa7134-empress.c b/drivers/media/pci/saa7134/saa7134-empress.c
index 22632f9..dc14930 100644
--- a/drivers/media/pci/saa7134/saa7134-empress.c
+++ b/drivers/media/pci/saa7134/saa7134-empress.c
@@ -157,11 +157,14 @@ static int empress_try_fmt_vid_cap(struct file *file, void *priv,
 				struct v4l2_format *f)
 {
 	struct saa7134_dev *dev = video_drvdata(file);
-	struct v4l2_mbus_framefmt mbus_fmt;
+	struct v4l2_subdev_pad_config pad_cfg;
+	struct v4l2_subdev_format format = {
+		.which = V4L2_SUBDEV_FORMAT_TRY,
+	};
 
-	v4l2_fill_mbus_format(&mbus_fmt, &f->fmt.pix, MEDIA_BUS_FMT_FIXED);
-	saa_call_all(dev, video, try_mbus_fmt, &mbus_fmt);
-	v4l2_fill_pix_format(&f->fmt.pix, &mbus_fmt);
+	v4l2_fill_mbus_format(&format.format, &f->fmt.pix, MEDIA_BUS_FMT_FIXED);
+	saa_call_all(dev, pad, set_fmt, &pad_cfg, &format);
+	v4l2_fill_pix_format(&f->fmt.pix, &format.format);
 
 	f->fmt.pix.pixelformat  = V4L2_PIX_FMT_MPEG;
 	f->fmt.pix.sizeimage    = TS_PACKET_SIZE * dev->ts.nr_packets;
diff --git a/drivers/media/platform/blackfin/bfin_capture.c b/drivers/media/platform/blackfin/bfin_capture.c
index 6ea11b1..aa50eba 100644
--- a/drivers/media/platform/blackfin/bfin_capture.c
+++ b/drivers/media/platform/blackfin/bfin_capture.c
@@ -602,7 +602,10 @@ static int bcap_try_format(struct bcap_device *bcap,
 {
 	struct bcap_format *sf = bcap->sensor_formats;
 	struct bcap_format *fmt = NULL;
-	struct v4l2_mbus_framefmt mbus_fmt;
+	struct v4l2_subdev_pad_config pad_cfg;
+	struct v4l2_subdev_format format = {
+		.which = V4L2_SUBDEV_FORMAT_TRY,
+	};
 	int ret, i;
 
 	for (i = 0; i < bcap->num_sensor_formats; i++) {
@@ -613,16 +616,16 @@ static int bcap_try_format(struct bcap_device *bcap,
 	if (i == bcap->num_sensor_formats)
 		fmt = &sf[0];
 
-	v4l2_fill_mbus_format(&mbus_fmt, pixfmt, fmt->mbus_code);
-	ret = v4l2_subdev_call(bcap->sd, video,
-				try_mbus_fmt, &mbus_fmt);
+	v4l2_fill_mbus_format(&format.format, pixfmt, fmt->mbus_code);
+	ret = v4l2_subdev_call(bcap->sd, pad, set_fmt, &pad_cfg,
+				&format);
 	if (ret < 0)
 		return ret;
-	v4l2_fill_pix_format(pixfmt, &mbus_fmt);
+	v4l2_fill_pix_format(pixfmt, &format.format);
 	if (bcap_fmt) {
 		for (i = 0; i < bcap->num_sensor_formats; i++) {
 			fmt = &sf[i];
-			if (mbus_fmt.code == fmt->mbus_code)
+			if (format.format.code == fmt->mbus_code)
 				break;
 		}
 		*bcap_fmt = *fmt;
diff --git a/drivers/media/platform/marvell-ccic/mcam-core.c b/drivers/media/platform/marvell-ccic/mcam-core.c
index 9c64b5d..5f48154 100644
--- a/drivers/media/platform/marvell-ccic/mcam-core.c
+++ b/drivers/media/platform/marvell-ccic/mcam-core.c
@@ -1413,16 +1413,19 @@ static int mcam_vidioc_try_fmt_vid_cap(struct file *filp, void *priv,
 	struct mcam_camera *cam = priv;
 	struct mcam_format_struct *f;
 	struct v4l2_pix_format *pix = &fmt->fmt.pix;
-	struct v4l2_mbus_framefmt mbus_fmt;
+	struct v4l2_subdev_pad_config pad_cfg;
+	struct v4l2_subdev_format format = {
+		.which = V4L2_SUBDEV_FORMAT_TRY,
+	};
 	int ret;
 
 	f = mcam_find_format(pix->pixelformat);
 	pix->pixelformat = f->pixelformat;
-	v4l2_fill_mbus_format(&mbus_fmt, pix, f->mbus_code);
+	v4l2_fill_mbus_format(&format.format, pix, f->mbus_code);
 	mutex_lock(&cam->s_mutex);
-	ret = sensor_call(cam, video, try_mbus_fmt, &mbus_fmt);
+	ret = sensor_call(cam, pad, set_fmt, &pad_cfg, &format);
 	mutex_unlock(&cam->s_mutex);
-	v4l2_fill_pix_format(pix, &mbus_fmt);
+	v4l2_fill_pix_format(pix, &format.format);
 	switch (f->pixelformat) {
 	case V4L2_PIX_FMT_YUV420:
 	case V4L2_PIX_FMT_YVU420:
diff --git a/drivers/media/platform/soc_camera/atmel-isi.c b/drivers/media/platform/soc_camera/atmel-isi.c
index cbf83d9..31c15fd 100644
--- a/drivers/media/platform/soc_camera/atmel-isi.c
+++ b/drivers/media/platform/soc_camera/atmel-isi.c
@@ -535,7 +535,11 @@ static int isi_camera_try_fmt(struct soc_camera_device *icd,
 	struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
 	const struct soc_camera_format_xlate *xlate;
 	struct v4l2_pix_format *pix = &f->fmt.pix;
-	struct v4l2_mbus_framefmt mf;
+	struct v4l2_subdev_pad_config pad_cfg;
+	struct v4l2_subdev_format format = {
+		.which = V4L2_SUBDEV_FORMAT_TRY,
+	};
+	struct v4l2_mbus_framefmt *mf = &format.format;
 	u32 pixfmt = pix->pixelformat;
 	int ret;
 
@@ -552,21 +556,21 @@ static int isi_camera_try_fmt(struct soc_camera_device *icd,
 		pix->width = MAX_SUPPORT_WIDTH;
 
 	/* limit to sensor capabilities */
-	mf.width	= pix->width;
-	mf.height	= pix->height;
-	mf.field	= pix->field;
-	mf.colorspace	= pix->colorspace;
-	mf.code		= xlate->code;
+	mf->width	= pix->width;
+	mf->height	= pix->height;
+	mf->field	= pix->field;
+	mf->colorspace	= pix->colorspace;
+	mf->code	= xlate->code;
 
-	ret = v4l2_subdev_call(sd, video, try_mbus_fmt, &mf);
+	ret = v4l2_subdev_call(sd, pad, set_fmt, &pad_cfg, &format);
 	if (ret < 0)
 		return ret;
 
-	pix->width	= mf.width;
-	pix->height	= mf.height;
-	pix->colorspace	= mf.colorspace;
+	pix->width	= mf->width;
+	pix->height	= mf->height;
+	pix->colorspace	= mf->colorspace;
 
-	switch (mf.field) {
+	switch (mf->field) {
 	case V4L2_FIELD_ANY:
 		pix->field = V4L2_FIELD_NONE;
 		break;
@@ -574,7 +578,7 @@ static int isi_camera_try_fmt(struct soc_camera_device *icd,
 		break;
 	default:
 		dev_err(icd->parent, "Field type %d unsupported.\n",
-			mf.field);
+			mf->field);
 		ret = -EINVAL;
 	}
 
diff --git a/drivers/media/platform/soc_camera/mx2_camera.c b/drivers/media/platform/soc_camera/mx2_camera.c
index a1b4264..d45f50a 100644
--- a/drivers/media/platform/soc_camera/mx2_camera.c
+++ b/drivers/media/platform/soc_camera/mx2_camera.c
@@ -1187,7 +1187,11 @@ static int mx2_camera_try_fmt(struct soc_camera_device *icd,
 	struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
 	const struct soc_camera_format_xlate *xlate;
 	struct v4l2_pix_format *pix = &f->fmt.pix;
-	struct v4l2_mbus_framefmt mf;
+	struct v4l2_subdev_pad_config pad_cfg;
+	struct v4l2_subdev_format format = {
+		.which = V4L2_SUBDEV_FORMAT_TRY,
+	};
+	struct v4l2_mbus_framefmt *mf = &format.format;
 	__u32 pixfmt = pix->pixelformat;
 	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
 	struct mx2_camera_dev *pcdev = ici->priv;
@@ -1210,13 +1214,13 @@ static int mx2_camera_try_fmt(struct soc_camera_device *icd,
 	pix->width &= ~0x7;
 
 	/* limit to sensor capabilities */
-	mf.width	= pix->width;
-	mf.height	= pix->height;
-	mf.field	= pix->field;
-	mf.colorspace	= pix->colorspace;
-	mf.code		= xlate->code;
+	mf->width	= pix->width;
+	mf->height	= pix->height;
+	mf->field	= pix->field;
+	mf->colorspace	= pix->colorspace;
+	mf->code	= xlate->code;
 
-	ret = v4l2_subdev_call(sd, video, try_mbus_fmt, &mf);
+	ret = v4l2_subdev_call(sd, pad, set_fmt, &pad_cfg, &format);
 	if (ret < 0)
 		return ret;
 
@@ -1227,29 +1231,29 @@ static int mx2_camera_try_fmt(struct soc_camera_device *icd,
 	emma_prp = mx27_emma_prp_get_format(xlate->code,
 					    xlate->host_fmt->fourcc);
 
-	if ((mf.width != pix->width || mf.height != pix->height) &&
+	if ((mf->width != pix->width || mf->height != pix->height) &&
 		emma_prp->cfg.in_fmt == PRP_CNTL_DATA_IN_YUV422) {
-		if (mx2_emmaprp_resize(pcdev, &mf, pix, false) < 0)
+		if (mx2_emmaprp_resize(pcdev, mf, pix, false) < 0)
 			dev_dbg(icd->parent, "%s: can't resize\n", __func__);
 	}
 
-	if (mf.field == V4L2_FIELD_ANY)
-		mf.field = V4L2_FIELD_NONE;
+	if (mf->field == V4L2_FIELD_ANY)
+		mf->field = V4L2_FIELD_NONE;
 	/*
 	 * Driver supports interlaced images provided they have
 	 * both fields so that they can be processed as if they
 	 * were progressive.
 	 */
-	if (mf.field != V4L2_FIELD_NONE && !V4L2_FIELD_HAS_BOTH(mf.field)) {
+	if (mf->field != V4L2_FIELD_NONE && !V4L2_FIELD_HAS_BOTH(mf->field)) {
 		dev_err(icd->parent, "Field type %d unsupported.\n",
-				mf.field);
+				mf->field);
 		return -EINVAL;
 	}
 
-	pix->width	= mf.width;
-	pix->height	= mf.height;
-	pix->field	= mf.field;
-	pix->colorspace	= mf.colorspace;
+	pix->width	= mf->width;
+	pix->height	= mf->height;
+	pix->field	= mf->field;
+	pix->colorspace	= mf->colorspace;
 
 	dev_dbg(icd->parent, "%s: returned params: width = %d, height = %d\n",
 		__func__, pix->width, pix->height);
diff --git a/drivers/media/platform/soc_camera/mx3_camera.c b/drivers/media/platform/soc_camera/mx3_camera.c
index 6c34dbb..f635017 100644
--- a/drivers/media/platform/soc_camera/mx3_camera.c
+++ b/drivers/media/platform/soc_camera/mx3_camera.c
@@ -912,7 +912,11 @@ static int mx3_camera_try_fmt(struct soc_camera_device *icd,
 	struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
 	const struct soc_camera_format_xlate *xlate;
 	struct v4l2_pix_format *pix = &f->fmt.pix;
-	struct v4l2_mbus_framefmt mf;
+	struct v4l2_subdev_pad_config pad_cfg;
+	struct v4l2_subdev_format format = {
+		.which = V4L2_SUBDEV_FORMAT_TRY,
+	};
+	struct v4l2_mbus_framefmt *mf = &format.format;
 	__u32 pixfmt = pix->pixelformat;
 	int ret;
 
@@ -929,21 +933,21 @@ static int mx3_camera_try_fmt(struct soc_camera_device *icd,
 		pix->width = 4096;
 
 	/* limit to sensor capabilities */
-	mf.width	= pix->width;
-	mf.height	= pix->height;
-	mf.field	= pix->field;
-	mf.colorspace	= pix->colorspace;
-	mf.code		= xlate->code;
+	mf->width	= pix->width;
+	mf->height	= pix->height;
+	mf->field	= pix->field;
+	mf->colorspace	= pix->colorspace;
+	mf->code	= xlate->code;
 
-	ret = v4l2_subdev_call(sd, video, try_mbus_fmt, &mf);
+	ret = v4l2_subdev_call(sd, pad, set_fmt, &pad_cfg, &format);
 	if (ret < 0)
 		return ret;
 
-	pix->width	= mf.width;
-	pix->height	= mf.height;
-	pix->colorspace	= mf.colorspace;
+	pix->width	= mf->width;
+	pix->height	= mf->height;
+	pix->colorspace	= mf->colorspace;
 
-	switch (mf.field) {
+	switch (mf->field) {
 	case V4L2_FIELD_ANY:
 		pix->field = V4L2_FIELD_NONE;
 		break;
@@ -951,7 +955,7 @@ static int mx3_camera_try_fmt(struct soc_camera_device *icd,
 		break;
 	default:
 		dev_err(icd->parent, "Field type %d unsupported.\n",
-			mf.field);
+			mf->field);
 		ret = -EINVAL;
 	}
 
diff --git a/drivers/media/platform/soc_camera/omap1_camera.c b/drivers/media/platform/soc_camera/omap1_camera.c
index 6663645..2a715e1 100644
--- a/drivers/media/platform/soc_camera/omap1_camera.c
+++ b/drivers/media/platform/soc_camera/omap1_camera.c
@@ -1322,7 +1322,11 @@ static int omap1_cam_try_fmt(struct soc_camera_device *icd,
 	struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
 	const struct soc_camera_format_xlate *xlate;
 	struct v4l2_pix_format *pix = &f->fmt.pix;
-	struct v4l2_mbus_framefmt mf;
+	struct v4l2_subdev_pad_config pad_cfg;
+	struct v4l2_subdev_format format = {
+		.which = V4L2_SUBDEV_FORMAT_TRY,
+	};
+	struct v4l2_mbus_framefmt *mf = &format.format;
 	int ret;
 	/* TODO: limit to mx1 hardware capabilities */
 
@@ -1333,21 +1337,21 @@ static int omap1_cam_try_fmt(struct soc_camera_device *icd,
 		return -EINVAL;
 	}
 
-	mf.width	= pix->width;
-	mf.height	= pix->height;
-	mf.field	= pix->field;
-	mf.colorspace	= pix->colorspace;
-	mf.code		= xlate->code;
+	mf->width	= pix->width;
+	mf->height	= pix->height;
+	mf->field	= pix->field;
+	mf->colorspace	= pix->colorspace;
+	mf->code	= xlate->code;
 
 	/* limit to sensor capabilities */
-	ret = v4l2_subdev_call(sd, video, try_mbus_fmt, &mf);
+	ret = v4l2_subdev_call(sd, pad, set_fmt, &pad_cfg, &format);
 	if (ret < 0)
 		return ret;
 
-	pix->width	= mf.width;
-	pix->height	= mf.height;
-	pix->field	= mf.field;
-	pix->colorspace	= mf.colorspace;
+	pix->width	= mf->width;
+	pix->height	= mf->height;
+	pix->field	= mf->field;
+	pix->colorspace	= mf->colorspace;
 
 	return 0;
 }
diff --git a/drivers/media/platform/soc_camera/pxa_camera.c b/drivers/media/platform/soc_camera/pxa_camera.c
index 48999f3..7ccd76f 100644
--- a/drivers/media/platform/soc_camera/pxa_camera.c
+++ b/drivers/media/platform/soc_camera/pxa_camera.c
@@ -1488,7 +1488,11 @@ static int pxa_camera_try_fmt(struct soc_camera_device *icd,
 	struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
 	const struct soc_camera_format_xlate *xlate;
 	struct v4l2_pix_format *pix = &f->fmt.pix;
-	struct v4l2_mbus_framefmt mf;
+	struct v4l2_subdev_pad_config pad_cfg;
+	struct v4l2_subdev_format format = {
+		.which = V4L2_SUBDEV_FORMAT_TRY,
+	};
+	struct v4l2_mbus_framefmt *mf = &format.format;
 	__u32 pixfmt = pix->pixelformat;
 	int ret;
 
@@ -1509,22 +1513,22 @@ static int pxa_camera_try_fmt(struct soc_camera_device *icd,
 			      pixfmt == V4L2_PIX_FMT_YUV422P ? 4 : 0);
 
 	/* limit to sensor capabilities */
-	mf.width	= pix->width;
-	mf.height	= pix->height;
+	mf->width	= pix->width;
+	mf->height	= pix->height;
 	/* Only progressive video supported so far */
-	mf.field	= V4L2_FIELD_NONE;
-	mf.colorspace	= pix->colorspace;
-	mf.code		= xlate->code;
+	mf->field	= V4L2_FIELD_NONE;
+	mf->colorspace	= pix->colorspace;
+	mf->code	= xlate->code;
 
-	ret = v4l2_subdev_call(sd, video, try_mbus_fmt, &mf);
+	ret = v4l2_subdev_call(sd, pad, set_fmt, &pad_cfg, &format);
 	if (ret < 0)
 		return ret;
 
-	pix->width	= mf.width;
-	pix->height	= mf.height;
-	pix->colorspace	= mf.colorspace;
+	pix->width	= mf->width;
+	pix->height	= mf->height;
+	pix->colorspace	= mf->colorspace;
 
-	switch (mf.field) {
+	switch (mf->field) {
 	case V4L2_FIELD_ANY:
 	case V4L2_FIELD_NONE:
 		pix->field	= V4L2_FIELD_NONE;
@@ -1532,7 +1536,7 @@ static int pxa_camera_try_fmt(struct soc_camera_device *icd,
 	default:
 		/* TODO: support interlaced at least in pass-through mode */
 		dev_err(icd->parent, "Field type %d unsupported.\n",
-			mf.field);
+			mf->field);
 		return -EINVAL;
 	}
 
diff --git a/drivers/media/platform/soc_camera/rcar_vin.c b/drivers/media/platform/soc_camera/rcar_vin.c
index 08fa610..063285a 100644
--- a/drivers/media/platform/soc_camera/rcar_vin.c
+++ b/drivers/media/platform/soc_camera/rcar_vin.c
@@ -1683,7 +1683,11 @@ static int rcar_vin_try_fmt(struct soc_camera_device *icd,
 	const struct soc_camera_format_xlate *xlate;
 	struct v4l2_pix_format *pix = &f->fmt.pix;
 	struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
-	struct v4l2_mbus_framefmt mf;
+	struct v4l2_subdev_pad_config pad_cfg;
+	struct v4l2_subdev_format format = {
+		.which = V4L2_SUBDEV_FORMAT_TRY,
+	};
+	struct v4l2_mbus_framefmt *mf = &format.format;
 	__u32 pixfmt = pix->pixelformat;
 	int width, height;
 	int ret;
@@ -1710,25 +1714,25 @@ static int rcar_vin_try_fmt(struct soc_camera_device *icd,
 	pix->sizeimage = 0;
 
 	/* limit to sensor capabilities */
-	mf.width = pix->width;
-	mf.height = pix->height;
-	mf.field = pix->field;
-	mf.code = xlate->code;
-	mf.colorspace = pix->colorspace;
+	mf->width = pix->width;
+	mf->height = pix->height;
+	mf->field = pix->field;
+	mf->code = xlate->code;
+	mf->colorspace = pix->colorspace;
 
 	ret = v4l2_device_call_until_err(sd->v4l2_dev, soc_camera_grp_id(icd),
-					 video, try_mbus_fmt, &mf);
+					 pad, set_fmt, &pad_cfg, &format);
 	if (ret < 0)
 		return ret;
 
 	/* Adjust only if VIN cannot scale */
-	if (pix->width > mf.width * 2)
-		pix->width = mf.width * 2;
-	if (pix->height > mf.height * 3)
-		pix->height = mf.height * 3;
+	if (pix->width > mf->width * 2)
+		pix->width = mf->width * 2;
+	if (pix->height > mf->height * 3)
+		pix->height = mf->height * 3;
 
-	pix->field = mf.field;
-	pix->colorspace = mf.colorspace;
+	pix->field = mf->field;
+	pix->colorspace = mf->colorspace;
 
 	if (pixfmt == V4L2_PIX_FMT_NV16) {
 		/* FIXME: check against rect_max after converting soc-camera */
@@ -1739,12 +1743,12 @@ static int rcar_vin_try_fmt(struct soc_camera_device *icd,
 			 * requested a bigger rectangle, it will not return a
 			 * smaller one.
 			 */
-			mf.width = VIN_MAX_WIDTH;
-			mf.height = VIN_MAX_HEIGHT;
+			mf->width = VIN_MAX_WIDTH;
+			mf->height = VIN_MAX_HEIGHT;
 			ret = v4l2_device_call_until_err(sd->v4l2_dev,
 							 soc_camera_grp_id(icd),
-							 video, try_mbus_fmt,
-							 &mf);
+							 pad, set_fmt, &pad_cfg,
+							 &format);
 			if (ret < 0) {
 				dev_err(icd->parent,
 					"client try_fmt() = %d\n", ret);
@@ -1752,9 +1756,9 @@ static int rcar_vin_try_fmt(struct soc_camera_device *icd,
 			}
 		}
 		/* We will scale exactly */
-		if (mf.width > width)
+		if (mf->width > width)
 			pix->width = width;
-		if (mf.height > height)
+		if (mf->height > height)
 			pix->height = height;
 	}
 
diff --git a/drivers/media/platform/soc_camera/sh_mobile_ceu_camera.c b/drivers/media/platform/soc_camera/sh_mobile_ceu_camera.c
index 566fd74..91c48ab 100644
--- a/drivers/media/platform/soc_camera/sh_mobile_ceu_camera.c
+++ b/drivers/media/platform/soc_camera/sh_mobile_ceu_camera.c
@@ -1499,7 +1499,11 @@ static int sh_mobile_ceu_try_fmt(struct soc_camera_device *icd,
 	const struct soc_camera_format_xlate *xlate;
 	struct v4l2_pix_format *pix = &f->fmt.pix;
 	struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
-	struct v4l2_mbus_framefmt mf;
+	struct v4l2_subdev_pad_config pad_cfg;
+	struct v4l2_subdev_format format = {
+		.which = V4L2_SUBDEV_FORMAT_TRY,
+	};
+	struct v4l2_mbus_framefmt *mf = &format.format;
 	__u32 pixfmt = pix->pixelformat;
 	int width, height;
 	int ret;
@@ -1527,21 +1531,21 @@ static int sh_mobile_ceu_try_fmt(struct soc_camera_device *icd,
 	height = pix->height;
 
 	/* limit to sensor capabilities */
-	mf.width	= pix->width;
-	mf.height	= pix->height;
-	mf.field	= pix->field;
-	mf.code		= xlate->code;
-	mf.colorspace	= pix->colorspace;
+	mf->width	= pix->width;
+	mf->height	= pix->height;
+	mf->field	= pix->field;
+	mf->code	= xlate->code;
+	mf->colorspace	= pix->colorspace;
 
 	ret = v4l2_device_call_until_err(sd->v4l2_dev, soc_camera_grp_id(icd),
-					 video, try_mbus_fmt, &mf);
+					 pad, set_fmt, &pad_cfg, &format);
 	if (ret < 0)
 		return ret;
 
-	pix->width	= mf.width;
-	pix->height	= mf.height;
-	pix->field	= mf.field;
-	pix->colorspace	= mf.colorspace;
+	pix->width	= mf->width;
+	pix->height	= mf->height;
+	pix->field	= mf->field;
+	pix->colorspace	= mf->colorspace;
 
 	switch (pixfmt) {
 	case V4L2_PIX_FMT_NV12:
@@ -1556,11 +1560,11 @@ static int sh_mobile_ceu_try_fmt(struct soc_camera_device *icd,
 			 * requested a bigger rectangle, it will not return a
 			 * smaller one.
 			 */
-			mf.width = pcdev->max_width;
-			mf.height = pcdev->max_height;
+			mf->width = pcdev->max_width;
+			mf->height = pcdev->max_height;
 			ret = v4l2_device_call_until_err(sd->v4l2_dev,
-					soc_camera_grp_id(icd), video,
-					try_mbus_fmt, &mf);
+					soc_camera_grp_id(icd), pad,
+					set_fmt, &pad_cfg, &format);
 			if (ret < 0) {
 				/* Shouldn't actually happen... */
 				dev_err(icd->parent,
@@ -1569,9 +1573,9 @@ static int sh_mobile_ceu_try_fmt(struct soc_camera_device *icd,
 			}
 		}
 		/* We will scale exactly */
-		if (mf.width > width)
+		if (mf->width > width)
 			pix->width = width;
-		if (mf.height > height)
+		if (mf->height > height)
 			pix->height = height;
 
 		pix->bytesperline = max(pix->bytesperline, pix->width);
diff --git a/drivers/media/platform/via-camera.c b/drivers/media/platform/via-camera.c
index 678ed9f..6331d6b 100644
--- a/drivers/media/platform/via-camera.c
+++ b/drivers/media/platform/via-camera.c
@@ -903,14 +903,17 @@ static int viacam_do_try_fmt(struct via_camera *cam,
 		struct v4l2_pix_format *upix, struct v4l2_pix_format *spix)
 {
 	int ret;
-	struct v4l2_mbus_framefmt mbus_fmt;
+	struct v4l2_subdev_pad_config pad_cfg;
+	struct v4l2_subdev_format format = {
+		.which = V4L2_SUBDEV_FORMAT_TRY,
+	};
 	struct via_format *f = via_find_format(upix->pixelformat);
 
 	upix->pixelformat = f->pixelformat;
 	viacam_fmt_pre(upix, spix);
-	v4l2_fill_mbus_format(&mbus_fmt, spix, f->mbus_code);
-	ret = sensor_call(cam, video, try_mbus_fmt, &mbus_fmt);
-	v4l2_fill_pix_format(spix, &mbus_fmt);
+	v4l2_fill_mbus_format(&format.format, spix, f->mbus_code);
+	ret = sensor_call(cam, pad, set_fmt, &pad_cfg, &format);
+	v4l2_fill_pix_format(spix, &format.format);
 	viacam_fmt_post(upix, spix);
 	return ret;
 }
-- 
2.1.4

