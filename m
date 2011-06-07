Return-path: <mchehab@pedra>
Received: from moutng.kundenserver.de ([212.227.126.187]:59152 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752715Ab1FGJ6F (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 7 Jun 2011 05:58:05 -0400
Date: Tue, 7 Jun 2011 11:58:03 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
cc: Robert Jarzmik <robert.jarzmik@free.fr>
Subject: [PATCH 1/3 v2] V4L: pxa_camera: remove redundant calculations
In-Reply-To: <Pine.LNX.4.64.1106071150080.31635@axis700.grange>
Message-ID: <Pine.LNX.4.64.1106071156360.31635@axis700.grange>
References: <Pine.LNX.4.64.1106071150080.31635@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

soc_camera core now performs the standard .bytesperline and .sizeimage
calculations internally, no need to duplicate in drivers.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---
 drivers/media/video/pxa_camera.c |    6 ------
 1 files changed, 0 insertions(+), 6 deletions(-)

diff --git a/drivers/media/video/pxa_camera.c b/drivers/media/video/pxa_camera.c
index b42bfa5..c7f84da 100644
--- a/drivers/media/video/pxa_camera.c
+++ b/drivers/media/video/pxa_camera.c
@@ -1499,12 +1499,6 @@ static int pxa_camera_try_fmt(struct soc_camera_device *icd,
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
-- 
1.7.2.5

