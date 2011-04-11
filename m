Return-path: <mchehab@gaivota>
Received: from moutng.kundenserver.de ([212.227.17.9]:65042 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752471Ab1DKI62 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 11 Apr 2011 04:58:28 -0400
Date: Mon, 11 Apr 2011 10:58:26 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
cc: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>,
	Sergio Aguirre <saaguirre@ti.com>
Subject: [PATCH] V4L: soc-camera: regression fix: calculate .sizeimage in
 soc_camera.c
Message-ID: <Pine.LNX.4.64.1104111054110.18511@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

A recent patch has given individual soc-camera host drivers a possibility 
to calculate .sizeimage and .bytesperline pixel format fields internally, 
however, some drivers relied on the core calculating these values for 
them, following a default algorithm. This patch restores the default 
calculation for such drivers.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---
diff --git a/drivers/media/video/soc_camera.c b/drivers/media/video/soc_camera.c
index 4628448..0918c48 100644
--- a/drivers/media/video/soc_camera.c
+++ b/drivers/media/video/soc_camera.c
@@ -376,6 +376,9 @@ static int soc_camera_set_fmt(struct soc_camera_device *icd,
 	dev_dbg(&icd->dev, "S_FMT(%c%c%c%c, %ux%u)\n",
 		pixfmtstr(pix->pixelformat), pix->width, pix->height);
 
+	pix->bytesperline = 0;
+	pix->sizeimage = 0;
+
 	/* We always call try_fmt() before set_fmt() or set_crop() */
 	ret = ici->ops->try_fmt(icd, f);
 	if (ret < 0)
@@ -391,6 +394,17 @@ static int soc_camera_set_fmt(struct soc_camera_device *icd,
 		return -EINVAL;
 	}
 
+	if (!pix->sizeimage) {
+		if (!pix->bytesperline) {
+			ret = soc_mbus_bytes_per_line(pix->width,
+						      icd->current_fmt->host_fmt);
+			if (ret > 0)
+				pix->bytesperline = ret;
+		}
+		if (pix->bytesperline)
+			pix->sizeimage = pix->bytesperline * pix->height;
+	}
+
 	icd->user_width		= pix->width;
 	icd->user_height	= pix->height;
 	icd->bytesperline	= pix->bytesperline;
