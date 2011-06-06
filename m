Return-path: <mchehab@pedra>
Received: from moutng.kundenserver.de ([212.227.126.171]:50631 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751889Ab1FFRAs (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 6 Jun 2011 13:00:48 -0400
Date: Mon, 6 Jun 2011 19:00:46 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
cc: Sascha Hauer <s.hauer@pengutronix.de>
Subject: [PATCH] V4L: mx3_camera: remove redundant calculations
Message-ID: <Pine.LNX.4.64.1106061859060.11169@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

soc_camera core now performs the standard .bytesperline and .sizeimage
calculations internally, no need to duplicate in drivers.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---
 drivers/media/video/mx3_camera.c |   12 ------------
 1 files changed, 0 insertions(+), 12 deletions(-)

diff --git a/drivers/media/video/mx3_camera.c b/drivers/media/video/mx3_camera.c
index c7680eb..69b2d9d 100644
--- a/drivers/media/video/mx3_camera.c
+++ b/drivers/media/video/mx3_camera.c
@@ -913,12 +913,6 @@ static int mx3_camera_set_fmt(struct soc_camera_device *icd,
 	pix->colorspace		= mf.colorspace;
 	icd->current_fmt	= xlate;
 
-	pix->bytesperline = soc_mbus_bytes_per_line(pix->width,
-						    xlate->host_fmt);
-	if (pix->bytesperline < 0)
-		return pix->bytesperline;
-	pix->sizeimage = pix->height * pix->bytesperline;
-
 	dev_dbg(icd->dev.parent, "Sensor set %dx%d\n", pix->width, pix->height);
 
 	return ret;
@@ -946,12 +940,6 @@ static int mx3_camera_try_fmt(struct soc_camera_device *icd,
 	if (pix->width > 4096)
 		pix->width = 4096;
 
-	pix->bytesperline = soc_mbus_bytes_per_line(pix->width,
-						    xlate->host_fmt);
-	if (pix->bytesperline < 0)
-		return pix->bytesperline;
-	pix->sizeimage = pix->height * pix->bytesperline;
-
 	/* limit to sensor capabilities */
 	mf.width	= pix->width;
 	mf.height	= pix->height;
-- 
1.7.2.5

