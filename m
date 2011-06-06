Return-path: <mchehab@pedra>
Received: from moutng.kundenserver.de ([212.227.126.187]:61254 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751889Ab1FFRCv (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 6 Jun 2011 13:02:51 -0400
Date: Mon, 6 Jun 2011 19:02:48 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
cc: Robert Jarzmik <robert.jarzmik@free.fr>
Subject: [PATCH] V4L: pxa_camera: remove redundant calculations
Message-ID: <Pine.LNX.4.64.1106061900480.11169@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

soc_camera core now performs the standard .bytesperline and .sizeimage
calculations internally, no need to duplicate in drivers.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---
 drivers/media/video/pxa_camera.c |   24 +++++++++++++-----------
 1 files changed, 13 insertions(+), 11 deletions(-)

diff --git a/drivers/media/video/pxa_camera.c b/drivers/media/video/pxa_camera.c
index b42bfa5..9968a6f 100644
--- a/drivers/media/video/pxa_camera.c
+++ b/drivers/media/video/pxa_camera.c
@@ -1499,16 +1499,10 @@ static int pxa_camera_try_fmt(struct soc_camera_device *icd,
 			      &pix->height, 32, 2048, 0,
 			      pixfmt == V4L2_PIX_FMT_YUV422P ? 4 : 0);
 
-	pix->bytesperline = soc_mbus_bytes_per_line(pix->width,
-						    xlate->host_fmt);
-	if (pix->bytesperline < 0)
-		return pix->bytesperline;
-	pix->sizeimage = pix->height * pix->bytesperline;
-
 	/* limit to sensor capabilities */
 	mf.width	= pix->width;
 	mf.height	= pix->height;
-	mf.field	= pix->field;
+	mf.field	= V4L2_FIELD_NONE;
 	mf.colorspace	= pix->colorspace;
 	mf.code		= xlate->code;
 
@@ -1596,8 +1590,12 @@ static int pxa_camera_suspend(struct soc_camera_device *icd, pm_message_t state)
 	pcdev->save_cicr[i++] = __raw_readl(pcdev->base + CICR3);
 	pcdev->save_cicr[i++] = __raw_readl(pcdev->base + CICR4);
 
-	if ((pcdev->icd) && (pcdev->icd->ops->suspend))
-		ret = pcdev->icd->ops->suspend(pcdev->icd, state);
+	if (pcdev->icd) {
+		struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
+		ret = v4l2_subdev_call(sd, core, s_power, 0);
+		if (ret == -ENOIOCTLCMD)
+			ret = 0;
+	}
 
 	return ret;
 }
@@ -1618,8 +1616,12 @@ static int pxa_camera_resume(struct soc_camera_device *icd)
 	__raw_writel(pcdev->save_cicr[i++], pcdev->base + CICR3);
 	__raw_writel(pcdev->save_cicr[i++], pcdev->base + CICR4);
 
-	if ((pcdev->icd) && (pcdev->icd->ops->resume))
-		ret = pcdev->icd->ops->resume(pcdev->icd);
+	if (pcdev->icd) {
+		struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
+		ret = v4l2_subdev_call(sd, core, s_power, 1);
+		if (ret == -ENOIOCTLCMD)
+			ret = 0;
+	}
 
 	/* Restart frame capture if active buffer exists */
 	if (!ret && pcdev->active)
-- 
1.7.2.5

