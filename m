Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mAOJT9j2021943
	for <video4linux-list@redhat.com>; Mon, 24 Nov 2008 14:29:09 -0500
Received: from smtp4-g19.free.fr (smtp4-g19.free.fr [212.27.42.30])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mAOJSu1R024779
	for <video4linux-list@redhat.com>; Mon, 24 Nov 2008 14:28:56 -0500
From: Robert Jarzmik <robert.jarzmik@free.fr>
To: g.liakhovetski@gmx.de
Date: Mon, 24 Nov 2008 20:28:48 +0100
Message-Id: <1227554928-25471-2-git-send-email-robert.jarzmik@free.fr>
In-Reply-To: <1227554928-25471-1-git-send-email-robert.jarzmik@free.fr>
References: <Pine.LNX.4.64.0811202055210.8290@axis700.grange>
	<1227554928-25471-1-git-send-email-robert.jarzmik@free.fr>
Cc: video4linux-list@redhat.com
Subject: [PATCH 2/2] pxa_camera: use the new translation structure
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

The new translation structure enables to build the format
list with buswidth, depth, host format and camera format
checked, so that it's not done anymore on try_fmt nor
set_fmt.

Signed-off-by: Robert Jarzmik <robert.jarzmik@free.fr>
---
 drivers/media/video/pxa_camera.c |  170 +++++++++++++++----------------------
 1 files changed, 69 insertions(+), 101 deletions(-)

diff --git a/drivers/media/video/pxa_camera.c b/drivers/media/video/pxa_camera.c
index 1bcdb5d..bdea201 100644
--- a/drivers/media/video/pxa_camera.c
+++ b/drivers/media/video/pxa_camera.c
@@ -156,7 +156,7 @@ static int pxa_videobuf_setup(struct videobuf_queue *vq, unsigned int *count,
 		*size += PAGE_ALIGN(icd->width * icd->height / 2); /* V pages */
 	} else {
 		*size = icd->width * icd->height *
-			((icd->current_fmt->depth + 7) >> 3);
+			((icd->current_fmt->host_fmt->depth + 7) >> 3);
 	}
 
 	if (0 == *count)
@@ -273,11 +273,11 @@ static int pxa_videobuf_prepare(struct videobuf_queue *vq,
 	 * the actual buffer is yours */
 	buf->inwork = 1;
 
-	if (buf->fmt	!= icd->current_fmt ||
+	if (buf->fmt	!= icd->current_fmt->host_fmt ||
 	    vb->width	!= icd->width ||
 	    vb->height	!= icd->height ||
 	    vb->field	!= field) {
-		buf->fmt	= icd->current_fmt;
+		buf->fmt	= icd->current_fmt->host_fmt;
 		vb->width	= icd->width;
 		vb->height	= icd->height;
 		vb->field	= field;
@@ -940,18 +940,44 @@ static bool depth_supported(struct soc_camera_device *icd, int depth)
 	return false;
 }
 
+static int required_buswidth(const struct soc_camera_data_format *fmt)
+{
+	switch (fmt->fourcc) {
+	case V4L2_PIX_FMT_UYVY:
+	case V4L2_PIX_FMT_VYUY:
+	case V4L2_PIX_FMT_YUYV:
+	case V4L2_PIX_FMT_YVYU:
+	case V4L2_PIX_FMT_RGB565:
+	case V4L2_PIX_FMT_RGB555:
+		return 8;
+	default:
+		return fmt->depth;
+	}
+}
+
 static int pxa_camera_get_formats(struct soc_camera_device *icd, int idx,
-				  const struct soc_camera_data_format **fmt)
+				  struct soc_camera_format_xlate *xlate)
 {
 	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
-	struct pxa_camera_dev *pcdev = ici->priv;
-	int formats = 0;
+	int formats = 0, buswidth, ret;
+
+	buswidth = required_buswidth(icd->formats + idx);
+
+	if (!depth_supported(icd, buswidth))
+		return 0;
+
+	ret = pxa_camera_try_bus_param(icd, buswidth);
+	if (ret < 0)
+		return 0;
 
 	switch (icd->formats[idx].fourcc) {
 	case V4L2_PIX_FMT_UYVY:
 		formats++;
-		if (fmt && (pcdev->platform_flags & PXA_CAMERA_DATAWIDTH_8)) {
-			*fmt++ = &pxa_camera_formats[0];
+		if (xlate) {
+			xlate->host_fmt = &pxa_camera_formats[0];
+			xlate->cam_fmt = icd->formats + idx;
+			xlate->buswidth = buswidth;
+			xlate++;
 			dev_dbg(&ici->dev, "Providing format %s using %s\n",
 				pxa_camera_formats[0].name,
 				icd->formats[idx].name);
@@ -962,76 +988,57 @@ static int pxa_camera_get_formats(struct soc_camera_device *icd, int idx,
 	case V4L2_PIX_FMT_RGB565:
 	case V4L2_PIX_FMT_RGB555:
 		formats++;
-		if (fmt && (pcdev->platform_flags & PXA_CAMERA_DATAWIDTH_8)) {
-			*fmt++ = &icd->formats[idx];
+		if (xlate) {
+			xlate->host_fmt = icd->formats + idx;
+			xlate->cam_fmt = icd->formats + idx;
+			xlate->buswidth = buswidth;
+			xlate++;
 			dev_dbg(&ici->dev, "Providing format %s packed\n",
 				icd->formats[idx].name);
 		}
 		break;
 	default:
 		/* Generic pass-through */
-		if (depth_supported(icd, icd->formats[idx].depth)) {
-			formats++;
-			if (fmt) {
-				*fmt++ = &icd->formats[idx];
-				dev_dbg(&ici->dev,
-					"Providing format %s in pass-through mode\n",
-					icd->formats[idx].name);
-			}
+		formats++;
+		if (xlate) {
+			xlate->host_fmt = icd->formats + idx;
+			xlate->cam_fmt = icd->formats + idx;
+			xlate->buswidth = icd->formats[idx].depth;
+			xlate++;
+			dev_dbg(&ici->dev,
+				"Providing format %s in pass-through mode\n",
+				icd->formats[idx].name);
 		}
 	}
 
 	return formats;
 }
 
+
 static int pxa_camera_set_fmt(struct soc_camera_device *icd,
 			      __u32 pixfmt, struct v4l2_rect *rect)
 {
 	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
-	struct pxa_camera_dev *pcdev = ici->priv;
-	const struct soc_camera_data_format *host_fmt = NULL;
+	const struct soc_camera_data_format *host_fmt, *cam_fmt = NULL;
+	const struct soc_camera_format_xlate *xlate;
 	int ret, buswidth;
 
-	switch (pixfmt) {
-	case V4L2_PIX_FMT_YUV422P:
-		host_fmt = &pxa_camera_formats[0];
-		pixfmt = V4L2_PIX_FMT_UYVY;
-	case V4L2_PIX_FMT_UYVY:
-	case V4L2_PIX_FMT_VYUY:
-	case V4L2_PIX_FMT_YUYV:
-	case V4L2_PIX_FMT_YVYU:
-	case V4L2_PIX_FMT_RGB565:
-	case V4L2_PIX_FMT_RGB555:
-		if (!(pcdev->platform_flags & PXA_CAMERA_DATAWIDTH_8)) {
-			dev_warn(&ici->dev,
-				 "8 bit bus unsupported, but required for format %x\n",
-				 pixfmt);
-			return -EINVAL;
-		}
+	xlate = soc_camera_xlate_by_fourcc(icd, pixfmt);
+	if (!xlate) {
+		dev_warn(&ici->dev, "Format %x not found\n", pixfmt);
+		return -EINVAL;
+	}
 
-		if (!host_fmt)
-			host_fmt = soc_camera_format_by_fourcc(icd, pixfmt);
+	buswidth = xlate->buswidth;
+	host_fmt = xlate->host_fmt;
+	cam_fmt = xlate->cam_fmt;
 
-		if (!host_fmt) {
-			dev_warn(&ici->dev, "Format %x not found\n", pixfmt);
-			return -EINVAL;
-		}
-		buswidth = 8;
+	switch (pixfmt) {
 	case 0:				/* Only geometry change */
 		ret = icd->ops->set_fmt(icd, pixfmt, rect);
 		break;
 	default:
-		/* Generic pass-through */
-		host_fmt = soc_camera_format_by_fourcc(icd, pixfmt);
-		if (!host_fmt || !depth_supported(icd, host_fmt->depth)) {
-			dev_warn(&ici->dev,
-				 "Format %x unsupported in pass-through mode\n",
-				 pixfmt);
-			return -EINVAL;
-		}
-
-		buswidth = host_fmt->depth;
-		ret = icd->ops->set_fmt(icd, pixfmt, rect);
+		ret = icd->ops->set_fmt(icd, cam_fmt->fourcc, rect);
 	}
 
 	if (ret < 0)
@@ -1040,7 +1047,7 @@ static int pxa_camera_set_fmt(struct soc_camera_device *icd,
 
 	if (pixfmt && !ret) {
 		icd->buswidth = buswidth;
-		icd->current_fmt = host_fmt;
+		icd->current_fmt = xlate;
 	}
 
 	return ret;
@@ -1050,54 +1057,14 @@ static int pxa_camera_try_fmt(struct soc_camera_device *icd,
 			      struct v4l2_format *f)
 {
 	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
-	struct pxa_camera_dev *pcdev = ici->priv;
-	const struct soc_camera_data_format *cam_fmt;
+	const struct soc_camera_format_xlate *xlate;
 	struct v4l2_pix_format *pix = &f->fmt.pix;
 	__u32 pixfmt = pix->pixelformat;
-	unsigned char buswidth;
-	int ret;
-
-	switch (pixfmt) {
-	case V4L2_PIX_FMT_YUV422P:
-		pixfmt = V4L2_PIX_FMT_UYVY;
-	case V4L2_PIX_FMT_UYVY:
-	case V4L2_PIX_FMT_VYUY:
-	case V4L2_PIX_FMT_YUYV:
-	case V4L2_PIX_FMT_YVYU:
-	case V4L2_PIX_FMT_RGB565:
-	case V4L2_PIX_FMT_RGB555:
-		if (!(pcdev->platform_flags & PXA_CAMERA_DATAWIDTH_8)) {
-			dev_warn(&ici->dev,
-				 "try-fmt: 8 bit bus unsupported for format %x\n",
-				 pixfmt);
-			return -EINVAL;
-		}
 
-		cam_fmt = soc_camera_format_by_fourcc(icd, pixfmt);
-		if (!cam_fmt) {
-			dev_warn(&ici->dev, "try-fmt: format %x not found\n",
-				 pixfmt);
-			return -EINVAL;
-		}
-		buswidth = 8;
-		break;
-	default:
-		/* Generic pass-through */
-		cam_fmt = soc_camera_format_by_fourcc(icd, pixfmt);
-		if (!cam_fmt || !depth_supported(icd, cam_fmt->depth)) {
-			dev_warn(&ici->dev,
-				 "try-fmt: Format %x unsupported in pass-through\n",
-				 pixfmt);
-			return -EINVAL;
-		}
-		buswidth = cam_fmt->depth;
-	}
-
-	ret = pxa_camera_try_bus_param(icd, buswidth);
-
-	if (ret < 0) {
-		dev_warn(&ici->dev, "Incompatible bus parameters!\n");
-		return ret;
+	xlate = soc_camera_xlate_by_fourcc(icd, pixfmt);
+	if (!xlate) {
+		dev_warn(&ici->dev, "Format %x not found\n", pixfmt);
+		return -EINVAL;
 	}
 
 	/* limit to pxa hardware capabilities */
@@ -1111,7 +1078,8 @@ static int pxa_camera_try_fmt(struct soc_camera_device *icd,
 		pix->width = 2048;
 	pix->width &= ~0x01;
 
-	pix->bytesperline = pix->width * DIV_ROUND_UP(cam_fmt->depth, 8);
+	pix->bytesperline = pix->width *
+		DIV_ROUND_UP(xlate->host_fmt->depth, 8);
 	pix->sizeimage = pix->height * pix->bytesperline;
 
 	/* limit to sensor capabilities */
-- 
1.5.6.5

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
