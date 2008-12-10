Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mBA7khEe014231
	for <video4linux-list@redhat.com>; Wed, 10 Dec 2008 02:46:43 -0500
Received: from rv-out-0506.google.com (rv-out-0506.google.com [209.85.198.235])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mBA7kSKD006348
	for <video4linux-list@redhat.com>; Wed, 10 Dec 2008 02:46:29 -0500
Received: by rv-out-0506.google.com with SMTP id f6so317185rvb.51
	for <video4linux-list@redhat.com>; Tue, 09 Dec 2008 23:46:28 -0800 (PST)
From: Magnus Damm <magnus.damm@gmail.com>
To: video4linux-list@redhat.com
Date: Wed, 10 Dec 2008 16:44:42 +0900
Message-Id: <20081210074442.5727.31628.sendpatchset@rx1.opensource.se>
In-Reply-To: <20081210074435.5727.93374.sendpatchset@rx1.opensource.se>
References: <20081210074435.5727.93374.sendpatchset@rx1.opensource.se>
Cc: g.liakhovetski@gmx.de
Subject: [PATCH 01/03] sh_mobile_ceu: use new pixel format translation code
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

From: Magnus Damm <damm@igel.co.jp>

This patch converts the sh_mobile_ceu driver to make use
of the new pixel format translation code. Only pass-though
mode at this point.

Signed-off-by: Magnus Damm <damm@igel.co.jp>
---

 drivers/media/video/sh_mobile_ceu_camera.c |   83 +++++++++++++++++++---------
 1 file changed, 57 insertions(+), 26 deletions(-)

--- 0008/drivers/media/video/sh_mobile_ceu_camera.c
+++ work/drivers/media/video/sh_mobile_ceu_camera.c	2008-12-09 22:56:02.000000000 +0900
@@ -434,8 +434,7 @@ static int sh_mobile_ceu_set_bus_param(s
 	return 0;
 }
 
-static int sh_mobile_ceu_try_bus_param(struct soc_camera_device *icd,
-				       __u32 pixfmt)
+static int sh_mobile_ceu_try_bus_param(struct soc_camera_device *icd)
 {
 	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
 	struct sh_mobile_ceu_dev *pcdev = ici->priv;
@@ -450,25 +449,60 @@ static int sh_mobile_ceu_try_bus_param(s
 	return 0;
 }
 
+static int sh_mobile_ceu_get_formats(struct soc_camera_device *icd, int idx,
+				     struct soc_camera_format_xlate *xlate)
+{
+	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
+	int ret;
+	int formats = 0;
+
+	ret = sh_mobile_ceu_try_bus_param(icd);
+	if (ret < 0)
+		return 0;
+
+	switch (icd->formats[idx].fourcc) {
+	default:
+		/* Generic pass-through */
+		formats++;
+		if (xlate) {
+			xlate->host_fmt = icd->formats + idx;
+			xlate->cam_fmt = icd->formats + idx;
+			xlate->buswidth = icd->formats[idx].depth;
+			xlate++;
+			dev_dbg(&ici->dev,
+				"Providing format %s in pass-through mode\n",
+				icd->formats[idx].name);
+		}
+	}
+
+	return formats;
+}
+
 static int sh_mobile_ceu_set_fmt(struct soc_camera_device *icd,
 				 __u32 pixfmt, struct v4l2_rect *rect)
 {
-	const struct soc_camera_data_format *cam_fmt;
+	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
+	const struct soc_camera_format_xlate *xlate;
 	int ret;
 
-	/*
-	 * TODO: find a suitable supported by the SoC output format, check
-	 * whether the sensor supports one of acceptable input formats.
-	 */
-	if (pixfmt) {
-		cam_fmt = soc_camera_format_by_fourcc(icd, pixfmt);
-		if (!cam_fmt)
-			return -EINVAL;
+	xlate = soc_camera_xlate_by_fourcc(icd, pixfmt);
+	if (!xlate) {
+		dev_warn(&ici->dev, "Format %x not found\n", pixfmt);
+		return -EINVAL;
+	}
+
+	switch (pixfmt) {
+	case 0:				/* Only geometry change */
+		ret = icd->ops->set_fmt(icd, pixfmt, rect);
+		break;
+	default:
+		ret = icd->ops->set_fmt(icd, xlate->cam_fmt->fourcc, rect);
 	}
 
-	ret = icd->ops->set_fmt(icd, pixfmt, rect);
-	if (pixfmt && !ret)
-		icd->current_fmt = cam_fmt;
+	if (pixfmt && !ret) {
+		icd->buswidth = xlate->buswidth;
+		icd->current_fmt = xlate->host_fmt;
+	}
 
 	return ret;
 }
@@ -476,19 +510,15 @@ static int sh_mobile_ceu_set_fmt(struct 
 static int sh_mobile_ceu_try_fmt(struct soc_camera_device *icd,
 				 struct v4l2_format *f)
 {
-	const struct soc_camera_data_format *cam_fmt;
-	int ret = sh_mobile_ceu_try_bus_param(icd, f->fmt.pix.pixelformat);
-
-	if (ret < 0)
-		return ret;
+	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
+	const struct soc_camera_format_xlate *xlate;
+	__u32 pixfmt = f->fmt.pix.pixelformat;
 
-	/*
-	 * TODO: find a suitable supported by the SoC output format, check
-	 * whether the sensor supports one of acceptable input formats.
-	 */
-	cam_fmt = soc_camera_format_by_fourcc(icd, f->fmt.pix.pixelformat);
-	if (!cam_fmt)
+	xlate = soc_camera_xlate_by_fourcc(icd, pixfmt);
+	if (!xlate) {
+		dev_warn(&ici->dev, "Format %x not found\n", pixfmt);
 		return -EINVAL;
+	}
 
 	/* FIXME: calculate using depth and bus width */
 
@@ -504,7 +534,7 @@ static int sh_mobile_ceu_try_fmt(struct 
 	f->fmt.pix.height &= ~0x03;
 
 	f->fmt.pix.bytesperline = f->fmt.pix.width *
-		DIV_ROUND_UP(cam_fmt->depth, 8);
+		DIV_ROUND_UP(xlate->host_fmt->depth, 8);
 	f->fmt.pix.sizeimage = f->fmt.pix.height * f->fmt.pix.bytesperline;
 
 	/* limit to sensor capabilities */
@@ -576,6 +606,7 @@ static struct soc_camera_host_ops sh_mob
 	.owner		= THIS_MODULE,
 	.add		= sh_mobile_ceu_add_device,
 	.remove		= sh_mobile_ceu_remove_device,
+	.get_formats	= sh_mobile_ceu_get_formats,
 	.set_fmt	= sh_mobile_ceu_set_fmt,
 	.try_fmt	= sh_mobile_ceu_try_fmt,
 	.reqbufs	= sh_mobile_ceu_reqbufs,

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
