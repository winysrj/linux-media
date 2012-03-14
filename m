Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.171]:61860 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753621Ab2CNPAV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 14 Mar 2012 11:00:21 -0400
Received: from localhost (localhost [127.0.0.1])
	by axis700.grange (Postfix) with ESMTP id C4D69189F9D
	for <linux-media@vger.kernel.org>; Wed, 14 Mar 2012 16:00:19 +0100 (CET)
Date: Wed, 14 Mar 2012 16:00:19 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH] V4L: soc-camera: call soc_camera_power_on() after adding
 the client to the host
Message-ID: <Pine.LNX.4.64.1203141553580.25284@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

soc_camera_power_on() calls client's .s_power(1) method, which can try to
access the client hardware. This, however, is typically only possible,
after calling host's .add() method, because that's where the host driver
usually turns the master clock on.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---

This patch has been lying around for some time, but it is indeed required 
for some camera drivers, e.g., mt9m111, otherwise they fail to function. 
I'll push it for 3.4.

 drivers/media/video/soc_camera.c |   32 ++++++++++++++++----------------
 1 files changed, 16 insertions(+), 16 deletions(-)

diff --git a/drivers/media/video/soc_camera.c b/drivers/media/video/soc_camera.c
index b827107..eb25756 100644
--- a/drivers/media/video/soc_camera.c
+++ b/drivers/media/video/soc_camera.c
@@ -526,10 +526,6 @@ static int soc_camera_open(struct file *file)
 			},
 		};
 
-		ret = soc_camera_power_on(icd, icl);
-		if (ret < 0)
-			goto epower;
-
 		/* The camera could have been already on, try to reset */
 		if (icl->reset)
 			icl->reset(icd->pdev);
@@ -540,6 +536,10 @@ static int soc_camera_open(struct file *file)
 			goto eiciadd;
 		}
 
+		ret = soc_camera_power_on(icd, icl);
+		if (ret < 0)
+			goto epower;
+
 		pm_runtime_enable(&icd->vdev->dev);
 		ret = pm_runtime_resume(&icd->vdev->dev);
 		if (ret < 0 && ret != -ENOSYS)
@@ -578,10 +578,10 @@ einitvb:
 esfmt:
 	pm_runtime_disable(&icd->vdev->dev);
 eresume:
-	ici->ops->remove(icd);
-eiciadd:
 	soc_camera_power_off(icd, icl);
 epower:
+	ici->ops->remove(icd);
+eiciadd:
 	icd->use_count--;
 	module_put(ici->ops->owner);
 
@@ -1050,6 +1050,14 @@ static int soc_camera_probe(struct soc_camera_device *icd)
 	if (ret < 0)
 		goto ereg;
 
+	/* The camera could have been already on, try to reset */
+	if (icl->reset)
+		icl->reset(icd->pdev);
+
+	ret = ici->ops->add(icd);
+	if (ret < 0)
+		goto eadd;
+
 	/*
 	 * This will not yet call v4l2_subdev_core_ops::s_power(1), because the
 	 * subdevice has not been initialised yet. We'll have to call it once
@@ -1060,14 +1068,6 @@ static int soc_camera_probe(struct soc_camera_device *icd)
 	if (ret < 0)
 		goto epower;
 
-	/* The camera could have been already on, try to reset */
-	if (icl->reset)
-		icl->reset(icd->pdev);
-
-	ret = ici->ops->add(icd);
-	if (ret < 0)
-		goto eadd;
-
 	/* Must have icd->vdev before registering the device */
 	ret = video_dev_create(icd);
 	if (ret < 0)
@@ -1165,10 +1165,10 @@ eadddev:
 	video_device_release(icd->vdev);
 	icd->vdev = NULL;
 evdc:
-	ici->ops->remove(icd);
-eadd:
 	soc_camera_power_off(icd, icl);
 epower:
+	ici->ops->remove(icd);
+eadd:
 	regulator_bulk_free(icl->num_regulators, icl->regulators);
 ereg:
 	v4l2_ctrl_handler_free(&icd->ctrl_handler);
-- 
1.7.2.5

