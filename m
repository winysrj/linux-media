Return-path: <mchehab@pedra>
Received: from moutng.kundenserver.de ([212.227.17.8]:49355 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751695Ab1FFRPV (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 6 Jun 2011 13:15:21 -0400
Received: from localhost (localhost [127.0.0.1])
	by axis700.grange (Postfix) with ESMTP id F3822189B77
	for <linux-media@vger.kernel.org>; Mon,  6 Jun 2011 19:15:19 +0200 (CEST)
Date: Mon, 6 Jun 2011 19:15:19 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH] V4L: sh_mobile_ceu_camera: remove redundant calculations
Message-ID: <Pine.LNX.4.64.1106061912320.11169@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

soc_camera core now performs the standard .bytesperline and .sizeimage
calculations internally, no need to duplicate in drivers.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---
 drivers/media/video/sh_mobile_ceu_camera.c |    5 -----
 1 files changed, 0 insertions(+), 5 deletions(-)

diff --git a/drivers/media/video/sh_mobile_ceu_camera.c b/drivers/media/video/sh_mobile_ceu_camera.c
index 3ae5c9c..b08debc 100644
--- a/drivers/media/video/sh_mobile_ceu_camera.c
+++ b/drivers/media/video/sh_mobile_ceu_camera.c
@@ -1701,11 +1701,6 @@ static int sh_mobile_ceu_try_fmt(struct soc_camera_device *icd,
 	width = pix->width;
 	height = pix->height;
 
-	pix->bytesperline = soc_mbus_bytes_per_line(width, xlate->host_fmt);
-	if ((int)pix->bytesperline < 0)
-		return pix->bytesperline;
-	pix->sizeimage = height * pix->bytesperline;
-
 	/* limit to sensor capabilities */
 	mf.width	= pix->width;
 	mf.height	= pix->height;
-- 
1.7.2.5

