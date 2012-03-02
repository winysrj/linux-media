Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.128.26]:60768 "EHLO mgw-da02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932115Ab2CBRc6 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 2 Mar 2012 12:32:58 -0500
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, dacohen@gmail.com,
	snjw23@gmail.com, andriy.shevchenko@linux.intel.com,
	t.stanislaws@samsung.com, tuukkat76@gmail.com,
	k.debski@samsung.com, riverful@gmail.com, hverkuil@xs4all.nl,
	teturtia@gmail.com
Subject: [PATCH v4 34/34] rm680: Add camera init
Date: Fri,  2 Mar 2012 19:30:42 +0200
Message-Id: <1330709442-16654-34-git-send-email-sakari.ailus@iki.fi>
In-Reply-To: <20120302173219.GA15695@valkosipuli.localdomain>
References: <20120302173219.GA15695@valkosipuli.localdomain>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>

This currently introduces an extra file to the arch/arm/mach-omap2
directory: board-rm680-camera.c. Keeping the device tree in mind, the
context of the file could be represented as static data with one exception:
the external clock to the sensor.

This external clock is provided by the OMAP 3 SoC and required by the
sensor. The issue is that the clock originates from the ISP and not from
PRCM block as the other clocks and thus is not supported by the clock
framework. Otherwise the sensor driver could just clk_get() and clk_enable()
it, just like the regulators and gpios.

Signed-off-by: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
---
 arch/arm/mach-omap2/Makefile             |    3 +-
 arch/arm/mach-omap2/board-rm680-camera.c |  375 ++++++++++++++++++++++++++++++
 arch/arm/mach-omap2/board-rm680.c        |   38 +++
 3 files changed, 415 insertions(+), 1 deletions(-)
 create mode 100644 arch/arm/mach-omap2/board-rm680-camera.c

diff --git a/arch/arm/mach-omap2/Makefile b/arch/arm/mach-omap2/Makefile
index fc9b238..f92cc92 100644
--- a/arch/arm/mach-omap2/Makefile
+++ b/arch/arm/mach-omap2/Makefile
@@ -206,7 +206,8 @@ obj-$(CONFIG_MACH_OMAP3_PANDORA)	+= board-omap3pandora.o
 obj-$(CONFIG_MACH_OMAP_3430SDP)		+= board-3430sdp.o
 obj-$(CONFIG_MACH_NOKIA_N8X0)		+= board-n8x0.o
 obj-$(CONFIG_MACH_NOKIA_RM680)		+= board-rm680.o \
-					   sdram-nokia.o
+					   sdram-nokia.o \
+					   board-rm680-camera.o
 obj-$(CONFIG_MACH_NOKIA_RX51)		+= board-rx51.o \
 					   sdram-nokia.o \
 					   board-rx51-peripherals.o \
diff --git a/arch/arm/mach-omap2/board-rm680-camera.c b/arch/arm/mach-omap2/board-rm680-camera.c
new file mode 100644
index 0000000..4306118
--- /dev/null
+++ b/arch/arm/mach-omap2/board-rm680-camera.c
@@ -0,0 +1,375 @@
+/**
+ * arch/arm/mach-omap2/board-rm680-camera.c
+ *
+ * Copyright (C) 2010--2012 Nokia Corporation
+ * Contact: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
+ *
+ * Based on board-rx71-camera.c by Vimarsh Zutshi
+ * Based on board-rx51-camera.c by Sakari Ailus
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
+ * 02110-1301 USA
+ *
+ */
+
+#include <linux/delay.h>
+#include <linux/gpio.h>
+#include <linux/i2c.h>
+#include <linux/mm.h>
+#include <linux/platform_device.h>
+#include <linux/videodev2.h>
+
+#include <asm/mach-types.h>
+#include <plat/omap-pm.h>
+
+#include <media/omap3isp.h>
+#include <media/smiapp.h>
+
+#include "../../../drivers/media/video/omap3isp/isp.h"
+#include "devices.h"
+
+#define SEC_CAMERA_RESET_GPIO	97
+
+#define RM680_PRI_SENSOR	1
+#define RM680_PRI_LENS		2
+#define RM680_SEC_SENSOR	3
+#define MAIN_CAMERA_XCLK	ISP_XCLK_A
+#define SEC_CAMERA_XCLK		ISP_XCLK_B
+
+/*
+ *
+ * Main Camera Module EXTCLK
+ * Used by the sensor and the actuator driver.
+ *
+ */
+static struct camera_xclk {
+	u32 hz;
+	u32 lock;
+	u8 xclksel;
+} cameras_xclk;
+
+static DEFINE_MUTEX(lock_xclk);
+
+static int rm680_update_xclk(struct v4l2_subdev *subdev, u32 hz, u32 which,
+			     u8 xclksel)
+{
+	struct isp_device *isp = v4l2_dev_to_isp_device(subdev->v4l2_dev);
+	int ret;
+
+	mutex_lock(&lock_xclk);
+
+	if (which == RM680_SEC_SENSOR) {
+		if (cameras_xclk.xclksel == MAIN_CAMERA_XCLK) {
+			ret = -EBUSY;
+			goto done;
+		}
+	} else {
+		if (cameras_xclk.xclksel == SEC_CAMERA_XCLK) {
+			ret = -EBUSY;
+			goto done;
+		}
+	}
+
+	if (hz) {	/* Turn on */
+		cameras_xclk.lock |= which;
+		if (cameras_xclk.hz == 0) {
+			isp->platform_cb.set_xclk(isp, hz, xclksel);
+			cameras_xclk.hz = hz;
+			cameras_xclk.xclksel = xclksel;
+		}
+	} else {	/* Turn off */
+		cameras_xclk.lock &= ~which;
+		if (cameras_xclk.lock == 0) {
+			isp->platform_cb.set_xclk(isp, 0, xclksel);
+			cameras_xclk.hz = 0;
+			cameras_xclk.xclksel = 0;
+		}
+	}
+
+	ret = cameras_xclk.hz;
+
+done:
+	mutex_unlock(&lock_xclk);
+	return ret;
+}
+
+/*
+ *
+ * Main Camera Sensor
+ *
+ */
+
+static int rm680_main_camera_set_xclk(struct v4l2_subdev *sd, int hz)
+{
+	return rm680_update_xclk(sd, hz, RM680_PRI_SENSOR, MAIN_CAMERA_XCLK);
+}
+
+static struct smiapp_flash_strobe_parms rm680_main_camera_strobe_setup = {
+	.mode			= 0x0c,
+	.strobe_width_high_us	= 100000,
+	.strobe_delay		= 0,
+	.stobe_start_point	= 0,
+	.trigger		= 0,
+};
+
+static struct smiapp_platform_data rm696_main_camera_platform_data = {
+	.i2c_addr_dfl		= SMIAPP_DFL_I2C_ADDR,
+	.i2c_addr_alt		= SMIAPP_ALT_I2C_ADDR,
+	.nvm_size		= 16 * 64,
+	.ext_clk		= 9.6 * 1000 * 1000,
+	.lanes			= 2,
+	/* bit rate / ddr / lanes */
+	.op_sys_clock		= (s64 []){ 796800000 / 2 / 2,
+					    840000000 / 2 / 2,
+					    1996800000 / 2 / 2, 0 },
+	.csi_signalling_mode	= SMIAPP_CSI_SIGNALLING_MODE_CSI2,
+	.strobe_setup		= &rm680_main_camera_strobe_setup,
+	.set_xclk		= rm680_main_camera_set_xclk,
+	.xshutdown		= SMIAPP_NO_XSHUTDOWN,
+};
+
+static struct smiapp_platform_data rm680_main_camera_platform_data = {
+	.i2c_addr_dfl		= SMIAPP_DFL_I2C_ADDR,
+	.i2c_addr_alt		= SMIAPP_ALT_I2C_ADDR,
+	.nvm_size		= 16 * 64,
+	.ext_clk		= 9.6 * 1000 * 1000,
+	.lanes			= 2,
+	.op_sys_clock		= (s64 []){ 840000000 / 2 / 2,
+					    1334400000 / 2 / 2,
+					    1593600000 / 2 / 2, 0 },
+	.csi_signalling_mode	= SMIAPP_CSI_SIGNALLING_MODE_CSI2,
+	.module_board_orient	= SMIAPP_MODULE_BOARD_ORIENT_180,
+	.strobe_setup		= &rm680_main_camera_strobe_setup,
+	.set_xclk		= rm680_main_camera_set_xclk,
+	.xshutdown		= SMIAPP_NO_XSHUTDOWN,
+};
+
+/*
+ *
+ * SECONDARY CAMERA Sensor
+ *
+ */
+
+#define SEC_CAMERA_XCLK		ISP_XCLK_B
+
+static int rm680_sec_camera_set_xclk(struct v4l2_subdev *sd, int hz)
+{
+	return rm680_update_xclk(sd, hz, RM680_SEC_SENSOR, SEC_CAMERA_XCLK);
+}
+
+static struct smiapp_platform_data rm696_sec_camera_platform_data = {
+	.ext_clk		= 10.8 * 1000 * 1000,
+	.lanes			= 1,
+	/* bit rate / ddr */
+	.op_sys_clock		= (s64 []){ 13770000 * 10 / 2, 0 },
+	.csi_signalling_mode	= SMIAPP_CSI_SIGNALLING_MODE_CCP2_DATA_CLOCK,
+	.module_board_orient	= SMIAPP_MODULE_BOARD_ORIENT_180,
+	.set_xclk		= rm680_sec_camera_set_xclk,
+	.xshutdown		= SEC_CAMERA_RESET_GPIO,
+};
+
+static struct smiapp_platform_data rm680_sec_camera_platform_data = {
+	.ext_clk		= 10.8 * 1000 * 1000,
+	.lanes			= 1,
+	/* bit rate / ddr */
+	.op_sys_clock		= (s64 []){ 11880000 * 10 / 2, 0 },
+	.csi_signalling_mode	= SMIAPP_CSI_SIGNALLING_MODE_CCP2_DATA_CLOCK,
+	.set_xclk		= rm680_sec_camera_set_xclk,
+	.xshutdown		= SEC_CAMERA_RESET_GPIO,
+};
+
+/*
+ *
+ * Init all the modules
+ *
+ */
+
+#define CAMERA_I2C_BUS_NUM		2
+#define AD5836_I2C_BUS_NUM		2
+#define AS3645A_I2C_BUS_NUM		2
+
+static struct i2c_board_info rm696_camera_i2c_devices[] = {
+	{
+		I2C_BOARD_INFO(SMIAPP_NAME, SMIAPP_ALT_I2C_ADDR),
+		.platform_data = &rm696_main_camera_platform_data,
+	},
+	{
+		I2C_BOARD_INFO(SMIAPP_NAME, SMIAPP_DFL_I2C_ADDR),
+		.platform_data = &rm696_sec_camera_platform_data,
+	},
+};
+
+static struct i2c_board_info rm680_camera_i2c_devices[] = {
+	{
+		I2C_BOARD_INFO(SMIAPP_NAME, SMIAPP_ALT_I2C_ADDR),
+		.platform_data = &rm680_main_camera_platform_data,
+	},
+	{
+		I2C_BOARD_INFO(SMIAPP_NAME, SMIAPP_DFL_I2C_ADDR),
+		.platform_data = &rm680_sec_camera_platform_data,
+	},
+};
+
+static struct isp_subdev_i2c_board_info rm696_camera_primary_subdevs[] = {
+	{
+		.board_info = &rm696_camera_i2c_devices[0],
+		.i2c_adapter_id = CAMERA_I2C_BUS_NUM,
+	},
+	{ NULL, 0, },
+};
+
+static struct isp_subdev_i2c_board_info rm696_camera_secondary_subdevs[] = {
+	{
+		.board_info = &rm696_camera_i2c_devices[1],
+		.i2c_adapter_id = CAMERA_I2C_BUS_NUM,
+	},
+	{ NULL, 0, },
+};
+
+static struct isp_subdev_i2c_board_info rm680_camera_primary_subdevs[] = {
+	{
+		.board_info = &rm680_camera_i2c_devices[0],
+		.i2c_adapter_id = CAMERA_I2C_BUS_NUM,
+	},
+	{ NULL, 0, },
+};
+
+static struct isp_subdev_i2c_board_info rm680_camera_secondary_subdevs[] = {
+	{
+		.board_info = &rm680_camera_i2c_devices[1],
+		.i2c_adapter_id = CAMERA_I2C_BUS_NUM,
+	},
+	{ NULL, 0, },
+};
+
+static struct isp_v4l2_subdevs_group rm696_camera_subdevs[] = {
+	{
+		.subdevs = rm696_camera_primary_subdevs,
+		.interface = ISP_INTERFACE_CSI2A_PHY2,
+		.bus = { .csi2 = {
+			.crc		= 1,
+			.vpclk_div	= 1,
+			.lanecfg	= {
+				.clk = {
+					.pol = 1,
+					.pos = 2,
+				},
+				.data[0] = {
+					.pol = 1,
+					.pos = 1,
+				},
+				.data[1] = {
+					.pol = 1,
+					.pos = 3,
+				},
+			},
+		} },
+	},
+	{
+		.subdevs = rm696_camera_secondary_subdevs,
+		.interface = ISP_INTERFACE_CCP2B_PHY1,
+		.bus = { .ccp2 = {
+			.strobe_clk_pol	= 0,
+			.crc		= 0,
+			.ccp2_mode	= 0,
+			.phy_layer	= 0,
+			.vpclk_div	= 2,
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
+	{ NULL, 0, },
+};
+
+static struct isp_v4l2_subdevs_group rm680_camera_subdevs[] = {
+	{
+		.subdevs = rm680_camera_primary_subdevs,
+		.interface = ISP_INTERFACE_CSI2A_PHY2,
+		.bus = { .csi2 = {
+			.crc		= 1,
+			.vpclk_div	= 1,
+			.lanecfg	= {
+				.clk = {
+					.pol = 1,
+					.pos = 2,
+				},
+				.data[0] = {
+					.pol = 1,
+					.pos = 3,
+				},
+				.data[1] = {
+					.pol = 1,
+					.pos = 1,
+				},
+			},
+		} },
+	},
+	{
+		.subdevs = rm680_camera_secondary_subdevs,
+		.interface = ISP_INTERFACE_CCP2B_PHY1,
+		.bus = { .ccp2 = {
+			.strobe_clk_pol	= 0,
+			.crc		= 0,
+			.ccp2_mode	= 0,
+			.phy_layer	= 0,
+			.vpclk_div	= 2,
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
+	{ NULL, 0, },
+};
+
+static struct isp_platform_data rm696_isp_platform_data = {
+	.subdevs = rm696_camera_subdevs,
+};
+
+static struct isp_platform_data rm680_isp_platform_data = {
+	.subdevs = rm680_camera_subdevs,
+};
+
+static inline int board_is_rm680(void)
+{
+	return (system_rev & 0x00f0) == 0x0020;
+}
+
+void __init rm680_camera_init(void)
+{
+	struct isp_platform_data *pdata;
+
+	if (board_is_rm680())
+		pdata = &rm680_isp_platform_data;
+	else
+		pdata = &rm696_isp_platform_data;
+
+	if (omap3_init_camera(pdata) < 0)
+		pr_warn("%s: unable to register camera platform device\n",
+			__func__);
+}
diff --git a/arch/arm/mach-omap2/board-rm680.c b/arch/arm/mach-omap2/board-rm680.c
index 8678b38..71607a70 100644
--- a/arch/arm/mach-omap2/board-rm680.c
+++ b/arch/arm/mach-omap2/board-rm680.c
@@ -66,6 +66,39 @@ static struct platform_device rm680_vemmc_device = {
 	},
 };
 
+#define REGULATOR_INIT_DATA(_name, _min, _max, _apply, _ops_mask) \
+	static struct regulator_init_data _name##_data = { \
+		.constraints = { \
+			.name                   = #_name, \
+			.min_uV                 = _min, \
+			.max_uV                 = _max, \
+			.apply_uV               = _apply, \
+			.valid_modes_mask       = REGULATOR_MODE_NORMAL | \
+						REGULATOR_MODE_STANDBY, \
+			.valid_ops_mask         = _ops_mask, \
+		}, \
+		.num_consumer_supplies  = ARRAY_SIZE(_name##_consumers), \
+		.consumer_supplies      = _name##_consumers, \
+}
+#define REGULATOR_INIT_DATA_FIXED(_name, _voltage) \
+	REGULATOR_INIT_DATA(_name, _voltage, _voltage, true, \
+				REGULATOR_CHANGE_STATUS | REGULATOR_CHANGE_MODE)
+
+static struct regulator_consumer_supply rm680_vaux2_consumers[] = {
+	REGULATOR_SUPPLY("VDD_CSIPHY1", "omap3isp"),	/* OMAP ISP */
+	REGULATOR_SUPPLY("VDD_CSIPHY2", "omap3isp"),	/* OMAP ISP */
+	REGULATOR_SUPPLY("vaux2", NULL),
+};
+REGULATOR_INIT_DATA_FIXED(rm680_vaux2, 1800000);
+
+static struct regulator_consumer_supply rm680_vaux3_consumers[] = {
+	REGULATOR_SUPPLY("VANA", "2-0037"),	/* Main Camera Sensor */
+	REGULATOR_SUPPLY("VANA", "2-000e"),	/* Main Camera Lens */
+	REGULATOR_SUPPLY("VANA", "2-0010"),	/* Front Camera */
+	REGULATOR_SUPPLY("vaux3", NULL),
+};
+REGULATOR_INIT_DATA_FIXED(rm680_vaux3, 2800000);
+
 static struct platform_device *rm680_peripherals_devices[] __initdata = {
 	&rm680_vemmc_device,
 };
@@ -82,6 +115,8 @@ static struct twl4030_gpio_platform_data rm680_gpio_data = {
 static struct twl4030_platform_data rm680_twl_data = {
 	.gpio			= &rm680_gpio_data,
 	/* add rest of the children here */
+	.vaux2			= &rm680_vaux2_data,
+	.vaux3			= &rm680_vaux3_data,
 };
 
 static void __init rm680_i2c_init(void)
@@ -129,6 +164,8 @@ static struct omap_board_mux board_mux[] __initdata = {
 };
 #endif
 
+void rm680_camera_init(void);
+
 static void __init rm680_init(void)
 {
 	struct omap_sdrc_params *sdrc_params;
@@ -141,6 +178,7 @@ static void __init rm680_init(void)
 
 	usb_musb_init(NULL);
 	rm680_peripherals_init();
+	rm680_camera_init();
 }
 
 MACHINE_START(NOKIA_RM680, "Nokia RM-680 board")
-- 
1.7.2.5

