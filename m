Return-path: <mchehab@pedra>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:30330 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755982Ab1F2MwE (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 29 Jun 2011 08:52:04 -0400
Received: from eu_spt1 (mailout2.w1.samsung.com [210.118.77.12])
 by mailout2.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0LNJ009BTYEGZV@mailout2.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 29 Jun 2011 13:51:55 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt1.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LNJ00LHWYEF4Q@spt1.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 29 Jun 2011 13:51:52 +0100 (BST)
Date: Wed, 29 Jun 2011 14:51:15 +0200
From: Tomasz Stanislawski <t.stanislaws@samsung.com>
Subject: [PATCH 6/8] v4l: s5p-tv: add drivers for HDMI on Samsung S5P platform
In-reply-to: <1309351877-32444-1-git-send-email-t.stanislaws@samsung.com>
To: linux-media@vger.kernel.org
Cc: m.szyprowski@samsung.com, t.stanislaws@samsung.com,
	kyungmin.park@samsung.com, hverkuil@xs4all.nl,
	laurent.pinchart@ideasonboard.com
Message-id: <1309351877-32444-7-git-send-email-t.stanislaws@samsung.com>
MIME-version: 1.0
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
References: <1309351877-32444-1-git-send-email-t.stanislaws@samsung.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Add drivers for HDMI outputs on Samsung platforms from S5P family.
- HDMIPHY - auxiliary I2C driver need by HDMI driver
- HDMI    - generation and control of streaming by HDMI output

Drivers are using:
- v4l2 framework
- runtime PM

Signed-off-by: Tomasz Stanislawski <t.stanislaws@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
Reviewed-by: Marek Szyprowski <m.szyprowski@samsung.com>
Reviewed-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Reviewed-by: Hans Verkuil <hverkuil@xs4all.nl>
---
 drivers/media/video/Kconfig              |    2 +
 drivers/media/video/Makefile             |    1 +
 drivers/media/video/s5p-tv/Kconfig       |   49 ++
 drivers/media/video/s5p-tv/Makefile      |   13 +
 drivers/media/video/s5p-tv/hdmi_drv.c    | 1043 ++++++++++++++++++++++++++++++
 drivers/media/video/s5p-tv/hdmiphy_drv.c |  196 ++++++
 drivers/media/video/s5p-tv/regs-hdmi.h   |  141 ++++
 7 files changed, 1445 insertions(+), 0 deletions(-)
 create mode 100644 drivers/media/video/s5p-tv/Kconfig
 create mode 100644 drivers/media/video/s5p-tv/Makefile
 create mode 100644 drivers/media/video/s5p-tv/hdmi_drv.c
 create mode 100644 drivers/media/video/s5p-tv/hdmiphy_drv.c
 create mode 100644 drivers/media/video/s5p-tv/regs-hdmi.h

diff --git a/drivers/media/video/Kconfig b/drivers/media/video/Kconfig
index 4847c2c..97a563f 100644
--- a/drivers/media/video/Kconfig
+++ b/drivers/media/video/Kconfig
@@ -954,6 +954,8 @@ config VIDEO_S5P_MIPI_CSIS
 	  To compile this driver as a module, choose M here: the
 	  module will be called s5p-csis.
 
+source "drivers/media/video/s5p-tv/Kconfig"
+
 #
 # USB Multimedia device configuration
 #
diff --git a/drivers/media/video/Makefile b/drivers/media/video/Makefile
index 89478f0..13c1082e 100644
--- a/drivers/media/video/Makefile
+++ b/drivers/media/video/Makefile
@@ -169,6 +169,7 @@ obj-$(CONFIG_VIDEO_SH_MOBILE_CEU)	+= sh_mobile_ceu_camera.o
 obj-$(CONFIG_VIDEO_OMAP1)		+= omap1_camera.o
 
 obj-$(CONFIG_VIDEO_SAMSUNG_S5P_FIMC) 	+= s5p-fimc/
+obj-$(CONFIG_VIDEO_SAMSUNG_S5P_TV)	+= s5p-tv/
 
 obj-$(CONFIG_ARCH_DAVINCI)		+= davinci/
 
diff --git a/drivers/media/video/s5p-tv/Kconfig b/drivers/media/video/s5p-tv/Kconfig
new file mode 100644
index 0000000..893be5b
--- /dev/null
+++ b/drivers/media/video/s5p-tv/Kconfig
@@ -0,0 +1,49 @@
+# drivers/media/video/s5p-tv/Kconfig
+#
+# Copyright (c) 2010-2011 Samsung Electronics Co., Ltd.
+#	http://www.samsung.com/
+# Tomasz Stanislawski <t.stanislaws@samsung.com>
+#
+# Licensed under GPL
+
+config VIDEO_SAMSUNG_S5P_TV
+	bool "Samsung TV driver for S5P platform (experimental)"
+	depends on PLAT_S5P
+	depends on EXPERIMENTAL
+	default n
+	---help---
+	  Say Y here to enable selecting the TV output devices for
+	  Samsung S5P platform.
+
+if VIDEO_SAMSUNG_S5P_TV
+
+config VIDEO_SAMSUNG_S5P_HDMI
+	tristate "Samsung HDMI Driver"
+	depends on VIDEO_V4L2
+	depends on VIDEO_SAMSUNG_S5P_TV
+	select VIDEO_SAMSUNG_S5P_HDMIPHY
+	help
+	  Say Y here if you want support for the HDMI output
+	  interface in S5P Samsung SoC. The driver can be compiled
+	  as module. It is an auxiliary driver, that exposes a V4L2
+	  subdev for use by other drivers. This driver requires
+	  hdmiphy driver to work correctly.
+
+config VIDEO_SAMSUNG_S5P_HDMI_DEBUG
+	bool "Enable debug for HDMI Driver"
+	depends on VIDEO_SAMSUNG_S5P_HDMI
+	default n
+	help
+	  Enables debugging for HDMI driver.
+
+config VIDEO_SAMSUNG_S5P_HDMIPHY
+	tristate "Samsung HDMIPHY Driver"
+	depends on VIDEO_DEV && VIDEO_V4L2 && I2C
+	depends on VIDEO_SAMSUNG_S5P_TV
+	help
+	  Say Y here if you want support for the physical HDMI
+	  interface in S5P Samsung SoC. The driver can be compiled
+	  as module. It is an I2C driver, that exposes a V4L2
+	  subdev for use by other drivers.
+
+endif # VIDEO_SAMSUNG_S5P_TV
diff --git a/drivers/media/video/s5p-tv/Makefile b/drivers/media/video/s5p-tv/Makefile
new file mode 100644
index 0000000..1b07132
--- /dev/null
+++ b/drivers/media/video/s5p-tv/Makefile
@@ -0,0 +1,13 @@
+# drivers/media/video/samsung/tvout/Makefile
+#
+# Copyright (c) 2010-2011 Samsung Electronics Co., Ltd.
+#	http://www.samsung.com/
+# Tomasz Stanislawski <t.stanislaws@samsung.com>
+#
+# Licensed under GPL
+
+obj-$(CONFIG_VIDEO_SAMSUNG_S5P_HDMIPHY) += s5p-hdmiphy.o
+s5p-hdmiphy-y += hdmiphy_drv.o
+obj-$(CONFIG_VIDEO_SAMSUNG_S5P_HDMI) += s5p-hdmi.o
+s5p-hdmi-y += hdmi_drv.o
+
diff --git a/drivers/media/video/s5p-tv/hdmi_drv.c b/drivers/media/video/s5p-tv/hdmi_drv.c
new file mode 100644
index 0000000..e40dd4d
--- /dev/null
+++ b/drivers/media/video/s5p-tv/hdmi_drv.c
@@ -0,0 +1,1043 @@
+/*
+ * Samsung HDMI interface driver
+ *
+ * Copyright (c) 2010-2011 Samsung Electronics Co., Ltd.
+ *
+ * Tomasz Stanislawski, <t.stanislaws@samsung.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published
+ * by the Free Software Foundiation. either version 2 of the License,
+ * or (at your option) any later version
+ */
+
+#ifdef CONFIG_VIDEO_SAMSUNG_S5P_HDMI_DEBUG
+#define DEBUG
+#endif
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
+MODULE_AUTHOR("Tomasz Stanislawski, <t.stanislaws@samsung.com>");
+MODULE_DESCRIPTION("Samsung HDMI");
+MODULE_LICENSE("GPL");
+
+/* default preset configured on probe */
+#define HDMI_DEFAULT_PRESET V4L2_DV_1080P60
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
+	struct v4l2_device v4l2_dev;
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
+struct hdmi_driver_data {
+	int hdmiphy_bus;
+};
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
+	struct hdmi_tg_regs tg;
+	struct v4l2_mbus_framefmt mbus_fmt;
+};
+
+/* I2C module and id for HDMIPHY */
+static struct i2c_board_info hdmiphy_info = {
+	I2C_BOARD_INFO("hdmiphy", 0x38),
+};
+
+static struct hdmi_driver_data hdmi_driver_data[] = {
+	{ .hdmiphy_bus = 3 },
+	{ .hdmiphy_bus = 8 },
+};
+
+static struct platform_device_id hdmi_driver_types[] = {
+	{
+		.name		= "s5pv210-hdmi",
+		.driver_data	= (unsigned long)&hdmi_driver_data[0],
+	}, {
+		.name		= "exynos4-hdmi",
+		.driver_data	= (unsigned long)&hdmi_driver_data[1],
+	}, {
+		/* end node */
+	}
+};
+
+static const struct v4l2_subdev_ops hdmi_sd_ops;
+
+static struct hdmi_device *sd_to_hdmi_dev(struct v4l2_subdev *sd)
+{
+	return container_of(sd, struct hdmi_device, sd);
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
+
+	(void)irq;
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
+static void hdmi_reg_init(struct hdmi_device *hdev)
+{
+	/* enable HPD interrupts */
+	hdmi_write_mask(hdev, HDMI_INTC_CON, ~0, HDMI_INTC_EN_GLOBAL |
+		HDMI_INTC_EN_HPD_PLUG | HDMI_INTC_EN_HPD_UNPLUG);
+	/* choose HDMI mode */
+	hdmi_write_mask(hdev, HDMI_MODE_SEL,
+		HDMI_MODE_HDMI_EN, HDMI_MODE_MASK);
+	/* disable bluescreen */
+	hdmi_write_mask(hdev, HDMI_CON_0, 0, HDMI_BLUE_SCR_EN);
+	/* choose bluescreen (fecal) color */
+	hdmi_writeb(hdev, HDMI_BLUE_SCREEN_0, 0x12);
+	hdmi_writeb(hdev, HDMI_BLUE_SCREEN_1, 0x34);
+	hdmi_writeb(hdev, HDMI_BLUE_SCREEN_2, 0x56);
+	/* enable AVI packet every vsync, fixes purple line problem */
+	hdmi_writeb(hdev, HDMI_AVI_CON, 0x02);
+	/* force YUV444, look to CEA-861-D, table 7 for more detail */
+	hdmi_writeb(hdev, HDMI_AVI_BYTE(0), 2 << 5);
+	hdmi_write_mask(hdev, HDMI_CON_1, 2, 3 << 5);
+}
+
+static void hdmi_timing_apply(struct hdmi_device *hdev,
+	const struct hdmi_preset_conf *conf)
+{
+	const struct hdmi_core_regs *core = &conf->core;
+	const struct hdmi_tg_regs *tg = &conf->tg;
+
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
+static int hdmi_conf_apply(struct hdmi_device *hdmi_dev)
+{
+	struct device *dev = hdmi_dev->dev;
+	const struct hdmi_preset_conf *conf = hdmi_dev->cur_conf;
+	struct v4l2_dv_preset preset;
+	int ret;
+
+	dev_dbg(dev, "%s\n", __func__);
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
+	/* setting core registers */
+	hdmi_timing_apply(hdmi_dev, conf);
+
+	return 0;
+}
+
+static void hdmi_dumpregs(struct hdmi_device *hdev, char *prefix)
+{
+#define DUMPREG(reg_id) \
+	dev_dbg(hdev->dev, "%s:" #reg_id " = %08x\n", prefix, \
+		readl(hdev->regs + reg_id))
+
+	dev_dbg(hdev->dev, "%s: ---- CONTROL REGISTERS ----\n", prefix);
+	DUMPREG(HDMI_INTC_FLAG);
+	DUMPREG(HDMI_INTC_CON);
+	DUMPREG(HDMI_HPD_STATUS);
+	DUMPREG(HDMI_PHY_RSTOUT);
+	DUMPREG(HDMI_PHY_VPLL);
+	DUMPREG(HDMI_PHY_CMU);
+	DUMPREG(HDMI_CORE_RSTOUT);
+
+	dev_dbg(hdev->dev, "%s: ---- CORE REGISTERS ----\n", prefix);
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
+	dev_dbg(hdev->dev, "%s: ---- CORE SYNC REGISTERS ----\n", prefix);
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
+	dev_dbg(hdev->dev, "%s: ---- TG REGISTERS ----\n", prefix);
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
+
+	for (i = 0; i < ARRAY_SIZE(hdmi_conf); ++i)
+		if (hdmi_conf[i].preset == preset)
+			return  hdmi_conf[i].conf;
+	return NULL;
+}
+
+static int hdmi_streamon(struct hdmi_device *hdev)
+{
+	struct device *dev = hdev->dev;
+	struct hdmi_resources *res = &hdev->res;
+	int ret, tries;
+
+	dev_dbg(dev, "%s\n", __func__);
+
+	ret = v4l2_subdev_call(hdev->phy_sd, video, s_stream, 1);
+	if (ret)
+		return ret;
+
+	/* waiting for HDMIPHY's PLL to get to steady state */
+	for (tries = 100; tries; --tries) {
+		u32 val = hdmi_read(hdev, HDMI_PHY_STATUS);
+		if (val & HDMI_PHY_STATUS_READY)
+			break;
+		mdelay(1);
+	}
+	/* steady state not achieved */
+	if (tries == 0) {
+		dev_err(dev, "hdmiphy's pll could not reach steady state.\n");
+		v4l2_subdev_call(hdev->phy_sd, video, s_stream, 0);
+		hdmi_dumpregs(hdev, "s_stream");
+		return -EIO;
+	}
+
+	/* hdmiphy clock is used for HDMI in streaming mode */
+	clk_disable(res->sclk_hdmi);
+	clk_set_parent(res->sclk_hdmi, res->sclk_hdmiphy);
+	clk_enable(res->sclk_hdmi);
+
+	/* enable HDMI and timing generator */
+	hdmi_write_mask(hdev, HDMI_CON_0, ~0, HDMI_EN);
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
+	dev_dbg(dev, "%s\n", __func__);
+
+	hdmi_write_mask(hdev, HDMI_CON_0, 0, HDMI_EN);
+	hdmi_write_mask(hdev, HDMI_TG_CMD, 0, HDMI_TG_EN);
+
+	/* pixel(vpll) clock is used for HDMI in config mode */
+	clk_disable(res->sclk_hdmi);
+	clk_set_parent(res->sclk_hdmi, res->sclk_pixel);
+	clk_enable(res->sclk_hdmi);
+
+	v4l2_subdev_call(hdev->phy_sd, video, s_stream, 0);
+
+	hdmi_dumpregs(hdev, "streamoff");
+	return 0;
+}
+
+static int hdmi_s_stream(struct v4l2_subdev *sd, int enable)
+{
+	struct hdmi_device *hdev = sd_to_hdmi_dev(sd);
+	struct device *dev = hdev->dev;
+
+	dev_dbg(dev, "%s(%d)\n", __func__, enable);
+	if (enable)
+		return hdmi_streamon(hdev);
+	return hdmi_streamoff(hdev);
+}
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
+	clk_enable(res->sclk_hdmi);
+}
+
+static void hdmi_resource_poweroff(struct hdmi_resources *res)
+{
+	/* turn clocks off */
+	clk_disable(res->sclk_hdmi);
+	/* power-off hdmiphy */
+	clk_disable(res->hdmiphy);
+	/* turn HDMI power off */
+	regulator_bulk_disable(res->regul_count, res->regul_bulk);
+}
+
+static int hdmi_s_power(struct v4l2_subdev *sd, int on)
+{
+	struct hdmi_device *hdev = sd_to_hdmi_dev(sd);
+	int ret;
+
+	if (on)
+		ret = pm_runtime_get_sync(hdev->dev);
+	else
+		ret = pm_runtime_put_sync(hdev->dev);
+	/* only values < 0 indicate errors */
+	return IS_ERR_VALUE(ret) ? ret : 0;
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
+		return -EINVAL;
+	}
+	hdev->cur_conf = conf;
+	hdev->cur_preset = preset->preset;
+	return 0;
+}
+
+static int hdmi_g_dv_preset(struct v4l2_subdev *sd,
+	struct v4l2_dv_preset *preset)
+{
+	memset(preset, 0, sizeof(*preset));
+	preset->preset = sd_to_hdmi_dev(sd)->cur_preset;
+	return 0;
+}
+
+static int hdmi_g_mbus_fmt(struct v4l2_subdev *sd,
+	  struct v4l2_mbus_framefmt *fmt)
+{
+	struct hdmi_device *hdev = sd_to_hdmi_dev(sd);
+	struct device *dev = hdev->dev;
+
+	dev_dbg(dev, "%s\n", __func__);
+	if (!hdev->cur_conf)
+		return -EINVAL;
+	*fmt = hdev->cur_conf->mbus_fmt;
+	return 0;
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
+static const struct v4l2_subdev_core_ops hdmi_sd_core_ops = {
+	.s_power = hdmi_s_power,
+};
+
+static const struct v4l2_subdev_video_ops hdmi_sd_video_ops = {
+	.s_dv_preset = hdmi_s_dv_preset,
+	.g_dv_preset = hdmi_g_dv_preset,
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
+static int hdmi_runtime_suspend(struct device *dev)
+{
+	struct v4l2_subdev *sd = dev_get_drvdata(dev);
+	struct hdmi_device *hdev = sd_to_hdmi_dev(sd);
+
+	dev_dbg(dev, "%s\n", __func__);
+	hdmi_resource_poweroff(&hdev->res);
+	return 0;
+}
+
+static int hdmi_runtime_resume(struct device *dev)
+{
+	struct v4l2_subdev *sd = dev_get_drvdata(dev);
+	struct hdmi_device *hdev = sd_to_hdmi_dev(sd);
+	int ret = 0;
+
+	dev_dbg(dev, "%s\n", __func__);
+
+	hdmi_resource_poweron(&hdev->res);
+
+	ret = hdmi_conf_apply(hdev);
+	if (ret)
+		goto fail;
+
+	dev_dbg(dev, "poweron succeed\n");
+
+	return 0;
+
+fail:
+	hdmi_resource_poweroff(&hdev->res);
+	dev_err(dev, "poweron failed\n");
+
+	return ret;
+}
+
+static const struct dev_pm_ops hdmi_pm_ops = {
+	.runtime_suspend = hdmi_runtime_suspend,
+	.runtime_resume	 = hdmi_runtime_resume,
+};
+
+static void hdmi_resources_cleanup(struct hdmi_device *hdev)
+{
+	struct hdmi_resources *res = &hdev->res;
+
+	dev_dbg(hdev->dev, "HDMI resource cleanup\n");
+	/* put clocks, power */
+	if (res->regul_count)
+		regulator_bulk_free(res->regul_count, res->regul_bulk);
+	/* kfree is NULL-safe */
+	kfree(res->regul_bulk);
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
+	dev_dbg(dev, "HDMI resource init\n");
+
+	memset(res, 0, sizeof *res);
+	/* get clocks, power */
+
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
+		sizeof res->regul_bulk[0], GFP_KERNEL);
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
+static int __devinit hdmi_probe(struct platform_device *pdev)
+{
+	struct device *dev = &pdev->dev;
+	struct resource *res;
+	struct i2c_adapter *phy_adapter;
+	struct v4l2_subdev *sd;
+	struct hdmi_device *hdmi_dev = NULL;
+	struct hdmi_driver_data *drv_data;
+	int ret;
+
+	dev_dbg(dev, "probe start\n");
+
+	hdmi_dev = kzalloc(sizeof(*hdmi_dev), GFP_KERNEL);
+	if (!hdmi_dev) {
+		dev_err(dev, "out of memory\n");
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
+	hdmi_dev->regs = ioremap(res->start, resource_size(res));
+	if (hdmi_dev->regs == NULL) {
+		dev_err(dev, "register mapping failed.\n");
+		ret = -ENXIO;
+		goto fail_hdev;
+	}
+
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
+	/* setting v4l2 name to prevent WARN_ON in v4l2_device_register */
+	strlcpy(hdmi_dev->v4l2_dev.name, dev_name(dev),
+		sizeof(hdmi_dev->v4l2_dev.name));
+	/* passing NULL owner prevents driver from erasing drvdata */
+	ret = v4l2_device_register(NULL, &hdmi_dev->v4l2_dev);
+	if (ret) {
+		dev_err(dev, "could not register v4l2 device.\n");
+		goto fail_irq;
+	}
+
+	drv_data = (struct hdmi_driver_data *)
+		platform_get_device_id(pdev)->driver_data;
+	phy_adapter = i2c_get_adapter(drv_data->hdmiphy_bus);
+	if (phy_adapter == NULL) {
+		dev_err(dev, "adapter request failed\n");
+		ret = -ENXIO;
+		goto fail_vdev;
+	}
+
+	hdmi_dev->phy_sd = v4l2_i2c_new_subdev_board(&hdmi_dev->v4l2_dev,
+		phy_adapter, &hdmiphy_info, NULL);
+	/* on failure or not adapter is no longer useful */
+	i2c_put_adapter(phy_adapter);
+	if (hdmi_dev->phy_sd == NULL) {
+		dev_err(dev, "missing subdev for hdmiphy\n");
+		ret = -ENODEV;
+		goto fail_vdev;
+	}
+
+	clk_enable(hdmi_dev->res.hdmi);
+
+	pm_runtime_enable(dev);
+
+	sd = &hdmi_dev->sd;
+	v4l2_subdev_init(sd, &hdmi_sd_ops);
+	sd->owner = THIS_MODULE;
+
+	strlcpy(sd->name, "s5p-hdmi", sizeof sd->name);
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
+	v4l2_device_unregister(&hdmi_dev->v4l2_dev);
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
+	dev_err(dev, "probe failed\n");
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
+	clk_disable(hdmi_dev->res.hdmi);
+	v4l2_device_unregister(&hdmi_dev->v4l2_dev);
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
+static struct platform_driver hdmi_driver __refdata = {
+	.probe = hdmi_probe,
+	.remove = __devexit_p(hdmi_remove),
+	.id_table = hdmi_driver_types,
+	.driver = {
+		.name = "s5p-hdmi",
+		.owner = THIS_MODULE,
+		.pm = &hdmi_pm_ops,
+	}
+};
+
+/* D R I V E R   I N I T I A L I Z A T I O N */
+
+static int __init hdmi_init(void)
+{
+	int ret;
+	static const char banner[] __initdata = KERN_INFO \
+		"Samsung HDMI output driver, "
+		"(c) 2010-2011 Samsung Electronics Co., Ltd.\n";
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
+
diff --git a/drivers/media/video/s5p-tv/hdmiphy_drv.c b/drivers/media/video/s5p-tv/hdmiphy_drv.c
new file mode 100644
index 0000000..da5b684
--- /dev/null
+++ b/drivers/media/video/s5p-tv/hdmiphy_drv.c
@@ -0,0 +1,196 @@
+/*
+ * Samsung HDMI Physical interface driver
+ *
+ * Copyright (C) 2010-2011 Samsung Electronics Co.Ltd
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
+MODULE_AUTHOR("Tomasz Stanislawski <t.stanislaws@samsung.com>");
+MODULE_DESCRIPTION("Samsung HDMI Physical interface driver");
+MODULE_LICENSE("GPL");
+
+struct hdmiphy_conf {
+	u32 preset;
+	const u8 *data;
+};
+
+static const u8 hdmiphy_conf27[32] = {
+	0x01, 0x05, 0x00, 0xD8, 0x10, 0x1C, 0x30, 0x40,
+	0x6B, 0x10, 0x02, 0x51, 0xDf, 0xF2, 0x54, 0x87,
+	0x84, 0x00, 0x30, 0x38, 0x00, 0x08, 0x10, 0xE0,
+	0x22, 0x40, 0xe3, 0x26, 0x00, 0x00, 0x00, 0x00,
+};
+
+static const u8 hdmiphy_conf74_175[32] = {
+	0x01, 0x05, 0x00, 0xD8, 0x10, 0x9C, 0xef, 0x5B,
+	0x6D, 0x10, 0x01, 0x51, 0xef, 0xF3, 0x54, 0xb9,
+	0x84, 0x00, 0x30, 0x38, 0x00, 0x08, 0x10, 0xE0,
+	0x22, 0x40, 0xa5, 0x26, 0x01, 0x00, 0x00, 0x00,
+};
+
+static const u8 hdmiphy_conf74_25[32] = {
+	0x01, 0x05, 0x00, 0xd8, 0x10, 0x9c, 0xf8, 0x40,
+	0x6a, 0x10, 0x01, 0x51, 0xff, 0xf1, 0x54, 0xba,
+	0x84, 0x00, 0x30, 0x38, 0x00, 0x08, 0x10, 0xe0,
+	0x22, 0x40, 0xa4, 0x26, 0x01, 0x00, 0x00, 0x00,
+};
+
+static const u8 hdmiphy_conf148_5[32] = {
+	0x01, 0x05, 0x00, 0xD8, 0x10, 0x9C, 0xf8, 0x40,
+	0x6A, 0x18, 0x00, 0x51, 0xff, 0xF1, 0x54, 0xba,
+	0x84, 0x00, 0x10, 0x38, 0x00, 0x08, 0x10, 0xE0,
+	0x22, 0x40, 0xa4, 0x26, 0x02, 0x00, 0x00, 0x00,
+};
+
+static const u8 hdmiphy_conf148_35[32] = {
+	0x01, 0x05, 0x00, 0xD8, 0x10, 0x9C, 0xef, 0x5B,
+	0x6D, 0x18, 0x00, 0x51, 0xef, 0xF3, 0x54, 0xb9,
+	0x84, 0x00, 0x30, 0x38, 0x00, 0x08, 0x10, 0xE0,
+	0x22, 0x40, 0xa5, 0x26, 0x02, 0x00, 0x00, 0x00,
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
+};
+
+const u8 *hdmiphy_preset2conf(u32 preset)
+{
+	int i;
+	for (i = 0; i < ARRAY_SIZE(hdmiphy_conf); ++i)
+		if (hdmiphy_conf[i].preset == preset)
+			return hdmiphy_conf[i].data;
+	return NULL;
+}
+
+static int hdmiphy_s_power(struct v4l2_subdev *sd, int on)
+{
+	/* to be implemented */
+	return 0;
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
+
+	dev_info(dev, "s_dv_preset(preset = %d)\n", preset->preset);
+	data = hdmiphy_preset2conf(preset->preset);
+	if (!data) {
+		dev_err(dev, "format not supported\n");
+		return -EINVAL;
+	}
+
+	/* storing configuration to the device */
+	memcpy(buffer, data, 32);
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
+
+	dev_info(dev, "s_stream(%d)\n", enable);
+	/* going to/from configuration from/to operation mode */
+	buffer[0] = 0x1f;
+	buffer[1] = enable ? 0x80 : 0x00;
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
+static int __devinit hdmiphy_probe(struct i2c_client *client,
+	const struct i2c_device_id *id)
+{
+	static struct v4l2_subdev sd;
+
+	v4l2_i2c_subdev_init(&sd, client, &hdmiphy_ops);
+	dev_info(&client->dev, "probe successful\n");
+	return 0;
+}
+
+static int __devexit hdmiphy_remove(struct i2c_client *client)
+{
+	dev_info(&client->dev, "remove successful\n");
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
diff --git a/drivers/media/video/s5p-tv/regs-hdmi.h b/drivers/media/video/s5p-tv/regs-hdmi.h
new file mode 100644
index 0000000..ac93ad6
--- /dev/null
+++ b/drivers/media/video/s5p-tv/regs-hdmi.h
@@ -0,0 +1,141 @@
+/* linux/arch/arm/mach-exynos4/include/mach/regs-hdmi.h
+ *
+ * Copyright (c) 2010-2011 Samsung Electronics Co., Ltd.
+ * http://www.samsung.com/
+ *
+ * HDMI register header file for Samsung TVOUT driver
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+*/
+
+#ifndef SAMSUNG_REGS_HDMI_H
+#define SAMSUNG_REGS_HDMI_H
+
+/*
+ * Register part
+*/
+
+#define HDMI_CTRL_BASE(x)		((x) + 0x00000000)
+#define HDMI_CORE_BASE(x)		((x) + 0x00010000)
+#define HDMI_TG_BASE(x)			((x) + 0x00050000)
+
+/* Control registers */
+#define HDMI_INTC_CON			HDMI_CTRL_BASE(0x0000)
+#define HDMI_INTC_FLAG			HDMI_CTRL_BASE(0x0004)
+#define HDMI_HPD_STATUS			HDMI_CTRL_BASE(0x000C)
+#define HDMI_PHY_RSTOUT			HDMI_CTRL_BASE(0x0014)
+#define HDMI_PHY_VPLL			HDMI_CTRL_BASE(0x0018)
+#define HDMI_PHY_CMU			HDMI_CTRL_BASE(0x001C)
+#define HDMI_CORE_RSTOUT		HDMI_CTRL_BASE(0x0020)
+
+/* Core registers */
+#define HDMI_CON_0			HDMI_CORE_BASE(0x0000)
+#define HDMI_CON_1			HDMI_CORE_BASE(0x0004)
+#define HDMI_CON_2			HDMI_CORE_BASE(0x0008)
+#define HDMI_SYS_STATUS			HDMI_CORE_BASE(0x0010)
+#define HDMI_PHY_STATUS			HDMI_CORE_BASE(0x0014)
+#define HDMI_STATUS_EN			HDMI_CORE_BASE(0x0020)
+#define HDMI_HPD			HDMI_CORE_BASE(0x0030)
+#define HDMI_MODE_SEL			HDMI_CORE_BASE(0x0040)
+#define HDMI_BLUE_SCREEN_0		HDMI_CORE_BASE(0x0050)
+#define HDMI_BLUE_SCREEN_1		HDMI_CORE_BASE(0x0054)
+#define HDMI_BLUE_SCREEN_2		HDMI_CORE_BASE(0x0058)
+#define HDMI_H_BLANK_0			HDMI_CORE_BASE(0x00A0)
+#define HDMI_H_BLANK_1			HDMI_CORE_BASE(0x00A4)
+#define HDMI_V_BLANK_0			HDMI_CORE_BASE(0x00B0)
+#define HDMI_V_BLANK_1			HDMI_CORE_BASE(0x00B4)
+#define HDMI_V_BLANK_2			HDMI_CORE_BASE(0x00B8)
+#define HDMI_H_V_LINE_0			HDMI_CORE_BASE(0x00C0)
+#define HDMI_H_V_LINE_1			HDMI_CORE_BASE(0x00C4)
+#define HDMI_H_V_LINE_2			HDMI_CORE_BASE(0x00C8)
+#define HDMI_VSYNC_POL			HDMI_CORE_BASE(0x00E4)
+#define HDMI_INT_PRO_MODE		HDMI_CORE_BASE(0x00E8)
+#define HDMI_V_BLANK_F_0		HDMI_CORE_BASE(0x0110)
+#define HDMI_V_BLANK_F_1		HDMI_CORE_BASE(0x0114)
+#define HDMI_V_BLANK_F_2		HDMI_CORE_BASE(0x0118)
+#define HDMI_H_SYNC_GEN_0		HDMI_CORE_BASE(0x0120)
+#define HDMI_H_SYNC_GEN_1		HDMI_CORE_BASE(0x0124)
+#define HDMI_H_SYNC_GEN_2		HDMI_CORE_BASE(0x0128)
+#define HDMI_V_SYNC_GEN_1_0		HDMI_CORE_BASE(0x0130)
+#define HDMI_V_SYNC_GEN_1_1		HDMI_CORE_BASE(0x0134)
+#define HDMI_V_SYNC_GEN_1_2		HDMI_CORE_BASE(0x0138)
+#define HDMI_V_SYNC_GEN_2_0		HDMI_CORE_BASE(0x0140)
+#define HDMI_V_SYNC_GEN_2_1		HDMI_CORE_BASE(0x0144)
+#define HDMI_V_SYNC_GEN_2_2		HDMI_CORE_BASE(0x0148)
+#define HDMI_V_SYNC_GEN_3_0		HDMI_CORE_BASE(0x0150)
+#define HDMI_V_SYNC_GEN_3_1		HDMI_CORE_BASE(0x0154)
+#define HDMI_V_SYNC_GEN_3_2		HDMI_CORE_BASE(0x0158)
+#define HDMI_AVI_CON			HDMI_CORE_BASE(0x0300)
+#define HDMI_AVI_BYTE(n)		HDMI_CORE_BASE(0x0320 + 4 * (n))
+#define	HDMI_DC_CONTROL			HDMI_CORE_BASE(0x05C0)
+#define HDMI_VIDEO_PATTERN_GEN		HDMI_CORE_BASE(0x05C4)
+#define HDMI_HPD_GEN			HDMI_CORE_BASE(0x05C8)
+
+/* Timing generator registers */
+#define HDMI_TG_CMD			HDMI_TG_BASE(0x0000)
+#define HDMI_TG_H_FSZ_L			HDMI_TG_BASE(0x0018)
+#define HDMI_TG_H_FSZ_H			HDMI_TG_BASE(0x001C)
+#define HDMI_TG_HACT_ST_L		HDMI_TG_BASE(0x0020)
+#define HDMI_TG_HACT_ST_H		HDMI_TG_BASE(0x0024)
+#define HDMI_TG_HACT_SZ_L		HDMI_TG_BASE(0x0028)
+#define HDMI_TG_HACT_SZ_H		HDMI_TG_BASE(0x002C)
+#define HDMI_TG_V_FSZ_L			HDMI_TG_BASE(0x0030)
+#define HDMI_TG_V_FSZ_H			HDMI_TG_BASE(0x0034)
+#define HDMI_TG_VSYNC_L			HDMI_TG_BASE(0x0038)
+#define HDMI_TG_VSYNC_H			HDMI_TG_BASE(0x003C)
+#define HDMI_TG_VSYNC2_L		HDMI_TG_BASE(0x0040)
+#define HDMI_TG_VSYNC2_H		HDMI_TG_BASE(0x0044)
+#define HDMI_TG_VACT_ST_L		HDMI_TG_BASE(0x0048)
+#define HDMI_TG_VACT_ST_H		HDMI_TG_BASE(0x004C)
+#define HDMI_TG_VACT_SZ_L		HDMI_TG_BASE(0x0050)
+#define HDMI_TG_VACT_SZ_H		HDMI_TG_BASE(0x0054)
+#define HDMI_TG_FIELD_CHG_L		HDMI_TG_BASE(0x0058)
+#define HDMI_TG_FIELD_CHG_H		HDMI_TG_BASE(0x005C)
+#define HDMI_TG_VACT_ST2_L		HDMI_TG_BASE(0x0060)
+#define HDMI_TG_VACT_ST2_H		HDMI_TG_BASE(0x0064)
+#define HDMI_TG_VSYNC_TOP_HDMI_L	HDMI_TG_BASE(0x0078)
+#define HDMI_TG_VSYNC_TOP_HDMI_H	HDMI_TG_BASE(0x007C)
+#define HDMI_TG_VSYNC_BOT_HDMI_L	HDMI_TG_BASE(0x0080)
+#define HDMI_TG_VSYNC_BOT_HDMI_H	HDMI_TG_BASE(0x0084)
+#define HDMI_TG_FIELD_TOP_HDMI_L	HDMI_TG_BASE(0x0088)
+#define HDMI_TG_FIELD_TOP_HDMI_H	HDMI_TG_BASE(0x008C)
+#define HDMI_TG_FIELD_BOT_HDMI_L	HDMI_TG_BASE(0x0090)
+#define HDMI_TG_FIELD_BOT_HDMI_H	HDMI_TG_BASE(0x0094)
+
+/*
+ * Bit definition part
+ */
+
+/* HDMI_INTC_CON */
+#define HDMI_INTC_EN_GLOBAL		(1 << 6)
+#define HDMI_INTC_EN_HPD_PLUG		(1 << 3)
+#define HDMI_INTC_EN_HPD_UNPLUG		(1 << 2)
+
+/* HDMI_INTC_FLAG */
+#define HDMI_INTC_FLAG_HPD_PLUG		(1 << 3)
+#define HDMI_INTC_FLAG_HPD_UNPLUG	(1 << 2)
+
+/* HDMI_PHY_RSTOUT */
+#define HDMI_PHY_SW_RSTOUT		(1 << 0)
+
+/* HDMI_CORE_RSTOUT */
+#define HDMI_CORE_SW_RSTOUT		(1 << 0)
+
+/* HDMI_CON_0 */
+#define HDMI_BLUE_SCR_EN		(1 << 5)
+#define HDMI_EN				(1 << 0)
+
+/* HDMI_PHY_STATUS */
+#define HDMI_PHY_STATUS_READY		(1 << 0)
+
+/* HDMI_MODE_SEL */
+#define HDMI_MODE_HDMI_EN		(1 << 1)
+#define HDMI_MODE_DVI_EN		(1 << 0)
+#define HDMI_MODE_MASK			(3 << 0)
+
+/* HDMI_TG_CMD */
+#define HDMI_TG_EN			(1 << 0)
+
+#endif /* SAMSUNG_REGS_HDMI_H */
-- 
1.7.5.4

