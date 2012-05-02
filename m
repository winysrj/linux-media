Return-path: <linux-media-owner@vger.kernel.org>
Received: from na3sys009aob106.obsmtp.com ([74.125.149.76]:39087 "EHLO
	na3sys009aog106.obsmtp.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755288Ab2EBPQT (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 2 May 2012 11:16:19 -0400
Received: by obbuo19 with SMTP id uo19so1209106obb.26
        for <linux-media@vger.kernel.org>; Wed, 02 May 2012 08:16:17 -0700 (PDT)
From: Sergio Aguirre <saaguirre@ti.com>
To: linux-media@vger.kernel.org
Cc: linux-omap@vger.kernel.org, Sergio Aguirre <saaguirre@ti.com>
Subject: [PATCH v3 07/10] arm: omap4430sdp: Add support for omap4iss camera
Date: Wed,  2 May 2012 10:15:46 -0500
Message-Id: <1335971749-21258-8-git-send-email-saaguirre@ti.com>
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
 arch/arm/mach-omap2/Kconfig                |   16 +
 arch/arm/mach-omap2/Makefile               |    2 +
 arch/arm/mach-omap2/board-4430sdp-camera.c |  415 ++++++++++++++++++++++++++++
 arch/arm/mach-omap2/board-4430sdp.c        |   20 ++
 4 files changed, 453 insertions(+), 0 deletions(-)
 create mode 100644 arch/arm/mach-omap2/board-4430sdp-camera.c

diff --git a/arch/arm/mach-omap2/Kconfig b/arch/arm/mach-omap2/Kconfig
index 8141b76..54645aa 100644
--- a/arch/arm/mach-omap2/Kconfig
+++ b/arch/arm/mach-omap2/Kconfig
@@ -335,6 +335,22 @@ config MACH_OMAP_4430SDP
 	select OMAP_PACKAGE_CBS
 	select REGULATOR_FIXED_VOLTAGE if REGULATOR
 
+config MACH_OMAP_4430SDP_CAMERA_SUPPORT
+	bool "OMAP 4430 SDP board Camera support"
+	depends on MACH_OMAP_4430SDP
+	select MEDIA_SUPPORT
+	select MEDIA_CONTROLLER
+	select VIDEO_DEV
+	select VIDEO_V4L2_SUBDEV_API
+	select V4L_PLATFORM_DRIVERS
+	select VIDEO_OMAP4
+	select VIDEO_OV5640
+	select VIDEO_OV5650
+	help
+	  Enable Camera HW support for OMAP 4430 SDP board
+	  This is for using the OMAP4 ISS CSI2A Camera sensor
+	  interface.
+
 config MACH_OMAP4_PANDA
 	bool "OMAP4 Panda Board"
 	default y
diff --git a/arch/arm/mach-omap2/Makefile b/arch/arm/mach-omap2/Makefile
index 49f92bc..ebd8f63 100644
--- a/arch/arm/mach-omap2/Makefile
+++ b/arch/arm/mach-omap2/Makefile
@@ -239,6 +239,8 @@ obj-$(CONFIG_MACH_TI8148EVM)		+= board-ti8168evm.o
 
 # Platform specific device init code
 
+obj-$(CONFIG_MACH_OMAP_4430SDP_CAMERA_SUPPORT)	+= board-4430sdp-camera.o
+
 omap-flash-$(CONFIG_MTD_NAND_OMAP2)	:= board-flash.o
 omap-flash-$(CONFIG_MTD_ONENAND_OMAP2)	:= board-flash.o
 obj-y					+= $(omap-flash-y) $(omap-flash-m)
diff --git a/arch/arm/mach-omap2/board-4430sdp-camera.c b/arch/arm/mach-omap2/board-4430sdp-camera.c
new file mode 100644
index 0000000..9a8881f
--- /dev/null
+++ b/arch/arm/mach-omap2/board-4430sdp-camera.c
@@ -0,0 +1,415 @@
+#include <linux/gpio.h>
+#include <linux/clk.h>
+#include <linux/delay.h>
+#include <linux/i2c/twl.h>
+#include <linux/mfd/twl6040.h>
+#include <linux/regulator/consumer.h>
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
+#define OMAP4430SDP_GPIO_CAM_PDN_B	38
+#define OMAP4430SDP_GPIO_CAM_PDN_C	39
+
+static struct clk *sdp4430_cam1_aux_clk;
+static struct clk *sdp4430_cam2_aux_clk;
+static struct regulator *sdp4430_cam2pwr_reg;
+
+static int sdp4430_ov_cam1_power(struct v4l2_subdev *subdev, int on)
+{
+	struct device *dev = subdev->v4l2_dev->dev;
+	int ret;
+
+	if (on) {
+		if (!regulator_is_enabled(sdp4430_cam2pwr_reg)) {
+			ret = regulator_enable(sdp4430_cam2pwr_reg);
+			if (ret) {
+				dev_err(dev,
+					"Error in enabling sensor power regulator 'cam2pwr'\n");
+				return ret;
+			}
+
+			msleep(50);
+		}
+
+		gpio_set_value(OMAP4430SDP_GPIO_CAM_PDN_B, 1);
+		msleep(10);
+		ret = clk_enable(sdp4430_cam1_aux_clk); /* Enable XCLK */
+		if (ret) {
+			dev_err(dev,
+				"Error in clk_enable() in %s(%d)\n",
+				__func__, on);
+			gpio_set_value(OMAP4430SDP_GPIO_CAM_PDN_B, 0);
+			return ret;
+		}
+		msleep(10);
+	} else {
+		clk_disable(sdp4430_cam1_aux_clk);
+		msleep(1);
+		gpio_set_value(OMAP4430SDP_GPIO_CAM_PDN_B, 0);
+		if (regulator_is_enabled(sdp4430_cam2pwr_reg)) {
+			ret = regulator_disable(sdp4430_cam2pwr_reg);
+			if (ret) {
+				dev_err(dev,
+					"Error in disabling sensor power regulator 'cam2pwr'\n");
+				return ret;
+			}
+		}
+	}
+
+	return 0;
+}
+
+static int sdp4430_ov_cam2_power(struct v4l2_subdev *subdev, int on)
+{
+	struct device *dev = subdev->v4l2_dev->dev;
+	int ret;
+
+	if (on) {
+		u8 gpoctl = 0;
+
+		ret = regulator_enable(sdp4430_cam2pwr_reg);
+		if (ret) {
+			dev_err(dev,
+				"Error in enabling sensor power regulator 'cam2pwr'\n");
+			return ret;
+		}
+
+		msleep(50);
+
+		if (twl_i2c_read_u8(TWL_MODULE_AUDIO_VOICE, &gpoctl,
+				    TWL6040_REG_GPOCTL))
+			return -ENODEV;
+		if (twl_i2c_write_u8(TWL_MODULE_AUDIO_VOICE,
+				     gpoctl | TWL6040_GPO3,
+				     TWL6040_REG_GPOCTL))
+			return -ENODEV;
+
+		msleep(10);
+
+		gpio_set_value(OMAP4430SDP_GPIO_CAM_PDN_C, 1);
+		msleep(10);
+		ret = clk_enable(sdp4430_cam2_aux_clk); /* Enable XCLK */
+		if (ret) {
+			dev_err(dev,
+				"Error in clk_enable() in %s(%d)\n",
+				__func__, on);
+			gpio_set_value(OMAP4430SDP_GPIO_CAM_PDN_C, 0);
+			return ret;
+		}
+		msleep(10);
+	} else {
+		clk_disable(sdp4430_cam2_aux_clk);
+		msleep(1);
+		gpio_set_value(OMAP4430SDP_GPIO_CAM_PDN_C, 0);
+		if (regulator_is_enabled(sdp4430_cam2pwr_reg)) {
+			ret = regulator_disable(sdp4430_cam2pwr_reg);
+			if (ret) {
+				dev_err(dev,
+					"Error in disabling sensor power regulator 'cam2pwr'\n");
+				return ret;
+			}
+		}
+	}
+
+	return 0;
+}
+
+#define OV5640_I2C_ADDRESS   (0x3C)
+
+static struct ov5640_platform_data ov5640_cam1_platform_data = {
+	.s_power = sdp4430_ov_cam1_power,
+};
+
+static struct i2c_board_info ov5640_cam1_i2c_device = {
+	I2C_BOARD_INFO("ov5640", OV5640_I2C_ADDRESS),
+	.platform_data = &ov5640_cam1_platform_data,
+};
+
+static struct ov5640_platform_data ov5640_cam2_platform_data = {
+	.s_power = sdp4430_ov_cam2_power,
+};
+
+static struct i2c_board_info ov5640_cam2_i2c_device = {
+	I2C_BOARD_INFO("ov5640", OV5640_I2C_ADDRESS),
+	.platform_data = &ov5640_cam2_platform_data,
+};
+
+#define OV5650_I2C_ADDRESS   (0x36)
+
+static struct ov5650_platform_data ov5650_cam1_platform_data = {
+	.s_power = sdp4430_ov_cam1_power,
+};
+
+static struct i2c_board_info ov5650_cam1_i2c_device = {
+	I2C_BOARD_INFO("ov5650", OV5650_I2C_ADDRESS),
+	.platform_data = &ov5650_cam1_platform_data,
+};
+
+static struct ov5650_platform_data ov5650_cam2_platform_data = {
+	.s_power = sdp4430_ov_cam2_power,
+};
+
+static struct i2c_board_info ov5650_cam2_i2c_device = {
+	I2C_BOARD_INFO("ov5650", OV5650_I2C_ADDRESS),
+	.platform_data = &ov5650_cam2_platform_data,
+};
+
+static struct iss_subdev_i2c_board_info ov5640_cam1_subdevs[] = {
+	{
+		.board_info = &ov5640_cam1_i2c_device,
+		.i2c_adapter_id = 2,
+	},
+	{ NULL, 0, },
+};
+
+static struct iss_subdev_i2c_board_info ov5650_cam1_subdevs[] = {
+	{
+		.board_info = &ov5650_cam1_i2c_device,
+		.i2c_adapter_id = 2,
+	},
+	{ NULL, 0, },
+};
+
+static struct iss_subdev_i2c_board_info ov5640_cam2_subdevs[] = {
+	{
+		.board_info = &ov5640_cam2_i2c_device,
+		.i2c_adapter_id = 3,
+	},
+	{ NULL, 0, },
+};
+
+static struct iss_subdev_i2c_board_info ov5650_cam2_subdevs[] = {
+	{
+		.board_info = &ov5650_cam2_i2c_device,
+		.i2c_adapter_id = 3,
+	},
+	{ NULL, 0, },
+};
+
+static struct iss_v4l2_subdevs_group sdp4430_camera_subdevs[] = {
+	{
+		.subdevs = ov5640_cam1_subdevs,
+		.interface = ISS_INTERFACE_CSI2B_PHY2,
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
+		.subdevs = ov5650_cam1_subdevs,
+		.interface = ISS_INTERFACE_CSI2B_PHY2,
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
+		.subdevs = ov5640_cam2_subdevs,
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
+		.subdevs = ov5650_cam2_subdevs,
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
+static void sdp4430_omap4iss_set_constraints(struct iss_device *iss, bool enable)
+{
+	if (!iss)
+		return;
+
+	/* FIXME: Look for something more precise as a good throughtput limit */
+	omap_pm_set_min_bus_tput(iss->dev, OCP_INITIATOR_AGENT,
+				 enable ? 800000 : -1);
+}
+
+static struct iss_platform_data sdp4430_iss_platform_data = {
+	.subdevs = sdp4430_camera_subdevs,
+	.set_constraints = sdp4430_omap4iss_set_constraints,
+};
+
+static struct omap_device_pad omap4iss_pads[] = {
+	/* CSI2-A */
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
+	/* CSI2-B */
+	{
+		.name   = "csi22_dx0.csi22_dx0",
+		.enable = OMAP_MUX_MODE0 | OMAP_INPUT_EN,
+	},
+	{
+		.name   = "csi22_dy0.csi22_dy0",
+		.enable = OMAP_MUX_MODE0 | OMAP_INPUT_EN,
+	},
+	{
+		.name   = "csi22_dx1.csi22_dx1",
+		.enable = OMAP_MUX_MODE0 | OMAP_INPUT_EN,
+	},
+	{
+		.name   = "csi22_dy1.csi22_dy1",
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
+static int __init sdp4430_camera_init(void)
+{
+	if (!machine_is_omap_4430sdp())
+		return 0;
+
+	sdp4430_cam2pwr_reg = regulator_get(NULL, "cam2pwr");
+	if (IS_ERR(sdp4430_cam2pwr_reg)) {
+		printk(KERN_ERR "Unable to get 'cam2pwr' regulator for sensor power\n");
+		return -ENODEV;
+	}
+	
+	if (regulator_set_voltage(sdp4430_cam2pwr_reg, 2600000, 3100000)) {
+		printk(KERN_ERR "Unable to set valid 'cam2pwr' regulator"
+			" voltage range to: 2.6V ~ 3.1V\n");
+		regulator_put(sdp4430_cam2pwr_reg);
+		return -ENODEV;
+	}
+
+	sdp4430_cam1_aux_clk = clk_get(NULL, "auxclk2_ck");
+	if (IS_ERR(sdp4430_cam1_aux_clk)) {
+		printk(KERN_ERR "Unable to get auxclk2_ck\n");
+		regulator_put(sdp4430_cam2pwr_reg);
+		return -ENODEV;
+	}
+
+	if (clk_set_rate(sdp4430_cam1_aux_clk,
+			clk_round_rate(sdp4430_cam1_aux_clk, 24000000))) {
+		clk_put(sdp4430_cam1_aux_clk);
+		regulator_put(sdp4430_cam2pwr_reg);
+		return -EINVAL;
+	}
+
+	sdp4430_cam2_aux_clk = clk_get(NULL, "auxclk3_ck");
+	if (IS_ERR(sdp4430_cam2_aux_clk)) {
+		printk(KERN_ERR "Unable to get auxclk3_ck\n");
+		clk_put(sdp4430_cam1_aux_clk);
+		regulator_put(sdp4430_cam2pwr_reg);
+		return -ENODEV;
+	}
+
+	if (clk_set_rate(sdp4430_cam2_aux_clk,
+			clk_round_rate(sdp4430_cam2_aux_clk, 24000000))) {
+		clk_put(sdp4430_cam1_aux_clk);
+		clk_put(sdp4430_cam2_aux_clk);
+		regulator_put(sdp4430_cam2pwr_reg);
+		return -EINVAL;
+	}
+
+	omap_mux_init_gpio(OMAP4430SDP_GPIO_CAM_PDN_B, OMAP_PIN_OUTPUT);
+	omap_mux_init_gpio(OMAP4430SDP_GPIO_CAM_PDN_C, OMAP_PIN_OUTPUT);
+
+	/* Init FREF_CLK2_OUT */
+	omap_mux_init_signal("fref_clk2_out", OMAP_PIN_OUTPUT);
+
+	/* Init FREF_CLK3_OUT */
+	omap_mux_init_signal("fref_clk3_out", OMAP_PIN_OUTPUT);
+
+	if (gpio_request(OMAP4430SDP_GPIO_CAM_PDN_B, "CAM_PDN_B"))
+		printk(KERN_WARNING "Cannot request GPIO %d\n",
+			OMAP4430SDP_GPIO_CAM_PDN_B);
+	else
+		gpio_direction_output(OMAP4430SDP_GPIO_CAM_PDN_B, 0);
+
+	if (gpio_request(OMAP4430SDP_GPIO_CAM_PDN_C, "CAM_PDN_C"))
+		printk(KERN_WARNING "Cannot request GPIO %d\n",
+			OMAP4430SDP_GPIO_CAM_PDN_C);
+	else
+		gpio_direction_output(OMAP4430SDP_GPIO_CAM_PDN_C, 0);
+
+	if (omap4_init_camera(&sdp4430_iss_platform_data, &omap4iss_data)) {
+		gpio_free(OMAP4430SDP_GPIO_CAM_PDN_B);
+		gpio_free(OMAP4430SDP_GPIO_CAM_PDN_C);
+		regulator_put(sdp4430_cam2pwr_reg);
+		clk_put(sdp4430_cam1_aux_clk);
+		clk_put(sdp4430_cam2_aux_clk);
+		return -ENODEV;
+	}
+
+	return 0;
+}
+late_initcall(sdp4430_camera_init);
diff --git a/arch/arm/mach-omap2/board-4430sdp.c b/arch/arm/mach-omap2/board-4430sdp.c
index 130ab00..c8f8229 100644
--- a/arch/arm/mach-omap2/board-4430sdp.c
+++ b/arch/arm/mach-omap2/board-4430sdp.c
@@ -458,6 +458,10 @@ static struct regulator_consumer_supply sdp4430_vaux_supply[] = {
 	REGULATOR_SUPPLY("vmmc", "omap_hsmmc.1"),
 };
 
+static struct regulator_consumer_supply sdp4430_vaux3_supply[] = {
+	REGULATOR_SUPPLY("cam2pwr", NULL),
+};
+
 static struct regulator_consumer_supply omap4_sdp4430_vmmc5_supply = {
 	.supply = "vmmc",
 	.dev_name = "omap_hsmmc.4",
@@ -548,6 +552,21 @@ static struct regulator_init_data sdp4430_vaux1 = {
 	.consumer_supplies      = sdp4430_vaux_supply,
 };
 
+static struct regulator_init_data sdp4430_vaux3 = {
+	.constraints = {
+		.min_uV			= 1000000,
+		.max_uV			= 3000000,
+		.apply_uV		= true,
+		.valid_modes_mask	= REGULATOR_MODE_NORMAL
+					| REGULATOR_MODE_STANDBY,
+		.valid_ops_mask	 = REGULATOR_CHANGE_VOLTAGE
+					| REGULATOR_CHANGE_MODE
+					| REGULATOR_CHANGE_STATUS,
+	},
+	.num_consumer_supplies  = ARRAY_SIZE(sdp4430_vaux3_supply),
+	.consumer_supplies      = sdp4430_vaux3_supply,
+};
+
 static struct regulator_init_data sdp4430_vusim = {
 	.constraints = {
 		.min_uV			= 1200000,
@@ -589,6 +608,7 @@ static struct twl4030_platform_data sdp4430_twldata = {
 	/* Regulators */
 	.vusim		= &sdp4430_vusim,
 	.vaux1		= &sdp4430_vaux1,
+	.vaux3		= &sdp4430_vaux3,
 };
 
 static struct i2c_board_info __initdata sdp4430_i2c_3_boardinfo[] = {
-- 
1.7.5.4

