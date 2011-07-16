Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.9]:64733 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750934Ab1GPAN7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 15 Jul 2011 20:13:59 -0400
Received: from localhost (localhost [127.0.0.1])
	by axis700.grange (Postfix) with ESMTP id 7C27A189B6D
	for <linux-media@vger.kernel.org>; Sat, 16 Jul 2011 02:13:58 +0200 (CEST)
Date: Sat, 16 Jul 2011 02:13:58 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 5/6] V4L: soc-camera: un-export the soc-camera bus
In-Reply-To: <Pine.LNX.4.64.1107160135500.27399@axis700.grange>
Message-ID: <Pine.LNX.4.64.1107160209080.27399@axis700.grange>
References: <Pine.LNX.4.64.1107160135500.27399@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The soc-camera bus is now completely local again.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---
 drivers/media/video/soc_camera.c |    3 +--
 include/media/soc_camera.h       |    8 +++-----
 2 files changed, 4 insertions(+), 7 deletions(-)

diff --git a/drivers/media/video/soc_camera.c b/drivers/media/video/soc_camera.c
index 96bed29..0df31b5 100644
--- a/drivers/media/video/soc_camera.c
+++ b/drivers/media/video/soc_camera.c
@@ -1207,12 +1207,11 @@ static int soc_camera_remove(struct device *dev)
 	return 0;
 }
 
-struct bus_type soc_camera_bus_type = {
+static struct bus_type soc_camera_bus_type = {
 	.name		= "soc-camera",
 	.probe		= soc_camera_probe,
 	.remove		= soc_camera_remove,
 };
-EXPORT_SYMBOL_GPL(soc_camera_bus_type);
 
 static struct device_driver ic_drv = {
 	.name	= "camera",
diff --git a/include/media/soc_camera.h b/include/media/soc_camera.h
index 70c4ea5..c31d55b 100644
--- a/include/media/soc_camera.h
+++ b/include/media/soc_camera.h
@@ -20,12 +20,10 @@
 #include <media/videobuf2-core.h>
 #include <media/v4l2-device.h>
 
-extern struct bus_type soc_camera_bus_type;
-
 struct file;
 
 struct soc_camera_device {
-	struct list_head list;
+	struct list_head list;		/* list of all registered devices */
 	struct device dev;
 	struct device *pdev;		/* Platform device */
 	s32 user_width;
@@ -126,8 +124,8 @@ struct soc_camera_link {
 	int num_regulators;
 
 	/*
-	 * For non-I2C devices platform platform has to provide methods to
-	 * add a device to the system and to remove
+	 * For non-I2C devices platform has to provide methods to add a device
+	 * to the system and to remove it
 	 */
 	int (*add_device)(struct soc_camera_link *, struct device *);
 	void (*del_device)(struct soc_camera_link *);
-- 
1.7.2.5

