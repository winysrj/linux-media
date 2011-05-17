Return-path: <mchehab@pedra>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:50405 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753319Ab1EQJ3M (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 17 May 2011 05:29:12 -0400
Received: by mail-wy0-f174.google.com with SMTP id 21so219628wya.19
        for <linux-media@vger.kernel.org>; Tue, 17 May 2011 02:29:11 -0700 (PDT)
From: Javier Martin <javier.martin@vista-silicon.com>
To: linux-media@vger.kernel.org
Cc: g.liakhovetski@gmx.de, laurent.pinchart@ideasonboard.com,
	carlighting@yahoo.co.nz, beagleboard@googlegroups.com,
	linux-arm-kernel@lists.infradead.org,
	Javier Martin <javier.martin@vista-silicon.com>
Subject: [PATCH 2/2] OMAP3BEAGLE: Add support for mt9p031 sensor (LI-5M03 module).
Date: Tue, 17 May 2011 11:28:48 +0200
Message-Id: <1305624528-5595-3-git-send-email-javier.martin@vista-silicon.com>
In-Reply-To: <1305624528-5595-1-git-send-email-javier.martin@vista-silicon.com>
References: <1305624528-5595-1-git-send-email-javier.martin@vista-silicon.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>


Signed-off-by: Javier Martin <javier.martin@vista-silicon.com>
---
 arch/arm/mach-omap2/board-omap3beagle.c |  130 ++++++++++++++++++++++++++++++-
 arch/arm/mach-omap2/devices.c           |    2 +-
 2 files changed, 127 insertions(+), 5 deletions(-)

diff --git a/arch/arm/mach-omap2/board-omap3beagle.c b/arch/arm/mach-omap2/board-omap3beagle.c
index 33007fd..ccd72dc 100644
--- a/arch/arm/mach-omap2/board-omap3beagle.c
+++ b/arch/arm/mach-omap2/board-omap3beagle.c
@@ -24,15 +24,20 @@
 #include <linux/input.h>
 #include <linux/gpio_keys.h>
 #include <linux/opp.h>
+#include <linux/i2c.h>
+#include <linux/mm.h>
+#include <linux/videodev2.h>
 
 #include <linux/mtd/mtd.h>
 #include <linux/mtd/partitions.h>
 #include <linux/mtd/nand.h>
 #include <linux/mmc/host.h>
-
+#include <linux/gpio.h>
 #include <linux/regulator/machine.h>
 #include <linux/i2c/twl.h>
 
+#include <media/mt9p031.h>
+
 #include <mach/hardware.h>
 #include <asm/mach-types.h>
 #include <asm/mach/arch.h>
@@ -47,12 +52,18 @@
 #include <plat/nand.h>
 #include <plat/usb.h>
 #include <plat/omap_device.h>
+#include <plat/i2c.h>
 
 #include "mux.h"
 #include "hsmmc.h"
 #include "timer-gp.h"
 #include "pm.h"
+#include "devices.h"
+#include "../../../drivers/media/video/omap3isp/isp.h"
+#include "../../../drivers/media/video/omap3isp/ispreg.h"
 
+#define MT9P031_RESET_GPIO	98
+#define MT9P031_XCLK		ISP_XCLK_A
 #define NAND_BLOCK_SIZE		SZ_128K
 
 /*
@@ -273,6 +284,44 @@ static struct regulator_consumer_supply beagle_vsim_supply = {
 
 static struct gpio_led gpio_leds[];
 
+static struct regulator_consumer_supply beagle_vaux3_supply = {
+	.supply		= "cam_1v8",
+};
+
+static struct regulator_consumer_supply beagle_vaux4_supply = {
+	.supply		= "cam_2v8",
+};
+
+/* VAUX3 for CAM_1V8 */
+static struct regulator_init_data beagle_vaux3 = {
+	.constraints = {
+		.min_uV			= 1800000,
+		.max_uV			= 1800000,
+		.apply_uV		= true,
+		.valid_modes_mask	= REGULATOR_MODE_NORMAL
+					| REGULATOR_MODE_STANDBY,
+		.valid_ops_mask		= REGULATOR_CHANGE_MODE
+					| REGULATOR_CHANGE_STATUS,
+	},
+	.num_consumer_supplies	= 1,
+	.consumer_supplies	= &beagle_vaux3_supply,
+};
+
+/* VAUX4 for CAM_2V8 */
+static struct regulator_init_data beagle_vaux4 = {
+	.constraints = {
+		.min_uV			= 1800000,
+		.max_uV			= 1800000,
+		.apply_uV		= true,
+		.valid_modes_mask	= REGULATOR_MODE_NORMAL
+					| REGULATOR_MODE_STANDBY,
+		.valid_ops_mask		= REGULATOR_CHANGE_MODE
+					| REGULATOR_CHANGE_STATUS,
+	},
+	.num_consumer_supplies	= 1,
+	.consumer_supplies	= &beagle_vaux4_supply,
+};
+
 static int beagle_twl_gpio_setup(struct device *dev,
 		unsigned gpio, unsigned ngpio)
 {
@@ -309,6 +358,15 @@ static int beagle_twl_gpio_setup(struct device *dev,
 			pr_err("%s: unable to configure EHCI_nOC\n", __func__);
 	}
 
+	if (omap3_beagle_get_rev() == OMAP3BEAGLE_BOARD_XM) {
+		/*
+		 * Power on camera interface - only on pre-production, not
+		 * needed on production boards
+		 */
+		gpio_request(gpio + 2, "CAM_EN");
+		gpio_direction_output(gpio + 2, 1);
+	}
+
 	/*
 	 * TWL4030_GPIO_MAX + 0 == ledA, EHCI nEN_USB_PWR (out, XM active
 	 * high / others active low)
@@ -451,6 +509,8 @@ static struct twl4030_platform_data beagle_twldata = {
 	.vsim		= &beagle_vsim,
 	.vdac		= &beagle_vdac,
 	.vpll2		= &beagle_vpll2,
+	.vaux3		= &beagle_vaux3,
+	.vaux4		= &beagle_vaux4,
 };
 
 static struct i2c_board_info __initdata beagle_i2c_boardinfo[] = {
@@ -463,15 +523,16 @@ static struct i2c_board_info __initdata beagle_i2c_boardinfo[] = {
 };
 
 static struct i2c_board_info __initdata beagle_i2c_eeprom[] = {
-       {
-               I2C_BOARD_INFO("eeprom", 0x50),
-       },
+	{
+		I2C_BOARD_INFO("eeprom", 0x50),
+	},
 };
 
 static int __init omap3_beagle_i2c_init(void)
 {
 	omap_register_i2c_bus(1, 2600, beagle_i2c_boardinfo,
 			ARRAY_SIZE(beagle_i2c_boardinfo));
+	omap_register_i2c_bus(2, 100, NULL, 0); /* Enable I2C2 for camera */
 	/* Bus 3 is attached to the DVI port where devices like the pico DLP
 	 * projector don't work reliably with 400kHz */
 	omap_register_i2c_bus(3, 100, beagle_i2c_eeprom, ARRAY_SIZE(beagle_i2c_eeprom));
@@ -654,6 +715,62 @@ static void __init beagle_opp_init(void)
 	return;
 }
 
+extern struct platform_device omap3isp_device;
+
+static int beagle_cam_set_xclk(struct v4l2_subdev *subdev, int hz)
+{
+	struct isp_device *isp = platform_get_drvdata(&omap3isp_device);
+	int ret;
+
+	ret = isp->platform_cb.set_xclk(isp, hz, MT9P031_XCLK);
+	return 0;
+}
+
+static int beagle_cam_reset(struct v4l2_subdev *subdev, int active)
+{
+	/* Set RESET_BAR to !active */
+	gpio_set_value(MT9P031_RESET_GPIO, !active);
+
+	return 0;
+}
+
+static struct mt9p031_platform_data beagle_mt9p031_platform_data = {
+	.set_xclk		= beagle_cam_set_xclk,
+	.reset			= beagle_cam_reset,
+};
+
+static struct i2c_board_info mt9p031_camera_i2c_device = {
+	I2C_BOARD_INFO("mt9p031", 0x48),
+	.platform_data = &beagle_mt9p031_platform_data,
+};
+
+static struct isp_subdev_i2c_board_info mt9p031_camera_subdevs[] = {
+	{
+		.board_info = &mt9p031_camera_i2c_device,
+		.i2c_adapter_id = 2,
+	},
+	{ NULL, 0, },
+};
+
+static struct isp_v4l2_subdevs_group beagle_camera_subdevs[] = {
+	{
+		.subdevs = mt9p031_camera_subdevs,
+		.interface = ISP_INTERFACE_PARALLEL,
+		.bus = {
+			.parallel = {
+				.data_lane_shift = 0,
+				.clk_pol = 1,
+				.bridge = ISPCTRL_PAR_BRIDGE_DISABLE,
+			}
+		},
+	},
+	{ },
+};
+
+static struct isp_platform_data beagle_isp_platform_data = {
+	.subdevs = beagle_camera_subdevs,
+};
+
 static void __init omap3_beagle_init(void)
 {
 	omap3_mux_init(board_mux, OMAP_PACKAGE_CBB);
@@ -679,6 +796,11 @@ static void __init omap3_beagle_init(void)
 
 	beagle_display_init();
 	beagle_opp_init();
+
+	/* Enable camera */
+	gpio_request(MT9P031_RESET_GPIO, "cam_rst");
+	gpio_direction_output(MT9P031_RESET_GPIO, 0);
+	omap3_init_camera(&beagle_isp_platform_data);
 }
 
 MACHINE_START(OMAP3_BEAGLE, "OMAP3 Beagle Board")
diff --git a/arch/arm/mach-omap2/devices.c b/arch/arm/mach-omap2/devices.c
index 7b85585..ae5ba25 100644
--- a/arch/arm/mach-omap2/devices.c
+++ b/arch/arm/mach-omap2/devices.c
@@ -200,7 +200,7 @@ static struct resource omap3isp_resources[] = {
 	}
 };
 
-static struct platform_device omap3isp_device = {
+struct platform_device omap3isp_device = {
 	.name		= "omap3isp",
 	.id		= -1,
 	.num_resources	= ARRAY_SIZE(omap3isp_resources),
-- 
1.7.0.4

