Return-path: <mchehab@pedra>
Received: from eu1sys200aog116.obsmtp.com ([207.126.144.141]:53587 "EHLO
	eu1sys200aog116.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755727Ab0KJMxp (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 10 Nov 2010 07:53:45 -0500
From: Jimmy Rubin <jimmy.rubin@stericsson.com>
To: <linux-fbdev@vger.kernel.org>,
	<linux-arm-kernel@lists.infradead.org>,
	<linux-media@vger.kernel.org>
Cc: Linus Walleij <linus.walleij@stericsson.com>,
	Dan Johansson <dan.johansson@stericsson.com>,
	Jimmy Rubin <jimmy.rubin@stericsson.com>
Subject: [PATCH 10/10] ux500: MCDE: Add platform specific data
Date: Wed, 10 Nov 2010 13:04:13 +0100
Message-ID: <1289390653-6111-11-git-send-email-jimmy.rubin@stericsson.com>
In-Reply-To: <1289390653-6111-10-git-send-email-jimmy.rubin@stericsson.com>
References: <1289390653-6111-1-git-send-email-jimmy.rubin@stericsson.com>
 <1289390653-6111-2-git-send-email-jimmy.rubin@stericsson.com>
 <1289390653-6111-3-git-send-email-jimmy.rubin@stericsson.com>
 <1289390653-6111-4-git-send-email-jimmy.rubin@stericsson.com>
 <1289390653-6111-5-git-send-email-jimmy.rubin@stericsson.com>
 <1289390653-6111-6-git-send-email-jimmy.rubin@stericsson.com>
 <1289390653-6111-7-git-send-email-jimmy.rubin@stericsson.com>
 <1289390653-6111-8-git-send-email-jimmy.rubin@stericsson.com>
 <1289390653-6111-9-git-send-email-jimmy.rubin@stericsson.com>
 <1289390653-6111-10-git-send-email-jimmy.rubin@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

This patch adds support for the MCDE, Memory-to-display controller,
found in the ST-Ericsson ux500 products.

The configuration of the MCDE hardware, the MCDE framebuffer device
and the display that is connected to ux500 is managed in this patch.

Signed-off-by: Jimmy Rubin <jimmy.rubin@stericsson.com>
Acked-by: Linus Walleij <linus.walleij.stericsson.com>
---
 arch/arm/mach-ux500/Kconfig                    |    8 +
 arch/arm/mach-ux500/Makefile                   |    1 +
 arch/arm/mach-ux500/board-mop500-mcde.c        |  209 ++++++++++++++++++++++++
 arch/arm/mach-ux500/board-mop500-regulators.c  |   28 +++
 arch/arm/mach-ux500/board-mop500.c             |    3 +
 arch/arm/mach-ux500/devices-db8500.c           |   68 ++++++++
 arch/arm/mach-ux500/include/mach/db8500-regs.h |    7 +
 arch/arm/mach-ux500/include/mach/devices.h     |    1 +
 arch/arm/mach-ux500/include/mach/prcmu-regs.h  |    1 +
 arch/arm/mach-ux500/include/mach/prcmu.h       |    3 +
 arch/arm/mach-ux500/prcmu.c                    |  129 +++++++++++++++
 11 files changed, 458 insertions(+), 0 deletions(-)
 create mode 100644 arch/arm/mach-ux500/board-mop500-mcde.c

diff --git a/arch/arm/mach-ux500/Kconfig b/arch/arm/mach-ux500/Kconfig
index 2dd44a0..a868629 100644
--- a/arch/arm/mach-ux500/Kconfig
+++ b/arch/arm/mach-ux500/Kconfig
@@ -50,5 +50,13 @@ config U5500_MBOX
 	default y
 	help
 	  Add support for U5500 mailbox communication with modem side
+#Configuration for MCDE setup
 
+config DISPLAY_GENERIC_DSI_PRIMARY
+        bool "Main display support"
+	depends on MACH_U8500_MOP && FB_MCDE && REGULATOR
+	select MCDE_DISPLAY_GENERIC_DSI
+        default y
+	help
+	  Say yes here if main display exists
 endif
diff --git a/arch/arm/mach-ux500/Makefile b/arch/arm/mach-ux500/Makefile
index 9e27a84..5562c85 100644
--- a/arch/arm/mach-ux500/Makefile
+++ b/arch/arm/mach-ux500/Makefile
@@ -13,3 +13,4 @@ obj-$(CONFIG_LOCAL_TIMERS)	+= localtimer.o
 obj-$(CONFIG_REGULATOR_AB8500)	+= board-mop500-regulators.o
 obj-$(CONFIG_U5500_MODEM_IRQ)	+= modem_irq.o
 obj-$(CONFIG_U5500_MBOX)	+= mbox.o
+obj-$(CONFIG_FB_MCDE)		+= board-mop500-mcde.o
diff --git a/arch/arm/mach-ux500/board-mop500-mcde.c b/arch/arm/mach-ux500/board-mop500-mcde.c
new file mode 100644
index 0000000..3695746
--- /dev/null
+++ b/arch/arm/mach-ux500/board-mop500-mcde.c
@@ -0,0 +1,209 @@
+/*
+ * Copyright (C) ST-Ericsson SA 2010
+ *
+ * Author: Marcus Lorentzon <marcus.xm.lorentzon@stericsson.com>
+ * for ST-Ericsson.
+ *
+ * License terms: GNU General Public License (GPL), version 2.
+ */
+#include <linux/platform_device.h>
+#include <linux/kernel.h>
+#include <linux/gpio.h>
+#include <linux/delay.h>
+
+#include <video/mcde/mcde_display.h>
+#include <video/mcde/mcde_display-generic_dsi.h>
+#include <video/mcde/mcde_fb.h>
+#include <video/mcde/mcde_dss.h>
+
+#include <mach/db8500-regs.h>
+
+#include "board-mop500.h"
+
+#define DSI_UNIT_INTERVAL_0	0x9
+#define DSI_UNIT_INTERVAL_1	0x9
+#define DSI_UNIT_INTERVAL_2	0x6
+
+#define PRIMARY_DISPLAY_ID	0
+#define SECONDARY_DISPLAY_ID	1
+#define TERTIARY_DISPLAY_ID	2
+
+static bool rotate_main = true;
+
+static int generic_platform_enable(struct mcde_display_device *dev)
+{
+	struct mcde_display_generic_platform_data *pdata =
+		dev->dev.platform_data;
+
+	dev_dbg(&dev->dev, "%s: Reset & power on generic display\n", __func__);
+
+	if (pdata->regulator) {
+		if (regulator_enable(pdata->regulator) < 0) {
+			dev_err(&dev->dev, "%s:Failed to enable regulator\n"
+				, __func__);
+			return -EINVAL;
+		}
+	}
+
+	gpio_direction_output(pdata->reset_gpio,
+				!pdata->reset_high);
+	if (pdata->reset_gpio)
+		gpio_set_value(pdata->reset_gpio, pdata->reset_high);
+	mdelay(pdata->reset_delay);
+	if (pdata->reset_gpio)
+		gpio_set_value(pdata->reset_gpio, !pdata->reset_high);
+
+	return 0;
+}
+
+static int generic_platform_disable(struct mcde_display_device *dev)
+{
+	struct mcde_display_generic_platform_data *pdata =
+		dev->dev.platform_data;
+
+	dev_dbg(&dev->dev, "%s:Reset & power off generic display\n", __func__);
+
+	if (pdata->regulator) {
+		if (regulator_disable(pdata->regulator) < 0) {
+			dev_err(&dev->dev, "%s:Failed to disable regulator\n"
+				, __func__);
+			return -EINVAL;
+		}
+	}
+	return 0;
+}
+
+#ifdef CONFIG_DISPLAY_GENERIC_DSI_PRIMARY
+static struct mcde_port port0 = {
+	.type = MCDE_PORTTYPE_DSI,
+	.mode = MCDE_PORTMODE_CMD,
+	.pixel_format = MCDE_PORTPIXFMT_DSI_24BPP,
+	.ifc = 1,
+	.link = 0,
+#ifdef CONFIG_DISPLAY_GENERIC_DSI_PRIMARY_AUTO_SYNC
+	.sync_src = MCDE_SYNCSRC_OFF,
+	.update_auto_trig = true,
+#else
+	.sync_src = MCDE_SYNCSRC_BTA,
+	.update_auto_trig = false,
+#endif
+	.phy = {
+		.dsi = {
+			.virt_id = 0,
+			.num_data_lanes = 2,
+			.ui = DSI_UNIT_INTERVAL_0,
+			.clk_cont = false,
+		},
+	},
+};
+
+struct mcde_display_generic_platform_data generic_display0_pdata = {
+	.reset_gpio = MOP500_EGPIO(15),
+	.reset_delay = 1,
+	.regulator_id = "v-display",
+	.min_supply_voltage = 2500000, /* 2.5V */
+	.max_supply_voltage = 2700000 /* 2.7V */
+};
+
+struct mcde_display_device generic_display0 = {
+	.name = "mcde_disp_generic",
+	.id = PRIMARY_DISPLAY_ID,
+	.port = &port0,
+	.chnl_id = MCDE_CHNL_A,
+	.fifo = MCDE_FIFO_C0,
+	.default_pixel_format = MCDE_OVLYPIXFMT_RGB565,
+	.native_x_res = 864,
+	.native_y_res = 480,
+#ifdef CONFIG_DISPLAY_GENERIC_DSI_PRIMARY_VSYNC
+	.synchronized_update = true,
+#else
+	.synchronized_update = false,
+#endif
+	/* TODO: Remove rotation buffers once ESRAM driver is completed */
+	.rotbuf1 = U8500_ESRAM_BASE + 0x20000 * 4,
+	.rotbuf2 = U8500_ESRAM_BASE + 0x20000 * 4 + 0x10000,
+	.dev = {
+		.platform_data = &generic_display0_pdata,
+	},
+	.platform_enable = generic_platform_enable,
+	.platform_disable = generic_platform_disable,
+};
+#endif /* CONFIG_DISPLAY_GENERIC_DSI_PRIMARY */
+
+
+static struct fb_info *fbs[1] = { NULL};
+static struct mcde_display_device *displays[1] = { NULL};
+/*
+* This function will create the framebuffer for the display that is registered.
+*/
+static int display_postregistered_callback(struct notifier_block *nb,
+	unsigned long event, void *dev)
+{
+	struct mcde_display_device *ddev = dev;
+	u16 width, height;
+	u16 virtual_width, virtual_height;
+	u32 rotate = FB_ROTATE_UR;
+
+	if (event != MCDE_DSS_EVENT_DISPLAY_REGISTERED)
+		return 0;
+
+	if (ddev->id < PRIMARY_DISPLAY_ID || ddev->id >= ARRAY_SIZE(fbs))
+		return 0;
+
+	mcde_dss_get_native_resolution(ddev, &width, &height);
+
+	if (ddev->id == PRIMARY_DISPLAY_ID && rotate_main) {
+		swap(width, height);
+#ifdef CONFIG_DISPLAY_GENERIC_DSI_PRIMARY_ROTATE_180_DEGREES
+		rotate = FB_ROTATE_CCW;
+#else
+		rotate = FB_ROTATE_CW;
+#endif
+	}
+
+	virtual_width = width;
+	virtual_height = height * 2;
+#ifdef CONFIG_DISPLAY_GENERIC_DSI_PRIMARY_AUTO_SYNC
+	if (ddev->id == PRIMARY_DISPLAY_ID)
+		virtual_height = height;
+#endif
+
+	/* Create frame buffer */
+	fbs[ddev->id] = mcde_fb_create(ddev,
+		width, height,
+		virtual_width, virtual_height,
+		ddev->default_pixel_format,
+		rotate);
+
+	if (IS_ERR(fbs[ddev->id]))
+		pr_warning("Failed to create fb for display %s\n", ddev->name);
+	else
+		pr_info("Framebuffer created (%s)\n", ddev->name);
+
+	return 0;
+}
+
+static struct notifier_block display_nb = {
+	.notifier_call = display_postregistered_callback,
+};
+
+
+int __init init_display_devices(void)
+{
+	int ret;
+
+	ret = mcde_dss_register_notifier(&display_nb);
+	if (ret)
+		pr_warning("Failed to register dss notifier\n");
+
+#ifdef CONFIG_DISPLAY_GENERIC_DSI_PRIMARY
+	ret = mcde_display_device_register(&generic_display0);
+	if (ret)
+		pr_warning("Failed to register generic display device 0\n");
+	displays[0] = &generic_display0;
+#endif
+
+	return ret;
+}
+
+module_init(init_display_devices);
diff --git a/arch/arm/mach-ux500/board-mop500-regulators.c b/arch/arm/mach-ux500/board-mop500-regulators.c
index 1187f1f..8b1ecee 100644
--- a/arch/arm/mach-ux500/board-mop500-regulators.c
+++ b/arch/arm/mach-ux500/board-mop500-regulators.c
@@ -9,6 +9,20 @@
  */
 #include <linux/kernel.h>
 #include <linux/regulator/machine.h>
+#include <linux/platform_device.h>
+
+#include <mach/devices.h>
+
+
+#define AB8500_VAUXN_LDO_MIN_VOLTAGE    (1100000)
+#define AB8500_VAUXN_LDO_MAX_VOLTAGE    (3300000)
+
+static struct regulator_consumer_supply ab8500_vaux1_consumers[] = {
+	{
+		.dev = NULL,
+		.supply = "v-display",
+	},
+};
 
 /* supplies to the display/camera */
 static struct regulator_init_data ab8500_vaux1_regulator = {
@@ -19,6 +33,8 @@ static struct regulator_init_data ab8500_vaux1_regulator = {
 		.valid_ops_mask = REGULATOR_CHANGE_VOLTAGE|
 					REGULATOR_CHANGE_STATUS,
 	},
+	.num_consumer_supplies = ARRAY_SIZE(ab8500_vaux1_consumers),
+	.consumer_supplies = ab8500_vaux1_consumers,
 };
 
 /* supplies to the on-board eMMC */
@@ -92,10 +108,22 @@ static struct regulator_init_data ab8500_vintcore_init = {
 };
 
 /* supply for U8500 CSI/DSI, VANA LDO */
+#define AB8500_VANA_REGULATOR_MIN_VOLTAGE      (0)
+#define AB8500_VANA_REGULATOR_MAX_VOLTAGE      (1200000)
+
+static struct regulator_consumer_supply ab8500_vana_consumers[] = {
+	{
+		.dev_name = "mcde",
+		.supply = "v-ana",
+	},
+};
+
 static struct regulator_init_data ab8500_vana_init = {
 	.constraints = {
 		.name = "V-CSI/DSI",
 		.valid_ops_mask = REGULATOR_CHANGE_STATUS,
 	},
+	.num_consumer_supplies = ARRAY_SIZE(ab8500_vana_consumers),
+	.consumer_supplies = ab8500_vana_consumers,
 };
 
diff --git a/arch/arm/mach-ux500/board-mop500.c b/arch/arm/mach-ux500/board-mop500.c
index e6e3e82..7c90a50 100644
--- a/arch/arm/mach-ux500/board-mop500.c
+++ b/arch/arm/mach-ux500/board-mop500.c
@@ -303,6 +303,9 @@ static struct platform_device *platform_devs[] __initdata = {
 	&ux500_i2c2_device,
 	&ux500_i2c3_device,
 	&ux500_ske_keypad_device,
+#ifdef CONFIG_FB_MCDE
+	&ux500_mcde_device,
+#endif
 };
 
 static void __init u8500_init_machine(void)
diff --git a/arch/arm/mach-ux500/devices-db8500.c b/arch/arm/mach-ux500/devices-db8500.c
index a090208..1017fdc 100644
--- a/arch/arm/mach-ux500/devices-db8500.c
+++ b/arch/arm/mach-ux500/devices-db8500.c
@@ -12,11 +12,15 @@
 #include <linux/gpio.h>
 #include <linux/amba/bus.h>
 #include <linux/amba/pl022.h>
+#include <linux/delay.h>
+
+#include <video/mcde/mcde.h>
 
 #include <plat/ste_dma40.h>
 
 #include <mach/hardware.h>
 #include <mach/setup.h>
+#include <mach/prcmu.h>
 
 #include "ste-dma40-db8500.h"
 
@@ -379,3 +383,67 @@ struct platform_device ux500_ske_keypad_device = {
 	.num_resources = ARRAY_SIZE(keypad_resources),
 	.resource = keypad_resources,
 };
+static struct resource mcde_resources[] = {
+	[0] = {
+		.name  = MCDE_IO_AREA,
+		.start = U8500_MCDE_BASE,
+		.end   = U8500_MCDE_BASE + 0x1000 - 1, /*TODO: Fix size*/
+		.flags = IORESOURCE_MEM,
+	},
+	[1] = {
+		.name  = MCDE_IO_AREA,
+		.start = U8500_DSI_LINK1_BASE,
+		.end   = U8500_DSI_LINK1_BASE + U8500_DSI_LINK_SIZE - 1,
+		.flags = IORESOURCE_MEM,
+	},
+	[2] = {
+		.name  = MCDE_IO_AREA,
+		.start = U8500_DSI_LINK2_BASE,
+		.end   = U8500_DSI_LINK2_BASE + U8500_DSI_LINK_SIZE - 1,
+		.flags = IORESOURCE_MEM,
+	},
+	[3] = {
+		.name  = MCDE_IO_AREA,
+		.start = U8500_DSI_LINK3_BASE,
+		.end   = U8500_DSI_LINK3_BASE + U8500_DSI_LINK_SIZE - 1,
+		.flags = IORESOURCE_MEM,
+	},
+	[4] = {
+		.name  = MCDE_IRQ,
+		.start = IRQ_DISP,
+		.end   = IRQ_DISP,
+		.flags = IORESOURCE_IRQ,
+	},
+};
+
+static int mcde_platform_enable(void)
+{
+	return prcmu_mcde_enable();
+}
+
+static int mcde_platform_disable(void)
+{
+	return prcmu_mcde_disable();
+}
+
+static struct mcde_platform_data mcde_pdata = {
+	.num_dsilinks = 3,
+	.outmux = { 0, 3, 0, 0, 0 },
+	.syncmux = 0x01,
+	.regulator_id = "v-ana",
+	.clock_dsi_id = "hdmi",
+	.clock_dsi_lp_id = "tv",
+	.clock_mcde_id = "mcde",
+	.platform_enable = mcde_platform_enable,
+	.platform_disable = mcde_platform_disable,
+};
+
+struct platform_device ux500_mcde_device = {
+	.name = "mcde",
+	.id = -1,
+	.dev = {
+		.platform_data = &mcde_pdata,
+	},
+	.num_resources = ARRAY_SIZE(mcde_resources),
+	.resource = mcde_resources,
+};
diff --git a/arch/arm/mach-ux500/include/mach/db8500-regs.h b/arch/arm/mach-ux500/include/mach/db8500-regs.h
index f07d098..4acb632 100644
--- a/arch/arm/mach-ux500/include/mach/db8500-regs.h
+++ b/arch/arm/mach-ux500/include/mach/db8500-regs.h
@@ -142,4 +142,11 @@
 #define U8500_GPIOBANK7_BASE	(U8500_GPIO2_BASE + 0x80)
 #define U8500_GPIOBANK8_BASE	U8500_GPIO3_BASE
 
+#define U8500_DSI_LINK_SIZE	0x1000
+#define U8500_DSI_LINK1_BASE	U8500_MCDE_BASE
+#define U8500_DSI_LINK2_BASE	(U8500_DSI_LINK1_BASE + U8500_DSI_LINK_SIZE)
+#define U8500_DSI_LINK3_BASE	(U8500_DSI_LINK2_BASE + U8500_DSI_LINK_SIZE)
+#define U8500_DSI_LINK_COUNT	0x3
+
+
 #endif
diff --git a/arch/arm/mach-ux500/include/mach/devices.h b/arch/arm/mach-ux500/include/mach/devices.h
index b91a4d1..58fbb34 100644
--- a/arch/arm/mach-ux500/include/mach/devices.h
+++ b/arch/arm/mach-ux500/include/mach/devices.h
@@ -19,6 +19,7 @@ extern struct amba_device ux500_uart0_device;
 extern struct amba_device ux500_uart1_device;
 extern struct amba_device ux500_uart2_device;
 
+extern struct platform_device ux500_mcde_device;
 extern struct platform_device ux500_i2c1_device;
 extern struct platform_device ux500_i2c2_device;
 extern struct platform_device ux500_i2c3_device;
diff --git a/arch/arm/mach-ux500/include/mach/prcmu-regs.h b/arch/arm/mach-ux500/include/mach/prcmu-regs.h
index 8885f39..1fc419e 100644
--- a/arch/arm/mach-ux500/include/mach/prcmu-regs.h
+++ b/arch/arm/mach-ux500/include/mach/prcmu-regs.h
@@ -80,6 +80,7 @@
 
 /* ePOD and memory power signal control registers */
 #define PRCM_EPOD_C_SET            (_PRCMU_BASE + 0x410)
+#define PRCM_EPOD_C_CLR            (_PRCMU_BASE + 0x414)
 #define PRCM_SRAM_LS_SLEEP         (_PRCMU_BASE + 0x304)
 
 /* Debug power control unit registers */
diff --git a/arch/arm/mach-ux500/include/mach/prcmu.h b/arch/arm/mach-ux500/include/mach/prcmu.h
index 549843f..ee00a9c 100644
--- a/arch/arm/mach-ux500/include/mach/prcmu.h
+++ b/arch/arm/mach-ux500/include/mach/prcmu.h
@@ -12,4 +12,7 @@
 int prcmu_abb_read(u8 slave, u8 reg, u8 *value, u8 size);
 int prcmu_abb_write(u8 slave, u8 reg, u8 *value, u8 size);
 
+int prcmu_mcde_enable(void);
+int prcmu_mcde_disable(void);
+
 #endif /* __MACH_PRCMU_H */
diff --git a/arch/arm/mach-ux500/prcmu.c b/arch/arm/mach-ux500/prcmu.c
index 293274d..33b7827 100644
--- a/arch/arm/mach-ux500/prcmu.c
+++ b/arch/arm/mach-ux500/prcmu.c
@@ -11,6 +11,7 @@
 #include <linux/errno.h>
 #include <linux/err.h>
 #include <linux/io.h>
+#include <linux/delay.h>
 #include <linux/mutex.h>
 #include <linux/completion.h>
 #include <linux/jiffies.h>
@@ -37,6 +38,34 @@
 #define I2C_READ(slave) (((slave) << 1) | BIT(0))
 #define I2C_STOP_EN BIT(3)
 
+/*
+* Used by MCDE to setup all necessary PRCMU registers
+*/
+#define PRCMU_CLAMP_DSS_DSIPLL		0x00600C00
+#define PRCMU_CLAMP_DSIPLL		0x00400800
+#define PRCMU_RESET_DSS_DSIPLL		0x0000400C
+#define PRCMU_RESET_DSIPLL		0x00004000
+#define PRCMU_ENABLE_DSS_MEM		0x00200000
+#define PRCMU_ENABLE_DSS_LOGIC		0x00100000
+#define PRCMU_DSS_SLEEP_OUTPUT_MASK	0x400
+#define PRCMU_UNCLAMP_DSS_DSIPLL	0x00600C00
+#define PRCMU_UNCLAMP_DSIPLL		0x00400800
+#define PRCMU_POWER_ON_DSI		0x00008000
+
+#define PRCMU_DSI_CLOCK_SETTING		0x00000148
+#define PRCMU_DSI_LP_CLOCK_SETTING	0x00000F00
+#define PRCMU_PLLDSI_FREQ_SETTING	0x00020123
+
+#define PRCMU_ENABLE_PLLDSI		0x00000001
+#define PRCMU_DISABLE_PLLDSI		0x00000000
+#define PRCMU_RELEASE_RESET_DSS		0x0000400C
+#define PRCMU_RELEASE_RESET_DSI		0x00004000
+#define PRCMU_DSI_PLLOUT_SEL_SETTING	0x00000202
+#define PRCMU_ENABLE_ESCAPE_CLOCK	0x07010101
+#define PRCMU_DSI_RESET_SW		0x00000007
+
+#define PRCMU_MCDE_DELAY			10
+
 enum ack_mb5_status {
 	I2C_WR_OK = 0x01,
 	I2C_RD_OK = 0x02,
@@ -145,6 +174,106 @@ unlock_and_return:
 }
 EXPORT_SYMBOL(prcmu_abb_write);
 
+static void mcde_epod_enable(void)
+{
+	/* Power on DSS mem */
+	writel(PRCMU_ENABLE_DSS_MEM, PRCM_EPOD_C_SET);
+	mdelay(PRCMU_MCDE_DELAY);
+	/* Power on DSS logic */
+	writel(PRCMU_ENABLE_DSS_LOGIC, PRCM_EPOD_C_SET);
+	mdelay(PRCMU_MCDE_DELAY);
+}
+
+static void mcde_epod_disable(void)
+{
+	/* Power off DSS mem */
+	writel(PRCMU_ENABLE_DSS_MEM, PRCM_EPOD_C_CLR);
+	mdelay(PRCMU_MCDE_DELAY);
+	/* Power off DSS logic */
+	writel(PRCMU_ENABLE_DSS_LOGIC, PRCM_EPOD_C_CLR);
+	mdelay(PRCMU_MCDE_DELAY);
+}
+
+int prcmu_mcde_enable(void)
+{
+	u32 temp;
+
+	/* Clamp DSS out, DSIPLL in/out, (why not DSS input?) */
+	writel(PRCMU_CLAMP_DSS_DSIPLL, PRCM_MMIP_LS_CLAMP_SET);
+	mdelay(PRCMU_MCDE_DELAY);
+
+	/* Enable DSS_M_INITN, DSS_L_RESETN, DSIPLL_RESETN resets */
+	writel(PRCMU_RESET_DSS_DSIPLL, PRCM_APE_RESETN_CLR);
+	mdelay(PRCMU_MCDE_DELAY);
+
+	mcde_epod_enable();
+
+	/* Release DSS_SLEEP */
+	temp = readl(PRCM_SRAM_LS_SLEEP);
+	writel(temp & ~PRCMU_DSS_SLEEP_OUTPUT_MASK, PRCM_SRAM_LS_SLEEP);
+	mdelay(PRCMU_MCDE_DELAY);
+
+	/* Unclamp DSS out, DSIPLL in/out, (why not DSS input?) */
+	writel(PRCMU_UNCLAMP_DSS_DSIPLL, PRCM_MMIP_LS_CLAMP_CLR);
+	mdelay(PRCMU_MCDE_DELAY);
+
+	/* HDMI and TVCLK Should be handled somewhere else */
+	writel(PRCMU_DSI_CLOCK_SETTING, PRCM_HDMICLK_MGT);
+	mdelay(PRCMU_MCDE_DELAY);
+
+	writel(PRCMU_DSI_LP_CLOCK_SETTING, PRCM_TVCLK_MGT);
+	mdelay(PRCMU_MCDE_DELAY);
+
+	writel(PRCMU_PLLDSI_FREQ_SETTING, PRCM_PLLDSI_FREQ);
+	mdelay(PRCMU_MCDE_DELAY);
+	/* Start DSI PLL */
+	writel(PRCMU_ENABLE_PLLDSI, PRCM_PLLDSI_ENABLE);
+	mdelay(PRCMU_MCDE_DELAY);
+
+	/* Release DSS_M_INITN, DSS_L_RESETN, DSIPLL_RESETN */
+	writel(PRCMU_RELEASE_RESET_DSS, PRCM_APE_RESETN_SET);
+	mdelay(PRCMU_MCDE_DELAY);
+
+	writel(PRCMU_DSI_PLLOUT_SEL_SETTING, PRCM_DSI_PLLOUT_SEL);
+	mdelay(PRCMU_MCDE_DELAY);
+
+	writel(PRCMU_ENABLE_ESCAPE_CLOCK, PRCM_DSITVCLK_DIV);
+	mdelay(PRCMU_MCDE_DELAY);
+	/* Release DSI reset 0/1/2 */
+	writel(PRCMU_DSI_RESET_SW, PRCM_DSI_SW_RESET);
+	mdelay(PRCMU_MCDE_DELAY);
+	return 0;
+}
+
+int prcmu_mcde_disable(void)
+{
+	u32 temp;
+
+	writel(PRCMU_DISABLE_PLLDSI, PRCM_PLLDSI_ENABLE);
+	mdelay(PRCMU_MCDE_DELAY);
+
+	/* Clamp DSS out, DSIPLL in/out, (why not DSS input?) */
+	writel(PRCMU_CLAMP_DSS_DSIPLL, PRCM_MMIP_LS_CLAMP_SET);
+	mdelay(PRCMU_MCDE_DELAY);
+
+	/* Release DSS_SLEEP */
+	temp = readl(PRCM_SRAM_LS_SLEEP);
+	writel(temp & ~PRCMU_DSS_SLEEP_OUTPUT_MASK, PRCM_SRAM_LS_SLEEP);
+	mdelay(PRCMU_MCDE_DELAY);
+
+	/* Disable DSS_M_INITN, DSS_L_RESETN, DSIPLL_RESETN resets */
+	writel(PRCMU_RESET_DSS_DSIPLL, PRCM_APE_RESETN_CLR);
+	mdelay(PRCMU_MCDE_DELAY);
+
+	mcde_epod_disable();
+
+	/* Unclamp DSS out, DSIPLL in/out, (why not DSS input?) */
+	writel(PRCMU_UNCLAMP_DSS_DSIPLL, PRCM_MMIP_LS_CLAMP_CLR);
+	mdelay(PRCMU_MCDE_DELAY);
+
+	return 0;
+}
+
 static void read_mailbox_0(void)
 {
 	writel(MBOX_BIT(0), PRCM_ARM_IT1_CLEAR);
-- 
1.6.3.3

