Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:59184 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753864AbZKHOJO (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 8 Nov 2009 09:09:14 -0500
Received: from lyakh (helo=localhost)
	by axis700.grange with local-esmtp (Exim 4.63)
	(envelope-from <g.liakhovetski@gmx.de>)
	id 1N78SX-000633-8V
	for linux-media@vger.kernel.org; Sun, 08 Nov 2009 15:09:37 +0100
Date: Sun, 8 Nov 2009 15:09:37 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH] soc-camera: properly initialise the device object when
 reusing
Message-ID: <Pine.LNX.4.64.0911081508400.19545@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Commit ef373189f62413803b7b816c972fc154c488cdc0 "fix use-after-free Oops,
resulting from a driver-core API change" fixed the Oops, but didn't correct
missing device object initialisation. This patch makes unloading and reloading
of soc-camera host- and client-drivers possible again.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---

This is the second of the two patches, that I'm going to push upstream for 
2.6.32 inclusion.

 drivers/media/video/soc_camera.c |   17 ++++++++++++-----
 1 files changed, 12 insertions(+), 5 deletions(-)

diff --git a/drivers/media/video/soc_camera.c b/drivers/media/video/soc_camera.c
index 36e617b..95fdeb2 100644
--- a/drivers/media/video/soc_camera.c
+++ b/drivers/media/video/soc_camera.c
@@ -1097,6 +1097,13 @@ static int default_s_crop(struct soc_camera_device *icd, struct v4l2_crop *a)
 	return v4l2_subdev_call(sd, video, s_crop, a);
 }
 
+static void soc_camera_device_init(struct device *dev, void *pdata)
+{
+	dev->platform_data	= pdata;
+	dev->bus		= &soc_camera_bus_type;
+	dev->release		= dummy_release;
+}
+
 int soc_camera_host_register(struct soc_camera_host *ici)
 {
 	struct soc_camera_host *ix;
@@ -1158,6 +1165,7 @@ void soc_camera_host_unregister(struct soc_camera_host *ici)
 
 	list_for_each_entry(icd, &devices, list) {
 		if (icd->iface == ici->nr) {
+			void *pdata = icd->dev.platform_data;
 			/* The bus->remove will be called */
 			device_unregister(&icd->dev);
 			/*
@@ -1169,6 +1177,7 @@ void soc_camera_host_unregister(struct soc_camera_host *ici)
 			 * device private data.
 			 */
 			memset(&icd->dev, 0, sizeof(icd->dev));
+			soc_camera_device_init(&icd->dev, pdata);
 		}
 	}
 
@@ -1200,10 +1209,7 @@ static int soc_camera_device_register(struct soc_camera_device *icd)
 		 * man, stay reasonable... */
 		return -ENOMEM;
 
-	icd->devnum = num;
-	icd->dev.bus = &soc_camera_bus_type;
-
-	icd->dev.release	= dummy_release;
+	icd->devnum		= num;
 	icd->use_count		= 0;
 	icd->host_priv		= NULL;
 	mutex_init(&icd->video_lock);
@@ -1311,12 +1317,13 @@ static int __devinit soc_camera_pdrv_probe(struct platform_device *pdev)
 	icd->iface = icl->bus_id;
 	icd->pdev = &pdev->dev;
 	platform_set_drvdata(pdev, icd);
-	icd->dev.platform_data = icl;
 
 	ret = soc_camera_device_register(icd);
 	if (ret < 0)
 		goto escdevreg;
 
+	soc_camera_device_init(&icd->dev, icl);
+
 	icd->user_width		= DEFAULT_WIDTH;
 	icd->user_height	= DEFAULT_HEIGHT;
 
-- 
1.6.2.4

