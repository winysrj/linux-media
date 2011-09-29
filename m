Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.171]:57613 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757192Ab1I2QTD (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 29 Sep 2011 12:19:03 -0400
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Deepthy Ravi <deepthy.ravi@ti.com>
Subject: [PATCH 6/9] V4L: soc-camera: prepare hooks for Media Controller wrapper
Date: Thu, 29 Sep 2011 18:18:54 +0200
Message-Id: <1317313137-4403-7-git-send-email-g.liakhovetski@gmx.de>
In-Reply-To: <1317313137-4403-1-git-send-email-g.liakhovetski@gmx.de>
References: <1317313137-4403-1-git-send-email-g.liakhovetski@gmx.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Extend soc-camera host operations with a target parameter to specify, whether
the operation should be propagated to subdevices or only applied to the host
itself.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---
 drivers/media/video/atmel-isi.c            |   10 +++-
 drivers/media/video/mx1_camera.c           |   10 +++-
 drivers/media/video/mx2_camera.c           |   10 +++-
 drivers/media/video/mx3_camera.c           |   10 +++-
 drivers/media/video/omap1_camera.c         |   12 +++-
 drivers/media/video/pxa_camera.c           |   10 +++-
 drivers/media/video/sh_mobile_ceu_camera.c |   12 +++-
 drivers/media/video/soc_camera.c           |   82 +++++++++++++++++++++-------
 include/media/soc_camera.h                 |   25 ++++++++-
 include/media/soc_entity.h                 |   19 +++++++
 10 files changed, 163 insertions(+), 37 deletions(-)
 create mode 100644 include/media/soc_entity.h

diff --git a/drivers/media/video/atmel-isi.c b/drivers/media/video/atmel-isi.c
index 84d7a85..6db8d43 100644
--- a/drivers/media/video/atmel-isi.c
+++ b/drivers/media/video/atmel-isi.c
@@ -527,7 +527,7 @@ static int isi_camera_init_videobuf(struct vb2_queue *q,
 }
 
 static int isi_camera_set_fmt(struct soc_camera_device *icd,
-			      struct v4l2_format *f)
+			      struct v4l2_format *f, enum soc_camera_target tgt)
 {
 	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
 	struct atmel_isi *isi = ici->priv;
@@ -537,6 +537,9 @@ static int isi_camera_set_fmt(struct soc_camera_device *icd,
 	struct v4l2_mbus_framefmt mf;
 	int ret;
 
+	if (tgt != SOCAM_TARGET_PIPELINE)
+		return -EINVAL;
+
 	xlate = soc_camera_xlate_by_fourcc(icd, pix->pixelformat);
 	if (!xlate) {
 		dev_warn(icd->parent, "Format %x not found\n",
@@ -577,7 +580,7 @@ static int isi_camera_set_fmt(struct soc_camera_device *icd,
 }
 
 static int isi_camera_try_fmt(struct soc_camera_device *icd,
-			      struct v4l2_format *f)
+			      struct v4l2_format *f, enum soc_camera_target tgt)
 {
 	struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
 	const struct soc_camera_format_xlate *xlate;
@@ -586,6 +589,9 @@ static int isi_camera_try_fmt(struct soc_camera_device *icd,
 	u32 pixfmt = pix->pixelformat;
 	int ret;
 
+	if (tgt != SOCAM_TARGET_PIPELINE)
+		return -EINVAL;
+
 	xlate = soc_camera_xlate_by_fourcc(icd, pixfmt);
 	if (pixfmt && !xlate) {
 		dev_warn(icd->parent, "Format %x not found\n", pixfmt);
diff --git a/drivers/media/video/mx1_camera.c b/drivers/media/video/mx1_camera.c
index 055d11d..b63a163 100644
--- a/drivers/media/video/mx1_camera.c
+++ b/drivers/media/video/mx1_camera.c
@@ -564,7 +564,7 @@ static int mx1_camera_set_bus_param(struct soc_camera_device *icd)
 }
 
 static int mx1_camera_set_fmt(struct soc_camera_device *icd,
-			      struct v4l2_format *f)
+			      struct v4l2_format *f, enum soc_camera_target tgt)
 {
 	struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
 	const struct soc_camera_format_xlate *xlate;
@@ -572,6 +572,9 @@ static int mx1_camera_set_fmt(struct soc_camera_device *icd,
 	struct v4l2_mbus_framefmt mf;
 	int ret, buswidth;
 
+	if (tgt != SOCAM_TARGET_PIPELINE)
+		return -EINVAL;
+
 	xlate = soc_camera_xlate_by_fourcc(icd, pix->pixelformat);
 	if (!xlate) {
 		dev_warn(icd->parent, "Format %x not found\n",
@@ -610,7 +613,7 @@ static int mx1_camera_set_fmt(struct soc_camera_device *icd,
 }
 
 static int mx1_camera_try_fmt(struct soc_camera_device *icd,
-			      struct v4l2_format *f)
+			      struct v4l2_format *f, enum soc_camera_target tgt)
 {
 	struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
 	const struct soc_camera_format_xlate *xlate;
@@ -619,6 +622,9 @@ static int mx1_camera_try_fmt(struct soc_camera_device *icd,
 	int ret;
 	/* TODO: limit to mx1 hardware capabilities */
 
+	if (tgt != SOCAM_TARGET_PIPELINE)
+		return -EINVAL;
+
 	xlate = soc_camera_xlate_by_fourcc(icd, pix->pixelformat);
 	if (!xlate) {
 		dev_warn(icd->parent, "Format %x not found\n",
diff --git a/drivers/media/video/mx2_camera.c b/drivers/media/video/mx2_camera.c
index ffbfbfe..614dd0a 100644
--- a/drivers/media/video/mx2_camera.c
+++ b/drivers/media/video/mx2_camera.c
@@ -911,7 +911,7 @@ static int mx2_camera_set_crop(struct soc_camera_device *icd,
 }
 
 static int mx2_camera_set_fmt(struct soc_camera_device *icd,
-			       struct v4l2_format *f)
+			      struct v4l2_format *f, enum soc_camera_target tgt)
 {
 	struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
 	const struct soc_camera_format_xlate *xlate;
@@ -919,6 +919,9 @@ static int mx2_camera_set_fmt(struct soc_camera_device *icd,
 	struct v4l2_mbus_framefmt mf;
 	int ret;
 
+	if (tgt != SOCAM_TARGET_PIPELINE)
+		return -EINVAL;
+
 	xlate = soc_camera_xlate_by_fourcc(icd, pix->pixelformat);
 	if (!xlate) {
 		dev_warn(icd->parent, "Format %x not found\n",
@@ -949,7 +952,7 @@ static int mx2_camera_set_fmt(struct soc_camera_device *icd,
 }
 
 static int mx2_camera_try_fmt(struct soc_camera_device *icd,
-				  struct v4l2_format *f)
+			      struct v4l2_format *f, enum soc_camera_target tgt)
 {
 	struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
 	const struct soc_camera_format_xlate *xlate;
@@ -959,6 +962,9 @@ static int mx2_camera_try_fmt(struct soc_camera_device *icd,
 	unsigned int width_limit;
 	int ret;
 
+	if (tgt != SOCAM_TARGET_PIPELINE)
+		return -EINVAL;
+
 	xlate = soc_camera_xlate_by_fourcc(icd, pixfmt);
 	if (pixfmt && !xlate) {
 		dev_warn(icd->parent, "Format %x not found\n", pixfmt);
diff --git a/drivers/media/video/mx3_camera.c b/drivers/media/video/mx3_camera.c
index 6020061..466c2cf 100644
--- a/drivers/media/video/mx3_camera.c
+++ b/drivers/media/video/mx3_camera.c
@@ -846,7 +846,7 @@ static int mx3_camera_set_crop(struct soc_camera_device *icd,
 }
 
 static int mx3_camera_set_fmt(struct soc_camera_device *icd,
-			      struct v4l2_format *f)
+			      struct v4l2_format *f, enum soc_camera_target tgt)
 {
 	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
 	struct mx3_camera_dev *mx3_cam = ici->priv;
@@ -856,6 +856,9 @@ static int mx3_camera_set_fmt(struct soc_camera_device *icd,
 	struct v4l2_mbus_framefmt mf;
 	int ret;
 
+	if (tgt != SOCAM_TARGET_PIPELINE)
+		return -EINVAL;
+
 	xlate = soc_camera_xlate_by_fourcc(icd, pix->pixelformat);
 	if (!xlate) {
 		dev_warn(icd->parent, "Format %x not found\n",
@@ -906,7 +909,7 @@ static int mx3_camera_set_fmt(struct soc_camera_device *icd,
 }
 
 static int mx3_camera_try_fmt(struct soc_camera_device *icd,
-			      struct v4l2_format *f)
+			      struct v4l2_format *f, enum soc_camera_target tgt)
 {
 	struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
 	const struct soc_camera_format_xlate *xlate;
@@ -915,6 +918,9 @@ static int mx3_camera_try_fmt(struct soc_camera_device *icd,
 	__u32 pixfmt = pix->pixelformat;
 	int ret;
 
+	if (tgt != SOCAM_TARGET_PIPELINE)
+		return -EINVAL;
+
 	xlate = soc_camera_xlate_by_fourcc(icd, pixfmt);
 	if (pixfmt && !xlate) {
 		dev_warn(icd->parent, "Format %x not found\n", pixfmt);
diff --git a/drivers/media/video/omap1_camera.c b/drivers/media/video/omap1_camera.c
index e73a23e..967e32b 100644
--- a/drivers/media/video/omap1_camera.c
+++ b/drivers/media/video/omap1_camera.c
@@ -1216,7 +1216,7 @@ static int set_mbus_format(struct omap1_cam_dev *pcdev, struct device *dev,
 }
 
 static int omap1_cam_set_crop(struct soc_camera_device *icd,
-			       struct v4l2_crop *crop)
+			      struct v4l2_crop *crop)
 {
 	struct v4l2_rect *rect = &crop->c;
 	const struct soc_camera_format_xlate *xlate = icd->current_fmt;
@@ -1265,7 +1265,7 @@ static int omap1_cam_set_crop(struct soc_camera_device *icd,
 }
 
 static int omap1_cam_set_fmt(struct soc_camera_device *icd,
-			      struct v4l2_format *f)
+			     struct v4l2_format *f, enum soc_camera_target tgt)
 {
 	struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
 	const struct soc_camera_format_xlate *xlate;
@@ -1276,6 +1276,9 @@ static int omap1_cam_set_fmt(struct soc_camera_device *icd,
 	struct v4l2_mbus_framefmt mf;
 	int ret;
 
+	if (tgt != SOCAM_TARGET_PIPELINE)
+		return -EINVAL;
+
 	xlate = soc_camera_xlate_by_fourcc(icd, pix->pixelformat);
 	if (!xlate) {
 		dev_warn(dev, "%s: format %#x not found\n", __func__,
@@ -1314,7 +1317,7 @@ static int omap1_cam_set_fmt(struct soc_camera_device *icd,
 }
 
 static int omap1_cam_try_fmt(struct soc_camera_device *icd,
-			      struct v4l2_format *f)
+			     struct v4l2_format *f, enum soc_camera_target tgt)
 {
 	struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
 	const struct soc_camera_format_xlate *xlate;
@@ -1323,6 +1326,9 @@ static int omap1_cam_try_fmt(struct soc_camera_device *icd,
 	int ret;
 	/* TODO: limit to mx1 hardware capabilities */
 
+	if (tgt != SOCAM_TARGET_PIPELINE)
+		return -EINVAL;
+
 	xlate = soc_camera_xlate_by_fourcc(icd, pix->pixelformat);
 	if (!xlate) {
 		dev_warn(icd->parent, "Format %#x not found\n",
diff --git a/drivers/media/video/pxa_camera.c b/drivers/media/video/pxa_camera.c
index 2f9ae63..fc74788 100644
--- a/drivers/media/video/pxa_camera.c
+++ b/drivers/media/video/pxa_camera.c
@@ -1418,7 +1418,7 @@ static int pxa_camera_set_crop(struct soc_camera_device *icd,
 }
 
 static int pxa_camera_set_fmt(struct soc_camera_device *icd,
-			      struct v4l2_format *f)
+			      struct v4l2_format *f, enum soc_camera_target tgt)
 {
 	struct device *dev = icd->parent;
 	struct soc_camera_host *ici = to_soc_camera_host(dev);
@@ -1433,6 +1433,9 @@ static int pxa_camera_set_fmt(struct soc_camera_device *icd,
 	struct v4l2_mbus_framefmt mf;
 	int ret;
 
+	if (tgt != SOCAM_TARGET_PIPELINE)
+		return -EINVAL;
+
 	xlate = soc_camera_xlate_by_fourcc(icd, pix->pixelformat);
 	if (!xlate) {
 		dev_warn(dev, "Format %x not found\n", pix->pixelformat);
@@ -1488,7 +1491,7 @@ static int pxa_camera_set_fmt(struct soc_camera_device *icd,
 }
 
 static int pxa_camera_try_fmt(struct soc_camera_device *icd,
-			      struct v4l2_format *f)
+			      struct v4l2_format *f, enum soc_camera_target tgt)
 {
 	struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
 	const struct soc_camera_format_xlate *xlate;
@@ -1497,6 +1500,9 @@ static int pxa_camera_try_fmt(struct soc_camera_device *icd,
 	__u32 pixfmt = pix->pixelformat;
 	int ret;
 
+	if (tgt != SOCAM_TARGET_PIPELINE)
+		return -EINVAL;
+
 	xlate = soc_camera_xlate_by_fourcc(icd, pixfmt);
 	if (!xlate) {
 		dev_warn(icd->parent, "Format %x not found\n", pixfmt);
diff --git a/drivers/media/video/sh_mobile_ceu_camera.c b/drivers/media/video/sh_mobile_ceu_camera.c
index 367dd43..3e7085f 100644
--- a/drivers/media/video/sh_mobile_ceu_camera.c
+++ b/drivers/media/video/sh_mobile_ceu_camera.c
@@ -1509,7 +1509,7 @@ static int ceu_crop_full_window(struct soc_camera_device *icd,
 
 /* Similar to set_crop multistage iterative algorithm */
 static int sh_mobile_ceu_set_fmt(struct soc_camera_device *icd,
-				 struct v4l2_format *f)
+				 struct v4l2_format *f, enum soc_camera_target tgt)
 {
 	struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
 	struct device *dev = icd->parent;
@@ -1530,6 +1530,9 @@ static int sh_mobile_ceu_set_fmt(struct soc_camera_device *icd,
 	bool image_mode;
 	int ret;
 
+	if (tgt != SOCAM_TARGET_PIPELINE)
+		return -EINVAL;
+
 	/* .try_fmt() has been called, size valid */
 
 	xlate = soc_camera_xlate_by_fourcc(icd, pixfmt);
@@ -1644,7 +1647,7 @@ static int sh_mobile_ceu_set_fmt(struct soc_camera_device *icd,
 }
 
 static int sh_mobile_ceu_try_fmt(struct soc_camera_device *icd,
-				 struct v4l2_format *f)
+				 struct v4l2_format *f, enum soc_camera_target tgt)
 {
 	const struct soc_camera_format_xlate *xlate;
 	struct v4l2_pix_format *pix = &f->fmt.pix;
@@ -1654,6 +1657,9 @@ static int sh_mobile_ceu_try_fmt(struct soc_camera_device *icd,
 	int width, height;
 	int ret;
 
+	if (tgt != SOCAM_TARGET_PIPELINE)
+		return -EINVAL;
+
 	dev_geo(icd->parent, "TRY_FMT(pix=0x%x, %ux%u)\n",
 		 pixfmt, pix->width, pix->height);
 
@@ -1772,7 +1778,7 @@ static int sh_mobile_ceu_set_livecrop(struct soc_camera_device *icd,
 				.colorspace	= icd->colorspace,
 			},
 		};
-		ret = sh_mobile_ceu_set_fmt(icd, &f);
+		ret = sh_mobile_ceu_set_fmt(icd, &f, SOCAM_TARGET_PIPELINE);
 		if (!ret && (out_width != f.fmt.pix.width ||
 			     out_height != f.fmt.pix.height))
 			ret = -EINVAL;
diff --git a/drivers/media/video/soc_camera.c b/drivers/media/video/soc_camera.c
index 2905a88..790c14c 100644
--- a/drivers/media/video/soc_camera.c
+++ b/drivers/media/video/soc_camera.c
@@ -30,6 +30,7 @@
 #include <linux/vmalloc.h>
 
 #include <media/soc_camera.h>
+#include <media/soc_entity.h>
 #include <media/v4l2-common.h>
 #include <media/v4l2-ioctl.h>
 #include <media/v4l2-dev.h>
@@ -183,8 +184,8 @@ EXPORT_SYMBOL(soc_camera_apply_board_flags);
 #define pixfmtstr(x) (x) & 0xff, ((x) >> 8) & 0xff, ((x) >> 16) & 0xff, \
 	((x) >> 24) & 0xff
 
-static int soc_camera_try_fmt(struct soc_camera_device *icd,
-			      struct v4l2_format *f)
+int soc_camera_try_fmt(struct soc_camera_device *icd, struct v4l2_format *f,
+		       enum soc_camera_target target)
 {
 	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
 	struct v4l2_pix_format *pix = &f->fmt.pix;
@@ -196,7 +197,7 @@ static int soc_camera_try_fmt(struct soc_camera_device *icd,
 	pix->bytesperline = 0;
 	pix->sizeimage = 0;
 
-	ret = ici->ops->try_fmt(icd, f);
+	ret = ici->ops->try_fmt(icd, f, target);
 	if (ret < 0)
 		return ret;
 
@@ -232,7 +233,7 @@ static int soc_camera_try_fmt_vid_cap(struct file *file, void *priv,
 		return -EINVAL;
 
 	/* limit format to hardware capabilities */
-	return soc_camera_try_fmt(icd, f);
+	return soc_camera_try_fmt(icd, f, SOCAM_TARGET_PIPELINE);
 }
 
 static int soc_camera_enum_input(struct file *file, void *priv,
@@ -472,22 +473,24 @@ static void soc_camera_free_user_formats(struct soc_camera_device *icd)
 }
 
 /* Called with .vb_lock held, or from the first open(2), see comment there */
-static int soc_camera_set_fmt(struct soc_camera_device *icd,
-			      struct v4l2_format *f)
+int soc_camera_set_fmt(struct soc_camera_device *icd, struct v4l2_format *f,
+		       enum soc_camera_target target)
 {
+	struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
 	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
 	struct v4l2_pix_format *pix = &f->fmt.pix;
+	struct v4l2_mbus_framefmt mf;
 	int ret;
 
 	dev_dbg(icd->pdev, "S_FMT(%c%c%c%c, %ux%u)\n",
 		pixfmtstr(pix->pixelformat), pix->width, pix->height);
 
-	/* We always call try_fmt() before set_fmt() or set_crop() */
-	ret = soc_camera_try_fmt(icd, f);
+	/* We always call try_fmt() before set_fmt() */
+	ret = soc_camera_try_fmt(icd, f, target);
 	if (ret < 0)
 		return ret;
 
-	ret = ici->ops->set_fmt(icd, f);
+	ret = ici->ops->set_fmt(icd, f, target);
 	if (ret < 0) {
 		return ret;
 	} else if (!icd->current_fmt ||
@@ -497,8 +500,26 @@ static int soc_camera_set_fmt(struct soc_camera_device *icd,
 		return -EINVAL;
 	}
 
-	icd->user_width		= pix->width;
-	icd->user_height	= pix->height;
+	switch (target) {
+	case SOCAM_TARGET_PIPELINE:
+		ret = v4l2_subdev_call(sd, video, g_mbus_fmt, &mf);
+		if (!ret) {
+			icd->host_input_width	= mf.width;
+			icd->host_input_height	= mf.height;
+		} else {
+			/* What shall we do with such a client? */
+			icd->host_input_width	= pix->width;
+			icd->host_input_height	= pix->height;
+		}
+		/* fall through */
+	case SOCAM_TARGET_HOST_OUT:
+		icd->user_width		= pix->width;
+		icd->user_height	= pix->height;
+		break;
+	case SOCAM_TARGET_HOST_IN:
+		icd->host_input_width	= pix->width;
+		icd->host_input_height	= pix->height;
+	}
 	icd->bytesperline	= pix->bytesperline;
 	icd->sizeimage		= pix->sizeimage;
 	icd->colorspace		= pix->colorspace;
@@ -515,8 +536,8 @@ static int soc_camera_set_fmt(struct soc_camera_device *icd,
 static int soc_camera_open(struct file *file)
 {
 	struct video_device *vdev = video_devdata(file);
-	struct soc_camera_device *icd = dev_get_drvdata(vdev->parent);
-	struct soc_camera_link *icl = to_soc_camera_link(icd);
+	struct soc_camera_device *icd = video_get_drvdata(vdev);
+	struct soc_camera_link *icl;
 	struct soc_camera_host *ici;
 	int ret;
 
@@ -524,6 +545,7 @@ static int soc_camera_open(struct file *file)
 		/* No device driver attached */
 		return -ENODEV;
 
+	icl = to_soc_camera_link(icd);
 	ici = to_soc_camera_host(icd->parent);
 
 	if (!try_module_get(ici->ops->owner)) {
@@ -573,7 +595,7 @@ static int soc_camera_open(struct file *file)
 		 * apart from someone else calling open() simultaneously, but
 		 * .video_lock is protecting us against it.
 		 */
-		ret = soc_camera_set_fmt(icd, &f);
+		ret = soc_camera_set_fmt(icd, &f, SOCAM_TARGET_PIPELINE);
 		if (ret < 0)
 			goto esfmt;
 
@@ -735,7 +757,7 @@ static int soc_camera_s_fmt_vid_cap(struct file *file, void *priv,
 		return -EBUSY;
 	}
 
-	ret = soc_camera_set_fmt(icd, f);
+	ret = soc_camera_set_fmt(icd, f, SOCAM_TARGET_PIPELINE);
 
 	if (!ret && !icd->streamer)
 		icd->streamer = file;
@@ -1132,6 +1154,17 @@ static int soc_camera_probe(struct soc_camera_device *icd)
 	sd = soc_camera_to_subdev(icd);
 	sd->grp_id = (long)icd;
 
+	if (sd->ops->pad) {
+		/*
+		 * This client driver implements the pad-level API. Build and
+		 * enable a Media Controller infrastructure. If the host driver
+		 * doesn't implement it, it will be emulated.
+		 */
+		ret = soc_camera_mc_install(icd);
+		if (ret < 0)
+			goto emce;
+	}
+
 	if (v4l2_ctrl_add_handler(&icd->ctrl_handler, sd->ctrl_handler))
 		goto ectrl;
 
@@ -1159,8 +1192,10 @@ static int soc_camera_probe(struct soc_camera_device *icd)
 
 	/* Try to improve our guess of a reasonable window format */
 	if (!v4l2_subdev_call(sd, video, g_mbus_fmt, &mf)) {
-		icd->user_width		= mf.width;
-		icd->user_height	= mf.height;
+		icd->host_input_width	= mf.width;
+		icd->host_input_height	= mf.height;
+		icd->user_width		= icd->host_input_width;
+		icd->user_height	= icd->host_input_height;
 		icd->colorspace		= mf.colorspace;
 		icd->field		= mf.field;
 	}
@@ -1180,6 +1215,8 @@ evidstart:
 	soc_camera_free_user_formats(icd);
 eiufmt:
 ectrl:
+	soc_camera_mc_free(icd);
+emce:
 	if (icl->board_info) {
 		soc_camera_free_i2c(icd);
 	} else {
@@ -1218,6 +1255,8 @@ static int soc_camera_remove(struct soc_camera_device *icd)
 		icd->vdev = NULL;
 	}
 
+	soc_camera_mc_free(icd);
+
 	if (icl->board_info) {
 		soc_camera_free_i2c(icd);
 	} else {
@@ -1336,6 +1375,8 @@ int soc_camera_host_register(struct soc_camera_host *ici)
 	if (ret < 0)
 		goto edevreg;
 
+	soc_camera_mc_register(ici);
+
 	list_add_tail(&ici->list, &hosts);
 	mutex_unlock(&list_lock);
 
@@ -1361,9 +1402,11 @@ void soc_camera_host_unregister(struct soc_camera_host *ici)
 		if (icd->iface == ici->nr && to_soc_camera_control(icd))
 			soc_camera_remove(icd);
 
-	mutex_unlock(&list_lock);
+	soc_camera_mc_unregister(ici);
 
 	v4l2_device_unregister(&ici->v4l2_dev);
+
+	mutex_unlock(&list_lock);
 }
 EXPORT_SYMBOL(soc_camera_host_unregister);
 
@@ -1443,7 +1486,6 @@ static int video_dev_create(struct soc_camera_device *icd)
 
 	strlcpy(vdev->name, ici->drv_name, sizeof(vdev->name));
 
-	vdev->parent		= icd->pdev;
 	vdev->current_norm	= V4L2_STD_UNKNOWN;
 	vdev->fops		= &soc_camera_fops;
 	vdev->ioctl_ops		= &soc_camera_ioctl_ops;
@@ -1451,6 +1493,8 @@ static int video_dev_create(struct soc_camera_device *icd)
 	vdev->tvnorms		= V4L2_STD_UNKNOWN;
 	vdev->ctrl_handler	= &icd->ctrl_handler;
 	vdev->lock		= &icd->video_lock;
+	vdev->v4l2_dev		= &ici->v4l2_dev;
+	video_set_drvdata(vdev, icd);
 
 	icd->vdev = vdev;
 
diff --git a/include/media/soc_camera.h b/include/media/soc_camera.h
index d60bad4..0a21ff1 100644
--- a/include/media/soc_camera.h
+++ b/include/media/soc_camera.h
@@ -54,6 +54,8 @@ struct soc_camera_device {
 		struct videobuf_queue vb_vidq;
 		struct vb2_queue vb2_vidq;
 	};
+	unsigned int host_input_width;
+	unsigned int host_input_height;
 };
 
 struct soc_camera_host {
@@ -63,6 +65,18 @@ struct soc_camera_host {
 	void *priv;
 	const char *drv_name;
 	struct soc_camera_host_ops *ops;
+#if defined(CONFIG_MEDIA_CONTROLLER)
+	struct media_device mdev;
+	struct v4l2_subdev bus_sd;
+	struct media_pad bus_pads[2];
+	struct media_pad vdev_pads[1];
+#endif
+};
+
+enum soc_camera_target {
+	SOCAM_TARGET_PIPELINE,
+	SOCAM_TARGET_HOST_IN,
+	SOCAM_TARGET_HOST_OUT,
 };
 
 struct soc_camera_host_ops {
@@ -86,8 +100,10 @@ struct soc_camera_host_ops {
 	 * to change the output sizes
 	 */
 	int (*set_livecrop)(struct soc_camera_device *, struct v4l2_crop *);
-	int (*set_fmt)(struct soc_camera_device *, struct v4l2_format *);
-	int (*try_fmt)(struct soc_camera_device *, struct v4l2_format *);
+	int (*set_fmt)(struct soc_camera_device *, struct v4l2_format *,
+		       enum soc_camera_target);
+	int (*try_fmt)(struct soc_camera_device *, struct v4l2_format *,
+		       enum soc_camera_target);
 	void (*init_videobuf)(struct videobuf_queue *,
 			      struct soc_camera_device *);
 	int (*init_videobuf2)(struct vb2_queue *,
@@ -173,6 +189,11 @@ static inline struct v4l2_subdev *soc_camera_to_subdev(
 int soc_camera_host_register(struct soc_camera_host *ici);
 void soc_camera_host_unregister(struct soc_camera_host *ici);
 
+int soc_camera_try_fmt(struct soc_camera_device *icd, struct v4l2_format *f,
+		       enum soc_camera_target target);
+int soc_camera_set_fmt(struct soc_camera_device *icd, struct v4l2_format *f,
+		       enum soc_camera_target target);
+
 const struct soc_camera_format_xlate *soc_camera_xlate_by_fourcc(
 	const struct soc_camera_device *icd, u32 fourcc);
 
diff --git a/include/media/soc_entity.h b/include/media/soc_entity.h
new file mode 100644
index 0000000..e461f5e
--- /dev/null
+++ b/include/media/soc_entity.h
@@ -0,0 +1,19 @@
+/*
+ * soc-camera Media Controller wrapper
+ *
+ * Copyright (C) 2011, Guennadi Liakhovetski <g.liakhovetski@gmx.de>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef SOC_ENTITY_H
+#define SOC_ENTITY_H
+
+#define soc_camera_mc_install(x) 0
+#define soc_camera_mc_free(x) do {} while (0)
+#define soc_camera_mc_register(x) do {} while (0)
+#define soc_camera_mc_unregister(x) do {} while (0)
+
+#endif
-- 
1.7.2.5

