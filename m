Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.186]:51740 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752319Ab2LZRgB (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 26 Dec 2012 12:36:01 -0500
Received: from 6a.grange (6a.grange [192.168.1.11])
	by axis700.grange (Postfix) with ESMTPS id 624C040BDC
	for <linux-media@vger.kernel.org>; Wed, 26 Dec 2012 18:35:59 +0100 (CET)
Received: from lyakh by 6a.grange with local (Exim 4.72)
	(envelope-from <g.liakhovetski@gmx.de>)
	id 1Tnutb-0001cX-1v
	for linux-media@vger.kernel.org; Wed, 26 Dec 2012 18:35:59 +0100
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: linux-media@vger.kernel.org
Subject: [PATCH 6/6] soc-camera: fix repeated regulator requesting
Date: Wed, 26 Dec 2012 18:35:58 +0100
Message-Id: <1356543358-6180-7-git-send-email-g.liakhovetski@gmx.de>
In-Reply-To: <1356543358-6180-1-git-send-email-g.liakhovetski@gmx.de>
References: <1356543358-6180-1-git-send-email-g.liakhovetski@gmx.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Currently devm_regulator_bulk_get() is called by soc-camera during host
driver probing, but regulators are attached to the camera platform
device, that is staying, independent whether the host probed successfully
or not. This can lead to repeated regulator requesting, if the host
driver is re-probed. Move the call to platform device probing to avoid
this.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---
 drivers/media/platform/soc_camera/soc_camera.c |   13 +++++++------
 1 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/media/platform/soc_camera/soc_camera.c b/drivers/media/platform/soc_camera/soc_camera.c
index 4285a8b..0b6ddff 100644
--- a/drivers/media/platform/soc_camera/soc_camera.c
+++ b/drivers/media/platform/soc_camera/soc_camera.c
@@ -1146,11 +1146,6 @@ static int soc_camera_probe(struct soc_camera_device *icd)
 	if (ret < 0)
 		return ret;
 
-	ret = devm_regulator_bulk_get(icd->pdev, ssdd->num_regulators,
-				      ssdd->regulators);
-	if (ret < 0)
-		goto ereg;
-
 	/* The camera could have been already on, try to reset */
 	if (ssdd->reset)
 		ssdd->reset(icd->pdev);
@@ -1255,7 +1250,6 @@ evdc:
 	ici->ops->remove(icd);
 	mutex_unlock(&ici->host_lock);
 eadd:
-ereg:
 	v4l2_ctrl_handler_free(&icd->ctrl_handler);
 	return ret;
 }
@@ -1542,7 +1536,9 @@ static int soc_camera_video_start(struct soc_camera_device *icd)
 static int __devinit soc_camera_pdrv_probe(struct platform_device *pdev)
 {
 	struct soc_camera_desc *sdesc = pdev->dev.platform_data;
+	struct soc_camera_subdev_desc *ssdd = &sdesc->subdev_desc;
 	struct soc_camera_device *icd;
+	int ret;
 
 	if (!sdesc)
 		return -EINVAL;
@@ -1551,6 +1547,11 @@ static int __devinit soc_camera_pdrv_probe(struct platform_device *pdev)
 	if (!icd)
 		return -ENOMEM;
 
+	ret = devm_regulator_bulk_get(&pdev->dev, ssdd->num_regulators,
+				      ssdd->regulators);
+	if (ret < 0)
+		return ret;
+
 	icd->iface = sdesc->host_desc.bus_id;
 	icd->sdesc = sdesc;
 	icd->pdev = &pdev->dev;
-- 
1.7.2.5

