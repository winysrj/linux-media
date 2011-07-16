Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.187]:60108 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750934Ab1GPANq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 15 Jul 2011 20:13:46 -0400
Received: from localhost (localhost [127.0.0.1])
	by axis700.grange (Postfix) with ESMTP id 397C7189B6D
	for <linux-media@vger.kernel.org>; Sat, 16 Jul 2011 02:13:45 +0200 (CEST)
Date: Sat, 16 Jul 2011 02:13:45 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 2/6] V4L: soc-camera: remove now unused soc-camera specific
 PM hooks
In-Reply-To: <Pine.LNX.4.64.1107160135500.27399@axis700.grange>
Message-ID: <Pine.LNX.4.64.1107160202390.27399@axis700.grange>
References: <Pine.LNX.4.64.1107160135500.27399@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

soc-camera host drivers shall be implementing their PM, using standard
kernel methods, soc-camera specific hooks can die.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---
 drivers/media/video/soc_camera.c |   26 --------------------------
 include/media/soc_camera.h       |    2 --
 2 files changed, 0 insertions(+), 28 deletions(-)

diff --git a/drivers/media/video/soc_camera.c b/drivers/media/video/soc_camera.c
index 136326e..5084e72 100644
--- a/drivers/media/video/soc_camera.c
+++ b/drivers/media/video/soc_camera.c
@@ -1209,36 +1209,10 @@ static int soc_camera_remove(struct device *dev)
 	return 0;
 }
 
-static int soc_camera_suspend(struct device *dev, pm_message_t state)
-{
-	struct soc_camera_device *icd = to_soc_camera_dev(dev);
-	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
-	int ret = 0;
-
-	if (ici->ops->suspend)
-		ret = ici->ops->suspend(icd, state);
-
-	return ret;
-}
-
-static int soc_camera_resume(struct device *dev)
-{
-	struct soc_camera_device *icd = to_soc_camera_dev(dev);
-	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
-	int ret = 0;
-
-	if (ici->ops->resume)
-		ret = ici->ops->resume(icd);
-
-	return ret;
-}
-
 struct bus_type soc_camera_bus_type = {
 	.name		= "soc-camera",
 	.probe		= soc_camera_probe,
 	.remove		= soc_camera_remove,
-	.suspend	= soc_camera_suspend,
-	.resume		= soc_camera_resume,
 };
 EXPORT_SYMBOL_GPL(soc_camera_bus_type);
 
diff --git a/include/media/soc_camera.h b/include/media/soc_camera.h
index 21dd8a4..70c4ea5 100644
--- a/include/media/soc_camera.h
+++ b/include/media/soc_camera.h
@@ -66,8 +66,6 @@ struct soc_camera_host_ops {
 	struct module *owner;
 	int (*add)(struct soc_camera_device *);
 	void (*remove)(struct soc_camera_device *);
-	int (*suspend)(struct soc_camera_device *, pm_message_t);
-	int (*resume)(struct soc_camera_device *);
 	/*
 	 * .get_formats() is called for each client device format, but
 	 * .put_formats() is only called once. Further, if any of the calls to
-- 
1.7.2.5

