Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mACKVv1v022653
	for <video4linux-list@redhat.com>; Wed, 12 Nov 2008 15:31:57 -0500
Received: from smtp4-g19.free.fr (smtp4-g19.free.fr [212.27.42.30])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mACKVl1X027209
	for <video4linux-list@redhat.com>; Wed, 12 Nov 2008 15:31:47 -0500
From: Robert Jarzmik <robert.jarzmik@free.fr>
To: g.liakhovetski@gmx.de, video4linux-list@redhat.com
Date: Wed, 12 Nov 2008 21:29:40 +0100
Message-Id: <1226521783-19806-10-git-send-email-robert.jarzmik@free.fr>
In-Reply-To: <1226521783-19806-9-git-send-email-robert.jarzmik@free.fr>
References: <1226521783-19806-1-git-send-email-robert.jarzmik@free.fr>
	<1226521783-19806-2-git-send-email-robert.jarzmik@free.fr>
	<1226521783-19806-3-git-send-email-robert.jarzmik@free.fr>
	<1226521783-19806-4-git-send-email-robert.jarzmik@free.fr>
	<1226521783-19806-5-git-send-email-robert.jarzmik@free.fr>
	<1226521783-19806-6-git-send-email-robert.jarzmik@free.fr>
	<1226521783-19806-7-git-send-email-robert.jarzmik@free.fr>
	<1226521783-19806-8-git-send-email-robert.jarzmik@free.fr>
	<1226521783-19806-9-git-send-email-robert.jarzmik@free.fr>
Cc: 
Subject: [PATCH 09/13] pxa_camera: use the translation framework
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

Use the newly created translation framework for pxa camera
host.

Signed-off-by: Robert Jarzmik <robert.jarzmik@free.fr>
---
 drivers/media/video/pxa_camera.c |   89 ++++++++++++++++++++++----------------
 1 files changed, 52 insertions(+), 37 deletions(-)

diff --git a/drivers/media/video/pxa_camera.c b/drivers/media/video/pxa_camera.c
index 56aeb07..3e7ce6f 100644
--- a/drivers/media/video/pxa_camera.c
+++ b/drivers/media/video/pxa_camera.c
@@ -27,6 +27,7 @@
 #include <linux/platform_device.h>
 #include <linux/mutex.h>
 #include <linux/clk.h>
+#include <linux/vmalloc.h>
 
 #include <media/v4l2-common.h>
 #include <media/v4l2-dev.h>
@@ -693,10 +694,17 @@ static int pxa_camera_add_device(struct soc_camera_device *icd)
 
 	pxa_camera_activate(pcdev);
 	ret = icd->ops->init(icd);
+	if (ret < 0)
+		goto einit;
+
+	pcdev->icd = icd;
 
-	if (!ret)
-		pcdev->icd = icd;
+	mutex_unlock(&camera_lock);
+
+	return 0;
 
+einit:
+	pxa_camera_deactivate(pcdev);
 ebusy:
 	mutex_unlock(&camera_lock);
 
@@ -713,6 +721,8 @@ static void pxa_camera_remove_device(struct soc_camera_device *icd)
 	dev_info(&icd->dev, "PXA Camera driver detached from camera %d\n",
 		 icd->devnum);
 
+	mutex_lock(&camera_lock);
+
 	/* disable capture, disable interrupts */
 	CICR0 = 0x3ff;
 
@@ -725,7 +735,12 @@ static void pxa_camera_remove_device(struct soc_camera_device *icd)
 
 	pxa_camera_deactivate(pcdev);
 
+	vfree(icd->host_priv);
+	icd->host_priv = NULL;
+
 	pcdev->icd = NULL;
+
+	mutex_unlock(&camera_lock);
 }
 
 static int test_platform_param(struct pxa_camera_dev *pcdev,
@@ -898,23 +913,30 @@ static int pxa_camera_try_bus_param(struct soc_camera_device *icd, __u32 pixfmt)
 	return soc_camera_bus_param_compatible(camera_flags, bus_flags) ? 0 : -EINVAL;
 }
 
+static struct soc_camera_data_format *
+pxa_camera_find_sensor_fmt(struct soc_camera_device *icd, __u32 pixfmt)
+{
+	int i;
+
+	if (pixfmt) {
+		for (i = 0; i < icd->num_available_fmts; i++)
+			if (icd->available_fmts[i].host_fmt->fourcc == pixfmt)
+				return icd->available_fmts[i].sensor_fmt;
+	}
+	return NULL;
+}
+
 static int pxa_camera_set_fmt(struct soc_camera_device *icd,
 			      __u32 pixfmt, struct v4l2_rect *rect)
 {
-	const struct soc_camera_data_format *cam_fmt;
+	const struct soc_camera_data_format *cam_fmt = NULL;
 	int ret;
 
-	/*
-	 * TODO: find a suitable supported by the SoC output format, check
-	 * whether the sensor supports one of acceptable input formats.
-	 */
-	if (pixfmt) {
-		cam_fmt = soc_camera_format_by_fourcc(icd, pixfmt);
-		if (!cam_fmt)
-			return -EINVAL;
-	}
+	cam_fmt = pxa_camera_find_sensor_fmt(icd, pixfmt);
+	if (!cam_fmt)
+		return -EINVAL;
 
-	ret = icd->ops->set_fmt(icd, pixfmt, rect);
+	ret = icd->ops->set_fmt(icd, cam_fmt->fourcc, rect);
 	if (pixfmt && !ret)
 		icd->current_fmt = cam_fmt;
 
@@ -924,18 +946,16 @@ static int pxa_camera_set_fmt(struct soc_camera_device *icd,
 static int pxa_camera_try_fmt(struct soc_camera_device *icd,
 			      struct v4l2_format *f)
 {
-	const struct soc_camera_data_format *cam_fmt;
+	const struct soc_camera_data_format *cam_fmt = NULL;
 	struct v4l2_pix_format *pix = &f->fmt.pix;
-	int ret = pxa_camera_try_bus_param(icd, pix->pixelformat);
+	__u32 pixfmt = pix->pixelformat;
+	int ret = pxa_camera_try_bus_param(icd, pixfmt);
 
 	if (ret < 0)
 		return ret;
 
-	/*
-	 * TODO: find a suitable supported by the SoC output format, check
-	 * whether the sensor supports one of acceptable input formats.
-	 */
-	cam_fmt = soc_camera_format_by_fourcc(icd, pix->pixelformat);
+	cam_fmt = pxa_camera_find_sensor_fmt(icd, pixfmt);
+
 	if (!cam_fmt)
 		return -EINVAL;
 
@@ -958,22 +978,6 @@ static int pxa_camera_try_fmt(struct soc_camera_device *icd,
 	return icd->ops->try_fmt(icd, f);
 }
 
-static int pxa_camera_enum_fmt(struct soc_camera_device *icd,
-			       struct v4l2_fmtdesc *f)
-{
-	const struct soc_camera_data_format *format;
-
-	if (f->index >= icd->num_formats)
-		return -EINVAL;
-
-	format = &icd->formats[f->index];
-
-	strlcpy(f->description, format->name, sizeof(f->description));
-	f->pixelformat = format->fourcc;
-
-	return 0;
-}
-
 static int pxa_camera_reqbufs(struct soc_camera_file *icf,
 			      struct v4l2_requestbuffers *p)
 {
@@ -1079,7 +1083,6 @@ static struct soc_camera_host_ops pxa_soc_camera_host_ops = {
 	.resume		= pxa_camera_resume,
 	.set_fmt	= pxa_camera_set_fmt,
 	.try_fmt	= pxa_camera_try_fmt,
-	.enum_fmt	= pxa_camera_enum_fmt,
 	.init_videobuf	= pxa_camera_init_videobuf,
 	.reqbufs	= pxa_camera_reqbufs,
 	.poll		= pxa_camera_poll,
@@ -1087,10 +1090,22 @@ static struct soc_camera_host_ops pxa_soc_camera_host_ops = {
 	.set_bus_param	= pxa_camera_set_bus_param,
 };
 
+static struct soc_camera_format_translate pxa_pixfmt_translations[] = {
+	{ JPG_FMT("CbYCrY 16 bit", 16, V4L2_PIX_FMT_UYVY), V4L2_PIX_FMT_UYVY },
+	{ JPG_FMT("CrYCbY 16 bit", 16, V4L2_PIX_FMT_VYUY), V4L2_PIX_FMT_VYUY },
+	{ JPG_FMT("YCbYCr 16 bit", 16, V4L2_PIX_FMT_YUYV), V4L2_PIX_FMT_YUYV },
+	{ JPG_FMT("YCrYCb 16 bit", 16, V4L2_PIX_FMT_YVYU), V4L2_PIX_FMT_YVYU },
+	{ JPG_FMT("YUV planar", 16, V4L2_PIX_FMT_YUV422P), V4L2_PIX_FMT_UYVY },
+	{ RGB_FMT("RGB 555", 16, V4L2_PIX_FMT_RGB555), V4L2_PIX_FMT_RGB555 },
+	{ RGB_FMT("RGB 565", 16, V4L2_PIX_FMT_RGB565), V4L2_PIX_FMT_RGB565 },
+	LAST_FMT_TRANSLATION
+};
+
 /* Should be allocated dynamically too, but we have only one. */
 static struct soc_camera_host pxa_soc_camera_host = {
 	.drv_name		= PXA_CAM_DRV_NAME,
 	.ops			= &pxa_soc_camera_host_ops,
+	.translate_fmt		= pxa_pixfmt_translations,
 };
 
 static int pxa_camera_probe(struct platform_device *pdev)
-- 
1.5.6.5

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
