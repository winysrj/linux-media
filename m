Return-path: <mchehab@pedra>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:54066 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752327Ab1E3Iha (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 30 May 2011 04:37:30 -0400
Received: by mail-ww0-f44.google.com with SMTP id 36so3680967wwa.1
        for <linux-media@vger.kernel.org>; Mon, 30 May 2011 01:37:29 -0700 (PDT)
From: Javier Martin <javier.martin@vista-silicon.com>
To: linux-media@vger.kernel.org
Cc: g.liakhovetski@gmx.de, laurent.pinchart@ideasonboard.com,
	carlighting@yahoo.co.nz, beagleboard@googlegroups.com,
	mch_kot@yahoo.com.cn,
	Javier Martin <javier.martin@vista-silicon.com>
Subject: [PATCH v4 2/2] Add support for mt9p031 (LI-5M03 module) in Beagleboard xM.
Date: Mon, 30 May 2011 10:37:17 +0200
Message-Id: <1306744637-9051-2-git-send-email-javier.martin@vista-silicon.com>
In-Reply-To: <1306744637-9051-1-git-send-email-javier.martin@vista-silicon.com>
References: <1306744637-9051-1-git-send-email-javier.martin@vista-silicon.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Since isp clocks have not been exposed yet, this patch
includes a temporal solution for testing mt9p031 driver
in Beagleboard xM.

Signed-off-by: Javier Martin <javier.martin@vista-silicon.com>
---
 arch/arm/mach-omap2/Makefile                   |    1 +
 arch/arm/mach-omap2/board-omap3beagle-camera.c |   88 ++++++++++++++++++++++++
 arch/arm/mach-omap2/board-omap3beagle.c        |   58 ++++++++++++++++
 3 files changed, 147 insertions(+), 0 deletions(-)
 create mode 100644 arch/arm/mach-omap2/board-omap3beagle-camera.c

diff --git a/arch/arm/mach-omap2/Makefile b/arch/arm/mach-omap2/Makefile
index 512b152..05cd983 100644
--- a/arch/arm/mach-omap2/Makefile
+++ b/arch/arm/mach-omap2/Makefile
@@ -179,6 +179,7 @@ obj-$(CONFIG_MACH_OMAP_2430SDP)		+= board-2430sdp.o \
 					   hsmmc.o
 obj-$(CONFIG_MACH_OMAP_APOLLON)		+= board-apollon.o
 obj-$(CONFIG_MACH_OMAP3_BEAGLE)		+= board-omap3beagle.o \
+					   board-omap3beagle-camera.o \
 					   hsmmc.o
 obj-$(CONFIG_MACH_DEVKIT8000)     	+= board-devkit8000.o \
                                            hsmmc.o
diff --git a/arch/arm/mach-omap2/board-omap3beagle-camera.c b/arch/arm/mach-omap2/board-omap3beagle-camera.c
new file mode 100644
index 0000000..840f8f3
--- /dev/null
+++ b/arch/arm/mach-omap2/board-omap3beagle-camera.c
@@ -0,0 +1,88 @@
+#include <linux/gpio.h>
+#include <linux/regulator/machine.h>
+
+#include <plat/i2c.h>
+
+#include <media/mt9p031.h>
+
+#include "devices.h"
+#include "../../../drivers/media/video/omap3isp/isp.h"
+
+#define MT9P031_RESET_GPIO	98
+#define MT9P031_XCLK		ISP_XCLK_A
+
+static struct regulator *reg_1v8, *reg_2v8;
+
+static int beagle_cam_set_xclk(struct v4l2_subdev *subdev, int hz)
+{
+	struct isp_device *isp = v4l2_dev_to_isp_device(subdev->v4l2_dev);
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
+	.set_xclk               = beagle_cam_set_xclk,
+	.reset                  = beagle_cam_reset,
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
+				.parallel = {
+					.data_lane_shift = 0,
+					.clk_pol = 1,
+					.bridge = ISPCTRL_PAR_BRIDGE_DISABLE,
+				}
+		},
+	},
+	{ },
+};
+
+static struct isp_platform_data beagle_isp_platform_data = {
+	.subdevs = beagle_camera_subdevs,
+};
+
+void __init beagle_camera_init(void)
+{
+	reg_1v8 = regulator_get(NULL, "cam_1v8");
+	if (IS_ERR(reg_1v8))
+		pr_err("%s: cannot get cam_1v8 regulator\n", __func__);
+	else
+		regulator_enable(reg_1v8);
+
+	reg_2v8 = regulator_get(NULL, "cam_2v8");
+	if (IS_ERR(reg_2v8))
+		pr_err("%s: cannot get cam_2v8 regulator\n", __func__);
+	else
+		regulator_enable(reg_2v8);
+
+	omap_register_i2c_bus(2, 100, NULL, 0);
+	gpio_request(MT9P031_RESET_GPIO, "cam_rst");
+	gpio_direction_output(MT9P031_RESET_GPIO, 0);
+	omap3_init_camera(&beagle_isp_platform_data);
+}
diff --git a/arch/arm/mach-omap2/board-omap3beagle.c b/arch/arm/mach-omap2/board-omap3beagle.c
index 33007fd..0bdc522 100644
--- a/arch/arm/mach-omap2/board-omap3beagle.c
+++ b/arch/arm/mach-omap2/board-omap3beagle.c
@@ -24,12 +24,16 @@
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
 
+#include <linux/gpio.h>
 #include <linux/regulator/machine.h>
 #include <linux/i2c/twl.h>
 
@@ -47,6 +51,7 @@
 #include <plat/nand.h>
 #include <plat/usb.h>
 #include <plat/omap_device.h>
+#include <plat/i2c.h>
 
 #include "mux.h"
 #include "hsmmc.h"
@@ -273,6 +278,44 @@ static struct regulator_consumer_supply beagle_vsim_supply = {
 
 static struct gpio_led gpio_leds[];
 
+static struct regulator_consumer_supply beagle_vaux3_supply = {
+	.supply         = "cam_1v8",
+};
+
+static struct regulator_consumer_supply beagle_vaux4_supply = {
+	.supply         = "cam_2v8",
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
+	.num_consumer_supplies		= 1,
+	.consumer_supplies		= &beagle_vaux3_supply,
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
+	.num_consumer_supplies  = 1,
+	.consumer_supplies      = &beagle_vaux4_supply,
+};
+
 static int beagle_twl_gpio_setup(struct device *dev,
 		unsigned gpio, unsigned ngpio)
 {
@@ -309,6 +352,15 @@ static int beagle_twl_gpio_setup(struct device *dev,
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
@@ -451,6 +503,8 @@ static struct twl4030_platform_data beagle_twldata = {
 	.vsim		= &beagle_vsim,
 	.vdac		= &beagle_vdac,
 	.vpll2		= &beagle_vpll2,
+	.vaux3          = &beagle_vaux3,
+	.vaux4          = &beagle_vaux4,
 };
 
 static struct i2c_board_info __initdata beagle_i2c_boardinfo[] = {
@@ -654,10 +708,13 @@ static void __init beagle_opp_init(void)
 	return;
 }
 
+extern void __init beagle_camera_init(void);
+
 static void __init omap3_beagle_init(void)
 {
 	omap3_mux_init(board_mux, OMAP_PACKAGE_CBB);
 	omap3_beagle_init_rev();
+
 	omap3_beagle_i2c_init();
 	platform_add_devices(omap3_beagle_devices,
 			ARRAY_SIZE(omap3_beagle_devices));
@@ -679,6 +736,7 @@ static void __init omap3_beagle_init(void)
 
 	beagle_display_init();
 	beagle_opp_init();
+	beagle_camera_init();
 }
 
 MACHINE_START(OMAP3_BEAGLE, "OMAP3 Beagle Board")
-- 
1.7.0.4

