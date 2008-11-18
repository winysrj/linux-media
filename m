Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mAIJR0IM024764
	for <video4linux-list@redhat.com>; Tue, 18 Nov 2008 14:27:01 -0500
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id mAIJQXv0026327
	for <video4linux-list@redhat.com>; Tue, 18 Nov 2008 14:26:38 -0500
Date: Tue, 18 Nov 2008 20:25:56 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: video4linux-list@redhat.com
In-Reply-To: <Pine.LNX.4.64.0811181945410.8628@axis700.grange>
Message-ID: <Pine.LNX.4.64.0811182010460.8628@axis700.grange>
References: <Pine.LNX.4.64.0811181945410.8628@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: 
Subject: [PATCH 2/2 v3] pxa-camera: pixel format negotiation
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

Use the new format-negotiation infrastructure, support all four YUV422 
packed and the planar formats.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>

---

diff --git a/drivers/media/video/pxa_camera.c b/drivers/media/video/pxa_camera.c
index 37afdfa..1bcdb5d 100644
--- a/drivers/media/video/pxa_camera.c
+++ b/drivers/media/video/pxa_camera.c
@@ -765,6 +765,9 @@ static int test_platform_param(struct pxa_camera_dev *pcdev,
 		if (!(pcdev->platform_flags & PXA_CAMERA_DATAWIDTH_8))
 			return -EINVAL;
 		*flags |= SOCAM_DATAWIDTH_8;
+		break;
+	default:
+		return -EINVAL;
 	}
 
 	return 0;
@@ -823,12 +826,10 @@ static int pxa_camera_set_bus_param(struct soc_camera_device *icd, __u32 pixfmt)
 	 * We fix bit-per-pixel equal to data-width... */
 	switch (common_flags & SOCAM_DATAWIDTH_MASK) {
 	case SOCAM_DATAWIDTH_10:
-		icd->buswidth = 10;
 		dw = 4;
 		bpp = 0x40;
 		break;
 	case SOCAM_DATAWIDTH_9:
-		icd->buswidth = 9;
 		dw = 3;
 		bpp = 0x20;
 		break;
@@ -836,7 +837,6 @@ static int pxa_camera_set_bus_param(struct soc_camera_device *icd, __u32 pixfmt)
 		/* Actually it can only be 8 now,
 		 * default is just to silence compiler warnings */
 	case SOCAM_DATAWIDTH_8:
-		icd->buswidth = 8;
 		dw = 2;
 		bpp = 0;
 	}
@@ -862,7 +862,17 @@ static int pxa_camera_set_bus_param(struct soc_camera_device *icd, __u32 pixfmt)
 	case V4L2_PIX_FMT_YUV422P:
 		pcdev->channels = 3;
 		cicr1 |= CICR1_YCBCR_F;
+		/*
+		 * Normally, pxa bus wants as input UYVY format. We allow all
+		 * reorderings of the YUV422 format, as no processing is done,
+		 * and the YUV stream is just passed through without any
+		 * transformation. Note that UYVY is the only format that
+		 * should be used if pxa framebuffer Overlay2 is used.
+		 */
+	case V4L2_PIX_FMT_UYVY:
+	case V4L2_PIX_FMT_VYUY:
 	case V4L2_PIX_FMT_YUYV:
+	case V4L2_PIX_FMT_YVYU:
 		cicr1 |= CICR1_COLOR_SP_VAL(2);
 		break;
 	case V4L2_PIX_FMT_RGB555:
@@ -888,13 +898,14 @@ static int pxa_camera_set_bus_param(struct soc_camera_device *icd, __u32 pixfmt)
 	return 0;
 }
 
-static int pxa_camera_try_bus_param(struct soc_camera_device *icd, __u32 pixfmt)
+static int pxa_camera_try_bus_param(struct soc_camera_device *icd,
+				    unsigned char buswidth)
 {
 	struct soc_camera_host *ici =
 		to_soc_camera_host(icd->dev.parent);
 	struct pxa_camera_dev *pcdev = ici->priv;
 	unsigned long bus_flags, camera_flags;
-	int ret = test_platform_param(pcdev, icd->buswidth, &bus_flags);
+	int ret = test_platform_param(pcdev, buswidth, &bus_flags);
 
 	if (ret < 0)
 		return ret;
@@ -904,25 +915,133 @@ static int pxa_camera_try_bus_param(struct soc_camera_device *icd, __u32 pixfmt)
 	return soc_camera_bus_param_compatible(camera_flags, bus_flags) ? 0 : -EINVAL;
 }
 
+static const struct soc_camera_data_format pxa_camera_formats[] = {
+	{
+		.name		= "Planar YUV422 16 bit",
+		.depth		= 16,
+		.fourcc		= V4L2_PIX_FMT_YUV422P,
+		.colorspace	= V4L2_COLORSPACE_JPEG,
+	},
+};
+
+static bool depth_supported(struct soc_camera_device *icd, int depth)
+{
+	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
+	struct pxa_camera_dev *pcdev = ici->priv;
+
+	switch (depth) {
+	case 8:
+		return !!(pcdev->platform_flags & PXA_CAMERA_DATAWIDTH_8);
+	case 9:
+		return !!(pcdev->platform_flags & PXA_CAMERA_DATAWIDTH_9);
+	case 10:
+		return !!(pcdev->platform_flags & PXA_CAMERA_DATAWIDTH_10);
+	}
+	return false;
+}
+
+static int pxa_camera_get_formats(struct soc_camera_device *icd, int idx,
+				  const struct soc_camera_data_format **fmt)
+{
+	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
+	struct pxa_camera_dev *pcdev = ici->priv;
+	int formats = 0;
+
+	switch (icd->formats[idx].fourcc) {
+	case V4L2_PIX_FMT_UYVY:
+		formats++;
+		if (fmt && (pcdev->platform_flags & PXA_CAMERA_DATAWIDTH_8)) {
+			*fmt++ = &pxa_camera_formats[0];
+			dev_dbg(&ici->dev, "Providing format %s using %s\n",
+				pxa_camera_formats[0].name,
+				icd->formats[idx].name);
+		}
+	case V4L2_PIX_FMT_VYUY:
+	case V4L2_PIX_FMT_YUYV:
+	case V4L2_PIX_FMT_YVYU:
+	case V4L2_PIX_FMT_RGB565:
+	case V4L2_PIX_FMT_RGB555:
+		formats++;
+		if (fmt && (pcdev->platform_flags & PXA_CAMERA_DATAWIDTH_8)) {
+			*fmt++ = &icd->formats[idx];
+			dev_dbg(&ici->dev, "Providing format %s packed\n",
+				icd->formats[idx].name);
+		}
+		break;
+	default:
+		/* Generic pass-through */
+		if (depth_supported(icd, icd->formats[idx].depth)) {
+			formats++;
+			if (fmt) {
+				*fmt++ = &icd->formats[idx];
+				dev_dbg(&ici->dev,
+					"Providing format %s in pass-through mode\n",
+					icd->formats[idx].name);
+			}
+		}
+	}
+
+	return formats;
+}
+
 static int pxa_camera_set_fmt(struct soc_camera_device *icd,
 			      __u32 pixfmt, struct v4l2_rect *rect)
 {
-	const struct soc_camera_data_format *cam_fmt;
-	int ret;
+	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
+	struct pxa_camera_dev *pcdev = ici->priv;
+	const struct soc_camera_data_format *host_fmt = NULL;
+	int ret, buswidth;
 
-	/*
-	 * TODO: find a suitable supported by the SoC output format, check
-	 * whether the sensor supports one of acceptable input formats.
-	 */
-	if (pixfmt) {
-		cam_fmt = soc_camera_format_by_fourcc(icd, pixfmt);
-		if (!cam_fmt)
+	switch (pixfmt) {
+	case V4L2_PIX_FMT_YUV422P:
+		host_fmt = &pxa_camera_formats[0];
+		pixfmt = V4L2_PIX_FMT_UYVY;
+	case V4L2_PIX_FMT_UYVY:
+	case V4L2_PIX_FMT_VYUY:
+	case V4L2_PIX_FMT_YUYV:
+	case V4L2_PIX_FMT_YVYU:
+	case V4L2_PIX_FMT_RGB565:
+	case V4L2_PIX_FMT_RGB555:
+		if (!(pcdev->platform_flags & PXA_CAMERA_DATAWIDTH_8)) {
+			dev_warn(&ici->dev,
+				 "8 bit bus unsupported, but required for format %x\n",
+				 pixfmt);
+			return -EINVAL;
+		}
+
+		if (!host_fmt)
+			host_fmt = soc_camera_format_by_fourcc(icd, pixfmt);
+
+		if (!host_fmt) {
+			dev_warn(&ici->dev, "Format %x not found\n", pixfmt);
 			return -EINVAL;
+		}
+		buswidth = 8;
+	case 0:				/* Only geometry change */
+		ret = icd->ops->set_fmt(icd, pixfmt, rect);
+		break;
+	default:
+		/* Generic pass-through */
+		host_fmt = soc_camera_format_by_fourcc(icd, pixfmt);
+		if (!host_fmt || !depth_supported(icd, host_fmt->depth)) {
+			dev_warn(&ici->dev,
+				 "Format %x unsupported in pass-through mode\n",
+				 pixfmt);
+			return -EINVAL;
+		}
+
+		buswidth = host_fmt->depth;
+		ret = icd->ops->set_fmt(icd, pixfmt, rect);
 	}
 
-	ret = icd->ops->set_fmt(icd, pixfmt, rect);
-	if (pixfmt && !ret)
-		icd->current_fmt = cam_fmt;
+	if (ret < 0)
+		dev_warn(&ici->dev, "Failed to configure for format %x\n",
+			 pixfmt);
+
+	if (pixfmt && !ret) {
+		icd->buswidth = buswidth;
+		icd->current_fmt = host_fmt;
+	}
 
 	return ret;
 }
@@ -930,34 +1049,70 @@ static int pxa_camera_set_fmt(struct soc_camera_device *icd,
 static int pxa_camera_try_fmt(struct soc_camera_device *icd,
 			      struct v4l2_format *f)
 {
+	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
+	struct pxa_camera_dev *pcdev = ici->priv;
 	const struct soc_camera_data_format *cam_fmt;
-	int ret = pxa_camera_try_bus_param(icd, f->fmt.pix.pixelformat);
+	struct v4l2_pix_format *pix = &f->fmt.pix;
+	__u32 pixfmt = pix->pixelformat;
+	unsigned char buswidth;
+	int ret;
 
-	if (ret < 0)
-		return ret;
+	switch (pixfmt) {
+	case V4L2_PIX_FMT_YUV422P:
+		pixfmt = V4L2_PIX_FMT_UYVY;
+	case V4L2_PIX_FMT_UYVY:
+	case V4L2_PIX_FMT_VYUY:
+	case V4L2_PIX_FMT_YUYV:
+	case V4L2_PIX_FMT_YVYU:
+	case V4L2_PIX_FMT_RGB565:
+	case V4L2_PIX_FMT_RGB555:
+		if (!(pcdev->platform_flags & PXA_CAMERA_DATAWIDTH_8)) {
+			dev_warn(&ici->dev,
+				 "try-fmt: 8 bit bus unsupported for format %x\n",
+				 pixfmt);
+			return -EINVAL;
+		}
 
-	/*
-	 * TODO: find a suitable supported by the SoC output format, check
-	 * whether the sensor supports one of acceptable input formats.
-	 */
-	cam_fmt = soc_camera_format_by_fourcc(icd, f->fmt.pix.pixelformat);
-	if (!cam_fmt)
-		return -EINVAL;
+		cam_fmt = soc_camera_format_by_fourcc(icd, pixfmt);
+		if (!cam_fmt) {
+			dev_warn(&ici->dev, "try-fmt: format %x not found\n",
+				 pixfmt);
+			return -EINVAL;
+		}
+		buswidth = 8;
+		break;
+	default:
+		/* Generic pass-through */
+		cam_fmt = soc_camera_format_by_fourcc(icd, pixfmt);
+		if (!cam_fmt || !depth_supported(icd, cam_fmt->depth)) {
+			dev_warn(&ici->dev,
+				 "try-fmt: Format %x unsupported in pass-through\n",
+				 pixfmt);
+			return -EINVAL;
+		}
+		buswidth = cam_fmt->depth;
+	}
+
+	ret = pxa_camera_try_bus_param(icd, buswidth);
+
+	if (ret < 0) {
+		dev_warn(&ici->dev, "Incompatible bus parameters!\n");
+		return ret;
+	}
 
 	/* limit to pxa hardware capabilities */
-	if (f->fmt.pix.height < 32)
-		f->fmt.pix.height = 32;
-	if (f->fmt.pix.height > 2048)
-		f->fmt.pix.height = 2048;
-	if (f->fmt.pix.width < 48)
-		f->fmt.pix.width = 48;
-	if (f->fmt.pix.width > 2048)
-		f->fmt.pix.width = 2048;
-	f->fmt.pix.width &= ~0x01;
-
-	f->fmt.pix.bytesperline = f->fmt.pix.width *
-		DIV_ROUND_UP(cam_fmt->depth, 8);
-	f->fmt.pix.sizeimage = f->fmt.pix.height * f->fmt.pix.bytesperline;
+	if (pix->height < 32)
+		pix->height = 32;
+	if (pix->height > 2048)
+		pix->height = 2048;
+	if (pix->width < 48)
+		pix->width = 48;
+	if (pix->width > 2048)
+		pix->width = 2048;
+	pix->width &= ~0x01;
+
+	pix->bytesperline = pix->width * DIV_ROUND_UP(cam_fmt->depth, 8);
+	pix->sizeimage = pix->height * pix->bytesperline;
 
 	/* limit to sensor capabilities */
 	return icd->ops->try_fmt(icd, f);
@@ -1068,6 +1223,7 @@ static struct soc_camera_host_ops pxa_soc_camera_host_ops = {
 	.remove		= pxa_camera_remove_device,
 	.suspend	= pxa_camera_suspend,
 	.resume		= pxa_camera_resume,
+	.get_formats	= pxa_camera_get_formats,
 	.set_fmt	= pxa_camera_set_fmt,
 	.try_fmt	= pxa_camera_try_fmt,
 	.init_videobuf	= pxa_camera_init_videobuf,

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
