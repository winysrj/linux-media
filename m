Return-path: <mchehab@pedra>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:35236 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752410Ab1FTLVc (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 20 Jun 2011 07:21:32 -0400
Received: by mail-wy0-f174.google.com with SMTP id 38so1570355wyb.19
        for <linux-media@vger.kernel.org>; Mon, 20 Jun 2011 04:21:32 -0700 (PDT)
From: Javier Martin <javier.martin@vista-silicon.com>
To: linux-media@vger.kernel.org
Cc: g.liakhovetski@gmx.de, laurent.pinchart@ideasonboard.com,
	carlighting@yahoo.co.nz, beagleboard@googlegroups.com,
	mch_kot@yahoo.com.cn,
	Javier Martin <javier.martin@vista-silicon.com>
Subject: [PATCH v8 2/2] Add support for mt9p031 sensor in Beagleboard XM.
Date: Mon, 20 Jun 2011 13:21:17 +0200
Message-Id: <1308568877-9164-2-git-send-email-javier.martin@vista-silicon.com>
In-Reply-To: <1308568877-9164-1-git-send-email-javier.martin@vista-silicon.com>
References: <1308568877-9164-1-git-send-email-javier.martin@vista-silicon.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Use new platform data ext_freq and target_freq.

Signed-off-by: Javier Martin <javier.martin@vista-silicon.com>
---
 arch/arm/mach-omap2/Makefile                   |    1 +
 arch/arm/mach-omap2/board-omap3beagle-camera.c |   95 ++++++++++++++++++++++++
 arch/arm/mach-omap2/board-omap3beagle.c        |   50 ++++++++++++
 3 files changed, 146 insertions(+), 0 deletions(-)
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
index 0000000..96b4f95
--- /dev/null
+++ b/arch/arm/mach-omap2/board-omap3beagle-camera.c
@@ -0,0 +1,95 @@
+#include <linux/gpio.h>
+#include <linux/regulator/machine.h>
+
+#include <plat/i2c.h>
+
+#include <media/mt9p031.h>
+#include <asm/mach-types.h>
+#include "devices.h"
+#include "../../../drivers/media/video/omap3isp/isp.h"
+
+#define MT9P031_RESET_GPIO	98
+#define MT9P031_XCLK		ISP_XCLK_A
+#define MT9P031_EXT_FREQ	21000000
+
+static struct regulator *reg_1v8, *reg_2v8;
+
+static int beagle_cam_set_xclk(struct v4l2_subdev *subdev, int hz)
+{
+	struct isp_device *isp = v4l2_dev_to_isp_device(subdev->v4l2_dev);
+
+	return isp->platform_cb.set_xclk(isp, hz, MT9P031_XCLK);
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
+	.set_xclk	= beagle_cam_set_xclk,
+	.reset		= beagle_cam_reset,
+	.ext_freq	= MT9P031_EXT_FREQ,
+	.target_freq	= 48000000,
+	.version	= MT9P031_COLOR_VERSION,
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
+static int __init beagle_camera_init(void)
+{
+	if (!machine_is_omap3_beagle() || !cpu_is_omap3630())
+		return 0;
+
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
+	return 0;
+}
+late_initcall(beagle_camera_init);
diff --git a/arch/arm/mach-omap2/board-omap3beagle.c b/arch/arm/mach-omap2/board-omap3beagle.c
index 33007fd..c14e9d6 100644
--- a/arch/arm/mach-omap2/board-omap3beagle.c
+++ b/arch/arm/mach-omap2/board-omap3beagle.c
@@ -30,6 +30,7 @@
 #include <linux/mtd/nand.h>
 #include <linux/mmc/host.h>
 
+#include <linux/gpio.h>
 #include <linux/regulator/machine.h>
 #include <linux/i2c/twl.h>
 
@@ -273,6 +274,44 @@ static struct regulator_consumer_supply beagle_vsim_supply = {
 
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
@@ -309,6 +348,15 @@ static int beagle_twl_gpio_setup(struct device *dev,
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
@@ -451,6 +499,8 @@ static struct twl4030_platform_data beagle_twldata = {
 	.vsim		= &beagle_vsim,
 	.vdac		= &beagle_vdac,
 	.vpll2		= &beagle_vpll2,
+	.vaux3          = &beagle_vaux3,
+	.vaux4          = &beagle_vaux4,
 };
 
 static struct i2c_board_info __initdata beagle_i2c_boardinfo[] = {
-- 
1.7.0.4

