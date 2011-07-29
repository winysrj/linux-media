Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.171]:55490 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755619Ab1G2K5D (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 29 Jul 2011 06:57:03 -0400
Received: from 6a.grange (6a.grange [192.168.1.11])
	by axis700.grange (Postfix) with ESMTPS id E93C7189B6F
	for <linux-media@vger.kernel.org>; Fri, 29 Jul 2011 12:56:59 +0200 (CEST)
Received: from lyakh by 6a.grange with local (Exim 4.72)
	(envelope-from <g.liakhovetski@gmx.de>)
	id 1QmkkV-0007n2-PD
	for linux-media@vger.kernel.org; Fri, 29 Jul 2011 12:56:59 +0200
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: linux-media@vger.kernel.org
Subject: [PATCH 02/59] V4L: sh_mobile_ceu_camera: don't try to improve client scaling, if perfect
Date: Fri, 29 Jul 2011 12:56:02 +0200
Message-Id: <1311937019-29914-3-git-send-email-g.liakhovetski@gmx.de>
In-Reply-To: <1311937019-29914-1-git-send-email-g.liakhovetski@gmx.de>
References: <1311937019-29914-1-git-send-email-g.liakhovetski@gmx.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

If the client has managed to configure the precise output format,
we don't have to try to further improve it.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---
 drivers/media/video/sh_mobile_ceu_camera.c |   21 ++++++++++++++++-----
 1 files changed, 16 insertions(+), 5 deletions(-)

diff --git a/drivers/media/video/sh_mobile_ceu_camera.c b/drivers/media/video/sh_mobile_ceu_camera.c
index 2e5a01d..407b96a 100644
--- a/drivers/media/video/sh_mobile_ceu_camera.c
+++ b/drivers/media/video/sh_mobile_ceu_camera.c
@@ -1279,6 +1279,7 @@ static int client_s_fmt(struct soc_camera_device *icd,
 	unsigned int width = mf->width, height = mf->height, tmp_w, tmp_h;
 	unsigned int max_width, max_height;
 	struct v4l2_cropcap cap;
+	bool ceu_1to1;
 	int ret;
 
 	ret = v4l2_device_call_until_err(sd->v4l2_dev, (long)icd, video,
@@ -1288,7 +1289,14 @@ static int client_s_fmt(struct soc_camera_device *icd,
 
 	dev_geo(dev, "camera scaled to %ux%u\n", mf->width, mf->height);
 
-	if ((width == mf->width && height == mf->height) || !ceu_can_scale)
+	if (width == mf->width && height == mf->height) {
+		/* Perfect! The client has done it all. */
+		ceu_1to1 = true;
+		goto update_cache;
+	}
+
+	ceu_1to1 = false;
+	if (!ceu_can_scale)
 		goto update_cache;
 
 	cap.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
@@ -1328,7 +1336,10 @@ update_cache:
 	if (ret < 0)
 		return ret;
 
-	update_subrect(cam);
+	if (ceu_1to1)
+		cam->subrect = cam->rect;
+	else
+		update_subrect(cam);
 
 	return 0;
 }
@@ -1579,8 +1590,8 @@ static void calculate_client_output(struct soc_camera_device *icd,
 	dev_geo(dev, "3: scales %u:%u\n", scale_h, scale_v);
 
 	/*
-	 * 4. Calculate client output window by applying combined scales to real
-	 *    input window.
+	 * 4. Calculate desired client output window by applying combined scales
+	 *    to client (real) input window.
 	 */
 	mf->width	= scale_down(cam->rect.width, scale_h);
 	mf->height	= scale_down(cam->rect.height, scale_v);
@@ -1627,7 +1638,7 @@ static int sh_mobile_ceu_set_fmt(struct soc_camera_device *icd,
 		return -EINVAL;
 	}
 
-	/* 1.-4. Calculate client output geometry */
+	/* 1.-4. Calculate desired client output geometry */
 	calculate_client_output(icd, pix, &mf);
 	mf.field	= pix->field;
 	mf.colorspace	= pix->colorspace;
-- 
1.7.2.5

