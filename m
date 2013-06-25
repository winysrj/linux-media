Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.9]:57311 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751985Ab3FYJMx (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 25 Jun 2013 05:12:53 -0400
Received: from localhost (localhost [127.0.0.1])
	by axis700.grange (Postfix) with ESMTP id B45D140BB3
	for <linux-media@vger.kernel.org>; Tue, 25 Jun 2013 11:12:50 +0200 (CEST)
Date: Tue, 25 Jun 2013 11:12:50 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH] V4L2: soc-camera: remove several CEU references in the
 generic scaler
Message-ID: <Pine.LNX.4.64.1306251109480.30321@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The scaling / cropping library, that has been extracted from the CEU
driver still contained a couple of references to the original hardware.
Clean them up.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---

A cosmetic fix, goes on top of

https://patchwork.linuxtv.org/patch/18209/
https://patchwork.linuxtv.org/patch/18210/

I'll be pushing them together with other V4L2 asynchronous probing hick up 
fixes later today.

 drivers/media/platform/soc_camera/soc_scale_crop.c |   15 ++++++++-------
 1 files changed, 8 insertions(+), 7 deletions(-)

diff --git a/drivers/media/platform/soc_camera/soc_scale_crop.c b/drivers/media/platform/soc_camera/soc_scale_crop.c
index be7067f..cbd3a34 100644
--- a/drivers/media/platform/soc_camera/soc_scale_crop.c
+++ b/drivers/media/platform/soc_camera/soc_scale_crop.c
@@ -221,7 +221,7 @@ static int client_s_fmt(struct soc_camera_device *icd,
 	struct device *dev = icd->parent;
 	unsigned int width = mf->width, height = mf->height, tmp_w, tmp_h;
 	struct v4l2_cropcap cap;
-	bool ceu_1to1;
+	bool host_1to1;
 	int ret;
 
 	ret = v4l2_device_call_until_err(sd->v4l2_dev,
@@ -234,11 +234,11 @@ static int client_s_fmt(struct soc_camera_device *icd,
 
 	if (width == mf->width && height == mf->height) {
 		/* Perfect! The client has done it all. */
-		ceu_1to1 = true;
+		host_1to1 = true;
 		goto update_cache;
 	}
 
-	ceu_1to1 = false;
+	host_1to1 = false;
 	if (!host_can_scale)
 		goto update_cache;
 
@@ -282,7 +282,7 @@ update_cache:
 	if (ret < 0)
 		return ret;
 
-	if (ceu_1to1)
+	if (host_1to1)
 		*subrect = *rect;
 	else
 		update_subrect(rect, subrect);
@@ -338,7 +338,7 @@ int soc_camera_client_scale(struct soc_camera_device *icd,
 	mf->colorspace	= mf_tmp.colorspace;
 
 	/*
-	 * 8. Calculate new CEU crop - apply camera scales to previously
+	 * 8. Calculate new host crop - apply camera scales to previously
 	 *    updated "effective" crop.
 	 */
 	*width = soc_camera_shift_scale(subrect->width, shift, scale_h);
@@ -353,7 +353,7 @@ EXPORT_SYMBOL(soc_camera_client_scale);
 /*
  * Calculate real client output window by applying new scales to the current
  * client crop. New scales are calculated from the requested output format and
- * CEU crop, mapped backed onto the client input (subrect).
+ * host crop, mapped backed onto the client input (subrect).
  */
 void soc_camera_calc_client_output(struct soc_camera_device *icd,
 		struct v4l2_rect *rect, struct v4l2_rect *subrect,
@@ -384,7 +384,8 @@ void soc_camera_calc_client_output(struct soc_camera_device *icd,
 
 	/*
 	 * TODO: CEU cannot scale images larger than VGA to smaller than SubQCIF
-	 * (128x96) or larger than VGA
+	 * (128x96) or larger than VGA. This and similar limitations have to be
+	 * taken into account here.
 	 */
 	scale_h = soc_camera_calc_scale(subrect->width, shift, pix->width);
 	scale_v = soc_camera_calc_scale(subrect->height, shift, pix->height);
-- 
1.7.2.5

