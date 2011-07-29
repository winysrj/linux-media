Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.9]:52195 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756308Ab1G2K5G (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 29 Jul 2011 06:57:06 -0400
Received: from 6a.grange (6a.grange [192.168.1.11])
	by axis700.grange (Postfix) with ESMTPS id 72C3118B048
	for <linux-media@vger.kernel.org>; Fri, 29 Jul 2011 12:57:02 +0200 (CEST)
Received: from lyakh by 6a.grange with local (Exim 4.72)
	(envelope-from <g.liakhovetski@gmx.de>)
	id 1QmkkY-0007pk-BY
	for linux-media@vger.kernel.org; Fri, 29 Jul 2011 12:57:02 +0200
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: linux-media@vger.kernel.org
Subject: [PATCH 57/59] V4L: soc_camera_platform: remove superfluous soc-camera client operations
Date: Fri, 29 Jul 2011 12:56:57 +0200
Message-Id: <1311937019-29914-58-git-send-email-g.liakhovetski@gmx.de>
In-Reply-To: <1311937019-29914-1-git-send-email-g.liakhovetski@gmx.de>
References: <1311937019-29914-1-git-send-email-g.liakhovetski@gmx.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Now that all soc-camera hosts have been ported to use V4L2 subdevice
mediabus-config operations and soc-camera client bus-parameter operations
have been made optional, they can be removed.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---
 drivers/media/video/soc_camera_platform.c |   31 +----------------------------
 include/media/soc_camera_platform.h       |    1 -
 2 files changed, 1 insertions(+), 31 deletions(-)

diff --git a/drivers/media/video/soc_camera_platform.c b/drivers/media/video/soc_camera_platform.c
index 7045e45..f5ebe59 100644
--- a/drivers/media/video/soc_camera_platform.c
+++ b/drivers/media/video/soc_camera_platform.c
@@ -30,32 +30,12 @@ static struct soc_camera_platform_priv *get_priv(struct platform_device *pdev)
 	return container_of(subdev, struct soc_camera_platform_priv, subdev);
 }
 
-static struct soc_camera_platform_info *get_info(struct soc_camera_device *icd)
-{
-	struct platform_device *pdev =
-		to_platform_device(to_soc_camera_control(icd));
-	return pdev->dev.platform_data;
-}
-
 static int soc_camera_platform_s_stream(struct v4l2_subdev *sd, int enable)
 {
 	struct soc_camera_platform_info *p = v4l2_get_subdevdata(sd);
 	return p->set_capture(p, enable);
 }
 
-static int soc_camera_platform_set_bus_param(struct soc_camera_device *icd,
-					     unsigned long flags)
-{
-	return 0;
-}
-
-static unsigned long
-soc_camera_platform_query_bus_param(struct soc_camera_device *icd)
-{
-	struct soc_camera_platform_info *p = get_info(icd);
-	return p->bus_param;
-}
-
 static int soc_camera_platform_fill_fmt(struct v4l2_subdev *sd,
 					struct v4l2_mbus_framefmt *mf)
 {
@@ -142,11 +122,6 @@ static struct v4l2_subdev_ops platform_subdev_ops = {
 	.video	= &platform_subdev_video_ops,
 };
 
-static struct soc_camera_ops soc_camera_platform_ops = {
-	.set_bus_param		= soc_camera_platform_set_bus_param,
-	.query_bus_param	= soc_camera_platform_query_bus_param,
-};
-
 static int soc_camera_platform_probe(struct platform_device *pdev)
 {
 	struct soc_camera_host *ici;
@@ -175,7 +150,7 @@ static int soc_camera_platform_probe(struct platform_device *pdev)
 	/* Set the control device reference */
 	icd->control = &pdev->dev;
 
-	icd->ops = &soc_camera_platform_ops;
+	icd->ops = NULL;
 
 	ici = to_soc_camera_host(icd->parent);
 
@@ -190,7 +165,6 @@ static int soc_camera_platform_probe(struct platform_device *pdev)
 	return ret;
 
 evdrs:
-	icd->ops = NULL;
 	platform_set_drvdata(pdev, NULL);
 	kfree(priv);
 	return ret;
@@ -199,11 +173,8 @@ evdrs:
 static int soc_camera_platform_remove(struct platform_device *pdev)
 {
 	struct soc_camera_platform_priv *priv = get_priv(pdev);
-	struct soc_camera_platform_info *p = pdev->dev.platform_data;
-	struct soc_camera_device *icd = p->icd;
 
 	v4l2_device_unregister_subdev(&priv->subdev);
-	icd->ops = NULL;
 	platform_set_drvdata(pdev, NULL);
 	kfree(priv);
 	return 0;
diff --git a/include/media/soc_camera_platform.h b/include/media/soc_camera_platform.h
index a15f92b..8aa4200 100644
--- a/include/media/soc_camera_platform.h
+++ b/include/media/soc_camera_platform.h
@@ -21,7 +21,6 @@ struct soc_camera_platform_info {
 	const char *format_name;
 	unsigned long format_depth;
 	struct v4l2_mbus_framefmt format;
-	unsigned long bus_param;
 	unsigned long mbus_param;
 	enum v4l2_mbus_type mbus_type;
 	struct soc_camera_device *icd;
-- 
1.7.2.5

