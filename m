Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mACKVmv3022466
	for <video4linux-list@redhat.com>; Wed, 12 Nov 2008 15:31:48 -0500
Received: from smtp4-g19.free.fr (smtp4-g19.free.fr [212.27.42.30])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mACKVZth027066
	for <video4linux-list@redhat.com>; Wed, 12 Nov 2008 15:31:36 -0500
From: Robert Jarzmik <robert.jarzmik@free.fr>
To: g.liakhovetski@gmx.de, video4linux-list@redhat.com
Date: Wed, 12 Nov 2008 21:29:34 +0100
Message-Id: <1226521783-19806-4-git-send-email-robert.jarzmik@free.fr>
In-Reply-To: <1226521783-19806-3-git-send-email-robert.jarzmik@free.fr>
References: <1226521783-19806-1-git-send-email-robert.jarzmik@free.fr>
	<1226521783-19806-2-git-send-email-robert.jarzmik@free.fr>
	<1226521783-19806-3-git-send-email-robert.jarzmik@free.fr>
Cc: 
Subject: [PATCH 03/13] soc-camera: let camera host drivers decide upon pixel
	format
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>

Pixel format requested by the user is not necessarily the same, as what
a sensor driver provides. There are situations, when a camera host driver
provides the required format, but requires a different format from the
sensor. Further, the list of formats, supported by sensors is pretty static
and can be pretty good described with a constant list of structures. Whereas
decisions, made by camera host drivers to support requested formats can be
quite complex, therefore it is better to let the host driver do the work.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---
 drivers/media/video/pxa_camera.c           |   32 +++++++++++++++-
 drivers/media/video/sh_mobile_ceu_camera.c |   32 +++++++++++++++-
 drivers/media/video/soc_camera.c           |   58 ++++++++++-----------------
 include/media/soc_camera.h                 |    3 +
 4 files changed, 87 insertions(+), 38 deletions(-)

diff --git a/drivers/media/video/pxa_camera.c b/drivers/media/video/pxa_camera.c
index 2a811f8..a375872 100644
--- a/drivers/media/video/pxa_camera.c
+++ b/drivers/media/video/pxa_camera.c
@@ -907,17 +907,43 @@ static int pxa_camera_try_bus_param(struct soc_camera_device *icd, __u32 pixfmt)
 static int pxa_camera_set_fmt_cap(struct soc_camera_device *icd,
 				  __u32 pixfmt, struct v4l2_rect *rect)
 {
-	return icd->ops->set_fmt_cap(icd, pixfmt, rect);
+	const struct soc_camera_data_format *cam_fmt;
+	int ret;
+
+	/*
+	 * TODO: find a suitable supported by the SoC output format, check
+	 * whether the sensor supports one of acceptable input formats.
+	 */
+	if (pixfmt) {
+		cam_fmt = soc_camera_format_by_fourcc(icd, pixfmt);
+		if (!cam_fmt)
+			return -EINVAL;
+	}
+
+	ret = icd->ops->set_fmt_cap(icd, pixfmt, rect);
+	if (pixfmt && !ret)
+		icd->current_fmt = cam_fmt;
+
+	return ret;
 }
 
 static int pxa_camera_try_fmt_cap(struct soc_camera_device *icd,
 				  struct v4l2_format *f)
 {
+	const struct soc_camera_data_format *cam_fmt;
 	int ret = pxa_camera_try_bus_param(icd, f->fmt.pix.pixelformat);
 
 	if (ret < 0)
 		return ret;
 
+	/*
+	 * TODO: find a suitable supported by the SoC output format, check
+	 * whether the sensor supports one of acceptable input formats.
+	 */
+	cam_fmt = soc_camera_format_by_fourcc(icd, f->fmt.pix.pixelformat);
+	if (!cam_fmt)
+		return -EINVAL;
+
 	/* limit to pxa hardware capabilities */
 	if (f->fmt.pix.height < 32)
 		f->fmt.pix.height = 32;
@@ -929,6 +955,10 @@ static int pxa_camera_try_fmt_cap(struct soc_camera_device *icd,
 		f->fmt.pix.width = 2048;
 	f->fmt.pix.width &= ~0x01;
 
+	f->fmt.pix.bytesperline = f->fmt.pix.width *
+		DIV_ROUND_UP(cam_fmt->depth, 8);
+	f->fmt.pix.sizeimage = f->fmt.pix.height * f->fmt.pix.bytesperline;
+
 	/* limit to sensor capabilities */
 	return icd->ops->try_fmt_cap(icd, f);
 }
diff --git a/drivers/media/video/sh_mobile_ceu_camera.c b/drivers/media/video/sh_mobile_ceu_camera.c
index a6b29a4..1bacfc7 100644
--- a/drivers/media/video/sh_mobile_ceu_camera.c
+++ b/drivers/media/video/sh_mobile_ceu_camera.c
@@ -447,17 +447,43 @@ static int sh_mobile_ceu_try_bus_param(struct soc_camera_device *icd,
 static int sh_mobile_ceu_set_fmt_cap(struct soc_camera_device *icd,
 				     __u32 pixfmt, struct v4l2_rect *rect)
 {
-	return icd->ops->set_fmt_cap(icd, pixfmt, rect);
+	const struct soc_camera_data_format *cam_fmt;
+	int ret;
+
+	/*
+	 * TODO: find a suitable supported by the SoC output format, check
+	 * whether the sensor supports one of acceptable input formats.
+	 */
+	if (pixfmt) {
+		cam_fmt = soc_camera_format_by_fourcc(icd, pixfmt);
+		if (!cam_fmt)
+			return -EINVAL;
+	}
+
+	ret = icd->ops->set_fmt_cap(icd, pixfmt, rect);
+	if (pixfmt && !ret)
+		icd->current_fmt = cam_fmt;
+
+	return ret;
 }
 
 static int sh_mobile_ceu_try_fmt_cap(struct soc_camera_device *icd,
 				     struct v4l2_format *f)
 {
+	const struct soc_camera_data_format *cam_fmt;
 	int ret = sh_mobile_ceu_try_bus_param(icd, f->fmt.pix.pixelformat);
 
 	if (ret < 0)
 		return ret;
 
+	/*
+	 * TODO: find a suitable supported by the SoC output format, check
+	 * whether the sensor supports one of acceptable input formats.
+	 */
+	cam_fmt = soc_camera_format_by_fourcc(icd, f->fmt.pix.pixelformat);
+	if (!cam_fmt)
+		return -EINVAL;
+
 	/* FIXME: calculate using depth and bus width */
 
 	if (f->fmt.pix.height < 4)
@@ -471,6 +497,10 @@ static int sh_mobile_ceu_try_fmt_cap(struct soc_camera_device *icd,
 	f->fmt.pix.width &= ~0x01;
 	f->fmt.pix.height &= ~0x03;
 
+	f->fmt.pix.bytesperline = f->fmt.pix.width *
+		DIV_ROUND_UP(cam_fmt->depth, 8);
+	f->fmt.pix.sizeimage = f->fmt.pix.height * f->fmt.pix.bytesperline;
+
 	/* limit to sensor capabilities */
 	return icd->ops->try_fmt_cap(icd, f);
 }
diff --git a/drivers/media/video/soc_camera.c b/drivers/media/video/soc_camera.c
index 2d1f474..afadb33 100644
--- a/drivers/media/video/soc_camera.c
+++ b/drivers/media/video/soc_camera.c
@@ -35,7 +35,7 @@ static LIST_HEAD(devices);
 static DEFINE_MUTEX(list_lock);
 static DEFINE_MUTEX(video_lock);
 
-const static struct soc_camera_data_format *format_by_fourcc(
+const struct soc_camera_data_format *soc_camera_format_by_fourcc(
 	struct soc_camera_device *icd, unsigned int fourcc)
 {
 	unsigned int i;
@@ -45,6 +45,7 @@ const static struct soc_camera_data_format *format_by_fourcc(
 			return icd->formats + i;
 	return NULL;
 }
+EXPORT_SYMBOL(soc_camera_format_by_fourcc);
 
 static int soc_camera_try_fmt_vid_cap(struct file *file, void *priv,
 				      struct v4l2_format *f)
@@ -54,25 +55,19 @@ static int soc_camera_try_fmt_vid_cap(struct file *file, void *priv,
 	struct soc_camera_host *ici =
 		to_soc_camera_host(icd->dev.parent);
 	enum v4l2_field field;
-	const struct soc_camera_data_format *fmt;
 	int ret;
 
 	WARN_ON(priv != file->private_data);
 
-	fmt = format_by_fourcc(icd, f->fmt.pix.pixelformat);
-	if (!fmt) {
-		dev_dbg(&icd->dev, "invalid format 0x%08x\n",
-			f->fmt.pix.pixelformat);
-		return -EINVAL;
-	}
-
-	dev_dbg(&icd->dev, "fmt: 0x%08x\n", fmt->fourcc);
-
+	/*
+	 * TODO: this might also have to migrate to host-drivers, if anyone
+	 * wishes to support other fields
+	 */
 	field = f->fmt.pix.field;
 
 	if (field == V4L2_FIELD_ANY) {
-		field = V4L2_FIELD_NONE;
-	} else if (V4L2_FIELD_NONE != field) {
+		f->fmt.pix.field = V4L2_FIELD_NONE;
+	} else if (field != V4L2_FIELD_NONE) {
 		dev_err(&icd->dev, "Field type invalid.\n");
 		return -EINVAL;
 	}
@@ -80,13 +75,6 @@ static int soc_camera_try_fmt_vid_cap(struct file *file, void *priv,
 	/* limit format to hardware capabilities */
 	ret = ici->ops->try_fmt_cap(icd, f);
 
-	/* calculate missing fields */
-	f->fmt.pix.field = field;
-	f->fmt.pix.bytesperline =
-		(f->fmt.pix.width * fmt->depth) >> 3;
-	f->fmt.pix.sizeimage =
-		f->fmt.pix.height * f->fmt.pix.bytesperline;
-
 	return ret;
 }
 
@@ -325,18 +313,10 @@ static int soc_camera_s_fmt_vid_cap(struct file *file, void *priv,
 		to_soc_camera_host(icd->dev.parent);
 	int ret;
 	struct v4l2_rect rect;
-	const static struct soc_camera_data_format *data_fmt;
 
 	WARN_ON(priv != file->private_data);
 
-	data_fmt = format_by_fourcc(icd, f->fmt.pix.pixelformat);
-	if (!data_fmt)
-		return -EINVAL;
-
-	/* buswidth may be further adjusted by the ici */
-	icd->buswidth = data_fmt->depth;
-
-	ret = soc_camera_try_fmt_vid_cap(file, icf, f);
+	ret = soc_camera_try_fmt_vid_cap(file, priv, f);
 	if (ret < 0)
 		return ret;
 
@@ -345,14 +325,21 @@ static int soc_camera_s_fmt_vid_cap(struct file *file, void *priv,
 	rect.width	= f->fmt.pix.width;
 	rect.height	= f->fmt.pix.height;
 	ret = ici->ops->set_fmt_cap(icd, f->fmt.pix.pixelformat, &rect);
-	if (ret < 0)
+	if (ret < 0) {
 		return ret;
+	} else if (!icd->current_fmt ||
+		   icd->current_fmt->fourcc != f->fmt.pix.pixelformat) {
+		dev_err(&ici->dev, "Host driver hasn't set up current "
+			"format correctly!\n");
+		return -EINVAL;
+	}
 
-	icd->current_fmt	= data_fmt;
+	/* buswidth may be further adjusted by the ici */
+	icd->buswidth		= icd->current_fmt->depth;
 	icd->width		= rect.width;
 	icd->height		= rect.height;
 	icf->vb_vidq.field	= f->fmt.pix.field;
-	if (V4L2_BUF_TYPE_VIDEO_CAPTURE != f->type)
+	if (f->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
 		dev_warn(&icd->dev, "Attention! Wrong buf-type %d\n",
 			 f->type);
 
@@ -394,10 +381,9 @@ static int soc_camera_g_fmt_vid_cap(struct file *file, void *priv,
 	f->fmt.pix.height	= icd->height;
 	f->fmt.pix.field	= icf->vb_vidq.field;
 	f->fmt.pix.pixelformat	= icd->current_fmt->fourcc;
-	f->fmt.pix.bytesperline	=
-		(f->fmt.pix.width * icd->current_fmt->depth) >> 3;
-	f->fmt.pix.sizeimage	=
-		f->fmt.pix.height * f->fmt.pix.bytesperline;
+	f->fmt.pix.bytesperline	= f->fmt.pix.width *
+		DIV_ROUND_UP(icd->current_fmt->depth, 8);
+	f->fmt.pix.sizeimage	= f->fmt.pix.height * f->fmt.pix.bytesperline;
 	dev_dbg(&icd->dev, "current_fmt->fourcc: 0x%08x\n",
 		icd->current_fmt->fourcc);
 	return 0;
diff --git a/include/media/soc_camera.h b/include/media/soc_camera.h
index 5eb9540..c9b2b7f 100644
--- a/include/media/soc_camera.h
+++ b/include/media/soc_camera.h
@@ -105,6 +105,9 @@ extern void soc_camera_device_unregister(struct soc_camera_device *icd);
 extern int soc_camera_video_start(struct soc_camera_device *icd);
 extern void soc_camera_video_stop(struct soc_camera_device *icd);
 
+extern const struct soc_camera_data_format *soc_camera_format_by_fourcc(
+	struct soc_camera_device *icd, unsigned int fourcc);
+
 struct soc_camera_data_format {
 	char *name;
 	unsigned int depth;
-- 
1.5.6.5

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
