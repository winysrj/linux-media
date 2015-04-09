Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud3.xs4all.net ([194.109.24.30]:50445 "EHLO
	lb3-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933699AbbDIKWc (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 9 Apr 2015 06:22:32 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Prabhakar Lad <prabhakar.csengg@gmail.com>,
	Scott Jiang <scott.jiang.linux@gmail.com>,
	Jonathan Corbet <corbet@lwn.net>
Subject: [PATCH 6/7] v4l2: replace s_mbus_fmt by set_fmt in bridge drivers
Date: Thu,  9 Apr 2015 12:21:27 +0200
Message-Id: <1428574888-46407-7-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1428574888-46407-1-git-send-email-hverkuil@xs4all.nl>
References: <1428574888-46407-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Replace all calls to s_mbus_fmt in bridge drivers by calls to the
set_fmt pad op.

Remove the old try/s_mbus_fmt video ops since they are now no longer used.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Prabhakar Lad <prabhakar.csengg@gmail.com>
Cc: Scott Jiang <scott.jiang.linux@gmail.com>
Cc: Jonathan Corbet <corbet@lwn.net>
---
 drivers/media/pci/cx18/cx18-controls.c             | 13 +++--
 drivers/media/pci/cx18/cx18-ioctl.c                | 12 +++--
 drivers/media/pci/cx23885/cx23885-video.c          | 12 +++--
 drivers/media/pci/ivtv/ivtv-controls.c             | 12 +++--
 drivers/media/pci/ivtv/ivtv-ioctl.c                | 12 +++--
 drivers/media/pci/saa7134/saa7134-empress.c        | 10 ++--
 drivers/media/platform/am437x/am437x-vpfe.c        | 19 ++-----
 drivers/media/platform/blackfin/bfin_capture.c     |  8 +--
 drivers/media/platform/marvell-ccic/mcam-core.c    |  8 +--
 drivers/media/platform/sh_vou.c                    | 61 ++++++++++++----------
 drivers/media/platform/soc_camera/atmel-isi.c      | 27 +++++-----
 drivers/media/platform/soc_camera/mx2_camera.c     | 35 +++++++------
 drivers/media/platform/soc_camera/mx3_camera.c     | 31 ++++++-----
 drivers/media/platform/soc_camera/omap1_camera.c   | 44 +++++++++-------
 drivers/media/platform/soc_camera/pxa_camera.c     | 33 ++++++------
 drivers/media/platform/soc_camera/rcar_vin.c       |  4 +-
 .../platform/soc_camera/sh_mobile_ceu_camera.c     |  8 +--
 drivers/media/platform/soc_camera/soc_scale_crop.c | 37 +++++++------
 drivers/media/platform/via-camera.c                |  8 +--
 drivers/media/usb/cx231xx/cx231xx-417.c            | 12 +++--
 drivers/media/usb/cx231xx/cx231xx-video.c          | 23 ++++----
 drivers/media/usb/em28xx/em28xx-camera.c           | 12 +++--
 drivers/media/usb/go7007/go7007-v4l2.c             | 12 +++--
 drivers/media/usb/pvrusb2/pvrusb2-hdw.c            | 17 +++---
 include/media/v4l2-subdev.h                        |  8 ---
 25 files changed, 256 insertions(+), 222 deletions(-)

diff --git a/drivers/media/pci/cx18/cx18-controls.c b/drivers/media/pci/cx18/cx18-controls.c
index 4aeb7c6..71227a1 100644
--- a/drivers/media/pci/cx18/cx18-controls.c
+++ b/drivers/media/pci/cx18/cx18-controls.c
@@ -93,13 +93,16 @@ static int cx18_s_video_encoding(struct cx2341x_handler *cxhdl, u32 val)
 {
 	struct cx18 *cx = container_of(cxhdl, struct cx18, cxhdl);
 	int is_mpeg1 = val == V4L2_MPEG_VIDEO_ENCODING_MPEG_1;
-	struct v4l2_mbus_framefmt fmt;
+	struct v4l2_subdev_format format = {
+		.which = V4L2_SUBDEV_FORMAT_ACTIVE,
+	};
+	struct v4l2_mbus_framefmt *fmt = &format.format;
 
 	/* fix videodecoder resolution */
-	fmt.width = cxhdl->width / (is_mpeg1 ? 2 : 1);
-	fmt.height = cxhdl->height;
-	fmt.code = MEDIA_BUS_FMT_FIXED;
-	v4l2_subdev_call(cx->sd_av, video, s_mbus_fmt, &fmt);
+	fmt->width = cxhdl->width / (is_mpeg1 ? 2 : 1);
+	fmt->height = cxhdl->height;
+	fmt->code = MEDIA_BUS_FMT_FIXED;
+	v4l2_subdev_call(cx->sd_av, pad, set_fmt, NULL, &format);
 	return 0;
 }
 
diff --git a/drivers/media/pci/cx18/cx18-ioctl.c b/drivers/media/pci/cx18/cx18-ioctl.c
index 79aee30..55525af 100644
--- a/drivers/media/pci/cx18/cx18-ioctl.c
+++ b/drivers/media/pci/cx18/cx18-ioctl.c
@@ -267,7 +267,9 @@ static int cx18_s_fmt_vid_cap(struct file *file, void *fh,
 {
 	struct cx18_open_id *id = fh2id(fh);
 	struct cx18 *cx = id->cx;
-	struct v4l2_mbus_framefmt mbus_fmt;
+	struct v4l2_subdev_format format = {
+		.which = V4L2_SUBDEV_FORMAT_ACTIVE,
+	};
 	struct cx18_stream *s = &cx->streams[id->type];
 	int ret;
 	int w, h;
@@ -296,10 +298,10 @@ static int cx18_s_fmt_vid_cap(struct file *file, void *fh,
 		s->vb_bytes_per_line = 1440; /* Packed */
 	}
 
-	mbus_fmt.width = cx->cxhdl.width = w;
-	mbus_fmt.height = cx->cxhdl.height = h;
-	mbus_fmt.code = MEDIA_BUS_FMT_FIXED;
-	v4l2_subdev_call(cx->sd_av, video, s_mbus_fmt, &mbus_fmt);
+	format.format.width = cx->cxhdl.width = w;
+	format.format.height = cx->cxhdl.height = h;
+	format.format.code = MEDIA_BUS_FMT_FIXED;
+	v4l2_subdev_call(cx->sd_av, pad, set_fmt, NULL, &format);
 	return cx18_g_fmt_vid_cap(file, fh, fmt);
 }
 
diff --git a/drivers/media/pci/cx23885/cx23885-video.c b/drivers/media/pci/cx23885/cx23885-video.c
index 2232b38..ec76470 100644
--- a/drivers/media/pci/cx23885/cx23885-video.c
+++ b/drivers/media/pci/cx23885/cx23885-video.c
@@ -581,7 +581,9 @@ static int vidioc_s_fmt_vid_cap(struct file *file, void *priv,
 	struct v4l2_format *f)
 {
 	struct cx23885_dev *dev = video_drvdata(file);
-	struct v4l2_mbus_framefmt mbus_fmt;
+	struct v4l2_subdev_format format = {
+		.which = V4L2_SUBDEV_FORMAT_ACTIVE,
+	};
 	int err;
 
 	dprintk(2, "%s()\n", __func__);
@@ -600,10 +602,10 @@ static int vidioc_s_fmt_vid_cap(struct file *file, void *priv,
 	dev->field	= f->fmt.pix.field;
 	dprintk(2, "%s() width=%d height=%d field=%d\n", __func__,
 		dev->width, dev->height, dev->field);
-	v4l2_fill_mbus_format(&mbus_fmt, &f->fmt.pix, MEDIA_BUS_FMT_FIXED);
-	call_all(dev, video, s_mbus_fmt, &mbus_fmt);
-	v4l2_fill_pix_format(&f->fmt.pix, &mbus_fmt);
-	/* s_mbus_fmt overwrites f->fmt.pix.field, restore it */
+	v4l2_fill_mbus_format(&format.format, &f->fmt.pix, MEDIA_BUS_FMT_FIXED);
+	call_all(dev, pad, set_fmt, NULL, &format);
+	v4l2_fill_pix_format(&f->fmt.pix, &format.format);
+	/* set_fmt overwrites f->fmt.pix.field, restore it */
 	f->fmt.pix.field = dev->field;
 	return 0;
 }
diff --git a/drivers/media/pci/ivtv/ivtv-controls.c b/drivers/media/pci/ivtv/ivtv-controls.c
index ccf548c..8a55ccb 100644
--- a/drivers/media/pci/ivtv/ivtv-controls.c
+++ b/drivers/media/pci/ivtv/ivtv-controls.c
@@ -64,13 +64,15 @@ static int ivtv_s_video_encoding(struct cx2341x_handler *cxhdl, u32 val)
 {
 	struct ivtv *itv = container_of(cxhdl, struct ivtv, cxhdl);
 	int is_mpeg1 = val == V4L2_MPEG_VIDEO_ENCODING_MPEG_1;
-	struct v4l2_mbus_framefmt fmt;
+	struct v4l2_subdev_format format = {
+		.which = V4L2_SUBDEV_FORMAT_ACTIVE,
+	};
 
 	/* fix videodecoder resolution */
-	fmt.width = cxhdl->width / (is_mpeg1 ? 2 : 1);
-	fmt.height = cxhdl->height;
-	fmt.code = MEDIA_BUS_FMT_FIXED;
-	v4l2_subdev_call(itv->sd_video, video, s_mbus_fmt, &fmt);
+	format.format.width = cxhdl->width / (is_mpeg1 ? 2 : 1);
+	format.format.height = cxhdl->height;
+	format.format.code = MEDIA_BUS_FMT_FIXED;
+	v4l2_subdev_call(itv->sd_video, pad, set_fmt, NULL, &format);
 	return 0;
 }
 
diff --git a/drivers/media/pci/ivtv/ivtv-ioctl.c b/drivers/media/pci/ivtv/ivtv-ioctl.c
index 6fe6c4a..10c31cd 100644
--- a/drivers/media/pci/ivtv/ivtv-ioctl.c
+++ b/drivers/media/pci/ivtv/ivtv-ioctl.c
@@ -581,7 +581,9 @@ static int ivtv_s_fmt_vid_cap(struct file *file, void *fh, struct v4l2_format *f
 {
 	struct ivtv_open_id *id = fh2id(fh);
 	struct ivtv *itv = id->itv;
-	struct v4l2_mbus_framefmt mbus_fmt;
+	struct v4l2_subdev_format format = {
+		.which = V4L2_SUBDEV_FORMAT_ACTIVE,
+	};
 	int ret = ivtv_try_fmt_vid_cap(file, fh, fmt);
 	int w = fmt->fmt.pix.width;
 	int h = fmt->fmt.pix.height;
@@ -599,10 +601,10 @@ static int ivtv_s_fmt_vid_cap(struct file *file, void *fh, struct v4l2_format *f
 	itv->cxhdl.height = h;
 	if (v4l2_ctrl_g_ctrl(itv->cxhdl.video_encoding) == V4L2_MPEG_VIDEO_ENCODING_MPEG_1)
 		fmt->fmt.pix.width /= 2;
-	mbus_fmt.width = fmt->fmt.pix.width;
-	mbus_fmt.height = h;
-	mbus_fmt.code = MEDIA_BUS_FMT_FIXED;
-	v4l2_subdev_call(itv->sd_video, video, s_mbus_fmt, &mbus_fmt);
+	format.format.width = fmt->fmt.pix.width;
+	format.format.height = h;
+	format.format.code = MEDIA_BUS_FMT_FIXED;
+	v4l2_subdev_call(itv->sd_video, pad, set_fmt, NULL, &format);
 	return ivtv_g_fmt_vid_cap(file, fh, fmt);
 }
 
diff --git a/drivers/media/pci/saa7134/saa7134-empress.c b/drivers/media/pci/saa7134/saa7134-empress.c
index dc14930..c9118e0 100644
--- a/drivers/media/pci/saa7134/saa7134-empress.c
+++ b/drivers/media/pci/saa7134/saa7134-empress.c
@@ -140,11 +140,13 @@ static int empress_s_fmt_vid_cap(struct file *file, void *priv,
 				struct v4l2_format *f)
 {
 	struct saa7134_dev *dev = video_drvdata(file);
-	struct v4l2_mbus_framefmt mbus_fmt;
+	struct v4l2_subdev_format format = {
+		.which = V4L2_SUBDEV_FORMAT_ACTIVE,
+	};
 
-	v4l2_fill_mbus_format(&mbus_fmt, &f->fmt.pix, MEDIA_BUS_FMT_FIXED);
-	saa_call_all(dev, video, s_mbus_fmt, &mbus_fmt);
-	v4l2_fill_pix_format(&f->fmt.pix, &mbus_fmt);
+	v4l2_fill_mbus_format(&format.format, &f->fmt.pix, MEDIA_BUS_FMT_FIXED);
+	saa_call_all(dev, pad, set_fmt, NULL, &format);
+	v4l2_fill_pix_format(&f->fmt.pix, &format.format);
 
 	f->fmt.pix.pixelformat  = V4L2_PIX_FMT_MPEG;
 	f->fmt.pix.sizeimage    = TS_PACKET_SIZE * dev->ts.nr_packets;
diff --git a/drivers/media/platform/am437x/am437x-vpfe.c b/drivers/media/platform/am437x/am437x-vpfe.c
index d4195ff..9522bf3 100644
--- a/drivers/media/platform/am437x/am437x-vpfe.c
+++ b/drivers/media/platform/am437x/am437x-vpfe.c
@@ -1455,7 +1455,6 @@ static int __vpfe_get_format(struct vpfe_device *vpfe,
 static int __vpfe_set_format(struct vpfe_device *vpfe,
 			     struct v4l2_format *format, unsigned int *bpp)
 {
-	struct v4l2_mbus_framefmt mbus_fmt;
 	struct vpfe_subdev_info *sdinfo;
 	struct v4l2_subdev_format fmt;
 	int ret;
@@ -1472,23 +1471,11 @@ static int __vpfe_set_format(struct vpfe_device *vpfe,
 	pix_to_mbus(vpfe, &format->fmt.pix, &fmt.format);
 
 	ret = v4l2_subdev_call(sdinfo->sd, pad, set_fmt, NULL, &fmt);
-	if (ret && ret != -ENOIOCTLCMD && ret != -ENODEV)
+	if (ret)
 		return ret;
 
-	if (!ret) {
-		v4l2_fill_pix_format(&format->fmt.pix, &fmt.format);
-		mbus_to_pix(vpfe, &fmt.format, &format->fmt.pix, bpp);
-	} else {
-		ret = v4l2_device_call_until_err(&vpfe->v4l2_dev,
-						 sdinfo->grp_id,
-						 video, s_mbus_fmt,
-						 &mbus_fmt);
-		if (ret && ret != -ENOIOCTLCMD && ret != -ENODEV)
-			return ret;
-
-		v4l2_fill_pix_format(&format->fmt.pix, &mbus_fmt);
-		mbus_to_pix(vpfe, &mbus_fmt, &format->fmt.pix, bpp);
-	}
+	v4l2_fill_pix_format(&format->fmt.pix, &fmt.format);
+	mbus_to_pix(vpfe, &fmt.format, &format->fmt.pix, bpp);
 
 	format->type = vpfe->fmt.type;
 
diff --git a/drivers/media/platform/blackfin/bfin_capture.c b/drivers/media/platform/blackfin/bfin_capture.c
index aa50eba..b7e70fb 100644
--- a/drivers/media/platform/blackfin/bfin_capture.c
+++ b/drivers/media/platform/blackfin/bfin_capture.c
@@ -674,7 +674,9 @@ static int bcap_s_fmt_vid_cap(struct file *file, void *priv,
 				struct v4l2_format *fmt)
 {
 	struct bcap_device *bcap_dev = video_drvdata(file);
-	struct v4l2_mbus_framefmt mbus_fmt;
+	struct v4l2_subdev_format format = {
+		.which = V4L2_SUBDEV_FORMAT_ACTIVE,
+	};
 	struct bcap_format bcap_fmt;
 	struct v4l2_pix_format *pixfmt = &fmt->fmt.pix;
 	int ret;
@@ -687,8 +689,8 @@ static int bcap_s_fmt_vid_cap(struct file *file, void *priv,
 	if (ret < 0)
 		return ret;
 
-	v4l2_fill_mbus_format(&mbus_fmt, pixfmt, bcap_fmt.mbus_code);
-	ret = v4l2_subdev_call(bcap_dev->sd, video, s_mbus_fmt, &mbus_fmt);
+	v4l2_fill_mbus_format(&format.format, pixfmt, bcap_fmt.mbus_code);
+	ret = v4l2_subdev_call(bcap_dev->sd, pad, set_fmt, NULL, &format);
 	if (ret < 0)
 		return ret;
 	bcap_dev->fmt = *pixfmt;
diff --git a/drivers/media/platform/marvell-ccic/mcam-core.c b/drivers/media/platform/marvell-ccic/mcam-core.c
index 5f48154..c63b384 100644
--- a/drivers/media/platform/marvell-ccic/mcam-core.c
+++ b/drivers/media/platform/marvell-ccic/mcam-core.c
@@ -998,13 +998,15 @@ static int mcam_cam_set_flip(struct mcam_camera *cam)
 
 static int mcam_cam_configure(struct mcam_camera *cam)
 {
-	struct v4l2_mbus_framefmt mbus_fmt;
+	struct v4l2_subdev_format format = {
+		.which = V4L2_SUBDEV_FORMAT_ACTIVE,
+	};
 	int ret;
 
-	v4l2_fill_mbus_format(&mbus_fmt, &cam->pix_format, cam->mbus_code);
+	v4l2_fill_mbus_format(&format.format, &cam->pix_format, cam->mbus_code);
 	ret = sensor_call(cam, core, init, 0);
 	if (ret == 0)
-		ret = sensor_call(cam, video, s_mbus_fmt, &mbus_fmt);
+		ret = sensor_call(cam, pad, set_fmt, NULL, &format);
 	/*
 	 * OV7670 does weird things if flip is set *before* format...
 	 */
diff --git a/drivers/media/platform/sh_vou.c b/drivers/media/platform/sh_vou.c
index dde1ccc..829e85c 100644
--- a/drivers/media/platform/sh_vou.c
+++ b/drivers/media/platform/sh_vou.c
@@ -679,12 +679,14 @@ static int sh_vou_s_fmt_vid_out(struct file *file, void *priv,
 	unsigned int img_height_max;
 	int pix_idx;
 	struct sh_vou_geometry geo;
-	struct v4l2_mbus_framefmt mbfmt = {
+	struct v4l2_subdev_format format = {
+		.which = V4L2_SUBDEV_FORMAT_ACTIVE,
 		/* Revisit: is this the correct code? */
-		.code = MEDIA_BUS_FMT_YUYV8_2X8,
-		.field = V4L2_FIELD_INTERLACED,
-		.colorspace = V4L2_COLORSPACE_SMPTE170M,
+		.format.code = MEDIA_BUS_FMT_YUYV8_2X8,
+		.format.field = V4L2_FIELD_INTERLACED,
+		.format.colorspace = V4L2_COLORSPACE_SMPTE170M,
 	};
+	struct v4l2_mbus_framefmt *mbfmt = &format.format;
 	int ret;
 
 	dev_dbg(vou_dev->v4l2_dev.dev, "%s(): %ux%u -> %ux%u\n", __func__,
@@ -720,27 +722,27 @@ static int sh_vou_s_fmt_vid_out(struct file *file, void *priv,
 
 	vou_adjust_output(&geo, vou_dev->std);
 
-	mbfmt.width = geo.output.width;
-	mbfmt.height = geo.output.height;
-	ret = v4l2_device_call_until_err(&vou_dev->v4l2_dev, 0, video,
-					 s_mbus_fmt, &mbfmt);
+	mbfmt->width = geo.output.width;
+	mbfmt->height = geo.output.height;
+	ret = v4l2_device_call_until_err(&vou_dev->v4l2_dev, 0, pad,
+					 set_fmt, NULL, &format);
 	/* Must be implemented, so, don't check for -ENOIOCTLCMD */
 	if (ret < 0)
 		return ret;
 
 	dev_dbg(vou_dev->v4l2_dev.dev, "%s(): %ux%u -> %ux%u\n", __func__,
-		geo.output.width, geo.output.height, mbfmt.width, mbfmt.height);
+		geo.output.width, geo.output.height, mbfmt->width, mbfmt->height);
 
 	/* Sanity checks */
-	if ((unsigned)mbfmt.width > VOU_MAX_IMAGE_WIDTH ||
-	    (unsigned)mbfmt.height > img_height_max ||
-	    mbfmt.code != MEDIA_BUS_FMT_YUYV8_2X8)
+	if ((unsigned)mbfmt->width > VOU_MAX_IMAGE_WIDTH ||
+	    (unsigned)mbfmt->height > img_height_max ||
+	    mbfmt->code != MEDIA_BUS_FMT_YUYV8_2X8)
 		return -EIO;
 
-	if (mbfmt.width != geo.output.width ||
-	    mbfmt.height != geo.output.height) {
-		geo.output.width = mbfmt.width;
-		geo.output.height = mbfmt.height;
+	if (mbfmt->width != geo.output.width ||
+	    mbfmt->height != geo.output.height) {
+		geo.output.width = mbfmt->width;
+		geo.output.height = mbfmt->height;
 
 		vou_adjust_input(&geo, vou_dev->std);
 	}
@@ -942,11 +944,12 @@ static int sh_vou_s_crop(struct file *file, void *fh, const struct v4l2_crop *a)
 	struct v4l2_crop sd_crop = {.type = V4L2_BUF_TYPE_VIDEO_OUTPUT};
 	struct v4l2_pix_format *pix = &vou_dev->pix;
 	struct sh_vou_geometry geo;
-	struct v4l2_mbus_framefmt mbfmt = {
+	struct v4l2_subdev_format format = {
+		.which = V4L2_SUBDEV_FORMAT_ACTIVE,
 		/* Revisit: is this the correct code? */
-		.code = MEDIA_BUS_FMT_YUYV8_2X8,
-		.field = V4L2_FIELD_INTERLACED,
-		.colorspace = V4L2_COLORSPACE_SMPTE170M,
+		.format.code = MEDIA_BUS_FMT_YUYV8_2X8,
+		.format.field = V4L2_FIELD_INTERLACED,
+		.format.colorspace = V4L2_COLORSPACE_SMPTE170M,
 	};
 	unsigned int img_height_max;
 	int ret;
@@ -984,22 +987,22 @@ static int sh_vou_s_crop(struct file *file, void *fh, const struct v4l2_crop *a)
 	 */
 	v4l2_device_call_until_err(&vou_dev->v4l2_dev, 0, video,
 				   s_crop, &sd_crop);
-	mbfmt.width = geo.output.width;
-	mbfmt.height = geo.output.height;
-	ret = v4l2_device_call_until_err(&vou_dev->v4l2_dev, 0, video,
-					 s_mbus_fmt, &mbfmt);
+	format.format.width = geo.output.width;
+	format.format.height = geo.output.height;
+	ret = v4l2_device_call_until_err(&vou_dev->v4l2_dev, 0, pad,
+					 set_fmt, NULL, &format);
 	/* Must be implemented, so, don't check for -ENOIOCTLCMD */
 	if (ret < 0)
 		return ret;
 
 	/* Sanity checks */
-	if ((unsigned)mbfmt.width > VOU_MAX_IMAGE_WIDTH ||
-	    (unsigned)mbfmt.height > img_height_max ||
-	    mbfmt.code != MEDIA_BUS_FMT_YUYV8_2X8)
+	if ((unsigned)format.format.width > VOU_MAX_IMAGE_WIDTH ||
+	    (unsigned)format.format.height > img_height_max ||
+	    format.format.code != MEDIA_BUS_FMT_YUYV8_2X8)
 		return -EIO;
 
-	geo.output.width = mbfmt.width;
-	geo.output.height = mbfmt.height;
+	geo.output.width = format.format.width;
+	geo.output.height = format.format.height;
 
 	/*
 	 * No down-scaling. According to the API, current call has precedence:
diff --git a/drivers/media/platform/soc_camera/atmel-isi.c b/drivers/media/platform/soc_camera/atmel-isi.c
index 31c15fd..5acb682 100644
--- a/drivers/media/platform/soc_camera/atmel-isi.c
+++ b/drivers/media/platform/soc_camera/atmel-isi.c
@@ -487,7 +487,10 @@ static int isi_camera_set_fmt(struct soc_camera_device *icd,
 	struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
 	const struct soc_camera_format_xlate *xlate;
 	struct v4l2_pix_format *pix = &f->fmt.pix;
-	struct v4l2_mbus_framefmt mf;
+	struct v4l2_subdev_format format = {
+		.which = V4L2_SUBDEV_FORMAT_ACTIVE,
+	};
+	struct v4l2_mbus_framefmt *mf = &format.format;
 	int ret;
 
 	xlate = soc_camera_xlate_by_fourcc(icd, pix->pixelformat);
@@ -500,27 +503,27 @@ static int isi_camera_set_fmt(struct soc_camera_device *icd,
 	dev_dbg(icd->parent, "Plan to set format %dx%d\n",
 			pix->width, pix->height);
 
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
 
-	ret = v4l2_subdev_call(sd, video, s_mbus_fmt, &mf);
+	ret = v4l2_subdev_call(sd, pad, set_fmt, NULL, &format);
 	if (ret < 0)
 		return ret;
 
-	if (mf.code != xlate->code)
+	if (mf->code != xlate->code)
 		return -EINVAL;
 
 	ret = configure_geometry(isi, pix->width, pix->height, xlate->code);
 	if (ret < 0)
 		return ret;
 
-	pix->width		= mf.width;
-	pix->height		= mf.height;
-	pix->field		= mf.field;
-	pix->colorspace		= mf.colorspace;
+	pix->width		= mf->width;
+	pix->height		= mf->height;
+	pix->field		= mf->field;
+	pix->colorspace		= mf->colorspace;
 	icd->current_fmt	= xlate;
 
 	dev_dbg(icd->parent, "Finally set format %dx%d\n",
diff --git a/drivers/media/platform/soc_camera/mx2_camera.c b/drivers/media/platform/soc_camera/mx2_camera.c
index d45f50a..ea4c423 100644
--- a/drivers/media/platform/soc_camera/mx2_camera.c
+++ b/drivers/media/platform/soc_camera/mx2_camera.c
@@ -1127,7 +1127,10 @@ static int mx2_camera_set_fmt(struct soc_camera_device *icd,
 	struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
 	const struct soc_camera_format_xlate *xlate;
 	struct v4l2_pix_format *pix = &f->fmt.pix;
-	struct v4l2_mbus_framefmt mf;
+	struct v4l2_subdev_format format = {
+		.which = V4L2_SUBDEV_FORMAT_ACTIVE,
+	};
+	struct v4l2_mbus_framefmt *mf = &format.format;
 	int ret;
 
 	dev_dbg(icd->parent, "%s: requested params: width = %d, height = %d\n",
@@ -1140,19 +1143,19 @@ static int mx2_camera_set_fmt(struct soc_camera_device *icd,
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
 
-	ret = v4l2_subdev_call(sd, video, s_mbus_fmt, &mf);
+	ret = v4l2_subdev_call(sd, pad, set_fmt, NULL, &format);
 	if (ret < 0 && ret != -ENOIOCTLCMD)
 		return ret;
 
 	/* Store width and height returned by the sensor for resizing */
-	pcdev->s_width = mf.width;
-	pcdev->s_height = mf.height;
+	pcdev->s_width = mf->width;
+	pcdev->s_height = mf->height;
 	dev_dbg(icd->parent, "%s: sensor params: width = %d, height = %d\n",
 		__func__, pcdev->s_width, pcdev->s_height);
 
@@ -1160,19 +1163,19 @@ static int mx2_camera_set_fmt(struct soc_camera_device *icd,
 						   xlate->host_fmt->fourcc);
 
 	memset(pcdev->resizing, 0, sizeof(pcdev->resizing));
-	if ((mf.width != pix->width || mf.height != pix->height) &&
+	if ((mf->width != pix->width || mf->height != pix->height) &&
 		pcdev->emma_prp->cfg.in_fmt == PRP_CNTL_DATA_IN_YUV422) {
-		if (mx2_emmaprp_resize(pcdev, &mf, pix, true) < 0)
+		if (mx2_emmaprp_resize(pcdev, mf, pix, true) < 0)
 			dev_dbg(icd->parent, "%s: can't resize\n", __func__);
 	}
 
-	if (mf.code != xlate->code)
+	if (mf->code != xlate->code)
 		return -EINVAL;
 
-	pix->width		= mf.width;
-	pix->height		= mf.height;
-	pix->field		= mf.field;
-	pix->colorspace		= mf.colorspace;
+	pix->width		= mf->width;
+	pix->height		= mf->height;
+	pix->field		= mf->field;
+	pix->colorspace		= mf->colorspace;
 	icd->current_fmt	= xlate;
 
 	dev_dbg(icd->parent, "%s: returned params: width = %d, height = %d\n",
diff --git a/drivers/media/platform/soc_camera/mx3_camera.c b/drivers/media/platform/soc_camera/mx3_camera.c
index f635017..ace41f5 100644
--- a/drivers/media/platform/soc_camera/mx3_camera.c
+++ b/drivers/media/platform/soc_camera/mx3_camera.c
@@ -828,7 +828,7 @@ static int mx3_camera_set_crop(struct soc_camera_device *icd,
 	if (mf->width & 7) {
 		/* Ouch! We can only handle 8-byte aligned width... */
 		stride_align(&mf->width);
-		ret = v4l2_subdev_call(sd, video, s_mbus_fmt, mf);
+		ret = v4l2_subdev_call(sd, pad, set_fmt, NULL, &fmt);
 		if (ret < 0)
 			return ret;
 	}
@@ -854,7 +854,10 @@ static int mx3_camera_set_fmt(struct soc_camera_device *icd,
 	struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
 	const struct soc_camera_format_xlate *xlate;
 	struct v4l2_pix_format *pix = &f->fmt.pix;
-	struct v4l2_mbus_framefmt mf;
+	struct v4l2_subdev_format format = {
+		.which = V4L2_SUBDEV_FORMAT_ACTIVE,
+	};
+	struct v4l2_mbus_framefmt *mf = &format.format;
 	int ret;
 
 	xlate = soc_camera_xlate_by_fourcc(icd, pix->pixelformat);
@@ -875,17 +878,17 @@ static int mx3_camera_set_fmt(struct soc_camera_device *icd,
 
 	configure_geometry(mx3_cam, pix->width, pix->height, xlate->host_fmt);
 
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
 
-	ret = v4l2_subdev_call(sd, video, s_mbus_fmt, &mf);
+	ret = v4l2_subdev_call(sd, pad, set_fmt, NULL, &format);
 	if (ret < 0)
 		return ret;
 
-	if (mf.code != xlate->code)
+	if (mf->code != xlate->code)
 		return -EINVAL;
 
 	if (!mx3_cam->idmac_channel[0]) {
@@ -894,11 +897,11 @@ static int mx3_camera_set_fmt(struct soc_camera_device *icd,
 			return ret;
 	}
 
-	pix->width		= mf.width;
-	pix->height		= mf.height;
-	pix->field		= mf.field;
-	mx3_cam->field		= mf.field;
-	pix->colorspace		= mf.colorspace;
+	pix->width		= mf->width;
+	pix->height		= mf->height;
+	pix->field		= mf->field;
+	mx3_cam->field		= mf->field;
+	pix->colorspace		= mf->colorspace;
 	icd->current_fmt	= xlate;
 
 	dev_dbg(icd->parent, "Sensor set %dx%d\n", pix->width, pix->height);
diff --git a/drivers/media/platform/soc_camera/omap1_camera.c b/drivers/media/platform/soc_camera/omap1_camera.c
index 2a715e1..ba8dcd1 100644
--- a/drivers/media/platform/soc_camera/omap1_camera.c
+++ b/drivers/media/platform/soc_camera/omap1_camera.c
@@ -1157,7 +1157,7 @@ static int dma_align(int *width, int *height,
 	return 1;
 }
 
-#define subdev_call_with_sense(pcdev, dev, icd, sd, function, args...)		     \
+#define subdev_call_with_sense(pcdev, dev, icd, sd, op, function, args...)		     \
 ({										     \
 	struct soc_camera_sense sense = {					     \
 		.master_clock		= pcdev->camexclk,			     \
@@ -1168,7 +1168,7 @@ static int dma_align(int *width, int *height,
 	if (pcdev->pdata)							     \
 		sense.pixel_clock_max = pcdev->pdata->lclk_khz_max * 1000;	     \
 	icd->sense = &sense;							     \
-	__ret = v4l2_subdev_call(sd, video, function, ##args);			     \
+	__ret = v4l2_subdev_call(sd, op, function, ##args);			     \
 	icd->sense = NULL;							     \
 										     \
 	if (sense.flags & SOCAM_SENSE_PCLK_CHANGED) {				     \
@@ -1182,16 +1182,17 @@ static int dma_align(int *width, int *height,
 	__ret;									     \
 })
 
-static int set_mbus_format(struct omap1_cam_dev *pcdev, struct device *dev,
+static int set_format(struct omap1_cam_dev *pcdev, struct device *dev,
 		struct soc_camera_device *icd, struct v4l2_subdev *sd,
-		struct v4l2_mbus_framefmt *mf,
+		struct v4l2_subdev_format *format,
 		const struct soc_camera_format_xlate *xlate)
 {
 	s32 bytes_per_line;
-	int ret = subdev_call_with_sense(pcdev, dev, icd, sd, s_mbus_fmt, mf);
+	struct v4l2_mbus_framefmt *mf = &format->format;
+	int ret = subdev_call_with_sense(pcdev, dev, icd, sd, pad, set_fmt, NULL, format);
 
 	if (ret < 0) {
-		dev_err(dev, "%s: s_mbus_fmt failed\n", __func__);
+		dev_err(dev, "%s: set_fmt failed\n", __func__);
 		return ret;
 	}
 
@@ -1230,7 +1231,7 @@ static int omap1_cam_set_crop(struct soc_camera_device *icd,
 	struct v4l2_mbus_framefmt *mf = &fmt.format;
 	int ret;
 
-	ret = subdev_call_with_sense(pcdev, dev, icd, sd, s_crop, crop);
+	ret = subdev_call_with_sense(pcdev, dev, icd, sd, video, s_crop, crop);
 	if (ret < 0) {
 		dev_warn(dev, "%s: failed to crop to %ux%u@%u:%u\n", __func__,
 			 rect->width, rect->height, rect->left, rect->top);
@@ -1254,7 +1255,7 @@ static int omap1_cam_set_crop(struct soc_camera_device *icd,
 
 	if (!ret) {
 		/* sensor returned geometry not DMA aligned, trying to fix */
-		ret = set_mbus_format(pcdev, dev, icd, sd, mf, xlate);
+		ret = set_format(pcdev, dev, icd, sd, &fmt, xlate);
 		if (ret < 0) {
 			dev_err(dev, "%s: failed to set format\n", __func__);
 			return ret;
@@ -1276,7 +1277,10 @@ static int omap1_cam_set_fmt(struct soc_camera_device *icd,
 	struct soc_camera_host *ici = to_soc_camera_host(dev);
 	struct omap1_cam_dev *pcdev = ici->priv;
 	struct v4l2_pix_format *pix = &f->fmt.pix;
-	struct v4l2_mbus_framefmt mf;
+	struct v4l2_subdev_format format = {
+		.which = V4L2_SUBDEV_FORMAT_ACTIVE,
+	};
+	struct v4l2_mbus_framefmt *mf = &format.format;
 	int ret;
 
 	xlate = soc_camera_xlate_by_fourcc(icd, pix->pixelformat);
@@ -1286,13 +1290,13 @@ static int omap1_cam_set_fmt(struct soc_camera_device *icd,
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
 
-	ret = dma_align(&mf.width, &mf.height, xlate->host_fmt, pcdev->vb_mode,
+	ret = dma_align(&mf->width, &mf->height, xlate->host_fmt, pcdev->vb_mode,
 			true);
 	if (ret < 0) {
 		dev_err(dev, "%s: failed to align %ux%u %s with DMA\n",
@@ -1301,16 +1305,16 @@ static int omap1_cam_set_fmt(struct soc_camera_device *icd,
 		return ret;
 	}
 
-	ret = set_mbus_format(pcdev, dev, icd, sd, &mf, xlate);
+	ret = set_format(pcdev, dev, icd, sd, &format, xlate);
 	if (ret < 0) {
 		dev_err(dev, "%s: failed to set format\n", __func__);
 		return ret;
 	}
 
-	pix->width	 = mf.width;
-	pix->height	 = mf.height;
-	pix->field	 = mf.field;
-	pix->colorspace  = mf.colorspace;
+	pix->width	 = mf->width;
+	pix->height	 = mf->height;
+	pix->field	 = mf->field;
+	pix->colorspace  = mf->colorspace;
 	icd->current_fmt = xlate;
 
 	return 0;
diff --git a/drivers/media/platform/soc_camera/pxa_camera.c b/drivers/media/platform/soc_camera/pxa_camera.c
index 7ccd76f..fcb942d 100644
--- a/drivers/media/platform/soc_camera/pxa_camera.c
+++ b/drivers/media/platform/soc_camera/pxa_camera.c
@@ -1383,7 +1383,7 @@ static int pxa_camera_set_crop(struct soc_camera_device *icd,
 		v4l_bound_align_image(&mf->width, 48, 2048, 1,
 			&mf->height, 32, 2048, 0,
 			fourcc == V4L2_PIX_FMT_YUV422P ? 4 : 0);
-		ret = v4l2_subdev_call(sd, video, s_mbus_fmt, mf);
+		ret = v4l2_subdev_call(sd, pad, set_fmt, NULL, &fmt);
 		if (ret < 0)
 			return ret;
 
@@ -1425,7 +1425,10 @@ static int pxa_camera_set_fmt(struct soc_camera_device *icd,
 		.pixel_clock_max = pcdev->ciclk / 4,
 	};
 	struct v4l2_pix_format *pix = &f->fmt.pix;
-	struct v4l2_mbus_framefmt mf;
+	struct v4l2_subdev_format format = {
+		.which = V4L2_SUBDEV_FORMAT_ACTIVE,
+	};
+	struct v4l2_mbus_framefmt *mf = &format.format;
 	int ret;
 
 	xlate = soc_camera_xlate_by_fourcc(icd, pix->pixelformat);
@@ -1439,15 +1442,15 @@ static int pxa_camera_set_fmt(struct soc_camera_device *icd,
 		/* The caller holds a mutex. */
 		icd->sense = &sense;
 
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
 
-	ret = v4l2_subdev_call(sd, video, s_mbus_fmt, &mf);
+	ret = v4l2_subdev_call(sd, pad, set_fmt, NULL, &format);
 
-	if (mf.code != xlate->code)
+	if (mf->code != xlate->code)
 		return -EINVAL;
 
 	icd->sense = NULL;
@@ -1455,10 +1458,10 @@ static int pxa_camera_set_fmt(struct soc_camera_device *icd,
 	if (ret < 0) {
 		dev_warn(dev, "Failed to configure for format %x\n",
 			 pix->pixelformat);
-	} else if (pxa_camera_check_frame(mf.width, mf.height)) {
+	} else if (pxa_camera_check_frame(mf->width, mf->height)) {
 		dev_warn(dev,
 			 "Camera driver produced an unsupported frame %dx%d\n",
-			 mf.width, mf.height);
+			 mf->width, mf->height);
 		ret = -EINVAL;
 	} else if (sense.flags & SOCAM_SENSE_PCLK_CHANGED) {
 		if (sense.pixel_clock > sense.pixel_clock_max) {
@@ -1473,10 +1476,10 @@ static int pxa_camera_set_fmt(struct soc_camera_device *icd,
 	if (ret < 0)
 		return ret;
 
-	pix->width		= mf.width;
-	pix->height		= mf.height;
-	pix->field		= mf.field;
-	pix->colorspace		= mf.colorspace;
+	pix->width		= mf->width;
+	pix->height		= mf->height;
+	pix->field		= mf->field;
+	pix->colorspace		= mf->colorspace;
 	icd->current_fmt	= xlate;
 
 	return ret;
diff --git a/drivers/media/platform/soc_camera/rcar_vin.c b/drivers/media/platform/soc_camera/rcar_vin.c
index 063285a..35deed8 100644
--- a/drivers/media/platform/soc_camera/rcar_vin.c
+++ b/drivers/media/platform/soc_camera/rcar_vin.c
@@ -1376,8 +1376,8 @@ static int rcar_vin_get_formats(struct soc_camera_device *icd, unsigned int idx,
 			mf->height = 960 >> shift;
 			ret = v4l2_device_call_until_err(sd->v4l2_dev,
 							 soc_camera_grp_id(icd),
-							 video, s_mbus_fmt,
-							 mf);
+							 pad, set_fmt, NULL,
+							 &fmt);
 			if (ret < 0)
 				return ret;
 		}
diff --git a/drivers/media/platform/soc_camera/sh_mobile_ceu_camera.c b/drivers/media/platform/soc_camera/sh_mobile_ceu_camera.c
index 91c48ab..c5c6c4e 100644
--- a/drivers/media/platform/soc_camera/sh_mobile_ceu_camera.c
+++ b/drivers/media/platform/soc_camera/sh_mobile_ceu_camera.c
@@ -1111,8 +1111,8 @@ static int sh_mobile_ceu_get_formats(struct soc_camera_device *icd, unsigned int
 			mf->width	= 2560 >> shift;
 			mf->height	= 1920 >> shift;
 			ret = v4l2_device_call_until_err(sd->v4l2_dev,
-					soc_camera_grp_id(icd), video,
-					s_mbus_fmt, mf);
+					soc_camera_grp_id(icd), pad,
+					set_fmt, NULL, &fmt);
 			if (ret < 0)
 				return ret;
 			shift++;
@@ -1286,8 +1286,8 @@ static int sh_mobile_ceu_set_crop(struct soc_camera_device *icd,
 
 	if (interm_width < icd->user_width || interm_height < icd->user_height) {
 		ret = v4l2_device_call_until_err(sd->v4l2_dev,
-					soc_camera_grp_id(icd), video,
-					s_mbus_fmt, mf);
+					soc_camera_grp_id(icd), pad,
+					set_fmt, NULL, &fmt);
 		if (ret < 0)
 			return ret;
 
diff --git a/drivers/media/platform/soc_camera/soc_scale_crop.c b/drivers/media/platform/soc_camera/soc_scale_crop.c
index 8e74fb7..bda29bc 100644
--- a/drivers/media/platform/soc_camera/soc_scale_crop.c
+++ b/drivers/media/platform/soc_camera/soc_scale_crop.c
@@ -211,22 +211,23 @@ int soc_camera_client_s_crop(struct v4l2_subdev *sd,
 }
 EXPORT_SYMBOL(soc_camera_client_s_crop);
 
-/* Iterative s_mbus_fmt, also updates cached client crop on success */
-static int client_s_fmt(struct soc_camera_device *icd,
+/* Iterative set_fmt, also updates cached client crop on success */
+static int client_set_fmt(struct soc_camera_device *icd,
 			struct v4l2_rect *rect, struct v4l2_rect *subrect,
 			unsigned int max_width, unsigned int max_height,
-			struct v4l2_mbus_framefmt *mf, bool host_can_scale)
+			struct v4l2_subdev_format *format, bool host_can_scale)
 {
 	struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
 	struct device *dev = icd->parent;
+	struct v4l2_mbus_framefmt *mf = &format->format;
 	unsigned int width = mf->width, height = mf->height, tmp_w, tmp_h;
 	struct v4l2_cropcap cap;
 	bool host_1to1;
 	int ret;
 
 	ret = v4l2_device_call_until_err(sd->v4l2_dev,
-					 soc_camera_grp_id(icd), video,
-					 s_mbus_fmt, mf);
+					 soc_camera_grp_id(icd), pad,
+					 set_fmt, NULL, format);
 	if (ret < 0)
 		return ret;
 
@@ -265,8 +266,8 @@ static int client_s_fmt(struct soc_camera_device *icd,
 		mf->width = tmp_w;
 		mf->height = tmp_h;
 		ret = v4l2_device_call_until_err(sd->v4l2_dev,
-					soc_camera_grp_id(icd), video,
-					s_mbus_fmt, mf);
+					soc_camera_grp_id(icd), pad,
+					set_fmt, NULL, format);
 		dev_geo(dev, "Camera scaled to %ux%u\n",
 			mf->width, mf->height);
 		if (ret < 0) {
@@ -309,7 +310,11 @@ int soc_camera_client_scale(struct soc_camera_device *icd,
 			bool host_can_scale, unsigned int shift)
 {
 	struct device *dev = icd->parent;
-	struct v4l2_mbus_framefmt mf_tmp = *mf;
+	struct v4l2_subdev_format fmt_tmp = {
+		.which = V4L2_SUBDEV_FORMAT_ACTIVE,
+		.format = *mf,
+	};
+	struct v4l2_mbus_framefmt *mf_tmp = &fmt_tmp.format;
 	unsigned int scale_h, scale_v;
 	int ret;
 
@@ -317,25 +322,25 @@ int soc_camera_client_scale(struct soc_camera_device *icd,
 	 * 5. Apply iterative camera S_FMT for camera user window (also updates
 	 *    client crop cache and the imaginary sub-rectangle).
 	 */
-	ret = client_s_fmt(icd, rect, subrect, *width, *height,
-			   &mf_tmp, host_can_scale);
+	ret = client_set_fmt(icd, rect, subrect, *width, *height,
+			   &fmt_tmp, host_can_scale);
 	if (ret < 0)
 		return ret;
 
 	dev_geo(dev, "5: camera scaled to %ux%u\n",
-		mf_tmp.width, mf_tmp.height);
+		mf_tmp->width, mf_tmp->height);
 
 	/* 6. Retrieve camera output window (g_fmt) */
 
 	/* unneeded - it is already in "mf_tmp" */
 
 	/* 7. Calculate new client scales. */
-	scale_h = soc_camera_calc_scale(rect->width, shift, mf_tmp.width);
-	scale_v = soc_camera_calc_scale(rect->height, shift, mf_tmp.height);
+	scale_h = soc_camera_calc_scale(rect->width, shift, mf_tmp->width);
+	scale_v = soc_camera_calc_scale(rect->height, shift, mf_tmp->height);
 
-	mf->width	= mf_tmp.width;
-	mf->height	= mf_tmp.height;
-	mf->colorspace	= mf_tmp.colorspace;
+	mf->width	= mf_tmp->width;
+	mf->height	= mf_tmp->height;
+	mf->colorspace	= mf_tmp->colorspace;
 
 	/*
 	 * 8. Calculate new host crop - apply camera scales to previously
diff --git a/drivers/media/platform/via-camera.c b/drivers/media/platform/via-camera.c
index 6331d6b..32e4ff4 100644
--- a/drivers/media/platform/via-camera.c
+++ b/drivers/media/platform/via-camera.c
@@ -249,13 +249,15 @@ static int viacam_set_flip(struct via_camera *cam)
  */
 static int viacam_configure_sensor(struct via_camera *cam)
 {
-	struct v4l2_mbus_framefmt mbus_fmt;
+	struct v4l2_subdev_format format = {
+		.which = V4L2_SUBDEV_FORMAT_ACTIVE,
+	};
 	int ret;
 
-	v4l2_fill_mbus_format(&mbus_fmt, &cam->sensor_format, cam->mbus_code);
+	v4l2_fill_mbus_format(&format.format, &cam->sensor_format, cam->mbus_code);
 	ret = sensor_call(cam, core, init, 0);
 	if (ret == 0)
-		ret = sensor_call(cam, video, s_mbus_fmt, &mbus_fmt);
+		ret = sensor_call(cam, pad, set_fmt, NULL, &format);
 	/*
 	 * OV7670 does weird things if flip is set *before* format...
 	 */
diff --git a/drivers/media/usb/cx231xx/cx231xx-417.c b/drivers/media/usb/cx231xx/cx231xx-417.c
index 983ea83..3474af7 100644
--- a/drivers/media/usb/cx231xx/cx231xx-417.c
+++ b/drivers/media/usb/cx231xx/cx231xx-417.c
@@ -1878,13 +1878,15 @@ static int cx231xx_s_video_encoding(struct cx2341x_handler *cxhdl, u32 val)
 {
 	struct cx231xx *dev = container_of(cxhdl, struct cx231xx, mpeg_ctrl_handler);
 	int is_mpeg1 = val == V4L2_MPEG_VIDEO_ENCODING_MPEG_1;
-	struct v4l2_mbus_framefmt fmt;
+	struct v4l2_subdev_format format = {
+		.which = V4L2_SUBDEV_FORMAT_ACTIVE,
+	};
 
 	/* fix videodecoder resolution */
-	fmt.width = cxhdl->width / (is_mpeg1 ? 2 : 1);
-	fmt.height = cxhdl->height;
-	fmt.code = MEDIA_BUS_FMT_FIXED;
-	v4l2_subdev_call(dev->sd_cx25840, video, s_mbus_fmt, &fmt);
+	format.format.width = cxhdl->width / (is_mpeg1 ? 2 : 1);
+	format.format.height = cxhdl->height;
+	format.format.code = MEDIA_BUS_FMT_FIXED;
+	v4l2_subdev_call(dev->sd_cx25840, pad, set_fmt, NULL, &format);
 	return 0;
 }
 
diff --git a/drivers/media/usb/cx231xx/cx231xx-video.c b/drivers/media/usb/cx231xx/cx231xx-video.c
index c261e16..af44f2d 100644
--- a/drivers/media/usb/cx231xx/cx231xx-video.c
+++ b/drivers/media/usb/cx231xx/cx231xx-video.c
@@ -1013,7 +1013,9 @@ static int vidioc_s_fmt_vid_cap(struct file *file, void *priv,
 	struct cx231xx *dev = fh->dev;
 	int rc;
 	struct cx231xx_fmt *fmt;
-	struct v4l2_mbus_framefmt mbus_fmt;
+	struct v4l2_subdev_format format = {
+		.which = V4L2_SUBDEV_FORMAT_ACTIVE,
+	};
 
 	rc = check_dev(dev);
 	if (rc < 0)
@@ -1041,9 +1043,9 @@ static int vidioc_s_fmt_vid_cap(struct file *file, void *priv,
 	dev->height = f->fmt.pix.height;
 	dev->format = fmt;
 
-	v4l2_fill_mbus_format(&mbus_fmt, &f->fmt.pix, MEDIA_BUS_FMT_FIXED);
-	call_all(dev, video, s_mbus_fmt, &mbus_fmt);
-	v4l2_fill_pix_format(&f->fmt.pix, &mbus_fmt);
+	v4l2_fill_mbus_format(&format.format, &f->fmt.pix, MEDIA_BUS_FMT_FIXED);
+	call_all(dev, pad, set_fmt, NULL, &format);
+	v4l2_fill_pix_format(&f->fmt.pix, &format.format);
 
 	return rc;
 }
@@ -1061,7 +1063,9 @@ static int vidioc_s_std(struct file *file, void *priv, v4l2_std_id norm)
 {
 	struct cx231xx_fh *fh = priv;
 	struct cx231xx *dev = fh->dev;
-	struct v4l2_mbus_framefmt mbus_fmt;
+	struct v4l2_subdev_format format = {
+		.which = V4L2_SUBDEV_FORMAT_ACTIVE,
+	};
 	int rc;
 
 	rc = check_dev(dev);
@@ -1085,11 +1089,10 @@ static int vidioc_s_std(struct file *file, void *priv, v4l2_std_id norm)
 	/* We need to reset basic properties in the decoder related to
 	   resolution (since a standard change effects things like the number
 	   of lines in VACT, etc) */
-	memset(&mbus_fmt, 0, sizeof(mbus_fmt));
-	mbus_fmt.code = MEDIA_BUS_FMT_FIXED;
-	mbus_fmt.width = dev->width;
-	mbus_fmt.height = dev->height;
-	call_all(dev, video, s_mbus_fmt, &mbus_fmt);
+	format.format.code = MEDIA_BUS_FMT_FIXED;
+	format.format.width = dev->width;
+	format.format.height = dev->height;
+	call_all(dev, pad, set_fmt, NULL, &format);
 
 	/* do mode control overrides */
 	cx231xx_do_mode_ctrl_overrides(dev);
diff --git a/drivers/media/usb/em28xx/em28xx-camera.c b/drivers/media/usb/em28xx/em28xx-camera.c
index a4b22c2..ed0b3a8 100644
--- a/drivers/media/usb/em28xx/em28xx-camera.c
+++ b/drivers/media/usb/em28xx/em28xx-camera.c
@@ -404,7 +404,9 @@ int em28xx_init_camera(struct em28xx *dev)
 			.addr = client->addr,
 			.platform_data = &camlink,
 		};
-		struct v4l2_mbus_framefmt fmt;
+		struct v4l2_subdev_format format = {
+			.which = V4L2_SUBDEV_FORMAT_ACTIVE,
+		};
 
 		/*
 		 * FIXME: sensor supports resolutions up to 1600x1200, but
@@ -425,10 +427,10 @@ int em28xx_init_camera(struct em28xx *dev)
 			break;
 		}
 
-		fmt.code = MEDIA_BUS_FMT_YUYV8_2X8;
-		fmt.width = 640;
-		fmt.height = 480;
-		v4l2_subdev_call(subdev, video, s_mbus_fmt, &fmt);
+		format.format.code = MEDIA_BUS_FMT_YUYV8_2X8;
+		format.format.width = 640;
+		format.format.height = 480;
+		v4l2_subdev_call(subdev, pad, set_fmt, NULL, &format);
 
 		/* NOTE: for UXGA=1600x1200 switch to 12MHz */
 		dev->board.xclk = EM28XX_XCLK_FREQUENCY_24MHZ;
diff --git a/drivers/media/usb/go7007/go7007-v4l2.c b/drivers/media/usb/go7007/go7007-v4l2.c
index d6bf982..c57207e 100644
--- a/drivers/media/usb/go7007/go7007-v4l2.c
+++ b/drivers/media/usb/go7007/go7007-v4l2.c
@@ -250,15 +250,17 @@ static int set_capture_size(struct go7007 *go, struct v4l2_format *fmt, int try)
 	go->encoder_v_offset = go->board_info->sensor_v_offset;
 
 	if (go->board_info->sensor_flags & GO7007_SENSOR_SCALING) {
-		struct v4l2_mbus_framefmt mbus_fmt;
+		struct v4l2_subdev_format format = {
+			.which = V4L2_SUBDEV_FORMAT_ACTIVE,
+		};
 
-		mbus_fmt.code = MEDIA_BUS_FMT_FIXED;
-		mbus_fmt.width = fmt ? fmt->fmt.pix.width : width;
-		mbus_fmt.height = height;
+		format.format.code = MEDIA_BUS_FMT_FIXED;
+		format.format.width = fmt ? fmt->fmt.pix.width : width;
+		format.format.height = height;
 		go->encoder_h_halve = 0;
 		go->encoder_v_halve = 0;
 		go->encoder_subsample = 0;
-		call_all(&go->v4l2_dev, video, s_mbus_fmt, &mbus_fmt);
+		call_all(&go->v4l2_dev, pad, set_fmt, NULL, &format);
 	} else {
 		if (width <= sensor_width / 4) {
 			go->encoder_h_halve = 1;
diff --git a/drivers/media/usb/pvrusb2/pvrusb2-hdw.c b/drivers/media/usb/pvrusb2/pvrusb2-hdw.c
index 930593d..1256972 100644
--- a/drivers/media/usb/pvrusb2/pvrusb2-hdw.c
+++ b/drivers/media/usb/pvrusb2/pvrusb2-hdw.c
@@ -2958,14 +2958,17 @@ static void pvr2_subdev_update(struct pvr2_hdw *hdw)
 	}
 
 	if (hdw->res_hor_dirty || hdw->res_ver_dirty || hdw->force_dirty) {
-		struct v4l2_mbus_framefmt fmt;
-		memset(&fmt, 0, sizeof(fmt));
-		fmt.width = hdw->res_hor_val;
-		fmt.height = hdw->res_ver_val;
-		fmt.code = MEDIA_BUS_FMT_FIXED;
+		struct v4l2_subdev_format format = {
+			.which = V4L2_SUBDEV_FORMAT_ACTIVE,
+		};
+
+		format.format.width = hdw->res_hor_val;
+		format.format.height = hdw->res_ver_val;
+		format.format.code = MEDIA_BUS_FMT_FIXED;
 		pvr2_trace(PVR2_TRACE_CHIPS, "subdev v4l2 set_size(%dx%d)",
-			   fmt.width, fmt.height);
-		v4l2_device_call_all(&hdw->v4l2_dev, 0, video, s_mbus_fmt, &fmt);
+			   format.format.width, format.format.height);
+		v4l2_device_call_all(&hdw->v4l2_dev, 0, pad, set_fmt,
+				     NULL, &format);
 	}
 
 	if (hdw->srate_dirty || hdw->force_dirty) {
diff --git a/include/media/v4l2-subdev.h b/include/media/v4l2-subdev.h
index 67a8e4e..8f5da73 100644
--- a/include/media/v4l2-subdev.h
+++ b/include/media/v4l2-subdev.h
@@ -293,10 +293,6 @@ struct v4l2_mbus_frame_desc {
 
    g_dv_timings(): Get custom dv timings in the sub device.
 
-   try_mbus_fmt: try to set a pixel format on a video data source
-
-   s_mbus_fmt: set a pixel format on a video data source
-
    g_mbus_config: get supported mediabus configurations
 
    s_mbus_config: set a certain mediabus configuration. This operation is added
@@ -334,10 +330,6 @@ struct v4l2_subdev_video_ops {
 			struct v4l2_dv_timings *timings);
 	int (*query_dv_timings)(struct v4l2_subdev *sd,
 			struct v4l2_dv_timings *timings);
-	int (*try_mbus_fmt)(struct v4l2_subdev *sd,
-			    struct v4l2_mbus_framefmt *fmt);
-	int (*s_mbus_fmt)(struct v4l2_subdev *sd,
-			  struct v4l2_mbus_framefmt *fmt);
 	int (*g_mbus_config)(struct v4l2_subdev *sd,
 			     struct v4l2_mbus_config *cfg);
 	int (*s_mbus_config)(struct v4l2_subdev *sd,
-- 
2.1.4

