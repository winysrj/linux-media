Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:56385 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750952AbZDXQjf (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 24 Apr 2009 12:39:35 -0400
Date: Fri, 24 Apr 2009 18:39:47 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Robert Jarzmik <robert.jarzmik@free.fr>,
	Magnus Damm <magnus.damm@gmail.com>,
	Paul Mundt <lethal@linux-sh.org>
Subject: [PATCH 1/8] soc-camera: prepare for the platform driver conversion
In-Reply-To: <Pine.LNX.4.64.0904241818130.8309@axis700.grange>
Message-ID: <Pine.LNX.4.64.0904241829210.8309@axis700.grange>
References: <Pine.LNX.4.64.0904241818130.8309@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add a platform driver to soc_camera.c. This way we preserve backwards
compatibility with existing platforms and can start converting them one by one
to the new platform-device soc-camera interface.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---
 drivers/media/video/soc_camera.c |   71 +++++++++++++++++++++++++++++++++++---
 include/media/soc_camera.h       |    5 +++
 2 files changed, 71 insertions(+), 5 deletions(-)

diff --git a/drivers/media/video/soc_camera.c b/drivers/media/video/soc_camera.c
index 2d341f5..fecd7e7 100644
--- a/drivers/media/video/soc_camera.c
+++ b/drivers/media/video/soc_camera.c
@@ -16,19 +16,21 @@
  * published by the Free Software Foundation.
  */
 
-#include <linux/module.h>
-#include <linux/init.h>
 #include <linux/device.h>
-#include <linux/list.h>
 #include <linux/err.h>
+#include <linux/i2c.h>
+#include <linux/init.h>
+#include <linux/list.h>
+#include <linux/module.h>
 #include <linux/mutex.h>
+#include <linux/platform_device.h>
 #include <linux/vmalloc.h>
 
+#include <media/soc_camera.h>
 #include <media/v4l2-common.h>
-#include <media/v4l2-ioctl.h>
 #include <media/v4l2-dev.h>
+#include <media/v4l2-ioctl.h>
 #include <media/videobuf-core.h>
-#include <media/soc_camera.h>
 
 /* Default to VGA resolution */
 #define DEFAULT_WIDTH	640
@@ -1159,6 +1161,57 @@ void soc_camera_video_stop(struct soc_camera_device *icd)
 }
 EXPORT_SYMBOL(soc_camera_video_stop);
 
+static int __devinit soc_camera_pdrv_probe(struct platform_device *pdev)
+{
+	struct soc_camera_link *icl = pdev->dev.platform_data;
+	struct i2c_adapter *adap;
+	struct i2c_client *client;
+
+	if (!icl)
+		return -EINVAL;
+
+	adap = i2c_get_adapter(icl->i2c_adapter_id);
+	if (!adap) {
+		dev_warn(&pdev->dev, "Cannot get adapter #%d. No driver?\n",
+			 icl->i2c_adapter_id);
+		/* -ENODEV and -ENXIO do not produce an error on probe()... */
+		return -ENOENT;
+	}
+
+	icl->board_info->platform_data = icl;
+	client = i2c_new_device(adap, icl->board_info);
+	if (!client) {
+		i2c_put_adapter(adap);
+		return -ENOMEM;
+	}
+
+	platform_set_drvdata(pdev, client);
+
+	return 0;
+}
+
+static int __devexit soc_camera_pdrv_remove(struct platform_device *pdev)
+{
+	struct i2c_client *client = platform_get_drvdata(pdev);
+
+	if (!client)
+		return -ENODEV;
+
+	i2c_unregister_device(client);
+	i2c_put_adapter(client->adapter);
+
+	return 0;
+}
+
+static struct platform_driver soc_camera_pdrv = {
+	.probe	= soc_camera_pdrv_probe,
+	.remove	= __exit_p(soc_camera_pdrv_remove),
+	.driver	= {
+		.name = "soc-camera-pdrv",
+		.owner = THIS_MODULE,
+	},
+};
+
 static int __init soc_camera_init(void)
 {
 	int ret = bus_register(&soc_camera_bus_type);
@@ -1168,8 +1221,14 @@ static int __init soc_camera_init(void)
 	if (ret)
 		goto edrvr;
 
+	ret = platform_driver_register(&soc_camera_pdrv);
+	if (ret)
+		goto epdr;
+
 	return 0;
 
+epdr:
+	driver_unregister(&ic_drv);
 edrvr:
 	bus_unregister(&soc_camera_bus_type);
 	return ret;
@@ -1177,6 +1236,7 @@ edrvr:
 
 static void __exit soc_camera_exit(void)
 {
+	platform_driver_unregister(&soc_camera_pdrv);
 	driver_unregister(&ic_drv);
 	bus_unregister(&soc_camera_bus_type);
 }
@@ -1187,3 +1247,4 @@ module_exit(soc_camera_exit);
 MODULE_DESCRIPTION("Image capture bus driver");
 MODULE_AUTHOR("Guennadi Liakhovetski <kernel@pengutronix.de>");
 MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform:soc-camera-pdrv");
diff --git a/include/media/soc_camera.h b/include/media/soc_camera.h
index bef5e81..23ecead 100644
--- a/include/media/soc_camera.h
+++ b/include/media/soc_camera.h
@@ -92,11 +92,16 @@ struct soc_camera_host_ops {
 #define SOCAM_SENSOR_INVERT_VSYNC	(1 << 3)
 #define SOCAM_SENSOR_INVERT_DATA	(1 << 4)
 
+struct i2c_board_info;
+
 struct soc_camera_link {
 	/* Camera bus id, used to match a camera and a bus */
 	int bus_id;
 	/* Per camera SOCAM_SENSOR_* bus flags */
 	unsigned long flags;
+	int i2c_adapter_id;
+	struct i2c_board_info *board_info;
+	const char *module_name;
 	/* Optional callbacks to power on or off and reset the sensor */
 	int (*power)(struct device *, int);
 	int (*reset)(struct device *);
-- 
1.6.2.4

