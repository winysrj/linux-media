Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m6EC2xNt004756
	for <video4linux-list@redhat.com>; Mon, 14 Jul 2008 08:02:59 -0400
Received: from rv-out-0506.google.com (rv-out-0506.google.com [209.85.198.232])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m6EC23kt001382
	for <video4linux-list@redhat.com>; Mon, 14 Jul 2008 08:02:47 -0400
Received: by rv-out-0506.google.com with SMTP id f6so5596102rvb.51
	for <video4linux-list@redhat.com>; Mon, 14 Jul 2008 05:02:47 -0700 (PDT)
From: Magnus Damm <magnus.damm@gmail.com>
To: video4linux-list@redhat.com
Date: Mon, 14 Jul 2008 21:02:59 +0900
Message-Id: <20080714120259.4806.60521.sendpatchset@rx1.opensource.se>
In-Reply-To: <20080714120204.4806.87287.sendpatchset@rx1.opensource.se>
References: <20080714120204.4806.87287.sendpatchset@rx1.opensource.se>
Cc: paulius.zaleckas@teltonika.lt, linux-sh@vger.kernel.org,
	mchehab@infradead.org, lethal@linux-sh.org,
	akpm@linux-foundation.org, g.liakhovetski@gmx.de
Subject: [PATCH 06/06] soc_camera_platform: Add SoC Camera Platform driver
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

This patch adds a simple platform camera device. Useful for testing
cameras with SoC camera host drivers. Only one single pixel format
and resolution combination is supported.

Signed-off-by: Magnus Damm <damm@igel.co.jp>
---

 drivers/media/video/Kconfig               |    6 
 drivers/media/video/Makefile              |    1 
 drivers/media/video/soc_camera_platform.c |  198 +++++++++++++++++++++++++++++
 include/media/soc_camera_platform.h       |   15 ++
 4 files changed, 220 insertions(+)

--- 0011/drivers/media/video/Kconfig
+++ work/drivers/media/video/Kconfig	2008-07-14 20:31:16.000000000 +0900
@@ -950,6 +950,12 @@ config MT9V022_PCA9536_SWITCH
 	  Select this if your MT9V022 camera uses a PCA9536 I2C GPIO
 	  extender to switch between 8 and 10 bit datawidth modes
 
+config SOC_CAMERA_PLATFORM
+	tristate "platform camera support"
+	depends on SOC_CAMERA
+	help
+	  This is a generic SoC camera platform driver, useful for testing
+
 config VIDEO_PXA27x
 	tristate "PXA27x Quick Capture Interface driver"
 	depends on VIDEO_DEV && PXA27x
--- 0011/drivers/media/video/Makefile
+++ work/drivers/media/video/Makefile	2008-07-14 20:31:16.000000000 +0900
@@ -135,6 +135,7 @@ obj-$(CONFIG_VIDEO_SH_MOBILE_CEU)	+= sh_
 obj-$(CONFIG_SOC_CAMERA)	+= soc_camera.o
 obj-$(CONFIG_SOC_CAMERA_MT9M001)	+= mt9m001.o
 obj-$(CONFIG_SOC_CAMERA_MT9V022)	+= mt9v022.o
+obj-$(CONFIG_SOC_CAMERA_PLATFORM)	+= soc_camera_platform.o
 
 obj-$(CONFIG_VIDEO_AU0828) += au0828/
 
--- /dev/null
+++ work/drivers/media/video/soc_camera_platform.c	2008-07-14 20:32:06.000000000 +0900
@@ -0,0 +1,198 @@
+/*
+ * Generic Platform Camera Driver
+ *
+ * Copyright (C) 2008 Magnus Damm
+ * Based on mt9m001 driver,
+ * Copyright (C) 2008, Guennadi Liakhovetski <kernel@pengutronix.de>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/slab.h>
+#include <linux/delay.h>
+#include <linux/platform_device.h>
+#include <linux/videodev2.h>
+#include <media/v4l2-common.h>
+#include <media/soc_camera.h>
+
+struct soc_camera_platform_info {
+	int iface;
+	char *format_name;
+	unsigned long format_depth;
+	struct v4l2_pix_format format;
+	unsigned long bus_param;
+	int (*set_capture)(struct soc_camera_platform_info *info, int enable);
+};
+
+struct soc_camera_platform_priv {
+	struct soc_camera_platform_info *info;
+	struct soc_camera_device icd;
+	struct soc_camera_data_format format;
+};
+
+static struct soc_camera_platform_info *
+soc_camera_platform_get_info(struct soc_camera_device *icd)
+{
+	struct soc_camera_platform_priv *priv;
+	priv = container_of(icd, struct soc_camera_platform_priv, icd);
+	return priv->info;
+}
+
+static int soc_camera_platform_init(struct soc_camera_device *icd)
+{
+	return 0;
+}
+
+static int soc_camera_platform_release(struct soc_camera_device *icd)
+{
+	return 0;
+}
+
+static int soc_camera_platform_start_capture(struct soc_camera_device *icd)
+{
+	struct soc_camera_platform_info *p = soc_camera_platform_get_info(icd);
+	return p->set_capture(p, 1);
+}
+
+static int soc_camera_platform_stop_capture(struct soc_camera_device *icd)
+{
+	struct soc_camera_platform_info *p = soc_camera_platform_get_info(icd);
+	return p->set_capture(p, 0);
+}
+
+static int soc_camera_platform_set_bus_param(struct soc_camera_device *icd,
+					     unsigned long flags)
+{
+	return 0;
+}
+
+static unsigned long
+soc_camera_platform_query_bus_param(struct soc_camera_device *icd)
+{
+	struct soc_camera_platform_info *p = soc_camera_platform_get_info(icd);
+	return p->bus_param;
+}
+
+static int soc_camera_platform_set_fmt_cap(struct soc_camera_device *icd,
+					   __u32 pixfmt, struct v4l2_rect *rect)
+{
+	return 0;
+}
+
+static int soc_camera_platform_try_fmt_cap(struct soc_camera_device *icd,
+					   struct v4l2_format *f)
+{
+	struct soc_camera_platform_info *p = soc_camera_platform_get_info(icd);
+
+	f->fmt.pix.width = p->format.width;
+	f->fmt.pix.height = p->format.height;
+	return 0;
+}
+
+static int soc_camera_platform_video_probe(struct soc_camera_device *icd)
+{
+	struct soc_camera_platform_priv *priv;
+	priv = container_of(icd, struct soc_camera_platform_priv, icd);
+
+	priv->format.name = priv->info->format_name;
+	priv->format.depth = priv->info->format_depth;
+	priv->format.fourcc = priv->info->format.pixelformat;
+	priv->format.colorspace = priv->info->format.colorspace;
+
+	icd->formats = &priv->format;
+	icd->num_formats = 1;
+
+	return soc_camera_video_start(icd);
+}
+
+static void soc_camera_platform_video_remove(struct soc_camera_device *icd)
+{
+	soc_camera_video_stop(icd);
+}
+
+static struct soc_camera_ops soc_camera_platform_ops = {
+	.owner			= THIS_MODULE,
+	.probe			= soc_camera_platform_video_probe,
+	.remove			= soc_camera_platform_video_remove,
+	.init			= soc_camera_platform_init,
+	.release		= soc_camera_platform_release,
+	.start_capture		= soc_camera_platform_start_capture,
+	.stop_capture		= soc_camera_platform_stop_capture,
+	.set_fmt_cap		= soc_camera_platform_set_fmt_cap,
+	.try_fmt_cap		= soc_camera_platform_try_fmt_cap,
+	.set_bus_param		= soc_camera_platform_set_bus_param,
+	.query_bus_param	= soc_camera_platform_query_bus_param,
+};
+
+static int soc_camera_platform_probe(struct platform_device *pdev)
+{
+	struct soc_camera_platform_priv *priv;
+	struct soc_camera_platform_info *p;
+	struct soc_camera_device *icd;
+	int ret;
+
+	p = pdev->dev.platform_data;
+	if (!p)
+		return -EINVAL;
+
+	priv = kzalloc(sizeof(*priv), GFP_KERNEL);
+	if (!priv)
+		return -ENOMEM;
+
+	priv->info = p;
+	platform_set_drvdata(pdev, priv);
+
+	icd = &priv->icd;
+	icd->ops	= &soc_camera_platform_ops;
+	icd->control	= &pdev->dev;
+	icd->width_min	= 0;
+	icd->width_max	= priv->info->format.width;
+	icd->height_min	= 0;
+	icd->height_max	= priv->info->format.height;
+	icd->y_skip_top	= 0;
+	icd->iface	= priv->info->iface;
+
+	ret = soc_camera_device_register(icd);
+	if (ret)
+		kfree(priv);
+
+	return ret;
+}
+
+static int soc_camera_platform_remove(struct platform_device *pdev)
+{
+	struct soc_camera_platform_priv *priv = platform_get_drvdata(pdev);
+
+	soc_camera_device_unregister(&priv->icd);
+	kfree(priv);
+	return 0;
+}
+
+static struct platform_driver soc_camera_platform_driver = {
+	.driver 	= {
+		.name	= "soc_camera_platform",
+	},
+	.probe		= soc_camera_platform_probe,
+	.remove		= soc_camera_platform_remove,
+};
+
+static int __init soc_camera_platform_module_init(void)
+{
+	return platform_driver_register(&soc_camera_platform_driver);
+}
+
+static void __exit soc_camera_platform_module_exit(void)
+{
+	return platform_driver_unregister(&soc_camera_platform_driver);
+}
+
+module_init(soc_camera_platform_module_init);
+module_exit(soc_camera_platform_module_exit);
+
+MODULE_DESCRIPTION("SoC Camera Platform driver");
+MODULE_AUTHOR("Magnus Damm");
+MODULE_LICENSE("GPL v2");
--- /dev/null
+++ work/include/media/soc_camera_platform.h	2008-07-14 20:31:16.000000000 +0900
@@ -0,0 +1,15 @@
+#ifndef __SOC_CAMERA_H__
+#define __SOC_CAMERA_H__
+
+#include <linux/videodev2.h>
+
+struct soc_camera_platform_info {
+	int iface;
+	char *format_name;
+	unsigned long format_depth;
+	struct v4l2_pix_format format;
+	unsigned long bus_param;
+	int (*set_capture)(struct soc_camera_platform_info *info, int enable);
+};
+
+#endif /* __SOC_CAMERA_H__ */

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
