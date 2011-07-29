Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.9]:59687 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756288Ab1G2K5F (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 29 Jul 2011 06:57:05 -0400
Received: from 6a.grange (6a.grange [192.168.1.11])
	by axis700.grange (Postfix) with ESMTPS id 90C4218B053
	for <linux-media@vger.kernel.org>; Fri, 29 Jul 2011 12:57:01 +0200 (CEST)
Received: from lyakh by 6a.grange with local (Exim 4.72)
	(envelope-from <g.liakhovetski@gmx.de>)
	id 1QmkkX-0007os-Gh
	for linux-media@vger.kernel.org; Fri, 29 Jul 2011 12:57:01 +0200
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: linux-media@vger.kernel.org
Subject: [PATCH 39/59] V4L: soc-camera: camera client operations no longer compulsory
Date: Fri, 29 Jul 2011 12:56:39 +0200
Message-Id: <1311937019-29914-40-git-send-email-g.liakhovetski@gmx.de>
In-Reply-To: <1311937019-29914-1-git-send-email-g.liakhovetski@gmx.de>
References: <1311937019-29914-1-git-send-email-g.liakhovetski@gmx.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

With the transition of all soc-camera host drivers to use V4L2
subdevice .[gs]_mbus_config() operations, soc-camera client operations
no longer have to be compulsory.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---
 drivers/media/video/soc_camera.c |   10 ++++------
 1 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/media/video/soc_camera.c b/drivers/media/video/soc_camera.c
index 8b16152..e05d1c7 100644
--- a/drivers/media/video/soc_camera.c
+++ b/drivers/media/video/soc_camera.c
@@ -482,7 +482,7 @@ static int soc_camera_open(struct file *file)
 	struct soc_camera_host *ici;
 	int ret;
 
-	if (!icd->ops)
+	if (!to_soc_camera_control(icd))
 		/* No device driver attached */
 		return -ENODEV;
 
@@ -835,6 +835,9 @@ static int soc_camera_queryctrl(struct file *file, void *priv,
 			return 0;
 		}
 
+	if (!icd->ops)
+		return -EINVAL;
+
 	/* Then device controls */
 	for (i = 0; i < icd->ops->num_controls; i++)
 		if (qc->id == icd->ops->controls[i].id) {
@@ -1461,11 +1464,6 @@ static int soc_camera_video_start(struct soc_camera_device *icd)
 	if (!icd->parent)
 		return -ENODEV;
 
-	if (!icd->ops ||
-	    !icd->ops->query_bus_param ||
-	    !icd->ops->set_bus_param)
-		return -EINVAL;
-
 	ret = video_register_device(icd->vdev, VFL_TYPE_GRABBER, -1);
 	if (ret < 0) {
 		dev_err(icd->pdev, "video_register_device failed: %d\n", ret);
-- 
1.7.2.5

