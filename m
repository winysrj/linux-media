Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.187]:61955 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753512Ab1IGQrL (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 7 Sep 2011 12:47:11 -0400
Received: from localhost (localhost [127.0.0.1])
	by axis700.grange (Postfix) with ESMTP id F23F118B03B
	for <linux-media@vger.kernel.org>; Wed,  7 Sep 2011 17:03:09 +0200 (CEST)
Date: Wed, 7 Sep 2011 17:03:09 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 1/2] V4L: sh_mobile_ceu_camera: the host shall configure the
 pipeline
In-Reply-To: <Pine.LNX.4.64.1109071550320.14818@axis700.grange>
Message-ID: <Pine.LNX.4.64.1109071645550.14818@axis700.grange>
References: <Pine.LNX.4.64.1109071550320.14818@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

>From 2ead2de80898ad53923a4fc4d4e1142ae414fd2f Mon Sep 17 00:00:00 2001
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Date: Wed, 7 Sep 2011 16:59:47 +0200
Subject: [PATCH] V4L: sh_mobile_ceu_camera: the host shall configure the pipeline

It is a task of the host / bridge driver to bind single subdevices into a
pipeline, not of respective subdevices. Eventually this might be handled
by the Media Controller API.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---
 drivers/media/video/sh_mobile_ceu_camera.c |   20 +++++++++++++++-----
 1 files changed, 15 insertions(+), 5 deletions(-)

diff --git a/drivers/media/video/sh_mobile_ceu_camera.c b/drivers/media/video/sh_mobile_ceu_camera.c
index 56bb82d..ddb3951 100644
--- a/drivers/media/video/sh_mobile_ceu_camera.c
+++ b/drivers/media/video/sh_mobile_ceu_camera.c
@@ -564,16 +564,24 @@ static int sh_mobile_ceu_add_device(struct soc_camera_device *icd)
 	ret = sh_mobile_ceu_soft_reset(pcdev);
 
 	csi2_sd = find_csi2(pcdev);
+	if (csi2_sd)
+		csi2_sd->grp_id = (long)icd;
 
 	ret = v4l2_subdev_call(csi2_sd, core, s_power, 1);
-	if (ret != -ENODEV && ret != -ENOIOCTLCMD && ret < 0) {
+	if (ret < 0 && ret != -ENOIOCTLCMD && ret != -ENODEV) {
 		pm_runtime_put_sync(ici->v4l2_dev.dev);
-	} else {
-		pcdev->icd = icd;
-		ret = 0;
+		return ret;
 	}
 
-	return ret;
+	/*
+	 * -ENODEV is special: either csi2_sd == NULL or the CSI-2 driver
+	 * has not found this soc-camera device among its clients
+	 */
+	if (ret == -ENODEV && csi2_sd)
+		csi2_sd->grp_id = 0;
+	pcdev->icd = icd;
+
+	return 0;
 }
 
 /* Called with .video_lock held */
@@ -586,6 +594,8 @@ static void sh_mobile_ceu_remove_device(struct soc_camera_device *icd)
 	BUG_ON(icd != pcdev->icd);
 
 	v4l2_subdev_call(csi2_sd, core, s_power, 0);
+	if (csi2_sd)
+		csi2_sd->grp_id = 0;
 	/* disable capture, disable interrupts */
 	ceu_write(pcdev, CEIER, 0);
 	sh_mobile_ceu_soft_reset(pcdev);
-- 
1.7.2.5

