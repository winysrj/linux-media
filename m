Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f49.google.com ([209.85.220.49]:60095 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932152AbaJaJKW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 31 Oct 2014 05:10:22 -0400
From: Yoshihiro Kaneko <ykaneko0929@gmail.com>
To: linux-media@vger.kernel.org
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Simon Horman <horms@verge.net.au>,
	Magnus Damm <magnus.damm@gmail.com>, linux-sh@vger.kernel.org
Subject: [PATCH] media: soc_camera: rcar_vin: Fix alignment of clipping size
Date: Fri, 31 Oct 2014 18:10:10 +0900
Message-Id: <1414746610-23194-1-git-send-email-ykaneko0929@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Koji Matsuoka <koji.matsuoka.xm@renesas.com>

Since the Start Line Pre-Clip register, the Start Pixel Pre-Clip
register and the End Line Post-Clip register do not have restriction
of H/W to a setting value, the processing of alignment is unnecessary.
This patch corrects so that processing of alignment is not performed.

However, the End Pixel Post-Clip register has restriction
of H/W which must be an even number value at the time of the
output of YCbCr-422 format. By this patch, the processing of
alignment to an even number value is added on the above-mentioned
conditions.

The variable set to a register is as follows.

 - Start Line Pre-Clip register
   cam->vin_top
 - Start Pixel Pre-Clip register
   cam->vin_left
 - End Line Post-Clip register
   pix->height
 - End Pixel Post-Clip register
   pix->width

Signed-off-by: Koji Matsuoka <koji.matsuoka.xm@renesas.com>
Signed-off-by: Yoshihiro Kaneko <ykaneko0929@gmail.com>
---
 drivers/media/platform/soc_camera/rcar_vin.c | 18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

diff --git a/drivers/media/platform/soc_camera/rcar_vin.c b/drivers/media/platform/soc_camera/rcar_vin.c
index d3d2f7d..1934e15 100644
--- a/drivers/media/platform/soc_camera/rcar_vin.c
+++ b/drivers/media/platform/soc_camera/rcar_vin.c
@@ -1558,8 +1558,8 @@ static int rcar_vin_set_crop(struct soc_camera_device *icd,
 	cam->width = mf.width;
 	cam->height = mf.height;
 
-	cam->vin_left = rect->left & ~1;
-	cam->vin_top = rect->top & ~1;
+	cam->vin_left = rect->left;
+	cam->vin_top = rect->top;
 
 	/* Use VIN cropping to crop to the new window. */
 	ret = rcar_vin_set_rect(icd);
@@ -1761,8 +1761,18 @@ static int rcar_vin_try_fmt(struct soc_camera_device *icd,
 	}
 
 	/* FIXME: calculate using depth and bus width */
-	v4l_bound_align_image(&pix->width, 2, VIN_MAX_WIDTH, 1,
-			      &pix->height, 4, VIN_MAX_HEIGHT, 2, 0);
+	/*
+	 * When performing a YCbCr-422 format output, even if it performs
+	 * odd number clipping by pixel post clip processing, it is outputted
+	 * to a memory per even pixels.
+	 */
+	if ((pixfmt == V4L2_PIX_FMT_NV16) || (pixfmt == V4L2_PIX_FMT_YUYV) ||
+		(pixfmt == V4L2_PIX_FMT_UYVY))
+		v4l_bound_align_image(&pix->width, 5, VIN_MAX_WIDTH, 1,
+				      &pix->height, 2, VIN_MAX_HEIGHT, 0, 0);
+	else
+		v4l_bound_align_image(&pix->width, 5, VIN_MAX_WIDTH, 0,
+				      &pix->height, 2, VIN_MAX_HEIGHT, 0, 0);
 
 	width = pix->width;
 	height = pix->height;
-- 
1.9.1

