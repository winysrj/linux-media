Return-path: <mchehab@pedra>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:39459 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754846Ab1DKM3n (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 11 Apr 2011 08:29:43 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Received: from eu_spt1 ([210.118.77.14]) by mailout4.w1.samsung.com
 (Sun Java(tm) System Messaging Server 6.3-8.04 (built Jul 29 2009; 32bit))
 with ESMTP id <0LJH005E9MPDXJ00@mailout4.w1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 11 Apr 2011 13:29:40 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt1.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LJH0087NMPBIJ@spt1.w1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 11 Apr 2011 13:29:37 +0100 (BST)
Date: Mon, 11 Apr 2011 14:29:24 +0200
From: Tomasz Stanislawski <t.stanislaws@samsung.com>
Subject: [PATCH 3/3] s5p-tv: add drivers for TV on EXYNOS4 platform
In-reply-to: <1302524964-31407-1-git-send-email-t.stanislaws@samsung.com>
To: linux-media@vger.kernel.org
Cc: m.szyprowski@samsung.com, t.stanislaws@samsung.com,
	kyungmin.park@samsung.com
Message-id: <1302524964-31407-4-git-send-email-t.stanislaws@samsung.com>
References: <1302524964-31407-1-git-send-email-t.stanislaws@samsung.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Signed-off-by: Tomasz Stanislawski <t.stanislaws@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
Reviewed-by: Marek Szyprowski <m.szyprowski@samsung.com>

stp-tv: mixer: add watchdog timer for stream stopping
s5p-tv: mixer: fix cleaning list for enqueued buffers during stream stop
s5p-tv: mixer: add new debugging api
s5p-tv: mixer: port to new debugging API
s5p-tv: hdmi: fix missing owner module for subdev
s5p-tv: integrate with Runtime Power Management
s5p-tv: hdmiphy: fixed configuration handling
s5p-tv: mixer: fix freed mem usage
s5p-tv: fix sequence of power setup
s5p-tv: fix Kconfig
s5p-tv: mixer: add support for SYSMMU
s5p-tv: mixer: fix sysmmu and power setup sequence
s5p-tv: mixer: fix premature start of VP streaming
s5p-tv: hdmi: fix pink line bug
s5p-tv: hdmi: add controll for clocks and regulators
s5p-tv: mixer: add control for clocks and regulators
s5p-tv: mixer: fix chroma distorions
s5p-tv: fix name of TV regulator to tv_core
s5p-tv: hdmi: force YUV422 on output
s5p-tv: hdmi: revision of preset configuration
s5p-tv: mixer: add S_OUTPUT
s5p-tv: mixer: add support for interlaced modes
s5p-tv: mixer: add support for S_STD
s5p-tv: mixer: fix power management
s5p-tv: mixer: force YUV444 mbus format
s5p-tv: mixer: remove useless setup of clock
s5p-tv: mixer: fix computation of plane size
s5p-tv: sdo: add support for Analog TV
s5p-tv: mixer: port to DMA-IOMMU allocator
s5p-tv: remove usage of platform data
s5p-tv: fix regulator management
---
 drivers/media/video/Kconfig                  |    8 +
 drivers/media/video/Makefile                 |    1 +
 drivers/media/video/s5p-tv/Kconfig           |   69 +
 drivers/media/video/s5p-tv/Makefile          |   17 +
 drivers/media/video/s5p-tv/hdmi.h            |   74 +
 drivers/media/video/s5p-tv/hdmi_drv.c        |  984 ++++++++++++++
 drivers/media/video/s5p-tv/hdmiphy_drv.c     |  247 ++++
 drivers/media/video/s5p-tv/mixer.h           |  329 +++++
 drivers/media/video/s5p-tv/mixer_drv.c       |  493 +++++++
 drivers/media/video/s5p-tv/mixer_grp_layer.c |  180 +++
 drivers/media/video/s5p-tv/mixer_reg.c       |  543 ++++++++
 drivers/media/video/s5p-tv/mixer_reg.h       |   45 +
 drivers/media/video/s5p-tv/mixer_video.c     |  937 +++++++++++++
 drivers/media/video/s5p-tv/mixer_vp_layer.c  |  207 +++
 drivers/media/video/s5p-tv/regs-hdmi.h       | 1849 ++++++++++++++++++++++++++
 drivers/media/video/s5p-tv/regs-sdo.h        |  453 +++++++
 drivers/media/video/s5p-tv/regs-vmx.h        |  197 +++
 drivers/media/video/s5p-tv/regs-vp.h         |  277 ++++
 drivers/media/video/s5p-tv/sdo_drv.c         |  538 ++++++++
 19 files changed, 7448 insertions(+), 0 deletions(-)
 create mode 100644 drivers/media/video/s5p-tv/Kconfig
 create mode 100644 drivers/media/video/s5p-tv/Makefile
 create mode 100644 drivers/media/video/s5p-tv/hdmi.h
 create mode 100644 drivers/media/video/s5p-tv/hdmi_drv.c
 create mode 100644 drivers/media/video/s5p-tv/hdmiphy_drv.c
 create mode 100644 drivers/media/video/s5p-tv/mixer.h
 create mode 100644 drivers/media/video/s5p-tv/mixer_drv.c
 create mode 100644 drivers/media/video/s5p-tv/mixer_grp_layer.c
 create mode 100644 drivers/media/video/s5p-tv/mixer_reg.c
 create mode 100644 drivers/media/video/s5p-tv/mixer_reg.h
 create mode 100644 drivers/media/video/s5p-tv/mixer_video.c
 create mode 100644 drivers/media/video/s5p-tv/mixer_vp_layer.c
 create mode 100644 drivers/media/video/s5p-tv/regs-hdmi.h
 create mode 100644 drivers/media/video/s5p-tv/regs-sdo.h
 create mode 100644 drivers/media/video/s5p-tv/regs-vmx.h
 create mode 100644 drivers/media/video/s5p-tv/regs-vp.h
 create mode 100644 drivers/media/video/s5p-tv/sdo_drv.c

diff --git a/drivers/media/video/Kconfig b/drivers/media/video/Kconfig
index 53e407e..ac5502c 100644
--- a/drivers/media/video/Kconfig
+++ b/drivers/media/video/Kconfig
@@ -1046,3 +1046,11 @@ config  VIDEO_SAMSUNG_S5P_FIMC
 	  (video postprocessor)
 
 endif # V4L_MEM2MEM_DRIVERS
+
+menuconfig VIDEO_SAMSUNG_S5P_TV
+	bool "Digital/analog TV output interfaces"
+	default y
+if VIDEO_SAMSUNG_S5P_TV
+source "drivers/media/video/s5p-tv/Kconfig"
+endif # VIDEO_SAMSUNG_S5P_TV
+
diff --git a/drivers/media/video/Makefile b/drivers/media/video/Makefile
index 2745c30..98b0932 100644
--- a/drivers/media/video/Makefile
+++ b/drivers/media/video/Makefile
@@ -167,6 +167,7 @@ obj-$(CONFIG_VIDEO_SH_MOBILE_CSI2)	+= sh_mobile_csi2.o
 obj-$(CONFIG_VIDEO_SH_MOBILE_CEU)	+= sh_mobile_ceu_camera.o
 obj-$(CONFIG_VIDEO_OMAP1)		+= omap1_camera.o
 obj-$(CONFIG_VIDEO_SAMSUNG_S5P_FIMC) 	+= s5p-fimc/
+obj-$(CONFIG_VIDEO_SAMSUNG_S5P_TV)	+= s5p-tv/
 
 obj-$(CONFIG_ARCH_DAVINCI)		+= davinci/
 
diff --git a/drivers/media/video/s5p-tv/Kconfig b/drivers/media/video/s5p-tv/Kconfig
new file mode 100644
index 0000000..4c5b3e3
--- /dev/null
+++ b/drivers/media/video/s5p-tv/Kconfig
@@ -0,0 +1,69 @@
+# drivers/media/video/samsung/tvout/Kconfig
+#
+# Copyright (c) 2010 Samsung Electronics Co., Ltd.
+#	http://www.samsung.com/
+# Tomasz Stanislawski <t.stanislaws@samsung.com>
+#
+# Licensed under GPLv2
+
+comment "HDMI output drivers"
+
+config VIDEO_SAMSUNG_S5P_HDMIPHY
+	tristate "Samsung HDMIPHY Driver"
+	depends on VIDEO_DEV && VIDEO_V4L2 && PLAT_S5P
+	default y
+	help
+	  Say Y here if you want support for the physical HDMI
+	  interface in S5P Samsung SoC. The driver can be compiled
+	  as module. It is an I2C driver, that produce a V4L2
+	  subdev for use by other drivers.
+
+config VIDEO_SAMSUNG_S5P_HDMI
+	tristate "Samsung HDMI Driver"
+	depends on VIDEO_SAMSUNG_S5P_HDMIPHY
+	help
+	  Say Y here if you want support for the HDMI
+	  interface in S5P Samsung SoC. The driver can be compiled
+	  as module. It is an auxliary driver, that produce a V4L2
+	  subdev for use by other drivers. This driver requires
+	  hdmiphy driver to work correctly.
+
+comment "Analog TV output drivers"
+
+config VIDEO_SAMSUNG_S5P_SDO
+	tristate "Samsung Analog TV Driver"
+	depends on VIDEO_DEV && VIDEO_V4L2 && PLAT_S5P
+	help
+	  Say Y here if you want support for the analog TV
+	  interface in S5P Samsung SoC. The driver can be compiled
+	  as module. It is an auxliary driver, that produce a V4L2
+	  subdev for use by other drivers. This driver requires
+	  hdmiphy driver to work correctly.
+
+comment "Mixer drivers"
+
+config VIDEO_SAMSUNG_S5P_MIXER
+	tristate "Samsung Mixer and Video Processor Driver"
+	depends on VIDEO_DEV && VIDEO_V4L2 && PLAT_S5P
+	depends on S5P_SYSTEM_MMU
+	default y
+	select VIDEOBUF2_DMA_IOMMU
+	help
+	  Mixer driver for Samsung ARM based SoC.
+
+config VIDEO_SAMSUNG_S5P_MIXER_LOG_LEVEL
+	int "Log level for Samsung Mixer/Video Processor Driver"
+	depends on VIDEO_SAMSUNG_S5P_MIXER
+	range 0 7
+	default 6
+	help
+	  Select driver log level.
+	  Examples:
+		0 - emerg
+		1 - alert
+		2 - crit
+		3 - err
+		4 - warning
+		5 - notice
+		6 - info (default)
+		7 - debug
diff --git a/drivers/media/video/s5p-tv/Makefile b/drivers/media/video/s5p-tv/Makefile
new file mode 100644
index 0000000..8616ef3
--- /dev/null
+++ b/drivers/media/video/s5p-tv/Makefile
@@ -0,0 +1,17 @@
+# drivers/media/video/samsung/tvout/Makefile
+#
+# Copyright (c) 2010 Samsung Electronics Co., Ltd.
+#	http://www.samsung.com/
+# Tomasz Stanislawski <t.stanislaws@samsung.com>
+#
+# Licensed under GPLv2
+
+obj-$(CONFIG_VIDEO_SAMSUNG_S5P_HDMIPHY) += s5p-hdmiphy.o
+s5p-hdmiphy-y += hdmiphy_drv.o
+obj-$(CONFIG_VIDEO_SAMSUNG_S5P_HDMI) += s5p-hdmi.o
+s5p-hdmi-y += hdmi_drv.o
+obj-$(CONFIG_VIDEO_SAMSUNG_S5P_SDO) += s5p-sdo.o
+s5p-sdo-y += sdo_drv.o
+obj-$(CONFIG_VIDEO_SAMSUNG_S5P_MIXER) += s5p-mixer.o
+s5p-mixer-y += mixer_drv.o mixer_video.o mixer_reg.o mixer_grp_layer.o mixer_vp_layer.o
+
diff --git a/drivers/media/video/s5p-tv/hdmi.h b/drivers/media/video/s5p-tv/hdmi.h
new file mode 100644
index 0000000..a2c6073
--- /dev/null
+++ b/drivers/media/video/s5p-tv/hdmi.h
@@ -0,0 +1,74 @@
+/*
+ * Samsung HDMI interface driver
+ *
+ * Copyright (c) 2010 Samsung Electronics
+ *
+ * Tomasz Stanislawski, t.stanislaws@samsung.com
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published
+ * by the Free Software Foundiation. either version 2 of the License,
+ * or (at your option) any later version
+ */
+
+#ifndef _SAMSUNG_HDMI_H_
+#define _SAMSUNG_HDMI_H_ __FILE__
+
+#include <linux/kernel.h>
+#include <linux/videodev2.h>
+#include <media/v4l2-mediabus.h>
+
+struct hdmi_tg_regs {
+	u8 cmd;
+	u8 h_fsz_l;
+	u8 h_fsz_h;
+	u8 hact_st_l;
+	u8 hact_st_h;
+	u8 hact_sz_l;
+	u8 hact_sz_h;
+	u8 v_fsz_l;
+	u8 v_fsz_h;
+	u8 vsync_l;
+	u8 vsync_h;
+	u8 vsync2_l;
+	u8 vsync2_h;
+	u8 vact_st_l;
+	u8 vact_st_h;
+	u8 vact_sz_l;
+	u8 vact_sz_h;
+	u8 field_chg_l;
+	u8 field_chg_h;
+	u8 vact_st2_l;
+	u8 vact_st2_h;
+	u8 vsync_top_hdmi_l;
+	u8 vsync_top_hdmi_h;
+	u8 vsync_bot_hdmi_l;
+	u8 vsync_bot_hdmi_h;
+	u8 field_top_hdmi_l;
+	u8 field_top_hdmi_h;
+	u8 field_bot_hdmi_l;
+	u8 field_bot_hdmi_h;
+};
+
+struct hdmi_core_regs {
+	u8 h_blank[2];
+	u8 v_blank[3];
+	u8 h_v_line[3];
+	u8 vsync_pol[1];
+	u8 int_pro_mode[1];
+	u8 v_blank_f[3];
+	u8 h_sync_gen[3];
+	u8 v_sync_gen1[3];
+	u8 v_sync_gen2[3];
+	u8 v_sync_gen3[3];
+};
+
+struct hdmi_preset_conf {
+	struct hdmi_core_regs core;
+	/* u8 tg[29]; */
+	struct hdmi_tg_regs tg;
+	struct v4l2_mbus_framefmt mbus_fmt;
+};
+
+#endif /* _SAMSUNG_HDMI_H_ */
+
diff --git a/drivers/media/video/s5p-tv/hdmi_drv.c b/drivers/media/video/s5p-tv/hdmi_drv.c
new file mode 100644
index 0000000..d65fa6b
--- /dev/null
+++ b/drivers/media/video/s5p-tv/hdmi_drv.c
@@ -0,0 +1,984 @@
+/*
+ * Samsung HDMI interface driver
+ *
+ * Copyright (c) 2010 Samsung Electronics
+ *
+ * Tomasz Stanislawski, t.stanislaws@samsung.com
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published
+ * by the Free Software Foundiation. either version 2 of the License,
+ * or (at your option) any later version
+ */
+
+#include "hdmi.h"
+
+#include <linux/kernel.h>
+#include <linux/slab.h>
+#include <linux/io.h>
+#include <linux/i2c.h>
+#include <linux/platform_device.h>
+#include <media/v4l2-subdev.h>
+#include <linux/module.h>
+#include <linux/interrupt.h>
+#include <linux/irq.h>
+#include <linux/delay.h>
+#include <linux/bug.h>
+#include <linux/pm_runtime.h>
+#include <linux/clk.h>
+#include <linux/regulator/consumer.h>
+
+#include <media/v4l2-common.h>
+#include <media/v4l2-dev.h>
+#include <media/v4l2-device.h>
+
+#include "regs-hdmi.h"
+
+MODULE_AUTHOR("Tomasz Stanislawski, t.stanislaws@samsung.com");
+MODULE_DESCRIPTION("Samsung HDMI");
+MODULE_LICENSE("GPL");
+
+/* #define HDMI_DEFAULT_PRESET V4L2_DV_480P59_94 */
+/* #define HDMI_DEFAULT_PRESET V4L2_DV_720P59_94 */
+#define HDMI_DEFAULT_PRESET V4L2_DV_1080P60
+/* #define HDMI_DEFAULT_PRESET V4L2_DV_1080P59_94 */
+
+/* D R I V E R   I N I T I A L I Z A T I O N */
+
+static struct platform_driver hdmi_driver;
+
+static int __init hdmi_init(void)
+{
+	int ret;
+	static const char banner[] __initdata = KERN_INFO \
+		"Samsung HDMI output driver, "
+		"(c) 2010 Samsung Electronics\n";
+	printk(banner);
+
+	ret = platform_driver_register(&hdmi_driver);
+	if (ret)
+		printk(KERN_ERR "HDMI platform driver register failed\n");
+
+	return ret;
+}
+module_init(hdmi_init);
+
+static void __exit hdmi_exit(void)
+{
+	platform_driver_unregister(&hdmi_driver);
+}
+module_exit(hdmi_exit);
+
+struct hdmi_resources {
+	struct clk *hdmi;
+	struct clk *sclk_hdmi;
+	struct clk *sclk_pixel;
+	struct clk *sclk_hdmiphy;
+	struct clk *hdmiphy;
+	struct regulator_bulk_data *regul_bulk;
+	int regul_count;
+};
+
+struct hdmi_device {
+	/** base address of HDMI registers */
+	void __iomem *regs;
+	/** HDMI interrupt */
+	unsigned int irq;
+	/** pointer to device parent */
+	struct device *dev;
+	/** subdev generated by HDMI device */
+	struct v4l2_subdev sd;
+	/** V4L2 device structure */
+	struct v4l2_device vdev;
+	/** subdev of HDMIPHY interface */
+	struct v4l2_subdev *phy_sd;
+	/** configuration of current graphic mode */
+	const struct hdmi_preset_conf *cur_conf;
+	/** current preset */
+	u32 cur_preset;
+	/** other resources */
+	struct hdmi_resources res;
+};
+
+/* FIXME: this parameters should be acquired from platform data */
+static struct i2c_board_info hdmiphy_info = {
+	I2C_BOARD_INFO("hdmiphy", 0x38),
+	/* .irq = IRQ_HDMI_I2C, */
+};
+static int hdmiphy_bus = 8;
+
+static irqreturn_t hdmi_irq_handler(int irq, void *dev_data);
+
+static const struct v4l2_subdev_ops hdmi_sd_ops;
+
+static const struct hdmi_preset_conf *hdmi_preset2conf(u32 preset);
+
+#define CHECK_POINT dev_err(dev, "%s:%d\n", __func__, __LINE__)
+
+static struct hdmi_device *sd_to_hdmi_dev(struct v4l2_subdev *sd)
+{
+	return container_of(sd, struct hdmi_device, sd);
+}
+
+static int hdmi_resources_init(struct hdmi_device *hdev);
+static void hdmi_resources_cleanup(struct hdmi_device *hdev);
+
+static int __devinit hdmi_probe(struct platform_device *pdev)
+{
+	struct device *dev = &pdev->dev;
+	struct resource *res;
+	struct i2c_adapter *phy_adapter;
+	struct v4l2_subdev *sd;
+	struct hdmi_device *hdmi_dev = NULL;
+
+	int ret;
+
+	dev_info(dev, "probe start\n");
+
+	hdmi_dev = kzalloc(sizeof(*hdmi_dev), GFP_KERNEL);
+	if (!hdmi_dev) {
+		dev_err(dev, "not enough memory.\n");
+		ret = -ENOMEM;
+		goto fail;
+	}
+
+	hdmi_dev->dev = dev;
+
+	ret = hdmi_resources_init(hdmi_dev);
+	if (ret)
+		goto fail_hdev;
+
+	/* mapping HDMI registers */
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (res == NULL) {
+		dev_err(dev, "get memory resource failed.\n");
+		ret = -ENXIO;
+		goto fail_init;
+	}
+
+	/* TODO: add request_mem_region */
+	hdmi_dev->regs = ioremap(res->start, resource_size(res));
+	if (hdmi_dev->regs == NULL) {
+		dev_err(dev, "register mapping failed.\n");
+		ret = -ENXIO;
+		goto fail_hdev;
+	}
+
+	/* acquiring HDMI interrupt */
+	res = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
+	if (res == NULL) {
+		dev_err(dev, "get interrupt resource failed.\n");
+		ret = -ENXIO;
+		goto fail_regs;
+	}
+
+	ret = request_irq(res->start, hdmi_irq_handler, 0, "hdmi", hdmi_dev);
+	if (ret) {
+		dev_err(dev, "request interrupt failed.\n");
+		goto fail_regs;
+	}
+	hdmi_dev->irq = res->start;
+
+	ret = v4l2_device_register(dev, &hdmi_dev->vdev);
+	if (ret) {
+		dev_err(dev, "could not register v4l2 device.\n");
+		goto fail_irq;
+	}
+
+	phy_adapter = i2c_get_adapter(hdmiphy_bus);
+	if (phy_adapter == NULL) {
+		dev_err(dev, "adapter request failed\n");
+		ret = -ENXIO;
+		goto fail_vdev;
+	}
+
+	hdmi_dev->phy_sd = v4l2_i2c_new_subdev_board(&hdmi_dev->vdev,
+		phy_adapter, &hdmiphy_info, NULL);
+	/* on failure or not adapter is no longer useful */
+	i2c_put_adapter(phy_adapter);
+	if (hdmi_dev->phy_sd == NULL) {
+		dev_err(dev, "missing subdev for hdmiphy\n");
+		ret = -ENODEV;
+		goto fail_vdev;
+	}
+
+	pm_runtime_set_active(dev);
+	pm_runtime_enable(dev);
+
+	sd = &hdmi_dev->sd;
+	v4l2_subdev_init(sd, &hdmi_sd_ops);
+	sd->owner = THIS_MODULE;
+
+	strlcpy(sd->name, hdmi_driver.driver.name, sizeof sd->name);
+	hdmi_dev->cur_preset = HDMI_DEFAULT_PRESET;
+	/* FIXME: missing fail preset is not supported */
+	hdmi_dev->cur_conf = hdmi_preset2conf(hdmi_dev->cur_preset);
+
+	/* storing subdev for call that have only access to struct device */
+	dev_set_drvdata(dev, sd);
+
+	dev_info(dev, "probe sucessful\n");
+
+	return 0;
+
+fail_vdev:
+	v4l2_device_unregister(&hdmi_dev->vdev);
+
+fail_irq:
+	free_irq(hdmi_dev->irq, hdmi_dev);
+
+fail_regs:
+	iounmap(hdmi_dev->regs);
+
+fail_init:
+	hdmi_resources_cleanup(hdmi_dev);
+
+fail_hdev:
+	kfree(hdmi_dev);
+
+fail:
+	dev_info(dev, "probe failed\n");
+	return ret;
+}
+
+static int __devexit hdmi_remove(struct platform_device *pdev)
+{
+	struct device *dev = &pdev->dev;
+	struct v4l2_subdev *sd = dev_get_drvdata(dev);
+	struct hdmi_device *hdmi_dev = sd_to_hdmi_dev(sd);
+
+	pm_runtime_disable(dev);
+	v4l2_device_unregister(&hdmi_dev->vdev);
+	disable_irq(hdmi_dev->irq);
+	free_irq(hdmi_dev->irq, hdmi_dev);
+	iounmap(hdmi_dev->regs);
+	hdmi_resources_cleanup(hdmi_dev);
+	kfree(hdmi_dev);
+	dev_info(dev, "remove sucessful\n");
+
+	return 0;
+}
+
+static int hdmi_runtime_suspend(struct device *dev)
+{
+	dev_info(dev, "%s\n", __func__);
+	return 0;
+}
+
+static int hdmi_runtime_resume(struct device *dev)
+{
+	dev_info(dev, "%s\n", __func__);
+	return 0;
+}
+
+static const struct dev_pm_ops hdmi_pm_ops = {
+	.runtime_suspend = hdmi_runtime_suspend,
+	.runtime_resume	 = hdmi_runtime_resume,
+};
+
+static struct platform_driver hdmi_driver __refdata = {
+	.probe = hdmi_probe,
+	.remove = __devexit_p(hdmi_remove),
+	.driver = {
+		.name = "s5p-hdmi",
+		.owner = THIS_MODULE,
+		.pm = &hdmi_pm_ops,
+	}
+};
+
+static int hdmi_resources_init(struct hdmi_device *hdev)
+{
+	struct device *dev = hdev->dev;
+	struct hdmi_resources *res = &hdev->res;
+	static char *supply[] = {
+		"hdmi-en",
+		"vdd",
+		"vdd_osc",
+		"vdd_pll",
+	};
+	int i, ret;
+
+	dev_info(dev, "HDMI resource init\n");
+
+	memset(res, 0, sizeof *res);
+	/* get clocks, power */
+
+	/* move this names somewhere */
+	res->hdmi = clk_get(dev, "hdmi");
+	if (IS_ERR_OR_NULL(res->hdmi)) {
+		dev_err(dev, "failed to get clock 'hdmi'\n");
+		goto fail;
+	}
+	res->sclk_hdmi = clk_get(dev, "sclk_hdmi");
+	if (IS_ERR_OR_NULL(res->sclk_hdmi)) {
+		dev_err(dev, "failed to get clock 'sclk_hdmi'\n");
+		goto fail;
+	}
+	res->sclk_pixel = clk_get(dev, "sclk_pixel");
+	if (IS_ERR_OR_NULL(res->sclk_pixel)) {
+		dev_err(dev, "failed to get clock 'sclk_pixel'\n");
+		goto fail;
+	}
+	res->sclk_hdmiphy = clk_get(dev, "sclk_hdmiphy");
+	if (IS_ERR_OR_NULL(res->sclk_hdmiphy)) {
+		dev_err(dev, "failed to get clock 'sclk_hdmiphy'\n");
+		goto fail;
+	}
+	res->hdmiphy = clk_get(dev, "hdmiphy");
+	if (IS_ERR_OR_NULL(res->hdmiphy)) {
+		dev_err(dev, "failed to get clock 'hdmiphy'\n");
+		goto fail;
+	}
+	res->regul_bulk = kzalloc(ARRAY_SIZE(supply) *
+		sizeof (struct regulator_bulk_data), GFP_KERNEL);
+	if (!res->regul_bulk) {
+		dev_err(dev, "failed to get memory for regulators\n");
+		goto fail;
+	}
+	for (i = 0; i < ARRAY_SIZE(supply); ++i) {
+		res->regul_bulk[i].supply = supply[i];
+		res->regul_bulk[i].consumer = NULL;
+	}
+		
+	ret = regulator_bulk_get(dev, ARRAY_SIZE(supply), res->regul_bulk);
+	if (ret) {
+		dev_err(dev, "failed to get regulators\n");
+		goto fail;
+	}
+	res->regul_count = ARRAY_SIZE(supply);
+
+	return 0;
+fail:
+	dev_err(dev, "HDMI resource init - failed\n");
+	hdmi_resources_cleanup(hdev);
+	return -ENODEV;
+}
+
+static void hdmi_resources_cleanup(struct hdmi_device *hdev)
+{
+	struct hdmi_resources *res = &hdev->res;
+
+	dev_info(hdev->dev, "HDMI resource deinit\n");
+	/* put clocks, power */
+	if (res->regul_count)
+		regulator_bulk_free(res->regul_count, res->regul_bulk);
+	if (res->regul_bulk)
+		kfree(res->regul_bulk);
+	if (!IS_ERR_OR_NULL(res->hdmiphy))
+		clk_put(res->hdmiphy);
+	if (!IS_ERR_OR_NULL(res->sclk_hdmiphy))
+		clk_put(res->sclk_hdmiphy);
+	if (!IS_ERR_OR_NULL(res->sclk_pixel))
+		clk_put(res->sclk_pixel);
+	if (!IS_ERR_OR_NULL(res->sclk_hdmi))
+		clk_put(res->sclk_hdmi);
+	if (!IS_ERR_OR_NULL(res->hdmi))
+		clk_put(res->hdmi);
+	memset(res, 0, sizeof *res);
+}
+
+static inline
+void hdmi_write(struct hdmi_device *hdev, u32 reg_id, u32 value)
+{
+	writel(value, hdev->regs + reg_id);
+}
+
+static inline
+void hdmi_write_mask(struct hdmi_device *hdev, u32 reg_id, u32 value, u32 mask)
+{
+	u32 old = readl(hdev->regs + reg_id);
+	value = (value & mask) | (old & ~mask);
+	writel(value, hdev->regs + reg_id);
+}
+
+static inline
+void hdmi_writeb(struct hdmi_device *hdev, u32 reg_id, u8 value)
+{
+	writeb(value, hdev->regs + reg_id);
+}
+
+static inline u32 hdmi_read(struct hdmi_device *hdev, u32 reg_id)
+{
+	return readl(hdev->regs + reg_id);
+}
+
+static irqreturn_t hdmi_irq_handler(int irq, void *dev_data)
+{
+	struct hdmi_device *hdev = dev_data;
+	u32 intc_flag;
+	(void)irq;
+	/* TODO: add V4L2 event generation */
+
+	intc_flag = hdmi_read(hdev, HDMI_INTC_FLAG);
+	/* clearing flags for HPD plug/unplug */
+	if (intc_flag & HDMI_INTC_FLAG_HPD_UNPLUG) {
+		printk(KERN_INFO "unplugged\n");
+		hdmi_write_mask(hdev, HDMI_INTC_FLAG, ~0,
+			HDMI_INTC_FLAG_HPD_UNPLUG);
+	}
+	if (intc_flag & HDMI_INTC_FLAG_HPD_PLUG) {
+		printk(KERN_INFO "plugged\n");
+		hdmi_write_mask(hdev, HDMI_INTC_FLAG, ~0,
+			HDMI_INTC_FLAG_HPD_PLUG);
+	}
+
+	return IRQ_HANDLED;
+}
+
+static int hdmi_s_dv_preset(struct v4l2_subdev *sd,
+	struct v4l2_dv_preset *preset);
+
+static void hdmi_resource_poweron(struct hdmi_resources *res)
+{
+	/* turn HDMI power on */
+	regulator_bulk_enable(res->regul_count, res->regul_bulk);
+	/* power-on hdmi physical interface */
+	clk_enable(res->hdmiphy);
+	/* use VPP as parent clock; HDMIPHY is not working yet */
+	clk_set_parent(res->sclk_hdmi, res->sclk_pixel);
+	/* turn clocks on */
+	clk_enable(res->hdmi);
+	clk_enable(res->sclk_hdmi);
+}
+
+static void hdmi_resource_poweroff(struct hdmi_resources *res)
+{
+	/* turn clocks off */
+	clk_disable(res->sclk_hdmi);
+	clk_disable(res->hdmi);
+	/* power-off hdmiphy */
+	clk_disable(res->hdmiphy);
+	/* turn HDMI power off */
+	regulator_bulk_disable(res->regul_count, res->regul_bulk);
+}
+
+static int hdmi_conf_apply(struct hdmi_device *hdmi_dev);
+
+static int hdmi_poweron(struct hdmi_device *hdev)
+{
+	struct device *dev = hdev->dev;
+	int ret = 0;
+
+	pm_runtime_get_sync(dev);
+	hdmi_resource_poweron(&hdev->res);
+
+	ret = hdmi_conf_apply(hdev);
+	if (ret)
+		goto fail;
+
+	dev_info(dev, "poweron succeed\n");
+
+	return 0;
+
+fail:
+	/* turn power off */
+	hdmi_resource_poweroff(&hdev->res);
+	pm_runtime_put_sync(dev);
+	dev_info(dev, "poweron failed\n");
+
+	return ret;
+}
+
+static int hdmi_poweroff(struct hdmi_device *hdev)
+{
+	struct device *dev = hdev->dev;
+
+	hdmi_resource_poweroff(&hdev->res);
+	pm_runtime_put_sync(dev);
+	dev_info(dev, "poweroff succeed\n");
+
+	return 0;
+}
+
+static int hdmi_s_power(struct v4l2_subdev *sd, int on)
+{
+	struct hdmi_device *hdev = sd_to_hdmi_dev(sd);
+	if (on)
+		return hdmi_poweron(hdev);
+	else
+		return hdmi_poweroff(hdev);
+}
+
+static void hdmi_timing_apply(struct hdmi_device *hdev,
+	const struct hdmi_preset_conf *conf);
+static void hdmi_dumpregs(struct hdmi_device *hdev, char *prefix);
+
+static void hdmi_reg_init(struct hdmi_device *hdev)
+{
+	/* enable HPD interrupts */
+	hdmi_write_mask(hdev, HDMI_INTC_CON, ~0, HDMI_INTC_EN_GLOBAL |
+		HDMI_INTC_EN_HPD_PLUG | HDMI_INTC_EN_HPD_UNPLUG);
+	/* choose HDMI mode */
+	hdmi_write_mask(hdev, HDMI_MODE_SEL,
+		HDMI_MODE_HDMI_EN | HDMI_MODE_DVI_DIS, HDMI_MODE_MASK);
+	/* XXX: choose bluescreen */
+	hdmi_write_mask(hdev, HDMI_CON_0, 0, HDMI_BLUE_SCR_EN);
+	/* choose bluescreen (fecal) color */
+	hdmi_writeb(hdev, HDMI_BLUE_SCREEN_0, 0x12);
+	hdmi_writeb(hdev, HDMI_BLUE_SCREEN_1, 0x34);
+	hdmi_writeb(hdev, HDMI_BLUE_SCREEN_2, 0x56);
+	/* enable AVI packet every vsync, fixes purple line problem */
+	hdmi_writeb(hdev, HDMI_AVI_CON, 0x02);
+	/* force YUV444, look to CEA-861-D, table 7 for more detail */
+	hdmi_writeb(hdev, HDMI_AVI_BYTE1, 2 << 5);
+	hdmi_write_mask(hdev, HDMI_CON_1, 2, 3 << 5);
+}
+
+static int hdmi_conf_apply(struct hdmi_device *hdmi_dev)
+{
+	struct device *dev = hdmi_dev->dev;
+	const struct hdmi_preset_conf *conf = hdmi_dev->cur_conf;
+	struct v4l2_dv_preset preset;
+	int tries, ret;
+	dev_info(dev, "%s\n", __func__);
+
+	/* reset hdmiphy */
+	hdmi_write_mask(hdmi_dev, HDMI_PHY_RSTOUT, ~0, HDMI_PHY_SW_RSTOUT);
+	mdelay(10);
+	hdmi_write_mask(hdmi_dev, HDMI_PHY_RSTOUT,  0, HDMI_PHY_SW_RSTOUT);
+	mdelay(10);
+
+	/* configure presets */
+	preset.preset = hdmi_dev->cur_preset;
+	ret = v4l2_subdev_call(hdmi_dev->phy_sd, video, s_dv_preset, &preset);
+	if (ret) {
+		dev_err(dev, "failed to set preset (%u)\n", preset.preset);
+		return ret;
+	}
+
+	/* resetting HDMI core */
+	hdmi_write_mask(hdmi_dev, HDMI_CORE_RSTOUT,  0, HDMI_CORE_SW_RSTOUT);
+	mdelay(10);
+	hdmi_write_mask(hdmi_dev, HDMI_CORE_RSTOUT, ~0, HDMI_CORE_SW_RSTOUT);
+	mdelay(10);
+
+	hdmi_reg_init(hdmi_dev);
+
+	/* waiting for HDMIPHY's PLL to get to steady state */
+	for (tries = 100; tries; --tries) {
+		u32 val = hdmi_read(hdmi_dev, HDMI_PHY_STATUS);
+		if (val & HDMI_PHY_STATUS_READY)
+			break;
+		mdelay(1);
+	}
+	/* steady state not achieved */
+	if (tries == 0) {
+		dev_err(dev, "hdmiphy's pll could not reach steady state.\n");
+		hdmi_dumpregs(hdmi_dev, "s_preset");
+		return -EIO;
+	}
+
+	/* setting core registers */
+	hdmi_timing_apply(hdmi_dev, conf);
+
+	return 0;
+}
+
+static int hdmi_s_dv_preset(struct v4l2_subdev *sd,
+	struct v4l2_dv_preset *preset)
+{
+	struct hdmi_device *hdev = sd_to_hdmi_dev(sd);
+	struct device *dev = hdev->dev;
+	const struct hdmi_preset_conf *conf;
+
+	conf = hdmi_preset2conf(preset->preset);
+	if (conf == NULL) {
+		dev_err(dev, "preset (%u) not supported\n", preset->preset);
+		return -ENXIO;
+	}
+	hdev->cur_conf = conf;
+	hdev->cur_preset = preset->preset;
+	return 0;
+}
+
+static int hdmi_enum_dv_presets(struct v4l2_subdev *sd,
+	struct v4l2_dv_enum_preset *preset);
+
+static int hdmi_g_mbus_fmt(struct v4l2_subdev *sd,
+	  struct v4l2_mbus_framefmt *fmt)
+{
+	struct hdmi_device *hdev = sd_to_hdmi_dev(sd);
+	struct device *dev = hdev->dev;
+	dev_info(dev, "%s\n", __func__);
+	if (!hdev->cur_conf)
+		return -ENXIO;
+	*fmt = hdev->cur_conf->mbus_fmt;
+	return 0;
+}
+
+static int hdmi_streamon(struct hdmi_device *hdev)
+{
+	struct device *dev = hdev->dev;
+	struct hdmi_resources *res = &hdev->res;
+
+	dev_info(dev, "%s\n", __func__);
+
+	/* hdmiphy clock is used for HDMI in streaming mode */
+	clk_disable(res->sclk_hdmi);
+	clk_set_parent(res->sclk_hdmi, res->sclk_hdmiphy);
+	clk_enable(res->sclk_hdmi);
+
+	hdmi_write_mask(hdev, HDMI_CON_0, ~0, HDMI_EN);
+	/* XXX: enable VSYNC and BT656 synchro */
+	/* dmi_write(hdev, S5P_HDMI_TG_CMD, ~0, (1 << 3) | (1 << 4)); */
+	hdmi_write_mask(hdev, HDMI_TG_CMD, ~0, HDMI_TG_EN);
+	hdmi_dumpregs(hdev, "streamon");
+	return 0;
+}
+
+static int hdmi_streamoff(struct hdmi_device *hdev)
+{
+	struct device *dev = hdev->dev;
+	struct hdmi_resources *res = &hdev->res;
+
+	dev_info(dev, "%s\n", __func__);
+
+	hdmi_write_mask(hdev, HDMI_CON_0, 0, HDMI_EN);
+	hdmi_write_mask(hdev, HDMI_TG_CMD, 0, HDMI_TG_EN);
+
+	/* pixel(vpll) clock is used for HDMI in config mode */
+	clk_disable(res->sclk_hdmi);
+	clk_set_parent(res->sclk_hdmi, res->sclk_pixel);
+	clk_enable(res->sclk_hdmi);
+
+	hdmi_dumpregs(hdev, "streamoff");
+	return 0;
+}
+
+static int hdmi_s_stream(struct v4l2_subdev *sd, int enable)
+{
+	struct hdmi_device *hdev = sd_to_hdmi_dev(sd);
+	struct device *dev = hdev->dev;
+	dev_info(dev, "%s(%d)\n", __func__, enable);
+	if (enable)
+		return hdmi_streamon(hdev);
+	else
+		return hdmi_streamoff(hdev);
+	/* call stream_setup from pdata (it changes clocks) */
+	/* set bit 0 in in HDMI_CON_0 */
+	/* set bits in in HDMI_TG_CMD */
+	/* enjoy your TV */
+}
+
+static const struct v4l2_subdev_core_ops hdmi_sd_core_ops = {
+	.s_power = hdmi_s_power,
+};
+
+static const struct v4l2_subdev_video_ops hdmi_sd_video_ops = {
+	.s_dv_preset = hdmi_s_dv_preset,
+	.enum_dv_presets = hdmi_enum_dv_presets,
+	.g_mbus_fmt = hdmi_g_mbus_fmt,
+	.s_stream = hdmi_s_stream,
+};
+
+static const struct v4l2_subdev_ops hdmi_sd_ops = {
+	.core = &hdmi_sd_core_ops,
+	.video = &hdmi_sd_video_ops,
+};
+
+static void hdmi_timing_apply(struct hdmi_device *hdev,
+	const struct hdmi_preset_conf *conf)
+{
+	const struct hdmi_core_regs *core = &conf->core;
+	const struct hdmi_tg_regs *tg = &conf->tg;
+	/* setting core registers */
+	hdmi_writeb(hdev, HDMI_H_BLANK_0, core->h_blank[0]);
+	hdmi_writeb(hdev, HDMI_H_BLANK_1, core->h_blank[1]);
+	hdmi_writeb(hdev, HDMI_V_BLANK_0, core->v_blank[0]);
+	hdmi_writeb(hdev, HDMI_V_BLANK_1, core->v_blank[1]);
+	hdmi_writeb(hdev, HDMI_V_BLANK_2, core->v_blank[2]);
+	hdmi_writeb(hdev, HDMI_H_V_LINE_0, core->h_v_line[0]);
+	hdmi_writeb(hdev, HDMI_H_V_LINE_1, core->h_v_line[1]);
+	hdmi_writeb(hdev, HDMI_H_V_LINE_2, core->h_v_line[2]);
+	hdmi_writeb(hdev, HDMI_VSYNC_POL, core->vsync_pol[0]);
+	hdmi_writeb(hdev, HDMI_INT_PRO_MODE, core->int_pro_mode[0]);
+	hdmi_writeb(hdev, HDMI_V_BLANK_F_0, core->v_blank_f[0]);
+	hdmi_writeb(hdev, HDMI_V_BLANK_F_1, core->v_blank_f[1]);
+	hdmi_writeb(hdev, HDMI_V_BLANK_F_2, core->v_blank_f[2]);
+	hdmi_writeb(hdev, HDMI_H_SYNC_GEN_0, core->h_sync_gen[0]);
+	hdmi_writeb(hdev, HDMI_H_SYNC_GEN_1, core->h_sync_gen[1]);
+	hdmi_writeb(hdev, HDMI_H_SYNC_GEN_2, core->h_sync_gen[2]);
+	hdmi_writeb(hdev, HDMI_V_SYNC_GEN_1_0, core->v_sync_gen1[0]);
+	hdmi_writeb(hdev, HDMI_V_SYNC_GEN_1_1, core->v_sync_gen1[1]);
+	hdmi_writeb(hdev, HDMI_V_SYNC_GEN_1_2, core->v_sync_gen1[2]);
+	hdmi_writeb(hdev, HDMI_V_SYNC_GEN_2_0, core->v_sync_gen2[0]);
+	hdmi_writeb(hdev, HDMI_V_SYNC_GEN_2_1, core->v_sync_gen2[1]);
+	hdmi_writeb(hdev, HDMI_V_SYNC_GEN_2_2, core->v_sync_gen2[2]);
+	hdmi_writeb(hdev, HDMI_V_SYNC_GEN_3_0, core->v_sync_gen3[0]);
+	hdmi_writeb(hdev, HDMI_V_SYNC_GEN_3_1, core->v_sync_gen3[1]);
+	hdmi_writeb(hdev, HDMI_V_SYNC_GEN_3_2, core->v_sync_gen3[2]);
+	/* Timing generator registers */
+	hdmi_writeb(hdev, HDMI_TG_H_FSZ_L, tg->h_fsz_l);
+	hdmi_writeb(hdev, HDMI_TG_H_FSZ_H, tg->h_fsz_h);
+	hdmi_writeb(hdev, HDMI_TG_HACT_ST_L, tg->hact_st_l);
+	hdmi_writeb(hdev, HDMI_TG_HACT_ST_H, tg->hact_st_h);
+	hdmi_writeb(hdev, HDMI_TG_HACT_SZ_L, tg->hact_sz_l);
+	hdmi_writeb(hdev, HDMI_TG_HACT_SZ_H, tg->hact_sz_h);
+	hdmi_writeb(hdev, HDMI_TG_V_FSZ_L, tg->v_fsz_l);
+	hdmi_writeb(hdev, HDMI_TG_V_FSZ_H, tg->v_fsz_h);
+	hdmi_writeb(hdev, HDMI_TG_VSYNC_L, tg->vsync_l);
+	hdmi_writeb(hdev, HDMI_TG_VSYNC_H, tg->vsync_h);
+	hdmi_writeb(hdev, HDMI_TG_VSYNC2_L, tg->vsync2_l);
+	hdmi_writeb(hdev, HDMI_TG_VSYNC2_H, tg->vsync2_h);
+	hdmi_writeb(hdev, HDMI_TG_VACT_ST_L, tg->vact_st_l);
+	hdmi_writeb(hdev, HDMI_TG_VACT_ST_H, tg->vact_st_h);
+	hdmi_writeb(hdev, HDMI_TG_VACT_SZ_L, tg->vact_sz_l);
+	hdmi_writeb(hdev, HDMI_TG_VACT_SZ_H, tg->vact_sz_h);
+	hdmi_writeb(hdev, HDMI_TG_FIELD_CHG_L, tg->field_chg_l);
+	hdmi_writeb(hdev, HDMI_TG_FIELD_CHG_H, tg->field_chg_h);
+	hdmi_writeb(hdev, HDMI_TG_VACT_ST2_L, tg->vact_st2_l);
+	hdmi_writeb(hdev, HDMI_TG_VACT_ST2_H, tg->vact_st2_h);
+	hdmi_writeb(hdev, HDMI_TG_VSYNC_TOP_HDMI_L, tg->vsync_top_hdmi_l);
+	hdmi_writeb(hdev, HDMI_TG_VSYNC_TOP_HDMI_H, tg->vsync_top_hdmi_h);
+	hdmi_writeb(hdev, HDMI_TG_VSYNC_BOT_HDMI_L, tg->vsync_bot_hdmi_l);
+	hdmi_writeb(hdev, HDMI_TG_VSYNC_BOT_HDMI_H, tg->vsync_bot_hdmi_h);
+	hdmi_writeb(hdev, HDMI_TG_FIELD_TOP_HDMI_L, tg->field_top_hdmi_l);
+	hdmi_writeb(hdev, HDMI_TG_FIELD_TOP_HDMI_H, tg->field_top_hdmi_h);
+	hdmi_writeb(hdev, HDMI_TG_FIELD_BOT_HDMI_L, tg->field_bot_hdmi_l);
+	hdmi_writeb(hdev, HDMI_TG_FIELD_BOT_HDMI_H, tg->field_bot_hdmi_h);
+}
+
+static const struct hdmi_preset_conf hdmi_conf_480p = {
+	.core = {
+		.h_blank = {0x8a, 0x00},
+		.v_blank = {0x0d, 0x6a, 0x01},
+		.h_v_line = {0x0d, 0xa2, 0x35},
+		.vsync_pol = {0x01},
+		.int_pro_mode = {0x00},
+		.v_blank_f = {0x00, 0x00, 0x00},
+		.h_sync_gen = {0x0e, 0x30, 0x11},
+		.v_sync_gen1 = {0x0f, 0x90, 0x00},
+		/* other don't care */
+	},
+	.tg = {
+		0x00, /* cmd */
+		0x5a, 0x03, /* h_fsz */
+		0x8a, 0x00, 0xd0, 0x02, /* hact */
+		0x0d, 0x02, /* v_fsz */
+		0x01, 0x00, 0x33, 0x02, /* vsync */
+		0x2d, 0x00, 0xe0, 0x01, /* vact */
+		0x33, 0x02, /* field_chg */
+		0x49, 0x02, /* vact_st2 */
+		0x01, 0x00, 0x33, 0x02, /* vsync top/bot */
+		0x01, 0x00, 0x33, 0x02, /* field top/bot */
+	},
+	.mbus_fmt = {
+		.width = 720,
+		.height = 480,
+		.code = V4L2_MBUS_FMT_FIXED, /* means RGB888 */
+		.field = V4L2_FIELD_NONE,
+	},
+};
+
+static const struct hdmi_preset_conf hdmi_conf_720p60 = {
+	.core = {
+		.h_blank = {0x72, 0x01},
+		.v_blank = {0xee, 0xf2, 0x00},
+		.h_v_line = {0xee, 0x22, 0x67},
+		.vsync_pol = {0x00},
+		.int_pro_mode = {0x00},
+		.v_blank_f = {0x00, 0x00, 0x00}, /* don't care */
+		.h_sync_gen = {0x6c, 0x50, 0x02},
+		.v_sync_gen1 = {0x0a, 0x50, 0x00},
+		/* other don't care */
+	},
+	.tg = {
+		0x00, /* cmd */
+		0x72, 0x06, /* h_fsz */
+		0x72, 0x01, 0x00, 0x05, /* hact */
+		0xee, 0x02, /* v_fsz */
+		0x01, 0x00, 0x33, 0x02, /* vsync */
+		0x1e, 0x00, 0xd0, 0x02, /* vact */
+		0x33, 0x02, /* field_chg */
+		0x49, 0x02, /* vact_st2 */
+		0x01, 0x00, 0x33, 0x02, /* vsync top/bot */
+		0x01, 0x00, 0x33, 0x02, /* field top/bot */
+	},
+	.mbus_fmt = {
+		.width = 1280,
+		.height = 720,
+		.code = V4L2_MBUS_FMT_FIXED, /* means RGB888 */
+		.field = V4L2_FIELD_NONE,
+	},
+};
+
+static const struct hdmi_preset_conf hdmi_conf_1080p50 = {
+	.core = {
+		.h_blank = {0xd0, 0x02},
+		.v_blank = {0x65, 0x6c, 0x01},
+		.h_v_line = {0x65, 0x04, 0xa5},
+		.vsync_pol = {0x00},
+		.int_pro_mode = {0x00},
+		.v_blank_f = {0x00, 0x00, 0x00}, /* don't care */
+		.h_sync_gen = {0x0e, 0xea, 0x08},
+		.v_sync_gen1 = {0x09, 0x40, 0x00},
+		/* other don't care */
+	},
+	.tg = {
+		0x00, /* cmd */
+		0x98, 0x08, /* h_fsz */
+		0x18, 0x01, 0x80, 0x07, /* hact */
+		0x65, 0x04, /* v_fsz */
+		0x01, 0x00, 0x33, 0x02, /* vsync */
+		0x2d, 0x00, 0x38, 0x04, /* vact */
+		0x33, 0x02, /* field_chg */
+		0x49, 0x02, /* vact_st2 */
+		0x01, 0x00, 0x33, 0x02, /* vsync top/bot */
+		0x01, 0x00, 0x33, 0x02, /* field top/bot */
+	},
+	.mbus_fmt = {
+		.width = 1920,
+		.height = 1080,
+		.code = V4L2_MBUS_FMT_FIXED, /* means RGB888 */
+		.field = V4L2_FIELD_NONE,
+	},
+};
+
+static const struct hdmi_preset_conf hdmi_conf_1080p60 = {
+	.core = {
+		.h_blank = {0x18, 0x01},
+		.v_blank = {0x65, 0x6c, 0x01},
+		.h_v_line = {0x65, 0x84, 0x89},
+		.vsync_pol = {0x00},
+		.int_pro_mode = {0x00},
+		.v_blank_f = {0x00, 0x00, 0x00}, /* don't care */
+		.h_sync_gen = {0x56, 0x08, 0x02},
+		.v_sync_gen1 = {0x09, 0x40, 0x00},
+		/* other don't care */
+	},
+	.tg = {
+		0x00, /* cmd */
+		0x98, 0x08, /* h_fsz */
+		0x18, 0x01, 0x80, 0x07, /* hact */
+		0x65, 0x04, /* v_fsz */
+		0x01, 0x00, 0x33, 0x02, /* vsync */
+		0x2d, 0x00, 0x38, 0x04, /* vact */
+		0x33, 0x02, /* field_chg */
+		0x48, 0x02, /* vact_st2 */
+		0x01, 0x00, 0x01, 0x00, /* vsync top/bot */
+		0x01, 0x00, 0x33, 0x02, /* field top/bot */
+	},
+	.mbus_fmt = {
+		.width = 1920,
+		.height = 1080,
+		.code = V4L2_MBUS_FMT_FIXED, /* means RGB888 */
+		.field = V4L2_FIELD_NONE,
+	},
+};
+
+static const struct {
+	u32 preset;
+	const struct hdmi_preset_conf *conf;
+} hdmi_conf[] = {
+	{ V4L2_DV_480P59_94, &hdmi_conf_480p },
+	{ V4L2_DV_720P59_94, &hdmi_conf_720p60 },
+	{ V4L2_DV_1080P50, &hdmi_conf_1080p50 },
+	{ V4L2_DV_1080P30, &hdmi_conf_1080p60 },
+	{ V4L2_DV_1080P60, &hdmi_conf_1080p60 },
+	{ V4L2_DV_1080P59_94, &hdmi_conf_1080p60 },
+};
+
+static const struct hdmi_preset_conf *hdmi_preset2conf(u32 preset)
+{
+	int i;
+	for (i = 0; i < ARRAY_SIZE(hdmi_conf); ++i)
+		if (hdmi_conf[i].preset == preset)
+			return  hdmi_conf[i].conf;
+	return NULL;
+}
+
+static int hdmi_enum_dv_presets(struct v4l2_subdev *sd,
+	struct v4l2_dv_enum_preset *preset)
+{
+	if (preset->index >= ARRAY_SIZE(hdmi_conf))
+		return -EINVAL;
+	return v4l_fill_dv_preset_info(hdmi_conf[preset->index].preset, preset);
+}
+
+static void hdmi_dumpregs(struct hdmi_device *hdev, char *prefix)
+{
+#define DUMPREG(reg_id) \
+	printk(KERN_DEBUG "%s:" #reg_id " = %08x\n", prefix, \
+	readl(hdev->regs + reg_id))
+	printk(KERN_ERR "%s: ---- CONTROL REGISTERS ----\n", prefix);
+	DUMPREG(HDMI_INTC_FLAG);
+	DUMPREG(HDMI_INTC_CON);
+	DUMPREG(HDMI_HPD_STATUS);
+	DUMPREG(HDMI_PHY_RSTOUT);
+	DUMPREG(HDMI_PHY_VPLL);
+	DUMPREG(HDMI_PHY_CMU);
+	DUMPREG(HDMI_CORE_RSTOUT);
+
+	printk(KERN_ERR "%s: ---- CORE REGISTERS ----\n", prefix);
+	DUMPREG(HDMI_CON_0);
+	DUMPREG(HDMI_CON_1);
+	DUMPREG(HDMI_CON_2);
+	DUMPREG(HDMI_SYS_STATUS);
+	DUMPREG(HDMI_PHY_STATUS);
+	DUMPREG(HDMI_STATUS_EN);
+	DUMPREG(HDMI_HPD);
+	DUMPREG(HDMI_MODE_SEL);
+	DUMPREG(HDMI_HPD_GEN);
+	DUMPREG(HDMI_DC_CONTROL);
+	DUMPREG(HDMI_VIDEO_PATTERN_GEN);
+
+	printk(KERN_ERR "%s: ---- CORE SYNC REGISTERS ----\n", prefix);
+	DUMPREG(HDMI_H_BLANK_0);
+	DUMPREG(HDMI_H_BLANK_1);
+	DUMPREG(HDMI_V_BLANK_0);
+	DUMPREG(HDMI_V_BLANK_1);
+	DUMPREG(HDMI_V_BLANK_2);
+	DUMPREG(HDMI_H_V_LINE_0);
+	DUMPREG(HDMI_H_V_LINE_1);
+	DUMPREG(HDMI_H_V_LINE_2);
+	DUMPREG(HDMI_VSYNC_POL);
+	DUMPREG(HDMI_INT_PRO_MODE);
+	DUMPREG(HDMI_V_BLANK_F_0);
+	DUMPREG(HDMI_V_BLANK_F_1);
+	DUMPREG(HDMI_V_BLANK_F_2);
+	DUMPREG(HDMI_H_SYNC_GEN_0);
+	DUMPREG(HDMI_H_SYNC_GEN_1);
+	DUMPREG(HDMI_H_SYNC_GEN_2);
+	DUMPREG(HDMI_V_SYNC_GEN_1_0);
+	DUMPREG(HDMI_V_SYNC_GEN_1_1);
+	DUMPREG(HDMI_V_SYNC_GEN_1_2);
+	DUMPREG(HDMI_V_SYNC_GEN_2_0);
+	DUMPREG(HDMI_V_SYNC_GEN_2_1);
+	DUMPREG(HDMI_V_SYNC_GEN_2_2);
+	DUMPREG(HDMI_V_SYNC_GEN_3_0);
+	DUMPREG(HDMI_V_SYNC_GEN_3_1);
+	DUMPREG(HDMI_V_SYNC_GEN_3_2);
+
+	printk(KERN_ERR "%s: ---- TG REGISTERS ----\n", prefix);
+	DUMPREG(HDMI_TG_CMD);
+	DUMPREG(HDMI_TG_H_FSZ_L);
+	DUMPREG(HDMI_TG_H_FSZ_H);
+	DUMPREG(HDMI_TG_HACT_ST_L);
+	DUMPREG(HDMI_TG_HACT_ST_H);
+	DUMPREG(HDMI_TG_HACT_SZ_L);
+	DUMPREG(HDMI_TG_HACT_SZ_H);
+	DUMPREG(HDMI_TG_V_FSZ_L);
+	DUMPREG(HDMI_TG_V_FSZ_H);
+	DUMPREG(HDMI_TG_VSYNC_L);
+	DUMPREG(HDMI_TG_VSYNC_H);
+	DUMPREG(HDMI_TG_VSYNC2_L);
+	DUMPREG(HDMI_TG_VSYNC2_H);
+	DUMPREG(HDMI_TG_VACT_ST_L);
+	DUMPREG(HDMI_TG_VACT_ST_H);
+	DUMPREG(HDMI_TG_VACT_SZ_L);
+	DUMPREG(HDMI_TG_VACT_SZ_H);
+	DUMPREG(HDMI_TG_FIELD_CHG_L);
+	DUMPREG(HDMI_TG_FIELD_CHG_H);
+	DUMPREG(HDMI_TG_VACT_ST2_L);
+	DUMPREG(HDMI_TG_VACT_ST2_H);
+	DUMPREG(HDMI_TG_VSYNC_TOP_HDMI_L);
+	DUMPREG(HDMI_TG_VSYNC_TOP_HDMI_H);
+	DUMPREG(HDMI_TG_VSYNC_BOT_HDMI_L);
+	DUMPREG(HDMI_TG_VSYNC_BOT_HDMI_H);
+	DUMPREG(HDMI_TG_FIELD_TOP_HDMI_L);
+	DUMPREG(HDMI_TG_FIELD_TOP_HDMI_H);
+	DUMPREG(HDMI_TG_FIELD_BOT_HDMI_L);
+	DUMPREG(HDMI_TG_FIELD_BOT_HDMI_H);
+#undef DUMPREG
+}
+
diff --git a/drivers/media/video/s5p-tv/hdmiphy_drv.c b/drivers/media/video/s5p-tv/hdmiphy_drv.c
new file mode 100644
index 0000000..c46515a
--- /dev/null
+++ b/drivers/media/video/s5p-tv/hdmiphy_drv.c
@@ -0,0 +1,247 @@
+/*
+ * Samsung HDMI Physical interface driver
+ *
+ * Copyright (C) 2010 Samsung Electronics Co.Ltd
+ * Author: Tomasz Stanislawski <t.stanislaws@samsung.com>
+ *
+ * This program is free software; you can redistribute  it and/or modify it
+ * under  the terms of  the GNU General  Public License as published by the
+ * Free Software Foundation;  either version 2 of the  License, or (at your
+ * option) any later version.
+ */
+
+#include <linux/module.h>
+#include <linux/i2c.h>
+#include <linux/slab.h>
+#include <linux/clk.h>
+#include <linux/io.h>
+#include <linux/interrupt.h>
+#include <linux/irq.h>
+#include <linux/err.h>
+
+#include <media/v4l2-subdev.h>
+
+/* Module information */
+MODULE_AUTHOR("Tomasz Stanislawski <t.stanislaws@samsung.com>");
+MODULE_DESCRIPTION("Samsung HDMI Physical interface driver");
+MODULE_LICENSE("GPL");
+
+struct hdmiphy_conf {
+	u32 preset;
+	const u8 *data;
+};
+
+static struct i2c_driver hdmiphy_driver;
+static const struct v4l2_subdev_ops hdmiphy_ops;
+static const struct hdmiphy_conf hdmiphy_conf[];
+
+static int __init hdmiphy_init(void)
+{
+	return i2c_add_driver(&hdmiphy_driver);
+}
+module_init(hdmiphy_init);
+
+static void __exit hdmiphy_exit(void)
+{
+	i2c_del_driver(&hdmiphy_driver);
+}
+module_exit(hdmiphy_exit);
+
+static int __devinit hdmiphy_probe(struct i2c_client *client,
+	const struct i2c_device_id *id)
+{
+	static struct v4l2_subdev sd;
+	struct device *dev = &client->dev;
+	v4l2_i2c_subdev_init(&sd, client, &hdmiphy_ops);
+	dev_info(dev, "probe successful\n");
+	return 0;
+}
+
+static int __devexit hdmiphy_remove(struct i2c_client *client)
+{
+	struct device *dev = &client->dev;
+	dev_info(dev, "remove successful\n");
+	return 0;
+}
+
+static const struct i2c_device_id hdmiphy_id[] = {
+	{ "hdmiphy", 0 },
+	{ },
+};
+MODULE_DEVICE_TABLE(i2c, hdmiphy_id);
+
+static struct i2c_driver hdmiphy_driver = {
+	.driver = {
+		.name	= "s5p-hdmiphy",
+		.owner	= THIS_MODULE,
+	},
+	.probe		= hdmiphy_probe,
+	.remove		= __devexit_p(hdmiphy_remove),
+	.id_table = hdmiphy_id,
+};
+
+static int hdmiphy_s_power(struct v4l2_subdev *sd, int on)
+{
+	return 0;
+}
+
+const u8 *hdmiphy_preset2conf(u32 preset)
+{
+	int i;
+	for (i = 0; hdmiphy_conf[i].preset != V4L2_DV_INVALID; ++i)
+		if (hdmiphy_conf[i].preset == preset)
+			return hdmiphy_conf[i].data;
+	return NULL;
+}
+
+static int hdmiphy_s_dv_preset(struct v4l2_subdev *sd,
+	struct v4l2_dv_preset *preset)
+{
+	const u8 *data;
+	u8 buffer[32];
+	int ret;
+	struct i2c_client *client = v4l2_get_subdevdata(sd);
+	struct device *dev = &client->dev;
+	int x, y;
+
+	data = hdmiphy_preset2conf(preset->preset);
+	if (!data) {
+		dev_err(dev, "format not supported\n");
+		return -ENXIO;
+	}
+
+	/* storing configuration to the device */
+	memcpy(buffer, data, 32);
+	for (y = 0; y < 4; ++y) {
+		char txt[64], *p = txt;
+		for (x = 0; x < 8; ++x)
+			p += sprintf(p, "0x%02x, ", buffer[8 * y + x]);
+		dev_info(dev, "[%02d-%02d] = %s\n", 8 * y, 8 * y + 7, txt);
+	}
+	ret = i2c_master_send(client, buffer, 32);
+	if (ret != 32) {
+		dev_err(dev, "failed to configure HDMIPHY via I2C\n");
+		return -EIO;
+	}
+
+	return 0;
+}
+
+static int hdmiphy_s_stream(struct v4l2_subdev *sd, int enable)
+{
+	struct i2c_client *client = v4l2_get_subdevdata(sd);
+	struct device *dev = &client->dev;
+	u8 buffer[2];
+	int ret;
+	/* going to/from configuration from/to operation mode */
+	buffer[0] = 0x1f;
+	if (enable)
+		buffer[1] = 0x80;
+	else
+		buffer[1] = 0x00;
+
+	ret = i2c_master_send(client, buffer, 2);
+	if (ret != 2) {
+		dev_err(dev, "stream (%d) failed\n", enable);
+		return -EIO;
+	}
+	return 0;
+}
+
+static const struct v4l2_subdev_core_ops hdmiphy_core_ops = {
+	.s_power =  hdmiphy_s_power,
+};
+
+static const struct v4l2_subdev_video_ops hdmiphy_video_ops = {
+	.s_dv_preset = hdmiphy_s_dv_preset,
+	.s_stream =  hdmiphy_s_stream,
+};
+
+static const struct v4l2_subdev_ops hdmiphy_ops = {
+	.core = &hdmiphy_core_ops,
+	.video = &hdmiphy_video_ops,
+};
+
+static const u8 hdmiphy_conf27[32] = {
+	0x01, 0x05, 0x00, 0xD8, 0x10, 0x1C, 0x30, 0x40,
+	0x6B, 0x10, 0x02, 0x51, 0xDf, 0xF2, 0x54, 0x87,
+	0x84, 0x00, 0x30, 0x38, 0x00, 0x08, 0x10, 0xE0,
+	0x22, 0x40, 0xe3, 0x26, 0x00, 0x00, 0x00, 0x80,
+};
+
+static const u8 hdmiphy_conf74_175[32] = {
+	0x01, 0x05, 0x00, 0xD8, 0x10, 0x9C, 0xef, 0x5B,
+	0x6D, 0x10, 0x01, 0x51, 0xef, 0xF3, 0x54, 0xb9,
+	0x84, 0x00, 0x30, 0x38, 0x00, 0x08, 0x10, 0xE0,
+	0x22, 0x40, 0xa5, 0x26, 0x01, 0x00, 0x00, 0x80,
+};
+
+static const u8 hdmiphy_conf74_25[32] = {
+	0x01, 0x05, 0x00, 0xd8, 0x10, 0x9c, 0xf8, 0x40,
+	0x6a, 0x10, 0x01, 0x51, 0xff, 0xf1, 0x54, 0xba,
+	0x84, 0x00, 0x30, 0x38, 0x00, 0x08, 0x10, 0xe0,
+	0x22, 0x40, 0xa4, 0x26, 0x01, 0x00, 0x00, 0x80,
+};
+
+static const u8 hdmiphy_conf148_5[32] = {
+	0x01, 0x05, 0x00, 0xD8, 0x10, 0x9C, 0xf8, 0x40,
+	0x6A, 0x18, 0x00, 0x51, 0xff, 0xF1, 0x54, 0xba,
+	0x84, 0x00, 0x10, 0x38, 0x00, 0x08, 0x10, 0xE0,
+	0x22, 0x40, 0xa4, 0x26, 0x02, 0x00, 0x00, 0x80,
+};
+
+static const u8 hdmiphy_conf148_35[32] = {
+	0x01, 0x05, 0x00, 0xD8, 0x10, 0x9C, 0xef, 0x5B,
+	0x6D, 0x18, 0x00, 0x51, 0xef, 0xF3, 0x54, 0xb9,
+	0x84, 0x00, 0x30, 0x38, 0x00, 0x08, 0x10, 0xE0,
+	0x22, 0x40, 0xa5, 0x26, 0x02, 0x00, 0x00, 0x80,
+};
+
+static const struct hdmiphy_conf hdmiphy_conf[] = {
+	{ V4L2_DV_480P59_94, hdmiphy_conf27 },
+	{ V4L2_DV_1080P30, hdmiphy_conf74_175 },
+	{ V4L2_DV_720P59_94, hdmiphy_conf74_175 },
+	{ V4L2_DV_720P60, hdmiphy_conf74_25 },
+	{ V4L2_DV_1080P50, hdmiphy_conf148_5 },
+	{ V4L2_DV_1080P60, hdmiphy_conf148_5 },
+	{ V4L2_DV_1080P59_94, hdmiphy_conf148_35},
+	{ V4L2_DV_INVALID, NULL },
+};
+
+#if 0 /* original tables from EXYNOS4 manual */
+/* 27 MHz */
+0x01, 0x05, 0x00, 0xD8, 0x10, 0x1C, 0x30, 0x40,
+0x6B, 0x10, 0x02, 0x51, 0xDF, 0xF2, 0x54, 0x87,
+0x84, 0x00, 0x20, 0x38, 0x00, 0x08, 0x10, 0xE0,
+0x22, 0x40, 0xE3, 0x26, 0x00, 0x00, 0x00, 0x80
+
+/* 27.03 MHz */
+0x01, 0x05, 0x00, 0xD4, 0x10, 0x9C, 0x09, 0x64,
+0x6B, 0x10, 0x02, 0x51, 0xDF, 0xF2, 0x54, 0x87,
+0x84, 0x00, 0x20, 0x38, 0x00, 0x08, 0x10, 0xE0,
+0x22, 0x40, 0xE2, 0x26, 0x00, 0x00, 0x00, 0x80
+
+/* 74.18 */
+0x01, 0x05, 0x00, 0xD8, 0x10, 0x9C, 0xEF, 0x5B,
+0x6D, 0x10, 0x01, 0x51, 0xEF, 0xF3, 0x54, 0xB9,
+0x84, 0x00, 0x20, 0x38, 0x00, 0x08, 0x10, 0xE0,
+0x22, 0x40, 0xA5, 0x26, 0x01, 0x00, 0x00, 0x80
+
+/* 74.24 */
+0x01, 0x05, 0x00, 0xD8, 0x10, 0x9C, 0xF8, 0x40,
+0x6A, 0x10, 0x01, 0x51, 0xFF, 0xF1, 0x54, 0xBA,
+0x84, 0x00, 0x00, 0x38, 0x00, 0x08, 0x10, 0xE0,
+0x22, 0x40, 0xA4, 0x26, 0x01, 0x00, 0x00, 0x80
+
+/* 148.35 */
+0x01, 0x05, 0x00, 0xD8, 0x10, 0x9C, 0xEF, 0x5B,
+0x6D, 0x18, 0x00, 0x51, 0xEF, 0xF3, 0x54, 0xB9,
+0x84, 0x00, 0x20, 0x38, 0x00, 0x08, 0x10, 0xE0,
+0x22, 0x40, 0xA5, 0x26, 0x02, 0x00, 0x00, 0x80
+
+/* 148.5 */
+0x01, 0x05, 0x00, 0xD8, 0x10, 0x9C, 0xF8, 0x40,
+0x6A, 0x18, 0x00, 0x51, 0xFF, 0xF1, 0x54, 0xBA,
+0x84, 0x00, 0x00, 0x38, 0x00, 0x08, 0x10, 0xE0,
+0x22, 0x40, 0xA4, 0x26, 0x02, 0x00, 0x00, 0x80,
+#endif
diff --git a/drivers/media/video/s5p-tv/mixer.h b/drivers/media/video/s5p-tv/mixer.h
new file mode 100644
index 0000000..6ef41fa
--- /dev/null
+++ b/drivers/media/video/s5p-tv/mixer.h
@@ -0,0 +1,329 @@
+/*
+ * Samsung TV Mixer driver
+ *
+ * Copyright (c) 2010 Samsung Electronics
+ *
+ * Tomasz Stanislawski, t.stanislaws@samsung.com
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published
+ * by the Free Software Foundiation. either version 2 of the License,
+ * or (at your option) any later version
+ */
+
+#ifndef _SAMSUNG_MIXER_H_
+#define _SAMSUNG_MIXER_H_
+
+#include <linux/fb.h>
+#include <linux/kernel.h>
+#include <linux/spinlock.h>
+#include <linux/wait.h>
+#include <media/v4l2-device.h>
+#include <media/videobuf2-core.h>
+
+#include "regs-vmx.h"
+
+/** maximum number of output interfaces */
+#define MXR_OUTPUTS 2
+/** maximum number of input interfaces (layers) */
+#define MXR_MAX_LAYERS 3
+#define MXR_DRIVER_NAME "s5p-mixer"
+/** maximal number of planes for every layer */
+#define MXR_MAX_PLANES	2
+
+#define MXR_ENABLE 1
+#define MXR_DISABLE 0
+
+/** description of a macroblock for packed formats */
+struct mxr_block {
+	/** vertical number of pixels in macroblock */
+	unsigned int pxWidth:8;
+	/** horizontal number of pixels in macroblock */
+	unsigned int pxHeight:8;
+	/** size of block in bytes */
+	unsigned int bSize:16;
+};
+
+/** description of supported format */
+struct mxr_format {
+	/** format name/mnemonic */
+	char *name;
+	/** fourcc identifier */
+	u32 fourcc;
+	/** number of planes in image data */
+	int num_planes;
+	/** description of block for each plane */
+	struct mxr_block plane[MXR_MAX_PLANES];
+	/** number of subframes in image data */
+	int num_subframes;
+	/** specifies to which subframe belong given plane */
+	int plane2subframe[MXR_MAX_PLANES];
+	/** internal code, driver dependant */
+	unsigned long hwCode;
+};
+
+/** description of crop configuration for image */
+struct mxr_crop {
+	/** width of layer in pixels */
+	unsigned int full_width;
+	/** height of layer in pixels */
+	unsigned int full_height;
+	/** horizontal offset of first pixel to be displayed */
+	unsigned int x_offset;
+	/** vertical offset of first pixel to be displayed */
+	unsigned int y_offset;
+	/** width of displayed data in pixels */
+	unsigned int width;
+	/** height of displayed data in pixels */
+	unsigned int height;
+	/** indicate which fields are present in buffer */
+	unsigned int field;
+};
+
+/** description of transformation from source to destination image */
+struct mxr_geometry {
+	/** cropping for source image */
+	struct mxr_crop src;
+	/** cropping for destination image */
+	struct mxr_crop dst;
+	/** layer-dependant description of horizontal scaling */
+	unsigned int x_ratio;
+	/** layer-dependant description of vertical scaling */
+	unsigned int y_ratio;
+};
+
+/** instance of a buffer */
+struct mxr_buffer {
+	/** common v4l buffer stuff -- must be first */
+	struct vb2_buffer	vb;
+	/** node for layer's lists */
+	struct list_head	list;
+};
+
+
+/** internal states of layer */
+enum mxr_layer_state {
+	/** layers is not shown */
+	MXR_LAYER_IDLE = 0,
+	/** state between STREAMON and hardware start */
+	MXR_LAYER_STREAMING_START,
+	/** layer is shown */
+	MXR_LAYER_STREAMING,
+	/** state before STREAMOFF is finished */
+	MXR_LAYER_STREAMING_FINISH,
+};
+
+/** forward declarations */
+struct mxr_device;
+struct mxr_layer;
+
+/** callback for layers operation */
+struct mxr_layer_ops {
+	/* TODO: try to port it to subdev API */
+	/** handler for resource release function */
+	void (*release)(struct mxr_layer *);
+	/** setting buffer to HW */
+	void (*buffer_set)(struct mxr_layer *, struct mxr_buffer *);
+	/** setting format and geometry in HW */
+	void (*format_set)(struct mxr_layer *);
+	/** streaming stop/start */
+	void (*stream_set)(struct mxr_layer *, int);
+	/** adjusting geometry */
+	void (*fix_geometry)(struct mxr_layer *);
+};
+
+/** layer instance, a single window and content displayed on output */
+struct mxr_layer {
+	/** parent mixer device */
+	struct mxr_device *mdev;
+	/** layer index (unique identifier) */
+	int idx;
+	/** callbacks for layer methods */
+	struct mxr_layer_ops ops;
+	/** format array */
+	const struct mxr_format **fmt_array;
+	/** size of format array */
+	unsigned long fmt_array_size;
+
+	/** lock for protection of list and state fields */
+	spinlock_t enq_slock;
+	/** list for enqueued buffers */
+	struct list_head enq_list;
+	/** buffer currently owned by hardware in temporary registers */
+	struct mxr_buffer *update_buf;
+	/** buffer currently owned by hardware in shadow registers */
+	struct mxr_buffer *shadow_buf;
+	/** state of layer IDLE/STREAMING */
+	enum mxr_layer_state state;
+
+	/** mutex for protection of fields below */
+	struct mutex mutex;
+	/** use count */
+	int n_user;
+	/** handler for video node */
+	struct video_device vfd;
+	/** queue for output buffers */
+	struct vb2_queue vb_queue;
+	/** current image format */
+	const struct mxr_format *fmt;
+	/** current geometry of image */
+	struct mxr_geometry geo;
+};
+
+/** description of mixers output interface */
+struct mxr_output {
+	/** name of output */
+	char name[32];
+	/** output subdev */
+	struct v4l2_subdev *sd;
+	/** cookie used for configuration of registers */
+	int cookie;
+};
+
+/** specify source of output subdevs */
+struct mxr_output_conf {
+	/** name of output (connector) */
+	char *output_name;
+	/** name of module that generates output subdev */
+	char *module_name;
+	/** cookie need for mixer HW */
+	int cookie;
+};
+
+struct clk;
+struct regulator;
+
+/** auxiliary resources used my mixer */
+struct mxr_resources {
+	/** interrupt index */
+	int irq;
+	/** pointer to Mixer registers */
+	void __iomem *mxr_regs;
+	/** pointer to Video Processor registers */
+	void __iomem *vp_regs;
+	/** other resources, should used under mxr_device.mutex */
+	struct clk *mixer;
+	struct clk *vp;
+	struct clk *sclk_mixer;
+	struct clk *sclk_hdmi;
+	struct clk *sclk_dac;
+};
+
+/** drivers instance */
+struct mxr_device {
+	/** master device */
+	struct device *dev;
+	/** state of each layer */
+	struct mxr_layer *layer[MXR_MAX_LAYERS];
+	/** state of each output */
+	struct mxr_output *output[MXR_OUTPUTS];
+
+	/* video resources */
+
+	/** V4L2 device */
+	struct v4l2_device v4l2_dev;
+	/** pointer to IOMMU device */
+	struct device *iommu_dev;
+	/** context of allocator */
+	void *alloc_ctx;
+
+	/** spinlock for protection of registers */
+	spinlock_t reg_slock;
+
+	/** mutex for protection of fields below */
+	struct mutex mutex;
+	/** number of power consumers */
+	int n_power;
+	/** number of entities depndant on output configuration */
+	int n_output;
+	/** number of users that do streaming */
+	int n_streamer;
+	/** index of current output */
+	int current_output;
+	/** auxiliary resources used my mixer */
+	struct mxr_resources res;
+};
+
+/** transform device structure into mixer device */
+static inline struct mxr_device *to_mdev(struct device *dev)
+{
+	struct v4l2_device *vdev = dev_get_drvdata(dev);
+	return container_of(vdev, struct mxr_device, v4l2_dev);
+}
+
+/** get current output data, should be called under mdev's mutex */
+static inline struct mxr_output *to_output(struct mxr_device *mdev)
+{
+	return mdev->output[mdev->current_output];
+}
+
+/** get current output subdev, should be called under mdev's mutex */
+static inline struct v4l2_subdev *to_outsd(struct mxr_device *mdev)
+{
+	struct mxr_output *out = to_output(mdev);
+	return out ? out->sd : NULL;
+}
+
+/** forward declaration for mixer platform data */
+struct mxr_platform_data;
+
+/** acquiring common video resources */
+int __devinit mxr_acquire_video(struct mxr_device *mdev,
+	struct mxr_output_conf *output_cont, int output_count);
+
+/** releasing common video resources */
+void __devexit mxr_release_video(struct mxr_device *mdev);
+
+struct mxr_layer *mxr_graph_layer_create(struct mxr_device *mdev, int idx);
+struct mxr_layer *mxr_vp_layer_create(struct mxr_device *mdev, int idx);
+struct mxr_layer *mxr_base_layer_create(struct mxr_device *mdev,
+	int idx, char *name, struct mxr_layer_ops *ops);
+
+void mxr_base_layer_release(struct mxr_layer *layer);
+void mxr_layer_release(struct mxr_layer *layer);
+
+int mxr_base_layer_register(struct mxr_layer *layer);
+void mxr_base_layer_unregister(struct mxr_layer *layer);
+
+unsigned long mxr_get_plane_size(const struct mxr_block *blk,
+	unsigned int width, unsigned int height);
+
+/** adds new consumer for mixer's power */
+void mxr_power_get(struct mxr_device *mdev);
+/** removes consumer for mixer's power */
+void mxr_power_put(struct mxr_device *mdev);
+/** add new client for output configuration */
+void mxr_output_get(struct mxr_device *mdev);
+/** removes new client for output configuration */
+void mxr_output_put(struct mxr_device *mdev);
+/** add new client for streaming */
+void mxr_streamer_get(struct mxr_device *mdev);
+/** removes new client for streaming */
+void mxr_streamer_put(struct mxr_device *mdev);
+/** returns format of data delivared to current output */
+void mxr_get_mbus_fmt(struct mxr_device *mdev,
+	struct v4l2_mbus_framefmt *mbus_fmt);
+
+/* Debug */
+
+#define MXR_CHECK printk(KERN_ERR "%s:%d\n", __func__, __LINE__)
+
+#define mxr_printk(mdev, level, fmt, ...)				\
+do {									\
+	extern int mxr_log_level;					\
+	(void) (mdev == (struct mxr_device *)NULL); /* type check */	\
+	if (level <= CONFIG_VIDEO_SAMSUNG_S5P_MIXER_LOG_LEVEL		\
+		&& level <= mxr_log_level) {				\
+		char prefix[4] = "<*>";					\
+		prefix[1] = '0' + level;				\
+		dev_printk(prefix, mdev->dev, fmt, ##__VA_ARGS__);	\
+	}								\
+} while (0)
+
+#define mxr_err(mdev, fmt, ...)  mxr_printk(mdev, 3, fmt, ##__VA_ARGS__)
+#define mxr_warn(mdev, fmt, ...) mxr_printk(mdev, 4, fmt, ##__VA_ARGS__)
+#define mxr_info(mdev, fmt, ...) mxr_printk(mdev, 6, fmt, ##__VA_ARGS__)
+#define mxr_dbg(mdev, fmt, ...)  mxr_printk(mdev, 7, fmt, ##__VA_ARGS__)
+
+#endif /* _SAMSUNG_MIXER_H_ */
+
diff --git a/drivers/media/video/s5p-tv/mixer_drv.c b/drivers/media/video/s5p-tv/mixer_drv.c
new file mode 100644
index 0000000..82a4248
--- /dev/null
+++ b/drivers/media/video/s5p-tv/mixer_drv.c
@@ -0,0 +1,493 @@
+/*
+ * Samsung TV Mixer driver
+ *
+ * Copyright (c) 2010 Samsung Electronics
+ *
+ * Tomasz Stanislawski, t.stanislaws@samsung.com
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published
+ * by the Free Software Foundiation. either version 2 of the License,
+ * or (at your option) any later version
+ */
+
+#include "mixer.h"
+#include "mixer_reg.h"
+
+#include <linux/module.h>
+#include <linux/platform_device.h>
+#include <linux/io.h>
+#include <linux/interrupt.h>
+#include <linux/irq.h>
+#include <linux/fb.h>
+#include <linux/delay.h>
+#include <linux/pm_runtime.h>
+#include <linux/clk.h>
+
+#include <media/videobuf2-dma-iommu.h>
+#include <plat/sysmmu.h>
+
+MODULE_AUTHOR("Tomasz Stanislawski, t.stanislaws@samsung.com");
+MODULE_DESCRIPTION("Samsung MIXER");
+MODULE_LICENSE("GPL");
+
+/* --------- DRIVER PARAMETERS ---------- */
+
+int mxr_log_level = 6;
+module_param_named(debug, mxr_log_level, int, S_IRUGO | S_IWUSR);
+
+static struct mxr_output_conf mxr_output_conf[] = {
+	{
+		.output_name = "S5P SDO connector",
+		.module_name = "s5p-sdo",
+		.cookie = 0,
+	},
+	{
+		.output_name = "S5P HDMI connector",
+		.module_name = "s5p-hdmi",
+		.cookie = 1,
+	},
+};
+
+/* --------- DRIVER INITIALIZATION ---------- */
+
+static struct platform_driver mxr_driver __refdata;
+
+static int __init mxr_init(void)
+{
+	int ret;
+	static const char banner[] __initdata = KERN_INFO
+		"Samsung TV Mixer driver, (c) 2010 Samsung Electronics\n";
+	printk(banner);
+
+	ret = platform_driver_register(&mxr_driver);
+	if (ret != 0) {
+		printk(KERN_ERR "registration of MIXER driver failed\n");
+		return -ENXIO;
+	}
+
+	return 0;
+}
+module_init(mxr_init);
+
+static void __exit mxr_exit(void)
+{
+	platform_driver_unregister(&mxr_driver);
+}
+module_exit(mxr_exit);
+
+static int __devinit mxr_acquire_resources(struct mxr_device *mdev,
+	struct platform_device *pdev);
+
+static void mxr_release_resources(struct mxr_device *mdev);
+
+static int __devinit mxr_acquire_layers(struct mxr_device *mdev,
+	struct mxr_platform_data *pdata);
+
+static void mxr_release_layers(struct mxr_device *mxr_dev);
+
+static int __devinit mxr_probe(struct platform_device *pdev)
+{
+	struct device *dev = &pdev->dev;
+	struct mxr_platform_data *pdata = dev->platform_data;
+	struct mxr_device *mdev;
+	int ret;
+
+	/* mdev does not exist yet so no mxr_dbg is used */
+	dev_info(dev, "probe start\n");
+
+	mdev = kzalloc(sizeof *mdev, GFP_KERNEL);
+	if (!mdev) {
+		mxr_err(mdev, "not enough memory.\n");
+		ret = -ENOMEM;
+		goto fail;
+	}
+
+	/* setup pointer to master device */
+	mdev->dev = dev;
+
+	mutex_init(&mdev->mutex);
+	spin_lock_init(&mdev->reg_slock);
+
+	/* acquire resources: regs, irqs, clocks, regulators */
+	ret = mxr_acquire_resources(mdev, pdev);
+	if (ret)
+		goto fail_mem;
+
+	/* configure resources for video output */
+	ret = mxr_acquire_video(mdev, mxr_output_conf,
+		ARRAY_SIZE(mxr_output_conf));
+	if (ret)
+		goto fail_resources;
+
+	/* configure layers */
+	ret = mxr_acquire_layers(mdev, pdata);
+	if (ret)
+		goto fail_video;
+
+	pm_runtime_set_active(dev);
+	pm_runtime_enable(dev);
+
+	mxr_info(mdev, "probe successful\n");
+	return 0;
+
+fail_video:
+	mxr_release_video(mdev);
+
+fail_resources:
+	mxr_release_resources(mdev);
+
+fail_mem:
+	kfree(mdev);
+
+fail:
+	dev_info(dev, "probe failed\n");
+	return ret;
+}
+
+static int __devexit mxr_remove(struct platform_device *pdev)
+{
+	struct device *dev = &pdev->dev;
+	struct mxr_device *mdev = to_mdev(dev);
+
+	pm_runtime_disable(dev);
+
+	mxr_release_layers(mdev);
+	mxr_release_video(mdev);
+	mxr_release_resources(mdev);
+
+	kfree(mdev);
+
+	dev_info(dev, "remove sucessful\n");
+	return 0;
+}
+
+static int mxr_runtime_suspend(struct device *dev)
+{
+	dev_info(dev, "%s\n", __func__);
+	return 0;
+}
+
+static int mxr_runtime_resume(struct device *dev)
+{
+	dev_info(dev, "%s\n", __func__);
+	return 0;
+}
+
+static const struct dev_pm_ops mxr_pm_ops = {
+	.runtime_suspend = mxr_runtime_suspend,
+	.runtime_resume	 = mxr_runtime_resume,
+};
+
+static struct platform_driver mxr_driver __refdata = {
+	.probe = mxr_probe,
+	.remove = __devexit_p(mxr_remove),
+	.driver = {
+		.name = MXR_DRIVER_NAME,
+		.owner = THIS_MODULE,
+		.pm = &mxr_pm_ops,
+	}
+};
+
+static int __devinit mxr_acquire_plat_resources(struct mxr_device *mdev,
+	struct platform_device *pdev)
+{
+	struct resource *res;
+	int ret;
+	res = platform_get_resource_byname(pdev, IORESOURCE_MEM, "mxr");
+	if (res == NULL) {
+		mxr_err(mdev, "get memory resource failed.\n");
+		ret = -ENXIO;
+		goto fail;
+	}
+
+	mdev->res.mxr_regs = ioremap(res->start, resource_size(res));
+	if (mdev->res.mxr_regs == NULL) {
+		mxr_err(mdev, "register mapping failed.\n");
+		ret = -ENXIO;
+		goto fail;
+	}
+
+	res = platform_get_resource_byname(pdev, IORESOURCE_MEM, "vp");
+	if (res == NULL) {
+		mxr_err(mdev, "get memory resource failed.\n");
+		ret = -ENXIO;
+		goto fail_mxr_regs;
+	}
+
+	mdev->res.vp_regs = ioremap(res->start, resource_size(res));
+	if (mdev->res.vp_regs == NULL) {
+		mxr_err(mdev, "register mapping failed.\n");
+		ret = -ENXIO;
+		goto fail_mxr_regs;
+	}
+
+	res = platform_get_resource_byname(pdev, IORESOURCE_IRQ, "irq");
+	if (res == NULL) {
+		mxr_err(mdev, "get interrupt resource failed.\n");
+		ret = -ENXIO;
+		goto fail_vp_regs;
+	}
+
+	ret = request_irq(res->start, mxr_irq_handler, 0, "s5p-mixer", mdev);
+	if (ret) {
+		mxr_err(mdev, "request interrupt failed.\n");
+		goto fail_vp_regs;
+	}
+	mdev->res.irq = res->start;
+
+	return 0;
+
+fail_vp_regs:
+	iounmap(mdev->res.vp_regs);
+
+fail_mxr_regs:
+	iounmap(mdev->res.mxr_regs);
+
+fail:
+	return ret;
+}
+
+static void mxr_release_plat_resources(struct mxr_device *mdev)
+{
+	free_irq(mdev->res.irq, mdev);
+	iounmap(mdev->res.vp_regs);
+	iounmap(mdev->res.mxr_regs);
+}
+
+static void mxr_release_clocks(struct mxr_device *mdev)
+{
+	struct mxr_resources *res = &mdev->res;
+
+	if (!IS_ERR_OR_NULL(res->sclk_dac))
+		clk_put(res->sclk_dac);
+	if (!IS_ERR_OR_NULL(res->sclk_hdmi))
+		clk_put(res->sclk_hdmi);
+	if (!IS_ERR_OR_NULL(res->sclk_mixer))
+		clk_put(res->sclk_mixer);
+	if (!IS_ERR_OR_NULL(res->vp))
+		clk_put(res->vp);
+	if (!IS_ERR_OR_NULL(res->mixer))
+		clk_put(res->mixer);
+}
+
+static int mxr_acquire_clocks(struct mxr_device *mdev)
+{
+	struct mxr_resources *res = &mdev->res;
+	struct device *dev = mdev->dev;
+
+	res->mixer = clk_get(dev, "mixer");
+	if (IS_ERR_OR_NULL(res->mixer)) {
+		mxr_err(mdev, "failed to get clock 'mixer'\n");
+		goto fail;
+	}
+	res->vp = clk_get(dev, "vp");
+	if (IS_ERR_OR_NULL(res->vp)) {
+		mxr_err(mdev, "failed to get clock 'vp'\n");
+		goto fail;
+	}
+	res->sclk_mixer = clk_get(dev, "sclk_mixer");
+	if (IS_ERR_OR_NULL(res->sclk_mixer)) {
+		mxr_err(mdev, "failed to get clock 'sclk_mixer'\n");
+		goto fail;
+	}
+	res->sclk_hdmi = clk_get(dev, "sclk_hdmi");
+	if (IS_ERR_OR_NULL(res->sclk_hdmi)) {
+		mxr_err(mdev, "failed to get clock 'sclk_hdmi'\n");
+		goto fail;
+	}
+	res->sclk_dac = clk_get(dev, "sclk_dac");
+	if (IS_ERR_OR_NULL(res->sclk_dac)) {
+		mxr_err(mdev, "failed to get clock 'sclk_dac'\n");
+		goto fail;
+	}
+
+	return 0;
+fail:
+	mxr_release_clocks(mdev);
+	return -ENODEV;
+}
+
+static int __devinit mxr_acquire_resources(struct mxr_device *mdev,
+	struct platform_device *pdev)
+{
+	int ret;
+	ret = mxr_acquire_plat_resources(mdev, pdev);
+	if (ret)
+		goto fail;
+
+	ret = mxr_acquire_clocks(mdev);
+	if (ret)
+		goto fail_plat;
+
+	mxr_info(mdev, "resources acquired\n");
+	return 0;
+
+fail_plat:
+	mxr_release_plat_resources(mdev);
+fail:
+	mxr_err(mdev, "resources acquire failed\n");
+	return ret;
+}
+
+static void mxr_release_resources(struct mxr_device *mdev)
+{
+	mxr_release_clocks(mdev);
+	mxr_release_plat_resources(mdev);
+	memset(&mdev->res, 0, sizeof mdev->res);
+}
+
+static int __devinit mxr_acquire_layers(struct mxr_device *mdev,
+	struct mxr_platform_data *pdata)
+{
+	mdev->layer[0] = mxr_graph_layer_create(mdev, 0);
+	mdev->layer[1] = mxr_graph_layer_create(mdev, 1);
+	mdev->layer[2] = mxr_vp_layer_create(mdev, 0);
+
+	if (!mdev->layer[0] || !mdev->layer[1] || !mdev->layer[2]) {
+		mxr_err(mdev, "failed to acquire layers\n");
+		goto fail;
+	}
+
+	return 0;
+
+fail:
+	mxr_release_layers(mdev);
+	return -ENODEV;
+}
+
+static void mxr_release_layers(struct mxr_device *mdev)
+{
+	int i;
+	for (i = 0; i < ARRAY_SIZE(mdev->layer); ++i)
+		if (mdev->layer[i])
+			mxr_layer_release(mdev->layer[i]);
+}
+
+void mxr_power_get(struct mxr_device *mdev)
+{
+	struct device *dev = mdev->dev;
+
+	mutex_lock(&mdev->mutex);
+	++mdev->n_power;
+	mxr_dbg(mdev, "%s(%d)\n", __func__, mdev->n_power);
+	if (mdev->n_power == 1) {
+		struct mxr_resources *res = &mdev->res;
+		/* enable sysmmu */
+		vb2_dma_iommu_enable(mdev->alloc_ctx);
+		/* power on */
+		pm_runtime_get_sync(dev);
+		/* turn clocks on */
+		clk_enable(res->mixer);
+		clk_enable(res->vp);
+		clk_enable(res->sclk_mixer);
+		/* apply default configuration */
+		mxr_reg_reset(mdev);
+	}
+	mutex_unlock(&mdev->mutex);
+}
+
+void mxr_power_put(struct mxr_device *mdev)
+{
+	struct device *dev = mdev->dev;
+
+	mutex_lock(&mdev->mutex);
+	--mdev->n_power;
+	mxr_dbg(mdev, "%s(%d)\n", __func__, mdev->n_power);
+	if (mdev->n_power == 0) {
+		struct mxr_resources *res = &mdev->res;
+		/* turn clocks off */
+		clk_disable(res->sclk_mixer);
+		clk_disable(res->vp);
+		clk_disable(res->mixer);
+		/* power off */
+		pm_runtime_put_sync(dev);
+		/* disable sysmmu */
+		vb2_dma_iommu_disable(mdev->alloc_ctx);
+	}
+	WARN(mdev->n_power < 0, "negative number of power users (%d)\n",
+		mdev->n_power);
+	mutex_unlock(&mdev->mutex);
+}
+
+void mxr_get_mbus_fmt(struct mxr_device *mdev,
+	struct v4l2_mbus_framefmt *mbus_fmt)
+{
+	struct v4l2_subdev *sd;
+	int ret;
+	mutex_lock(&mdev->mutex);
+	sd = to_outsd(mdev);
+	ret = v4l2_subdev_call(sd, video, g_mbus_fmt, mbus_fmt);
+	WARN(ret, "failed to get mbus_fmt for output %s\n", sd->name);
+	mutex_unlock(&mdev->mutex);
+}
+
+void mxr_streamer_get(struct mxr_device *mdev)
+{
+	mutex_lock(&mdev->mutex);
+	++mdev->n_streamer;
+	mxr_dbg(mdev, "%s(%d)\n", __func__, mdev->n_streamer);
+	if (mdev->n_streamer == 1) {
+		struct v4l2_subdev *sd = to_outsd(mdev);
+		struct v4l2_mbus_framefmt mbus_fmt;
+		struct mxr_resources *res = &mdev->res;
+		int ret;
+		ret = v4l2_subdev_call(sd, video, g_mbus_fmt, &mbus_fmt);
+		WARN(ret, "failed to get mbus_fmt for output %s\n", sd->name);
+		mxr_reg_set_mbus_fmt(mdev, &mbus_fmt);
+		mxr_reg_s_output(mdev, to_output(mdev)->cookie);
+		if (to_output(mdev)->cookie == 0)
+			clk_set_parent(res->sclk_mixer, res->sclk_dac);
+		else
+			clk_set_parent(res->sclk_mixer, res->sclk_hdmi);
+		mxr_reg_streamon(mdev);
+		ret = v4l2_subdev_call(sd, video, s_stream, 1);
+		WARN(ret, "starting stream failed for output %s\n", sd->name);
+	}
+	mutex_unlock(&mdev->mutex);
+	mxr_reg_dump(mdev);
+	/* FIXME: what to do when streaming fails? */
+}
+
+void mxr_streamer_put(struct mxr_device *mdev)
+{
+	mutex_lock(&mdev->mutex);
+	--mdev->n_streamer;
+	mxr_dbg(mdev, "%s(%d)\n", __func__, mdev->n_streamer);
+	if (mdev->n_streamer == 0) {
+		int ret;
+		struct v4l2_subdev *sd = to_outsd(mdev);
+		mxr_reg_streamoff(mdev);
+		ret = v4l2_subdev_call(sd, video, s_stream, 0);
+		WARN(ret, "stopping stream failed for output %s\n", sd->name);
+	}
+	WARN(mdev->n_streamer < 0, "negative number of streamers (%d)\n",
+		mdev->n_streamer);
+	mutex_unlock(&mdev->mutex);
+	mxr_reg_dump(mdev);
+}
+
+void mxr_output_get(struct mxr_device *mdev)
+{
+	mutex_lock(&mdev->mutex);
+	++mdev->n_output;
+	mxr_dbg(mdev, "%s(%d)\n", __func__, mdev->n_output);
+	/* turn on auxliary driver */
+	if (mdev->n_output == 1)
+		v4l2_subdev_call(to_outsd(mdev), core, s_power, 1);
+	mutex_unlock(&mdev->mutex);
+}
+
+void mxr_output_put(struct mxr_device *mdev)
+{
+	mutex_lock(&mdev->mutex);
+	--mdev->n_output;
+	mxr_dbg(mdev, "%s(%d)\n", __func__, mdev->n_output);
+	/* turn on auxliary driver */
+	if (mdev->n_output == 0)
+		v4l2_subdev_call(to_outsd(mdev), core, s_power, 0);
+	WARN(mdev->n_output < 0, "negative number of output users (%d)\n",
+		mdev->n_output);
+	mutex_unlock(&mdev->mutex);
+}
+
diff --git a/drivers/media/video/s5p-tv/mixer_grp_layer.c b/drivers/media/video/s5p-tv/mixer_grp_layer.c
new file mode 100644
index 0000000..fcf2b67
--- /dev/null
+++ b/drivers/media/video/s5p-tv/mixer_grp_layer.c
@@ -0,0 +1,180 @@
+/*
+ * Samsung TV Mixer driver
+ *
+ * Copyright (c) 2010 Samsung Electronics
+ *
+ * Tomasz Stanislawski, t.stanislaws@samsung.com
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published
+ * by the Free Software Foundiation. either version 2 of the License,
+ * or (at your option) any later version
+ */
+
+#include "mixer.h"
+#include "mixer_reg.h"
+
+#include <media/videobuf2-dma-iommu.h>
+
+/* FORMAT DEFINITIONS */
+
+static const struct mxr_format mxr_fb_fmt_rgb565 = {
+	.name = "RGB565",
+	.fourcc = V4L2_PIX_FMT_RGB565,
+	.num_planes = 1,
+	.plane = {
+		{ .pxWidth = 1, .pxHeight = 1, .bSize = 2 },
+	},
+	.num_subframes = 1,
+	.hwCode = 4,
+};
+
+static const struct mxr_format mxr_fb_fmt_argb1555 = {
+	.name = "ARGB1555",
+	.num_planes = 1,
+	.fourcc = V4L2_PIX_FMT_RGB555,
+	.plane = {
+		{ .pxWidth = 1, .pxHeight = 1, .bSize = 2 },
+	},
+	.num_subframes = 1,
+	.hwCode = 5,
+};
+
+static const struct mxr_format mxr_fb_fmt_argb4444 = {
+	.name = "ARGB4444",
+	.num_planes = 1,
+	.fourcc = V4L2_PIX_FMT_RGB444,
+	.plane = {
+		{ .pxWidth = 1, .pxHeight = 1, .bSize = 2 },
+	},
+	.num_subframes = 1,
+	.hwCode = 6,
+};
+
+static const struct mxr_format mxr_fb_fmt_argb8888 = {
+	.name = "ARGB8888",
+	.fourcc = V4L2_PIX_FMT_BGR32,
+	.num_planes = 1,
+	.plane = {
+		{ .pxWidth = 1, .pxHeight = 1, .bSize = 4 },
+	},
+	.num_subframes = 1,
+	.hwCode = 7,
+};
+
+static const struct mxr_format *mxr_graph_format[] = {
+	&mxr_fb_fmt_rgb565,
+	&mxr_fb_fmt_argb1555,
+	&mxr_fb_fmt_argb4444,
+	&mxr_fb_fmt_argb8888,
+};
+
+/* AUXILIARY CALLBACKS */
+
+static void mxr_graph_layer_release(struct mxr_layer *layer)
+{
+	mxr_base_layer_unregister(layer);
+	mxr_base_layer_release(layer);
+}
+
+static void mxr_graph_buffer_set(struct mxr_layer *layer,
+	struct mxr_buffer *buf)
+{
+	dma_addr_t addr = 0;
+	if (buf)
+		addr = vb2_dma_iommu_plane_addr(&buf->vb, 0);
+	mxr_reg_graph_buffer(layer->mdev, layer->idx, addr);
+}
+
+static void mxr_graph_stream_set(struct mxr_layer *layer, int en)
+{
+	mxr_reg_graph_layer_stream(layer->mdev, layer->idx, en);
+}
+
+static void mxr_graph_format_set(struct mxr_layer *layer)
+{
+	mxr_reg_graph_format(layer->mdev, layer->idx,
+		layer->fmt, &layer->geo);
+}
+
+static void mxr_graph_fix_geometry(struct mxr_layer *layer)
+{
+	struct mxr_geometry *geo = &layer->geo;
+	/* limit to boundary size */
+	geo->src.full_width = clamp_val(geo->src.full_width, 1, 32767);
+	geo->src.full_height = clamp_val(geo->src.full_height, 1, 2047);
+	geo->src.width = clamp_val(geo->src.width, 1, geo->src.full_width);
+	geo->src.width = min(geo->src.width, 2047U);
+	/* not possible to crop of Y axis */
+	geo->src.y_offset = min(geo->src.y_offset, geo->src.full_height - 1);
+	geo->src.height = geo->src.full_height - geo->src.y_offset;
+	/* limitting offset */
+	geo->src.x_offset = min(geo->src.x_offset,
+		geo->src.full_width - geo->src.width);
+
+	/* setting position in output */
+	geo->dst.width = min(geo->dst.width, geo->dst.full_width);
+	geo->dst.height = min(geo->dst.height, geo->dst.full_height);
+
+	/* Mixer supports only 1x and 2x scaling */
+	if (geo->dst.width >= 2 * geo->src.width) {
+		geo->x_ratio = 1;
+		geo->dst.width = 2 * geo->src.width;
+	} else {
+		geo->x_ratio = 0;
+		geo->dst.width = geo->src.width;
+	}
+
+	if (geo->dst.height >= 2 * geo->src.height) {
+		geo->y_ratio = 1;
+		geo->dst.height = 2 * geo->src.height;
+	} else {
+		geo->y_ratio = 0;
+		geo->dst.height = geo->src.height;
+	}
+
+	geo->dst.x_offset = min(geo->dst.x_offset,
+		geo->dst.full_width - geo->dst.width);
+	geo->dst.y_offset = min(geo->dst.y_offset,
+		geo->dst.full_height - geo->dst.height);
+}
+
+/* PUBLIC API */
+
+struct mxr_layer *mxr_graph_layer_create(struct mxr_device *mdev, int idx)
+{
+	struct mxr_layer *layer;
+	int ret;
+	struct mxr_layer_ops ops = {
+		.release = mxr_graph_layer_release,
+		.buffer_set = mxr_graph_buffer_set,
+		.stream_set = mxr_graph_stream_set,
+		.format_set = mxr_graph_format_set,
+		.fix_geometry = mxr_graph_fix_geometry,
+	};
+	char name[32];
+
+	sprintf(name, "graph%d", idx);
+
+	layer = mxr_base_layer_create(mdev, idx, name, &ops);
+	if (layer == NULL) {
+		mxr_err(mdev, "failed to initialize layer(%d) base\n", idx);
+		goto fail;
+	}
+
+	layer->fmt_array = mxr_graph_format;
+	layer->fmt_array_size = ARRAY_SIZE(mxr_graph_format);
+
+	ret = mxr_base_layer_register(layer);
+	if (ret)
+		goto fail_layer;
+
+	return layer;
+
+fail_layer:
+	mxr_base_layer_release(layer);
+
+fail:
+	return NULL;
+}
+
diff --git a/drivers/media/video/s5p-tv/mixer_reg.c b/drivers/media/video/s5p-tv/mixer_reg.c
new file mode 100644
index 0000000..d8f85a0
--- /dev/null
+++ b/drivers/media/video/s5p-tv/mixer_reg.c
@@ -0,0 +1,543 @@
+/*
+ * Samsung TV Mixer driver
+ *
+ * Copyright (c) 2010 Samsung Electronics
+ *
+ * Tomasz Stanislawski, t.stanislaws@samsung.com
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published
+ * by the Free Software Foundiation. either version 2 of the License,
+ * or (at your option) any later version
+ */
+
+#include "mixer_reg.h"
+#include "regs-vmx.h"
+#include "regs-vp.h"
+
+#include <linux/delay.h>
+
+/* Register access subroutines */
+
+static inline u32 vp_read(struct mxr_device *mdev, u32 reg_id)
+{
+	return readl(mdev->res.vp_regs + reg_id);
+}
+
+static inline void vp_write(struct mxr_device *mdev, u32 reg_id, u32 val)
+{
+	writel(val, mdev->res.vp_regs + reg_id);
+}
+
+static inline void vp_write_mask(struct mxr_device *mdev, u32 reg_id,
+	u32 val, u32 mask)
+{
+	u32 old = vp_read(mdev, reg_id);
+	val = (val & mask) | (old & ~mask);
+	writel(val, mdev->res.vp_regs + reg_id);
+}
+
+static inline u32 mxr_read(struct mxr_device *mdev, u32 reg_id)
+{
+	return readl(mdev->res.mxr_regs + reg_id);
+}
+
+static inline void mxr_write(struct mxr_device *mdev, u32 reg_id, u32 val)
+{
+	writel(val, mdev->res.mxr_regs + reg_id);
+}
+
+static inline void mxr_write_mask(struct mxr_device *mdev, u32 reg_id,
+	u32 val, u32 mask)
+{
+	u32 old = mxr_read(mdev, reg_id);
+	val = (val & mask) | (old & ~mask);
+	writel(val, mdev->res.mxr_regs + reg_id);
+}
+
+void mxr_vsync_set_update(struct mxr_device *mdev, int en)
+{
+	/* block update on vsync */
+	mxr_write_mask(mdev, MXR_STATUS, en ? MXR_STATUS_SYNC_ENABLE : 0,
+		MXR_STATUS_SYNC_ENABLE);
+	vp_write(mdev, VP_SHADOW_UPDATE, en ? VP_SHADOW_UPDATE_ENABLE : 0);
+}
+
+static void __mxr_reg_vp_reset(struct mxr_device *mdev)
+{
+	int tries = 100;
+	vp_write(mdev, VP_SRESET, VP_SRESET_PROCESSING);
+	for (tries = 100; tries; --tries) {
+		/* waiting until VP_SRESET_PROCESSING is 0 */
+		if (~vp_read(mdev, VP_SRESET) & VP_SRESET_PROCESSING)
+			break;
+		mdelay(10);
+	}
+	WARN(tries == 0, "failed to reset Video Processor\n");
+}
+
+static void mxr_reg_vp_default_filter(struct mxr_device *mdev);
+
+void mxr_reg_reset(struct mxr_device *mdev)
+{
+	unsigned long flags;
+	u32 val; /* value stored to register */
+
+	spin_lock_irqsave(&mdev->reg_slock, flags);
+	mxr_vsync_set_update(mdev, MXR_DISABLE);
+
+	/* set output in RGB888 mode */
+	mxr_write(mdev, MXR_CFG, MXR_CFG_OUT_YUV444);
+
+	/* 16 beat burst in DMA */
+	mxr_write_mask(mdev, MXR_STATUS, MXR_STATUS_16_BURST,
+		MXR_STATUS_BURST_MASK);
+
+	/* setting default layer priority: layer1 > video > layer0
+	 * because typical usage scenario would be
+	 * layer0 - framebuffer
+	 * video - video overlay
+	 * layer1 - OSD
+	 */
+	val  = MXR_LAYER_CFG_GRP0_VAL(1);
+	val |= MXR_LAYER_CFG_VP_VAL(2);
+	val |= MXR_LAYER_CFG_GRP1_VAL(3);
+	mxr_write(mdev, MXR_LAYER_CFG, val);
+
+	/* use dark gray background color */
+	mxr_write(mdev, MXR_BG_COLOR0, 0x808080);
+	mxr_write(mdev, MXR_BG_COLOR1, 0x808080);
+	mxr_write(mdev, MXR_BG_COLOR2, 0x808080);
+
+	/* setting graphical layers */
+
+	val  = MXR_GRP_CFG_COLOR_KEY_DISABLE; /* no blank key */
+	val |= MXR_GRP_CFG_BLEND_PRE_MUL; /* premul mode */
+	val |= MXR_GRP_CFG_ALPHA_VAL(0xff); /* non-transparent alpha */
+
+	/* the same configuration for both layers */
+	mxr_write(mdev, MXR_GRAPHIC_CFG(0), val);
+	mxr_write(mdev, MXR_GRAPHIC_CFG(1), val);
+
+	/* configuration of Video Processor Registers */
+	__mxr_reg_vp_reset(mdev);
+	mxr_reg_vp_default_filter(mdev);
+
+	mxr_vsync_set_update(mdev, MXR_ENABLE);
+	spin_unlock_irqrestore(&mdev->reg_slock, flags);
+}
+
+void mxr_reg_graph_format(struct mxr_device *mdev, int idx,
+	const struct mxr_format *fmt, const struct mxr_geometry *geo)
+{
+	u32 val;
+	unsigned long flags;
+
+	spin_lock_irqsave(&mdev->reg_slock, flags);
+	mxr_vsync_set_update(mdev, MXR_DISABLE);
+
+	/* setup format */
+	mxr_write_mask(mdev, MXR_GRAPHIC_CFG(idx),
+		MXR_GRP_CFG_FORMAT_VAL(fmt->hwCode), MXR_GRP_CFG_FORMAT_MASK);
+
+	/* setup geometry */
+	mxr_write(mdev, MXR_GRAPHIC_SPAN(idx), geo->src.full_width);
+	val  = MXR_GRP_WH_WIDTH(geo->src.width);
+	val |= MXR_GRP_WH_HEIGHT(geo->src.height);
+	val |= MXR_GRP_WH_H_SCALE(geo->x_ratio);
+	val |= MXR_GRP_WH_V_SCALE(geo->y_ratio);
+	mxr_write(mdev, MXR_GRAPHIC_WH(idx), val);
+
+	/* setup offsets in source image */
+	val  = MXR_GRP_SXY_SX(geo->src.x_offset);
+	val |= MXR_GRP_SXY_SY(geo->src.y_offset);
+	mxr_write(mdev, MXR_GRAPHIC_SXY(idx), val);
+
+	/* setup offsets in display image */
+	val  = MXR_GRP_DXY_DX(geo->dst.x_offset);
+	val |= MXR_GRP_DXY_DY(geo->dst.y_offset);
+	mxr_write(mdev, MXR_GRAPHIC_DXY(idx), val);
+
+	mxr_vsync_set_update(mdev, MXR_ENABLE);
+	spin_unlock_irqrestore(&mdev->reg_slock, flags);
+}
+
+void mxr_reg_vp_format(struct mxr_device *mdev,
+	const struct mxr_format *fmt, const struct mxr_geometry *geo)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&mdev->reg_slock, flags);
+	mxr_vsync_set_update(mdev, MXR_DISABLE);
+
+	vp_write_mask(mdev, VP_MODE, fmt->hwCode, VP_MODE_FMT_MASK);
+
+	/* setting size of input image */
+	vp_write(mdev, VP_IMG_SIZE_Y, VP_IMG_HSIZE(geo->src.full_width) |
+		VP_IMG_VSIZE(geo->src.full_height));
+	/* chroma height has to reduced by 2 to avoid chroma distorions */
+	vp_write(mdev, VP_IMG_SIZE_C, VP_IMG_HSIZE(geo->src.full_width) |
+		VP_IMG_VSIZE(geo->src.full_height / 2));
+
+	vp_write(mdev, VP_SRC_WIDTH, geo->src.width);
+	vp_write(mdev, VP_SRC_HEIGHT, geo->src.height);
+	vp_write(mdev, VP_SRC_H_POSITION,
+		VP_SRC_H_POSITION_VAL(geo->src.x_offset));
+	vp_write(mdev, VP_SRC_V_POSITION, geo->src.y_offset);
+
+	vp_write(mdev, VP_DST_WIDTH, geo->dst.width);
+	vp_write(mdev, VP_DST_H_POSITION, geo->dst.x_offset);
+	if (geo->dst.field == V4L2_FIELD_INTERLACED) {
+		vp_write(mdev, VP_DST_HEIGHT, geo->dst.height / 2);
+		vp_write(mdev, VP_DST_V_POSITION, geo->dst.y_offset / 2);
+	} else {
+		vp_write(mdev, VP_DST_HEIGHT, geo->dst.height);
+		vp_write(mdev, VP_DST_V_POSITION, geo->dst.y_offset);
+	}
+
+	vp_write(mdev, VP_H_RATIO, geo->x_ratio);
+	vp_write(mdev, VP_V_RATIO, geo->y_ratio);
+
+	vp_write(mdev, VP_ENDIAN_MODE, VP_ENDIAN_MODE_LITTLE);
+
+	mxr_vsync_set_update(mdev, MXR_ENABLE);
+	spin_unlock_irqrestore(&mdev->reg_slock, flags);
+
+}
+
+void mxr_reg_graph_buffer(struct mxr_device *mdev, int idx, dma_addr_t addr)
+{
+	u32 val = addr ? ~0 : 0;
+	unsigned long flags;
+	/*printk(KERN_INFO "%s(%08x)\n", __func__, addr);*/
+	spin_lock_irqsave(&mdev->reg_slock, flags);
+	mxr_vsync_set_update(mdev, MXR_DISABLE);
+
+	if (idx == 0)
+		mxr_write_mask(mdev, MXR_CFG, val, MXR_CFG_GRP0_ENABLE);
+	else
+		mxr_write_mask(mdev, MXR_CFG, val, MXR_CFG_GRP1_ENABLE);
+	mxr_write(mdev, MXR_GRAPHIC_BASE(idx), addr);
+
+	mxr_vsync_set_update(mdev, MXR_ENABLE);
+	spin_unlock_irqrestore(&mdev->reg_slock, flags);
+}
+
+void mxr_reg_vp_buffer(struct mxr_device *mdev,
+	dma_addr_t luma_addr[2], dma_addr_t chroma_addr[2])
+{
+	u32 val = luma_addr[0] ? ~0 : 0;
+	unsigned long flags;
+	/*printk(KERN_CRIT "%s(luma=%08x, chroma=%08x)\n", __func__,
+		luma_addr, chroma_addr);*/
+	spin_lock_irqsave(&mdev->reg_slock, flags);
+	mxr_vsync_set_update(mdev, MXR_DISABLE);
+
+	mxr_write_mask(mdev, MXR_CFG, val, MXR_CFG_VP_ENABLE);
+	vp_write_mask(mdev, VP_ENABLE, val, VP_ENABLE_ON);
+	/* TODO: fix tiled mode */
+	vp_write(mdev, VP_TOP_Y_PTR, luma_addr[0]);
+	vp_write(mdev, VP_TOP_C_PTR, chroma_addr[0]);
+	vp_write(mdev, VP_BOT_Y_PTR, luma_addr[1]);
+	vp_write(mdev, VP_BOT_C_PTR, chroma_addr[1]);
+
+	mxr_vsync_set_update(mdev, MXR_ENABLE);
+	spin_unlock_irqrestore(&mdev->reg_slock, flags);
+}
+
+static void mxr_irq_layer_handle(struct mxr_layer *layer)
+{
+	struct list_head *head = &layer->enq_list;
+	struct mxr_buffer *done;
+
+	/* skip non-existing layer */
+	if (layer == NULL)
+		return;
+
+	spin_lock(&layer->enq_slock);
+	if (layer->state == MXR_LAYER_IDLE)
+		goto done;
+
+	done = layer->shadow_buf;
+	layer->shadow_buf = layer->update_buf;
+
+	if (list_empty(head)) {
+		if (layer->state != MXR_LAYER_STREAMING)
+			layer->update_buf = NULL;
+	} else {
+		struct mxr_buffer *next;
+		next = list_first_entry(head, struct mxr_buffer, list);
+		list_del(&next->list);
+		layer->update_buf = next;
+	}
+
+	layer->ops.buffer_set(layer, layer->update_buf);
+
+	if (done && done != layer->shadow_buf)
+		vb2_buffer_done(&done->vb, VB2_BUF_STATE_DONE);
+
+done:
+	spin_unlock(&layer->enq_slock);
+}
+
+irqreturn_t mxr_irq_handler(int irq, void *dev_data)
+{
+	struct mxr_device *mdev = dev_data;
+	u32 i, val;
+	spin_lock(&mdev->reg_slock);
+	val = mxr_read(mdev, MXR_INT_STATUS);
+
+	/* clear interrupts */
+	mxr_write(mdev, MXR_INT_STATUS, val);
+
+	spin_unlock(&mdev->reg_slock);
+	/* leave on non-vsync event */
+	if (~val & MXR_INT_EN_VSYNC)
+		return IRQ_HANDLED;
+	for (i = 0; i < MXR_MAX_LAYERS; ++i)
+		mxr_irq_layer_handle(mdev->layer[i]);
+	return IRQ_HANDLED;
+}
+
+void mxr_reg_s_output(struct mxr_device *mdev, int cookie)
+{
+	u32 val;
+
+	val = cookie == 0 ? MXR_CFG_DST_TV : MXR_CFG_DST_HDMI;
+	mxr_write_mask(mdev, MXR_CFG, val, MXR_CFG_DST_MASK);
+}
+
+void mxr_reg_streamon(struct mxr_device *mdev)
+{
+	unsigned long flags;
+	spin_lock_irqsave(&mdev->reg_slock, flags);
+	mxr_vsync_set_update(mdev, MXR_DISABLE);
+
+	/* start MIXER */
+	mxr_write_mask(mdev, MXR_STATUS, ~0, MXR_STATUS_REG_RUN);
+	/* start all interrupts */
+	mxr_write_mask(mdev, MXR_INT_EN, ~0, MXR_INT_EN_ALL);
+
+	mxr_vsync_set_update(mdev, MXR_ENABLE);
+	spin_unlock_irqrestore(&mdev->reg_slock, flags);
+}
+
+void mxr_reg_streamoff(struct mxr_device *mdev)
+{
+	unsigned long flags;
+	spin_lock_irqsave(&mdev->reg_slock, flags);
+	mxr_vsync_set_update(mdev, MXR_DISABLE);
+
+	/* stop MIXER */
+	mxr_write_mask(mdev, MXR_STATUS, 0, MXR_STATUS_REG_RUN);
+	/* disable all interrupts */
+	mxr_write_mask(mdev, MXR_INT_EN, 0, MXR_INT_EN_ALL);
+
+	mxr_vsync_set_update(mdev, MXR_ENABLE);
+	spin_unlock_irqrestore(&mdev->reg_slock, flags);
+}
+
+void mxr_reg_set_mbus_fmt(struct mxr_device *mdev,
+	struct v4l2_mbus_framefmt *fmt)
+{
+	u32 val = 0;
+	unsigned long flags;
+
+	spin_lock_irqsave(&mdev->reg_slock, flags);
+	mxr_vsync_set_update(mdev, MXR_DISABLE);
+
+	/* choosing between interlace and progressive mode */
+	if (fmt->field == V4L2_FIELD_INTERLACED)
+		val |= MXR_CFG_SCAN_INTERLACE;
+	else
+		val |= MXR_CFG_SCAN_PROGRASSIVE;
+
+	/* choosing between porper HD and SD mode */
+	if (fmt->height == 480)
+		val |= MXR_CFG_NTSC | MXR_CFG_SD;
+	else if (fmt->height == 576)
+		val |= MXR_CFG_PAL | MXR_CFG_SD;
+	else if (fmt->height == 720)
+		val |= MXR_CFG_HD_720 | MXR_CFG_HD;
+	else if (fmt->height == 1080)
+		val |= MXR_CFG_HD_1080 | MXR_CFG_HD;
+	else
+		WARN(1, "unrecognized mbus height %u!\n", fmt->height);
+
+	mxr_write_mask(mdev, MXR_CFG, val, MXR_CFG_SCAN_MASK);
+
+	val = (fmt->field == V4L2_FIELD_INTERLACED) ? ~0 : 0;
+	vp_write_mask(mdev, VP_MODE, val,
+		VP_MODE_LINE_SKIP | VP_MODE_FIELD_ID_AUTO_TOGGLING);
+
+	mxr_vsync_set_update(mdev, MXR_ENABLE);
+	spin_unlock_irqrestore(&mdev->reg_slock, flags);
+}
+
+void mxr_reg_graph_layer_stream(struct mxr_device *mdev, int idx, int en)
+{
+	/* no extra actions need to be done */
+}
+
+void mxr_reg_vp_layer_stream(struct mxr_device *mdev, int en)
+{
+	/* no extra actions need to be done */
+}
+
+static const u8 filter_y_horiz_tap8[] = {
+	0,	-1,	-1,	-1,	-1,	-1,	-1,	-1,
+	-1,	-1,	-1,	-1,	-1,	0,	0,	0,
+	0,	2,	4,	5,	6,	6,	6,	6,
+	6,	5,	5,	4,	3,	2,	1,	1,
+	0,	-6,	-12,	-16,	-18,	-20,	-21,	-20,
+	-20,	-18,	-16,	-13,	-10,	-8,	-5,	-2,
+	127,	126,	125,	121,	114,	107,	99,	89,
+	79,	68,	57,	46,	35,	25,	16,	8,
+};
+
+static const u8 filter_y_vert_tap4[] = {
+	0,	-3,	-6,	-8,	-8,	-8,	-8,	-7,
+	-6,	-5,	-4,	-3,	-2,	-1,	-1,	0,
+	127,	126,	124,	118,	111,	102,	92,	81,
+	70,	59,	48,	37,	27,	19,	11,	5,
+	0,	5,	11,	19,	27,	37,	48,	59,
+	70,	81,	92,	102,	111,	118,	124,	126,
+	0,	0,	-1,	-1,	-2,	-3,	-4,	-5,
+	-6,	-7,	-8,	-8,	-8,	-8,	-6,	-3,
+};
+
+static const u8 filter_cr_horiz_tap4[] = {
+	0,	-3,	-6,	-8,	-8,	-8,	-8,	-7,
+	-6,	-5,	-4,	-3,	-2,	-1,	-1,	0,
+	127,	126,	124,	118,	111,	102,	92,	81,
+	70,	59,	48,	37,	27,	19,	11,	5,
+};
+
+static inline void mxr_reg_vp_filter_set(struct mxr_device *mdev,
+	int reg_id, const u8 *data, unsigned int size)
+{
+	/* assure 4-byte align */
+	BUG_ON(size & 3);
+	for (; size; size -= 4, reg_id += 4, data += 4) {
+		u32 val = (data[0] << 24) |  (data[1] << 16) |
+			(data[2] << 8) | data[3];
+		vp_write(mdev, reg_id, val);
+	}
+}
+
+static void mxr_reg_vp_default_filter(struct mxr_device *mdev)
+{
+	mxr_reg_vp_filter_set(mdev, VP_POLY8_Y0_LL,
+		filter_y_horiz_tap8, sizeof filter_y_horiz_tap8);
+	mxr_reg_vp_filter_set(mdev, VP_POLY4_Y0_LL,
+		filter_y_vert_tap4, sizeof filter_y_vert_tap4);
+	mxr_reg_vp_filter_set(mdev, VP_POLY4_C0_LL,
+		filter_cr_horiz_tap4, sizeof filter_cr_horiz_tap4);
+}
+
+static void mxr_reg_mxr_dump(struct mxr_device *mdev)
+{
+#define DUMPREG(reg_id) \
+do { \
+	u32 value = readl(mdev->res.mxr_regs + reg_id); \
+	mxr_dbg(mdev, #reg_id " = %08x\n", value); \
+} while (0)
+	DUMPREG(MXR_STATUS);
+	DUMPREG(MXR_CFG);
+	DUMPREG(MXR_INT_EN);
+	DUMPREG(MXR_INT_STATUS);
+
+	DUMPREG(MXR_LAYER_CFG);
+	DUMPREG(MXR_VIDEO_CFG);
+
+	DUMPREG(MXR_GRAPHIC0_CFG);
+	DUMPREG(MXR_GRAPHIC0_BASE);
+	DUMPREG(MXR_GRAPHIC0_SPAN);
+	DUMPREG(MXR_GRAPHIC0_WH);
+	DUMPREG(MXR_GRAPHIC0_SXY);
+	DUMPREG(MXR_GRAPHIC0_DXY);
+
+	DUMPREG(MXR_GRAPHIC1_CFG);
+	DUMPREG(MXR_GRAPHIC1_BASE);
+	DUMPREG(MXR_GRAPHIC1_SPAN);
+	DUMPREG(MXR_GRAPHIC1_WH);
+	DUMPREG(MXR_GRAPHIC1_SXY);
+	DUMPREG(MXR_GRAPHIC1_DXY);
+#undef DUMPREG
+}
+
+static void mxr_reg_vp_dump(struct mxr_device *mdev)
+{
+#define DUMPREG(reg_id) \
+do { \
+	u32 value = readl(mdev->res.vp_regs + reg_id); \
+	mxr_dbg(mdev, #reg_id " = %08x\n", value); \
+} while (0)
+
+	DUMPREG(VP_ENABLE);
+	DUMPREG(VP_SRESET);
+	DUMPREG(VP_SHADOW_UPDATE);
+	DUMPREG(VP_FIELD_ID);
+	DUMPREG(VP_MODE);
+	DUMPREG(VP_IMG_SIZE_Y);
+	DUMPREG(VP_IMG_SIZE_C);
+	DUMPREG(VP_PER_RATE_CTRL);
+	DUMPREG(VP_TOP_Y_PTR);
+	DUMPREG(VP_BOT_Y_PTR);
+	DUMPREG(VP_TOP_C_PTR);
+	DUMPREG(VP_BOT_C_PTR);
+	DUMPREG(VP_ENDIAN_MODE);
+	DUMPREG(VP_SRC_H_POSITION);
+	DUMPREG(VP_SRC_V_POSITION);
+	DUMPREG(VP_SRC_WIDTH);
+	DUMPREG(VP_SRC_HEIGHT);
+	DUMPREG(VP_DST_H_POSITION);
+	DUMPREG(VP_DST_V_POSITION);
+	DUMPREG(VP_DST_WIDTH);
+	DUMPREG(VP_DST_HEIGHT);
+	DUMPREG(VP_H_RATIO);
+	DUMPREG(VP_V_RATIO);
+
+	DUMPREG(VP_FIELD_ID_S);
+	DUMPREG(VP_MODE_S);
+	DUMPREG(VP_IMG_SIZE_Y_S);
+	DUMPREG(VP_IMG_SIZE_C_S);
+	DUMPREG(VP_TOP_Y_PTR_S);
+	DUMPREG(VP_BOT_Y_PTR_S);
+	DUMPREG(VP_TOP_C_PTR_S);
+	DUMPREG(VP_BOT_C_PTR_S);
+	DUMPREG(VP_ENDIAN_MODE_S);
+	DUMPREG(VP_SRC_H_POSITION_S);
+	DUMPREG(VP_SRC_V_POSITION_S);
+	DUMPREG(VP_SRC_WIDTH_S);
+	DUMPREG(VP_SRC_HEIGHT_S);
+	DUMPREG(VP_DST_H_POSITION_S);
+	DUMPREG(VP_DST_V_POSITION_S);
+	DUMPREG(VP_DST_WIDTH_S);
+	DUMPREG(VP_DST_HEIGHT_S);
+	DUMPREG(VP_H_RATIO_S);
+	DUMPREG(VP_V_RATIO_S);
+
+	DUMPREG(VP_PP_BYPASS);
+	DUMPREG(VP_PP_SATURATION);
+	DUMPREG(VP_PP_SHARPNESS);
+	DUMPREG(VP_PP_LINE_EQ0);
+	DUMPREG(VP_PP_LINE_EQ1);
+	DUMPREG(VP_PP_LINE_EQ2);
+	DUMPREG(VP_PP_LINE_EQ3);
+	DUMPREG(VP_PP_LINE_EQ4);
+	DUMPREG(VP_PP_LINE_EQ5);
+	DUMPREG(VP_PP_LINE_EQ6);
+	DUMPREG(VP_PP_LINE_EQ7);
+	DUMPREG(VP_PP_BRIGHT_OFFSET);
+	DUMPREG(VP_VERSION_INFO);
+
+#undef DUMPREG
+}
+
+void mxr_reg_dump(struct mxr_device *mdev)
+{
+	mxr_reg_mxr_dump(mdev);
+	mxr_reg_vp_dump(mdev);
+}
+
diff --git a/drivers/media/video/s5p-tv/mixer_reg.h b/drivers/media/video/s5p-tv/mixer_reg.h
new file mode 100644
index 0000000..8f6fc3e
--- /dev/null
+++ b/drivers/media/video/s5p-tv/mixer_reg.h
@@ -0,0 +1,45 @@
+/*
+ * Samsung TV Mixer driver
+ *
+ * Copyright (c) 2010 Samsung Electronics
+ *
+ * Tomasz Stanislawski, t.stanislaws@samsung.com
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published
+ * by the Free Software Foundiation. either version 2 of the License,
+ * or (at your option) any later version
+ */
+
+#ifndef _SAMSUNG_MIXER_REG_H_
+#define _SAMSUNG_MIXER_REG_H_	__FILE__
+
+#include "mixer.h"
+
+#include <linux/kernel.h>
+#include <linux/io.h>
+#include <linux/irq.h>
+
+void mxr_vsync_set_update(struct mxr_device *mdev, int en);
+void mxr_reg_reset(struct mxr_device *mdev);
+irqreturn_t mxr_irq_handler(int irq, void *dev_data);
+void mxr_reg_s_output(struct mxr_device *mdev, int cookie);
+void mxr_reg_streamon(struct mxr_device *mdev);
+void mxr_reg_streamoff(struct mxr_device *mdev);
+void mxr_reg_set_mbus_fmt(struct mxr_device *mdev,
+	struct v4l2_mbus_framefmt *fmt);
+void mxr_reg_graph_layer_stream(struct mxr_device *mdev, int idx, int en);
+void mxr_reg_graph_buffer(struct mxr_device *mdev, int idx, dma_addr_t addr);
+void mxr_reg_graph_format(struct mxr_device *mdev, int idx,
+	const struct mxr_format *fmt, const struct mxr_geometry *geo);
+
+void mxr_reg_vp_layer_stream(struct mxr_device *mdev, int en);
+void mxr_reg_vp_buffer(struct mxr_device *mdev,
+	dma_addr_t luma_addr[2], dma_addr_t chroma_addr[2]);
+void mxr_reg_vp_format(struct mxr_device *mdev,
+	const struct mxr_format *fmt, const struct mxr_geometry *geo);
+
+void mxr_reg_dump(struct mxr_device *mdev);
+
+#endif /* _SAMSUNG_MIXER_REG_H_ */
+
diff --git a/drivers/media/video/s5p-tv/mixer_video.c b/drivers/media/video/s5p-tv/mixer_video.c
new file mode 100644
index 0000000..4d6527e
--- /dev/null
+++ b/drivers/media/video/s5p-tv/mixer_video.c
@@ -0,0 +1,937 @@
+/*
+ * Samsung TV Mixer driver
+ *
+ * Copyright (c) 2010 Samsung Electronics
+ *
+ * Tomasz Stanislawski, t.stanislaws@samsung.com
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published
+ * by the Free Software Foundiation. either version 2 of the License,
+ * or (at your option) any later version
+ */
+
+#include "mixer.h"
+
+#include <media/v4l2-ioctl.h>
+#include <linux/videodev2.h>
+#include <linux/mm.h>
+#include <linux/version.h>
+#include <linux/timer.h>
+
+#include <media/videobuf2-dma-iommu.h>
+#include <plat/sysmmu.h>
+
+static int find_reg_callback(struct device *dev, void *p)
+{
+	struct v4l2_subdev **sd = p;
+
+	*sd = dev_get_drvdata(dev);
+	/* non-zero value stops iteration */
+	return 1;
+}
+
+static struct v4l2_subdev *find_and_register_subdev(char *module_name,
+	struct v4l2_device *vdev)
+{
+	struct device_driver *drv;
+	struct v4l2_subdev *sd;
+	int ret;
+
+	request_module(module_name);
+	/* TODO: add waiting until probe is finished */
+	drv = driver_find(module_name, &platform_bus_type);
+	if (WARN(!drv, "driver %s is missing\n", module_name))
+		return NULL;
+	/* driver refcnt is increased, it is safe to iterate over devices */
+	ret = driver_for_each_device(drv, NULL, &sd, find_reg_callback);
+	/* ret == 0 means that find_reg_callback was never executed */
+	WARN(ret == 0, "module %s provides no subdev!\n", module_name);
+	/* v4l2_device_register_subdev detects if sd is NULL */
+	ret = v4l2_device_register_subdev(vdev, sd);
+	put_driver(drv);
+	return ret == 0 ? sd : NULL;
+}
+
+int __devinit mxr_acquire_video(struct mxr_device *mdev,
+	struct mxr_output_conf *output_conf, int output_count)
+{
+	struct device *dev = mdev->dev;
+	struct v4l2_device *vdev = &mdev->v4l2_dev;
+	int i;
+	int ret = 0;
+	struct v4l2_subdev *sd;
+
+	strlcpy(vdev->name, "s5p-tv", sizeof(vdev->name));
+	/* prepare context for V4L2 device */
+	ret = v4l2_device_register(dev, vdev);
+	if (ret) {
+		mxr_err(mdev, "could not register v4l2 device.\n");
+		goto fail;
+	}
+
+	/* prepare alloc context */
+	mdev->iommu_dev = s5p_sysmmu_get(S5P_SYSMMU_TV);
+	if (IS_ERR_OR_NULL(mdev->iommu_dev)) {
+		mxr_err(mdev, "could not acquire SYSMMU device\n");
+		ret = -ENODEV;
+		goto fail_v4l2_dev;
+	}
+	mdev->alloc_ctx = vb2_dma_iommu_init(dev, mdev->iommu_dev, NULL);
+	if (IS_ERR_OR_NULL(mdev->alloc_ctx)) {
+		mxr_err(mdev, "could not initialize allocator's context\n");
+		ret = -ENOMEM;
+		goto fail_iommu_dev;
+	}
+
+	/* registering outputs */
+	for (i = 0; i < output_count && i < MXR_OUTPUTS; ++i) {
+		struct mxr_output_conf *conf = &output_conf[i];
+		struct mxr_output *out;
+		sd = find_and_register_subdev(conf->module_name, vdev);
+		if (sd == NULL) {
+			mxr_err(mdev, "failed to find subdev in module '%s'\n",
+				conf->module_name);
+			ret = -ENXIO;
+			goto fail_output;
+		}
+		out = kzalloc(sizeof *out, GFP_KERNEL);
+		if (out == NULL) {
+			mxr_err(mdev, "no memory for '%s'\n",
+				conf->output_name);
+			ret = -ENOMEM;
+			/* registered subdevs are removed in fail_v4l2_dev */
+			goto fail_output;
+		}
+		strlcpy(out->name, conf->output_name, sizeof(out->name));
+		out->sd = sd;
+		out->cookie = conf->cookie;
+		mdev->output[i] = out;
+		mxr_info(mdev, "added output '%s' from module '%s'\n",
+			conf->output_name, conf->module_name);
+	}
+
+	return 0;
+
+fail_output:
+	/* kfree is NULL-safe */
+	for (i = 0; i < MXR_OUTPUTS; ++i)
+		kfree(mdev->output[i]);
+	memset(mdev->output, 0, sizeof mdev->output);
+
+	/* freeing allocator context */
+	vb2_dma_iommu_cleanup(mdev->alloc_ctx);
+
+fail_iommu_dev:
+	s5p_sysmmu_put(mdev->iommu_dev);
+
+fail_v4l2_dev:
+	/* NOTE: automatically unregisteres all subdevs */
+	v4l2_device_unregister(vdev);
+
+fail:
+	return ret;
+}
+
+void __devexit mxr_release_video(struct mxr_device *mdev)
+{
+	int i;
+
+	/* kfree is NULL-safe */
+	for (i = 0; i < MXR_OUTPUTS; ++i)
+		kfree(mdev->output[i]);
+
+	vb2_dma_iommu_cleanup(mdev->alloc_ctx);
+	s5p_sysmmu_put(mdev->iommu_dev);
+	v4l2_device_unregister(&mdev->v4l2_dev);
+}
+
+static int mxr_querycap(struct file *file, void *priv,
+	struct v4l2_capability *cap)
+{
+	struct mxr_layer *layer = video_drvdata(file);
+	struct mxr_device *mdev = layer->mdev;
+	mxr_dbg(mdev, "%s:%d\n", __func__, __LINE__);
+
+	strlcpy(cap->driver, MXR_DRIVER_NAME, sizeof cap->driver);
+	strlcpy(cap->card, layer->vfd.name, sizeof cap->card);
+	sprintf(cap->bus_info, "%d", layer->idx);
+	cap->version = KERNEL_VERSION(0, 1, 0);
+	cap->capabilities = V4L2_CAP_STREAMING |
+		V4L2_CAP_VIDEO_OUTPUT | V4L2_CAP_VIDEO_OUTPUT_MPLANE;
+
+	return 0;
+}
+
+/* Geometry handling */
+static void mxr_layer_geo_fix(struct mxr_layer *layer)
+{
+	struct mxr_device *mdev = layer->mdev;
+	struct v4l2_mbus_framefmt mbus_fmt;
+
+	/* TODO: add some dirty flag */
+	mxr_get_mbus_fmt(mdev, &mbus_fmt);
+	layer->geo.dst.full_width = mbus_fmt.width;
+	layer->geo.dst.full_height = mbus_fmt.height;
+	layer->geo.dst.field = mbus_fmt.field;
+	layer->ops.fix_geometry(layer);
+}
+
+static void mxr_layer_default_geo(struct mxr_layer *layer)
+{
+	struct mxr_device *mdev = layer->mdev;
+	struct v4l2_mbus_framefmt mbus_fmt;
+
+	memset(&layer->geo, 0, sizeof layer->geo);
+
+	mxr_get_mbus_fmt(mdev, &mbus_fmt);
+
+	layer->geo.dst.full_width = mbus_fmt.width;
+	layer->geo.dst.full_height = mbus_fmt.height;
+	layer->geo.dst.width = layer->geo.dst.full_width;
+	layer->geo.dst.height = layer->geo.dst.full_height;
+	layer->geo.dst.field = mbus_fmt.field;
+
+	layer->geo.src.full_width = mbus_fmt.width;
+	layer->geo.src.full_height = mbus_fmt.height;
+	layer->geo.src.width = layer->geo.src.full_width;
+	layer->geo.src.height = layer->geo.src.full_height;
+
+	layer->ops.fix_geometry(layer);
+}
+
+static void mxr_geometry_dump(struct mxr_device *mdev, struct mxr_geometry *geo)
+{
+	mxr_dbg(mdev, "src.full_size = (%u, %u)\n",
+		geo->src.full_width, geo->src.full_height);
+	mxr_dbg(mdev, "src.size = (%u, %u)\n",
+		geo->src.width, geo->src.height);
+	mxr_dbg(mdev, "src.offset = (%u, %u)\n",
+		geo->src.x_offset, geo->src.y_offset);
+	mxr_dbg(mdev, "dst.full_size = (%u, %u)\n",
+		geo->dst.full_width, geo->dst.full_height);
+	mxr_dbg(mdev, "dst.size = (%u, %u)\n",
+		geo->dst.width, geo->dst.height);
+	mxr_dbg(mdev, "dst.offset = (%u, %u)\n",
+		geo->dst.x_offset, geo->dst.y_offset);
+	mxr_dbg(mdev, "ratio = (%u, %u)\n",
+		geo->x_ratio, geo->y_ratio);
+}
+
+
+static const struct mxr_format *find_format_by_fourcc(
+	struct mxr_layer *layer, unsigned long fourcc);
+static const struct mxr_format *find_format_by_index(
+	struct mxr_layer *layer, unsigned long index);
+
+static int mxr_enum_fmt(struct file *file, void  *priv,
+	struct v4l2_fmtdesc *f)
+{
+	struct mxr_layer *layer = video_drvdata(file);
+	struct mxr_device *mdev = layer->mdev;
+	const struct mxr_format *fmt;
+
+	mxr_dbg(mdev, "%s\n", __func__);
+	fmt = find_format_by_index(layer, f->index);
+	if (fmt == NULL)
+		return -EINVAL;
+
+	strlcpy(f->description, fmt->name, sizeof(f->description));
+	f->pixelformat = fmt->fourcc;
+
+	return 0;
+}
+
+static int mxr_s_fmt(struct file *file, void *priv,
+	struct v4l2_format *f)
+{
+	struct mxr_layer *layer = video_drvdata(file);
+	const struct mxr_format *fmt;
+	struct v4l2_pix_format_mplane *pix;
+	struct mxr_device *mdev = layer->mdev;
+	struct mxr_geometry *geo = &layer->geo;
+	int i;
+
+	mxr_dbg(mdev, "%s:%d\n", __func__, __LINE__);
+
+	pix = &f->fmt.pix_mp;
+	fmt = find_format_by_fourcc(layer, pix->pixelformat);
+	if (fmt == NULL) {
+		mxr_warn(mdev, "not recognized fourcc: %08x\n",
+			pix->pixelformat);
+		return -EINVAL;
+	}
+	layer->fmt = fmt;
+	geo->src.full_width = pix->width;
+	geo->src.width = pix->width;
+	geo->src.full_height = pix->height;
+	geo->src.height = pix->height;
+	/* assure consistency of geometry */
+	mxr_layer_geo_fix(layer);
+
+	for (i = 0; i < fmt->num_subframes; ++i) {
+		unsigned int nPixel = fmt->plane[i].pxHeight *
+			fmt->plane[i].pxWidth;
+		pix->plane_fmt[i].bytesperline = geo->src.full_width *
+			fmt->plane[i].bSize / nPixel;
+	}
+	mxr_dbg(mdev, "width=%u height=%u bpp=%u span=%u\n",
+		geo->src.width, geo->src.height,
+		pix->plane_fmt[0].bytesperline, geo->src.full_width);
+	return 0;
+}
+
+static int mxr_g_fmt(struct file *file, void *priv,
+			     struct v4l2_format *f)
+{
+	struct mxr_layer *layer = video_drvdata(file);
+	struct mxr_device *mdev = layer->mdev;
+	mxr_dbg(mdev, "%s:%d\n", __func__, __LINE__);
+
+	f->fmt.pix.width	= layer->geo.src.full_width;
+	f->fmt.pix.height	= layer->geo.src.full_height;
+	f->fmt.pix.field	= V4L2_FIELD_NONE;
+	f->fmt.pix.pixelformat	= layer->fmt->fourcc;
+
+	return 0;
+}
+
+static inline struct mxr_crop *choose_crop_by_type(struct mxr_geometry *geo,
+	enum v4l2_buf_type type)
+{
+	switch (type) {
+	case V4L2_BUF_TYPE_VIDEO_OUTPUT:
+	case V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE:
+		return &geo->dst;
+	case V4L2_BUF_TYPE_VIDEO_OVERLAY:
+		return &geo->src;
+	default:
+		return NULL;
+	}
+}
+
+static int mxr_g_crop(struct file *file, void *fh, struct v4l2_crop *a)
+{
+	struct mxr_layer *layer = video_drvdata(file);
+	struct mxr_device *mdev = layer->mdev;
+	struct mxr_crop *crop;
+	mxr_dbg(mdev, "%s:%d\n", __func__, __LINE__);
+	crop = choose_crop_by_type(&layer->geo, a->type);
+	if (crop == NULL)
+		return -EINVAL;
+	mxr_layer_geo_fix(layer);
+	a->c.left = crop->x_offset;
+	a->c.top = crop->y_offset;
+	a->c.width = crop->width;
+	a->c.height = crop->height;
+	return 0;
+}
+
+static int mxr_s_crop(struct file *file, void *fh, struct v4l2_crop *a)
+{
+	struct mxr_layer *layer = video_drvdata(file);
+	struct mxr_device *mdev = layer->mdev;
+	struct mxr_crop *crop;
+	mxr_dbg(mdev, "%s:%d\n", __func__, __LINE__);
+	crop = choose_crop_by_type(&layer->geo, a->type);
+	if (crop == NULL)
+		return -EINVAL;
+	crop->x_offset = a->c.left;
+	crop->y_offset = a->c.top;
+	crop->width = a->c.width;
+	crop->height = a->c.height;
+	mxr_layer_geo_fix(layer);
+	return 0;
+}
+
+static int mxr_cropcap(struct file *file, void *fh, struct v4l2_cropcap *a)
+{
+	struct mxr_layer *layer = video_drvdata(file);
+	struct mxr_device *mdev = layer->mdev;
+	struct mxr_crop *crop;
+	mxr_dbg(mdev, "%s:%d\n", __func__, __LINE__);
+	crop = choose_crop_by_type(&layer->geo, a->type);
+	if (crop == NULL)
+		return -EINVAL;
+	mxr_layer_geo_fix(layer);
+	a->bounds.left = 0;
+	a->bounds.top = 0;
+	a->bounds.width = crop->full_width;
+	a->bounds.top = crop->full_height;
+	a->defrect = a->bounds;
+	return 0;
+}
+
+static int mxr_enum_dv_presets(struct file *file, void *fh,
+	struct v4l2_dv_enum_preset *preset)
+{
+	struct mxr_layer *layer = video_drvdata(file);
+	struct mxr_device *mdev = layer->mdev;
+	int ret;
+
+	/* lock protects from changing sd_out */
+	mutex_lock(&mdev->mutex);
+	ret = v4l2_subdev_call(to_outsd(mdev), video, enum_dv_presets, preset);
+	mutex_unlock(&mdev->mutex);
+
+	return ret ? -EINVAL : 0;
+}
+
+static int mxr_s_dv_preset(struct file *file, void *fh,
+	struct v4l2_dv_preset *preset)
+{
+	struct mxr_layer *layer = video_drvdata(file);
+	struct mxr_device *mdev = layer->mdev;
+	int ret;
+
+	/* lock protects from changing sd_out */
+	mutex_lock(&mdev->mutex);
+
+	/* preset change cannot be done while there is an entity
+	 * dependant on output configuration
+	 */
+	if (mdev->n_output == 0)
+		ret = v4l2_subdev_call(to_outsd(mdev), video, s_dv_preset,
+			preset);
+	else
+		ret = -EBUSY;
+
+	mutex_unlock(&mdev->mutex);
+
+	return ret;
+}
+
+static int mxr_g_dv_preset(struct file *file, void *fh,
+	struct v4l2_dv_preset *preset)
+{
+	struct mxr_layer *layer = video_drvdata(file);
+	struct mxr_device *mdev = layer->mdev;
+	int ret;
+
+	/* lock protects from changing sd_out */
+	mutex_lock(&mdev->mutex);
+	ret = v4l2_subdev_call(to_outsd(mdev), video, query_dv_preset, preset);
+	mutex_unlock(&mdev->mutex);
+
+	return ret;
+}
+
+static int mxr_s_std(struct file *file, void *fh, v4l2_std_id *norm)
+{
+	struct mxr_layer *layer = video_drvdata(file);
+	struct mxr_device *mdev = layer->mdev;
+	int ret;
+
+	/* lock protects from changing sd_out */
+	mutex_lock(&mdev->mutex);
+
+	/* standard change cannot be done while there is an entity
+	 * dependant on output configuration
+	 */
+	if (mdev->n_output == 0)
+		ret = v4l2_subdev_call(to_outsd(mdev), video, s_std_output,
+			*norm);
+	else
+		ret = -EBUSY;
+
+	mutex_unlock(&mdev->mutex);
+
+	return ret;
+}
+
+static int mxr_enum_output(struct file *file, void *fh, struct v4l2_output *a)
+{
+	struct mxr_layer *layer = video_drvdata(file);
+	struct mxr_device *mdev = layer->mdev;
+	struct mxr_output *out;
+	struct v4l2_subdev *sd;
+
+	if (a->index >= MXR_OUTPUTS)
+		return -EINVAL;
+	out = mdev->output[a->index];
+	sd = out->sd;
+	if (out == NULL)
+		return -EINVAL;
+	strlcpy(a->name, out->name, sizeof(a->name));
+
+	/* try to obtain supported tv norms */
+	v4l2_subdev_call(sd, video, g_tvnorms, &a->std);
+	a->capabilities = 0;
+	if (sd->ops->video && sd->ops->video->s_dv_preset)
+		a->capabilities |= V4L2_OUT_CAP_PRESETS;
+	if (sd->ops->video && sd->ops->video->s_std_output)
+		a->capabilities |= V4L2_OUT_CAP_STD;
+
+	return 0;
+}
+
+static int mxr_s_output(struct file *file, void *fh, unsigned int i)
+{
+	struct video_device *vfd = video_devdata(file);
+	struct mxr_layer *layer = video_drvdata(file);
+	struct mxr_device *mdev = layer->mdev;
+	int ret = 0;
+
+	if (i >= MXR_OUTPUTS || mdev->output[i] == NULL)
+		return -EINVAL;
+
+	mutex_lock(&mdev->mutex);
+	if (mdev->n_output > 0) {
+		ret = -EBUSY;
+		goto done;
+	}
+	mdev->current_output = i;
+	mxr_info(mdev, "tvnorms = %08x\n", vfd->tvnorms);
+	vfd->tvnorms = 0;
+	v4l2_subdev_call(to_outsd(mdev), video, g_tvnorms, &vfd->tvnorms);
+	mxr_info(mdev, "new tvnorms = %08x\n", vfd->tvnorms);
+
+done:
+	mutex_unlock(&mdev->mutex);
+	return ret;
+}
+
+static int mxr_reqbufs(struct file *file, void *priv,
+			  struct v4l2_requestbuffers *p)
+{
+	struct mxr_layer *layer = video_drvdata(file);
+	struct mxr_device *mdev = layer->mdev;
+	mxr_dbg(mdev, "%s:%d\n", __func__, __LINE__);
+	return vb2_reqbufs(&layer->vb_queue, p);
+}
+
+static int mxr_querybuf(struct file *file, void *priv, struct v4l2_buffer *p)
+{
+	struct mxr_layer *layer = video_drvdata(file);
+	struct mxr_device *mdev = layer->mdev;
+	mxr_dbg(mdev, "%s:%d\n", __func__, __LINE__);
+	return vb2_querybuf(&layer->vb_queue, p);
+}
+
+static int mxr_qbuf(struct file *file, void *priv, struct v4l2_buffer *p)
+{
+	struct mxr_layer *layer = video_drvdata(file);
+	struct mxr_device *mdev = layer->mdev;
+	mxr_dbg(mdev, "%s:%d(%d)\n", __func__, __LINE__,
+		p->index);
+	return vb2_qbuf(&layer->vb_queue, p);
+}
+
+static int mxr_dqbuf(struct file *file, void *priv, struct v4l2_buffer *p)
+{
+	struct mxr_layer *layer = video_drvdata(file);
+	struct mxr_device *mdev = layer->mdev;
+	mxr_dbg(mdev, "%s:%d\n", __func__, __LINE__);
+	return vb2_dqbuf(&layer->vb_queue, p, file->f_flags & O_NONBLOCK);
+}
+
+static int mxr_streamon(struct file *file, void *priv, enum v4l2_buf_type i)
+{
+	struct mxr_layer *layer = video_drvdata(file);
+	struct mxr_device *mdev = layer->mdev;
+	mxr_dbg(mdev, "%s:%d\n", __func__, __LINE__);
+	return vb2_streamon(&layer->vb_queue, i);
+}
+
+static int mxr_streamoff(struct file *file, void *priv, enum v4l2_buf_type i)
+{
+	struct mxr_layer *layer = video_drvdata(file);
+	struct mxr_device *mdev = layer->mdev;
+	mxr_dbg(mdev, "%s:%d\n", __func__, __LINE__);
+	return vb2_streamoff(&layer->vb_queue, i);
+}
+
+static const struct v4l2_ioctl_ops mxr_ioctl_ops = {
+	.vidioc_querycap = mxr_querycap,
+	.vidioc_enum_fmt_vid_out = mxr_enum_fmt,
+	.vidioc_s_fmt_vid_out_mplane = mxr_s_fmt,
+	.vidioc_g_fmt_vid_out_mplane = mxr_g_fmt,
+	.vidioc_reqbufs = mxr_reqbufs,
+	.vidioc_querybuf = mxr_querybuf,
+	.vidioc_qbuf = mxr_qbuf,
+	.vidioc_dqbuf = mxr_dqbuf,
+	.vidioc_streamon = mxr_streamon,
+	.vidioc_streamoff = mxr_streamoff,
+
+	/* Preset functions */
+	.vidioc_enum_dv_presets = mxr_enum_dv_presets,
+	.vidioc_s_dv_preset = mxr_s_dv_preset,
+	.vidioc_g_dv_preset = mxr_g_dv_preset,
+
+	/* analog TV standard functions */
+	.vidioc_s_std = mxr_s_std,
+
+	/* Output handling */
+	.vidioc_enum_output = mxr_enum_output,
+	.vidioc_s_output = mxr_s_output,
+	/* Crop ioctls */
+	.vidioc_g_crop = mxr_g_crop,
+	.vidioc_s_crop = mxr_s_crop,
+	.vidioc_cropcap = mxr_cropcap,
+};
+
+static int mxr_video_open(struct file *file)
+{
+	struct mxr_layer *layer = video_drvdata(file);
+	struct mxr_device *mdev = layer->mdev;
+	int ret = 0;
+
+	mxr_dbg(mdev, "%s:%d\n", __func__, __LINE__);
+	/* assure device probe is finished */
+	wait_for_device_probe();
+	/* lock layer->mutex is already taken by video_device */
+	if (++layer->n_user == 1) {
+		mxr_power_get(mdev);
+		/* set default format, first on the list */
+		layer->fmt = layer->fmt_array[0];
+		/* setup default geometry */
+		mxr_layer_default_geo(layer);
+		ret = vb2_queue_init(&layer->vb_queue);
+		if (ret != 0) {
+			mxr_err(mdev, "failed to initialize vb2 queue\n");
+			mxr_power_put(mdev);
+			--layer->n_user;
+		}
+	}
+	return ret;
+}
+
+static unsigned int
+mxr_video_poll(struct file *file, struct poll_table_struct *wait)
+{
+	struct mxr_layer *layer = video_drvdata(file);
+	struct mxr_device *mdev = layer->mdev;
+
+	mxr_info(mdev, "%s:%d\n", __func__, __LINE__);
+
+	return vb2_poll(&layer->vb_queue, file, wait);
+}
+
+static int mxr_video_mmap(struct file *file, struct vm_area_struct *vma)
+{
+	struct mxr_layer *layer = video_drvdata(file);
+	struct mxr_device *mdev = layer->mdev;
+
+	mxr_info(mdev, "%s:%d\n", __func__, __LINE__);
+
+	return vb2_mmap(&layer->vb_queue, vma);
+}
+
+static int mxr_video_release(struct file *file)
+{
+	struct mxr_layer *layer = video_drvdata(file);
+	struct mxr_device *mdev = layer->mdev;
+
+	mxr_info(mdev, "%s:%d\n", __func__, __LINE__);
+	if (--layer->n_user == 0) {
+		vb2_queue_release(&layer->vb_queue);
+		/* TODO: move power off to timer thread */
+		mxr_power_put(mdev);
+	}
+	return 0;
+}
+
+static const struct v4l2_file_operations mxr_fops = {
+	.owner = THIS_MODULE,
+	.open = mxr_video_open,
+	.poll = mxr_video_poll,
+	.mmap = mxr_video_mmap,
+	.release = mxr_video_release,
+	.unlocked_ioctl = video_ioctl2,
+};
+
+static unsigned int divup(unsigned int divident, unsigned int divisor)
+{
+	return (divident + divisor - 1) / divisor;
+}
+
+unsigned long mxr_get_plane_size(const struct mxr_block *blk,
+	unsigned int width, unsigned int height)
+{
+	unsigned int blWidth = divup(width, blk->pxWidth);
+	unsigned int blHeight = divup(height, blk->pxHeight);
+	return blWidth * blHeight * blk->bSize;
+}
+
+static int queue_setup(struct vb2_queue *vq, unsigned int *nbuffers,
+	unsigned int *nplanes, unsigned long sizes[],
+	void *alloc_ctxs[])
+{
+	struct mxr_layer *layer = vb2_get_drv_priv(vq);
+	const struct mxr_format *fmt = layer->fmt;
+	int i;
+	struct mxr_device *mdev = layer->mdev;
+	mxr_dbg(mdev, "%s\n", __func__);
+	/* checking if format was configured */
+	if (fmt == NULL)
+		return -EINVAL;
+	mxr_dbg(mdev, "fmt = %s\n", fmt->name);
+
+	*nplanes = fmt->num_subframes;
+	for (i = 0; i < fmt->num_subframes; ++i) {
+		alloc_ctxs[i] = layer->mdev->alloc_ctx;
+		sizes[i] = 0;
+	}
+
+	for (i = 0; i < fmt->num_planes; ++i) {
+		int frame_idx = fmt->plane2subframe[i];
+		const struct mxr_block *blk = &fmt->plane[i];
+		unsigned long plane_size;
+		plane_size = mxr_get_plane_size(blk, layer->geo.src.full_width,
+			layer->geo.src.full_height);
+		sizes[frame_idx] += plane_size;
+		mxr_dbg(mdev, "plane_size[%d] = %08lx\n", i, plane_size);
+	}
+	for (i = 0; i < fmt->num_subframes; ++i) {
+		sizes[i] = PAGE_ALIGN(sizes[i]);
+		mxr_dbg(mdev, "size[%d] = %08lx\n", i, sizes[i]);
+	}
+
+	if (*nbuffers == 0)
+		*nbuffers = 1;
+
+	return 0;
+}
+
+static void buf_queue(struct vb2_buffer *vb)
+{
+	struct mxr_buffer *buffer = container_of(vb, struct mxr_buffer, vb);
+	struct mxr_layer *layer = vb2_get_drv_priv(vb->vb2_queue);
+	struct mxr_device *mdev = layer->mdev;
+	unsigned long flags;
+	int must_start = 0;
+
+	spin_lock_irqsave(&layer->enq_slock, flags);
+	if (layer->state == MXR_LAYER_STREAMING_START) {
+		layer->state = MXR_LAYER_STREAMING;
+		must_start = 1;
+	}
+	list_add_tail(&buffer->list, &layer->enq_list);
+	spin_unlock_irqrestore(&layer->enq_slock, flags);
+	if (must_start) {
+		layer->ops.stream_set(layer, MXR_ENABLE);
+		mxr_streamer_get(mdev);
+	}
+
+	mxr_dbg(mdev, "queuing buffer\n");
+}
+
+static void wait_lock(struct vb2_queue *vq)
+{
+	struct mxr_layer *layer = vb2_get_drv_priv(vq);
+	struct mxr_device *mdev = layer->mdev;
+	mxr_dbg(mdev, "%s\n", __func__);
+	mutex_lock(&layer->mutex);
+}
+
+static void wait_unlock(struct vb2_queue *vq)
+{
+	struct mxr_layer *layer = vb2_get_drv_priv(vq);
+	struct mxr_device *mdev = layer->mdev;
+	mxr_dbg(mdev, "%s\n", __func__);
+	mutex_unlock(&layer->mutex);
+}
+
+static int start_streaming(struct vb2_queue *vq)
+{
+	struct mxr_layer *layer = vb2_get_drv_priv(vq);
+	struct mxr_device *mdev = layer->mdev;
+	unsigned long flags;
+
+	mxr_dbg(mdev, "%s\n", __func__);
+	/* block any changes in output configuration */
+	mxr_output_get(mdev);
+
+	/* update layers geometry */
+	mxr_layer_geo_fix(layer);
+	mxr_geometry_dump(mdev, &layer->geo);
+
+	layer->ops.format_set(layer);
+	/* enabling layer in hardware */
+	spin_lock_irqsave(&layer->enq_slock, flags);
+	layer->state = MXR_LAYER_STREAMING_START;
+	spin_unlock_irqrestore(&layer->enq_slock, flags);
+
+	return 0;
+}
+
+static void mxr_watchdog(unsigned long arg)
+{
+	struct mxr_layer *layer = (struct mxr_layer *) arg;
+	struct mxr_device *mdev = layer->mdev;
+	unsigned long flags;
+
+	mxr_err(mdev, "watchdog fired for layer %s\n", layer->vfd.name);
+
+	spin_lock_irqsave(&layer->enq_slock, flags);
+
+	if (layer->update_buf == layer->shadow_buf)
+		layer->update_buf = NULL;
+	if (layer->update_buf) {
+		vb2_buffer_done(&layer->update_buf->vb, VB2_BUF_STATE_ERROR);
+		layer->update_buf = NULL;
+	}
+	if (layer->shadow_buf) {
+		vb2_buffer_done(&layer->shadow_buf->vb, VB2_BUF_STATE_ERROR);
+		layer->shadow_buf = NULL;
+	}
+	spin_unlock_irqrestore(&layer->enq_slock, flags);
+}
+
+static int stop_streaming(struct vb2_queue *vq)
+{
+	struct mxr_layer *layer = vb2_get_drv_priv(vq);
+	struct mxr_device *mdev = layer->mdev;
+	unsigned long flags;
+	struct timer_list watchdog;
+	struct mxr_buffer *buf, *buf_tmp;
+
+	mxr_dbg(mdev, "%s\n", __func__);
+
+	spin_lock_irqsave(&layer->enq_slock, flags);
+
+	/* reset list */
+	layer->state = MXR_LAYER_STREAMING_FINISH;
+
+	/* set all buffer to be done */
+	list_for_each_entry_safe(buf, buf_tmp, &layer->enq_list, list) {
+		list_del(&buf->list);
+		vb2_buffer_done(&buf->vb, VB2_BUF_STATE_ERROR);
+	}
+
+	spin_unlock_irqrestore(&layer->enq_slock, flags);
+
+	/* give 1 seconds to complete to complete last buffers */
+	setup_timer_on_stack(&watchdog, mxr_watchdog,
+		(unsigned long)layer);
+	mod_timer(&watchdog, jiffies + msecs_to_jiffies(1000));
+
+	/* wait until all buffers are goes to done state */
+	vb2_wait_for_all_buffers(vq);
+
+	/* stop timer if all synchronization is done */
+	del_timer_sync(&watchdog);
+	destroy_timer_on_stack(&watchdog);
+
+	/* stopping hardware */
+	spin_lock_irqsave(&layer->enq_slock, flags);
+	layer->state = MXR_LAYER_IDLE;
+	spin_unlock_irqrestore(&layer->enq_slock, flags);
+
+	/* disabling layer in hardware */
+	layer->ops.stream_set(layer, MXR_DISABLE);
+	/* remove one streamer */
+	mxr_streamer_put(mdev);
+	/* allow changes in output configuration */
+	mxr_output_put(mdev);
+	return 0;
+}
+
+static struct vb2_ops mxr_video_qops = {
+	.queue_setup = queue_setup,
+	.buf_queue = buf_queue,
+	.wait_prepare = wait_unlock,
+	.wait_finish = wait_lock,
+	.start_streaming = start_streaming,
+	.stop_streaming = stop_streaming,
+};
+
+/* FIXME: itry to put this functions to mxr_base_layer_create */
+int mxr_base_layer_register(struct mxr_layer *layer)
+{
+	struct mxr_device *mdev = layer->mdev;
+	int ret;
+	ret = video_register_device(&layer->vfd, VFL_TYPE_GRABBER, -1);
+	if (ret)
+		mxr_err(mdev, "failed to register video device\n");
+	else
+		mxr_info(mdev, "registered layer %s as /dev/video%d\n",
+			layer->vfd.name, layer->vfd.num);
+	return ret;
+}
+
+void mxr_base_layer_unregister(struct mxr_layer *layer)
+{
+	video_unregister_device(&layer->vfd);
+}
+
+void mxr_layer_release(struct mxr_layer *layer)
+{
+	if (layer->ops.release)
+		layer->ops.release(layer);
+}
+
+void mxr_base_layer_release(struct mxr_layer *layer)
+{
+	kfree(layer);
+}
+
+static void mxr_vfd_release(struct video_device *vdev)
+{
+	printk(KERN_INFO "video device release\n");
+}
+
+struct mxr_layer *mxr_base_layer_create(struct mxr_device *mdev,
+	int idx, char *name, struct mxr_layer_ops *ops)
+{
+	struct mxr_layer *layer;
+
+	layer = kzalloc(sizeof *layer, GFP_KERNEL);
+	if (layer == NULL) {
+		mxr_err(mdev, "not enough memory for layer.\n");
+		goto fail;
+	}
+
+	layer->mdev = mdev;
+	layer->idx = idx;
+	layer->ops = *ops;
+
+	spin_lock_init(&layer->enq_slock);
+	INIT_LIST_HEAD(&layer->enq_list);
+	mutex_init(&layer->mutex);
+
+	layer->vfd = (struct video_device) {
+		.minor = -1,
+		.release = mxr_vfd_release,
+		.fops = &mxr_fops,
+		.ioctl_ops = &mxr_ioctl_ops,
+	};
+	strlcpy(layer->vfd.name, name, sizeof(layer->vfd.name));
+
+	video_set_drvdata(&layer->vfd, layer);
+	layer->vfd.lock = &layer->mutex;
+	layer->vfd.v4l2_dev = &mdev->v4l2_dev;
+
+	layer->vb_queue = (struct vb2_queue) {
+		.type = V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE,
+		.io_modes = VB2_MMAP | VB2_USERPTR,
+		.drv_priv = layer,
+		.buf_struct_size = sizeof(struct mxr_buffer),
+		.ops = &mxr_video_qops,
+		.mem_ops = &vb2_dma_iommu_memops,
+	};
+
+	return layer;
+
+fail:
+	return NULL;
+}
+
+static const struct mxr_format *find_format_by_fourcc(
+	struct mxr_layer *layer, unsigned long fourcc)
+{
+	int i;
+	for (i = 0; i < layer->fmt_array_size; ++i)
+		if (layer->fmt_array[i]->fourcc == fourcc)
+			return layer->fmt_array[i];
+	return NULL;
+}
+
+static const struct mxr_format *find_format_by_index(
+	struct mxr_layer *layer, unsigned long index)
+{
+	if (index >= layer->fmt_array_size)
+		return NULL;
+	return layer->fmt_array[index];
+}
+
diff --git a/drivers/media/video/s5p-tv/mixer_vp_layer.c b/drivers/media/video/s5p-tv/mixer_vp_layer.c
new file mode 100644
index 0000000..5932cee
--- /dev/null
+++ b/drivers/media/video/s5p-tv/mixer_vp_layer.c
@@ -0,0 +1,207 @@
+/*
+ * Samsung TV Mixer driver
+ *
+ * Copyright (c) 2010 Samsung Electronics
+ *
+ * Tomasz Stanislawski, t.stanislaws@samsung.com
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published
+ * by the Free Software Foundiation. either version 2 of the License,
+ * or (at your option) any later version
+ */
+
+#include "mixer.h"
+#include "mixer_reg.h"
+
+#include <media/videobuf2-dma-iommu.h>
+
+#include "regs-vp.h"
+
+
+/* FORMAT DEFINITIONS */
+static const struct mxr_format mxr_fmt_nv12 = {
+	.name = "NV12",
+	.fourcc = V4L2_PIX_FMT_NV12,
+	.num_planes = 2,
+	.plane = {
+		{ .pxWidth = 1, .pxHeight = 1, .bSize = 1 },
+		{ .pxWidth = 2, .pxHeight = 2, .bSize = 2 },
+	},
+	.num_subframes = 1,
+	.hwCode = VP_MODE_NV12 | VP_MODE_MEM_LINEAR,
+};
+
+static const struct mxr_format mxr_fmt_nv21 = {
+	.name = "NV21",
+	.fourcc = V4L2_PIX_FMT_NV21,
+	.num_planes = 2,
+	.plane = {
+		{ .pxWidth = 1, .pxHeight = 1, .bSize = 1 },
+		{ .pxWidth = 2, .pxHeight = 2, .bSize = 2 },
+	},
+	.num_subframes = 1,
+	.hwCode = VP_MODE_NV21 | VP_MODE_MEM_LINEAR,
+};
+
+static const struct mxr_format mxr_fmt_nv12m = {
+	.name = "NV12 (mplane)",
+	.fourcc = V4L2_PIX_FMT_NV12M,
+	.num_planes = 2,
+	.plane = {
+		{ .pxWidth = 1, .pxHeight = 1, .bSize = 1 },
+		{ .pxWidth = 2, .pxHeight = 2, .bSize = 2 },
+	},
+	.num_subframes = 2,
+	.plane2subframe = {0, 1},
+	.hwCode = VP_MODE_NV12 | VP_MODE_MEM_LINEAR,
+};
+
+static const struct mxr_format mxr_fmt_nv12mt = {
+	.name = "NV12 tiled (mplane)",
+	.fourcc = V4L2_PIX_FMT_NV12MT,
+	.num_planes = 2,
+	.plane = {
+		{ .pxWidth = 128, .pxHeight = 32, .bSize = 4096 },
+		{ .pxWidth = 128, .pxHeight = 32, .bSize = 2048 },
+	},
+	.num_subframes = 2,
+	.plane2subframe = {0, 1},
+	.hwCode = VP_MODE_NV12 | VP_MODE_MEM_TILED,
+};
+
+static const struct mxr_format *mxr_video_format[] = {
+	&mxr_fmt_nv12,
+	&mxr_fmt_nv21,
+	&mxr_fmt_nv12m,
+	&mxr_fmt_nv12mt,
+};
+
+/* AUXILIARY CALLBACKS */
+
+static void mxr_vp_layer_release(struct mxr_layer *layer)
+{
+	mxr_base_layer_unregister(layer);
+	mxr_base_layer_release(layer);
+}
+
+static void mxr_vp_buffer_set(struct mxr_layer *layer,
+	struct mxr_buffer *buf)
+{
+	dma_addr_t luma_addr[2] = {0, 0};
+	dma_addr_t chroma_addr[2] = {0, 0};
+	if (buf == NULL) {
+		mxr_reg_vp_buffer(layer->mdev, luma_addr, chroma_addr);
+		return;
+	}
+	luma_addr[0] = vb2_dma_iommu_plane_addr(&buf->vb, 0);
+	if (layer->fmt->num_subframes == 2) {
+		chroma_addr[0] = vb2_dma_iommu_plane_addr(&buf->vb, 1);
+	} else {
+		/* FIXME: mxr_get_plane_size compute integer division,
+		 * which is slow and should not be performed in interrupt */
+		chroma_addr[0] = luma_addr[0] + mxr_get_plane_size(
+			&layer->fmt->plane[0], layer->geo.src.full_width,
+			layer->geo.src.full_height);
+	}
+	if (layer->fmt->hwCode & VP_MODE_MEM_TILED) {
+		luma_addr[1] = luma_addr[0] + 0x40;
+		chroma_addr[1] = chroma_addr[0] + 0x40;
+	} else {
+		luma_addr[1] = luma_addr[0] + layer->geo.src.full_width;
+		chroma_addr[1] = chroma_addr[0];
+	}
+	mxr_reg_vp_buffer(layer->mdev, luma_addr, chroma_addr);
+}
+
+static void mxr_vp_stream_set(struct mxr_layer *layer, int en)
+{
+	mxr_reg_vp_layer_stream(layer->mdev, en);
+}
+
+static void mxr_vp_format_set(struct mxr_layer *layer)
+{
+	mxr_reg_vp_format(layer->mdev, layer->fmt, &layer->geo);
+}
+
+static void mxr_vp_fix_geometry(struct mxr_layer *layer)
+{
+	struct mxr_geometry *geo = &layer->geo;
+	/* align horizontal size to 8 pixels */
+	geo->src.full_width = ALIGN(geo->src.full_width, 8);
+	/* limit to boundary size */
+	geo->src.full_width = clamp_val(geo->src.full_width, 8, 8192);
+	geo->src.full_height = clamp_val(geo->src.full_height, 1, 8192);
+	geo->src.width = clamp_val(geo->src.width, 32, geo->src.full_width);
+	geo->src.width = min(geo->src.width, 2047U);
+	geo->src.height = clamp_val(geo->src.height, 4, geo->src.full_height);
+	geo->src.height = min(geo->src.height, 2047U);
+
+	/* setting size of output window */
+	geo->dst.width = clamp_val(geo->dst.width, 8, geo->dst.full_width);
+	geo->dst.height = clamp_val(geo->dst.height, 1, geo->dst.full_height);
+
+	/* ensure that scaling is in range 1/4x to 16x */
+	if (geo->src.width >= 4 * geo->dst.width)
+		geo->src.width = 4 * geo->dst.width;
+	if (geo->dst.width >= 16 * geo->src.width)
+		geo->dst.width = 16 * geo->src.width;
+	if (geo->src.height >= 4 * geo->dst.height)
+		geo->src.height = 4 * geo->dst.height;
+	if (geo->dst.height >= 16 * geo->src.height)
+		geo->dst.height = 16 * geo->src.height;
+
+	/* setting scaling ratio */
+	geo->x_ratio = (geo->src.width << 16) / geo->dst.width;
+	geo->y_ratio = (geo->src.height << 16) / geo->dst.height;
+
+	/* adjust offsets */
+	geo->src.x_offset = min(geo->src.x_offset,
+		geo->src.full_width - geo->src.width);
+	geo->src.y_offset = min(geo->src.y_offset,
+		geo->src.full_height - geo->src.height);
+	geo->dst.x_offset = min(geo->dst.x_offset,
+		geo->dst.full_width - geo->dst.width);
+	geo->dst.y_offset = min(geo->dst.y_offset,
+		geo->dst.full_height - geo->dst.height);
+}
+
+/* PUBLIC API */
+
+struct mxr_layer *mxr_vp_layer_create(struct mxr_device *mdev, int idx)
+{
+	struct mxr_layer *layer;
+	int ret;
+	struct mxr_layer_ops ops = {
+		.release = mxr_vp_layer_release,
+		.buffer_set = mxr_vp_buffer_set,
+		.stream_set = mxr_vp_stream_set,
+		.format_set = mxr_vp_format_set,
+		.fix_geometry = mxr_vp_fix_geometry,
+	};
+	char name[32];
+
+	sprintf(name, "video%d", idx);
+
+	layer = mxr_base_layer_create(mdev, idx, name, &ops);
+	if (layer == NULL) {
+		mxr_err(mdev, "failed to initialize layer(%d) base\n", idx);
+		goto fail;
+	}
+
+	layer->fmt_array = mxr_video_format;
+	layer->fmt_array_size = ARRAY_SIZE(mxr_video_format);
+
+	ret = mxr_base_layer_register(layer);
+	if (ret)
+		goto fail_layer;
+
+	return layer;
+
+fail_layer:
+	mxr_base_layer_release(layer);
+
+fail:
+	return NULL;
+}
+
diff --git a/drivers/media/video/s5p-tv/regs-hdmi.h b/drivers/media/video/s5p-tv/regs-hdmi.h
new file mode 100644
index 0000000..eedf36d
--- /dev/null
+++ b/drivers/media/video/s5p-tv/regs-hdmi.h
@@ -0,0 +1,1849 @@
+/* linux/arch/arm/mach-exynos4/include/mach/regs-hdmi.h
+ *
+ * Copyright (c) 2010 Samsung Electronics
+ * http://www.samsung.com/
+ *
+ * HDMI register header file for Samsung TVOUT driver
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+*/
+
+#ifndef __ASM_ARCH_REGS_HDMI_H
+
+/*
+ * Register part
+*/
+#define HDMI_CTRL_BASE(x)			(x)
+#define HDMI_BASE(x)				((x) + 0x00010000)
+#define HDMI_SPDIF_BASE(x)			((x) + 0x00030000)
+#define HDMI_I2S_BASE(x)			((x) + 0x00040000)
+#define HDMI_TG_BASE(x)				((x) + 0x00050000)
+#define HDMI_EFUSE_BASE(x)			((x) + 0x00060000)
+
+
+/* Interrupt Control Register */
+#define HDMI_INTC_CON			HDMI_CTRL_BASE(0x0000)
+/* Interrupt Flag Register */
+#define HDMI_INTC_FLAG			HDMI_CTRL_BASE(0x0004)
+/* HDCP KEY Status */
+#define HDMI_HDCP_KEY_LOAD			HDMI_CTRL_BASE(0x0008)
+/* HPD signal */
+#define HDMI_HPD_STATUS			HDMI_CTRL_BASE(0x000C)
+/* Audio system clock selection */
+#define HDMI_AUDIO_CLKSEL			HDMI_CTRL_BASE(0x0010)
+/* HDMI PHY Reset Out */
+#define HDMI_PHY_RSTOUT			HDMI_CTRL_BASE(0x0014)
+/* HDMI PHY VPLL Monitor */
+#define HDMI_PHY_VPLL			HDMI_CTRL_BASE(0x0018)
+/* HDMI PHY CMU Monitor */
+#define HDMI_PHY_CMU			HDMI_CTRL_BASE(0x001C)
+/* HDMI TX Core S/W reset */
+#define HDMI_CORE_RSTOUT			HDMI_CTRL_BASE(0x0020)
+
+/* HDMI System Control Register 0 0x00 */
+#define HDMI_CON_0				HDMI_BASE(0x0000)
+/* HDMI System Control Register 1 0x00 */
+#define HDMI_CON_1				HDMI_BASE(0x0004)
+/* HDMI System Control Register 2. 0x00 */
+#define HDMI_CON_2				HDMI_BASE(0x0008)
+/* HDMI System Status Register 0x00 */
+#define HDMI_SYS_STATUS			HDMI_BASE(0x0010)
+/* HDMI Phy Status */
+#define HDMI_PHY_STATUS			HDMI_BASE(0x0014)
+/* HDMI System Status Enable Register 0x00 */
+#define HDMI_STATUS_EN			HDMI_BASE(0x0020)
+/* Hot Plug Detection Control Register 0x00 */
+#define HDMI_HPD				HDMI_BASE(0x0030)
+/* HDMI/DVI Mode Selection 0x00 */
+#define HDMI_MODE_SEL			HDMI_BASE(0x0040)
+/* HDCP Encryption Enable Register 0x00 */
+#define HDMI_ENC_EN				HDMI_BASE(0x0044)
+
+/* Pixel Values for Blue Screen 0x00 */
+#define HDMI_BLUE_SCREEN_0			HDMI_BASE(0x0050)
+/* Pixel Values for Blue Screen 0x00 */
+#define HDMI_BLUE_SCREEN_1			HDMI_BASE(0x0054)
+/* Pixel Values for Blue Screen 0x00 */
+#define HDMI_BLUE_SCREEN_2			HDMI_BASE(0x0058)
+
+/* Maximum Y (or R,G,B) Pixel Value 0xEB */
+#define HDMI_YMAX				HDMI_BASE(0x0060)
+/* Minimum Y (or R,G,B) Pixel Value 0x10 */
+#define HDMI_YMIN				HDMI_BASE(0x0064)
+/* Maximum Cb/ Cr Pixel Value 0xF0 */
+#define HDMI_CMAX				HDMI_BASE(0x0068)
+/* Minimum Cb/ Cr Pixel Value 0x10 */
+#define HDMI_CMIN				HDMI_BASE(0x006C)
+
+/* Horizontal Blanking Setting 0x00 */
+#define HDMI_H_BLANK_0			HDMI_BASE(0x00A0)
+/* Horizontal Blanking Setting 0x00 */
+#define HDMI_H_BLANK_1			HDMI_BASE(0x00A4)
+/* Vertical Blanking Setting 0x00 */
+#define HDMI_V_BLANK_0			HDMI_BASE(0x00B0)
+/* Vertical Blanking Setting 0x00 */
+#define HDMI_V_BLANK_1			HDMI_BASE(0x00B4)
+/* Vertical Blanking Setting 0x00 */
+#define HDMI_V_BLANK_2			HDMI_BASE(0x00B8)
+/* Hori. Line and Ver. Line 0x00 */
+#define HDMI_H_V_LINE_0			HDMI_BASE(0x00C0)
+/* Hori. Line and Ver. Line 0x00 */
+#define HDMI_H_V_LINE_1			HDMI_BASE(0x00C4)
+/* Hori. Line and Ver. Line 0x00 */
+#define HDMI_H_V_LINE_2			HDMI_BASE(0x00C8)
+
+/* Vertical Sync Polarity Control Register 0x00 */
+#define HDMI_SYNC_MODE			HDMI_BASE(0x00E4)
+/* Vertical Sync Polarity Control Register 0x00 */
+#define HDMI_VSYNC_POL			HDMI_BASE(0x00E4)
+/* Interlace/ Progressive Control Register 0x00 */
+#define HDMI_INT_PRO_MODE			HDMI_BASE(0x00E8)
+
+/* Vertical Blanking Setting for Bottom Field 0x00 */
+#define HDMI_V_BLANK_F_0			HDMI_BASE(0x0110)
+/* Vertical Blanking Setting for Bottom Field 0x00 */
+#define HDMI_V_BLANK_F_1			HDMI_BASE(0x0114)
+/* Vertical Blanking Setting for Bottom Field 0x00 */
+#define HDMI_V_BLANK_F_2			HDMI_BASE(0x0118)
+/* Horizontal Sync Generation Setting 0x00 */
+#define HDMI_H_SYNC_GEN_0			HDMI_BASE(0x0120)
+/* Horizontal Sync Generation Setting 0x00 */
+#define HDMI_H_SYNC_GEN_1			HDMI_BASE(0x0124)
+/* Horizontal Sync Generation Setting 0x00 */
+#define HDMI_H_SYNC_GEN_2			HDMI_BASE(0x0128)
+/* Vertical Sync Generation for Top Field or Frame. 0x01 */
+#define HDMI_V_SYNC_GEN_1_0			HDMI_BASE(0x0130)
+/* Vertical Sync Generation for Top Field or Frame. 0x10 */
+#define HDMI_V_SYNC_GEN_1_1			HDMI_BASE(0x0134)
+/* Vertical Sync Generation for Top Field or Frame. 0x00 */
+#define HDMI_V_SYNC_GEN_1_2			HDMI_BASE(0x0138)
+/* Vertical Sync Generation for Bottom field ? Vertical position. 0x01 */
+#define HDMI_V_SYNC_GEN_2_0			HDMI_BASE(0x0140)
+/* Vertical Sync Generation for Bottom field ? Vertical position. 0x10 */
+#define HDMI_V_SYNC_GEN_2_1			HDMI_BASE(0x0144)
+/* Vertical Sync Generation for Bottom field ? Vertical position. 0x00 */
+#define HDMI_V_SYNC_GEN_2_2			HDMI_BASE(0x0148)
+/* Vertical Sync Generation for Bottom field ? Horizontal position. 0x01 */
+#define HDMI_V_SYNC_GEN_3_0			HDMI_BASE(0x0150)
+/* Vertical Sync Generation for Bottom field ? Horizontal position. 0x10 */
+#define HDMI_V_SYNC_GEN_3_1			HDMI_BASE(0x0154)
+/* Vertical Sync Generation for Bottom field ? Horizontal position. 0x00 */
+#define HDMI_V_SYNC_GEN_3_2			HDMI_BASE(0x0158)
+
+/* ASP Packet Control Register 0x00 */
+#define HDMI_ASP_CON			HDMI_BASE(0x0160)
+/* ASP Packet sp_flat Bit Control 0x00 */
+#define HDMI_ASP_SP_FLAT			HDMI_BASE(0x0164)
+/* ASP Audio Channel Configuration 0x04 */
+#define HDMI_ASP_CHCFG0			HDMI_BASE(0x0170)
+/* ASP Audio Channel Configuration 0x1A */
+#define HDMI_ASP_CHCFG1			HDMI_BASE(0x0174)
+/* ASP Audio Channel Configuration 0x2C */
+#define HDMI_ASP_CHCFG2			HDMI_BASE(0x0178)
+/* ASP Audio Channel Configuration 0x3E */
+#define HDMI_ASP_CHCFG3			HDMI_BASE(0x017C)
+
+/* ACR Packet Control Register 0x00 */
+#define HDMI_ACR_CON			HDMI_BASE(0x0180)
+/* Measured CTS Value 0x01 */
+#define HDMI_ACR_MCTS0			HDMI_BASE(0x0184)
+/* Measured CTS Value 0x00 */
+#define HDMI_ACR_MCTS1			HDMI_BASE(0x0188)
+/* Measured CTS Value 0x00 */
+#define HDMI_ACR_MCTS2			HDMI_BASE(0x018C)
+/* CTS Value for Fixed CTS Transmission Mode. 0xE8 */
+#define HDMI_ACR_CTS0			HDMI_BASE(0x0190)
+/* CTS Value for Fixed CTS Transmission Mode. 0x03 */
+#define HDMI_ACR_CTS1			HDMI_BASE(0x0194)
+/* CTS Value for Fixed CTS Transmission Mode. 0x00 */
+#define HDMI_ACR_CTS2			HDMI_BASE(0x0198)
+/* N Value for ACR Packet. 0xE8 */
+#define HDMI_ACR_N0				HDMI_BASE(0x01A0)
+/* N Value for ACR Packet. 0x03 */
+#define HDMI_ACR_N1				HDMI_BASE(0x01A4)
+/* N Value for ACR Packet. 0x00 */
+#define HDMI_ACR_N2				HDMI_BASE(0x01A8)
+/* Altenate LSB for Fixed CTS Transmission Mode 0x00 */
+#define HDMI_ACR_LSB2			HDMI_BASE(0x01B0)
+/* Number of ACR Packet Transmission per frame 0x1F */
+#define HDMI_ACR_TXCNT			HDMI_BASE(0x01B4)
+/* Interval for ACR Packet Transmission 0x63 */
+#define HDMI_ACR_TXINTERVAL			HDMI_BASE(0x01B8)
+/* CTS Offset for Measured CTS mode. 0x00 */
+#define HDMI_ACR_CTS_OFFSET			HDMI_BASE(0x01BC)
+
+/* ACR Packet Control register 0x00 */
+#define HDMI_GCP_CON			HDMI_BASE(0x01C0)
+/* GCP Packet Body 0x00 */
+#define HDMI_GCP_BYTE1			HDMI_BASE(0x01D0)
+/* GCP Packet Body 0x01 */
+#define HDMI_GCP_BYTE2			HDMI_BASE(0x01D4)
+/* GCP Packet Body 0x02 */
+#define HDMI_GCP_BYTE3			HDMI_BASE(0x01D8)
+
+/* ACP Packet Control register 0x00 */
+#define HDMI_ACP_CON			HDMI_BASE(0x01E0)
+/* ACP Packet Header 0x00 */
+#define HDMI_ACP_TYPE			HDMI_BASE(0x01E4)
+
+/* ACP Packet Body 0x00 */
+#define HDMI_ACP_DATA0			HDMI_BASE(0x0200)
+/* ACP Packet Body 0x00 */
+#define HDMI_ACP_DATA1			HDMI_BASE(0x0204)
+/* ACP Packet Body 0x00 */
+#define HDMI_ACP_DATA2			HDMI_BASE(0x0208)
+/* ACP Packet Body 0x00 */
+#define HDMI_ACP_DATA3			HDMI_BASE(0x020c)
+/* ACP Packet Body 0x00 */
+#define HDMI_ACP_DATA4			HDMI_BASE(0x0210)
+/* ACP Packet Body 0x00 */
+#define HDMI_ACP_DATA5			HDMI_BASE(0x0214)
+/* ACP Packet Body 0x00 */
+#define HDMI_ACP_DATA6			HDMI_BASE(0x0218)
+/* ACP Packet Body 0x00 */
+#define HDMI_ACP_DATA7			HDMI_BASE(0x021c)
+/* ACP Packet Body 0x00 */
+#define HDMI_ACP_DATA8			HDMI_BASE(0x0220)
+/* ACP Packet Body 0x00 */
+#define HDMI_ACP_DATA9			HDMI_BASE(0x0224)
+/* ACP Packet Body 0x00 */
+#define HDMI_ACP_DATA10			HDMI_BASE(0x0228)
+/* ACP Packet Body 0x00 */
+#define HDMI_ACP_DATA11			HDMI_BASE(0x022c)
+/* ACP Packet Body 0x00 */
+#define HDMI_ACP_DATA12			HDMI_BASE(0x0230)
+/* ACP Packet Body 0x00 */
+#define HDMI_ACP_DATA13			HDMI_BASE(0x0234)
+/* ACP Packet Body 0x00 */
+#define HDMI_ACP_DATA14			HDMI_BASE(0x0238)
+/* ACP Packet Body 0x00 */
+#define HDMI_ACP_DATA15			HDMI_BASE(0x023c)
+/* ACP Packet Body 0x00 */
+#define HDMI_ACP_DATA16			HDMI_BASE(0x0240)
+
+/* ACR Packet Control Register 0x00 */
+#define HDMI_ISRC_CON			HDMI_BASE(0x0250)
+/* ISCR1 Packet Header 0x00 */
+#define HDMI_ISRC1_HEADER1			HDMI_BASE(0x0264)
+
+/* ISRC1 Packet Body 0x00 */
+#define HDMI_ISRC1_DATA0			HDMI_BASE(0x0270)
+/* ISRC1 Packet Body 0x00 */
+#define HDMI_ISRC1_DATA1			HDMI_BASE(0x0274)
+/* ISRC1 Packet Body 0x00 */
+#define HDMI_ISRC1_DATA2			HDMI_BASE(0x0278)
+/* ISRC1 Packet Body 0x00 */
+#define HDMI_ISRC1_DATA3			HDMI_BASE(0x027c)
+/* ISRC1 Packet Body 0x00 */
+#define HDMI_ISRC1_DATA4			HDMI_BASE(0x0280)
+/* ISRC1 Packet Body 0x00 */
+#define HDMI_ISRC1_DATA5			HDMI_BASE(0x0284)
+/* ISRC1 Packet Body 0x00 */
+#define HDMI_ISRC1_DATA6			HDMI_BASE(0x0288)
+/* ISRC1 Packet Body 0x00 */
+#define HDMI_ISRC1_DATA7			HDMI_BASE(0x028c)
+/* ISRC1 Packet Body 0x00 */
+#define HDMI_ISRC1_DATA8			HDMI_BASE(0x0290)
+/* ISRC1 Packet Body 0x00 */
+#define HDMI_ISRC1_DATA9			HDMI_BASE(0x0294)
+/* ISRC1 Packet Body 0x00 */
+#define HDMI_ISRC1_DATA10			HDMI_BASE(0x0298)
+/* ISRC1 Packet Body 0x00 */
+#define HDMI_ISRC1_DATA11			HDMI_BASE(0x029c)
+/* ISRC1 Packet Body 0x00 */
+#define HDMI_ISRC1_DATA12			HDMI_BASE(0x02a0)
+/* ISRC1 Packet Body 0x00 */
+#define HDMI_ISRC1_DATA13			HDMI_BASE(0x02a4)
+/* ISRC1 Packet Body 0x00 */
+#define HDMI_ISRC1_DATA14			HDMI_BASE(0x02a8)
+/* ISRC1 Packet Body 0x00 */
+#define HDMI_ISRC1_DATA15			HDMI_BASE(0x02ac)
+
+/* ISRC2 Packet Body 0x00 */
+#define HDMI_ISRC2_DATA0			HDMI_BASE(0x02b0)
+/* ISRC2 Packet Body 0x00 */
+#define HDMI_ISRC2_DATA1			HDMI_BASE(0x02b4)
+/* ISRC2 Packet Body 0x00 */
+#define HDMI_ISRC2_DATA2			HDMI_BASE(0x02b8)
+/* ISRC2 Packet Body 0x00 */
+#define HDMI_ISRC2_DATA3			HDMI_BASE(0x02bc)
+/* ISRC2 Packet Body 0x00 */
+#define HDMI_ISRC2_DATA4			HDMI_BASE(0x02c0)
+/* ISRC2 Packet Body 0x00 */
+#define HDMI_ISRC2_DATA5			HDMI_BASE(0x02c4)
+/* ISRC2 Packet Body 0x00 */
+#define HDMI_ISRC2_DATA6			HDMI_BASE(0x02c8)
+/* ISRC2 Packet Body 0x00 */
+#define HDMI_ISRC2_DATA7			HDMI_BASE(0x02cc)
+/* ISRC2 Packet Body 0x00 */
+#define HDMI_ISRC2_DATA8			HDMI_BASE(0x02d0)
+/* ISRC2 Packet Body 0x00 */
+#define HDMI_ISRC2_DATA9			HDMI_BASE(0x02d4)
+/* ISRC2 Packet Body 0x00 */
+#define HDMI_ISRC2_DATA10			HDMI_BASE(0x02d8)
+/* ISRC2 Packet Body 0x00 */
+#define HDMI_ISRC2_DATA11			HDMI_BASE(0x02dc)
+/* ISRC2 Packet Body 0x00 */
+#define HDMI_ISRC2_DATA12			HDMI_BASE(0x02e0)
+/* ISRC2 Packet Body 0x00 */
+#define HDMI_ISRC2_DATA13			HDMI_BASE(0x02e4)
+/* ISRC2 Packet Body 0x00 */
+#define HDMI_ISRC2_DATA14			HDMI_BASE(0x02e8)
+/* ISRC2 Packet Body 0x00 */
+#define HDMI_ISRC2_DATA15			HDMI_BASE(0x02ec)
+
+/* AVI Packet Control Register 0x00 */
+#define HDMI_AVI_CON			HDMI_BASE(0x0300)
+/* AVI Packet Checksum 0x00 */
+#define HDMI_AVI_CHECK_SUM			HDMI_BASE(0x0310)
+
+/* AVI Packet Body 0x00 */
+#define HDMI_AVI_BYTE1			HDMI_BASE(0x0320)
+/* AVI Packet Body 0x00 */
+#define HDMI_AVI_BYTE2			HDMI_BASE(0x0324)
+/* AVI Packet Body 0x00 */
+#define HDMI_AVI_BYTE3			HDMI_BASE(0x0328)
+/* AVI Packet Body 0x00 */
+#define HDMI_AVI_BYTE4			HDMI_BASE(0x032c)
+/* AVI Packet Body 0x00 */
+#define HDMI_AVI_BYTE5			HDMI_BASE(0x0330)
+/* AVI Packet Body 0x00 */
+#define HDMI_AVI_BYTE6			HDMI_BASE(0x0334)
+/* AVI Packet Body 0x00 */
+#define HDMI_AVI_BYTE7			HDMI_BASE(0x0338)
+/* AVI Packet Body 0x00 */
+#define HDMI_AVI_BYTE8			HDMI_BASE(0x033c)
+/* AVI Packet Body 0x00 */
+#define HDMI_AVI_BYTE9			HDMI_BASE(0x0340)
+/* AVI Packet Body 0x00 */
+#define HDMI_AVI_BYTE10			HDMI_BASE(0x0344)
+/* AVI Packet Body 0x00 */
+#define HDMI_AVI_BYTE11			HDMI_BASE(0x0348)
+/* AVI Packet Body 0x00 */
+#define HDMI_AVI_BYTE12			HDMI_BASE(0x034c)
+/* AVI Packet Body 0x00  */
+#define HDMI_AVI_BYTE13			HDMI_BASE(0x0350)
+
+/* AUI Packet Control Register 0x00 */
+#define HDMI_AUI_CON			HDMI_BASE(0x0360)
+/* AUI Packet Checksum 0x00 */
+#define HDMI_AUI_CHECK_SUM			HDMI_BASE(0x0370)
+
+/* AUI Packet Body 0x00 */
+#define HDMI_AUI_BYTE1			HDMI_BASE(0x0380)
+/* AUI Packet Body 0x00 */
+#define HDMI_AUI_BYTE2			HDMI_BASE(0x0384)
+/* AUI Packet Body 0x00 */
+#define HDMI_AUI_BYTE3			HDMI_BASE(0x0388)
+/* AUI Packet Body 0x00 */
+#define HDMI_AUI_BYTE4			HDMI_BASE(0x038c)
+/* AUI Packet Body 0x00 */
+#define HDMI_AUI_BYTE5			HDMI_BASE(0x0390)
+
+/* ACR Packet Control Register 0x00 */
+#define HDMI_MPG_CON			HDMI_BASE(0x03A0)
+/* MPG Packet Checksum 0x00 */
+#define HDMI_MPG_CHECK_SUM			HDMI_BASE(0x03B0)
+
+/* MPEG Packet Body 0x00 */
+#define HDMI_MPEG_BYTE1			HDMI_BASE(0x03c0)
+/* MPEG Packet Body 0x00 */
+#define HDMI_MPEG_BYTE2			HDMI_BASE(0x03c4)
+/* MPEG Packet Body 0x00 */
+#define HDMI_MPEG_BYTE3			HDMI_BASE(0x03c8)
+/* MPEG Packet Body 0x00 */
+#define HDMI_MPEG_BYTE4			HDMI_BASE(0x03cc)
+/* MPEG Packet Body 0x00 */
+#define HDMI_MPEG_BYTE5			HDMI_BASE(0x03d0)
+
+/* SPD Packet Control Register 0x00 */
+#define HDMI_SPD_CON			HDMI_BASE(0x0400)
+/* SPD Packet Header 0x00 */
+#define HDMI_SPD_HEADER0			HDMI_BASE(0x0410)
+/* SPD Packet Header 0x00 */
+#define HDMI_SPD_HEADER1			HDMI_BASE(0x0414)
+/* SPD Packet Header 0x00 */
+#define HDMI_SPD_HEADER2			HDMI_BASE(0x0418)
+
+/* SPD Packet Body 0x00 */
+#define HDMI_SPD_DATA0			HDMI_BASE(0x0420)
+/* SPD Packet Body 0x00 */
+#define HDMI_SPD_DATA1			HDMI_BASE(0x0424)
+/* SPD Packet Body 0x00 */
+#define HDMI_SPD_DATA2			HDMI_BASE(0x0428)
+/* SPD Packet Body 0x00 */
+#define HDMI_SPD_DATA3			HDMI_BASE(0x042c)
+/* SPD Packet Body 0x00 */
+#define HDMI_SPD_DATA4			HDMI_BASE(0x0430)
+/* SPD Packet Body 0x00 */
+#define HDMI_SPD_DATA5			HDMI_BASE(0x0434)
+/* SPD Packet Body 0x00 */
+#define HDMI_SPD_DATA6			HDMI_BASE(0x0438)
+/* SPD Packet Body 0x00 */
+#define HDMI_SPD_DATA7			HDMI_BASE(0x043c)
+/* SPD Packet Body 0x00 */
+#define HDMI_SPD_DATA8			HDMI_BASE(0x0440)
+/* SPD Packet Body 0x00 */
+#define HDMI_SPD_DATA9			HDMI_BASE(0x0444)
+/* SPD Packet Body 0x00 */
+#define HDMI_SPD_DATA10			HDMI_BASE(0x0448)
+/* SPD Packet Body 0x00 */
+#define HDMI_SPD_DATA11			HDMI_BASE(0x044c)
+/* SPD Packet Body 0x00 */
+#define HDMI_SPD_DATA12			HDMI_BASE(0x0450)
+/* SPD Packet Body 0x00 */
+#define HDMI_SPD_DATA13			HDMI_BASE(0x0454)
+/* SPD Packet Body 0x00 */
+#define HDMI_SPD_DATA14			HDMI_BASE(0x0458)
+/* SPD Packet Body 0x00 */
+#define HDMI_SPD_DATA15			HDMI_BASE(0x045c)
+/* SPD Packet Body 0x00 */
+#define HDMI_SPD_DATA16			HDMI_BASE(0x0460)
+/* SPD Packet Body 0x00 */
+#define HDMI_SPD_DATA17			HDMI_BASE(0x0464)
+/* SPD Packet Body 0x00 */
+#define HDMI_SPD_DATA18			HDMI_BASE(0x0468)
+/* SPD Packet Body 0x00 */
+#define HDMI_SPD_DATA19			HDMI_BASE(0x046c)
+/* SPD Packet Body 0x00 */
+#define HDMI_SPD_DATA20			HDMI_BASE(0x0470)
+/* SPD Packet Body 0x00 */
+#define HDMI_SPD_DATA21			HDMI_BASE(0x0474)
+/* SPD Packet Body 0x00 */
+#define HDMI_SPD_DATA22			HDMI_BASE(0x0478)
+/* SPD Packet Body 0x00 */
+#define HDMI_SPD_DATA23			HDMI_BASE(0x048c)
+/* SPD Packet Body 0x00 */
+#define HDMI_SPD_DATA24			HDMI_BASE(0x0480)
+/* SPD Packet Body 0x00 */
+#define HDMI_SPD_DATA25			HDMI_BASE(0x0484)
+/* SPD Packet Body 0x00 */
+#define HDMI_SPD_DATA26			HDMI_BASE(0x0488)
+/* SPD Packet Body 0x00 */
+#define HDMI_SPD_DATA27			HDMI_BASE(0x048c)
+
+/* SHA-1 Value from Repeater 0x00 */
+#define HDMI_HDCP_RX_SHA1_0_0		HDMI_BASE(0x0600)
+/* SHA-1 Value from Repeater 0x00 */
+#define HDMI_HDCP_RX_SHA1_0_1		HDMI_BASE(0x0604)
+/* SHA-1 value from Repeater 0x00 */
+#define HDMI_HDCP_RX_SHA1_0_2		HDMI_BASE(0x0608)
+/* SHA-1 value from Repeater 0x00 */
+#define HDMI_HDCP_RX_SHA1_0_3		HDMI_BASE(0x060C)
+/* SHA-1 value from Repeater 0x00 */
+#define HDMI_HDCP_RX_SHA1_1_0		HDMI_BASE(0x0610)
+/* SHA-1 value from Repeater 0x00 */
+#define HDMI_HDCP_RX_SHA1_1_1		HDMI_BASE(0x0614)
+/* SHA-1 value from Repeater 0x00 */
+#define HDMI_HDCP_RX_SHA1_1_2		HDMI_BASE(0x0618)
+/* SHA-1 value from Repeater 0x00 */
+#define HDMI_HDCP_RX_SHA1_1_3		HDMI_BASE(0x061C)
+/* SHA-1 value from Repeater 0x00 */
+#define HDMI_HDCP_RX_SHA1_2_0		HDMI_BASE(0x0620)
+/* SHA-1 value from Repeater 0x00 */
+#define HDMI_HDCP_RX_SHA1_2_1		HDMI_BASE(0x0624)
+/* SHA-1 value from Repeater 0x00 */
+#define HDMI_HDCP_RX_SHA1_2_2		HDMI_BASE(0x0628)
+/* SHA-1 value from Repeater 0x00 */
+#define HDMI_HDCP_RX_SHA1_2_3		HDMI_BASE(0x062C)
+/* SHA-1 value from Repeater 0x00 */
+#define HDMI_HDCP_RX_SHA1_3_0		HDMI_BASE(0x0630)
+/* SHA-1 value from Repeater 0x00 */
+#define HDMI_HDCP_RX_SHA1_3_1		HDMI_BASE(0x0634)
+/* SHA-1 value from Repeater 0x00 */
+#define HDMI_HDCP_RX_SHA1_3_2		HDMI_BASE(0x0638)
+/* SHA-1 value from Repeater 0x00 */
+#define HDMI_HDCP_RX_SHA1_3_3		HDMI_BASE(0x063C)
+/* SHA-1 value from Repeater 0x00 */
+#define HDMI_HDCP_RX_SHA1_4_0		HDMI_BASE(0x0640)
+/* SHA-1 value from Repeater 0x00 */
+#define HDMI_HDCP_RX_SHA1_4_1		HDMI_BASE(0x0644)
+/* SHA-1 value from Repeater 0x00 */
+#define HDMI_HDCP_RX_SHA1_4_2		HDMI_BASE(0x0648)
+/* SHA-1 value from Repeater 0x00 */
+#define HDMI_HDCP_RX_SHA1_4_3		HDMI_BASE(0x064C)
+
+/* Receiver KSV 0 0x00 */
+#define HDMI_HDCP_RX_KSV_0_0		HDMI_BASE(0x0650)
+/* Receiver KSV 0 0x00 */
+#define HDMI_HDCP_RX_KSV_0_1		HDMI_BASE(0x0654)
+/* Receiver KSV 0 0x00 */
+#define HDMI_HDCP_RX_KSV_0_2		HDMI_BASE(0x0658)
+/* Receiver KSV 0 0x00 */
+#define HDMI_HDCP_RX_KSV_0_3		HDMI_BASE(0x065C)
+/* Receiver KSV 1 0x00 */
+#define HDMI_HDCP_RX_KSV_0_4		HDMI_BASE(0x0660)
+
+/* Receiver KSV 1 0x00 */
+#define HDMI_HDCP_KSV_LIST_CON		HDMI_BASE(0x0664)
+/* 2nd authentication status 0x00 */
+#define HDMI_HDCP_SHA_RESULT		HDMI_BASE(0x0670)
+/* HDCP Control 0x00 */
+#define HDMI_HDCP_CTRL1			HDMI_BASE(0x0680)
+/* HDCP Control 0x00 */
+#define HDMI_HDCP_CTRL2			HDMI_BASE(0x0684)
+/* HDCP Ri, Pj, V result 0x00 */
+#define HDMI_HDCP_CHECK_RESULT		HDMI_BASE(0x0690)
+
+/* Receiver BKSV 0x00 */
+#define HDMI_HDCP_BKSV_0_0			HDMI_BASE(0x06A0)
+/* Receiver BKSV 0x00 */
+#define HDMI_HDCP_BKSV_0_1			HDMI_BASE(0x06A4)
+/* Receiver BKSV 0x00 */
+#define HDMI_HDCP_BKSV_0_2			HDMI_BASE(0x06A8)
+/* Receiver BKSV 0x00 */
+#define HDMI_HDCP_BKSV_0_3			HDMI_BASE(0x06AC)
+/* Receiver BKSV 0x00 */
+#define HDMI_HDCP_BKSV_1			HDMI_BASE(0x06B0)
+
+/* Transmitter AKSV 0x00 */
+#define HDMI_HDCP_AKSV_0_0			HDMI_BASE(0x06C0)
+/* Transmitter AKSV 0x00 */
+#define HDMI_HDCP_AKSV_0_1			HDMI_BASE(0x06C4)
+/* Transmitter AKSV 0x00 */
+#define HDMI_HDCP_AKSV_0_2			HDMI_BASE(0x06C8)
+/* Transmitter AKSV 0x00 */
+#define HDMI_HDCP_AKSV_0_3			HDMI_BASE(0x06CC)
+/* Transmitter AKSV 0x00 */
+#define HDMI_HDCP_AKSV_1			HDMI_BASE(0x06D0)
+
+/* Transmitter An 0x00 */
+#define HDMI_HDCP_An_0_0			HDMI_BASE(0x06E0)
+/* Transmitter An 0x00 */
+#define HDMI_HDCP_An_0_1			HDMI_BASE(0x06E4)
+/* Transmitter An 0x00 */
+#define HDMI_HDCP_An_0_2			HDMI_BASE(0x06E8)
+/* Transmitter An 0x00 */
+#define HDMI_HDCP_An_0_3			HDMI_BASE(0x06EC)
+/* Transmitter An 0x00 */
+#define HDMI_HDCP_An_1_0			HDMI_BASE(0x06F0)
+/* Transmitter An 0x00 */
+#define HDMI_HDCP_An_1_1			HDMI_BASE(0x06F4)
+/* Transmitter An 0x00 */
+#define HDMI_HDCP_An_1_2			HDMI_BASE(0x06F8)
+/* Transmitter An 0x00 */
+#define HDMI_HDCP_An_1_3			HDMI_BASE(0x06FC)
+
+/* Receiver BCAPS 0x00 */
+#define HDMI_HDCP_BCAPS			HDMI_BASE(0x0700)
+/* Receiver BSTATUS 0x00 */
+#define HDMI_HDCP_BSTATUS_0			HDMI_BASE(0x0710)
+/* Receiver BSTATUS 0x00 */
+#define HDMI_HDCP_BSTATUS_1			HDMI_BASE(0x0714)
+/* Transmitter Ri 0x00 */
+#define HDMI_HDCP_Ri_0			HDMI_BASE(0x0740)
+/* Transmitter Ri 0x00 */
+#define HDMI_HDCP_Ri_1			HDMI_BASE(0x0744)
+
+/* HDCP I2C interrupt status */
+#define HDMI_HDCP_I2C_INT			HDMI_BASE(0x0780)
+/* HDCP An interrupt status */
+#define HDMI_HDCP_AN_INT			HDMI_BASE(0x0790)
+/* HDCP Watchdog interrupt status */
+#define HDMI_HDCP_WDT_INT			HDMI_BASE(0x07a0)
+/* HDCP RI interrupt status */
+#define HDMI_HDCP_RI_INT			HDMI_BASE(0x07b0)
+
+/* HDCP Ri Interrupt Frame number index register 0 */
+#define HDMI_HDCP_RI_COMPARE_0		HDMI_BASE(0x07d0)
+/* HDCP Ri Interrupt Frame number index register 1 */
+#define HDMI_HDCP_RI_COMPARE_1		HDMI_BASE(0x07d4)
+/* Current value of the frame count index in the hardware */
+#define HDMI_HDCP_FRAME_COUNT		HDMI_BASE(0x07e0)
+
+/* Gamut Metadata packet transmission control register */
+#define HDMI_GAMUT_CON			HDMI_BASE(0x0500)
+/* Gamut metadata packet header */
+#define HDMI_GAMUT_HEADER0			HDMI_BASE(0x0504)
+/* Gamut metadata packet header */
+#define HDMI_GAMUT_HEADER1			HDMI_BASE(0x0508)
+/* Gamut metadata packet header */
+#define HDMI_GAMUT_HEADER2			HDMI_BASE(0x050c)
+/* Gamut Metadata packet body data */
+#define HDMI_GAMUT_DATA00			HDMI_BASE(0x0510)
+/* Gamut Metadata packet body data */
+#define HDMI_GAMUT_DATA01			HDMI_BASE(0x0514)
+/* Gamut Metadata packet body data */
+#define HDMI_GAMUT_DATA02			HDMI_BASE(0x0518)
+/* Gamut Metadata packet body data */
+#define HDMI_GAMUT_DATA03			HDMI_BASE(0x051c)
+/* Gamut Metadata packet body data */
+#define HDMI_GAMUT_DATA04			HDMI_BASE(0x0520)
+/* Gamut Metadata packet body data */
+#define HDMI_GAMUT_DATA05			HDMI_BASE(0x0524)
+/* Gamut Metadata packet body data */
+#define HDMI_GAMUT_DATA06			HDMI_BASE(0x0528)
+/* Gamut Metadata packet body data */
+#define HDMI_GAMUT_DATA07			HDMI_BASE(0x052c)
+/* Gamut Metadata packet body data */
+#define HDMI_GAMUT_DATA08			HDMI_BASE(0x0530)
+/* Gamut Metadata packet body data */
+#define HDMI_GAMUT_DATA09			HDMI_BASE(0x0534)
+/* Gamut Metadata packet body data */
+#define HDMI_GAMUT_DATA10			HDMI_BASE(0x0538)
+/* Gamut Metadata packet body data */
+#define HDMI_GAMUT_DATA11			HDMI_BASE(0x053c)
+/* Gamut Metadata packet body data */
+#define HDMI_GAMUT_DATA12			HDMI_BASE(0x0540)
+/* Gamut Metadata packet body data */
+#define HDMI_GAMUT_DATA13			HDMI_BASE(0x0544)
+/* Gamut Metadata packet body data */
+#define HDMI_GAMUT_DATA14			HDMI_BASE(0x0548)
+/* Gamut Metadata packet body data */
+#define HDMI_GAMUT_DATA15			HDMI_BASE(0x054c)
+/* Gamut Metadata packet body data */
+#define HDMI_GAMUT_DATA16			HDMI_BASE(0x0550)
+/* Gamut Metadata packet body data */
+#define HDMI_GAMUT_DATA17			HDMI_BASE(0x0554)
+/* Gamut Metadata packet body data */
+#define HDMI_GAMUT_DATA18			HDMI_BASE(0x0558)
+/* Gamut Metadata packet body data */
+#define HDMI_GAMUT_DATA19			HDMI_BASE(0x055c)
+/* Gamut Metadata packet body data */
+#define HDMI_GAMUT_DATA20			HDMI_BASE(0x0560)
+/* Gamut Metadata packet body data */
+#define HDMI_GAMUT_DATA21			HDMI_BASE(0x0564)
+/* Gamut Metadata packet body data */
+#define HDMI_GAMUT_DATA22			HDMI_BASE(0x0568)
+/* Gamut Metadata packet body data */
+#define HDMI_GAMUT_DATA23			HDMI_BASE(0x056c)
+/* Gamut Metadata packet body data */
+#define HDMI_GAMUT_DATA24			HDMI_BASE(0x0570)
+/* Gamut Metadata packet body data */
+#define HDMI_GAMUT_DATA25			HDMI_BASE(0x0574)
+/* Gamut Metadata packet body data */
+#define HDMI_GAMUT_DATA26			HDMI_BASE(0x0578)
+/* Gamut Metadata packet body data */
+#define HDMI_GAMUT_DATA27			HDMI_BASE(0x057c)
+
+/* Gamut Metadata packet body data */
+#define	HDMI_DC_CONTROL			HDMI_BASE(0x05C0)
+/* Gamut Metadata packet body data */
+#define HDMI_VIDEO_PATTERN_GEN		HDMI_BASE(0x05C4)
+/* Gamut Metadata packet body data */
+#define HDMI_HPD_GEN			HDMI_BASE(0x05C8)
+
+
+/* SPDIFIN_CLK_CTRL [1:0] 0x02 */
+#define HDMI_SPDIFIN_CLK_CTRL		HDMI_SPDIF_BASE(0x0000)
+/* SPDIFIN_OP_CTRL [1:0] 0x00 */
+#define HDMI_SPDIFIN_OP_CTRL		HDMI_SPDIF_BASE(0x0004)
+/* SPDIFIN_IRQ_MASK[7:0] 0x00 */
+#define HDMI_SPDIFIN_IRQ_MASK		HDMI_SPDIF_BASE(0x0008)
+/* SPDIFIN_IRQ_STATUS [7:0] 0x00 */
+#define HDMI_SPDIFIN_IRQ_STATUS		HDMI_SPDIF_BASE(0x000C)
+/* SPDIFIN_CONFIG [7:0] 0x00 */
+#define HDMI_SPDIFIN_CONFIG_1		HDMI_SPDIF_BASE(0x0010)
+/* SPDIFIN_CONFIG [11:8] 0x00 */
+#define HDMI_SPDIFIN_CONFIG_2		HDMI_SPDIF_BASE(0x0014)
+/* SPDIFIN_USER_VALUE [7:0] 0x00 */
+#define HDMI_SPDIFIN_USER_VALUE_1		HDMI_SPDIF_BASE(0x0020)
+/* SPDIFIN_USER_VALUE [15:8] 0x00 */
+#define HDMI_SPDIFIN_USER_VALUE_2		HDMI_SPDIF_BASE(0x0024)
+/* SPDIFIN_USER_VALUE [23:16] 0x00 */
+#define HDMI_SPDIFIN_USER_VALUE_3		HDMI_SPDIF_BASE(0x0028)
+/* SPDIFIN_USER_VALUE [31:24] 0x00 */
+#define HDMI_SPDIFIN_USER_VALUE_4		HDMI_SPDIF_BASE(0x002C)
+/* SPDIFIN_CH_STATUS_0 [7:0] 0x00 */
+#define HDMI_SPDIFIN_CH_STATUS_0_1		HDMI_SPDIF_BASE(0x0030)
+/* SPDIFIN_CH_STATUS_0 [15:8] 0x00 */
+#define HDMI_SPDIFIN_CH_STATUS_0_2		HDMI_SPDIF_BASE(0x0034)
+/* SPDIFIN_CH_STATUS_0 [23:16] 0x00 */
+#define HDMI_SPDIFIN_CH_STATUS_0_3		HDMI_SPDIF_BASE(0x0038)
+/* SPDIFIN_CH_STATUS_0 [31:24] 0x00 */
+#define HDMI_SPDIFIN_CH_STATUS_0_4		HDMI_SPDIF_BASE(0x003C)
+/* SPDIFIN_CH_STATUS_1 0x00 */
+#define HDMI_SPDIFIN_CH_STATUS_1		HDMI_SPDIF_BASE(0x0040)
+/* SPDIF_FRAME_PERIOD [7:0] 0x00 */
+#define HDMI_SPDIFIN_FRAME_PERIOD_1		HDMI_SPDIF_BASE(0x0048)
+/* SPDIF_FRAME_PERIOD [15:8] 0x00 */
+#define HDMI_SPDIFIN_FRAME_PERIOD_2		HDMI_SPDIF_BASE(0x004C)
+/* SPDIFIN_Pc_INFO [7:0] 0x00 */
+#define HDMI_SPDIFIN_Pc_INFO_1		HDMI_SPDIF_BASE(0x0050)
+/* SPDIFIN_Pc_INFO [15:8] 0x00 */
+#define HDMI_SPDIFIN_Pc_INFO_2		HDMI_SPDIF_BASE(0x0054)
+/* SPDIFIN_Pd_INFO [7:0] 0x00 */
+#define HDMI_SPDIFIN_Pd_INFO_1		HDMI_SPDIF_BASE(0x0058)
+/* SPDIFIN_Pd_INFO [15:8] 0x00 */
+#define HDMI_SPDIFIN_Pd_INFO_2		HDMI_SPDIF_BASE(0x005C)
+/* SPDIFIN_DATA_BUF_0 [7:0] 0x00 */
+#define HDMI_SPDIFIN_DATA_BUF_0_1		HDMI_SPDIF_BASE(0x0060)
+/* SPDIFIN_DATA_BUF_0 [15:8] 0x00 */
+#define HDMI_SPDIFIN_DATA_BUF_0_2		HDMI_SPDIF_BASE(0x0064)
+/* SPDIFIN_DATA_BUF_0 [23:16] 0x00 */
+#define HDMI_SPDIFIN_DATA_BUF_0_3		HDMI_SPDIF_BASE(0x0068)
+/* SPDIFIN_DATA_BUF_0 [31:28] 0x00 */
+#define HDMI_SPDIFIN_USER_BUF_0		HDMI_SPDIF_BASE(0x006C)
+/* SPDIFIN_DATA_BUF_1 [7:0] 0x00 */
+#define HDMI_SPDIFIN_DATA_BUF_1_1		HDMI_SPDIF_BASE(0x0070)
+/* SPDIFIN_DATA_BUF_1 [15:8] 0x00 */
+#define HDMI_SPDIFIN_DATA_BUF_1_2		HDMI_SPDIF_BASE(0x0074)
+/* SPDIFIN_DATA_BUF_1 [23:16] 0x00 */
+#define HDMI_SPDIFIN_DATA_BUF_1_3		HDMI_SPDIF_BASE(0x0078)
+/* SPDIFIN_DATA_BUF_1 [31:28] 0x00 */
+#define HDMI_SPDIFIN_USER_BUF_1		HDMI_SPDIF_BASE(0x007C)
+
+
+/* I2S Clock Enable Register0x00  */
+#define HDMI_I2S_CLK_CON			HDMI_I2S_BASE(0x0000)
+/* I2S Control Register 10x00  */
+#define HDMI_I2S_CON_1			HDMI_I2S_BASE(0x0004)
+/* I2S Control Register 20x00  */
+#define HDMI_I2S_CON_2			HDMI_I2S_BASE(0x0008)
+/* I2S Input Pin Selection Register 0 0x77  */
+#define HDMI_I2S_PIN_SEL_0			HDMI_I2S_BASE(0x000C)
+/* I2S Input Pin Selection Register 1 0x77  */
+#define HDMI_I2S_PIN_SEL_1			HDMI_I2S_BASE(0x0010)
+/* I2S Input Pin Selection Register 2 0x77  */
+#define HDMI_I2S_PIN_SEL_2			HDMI_I2S_BASE(0x0014)
+/* I2S Input Pin Selection Register 30x07  */
+#define HDMI_I2S_PIN_SEL_3			HDMI_I2S_BASE(0x0018)
+/* I2S DSD Control Register0x02  */
+#define HDMI_I2S_DSD_CON			HDMI_I2S_BASE(0x001C)
+/* I2S In/Mux Control Register 0x60  */
+#define HDMI_I2S_MUX_CON			HDMI_I2S_BASE(0x0020)
+/* I2S Channel Status Control Register0x00  */
+#define HDMI_I2S_CH_ST_CON			HDMI_I2S_BASE(0x0024)
+/* I2S Channel Status Block 00x00  */
+#define HDMI_I2S_CH_ST_0			HDMI_I2S_BASE(0x0028)
+/* I2S Channel Status Block 10x00  */
+#define HDMI_I2S_CH_ST_1			HDMI_I2S_BASE(0x002C)
+/* I2S Channel Status Block 20x00  */
+#define HDMI_I2S_CH_ST_2			HDMI_I2S_BASE(0x0030)
+/* I2S Channel Status Block 30x00  */
+#define HDMI_I2S_CH_ST_3			HDMI_I2S_BASE(0x0034)
+/* I2S Channel Status Block 40x00  */
+#define HDMI_I2S_CH_ST_4			HDMI_I2S_BASE(0x0038)
+/* I2S Channel Status Block Shadow Register 00x00  */
+#define HDMI_I2S_CH_ST_SH_0			HDMI_I2S_BASE(0x003C)
+/* I2S Channel Status Block Shadow Register 10x00  */
+#define HDMI_I2S_CH_ST_SH_1			HDMI_I2S_BASE(0x0040)
+/* I2S Channel Status Block Shadow Register 20x00  */
+#define HDMI_I2S_CH_ST_SH_2			HDMI_I2S_BASE(0x0044)
+/* I2S Channel Status Block Shadow Register 30x00  */
+#define HDMI_I2S_CH_ST_SH_3			HDMI_I2S_BASE(0x0048)
+/* I2S Channel Status Block Shadow Register 40x00  */
+#define HDMI_I2S_CH_ST_SH_4			HDMI_I2S_BASE(0x004C)
+/* I2S Audio Sample Validity Register0x00  */
+#define HDMI_I2S_VD_DATA			HDMI_I2S_BASE(0x0050)
+/* I2S Channel Enable Register0x03  */
+#define HDMI_I2S_MUX_CH			HDMI_I2S_BASE(0x0054)
+/* I2S CUV Enable Register0x03  */
+#define HDMI_I2S_MUX_CUV			HDMI_I2S_BASE(0x0058)
+/* I2S Interrupt Request Mask Register0x03  */
+#define HDMI_I2S_IRQ_MASK			HDMI_I2S_BASE(0x005C)
+/* I2S Interrupt Request Status Register0x00  */
+#define HDMI_I2S_IRQ_STATUS			HDMI_I2S_BASE(0x0060)
+/* I2S PCM Output Data Register0x00  */
+#define HDMI_I2S_CH0_L_0			HDMI_I2S_BASE(0x0064)
+/* I2S PCM Output Data Register0x00  */
+#define HDMI_I2S_CH0_L_1			HDMI_I2S_BASE(0x0068)
+/* I2S PCM Output Data Register0x00  */
+#define HDMI_I2S_CH0_L_2			HDMI_I2S_BASE(0x006C)
+/* I2S PCM Output Data Register0x00  */
+#define HDMI_I2S_CH0_L_3			HDMI_I2S_BASE(0x0070)
+/* I2S PCM Output Data Register0x00  */
+#define HDMI_I2S_CH0_R_0			HDMI_I2S_BASE(0x0074)
+/* I2S PCM Output Data Register0x00  */
+#define HDMI_I2S_CH0_R_1			HDMI_I2S_BASE(0x0078)
+/* I2S PCM Output Data Register0x00  */
+#define HDMI_I2S_CH0_R_2			HDMI_I2S_BASE(0x007C)
+/* I2S PCM Output Data Register0x00  */
+#define HDMI_I2S_CH0_R_3			HDMI_I2S_BASE(0x0080)
+/* I2S PCM Output Data Register0x00  */
+#define HDMI_I2S_CH1_L_0			HDMI_I2S_BASE(0x0084)
+/* I2S PCM Output Data Register0x00  */
+#define HDMI_I2S_CH1_L_1			HDMI_I2S_BASE(0x0088)
+/* I2S PCM Output Data Register0x00  */
+#define HDMI_I2S_CH1_L_2			HDMI_I2S_BASE(0x008C)
+/* I2S PCM Output Data Register0x00  */
+#define HDMI_I2S_CH1_L_3			HDMI_I2S_BASE(0x0090)
+/* I2S PCM Output Data Register0x00  */
+#define HDMI_I2S_CH1_R_0			HDMI_I2S_BASE(0x0094)
+/* I2S PCM Output Data Register0x00  */
+#define HDMI_I2S_CH1_R_1			HDMI_I2S_BASE(0x0098)
+/* I2S PCM Output Data Register0x00  */
+#define HDMI_I2S_CH1_R_2			HDMI_I2S_BASE(0x009C)
+/* I2S PCM Output Data Register0x00  */
+#define HDMI_I2S_CH1_R_3			HDMI_I2S_BASE(0x00A0)
+/* I2S PCM Output Data Register0x00  */
+#define HDMI_I2S_CH2_L_0			HDMI_I2S_BASE(0x00A4)
+/* I2S PCM Output Data Register0x00  */
+#define HDMI_I2S_CH2_L_1			HDMI_I2S_BASE(0x00A8)
+/* I2S PCM Output Data Register0x00  */
+#define HDMI_I2S_CH2_L_2			HDMI_I2S_BASE(0x00AC)
+/* I2S PCM Output Data Register0x00  */
+#define HDMI_I2S_CH2_L_3			HDMI_I2S_BASE(0x00B0)
+/* I2S PCM Output Data Register0x00  */
+#define HDMI_I2S_CH2_R_0			HDMI_I2S_BASE(0x00B4)
+/* I2S PCM Output Data Register0x00  */
+#define HDMI_I2S_CH2_R_1			HDMI_I2S_BASE(0x00B8)
+/* I2S PCM Output Data Register0x00  */
+#define HDMI_I2S_CH2_R_2			HDMI_I2S_BASE(0x00BC)
+/* I2S PCM Output Data Register0x00  */
+#define HDMI_I2S_Ch2_R_3			HDMI_I2S_BASE(0x00C0)
+/* I2S PCM Output Data Register0x00  */
+#define HDMI_I2S_CH3_L_0			HDMI_I2S_BASE(0x00C4)
+/* I2S PCM Output Data Register0x00  */
+#define HDMI_I2S_CH3_L_1			HDMI_I2S_BASE(0x00C8)
+/* I2S PCM Output Data Register0x00  */
+#define HDMI_I2S_CH3_L_2			HDMI_I2S_BASE(0x00CC)
+/* I2S PCM Output Data Register0x00  */
+#define HDMI_I2S_CH3_R_0			HDMI_I2S_BASE(0x00D0)
+/* I2S PCM Output Data Register0x00  */
+#define HDMI_I2S_CH3_R_1			HDMI_I2S_BASE(0x00D4)
+/* I2S PCM Output Data Register0x00  */
+#define HDMI_I2S_CH3_R_2			HDMI_I2S_BASE(0x00D8)
+/* I2S CUV Output Data Register0x00  */
+#define HDMI_I2S_CUV_L_R			HDMI_I2S_BASE(0x00DC)
+
+
+/* Command Register 0x00 */
+#define HDMI_TG_CMD				HDMI_TG_BASE(0x0000)
+/* Horizontal Full Size 0x72 */
+#define HDMI_TG_H_FSZ_L			HDMI_TG_BASE(0x0018)
+/* Horizontal Full Size 0x06 */
+#define HDMI_TG_H_FSZ_H			HDMI_TG_BASE(0x001C)
+/* Horizontal Active Start 0x05 */
+#define HDMI_TG_HACT_ST_L			HDMI_TG_BASE(0x0020)
+/* Horizontal Active Start 0x01 */
+#define HDMI_TG_HACT_ST_H			HDMI_TG_BASE(0x0024)
+/* Horizontal Active Size 0x00 */
+#define HDMI_TG_HACT_SZ_L			HDMI_TG_BASE(0x0028)
+/* Horizontal Active Size 0x05 */
+#define HDMI_TG_HACT_SZ_H			HDMI_TG_BASE(0x002C)
+/* Vertical Full Line Size 0xEE */
+#define HDMI_TG_V_FSZ_L			HDMI_TG_BASE(0x0030)
+/* Vertical Full Line Size 0x02 */
+#define HDMI_TG_V_FSZ_H			HDMI_TG_BASE(0x0034)
+/* Vertical Sync Position 0x01 */
+#define HDMI_TG_VSYNC_L			HDMI_TG_BASE(0x0038)
+/* Vertical Sync Position 0x00 */
+#define HDMI_TG_VSYNC_H			HDMI_TG_BASE(0x003C)
+/* Vertical Sync Position for Bottom Field 0x33 */
+#define HDMI_TG_VSYNC2_L			HDMI_TG_BASE(0x0040)
+/* Vertical Sync Position for Bottom Field 0x02 */
+#define HDMI_TG_VSYNC2_H			HDMI_TG_BASE(0x0044)
+/* Vertical Sync Active Start Position 0x1a */
+#define HDMI_TG_VACT_ST_L			HDMI_TG_BASE(0x0048)
+/* Vertical Sync Active Start Position 0x00 */
+#define HDMI_TG_VACT_ST_H			HDMI_TG_BASE(0x004C)
+/* Vertical Active Size 0xd0 */
+#define HDMI_TG_VACT_SZ_L			HDMI_TG_BASE(0x0050)
+/* Vertical Active Size 0x02 */
+#define HDMI_TG_VACT_SZ_H			HDMI_TG_BASE(0x0054)
+/* Field Change Position 0x33 */
+#define HDMI_TG_FIELD_CHG_L			HDMI_TG_BASE(0x0058)
+/* Field Change Position 0x02 */
+#define HDMI_TG_FIELD_CHG_H			HDMI_TG_BASE(0x005C)
+/* Vertical Sync Active Start Position for Bottom Field 0x48 */
+#define HDMI_TG_VACT_ST2_L			HDMI_TG_BASE(0x0060)
+/* Vertical Sync Active Start Position for Bottom Field 0x02 */
+#define HDMI_TG_VACT_ST2_H			HDMI_TG_BASE(0x0064)
+
+/* HDMI Vsync Positon for Top Field 0x01 */
+#define HDMI_TG_VSYNC_TOP_HDMI_L		HDMI_TG_BASE(0x0078)
+/* HDMI Vsync Positon for Top Field 0x00 */
+#define HDMI_TG_VSYNC_TOP_HDMI_H		HDMI_TG_BASE(0x007C)
+/* HDMI Vsync Positon for Bottom Field 0x33 */
+#define HDMI_TG_VSYNC_BOT_HDMI_L		HDMI_TG_BASE(0x0080)
+/* HDMI Vsync Positon for Bottom Field 0x02 */
+#define HDMI_TG_VSYNC_BOT_HDMI_H		HDMI_TG_BASE(0x0084)
+/* HDMI Top Field Start Position 0x01 */
+#define HDMI_TG_FIELD_TOP_HDMI_L		HDMI_TG_BASE(0x0088)
+/* HDMI Top Field Start Position 0x00 */
+#define HDMI_TG_FIELD_TOP_HDMI_H		HDMI_TG_BASE(0x008C)
+/* HDMI Bottom Field Start Position 0x33 */
+#define HDMI_TG_FIELD_BOT_HDMI_L		HDMI_TG_BASE(0x0090)
+/* HDMI Bottom Field Start Position 0x02 */
+#define HDMI_TG_FIELD_BOT_HDMI_H		HDMI_TG_BASE(0x0094)
+
+#define HDMI_EFUSE_CTRL			HDMI_EFUSE_BASE(0x0000)
+#define HDMI_EFUSE_STATUS			HDMI_EFUSE_BASE(0x0004)
+#define HDMI_EFUSE_ADDR_WIDTH		HDMI_EFUSE_BASE(0x0008)
+#define HDMI_EFUSE_SIGDEV_ASSERT		HDMI_EFUSE_BASE(0x000c)
+#define HDMI_EFUSE_SIGDEV_DEASSERT		HDMI_EFUSE_BASE(0x0010)
+#define HDMI_EFUSE_PRCHG_ASSERT		HDMI_EFUSE_BASE(0x0014)
+#define HDMI_EFUSE_PRCHG_DEASSERT		HDMI_EFUSE_BASE(0x0018)
+#define HDMI_EFUSE_FSET_ASSERT		HDMI_EFUSE_BASE(0x001c)
+#define HDMI_EFUSE_FSET_DEASSERT		HDMI_EFUSE_BASE(0x0020)
+#define HDMI_EFUSE_SENSING			HDMI_EFUSE_BASE(0x0024)
+#define HDMI_EFUSE_SCK_ASSERT		HDMI_EFUSE_BASE(0x0028)
+#define HDMI_EFUSE_SCK_DEASSERT		HDMI_EFUSE_BASE(0x002c)
+#define HDMI_EFUSE_SDOUT_OFFSET		HDMI_EFUSE_BASE(0x0030)
+#define HDMI_EFUSE_READ_OFFSET		HDMI_EFUSE_BASE(0x0034)
+
+#define HDMI_AUI_SZ				5
+#define HDMI_GCP_SZ				3
+#define HDMI_SPD_SZ				28
+#define HDMI_AVI_SZ				13
+#define HDMI_MPG_SZ				5
+#define HDMI_GMU_SX				28
+#define HDMI_ISRC_SZ			16
+#define HDMI_ACP_SZ				17
+
+/*
+ * Bit definition part
+ */
+
+/* Control Register */
+
+/* INTC_CON */
+#define HDMI_INTC_ACT_HI			(1 << 7)
+#define HDMI_INTC_ACT_LOW			(0 << 7)
+#define HDMI_INTC_EN_GLOBAL			(1 << 6)
+#define HDMI_INTC_DIS_GLOBAL		(0 << 6)
+#define HDMI_INTC_EN_I2S			(1 << 5)
+#define HDMI_INTC_DIS_I2S			(0 << 5)
+#define HDMI_INTC_EN_CEC			(1 << 4)
+#define HDMI_INTC_DIS_CEC			(0 << 4)
+#define HDMI_INTC_EN_HPD_PLUG		(1 << 3)
+#define HDMI_INTC_DIS_HPD_PLUG		(0 << 3)
+#define HDMI_INTC_EN_HPD_UNPLUG		(1 << 2)
+#define HDMI_INTC_DIS_HPD_UNPLUG		(0 << 2)
+#define HDMI_INTC_EN_SPDIF			(1 << 1)
+#define HDMI_INTC_DIS_SPDIF			(0 << 1)
+#define HDMI_INTC_EN_HDCP			(1 << 0)
+#define HDMI_INTC_DIS_HDCP			(0 << 0)
+
+/* INTC_FLAG */
+#define HDMI_INTC_FLAG_I2S			(1 << 5)
+#define HDMI_INTC_FLAG_CEC			(1 << 4)
+#define HDMI_INTC_FLAG_HPD_PLUG		(1 << 3)
+#define HDMI_INTC_FLAG_HPD_UNPLUG		(1 << 2)
+#define HDMI_INTC_FLAG_SPDIF		(1 << 1)
+#define HDMI_INTC_FLAG_HDCP			(1 << 0)
+
+/* HDCP_KEY_LOAD_DONE */
+#define HDMI_HDCP_KEY_LOAD_DONE		(1 << 0)
+
+/* HPD_STATUS */
+#define HDMI_HPD_PLUGED			(1 << 0)
+
+/* AUDIO_CLKSEL */
+#define HDMI_AUDIO_SPDIF_CLK		(1 << 0)
+#define HDMI_AUDIO_PCLK			(0 << 0)
+
+/* HDMI_PHY_RSTOUT */
+#define HDMI_PHY_SW_RSTOUT			(1 << 0)
+
+/* HDMI_PHY_VPLL */
+#define HDMI_PHY_VPLL_LOCK			(1 << 7)
+#define HDMI_PHY_VPLL_CODE_MASK		(0x7 << 0)
+
+/* HDMI_PHY_CMU */
+#define HDMI_PHY_CMU_LOCK			(1 << 7)
+#define HDMI_PHY_CMU_CODE_MASK		(0x7 << 0)
+
+/* HDMI_CORE_RSTOUT */
+#define HDMI_CORE_SW_RSTOUT			(1 << 0)
+
+
+/* Core Register */
+
+/* HDMI_CON_0 */
+#define HDMI_BLUE_SCR_EN			(1 << 5)
+#define HDMI_BLUE_SCR_DIS			(0 << 5)
+#define HDMI_ENC_OPTION			(1 << 4)
+#define HDMI_ASP_EN				(1 << 2)
+#define HDMI_ASP_DIS			(0 << 2)
+#define HDMI_PWDN_ENB_NORMAL		(1 << 1)
+#define HDMI_PWDN_ENB_PD			(0 << 1)
+#define HDMI_EN				(1 << 0)
+#define HDMI_DIS				(~(1 << 0))
+
+/* HDMI_CON_1 */
+#define HDMI_PX_LMT_CTRL_BYPASS		(0 << 5)
+#define HDMI_PX_LMT_CTRL_RGB		(1 << 5)
+#define HDMI_PX_LMT_CTRL_YPBPR		(2 << 5)
+#define HDMI_PX_LMT_CTRL_RESERVED		(3 << 5)
+/*Not support in S5PV210 */
+#define HDMI_CON_PXL_REP_RATIO_MASK		(1 << 1 | 1 << 0)
+/*Not support in S5PV210 */
+#define HDMI_DOUBLE_PIXEL_REPETITION	(0x01)
+
+/* HDMI_CON_2 */
+#define HDMI_VID_PREAMBLE_EN		(0 << 5)
+#define HDMI_VID_PREAMBLE_DIS		(1 << 5)
+#define HDMI_GUARD_BAND_EN			(0 << 1)
+#define HDMI_GUARD_BAND_DIS			(1 << 1)
+
+/* STATUS */
+#define HDMI_AUTHEN_ACK_AUTH		(1 << 7)
+#define HDMI_AUTHEN_ACK_NOT			(0 << 7)
+#define HDMI_AUD_FIFO_OVF_FULL		(1 << 6)
+#define HDMI_AUD_FIFO_OVF_NOT		(0 << 6)
+#define HDMI_UPDATE_RI_INT_OCC		(1 << 4)
+#define HDMI_UPDATE_RI_INT_NOT		(0 << 4)
+#define HDMI_UPDATE_RI_INT_CLEAR		(1 << 4)
+#define HDMI_UPDATE_PJ_INT_OCC		(1 << 3)
+#define HDMI_UPDATE_PJ_INT_NOT		(0 << 3)
+#define HDMI_UPDATE_PJ_INT_CLEAR		(1 << 3)
+#define HDMI_WRITE_INT_OCC			(1 << 2)
+#define HDMI_WRITE_INT_NOT			(0 << 2)
+#define HDMI_WRITE_INT_CLEAR		(1 << 2)
+#define HDMI_WATCHDOG_INT_OCC		(1 << 1)
+#define HDMI_WATCHDOG_INT_NOT		(0 << 1)
+#define HDMI_WATCHDOG_INT_CLEAR		(1 << 1)
+#define HDMI_WTFORACTIVERX_INT_OCC		(1)
+#define HDMI_WTFORACTIVERX_INT_NOT		(0)
+#define HDMI_WTFORACTIVERX_INT_CLEAR	(1)
+
+/* PHY_STATUS */
+#define HDMI_PHY_STATUS_READY		(1)
+
+/* STATUS_EN */
+#define HDMI_AUD_FIFO_OVF_EN		(1 << 6)
+#define HDMI_AUD_FIFO_OVF_DIS		(0 << 6)
+#define HDMI_UPDATE_RI_INT_EN		(1 << 4)
+#define HDMI_UPDATE_RI_INT_DIS		(0 << 4)
+#define HDMI_UPDATE_PJ_INT_EN		(1 << 3)
+#define HDMI_UPDATE_PJ_INT_DIS		(0 << 3)
+#define HDMI_WRITE_INT_EN			(1 << 2)
+#define HDMI_WRITE_INT_DIS			(0 << 2)
+#define HDMI_WATCHDOG_INT_EN		(1 << 1)
+#define HDMI_WATCHDOG_INT_DIS		(0 << 1)
+#define HDMI_WTFORACTIVERX_INT_EN		(1)
+#define HDMI_WTFORACTIVERX_INT_DIS		(0)
+#define HDMI_INT_EN_ALL				(HDMI_UPDATE_RI_INT_EN|\
+						HDMI_UPDATE_PJ_INT_DIS|\
+						HDMI_WRITE_INT_EN|\
+						HDMI_WATCHDOG_INT_EN|\
+						HDMI_WTFORACTIVERX_INT_EN)
+#define HDMI_INT_DIS_ALL			(~0x1F)
+
+/* HPD */
+#define HDMI_SW_HPD_PLUGGED			(1 << 1)
+#define HDMI_SW_HPD_UNPLUGGED		(0 << 1)
+#define HDMI_HPD_SEL_I_HPD			(1)
+#define HDMI_HPD_SEL_SW_HPD			(0)
+
+/* MODE_SEL */
+#define HDMI_MODE_HDMI_EN			(1 << 1)
+#define HDMI_MODE_HDMI_DIS			(0 << 1)
+#define HDMI_MODE_DVI_EN			(1)
+#define HDMI_MODE_DVI_DIS			(0)
+#define HDMI_MODE_MASK				(3)
+
+/* ENC_EN */
+#define HDMI_HDCP_ENC_ENABLE		(1)
+#define HDMI_HDCP_ENC_DISABLE		(0)
+
+
+/* Video Related Register */
+
+/* BLUESCREEN_0/1/2 */
+#define HDMI_SET_BLUESCREEN_0(x)		((x) & 0xFF)
+#define HDMI_SET_BLUESCREEN_1(x)		((x) & 0xFF)
+#define HDMI_SET_BLUESCREEN_2(x)		((x) & 0xFF)
+
+/* HDMI_YMAX/YMIN/CMAX/CMIN */
+#define HDMI_SET_YMAX(x)			((x) & 0xFF)
+#define HDMI_SET_YMIN(x)			((x) & 0xFF)
+#define HDMI_SET_CMAX(x)			((x) & 0xFF)
+#define HDMI_SET_CMIN(x)			((x) & 0xFF)
+
+/* H_BLANK_0/1 */
+#define HDMI_SET_H_BLANK_0(x)		((x) & 0xFF)
+#define HDMI_SET_H_BLANK_1(x)		(((x) >> 8) & 0x3FF)
+
+/* V_BLANK_0/1/2 */
+#define HDMI_SET_V_BLANK_0(x)		((x) & 0xFF)
+#define HDMI_SET_V_BLANK_1(x)		(((x) >> 8) & 0xFF)
+#define HDMI_SET_V_BLANK_2(x)		(((x) >> 16) & 0xFF)
+
+/* H_V_LINE_0/1/2 */
+#define HDMI_SET_H_V_LINE_0(x)		((x) & 0xFF)
+#define HDMI_SET_H_V_LINE_1(x)		(((x) >> 8) & 0xFF)
+#define HDMI_SET_H_V_LINE_2(x)		(((x) >> 16) & 0xFF)
+
+/* VSYNC_POL */
+#define HDMI_V_SYNC_POL_ACT_LOW		(1)
+#define HDMI_V_SYNC_POL_ACT_HIGH		(0)
+
+/* INT_PRO_MODE */
+#define HDMI_INTERLACE_MODE			(1)
+#define HDMI_PROGRESSIVE_MODE		(0)
+
+/* V_BLANK_F_0/1/2 */
+#define HDMI_SET_V_BLANK_F_0(x)		((x) & 0xFF)
+#define HDMI_SET_V_BLANK_F_1(x)		(((x) >> 8) & 0xFF)
+#define HDMI_SET_V_BLANK_F_2(x)		(((x) >> 16) & 0xFF)
+
+
+/* H_SYNC_GEN_0/1/2 */
+#define HDMI_SET_H_SYNC_GEN_0(x)		((x) & 0xFF)
+#define HDMI_SET_H_SYNC_GEN_1(x)		(((x) >> 8) & 0xFF)
+#define HDMI_SET_H_SYNC_GEN_2(x)		(((x) >> 16) & 0xFF)
+
+
+/* V_SYNC_GEN1_0/1/2 */
+#define HDMI_SET_V_SYNC_GEN1_0(x)		((x) & 0xFF)
+#define HDMI_SET_V_SYNC_GEN1_1(x)		(((x) >> 8) & 0xFF)
+#define HDMI_SET_V_SYNC_GEN1_2(x)		(((x) >> 16) & 0xFF)
+
+/* V_SYNC_GEN2_0/1/2 */
+#define HDMI_SET_V_SYNC_GEN2_0(x)		((x) & 0xFF)
+#define HDMI_SET_V_SYNC_GEN2_1(x)		(((x) >> 8) & 0xFF)
+#define HDMI_SET_V_SYNC_GEN2_2(x)		(((x) >> 16) & 0xFF)
+
+/* V_SYNC_GEN3_0/1/2 */
+#define HDMI_SET_V_SYNC_GEN3_0(x)		((x) & 0xFF)
+#define HDMI_SET_V_SYNC_GEN3_1(x)		(((x) >> 8) & 0xFF)
+#define HDMI_SET_V_SYNC_GEN3_2(x)		(((x) >> 16) & 0xFF)
+
+
+/* Audio Related Packet Register */
+
+/* ASP_CON */
+#define HDMI_AUD_DST_DOUBLE			(1 << 7)
+#define HDMI_AUD_NO_DST_DOUBLE		(0 << 7)
+#define HDMI_AUD_TYPE_SAMPLE		(0 << 5)
+#define HDMI_AUD_TYPE_ONE_BIT		(1 << 5)
+#define HDMI_AUD_TYPE_HBR			(2 << 5)
+#define HDMI_AUD_TYPE_DST			(3 << 5)
+#define HDMI_AUD_MODE_TWO_CH		(0 << 4)
+#define HDMI_AUD_MODE_MULTI_CH		(1 << 4)
+#define HDMI_AUD_SP_AUD3_EN			(1 << 3)
+#define HDMI_AUD_SP_AUD2_EN			(1 << 2)
+#define HDMI_AUD_SP_AUD1_EN			(1 << 1)
+#define HDMI_AUD_SP_AUD0_EN			(1 << 0)
+#define HDMI_AUD_SP_ALL_DIS			(0 << 0)
+
+#define HDMI_AUD_SET_SP_PRE(x)		((x) & 0xF)
+
+/* ASP_SP_FLAT */
+#define HDMI_ASP_SP_FLAT_AUD_SAMPLE		(0)
+
+/* ASP_CHCFG0/1/2/3 */
+#define HDMI_SPK3R_SEL_I_PCM0L		(0 << 27)
+#define HDMI_SPK3R_SEL_I_PCM0R		(1 << 27)
+#define HDMI_SPK3R_SEL_I_PCM1L		(2 << 27)
+#define HDMI_SPK3R_SEL_I_PCM1R		(3 << 27)
+#define HDMI_SPK3R_SEL_I_PCM2L		(4 << 27)
+#define HDMI_SPK3R_SEL_I_PCM2R		(5 << 27)
+#define HDMI_SPK3R_SEL_I_PCM3L		(6 << 27)
+#define HDMI_SPK3R_SEL_I_PCM3R		(7 << 27)
+#define HDMI_SPK3L_SEL_I_PCM0L		(0 << 24)
+#define HDMI_SPK3L_SEL_I_PCM0R		(1 << 24)
+#define HDMI_SPK3L_SEL_I_PCM1L		(2 << 24)
+#define HDMI_SPK3L_SEL_I_PCM1R		(3 << 24)
+#define HDMI_SPK3L_SEL_I_PCM2L		(4 << 24)
+#define HDMI_SPK3L_SEL_I_PCM2R		(5 << 24)
+#define HDMI_SPK3L_SEL_I_PCM3L		(6 << 24)
+#define HDMI_SPK3L_SEL_I_PCM3R		(7 << 24)
+#define HDMI_SPK2R_SEL_I_PCM0L		(0 << 19)
+#define HDMI_SPK2R_SEL_I_PCM0R		(1 << 19)
+#define HDMI_SPK2R_SEL_I_PCM1L		(2 << 19)
+#define HDMI_SPK2R_SEL_I_PCM1R		(3 << 19)
+#define HDMI_SPK2R_SEL_I_PCM2L		(4 << 19)
+#define HDMI_SPK2R_SEL_I_PCM2R		(5 << 19)
+#define HDMI_SPK2R_SEL_I_PCM3L		(6 << 19)
+#define HDMI_SPK2R_SEL_I_PCM3R		(7 << 19)
+#define HDMI_SPK2L_SEL_I_PCM0L		(0 << 16)
+#define HDMI_SPK2L_SEL_I_PCM0R		(1 << 16)
+#define HDMI_SPK2L_SEL_I_PCM1L		(2 << 16)
+#define HDMI_SPK2L_SEL_I_PCM1R		(3 << 16)
+#define HDMI_SPK2L_SEL_I_PCM2L		(4 << 16)
+#define HDMI_SPK2L_SEL_I_PCM2R		(5 << 16)
+#define HDMI_SPK2L_SEL_I_PCM3L		(6 << 16)
+#define HDMI_SPK2L_SEL_I_PCM3R		(7 << 16)
+#define HDMI_SPK1R_SEL_I_PCM0L		(0 << 11)
+#define HDMI_SPK1R_SEL_I_PCM0R		(1 << 11)
+#define HDMI_SPK1R_SEL_I_PCM1L		(2 << 11)
+#define HDMI_SPK1R_SEL_I_PCM1R		(3 << 11)
+#define HDMI_SPK1R_SEL_I_PCM2L		(4 << 11)
+#define HDMI_SPK1R_SEL_I_PCM2R		(5 << 11)
+#define HDMI_SPK1R_SEL_I_PCM3L		(6 << 11)
+#define HDMI_SPK1R_SEL_I_PCM3R		(7 << 11)
+#define HDMI_SPK1L_SEL_I_PCM0L		(0 << 8)
+#define HDMI_SPK1L_SEL_I_PCM0R		(1 << 8)
+#define HDMI_SPK1L_SEL_I_PCM1L		(2 << 8)
+#define HDMI_SPK1L_SEL_I_PCM1R		(3 << 8)
+#define HDMI_SPK1L_SEL_I_PCM2L		(4 << 8)
+#define HDMI_SPK1L_SEL_I_PCM2R		(5 << 8)
+#define HDMI_SPK1L_SEL_I_PCM3L		(6 << 8)
+#define HDMI_SPK1L_SEL_I_PCM3R		(7 << 8)
+#define HDMI_SPK0R_SEL_I_PCM0L		(0 << 3)
+#define HDMI_SPK0R_SEL_I_PCM0R		(1 << 3)
+#define HDMI_SPK0R_SEL_I_PCM1L		(2 << 3)
+#define HDMI_SPK0R_SEL_I_PCM1R		(3 << 3)
+#define HDMI_SPK0R_SEL_I_PCM2L		(4 << 3)
+#define HDMI_SPK0R_SEL_I_PCM2R		(5 << 3)
+#define HDMI_SPK0R_SEL_I_PCM3L		(6 << 3)
+#define HDMI_SPK0R_SEL_I_PCM3R		(7 << 3)
+#define HDMI_SPK0L_SEL_I_PCM0L		(0)
+#define HDMI_SPK0L_SEL_I_PCM0R		(1)
+#define HDMI_SPK0L_SEL_I_PCM1L		(2)
+#define HDMI_SPK0L_SEL_I_PCM1R		(3)
+#define HDMI_SPK0L_SEL_I_PCM2L		(4)
+#define HDMI_SPK0L_SEL_I_PCM2R		(5)
+#define HDMI_SPK0L_SEL_I_PCM3L		(6)
+#define HDMI_SPK0L_SEL_I_PCM3R		(7)
+
+/* ACR_CON */
+#define HDMI_ALT_CTS_RATE_CTS_1		(0 << 3)
+#define HDMI_ALT_CTS_RATE_CTS_11		(1 << 3)
+#define HDMI_ALT_CTS_RATE_CTS_21		(2 << 3)
+#define HDMI_ALT_CTS_RATE_CTS_31		(3 << 3)
+#define HDMI_ACR_TX_MODE_NO_TX		(0)
+#define HDMI_ACR_TX_MODE_TX_ONCE		(1)
+#define HDMI_ACR_TX_MODE_TXCNT_VBI		(2)
+#define HDMI_ACR_TX_MODE_TX_VPC		(3)
+#define HDMI_ACR_TX_MODE_MESURE_CTS		(4)
+
+/* ACR_MCTS0/1/2 */
+#define HDMI_SET_ACR_MCTS_0(x)		((x) & 0xFF)
+#define HDMI_SET_ACR_MCTS_1(x)		(((x) >> 8) & 0xFF)
+#define HDMI_SET_ACR_MCTS_2(x)		(((x) >> 16) & 0xFF)
+
+/* ACR_CTS0/1/2 */
+#define HDMI_SET_ACR_CTS_0(x)		((x) & 0xFF)
+#define HDMI_SET_ACR_CTS_1(x)		(((x) >> 8) & 0xFF)
+#define HDMI_SET_ACR_CTS_2(x)		(((x) >> 16) & 0xFF)
+
+/* ACR_N0/1/2 */
+#define HDMI_SET_ACR_N_0(x)			((x) & 0xFF)
+#define HDMI_SET_ACR_N_1(x)			(((x) >> 8) & 0xFF)
+#define HDMI_SET_ACR_N_2(x)			(((x) >> 16) & 0xFF)
+
+
+/* ACR_LSB2 */
+#define HDMI_ACR_LSB2_MASK			(0xFF)
+
+/* ACR_TXCNT */
+#define HDMI_ACR_TXCNT_MASK			(0x1F)
+
+/* ACR_TXINTERNAL */
+#define HDMI_ACR_TX_INTERNAL_MASK		(0xFF)
+
+/* ACR_CTS_OFFSET */
+#define HDMI_ACR_CTS_OFFSET_MASK		(0xFF)
+
+/* GCP_CON */
+#define HDMI_GCP_CON_EN_1ST_VSYNC		(1 << 3)
+#define HDMI_GCP_CON_EN_2ST_VSYNC		(1 << 2)
+#define HDMI_GCP_CON_TRANS_EVERY_VSYNC	(2)
+#define HDMI_GCP_CON_NO_TRAN		(0)
+#define HDMI_GCP_CON_TRANS_ONCE		(1)
+#define HDMI_GCP_CON_TRANS_EVERY_VSYNC	(2)
+
+/* GCP_BYTE1 */
+#define HDMI_GCP_BYTE1_MASK			(0xFF)
+
+/* GCP_BYTE2 */
+#define HDMI_GCP_BYTE2_PP_MASK		(0xF << 4)
+#define HDMI_GCP_BYTE2_CD_24BPP		(1 << 2)
+/*Not support in S5PV210 */
+#define HDMI_GCP_BYTE2_CD_30BPP		(1 << 0 | 1 << 2)
+/*Not support in S5PV210 */
+#define HDMI_GCP_BYTE2_CD_36BPP		(1 << 1 | 1 << 2)
+/*Not support in S5PV210 */
+#define HDMI_GCP_BYTE2_CD_48BPP		(1 << 0 | 1 << 1 | 1 << 2)
+
+
+/* GCP_BYTE3 */
+#define HDMI_GCP_BYTE3_MASK			(0xFF)
+
+
+/* ACP Packet Register */
+
+/* ACP_CON */
+#define HDMI_ACP_FR_RATE_MASK		(0x1F << 3)
+#define HDMI_ACP_CON_NO_TRAN		(0)
+#define HDMI_ACP_CON_TRANS_ONCE		(1)
+#define HDMI_ACP_CON_TRANS_EVERY_VSYNC	(2)
+
+/* ACP_TYPE */
+#define HDMI_ACP_TYPE_MASK			(0xFF)
+
+/* ACP_DATA00~16 */
+#define HDMI_ACP_DATA_MASK			(0xFF)
+
+
+/* ISRC1/2 Packet Register */
+
+/* ISRC_CON */
+#define HDMI_ISRC_FR_RATE_MASK		(0x1F << 3)
+#define HDMI_ISRC_EN			(1 << 2)
+#define HDMI_ISRC_DIS			(0 << 2)
+
+
+/* ISRC1_HEADER1 */
+#define HDMI_ISRC1_HEADER_MASK		(0xFF)
+
+/* ISRC1_DATA 00~15 */
+#define HDMI_ISRC1_DATA_MASK		(0xFF)
+
+/* ISRC2_DATA 00~15 */
+#define HDMI_ISRC2_DATA_MASK		(0xFF)
+
+
+/* AVI InfoFrame Register */
+
+/* AVI_CON */
+
+/* AVI_CHECK_SUM */
+#define HDMI_SET_AVI_CHECK_SUM(x)		((x) & 0xFF)
+
+/* AVI_DATA01~13 */
+#define HDMI_SET_AVI_DATA(x)		((x) & 0xFF)
+#define HDMI_AVI_PIXEL_REPETITION_DOUBLE	(1<<0)
+#define HDMI_AVI_PICTURE_ASPECT_4_3		(1<<4)
+#define HDMI_AVI_PICTURE_ASPECT_16_9	(1<<5)
+
+
+/* Audio InfoFrame Register */
+
+/* AUI_CON */
+
+/* AUI_CHECK_SUM */
+#define HDMI_SET_AUI_CHECK_SUM(x)		((x) & 0xFF)
+
+/* AUI_DATA1~5 */
+#define HDMI_SET_AUI_DATA(x)		((x) & 0xFF)
+
+
+/* MPEG Source InfoFrame registers */
+
+/* MPG_CON */
+
+/* HDMI_MPG_CHECK_SUM */
+#define HDMI_SET_MPG_CHECK_SUM(x)		((x) & 0xFF)
+
+/* MPG_DATA1~5 */
+#define HDMI_SET_MPG_DATA(x)		((x) & 0xFF)
+
+
+/* Source Product Descriptor Infoframe registers */
+
+/* SPD_CON */
+
+/* SPD_HEADER0/1/2 */
+#define HDMI_SET_SPD_HEADER(x)		((x) & 0xFF)
+
+
+/* SPD_DATA0~27 */
+#define HDMI_SET_SPD_DATA(x)		((x) & 0xFF)
+
+
+/* HDCP Register */
+
+/* HDCP_SHA1_00~19 */
+#define HDMI_SET_HDCP_SHA1(x)		((x) & 0xFF)
+
+/* HDCP_KSV_LIST_0~4 */
+
+/* HDCP_KSV_LIST_CON */
+#define HDMI_HDCP_KSV_WRITE_DONE		(0x1 << 3)
+#define HDMI_HDCP_KSV_LIST_EMPTY		(0x1 << 2)
+#define HDMI_HDCP_KSV_END			(0x1 << 1)
+#define HDMI_HDCP_KSV_READ			(0x1 << 0)
+
+/* HDCP_CTRL1 */
+#define HDMI_HDCP_EN_PJ_EN			(1 << 4)
+#define HDMI_HDCP_EN_PJ_DIS			(~(1 << 4))
+#define HDMI_HDCP_SET_REPEATER_TIMEOUT	(1 << 2)
+#define HDMI_HDCP_CLEAR_REPEATER_TIMEOUT	(~(1 << 2))
+#define HDMI_HDCP_CP_DESIRED_EN		(1 << 1)
+#define HDMI_HDCP_CP_DESIRED_DIS		(~(1 << 1))
+#define HDMI_HDCP_ENABLE_1_1_FEATURE_EN	(1)
+#define HDMI_HDCP_ENABLE_1_1_FEATURE_DIS	(~(1))
+
+/* HDCP_CHECK_RESULT */
+#define HDMI_HDCP_Pi_MATCH_RESULT_Y		((0x1 << 3) | (0x1 << 2))
+#define HDMI_HDCP_Pi_MATCH_RESULT_N		((0x1 << 3) | (0x0 << 2))
+#define HDMI_HDCP_Ri_MATCH_RESULT_Y		((0x1 << 1) | (0x1 << 0))
+#define HDMI_HDCP_Ri_MATCH_RESULT_N		((0x1 << 1) | (0x0 << 0))
+#define HDMI_HDCP_CLR_ALL_RESULTS		(0)
+
+/* HDCP_BKSV0~4 */
+/* HDCP_AKSV0~4 */
+
+/* HDCP_BCAPS */
+#define HDMI_HDCP_BCAPS_REPEATER		(1 << 6)
+#define HDMI_HDCP_BCAPS_READY		(1 << 5)
+#define HDMI_HDCP_BCAPS_FAST		(1 << 4)
+#define HDMI_HDCP_BCAPS_1_1_FEATURES	(1 << 1)
+#define HDMI_HDCP_BCAPS_FAST_REAUTH		(1)
+
+/* HDCP_BSTATUS_0/1 */
+/* HDCP_Ri_0/1 */
+/* HDCP_I2C_INT */
+/* HDCP_AN_INT */
+/* HDCP_WATCHDOG_INT */
+/* HDCP_RI_INT/1 */
+/* HDCP_Ri_Compare_0 */
+/* HDCP_Ri_Compare_1 */
+/* HDCP_Frame_Count */
+
+
+/* Gamut Metadata Packet Register */
+
+/* GAMUT_CON */
+/* GAMUT_HEADER0 */
+/* GAMUT_HEADER1 */
+/* GAMUT_HEADER2 */
+/* GAMUT_METADATA0~27 */
+
+
+/* Video Mode Register */
+
+/* VIDEO_PATTERN_GEN */
+/* HPD_GEN */
+/* HDCP_Ri_Compare_0 */
+/* HDCP_Ri_Compare_0 */
+/* HDCP_Ri_Compare_0 */
+/* HDCP_Ri_Compare_0 */
+/* HDCP_Ri_Compare_0 */
+/* HDCP_Ri_Compare_0 */
+/* HDCP_Ri_Compare_0 */
+/* HDCP_Ri_Compare_0 */
+/* HDCP_Ri_Compare_0 */
+/* HDCP_Ri_Compare_0 */
+
+
+/* SPDIF Register */
+
+/* SPDIFIN_CLK_CTRL */
+#define HDMI_SPDIFIN_READY_CLK_DOWN		(1 << 1)
+#define HDMI_SPDIFIN_CLK_ON			(1)
+
+/* SPDIFIN_OP_CTRL */
+#define HDMI_SPDIFIN_SW_RESET		(0)
+#define HDMI_SPDIFIN_STATUS_CHECK_MODE	(1)
+#define HDMI_SPDIFIN_STATUS_CHK_OP_MODE	(3)
+
+/* SPDIFIN_IRQ_MASK */
+
+/* SPDIFIN_IRQ_STATUS */
+#define HDMI_SPDIFIN_IRQ_OVERFLOW_EN			(1 << 7)
+#define HDMI_SPDIFIN_IRQ_ABNORMAL_PD_EN			(1 << 6)
+#define HDMI_SPDIFIN_IRQ_SH_NOT_DETECTED_RIGHTTIME_EN	(1 << 5)
+#define HDMI_SPDIFIN_IRQ_SH_DETECTED_EN			(1 << 4)
+#define HDMI_SPDIFIN_IRQ_SH_NOT_DETECTED_EN			(1 << 3)
+#define HDMI_SPDIFIN_IRQ_WRONG_PREAMBLE_EN			(1 << 2)
+#define HDMI_SPDIFIN_IRQ_CH_STATUS_RECOVERED_EN		(1 << 1)
+#define HDMI_SPDIFIN_IRQ_WRONG_SIG_EN			(1 << 0)
+
+/* SPDIFIN_CONFIG_1 */
+#define HDMI_SPDIFIN_CFG_FILTER_3_SAMPLE			(0 << 6)
+#define HDMI_SPDIFIN_CFG_FILTER_2_SAMPLE			(1 << 6)
+#define HDMI_SPDIFIN_CFG_LINEAR_PCM_TYPE			(0 << 5)
+#define HDMI_SPDIFIN_CFG_NO_LINEAR_PCM_TYPE			(1 << 5)
+#define HDMI_SPDIFIN_CFG_PCPD_AUTO_SET			(0 << 4)
+#define HDMI_SPDIFIN_CFG_PCPD_MANUAL_SET			(1 << 4)
+#define HDMI_SPDIFIN_CFG_WORD_LENGTH_A_SET			(0 << 3)
+#define HDMI_SPDIFIN_CFG_WORD_LENGTH_M_SET			(1 << 3)
+#define HDMI_SPDIFIN_CFG_U_V_C_P_NEGLECT			(0 << 2)
+#define HDMI_SPDIFIN_CFG_U_V_C_P_REPORT			(1 << 2)
+#define HDMI_SPDIFIN_CFG_BURST_SIZE_1			(0 << 1)
+#define HDMI_SPDIFIN_CFG_BURST_SIZE_2			(1 << 1)
+#define HDMI_SPDIFIN_CFG_DATA_ALIGN_16BIT			(0 << 0)
+#define HDMI_SPDIFIN_CFG_DATA_ALIGN_32BIT			(1 << 0)
+
+/* SPDIFIN_CONFIG_2 */
+#define HDMI_SPDIFIN_CFG2_NO_CLK_DIV			(0)
+
+/* SPDIFIN_USER_VALUE_1 */
+/* SPDIFIN_USER_VALUE_2 */
+/* SPDIFIN_USER_VALUE_3 */
+/* SPDIFIN_USER_VALUE_4 */
+/* SPDIFIN_CH_STATUS_0_1 */
+/* SPDIFIN_CH_STATUS_0_2 */
+/* SPDIFIN_CH_STATUS_0_3 */
+/* SPDIFIN_CH_STATUS_0_4 */
+/* SPDIFIN_CH_STATUS_1 */
+/* SPDIFIN_FRAME_PERIOD_1 */
+/* SPDIFIN_FRAME_PERIOD_2 */
+/* SPDIFIN_PC_INFO_1 */
+/* SPDIFIN_PC_INFO_2 */
+/* SPDIFIN_PD_INFO_1 */
+/* SPDIFIN_PD_INFO_2 */
+/* SPDIFIN_DATA_BUF_0_1 */
+/* SPDIFIN_DATA_BUF_0_2 */
+/* SPDIFIN_DATA_BUF_0_3 */
+/* SPDIFIN_USER_BUF_0 */
+/* SPDIFIN_USER_BUF_1_1 */
+/* SPDIFIN_USER_BUF_1_2 */
+/* SPDIFIN_USER_BUF_1_3 */
+/* SPDIFIN_USER_BUF_1 */
+
+
+/* I2S Register */
+
+/* I2S_CLK_CON */
+#define HDMI_I2S_CLK_DIS			(0)
+#define HDMI_I2S_CLK_EN			(1)
+
+/* I2S_CON_1 */
+#define HDMI_I2S_SCLK_FALLING_EDGE		(0 << 1)
+#define HDMI_I2S_SCLK_RISING_EDGE		(1 << 1)
+#define HDMI_I2S_L_CH_LOW_POL		(0)
+#define HDMI_I2S_L_CH_HIGH_POL		(1)
+
+/* I2S_CON_2 */
+#define HDMI_I2S_MSB_FIRST_MODE		(0 << 6)
+#define HDMI_I2S_LSB_FIRST_MODE		(1 << 6)
+#define HDMI_I2S_BIT_CH_32FS		(0 << 4)
+#define HDMI_I2S_BIT_CH_48FS		(1 << 4)
+#define HDMI_I2S_BIT_CH_RESERVED		(2 << 4)
+#define HDMI_I2S_SDATA_16BIT		(1 << 2)
+#define HDMI_I2S_SDATA_20BIT		(2 << 2)
+#define HDMI_I2S_SDATA_24BIT		(3 << 2)
+#define HDMI_I2S_BASIC_FORMAT		(0)
+#define HDMI_I2S_L_JUST_FORMAT		(2)
+#define HDMI_I2S_R_JUST_FORMAT		(3)
+#define HDMI_I2S_CON_2_CLR			(~0xFF)
+#define HDMI_I2S_SET_BIT_CH(x)		(((x) & 0x7) << 4)
+#define HDMI_I2S_SET_SDATA_BIT(x)		(((x) & 0x7) << 2)
+
+/* I2S_PIN_SEL_0 */
+#define HDMI_I2S_SEL_SCLK(x)		(((x) & 0x7) << 4)
+#define HDMI_I2S_SEL_SCLK_DEFAULT_1		(0x7 << 4)
+#define HDMI_I2S_SEL_LRCK(x)		((x) & 0x7)
+#define HDMI_I2S_SEL_LRCK_DEFAULT_0		(0x7)
+
+/* I2S_PIN_SEL_1 */
+#define HDMI_I2S_SEL_SDATA1(x)		(((x) & 0x7) << 4)
+#define HDMI_I2S_SEL_SDATA1_DEFAULT_3	(0x7 << 4)
+#define HDMI_I2S_SEL_SDATA2(x)		((x) & 0x7)
+#define HDMI_I2S_SEL_SDATA2_DEFAULT_2	(0x7)
+
+/* I2S_PIN_SEL_2 */
+#define HDMI_I2S_SEL_SDATA3(x)		(((x) & 0x7) << 4)
+#define HDMI_I2S_SEL_SDATA3_DEFAULT_5	(0x7 << 4)
+#define HDMI_I2S_SEL_SDATA2(x)		((x) & 0x7)
+#define HDMI_I2S_SEL_SDATA2_DEFAULT_4	(0x7)
+
+/* I2S_PIN_SEL_3 */
+#define HDMI_I2S_SEL_DSD(x)			((x) & 0x7)
+#define HDMI_I2S_SEL_DSD_DEFAULT_6		(0x7)
+
+/* I2S_DSD_CON */
+#define HDMI_I2S_DSD_CLK_RI_EDGE		(1 << 1)
+#define HDMI_I2S_DSD_CLK_FA_EDGE		(0 << 1)
+#define HDMI_I2S_DSD_ENABLE			(1)
+#define HDMI_I2S_DSD_DISABLE		(0)
+
+/* I2S_MUX_CON */
+#define HDMI_I2S_NOISE_FILTER_ZERO		(0 << 5)
+#define HDMI_I2S_NOISE_FILTER_2_STAGE	(1 << 5)
+#define HDMI_I2S_NOISE_FILTER_3_STAGE	(2 << 5)
+#define HDMI_I2S_NOISE_FILTER_4_STAGE	(3 << 5)
+#define HDMI_I2S_NOISE_FILTER_5_STAGE	(4 << 5)
+#define HDMI_I2S_IN_DISABLE			(1 << 4)
+#define HDMI_I2S_IN_ENABLE			(0 << 4)
+#define HDMI_I2S_AUD_SPDIF			(0 << 2)
+#define HDMI_I2S_AUD_I2S			(1 << 2)
+#define HDMI_I2S_AUD_DSD			(2 << 2)
+#define HDMI_I2S_CUV_SPDIF_ENABLE		(0 << 1)
+#define HDMI_I2S_CUV_I2S_ENABLE		(1 << 1)
+#define HDMI_I2S_MUX_DISABLE		(0)
+#define HDMI_I2S_MUX_ENABLE			(1)
+#define HDMI_I2S_MUX_CON_CLR		(~0xFF)
+
+/* I2S_CH_ST_CON */
+#define HDMI_I2S_CH_STATUS_RELOAD		(1)
+#define HDMI_I2S_CH_ST_CON_CLR		(~1)
+
+/* I2S_CH_ST_0 / I2S_CH_ST_SH_0 */
+#define HDMI_I2S_CH_STATUS_MODE_0		(0 << 6)
+#define HDMI_I2S_2AUD_CH_WITHOUT_PREEMPH	(0 << 3)
+#define HDMI_I2S_2AUD_CH_WITH_PREEMPH	(1 << 3)
+#define HDMI_I2S_DEFAULT_EMPHASIS		(0 << 3)
+#define HDMI_I2S_COPYRIGHT			(0 << 2)
+#define HDMI_I2S_NO_COPYRIGHT		(1 << 2)
+#define HDMI_I2S_LINEAR_PCM			(0 << 1)
+#define HDMI_I2S_NO_LINEAR_PCM		(1 << 1)
+#define HDMI_I2S_CONSUMER_FORMAT		(0)
+#define HDMI_I2S_PROF_FORMAT		(1)
+#define HDMI_I2S_CH_ST_0_CLR		(~0xFF)
+
+/* I2S_CH_ST_1 / I2S_CH_ST_SH_1 */
+#define HDMI_I2S_CD_PLAYER			(0x00)
+#define HDMI_I2S_DAT_PLAYER			(0x03)
+#define HDMI_I2S_DCC_PLAYER			(0x43)
+#define HDMI_I2S_MINI_DISC_PLAYER		(0x49)
+
+/* I2S_CH_ST_2 / I2S_CH_ST_SH_2 */
+#define HDMI_I2S_CHANNEL_NUM_MASK		(0xF << 4)
+#define HDMI_I2S_SOURCE_NUM_MASK		(0xF)
+#define HDMI_I2S_SET_CHANNEL_NUM(x)		((x) & (0xF) << 4)
+#define HDMI_I2S_SET_SOURCE_NUM(x)		((x) & (0xF))
+
+/* I2S_CH_ST_3 / I2S_CH_ST_SH_3 */
+#define HDMI_I2S_CLK_ACCUR_LEVEL_1		(1 << 4)
+#define HDMI_I2S_CLK_ACCUR_LEVEL_2		(0 << 4)
+#define HDMI_I2S_CLK_ACCUR_LEVEL_3		(2 << 4)
+#define HDMI_I2S_SAMPLING_FREQ_44_1		(0x0)
+#define HDMI_I2S_SAMPLING_FREQ_48		(0x2)
+#define HDMI_I2S_SAMPLING_FREQ_32		(0x3)
+#define HDMI_I2S_SAMPLING_FREQ_96		(0xA)
+#define HDMI_I2S_SET_SAMPLING_FREQ(x)	((x) & (0xF))
+
+/* I2S_CH_ST_4 / I2S_CH_ST_SH_4 */
+#define HDMI_I2S_ORG_SAMPLING_FREQ_44_1	(0xF << 4)
+#define HDMI_I2S_ORG_SAMPLING_FREQ_88_2	(0x7 << 4)
+#define HDMI_I2S_ORG_SAMPLING_FREQ_22_05	(0xB << 4)
+#define HDMI_I2S_ORG_SAMPLING_FREQ_176_4	(0x3 << 4)
+#define HDMI_I2S_WORD_LENGTH_NOT_DEFINE	(0x0 << 1)
+#define HDMI_I2S_WORD_LENGTH_MAX24_20BITS	(0x1 << 1)
+#define HDMI_I2S_WORD_LENGTH_MAX24_22BITS	(0x2 << 1)
+#define HDMI_I2S_WORD_LENGTH_MAX24_23BITS	(0x4 << 1)
+#define HDMI_I2S_WORD_LENGTH_MAX24_24BITS	(0x5 << 1)
+#define HDMI_I2S_WORD_LENGTH_MAX24_21BITS	(0x6 << 1)
+#define HDMI_I2S_WORD_LENGTH_MAX20_16BITS	(0x1 << 1)
+#define HDMI_I2S_WORD_LENGTH_MAX20_18BITS	(0x2 << 1)
+#define HDMI_I2S_WORD_LENGTH_MAX20_19BITS	(0x4 << 1)
+#define HDMI_I2S_WORD_LENGTH_MAX20_20BITS	(0x5 << 1)
+#define HDMI_I2S_WORD_LENGTH_MAX20_17BITS	(0x6 << 1)
+#define HDMI_I2S_WORD_LENGTH_MAX_24BITS	(1)
+#define HDMI_I2S_WORD_LENGTH_MAX_20BITS	(0)
+
+/* I2S_VD_DATA */
+#define HDMI_I2S_VD_AUD_SAMPLE_RELIABLE	(0)
+#define HDMI_I2S_VD_AUD_SAMPLE_UNRELIABLE	(1)
+
+/* I2S_MUX_CH */
+#define HDMI_I2S_CH3_R_EN			(1 << 7)
+#define HDMI_I2S_CH3_L_EN			(1 << 6)
+#define HDMI_I2S_CH3_EN			(3 << 6)
+#define HDMI_I2S_CH2_R_EN			(1 << 5)
+#define HDMI_I2S_CH2_L_EN			(1 << 4)
+#define HDMI_I2S_CH2_EN			(3 << 4)
+#define HDMI_I2S_CH1_R_EN			(1 << 3)
+#define HDMI_I2S_CH1_L_EN			(1 << 2)
+#define HDMI_I2S_CH1_EN			(3 << 2)
+#define HDMI_I2S_CH0_R_EN			(1 << 1)
+#define HDMI_I2S_CH0_L_EN			(1)
+#define HDMI_I2S_CH0_EN			(3)
+#define HDMI_I2S_CH_ALL_EN			(0xFF)
+#define HDMI_I2S_MUX_CH_CLR			(~HDMI_I2S_CH_ALL_EN)
+
+/* I2S_MUX_CUV */
+#define HDMI_I2S_CUV_R_EN			(1 << 1)
+#define HDMI_I2S_CUV_L_EN			(1)
+#define HDMI_I2S_CUV_RL_EN			(0x03)
+
+/* I2S_IRQ_MASK */
+#define HDMI_I2S_INT2_DIS			(0 << 1)
+#define HDMI_I2S_INT2_EN			(1 << 1)
+
+/* I2S_IRQ_STATUS */
+#define HDMI_I2S_INT2_STATUS		(1 << 1)
+
+/* I2S_CH0_L_0 */
+/* I2S_CH0_L_1 */
+/* I2S_CH0_L_2 */
+/* I2S_CH0_L_3 */
+/* I2S_CH0_R_0 */
+/* I2S_CH0_R_1 */
+/* I2S_CH0_R_2 */
+/* I2S_CH0_R_3 */
+/* I2S_CH1_L_0 */
+/* I2S_CH1_L_1 */
+/* I2S_CH1_L_2 */
+/* I2S_CH1_L_3 */
+/* I2S_CH1_R_0 */
+/* I2S_CH1_R_1 */
+/* I2S_CH1_R_2 */
+/* I2S_CH1_R_3 */
+/* I2S_CH2_L_0 */
+/* I2S_CH2_L_1 */
+/* I2S_CH2_L_2 */
+/* I2S_CH2_L_3 */
+/* I2S_CH2_R_0 */
+/* I2S_CH2_R_1 */
+/* I2S_CH2_R_2 */
+/* I2S_Ch2_R_3 */
+/* I2S_CH3_L_0 */
+/* I2S_CH3_L_1 */
+/* I2S_CH3_L_2 */
+/* I2S_CH3_R_0 */
+/* I2S_CH3_R_1 */
+/* I2S_CH3_R_2 */
+
+/* I2S_CUV_L_R */
+#define HDMI_I2S_CUV_R_DATA_MASK		(0x7 << 4)
+#define HDMI_I2S_CUV_L_DATA_MASK		(0x7)
+
+
+/* Timing Generator Register */
+/* TG_CMD */
+#define HDMI_GETSYNC_TYPE_EN		(1 << 4)
+#define HDMI_GETSYNC_TYPE_DIS		(~HDMI_GETSYNC_TYPE_EN)
+#define HDMI_GETSYNC_EN			(1 << 3)
+#define HDMI_GETSYNC_DIS			(~HDMI_GETSYNC_EN)
+#define HDMI_FIELD_EN			(1 << 1)
+#define HDMI_FIELD_DIS			(~HDMI_FIELD_EN)
+#define HDMI_TG_EN				(1)
+#define HDMI_TG_DIS				(~HDMI_TG_EN)
+
+/* TG_CFG */
+/* TG_CB_SZ */
+/* TG_INDELAY_L */
+/* TG_INDELAY_H */
+/* TG_POL_CTRL */
+
+/* TG_H_FSZ_L */
+#define HDMI_SET_TG_H_FSZ_L(x)		((x) & 0xFF)
+
+/* TG_H_FSZ_H */
+#define HDMI_SET_TG_H_FSZ_H(x)		(((x) >> 8) & 0x1F)
+
+/* TG_HACT_ST_L */
+#define HDMI_SET_TG_HACT_ST_L(x)		((x) & 0xFF)
+
+/* TG_HACT_ST_H */
+#define HDMI_SET_TG_HACT_ST_H(x)		(((x) >> 8) & 0xF)
+
+/* TG_HACT_SZ_L */
+#define HDMI_SET_TG_HACT_SZ_L(x)		((x) & 0xFF)
+
+/* TG_HACT_SZ_H */
+#define HDMI_SET_TG_HACT_SZ_H(x)		(((x) >> 8) & 0xF)
+
+/* TG_V_FSZ_L */
+#define HDMI_SET_TG_V_FSZ_L(x)		((x) & 0xFF)
+
+/* TG_V_FSZ_H */
+#define HDMI_SET_TG_V_FSZ_H(x)		(((x) >> 8) & 0x7)
+
+/* TG_VSYNC_L */
+#define HDMI_SET_TG_VSYNC_L(x)		((x) & 0xFF)
+
+/* TG_VSYNC_H */
+#define HDMI_SET_TG_VSYNC_H(x)		(((x) >> 8) & 0x7)
+
+/* TG_VSYNC2_L */
+#define HDMI_SET_TG_VSYNC2_L(x)		((x) & 0xFF)
+
+/* TG_VSYNC2_H */
+#define HDMI_SET_TG_VSYNC2_H(x)		(((x) >> 8) & 0x7)
+
+/* TG_VACT_ST_L */
+#define HDMI_SET_TG_VACT_ST_L(x)		((x) & 0xFF)
+
+/* TG_VACT_ST_H */
+#define HDMI_SET_TG_VACT_ST_H(x)		(((x) >> 8) & 0x7)
+
+/* TG_VACT_SZ_L */
+#define HDMI_SET_TG_VACT_SZ_L(x)		((x) & 0xFF)
+
+/* TG_VACT_SZ_H */
+#define HDMI_SET_TG_VACT_SZ_H(x)		(((x) >> 8) & 0x7)
+
+/* TG_FIELD_CHG_L */
+#define HDMI_SET_TG_FIELD_CHG_L(x)		((x) & 0xFF)
+
+/* TG_FIELD_CHG_H */
+#define HDMI_SET_TG_FIELD_CHG_H(x)		(((x) >> 8) & 0x7)
+
+/* TG_VACT_ST2_L */
+#define HDMI_SET_TG_VACT_ST2_L(x)		((x) & 0xFF)
+
+/* TG_VACT_ST2_H */
+#define HDMI_SET_TG_VACT_ST2_H(x)		(((x) >> 8) & 0x7)
+
+/* TG_VACT_SC_ST_L */
+/* TG_VACT_SC_ST_H */
+/* TG_VACT_SC_SZ_L */
+/* TG_VACT_SC_SZ_H */
+
+/* TG_VSYNC_TOP_HDMI_L */
+#define HDMI_SET_TG_VSYNC_TOP_HDMI_L(x)	((x) & 0xFF)
+
+/* TG_VSYNC_TOP_HDMI_H */
+#define HDMI_SET_TG_VSYNC_TOP_HDMI_H(x)	(((x) >> 8) & 0x7)
+
+/* TG_VSYNC_BOT_HDMI_L */
+#define HDMI_SET_TG_VSYNC_BOT_HDMI_L(x)	((x) & 0xFF)
+
+/* TG_VSYNC_BOT_HDMI_H */
+#define HDMI_SET_TG_VSYNC_BOT_HDMI_H(x)	(((x) >> 8) & 0x7)
+
+/* TG_FIELD_TOP_HDMI_L */
+#define HDMI_SET_TG_FIELD_TOP_HDMI_L(x)	((x) & 0xFF)
+
+/* TG_FIELD_TOP_HDMI_H */
+#define HDMI_SET_TG_FIELD_TOP_HDMI_H(x)	(((x) >> 8) & 0x7)
+
+/* TG_FIELD_BOT_HDMI_L */
+#define HDMI_SET_TG_FIELD_BOT_HDMI_L(x)	((x) & 0xFF)
+
+/* TG_FIELD_BOT_HDMI_H */
+#define HDMI_SET_TG_FIELD_BOT_HDMI_H(x)	(((x) >> 8) & 0x7)
+
+/* TG_HSYNC_HDOUT_ST_L */
+/* TG_HSYNC_HDOUT_ST_H */
+/* TG_HSYNC_HDOUT_END_L */
+/* TG_HSYNC_HDOUT_END_H */
+/* TG_VSYNC_HDOUT_ST_L */
+/* TG_VSYNC_HDOUT_ST_H */
+/* TG_VSYNC_HDOUT_END_L */
+/* TG_VSYNC_HDOUT_END_H */
+/* TG_VSYNC_HDOUT_DLY_L */
+/* TG_VSYNC_HDOUT_DLY_H */
+/* TG_BT_ERR_RANGE */
+/* TG_BT_ERR_RESULT */
+/* TG_COR_THR */
+/* TG_COR_NUM */
+/* TG_BT_CON */
+/* TG_BT_H_FSZ_L */
+/* TG_BT_H_FSZ_H */
+/* TG_BT_HSYNC_ST */
+/* TG_BT_HSYNC_SZ */
+/* TG_BT_FSZ_L */
+/* TG_BT_FSZ_H */
+/* TG_BT_VACT_T_ST_L */
+/* TG_BT_VACT_T_ST_H */
+/* TG_BT_VACT_B_ST_L */
+/* TG_BT_VACT_B_ST_H */
+/* TG_BT_VACT_SZ_L */
+/* TG_BT_VACT_SZ_H */
+/* TG_BT_VSYNC_SZ */
+
+
+/* HDCP E-FUSE Control Register */
+/* HDCP_E_FUSE_CTRL */
+#define HDMI_EFUSE_CTRL_HDCP_KEY_READ	(1)
+
+/* HDCP_E_FUSE_STATUS */
+#define HDMI_EFUSE_ECC_FAIL			(1 << 2)
+#define HDMI_EFUSE_ECC_BUSY			(1 << 1)
+#define HDMI_EFUSE_ECC_DONE			(1)
+
+/* EFUSE_ADDR_WIDTH */
+/* EFUSE_SIGDEV_ASSERT */
+/* EFUSE_SIGDEV_DE-ASSERT */
+/* EFUSE_PRCHG_ASSERT */
+/* EFUSE_PRCHG_DE-ASSERT */
+/* EFUSE_FSET_ASSERT */
+/* EFUSE_FSET_DE-ASSERT */
+/* EFUSE_SENSING */
+/* EFUSE_SCK_ASSERT */
+/* EFUSE_SCK_DEASSERT */
+/* EFUSE_SDOUT_OFFSET */
+/* EFUSE_READ_OFFSET */
+
+/* HDCP_SHA_RESULT, Not support in s5pv210 */
+/* Not support in s5pv210 */
+#define HDMI_HDCP_SHA_VALID_NO_RD		(0 << 1)
+/* Not support in s5pv210 */
+#define HDMI_HDCP_SHA_VALID_RD		(1 << 1)
+/* Not support in s5pv210 */
+#define HDMI_HDCP_SHA_VALID			(1)
+/* Not support in s5pv210 */
+#define HDMI_HDCP_SHA_NO_VALID		(0)
+
+/* DC_CONTRAL */
+/*Not support in S5PV210 */
+#define HDMI_DC_CTL_12			(1 << 1)
+/*Not support in S5PV210 */
+#define HDMI_DC_CTL_8			(0)
+/*Not support in S5PV210 */
+#define HDMI_DC_CTL_10			(1)
+#endif /* __ASM_ARCH_REGS_HDMI_H */
diff --git a/drivers/media/video/s5p-tv/regs-sdo.h b/drivers/media/video/s5p-tv/regs-sdo.h
new file mode 100644
index 0000000..6b135b5
--- /dev/null
+++ b/drivers/media/video/s5p-tv/regs-sdo.h
@@ -0,0 +1,453 @@
+/* drivers/media/video/s5p-tv/regs-sdo.h
+ *
+ * Copyright (c) 2011 Samsung Electronics
+ *		http://www.samsung.com/
+ *
+ * SDO register description file
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef __ARCH_ARM_REGS_SDO_H
+#define __ARCH_ARM_REGS_SDO_H
+
+/*
+ * Register part
+ */
+#define SDO_CLKCON			(0x0000)
+#define SDO_CONFIG			(0x0008)
+#define SDO_SCALE			(0x000C)
+#define SDO_SYNC			(0x0010)
+#define SDO_VBI				(0x0014)
+#define SDO_SCALE_CH0			(0x001C)
+#define SDO_SCALE_CH1			(0x0020)
+#define SDO_SCALE_CH2			(0x0024)
+#define SDO_YCDELAY			(0x0034)
+#define SDO_SCHLOCK			(0x0038)
+#define SDO_DAC				(0x003C)
+#define SDO_FINFO			(0x0040)
+#define SDO_Y0				(0x0044)
+#define SDO_Y1				(0x0048)
+#define SDO_Y2				(0x004C)
+#define SDO_Y3				(0x0050)
+#define SDO_Y4				(0x0054)
+#define SDO_Y5				(0x0058)
+#define SDO_Y6				(0x005C)
+#define SDO_Y7				(0x0060)
+#define SDO_Y8				(0x0064)
+#define SDO_Y9				(0x0068)
+#define SDO_Y10				(0x006C)
+#define SDO_Y11				(0x0070)
+#define SDO_CB0				(0x0080)
+#define SDO_CB1				(0x0084)
+#define SDO_CB2				(0x0088)
+#define SDO_CB3				(0x008C)
+#define SDO_CB4				(0x0090)
+#define SDO_CB5				(0x0094)
+#define SDO_CB6				(0x0098)
+#define SDO_CB7				(0x009C)
+#define SDO_CB8				(0x00A0)
+#define SDO_CB9				(0x00A4)
+#define SDO_CB10			(0x00A8)
+#define SDO_CB11			(0x00AC)
+#define SDO_CR0				(0x00C0)
+#define SDO_CR1				(0x00C4)
+#define SDO_CR2				(0x00C8)
+#define SDO_CR3				(0x00CC)
+#define SDO_CR4				(0x00D0)
+#define SDO_CR5				(0x00D4)
+#define SDO_CR6				(0x00D8)
+#define SDO_CR7				(0x00DC)
+#define SDO_CR8				(0x00E0)
+#define SDO_CR9				(0x00E4)
+#define SDO_CR10			(0x00E8)
+#define SDO_CR11			(0x00EC)
+#define SDO_MV_ON			(0x0100)
+#define SDO_MV_SLINE_FIRST_EVEN		(0x0104)
+#define SDO_MV_SLINE_FIRST_SPACE_EVEN	(0x0108)
+#define SDO_MV_SLINE_FIRST_ODD		(0x010C)
+#define SDO_MV_SLINE_FIRST_SPACE_ODD	(0x0110)
+#define SDO_MV_SLINE_SPACING		(0x0114)
+#define SDO_MV_STRIPES_NUMBER		(0x0118)
+#define SDO_MV_STRIPES_THICKNESS	(0x011C)
+#define SDO_MV_PSP_DURATION		(0x0120)
+#define SDO_MV_PSP_FIRST		(0x0124)
+#define SDO_MV_PSP_SPACING		(0x0128)
+#define SDO_MV_SEL_LINE_PSP_AGC		(0x012C)
+#define SDO_MV_SEL_FORMAT_PSP_AGC	(0x0130)
+#define SDO_MV_PSP_AGC_A_ON		(0x0134)
+#define SDO_MV_PSP_AGC_B_ON		(0x0138)
+#define SDO_MV_BACK_PORCH		(0x013C)
+#define SDO_MV_BURST_ADVANCED_ON	(0x0140)
+#define SDO_MV_BURST_DURATION_ZONE1	(0x0144)
+#define SDO_MV_BURST_DURATION_ZONE2	(0x0148)
+#define SDO_MV_BURST_DURATION_ZONE3	(0x014C)
+#define SDO_MV_BURST_PHASE_ZONE		(0x0150)
+#define SDO_MV_SLICE_PHASE_LINE		(0x0154)
+#define SDO_MV_RGB_PROTECTION_ON	(0x0158)
+#define SDO_MV_480P_PROTECTION_ON	(0x015C)
+#define SDO_CCCON			(0x0180)
+#define SDO_YSCALE			(0x0184)
+#define SDO_CBSCALE			(0x0188)
+#define SDO_CRSCALE			(0x018C)
+#define SDO_CB_CR_OFFSET		(0x0190)
+#define SDO_CVBS_CC_Y1			(0x0198)
+#define SDO_CVBS_CC_Y2			(0x019C)
+#define SDO_CVBS_CC_C			(0x01A0)
+#define SDO_CSC_525_PORCH		(0x01B0)
+#define SDO_CSC_625_PORCH		(0x01B4)
+#define SDO_OSFC00_0			(0x0200)
+#define SDO_OSFC01_0			(0x0204)
+#define SDO_OSFC02_0			(0x0208)
+#define SDO_OSFC03_0			(0x020C)
+#define SDO_OSFC04_0			(0x0210)
+#define SDO_OSFC05_0			(0x0214)
+#define SDO_OSFC06_0			(0x0218)
+#define SDO_OSFC07_0			(0x021C)
+#define SDO_OSFC08_0			(0x0220)
+#define SDO_OSFC09_0			(0x0224)
+#define SDO_OSFC10_0			(0x0228)
+#define SDO_OSFC11_0			(0x022C)
+#define SDO_OSFC12_0			(0x0230)
+#define SDO_OSFC13_0			(0x0234)
+#define SDO_OSFC14_0			(0x0238)
+#define SDO_OSFC15_0			(0x023C)
+#define SDO_OSFC16_0			(0x0240)
+#define SDO_OSFC17_0			(0x0244)
+#define SDO_OSFC18_0			(0x0248)
+#define SDO_OSFC19_0			(0x024C)
+#define SDO_OSFC20_0			(0x0250)
+#define SDO_OSFC21_0			(0x0254)
+#define SDO_OSFC22_0			(0x0258)
+#define SDO_OSFC23_0			(0x025C)
+#define SDO_XTALK0			(0x0260)
+#define SDO_XTALK1			(0x0264)
+#define SDO_XTALK2			(0x0268)
+#define SDO_BB_CTRL			(0x026C)
+#define SDO_IRQ				(0x0280)
+#define SDO_IRQMASK			(0x0284)
+#define SDO_OSFC00_1			(0x02C0)
+#define SDO_OSFC01_1			(0x02C4)
+#define SDO_OSFC02_1			(0x02C8)
+#define SDO_OSFC03_1			(0x02CC)
+#define SDO_OSFC04_1			(0x02D0)
+#define SDO_OSFC05_1			(0x02D4)
+#define SDO_OSFC06_1			(0x02D8)
+#define SDO_OSFC07_1			(0x02DC)
+#define SDO_OSFC08_1			(0x02E0)
+#define SDO_OSFC09_1			(0x02E4)
+#define SDO_OSFC10_1			(0x02E8)
+#define SDO_OSFC11_1			(0x02EC)
+#define SDO_OSFC12_1			(0x02E0)
+#define SDO_OSFC13_1			(0x02F4)
+#define SDO_OSFC14_1			(0x02F8)
+#define SDO_OSFC15_1			(0x02FC)
+#define SDO_OSFC16_1			(0x0300)
+#define SDO_OSFC17_1			(0x0304)
+#define SDO_OSFC18_1			(0x0308)
+#define SDO_OSFC19_1			(0x030C)
+#define SDO_OSFC20_1			(0x0310)
+#define SDO_OSFC21_1			(0x0314)
+#define SDO_OSFC22_1			(0x0318)
+#define SDO_OSFC23_1			(0x031C)
+#define SDO_OSFC00_2			(0x0320)
+#define SDO_OSFC01_2			(0x0324)
+#define SDO_OSFC02_2			(0x0328)
+#define SDO_OSFC03_2			(0x032C)
+#define SDO_OSFC04_2			(0x0330)
+#define SDO_OSFC05_2			(0x0334)
+#define SDO_OSFC06_2			(0x0338)
+#define SDO_OSFC07_2			(0x033C)
+#define SDO_OSFC08_2			(0x0340)
+#define SDO_OSFC09_2			(0x0344)
+#define SDO_OSFC10_2			(0x0348)
+#define SDO_OSFC11_2			(0x034C)
+#define SDO_OSFC12_2			(0x0350)
+#define SDO_OSFC13_2			(0x0354)
+#define SDO_OSFC14_2			(0x0358)
+#define SDO_OSFC15_2			(0x035C)
+#define SDO_OSFC16_2			(0x0360)
+#define SDO_OSFC17_2			(0x0364)
+#define SDO_OSFC18_2			(0x0368)
+#define SDO_OSFC19_2			(0x036C)
+#define SDO_OSFC20_2			(0x0370)
+#define SDO_OSFC21_2			(0x0374)
+#define SDO_OSFC22_2			(0x0378)
+#define SDO_OSFC23_2			(0x037C)
+#define SDO_ARMCC			(0x03C0)
+#define SDO_ARMWSS525			(0x03C4)
+#define SDO_ARMWSS625			(0x03C8)
+#define SDO_ARMCGMS525			(0x03CC)
+#define SDO_ARMCGMS625			(0x03D4)
+#define SDO_VERSION			(0x03D8)
+#define SDO_CC				(0x0380)
+#define SDO_WSS525			(0x0384)
+#define SDO_WSS625			(0x0388)
+#define SDO_CGMS525			(0x038C)
+#define SDO_CGMS625			(0x0394)
+
+
+/*
+ * Bit definition part
+*/
+/* SDO Clock Control Register (SDO_CLKCON) */
+#define SDO_TVOUT_SW_RESET		(1 << 4)
+#define SDO_TVOUT_CLOCK_READY		(1 << 1)
+#define SDO_TVOUT_CLOCK_ON		(1)
+#define SDO_TVOUT_CLOCK_OFF		(0)
+
+/* SDO Video Standard Configuration Register (SDO_CONFIG) */
+#define SDO_DAC2_Y_G			(0 << 20)
+#define SDO_DAC2_PB_B			(1 << 20)
+#define SDO_DAC2_PR_R			(2 << 20)
+#define SDO_DAC1_Y_G			(0 << 18)
+#define SDO_DAC1_PB_B			(1 << 18)
+#define SDO_DAC1_PR_R			(2 << 18)
+#define SDO_DAC0_Y_G			(0 << 16)
+#define SDO_DAC0_PB_B			(1 << 16)
+#define SDO_DAC0_PR_R			(2 << 16)
+#define SDO_DAC2_CVBS			(0 << 12)
+#define SDO_DAC2_Y			(1 << 12)
+#define SDO_DAC2_C			(2 << 12)
+#define SDO_DAC1_CVBS			(0 << 10)
+#define SDO_DAC1_Y			(1 << 10)
+#define SDO_DAC1_C			(2 << 10)
+#define SDO_DAC0_CVBS			(0 << 8)
+#define SDO_DAC0_Y			(1 << 8)
+#define SDO_DAC0_C			(2 << 8)
+#define SDO_COMPOSITE			(0 << 6)
+#define SDO_COMPONENT			(1 << 6)
+#define SDO_RGB				(0 << 5)
+#define SDO_YPBPR			(1 << 5)
+#define SDO_INTERLACED			(0 << 4)
+#define SDO_PROGRESSIVE			(1 << 4)
+#define SDO_NTSC_M			(0)
+#define SDO_PAL_M			(1)
+#define SDO_PAL_BGHID			(2)
+#define SDO_PAL_N			(3)
+#define SDO_PAL_NC			(4)
+#define SDO_NTSC_443			(8)
+#define SDO_PAL_60			(9)
+#define SDO_STANDARD_MASK		(0xf)
+
+/* SDO Video Scale Configuration Register (SDO_SCALE) */
+#define SDO_COMPONENT_LEVEL_SEL_0IRE	(0 << 3)
+#define SDO_COMPONENT_LEVEL_SEL_75IRE	(1 << 3)
+#define SDO_COMPONENT_VTOS_RATIO_10_4	(0 << 2)
+#define SDO_COMPONENT_VTOS_RATIO_7_3	(1 << 2)
+#define SDO_COMPOSITE_LEVEL_SEL_0IRE	(0 << 1)
+#define SDO_COMPOSITE_LEVEL_SEL_75IRE	(1 << 1)
+#define SDO_COMPOSITE_VTOS_RATIO_10_4	(0)
+#define SDO_COMPOSITE_VTOS_RATIO_7_3	(1)
+
+/* SDO Video sync Register  */
+#define SDO_COMPONENT_SYNC_ABSENT	(0)
+#define SDO_COMPONENT_SYNC_YG		(1)
+#define SDO_COMPONENT_SYNC_ALL		(3)
+
+/* SDO VBI Configuration Register (SDO_VBI) */
+#define SDO_CVBS_NO_WSS			(0 << 14)
+#define SDO_CVBS_WSS_INS		(1 << 14)
+#define SDO_CVBS_NO_CLOSED_CAPTION	(0 << 12)
+#define SDO_CVBS_21H_CLOSED_CAPTION	(1 << 12)
+#define SDO_CVBS_21H_284H_CLOSED_CAPTION	(2 << 12)
+#define SDO_CVBS_USE_OTHERS		(3 << 12)
+#define SDO_CVBS_CLOSED_CAPTION_MASK	(3 << 12)
+
+/* SDO Channel #0 Scale Control Register (SDO_SCALE_CH0) */
+#define SDO_SCALE_CONV_OFFSET(x)	(((x) & 0x3FF) << 16)
+#define SDO_SCALE_CONV_GAIN(x)		((x) & 0xFFF)
+
+/* SDO Video Delay Control Register (SDO_YCDELAY) */
+#define SDO_DELAY_YTOC(x)		(((x) & 0xF) << 16)
+#define SDO_ACTIVE_START_OFFSET(x)	(((x) & 0xFF) << 8)
+#define SDO_ACTIVE_END_OFFSET(x)	((x) & 0xFF)
+
+/* SDO SCH Phase Control Register (SDO_SCHLOCK) */
+#define SDO_COLOR_SC_PHASE_ADJ		(1)
+#define SDO_COLOR_SC_PHASE_NOADJ	(0)
+
+/* SDO DAC Configuration Register (SDO_DAC) */
+#define SDO_POWER_ON_DAC		(1 << 0)
+#define SDO_POWER_DOWN_DAC		(0 << 0)
+
+/* SDO Status Register (SDO_FINFO) */
+#define SDO_FIELD_MOD_1001(x)		(((x) & (0x3ff << 16)) >> 16)
+#define SDO_FIELD_ID_BOTTOM(x)		((x) & (1 << 1))
+#define SDO_FIELD_ID_BOTTOM_PI_INCATION(x)	(1)
+
+#define SDO_MV_AGC_103_ON		(1)
+
+/* SDO Color Compensation On/Off Control (SDO_CCCON) */
+#define SDO_COMPENSATION_BHS_ADJ_ON	(0 << 4)
+#define SDO_COMPENSATION_BHS_ADJ_OFF	(1 << 4)
+#define SDO_COMPENSATION_CVBS_COMP_ON	(0)
+#define SDO_COMPENSATION_CVBS_COMP_OFF	(1)
+
+/* SDO Brightness Control for Y (SDO_YSCALE) */
+#define SDO_BRIGHTNESS_GAIN(x)		(((x) & 0xFF) << 16)
+#define SDO_BRIGHTNESS_OFFSET(x)	((x) & 0xFF)
+
+/* SDO Hue/Saturation Control for CB (SDO_CBSCALE) */
+#define SDO_HS_CB_GAIN0(x)		(((x) & 0x1FF) << 16)
+#define SDO_HS_CB_GAIN1(x)		((x) & 0x1FF)
+
+/* SDO Hue/Saturation Control for CR (SDO_CRSCALE) */
+#define SDO_HS_CR_GAIN0(x)		(((x) & 0x1FF) << 16)
+#define SDO_HS_CR_GAIN1(x)		((x) & 0x1FF)
+
+/* SDO Hue/Saturation Control for CB/CR (SDO_CB_CR_OFFSET) */
+#define SDO_HS_CR_OFFSET(x)		(((x) & 0x3FF) << 16)
+#define SDO_HS_CB_OFFSET(x)		((x) & 0x3FF)
+
+#define SDO_MAX_RGB_CUBE(x)		(((x) & 0xFF) << 8)
+#define SDO_MIN_RGB_CUBE(x)		((x) & 0xFF)
+
+/* Color Compensation Control Register for CVBS Output (SDO_CVBS_CC_Y1) */
+#define SDO_Y_LOWER_MID_CVBS_CORN(x)	(((x) & 0x3FF) << 16)
+#define SDO_Y_BOTTOM_CVBS_CORN(x)		((x) & 0x3FF)
+
+/* Color Compensation Control Register for CVBS Output (SDO_CVBS_CC_Y2) */
+#define SDO_Y_TOP_CVBS_CORN(x)		(((x) & 0x3FF) << 16)
+#define SDO_Y_UPPER_MID_CVBS_CORN(x)	((x) & 0x3FF)
+
+/* Color Compensation Control Register for CVBS Output (SDO_CVBS_CC_C) */
+#define SDO_RADIUS_CVBS_CORN(x)		((x) & 0x1FF)
+
+/*
+ * SDO 525 Line Component Front/Back Porch Position
+ * Control Register (SDO_CSC_525_PORCH)
+ */
+#define SDO_COMPONENT_525_BP(x)		(((x) & 0x3FF) << 16)
+#define SDO_COMPONENT_525_FP(x)		((x) & 0x3FF)
+
+/*
+ * SDO 625 Line Component Front/Back Porch Position
+ * Control Resigter(SDO_CSC_625_PORCH
+ */
+#define SDO_COMPONENT_625_BP(x)		(((x) & 0x3FF) << 16)
+#define SDO_COMPONENT_625_FP(x)		((x) & 0x3FF)
+
+/* SDO Oversampling #0 Filter Coefficient (SDO_OSFC00_0) */
+#define SDO_OSF_COEF_ODD(x)		(((x) & 0xFFF) << 16)
+#define SDO_OSF_COEF_EVEN(x)		((x) & 0xFFF)
+
+/* SDO Channel Crosstalk Cancellation Coefficient for Ch. 0 (SDO_XTALK0) */
+#define SDO_XTALK_COEF02(x)		(((x) & 0xFF) << 16)
+#define SDO_XTALK_COEF01(x)		((x) & 0xFF)
+
+/* SDO Black Burst Control Register (SDO_BB_CTRL) */
+#define SDO_REF_BB_LEVEL_NTSC		(0x11A << 8)
+#define SDO_REF_BB_LEVEL_PAL		(0xFB << 8)
+#define SDO_SEL_BB_CJAN_CVBS0_BB1_BB2	(0 << 4)
+#define SDO_SEL_BB_CJAN_BB0_CVBS1_BB2	(1 << 4)
+#define SDO_SEL_BB_CJAN_BB0_BB1_CVBS2	(2 << 4)
+#define SDO_BB_MODE_ENABLE		(1)
+#define SDO_BB_MODE_DISABLE		(0)
+
+/* SDO Interrupt Request Register (SDO_IRQ) */
+#define SDO_VSYNC_IRQ_PEND		(1)
+#define SDO_VSYNC_NO_IRQ		(0)
+
+/* SDO Interrupt Request Masking Register (SDO_IRQMASK) */
+#define SDO_VSYNC_IRQ_ENABLE		(0)
+#define SDO_VSYNC_IRQ_DISABLE		(1)
+
+/* SDO Closed Caption Data Registers (SDO_ARMCC) */
+#define SDO_DISPLAY_CC_CAPTION(x)	(((x) & 0xFF) << 16)
+#define SDO_NON_DISPLAY_CC_CAPTION(x)	((x) & 0xFF)
+
+/* SDO WSS 525 Data Registers (SDO_ARMWSS525) */
+#define SDO_CRC_WSS525(x)			(((x) & 0x3F) << 14)
+#define SDO_WORD2_WSS525_COPY_PERMIT		(0 << 6)
+#define SDO_WORD2_WSS525_ONECOPY_PERMIT		(1 << 6)
+#define SDO_WORD2_WSS525_NOCOPY_PERMIT		(3 << 6)
+#define SDO_WORD2_WSS525_MV_PSP_OFF		(0 << 8)
+#define SDO_WORD2_WSS525_MV_PSP_ON_2LINE_BURST	(1 << 8)
+#define SDO_WORD2_WSS525_MV_PSP_ON_BURST_OFF	(2 << 8)
+#define SDO_WORD2_WSS525_MV_PSP_ON_4LINE_BURST	(3 << 8)
+#define SDO_WORD2_WSS525_ANALOG_OFF		(0 << 10)
+#define SDO_WORD2_WSS525_ANALOG_ON		(1 << 10)
+#define SDO_WORD1_WSS525_COPY_INFO		(0 << 2)
+#define SDO_WORD1_WSS525_DEFAULT		(0xF << 2)
+#define SDO_WORD0_WSS525_4_3_NORMAL		(0)
+#define SDO_WORD0_WSS525_16_9_ANAMORPIC		(1)
+#define SDO_WORD0_WSS525_4_3_LETTERBOX		(2)
+
+/* SDO WSS 625 Data Registers (SDO_ARMWSS625) */
+#define SDO_WSS625_SURROUND_SOUND_DISABLE	(0 << 11)
+#define SDO_WSS625_SURROUND_SOUND_ENABLE	(1 << 11)
+#define SDO_WSS625_NO_COPYRIGHT			(0 << 12)
+#define SDO_WSS625_COPYRIGHT			(1 << 12)
+#define SDO_WSS625_COPY_NOT_RESTRICTED		(0 << 13)
+#define SDO_WSS625_COPY_RESTRICTED		(1 << 13)
+#define SDO_WSS625_TELETEXT_NO_SUBTITLES	(0 << 8)
+#define SDO_WSS625_TELETEXT_SUBTITLES		(1 << 8)
+#define SDO_WSS625_NO_OPEN_SUBTITLES		(0 << 9)
+#define SDO_WSS625_INACT_OPEN_SUBTITLES		(1 << 9)
+#define SDO_WSS625_OUTACT_OPEN_SUBTITLES	(2 << 9)
+#define SDO_WSS625_CAMERA			(0 << 4)
+#define SDO_WSS625_FILM				(1 << 4)
+#define SDO_WSS625_NORMAL_PAL			(0 << 5)
+#define SDO_WSS625_MOTION_ADAPTIVE_COLORPLUS	(1 << 5)
+#define SDO_WSS625_HELPER_NO_SIG		(0 << 6)
+#define SDO_WSS625_HELPER_SIG			(1 << 6)
+#define SDO_WSS625_4_3_FULL_576			(0x8)
+#define SDO_WSS625_14_9_LETTERBOX_CENTER_504	(0x1)
+#define SDO_WSS625_14_9_LETTERBOX_TOP_504	(0x2)
+#define SDO_WSS625_16_9_LETTERBOX_CENTER_430	(0xb)
+#define SDO_WSS625_16_9_LETTERBOX_TOP_430	(0x4)
+#define SDO_WSS625_16_9_LETTERBOX_CENTER	(0xd)
+#define SDO_WSS625_14_9_FULL_CENTER_576		(0xe)
+#define SDO_WSS625_16_9_ANAMORPIC_576		(0x7)
+
+/* SDO CGMS-A 525 Data Registers (SDO_ARMCGMS525) */
+#define SDO_CRC_CGMS525(x)			(((x) & 0x3F) << 14)
+#define SDO_WORD2_CGMS525_COPY_PERMIT		(0 << 6)
+#define SDO_WORD2_CGMS525_ONECOPY_PERMIT	(1 << 6)
+#define SDO_WORD2_CGMS525_NOCOPY_PERMIT		(3 << 6)
+#define SDO_WORD2_CGMS525_MV_PSP_OFF		(0 << 8)
+#define SDO_WORD2_CGMS525_MV_PSP_ON_2LINE_BURST	(1 << 8)
+#define SDO_WORD2_CGMS525_MV_PSP_ON_BURST_OFF	(2 << 8)
+#define SDO_WORD2_CGMS525_MV_PSP_ON_4LINE_BURST	(3 << 8)
+#define SDO_WORD2_CGMS525_ANALOG_OFF		(0 << 10)
+#define SDO_WORD2_CGMS525_ANALOG_ON		(1 << 10)
+#define SDO_WORD1_CGMS525_COPY_INFO		(0 << 2)
+#define SDO_WORD1_CGMS525_DEFAULT		(0xF << 2)
+#define SDO_WORD0_CGMS525_4_3_NORMAL		(0)
+#define SDO_WORD0_CGMS525_16_9_ANAMORPIC	(1)
+#define SDO_WORD0_CGMS525_4_3_LETTERBOX		(2)
+
+/* SDO CGMS-A 625 Data Registers (SDO_ARMCGMS625) */
+#define SDO_CGMS625_SURROUND_SOUND_DISABLE	(0 << 11)
+#define SDO_CGMS625_SURROUND_SOUND_ENABLE	(1 << 11)
+#define SDO_CGMS625_NO_COPYRIGHT		(0 << 12)
+#define SDO_CGMS625_COPYRIGHT			(1 << 12)
+#define SDO_CGMS625_COPY_NOT_RESTRICTED		(0 << 13)
+#define SDO_CGMS625_COPY_RESTRICTED		(1 << 13)
+#define SDO_CGMS625_TELETEXT_NO_SUBTITLES	(0 << 8)
+#define SDO_CGMS625_TELETEXT_SUBTITLES		(1 << 8)
+#define SDO_CGMS625_NO_OPEN_SUBTITLES		(0 << 9)
+#define SDO_CGMS625_INACT_OPEN_SUBTITLES	(1 << 9)
+#define SDO_CGMS625_OUTACT_OPEN_SUBTITLES	(2 << 9)
+#define SDO_CGMS625_CAMERA			(0 << 4)
+#define SDO_CGMS625_FILM			(1 << 4)
+#define SDO_CGMS625_NORMAL_PAL			(0 << 5)
+#define SDO_CGMS625_MOTION_ADAPTIVE_COLORPLUS	(1 << 5)
+#define SDO_CGMS625_HELPER_NO_SIG		(0 << 6)
+#define SDO_CGMS625_HELPER_SIG			(1 << 6)
+#define SDO_CGMS625_4_3_FULL_576		(0x8)
+#define SDO_CGMS625_14_9_LETTERBOX_CENTER_504	(0x1)
+#define SDO_CGMS625_14_9_LETTERBOX_TOP_504	(0x2)
+#define SDO_CGMS625_16_9_LETTERBOX_CENTER_430	(0xb)
+#define SDO_CGMS625_16_9_LETTERBOX_TOP_430	(0x4)
+#define SDO_CGMS625_16_9_LETTERBOX_CENTER	(0xd)
+#define SDO_CGMS625_14_9_FULL_CENTER_576	(0xe)
+#define SDO_CGMS625_16_9_ANAMORPIC_576		(0x7)
+
+/* SDO Version Register (SDO_VERSION) */
+#define SDO_VERSION_NUMBER_MASK			(0xFFFFFFFF)
+
+#endif /* __ARCH_ARM_REGS_SDO_H */
diff --git a/drivers/media/video/s5p-tv/regs-vmx.h b/drivers/media/video/s5p-tv/regs-vmx.h
new file mode 100644
index 0000000..08f169a
--- /dev/null
+++ b/drivers/media/video/s5p-tv/regs-vmx.h
@@ -0,0 +1,197 @@
+/*
+ * Copyright (c) 2010 Samsung Electronics
+ * http://www.samsung.com/
+ *
+ * Mixer register header file for Samsung Mixer driver
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+*/
+#ifndef __ASM_ARCH_REGS_VMX_H
+#define __ASM_ARCH_REGS_VMX_H
+
+/*
+ * Register part
+ */
+#define MXR_STATUS			(0x0000)
+#define MXR_CFG				(0x0004)
+#define MXR_INT_EN			(0x0008)
+#define MXR_INT_STATUS			(0x000C)
+#define MXR_LAYER_CFG			(0x0010)
+#define MXR_VIDEO_CFG			(0x0014)
+#define MXR_GRAPHIC0_CFG		(0x0020)
+#define MXR_GRAPHIC0_BASE		(0x0024)
+#define MXR_GRAPHIC0_SPAN		(0x0028)
+#define MXR_GRAPHIC0_SXY		(0x002C)
+#define MXR_GRAPHIC0_WH			(0x0030)
+#define MXR_GRAPHIC0_DXY		(0x0034)
+#define MXR_GRAPHIC0_BLANK		(0x0038)
+#define MXR_GRAPHIC1_CFG		(0x0040)
+#define MXR_GRAPHIC1_BASE		(0x0044)
+#define MXR_GRAPHIC1_SPAN		(0x0048)
+#define MXR_GRAPHIC1_SXY		(0x004C)
+#define MXR_GRAPHIC1_WH			(0x0050)
+#define MXR_GRAPHIC1_DXY		(0x0054)
+#define MXR_GRAPHIC1_BLANK		(0x0058)
+#define MXR_BG_CFG			(0x0060)
+#define MXR_BG_COLOR0			(0x0064)
+#define MXR_BG_COLOR1			(0x0068)
+#define MXR_BG_COLOR2			(0x006C)
+#define MXR_CM_COEFF_Y			(0x0080)
+#define MXR_CM_COEFF_CB			(0x0084)
+#define MXR_CM_COEFF_CR			(0x0088)
+#define MXR_VER				(0x0100)
+
+/* for parametrized access to registers */
+#define MXR_GRAPHIC_CFG(i)		(0x0020 + (i) * 0x20)
+#define MXR_GRAPHIC_BASE(i)		(0x0024 + (i) * 0x20)
+#define MXR_GRAPHIC_SPAN(i)		(0x0028 + (i) * 0x20)
+#define MXR_GRAPHIC_SXY(i)		(0x002C + (i) * 0x20)
+#define MXR_GRAPHIC_WH(i)		(0x0030 + (i) * 0x20)
+#define MXR_GRAPHIC_DXY(i)		(0x0034 + (i) * 0x20)
+#define MXR_GRAPHIC_BLANK(i)		(0x0038 + (i) * 0x20)
+
+/* Shadow registers */
+#define MXR_STATUS_S			(0x2000)
+#define MXR_CFG_S			(0x2004)
+#define MXR_LAYER_CFG_S			(0x2010)
+#define MXR_VIDEO_CFG_S			(0x2014)
+#define MXR_GRAPHIC0_CFG_S		(0x2020)
+#define MXR_GRAPHIC0_BASE_S		(0x2024)
+#define MXR_GRAPHIC0_SPAN_S		(0x2028)
+#define MXR_GRAPHIC0_SXY_S		(0x202C)
+#define MXR_GRAPHIC0_WH_S		(0x2030)
+#define MXR_GRAPHIC0_DXY_S		(0x2034)
+#define MXR_GRAPHIC0_BLANK_PIXEL_S	(0x2038)
+#define MXR_GRAPHIC1_CFG_S		(0x2040)
+#define MXR_GRAPHIC1_BASE_S		(0x2044)
+#define MXR_GRAPHIC1_SPAN_S		(0x2048)
+#define MXR_GRAPHIC1_SXY_S		(0x204C)
+#define MXR_GRAPHIC1_WH_S		(0x2050)
+#define MXR_GRAPHIC1_DXY_S		(0x2054)
+#define MXR_GRAPHIC1_BLANK_PIXEL_S	(0x2058)
+#define MXR_BG_COLOR0_S			(0x2064)
+#define MXR_BG_COLOR1_S			(0x2068)
+#define MXR_BG_COLOR2_S			(0x206C)
+
+/* for parametrized access to shadow registers */
+#define MXR_GRAPHIC_CFG_S(i)		(0x2020 + (i) * 0x20)
+#define MXR_GRAPHIC_BASE_S(i)		(0x2024 + (i) * 0x20)
+#define MXR_GRAPHIC_SPAN_S(i)		(0x2028 + (i) * 0x20)
+#define MXR_GRAPHIC_SXY_S(i)		(0x202C + (i) * 0x20)
+#define MXR_GRAPHIC_WH_S(i)		(0x2030 + (i) * 0x20)
+#define MXR_GRAPHIC_DXY_S(i)		(0x2034 + (i) * 0x20)
+#define MXR_GRAPHIC_BLANK_S(i)		(0x2038 + (i) * 0x20)
+
+/*
+ * Bit definition part
+ */
+
+#define MASK(high_bit, low_bit) \
+	(((2 << ((high_bit) - (low_bit))) - 1) << (low_bit))
+
+#define MASK_VAL(val, high_bit, low_bit) \
+	(((val) << (low_bit)) & MASK(high_bit, low_bit))
+
+/* MIXER_STATUS */
+#define MXR_STATUS_16_BURST		(1 << 7)
+#define MXR_STATUS_8_BURST		(0 << 7)
+#define MXR_STATUS_BURST_MASK		(1 << 7)
+#define MXR_STATUS_LITTLE_ENDIAN	(0 << 3)
+#define MXR_STATUS_BIG_ENDIAN		(1 << 3)
+#define MXR_STATUS_SYNC_ENABLE		(1 << 2)
+#define MXR_STATUS_OPERATING		(0 << 1)
+#define MXR_STATUS_IDLE_MODE		(1 << 1)
+#define MXR_STATUS_OPERATION_STATUS	(1 << 1)
+#define MXR_STATUS_REG_RUN		(1 << 0)
+
+/* MIXER_CFG */
+#define MXR_CFG_OUT_YUV444		(0 << 8)
+#define MXR_CFG_OUT_RGB888		(1 << 8)
+#define MXR_CFG_DST_TV			(0 << 7)
+#define MXR_CFG_DST_HDMI		(1 << 7)
+#define MXR_CFG_DST_MASK		(1 << 7)
+#define MXR_CFG_HD_720			(0 << 6)
+#define MXR_CFG_HD_1080			(1 << 6)
+#define MXR_CFG_GRP1_ENABLE		(1 << 5)
+#define MXR_CFG_GRP0_ENABLE		(1 << 4)
+#define MXR_CFG_VP_ENABLE		(1 << 3)
+#define MXR_CFG_SCAN_INTERLACE		(0 << 2)
+#define MXR_CFG_SCAN_PROGRASSIVE	(1 << 2)
+#define MXR_CFG_NTSC			(0 << 1)
+#define MXR_CFG_PAL			(1 << 1)
+#define MXR_CFG_SD			(0 << 0)
+#define MXR_CFG_HD			(1 << 0)
+#define MXR_CFG_SCAN_MASK		0x47
+
+/* MIXER_INT_EN */
+#define MXR_INT_EN_VSYNC		(1 << 11)
+#define MXR_INT_EN_VP			(1 << 10)
+#define MXR_INT_EN_GRP1			(1 << 9)
+#define MXR_INT_EN_GRP0			(1 << 8)
+#define MXR_INT_EN_ALL			(0x0f << 8)
+
+/* MIXER_INT_STATUS */
+#define MXR_INT_CLEAR_VSYNC		(1 << 11)
+#define MXR_INT_STATUS_VP		(1 << 10)
+#define MXR_INT_STATUS_GRP1		(1 << 9)
+#define MXR_INT_STATUS_GRP0		(1 << 8)
+#define MXR_INT_STATUS_VSYNC		(1 << 0)
+
+/* MIXER_LAYER_CFG */
+#define MXR_LAYER_CFG_GRP1_VAL(x)	MASK_VAL(x, 11, 8)
+#define MXR_LAYER_CFG_GRP1_HIDE		MASK_VAL(0, 11, 8)
+#define MXR_LAYER_CFG_GRP0_VAL(x)	MASK_VAL(x, 7, 4)
+#define MXR_LAYER_CFG_GRP0_HIDE		MASK_VAL(0, 7, 4)
+#define MXR_LAYER_CFG_VP_VAL(x)		MASK_VAL(x, 3, 0)
+#define MXR_LAYER_CFG_VP_HIDE		MASK_VAL(0, 3, 0)
+
+/* MIXER_VIDEO_CFG */
+#define MXR_VP_CFG_LIMITER_EN		(1 << 17)
+#define MXR_VP_CFG_BLEND_EN		(1 << 16)
+#define MXR_VP_CFG_ALPHA_VAL(x)		MASK_VAL(x, 7, 0)
+
+/* MIXER_GRAPHICn_CFG */
+#define MXR_GRP_CFG_COLOR_KEY_DISABLE	(1 << 21)
+#define MXR_GRP_CFG_BLEND_PRE_MUL	(1 << 20)
+#define MXR_GRP_CFG_BLEND_NORMAL	(0 << 20)
+#define MXR_GRP_CFG_WIN_BLEND		(1 << 17)
+#define MXR_GRP_CFG_PIXEL_BLEND		(1 << 16)
+#define MXR_GRP_CFG_FORMAT_VAL(x)	MASK_VAL(x, 11, 8)
+#define MXR_GRP_CFG_FORMAT_MASK		MXR_GRP_CFG_FORMAT_VAL(~0)
+#define MXR_GRP_CFG_ALPHA_VAL(x)	MASK_VAL(x, 7, 0)
+
+/* MIXER_GRAPHICn_WH */
+#define MXR_GRP_WH_H_SCALE(x)		MASK_VAL(x, 28, 28)
+#define MXR_GRP_WH_V_SCALE(x)		MASK_VAL(x, 12, 12)
+#define MXR_GRP_WH_WIDTH(x)		MASK_VAL(x, 26, 16)
+#define MXR_GRP_WH_HEIGHT(x)		MASK_VAL(x, 10, 0)
+
+/* MIXER_GRAPHICn_XY */
+#define MXR_GRP_SXY_SX(x)		MASK_VAL(x, 26, 16)
+#define MXR_GRP_SXY_SY(x)		MASK_VAL(x, 10, 0)
+
+/* MIXER_GRAPHICn_DXY */
+#define MXR_GRP_DXY_DX(x)		MASK_VAL(x, 26, 16)
+#define MXR_GRP_DXY_DY(x)		MASK_VAL(x, 10, 0)
+
+/* MIXER_BG_CFG, Not supported in S5PV210 */
+#define MXR_BG_CR_DIHER			(1 << 19)
+#define MXR_BG_CB_DIHER			(1 << 18)
+#define MXR_BG_Y_DIHER			(1 << 17)
+
+/* MIXER_BG_COLOR0/1/2 */
+#define MXR_BG_Y(x)			MASK_VAL(x, 23, 16)
+#define MXR_BG_CB(x)			MASK_VAL(x, 15, 8)
+#define MXR_BG_CR(x)			MASK_VAL(x, 7, 0)
+
+/* MIXER_CM_COEFF_{Y/CB/CR} */
+#define MXR_CM_COLOR_WIDE		(1 << 30)
+#define MXR_CM_COLOR_NARROW		(0 << 30)
+#define MXR_CM_COEF0(x)			MASK_VAL(x, 29, 20)
+#define MXR_CM_COEF1(x)			MASK_VAL(x, 19, 10)
+#define MXR_CM_COEF2(x)			MASK_VAL(x, 9, 0)
+
+#endif /* __ASM_ARCH_REGS_VMX_H */
+
diff --git a/drivers/media/video/s5p-tv/regs-vp.h b/drivers/media/video/s5p-tv/regs-vp.h
new file mode 100644
index 0000000..f06dbb6
--- /dev/null
+++ b/drivers/media/video/s5p-tv/regs-vp.h
@@ -0,0 +1,277 @@
+/*
+ * Copyright (c) 2010 Samsung Electronics
+ *		http://www.samsung.com/
+ *
+ * Video processor register header file for Samsung Mixer driver
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef __ARCH_ARM_REGS_VP_H
+#define __ARCH_ARM_REGS_VP_H
+
+/*
+ * Register part
+ */
+#define VP_ENABLE			(0x0000)
+#define VP_SRESET			(0x0004)
+#define VP_SHADOW_UPDATE		(0x0008)
+#define VP_FIELD_ID			(0x000C)
+#define VP_MODE				(0x0010)
+#define VP_IMG_SIZE_Y			(0x0014)
+#define VP_IMG_SIZE_C			(0x0018)
+#define VP_PER_RATE_CTRL		(0x001C)
+#define VP_TOP_Y_PTR			(0x0028)
+#define VP_BOT_Y_PTR			(0x002C)
+#define VP_TOP_C_PTR			(0x0030)
+#define VP_BOT_C_PTR			(0x0034)
+#define VP_ENDIAN_MODE			(0x03CC)
+#define VP_SRC_H_POSITION		(0x0044)
+#define VP_SRC_V_POSITION		(0x0048)
+#define VP_SRC_WIDTH			(0x004C)
+#define VP_SRC_HEIGHT			(0x0050)
+#define VP_DST_H_POSITION		(0x0054)
+#define VP_DST_V_POSITION		(0x0058)
+#define VP_DST_WIDTH			(0x005C)
+#define VP_DST_HEIGHT			(0x0060)
+#define VP_H_RATIO			(0x0064)
+#define VP_V_RATIO			(0x0068)
+#define VP_POLY8_Y0_LL			(0x006C)
+#define VP_POLY8_Y0_LH			(0x0070)
+#define VP_POLY8_Y0_HL			(0x0074)
+#define VP_POLY8_Y0_HH			(0x0078)
+#define VP_POLY8_Y1_LL			(0x007C)
+#define VP_POLY8_Y1_LH			(0x0080)
+#define VP_POLY8_Y1_HL			(0x0084)
+#define VP_POLY8_Y1_HH			(0x0088)
+#define VP_POLY8_Y2_LL			(0x008C)
+#define VP_POLY8_Y2_LH			(0x0090)
+#define VP_POLY8_Y2_HL			(0x0094)
+#define VP_POLY8_Y2_HH			(0x0098)
+#define VP_POLY8_Y3_LL			(0x009C)
+#define VP_POLY8_Y3_LH			(0x00A0)
+#define VP_POLY8_Y3_HL			(0x00A4)
+#define VP_POLY8_Y3_HH			(0x00A8)
+#define VP_POLY4_Y0_LL			(0x00EC)
+#define VP_POLY4_Y0_LH			(0x00F0)
+#define VP_POLY4_Y0_HL			(0x00F4)
+#define VP_POLY4_Y0_HH			(0x00F8)
+#define VP_POLY4_Y1_LL			(0x00FC)
+#define VP_POLY4_Y1_LH			(0x0100)
+#define VP_POLY4_Y1_HL			(0x0104)
+#define VP_POLY4_Y1_HH			(0x0108)
+#define VP_POLY4_Y2_LL			(0x010C)
+#define VP_POLY4_Y2_LH			(0x0110)
+#define VP_POLY4_Y2_HL			(0x0114)
+#define VP_POLY4_Y2_HH			(0x0118)
+#define VP_POLY4_Y3_LL			(0x011C)
+#define VP_POLY4_Y3_LH			(0x0120)
+#define VP_POLY4_Y3_HL			(0x0124)
+#define VP_POLY4_Y3_HH			(0x0128)
+#define VP_POLY4_C0_LL			(0x012C)
+#define VP_POLY4_C0_LH			(0x0130)
+#define VP_POLY4_C0_HL			(0x0134)
+#define VP_POLY4_C0_HH			(0x0138)
+#define VP_POLY4_C1_LL			(0x013C)
+#define VP_POLY4_C1_LH			(0x0140)
+#define VP_POLY4_C1_HL			(0x0144)
+#define VP_POLY4_C1_HH			(0x0148)
+#define VP_FIELD_ID_S			(0x016C)
+#define VP_MODE_S			(0x0170)
+#define VP_IMG_SIZE_Y_S			(0x0174)
+#define VP_IMG_SIZE_C_S			(0x0178)
+#define VP_TOP_Y_PTR_S			(0x0190)
+#define VP_BOT_Y_PTR_S			(0x0194)
+#define VP_TOP_C_PTR_S			(0x0198)
+#define VP_BOT_C_PTR_S			(0x019C)
+#define VP_SRC_H_POSITION_S		(0x01AC)
+#define VP_SRC_V_POSITION_S		(0x01B0)
+#define VP_SRC_WIDTH_S			(0x01B4)
+#define VP_SRC_HEIGHT_S			(0x01B8)
+#define VP_DST_H_POSITION_S		(0x01BC)
+#define VP_DST_V_POSITION_S		(0x01C0)
+#define VP_DST_WIDTH_S			(0x01C4)
+#define VP_DST_HEIGHT_S			(0x01C8)
+#define VP_H_RATIO_S			(0x01CC)
+#define VP_V_RATIO_S			(0x01D0)
+#define VP_PP_CSC_Y2Y_COEF		(0x01D4)
+#define VP_PP_CSC_CB2Y_COEF		(0x01D8)
+#define VP_PP_CSC_CR2Y_COEF		(0x01DC)
+#define VP_PP_CSC_Y2CB_COEF		(0x01E0)
+#define VP_PP_CSC_CB2CB_COEF		(0x01E4)
+#define VP_PP_CSC_CR2CB_COEF		(0x01E8)
+#define VP_PP_CSC_Y2CR_COEF		(0x01EC)
+#define VP_PP_CSC_CB2CR_COEF		(0x01F0)
+#define VP_PP_CSC_CR2CR_COEF		(0x01F4)
+#define VP_PP_BYPASS			(0x0200)
+#define VP_PP_SATURATION		(0x020C)
+#define VP_PP_SHARPNESS			(0x0210)
+#define VP_PP_LINE_EQ0			(0x0218)
+#define VP_PP_LINE_EQ1			(0x021C)
+#define VP_PP_LINE_EQ2			(0x0220)
+#define VP_PP_LINE_EQ3			(0x0224)
+#define VP_PP_LINE_EQ4			(0x0228)
+#define VP_PP_LINE_EQ5			(0x022C)
+#define VP_PP_LINE_EQ6			(0x0230)
+#define VP_PP_LINE_EQ7			(0x0234)
+#define VP_PP_BRIGHT_OFFSET		(0x0238)
+#define VP_PP_CSC_EN			(0x023C)
+#define VP_PP_BYPASS_S			(0x0258)
+#define VP_PP_SATURATION_S		(0x025C)
+#define VP_PP_SHARPNESS_S		(0x0260)
+#define VP_PP_LINE_EQ0_S		(0x0268)
+#define VP_PP_LINE_EQ1_S		(0x026C)
+#define VP_PP_LINE_EQ2_S		(0x0270)
+#define VP_PP_LINE_EQ3_S		(0x0274)
+#define VP_PP_LINE_EQ4_S		(0x0278)
+#define VP_PP_LINE_EQ5_S		(0x027C)
+#define VP_PP_LINE_EQ6_S		(0x0280)
+#define VP_PP_LINE_EQ7_S		(0x0284)
+#define VP_PP_BRIGHT_OFFSET_S		(0x0288)
+#define VP_PP_CSC_EN_S			(0x028C)
+#define VP_PP_CSC_Y2Y_COEF_S		(0x0290)
+#define VP_PP_CSC_CB2Y_COEF_S		(0x0294)
+#define VP_PP_CSC_CR2Y_COEF_S		(0x0298)
+#define VP_PP_CSC_Y2CB_COEF_S		(0x029C)
+#define VP_PP_CSC_CB2CB_COEF_S		(0x02A0)
+#define VP_PP_CSC_CR2CB_COEF_S		(0x02A4)
+#define VP_PP_CSC_Y2CR_COEF_S		(0x02A8)
+#define VP_PP_CSC_CB2CR_COEF_S		(0x02AC)
+#define VP_PP_CSC_CR2CR_COEF_S		(0x02B0)
+#define VP_ENDIAN_MODE_S		(0x03EC)
+#define VP_VERSION_INFO			(0x03FC)
+
+#define MASK(high_bit, low_bit) \
+	(((2 << ((high_bit) - (low_bit))) - 1) << (low_bit))
+
+#define MASK_VAL(val, high_bit, low_bit) \
+	(((val) << (low_bit)) & MASK(high_bit, low_bit))
+/*
+ * Bit definition part
+ */
+
+ /* VP_ENABLE */
+#define VP_ENABLE_ON_S			(1 << 2)
+#define VP_ENABLE_OPERATION_STATUS	(1 << 1)
+#define VP_ENABLE_ON			(1 << 0)
+
+/* VP_SRESET */
+#define VP_SRESET_PROCESSING		(1 << 0)
+
+/* VP_SHADOW_UPDATE */
+#define VP_SHADOW_UPDATE_ENABLE		(1 << 0)
+
+/* VP_FIELD_ID */
+#define VP_FIELD_ID_TOP			(0 << 0)
+#define VP_FIELD_ID_BOTTOM		(1 << 0)
+
+/* VP_MODE */
+#define VP_MODE_NV12			(0 << 6)
+#define VP_MODE_NV21			(1 << 6)
+#define VP_MODE_LINE_SKIP		(1 << 5)
+#define VP_MODE_MEM_LINEAR		(0 << 4)
+#define VP_MODE_MEM_TILED		(1 << 4)
+#define VP_MODE_FMT_MASK		(VP_MODE_NV21 | VP_MODE_MEM_TILED)
+#define VP_MODE_CROMA_EXP_TOP		(0 << 3)
+#define VP_MODE_CROMA_EXP_TOPBOT	(1 << 3)
+#define VP_MODE_FIELD_ID_AUTO_TOGGLING	(1 << 2)
+#define VP_MODE_2D_IPC			(1 << 1)
+
+/* VP_IMG_SIZE_Y */
+/* VP_IMG_SIZE_C */
+#define VP_IMG_HSIZE(x)			MASK_VAL(x, 29, 16)
+#define VP_IMG_VSIZE(x)			MASK_VAL(x, 13, 0)
+
+/* VP_ENDIAN_MODE */
+#define VP_ENDIAN_MODE_BIG		(0 << 0)
+#define VP_ENDIAN_MODE_LITTLE		(1 << 0)
+
+/* VP_SRC_H_POSITION */
+#define VP_SRC_H_POSITION_VAL(x)	MASK_VAL(x, 14, 4)
+
+/* VP_SRC_V_POSITION */
+#define VP_SRC_V_POSITION_VAL(x)	MASK_VAL(x, 10, 0)
+
+/* VP_SRC_WIDTH */
+/* VP_SRC_HEIGHT */
+#define VP_SRC_WIDTH_VAL(x)		MASK_VAL(x, 10, 0)
+#define VP_SRC_HEIGHT_VAL(x)		MASK_VAL(x, 10, 0)
+
+/* VP_DST_H_POSITION */
+/* VP_DST_V_POSITION */
+#define VP_DST_H_POSITION_VAL(x)	MASK_VAL(x, 10, 0)
+#define VP_DST_V_POSITION_VAL(x)	MASK_VAL(x, 10, 0)
+
+/* VP_DST_WIDTH */
+/* VP_DST_HEIGHT */
+#define VP_DST_WIDTH_VAL(x)		MASK_VAL(x, 10, 0)
+#define VP_DST_HEIGHT_VAL(x)		MASK_VAL(x, 10, 0)
+
+/* VP_H_RATIO */
+/* VP_V_RATIO */
+#define VP_H_RATIO_VAL(x)		MASK_VAL(x, 18, 0)
+#define VP_V_RATIO_VAL(x)		MASK_VAL(x, 18, 0)
+
+/* PP_CSC_Y2Y_COEF */
+#define PP_Y2Y_COEF_601_TO_709		(0x400)
+#define PP_Y2Y_COEF_709_TO_601		(0x400)
+
+/* PP_CSC_CB2Y_COEF */
+#define PP_CB2Y_COEF_601_TO_709		(0x879)
+#define PP_CB2Y_COEF_709_TO_601		(0x068)
+
+/* PP_CSC_CR2Y_COEF */
+#define PP_CR2Y_COEF_601_TO_709		(0x8D9)
+#define PP_CR2Y_COEF_709_TO_601		(0x0C9)
+
+/* PP_CSC_Y2CB_COEF */
+#define PP_Y2CB_COEF_601_TO_709		(0x0)
+#define PP_Y2CB_COEF_709_TO_601		(0x0)
+
+/* PP_CSC_CB2CB_COEF */
+#define PP_CB2CB_COEF_601_TO_709	(0x413)
+#define PP_CB2CB_COEF_709_TO_601	(0x3F6)
+
+/* PP_CSC_CR2CB_COEF */
+#define PP_CR2CB_COEF_601_TO_709	(0x875)
+#define PP_CR2CB_COEF_709_TO_601	(0x871)
+
+/* PP_CSC_Y2CR_COEF */
+#define PP_Y2CR_COEF_601_TO_709		(0x0)
+#define PP_Y2CR_COEF_709_TO_601		(0x0)
+
+/* PP_CSC_CB2CR_COEF */
+#define PP_CB2CR_COEF_601_TO_709	(0x04D)
+#define PP_CB2CR_COEF_709_TO_601	(0x84A)
+
+/* PP_CSC_CR2CR_COEF */
+#define PP_CR2CR_COEF_601_TO_709	(0x41A)
+#define PP_CR2CR_COEF_709_TO_601	(0xBEF)
+
+#define PP_CSC_COEF(x)			MASK_VAL(x, 11, 0)
+
+/* PP_BYPASS */
+#define VP_BY_PASS_ENABLE		(0)
+#define VP_BY_PASS_DISABLE		(1)
+
+/* PP_SATURATION */
+#define VP_SATURATION(x)		MASK_VAL(x, 7, 0)
+
+/* PP_SHARPNESS */
+#define VP_TH_HNOISE(x)			MASK_VAL(x, 15, 8)
+#define VP_SHARPNESS(x)			MASK_VAL(x, 1, 0)
+
+/* PP_LINE_EQ0 ~ 7 */
+#define VP_LINE_INTC(x)			MASK_VAL(x, 23, 8)
+#define VP_LINE_SLOPE(x)		MASK_VAL(x, 7, 0)
+
+/* PP_BRIGHT_OFFSET */
+#define VP_BRIGHT_OFFSET(x)		MASK_VAL(x, 8, 0)
+
+/* PP_CSC_EN */
+#define VP_SUB_Y_OFFSET_ENABLE		(1 << 1)
+#define VP_CSC_ENABLE			(1)
+
+#endif /* __ARCH_ARM_REGS_VP_H */
diff --git a/drivers/media/video/s5p-tv/sdo_drv.c b/drivers/media/video/s5p-tv/sdo_drv.c
new file mode 100644
index 0000000..2e1aaa7
--- /dev/null
+++ b/drivers/media/video/s5p-tv/sdo_drv.c
@@ -0,0 +1,538 @@
+/*
+ * Samsung Standard Definition Output (SDO) driver
+ *
+ * Copyright (c) 2011 Samsung Electronics
+ *
+ * Tomasz Stanislawski, t.stanislaws@samsung.com
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published
+ * by the Free Software Foundiation. either version 2 of the License,
+ * or (at your option) any later version
+ */
+
+#include <linux/clk.h>
+#include <linux/delay.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/interrupt.h>
+#include <linux/io.h>
+#include <linux/irq.h>
+#include <linux/platform_device.h>
+#include <linux/pm_runtime.h>
+#include <linux/regulator/consumer.h>
+#include <linux/slab.h>
+
+#include <media/v4l2-subdev.h>
+
+#include "regs-sdo.h"
+
+MODULE_AUTHOR("Tomasz Stanislawski, t.stanislaws@samsung.com");
+MODULE_DESCRIPTION("Samsung Standard Definition Output (SDO)");
+MODULE_LICENSE("GPL");
+
+#define SDO_DEFAULT_STD	V4L2_STD_PAL_B
+
+static struct platform_driver sdo_driver;
+
+struct sdo_format {
+	v4l2_std_id id;
+	/* all modes are 720 pixels wide */
+	unsigned int height;
+	unsigned int cookie;
+};
+
+struct sdo_device {
+	/** pointer to device parent */
+	struct device *dev;
+	/** base address of SDO registers */
+	void __iomem *regs;
+	/** SDO interrupt */
+	unsigned int irq;
+	/** DAC source clock */
+	struct clk *sclk_dac;
+	/** DAC clock */
+	struct clk *dac;
+	/** DAC physical interface */
+	struct clk *dacphy;
+	/** clock for control of VPLL */
+	struct clk *fout_vpll;
+	/** regulator for SDO IP power */
+	struct regulator *vdac;
+	/** regulator for SDO plug detection */
+	struct regulator *vdet;
+	/** subdev used as device interface */
+	struct v4l2_subdev sd;
+	/** current format */
+	const struct sdo_format *fmt;
+};
+
+static inline struct sdo_device *sd_to_sdev(struct v4l2_subdev *sd)
+{
+	return container_of(sd, struct sdo_device, sd);
+}
+
+static inline
+void sdo_write_mask(struct sdo_device *sdev, u32 reg_id, u32 value, u32 mask)
+{
+	u32 old = readl(sdev->regs + reg_id);
+	value = (value & mask) | (old & ~mask);
+	writel(value, sdev->regs + reg_id);
+}
+
+static inline
+void sdo_write(struct sdo_device *sdev, u32 reg_id, u32 value)
+{
+	writel(value, sdev->regs + reg_id);
+}
+
+static inline
+u32 sdo_read(struct sdo_device *sdev, u32 reg_id)
+{
+	return readl(sdev->regs + reg_id);
+}
+
+static int __init sdo_init(void)
+{
+	int ret;
+	static const char banner[] __initdata = KERN_INFO \
+		"Samsung Standard Definition Output (SDO) driver, "
+		"(c) 2011 Samsung Electronics\n";
+	printk(banner);
+
+	ret = platform_driver_register(&sdo_driver);
+	if (ret)
+		printk(KERN_ERR "SDO platform driver register failed\n");
+
+	return ret;
+}
+module_init(sdo_init);
+
+static void __exit sdo_exit(void)
+{
+	platform_driver_unregister(&sdo_driver);
+}
+module_exit(sdo_exit);
+
+static int __devinit sdo_probe(struct platform_device *pdev);
+static int __devexit sdo_remove(struct platform_device *pdev);
+static const struct dev_pm_ops sdo_pm_ops;
+
+static struct platform_driver sdo_driver __refdata = {
+	.probe = sdo_probe,
+	.remove = __devexit_p(sdo_remove),
+	.driver = {
+		.name = "s5p-sdo",
+		.owner = THIS_MODULE,
+		.pm = &sdo_pm_ops,
+	}
+};
+
+static irqreturn_t sdo_irq_handler(int irq, void *dev_data);
+static const struct sdo_format *sdo_find_format(v4l2_std_id id);
+static const struct v4l2_subdev_ops sdo_sd_ops;
+
+static int __devinit sdo_probe(struct platform_device *pdev)
+{
+	struct device *dev = &pdev->dev;
+	struct sdo_device *sdev;
+	struct resource *res;
+	int ret = 0;
+	struct clk *sclk_vpll;
+
+	dev_info(dev, "probe start\n");
+	sdev = kzalloc(sizeof *sdev, GFP_KERNEL);
+	if (!sdev) {
+		dev_err(dev, "not enough memory.\n");
+		ret = -ENOMEM;
+		goto fail;
+	}
+	sdev->dev = dev;
+
+	/* mapping registers */
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (res == NULL) {
+		dev_err(dev, "get memory resource failed.\n");
+		ret = -ENXIO;
+		goto fail_sdev;
+	}
+
+	sdev->regs = ioremap(res->start, resource_size(res));
+	if (sdev->regs == NULL) {
+		dev_err(dev, "register mapping failed.\n");
+		ret = -ENXIO;
+		goto fail_sdev;
+	}
+
+	/* acquiring interrupt */
+	res = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
+	if (res == NULL) {
+		dev_err(dev, "get interrupt resource failed.\n");
+		ret = -ENXIO;
+		goto fail_regs;
+	}
+	ret = request_irq(res->start, sdo_irq_handler, 0, "s5p-sdo", sdev);
+	if (ret) {
+		dev_err(dev, "request interrupt failed.\n");
+		goto fail_regs;
+	}
+	sdev->irq = res->start;
+
+	/* acquire clocks */
+	sdev->sclk_dac = clk_get(dev, "sclk_dac");
+	if (IS_ERR_OR_NULL(sdev->sclk_dac)) {
+		dev_err(dev, "failed to get clock 'sclk_dac'\n");
+		ret = -ENXIO;
+		goto fail_irq;
+	}
+	sdev->dac = clk_get(dev, "dac");
+	if (IS_ERR_OR_NULL(sdev->dac)) {
+		dev_err(dev, "failed to get clock 'dac'\n");
+		ret = -ENXIO;
+		goto fail_sclk_dac;
+	}
+	sdev->dacphy = clk_get(dev, "dacphy");
+	if (IS_ERR_OR_NULL(sdev->dacphy)) {
+		dev_err(dev, "failed to get clock 'dacphy'\n");
+		ret = -ENXIO;
+		goto fail_dac;
+	}
+	sclk_vpll = clk_get(dev, "sclk_vpll");
+	if (IS_ERR_OR_NULL(sclk_vpll)) {
+		dev_err(dev, "failed to get clock 'sclk_vpll'\n");
+		ret = -ENXIO;
+		goto fail_dacphy;
+	}
+	clk_set_parent(sdev->sclk_dac, sclk_vpll);
+	clk_put(sclk_vpll);
+	sdev->fout_vpll = clk_get(dev, "fout_vpll");
+	if (IS_ERR_OR_NULL(sdev->fout_vpll)) {
+		dev_err(dev, "failed to get clock 'fout_vpll'\n");
+		goto fail_dacphy;
+	}
+	dev_info(dev, "fout_vpll.rate = %lu\n", clk_get_rate(sclk_vpll));
+
+	/* acquire regulator */
+	sdev->vdac = regulator_get(dev, "vdd33a_dac");
+	if (IS_ERR_OR_NULL(sdev->vdac)) {
+		dev_err(dev, "failed to get regulator 'vdac'\n");
+		goto fail_fout_vpll;
+	}
+	sdev->vdet = regulator_get(dev, "vdet");
+	if (IS_ERR_OR_NULL(sdev->vdet)) {
+		dev_err(dev, "failed to get regulator 'vdet'\n");
+		goto fail_vdac;
+	}
+
+	/* configure power management */
+	pm_runtime_set_active(dev);
+	pm_runtime_enable(dev);
+
+	/* configuration of interface subdevice */
+	v4l2_subdev_init(&sdev->sd, &sdo_sd_ops);
+	sdev->sd.owner = THIS_MODULE;
+	strlcpy(sdev->sd.name, sdo_driver.driver.name, sizeof sdev->sd.name);
+
+	/* set default format */
+	sdev->fmt = sdo_find_format(SDO_DEFAULT_STD);
+	BUG_ON(sdev->fmt == NULL);
+
+	/* keeping subdev in device's private for use by other drivers */
+	dev_set_drvdata(dev, &sdev->sd);
+
+	dev_info(dev, "probe succeeded\n");
+	return 0;
+
+fail_vdac:
+	regulator_put(sdev->vdac);
+fail_fout_vpll:
+	clk_put(sdev->fout_vpll);
+fail_dacphy:
+	clk_put(sdev->dacphy);
+fail_dac:
+	clk_put(sdev->dac);
+fail_sclk_dac:
+	clk_put(sdev->sclk_dac);
+fail_irq:
+	free_irq(sdev->irq, sdev);
+fail_regs:
+	iounmap(sdev->regs);
+fail_sdev:
+	kfree(sdev);
+fail:
+	dev_info(dev, "probe failed\n");
+	return ret;
+}
+
+static int __devexit sdo_remove(struct platform_device *pdev)
+{
+	struct v4l2_subdev *sd = dev_get_drvdata(&pdev->dev);
+	struct sdo_device *sdev = sd_to_sdev(sd);
+
+	pm_runtime_disable(&pdev->dev);
+	regulator_put(sdev->vdet);
+	regulator_put(sdev->vdac);
+	clk_put(sdev->fout_vpll);
+	clk_put(sdev->dacphy);
+	clk_put(sdev->dac);
+	clk_put(sdev->sclk_dac);
+	free_irq(sdev->irq, sdev);
+	iounmap(sdev->regs);
+	kfree(sdev);
+
+	dev_info(&pdev->dev, "remove successful\n");
+	return 0;
+}
+
+static int sdo_runtime_suspend(struct device *dev)
+{
+	dev_info(dev, "suspend successful\n");
+	return 0;
+}
+
+static int sdo_runtime_resume(struct device *dev)
+{
+	dev_info(dev, "resume successful\n");
+	return 0;
+}
+
+static const struct dev_pm_ops sdo_pm_ops = {
+	.runtime_suspend = sdo_runtime_suspend,
+	.runtime_resume	 = sdo_runtime_resume,
+};
+
+static irqreturn_t sdo_irq_handler(int irq, void *dev_data)
+{
+	struct sdo_device *sdev = dev_data;
+
+	/* clear interrupt */
+	sdo_write_mask(sdev, SDO_IRQ, ~0, SDO_VSYNC_IRQ_PEND);
+	return IRQ_HANDLED;
+}
+
+static int sdo_s_power(struct v4l2_subdev *sd, int on);
+static int sdo_s_std_output(struct v4l2_subdev *sd, v4l2_std_id std);
+static int sdo_g_tvnorms(struct v4l2_subdev *sd, v4l2_std_id *std);
+static int sdo_g_mbus_fmt(struct v4l2_subdev *sd,
+	struct v4l2_mbus_framefmt *fmt);
+static int sdo_s_stream(struct v4l2_subdev *sd, int on);
+
+static const struct v4l2_subdev_core_ops sdo_sd_core_ops = {
+	.s_power = sdo_s_power,
+};
+
+static const struct v4l2_subdev_video_ops sdo_sd_video_ops = {
+	.s_std_output = sdo_s_std_output,
+	.querystd = NULL,
+	.g_tvnorms = sdo_g_tvnorms,
+	.g_mbus_fmt = sdo_g_mbus_fmt,
+	.s_stream = sdo_s_stream,
+};
+
+static const struct v4l2_subdev_ops sdo_sd_ops = {
+	.core = &sdo_sd_core_ops,
+	.video = &sdo_sd_video_ops,
+};
+
+static const struct sdo_format sdo_format[] = {
+	{ V4L2_STD_NTSC_M,	.height = 480, .cookie = SDO_NTSC_M },
+	{ V4L2_STD_PAL_M,	.height = 480, .cookie = SDO_PAL_M },
+	{ V4L2_STD_PAL_B,	.height = 576, .cookie = SDO_PAL_BGHID },
+	{ V4L2_STD_PAL_D,	.height = 576, .cookie = SDO_PAL_BGHID },
+	{ V4L2_STD_PAL_G,	.height = 576, .cookie = SDO_PAL_BGHID },
+	{ V4L2_STD_PAL_H,	.height = 576, .cookie = SDO_PAL_BGHID },
+	{ V4L2_STD_PAL_I,	.height = 576, .cookie = SDO_PAL_BGHID },
+	{ V4L2_STD_PAL_N,	.height = 576, .cookie = SDO_PAL_N },
+	{ V4L2_STD_PAL_Nc,	.height = 576, .cookie = SDO_PAL_NC },
+	{ V4L2_STD_NTSC_443,	.height = 480, .cookie = SDO_NTSC_443 },
+	{ V4L2_STD_PAL_60,	.height = 480, .cookie = SDO_PAL_60 },
+};
+
+static void sdo_reg_debug(struct sdo_device *sdev);
+
+static int sdo_g_tvnorms(struct v4l2_subdev *sd, v4l2_std_id *std)
+{
+	*std = V4L2_STD_NTSC_M | V4L2_STD_PAL_M | V4L2_STD_PAL_B |
+		V4L2_STD_PAL_D | V4L2_STD_PAL_G | V4L2_STD_PAL_H |
+		V4L2_STD_PAL_I | V4L2_STD_PAL_N | V4L2_STD_PAL_Nc |
+		V4L2_STD_NTSC_443 | V4L2_STD_PAL_60;
+	return 0;
+}
+
+static int sdo_s_std_output(struct v4l2_subdev *sd, v4l2_std_id std)
+{
+	struct sdo_device *sdev = sd_to_sdev(sd);
+	const struct sdo_format *fmt;
+	fmt = sdo_find_format(std);
+	if (fmt == NULL)
+		return -EINVAL;
+	sdev->fmt = fmt;
+	return 0;
+}
+
+static int sdo_g_mbus_fmt(struct v4l2_subdev *sd,
+	struct v4l2_mbus_framefmt *fmt)
+{
+	struct sdo_device *sdev = sd_to_sdev(sd);
+
+	if (!sdev->fmt)
+		return -ENXIO;
+	/* all modes are 720 pixels wide */
+	fmt->width = 720;
+	fmt->height = sdev->fmt->height;
+	fmt->code = V4L2_MBUS_FMT_FIXED;
+	fmt->field = V4L2_FIELD_INTERLACED;
+	return 0;
+}
+
+static int sdo_poweron(struct sdo_device *sdev)
+{
+	struct device *dev = sdev->dev;
+
+	pm_runtime_get_sync(dev);
+	clk_enable(sdev->sclk_dac);
+	clk_enable(sdev->dac);
+	regulator_enable(sdev->vdac);
+	regulator_enable(sdev->vdet);
+
+	/* software reset */
+	sdo_write_mask(sdev, SDO_CLKCON, ~0, SDO_TVOUT_SW_RESET);
+	mdelay(10);
+	sdo_write_mask(sdev, SDO_CLKCON, 0, SDO_TVOUT_SW_RESET);
+
+	/* setting TV mode */
+	sdo_write_mask(sdev, SDO_CONFIG, sdev->fmt->cookie, SDO_STANDARD_MASK);
+	/* XXX: forcing interlaced mode using undocumented bit */
+	sdo_write_mask(sdev, SDO_CONFIG, 0, SDO_PROGRESSIVE);
+	/* turn all VBI off */
+	sdo_write_mask(sdev, SDO_VBI, 0, SDO_CVBS_WSS_INS |
+		SDO_CVBS_CLOSED_CAPTION_MASK);
+	/* turn all post processing off */
+	sdo_write_mask(sdev, SDO_CCCON, ~0, SDO_COMPENSATION_BHS_ADJ_OFF |
+		SDO_COMPENSATION_CVBS_COMP_OFF);
+	sdo_reg_debug(sdev);
+
+	dev_info(dev, "poweron succeed\n");
+
+	return 0;
+}
+
+static int sdo_poweroff(struct sdo_device *sdev)
+{
+	struct device *dev = sdev->dev;
+
+	pm_runtime_put_sync(dev);
+	regulator_disable(sdev->vdet);
+	regulator_disable(sdev->vdac);
+	clk_disable(sdev->dac);
+	clk_disable(sdev->sclk_dac);
+	dev_info(dev, "poweroff succeed\n");
+
+	return 0;
+}
+
+static int sdo_s_power(struct v4l2_subdev *sd, int on)
+{
+	struct sdo_device *sdev = sd_to_sdev(sd);
+	if (on)
+		return sdo_poweron(sdev);
+	else
+		return sdo_poweroff(sdev);
+}
+
+static int sdo_streamon(struct sdo_device *sdev)
+{
+	/* set proper clock for Timing Generator */
+	clk_set_rate(sdev->fout_vpll, 54000000);
+	dev_info(sdev->dev, "fout_vpll.rate = %lu\n",
+		clk_get_rate(sdev->fout_vpll));
+	/* enable clock in SDO */
+	sdo_write_mask(sdev, SDO_CLKCON, ~0, SDO_TVOUT_CLOCK_ON);
+	clk_enable(sdev->dacphy);
+	/* enable DAC */
+	sdo_write_mask(sdev, SDO_DAC, ~0, SDO_POWER_ON_DAC);
+	sdo_reg_debug(sdev);
+	return 0;
+}
+
+static int sdo_streamoff(struct sdo_device *sdev)
+{
+	int tries;
+
+	sdo_write_mask(sdev, SDO_DAC, 0, SDO_POWER_ON_DAC);
+	clk_disable(sdev->dacphy);
+	sdo_write_mask(sdev, SDO_CLKCON, 0, SDO_TVOUT_CLOCK_ON);
+	for (tries = 100; tries; --tries) {
+		if (sdo_read(sdev, SDO_CLKCON) & SDO_TVOUT_CLOCK_READY)
+			break;
+		mdelay(1);
+	}
+	if (tries == 0)
+		dev_err(sdev->dev, "failed to stop streaming\n");
+	return tries ? 0 : -EIO;
+}
+
+static int sdo_s_stream(struct v4l2_subdev *sd, int on)
+{
+	struct sdo_device *sdev = sd_to_sdev(sd);
+	if (on)
+		return sdo_streamon(sdev);
+	else
+		return sdo_streamoff(sdev);
+}
+
+static const struct sdo_format *sdo_find_format(v4l2_std_id id)
+{
+	int i;
+	for (i = 0; i < ARRAY_SIZE(sdo_format); ++i)
+		if (sdo_format[i].id & id)
+			return &sdo_format[i];
+	return NULL;
+}
+
+static void sdo_reg_debug(struct sdo_device *sdev)
+{
+#define DBGREG(reg_id) \
+	dev_info(sdev->dev, #reg_id " = %08x\n", \
+		sdo_read(sdev, reg_id))
+
+	DBGREG(SDO_CLKCON);
+	DBGREG(SDO_CONFIG);
+	DBGREG(SDO_SCALE);
+	DBGREG(SDO_SYNC);
+	DBGREG(SDO_VBI);
+	DBGREG(SDO_SCALE_CH0);
+	DBGREG(SDO_SCALE_CH1);
+	DBGREG(SDO_SCALE_CH2);
+	DBGREG(SDO_YCDELAY);
+	DBGREG(SDO_SCHLOCK);
+	DBGREG(SDO_DAC);
+	DBGREG(SDO_FINFO);
+	DBGREG(SDO_CCCON);
+	DBGREG(SDO_YSCALE);
+	DBGREG(SDO_CBSCALE);
+	DBGREG(SDO_CRSCALE);
+	DBGREG(SDO_CB_CR_OFFSET);
+	DBGREG(SDO_CVBS_CC_Y1);
+	DBGREG(SDO_CVBS_CC_Y2);
+	DBGREG(SDO_CVBS_CC_C);
+	DBGREG(SDO_CSC_525_PORCH);
+	DBGREG(SDO_CSC_625_PORCH);
+	DBGREG(SDO_XTALK0);
+	DBGREG(SDO_XTALK1);
+	DBGREG(SDO_XTALK2);
+	DBGREG(SDO_BB_CTRL);
+	DBGREG(SDO_IRQ);
+	DBGREG(SDO_IRQMASK);
+	DBGREG(SDO_ARMCC);
+	DBGREG(SDO_ARMWSS525);
+	DBGREG(SDO_ARMWSS625);
+	DBGREG(SDO_ARMCGMS525);
+	DBGREG(SDO_ARMCGMS625);
+	DBGREG(SDO_VERSION);
+	DBGREG(SDO_CC);
+	DBGREG(SDO_WSS525);
+	DBGREG(SDO_WSS625);
+	DBGREG(SDO_CGMS525);
+	DBGREG(SDO_CGMS625);
+}
-- 
1.7.4.3
