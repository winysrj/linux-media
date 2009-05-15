Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:60927 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752740AbZEORSm (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 15 May 2009 13:18:42 -0400
Date: Fri, 15 May 2009 19:18:55 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Magnus Damm <magnus.damm@gmail.com>,
	Robert Jarzmik <robert.jarzmik@free.fr>,
	Darius Augulis <augulis.darius@gmail.com>,
	Paul Mundt <lethal@linux-sh.org>
Subject: [PATCH 01/10 v2] soc-camera: prepare soc_camera_platform.c and its
 users for conversion
In-Reply-To: <Pine.LNX.4.64.0905151817070.4658@axis700.grange>
Message-ID: <Pine.LNX.4.64.0905151822390.4658@axis700.grange>
References: <Pine.LNX.4.64.0905151817070.4658@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

soc_camera_platform.c is only used by y SuperH ap325rxa board. This patch
converts soc_camera_platform.c and its users for the soc-camera platform-
device conversion and also extends soc-camera core to handle non-I2C cameras.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---

Paul, may I pull this one over v4l? These patches only touch video 
functionality. Then I would need your ack.

 arch/sh/boards/board-ap325rxa.c     |   43 ++++++++++++++++++------
 drivers/media/video/soc_camera.c    |   61 ++++++++++++++++++++++++++--------
 include/media/soc_camera.h          |    6 +++
 include/media/soc_camera_platform.h |    2 +
 4 files changed, 86 insertions(+), 26 deletions(-)

diff --git a/arch/sh/boards/board-ap325rxa.c b/arch/sh/boards/board-ap325rxa.c
index cd1fcc0..0a5f97b 100644
--- a/arch/sh/boards/board-ap325rxa.c
+++ b/arch/sh/boards/board-ap325rxa.c
@@ -304,6 +304,9 @@ static int camera_set_capture(struct soc_camera_platform_info *info,
 	return ret;
 }
 
+static int ap325rxa_camera_add(struct soc_camera_link *icl, struct device *dev);
+static void ap325rxa_camera_del(struct soc_camera_link *icl);
+
 static struct soc_camera_platform_info camera_info = {
 	.iface = 0,
 	.format_name = "UYVY",
@@ -317,6 +320,10 @@ static struct soc_camera_platform_info camera_info = {
 	.bus_param = SOCAM_PCLK_SAMPLE_RISING | SOCAM_HSYNC_ACTIVE_HIGH |
 	SOCAM_VSYNC_ACTIVE_HIGH | SOCAM_MASTER | SOCAM_DATAWIDTH_8,
 	.set_capture = camera_set_capture,
+	.link = {
+		.add_device	= ap325rxa_camera_add,
+		.del_device	= ap325rxa_camera_del,
+	},
 };
 
 static struct platform_device camera_device = {
@@ -326,15 +333,20 @@ static struct platform_device camera_device = {
 	},
 };
 
-static int __init camera_setup(void)
+static int ap325rxa_camera_add(struct soc_camera_link *icl,
+			       struct device *dev)
 {
-	if (camera_probe() > 0)
-		platform_device_register(&camera_device);
+	if (icl != &camera_info.link || camera_probe() <= 0)
+		return -ENODEV;
 
-	return 0;
+	return platform_device_register(&camera_device);
 }
-late_initcall(camera_setup);
 
+static void ap325rxa_camera_del(struct soc_camera_link *icl)
+{
+	if (icl == &camera_info.link)
+		platform_device_unregister(&camera_device);
+}
 #endif /* CONFIG_I2C */
 
 static int ov7725_power(struct device *dev, int mode)
@@ -414,11 +426,19 @@ static struct ov772x_camera_info ov7725_info = {
 	},
 };
 
-static struct platform_device ap325rxa_camera = {
-	.name	= "soc-camera-pdrv",
-	.id	= 0,
-	.dev	= {
-		.platform_data = &ov7725_info.link,
+static struct platform_device ap325rxa_camera[] = {
+	{
+		.name	= "soc-camera-pdrv",
+		.id	= 0,
+		.dev	= {
+			.platform_data = &ov7725_info.link,
+		},
+	}, {
+		.name	= "soc-camera-pdrv",
+		.id	= 1,
+		.dev	= {
+			.platform_data = &camera_info.link,
+		},
 	},
 };
 
@@ -429,7 +449,8 @@ static struct platform_device *ap325rxa_devices[] __initdata = {
 	&ceu_device,
 	&nand_flash_device,
 	&sdcard_cn3_device,
-	&ap325rxa_camera,
+	&ap325rxa_camera[0],
+	&ap325rxa_camera[1],
 };
 
 static struct spi_board_info ap325rxa_spi_devices[] = {
diff --git a/drivers/media/video/soc_camera.c b/drivers/media/video/soc_camera.c
index 2014e9e..6fae6c6 100644
--- a/drivers/media/video/soc_camera.c
+++ b/drivers/media/video/soc_camera.c
@@ -1161,45 +1161,76 @@ void soc_camera_video_stop(struct soc_camera_device *icd)
 }
 EXPORT_SYMBOL(soc_camera_video_stop);
 
-static int __devinit soc_camera_pdrv_probe(struct platform_device *pdev)
+#ifdef CONFIG_I2C_BOARDINFO
+static int soc_camera_init_i2c(struct platform_device *pdev,
+			       struct soc_camera_link *icl)
 {
-	struct soc_camera_link *icl = pdev->dev.platform_data;
-	struct i2c_adapter *adap;
 	struct i2c_client *client;
+	struct i2c_adapter *adap = i2c_get_adapter(icl->i2c_adapter_id);
+	int ret;
 
-	if (!icl)
-		return -EINVAL;
-
-	adap = i2c_get_adapter(icl->i2c_adapter_id);
 	if (!adap) {
-		dev_warn(&pdev->dev, "Cannot get adapter #%d. No driver?\n",
-			 icl->i2c_adapter_id);
-		/* -ENODEV and -ENXIO do not produce an error on probe()... */
-		return -ENOENT;
+		ret = -ENODEV;
+		dev_err(&pdev->dev, "Cannot get adapter #%d. No driver?\n",
+			icl->i2c_adapter_id);
+		goto ei2cga;
 	}
 
 	icl->board_info->platform_data = icl;
 	client = i2c_new_device(adap, icl->board_info);
 	if (!client) {
-		i2c_put_adapter(adap);
-		return -ENOMEM;
+		ret = -ENOMEM;
+		goto ei2cnd;
 	}
 
 	platform_set_drvdata(pdev, client);
 
 	return 0;
+ei2cnd:
+	i2c_put_adapter(adap);
+ei2cga:
+	return ret;
 }
 
-static int __devexit soc_camera_pdrv_remove(struct platform_device *pdev)
+static void soc_camera_free_i2c(struct platform_device *pdev)
 {
 	struct i2c_client *client = platform_get_drvdata(pdev);
 
 	if (!client)
-		return -ENODEV;
+		return;
 
 	i2c_unregister_device(client);
 	i2c_put_adapter(client->adapter);
+}
+#else
+#define soc_camera_init_i2c(d, icl)	(-ENODEV)
+#define soc_camera_free_i2c(d)		do {} while (0)
+#endif
 
+static int __devinit soc_camera_pdrv_probe(struct platform_device *pdev)
+{
+	struct soc_camera_link *icl = pdev->dev.platform_data;
+
+	if (!icl)
+		return -EINVAL;
+
+	if (icl->board_info)
+		return soc_camera_init_i2c(pdev, icl);
+	else if (!icl->add_device || !icl->del_device)
+		return -EINVAL;
+
+	/* &pdev->dev will become &icd->dev */
+	return icl->add_device(icl, &pdev->dev);
+}
+
+static int __devexit soc_camera_pdrv_remove(struct platform_device *pdev)
+{
+	struct soc_camera_link *icl = pdev->dev.platform_data;
+
+	if (icl->board_info)
+		soc_camera_free_i2c(pdev);
+	else
+		icl->del_device(icl);
 	return 0;
 }
 
diff --git a/include/media/soc_camera.h b/include/media/soc_camera.h
index 23ecead..813e120 100644
--- a/include/media/soc_camera.h
+++ b/include/media/soc_camera.h
@@ -102,6 +102,12 @@ struct soc_camera_link {
 	int i2c_adapter_id;
 	struct i2c_board_info *board_info;
 	const char *module_name;
+	/*
+	 * For non-I2C devices platform platform has to provide methods to
+	 * add a device to the system and to remove
+	 */
+	int (*add_device)(struct soc_camera_link *, struct device *);
+	void (*del_device)(struct soc_camera_link *);
 	/* Optional callbacks to power on or off and reset the sensor */
 	int (*power)(struct device *, int);
 	int (*reset)(struct device *);
diff --git a/include/media/soc_camera_platform.h b/include/media/soc_camera_platform.h
index 1d092b4..af224de 100644
--- a/include/media/soc_camera_platform.h
+++ b/include/media/soc_camera_platform.h
@@ -12,6 +12,7 @@
 #define __SOC_CAMERA_H__
 
 #include <linux/videodev2.h>
+#include <media/soc_camera.h>
 
 struct soc_camera_platform_info {
 	int iface;
@@ -21,6 +22,7 @@ struct soc_camera_platform_info {
 	unsigned long bus_param;
 	void (*power)(int);
 	int (*set_capture)(struct soc_camera_platform_info *info, int enable);
+	struct soc_camera_link link;
 };
 
 #endif /* __SOC_CAMERA_H__ */
-- 
1.6.2.4

