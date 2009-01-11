Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:38623 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753277AbZAKAxG (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 10 Jan 2009 19:53:06 -0500
Date: Sun, 11 Jan 2009 01:53:05 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
cc: Robert Jarzmik <robert.jarzmik@free.fr>,
	Magnus Damm <damm@igel.co.jp>
Subject: [PATCH] soc-camera: fix S_CROP breakage on PXA and SuperH
Message-ID: <Pine.LNX.4.64.0901110148360.22041@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Recent format-negotiation patches caused S_CROP breakage in pxa_camera.c 
and sh_mobile_ceu_camera.c drivers, fix it.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---

Tested on PXA, Magnus, please test on sh, Robert, any objections?

diff --git a/drivers/media/video/pxa_camera.c b/drivers/media/video/pxa_camera.c
index a1d6008..07c334f 100644
--- a/drivers/media/video/pxa_camera.c
+++ b/drivers/media/video/pxa_camera.c
@@ -1155,23 +1155,23 @@ static int pxa_camera_set_fmt(struct soc_camera_device *icd,
 {
 	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
 	struct pxa_camera_dev *pcdev = ici->priv;
-	const struct soc_camera_data_format *host_fmt, *cam_fmt = NULL;
-	const struct soc_camera_format_xlate *xlate;
+	const struct soc_camera_data_format *cam_fmt = NULL;
+	const struct soc_camera_format_xlate *xlate = NULL;
 	struct soc_camera_sense sense = {
 		.master_clock = pcdev->mclk,
 		.pixel_clock_max = pcdev->ciclk / 4,
 	};
-	int ret, buswidth;
+	int ret;
 
-	xlate = soc_camera_xlate_by_fourcc(icd, pixfmt);
-	if (!xlate) {
-		dev_warn(&ici->dev, "Format %x not found\n", pixfmt);
-		return -EINVAL;
-	}
+	if (pixfmt) {
+		xlate = soc_camera_xlate_by_fourcc(icd, pixfmt);
+		if (!xlate) {
+			dev_warn(&ici->dev, "Format %x not found\n", pixfmt);
+			return -EINVAL;
+		}
 
-	buswidth = xlate->buswidth;
-	host_fmt = xlate->host_fmt;
-	cam_fmt = xlate->cam_fmt;
+		cam_fmt = xlate->cam_fmt;
+	}
 
 	/* If PCLK is used to latch data from the sensor, check sense */
 	if (pcdev->platform_flags & PXA_CAMERA_PCLK_EN)
@@ -1201,8 +1201,8 @@ static int pxa_camera_set_fmt(struct soc_camera_device *icd,
 	}
 
 	if (pixfmt && !ret) {
-		icd->buswidth = buswidth;
-		icd->current_fmt = host_fmt;
+		icd->buswidth = xlate->buswidth;
+		icd->current_fmt = xlate->host_fmt;
 	}
 
 	return ret;
diff --git a/drivers/media/video/sh_mobile_ceu_camera.c b/drivers/media/video/sh_mobile_ceu_camera.c
index 9a2586b..ddcb81d 100644
--- a/drivers/media/video/sh_mobile_ceu_camera.c
+++ b/drivers/media/video/sh_mobile_ceu_camera.c
@@ -603,21 +603,18 @@ static int sh_mobile_ceu_set_fmt(struct soc_camera_device *icd,
 	const struct soc_camera_format_xlate *xlate;
 	int ret;
 
+	if (!pixfmt)
+		return icd->ops->set_fmt(icd, pixfmt, rect);
+
 	xlate = soc_camera_xlate_by_fourcc(icd, pixfmt);
 	if (!xlate) {
 		dev_warn(&ici->dev, "Format %x not found\n", pixfmt);
 		return -EINVAL;
 	}
 
-	switch (pixfmt) {
-	case 0:				/* Only geometry change */
-		ret = icd->ops->set_fmt(icd, pixfmt, rect);
-		break;
-	default:
-		ret = icd->ops->set_fmt(icd, xlate->cam_fmt->fourcc, rect);
-	}
+	ret = icd->ops->set_fmt(icd, xlate->cam_fmt->fourcc, rect);
 
-	if (pixfmt && !ret) {
+	if (!ret) {
 		icd->buswidth = xlate->buswidth;
 		icd->current_fmt = xlate->host_fmt;
 		pcdev->camera_fmt = xlate->cam_fmt;
