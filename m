Return-path: <linux-media-owner@vger.kernel.org>
Received: from na3sys009aog136.obsmtp.com ([74.125.149.85]:42812 "EHLO
	na3sys009aog136.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754573Ab2EBPQY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 2 May 2012 11:16:24 -0400
Received: by obhx4 with SMTP id x4so1351991obh.34
        for <linux-media@vger.kernel.org>; Wed, 02 May 2012 08:16:23 -0700 (PDT)
From: Sergio Aguirre <saaguirre@ti.com>
To: linux-media@vger.kernel.org
Cc: linux-omap@vger.kernel.org, Sergio Aguirre <saaguirre@ti.com>
Subject: [PATCH v3 08/10] arm: omap4panda: Add support for omap4iss camera
Date: Wed,  2 May 2012 10:15:47 -0500
Message-Id: <1335971749-21258-9-git-send-email-saaguirre@ti.com>
In-Reply-To: <1335971749-21258-1-git-send-email-saaguirre@ti.com>
References: <1335971749-21258-1-git-send-email-saaguirre@ti.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This adds support for camera interface with the support for
following sensors:

- OV5640
- OV5650

Signed-off-by: Sergio Aguirre <saaguirre@ti.com>
---
 arch/arm/mach-omap2/Kconfig                   |   16 ++
 arch/arm/mach-omap2/Makefile                  |    1 +
 arch/arm/mach-omap2/board-omap4panda-camera.c |  209 +++++++++++++++++++++++++
 3 files changed, 226 insertions(+), 0 deletions(-)
 create mode 100644 arch/arm/mach-omap2/board-omap4panda-camera.c

diff --git a/arch/arm/mach-omap2/Kconfig b/arch/arm/mach-omap2/Kconfig
index 54645aa..4b267a6 100644
--- a/arch/arm/mach-omap2/Kconfig
+++ b/arch/arm/mach-omap2/Kconfig
@@ -359,6 +359,22 @@ config MACH_OMAP4_PANDA
 	select OMAP_PACKAGE_CBS
 	select REGULATOR_FIXED_VOLTAGE if REGULATOR
 
+config MACH_OMAP4_PANDA_CAMERA_SUPPORT
+	bool "OMAP4 Panda Board Camera support"
+	depends on MACH_OMAP4_PANDA
+	select MEDIA_SUPPORT
+	select MEDIA_CONTROLLER
+	select VIDEO_DEV
+	select VIDEO_V4L2_SUBDEV_API
+	select V4L_PLATFORM_DRIVERS
+	select VIDEO_OMAP4
+	select VIDEO_OV5640
+	select VIDEO_OV5650
+	help
+	  Enable Camera HW support for PandaBoard.
+	  This is for using the OMAP4 ISS CSI2A Camera sensor
+	  interface.
+
 config OMAP3_EMU
 	bool "OMAP3 debugging peripherals"
 	depends on ARCH_OMAP3
diff --git a/arch/arm/mach-omap2/Makefile b/arch/arm/mach-omap2/Makefile
index ebd8f63..e6724c4 100644
--- a/arch/arm/mach-omap2/Makefile
+++ b/arch/arm/mach-omap2/Makefile
@@ -240,6 +240,7 @@ obj-$(CONFIG_MACH_TI8148EVM)		+= board-ti8168evm.o
 # Platform specific device init code
 
 obj-$(CONFIG_MACH_OMAP_4430SDP_CAMERA_SUPPORT)	+= board-4430sdp-camera.o
+obj-$(CONFIG_MACH_OMAP4_PANDA_CAMERA_SUPPORT)	+= board-omap4panda-camera.o
 
 omap-flash-$(CONFIG_MTD_NAND_OMAP2)	:= board-flash.o
 omap-flash-$(CONFIG_MTD_ONENAND_OMAP2)	:= board-flash.o
diff --git a/arch/arm/mach-omap2/board-omap4panda-camera.c b/arch/arm/mach-omap2/board-omap4panda-camera.c
new file mode 100644
index 0000000..a5f7863
--- /dev/null
+++ b/arch/arm/mach-omap2/board-omap4panda-camera.c
@@ -0,0 +1,209 @@
+#include <linux/gpio.h>
+#include <linux/clk.h>
+#include <linux/delay.h>
+
+#include <plat/i2c.h>
+#include <plat/omap-pm.h>
+
+#include <asm/mach-types.h>
+
+#include <media/ov5640.h>
+#include <media/ov5650.h>
+
+#include "devices.h"
+#include "../../../drivers/media/video/omap4iss/iss.h"
+
+#include "control.h"
+#include "mux.h"
+
+#define PANDA_GPIO_CAM_PWRDN		45
+#define PANDA_GPIO_CAM_RESET		83
+
+static struct clk *panda_cam_aux_clk;
+
+static int panda_ov_power(struct v4l2_subdev *subdev, int on)
+{
+	struct device *dev = subdev->v4l2_dev->dev;
+
+	if (on) {
+		int ret;
+
+		gpio_set_value(PANDA_GPIO_CAM_PWRDN, 0);
+		ret = clk_enable(panda_cam_aux_clk);
+		if (ret) {
+			dev_err(dev,
+				"Error in clk_enable() in %s(%d)\n",
+				__func__, on);
+			gpio_set_value(PANDA_GPIO_CAM_PWRDN, 1);
+			return ret;
+		}
+		mdelay(2);
+	} else {
+		clk_disable(panda_cam_aux_clk);
+		gpio_set_value(PANDA_GPIO_CAM_PWRDN, 1);
+	}
+
+	return 0;
+}
+
+#define OV5640_I2C_ADDRESS   (0x3C)
+
+static struct ov5640_platform_data ov5640_platform_data = {
+      .s_power = panda_ov_power,
+};
+
+static struct i2c_board_info ov5640_camera_i2c_device = {
+	I2C_BOARD_INFO("ov5640", OV5640_I2C_ADDRESS),
+	.platform_data = &ov5640_platform_data,
+};
+
+#define OV5650_I2C_ADDRESS   (0x36)
+
+static struct ov5650_platform_data ov5650_platform_data = {
+      .s_power = panda_ov_power,
+};
+
+static struct i2c_board_info ov5650_camera_i2c_device = {
+	I2C_BOARD_INFO("ov5650", OV5650_I2C_ADDRESS),
+	.platform_data = &ov5650_platform_data,
+};
+
+static struct iss_subdev_i2c_board_info ov5640_camera_subdevs[] = {
+	{
+		.board_info = &ov5640_camera_i2c_device,
+		.i2c_adapter_id = 3,
+	},
+	{ NULL, 0, },
+};
+
+static struct iss_subdev_i2c_board_info ov5650_camera_subdevs[] = {
+	{
+		.board_info = &ov5650_camera_i2c_device,
+		.i2c_adapter_id = 3,
+	},
+	{ NULL, 0, },
+};
+
+static struct iss_v4l2_subdevs_group panda_camera_subdevs[] = {
+	{
+		.subdevs = ov5640_camera_subdevs,
+		.interface = ISS_INTERFACE_CSI2A_PHY1,
+		.bus = { .csi2 = {
+			.lanecfg	= {
+				.clk = {
+					.pol = 0,
+					.pos = 1,
+				},
+				.data[0] = {
+					.pol = 0,
+					.pos = 2,
+				},
+			},
+		} },
+	},
+	{
+		.subdevs = ov5650_camera_subdevs,
+		.interface = ISS_INTERFACE_CSI2A_PHY1,
+		.bus = { .csi2 = {
+			.lanecfg	= {
+				.clk = {
+					.pol = 0,
+					.pos = 1,
+				},
+				.data[0] = {
+					.pol = 0,
+					.pos = 2,
+				},
+			},
+		} },
+	},
+	{ },
+};
+
+static void panda_omap4iss_set_constraints(struct iss_device *iss, bool enable)
+{
+	if (!iss)
+		return;
+
+	/* FIXME: Look for something more precise as a good throughtput limit */
+	omap_pm_set_min_bus_tput(iss->dev, OCP_INITIATOR_AGENT,
+				 enable ? 800000 : -1);
+}
+
+static struct iss_platform_data panda_iss_platform_data = {
+	.subdevs = panda_camera_subdevs,
+	.set_constraints = panda_omap4iss_set_constraints,
+};
+
+
+static struct omap_device_pad omap4iss_pads[] = {
+	{
+		.name   = "csi21_dx0.csi21_dx0",
+		.enable = OMAP_MUX_MODE0 | OMAP_INPUT_EN,
+	},
+	{
+		.name   = "csi21_dy0.csi21_dy0",
+		.enable = OMAP_MUX_MODE0 | OMAP_INPUT_EN,
+	},
+	{
+		.name   = "csi21_dx1.csi21_dx1",
+		.enable = OMAP_MUX_MODE0 | OMAP_INPUT_EN,
+	},
+	{
+		.name   = "csi21_dy1.csi21_dy1",
+		.enable = OMAP_MUX_MODE0 | OMAP_INPUT_EN,
+	},
+	{
+		.name   = "csi21_dx2.csi21_dx2",
+		.enable = OMAP_MUX_MODE0 | OMAP_INPUT_EN,
+	},
+	{
+		.name   = "csi21_dy2.csi21_dy2",
+		.enable = OMAP_MUX_MODE0 | OMAP_INPUT_EN,
+	},
+};
+
+static struct omap_board_data omap4iss_data = {
+	.id	    		= 1,
+	.pads	 		= omap4iss_pads,
+	.pads_cnt       	= ARRAY_SIZE(omap4iss_pads),
+};
+
+static int __init panda_camera_init(void)
+{
+	if (!machine_is_omap4_panda())
+		return 0;
+
+	panda_cam_aux_clk = clk_get(NULL, "auxclk1_ck");
+	if (IS_ERR(panda_cam_aux_clk)) {
+		printk(KERN_ERR "Unable to get auxclk1_ck\n");
+		return -ENODEV;
+	}
+
+	if (clk_set_rate(panda_cam_aux_clk,
+			clk_round_rate(panda_cam_aux_clk, 24000000)))
+		return -EINVAL;
+
+	/* Select GPIO 45 */
+	omap_mux_init_gpio(PANDA_GPIO_CAM_PWRDN, OMAP_PIN_OUTPUT);
+
+	/* Select GPIO 83 */
+	omap_mux_init_gpio(PANDA_GPIO_CAM_RESET, OMAP_PIN_OUTPUT);
+
+	/* Init FREF_CLK1_OUT */
+	omap_mux_init_signal("fref_clk1_out", OMAP_PIN_OUTPUT);
+
+	if (gpio_request_one(PANDA_GPIO_CAM_PWRDN, GPIOF_OUT_INIT_HIGH,
+			     "CAM_PWRDN"))
+		printk(KERN_WARNING "Cannot request GPIO %d\n",
+			PANDA_GPIO_CAM_PWRDN);
+
+	if (gpio_request_one(PANDA_GPIO_CAM_RESET, GPIOF_OUT_INIT_HIGH,
+			     "CAM_RESET"))
+		printk(KERN_WARNING "Cannot request GPIO %d\n",
+			PANDA_GPIO_CAM_RESET);
+
+	omap4_init_camera(&panda_iss_platform_data, &omap4iss_data);
+	return 0;
+}
+late_initcall(panda_camera_init);
-- 
1.7.5.4

