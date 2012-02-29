Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:16620 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755822Ab2B2LJY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 29 Feb 2012 06:09:24 -0500
Received: from epcpsbgm1.samsung.com (mailout2.samsung.com [203.254.224.25])
 by mailout2.samsung.com
 (Oracle Communications Messaging Exchange Server 7u4-19.01 64bit (built Sep  7
 2010)) with ESMTP id <0M050048LIZ0U0K0@mailout2.samsung.com> for
 linux-media@vger.kernel.org; Wed, 29 Feb 2012 20:09:22 +0900 (KST)
Received: from jtppark ([12.23.118.214])
 by mmp2.samsung.com (Oracle Communications Messaging Exchange Server 7u4-19.01
 64bit (built Sep  7 2010)) with ESMTPA id <0M05004BYIZHOJ60@mmp2.samsung.com>
 for linux-media@vger.kernel.org; Wed, 29 Feb 2012 20:09:21 +0900 (KST)
Reply-to: jiun.yu@samsung.com
From: Jiun Yu <jiun.yu@samsung.com>
To: linux-media@vger.kernel.org
Cc: t.stanislaws@samsung.com, younglak1004.kim@samsung.com,
	june.bae@samsung.com, a.sim@samsung.com, sy0816.kang@samsung.com,
	sungchun.kang@samsung.com, khw0178.kim@samsung.com
References: 
In-reply-to: 
Subject: [PATCH] media: s5p-tv: support tv driver on Samsung Exynos5250 SoC
Date: Wed, 29 Feb 2012 20:09:16 +0900
Message-id: <015001ccf6d2$9495c4b0$bdc14e10$%yu@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7bit
Content-language: ko
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Jiun Yu <jiun.yu@samsung.com>

HDMI Tx in Samsung Exynos5250 SoC supports hdmi v1.4a specification.
And the hdmiphy configuration values are changed.

This patch is for supporting mixer and HDMI Tx on Samsung Exynos5250 SoC

Signed-off-by: Jiun Yu <jiun.yu@samsung.com>
---
 drivers/media/video/s5p-tv/Makefile           |    7 +
 drivers/media/video/s5p-tv/hdmi.h             |  211 ++++
 drivers/media/video/s5p-tv/hdmi_drv.c         |  518 +----------
 drivers/media/video/s5p-tv/hdmi_reg_v13.c     |  413 ++++++++
 drivers/media/video/s5p-tv/hdmi_reg_v14.c     |  710 ++++++++++++++
 drivers/media/video/s5p-tv/hdmiphy_conf_v13.c |   52 +
 drivers/media/video/s5p-tv/hdmiphy_conf_v14.c |   52 +
 drivers/media/video/s5p-tv/hdmiphy_drv.c      |   45 +-
 drivers/media/video/s5p-tv/mixer_video.c      |    2 +-
 drivers/media/video/s5p-tv/regs-hdmi-v13.h    |  145 +++
 drivers/media/video/s5p-tv/regs-hdmi-v14.h    | 1273 +++++++++++++++++++++++++
 drivers/media/video/s5p-tv/regs-hdmi.h        |  145 ---
 12 files changed, 2880 insertions(+), 693 deletions(-)
 create mode 100644 drivers/media/video/s5p-tv/hdmi.h
 create mode 100644 drivers/media/video/s5p-tv/hdmi_reg_v13.c
 create mode 100644 drivers/media/video/s5p-tv/hdmi_reg_v14.c
 create mode 100644 drivers/media/video/s5p-tv/hdmiphy_conf_v13.c
 create mode 100644 drivers/media/video/s5p-tv/hdmiphy_conf_v14.c
 create mode 100644 drivers/media/video/s5p-tv/regs-hdmi-v13.h
 create mode 100644 drivers/media/video/s5p-tv/regs-hdmi-v14.h
 delete mode 100644 drivers/media/video/s5p-tv/regs-hdmi.h

diff --git a/drivers/media/video/s5p-tv/Makefile b/drivers/media/video/s5p-tv/Makefile
index 37e4c17..a93b0af 100644
--- a/drivers/media/video/s5p-tv/Makefile
+++ b/drivers/media/video/s5p-tv/Makefile
@@ -15,3 +15,10 @@ s5p-sdo-y += sdo_drv.o
 obj-$(CONFIG_VIDEO_SAMSUNG_S5P_MIXER) += s5p-mixer.o
 s5p-mixer-y += mixer_drv.o mixer_video.o mixer_reg.o mixer_grp_layer.o mixer_vp_layer.o
 
+ifeq ($(CONFIG_VIDEO_SAMSUNG_S5P_HDMI),y)
+	ifeq ($(CONFIG_CPU_EXYNOS4210), y)
+		s5p-hdmi-y += hdmi_reg_v13.o hdmiphy_conf_v13.o
+	else
+		s5p-hdmi-y += hdmi_reg_v14.o hdmiphy_conf_v14.o
+	endif
+endif
diff --git a/drivers/media/video/s5p-tv/hdmi.h b/drivers/media/video/s5p-tv/hdmi.h
new file mode 100644
index 0000000..0a4bd20
--- /dev/null
+++ b/drivers/media/video/s5p-tv/hdmi.h
@@ -0,0 +1,211 @@
+/*
+ * Samsung HDMI interface driver
+ *
+ * Copyright (c) 2010-2011 Samsung Electronics Co., Ltd.
+ *
+ * Jiun Yu, <jiun.yu@samsung.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published
+ * by the Free Software Foundiation. either version 2 of the License,
+ * or (at your option) any later version
+ */
+
+#ifndef SAMSUMG_HDMI_H
+#define SAMSUNG_HDMI_H
+
+#ifdef CONFIG_VIDEO_EXYNOS_HDMI_DEBUG
+#define DEBUG
+#endif
+
+#include <linux/io.h>
+#include <linux/clk.h>
+#include <linux/interrupt.h>
+#include <linux/regulator/consumer.h>
+
+#include <media/v4l2-subdev.h>
+#include <media/v4l2-device.h>
+
+/* default preset configured on probe */
+#define HDMI_DEFAULT_PRESET V4L2_DV_1080P60
+/* sink pad number of hdmi subdev */
+#define HDMI_PAD_SINK	0
+/* number of hdmi subdev pads */
+#define HDMI_PADS_NUM	1
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
+#ifndef CONFIG_CPU_EXYNOS4210
+	u8 h_blank[2];
+	u8 v2_blank[2];
+	u8 v1_blank[2];
+	u8 v_line[2];
+	u8 h_line[2];
+	u8 hsync_pol[1];
+	u8 vsync_pol[1];
+	u8 int_pro_mode[1];
+	u8 v_blank_f0[2];
+	u8 v_blank_f1[2];
+	u8 h_sync_start[2];
+	u8 h_sync_end[2];
+	u8 v_sync_line_bef_2[2];
+	u8 v_sync_line_bef_1[2];
+	u8 v_sync_line_aft_2[2];
+	u8 v_sync_line_aft_1[2];
+	u8 v_sync_line_aft_pxl_2[2];
+	u8 v_sync_line_aft_pxl_1[2];
+	u8 v_blank_f2[2];
+	u8 v_blank_f3[2];
+	u8 v_blank_f4[2];
+	u8 v_blank_f5[2];
+	u8 v_sync_line_aft_3[2];
+	u8 v_sync_line_aft_4[2];
+	u8 v_sync_line_aft_5[2];
+	u8 v_sync_line_aft_6[2];
+	u8 v_sync_line_aft_pxl_3[2];
+	u8 v_sync_line_aft_pxl_4[2];
+	u8 v_sync_line_aft_pxl_5[2];
+	u8 v_sync_line_aft_pxl_6[2];
+	u8 vact_space_1[2];
+	u8 vact_space_2[2];
+	u8 vact_space_3[2];
+	u8 vact_space_4[2];
+	u8 vact_space_5[2];
+	u8 vact_space_6[2];
+#else
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
+#endif
+};
+
+struct hdmi_preset_conf {
+	struct hdmi_core_regs core;
+	struct hdmi_tg_regs tg;
+	struct v4l2_mbus_framefmt mbus_fmt;
+};
+
+struct hdmi_driver_data {
+	int hdmiphy_bus;
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
+	/** sink pad of hdmi subdev */
+	struct media_pad pad;
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
+struct hdmi_conf {
+	u32 preset;
+	const struct hdmi_preset_conf *conf;
+};
+extern const struct hdmi_conf hdmi_conf[];
+
+struct hdmiphy_conf {
+	u32 preset;
+	const u8 *data;
+};
+extern const struct hdmiphy_conf hdmiphy_conf[];
+extern const int hdmi_pre_cnt;
+extern const int hdmiphy_conf_cnt;
+
+irqreturn_t hdmi_irq_handler(int irq, void *dev_data);
+void hdmi_reg_init(struct hdmi_device *hdev);
+void hdmi_timing_apply(struct hdmi_device *hdev,
+	const struct hdmi_preset_conf *conf);
+int hdmi_conf_apply(struct hdmi_device *hdmi_dev);
+int is_hdmiphy_ready(struct hdmi_device *hdev);
+void hdmi_enable(struct hdmi_device *hdev, int on);
+void hdmi_tg_enable(struct hdmi_device *hdev, int on);
+void hdmi_dumpregs(struct hdmi_device *hdev, char *prefix);
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
+#endif /* SAMSUNG_HDMI_H */
diff --git a/drivers/media/video/s5p-tv/hdmi_drv.c b/drivers/media/video/s5p-tv/hdmi_drv.c
index 4c3cb7b..4f8dc2a 100644
--- a/drivers/media/video/s5p-tv/hdmi_drv.c
+++ b/drivers/media/video/s5p-tv/hdmi_drv.c
@@ -11,9 +11,7 @@
  * or (at your option) any later version
  */
 
-#ifdef CONFIG_VIDEO_SAMSUNG_S5P_HDMI_DEBUG
-#define DEBUG
-#endif
+#include "hdmi.h"
 
 #include <linux/kernel.h>
 #include <linux/slab.h>
@@ -36,107 +34,10 @@
 #include <media/v4l2-subdev.h>
 #include <media/exynos_mc.h>
 
-#include "regs-hdmi.h"
-
 MODULE_AUTHOR("Tomasz Stanislawski, <t.stanislaws@samsung.com>");
 MODULE_DESCRIPTION("Samsung HDMI");
 MODULE_LICENSE("GPL");
 
-/* default preset configured on probe */
-#define HDMI_DEFAULT_PRESET V4L2_DV_1080P60
-/* sink pad number of hdmi subdev */
-#define HDMI_PAD_SINK	0
-/* number of hdmi subdev pads */
-#define HDMI_PADS_NUM	1
-
-struct hdmi_resources {
-	struct clk *hdmi;
-	struct clk *sclk_hdmi;
-	struct clk *sclk_pixel;
-	struct clk *sclk_hdmiphy;
-	struct clk *hdmiphy;
-	struct regulator_bulk_data *regul_bulk;
-	int regul_count;
-};
-
-struct hdmi_device {
-	/** base address of HDMI registers */
-	void __iomem *regs;
-	/** HDMI interrupt */
-	unsigned int irq;
-	/** pointer to device parent */
-	struct device *dev;
-	/** subdev generated by HDMI device */
-	struct v4l2_subdev sd;
-	/** sink pad of hdmi subdev */
-	struct media_pad pad;
-	/** V4L2 device structure */
-	struct v4l2_device v4l2_dev;
-	/** subdev of HDMIPHY interface */
-	struct v4l2_subdev *phy_sd;
-	/** configuration of current graphic mode */
-	const struct hdmi_preset_conf *cur_conf;
-	/** current preset */
-	u32 cur_preset;
-	/** other resources */
-	struct hdmi_resources res;
-};
-
-struct hdmi_driver_data {
-	int hdmiphy_bus;
-};
-
-struct hdmi_tg_regs {
-	u8 cmd;
-	u8 h_fsz_l;
-	u8 h_fsz_h;
-	u8 hact_st_l;
-	u8 hact_st_h;
-	u8 hact_sz_l;
-	u8 hact_sz_h;
-	u8 v_fsz_l;
-	u8 v_fsz_h;
-	u8 vsync_l;
-	u8 vsync_h;
-	u8 vsync2_l;
-	u8 vsync2_h;
-	u8 vact_st_l;
-	u8 vact_st_h;
-	u8 vact_sz_l;
-	u8 vact_sz_h;
-	u8 field_chg_l;
-	u8 field_chg_h;
-	u8 vact_st2_l;
-	u8 vact_st2_h;
-	u8 vsync_top_hdmi_l;
-	u8 vsync_top_hdmi_h;
-	u8 vsync_bot_hdmi_l;
-	u8 vsync_bot_hdmi_h;
-	u8 field_top_hdmi_l;
-	u8 field_top_hdmi_h;
-	u8 field_bot_hdmi_l;
-	u8 field_bot_hdmi_h;
-};
-
-struct hdmi_core_regs {
-	u8 h_blank[2];
-	u8 v_blank[3];
-	u8 h_v_line[3];
-	u8 vsync_pol[1];
-	u8 int_pro_mode[1];
-	u8 v_blank_f[3];
-	u8 h_sync_gen[3];
-	u8 v_sync_gen1[3];
-	u8 v_sync_gen2[3];
-	u8 v_sync_gen3[3];
-};
-
-struct hdmi_preset_conf {
-	struct hdmi_core_regs core;
-	struct hdmi_tg_regs tg;
-	struct v4l2_mbus_framefmt mbus_fmt;
-};
-
 /* I2C module and id for HDMIPHY */
 static struct i2c_board_info hdmiphy_info = {
 	I2C_BOARD_INFO("hdmiphy", 0x38),
@@ -145,6 +46,7 @@ static struct i2c_board_info hdmiphy_info = {
 static struct hdmi_driver_data hdmi_driver_data[] = {
 	{ .hdmiphy_bus = 3 },
 	{ .hdmiphy_bus = 8 },
+	{ .hdmiphy_bus = 8 },
 };
 
 static struct platform_device_id hdmi_driver_types[] = {
@@ -155,6 +57,9 @@ static struct platform_device_id hdmi_driver_types[] = {
 		.name		= "exynos4-hdmi",
 		.driver_data	= (unsigned long)&hdmi_driver_data[1],
 	}, {
+		.name		= "exynos5-hdmi",
+		.driver_data	= (unsigned long)&hdmi_driver_data[2],
+	}, {
 		/* end node */
 	}
 };
@@ -166,407 +71,11 @@ static struct hdmi_device *sd_to_hdmi_dev(struct v4l2_subdev *sd)
 	return container_of(sd, struct hdmi_device, sd);
 }
 
-static inline
-void hdmi_write(struct hdmi_device *hdev, u32 reg_id, u32 value)
-{
-	writel(value, hdev->regs + reg_id);
-}
-
-static inline
-void hdmi_write_mask(struct hdmi_device *hdev, u32 reg_id, u32 value, u32 mask)
-{
-	u32 old = readl(hdev->regs + reg_id);
-	value = (value & mask) | (old & ~mask);
-	writel(value, hdev->regs + reg_id);
-}
-
-static inline
-void hdmi_writeb(struct hdmi_device *hdev, u32 reg_id, u8 value)
-{
-	writeb(value, hdev->regs + reg_id);
-}
-
-static inline u32 hdmi_read(struct hdmi_device *hdev, u32 reg_id)
-{
-	return readl(hdev->regs + reg_id);
-}
-
-static irqreturn_t hdmi_irq_handler(int irq, void *dev_data)
-{
-	struct hdmi_device *hdev = dev_data;
-	u32 intc_flag;
-
-	(void)irq;
-	intc_flag = hdmi_read(hdev, HDMI_INTC_FLAG);
-	/* clearing flags for HPD plug/unplug */
-	if (intc_flag & HDMI_INTC_FLAG_HPD_UNPLUG) {
-		printk(KERN_INFO "unplugged\n");
-		hdmi_write_mask(hdev, HDMI_INTC_FLAG, ~0,
-			HDMI_INTC_FLAG_HPD_UNPLUG);
-	}
-	if (intc_flag & HDMI_INTC_FLAG_HPD_PLUG) {
-		printk(KERN_INFO "plugged\n");
-		hdmi_write_mask(hdev, HDMI_INTC_FLAG, ~0,
-			HDMI_INTC_FLAG_HPD_PLUG);
-	}
-
-	return IRQ_HANDLED;
-}
-
-static void hdmi_reg_init(struct hdmi_device *hdev)
-{
-	/* enable HPD interrupts */
-	hdmi_write_mask(hdev, HDMI_INTC_CON, ~0, HDMI_INTC_EN_GLOBAL |
-		HDMI_INTC_EN_HPD_PLUG | HDMI_INTC_EN_HPD_UNPLUG);
-	/* choose DVI mode */
-	hdmi_write_mask(hdev, HDMI_MODE_SEL,
-		HDMI_MODE_DVI_EN, HDMI_MODE_MASK);
-	hdmi_write_mask(hdev, HDMI_CON_2, ~0,
-		HDMI_DVI_PERAMBLE_EN | HDMI_DVI_BAND_EN);
-	/* disable bluescreen */
-	hdmi_write_mask(hdev, HDMI_CON_0, 0, HDMI_BLUE_SCR_EN);
-	/* choose bluescreen (fecal) color */
-	hdmi_writeb(hdev, HDMI_BLUE_SCREEN_0, 0x12);
-	hdmi_writeb(hdev, HDMI_BLUE_SCREEN_1, 0x34);
-	hdmi_writeb(hdev, HDMI_BLUE_SCREEN_2, 0x56);
-}
-
-static void hdmi_timing_apply(struct hdmi_device *hdev,
-	const struct hdmi_preset_conf *conf)
-{
-	const struct hdmi_core_regs *core = &conf->core;
-	const struct hdmi_tg_regs *tg = &conf->tg;
-
-	/* setting core registers */
-	hdmi_writeb(hdev, HDMI_H_BLANK_0, core->h_blank[0]);
-	hdmi_writeb(hdev, HDMI_H_BLANK_1, core->h_blank[1]);
-	hdmi_writeb(hdev, HDMI_V_BLANK_0, core->v_blank[0]);
-	hdmi_writeb(hdev, HDMI_V_BLANK_1, core->v_blank[1]);
-	hdmi_writeb(hdev, HDMI_V_BLANK_2, core->v_blank[2]);
-	hdmi_writeb(hdev, HDMI_H_V_LINE_0, core->h_v_line[0]);
-	hdmi_writeb(hdev, HDMI_H_V_LINE_1, core->h_v_line[1]);
-	hdmi_writeb(hdev, HDMI_H_V_LINE_2, core->h_v_line[2]);
-	hdmi_writeb(hdev, HDMI_VSYNC_POL, core->vsync_pol[0]);
-	hdmi_writeb(hdev, HDMI_INT_PRO_MODE, core->int_pro_mode[0]);
-	hdmi_writeb(hdev, HDMI_V_BLANK_F_0, core->v_blank_f[0]);
-	hdmi_writeb(hdev, HDMI_V_BLANK_F_1, core->v_blank_f[1]);
-	hdmi_writeb(hdev, HDMI_V_BLANK_F_2, core->v_blank_f[2]);
-	hdmi_writeb(hdev, HDMI_H_SYNC_GEN_0, core->h_sync_gen[0]);
-	hdmi_writeb(hdev, HDMI_H_SYNC_GEN_1, core->h_sync_gen[1]);
-	hdmi_writeb(hdev, HDMI_H_SYNC_GEN_2, core->h_sync_gen[2]);
-	hdmi_writeb(hdev, HDMI_V_SYNC_GEN_1_0, core->v_sync_gen1[0]);
-	hdmi_writeb(hdev, HDMI_V_SYNC_GEN_1_1, core->v_sync_gen1[1]);
-	hdmi_writeb(hdev, HDMI_V_SYNC_GEN_1_2, core->v_sync_gen1[2]);
-	hdmi_writeb(hdev, HDMI_V_SYNC_GEN_2_0, core->v_sync_gen2[0]);
-	hdmi_writeb(hdev, HDMI_V_SYNC_GEN_2_1, core->v_sync_gen2[1]);
-	hdmi_writeb(hdev, HDMI_V_SYNC_GEN_2_2, core->v_sync_gen2[2]);
-	hdmi_writeb(hdev, HDMI_V_SYNC_GEN_3_0, core->v_sync_gen3[0]);
-	hdmi_writeb(hdev, HDMI_V_SYNC_GEN_3_1, core->v_sync_gen3[1]);
-	hdmi_writeb(hdev, HDMI_V_SYNC_GEN_3_2, core->v_sync_gen3[2]);
-	/* Timing generator registers */
-	hdmi_writeb(hdev, HDMI_TG_H_FSZ_L, tg->h_fsz_l);
-	hdmi_writeb(hdev, HDMI_TG_H_FSZ_H, tg->h_fsz_h);
-	hdmi_writeb(hdev, HDMI_TG_HACT_ST_L, tg->hact_st_l);
-	hdmi_writeb(hdev, HDMI_TG_HACT_ST_H, tg->hact_st_h);
-	hdmi_writeb(hdev, HDMI_TG_HACT_SZ_L, tg->hact_sz_l);
-	hdmi_writeb(hdev, HDMI_TG_HACT_SZ_H, tg->hact_sz_h);
-	hdmi_writeb(hdev, HDMI_TG_V_FSZ_L, tg->v_fsz_l);
-	hdmi_writeb(hdev, HDMI_TG_V_FSZ_H, tg->v_fsz_h);
-	hdmi_writeb(hdev, HDMI_TG_VSYNC_L, tg->vsync_l);
-	hdmi_writeb(hdev, HDMI_TG_VSYNC_H, tg->vsync_h);
-	hdmi_writeb(hdev, HDMI_TG_VSYNC2_L, tg->vsync2_l);
-	hdmi_writeb(hdev, HDMI_TG_VSYNC2_H, tg->vsync2_h);
-	hdmi_writeb(hdev, HDMI_TG_VACT_ST_L, tg->vact_st_l);
-	hdmi_writeb(hdev, HDMI_TG_VACT_ST_H, tg->vact_st_h);
-	hdmi_writeb(hdev, HDMI_TG_VACT_SZ_L, tg->vact_sz_l);
-	hdmi_writeb(hdev, HDMI_TG_VACT_SZ_H, tg->vact_sz_h);
-	hdmi_writeb(hdev, HDMI_TG_FIELD_CHG_L, tg->field_chg_l);
-	hdmi_writeb(hdev, HDMI_TG_FIELD_CHG_H, tg->field_chg_h);
-	hdmi_writeb(hdev, HDMI_TG_VACT_ST2_L, tg->vact_st2_l);
-	hdmi_writeb(hdev, HDMI_TG_VACT_ST2_H, tg->vact_st2_h);
-	hdmi_writeb(hdev, HDMI_TG_VSYNC_TOP_HDMI_L, tg->vsync_top_hdmi_l);
-	hdmi_writeb(hdev, HDMI_TG_VSYNC_TOP_HDMI_H, tg->vsync_top_hdmi_h);
-	hdmi_writeb(hdev, HDMI_TG_VSYNC_BOT_HDMI_L, tg->vsync_bot_hdmi_l);
-	hdmi_writeb(hdev, HDMI_TG_VSYNC_BOT_HDMI_H, tg->vsync_bot_hdmi_h);
-	hdmi_writeb(hdev, HDMI_TG_FIELD_TOP_HDMI_L, tg->field_top_hdmi_l);
-	hdmi_writeb(hdev, HDMI_TG_FIELD_TOP_HDMI_H, tg->field_top_hdmi_h);
-	hdmi_writeb(hdev, HDMI_TG_FIELD_BOT_HDMI_L, tg->field_bot_hdmi_l);
-	hdmi_writeb(hdev, HDMI_TG_FIELD_BOT_HDMI_H, tg->field_bot_hdmi_h);
-}
-
-static int hdmi_conf_apply(struct hdmi_device *hdmi_dev)
-{
-	struct device *dev = hdmi_dev->dev;
-	const struct hdmi_preset_conf *conf = hdmi_dev->cur_conf;
-	struct v4l2_dv_preset preset;
-	int ret;
-
-	dev_dbg(dev, "%s\n", __func__);
-
-	/* reset hdmiphy */
-	hdmi_write_mask(hdmi_dev, HDMI_PHY_RSTOUT, ~0, HDMI_PHY_SW_RSTOUT);
-	mdelay(10);
-	hdmi_write_mask(hdmi_dev, HDMI_PHY_RSTOUT,  0, HDMI_PHY_SW_RSTOUT);
-	mdelay(10);
-
-	/* configure presets */
-	preset.preset = hdmi_dev->cur_preset;
-	ret = v4l2_subdev_call(hdmi_dev->phy_sd, video, s_dv_preset, &preset);
-	if (ret) {
-		dev_err(dev, "failed to set preset (%u)\n", preset.preset);
-		return ret;
-	}
-
-	/* resetting HDMI core */
-	hdmi_write_mask(hdmi_dev, HDMI_CORE_RSTOUT,  0, HDMI_CORE_SW_RSTOUT);
-	mdelay(10);
-	hdmi_write_mask(hdmi_dev, HDMI_CORE_RSTOUT, ~0, HDMI_CORE_SW_RSTOUT);
-	mdelay(10);
-
-	hdmi_reg_init(hdmi_dev);
-
-	/* setting core registers */
-	hdmi_timing_apply(hdmi_dev, conf);
-
-	return 0;
-}
-
-static void hdmi_dumpregs(struct hdmi_device *hdev, char *prefix)
-{
-#define DUMPREG(reg_id) \
-	dev_dbg(hdev->dev, "%s:" #reg_id " = %08x\n", prefix, \
-		readl(hdev->regs + reg_id))
-
-	dev_dbg(hdev->dev, "%s: ---- CONTROL REGISTERS ----\n", prefix);
-	DUMPREG(HDMI_INTC_FLAG);
-	DUMPREG(HDMI_INTC_CON);
-	DUMPREG(HDMI_HPD_STATUS);
-	DUMPREG(HDMI_PHY_RSTOUT);
-	DUMPREG(HDMI_PHY_VPLL);
-	DUMPREG(HDMI_PHY_CMU);
-	DUMPREG(HDMI_CORE_RSTOUT);
-
-	dev_dbg(hdev->dev, "%s: ---- CORE REGISTERS ----\n", prefix);
-	DUMPREG(HDMI_CON_0);
-	DUMPREG(HDMI_CON_1);
-	DUMPREG(HDMI_CON_2);
-	DUMPREG(HDMI_SYS_STATUS);
-	DUMPREG(HDMI_PHY_STATUS);
-	DUMPREG(HDMI_STATUS_EN);
-	DUMPREG(HDMI_HPD);
-	DUMPREG(HDMI_MODE_SEL);
-	DUMPREG(HDMI_HPD_GEN);
-	DUMPREG(HDMI_DC_CONTROL);
-	DUMPREG(HDMI_VIDEO_PATTERN_GEN);
-
-	dev_dbg(hdev->dev, "%s: ---- CORE SYNC REGISTERS ----\n", prefix);
-	DUMPREG(HDMI_H_BLANK_0);
-	DUMPREG(HDMI_H_BLANK_1);
-	DUMPREG(HDMI_V_BLANK_0);
-	DUMPREG(HDMI_V_BLANK_1);
-	DUMPREG(HDMI_V_BLANK_2);
-	DUMPREG(HDMI_H_V_LINE_0);
-	DUMPREG(HDMI_H_V_LINE_1);
-	DUMPREG(HDMI_H_V_LINE_2);
-	DUMPREG(HDMI_VSYNC_POL);
-	DUMPREG(HDMI_INT_PRO_MODE);
-	DUMPREG(HDMI_V_BLANK_F_0);
-	DUMPREG(HDMI_V_BLANK_F_1);
-	DUMPREG(HDMI_V_BLANK_F_2);
-	DUMPREG(HDMI_H_SYNC_GEN_0);
-	DUMPREG(HDMI_H_SYNC_GEN_1);
-	DUMPREG(HDMI_H_SYNC_GEN_2);
-	DUMPREG(HDMI_V_SYNC_GEN_1_0);
-	DUMPREG(HDMI_V_SYNC_GEN_1_1);
-	DUMPREG(HDMI_V_SYNC_GEN_1_2);
-	DUMPREG(HDMI_V_SYNC_GEN_2_0);
-	DUMPREG(HDMI_V_SYNC_GEN_2_1);
-	DUMPREG(HDMI_V_SYNC_GEN_2_2);
-	DUMPREG(HDMI_V_SYNC_GEN_3_0);
-	DUMPREG(HDMI_V_SYNC_GEN_3_1);
-	DUMPREG(HDMI_V_SYNC_GEN_3_2);
-
-	dev_dbg(hdev->dev, "%s: ---- TG REGISTERS ----\n", prefix);
-	DUMPREG(HDMI_TG_CMD);
-	DUMPREG(HDMI_TG_H_FSZ_L);
-	DUMPREG(HDMI_TG_H_FSZ_H);
-	DUMPREG(HDMI_TG_HACT_ST_L);
-	DUMPREG(HDMI_TG_HACT_ST_H);
-	DUMPREG(HDMI_TG_HACT_SZ_L);
-	DUMPREG(HDMI_TG_HACT_SZ_H);
-	DUMPREG(HDMI_TG_V_FSZ_L);
-	DUMPREG(HDMI_TG_V_FSZ_H);
-	DUMPREG(HDMI_TG_VSYNC_L);
-	DUMPREG(HDMI_TG_VSYNC_H);
-	DUMPREG(HDMI_TG_VSYNC2_L);
-	DUMPREG(HDMI_TG_VSYNC2_H);
-	DUMPREG(HDMI_TG_VACT_ST_L);
-	DUMPREG(HDMI_TG_VACT_ST_H);
-	DUMPREG(HDMI_TG_VACT_SZ_L);
-	DUMPREG(HDMI_TG_VACT_SZ_H);
-	DUMPREG(HDMI_TG_FIELD_CHG_L);
-	DUMPREG(HDMI_TG_FIELD_CHG_H);
-	DUMPREG(HDMI_TG_VACT_ST2_L);
-	DUMPREG(HDMI_TG_VACT_ST2_H);
-	DUMPREG(HDMI_TG_VSYNC_TOP_HDMI_L);
-	DUMPREG(HDMI_TG_VSYNC_TOP_HDMI_H);
-	DUMPREG(HDMI_TG_VSYNC_BOT_HDMI_L);
-	DUMPREG(HDMI_TG_VSYNC_BOT_HDMI_H);
-	DUMPREG(HDMI_TG_FIELD_TOP_HDMI_L);
-	DUMPREG(HDMI_TG_FIELD_TOP_HDMI_H);
-	DUMPREG(HDMI_TG_FIELD_BOT_HDMI_L);
-	DUMPREG(HDMI_TG_FIELD_BOT_HDMI_H);
-#undef DUMPREG
-}
-
-static const struct hdmi_preset_conf hdmi_conf_480p = {
-	.core = {
-		.h_blank = {0x8a, 0x00},
-		.v_blank = {0x0d, 0x6a, 0x01},
-		.h_v_line = {0x0d, 0xa2, 0x35},
-		.vsync_pol = {0x01},
-		.int_pro_mode = {0x00},
-		.v_blank_f = {0x00, 0x00, 0x00},
-		.h_sync_gen = {0x0e, 0x30, 0x11},
-		.v_sync_gen1 = {0x0f, 0x90, 0x00},
-		/* other don't care */
-	},
-	.tg = {
-		0x00, /* cmd */
-		0x5a, 0x03, /* h_fsz */
-		0x8a, 0x00, 0xd0, 0x02, /* hact */
-		0x0d, 0x02, /* v_fsz */
-		0x01, 0x00, 0x33, 0x02, /* vsync */
-		0x2d, 0x00, 0xe0, 0x01, /* vact */
-		0x33, 0x02, /* field_chg */
-		0x49, 0x02, /* vact_st2 */
-		0x01, 0x00, 0x33, 0x02, /* vsync top/bot */
-		0x01, 0x00, 0x33, 0x02, /* field top/bot */
-	},
-	.mbus_fmt = {
-		.width = 720,
-		.height = 480,
-		.code = V4L2_MBUS_FMT_FIXED, /* means RGB888 */
-		.field = V4L2_FIELD_NONE,
-		.colorspace = V4L2_COLORSPACE_SRGB,
-	},
-};
-
-static const struct hdmi_preset_conf hdmi_conf_720p60 = {
-	.core = {
-		.h_blank = {0x72, 0x01},
-		.v_blank = {0xee, 0xf2, 0x00},
-		.h_v_line = {0xee, 0x22, 0x67},
-		.vsync_pol = {0x00},
-		.int_pro_mode = {0x00},
-		.v_blank_f = {0x00, 0x00, 0x00}, /* don't care */
-		.h_sync_gen = {0x6c, 0x50, 0x02},
-		.v_sync_gen1 = {0x0a, 0x50, 0x00},
-		/* other don't care */
-	},
-	.tg = {
-		0x00, /* cmd */
-		0x72, 0x06, /* h_fsz */
-		0x72, 0x01, 0x00, 0x05, /* hact */
-		0xee, 0x02, /* v_fsz */
-		0x01, 0x00, 0x33, 0x02, /* vsync */
-		0x1e, 0x00, 0xd0, 0x02, /* vact */
-		0x33, 0x02, /* field_chg */
-		0x49, 0x02, /* vact_st2 */
-		0x01, 0x00, 0x33, 0x02, /* vsync top/bot */
-		0x01, 0x00, 0x33, 0x02, /* field top/bot */
-	},
-	.mbus_fmt = {
-		.width = 1280,
-		.height = 720,
-		.code = V4L2_MBUS_FMT_FIXED, /* means RGB888 */
-		.field = V4L2_FIELD_NONE,
-		.colorspace = V4L2_COLORSPACE_SRGB,
-	},
-};
-
-static const struct hdmi_preset_conf hdmi_conf_1080p50 = {
-	.core = {
-		.h_blank = {0xd0, 0x02},
-		.v_blank = {0x65, 0x6c, 0x01},
-		.h_v_line = {0x65, 0x04, 0xa5},
-		.vsync_pol = {0x00},
-		.int_pro_mode = {0x00},
-		.v_blank_f = {0x00, 0x00, 0x00}, /* don't care */
-		.h_sync_gen = {0x0e, 0xea, 0x08},
-		.v_sync_gen1 = {0x09, 0x40, 0x00},
-		/* other don't care */
-	},
-	.tg = {
-		0x00, /* cmd */
-		0x98, 0x08, /* h_fsz */
-		0x18, 0x01, 0x80, 0x07, /* hact */
-		0x65, 0x04, /* v_fsz */
-		0x01, 0x00, 0x33, 0x02, /* vsync */
-		0x2d, 0x00, 0x38, 0x04, /* vact */
-		0x33, 0x02, /* field_chg */
-		0x49, 0x02, /* vact_st2 */
-		0x01, 0x00, 0x33, 0x02, /* vsync top/bot */
-		0x01, 0x00, 0x33, 0x02, /* field top/bot */
-	},
-	.mbus_fmt = {
-		.width = 1920,
-		.height = 1080,
-		.code = V4L2_MBUS_FMT_FIXED, /* means RGB888 */
-		.field = V4L2_FIELD_NONE,
-		.colorspace = V4L2_COLORSPACE_SRGB,
-	},
-};
-
-static const struct hdmi_preset_conf hdmi_conf_1080p60 = {
-	.core = {
-		.h_blank = {0x18, 0x01},
-		.v_blank = {0x65, 0x6c, 0x01},
-		.h_v_line = {0x65, 0x84, 0x89},
-		.vsync_pol = {0x00},
-		.int_pro_mode = {0x00},
-		.v_blank_f = {0x00, 0x00, 0x00}, /* don't care */
-		.h_sync_gen = {0x56, 0x08, 0x02},
-		.v_sync_gen1 = {0x09, 0x40, 0x00},
-		/* other don't care */
-	},
-	.tg = {
-		0x00, /* cmd */
-		0x98, 0x08, /* h_fsz */
-		0x18, 0x01, 0x80, 0x07, /* hact */
-		0x65, 0x04, /* v_fsz */
-		0x01, 0x00, 0x33, 0x02, /* vsync */
-		0x2d, 0x00, 0x38, 0x04, /* vact */
-		0x33, 0x02, /* field_chg */
-		0x48, 0x02, /* vact_st2 */
-		0x01, 0x00, 0x01, 0x00, /* vsync top/bot */
-		0x01, 0x00, 0x33, 0x02, /* field top/bot */
-	},
-	.mbus_fmt = {
-		.width = 1920,
-		.height = 1080,
-		.code = V4L2_MBUS_FMT_FIXED, /* means RGB888 */
-		.field = V4L2_FIELD_NONE,
-		.colorspace = V4L2_COLORSPACE_SRGB,
-	},
-};
-
-static const struct {
-	u32 preset;
-	const struct hdmi_preset_conf *conf;
-} hdmi_conf[] = {
-	{ V4L2_DV_480P59_94, &hdmi_conf_480p },
-	{ V4L2_DV_720P59_94, &hdmi_conf_720p60 },
-	{ V4L2_DV_1080P50, &hdmi_conf_1080p50 },
-	{ V4L2_DV_1080P30, &hdmi_conf_1080p60 },
-	{ V4L2_DV_1080P60, &hdmi_conf_1080p60 },
-};
-
 static const struct hdmi_preset_conf *hdmi_preset2conf(u32 preset)
 {
 	int i;
 
-	for (i = 0; i < ARRAY_SIZE(hdmi_conf); ++i)
+	for (i = 0; i < hdmi_pre_cnt; ++i)
 		if (hdmi_conf[i].preset == preset)
 			return  hdmi_conf[i].conf;
 	return NULL;
@@ -586,9 +95,9 @@ static int hdmi_streamon(struct hdmi_device *hdev)
 
 	/* waiting for HDMIPHY's PLL to get to steady state */
 	for (tries = 100; tries; --tries) {
-		u32 val = hdmi_read(hdev, HDMI_PHY_STATUS);
-		if (val & HDMI_PHY_STATUS_READY)
+		if (is_hdmiphy_ready(hdev))
 			break;
+
 		mdelay(1);
 	}
 	/* steady state not achieved */
@@ -605,8 +114,9 @@ static int hdmi_streamon(struct hdmi_device *hdev)
 	clk_enable(res->sclk_hdmi);
 
 	/* enable HDMI and timing generator */
-	hdmi_write_mask(hdev, HDMI_CON_0, ~0, HDMI_EN);
-	hdmi_write_mask(hdev, HDMI_TG_CMD, ~0, HDMI_TG_EN);
+	hdmi_enable(hdev, 1);
+	hdmi_tg_enable(hdev, 1);
+
 	hdmi_dumpregs(hdev, "streamon");
 	return 0;
 }
@@ -618,8 +128,8 @@ static int hdmi_streamoff(struct hdmi_device *hdev)
 
 	dev_dbg(dev, "%s\n", __func__);
 
-	hdmi_write_mask(hdev, HDMI_CON_0, 0, HDMI_EN);
-	hdmi_write_mask(hdev, HDMI_TG_CMD, 0, HDMI_TG_EN);
+	hdmi_enable(hdev, 0);
+	hdmi_tg_enable(hdev, 0);
 
 	/* pixel(vpll) clock is used for HDMI in config mode */
 	clk_disable(res->sclk_hdmi);
@@ -719,7 +229,7 @@ static int hdmi_g_mbus_fmt(struct v4l2_subdev *sd,
 static int hdmi_enum_dv_presets(struct v4l2_subdev *sd,
 	struct v4l2_dv_enum_preset *preset)
 {
-	if (preset->index >= ARRAY_SIZE(hdmi_conf))
+	if (preset->index >= hdmi_pre_cnt)
 		return -EINVAL;
 	return v4l_fill_dv_preset_info(hdmi_conf[preset->index].preset, preset);
 }
diff --git a/drivers/media/video/s5p-tv/hdmi_reg_v13.c b/drivers/media/video/s5p-tv/hdmi_reg_v13.c
new file mode 100644
index 0000000..6fd4152
--- /dev/null
+++ b/drivers/media/video/s5p-tv/hdmi_reg_v13.c
@@ -0,0 +1,413 @@
+/*
+ * Samsung HDMI driver
+ *
+ * Copyright (c) 2010-2011 Samsung Electronics Co., Ltd.
+ *
+ * Jiun Yu <jiun.yu@samsung.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published
+ * by the Free Software Foundiation. either version 2 of the License,
+ * or (at your option) any later version
+ */
+
+#include <linux/delay.h>
+
+#include "hdmi.h"
+#include "regs-hdmi-v13.h"
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
+const struct hdmi_conf hdmi_conf[] = {
+	{ V4L2_DV_480P59_94, &hdmi_conf_480p },
+	{ V4L2_DV_720P59_94, &hdmi_conf_720p60 },
+	{ V4L2_DV_1080P50, &hdmi_conf_1080p50 },
+	{ V4L2_DV_1080P30, &hdmi_conf_1080p60 },
+	{ V4L2_DV_1080P60, &hdmi_conf_1080p60 },
+};
+
+const int hdmi_pre_cnt = ARRAY_SIZE(hdmi_conf);
+
+irqreturn_t hdmi_irq_handler(int irq, void *dev_data)
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
+void hdmi_reg_init(struct hdmi_device *hdev)
+{
+	/* enable HPD interrupts */
+	hdmi_write_mask(hdev, HDMI_INTC_CON, ~0, HDMI_INTC_EN_GLOBAL |
+		HDMI_INTC_EN_HPD_PLUG | HDMI_INTC_EN_HPD_UNPLUG);
+	/* choose DVI mode */
+	hdmi_write_mask(hdev, HDMI_MODE_SEL,
+		HDMI_MODE_DVI_EN, HDMI_MODE_MASK);
+	hdmi_write_mask(hdev, HDMI_CON_2, ~0,
+		HDMI_DVI_PERAMBLE_EN | HDMI_DVI_BAND_EN);
+	/* disable bluescreen */
+	hdmi_write_mask(hdev, HDMI_CON_0, 0, HDMI_BLUE_SCR_EN);
+	/* choose bluescreen (fecal) color */
+	hdmi_writeb(hdev, HDMI_BLUE_SCREEN_0, 0x12);
+	hdmi_writeb(hdev, HDMI_BLUE_SCREEN_1, 0x34);
+	hdmi_writeb(hdev, HDMI_BLUE_SCREEN_2, 0x56);
+}
+
+void hdmi_timing_apply(struct hdmi_device *hdev,
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
+int hdmi_conf_apply(struct hdmi_device *hdmi_dev)
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
+int is_hdmiphy_ready(struct hdmi_device *hdev)
+{
+	u32 val = hdmi_read(hdev, HDMI_PHY_STATUS);
+	if (val & HDMI_PHY_STATUS_READY)
+		return 1;
+
+	return 0;
+}
+
+void hdmi_enable(struct hdmi_device *hdev, int on)
+{
+	if (on)
+		hdmi_write_mask(hdev, HDMI_CON_0, ~0, HDMI_EN);
+	else
+		hdmi_write_mask(hdev, HDMI_CON_0, 0, HDMI_EN);
+}
+
+void hdmi_tg_enable(struct hdmi_device *hdev, int on)
+{
+	u32 mask;
+
+	mask = (hdev->cur_conf->mbus_fmt.field == V4L2_FIELD_INTERLACED) ?
+			HDMI_TG_EN | HDMI_FIELD_EN : HDMI_TG_EN;
+
+	if (on)
+		hdmi_write_mask(hdev, HDMI_TG_CMD, ~0, mask);
+	else
+		hdmi_write_mask(hdev, HDMI_TG_CMD, 0, mask);
+}
+
+void hdmi_dumpregs(struct hdmi_device *hdev, char *prefix)
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
diff --git a/drivers/media/video/s5p-tv/hdmi_reg_v14.c b/drivers/media/video/s5p-tv/hdmi_reg_v14.c
new file mode 100644
index 0000000..e541b03
--- /dev/null
+++ b/drivers/media/video/s5p-tv/hdmi_reg_v14.c
@@ -0,0 +1,710 @@
+/*
+ * Samsung HDMI driver
+ *
+ * Copyright (c) 2010-2011 Samsung Electronics Co., Ltd.
+ *
+ * Jiun Yu <jiun.yu@samsung.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published
+ * by the Free Software Foundiation. either version 2 of the License,
+ * or (at your option) any later version
+ */
+
+#include <linux/delay.h>
+#include <linux/pm_runtime.h>
+#include <plat/devs.h>
+#include <plat/tv-core.h>
+
+#include "hdmi.h"
+#include "regs-hdmi-v14.h"
+
+static const struct hdmi_preset_conf hdmi_conf_1080p60 = {
+	.core = {
+		.h_blank = {0x18, 0x01},
+		.v2_blank = {0x65, 0x04},
+		.v1_blank = {0x2d, 0x00},
+		.v_line = {0x65, 0x04},
+		.h_line = {0x98, 0x08},
+		.hsync_pol = {0x00},
+		.vsync_pol = {0x00},
+		.int_pro_mode = {0x00},
+		.v_blank_f0 = {0xff, 0xff},
+		.v_blank_f1 = {0xff, 0xff},
+		.h_sync_start = {0x56, 0x00},
+		.h_sync_end = {0x82, 0x00},
+		.v_sync_line_bef_2 = {0x09, 0x00},
+		.v_sync_line_bef_1 = {0x04, 0x00},
+		.v_sync_line_aft_2 = {0xff, 0xff},
+		.v_sync_line_aft_1 = {0xff, 0xff},
+		.v_sync_line_aft_pxl_2 = {0xff, 0xff},
+		.v_sync_line_aft_pxl_1 = {0xff, 0xff},
+		.v_blank_f2 = {0xff, 0xff},
+		.v_blank_f3 = {0xff, 0xff},
+		.v_blank_f4 = {0xff, 0xff},
+		.v_blank_f5 = {0xff, 0xff},
+		.v_sync_line_aft_3 = {0xff, 0xff},
+		.v_sync_line_aft_4 = {0xff, 0xff},
+		.v_sync_line_aft_5 = {0xff, 0xff},
+		.v_sync_line_aft_6 = {0xff, 0xff},
+		.v_sync_line_aft_pxl_3 = {0xff, 0xff},
+		.v_sync_line_aft_pxl_4 = {0xff, 0xff},
+		.v_sync_line_aft_pxl_5 = {0xff, 0xff},
+		.v_sync_line_aft_pxl_6 = {0xff, 0xff},
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
+static const struct hdmi_preset_conf hdmi_conf_1080p50 = {
+	.core = {
+		.h_blank = {0xd0, 0x02},
+		.v2_blank = {0x65, 0x04},
+		.v1_blank = {0x2d, 0x00},
+		.v_line = {0x65, 0x04},
+		.h_line = {0x50, 0x0a},
+		.hsync_pol = {0x00},
+		.vsync_pol = {0x00},
+		.int_pro_mode = {0x00},
+		.v_blank_f0 = {0xff, 0xff},
+		.v_blank_f1 = {0xff, 0xff},
+		.h_sync_start = {0x0e, 0x02},
+		.h_sync_end = {0x3a, 0x02},
+		.v_sync_line_bef_2 = {0x09, 0x00},
+		.v_sync_line_bef_1 = {0x04, 0x00},
+		.v_sync_line_aft_2 = {0xff, 0xff},
+		.v_sync_line_aft_1 = {0xff, 0xff},
+		.v_sync_line_aft_pxl_2 = {0xff, 0xff},
+		.v_sync_line_aft_pxl_1 = {0xff, 0xff},
+		.v_blank_f2 = {0xff, 0xff},
+		.v_blank_f3 = {0xff, 0xff},
+		.v_blank_f4 = {0xff, 0xff},
+		.v_blank_f5 = {0xff, 0xff},
+		.v_sync_line_aft_3 = {0xff, 0xff},
+		.v_sync_line_aft_4 = {0xff, 0xff},
+		.v_sync_line_aft_5 = {0xff, 0xff},
+		.v_sync_line_aft_6 = {0xff, 0xff},
+		.v_sync_line_aft_pxl_3 = {0xff, 0xff},
+		.v_sync_line_aft_pxl_4 = {0xff, 0xff},
+		.v_sync_line_aft_pxl_5 = {0xff, 0xff},
+		.v_sync_line_aft_pxl_6 = {0xff, 0xff},
+		.vact_space_1 = {0xff, 0xff},
+		.vact_space_2 = {0xff, 0xff},
+		.vact_space_3 = {0xff, 0xff},
+		.vact_space_4 = {0xff, 0xff},
+		.vact_space_5 = {0xff, 0xff},
+		.vact_space_6 = {0xff, 0xff},
+		/* other don't care */
+	},
+	.tg = {
+		0x00, /* cmd */
+		0x50, 0x0a, /* h_fsz */
+		0xd0, 0x02, 0x80, 0x07, /* hact */
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
+static const struct hdmi_preset_conf hdmi_conf_1080p30 = {
+	.core = {
+		.h_blank = {0x18, 0x01},
+		.v2_blank = {0x65, 0x04},
+		.v1_blank = {0x2d, 0x00},
+		.v_line = {0x65, 0x04},
+		.h_line = {0x98, 0x08},
+		.hsync_pol = {0x00},
+		.vsync_pol = {0x00},
+		.int_pro_mode = {0x00},
+		.v_blank_f0 = {0xff, 0xff},
+		.v_blank_f1 = {0xff, 0xff},
+		.h_sync_start = {0x56, 0x00},
+		.h_sync_end = {0x82, 0x00},
+		.v_sync_line_bef_2 = {0x09, 0x00},
+		.v_sync_line_bef_1 = {0x04, 0x00},
+		.v_sync_line_aft_2 = {0xff, 0xff},
+		.v_sync_line_aft_1 = {0xff, 0xff},
+		.v_sync_line_aft_pxl_2 = {0xff, 0xff},
+		.v_sync_line_aft_pxl_1 = {0xff, 0xff},
+		.v_blank_f2 = {0xff, 0xff},
+		.v_blank_f3 = {0xff, 0xff},
+		.v_blank_f4 = {0xff, 0xff},
+		.v_blank_f5 = {0xff, 0xff},
+		.v_sync_line_aft_3 = {0xff, 0xff},
+		.v_sync_line_aft_4 = {0xff, 0xff},
+		.v_sync_line_aft_5 = {0xff, 0xff},
+		.v_sync_line_aft_6 = {0xff, 0xff},
+		.v_sync_line_aft_pxl_3 = {0xff, 0xff},
+		.v_sync_line_aft_pxl_4 = {0xff, 0xff},
+		.v_sync_line_aft_pxl_5 = {0xff, 0xff},
+		.v_sync_line_aft_pxl_6 = {0xff, 0xff},
+		.vact_space_1 = {0xff, 0xff},
+		.vact_space_2 = {0xff, 0xff},
+		.vact_space_3 = {0xff, 0xff},
+		.vact_space_4 = {0xff, 0xff},
+		.vact_space_5 = {0xff, 0xff},
+		.vact_space_6 = {0xff, 0xff},
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
+static const struct hdmi_preset_conf hdmi_conf_480p59_94 = {
+	.core = {
+		.h_blank = {0x8a, 0x00},
+		.v2_blank = {0x0d, 0x02},
+		.v1_blank = {0x2d, 0x00},
+		.v_line = {0x0d, 0x02},
+		.h_line = {0x5a, 0x03},
+		.hsync_pol = {0x01},
+		.vsync_pol = {0x01},
+		.int_pro_mode = {0x00},
+		.v_blank_f0 = {0xff, 0xff},
+		.v_blank_f1 = {0xff, 0xff},
+		.h_sync_start = {0x0e, 0x00},
+		.h_sync_end = {0x4c, 0x00},
+		.v_sync_line_bef_2 = {0x0f, 0x00},
+		.v_sync_line_bef_1 = {0x09, 0x00},
+		.v_sync_line_aft_2 = {0xff, 0xff},
+		.v_sync_line_aft_1 = {0xff, 0xff},
+		.v_sync_line_aft_pxl_2 = {0xff, 0xff},
+		.v_sync_line_aft_pxl_1 = {0xff, 0xff},
+		.v_blank_f2 = {0xff, 0xff},
+		.v_blank_f3 = {0xff, 0xff},
+		.v_blank_f4 = {0xff, 0xff},
+		.v_blank_f5 = {0xff, 0xff},
+		.v_sync_line_aft_3 = {0xff, 0xff},
+		.v_sync_line_aft_4 = {0xff, 0xff},
+		.v_sync_line_aft_5 = {0xff, 0xff},
+		.v_sync_line_aft_6 = {0xff, 0xff},
+		.v_sync_line_aft_pxl_3 = {0xff, 0xff},
+		.v_sync_line_aft_pxl_4 = {0xff, 0xff},
+		.v_sync_line_aft_pxl_5 = {0xff, 0xff},
+		.v_sync_line_aft_pxl_6 = {0xff, 0xff},
+		.vact_space_1 = {0xff, 0xff},
+		.vact_space_2 = {0xff, 0xff},
+		.vact_space_3 = {0xff, 0xff},
+		.vact_space_4 = {0xff, 0xff},
+		.vact_space_5 = {0xff, 0xff},
+		.vact_space_6 = {0xff, 0xff},
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
+		0x48, 0x02, /* vact_st2 */
+		0x01, 0x00, 0x01, 0x00, /* vsync top/bot */
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
+static const struct hdmi_preset_conf hdmi_conf_720p59_94 = {
+	.core = {
+		.h_blank = {0x72, 0x01},
+		.v2_blank = {0xee, 0x02},
+		.v1_blank = {0x1e, 0x00},
+		.v_line = {0xee, 0x02},
+		.h_line = {0x72, 0x06},
+		.hsync_pol = {0x00},
+		.vsync_pol = {0x00},
+		.int_pro_mode = {0x00},
+		.v_blank_f0 = {0xff, 0xff},
+		.v_blank_f1 = {0xff, 0xff},
+		.h_sync_start = {0x6c, 0x00},
+		.h_sync_end = {0x94, 0x00},
+		.v_sync_line_bef_2 = {0x0a, 0x00},
+		.v_sync_line_bef_1 = {0x05, 0x00},
+		.v_sync_line_aft_2 = {0xff, 0xff},
+		.v_sync_line_aft_1 = {0xff, 0xff},
+		.v_sync_line_aft_pxl_2 = {0xff, 0xff},
+		.v_sync_line_aft_pxl_1 = {0xff, 0xff},
+		.v_blank_f2 = {0xff, 0xff},
+		.v_blank_f3 = {0xff, 0xff},
+		.v_blank_f4 = {0xff, 0xff},
+		.v_blank_f5 = {0xff, 0xff},
+		.v_sync_line_aft_3 = {0xff, 0xff},
+		.v_sync_line_aft_4 = {0xff, 0xff},
+		.v_sync_line_aft_5 = {0xff, 0xff},
+		.v_sync_line_aft_6 = {0xff, 0xff},
+		.v_sync_line_aft_pxl_3 = {0xff, 0xff},
+		.v_sync_line_aft_pxl_4 = {0xff, 0xff},
+		.v_sync_line_aft_pxl_5 = {0xff, 0xff},
+		.v_sync_line_aft_pxl_6 = {0xff, 0xff},
+		.vact_space_1 = {0xff, 0xff},
+		.vact_space_2 = {0xff, 0xff},
+		.vact_space_3 = {0xff, 0xff},
+		.vact_space_4 = {0xff, 0xff},
+		.vact_space_5 = {0xff, 0xff},
+		.vact_space_6 = {0xff, 0xff},
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
+		0x48, 0x02, /* vact_st2 */
+		0x01, 0x00, 0x01, 0x00, /* vsync top/bot */
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
+const struct hdmi_conf hdmi_conf[] = {
+	{ V4L2_DV_480P59_94, &hdmi_conf_480p59_94 },
+	{ V4L2_DV_720P59_94, &hdmi_conf_720p59_94 },
+	{ V4L2_DV_1080P30, &hdmi_conf_1080p30 },
+	{ V4L2_DV_1080P50, &hdmi_conf_1080p50 },
+	{ V4L2_DV_1080P60, &hdmi_conf_1080p60 },
+};
+
+const int hdmi_pre_cnt = ARRAY_SIZE(hdmi_conf);
+
+irqreturn_t hdmi_irq_handler(int irq, void *dev_data)
+{
+	struct hdmi_device *hdev = dev_data;
+	u32 intc_flag;
+
+	(void)irq;
+	intc_flag = hdmi_read(hdev, HDMI_INTC_FLAG_0);
+	/* clearing flags for HPD plug/unplug */
+	if (intc_flag & HDMI_INTC_FLAG_HPD_UNPLUG) {
+		printk(KERN_INFO "unplugged\n");
+		hdmi_write_mask(hdev, HDMI_INTC_FLAG_0, ~0,
+			HDMI_INTC_FLAG_HPD_UNPLUG);
+	}
+	if (intc_flag & HDMI_INTC_FLAG_HPD_PLUG) {
+		printk(KERN_INFO "plugged\n");
+		hdmi_write_mask(hdev, HDMI_INTC_FLAG_0, ~0,
+			HDMI_INTC_FLAG_HPD_PLUG);
+	}
+
+	return IRQ_HANDLED;
+}
+
+void hdmi_reg_init(struct hdmi_device *hdev)
+{
+	/* enable HPD interrupts */
+	hdmi_write_mask(hdev, HDMI_INTC_CON_0, ~0, HDMI_INTC_EN_GLOBAL |
+		HDMI_INTC_EN_HPD_PLUG | HDMI_INTC_EN_HPD_UNPLUG);
+	/* choose DVI mode */
+	hdmi_write_mask(hdev, HDMI_MODE_SEL,
+		HDMI_MODE_DVI_EN, HDMI_MODE_MASK);
+	hdmi_write_mask(hdev, HDMI_CON_2, ~0,
+		HDMI_DVI_PERAMBLE_EN | HDMI_DVI_BAND_EN);
+	/* disable bluescreen */
+	hdmi_write_mask(hdev, HDMI_CON_0, 0, HDMI_BLUE_SCR_EN);
+	/* choose bluescreen (fecal) color */
+	hdmi_writeb(hdev, HDMI_BLUE_SCREEN_B_0, 0x12);
+	hdmi_writeb(hdev, HDMI_BLUE_SCREEN_G_0, 0x34);
+	hdmi_writeb(hdev, HDMI_BLUE_SCREEN_R_0, 0x56);
+}
+
+void hdmi_timing_apply(struct hdmi_device *hdev,
+	const struct hdmi_preset_conf *conf)
+{
+	const struct hdmi_core_regs *core = &conf->core;
+	const struct hdmi_tg_regs *tg = &conf->tg;
+
+	/* setting core registers */
+	hdmi_writeb(hdev, HDMI_H_BLANK_0, core->h_blank[0]);
+	hdmi_writeb(hdev, HDMI_H_BLANK_1, core->h_blank[1]);
+	hdmi_writeb(hdev, HDMI_V2_BLANK_0, core->v2_blank[0]);
+	hdmi_writeb(hdev, HDMI_V2_BLANK_1, core->v2_blank[1]);
+	hdmi_writeb(hdev, HDMI_V1_BLANK_0, core->v1_blank[0]);
+	hdmi_writeb(hdev, HDMI_V1_BLANK_1, core->v1_blank[1]);
+	hdmi_writeb(hdev, HDMI_V_LINE_0, core->v_line[0]);
+	hdmi_writeb(hdev, HDMI_V_LINE_1, core->v_line[1]);
+	hdmi_writeb(hdev, HDMI_H_LINE_0, core->h_line[0]);
+	hdmi_writeb(hdev, HDMI_H_LINE_1, core->h_line[1]);
+	hdmi_writeb(hdev, HDMI_HSYNC_POL, core->hsync_pol[0]);
+	hdmi_writeb(hdev, HDMI_VSYNC_POL, core->vsync_pol[0]);
+	hdmi_writeb(hdev, HDMI_INT_PRO_MODE, core->int_pro_mode[0]);
+	hdmi_writeb(hdev, HDMI_V_BLANK_F0_0, core->v_blank_f0[0]);
+	hdmi_writeb(hdev, HDMI_V_BLANK_F0_1, core->v_blank_f0[1]);
+	hdmi_writeb(hdev, HDMI_V_BLANK_F1_0, core->v_blank_f1[0]);
+	hdmi_writeb(hdev, HDMI_V_BLANK_F1_1, core->v_blank_f1[1]);
+	hdmi_writeb(hdev, HDMI_H_SYNC_START_0, core->h_sync_start[0]);
+	hdmi_writeb(hdev, HDMI_H_SYNC_START_1, core->h_sync_start[1]);
+	hdmi_writeb(hdev, HDMI_H_SYNC_END_0, core->h_sync_end[0]);
+	hdmi_writeb(hdev, HDMI_H_SYNC_END_1, core->h_sync_end[1]);
+	hdmi_writeb(hdev, HDMI_V_SYNC_LINE_BEF_2_0, core->v_sync_line_bef_2[0]);
+	hdmi_writeb(hdev, HDMI_V_SYNC_LINE_BEF_2_1, core->v_sync_line_bef_2[1]);
+	hdmi_writeb(hdev, HDMI_V_SYNC_LINE_BEF_1_0, core->v_sync_line_bef_1[0]);
+	hdmi_writeb(hdev, HDMI_V_SYNC_LINE_BEF_1_1, core->v_sync_line_bef_1[1]);
+	hdmi_writeb(hdev, HDMI_V_SYNC_LINE_AFT_2_0, core->v_sync_line_aft_2[0]);
+	hdmi_writeb(hdev, HDMI_V_SYNC_LINE_AFT_2_1, core->v_sync_line_aft_2[1]);
+	hdmi_writeb(hdev, HDMI_V_SYNC_LINE_AFT_1_0, core->v_sync_line_aft_1[0]);
+	hdmi_writeb(hdev, HDMI_V_SYNC_LINE_AFT_1_1, core->v_sync_line_aft_1[1]);
+	hdmi_writeb(hdev, HDMI_V_SYNC_LINE_AFT_PXL_2_0,
+			core->v_sync_line_aft_pxl_2[0]);
+	hdmi_writeb(hdev, HDMI_V_SYNC_LINE_AFT_PXL_2_1,
+			core->v_sync_line_aft_pxl_2[1]);
+	hdmi_writeb(hdev, HDMI_V_SYNC_LINE_AFT_PXL_1_0,
+			core->v_sync_line_aft_pxl_1[0]);
+	hdmi_writeb(hdev, HDMI_V_SYNC_LINE_AFT_PXL_1_1,
+			core->v_sync_line_aft_pxl_1[1]);
+	hdmi_writeb(hdev, HDMI_V_BLANK_F2_0, core->v_blank_f2[0]);
+	hdmi_writeb(hdev, HDMI_V_BLANK_F2_1, core->v_blank_f2[1]);
+	hdmi_writeb(hdev, HDMI_V_BLANK_F3_0, core->v_blank_f3[0]);
+	hdmi_writeb(hdev, HDMI_V_BLANK_F3_1, core->v_blank_f3[1]);
+	hdmi_writeb(hdev, HDMI_V_BLANK_F4_0, core->v_blank_f4[0]);
+	hdmi_writeb(hdev, HDMI_V_BLANK_F4_1, core->v_blank_f4[1]);
+	hdmi_writeb(hdev, HDMI_V_BLANK_F5_0, core->v_blank_f5[0]);
+	hdmi_writeb(hdev, HDMI_V_BLANK_F5_1, core->v_blank_f5[1]);
+	hdmi_writeb(hdev, HDMI_V_SYNC_LINE_AFT_3_0, core->v_sync_line_aft_3[0]);
+	hdmi_writeb(hdev, HDMI_V_SYNC_LINE_AFT_3_1, core->v_sync_line_aft_3[1]);
+	hdmi_writeb(hdev, HDMI_V_SYNC_LINE_AFT_4_0, core->v_sync_line_aft_4[0]);
+	hdmi_writeb(hdev, HDMI_V_SYNC_LINE_AFT_4_1, core->v_sync_line_aft_4[1]);
+	hdmi_writeb(hdev, HDMI_V_SYNC_LINE_AFT_5_0, core->v_sync_line_aft_5[0]);
+	hdmi_writeb(hdev, HDMI_V_SYNC_LINE_AFT_5_1, core->v_sync_line_aft_5[1]);
+	hdmi_writeb(hdev, HDMI_V_SYNC_LINE_AFT_6_0, core->v_sync_line_aft_6[0]);
+	hdmi_writeb(hdev, HDMI_V_SYNC_LINE_AFT_6_1, core->v_sync_line_aft_6[1]);
+	hdmi_writeb(hdev, HDMI_V_SYNC_LINE_AFT_PXL_3_0,
+			core->v_sync_line_aft_pxl_3[0]);
+	hdmi_writeb(hdev, HDMI_V_SYNC_LINE_AFT_PXL_3_1,
+			core->v_sync_line_aft_pxl_3[1]);
+	hdmi_writeb(hdev, HDMI_V_SYNC_LINE_AFT_PXL_4_0,
+			core->v_sync_line_aft_pxl_4[0]);
+	hdmi_writeb(hdev, HDMI_V_SYNC_LINE_AFT_PXL_4_1,
+			core->v_sync_line_aft_pxl_4[1]);
+	hdmi_writeb(hdev, HDMI_V_SYNC_LINE_AFT_PXL_5_0,
+			core->v_sync_line_aft_pxl_5[0]);
+	hdmi_writeb(hdev, HDMI_V_SYNC_LINE_AFT_PXL_5_1,
+			core->v_sync_line_aft_pxl_5[1]);
+	hdmi_writeb(hdev, HDMI_V_SYNC_LINE_AFT_PXL_6_0,
+			core->v_sync_line_aft_pxl_6[0]);
+	hdmi_writeb(hdev, HDMI_V_SYNC_LINE_AFT_PXL_6_1,
+			core->v_sync_line_aft_pxl_6[1]);
+	hdmi_writeb(hdev, HDMI_VACT_SPACE_1_0, core->vact_space_1[0]);
+	hdmi_writeb(hdev, HDMI_VACT_SPACE_1_1, core->vact_space_1[1]);
+	hdmi_writeb(hdev, HDMI_VACT_SPACE_2_0, core->vact_space_2[0]);
+	hdmi_writeb(hdev, HDMI_VACT_SPACE_2_1, core->vact_space_2[1]);
+	hdmi_writeb(hdev, HDMI_VACT_SPACE_3_0, core->vact_space_3[0]);
+	hdmi_writeb(hdev, HDMI_VACT_SPACE_3_1, core->vact_space_3[1]);
+	hdmi_writeb(hdev, HDMI_VACT_SPACE_4_0, core->vact_space_4[0]);
+	hdmi_writeb(hdev, HDMI_VACT_SPACE_4_1, core->vact_space_4[1]);
+	hdmi_writeb(hdev, HDMI_VACT_SPACE_5_0, core->vact_space_5[0]);
+	hdmi_writeb(hdev, HDMI_VACT_SPACE_5_1, core->vact_space_5[1]);
+	hdmi_writeb(hdev, HDMI_VACT_SPACE_6_0, core->vact_space_6[0]);
+	hdmi_writeb(hdev, HDMI_VACT_SPACE_6_1, core->vact_space_6[1]);
+
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
+int hdmi_conf_apply(struct hdmi_device *hdmi_dev)
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
+int is_hdmiphy_ready(struct hdmi_device *hdev)
+{
+	u32 val = hdmi_read(hdev, HDMI_PHY_STATUS);
+	if (val & HDMI_PHY_STATUS_READY)
+		return 1;
+
+	return 0;
+}
+
+void hdmi_enable(struct hdmi_device *hdev, int on)
+{
+	if (on)
+		hdmi_write_mask(hdev, HDMI_CON_0, ~0, HDMI_EN);
+	else
+		hdmi_write_mask(hdev, HDMI_CON_0, 0, HDMI_EN);
+}
+
+void hdmi_hpd_enable(struct hdmi_device *hdev, int on)
+{
+	/* enable HPD interrupts */
+	hdmi_write_mask(hdev, HDMI_INTC_CON_0, ~0, HDMI_INTC_EN_GLOBAL |
+			HDMI_INTC_EN_HPD_PLUG | HDMI_INTC_EN_HPD_UNPLUG);
+}
+
+void hdmi_tg_enable(struct hdmi_device *hdev, int on)
+{
+	u32 mask;
+
+	mask = (hdev->cur_conf->mbus_fmt.field == V4L2_FIELD_INTERLACED) ?
+			HDMI_TG_EN | HDMI_FIELD_EN : HDMI_TG_EN;
+
+	if (on)
+		hdmi_write_mask(hdev, HDMI_TG_CMD, ~0, mask);
+	else
+		hdmi_write_mask(hdev, HDMI_TG_CMD, 0, mask);
+}
+
+void hdmi_dumpregs(struct hdmi_device *hdev, char *prefix)
+{
+#define DUMPREG(reg_id) \
+	dev_dbg(hdev->dev, "%s:" #reg_id " = %08x\n", prefix, \
+		readl(hdev->regs + reg_id))
+
+	dev_dbg(hdev->dev, "%s: ---- CONTROL REGISTERS ----\n", prefix);
+	DUMPREG(HDMI_INTC_CON_0);
+	DUMPREG(HDMI_INTC_FLAG_0);
+	DUMPREG(HDMI_HPD_STATUS);
+	DUMPREG(HDMI_INTC_CON_1);
+	DUMPREG(HDMI_INTC_FLAG_1);
+	DUMPREG(HDMI_PHY_STATUS_0);
+	DUMPREG(HDMI_PHY_STATUS_PLL);
+	DUMPREG(HDMI_PHY_CON_0);
+	DUMPREG(HDMI_PHY_RSTOUT);
+	DUMPREG(HDMI_PHY_VPLL);
+	DUMPREG(HDMI_PHY_CMU);
+	DUMPREG(HDMI_CORE_RSTOUT);
+
+	dev_dbg(hdev->dev, "%s: ---- CORE REGISTERS ----\n", prefix);
+	DUMPREG(HDMI_CON_0);
+	DUMPREG(HDMI_CON_1);
+	DUMPREG(HDMI_CON_2);
+	DUMPREG(HDMI_STATUS);
+	DUMPREG(HDMI_PHY_STATUS);
+	DUMPREG(HDMI_STATUS_EN);
+	DUMPREG(HDMI_HPD);
+	DUMPREG(HDMI_MODE_SEL);
+	DUMPREG(HDMI_ENC_EN);
+	DUMPREG(HDMI_DC_CONTROL);
+	DUMPREG(HDMI_VIDEO_PATTERN_GEN);
+
+	dev_dbg(hdev->dev, "%s: ---- CORE SYNC REGISTERS ----\n", prefix);
+	DUMPREG(HDMI_H_BLANK_0);
+	DUMPREG(HDMI_H_BLANK_1);
+	DUMPREG(HDMI_V2_BLANK_0);
+	DUMPREG(HDMI_V2_BLANK_1);
+	DUMPREG(HDMI_V1_BLANK_0);
+	DUMPREG(HDMI_V1_BLANK_1);
+	DUMPREG(HDMI_V_LINE_0);
+	DUMPREG(HDMI_V_LINE_1);
+	DUMPREG(HDMI_H_LINE_0);
+	DUMPREG(HDMI_H_LINE_1);
+	DUMPREG(HDMI_HSYNC_POL);
+
+	DUMPREG(HDMI_VSYNC_POL);
+	DUMPREG(HDMI_INT_PRO_MODE);
+	DUMPREG(HDMI_V_BLANK_F0_0);
+	DUMPREG(HDMI_V_BLANK_F0_1);
+	DUMPREG(HDMI_V_BLANK_F1_0);
+	DUMPREG(HDMI_V_BLANK_F1_1);
+
+	DUMPREG(HDMI_H_SYNC_START_0);
+	DUMPREG(HDMI_H_SYNC_START_1);
+	DUMPREG(HDMI_H_SYNC_END_0);
+	DUMPREG(HDMI_H_SYNC_END_1);
+
+	DUMPREG(HDMI_V_SYNC_LINE_BEF_2_0);
+	DUMPREG(HDMI_V_SYNC_LINE_BEF_2_1);
+	DUMPREG(HDMI_V_SYNC_LINE_BEF_1_0);
+	DUMPREG(HDMI_V_SYNC_LINE_BEF_1_1);
+
+	DUMPREG(HDMI_V_SYNC_LINE_AFT_2_0);
+	DUMPREG(HDMI_V_SYNC_LINE_AFT_2_1);
+	DUMPREG(HDMI_V_SYNC_LINE_AFT_1_0);
+	DUMPREG(HDMI_V_SYNC_LINE_AFT_1_1);
+
+	DUMPREG(HDMI_V_SYNC_LINE_AFT_PXL_2_0);
+	DUMPREG(HDMI_V_SYNC_LINE_AFT_PXL_2_1);
+	DUMPREG(HDMI_V_SYNC_LINE_AFT_PXL_1_0);
+	DUMPREG(HDMI_V_SYNC_LINE_AFT_PXL_1_1);
+
+	DUMPREG(HDMI_V_BLANK_F2_0);
+	DUMPREG(HDMI_V_BLANK_F2_1);
+	DUMPREG(HDMI_V_BLANK_F3_0);
+	DUMPREG(HDMI_V_BLANK_F3_1);
+	DUMPREG(HDMI_V_BLANK_F4_0);
+	DUMPREG(HDMI_V_BLANK_F4_1);
+	DUMPREG(HDMI_V_BLANK_F5_0);
+	DUMPREG(HDMI_V_BLANK_F5_1);
+
+	DUMPREG(HDMI_V_SYNC_LINE_AFT_3_0);
+	DUMPREG(HDMI_V_SYNC_LINE_AFT_3_1);
+	DUMPREG(HDMI_V_SYNC_LINE_AFT_4_0);
+	DUMPREG(HDMI_V_SYNC_LINE_AFT_4_1);
+	DUMPREG(HDMI_V_SYNC_LINE_AFT_5_0);
+	DUMPREG(HDMI_V_SYNC_LINE_AFT_5_1);
+	DUMPREG(HDMI_V_SYNC_LINE_AFT_6_0);
+	DUMPREG(HDMI_V_SYNC_LINE_AFT_6_1);
+
+	DUMPREG(HDMI_V_SYNC_LINE_AFT_PXL_3_0);
+	DUMPREG(HDMI_V_SYNC_LINE_AFT_PXL_3_1);
+	DUMPREG(HDMI_V_SYNC_LINE_AFT_PXL_4_0);
+	DUMPREG(HDMI_V_SYNC_LINE_AFT_PXL_4_1);
+	DUMPREG(HDMI_V_SYNC_LINE_AFT_PXL_5_0);
+	DUMPREG(HDMI_V_SYNC_LINE_AFT_PXL_5_1);
+	DUMPREG(HDMI_V_SYNC_LINE_AFT_PXL_6_0);
+	DUMPREG(HDMI_V_SYNC_LINE_AFT_PXL_6_1);
+
+	DUMPREG(HDMI_VACT_SPACE_1_0);
+	DUMPREG(HDMI_VACT_SPACE_1_1);
+	DUMPREG(HDMI_VACT_SPACE_2_0);
+	DUMPREG(HDMI_VACT_SPACE_2_1);
+	DUMPREG(HDMI_VACT_SPACE_3_0);
+	DUMPREG(HDMI_VACT_SPACE_3_1);
+	DUMPREG(HDMI_VACT_SPACE_4_0);
+	DUMPREG(HDMI_VACT_SPACE_4_1);
+	DUMPREG(HDMI_VACT_SPACE_5_0);
+	DUMPREG(HDMI_VACT_SPACE_5_1);
+	DUMPREG(HDMI_VACT_SPACE_6_0);
+	DUMPREG(HDMI_VACT_SPACE_6_1);
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
+	DUMPREG(HDMI_TG_VACT_ST3_L);
+	DUMPREG(HDMI_TG_VACT_ST3_H);
+	DUMPREG(HDMI_TG_VACT_ST4_L);
+	DUMPREG(HDMI_TG_VACT_ST4_H);
+	DUMPREG(HDMI_TG_VSYNC_TOP_HDMI_L);
+	DUMPREG(HDMI_TG_VSYNC_TOP_HDMI_H);
+	DUMPREG(HDMI_TG_VSYNC_BOT_HDMI_L);
+	DUMPREG(HDMI_TG_VSYNC_BOT_HDMI_H);
+	DUMPREG(HDMI_TG_FIELD_TOP_HDMI_L);
+	DUMPREG(HDMI_TG_FIELD_TOP_HDMI_H);
+	DUMPREG(HDMI_TG_FIELD_BOT_HDMI_L);
+	DUMPREG(HDMI_TG_FIELD_BOT_HDMI_H);
+	DUMPREG(HDMI_TG_3D);
+
+#undef DUMPREG
+}
diff --git a/drivers/media/video/s5p-tv/hdmiphy_conf_v13.c b/drivers/media/video/s5p-tv/hdmiphy_conf_v13.c
new file mode 100644
index 0000000..16191c3
--- /dev/null
+++ b/drivers/media/video/s5p-tv/hdmiphy_conf_v13.c
@@ -0,0 +1,52 @@
+/*
+ * Samsung HDMI Physical interface driver
+ *
+ * Copyright (C) 2010-2011 Samsung Electronics Co.Ltd
+ * Author: Jiun Yu <jiun.yu@samsung.com>
+ *
+ * This program is free software; you can redistribute  it and/or modify it
+ * under  the terms of  the GNU General  Public License as published by the
+ * Free Software Foundation;  either version 2 of the  License, or (at your
+ * option) any later version.
+ */
+
+#include "hdmi.h"
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
+	0x84, 0x00, 0x10, 0x38, 0x00, 0x08, 0x10, 0xe0,
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
+const struct hdmiphy_conf hdmiphy_conf[] = {
+	{ V4L2_DV_480P59_94, hdmiphy_conf27 },
+	{ V4L2_DV_1080P30, hdmiphy_conf74_175 },
+	{ V4L2_DV_720P59_94, hdmiphy_conf74_175 },
+	{ V4L2_DV_720P60, hdmiphy_conf74_25 },
+	{ V4L2_DV_1080P50, hdmiphy_conf148_5 },
+	{ V4L2_DV_1080P60, hdmiphy_conf148_5 },
+};
+
+const int hdmiphy_conf_cnt = ARRAY_SIZE(hdmiphy_conf);
diff --git a/drivers/media/video/s5p-tv/hdmiphy_conf_v14.c b/drivers/media/video/s5p-tv/hdmiphy_conf_v14.c
new file mode 100644
index 0000000..a130a20
--- /dev/null
+++ b/drivers/media/video/s5p-tv/hdmiphy_conf_v14.c
@@ -0,0 +1,52 @@
+/*
+ * Samsung HDMI Physical interface driver
+ *
+ * Copyright (C) 2010-2011 Samsung Electronics Co.Ltd
+ * Author: Jiun Yu <jiun.yu@samsung.com>
+ *
+ * This program is free software; you can redistribute  it and/or modify it
+ * under  the terms of  the GNU General  Public License as published by the
+ * Free Software Foundation;  either version 2 of the  License, or (at your
+ * option) any later version.
+ */
+
+#include "hdmi.h"
+
+static const u8 hdmiphy_conf27[32] = {
+	0x01, 0x51, 0x2d, 0x75, 0x40, 0x01, 0x00, 0x08,
+	0x82, 0xa0, 0x0e, 0xd9, 0x45, 0xa0, 0xac, 0x80,
+	0x08, 0x80, 0x11, 0x04, 0x02, 0x22, 0x44, 0x86,
+	0x54, 0xe3, 0x24, 0x00, 0x00, 0x00, 0x01, 0x00,
+};
+
+static const u8 hdmiphy_conf74_175[32] = {
+	0x01, 0xd1, 0x1f, 0x10, 0x40, 0x5b, 0xef, 0x08,
+	0x81, 0xa0, 0xb9, 0xd8, 0x45, 0xa0, 0xac, 0x80,
+	0x5a, 0x80, 0x11, 0x04, 0x02, 0x22, 0x44, 0x86,
+	0x54, 0xa6, 0x24, 0x01, 0x00, 0x00, 0x01, 0x00,
+};
+
+static const u8 hdmiphy_conf74_25[32] = {
+	0x01, 0xd1, 0x1f, 0x10, 0x40, 0x40, 0xf8, 0x08,
+	0x81, 0xa0, 0xba, 0xd8, 0x45, 0xa0, 0xac, 0x80,
+	0x3c, 0x80, 0x11, 0x04, 0x02, 0x22, 0x44, 0x86,
+	0x54, 0xa5, 0x24, 0x01, 0x00, 0x00, 0x01, 0x00,
+};
+
+static const u8 hdmiphy_conf148_5[32] = {
+	0x01, 0xd1, 0x1f, 0x00, 0x40, 0x40, 0xf8, 0x08,
+	0x81, 0xa0, 0xba, 0xd8, 0x45, 0xa0, 0xac, 0x80,
+	0x3c, 0x80, 0x11, 0x04, 0x02, 0x22, 0x44, 0x86,
+	0x54, 0x4b, 0x25, 0x03, 0x00, 0x00, 0x01, 0x00,
+};
+
+const struct hdmiphy_conf hdmiphy_conf[] = {
+	{ V4L2_DV_480P59_94, hdmiphy_conf27 },
+	{ V4L2_DV_720P59_94, hdmiphy_conf74_175 },
+	{ V4L2_DV_720P60, hdmiphy_conf74_25 },
+	{ V4L2_DV_1080P30, hdmiphy_conf74_175 },
+	{ V4L2_DV_1080P50, hdmiphy_conf148_5 },
+	{ V4L2_DV_1080P60, hdmiphy_conf148_5 },
+};
+
+const int hdmiphy_conf_cnt = ARRAY_SIZE(hdmiphy_conf);
diff --git a/drivers/media/video/s5p-tv/hdmiphy_drv.c b/drivers/media/video/s5p-tv/hdmiphy_drv.c
index 6693f4a..3f0cca8 100644
--- a/drivers/media/video/s5p-tv/hdmiphy_drv.c
+++ b/drivers/media/video/s5p-tv/hdmiphy_drv.c
@@ -9,6 +9,7 @@
  * Free Software Foundation;  either version 2 of the  License, or (at your
  * option) any later version.
  */
+#include "hdmi.h"
 
 #include <linux/module.h>
 #include <linux/i2c.h>
@@ -25,52 +26,10 @@ MODULE_AUTHOR("Tomasz Stanislawski <t.stanislaws@samsung.com>");
 MODULE_DESCRIPTION("Samsung HDMI Physical interface driver");
 MODULE_LICENSE("GPL");
 
-struct hdmiphy_conf {
-	u32 preset;
-	const u8 *data;
-};
-
-static const u8 hdmiphy_conf27[32] = {
-	0x01, 0x05, 0x00, 0xD8, 0x10, 0x1C, 0x30, 0x40,
-	0x6B, 0x10, 0x02, 0x51, 0xDf, 0xF2, 0x54, 0x87,
-	0x84, 0x00, 0x30, 0x38, 0x00, 0x08, 0x10, 0xE0,
-	0x22, 0x40, 0xe3, 0x26, 0x00, 0x00, 0x00, 0x00,
-};
-
-static const u8 hdmiphy_conf74_175[32] = {
-	0x01, 0x05, 0x00, 0xD8, 0x10, 0x9C, 0xef, 0x5B,
-	0x6D, 0x10, 0x01, 0x51, 0xef, 0xF3, 0x54, 0xb9,
-	0x84, 0x00, 0x30, 0x38, 0x00, 0x08, 0x10, 0xE0,
-	0x22, 0x40, 0xa5, 0x26, 0x01, 0x00, 0x00, 0x00,
-};
-
-static const u8 hdmiphy_conf74_25[32] = {
-	0x01, 0x05, 0x00, 0xd8, 0x10, 0x9c, 0xf8, 0x40,
-	0x6a, 0x10, 0x01, 0x51, 0xff, 0xf1, 0x54, 0xba,
-	0x84, 0x00, 0x30, 0x38, 0x00, 0x08, 0x10, 0xe0,
-	0x22, 0x40, 0xa4, 0x26, 0x01, 0x00, 0x00, 0x00,
-};
-
-static const u8 hdmiphy_conf148_5[32] = {
-	0x01, 0x05, 0x00, 0xD8, 0x10, 0x9C, 0xf8, 0x40,
-	0x6A, 0x18, 0x00, 0x51, 0xff, 0xF1, 0x54, 0xba,
-	0x84, 0x00, 0x10, 0x38, 0x00, 0x08, 0x10, 0xE0,
-	0x22, 0x40, 0xa4, 0x26, 0x02, 0x00, 0x00, 0x00,
-};
-
-static const struct hdmiphy_conf hdmiphy_conf[] = {
-	{ V4L2_DV_480P59_94, hdmiphy_conf27 },
-	{ V4L2_DV_1080P30, hdmiphy_conf74_175 },
-	{ V4L2_DV_720P59_94, hdmiphy_conf74_175 },
-	{ V4L2_DV_720P60, hdmiphy_conf74_25 },
-	{ V4L2_DV_1080P50, hdmiphy_conf148_5 },
-	{ V4L2_DV_1080P60, hdmiphy_conf148_5 },
-};
-
 const u8 *hdmiphy_preset2conf(u32 preset)
 {
 	int i;
-	for (i = 0; i < ARRAY_SIZE(hdmiphy_conf); ++i)
+	for (i = 0; i < hdmiphy_conf_cnt; ++i)
 		if (hdmiphy_conf[i].preset == preset)
 			return hdmiphy_conf[i].data;
 	return NULL;
diff --git a/drivers/media/video/s5p-tv/mixer_video.c b/drivers/media/video/s5p-tv/mixer_video.c
index 2ca580b..a91503c 100644
--- a/drivers/media/video/s5p-tv/mixer_video.c
+++ b/drivers/media/video/s5p-tv/mixer_video.c
@@ -825,7 +825,7 @@ static int queue_setup(struct vb2_queue *vq, const struct v4l2_format *pfmt,
 	for (i = 0; i < fmt->num_subframes; ++i) {
 		alloc_ctxs[i] = layer->mdev->alloc_ctx;
 		sizes[i] = PAGE_ALIGN(planes[i].sizeimage);
-		mxr_dbg(mdev, "size[%d] = %08lx\n", i, sizes[i]);
+		mxr_dbg(mdev, "size[%d] = %08x\n", i, sizes[i]);
 	}
 
 	if (*nbuffers == 0)
diff --git a/drivers/media/video/s5p-tv/regs-hdmi-v13.h b/drivers/media/video/s5p-tv/regs-hdmi-v13.h
new file mode 100644
index 0000000..33247d1
--- /dev/null
+++ b/drivers/media/video/s5p-tv/regs-hdmi-v13.h
@@ -0,0 +1,145 @@
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
+/* HDMI_CON_2 */
+#define HDMI_DVI_PERAMBLE_EN		(1 << 5)
+#define HDMI_DVI_BAND_EN		(1 << 1)
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
diff --git a/drivers/media/video/s5p-tv/regs-hdmi-v14.h b/drivers/media/video/s5p-tv/regs-hdmi-v14.h
new file mode 100644
index 0000000..65d0c52
--- /dev/null
+++ b/drivers/media/video/s5p-tv/regs-hdmi-v14.h
@@ -0,0 +1,1273 @@
+/* linux/arch/arm/mach-exynos4/include/mach/regs-hdmi_14.h
+ *
+ * Copyright (c) 2010 Samsung Electronics
+ *		http://www.samsung.com/
+ *
+ * HDMI register header file for Samsung TVOUT driver
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+*/
+
+#ifndef __ARCH_ARM_REGS_HDMI_H
+#define __ARCH_ARM_REGS_HDMI_H
+
+/*
+ * Register part
+*/
+
+#define S5P_HDMI_I2C_PHY_BASE(x)	(x)
+
+#define HDMI_I2C_CON			S5P_HDMI_I2C_PHY_BASE(0x0000)
+#define HDMI_I2C_STAT			S5P_HDMI_I2C_PHY_BASE(0x0004)
+#define HDMI_I2C_ADD			S5P_HDMI_I2C_PHY_BASE(0x0008)
+#define HDMI_I2C_DS			S5P_HDMI_I2C_PHY_BASE(0x000c)
+#define HDMI_I2C_LC			S5P_HDMI_I2C_PHY_BASE(0x0010)
+
+#define HDMI_CTRL_BASE(x)		((x) + 0x00000000)
+#define HDMI_CORE_BASE(x)		((x) + 0x00010000)
+#define HDMI_SPDIF_BASE(x)		((x) + 0x00030000)
+#define HDMI_I2S_BASE(x)		((x) + 0x00040000)
+#define HDMI_TG_BASE(x)			((x) + 0x00050000)
+#define HDMI_EFUSE_BASE(x)		((x) + 0x00060000)
+
+/* Control registers */
+#define HDMI_INTC_CON_0			HDMI_CTRL_BASE(0x0000)
+#define HDMI_INTC_FLAG_0		HDMI_CTRL_BASE(0x0004)
+#define HDMI_HDCP_KEY_LOAD		HDMI_CTRL_BASE(0x0008)
+#define HDMI_HPD_STATUS			HDMI_CTRL_BASE(0x000C)
+
+#define HDMI_INTC_CON_1			HDMI_CTRL_BASE(0x0010)
+#define HDMI_INTC_FLAG_1		HDMI_CTRL_BASE(0x0014)
+#define HDMI_PHY_STATUS_0		HDMI_CTRL_BASE(0x0020)
+#define HDMI_PHY_STATUS_PLL		HDMI_CTRL_BASE(0x0028)
+#define HDMI_PHY_CON_0			HDMI_CTRL_BASE(0x0030)
+
+#define HDMI_HPD_CTRL			HDMI_CTRL_BASE(0x0040)
+#define HDMI_HPD_TH_(n)			HDMI_CTRL_BASE(0x0050 + 4 * (n))
+
+#define HDMI_AUDIO_CLKSEL		HDMI_CTRL_BASE(0x0070)
+#define HDMI_PHY_RSTOUT			HDMI_CTRL_BASE(0x0074)
+#define HDMI_PHY_VPLL			HDMI_CTRL_BASE(0x0078)
+#define HDMI_PHY_CMU			HDMI_CTRL_BASE(0x007C)
+#define HDMI_CORE_RSTOUT		HDMI_CTRL_BASE(0x080)
+
+/* HDMI core registers */
+#define HDMI_CON_0			HDMI_CORE_BASE(0x000)
+#define HDMI_CON_1			HDMI_CORE_BASE(0x004)
+#define HDMI_CON_2			HDMI_CORE_BASE(0x008)
+#define HDMI_SIM_MODE			HDMI_CORE_BASE(0x00C)
+#define HDMI_STATUS			HDMI_CORE_BASE(0x010)
+#define HDMI_PHY_STATUS			HDMI_CORE_BASE(0x014)
+#define HDMI_STATUS_EN			HDMI_CORE_BASE(0x020)
+#define HDMI_HPD			HDMI_CORE_BASE(0x030)
+#define HDMI_MODE_SEL			HDMI_CORE_BASE(0x040)
+#define HDMI_ENC_EN			HDMI_CORE_BASE(0x044)
+
+/* Video related registers */
+#define HDMI_YMAX			HDMI_CORE_BASE(0x060)
+#define HDMI_YMIN			HDMI_CORE_BASE(0x064)
+#define HDMI_CMAX			HDMI_CORE_BASE(0x068)
+#define HDMI_CMIN			HDMI_CORE_BASE(0x06c)
+
+#define HDMI_DI_PREFIX			HDMI_CORE_BASE(0x078)
+#define HDMI_VBI_ST_MG			HDMI_CORE_BASE(0x080)
+#define HDMI_END_MG			HDMI_CORE_BASE(0x084)
+
+#define HDMI_AUTH_ST_MG0		HDMI_CORE_BASE(0x090)
+#define HDMI_AUTH_ST_MG1		HDMI_CORE_BASE(0x094)
+#define HDMI_AUTH_END_MG0		HDMI_CORE_BASE(0x098)
+#define HDMI_AUTH_END_MG1		HDMI_CORE_BASE(0x09C)
+
+#define HDMI_H_BLANK_0			HDMI_CORE_BASE(0x0a0)
+#define HDMI_H_BLANK_1			HDMI_CORE_BASE(0x0a4)
+
+#define HDMI_V2_BLANK_0			HDMI_CORE_BASE(0x0b0)
+#define HDMI_V2_BLANK_1			HDMI_CORE_BASE(0x0b4)
+#define HDMI_V1_BLANK_0			HDMI_CORE_BASE(0x0b8)
+#define HDMI_V1_BLANK_1			HDMI_CORE_BASE(0x0bC)
+
+#define HDMI_V_LINE_0			HDMI_CORE_BASE(0x0c0)
+#define HDMI_V_LINE_1			HDMI_CORE_BASE(0x0c4)
+#define HDMI_H_LINE_0			HDMI_CORE_BASE(0x0c8)
+#define HDMI_H_LINE_1			HDMI_CORE_BASE(0x0cC)
+#define HDMI_HSYNC_POL			HDMI_CORE_BASE(0x0E0)
+
+#define HDMI_VSYNC_POL			HDMI_CORE_BASE(0x0e4)
+#define HDMI_INT_PRO_MODE		HDMI_CORE_BASE(0x0e8)
+
+#define HDMI_V_BLANK_F0_0		HDMI_CORE_BASE(0x110)
+#define HDMI_V_BLANK_F0_1		HDMI_CORE_BASE(0x114)
+#define HDMI_V_BLANK_F1_0		HDMI_CORE_BASE(0x118)
+#define HDMI_V_BLANK_F1_1		HDMI_CORE_BASE(0x11C)
+
+#define HDMI_H_SYNC_START_0		HDMI_CORE_BASE(0x120)
+#define HDMI_H_SYNC_START_1		HDMI_CORE_BASE(0x124)
+#define HDMI_H_SYNC_END_0		HDMI_CORE_BASE(0x128)
+#define HDMI_H_SYNC_END_1		HDMI_CORE_BASE(0x12C)
+
+#define HDMI_V_SYNC_LINE_BEF_2_0	HDMI_CORE_BASE(0x130)
+#define HDMI_V_SYNC_LINE_BEF_2_1	HDMI_CORE_BASE(0x134)
+#define HDMI_V_SYNC_LINE_BEF_1_0	HDMI_CORE_BASE(0x138)
+#define HDMI_V_SYNC_LINE_BEF_1_1	HDMI_CORE_BASE(0x13C)
+
+#define HDMI_V_SYNC_LINE_AFT_2_0	HDMI_CORE_BASE(0x140)
+#define HDMI_V_SYNC_LINE_AFT_2_1	HDMI_CORE_BASE(0x144)
+#define HDMI_V_SYNC_LINE_AFT_1_0	HDMI_CORE_BASE(0x148)
+#define HDMI_V_SYNC_LINE_AFT_1_1	HDMI_CORE_BASE(0x14C)
+
+#define HDMI_V_SYNC_LINE_AFT_PXL_2_0	HDMI_CORE_BASE(0x150)
+#define HDMI_V_SYNC_LINE_AFT_PXL_2_1	HDMI_CORE_BASE(0x154)
+#define HDMI_V_SYNC_LINE_AFT_PXL_1_0	HDMI_CORE_BASE(0x158)
+#define HDMI_V_SYNC_LINE_AFT_PXL_1_1	HDMI_CORE_BASE(0x15C)
+
+#define HDMI_V_BLANK_F2_0		HDMI_CORE_BASE(0x160)
+#define HDMI_V_BLANK_F2_1		HDMI_CORE_BASE(0x164)
+#define HDMI_V_BLANK_F3_0		HDMI_CORE_BASE(0x168)
+#define HDMI_V_BLANK_F3_1		HDMI_CORE_BASE(0x16C)
+#define HDMI_V_BLANK_F4_0		HDMI_CORE_BASE(0x170)
+#define HDMI_V_BLANK_F4_1		HDMI_CORE_BASE(0x174)
+#define HDMI_V_BLANK_F5_0		HDMI_CORE_BASE(0x178)
+#define HDMI_V_BLANK_F5_1		HDMI_CORE_BASE(0x17C)
+
+#define HDMI_V_SYNC_LINE_AFT_3_0	HDMI_CORE_BASE(0x180)
+#define HDMI_V_SYNC_LINE_AFT_3_1	HDMI_CORE_BASE(0x184)
+#define HDMI_V_SYNC_LINE_AFT_4_0	HDMI_CORE_BASE(0x188)
+#define HDMI_V_SYNC_LINE_AFT_4_1	HDMI_CORE_BASE(0x18C)
+#define HDMI_V_SYNC_LINE_AFT_5_0	HDMI_CORE_BASE(0x190)
+#define HDMI_V_SYNC_LINE_AFT_5_1	HDMI_CORE_BASE(0x194)
+#define HDMI_V_SYNC_LINE_AFT_6_0	HDMI_CORE_BASE(0x198)
+#define HDMI_V_SYNC_LINE_AFT_6_1	HDMI_CORE_BASE(0x19C)
+
+#define HDMI_V_SYNC_LINE_AFT_PXL_3_0	HDMI_CORE_BASE(0x1A0)
+#define HDMI_V_SYNC_LINE_AFT_PXL_3_1	HDMI_CORE_BASE(0x1A4)
+#define HDMI_V_SYNC_LINE_AFT_PXL_4_0	HDMI_CORE_BASE(0x1A8)
+#define HDMI_V_SYNC_LINE_AFT_PXL_4_1	HDMI_CORE_BASE(0x1AC)
+#define HDMI_V_SYNC_LINE_AFT_PXL_5_0	HDMI_CORE_BASE(0x1B0)
+#define HDMI_V_SYNC_LINE_AFT_PXL_5_1	HDMI_CORE_BASE(0x1B4)
+#define HDMI_V_SYNC_LINE_AFT_PXL_6_0	HDMI_CORE_BASE(0x1B8)
+#define HDMI_V_SYNC_LINE_AFT_PXL_6_1	HDMI_CORE_BASE(0x1BC)
+
+#define HDMI_VACT_SPACE_1_0		HDMI_CORE_BASE(0x1C0)
+#define HDMI_VACT_SPACE_1_1		HDMI_CORE_BASE(0x1C4)
+#define HDMI_VACT_SPACE_2_0		HDMI_CORE_BASE(0x1C8)
+#define HDMI_VACT_SPACE_2_1		HDMI_CORE_BASE(0x1CC)
+#define HDMI_VACT_SPACE_3_0		HDMI_CORE_BASE(0x1D0)
+#define HDMI_VACT_SPACE_3_1		HDMI_CORE_BASE(0x1D4)
+#define HDMI_VACT_SPACE_4_0		HDMI_CORE_BASE(0x1D8)
+#define HDMI_VACT_SPACE_4_1		HDMI_CORE_BASE(0x1DC)
+#define HDMI_VACT_SPACE_5_0		HDMI_CORE_BASE(0x1E0)
+#define HDMI_VACT_SPACE_5_1		HDMI_CORE_BASE(0x1E4)
+#define HDMI_VACT_SPACE_6_0		HDMI_CORE_BASE(0x1E8)
+#define HDMI_VACT_SPACE_6_1		HDMI_CORE_BASE(0x1EC)
+#define HDMI_CSC_MUX			HDMI_CORE_BASE(0x1F0)
+#define HDMI_SYNC_GEN_MUX		HDMI_CORE_BASE(0x1F4)
+
+#define HDMI_GCP_CON			HDMI_CORE_BASE(0x200)
+#define HDMI_GCP_CON_EX			HDMI_CORE_BASE(0x204)
+#define HDMI_GCP_BYTE1			HDMI_CORE_BASE(0x210)
+#define HDMI_GCP_BYTE2			HDMI_CORE_BASE(0x214)
+#define HDMI_GCP_BYTE3			HDMI_CORE_BASE(0x218)
+
+/* Audio related registers */
+#define HDMI_ASP_CON			HDMI_CORE_BASE(0x300)
+#define HDMI_ASP_SP_FLAT		HDMI_CORE_BASE(0x304)
+#define HDMI_ASP_CHCFG0			HDMI_CORE_BASE(0x310)
+#define HDMI_ASP_CHCFG1			HDMI_CORE_BASE(0x314)
+#define HDMI_ASP_CHCFG2			HDMI_CORE_BASE(0x318)
+#define HDMI_ASP_CHCFG3			HDMI_CORE_BASE(0x31c)
+
+#define HDMI_ACR_CON			HDMI_CORE_BASE(0x400)
+#define HDMI_ACR_MCTS0			HDMI_CORE_BASE(0x410)
+#define HDMI_ACR_MCTS1			HDMI_CORE_BASE(0x414)
+#define HDMI_ACR_MCTS2			HDMI_CORE_BASE(0x418)
+#define HDMI_ACR_CTS0			HDMI_CORE_BASE(0x420)
+#define HDMI_ACR_CTS1			HDMI_CORE_BASE(0x424)
+#define HDMI_ACR_CTS2			HDMI_CORE_BASE(0x428)
+#define HDMI_ACR_N0			HDMI_CORE_BASE(0x430)
+#define HDMI_ACR_N1			HDMI_CORE_BASE(0x434)
+#define HDMI_ACR_N2			HDMI_CORE_BASE(0x438)
+#define HDMI_ACR_LSB2			HDMI_CORE_BASE(0x440)
+#define HDMI_ACR_TXCNT			HDMI_CORE_BASE(0x444)
+#define HDMI_ACR_TXINTERNAL		HDMI_CORE_BASE(0x448)
+#define HDMI_ACR_CTS_OFFSET		HDMI_CORE_BASE(0x44c)
+
+#define HDMI_ACP_CON			HDMI_CORE_BASE(0x500)
+#define HDMI_ACP_TYPE			HDMI_CORE_BASE(0x514)
+/* offset of HDMI_ACP_DATA00 ~ 16 : 0x0520 ~ 0x0560 */
+#define HDMI_ACP_DATA(n)		HDMI_CORE_BASE(0x520 + 4 * (n))
+
+#define HDMI_ISRC_CON			HDMI_CORE_BASE(0x600)
+#define HDMI_ISRC1_HEADER1		HDMI_CORE_BASE(0x614)
+/* offset of HDMI_ISRC1_DATA00 ~ 15 : 0x0620 ~ 0x065C */
+#define HDMI_ISRC1_DATA(n)		HDMI_CORE_BASE(0x620 + 4 * (n))
+/* offset of HDMI_ISRC2_DATA00 ~ 15 : 0x06A0 ~ 0x06DC */
+#define HDMI_ISRC2_DATA(n)		HDMI_CORE_BASE(0x6A0 + 4 * (n))
+
+#define HDMI_AVI_CON			HDMI_CORE_BASE(0x700)
+#define HDMI_AVI_HEADER0		HDMI_CORE_BASE(0x710)
+#define HDMI_AVI_HEADER1		HDMI_CORE_BASE(0x714)
+#define HDMI_AVI_HEADER2		HDMI_CORE_BASE(0x718)
+#define HDMI_AVI_CHECK_SUM		HDMI_CORE_BASE(0x71C)
+/* offset of HDMI_AVI_BYTE1 ~ 13 : 0x0720 ~ 0x0750 */
+#define HDMI_AVI_BYTE(n)		HDMI_CORE_BASE(0x720 + 4 * (n - 1))
+
+#define HDMI_AUI_CON			HDMI_CORE_BASE(0x800)
+#define HDMI_AUI_HEADER0		HDMI_CORE_BASE(0x810)
+#define HDMI_AUI_HEADER1		HDMI_CORE_BASE(0x814)
+#define HDMI_AUI_HEADER2		HDMI_CORE_BASE(0x818)
+#define HDMI_AUI_CHECK_SUM		HDMI_CORE_BASE(0x81C)
+/* offset of HDMI_AUI_BYTE1 ~ 12 : 0x0820 ~ 0x084C */
+#define HDMI_AUI_BYTE(n)		HDMI_CORE_BASE(0x820 + 4 * (n - 1))
+
+#define HDMI_MPG_CON			HDMI_CORE_BASE(0x900)
+#define HDMI_MPG_CHECK_SUM		HDMI_CORE_BASE(0x91C)
+/* offset of HDMI_MPG_BYTE1 ~ 6 : 0x0920 ~ 0x0934 */
+#define HDMI_MPG_BYTE(n)		HDMI_CORE_BASE(0x920 + 4 * (n - 1))
+
+#define HDMI_SPD_CON			HDMI_CORE_BASE(0xA00)
+#define HDMI_SPD_HEADER0		HDMI_CORE_BASE(0xA10)
+#define HDMI_SPD_HEADER1		HDMI_CORE_BASE(0xA14)
+#define HDMI_SPD_HEADER2		HDMI_CORE_BASE(0xA18)
+/* offset of HDMI_SPD_DATA00 ~ 27 : 0x0A20 ~ 0x0A8C */
+#define HDMI_SPD_DATA0(n)		HDMI_CORE_BASE(0xA20 + 4 * (n))
+
+#define HDMI_GAMUT_CON			HDMI_CORE_BASE(0xB00)
+#define HDMI_GAMUT_HEADER0		HDMI_CORE_BASE(0xB10)
+#define HDMI_GAMUT_HEADER1		HDMI_CORE_BASE(0xB14)
+#define HDMI_GAMUT_HEADER2		HDMI_CORE_BASE(0xB18)
+/* offset of HDMI_GAMUT_METADATA00 ~ 27 : 0x0B20 ~ 0x0B8C */
+#define HDMI_GAMUT_METADATA(n)		HDMI_CORE_BASE(0xB20 + 4 * (n))
+
+#define HDMI_VSI_CON			HDMI_CORE_BASE(0xC00)
+#define HDMI_VSI_HEADER0		HDMI_CORE_BASE(0xC10)
+#define HDMI_VSI_HEADER1		HDMI_CORE_BASE(0xC14)
+#define HDMI_VSI_HEADER2		HDMI_CORE_BASE(0xC18)
+/* offset of HDMI_VSI_DATA00 ~ 27 : 0x0C20 ~ 0x0C8C */
+#define HDMI_VSI_DATA(n)		HDMI_CORE_BASE(0xC20 + 4 * (n))
+
+#define HDMI_DC_CONTROL			HDMI_CORE_BASE(0xD00)
+#define HDMI_VIDEO_PATTERN_GEN		HDMI_CORE_BASE(0xD04)
+#define HDMI_HPD_GEN0			HDMI_CORE_BASE(0xD08)
+#define HDMI_HPD_GEN1			HDMI_CORE_BASE(0xD0C)
+#define HDMI_HPD_GEN2			HDMI_CORE_BASE(0xD10)
+#define HDMI_HPD_GEN3			HDMI_CORE_BASE(0xD14)
+
+#define HDMI_DIM_CON			HDMI_CORE_BASE(0xD30)
+
+/* HDCP related registers */
+/* offset of HDMI_HDCP_SHA1_00 ~ 19 : 0x7000 ~ 0x704C */
+#define HDMI_HDCP_SHA1_(n)		HDMI_CORE_BASE(0x7000 + 4 * (n))
+
+/* offset of HDMI_HDCP_KSV_LIST_0 ~ 4 : 0x7050 ~ 0x7060 */
+#define HDMI_HDCP_KSV_LIST_(n)		HDMI_CORE_BASE(0x7050 + 4 * (n))
+
+#define HDMI_HDCP_KSV_LIST_CON		HDMI_CORE_BASE(0x7064)
+#define HDMI_HDCP_SHA_RESULT		HDMI_CORE_BASE(0x7070)
+#define HDMI_HDCP_CTRL1			HDMI_CORE_BASE(0x7080)
+#define HDMI_HDCP_CTRL2			HDMI_CORE_BASE(0x7084)
+#define HDMI_HDCP_CHECK_RESULT		HDMI_CORE_BASE(0x7090)
+
+/* offset of HDMI_HDCP_BKSV_0 ~ 4 : 0x70A0 ~ 0x70B0 */
+#define HDMI_HDCP_BKSV_(n)		HDMI_CORE_BASE(0x70A0 + 4 * (n))
+/* offset of HDMI_HDCP_AKSV_0 ~ 4 : 0x70C0 ~ 0x70D0 */
+#define HDMI_HDCP_AKSV_(n)		HDMI_CORE_BASE(0x70C0 + 4 * (n))
+
+/* offset of HDMI_HDCP_AN_0 ~ 7 : 0x70E0 ~ 0x70FC */
+#define HDMI_HDCP_AN_(n)		HDMI_CORE_BASE(0x70E0 + 4 * (n))
+
+#define HDMI_HDCP_BCAPS			HDMI_CORE_BASE(0x7100)
+#define HDMI_HDCP_BSTATUS_0		HDMI_CORE_BASE(0x7110)
+#define HDMI_HDCP_BSTATUS_1		HDMI_CORE_BASE(0x7114)
+#define HDMI_HDCP_RI_0			HDMI_CORE_BASE(0x7140)
+#define HDMI_HDCP_RI_1			HDMI_CORE_BASE(0x7144)
+#define HDMI_HDCP_I2C_INT		HDMI_CORE_BASE(0x7180)
+#define HDMI_HDCP_AN_INT		HDMI_CORE_BASE(0x7190)
+#define HDMI_HDCP_WDT_INT		HDMI_CORE_BASE(0x71a0)
+#define HDMI_HDCP_RI_INT		HDMI_CORE_BASE(0x71b0)
+
+#define HDMI_HDCP_RI_COMPARE_0		HDMI_CORE_BASE(0x71d0)
+#define HDMI_HDCP_RI_COMPARE_1		HDMI_CORE_BASE(0x71d4)
+#define HDMI_HDCP_FRAME_COUNT		HDMI_CORE_BASE(0x71e0)
+
+#define HDMI_RGB_ROUND_EN		HDMI_CORE_BASE(0xD500)
+
+#define HDMI_VACT_SPACE_R_0		HDMI_CORE_BASE(0xD504)
+#define HDMI_VACT_SPACE_R_1		HDMI_CORE_BASE(0xD508)
+
+#define HDMI_VACT_SPACE_G_0		HDMI_CORE_BASE(0xD50C)
+#define HDMI_VACT_SPACE_G_1		HDMI_CORE_BASE(0xD510)
+
+#define HDMI_VACT_SPACE_B_0		HDMI_CORE_BASE(0xD514)
+#define HDMI_VACT_SPACE_B_1		HDMI_CORE_BASE(0xD518)
+
+#define HDMI_BLUE_SCREEN_B_0		HDMI_CORE_BASE(0xD520)
+#define HDMI_BLUE_SCREEN_B_1		HDMI_CORE_BASE(0xD524)
+#define HDMI_BLUE_SCREEN_G_0		HDMI_CORE_BASE(0xD528)
+#define HDMI_BLUE_SCREEN_G_1		HDMI_CORE_BASE(0xD52C)
+#define HDMI_BLUE_SCREEN_R_0		HDMI_CORE_BASE(0xD530)
+#define HDMI_BLUE_SCREEN_R_1		HDMI_CORE_BASE(0xD534)
+
+/* SPDIF registers */
+#define HDMI_SPDIFIN_CLK_CTRL		HDMI_SPDIF_BASE(0x000)
+#define HDMI_SPDIFIN_OP_CTRL		HDMI_SPDIF_BASE(0x004)
+#define HDMI_SPDIFIN_IRQ_MASK		HDMI_SPDIF_BASE(0x008)
+#define HDMI_SPDIFIN_IRQ_STATUS		HDMI_SPDIF_BASE(0x00c)
+#define HDMI_SPDIFIN_CONFIG_1		HDMI_SPDIF_BASE(0x010)
+#define HDMI_SPDIFIN_CONFIG_2		HDMI_SPDIF_BASE(0x014)
+#define HDMI_SPDIFIN_USER_VALUE_1	HDMI_SPDIF_BASE(0x020)
+#define HDMI_SPDIFIN_USER_VALUE_2	HDMI_SPDIF_BASE(0x024)
+#define HDMI_SPDIFIN_USER_VALUE_3	HDMI_SPDIF_BASE(0x028)
+#define HDMI_SPDIFIN_USER_VALUE_4	HDMI_SPDIF_BASE(0x02c)
+#define HDMI_SPDIFIN_CH_STATUS_0_1	HDMI_SPDIF_BASE(0x030)
+#define HDMI_SPDIFIN_CH_STATUS_0_2	HDMI_SPDIF_BASE(0x034)
+#define HDMI_SPDIFIN_CH_STATUS_0_3	HDMI_SPDIF_BASE(0x038)
+#define HDMI_SPDIFIN_CH_STATUS_0_4	HDMI_SPDIF_BASE(0x03c)
+#define HDMI_SPDIFIN_CH_STATUS_1	HDMI_SPDIF_BASE(0x040)
+#define HDMI_SPDIFIN_FRAME_PERIOD_1	HDMI_SPDIF_BASE(0x048)
+#define HDMI_SPDIFIN_FRAME_PERIOD_2	HDMI_SPDIF_BASE(0x04c)
+#define HDMI_SPDIFIN_PC_INFO_1		HDMI_SPDIF_BASE(0x050)
+#define HDMI_SPDIFIN_PC_INFO_2		HDMI_SPDIF_BASE(0x054)
+#define HDMI_SPDIFIN_PD_INFO_1		HDMI_SPDIF_BASE(0x058)
+#define HDMI_SPDIFIN_PD_INFO_2		HDMI_SPDIF_BASE(0x05c)
+#define HDMI_SPDIFIN_DATA_BUF_0_1	HDMI_SPDIF_BASE(0x060)
+#define HDMI_SPDIFIN_DATA_BUF_0_2	HDMI_SPDIF_BASE(0x064)
+#define HDMI_SPDIFIN_DATA_BUF_0_3	HDMI_SPDIF_BASE(0x068)
+#define HDMI_SPDIFIN_USER_BUF_0		HDMI_SPDIF_BASE(0x06c)
+#define HDMI_SPDIFIN_DATA_BUF_1_1	HDMI_SPDIF_BASE(0x070)
+#define HDMI_SPDIFIN_DATA_BUF_1_2	HDMI_SPDIF_BASE(0x074)
+#define HDMI_SPDIFIN_DATA_BUF_1_3	HDMI_SPDIF_BASE(0x078)
+#define HDMI_SPDIFIN_USER_BUF_1		HDMI_SPDIF_BASE(0x07c)
+
+/* I2S registers */
+#define HDMI_I2S_CLK_CON		HDMI_I2S_BASE(0x000)
+#define HDMI_I2S_CON_1			HDMI_I2S_BASE(0x004)
+#define HDMI_I2S_CON_2			HDMI_I2S_BASE(0x008)
+#define HDMI_I2S_PIN_SEL_0		HDMI_I2S_BASE(0x00c)
+#define HDMI_I2S_PIN_SEL_1		HDMI_I2S_BASE(0x010)
+#define HDMI_I2S_PIN_SEL_2		HDMI_I2S_BASE(0x014)
+#define HDMI_I2S_PIN_SEL_3		HDMI_I2S_BASE(0x018)
+#define HDMI_I2S_DSD_CON		HDMI_I2S_BASE(0x01c)
+#define HDMI_I2S_IN_MUX_CON		HDMI_I2S_BASE(0x020)
+#define HDMI_I2S_CH_ST_CON		HDMI_I2S_BASE(0x024)
+#define HDMI_I2S_CH_ST_0		HDMI_I2S_BASE(0x028)
+#define HDMI_I2S_CH_ST_1		HDMI_I2S_BASE(0x02c)
+#define HDMI_I2S_CH_ST_2		HDMI_I2S_BASE(0x030)
+#define HDMI_I2S_CH_ST_3		HDMI_I2S_BASE(0x034)
+#define HDMI_I2S_CH_ST_4		HDMI_I2S_BASE(0x038)
+#define HDMI_I2S_CH_ST_SH_0		HDMI_I2S_BASE(0x03c)
+#define HDMI_I2S_CH_ST_SH_1		HDMI_I2S_BASE(0x040)
+#define HDMI_I2S_CH_ST_SH_2		HDMI_I2S_BASE(0x044)
+#define HDMI_I2S_CH_ST_SH_3		HDMI_I2S_BASE(0x048)
+#define HDMI_I2S_CH_ST_SH_4		HDMI_I2S_BASE(0x04c)
+#define HDMI_I2S_VD_DATA		HDMI_I2S_BASE(0x050)
+#define HDMI_I2S_MUX_CH			HDMI_I2S_BASE(0x054)
+#define HDMI_I2S_MUX_CUV		HDMI_I2S_BASE(0x058)
+#define HDMI_I2S_IRQ_MASK		HDMI_I2S_BASE(0x05c)
+#define HDMI_I2S_IRQ_STATUS		HDMI_I2S_BASE(0x060)
+
+#define HDMI_I2S_CH0_L_0		HDMI_I2S_BASE(0x0064)
+#define HDMI_I2S_CH0_L_1		HDMI_I2S_BASE(0x0068)
+#define HDMI_I2S_CH0_L_2		HDMI_I2S_BASE(0x006C)
+#define HDMI_I2S_CH0_L_3		HDMI_I2S_BASE(0x0070)
+#define HDMI_I2S_CH0_R_0		HDMI_I2S_BASE(0x0074)
+#define HDMI_I2S_CH0_R_1		HDMI_I2S_BASE(0x0078)
+#define HDMI_I2S_CH0_R_2		HDMI_I2S_BASE(0x007C)
+#define HDMI_I2S_CH0_R_3		HDMI_I2S_BASE(0x0080)
+#define HDMI_I2S_CH1_L_0		HDMI_I2S_BASE(0x0084)
+#define HDMI_I2S_CH1_L_1		HDMI_I2S_BASE(0x0088)
+#define HDMI_I2S_CH1_L_2		HDMI_I2S_BASE(0x008C)
+#define HDMI_I2S_CH1_L_3		HDMI_I2S_BASE(0x0090)
+#define HDMI_I2S_CH1_R_0		HDMI_I2S_BASE(0x0094)
+#define HDMI_I2S_CH1_R_1		HDMI_I2S_BASE(0x0098)
+#define HDMI_I2S_CH1_R_2		HDMI_I2S_BASE(0x009C)
+#define HDMI_I2S_CH1_R_3		HDMI_I2S_BASE(0x00A0)
+#define HDMI_I2S_CH2_L_0		HDMI_I2S_BASE(0x00A4)
+#define HDMI_I2S_CH2_L_1		HDMI_I2S_BASE(0x00A8)
+#define HDMI_I2S_CH2_L_2		HDMI_I2S_BASE(0x00AC)
+#define HDMI_I2S_CH2_L_3		HDMI_I2S_BASE(0x00B0)
+#define HDMI_I2S_CH2_R_0		HDMI_I2S_BASE(0x00B4)
+#define HDMI_I2S_CH2_R_1		HDMI_I2S_BASE(0x00B8)
+#define HDMI_I2S_CH2_R_2		HDMI_I2S_BASE(0x00BC)
+#define HDMI_I2S_Ch2_R_3		HDMI_I2S_BASE(0x00C0)
+#define HDMI_I2S_CH3_L_0		HDMI_I2S_BASE(0x00C4)
+#define HDMI_I2S_CH3_L_1		HDMI_I2S_BASE(0x00C8)
+#define HDMI_I2S_CH3_L_2		HDMI_I2S_BASE(0x00CC)
+#define HDMI_I2S_CH3_R_0		HDMI_I2S_BASE(0x00D0)
+#define HDMI_I2S_CH3_R_1		HDMI_I2S_BASE(0x00D4)
+#define HDMI_I2S_CH3_R_2		HDMI_I2S_BASE(0x00D8)
+#define HDMI_I2S_CUV_L_R		HDMI_I2S_BASE(0x00DC)
+
+/* Timing Generator registers */
+#define HDMI_TG_CMD			HDMI_TG_BASE(0x000)
+#define HDMI_TG_CFG			HDMI_TG_BASE(0x004)
+#define HDMI_TG_CB_SZ			HDMI_TG_BASE(0x008)
+#define HDMI_TG_INDELAY_L		HDMI_TG_BASE(0x00c)
+#define HDMI_TG_INDELAY_H		HDMI_TG_BASE(0x010)
+#define HDMI_TG_POL_CTRL		HDMI_TG_BASE(0x014)
+#define HDMI_TG_H_FSZ_L			HDMI_TG_BASE(0x018)
+#define HDMI_TG_H_FSZ_H			HDMI_TG_BASE(0x01c)
+#define HDMI_TG_HACT_ST_L		HDMI_TG_BASE(0x020)
+#define HDMI_TG_HACT_ST_H		HDMI_TG_BASE(0x024)
+#define HDMI_TG_HACT_SZ_L		HDMI_TG_BASE(0x028)
+#define HDMI_TG_HACT_SZ_H		HDMI_TG_BASE(0x02c)
+#define HDMI_TG_V_FSZ_L			HDMI_TG_BASE(0x030)
+#define HDMI_TG_V_FSZ_H			HDMI_TG_BASE(0x034)
+#define HDMI_TG_VSYNC_L			HDMI_TG_BASE(0x038)
+#define HDMI_TG_VSYNC_H			HDMI_TG_BASE(0x03c)
+#define HDMI_TG_VSYNC2_L		HDMI_TG_BASE(0x040)
+#define HDMI_TG_VSYNC2_H		HDMI_TG_BASE(0x044)
+#define HDMI_TG_VACT_ST_L		HDMI_TG_BASE(0x048)
+#define HDMI_TG_VACT_ST_H		HDMI_TG_BASE(0x04c)
+#define HDMI_TG_VACT_SZ_L		HDMI_TG_BASE(0x050)
+#define HDMI_TG_VACT_SZ_H		HDMI_TG_BASE(0x054)
+#define HDMI_TG_FIELD_CHG_L		HDMI_TG_BASE(0x058)
+#define HDMI_TG_FIELD_CHG_H		HDMI_TG_BASE(0x05c)
+#define HDMI_TG_VACT_ST2_L		HDMI_TG_BASE(0x060)
+#define HDMI_TG_VACT_ST2_H		HDMI_TG_BASE(0x064)
+#define HDMI_TG_VACT_ST3_L		HDMI_TG_BASE(0x068)
+#define HDMI_TG_VACT_ST3_H		HDMI_TG_BASE(0x06c)
+#define HDMI_TG_VACT_ST4_L		HDMI_TG_BASE(0x070)
+#define HDMI_TG_VACT_ST4_H		HDMI_TG_BASE(0x074)
+
+#define HDMI_TG_VSYNC_TOP_HDMI_L	HDMI_TG_BASE(0x078)
+#define HDMI_TG_VSYNC_TOP_HDMI_H	HDMI_TG_BASE(0x07c)
+#define HDMI_TG_VSYNC_BOT_HDMI_L	HDMI_TG_BASE(0x080)
+#define HDMI_TG_VSYNC_BOT_HDMI_H	HDMI_TG_BASE(0x084)
+#define HDMI_TG_FIELD_TOP_HDMI_L	HDMI_TG_BASE(0x088)
+#define HDMI_TG_FIELD_TOP_HDMI_H	HDMI_TG_BASE(0x08c)
+#define HDMI_TG_FIELD_BOT_HDMI_L	HDMI_TG_BASE(0x090)
+#define HDMI_TG_FIELD_BOT_HDMI_H	HDMI_TG_BASE(0x094)
+
+#define HDMI_TG_3D			HDMI_TG_BASE(0x0F0)
+
+#define HDMI_MHL_HSYNC_WIDTH		HDMI_TG_BASE(0x17C)
+#define HDMI_MHL_VSYNC_WIDTH		HDMI_TG_BASE(0x180)
+#define HDMI_MHL_CLK_INV		HDMI_TG_BASE(0x184)
+
+/* HDMI eFUSE registers */
+#define HDMI_EFUSE_CTRL			HDMI_EFUSE_BASE(0x000)
+#define HDMI_EFUSE_STATUS		HDMI_EFUSE_BASE(0x004)
+#define HDMI_EFUSE_ADDR_WIDTH		HDMI_EFUSE_BASE(0x008)
+#define HDMI_EFUSE_SIGDEV_ASSERT	HDMI_EFUSE_BASE(0x00c)
+#define HDMI_EFUSE_SIGDEV_DE_ASSERT	HDMI_EFUSE_BASE(0x010)
+#define HDMI_EFUSE_PRCHG_ASSERT		HDMI_EFUSE_BASE(0x014)
+#define HDMI_EFUSE_PRCHG_DE_ASSERT	HDMI_EFUSE_BASE(0x018)
+#define HDMI_EFUSE_FSET_ASSERT		HDMI_EFUSE_BASE(0x01c)
+#define HDMI_EFUSE_FSET_DE_ASSERT	HDMI_EFUSE_BASE(0x020)
+#define HDMI_EFUSE_SENSING		HDMI_EFUSE_BASE(0x024)
+#define HDMI_EFUSE_SCK_ASSERT		HDMI_EFUSE_BASE(0x028)
+#define HDMI_EFUSE_SCK_DE_ASSERT	HDMI_EFUSE_BASE(0x02c)
+#define HDMI_EFUSE_SDOUT_OFFSET		HDMI_EFUSE_BASE(0x030)
+#define HDMI_EFUSE_READ_OFFSET		HDMI_EFUSE_BASE(0x034)
+
+/*
+ * Bit definition part
+ */
+
+/* Control Register */
+
+/* HDMI_INTC_CON_0 */
+#define HDMI_INTC_POL				(1 << 7)
+#define HDMI_INTC_EN_GLOBAL			(1 << 6)
+#define HDMI_INTC_EN_I2S			(1 << 5)
+#define HDMI_INTC_EN_CEC			(1 << 4)
+#define HDMI_INTC_EN_HPD_PLUG			(1 << 3)
+#define HDMI_INTC_EN_HPD_UNPLUG			(1 << 2)
+#define HDMI_INTC_EN_SPDIF			(1 << 1)
+#define HDMI_INTC_EN_HDCP			(1 << 0)
+
+/* HDMI_INTC_FLAG_0 */
+#define HDMI_INTC_FLAG_I2S			(1 << 5)
+#define HDMI_INTC_FLAG_CEC			(1 << 4)
+#define HDMI_INTC_FLAG_HPD_PLUG			(1 << 3)
+#define HDMI_INTC_FLAG_HPD_UNPLUG		(1 << 2)
+#define HDMI_INTC_FLAG_SPDIF			(1 << 1)
+#define HDMI_INTC_FLAG_HDCP			(1 << 0)
+
+/* HDMI_HDCP_KEY_LOAD */
+#define HDMI_HDCP_KEY_LOAD_DONE			(1 << 0)
+
+/* HDMI_HPD_STATUS */
+#define HDMI_HPD_VALUE				(1 << 0)
+
+/* AUDIO_CLKSEL */
+#define HDMI_AUDIO_SPDIF_CLK			(1 << 0)
+#define HDMI_AUDIO_PCLK				(0 << 0)
+
+/* HDMI_PHY_RSTOUT */
+#define HDMI_PHY_SW_RSTOUT			(1 << 0)
+
+/* HDMI_PHY_VPLL */
+#define HDMI_PHY_VPLL_LOCK			(1 << 7)
+#define HDMI_PHY_VPLL_CODE_MASK			(0x7 << 0)
+
+/* HDMI_PHY_CMU */
+#define HDMI_PHY_CMU_LOCK			(1 << 7)
+#define HDMI_PHY_CMU_CODE_MASK			(0x7 << 0)
+
+/* HDMI_CORE_RSTOUT */
+#define HDMI_CORE_SW_RSTOUT			(1 << 0)
+
+/* Core Register */
+
+/* HDMI_CON_0 */
+#define HDMI_BLUE_SCR_EN			(1 << 5)
+#define HDMI_BLUE_SCR_DIS			(0 << 5)
+#define HDMI_ENC_OPTION				(1 << 4)
+#define HDMI_ASP_ENABLE				(1 << 2)
+#define HDMI_ASP_DISABLE			(0 << 2)
+#define HDMI_PWDN_ENB_NORMAL			(1 << 1)
+#define HDMI_PWDN_ENB_PD			(0 << 1)
+#define HDMI_EN					(1 << 0)
+#define HDMI_DIS				(~(1 << 0))
+
+/* HDMI_CON_1 */
+#define HDMI_PX_LMT_CTRL_BYPASS			(0 << 5)
+#define HDMI_PX_LMT_CTRL_RGB			(1 << 5)
+#define HDMI_PX_LMT_CTRL_YPBPR			(2 << 5)
+#define HDMI_PX_LMT_CTRL_RESERVED		(3 << 5)
+#define HDMI_CON_PXL_REP_RATIO_MASK		(1 << 1 | 1 << 0)
+#define HDMI_DOUBLE_PIXEL_REPETITION		(0x01)
+
+/* HDMI_CON_2 */
+#define HDMI_DVI_PERAMBLE_EN			(1 << 5)
+#define HDMI_DVI_BAND_EN			(1 << 1)
+
+/* STATUS */
+#define HDMI_AUTHEN_ACK_AUTH			(1 << 7)
+#define HDMI_AUTHEN_ACK_NOT			(0 << 7)
+#define HDMI_AUD_FIFO_OVF_FULL			(1 << 6)
+#define HDMI_AUD_FIFO_OVF_NOT			(0 << 6)
+#define HDMI_UPDATE_RI_INT_OCC			(1 << 4)
+#define HDMI_UPDATE_RI_INT_NOT			(0 << 4)
+#define HDMI_UPDATE_RI_INT_CLEAR		(1 << 4)
+#define HDMI_UPDATE_PJ_INT_OCC			(1 << 3)
+#define HDMI_UPDATE_PJ_INT_NOT			(0 << 3)
+#define HDMI_UPDATE_PJ_INT_CLEAR		(1 << 3)
+#define HDMI_WRITE_INT_OCC			(1 << 2)
+#define HDMI_WRITE_INT_NOT			(0 << 2)
+#define HDMI_WRITE_INT_CLEAR			(1 << 2)
+#define HDMI_WATCHDOG_INT_OCC			(1 << 1)
+#define HDMI_WATCHDOG_INT_NOT			(0 << 1)
+#define HDMI_WATCHDOG_INT_CLEAR			(1 << 1)
+#define HDMI_WTFORACTIVERX_INT_OCC		(1)
+#define HDMI_WTFORACTIVERX_INT_NOT		(0)
+#define HDMI_WTFORACTIVERX_INT_CLEAR		(1)
+
+/* PHY_STATUS */
+#define HDMI_PHY_STATUS_READY			(1)
+
+/* HDMI_MODE_SEL */
+#define HDMI_MODE_HDMI_EN		(1 << 1)
+#define HDMI_MODE_DVI_EN		(1 << 0)
+#define HDMI_MODE_MASK			(3 << 0)
+
+/* STATUS_EN */
+#define HDMI_AUD_FIFO_OVF_EN			(1 << 6)
+#define HDMI_AUD_FIFO_OVF_DIS			(0 << 6)
+#define HDMI_UPDATE_RI_INT_EN			(1 << 4)
+#define HDMI_UPDATE_RI_INT_DIS			(0 << 4)
+#define HDMI_UPDATE_PJ_INT_EN			(1 << 3)
+#define HDMI_UPDATE_PJ_INT_DIS			(0 << 3)
+#define HDMI_WRITE_INT_EN			(1 << 2)
+#define HDMI_WRITE_INT_DIS			(0 << 2)
+#define HDMI_WATCHDOG_INT_EN			(1 << 1)
+#define HDMI_WATCHDOG_INT_DIS			(0 << 1)
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
+#define HDMI_SW_HPD_UNPLUGGED			(0 << 1)
+#define HDMI_HPD_SEL_I_HPD			(1)
+#define HDMI_HPD_SEL_SW_HPD			(0)
+
+/* MODE_SEL */
+#define HDMI_MODE_EN				(1 << 1)
+#define HDMI_MODE_DIS				(0 << 1)
+#define HDMI_DVI_MODE_EN			(1)
+#define HDMI_DVI_MODE_DIS			(0)
+
+/* ENC_EN */
+#define HDMI_HDCP_ENC_ENABLE			(1)
+#define HDMI_HDCP_ENC_DISABLE			(0)
+
+/* Video Related Register */
+
+/* BLUESCREEN_0/1/2 */
+
+/* HDMI_YMAX/YMIN/CMAX/CMIN */
+
+/* H_BLANK_0/1 */
+
+/* V_BLANK_0/1/2 */
+
+/* H_V_LINE_0/1/2 */
+
+/* VSYNC_POL */
+#define HDMI_V_SYNC_POL_ACT_LOW			(1)
+#define HDMI_V_SYNC_POL_ACT_HIGH		(0)
+
+/* INT_PRO_MODE */
+#define HDMI_INTERLACE_MODE			(1)
+#define HDMI_PROGRESSIVE_MODE			(0)
+
+/* V_BLANK_F_0/1/2 */
+
+/* H_SYNC_GEN_0/1/2 */
+
+/* V_SYNC_GEN1_0/1/2 */
+
+/* V_SYNC_GEN2_0/1/2 */
+
+/* V_SYNC_GEN3_0/1/2 */
+
+/* Audio Related Packet Register */
+
+/* ASP_CON */
+#define HDMI_AUD_DST_DOUBLE			(1 << 7)
+#define HDMI_AUD_NO_DST_DOUBLE			(0 << 7)
+#define HDMI_AUD_TYPE_SAMPLE			(0 << 5)
+#define HDMI_AUD_TYPE_ONE_BIT			(1 << 5)
+#define HDMI_AUD_TYPE_HBR			(2 << 5)
+#define HDMI_AUD_TYPE_DST			(3 << 5)
+#define HDMI_AUD_MODE_TWO_CH			(0 << 4)
+#define HDMI_AUD_MODE_MULTI_CH			(1 << 4)
+#define HDMI_AUD_SP_AUD3_EN			(1 << 3)
+#define HDMI_AUD_SP_AUD2_EN			(1 << 2)
+#define HDMI_AUD_SP_AUD1_EN			(1 << 1)
+#define HDMI_AUD_SP_AUD0_EN			(1 << 0)
+#define HDMI_AUD_SP_ALL_DIS			(0 << 0)
+
+#define HDMI_AUD_SET_SP_PRE(x)			((x) & 0xF)
+
+/* ASP_SP_FLAT */
+#define HDMI_ASP_SP_FLAT_AUD_SAMPLE		(0)
+
+/* ASP_CHCFG0/1/2/3 */
+#define HDMI_SPK3R_SEL_I_PCM0L			(0 << 27)
+#define HDMI_SPK3R_SEL_I_PCM0R			(1 << 27)
+#define HDMI_SPK3R_SEL_I_PCM1L			(2 << 27)
+#define HDMI_SPK3R_SEL_I_PCM1R			(3 << 27)
+#define HDMI_SPK3R_SEL_I_PCM2L			(4 << 27)
+#define HDMI_SPK3R_SEL_I_PCM2R			(5 << 27)
+#define HDMI_SPK3R_SEL_I_PCM3L			(6 << 27)
+#define HDMI_SPK3R_SEL_I_PCM3R			(7 << 27)
+#define HDMI_SPK3L_SEL_I_PCM0L			(0 << 24)
+#define HDMI_SPK3L_SEL_I_PCM0R			(1 << 24)
+#define HDMI_SPK3L_SEL_I_PCM1L			(2 << 24)
+#define HDMI_SPK3L_SEL_I_PCM1R			(3 << 24)
+#define HDMI_SPK3L_SEL_I_PCM2L			(4 << 24)
+#define HDMI_SPK3L_SEL_I_PCM2R			(5 << 24)
+#define HDMI_SPK3L_SEL_I_PCM3L			(6 << 24)
+#define HDMI_SPK3L_SEL_I_PCM3R			(7 << 24)
+#define HDMI_SPK2R_SEL_I_PCM0L			(0 << 19)
+#define HDMI_SPK2R_SEL_I_PCM0R			(1 << 19)
+#define HDMI_SPK2R_SEL_I_PCM1L			(2 << 19)
+#define HDMI_SPK2R_SEL_I_PCM1R			(3 << 19)
+#define HDMI_SPK2R_SEL_I_PCM2L			(4 << 19)
+#define HDMI_SPK2R_SEL_I_PCM2R			(5 << 19)
+#define HDMI_SPK2R_SEL_I_PCM3L			(6 << 19)
+#define HDMI_SPK2R_SEL_I_PCM3R			(7 << 19)
+#define HDMI_SPK2L_SEL_I_PCM0L			(0 << 16)
+#define HDMI_SPK2L_SEL_I_PCM0R			(1 << 16)
+#define HDMI_SPK2L_SEL_I_PCM1L			(2 << 16)
+#define HDMI_SPK2L_SEL_I_PCM1R			(3 << 16)
+#define HDMI_SPK2L_SEL_I_PCM2L			(4 << 16)
+#define HDMI_SPK2L_SEL_I_PCM2R			(5 << 16)
+#define HDMI_SPK2L_SEL_I_PCM3L			(6 << 16)
+#define HDMI_SPK2L_SEL_I_PCM3R			(7 << 16)
+#define HDMI_SPK1R_SEL_I_PCM0L			(0 << 11)
+#define HDMI_SPK1R_SEL_I_PCM0R			(1 << 11)
+#define HDMI_SPK1R_SEL_I_PCM1L			(2 << 11)
+#define HDMI_SPK1R_SEL_I_PCM1R			(3 << 11)
+#define HDMI_SPK1R_SEL_I_PCM2L			(4 << 11)
+#define HDMI_SPK1R_SEL_I_PCM2R			(5 << 11)
+#define HDMI_SPK1R_SEL_I_PCM3L			(6 << 11)
+#define HDMI_SPK1R_SEL_I_PCM3R			(7 << 11)
+#define HDMI_SPK1L_SEL_I_PCM0L			(0 << 8)
+#define HDMI_SPK1L_SEL_I_PCM0R			(1 << 8)
+#define HDMI_SPK1L_SEL_I_PCM1L			(2 << 8)
+#define HDMI_SPK1L_SEL_I_PCM1R			(3 << 8)
+#define HDMI_SPK1L_SEL_I_PCM2L			(4 << 8)
+#define HDMI_SPK1L_SEL_I_PCM2R			(5 << 8)
+#define HDMI_SPK1L_SEL_I_PCM3L			(6 << 8)
+#define HDMI_SPK1L_SEL_I_PCM3R			(7 << 8)
+#define HDMI_SPK0R_SEL_I_PCM0L			(0 << 3)
+#define HDMI_SPK0R_SEL_I_PCM0R			(1 << 3)
+#define HDMI_SPK0R_SEL_I_PCM1L			(2 << 3)
+#define HDMI_SPK0R_SEL_I_PCM1R			(3 << 3)
+#define HDMI_SPK0R_SEL_I_PCM2L			(4 << 3)
+#define HDMI_SPK0R_SEL_I_PCM2R			(5 << 3)
+#define HDMI_SPK0R_SEL_I_PCM3L			(6 << 3)
+#define HDMI_SPK0R_SEL_I_PCM3R			(7 << 3)
+#define HDMI_SPK0L_SEL_I_PCM0L			(0)
+#define HDMI_SPK0L_SEL_I_PCM0R			(1)
+#define HDMI_SPK0L_SEL_I_PCM1L			(2)
+#define HDMI_SPK0L_SEL_I_PCM1R			(3)
+#define HDMI_SPK0L_SEL_I_PCM2L			(4)
+#define HDMI_SPK0L_SEL_I_PCM2R			(5)
+#define HDMI_SPK0L_SEL_I_PCM3L			(6)
+#define HDMI_SPK0L_SEL_I_PCM3R			(7)
+
+/* ACR_CON */
+#define HDMI_ACR_CON_TX_MODE_NO_TX		(0 << 0)
+#define HDMI_ACR_CON_TX_MODE_MESURED_CTS	(4 << 0)
+
+/* ACR_MCTS0/1/2 */
+
+/* ACR_CTS0/1/2 */
+
+/* ACR_N0/1/2 */
+#define HDMI_ACR_N0_VAL(x)			(x & 0xff)
+#define HDMI_ACR_N1_VAL(x)			((x >> 8) & 0xff)
+#define HDMI_ACR_N2_VAL(x)			((x >> 16) & 0xff)
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
+#define HDMI_GCP_CON_TRANS_EVERY_VSYNC		(2)
+#define HDMI_GCP_CON_NO_TRAN			(0)
+#define HDMI_GCP_CON_TRANS_ONCE			(1)
+#define HDMI_GCP_CON_TRANS_EVERY_VSYNC		(2)
+
+/* GCP_BYTE1 */
+#define HDMI_GCP_BYTE1_MASK			(0xFF)
+
+/* GCP_BYTE2 */
+#define HDMI_GCP_BYTE2_PP_MASK			(0xF << 4)
+#define HDMI_GCP_24BPP				(1 << 2)
+#define HDMI_GCP_30BPP				(1 << 0 | 1 << 2)
+#define HDMI_GCP_36BPP				(1 << 1 | 1 << 2)
+#define HDMI_GCP_48BPP				(1 << 0 | 1 << 1 | 1 << 2)
+
+/* GCP_BYTE3 */
+#define HDMI_GCP_BYTE3_MASK			(0xFF)
+
+/* ACP Packet Register */
+
+/* ACP_CON */
+#define HDMI_ACP_FR_RATE_MASK			(0x1F << 3)
+#define HDMI_ACP_CON_NO_TRAN			(0)
+#define HDMI_ACP_CON_TRANS_ONCE			(1)
+#define HDMI_ACP_CON_TRANS_EVERY_VSYNC		(2)
+
+/* ACP_TYPE */
+#define HDMI_ACP_TYPE_MASK			(0xFF)
+
+/* ACP_DATA00~16 */
+#define HDMI_ACP_DATA_MASK			(0xFF)
+
+/* ISRC1/2 Packet Register */
+
+/* ISRC_CON */
+#define HDMI_ISRC_FR_RATE_MASK			(0x1F << 3)
+#define HDMI_ISRC_EN				(1 << 2)
+#define HDMI_ISRC_DIS				(0 << 2)
+
+/* ISRC1_HEADER1 */
+#define HDMI_ISRC1_HEADER_MASK			(0xFF)
+
+/* ISRC1_DATA 00~15 */
+#define HDMI_ISRC1_DATA_MASK			(0xFF)
+
+/* ISRC2_DATA 00~15 */
+#define HDMI_ISRC2_DATA_MASK			(0xFF)
+
+/* AVI InfoFrame Register */
+
+/* AVI_CON */
+#define HDMI_AVI_CON_EVERY_VSYNC               (1 << 1)
+
+/* AVI_CHECK_SUM */
+
+/* AVI_DATA01~13 */
+#define HDMI_AVI_PIXEL_REPETITION_DOUBLE	(1<<0)
+#define HDMI_AVI_PICTURE_ASPECT_4_3		(1<<4)
+#define HDMI_AVI_PICTURE_ASPECT_16_9		(1<<5)
+
+/* Audio InfoFrame Register */
+
+/* AUI_CON */
+#define HDMI_AUI_CON_NO_TRAN			(0 << 0)
+#define HDMI_AUI_CON_TRANS_ONCE			(1 << 0)
+#define HDMI_AUI_CON_TRANS_EVERY_VSYNC		(2 << 0)
+
+/* AUI_CHECK_SUM */
+
+/* AUI_DATA1~5 */
+
+/* MPEG Source InfoFrame registers */
+
+/* MPG_CON */
+
+/* HDMI_MPG_CHECK_SUM */
+
+/* MPG_DATA1~5 */
+
+/* Source Product Descriptor Infoframe registers */
+
+/* SPD_CON */
+
+/* SPD_HEADER0/1/2 */
+
+/* SPD_DATA0~27 */
+
+/* VSI_CON */
+#define HDMI_VSI_CON_DO_NOT_TRANSMIT		(0 << 0)
+#define HDMI_VSI_CON_EVERY_VSYNC		(1 << 1)
+
+/* VSI_DATA00 ~ 27 */
+#define HDMI_VSI_DATA04_VIDEO_FORMAT(x)		(x << 5)
+#define HDMI_VSI_DATA05_3D_STRUCTURE(x)		(x << 4)
+#define HDMI_VSI_DATA06_3D_EXT_DATA(x)		(x << 4)
+
+/* HDCP Register */
+
+/* HDCP_SHA1_00~19 */
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
+#define HDMI_HDCP_SET_REPEATER_TIMEOUT		(1 << 2)
+#define HDMI_HDCP_CLEAR_REPEATER_TIMEOUT	(~(1 << 2))
+#define HDMI_HDCP_CP_DESIRED_EN			(1 << 1)
+#define HDMI_HDCP_CP_DESIRED_DIS		(~(1 << 1))
+#define HDMI_HDCP_ENABLE_1_1_FEATURE_EN		(1)
+#define HDMI_HDCP_ENABLE_1_1_FEATURE_DIS	(~(1))
+
+/* HDCP_CHECK_RESULT */
+#define HDMI_HDCP_PI_MATCH_RESULT_Y		((0x1 << 3) | (0x1 << 2))
+#define HDMI_HDCP_PI_MATCH_RESULT_N		((0x1 << 3) | (0x0 << 2))
+#define HDMI_HDCP_RI_MATCH_RESULT_Y		((0x1 << 1) | (0x1 << 0))
+#define HDMI_HDCP_RI_MATCH_RESULT_N		((0x1 << 1) | (0x0 << 0))
+#define HDMI_HDCP_CLR_ALL_RESULTS		(0)
+
+/* HDCP_BKSV0~4 */
+/* HDCP_AKSV0~4 */
+
+/* HDCP_BCAPS */
+#define HDMI_HDCP_BCAPS_REPEATER		(1 << 6)
+#define HDMI_HDCP_BCAPS_READY			(1 << 5)
+#define HDMI_HDCP_BCAPS_FAST			(1 << 4)
+#define HDMI_HDCP_BCAPS_1_1_FEATURES		(1 << 1)
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
+/* Gamut Metadata Packet Register */
+
+/* GAMUT_CON */
+/* GAMUT_HEADER0 */
+/* GAMUT_HEADER1 */
+/* GAMUT_HEADER2 */
+/* GAMUT_METADATA0~27 */
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
+/* SPDIF Register */
+
+/* SPDIFIN_CLK_CTRL */
+#define HDMI_SPDIFIN_READY_CLK_DOWN		(1 << 1)
+#define HDMI_SPDIFIN_CLK_ON			(1 << 0)
+
+/* SPDIFIN_OP_CTRL */
+#define HDMI_SPDIFIN_SW_RESET			(0 << 0)
+#define HDMI_SPDIFIN_STATUS_CHECK_MODE		(1 << 0)
+#define HDMI_SPDIFIN_STATUS_CHECK_MODE_HDMI	(3 << 0)
+
+/* SPDIFIN_IRQ_MASK */
+
+/* SPDIFIN_IRQ_STATUS */
+#define HDMI_SPDIFIN_IRQ_OVERFLOW_EN				(1 << 7)
+#define HDMI_SPDIFIN_IRQ_ABNORMAL_PD_EN				(1 << 6)
+#define HDMI_SPDIFIN_IRQ_SH_NOT_DETECTED_RIGHTTIME_EN		(1 << 5)
+#define HDMI_SPDIFIN_IRQ_SH_DETECTED_EN				(1 << 4)
+#define HDMI_SPDIFIN_IRQ_SH_NOT_DETECTED_EN			(1 << 3)
+#define HDMI_SPDIFIN_IRQ_WRONG_PREAMBLE_EN			(1 << 2)
+#define HDMI_SPDIFIN_IRQ_CH_STATUS_RECOVERED_EN			(1 << 1)
+#define HDMI_SPDIFIN_IRQ_WRONG_SIG_EN				(1 << 0)
+
+/* SPDIFIN_CONFIG_1 */
+#define HDMI_SPDIFIN_CFG_NOISE_FILTER_2_SAMPLE			(1 << 6)
+#define HDMI_SPDIFIN_CFG_PCPD_MANUAL				(1 << 4)
+#define HDMI_SPDIFIN_CFG_WORD_LENGTH_MANUAL			(1 << 3)
+#define HDMI_SPDIFIN_CFG_UVCP_REPORT				(1 << 2)
+#define HDMI_SPDIFIN_CFG_HDMI_2_BURST				(1 << 1)
+#define HDMI_SPDIFIN_CFG_DATA_ALIGN_32				(1 << 0)
+
+/* SPDIFIN_CONFIG_2 */
+#define HDMI_SPDIFIN_CFG2_NO_CLK_DIV				(0)
+
+/* SPDIFIN_USER_VALUE_1 */
+#define HDMI_SPDIFIN_USER_VAL_REPETITION_TIME_LOW(x)	((x & 0xf) << 4)
+#define HDMI_SPDIFIN_USER_VAL_WORD_LENGTH_24		(0xb << 0)
+#define HDMI_SPDIFIN_USER_VAL_REPETITION_TIME_HIGH(x)	((x >> 4) & 0xff)
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
+/* I2S Register */
+
+/* I2S_CLK_CON */
+#define HDMI_I2S_CLK_DISABLE			(0)
+#define HDMI_I2S_CLK_ENABLE			(1)
+
+/* I2S_CON_1 */
+#define HDMI_I2S_SCLK_FALLING_EDGE		(0 << 1)
+#define HDMI_I2S_SCLK_RISING_EDGE		(1 << 1)
+#define HDMI_I2S_L_CH_LOW_POL			(0)
+#define HDMI_I2S_L_CH_HIGH_POL			(1)
+
+/* I2S_CON_2 */
+#define HDMI_I2S_MSB_FIRST_MODE			(0 << 6)
+#define HDMI_I2S_LSB_FIRST_MODE			(1 << 6)
+#define HDMI_I2S_BIT_CH_32FS			(0 << 4)
+#define HDMI_I2S_BIT_CH_48FS			(1 << 4)
+#define HDMI_I2S_BIT_CH_RESERVED		(2 << 4)
+#define HDMI_I2S_SDATA_16BIT			(1 << 2)
+#define HDMI_I2S_SDATA_20BIT			(2 << 2)
+#define HDMI_I2S_SDATA_24BIT			(3 << 2)
+#define HDMI_I2S_BASIC_FORMAT			(0)
+#define HDMI_I2S_L_JUST_FORMAT			(2)
+#define HDMI_I2S_R_JUST_FORMAT			(3)
+#define HDMI_I2S_CON_2_CLR			(~(0xFF))
+#define HDMI_I2S_SET_BIT_CH(x)			(((x) & 0x7) << 4)
+#define HDMI_I2S_SET_SDATA_BIT(x)		(((x) & 0x7) << 2)
+
+/* I2S_PIN_SEL_0 */
+#define HDMI_I2S_SEL_SCLK(x)			(((x) & 0x7) << 4)
+#define HDMI_I2S_SEL_LRCK(x)			((x) & 0x7)
+
+/* I2S_PIN_SEL_1 */
+#define HDMI_I2S_SEL_SDATA1(x)			(((x) & 0x7) << 4)
+#define HDMI_I2S_SEL_SDATA0(x)			((x) & 0x7)
+
+/* I2S_PIN_SEL_2 */
+#define HDMI_I2S_SEL_SDATA3(x)			(((x) & 0x7) << 4)
+#define HDMI_I2S_SEL_SDATA2(x)			((x) & 0x7)
+
+/* I2S_PIN_SEL_3 */
+#define HDMI_I2S_SEL_DSD(x)			((x) & 0x7)
+
+/* I2S_DSD_CON */
+#define HDMI_I2S_DSD_CLK_RI_EDGE		(1 << 1)
+#define HDMI_I2S_DSD_CLK_FA_EDGE		(0 << 1)
+#define HDMI_I2S_DSD_ENABLE			(1 << 0)
+#define HDMI_I2S_DSD_DISABLE			(0 << 0)
+
+/* I2S_MUX_CON */
+#define HDMI_I2S_NOISE_FILTER_ZERO		(0 << 5)
+#define HDMI_I2S_NOISE_FILTER_2_STAGE		(1 << 5)
+#define HDMI_I2S_NOISE_FILTER_3_STAGE		(2 << 5)
+#define HDMI_I2S_NOISE_FILTER_4_STAGE		(3 << 5)
+#define HDMI_I2S_NOISE_FILTER_5_STAGE		(4 << 5)
+#define HDMI_I2S_IN_ENABLE			(1 << 4)
+#define HDMI_I2S_IN_DISABLE			(0 << 4)
+#define HDMI_I2S_AUD_SPDIF			(0 << 2)
+#define HDMI_I2S_AUD_I2S			(1 << 2)
+#define HDMI_I2S_AUD_DSD			(2 << 2)
+#define HDMI_I2S_CUV_SPDIF_ENABLE		(0 << 1)
+#define HDMI_I2S_CUV_I2S_ENABLE			(1 << 1)
+#define HDMI_I2S_MUX_DISABLE			(0 << 0)
+#define HDMI_I2S_MUX_ENABLE			(1 << 0)
+
+/* I2S_CH_ST_CON */
+#define HDMI_I2S_CH_STATUS_RELOAD		(1 << 0)
+#define HDMI_I2S_CH_ST_CON_CLR			(~(1))
+
+/* I2S_CH_ST_0 / I2S_CH_ST_SH_0 */
+#define HDMI_I2S_CH_STATUS_MODE_0		(0 << 6)
+#define HDMI_I2S_2AUD_CH_WITHOUT_PREEMPH	(0 << 3)
+#define HDMI_I2S_2AUD_CH_WITH_PREEMPH		(1 << 3)
+#define HDMI_I2S_DEFAULT_EMPHASIS		(0 << 3)
+#define HDMI_I2S_COPYRIGHT			(0 << 2)
+#define HDMI_I2S_NO_COPYRIGHT			(1 << 2)
+#define HDMI_I2S_LINEAR_PCM			(0 << 1)
+#define HDMI_I2S_NO_LINEAR_PCM			(1 << 1)
+#define HDMI_I2S_CONSUMER_FORMAT		(0)
+#define HDMI_I2S_PROF_FORMAT			(1)
+#define HDMI_I2S_CH_ST_0_CLR			(~(0xFF))
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
+#define HDMI_I2S_SET_SAMPLING_FREQ(x)		((x) & (0xF))
+
+/* I2S_CH_ST_4 / I2S_CH_ST_SH_4 */
+#define HDMI_I2S_ORG_SAMPLING_FREQ_44_1		(0xF << 4)
+#define HDMI_I2S_ORG_SAMPLING_FREQ_88_2		(0x7 << 4)
+#define HDMI_I2S_ORG_SAMPLING_FREQ_22_05	(0xB << 4)
+#define HDMI_I2S_ORG_SAMPLING_FREQ_176_4	(0x3 << 4)
+#define HDMI_I2S_WORD_LENGTH_NOT_DEFINE		(0x0 << 1)
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
+#define HDMI_I2S_WORD_LENGTH_MAX_24BITS		(1)
+#define HDMI_I2S_WORD_LENGTH_MAX_20BITS		(0)
+
+/* I2S_VD_DATA */
+#define HDMI_I2S_VD_AUD_SAMPLE_RELIABLE		(0)
+#define HDMI_I2S_VD_AUD_SAMPLE_UNRELIABLE	(1)
+
+/* I2S_MUX_CH */
+#define HDMI_I2S_CH3_R_EN			(1 << 7)
+#define HDMI_I2S_CH3_L_EN			(1 << 6)
+#define HDMI_I2S_CH2_R_EN			(1 << 5)
+#define HDMI_I2S_CH2_L_EN			(1 << 4)
+#define HDMI_I2S_CH1_R_EN			(1 << 3)
+#define HDMI_I2S_CH1_L_EN			(1 << 2)
+#define HDMI_I2S_CH0_R_EN			(1 << 1)
+#define HDMI_I2S_CH0_L_EN			(1)
+#define HDMI_I2S_CH_ALL_EN			(0xFF)
+#define HDMI_I2S_MUX_CH_CLR			(~HDMI_I2S_CH_ALL_EN)
+
+/* I2S_MUX_CUV */
+#define HDMI_I2S_CUV_R_EN			(1 << 1)
+#define HDMI_I2S_CUV_L_EN			(1 << 0)
+#define HDMI_I2S_CUV_RL_EN			(0x03)
+
+/* I2S_IRQ_MASK */
+#define HDMI_I2S_INT2_DIS			(0 << 1)
+#define HDMI_I2S_INT2_EN			(1 << 1)
+
+/* I2S_IRQ_STATUS */
+#define HDMI_I2S_INT2_STATUS			(1 << 1)
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
+/* Timing Generator Register */
+/* TG_CMD */
+#define HDMI_GETSYNC_TYPE			(1 << 4)
+#define HDMI_GETSYNC				(1 << 3)
+
+/* HDMI_TG_CMD */
+#define HDMI_FIELD_EN				(1 << 1)
+#define HDMI_TG_EN				(1 << 0)
+
+/* TG_CFG */
+/* TG_CB_SZ */
+/* TG_INDELAY_L */
+/* TG_INDELAY_H */
+/* TG_POL_CTRL */
+
+/* TG_H_FSZ_L */
+/* TG_H_FSZ_H */
+/* TG_HACT_ST_L */
+/* TG_HACT_ST_H */
+/* TG_HACT_SZ_L */
+/* TG_HACT_SZ_H */
+/* TG_V_FSZ_L */
+/* TG_V_FSZ_H */
+/* TG_VSYNC_L */
+/* TG_VSYNC_H */
+/* TG_VSYNC2_L */
+/* TG_VSYNC2_H */
+/* TG_VACT_ST_L */
+/* TG_VACT_ST_H */
+/* TG_VACT_SZ_L */
+/* TG_VACT_SZ_H */
+/* TG_FIELD_CHG_L */
+/* TG_FIELD_CHG_H */
+/* TG_VACT_ST2_L */
+/* TG_VACT_ST2_H */
+/* TG_VACT_SC_ST_L */
+/* TG_VACT_SC_ST_H */
+/* TG_VACT_SC_SZ_L */
+/* TG_VACT_SC_SZ_H */
+
+/* TG_VSYNC_TOP_HDMI_L */
+/* TG_VSYNC_TOP_HDMI_H */
+/* TG_VSYNC_BOT_HDMI_L */
+/* TG_VSYNC_BOT_HDMI_H */
+/* TG_FIELD_TOP_HDMI_L */
+/* TG_FIELD_TOP_HDMI_H */
+/* TG_FIELD_BOT_HDMI_L */
+/* TG_FIELD_BOT_HDMI_H */
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
+/* HDCP E-FUSE Control Register */
+/* HDCP_E_FUSE_CTRL */
+#define HDMI_EFUSE_CTRL_HDCP_KEY_READ		(1 << 0)
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
+/* HDCP_SHA_RESULT */
+#define HDMI_HDCP_SHA_VALID_NO_RD		(0 << 1)
+#define HDMI_HDCP_SHA_VALID_RD			(1 << 1)
+#define HDMI_HDCP_SHA_VALID			(1)
+#define HDMI_HDCP_SHA_NO_VALID			(0)
+
+/* DC_CONTRAL */
+#define HDMI_DC_CTL_12				(1 << 1)
+#define HDMI_DC_CTL_8				(0)
+#define HDMI_DC_CTL_10				(1)
+#endif	/* __ARCH_ARM_REGS_HDMI_H */
diff --git a/drivers/media/video/s5p-tv/regs-hdmi.h b/drivers/media/video/s5p-tv/regs-hdmi.h
deleted file mode 100644
index 33247d1..0000000
--- a/drivers/media/video/s5p-tv/regs-hdmi.h
+++ /dev/null
@@ -1,145 +0,0 @@
-/* linux/arch/arm/mach-exynos4/include/mach/regs-hdmi.h
- *
- * Copyright (c) 2010-2011 Samsung Electronics Co., Ltd.
- * http://www.samsung.com/
- *
- * HDMI register header file for Samsung TVOUT driver
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
-*/
-
-#ifndef SAMSUNG_REGS_HDMI_H
-#define SAMSUNG_REGS_HDMI_H
-
-/*
- * Register part
-*/
-
-#define HDMI_CTRL_BASE(x)		((x) + 0x00000000)
-#define HDMI_CORE_BASE(x)		((x) + 0x00010000)
-#define HDMI_TG_BASE(x)			((x) + 0x00050000)
-
-/* Control registers */
-#define HDMI_INTC_CON			HDMI_CTRL_BASE(0x0000)
-#define HDMI_INTC_FLAG			HDMI_CTRL_BASE(0x0004)
-#define HDMI_HPD_STATUS			HDMI_CTRL_BASE(0x000C)
-#define HDMI_PHY_RSTOUT			HDMI_CTRL_BASE(0x0014)
-#define HDMI_PHY_VPLL			HDMI_CTRL_BASE(0x0018)
-#define HDMI_PHY_CMU			HDMI_CTRL_BASE(0x001C)
-#define HDMI_CORE_RSTOUT		HDMI_CTRL_BASE(0x0020)
-
-/* Core registers */
-#define HDMI_CON_0			HDMI_CORE_BASE(0x0000)
-#define HDMI_CON_1			HDMI_CORE_BASE(0x0004)
-#define HDMI_CON_2			HDMI_CORE_BASE(0x0008)
-#define HDMI_SYS_STATUS			HDMI_CORE_BASE(0x0010)
-#define HDMI_PHY_STATUS			HDMI_CORE_BASE(0x0014)
-#define HDMI_STATUS_EN			HDMI_CORE_BASE(0x0020)
-#define HDMI_HPD			HDMI_CORE_BASE(0x0030)
-#define HDMI_MODE_SEL			HDMI_CORE_BASE(0x0040)
-#define HDMI_BLUE_SCREEN_0		HDMI_CORE_BASE(0x0050)
-#define HDMI_BLUE_SCREEN_1		HDMI_CORE_BASE(0x0054)
-#define HDMI_BLUE_SCREEN_2		HDMI_CORE_BASE(0x0058)
-#define HDMI_H_BLANK_0			HDMI_CORE_BASE(0x00A0)
-#define HDMI_H_BLANK_1			HDMI_CORE_BASE(0x00A4)
-#define HDMI_V_BLANK_0			HDMI_CORE_BASE(0x00B0)
-#define HDMI_V_BLANK_1			HDMI_CORE_BASE(0x00B4)
-#define HDMI_V_BLANK_2			HDMI_CORE_BASE(0x00B8)
-#define HDMI_H_V_LINE_0			HDMI_CORE_BASE(0x00C0)
-#define HDMI_H_V_LINE_1			HDMI_CORE_BASE(0x00C4)
-#define HDMI_H_V_LINE_2			HDMI_CORE_BASE(0x00C8)
-#define HDMI_VSYNC_POL			HDMI_CORE_BASE(0x00E4)
-#define HDMI_INT_PRO_MODE		HDMI_CORE_BASE(0x00E8)
-#define HDMI_V_BLANK_F_0		HDMI_CORE_BASE(0x0110)
-#define HDMI_V_BLANK_F_1		HDMI_CORE_BASE(0x0114)
-#define HDMI_V_BLANK_F_2		HDMI_CORE_BASE(0x0118)
-#define HDMI_H_SYNC_GEN_0		HDMI_CORE_BASE(0x0120)
-#define HDMI_H_SYNC_GEN_1		HDMI_CORE_BASE(0x0124)
-#define HDMI_H_SYNC_GEN_2		HDMI_CORE_BASE(0x0128)
-#define HDMI_V_SYNC_GEN_1_0		HDMI_CORE_BASE(0x0130)
-#define HDMI_V_SYNC_GEN_1_1		HDMI_CORE_BASE(0x0134)
-#define HDMI_V_SYNC_GEN_1_2		HDMI_CORE_BASE(0x0138)
-#define HDMI_V_SYNC_GEN_2_0		HDMI_CORE_BASE(0x0140)
-#define HDMI_V_SYNC_GEN_2_1		HDMI_CORE_BASE(0x0144)
-#define HDMI_V_SYNC_GEN_2_2		HDMI_CORE_BASE(0x0148)
-#define HDMI_V_SYNC_GEN_3_0		HDMI_CORE_BASE(0x0150)
-#define HDMI_V_SYNC_GEN_3_1		HDMI_CORE_BASE(0x0154)
-#define HDMI_V_SYNC_GEN_3_2		HDMI_CORE_BASE(0x0158)
-#define HDMI_AVI_CON			HDMI_CORE_BASE(0x0300)
-#define HDMI_AVI_BYTE(n)		HDMI_CORE_BASE(0x0320 + 4 * (n))
-#define	HDMI_DC_CONTROL			HDMI_CORE_BASE(0x05C0)
-#define HDMI_VIDEO_PATTERN_GEN		HDMI_CORE_BASE(0x05C4)
-#define HDMI_HPD_GEN			HDMI_CORE_BASE(0x05C8)
-
-/* Timing generator registers */
-#define HDMI_TG_CMD			HDMI_TG_BASE(0x0000)
-#define HDMI_TG_H_FSZ_L			HDMI_TG_BASE(0x0018)
-#define HDMI_TG_H_FSZ_H			HDMI_TG_BASE(0x001C)
-#define HDMI_TG_HACT_ST_L		HDMI_TG_BASE(0x0020)
-#define HDMI_TG_HACT_ST_H		HDMI_TG_BASE(0x0024)
-#define HDMI_TG_HACT_SZ_L		HDMI_TG_BASE(0x0028)
-#define HDMI_TG_HACT_SZ_H		HDMI_TG_BASE(0x002C)
-#define HDMI_TG_V_FSZ_L			HDMI_TG_BASE(0x0030)
-#define HDMI_TG_V_FSZ_H			HDMI_TG_BASE(0x0034)
-#define HDMI_TG_VSYNC_L			HDMI_TG_BASE(0x0038)
-#define HDMI_TG_VSYNC_H			HDMI_TG_BASE(0x003C)
-#define HDMI_TG_VSYNC2_L		HDMI_TG_BASE(0x0040)
-#define HDMI_TG_VSYNC2_H		HDMI_TG_BASE(0x0044)
-#define HDMI_TG_VACT_ST_L		HDMI_TG_BASE(0x0048)
-#define HDMI_TG_VACT_ST_H		HDMI_TG_BASE(0x004C)
-#define HDMI_TG_VACT_SZ_L		HDMI_TG_BASE(0x0050)
-#define HDMI_TG_VACT_SZ_H		HDMI_TG_BASE(0x0054)
-#define HDMI_TG_FIELD_CHG_L		HDMI_TG_BASE(0x0058)
-#define HDMI_TG_FIELD_CHG_H		HDMI_TG_BASE(0x005C)
-#define HDMI_TG_VACT_ST2_L		HDMI_TG_BASE(0x0060)
-#define HDMI_TG_VACT_ST2_H		HDMI_TG_BASE(0x0064)
-#define HDMI_TG_VSYNC_TOP_HDMI_L	HDMI_TG_BASE(0x0078)
-#define HDMI_TG_VSYNC_TOP_HDMI_H	HDMI_TG_BASE(0x007C)
-#define HDMI_TG_VSYNC_BOT_HDMI_L	HDMI_TG_BASE(0x0080)
-#define HDMI_TG_VSYNC_BOT_HDMI_H	HDMI_TG_BASE(0x0084)
-#define HDMI_TG_FIELD_TOP_HDMI_L	HDMI_TG_BASE(0x0088)
-#define HDMI_TG_FIELD_TOP_HDMI_H	HDMI_TG_BASE(0x008C)
-#define HDMI_TG_FIELD_BOT_HDMI_L	HDMI_TG_BASE(0x0090)
-#define HDMI_TG_FIELD_BOT_HDMI_H	HDMI_TG_BASE(0x0094)
-
-/*
- * Bit definition part
- */
-
-/* HDMI_INTC_CON */
-#define HDMI_INTC_EN_GLOBAL		(1 << 6)
-#define HDMI_INTC_EN_HPD_PLUG		(1 << 3)
-#define HDMI_INTC_EN_HPD_UNPLUG		(1 << 2)
-
-/* HDMI_INTC_FLAG */
-#define HDMI_INTC_FLAG_HPD_PLUG		(1 << 3)
-#define HDMI_INTC_FLAG_HPD_UNPLUG	(1 << 2)
-
-/* HDMI_PHY_RSTOUT */
-#define HDMI_PHY_SW_RSTOUT		(1 << 0)
-
-/* HDMI_CORE_RSTOUT */
-#define HDMI_CORE_SW_RSTOUT		(1 << 0)
-
-/* HDMI_CON_0 */
-#define HDMI_BLUE_SCR_EN		(1 << 5)
-#define HDMI_EN				(1 << 0)
-
-/* HDMI_CON_2 */
-#define HDMI_DVI_PERAMBLE_EN		(1 << 5)
-#define HDMI_DVI_BAND_EN		(1 << 1)
-
-/* HDMI_PHY_STATUS */
-#define HDMI_PHY_STATUS_READY		(1 << 0)
-
-/* HDMI_MODE_SEL */
-#define HDMI_MODE_HDMI_EN		(1 << 1)
-#define HDMI_MODE_DVI_EN		(1 << 0)
-#define HDMI_MODE_MASK			(3 << 0)
-
-/* HDMI_TG_CMD */
-#define HDMI_TG_EN			(1 << 0)
-
-#endif /* SAMSUNG_REGS_HDMI_H */
-- 
1.7.1


