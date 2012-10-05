Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.186]:58440 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750750Ab2JEPrS (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 5 Oct 2012 11:47:18 -0400
Date: Fri, 5 Oct 2012 17:47:14 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
cc: Albert Wang <twang13@marvell.com>
Subject: [PATCH] media: soc-camera: remove superfluous JPEG checking
Message-ID: <Pine.LNX.4.64.1210051743120.13761@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Explicit checks for the JPEG pixel format in soc_mbus_bytes_per_line() and 
soc_mbus_image_size() are superfluous, because also without them these 
functions will perform correctly. The former will return 0 based on 
packing == SOC_MBUS_PACKING_VARIABLE and the latter will simply multiply 
the user-provided line length by the image height to obtain a frame buffer 
size estimate. The original version of the "media: soc_camera: don't clear 
pix->sizeimage in JPEG mode" patch was correct and my amendment, adding 
these two checks was superfluous.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---
diff --git a/drivers/media/platform/soc_camera/soc_mediabus.c b/drivers/media/platform/soc_camera/soc_mediabus.c
index a397812..89dce09 100644
--- a/drivers/media/platform/soc_camera/soc_mediabus.c
+++ b/drivers/media/platform/soc_camera/soc_mediabus.c
@@ -378,9 +378,6 @@ EXPORT_SYMBOL(soc_mbus_samples_per_pixel);
 
 s32 soc_mbus_bytes_per_line(u32 width, const struct soc_mbus_pixelfmt *mf)
 {
-	if (mf->fourcc == V4L2_PIX_FMT_JPEG)
-		return 0;
-
 	if (mf->layout != SOC_MBUS_LAYOUT_PACKED)
 		return width * mf->bits_per_sample / 8;
 
@@ -403,9 +400,6 @@ EXPORT_SYMBOL(soc_mbus_bytes_per_line);
 s32 soc_mbus_image_size(const struct soc_mbus_pixelfmt *mf,
 			u32 bytes_per_line, u32 height)
 {
-	if (mf->fourcc == V4L2_PIX_FMT_JPEG)
-		return 0;
-
 	if (mf->layout == SOC_MBUS_LAYOUT_PACKED)
 		return bytes_per_line * height;
 
