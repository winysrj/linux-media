Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.186]:61770 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756386Ab1IGQTL (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 7 Sep 2011 12:19:11 -0400
Received: from localhost (localhost [127.0.0.1])
	by axis700.grange (Postfix) with ESMTP id 56D1518B03B
	for <linux-media@vger.kernel.org>; Wed,  7 Sep 2011 17:13:11 +0200 (CEST)
Date: Wed, 7 Sep 2011 17:13:11 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 2/2] V4L: soc-camera: call subdevice .s_power() method, when
 powering up or down
In-Reply-To: <Pine.LNX.4.64.1109071706550.14818@axis700.grange>
Message-ID: <Pine.LNX.4.64.1109071712290.14818@axis700.grange>
References: <Pine.LNX.4.64.1109071706550.14818@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Currently soc-camera can use power regulators and platform specific
methods to power clients up and down. Additionally, client drivers can
provide their own subdevice .s_power() methods, acting directly on the
device. This patch adds calls to this method, when external power
supplies are on.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---
 drivers/media/video/soc_camera.c |   38 ++++++++++++++++++++++++++++++++++----
 1 files changed, 34 insertions(+), 4 deletions(-)

diff --git a/drivers/media/video/soc_camera.c b/drivers/media/video/soc_camera.c
index de374da..5656b27 100644
--- a/drivers/media/video/soc_camera.c
+++ b/drivers/media/video/soc_camera.c
@@ -67,19 +67,36 @@ static int soc_camera_power_on(struct soc_camera_device *icd,
 		if (ret < 0) {
 			dev_err(icd->pdev,
 				"Platform failed to power-on the camera.\n");
-
-			regulator_bulk_disable(icl->num_regulators,
-					       icl->regulators);
+			goto elinkpwr;
 		}
 	}
 
+	if (!ret) {
+		struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
+		ret = v4l2_subdev_call(sd, core, s_power, 1);
+		if (ret < 0 && ret != -ENOIOCTLCMD && ret != -ENODEV)
+			goto esdpwr;
+	}
+
+	return 0;
+
+esdpwr:
+	if (icl->power)
+		icl->power(icd->pdev, 0);
+elinkpwr:
+	regulator_bulk_disable(icl->num_regulators,
+			       icl->regulators);
 	return ret;
 }
 
 static int soc_camera_power_off(struct soc_camera_device *icd,
 				struct soc_camera_link *icl)
 {
-	int ret;
+	struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
+	int ret = v4l2_subdev_call(sd, core, s_power, 0);
+
+	if (ret < 0 && ret != -ENOIOCTLCMD && ret != -ENODEV)
+		return ret;
 
 	if (icl->power) {
 		ret = icl->power(icd->pdev, 0);
@@ -1089,6 +1106,12 @@ static int soc_camera_probe(struct soc_camera_device *icd)
 	if (ret < 0)
 		goto ereg;
 
+	/*
+	 * This will not yet call v4l2_subdev_core_ops::s_power(1), because the
+	 * the subdevice has not yet been initialised. We'll have to call it
+	 * once again after initialisation, even though it shouldn't be needed,
+	 * we don't do any IO here.
+	 */
 	ret = soc_camera_power_on(icd, icl);
 	if (ret < 0)
 		goto epower;
@@ -1156,6 +1179,10 @@ static int soc_camera_probe(struct soc_camera_device *icd)
 	if (ret < 0)
 		goto evidstart;
 
+	ret = v4l2_subdev_call(sd, core, s_power, 1);
+	if (ret < 0 && ret != -ENOIOCTLCMD)
+		goto esdpwr;
+
 	/* Try to improve our guess of a reasonable window format */
 	if (!v4l2_subdev_call(sd, video, g_mbus_fmt, &mf)) {
 		icd->user_width		= mf.width;
@@ -1172,6 +1199,8 @@ static int soc_camera_probe(struct soc_camera_device *icd)
 
 	return 0;
 
+esdpwr:
+	video_unregister_device(icd->vdev);
 evidstart:
 	mutex_unlock(&icd->video_lock);
 	soc_camera_free_user_formats(icd);
@@ -1185,6 +1214,7 @@ eiufmt:
 enodrv:
 eadddev:
 	video_device_release(icd->vdev);
+	icd->vdev = NULL;
 evdc:
 	ici->ops->remove(icd);
 eadd:
-- 
1.7.2.5

