Return-path: <mchehab@pedra>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:55454 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752640Ab1BHJam (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 8 Feb 2011 04:30:42 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Date: Tue, 08 Feb 2011 10:30:27 +0100
From: Tomasz Stanislawski <t.stanislaws@samsung.com>
Subject: [PATCH 5/5] s5pc210: add s5p-tv to platform devices
In-reply-to: <1297157427-14560-1-git-send-email-t.stanislaws@samsung.com>
To: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: m.szyprowski@samsung.com, t.stanislaws@samsung.com,
	kyungmin.park@samsung.com
Message-id: <1297157427-14560-6-git-send-email-t.stanislaws@samsung.com>
References: <1297157427-14560-1-git-send-email-t.stanislaws@samsung.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Signed-off-by: Tomasz Stanislawski <t.stanislaws@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
Reviewed-by: Marek Szyprowski <m.szyprowski@samsung.com>
---
 arch/arm/mach-s5pv310/Kconfig                   |    7 +
 arch/arm/mach-s5pv310/Makefile                  |    1 +
 arch/arm/mach-s5pv310/clock.c                   |  126 +++++++-
 arch/arm/mach-s5pv310/dev-tv.c                  |  450 +++++++++++++++++++++++
 arch/arm/mach-s5pv310/include/mach/irqs.h       |    4 +
 arch/arm/mach-s5pv310/include/mach/map.h        |   26 ++
 arch/arm/mach-s5pv310/include/mach/regs-clock.h |   15 +
 arch/arm/plat-samsung/include/plat/devs.h       |    2 +
 8 files changed, 630 insertions(+), 1 deletions(-)
 create mode 100644 arch/arm/mach-s5pv310/dev-tv.c

diff --git a/arch/arm/mach-s5pv310/Kconfig b/arch/arm/mach-s5pv310/Kconfig
index 09c4c21..e62103b 100644
--- a/arch/arm/mach-s5pv310/Kconfig
+++ b/arch/arm/mach-s5pv310/Kconfig
@@ -20,6 +20,11 @@ config S5PV310_DEV_PD
 	help
 	  Compile in platform device definitions for Power Domain
 
+config S5PV310_DEV_TV
+	bool
+	help
+	  Compile in platform device definition for TV interface
+
 config S5PV310_SETUP_I2C1
 	bool
 	help
@@ -102,6 +107,8 @@ config MACH_UNIVERSAL_C210
 	select S3C_DEV_HSMMC3
 	select S5PV310_SETUP_SDHCI
 	select S3C_DEV_I2C1
+	select S3C_DEV_I2C8
+	select S5PV310_DEV_TV
 	select S5PV310_SETUP_I2C1
 	help
 	  Machine support for Samsung Mobile Universal S5PC210 Reference
diff --git a/arch/arm/mach-s5pv310/Makefile b/arch/arm/mach-s5pv310/Makefile
index 036fb38..a234b80 100644
--- a/arch/arm/mach-s5pv310/Makefile
+++ b/arch/arm/mach-s5pv310/Makefile
@@ -32,6 +32,7 @@ obj-y					+= dev-audio.o
 obj-$(CONFIG_S5PV310_DEV_PD)		+= dev-pd.o
 obj-$(CONFIG_S5PV310_DEV_SYSMMU)	+= dev-sysmmu.o
 
+obj-$(CONFIG_S5PV310_DEV_TV)		+= dev-tv.o
 obj-$(CONFIG_S5PV310_SETUP_I2C1)	+= setup-i2c1.o
 obj-$(CONFIG_S5PV310_SETUP_I2C2)	+= setup-i2c2.o
 obj-$(CONFIG_S5PV310_SETUP_I2C3)	+= setup-i2c3.o
diff --git a/arch/arm/mach-s5pv310/clock.c b/arch/arm/mach-s5pv310/clock.c
index 6161b54..5bca261 100644
--- a/arch/arm/mach-s5pv310/clock.c
+++ b/arch/arm/mach-s5pv310/clock.c
@@ -81,6 +81,11 @@ static int s5pv310_clksrc_mask_peril1_ctrl(struct clk *clk, int enable)
 	return s5p_gatectrl(S5P_CLKSRC_MASK_PERIL1, clk, enable);
 }
 
+static int s5pv310_clksrc_mask_tv_ctrl(struct clk *clk, int enable)
+{
+	return s5p_gatectrl(S5P_CLKSRC_MASK_TV, clk, enable);
+}
+
 static int s5pv310_clk_ip_cam_ctrl(struct clk *clk, int enable)
 {
 	return s5p_gatectrl(S5P_CLKGATE_IP_CAM, clk, enable);
@@ -116,6 +121,11 @@ static int s5pv310_clk_ip_perir_ctrl(struct clk *clk, int enable)
 	return s5p_gatectrl(S5P_CLKGATE_IP_PERIR, clk, enable);
 }
 
+static int s5pv310_clk_ip_tv_ctrl(struct clk *clk, int enable)
+{
+	return s5p_gatectrl(S5P_CLKGATE_IP_TV, clk, enable);
+}
+
 /* Core list of CMU_CPU side */
 
 static struct clksrc_clk clk_mout_apll = {
@@ -432,6 +442,26 @@ static struct clk init_clocks_off[] = {
 		.enable		= s5pv310_clk_ip_lcd1_ctrl,
 		.ctrlbit	= (1 << 0),
 	}, {
+		.name           = "dac",
+		.id             = -1,
+		.enable         = s5pv310_clk_ip_tv_ctrl,
+		.ctrlbit        = (1 << 2),
+	}, {
+		.name           = "mixer",
+		.id             = -1,
+		.enable         = s5pv310_clk_ip_tv_ctrl,
+		.ctrlbit        = (1 << 1),
+	}, {
+		.name           = "vp",
+		.id             = -1,
+		.enable         = s5pv310_clk_ip_tv_ctrl,
+		.ctrlbit        = (1 << 0),
+	}, {
+		.name           = "hdmi",
+		.id             = -1,
+		.enable         = s5pv310_clk_ip_tv_ctrl,
+		.ctrlbit        = (1 << 3),
+	}, {
 		.name		= "hsmmc",
 		.id		= 0,
 		.parent		= &clk_aclk_133.clk,
@@ -697,6 +727,93 @@ static struct clksrc_sources clkset_mout_g2d = {
 	.nr_sources	= ARRAY_SIZE(clkset_mout_g2d_list),
 };
 
+/* --------------------------------------
+ *         TV subsystem CLOCKS
+ * --------------------------------------
+ */
+
+static struct clk *clkset_sclk_dac_list[] = {
+	[0] = &clk_sclk_vpll.clk,
+	[1] = &clk_sclk_hdmiphy,
+};
+
+static struct clksrc_sources clkset_sclk_dac = {
+	.sources	= clkset_sclk_dac_list,
+	.nr_sources	= ARRAY_SIZE(clkset_sclk_dac_list),
+};
+
+static struct clksrc_clk clk_sclk_dac = {
+	.clk		= {
+		.name		= "sclk_dac",
+		.id		= -1,
+		.enable		= s5pv310_clksrc_mask_tv_ctrl,
+		.ctrlbit	= (1 << 8),
+	},
+	.sources = &clkset_sclk_dac,
+	.reg_src = { .reg = S5P_CLKSRC_TV, .shift = 8, .size = 1 },
+};
+
+static struct clksrc_clk clk_sclk_pixel  = {
+	.clk		= {
+		.name		= "sclk_pixel",
+		.id		= -1,
+		.parent = &clk_sclk_vpll.clk,
+	},
+	.reg_div = { .reg = S5P_CLKDIV_TV, .shift = 0, .size = 4 },
+};
+
+static struct clk *clkset_sclk_hdmi_list[] = {
+	[0] = &clk_sclk_pixel.clk,
+	[1] = &clk_sclk_hdmiphy,
+};
+
+static struct clksrc_sources clkset_sclk_hdmi = {
+	.sources	= clkset_sclk_hdmi_list,
+	.nr_sources	= ARRAY_SIZE(clkset_sclk_hdmi_list),
+};
+
+static struct clksrc_clk clk_sclk_hdmi = {
+	.clk		= {
+		.name		= "sclk_hdmi",
+		.id		= -1,
+		.enable		= s5pv310_clksrc_mask_tv_ctrl,
+		.ctrlbit	= (1 << 0),
+	},
+	.sources = &clkset_sclk_hdmi,
+	.reg_src = { .reg = S5P_CLKSRC_TV, .shift = 0, .size = 1 },
+};
+
+static struct clk *clkset_sclk_mixer_list[] = {
+	[0] = &clk_sclk_dac.clk,
+	[1] = &clk_sclk_hdmi.clk,
+};
+
+static struct clksrc_sources clkset_sclk_mixer = {
+	.sources	= clkset_sclk_mixer_list,
+	.nr_sources	= ARRAY_SIZE(clkset_sclk_mixer_list),
+};
+
+static struct clksrc_clk clk_sclk_mixer = {
+	.clk		= {
+		.name		= "sclk_mixer",
+		.id		= -1,
+		.enable		= s5pv310_clksrc_mask_tv_ctrl,
+		.ctrlbit	= (1 << 4),
+	},
+	.sources = &clkset_sclk_mixer,
+	.reg_src = { .reg = S5P_CLKSRC_TV, .shift = 4, .size = 1 },
+};
+
+static struct clksrc_clk *sclk_tv[] = {
+	&clk_sclk_dac,
+	&clk_sclk_pixel,
+	&clk_sclk_hdmi,
+	&clk_sclk_mixer,
+	NULL,
+};
+
+/* -------------------------------------------- */
+
 static struct clksrc_clk clk_dout_mmc0 = {
 	.clk		= {
 		.name		= "dout_mmc0",
@@ -1106,7 +1223,10 @@ void __init_or_cpufreq s5pv310_setup_clocks(void)
 }
 
 static struct clk *clks[] __initdata = {
-	/* Nothing here yet */
+	&clk_sclk_hdmi27m,
+	&clk_sclk_hdmiphy,
+	&clk_sclk_usbphy0,
+	&clk_sclk_usbphy1,
 };
 
 void __init s5pv310_register_clocks(void)
@@ -1118,6 +1238,10 @@ void __init s5pv310_register_clocks(void)
 	for (ptr = 0; ptr < ARRAY_SIZE(sysclks); ptr++)
 		s3c_register_clksrc(sysclks[ptr], 1);
 
+	/* register TV clocks */
+	for (ptr = 0; sclk_tv[ptr]; ++ptr)
+		s3c_register_clksrc(sclk_tv[ptr], 1);
+
 	s3c_register_clksrc(clksrcs, ARRAY_SIZE(clksrcs));
 	s3c_register_clocks(init_clocks, ARRAY_SIZE(init_clocks));
 
diff --git a/arch/arm/mach-s5pv310/dev-tv.c b/arch/arm/mach-s5pv310/dev-tv.c
new file mode 100644
index 0000000..b652c4c
--- /dev/null
+++ b/arch/arm/mach-s5pv310/dev-tv.c
@@ -0,0 +1,450 @@
+/* linux/arch/arm/mach-s5pv310/dev-tv.c
+ *
+ * Copyright 20i10 Samsung Electronics
+ *      Tomasz Stanislawski <t.stanislaws@samsung.com>
+ *
+ * S5P series device definition for TV device
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+*/
+
+#include "plat/tv.h"
+
+#include <mach/gpio.h>
+#include <plat/gpio-cfg.h>
+#include <mach/regs-clock.h>
+#include <mach/regs-pmu.h>
+
+#include <linux/kernel.h>
+#include <linux/string.h>
+#include <linux/platform_device.h>
+#include <linux/fb.h>
+#include <linux/gfp.h>
+#include <linux/dma-mapping.h>
+#include <linux/clk.h>
+#include <linux/regulator/consumer.h>
+#include <linux/delay.h>
+
+#include <mach/irqs.h>
+#include <mach/map.h>
+
+#include <plat/devs.h>
+#include <plat/cpu.h>
+
+/* macro for setting registeres */
+#define SETREG(name, value, mask) \
+do { \
+	u32 reg = readl(name); \
+	reg &= ~mask; \
+	reg |= value; \
+	writel(reg, name); \
+	reg = readl(name); \
+	printk(KERN_DEBUG #name " <- %08x\n", reg); \
+} while (0)
+
+/* macro for debugging registeres */
+#define DBGREG(name) \
+do { \
+	u32 reg = readl(name); \
+	printk(KERN_DEBUG #name " <- %08x\n", reg); \
+} while (0)
+
+static void dbg_plat_regs(void);
+
+/* very simpler tv-power-domain support */
+static int tv_power_cnt;
+
+static void tv_power_get(void)
+{
+	if (++tv_power_cnt == 1) {
+		int tries;
+		printk(KERN_ERR "TV power domain on - start\n");
+		dbg_plat_regs();
+		SETREG(S5P_CLKGATE_BLOCK, 0x02, 0x02); /* keep here */
+		SETREG(S5P_CMU_CLKSTOP_TV_SYS_PWR, 1, 1);
+		SETREG(S5P_CMU_RESET_TV_SYS_PWR, 1, 1);
+		SETREG(S5P_TV_SYS_PWR, 7, 7);
+		/* power domain on sequence */
+		SETREG(S5P_TV_CONFIGURATION, 7, 7);
+		for (tries = 1000; tries; mdelay(1), tries--)
+			if ((readl(S5P_TV_STATUS) & 7) == 7)
+				break;
+		WARN(tries == 0, "failed to turn TV power domain on\n");
+		printk(KERN_ERR "TV power domain on - finish\n");
+		dbg_plat_regs();
+	}
+}
+
+static void tv_power_put(void)
+{
+	if (--tv_power_cnt == 0) {
+		int tries;
+		printk(KERN_ERR "TV power domain off - start\n");
+		dbg_plat_regs();
+		SETREG(S5P_TV_CONFIGURATION, 0, 7);
+		for (tries = 1000; tries; mdelay(1), tries--)
+			if ((readl(S5P_TV_STATUS) & 7) == 0)
+				break;
+		WARN(tries == 0, "failed to turn TV power domain off\n");
+		SETREG(S5P_TV_SYS_PWR, 0, 7);
+		SETREG(S5P_CMU_RESET_TV_SYS_PWR, 0, 1);
+		SETREG(S5P_CMU_CLKSTOP_TV_SYS_PWR, 0, 1);
+		SETREG(S5P_CLKGATE_BLOCK, 0x00, 0x02); /* keep here */
+		printk(KERN_ERR "TV power domain off - finish\n");
+		dbg_plat_regs();
+	}
+}
+
+/* HDMI interface */
+static struct resource s5p_hdmi_resources[] = {
+	[0] = {
+		.start  = S5P_PA_HDMI,
+		.end    = S5P_PA_HDMI + S5P_SZ_HDMI - 1,
+		.flags  = IORESOURCE_MEM,
+	},
+	[1] = {
+		.start  = IRQ_HDMI,
+		.end    = IRQ_HDMI,
+		.flags  = IORESOURCE_IRQ,
+	},
+};
+
+static struct hdmi_platform_data hdmi_pdata;
+
+struct platform_device s5p_device_hdmi = {
+	.name           = "s5p-hdmi",
+	.id             = -1,
+	.num_resources  = ARRAY_SIZE(s5p_hdmi_resources),
+	.resource       = s5p_hdmi_resources,
+	.dev.platform_data = &hdmi_pdata,
+};
+EXPORT_SYMBOL(s5p_device_hdmi);
+
+static struct hdmi_plat_resource {
+	struct clk *hdmi;
+	struct clk *sclk_hdmi;
+	struct clk *sclk_pixel;
+	struct clk *sclk_hdmiphy;
+	struct regulator *ldo4;
+} hdmi_plat_resource;
+
+static void hdmi_deinit(struct device *dev);
+
+static int hdmi_init(struct device *dev)
+{
+	struct hdmi_plat_resource *res = &hdmi_plat_resource;
+	dev_info(dev, "platform HDMI Init\n");
+	memset(res, 0, sizeof *res);
+	/* get clocks, power, and GPIOs */
+	gpio_request(S5PV310_GPX3(7), "hpd-plug");
+	gpio_request(S5PV310_GPE0(1), "hdmi-en");
+
+	/* direct HPD to HDMI chip */
+	gpio_direction_input(S5PV310_GPX3(7));
+	s3c_gpio_cfgpin(S5PV310_GPX3(7), S3C_GPIO_SFN(0x3));
+	s3c_gpio_setpull(S5PV310_GPX3(7), S3C_GPIO_PULL_NONE);
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
+	res->ldo4 = regulator_get(dev, "vadc_3.3v_c210");
+	if (IS_ERR_OR_NULL(res->ldo4)) {
+		dev_err(dev, "failed to get regulator 'ldo4'\n");
+		goto fail;
+	}
+
+	/* use VPP as parent clock; HDMIPHY is not working yet */
+	clk_set_parent(res->sclk_hdmi, res->sclk_pixel);
+	/* regulator_enable(res->ldo4); */
+	tv_power_get();
+
+	dbg_plat_regs();
+
+	return 0;
+fail:
+	dev_err(dev, "platform HDMI Init - failed\n");
+	hdmi_deinit(dev);
+	return -ENODEV;
+}
+
+static void hdmi_deinit(struct device *dev)
+{
+	struct hdmi_plat_resource *res = &hdmi_plat_resource;
+	dev_info(dev, "platform HDMI Deinit\n");
+	/* put clocks, power, and GPIOs */
+	if (!IS_ERR_OR_NULL(res->ldo4)) {
+		tv_power_put();
+		/* regulator_disable(res->ldo4); */
+		regulator_put(res->ldo4);
+	}
+	if (!IS_ERR_OR_NULL(res->sclk_hdmiphy))
+		clk_put(res->sclk_hdmiphy);
+	if (!IS_ERR_OR_NULL(res->sclk_pixel))
+		clk_put(res->sclk_pixel);
+	if (!IS_ERR_OR_NULL(res->sclk_hdmi))
+		clk_put(res->sclk_hdmi);
+	if (!IS_ERR_OR_NULL(res->hdmi))
+		clk_put(res->hdmi);
+	memset(res, 0, sizeof *res);
+	gpio_free(S5PV310_GPE0(1));
+	gpio_free(S5PV310_GPX3(7));
+}
+
+static int hdmi_power_setup(struct device *dev, int en)
+{
+	struct hdmi_plat_resource *res = &hdmi_plat_resource;
+	if (en) {
+		dev_info(dev, "HDMI power-on\n");
+		/* turn HDMI power on */
+		gpio_direction_output(S5PV310_GPE0(1), 1);
+		/* tv_power_get(); */
+		regulator_enable(res->ldo4);
+		/* turn clocks on */
+		clk_enable(res->hdmi);
+		clk_enable(res->sclk_hdmi);
+		/* power-on hdmi physical interface */
+		SETREG(S5P_HDMI_PHY_CONTROL, 1, 1);
+	} else {
+		dev_info(dev, "HDMI power-off\n");
+		/* power-off hdmiphy */
+		SETREG(S5P_HDMI_PHY_CONTROL, 0, 1);
+		/* turn clocks off */
+		clk_disable(res->sclk_hdmi);
+		clk_disable(res->hdmi);
+		/* turn HDMI power off */
+		regulator_disable(res->ldo4);
+		/* tv_power_put(); */
+		gpio_direction_output(S5PV310_GPE0(1), 0);
+	}
+	dbg_plat_regs();
+	return 0;
+}
+
+static int hdmi_stream_setup(struct device *dev, int en)
+{
+	struct hdmi_plat_resource *res = &hdmi_plat_resource;
+	/* NOTE: assumed HDMI power is on */
+	if (en) {
+		dev_info(dev, "HDMI: stream on\n");
+		/* hdmiphy clock is used for HDMI in streaming mode */
+		clk_disable(res->sclk_hdmi);
+		clk_set_parent(res->sclk_hdmi, res->sclk_hdmiphy);
+		clk_enable(res->sclk_hdmi);
+		/* SETREG(S5P_CLKSRC_TV, 0x00000001, 0x00000001); */
+	} else {
+		dev_info(dev, "HDMI: stream off\n");
+		/* pixel(vpll) clock is used for HDMI in config mode */
+		clk_disable(res->sclk_hdmi);
+		clk_set_parent(res->sclk_hdmi, res->sclk_pixel);
+		clk_enable(res->sclk_hdmi);
+		/* SETREG(S5P_CLKSRC_TV, 0x00000000, 0x00000001); */
+	}
+	dbg_plat_regs();
+	return 0;
+}
+
+static struct hdmi_platform_data hdmi_pdata = {
+	.init = hdmi_init,
+	.deinit = hdmi_deinit,
+	.power_setup = hdmi_power_setup,
+	.stream_setup = hdmi_stream_setup,
+};
+
+/* MIXER */
+static struct resource s5p_mixer_resources[] = {
+	[0] = {
+		.start  = S5P_PA_MIXER,
+		.end    = S5P_PA_MIXER + S5P_SZ_MIXER - 1,
+		.flags  = IORESOURCE_MEM,
+		.name	= "mxr"
+	},
+	[1] = {
+		.start  = S5P_PA_VP,
+		.end    = S5P_PA_VP + S5P_SZ_VP - 1,
+		.flags  = IORESOURCE_MEM,
+		.name	= "vp"
+	},
+	[2] = {
+		.start  = IRQ_MIXER,
+		.end    = IRQ_MIXER,
+		.flags  = IORESOURCE_IRQ,
+		.name	= "irq"
+	},
+};
+
+static struct mxr_platform_data mxr_pdata;
+
+struct platform_device s5p_device_mixer = {
+	.name           = "s5p-mixer",
+	.id             = -1,
+	.num_resources  = ARRAY_SIZE(s5p_mixer_resources),
+	.resource       = s5p_mixer_resources,
+	.dev		= {
+		.coherent_dma_mask = DMA_BIT_MASK(32),
+		.dma_mask = &s5p_device_mixer.dev.coherent_dma_mask,
+		.platform_data = &mxr_pdata,
+	}
+};
+EXPORT_SYMBOL(s5p_device_mixer);
+
+static struct mxr_plat_resource {
+	struct clk *mixer;
+	struct clk *vp;
+	struct clk *sclk_mixer;
+	struct clk *sclk_hdmi;
+	struct clk *sclk_dac;
+	struct regulator *ldo4;
+} mxr_plat_resource;
+
+static void mxr_deinit(struct device *dev);
+
+static int mxr_init(struct device *dev)
+{
+	struct mxr_plat_resource *res = &mxr_plat_resource;
+	dev_info(dev, "platform Mixer Init\n");
+	res->mixer = clk_get(dev, "mixer");
+	if (IS_ERR_OR_NULL(res->mixer)) {
+		dev_err(dev, "failed to get clock 'mixer'\n");
+		goto fail;
+	}
+	res->vp = clk_get(dev, "vp");
+	if (IS_ERR_OR_NULL(res->vp)) {
+		dev_err(dev, "failed to get clock 'vp'\n");
+		goto fail;
+	}
+	res->sclk_mixer = clk_get(dev, "sclk_mixer");
+	if (IS_ERR_OR_NULL(res->sclk_mixer)) {
+		dev_err(dev, "failed to get clock 'sclk_mixer'\n");
+		goto fail;
+	}
+	res->sclk_hdmi = clk_get(dev, "sclk_hdmi");
+	if (IS_ERR_OR_NULL(res->sclk_hdmi)) {
+		dev_err(dev, "failed to get clock 'sclk_hdmi'\n");
+		goto fail;
+	}
+	res->sclk_dac = clk_get(dev, "sclk_dac");
+	if (IS_ERR_OR_NULL(res->sclk_dac)) {
+		dev_err(dev, "failed to get clock 'sclk_dac'\n");
+		goto fail;
+	}
+	res->ldo4 = regulator_get(dev, "vadc_3.3v_c210");
+	if (IS_ERR_OR_NULL(res->ldo4)) {
+		dev_err(dev, "failed to get regulator 'ldo4'\n");
+		goto fail;
+	}
+	/* regulator_enable(res->ldo4); */
+	tv_power_get();
+
+	/* XXX: fixed connetction between MIXER and HDMI */
+	clk_set_parent(res->sclk_mixer, res->sclk_hdmi);
+	dbg_plat_regs();
+	return 0;
+fail:
+	dev_err(dev, "platform Mixer Init - failed\n");
+	mxr_deinit(dev);
+	return -ENODEV;
+}
+
+static void mxr_deinit(struct device *dev)
+{
+	struct mxr_plat_resource *res = &mxr_plat_resource;
+	dev_info(dev, "platform Mixer denit\n");
+	if (!IS_ERR_OR_NULL(res->ldo4)) {
+		tv_power_put();
+		/* regulator_disable(res->ldo4); */
+		regulator_put(res->ldo4);
+	}
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
+	memset(res, 0, sizeof *res);
+}
+
+static int mxr_power_setup(struct device *dev, int en)
+{
+	struct mxr_plat_resource *res = &mxr_plat_resource;
+	/* enable/disable clocks, power, and GPIOs */
+	if (en) {
+		dev_info(dev, "MIXER power-on\n");
+		/* turn MIXER power on */
+		/* tv_power_get(); */
+		regulator_enable(res->ldo4);
+		/* turn clocks on */
+		clk_enable(res->mixer);
+		clk_enable(res->vp);
+		clk_enable(res->sclk_mixer);
+		/* HDMI CEC (no support) */
+		/* SETREG(S5P_CLKGATE_IP_PERIR, ~0, 1 << 11); */
+		/* keep here */
+	} else {
+		dev_info(dev, "MIXER power-off\n");
+		/* turn clocks off */
+		clk_disable(res->sclk_mixer);
+		clk_disable(res->vp);
+		clk_disable(res->mixer);
+		/* turn MIXER power off */
+		regulator_disable(res->ldo4);
+		/* tv_power_put(); */
+	}
+	dbg_plat_regs();
+	return 0;
+}
+
+static struct mxr_platform_output output[] = {
+	{ .output_name = "S5P HDMI connector", .module_name = "s5p-hdmi" },
+};
+
+static struct mxr_platform_data mxr_pdata = {
+	.output = output,
+	.output_cnt = ARRAY_SIZE(output),
+	.init = mxr_init,
+	.deinit = mxr_deinit,
+	.power_setup = mxr_power_setup,
+};
+
+static void dbg_plat_regs(void)
+{
+	DBGREG(S5P_CLKSRC_TV);
+	DBGREG(S5P_CLKSRC_MASK_TV);
+	DBGREG(S5P_CLKGATE_IP_TV);
+	DBGREG(S5P_CLKGATE_IP_PERIL); /* remove (unknown?) */
+	DBGREG(S5P_CLKGATE_IP_PERIL); /* I2C HDMI (I2C8) remove */
+	DBGREG(S5P_CLKGATE_IP_PERIR); /* HDMI CEC remove (no support) */
+	DBGREG(S5P_CLKGATE_BLOCK); /* keep here */
+	DBGREG(S5P_CLKSRC_TOP0);
+	DBGREG(S5P_CLKSRC_TOP1);
+	DBGREG(S5P_HDMI_PHY_CONTROL);
+	DBGREG(S5P_CMU_CLKSTOP_TV_SYS_PWR);
+	DBGREG(S5P_CMU_RESET_TV_SYS_PWR);
+	DBGREG(S5P_TV_SYS_PWR);
+	DBGREG(S5P_TV_CONFIGURATION);
+	DBGREG(S5P_TV_STATUS);
+	DBGREG(S5P_CLKDIV_TV);
+}
diff --git a/arch/arm/mach-s5pv310/include/mach/irqs.h b/arch/arm/mach-s5pv310/include/mach/irqs.h
index 0ba778b..76cfe4d 100644
--- a/arch/arm/mach-s5pv310/include/mach/irqs.h
+++ b/arch/arm/mach-s5pv310/include/mach/irqs.h
@@ -116,6 +116,10 @@
 
 #define IRQ_MCT_L1		COMBINER_IRQ(35, 3)
 
+/* Set the default NR_IRQS */
+#define IRQ_MIXER		COMBINER_IRQ(36, 0)
+#define IRQ_TVENC		COMBINER_IRQ(36, 1)
+
 #define IRQ_EINT4		COMBINER_IRQ(37, 0)
 #define IRQ_EINT5		COMBINER_IRQ(37, 1)
 #define IRQ_EINT6		COMBINER_IRQ(37, 2)
diff --git a/arch/arm/mach-s5pv310/include/mach/map.h b/arch/arm/mach-s5pv310/include/mach/map.h
index 845b739..acc2a71 100644
--- a/arch/arm/mach-s5pv310/include/mach/map.h
+++ b/arch/arm/mach-s5pv310/include/mach/map.h
@@ -147,4 +147,30 @@
 #define S5P_PA_MIPI_CSIS0		S5PV310_PA_MIPI_CSIS0
 #define S5P_PA_MIPI_CSIS1		S5PV310_PA_MIPI_CSIS1
 
+/* CEC */
+#define S5PV210_PA_CEC		(0x100B0000)
+#define S5P_PA_CEC		S5PV210_PA_CEC
+#define S5P_SZ_CEC		SZ_4K
+
+/* TVOUT */
+#define S5PV210_PA_TVENC	(0x12C20000)
+#define S5P_PA_TVENC		S5PV210_PA_TVENC
+#define S5P_SZ_TVENC		SZ_64K
+
+#define S5PV210_PA_VP		(0x12C00000)
+#define S5P_PA_VP		S5PV210_PA_VP
+#define S5P_SZ_VP		SZ_64K
+
+#define S5PV210_PA_MIXER	(0x12C10000)
+#define S5P_PA_MIXER		S5PV210_PA_MIXER
+#define S5P_SZ_MIXER		SZ_64K
+
+#define S5PV210_PA_HDMI		(0x12D00000)
+#define S5P_PA_HDMI		S5PV210_PA_HDMI
+#define S5P_SZ_HDMI		SZ_1M
+
+#define S5PV210_I2C_HDMI_PHY	(0x138E0000)
+#define S5P_I2C_HDMI_PHY	S5PV210_I2C_HDMI_PHY
+#define S5P_I2C_HDMI_SZ_PHY	SZ_1K
+
 #endif /* __ASM_ARCH_MAP_H */
diff --git a/arch/arm/mach-s5pv310/include/mach/regs-clock.h b/arch/arm/mach-s5pv310/include/mach/regs-clock.h
index b5c4ada..b1af66c 100644
--- a/arch/arm/mach-s5pv310/include/mach/regs-clock.h
+++ b/arch/arm/mach-s5pv310/include/mach/regs-clock.h
@@ -33,6 +33,7 @@
 #define S5P_CLKSRC_TOP0			S5P_CLKREG(0x0C210)
 #define S5P_CLKSRC_TOP1			S5P_CLKREG(0x0C214)
 #define S5P_CLKSRC_CAM			S5P_CLKREG(0x0C220)
+#define S5P_CLKSRC_TV			S5P_CLKREG(0x0C224)
 #define S5P_CLKSRC_IMAGE		S5P_CLKREG(0x0C230)
 #define S5P_CLKSRC_LCD0			S5P_CLKREG(0x0C234)
 #define S5P_CLKSRC_LCD1			S5P_CLKREG(0x0C238)
@@ -42,6 +43,7 @@
 
 #define S5P_CLKDIV_TOP			S5P_CLKREG(0x0C510)
 #define S5P_CLKDIV_CAM			S5P_CLKREG(0x0C520)
+#define S5P_CLKDIV_TV			S5P_CLKREG(0x0C524)
 #define S5P_CLKDIV_IMAGE		S5P_CLKREG(0x0C530)
 #define S5P_CLKDIV_LCD0			S5P_CLKREG(0x0C534)
 #define S5P_CLKDIV_LCD1			S5P_CLKREG(0x0C538)
@@ -58,6 +60,7 @@
 
 #define S5P_CLKSRC_MASK_TOP		S5P_CLKREG(0x0C310)
 #define S5P_CLKSRC_MASK_CAM		S5P_CLKREG(0x0C320)
+#define S5P_CLKSRC_MASK_TV		S5P_CLKREG(0x0C324)
 #define S5P_CLKSRC_MASK_LCD0		S5P_CLKREG(0x0C334)
 #define S5P_CLKSRC_MASK_LCD1		S5P_CLKREG(0x0C338)
 #define S5P_CLKSRC_MASK_FSYS		S5P_CLKREG(0x0C340)
@@ -67,6 +70,7 @@
 #define S5P_CLKDIV_STAT_TOP		S5P_CLKREG(0x0C610)
 
 #define S5P_CLKGATE_IP_CAM		S5P_CLKREG(0x0C920)
+#define S5P_CLKGATE_IP_TV		S5P_CLKREG(0x0C924)
 #define S5P_CLKGATE_IP_IMAGE		S5P_CLKREG(0x0C930)
 #define S5P_CLKGATE_IP_LCD0		S5P_CLKREG(0x0C934)
 #define S5P_CLKGATE_IP_LCD1		S5P_CLKREG(0x0C938)
@@ -164,4 +168,15 @@
 
 #define S5P_EPLL_CON			S5P_EPLL_CON0
 
+/* TVOUT related */
+#define S5P_TV_CONFIGURATION		S5P_PMUREG(0x03C20)
+#define S5P_TV_STATUS			S5P_PMUREG(0x03C24)
+#define S5P_TV_SYS_PWR			S5P_PMUREG(0x1384)
+#define S5P_CMU_CLKSTOP_TV_SYS_PWR	S5P_PMUREG(0x1144)
+#define S5P_CMU_RESET_TV_SYS_PWR	S5P_PMUREG(0x1164)
+
+#define S5P_HDMI_PHY_CONTROL		S5P_PMUREG(0x0700)
+#define S5P_CLKOUT_CMU_TOP		S5P_CLKREG(0x0CA00)
+#define S5P_PMU_DEBUG			S5P_PMUREG(0x0A00)
+
 #endif /* __ASM_ARCH_REGS_CLOCK_H */
diff --git a/arch/arm/plat-samsung/include/plat/devs.h b/arch/arm/plat-samsung/include/plat/devs.h
index 6effbb4..a6b78d4 100644
--- a/arch/arm/plat-samsung/include/plat/devs.h
+++ b/arch/arm/plat-samsung/include/plat/devs.h
@@ -134,6 +134,8 @@ extern struct platform_device samsung_device_keypad;
 extern struct platform_device s5p_device_fimc0;
 extern struct platform_device s5p_device_fimc1;
 extern struct platform_device s5p_device_fimc2;
+extern struct platform_device s5p_device_hdmi;
+extern struct platform_device s5p_device_mixer;
 
 extern struct platform_device s5p_device_mipi_csis0;
 extern struct platform_device s5p_device_mipi_csis1;
-- 
1.7.3.5

