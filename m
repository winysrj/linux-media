Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout-de.gmx.net ([213.165.64.23]:48830 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1753477Ab0GZQUl (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 26 Jul 2010 12:20:41 -0400
Date: Mon, 26 Jul 2010 18:20:58 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
cc: "linux-sh@vger.kernel.org" <linux-sh@vger.kernel.org>
Subject: [PATCH 3/5] V4L2: soc-camera: export soc-camera bus type for
 notifications
In-Reply-To: <Pine.LNX.4.64.1007261739180.9816@axis700.grange>
Message-ID: <Pine.LNX.4.64.1007261749500.9816@axis700.grange>
References: <Pine.LNX.4.64.1007261739180.9816@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---
 drivers/media/video/soc_camera.c |    3 ++-
 include/media/soc_camera.h       |    3 +++
 2 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/drivers/media/video/soc_camera.c b/drivers/media/video/soc_camera.c
index 475757b..f203293 100644
--- a/drivers/media/video/soc_camera.c
+++ b/drivers/media/video/soc_camera.c
@@ -1107,13 +1107,14 @@ static int soc_camera_resume(struct device *dev)
 	return ret;
 }
 
-static struct bus_type soc_camera_bus_type = {
+struct bus_type soc_camera_bus_type = {
 	.name		= "soc-camera",
 	.probe		= soc_camera_probe,
 	.remove		= soc_camera_remove,
 	.suspend	= soc_camera_suspend,
 	.resume		= soc_camera_resume,
 };
+EXPORT_SYMBOL_GPL(soc_camera_bus_type);
 
 static struct device_driver ic_drv = {
 	.name	= "camera",
diff --git a/include/media/soc_camera.h b/include/media/soc_camera.h
index b8289c2..2ce9573 100644
--- a/include/media/soc_camera.h
+++ b/include/media/soc_camera.h
@@ -12,12 +12,15 @@
 #ifndef SOC_CAMERA_H
 #define SOC_CAMERA_H
 
+#include <linux/device.h>
 #include <linux/mutex.h>
 #include <linux/pm.h>
 #include <linux/videodev2.h>
 #include <media/videobuf-core.h>
 #include <media/v4l2-device.h>
 
+extern struct bus_type soc_camera_bus_type;
+
 struct soc_camera_device {
 	struct list_head list;
 	struct device dev;
-- 
1.6.2.4

