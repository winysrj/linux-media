Return-path: <linux-media-owner@vger.kernel.org>
Received: from bear.ext.ti.com ([192.94.94.41]:38975 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755281AbZAMCEI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 12 Jan 2009 21:04:08 -0500
From: "Aguirre Rodriguez, Sergio Alberto" <saaguirre@ti.com>
To: "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"video4linux-list@redhat.com" <video4linux-list@redhat.com>,
	Sakari Ailus <sakari.ailus@nokia.com>,
	"Tuukka.O Toivonen" <tuukka.o.toivonen@nokia.com>,
	"Nagalla, Hari" <hnagalla@ti.com>
Date: Mon, 12 Jan 2009 20:03:42 -0600
Subject: [REVIEW PATCH 14/14] OMAP34XX: CAM: Add Sensors Support
Message-ID: <A24693684029E5489D1D202277BE894416429FA4@dlee02.ent.ti.com>
Content-Language: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This adds support in OMAP34xx SDP board file for
MT9P012 Sensor and DW9710 Lens driver.

Signed-off-by: Sergio Aguirre <saaguirre@ti.com>
---
 arch/arm/mach-omap2/board-3430sdp.c |  319 ++++++++++++++++++++++++++++++++++-
 1 files changed, 318 insertions(+), 1 deletions(-)

diff --git a/arch/arm/mach-omap2/board-3430sdp.c b/arch/arm/mach-omap2/board-3430sdp.c
index ade186b..8fa1d4d 100644
--- a/arch/arm/mach-omap2/board-3430sdp.c
+++ b/arch/arm/mach-omap2/board-3430sdp.c
@@ -23,6 +23,7 @@
 #include <linux/spi/spi.h>
 #include <linux/spi/ads7846.h>
 #include <linux/i2c/twl4030.h>
+#include <linux/mm.h>
 
 #include <mach/hardware.h>
 #include <asm/mach-types.h>
@@ -40,6 +41,31 @@
 #include <mach/dma.h>
 #include <mach/gpmc.h>
 
+#ifdef CONFIG_VIDEO_OMAP3
+#include <media/v4l2-int-device.h>
+#include <../drivers/media/video/omap34xxcam.h>
+#include <../drivers/media/video/isp/ispreg.h>
+#if defined(CONFIG_VIDEO_MT9P012) || defined(CONFIG_VIDEO_MT9P012_MODULE)
+/* Sensor specific GPIO signals */
+#define MT9P012_RESET_GPIO  	98
+#define MT9P012_STANDBY_GPIO	58
+
+#define MT9P012_USE_XCLKA  	0
+#define MT9P012_USE_XCLKB  	1
+
+#define VAUX_2_8_V		0x09
+#define VAUX_DEV_GRP_P1		0x20
+#define VAUX_DEV_GRP_NONE	0x00
+
+#include <media/mt9p012.h>
+static enum v4l2_power mt9p012_previous_power = V4L2_POWER_OFF;
+#endif
+#endif
+
+#ifdef CONFIG_VIDEO_DW9710
+#include <media/dw9710.h>
+#endif
+
 #include <asm/io.h>
 #include <asm/delay.h>
 #include <mach/control.h>
@@ -238,6 +264,281 @@ static struct spi_board_info sdp3430_spi_board_info[] __initdata = {
 	},
 };
 
+#ifdef CONFIG_VIDEO_OMAP3
+#define DEBUG_BASE		0x08000000
+#define REG_SDP3430_FPGA_GPIO_2 (0x50)
+#define FPGA_SPR_GPIO1_3v3	(0x1 << 14)
+#define FPGA_GPIO6_DIR_CTRL	(0x1 << 6)
+
+static void __iomem *fpga_map_addr;
+
+static void enable_fpga_vio_1v8(u8 enable)
+{
+	u16 reg_val;
+
+	fpga_map_addr = ioremap(DEBUG_BASE, 4096);
+	reg_val = readw(fpga_map_addr + REG_SDP3430_FPGA_GPIO_2);
+
+	/* Ensure that the SPR_GPIO1_3v3 is 0 - powered off.. 1 is on */
+	if (reg_val & FPGA_SPR_GPIO1_3v3) {
+		reg_val |= FPGA_SPR_GPIO1_3v3;
+		reg_val |= FPGA_GPIO6_DIR_CTRL; /* output mode */
+		writew(reg_val, fpga_map_addr + REG_SDP3430_FPGA_GPIO_2);
+		/* give a few milli sec to settle down
+		 * Let the sensor also settle down.. if required..
+		 */
+		if (enable)
+			mdelay(10);
+	}
+
+	if (enable) {
+		reg_val |= FPGA_SPR_GPIO1_3v3 | FPGA_GPIO6_DIR_CTRL;
+		writew(reg_val, fpga_map_addr + REG_SDP3430_FPGA_GPIO_2);
+	}
+	/* Vrise time for the voltage - should be less than 1 ms */
+	mdelay(1);
+}
+#endif
+
+#ifdef CONFIG_VIDEO_DW9710
+static int dw9710_lens_power_set(enum v4l2_power power)
+{
+
+	/* The power change depends on MT9P012 powerup, so if we request a
+	 * power state different from sensor, we should return error
+	 */
+	if ((mt9p012_previous_power != V4L2_POWER_OFF) &&
+					(power != mt9p012_previous_power))
+		return -EIO;
+
+	switch (power) {
+	case V4L2_POWER_OFF:
+		/* Power Down Sequence */
+#ifdef CONFIG_TWL4030_CORE
+		twl4030_i2c_write_u8(TWL4030_MODULE_PM_RECEIVER,
+				VAUX_DEV_GRP_NONE, TWL4030_VAUX2_DEV_GRP);
+#else
+#error "no power companion board defined!"
+#endif
+		enable_fpga_vio_1v8(0);
+		gpio_free(MT9P012_RESET_GPIO);
+		iounmap(fpga_map_addr);
+		gpio_free(MT9P012_STANDBY_GPIO);
+		break;
+	case V4L2_POWER_ON:
+		/* Request and configure gpio pins */
+		if (gpio_request(MT9P012_STANDBY_GPIO,
+						"mt9p012_standby_gpio")) {
+			printk(KERN_WARNING "Could not request GPIO %d"
+						" for MT9P012\n",
+						MT9P012_STANDBY_GPIO);
+			return -EIO;
+		}
+
+		/* Request and configure gpio pins */
+		if (gpio_request(MT9P012_RESET_GPIO, "mt9p012_reset_gpio"))
+			return -EIO;
+
+		/* set to output mode */
+		gpio_direction_output(MT9P012_STANDBY_GPIO, true);
+		/* set to output mode */
+		gpio_direction_output(MT9P012_RESET_GPIO, true);
+
+		/* STANDBY_GPIO is active HIGH for set LOW to release */
+		gpio_set_value(MT9P012_STANDBY_GPIO, 1);
+
+		/* nRESET is active LOW. set HIGH to release reset */
+		gpio_set_value(MT9P012_RESET_GPIO, 1);
+
+		/* turn on digital power */
+		enable_fpga_vio_1v8(1);
+#ifdef CONFIG_TWL4030_CORE
+		/* turn on analog power */
+		twl4030_i2c_write_u8(TWL4030_MODULE_PM_RECEIVER,
+				VAUX_2_8_V, TWL4030_VAUX2_DEDICATED);
+		twl4030_i2c_write_u8(TWL4030_MODULE_PM_RECEIVER,
+				VAUX_DEV_GRP_P1, TWL4030_VAUX2_DEV_GRP);
+#else
+#error "no power companion board defined!"
+#endif
+		/* out of standby */
+		gpio_set_value(MT9P012_STANDBY_GPIO, 0);
+		udelay(1000);
+
+		/* have to put sensor to reset to guarantee detection */
+		gpio_set_value(MT9P012_RESET_GPIO, 0);
+
+		udelay(1500);
+
+		/* nRESET is active LOW. set HIGH to release reset */
+		gpio_set_value(MT9P012_RESET_GPIO, 1);
+		/* give sensor sometime to get out of the reset.
+		 * Datasheet says 2400 xclks. At 6 MHz, 400 usec is
+		 * enough
+		 */
+		udelay(300);
+		break;
+	case V4L2_POWER_STANDBY:
+		break;
+	}
+	return 0;
+}
+
+static int dw9710_lens_set_prv_data(void *priv)
+{
+	struct omap34xxcam_hw_config *hwc = priv;
+
+	hwc->dev_index = 0;
+	hwc->dev_minor = 0;
+	hwc->dev_type = OMAP34XXCAM_SLAVE_LENS;
+
+	return 0;
+}
+
+static struct dw9710_platform_data sdp3430_dw9710_platform_data = {
+	.power_set      = dw9710_lens_power_set,
+	.priv_data_set  = dw9710_lens_set_prv_data,
+};
+#endif
+
+#if defined(CONFIG_VIDEO_MT9P012) || defined(CONFIG_VIDEO_MT9P012_MODULE)
+static struct omap34xxcam_sensor_config cam_hwc = {
+	.sensor_isp = 0,
+	.xclk = OMAP34XXCAM_XCLK_A,
+	.capture_mem = PAGE_ALIGN(2592 * 1944 * 2) * 4,
+};
+
+static int mt9p012_sensor_set_prv_data(void *priv)
+{
+	struct omap34xxcam_hw_config *hwc = priv;
+
+	hwc->u.sensor.xclk = cam_hwc.xclk;
+	hwc->u.sensor.sensor_isp = cam_hwc.sensor_isp;
+	hwc->u.sensor.capture_mem = cam_hwc.capture_mem;
+	hwc->dev_index = 0;
+	hwc->dev_minor = 0;
+	hwc->dev_type = OMAP34XXCAM_SLAVE_SENSOR;
+	return 0;
+}
+
+static struct isp_interface_config mt9p012_if_config = {
+	.ccdc_par_ser = ISP_PARLL,
+	.dataline_shift = 0x1,
+	.hsvs_syncdetect = ISPCTRL_SYNC_DETECT_VSRISE,
+	.vdint0_timing = 0x0,
+	.vdint1_timing = 0x0,
+	.strobe = 0x0,
+	.prestrobe = 0x0,
+	.shutter = 0x0,
+	.prev_sph = 2,
+	.prev_slv = 0,
+	.wenlog = ISPCCDC_CFG_WENLOG_OR,
+	.u.par.par_bridge = 0x0,
+	.u.par.par_clk_pol = 0x0,
+};
+
+static int mt9p012_sensor_power_set(enum v4l2_power power)
+{
+	switch (power) {
+	case V4L2_POWER_OFF:
+		/* Power Down Sequence */
+#ifdef CONFIG_TWL4030_CORE
+		twl4030_i2c_write_u8(TWL4030_MODULE_PM_RECEIVER,
+				VAUX_DEV_GRP_NONE, TWL4030_VAUX2_DEV_GRP);
+#else
+#error "no power companion board defined!"
+#endif
+		enable_fpga_vio_1v8(0);
+		gpio_free(MT9P012_RESET_GPIO);
+		iounmap(fpga_map_addr);
+		gpio_free(MT9P012_STANDBY_GPIO);
+		break;
+	case V4L2_POWER_ON:
+		if (mt9p012_previous_power == V4L2_POWER_OFF) {
+			/* Power Up Sequence */
+			isp_configure_interface(&mt9p012_if_config);
+
+			/* Request and configure gpio pins */
+			if (gpio_request(MT9P012_STANDBY_GPIO,
+						"mt9p012_standby_gpio")) {
+				printk(KERN_WARNING "Could not request GPIO %d"
+							" for MT9P012\n",
+							MT9P012_STANDBY_GPIO);
+				return -EIO;
+			}
+
+			/* Request and configure gpio pins */
+			if (gpio_request(MT9P012_RESET_GPIO,
+						"mt9p012_reset_gpio"))
+				return -EIO;
+
+			/* set to output mode */
+			gpio_direction_output(MT9P012_STANDBY_GPIO, true);
+			/* set to output mode */
+			gpio_direction_output(MT9P012_RESET_GPIO, true);
+
+			/* STANDBY_GPIO is active HIGH for set LOW to release */
+			gpio_set_value(MT9P012_STANDBY_GPIO, 1);
+
+			/* nRESET is active LOW. set HIGH to release reset */
+			gpio_set_value(MT9P012_RESET_GPIO, 1);
+
+			/* turn on digital power */
+			enable_fpga_vio_1v8(1);
+#ifdef CONFIG_TWL4030_CORE
+			/* turn on analog power */
+			twl4030_i2c_write_u8(TWL4030_MODULE_PM_RECEIVER,
+					VAUX_2_8_V, TWL4030_VAUX2_DEDICATED);
+			twl4030_i2c_write_u8(TWL4030_MODULE_PM_RECEIVER,
+					VAUX_DEV_GRP_P1, TWL4030_VAUX2_DEV_GRP);
+#else
+#error "no power companion board defined!"
+#endif
+		}
+
+		/* out of standby */
+		gpio_set_value(MT9P012_STANDBY_GPIO, 0);
+		udelay(1000);
+
+		if (mt9p012_previous_power == V4L2_POWER_OFF) {
+			/* have to put sensor to reset to guarantee detection */
+			gpio_set_value(MT9P012_RESET_GPIO, 0);
+
+			udelay(1500);
+
+			/* nRESET is active LOW. set HIGH to release reset */
+			gpio_set_value(MT9P012_RESET_GPIO, 1);
+			/* give sensor sometime to get out of the reset.
+			 * Datasheet says 2400 xclks. At 6 MHz, 400 usec is
+			 * enough
+			 */
+			udelay(300);
+		}
+		break;
+	case V4L2_POWER_STANDBY:
+		/* stand by */
+		gpio_set_value(MT9P012_STANDBY_GPIO, 1);
+		break;
+	}
+	/* Save powerstate to know what was before calling POWER_ON. */
+	mt9p012_previous_power = power;
+	return 0;
+}
+
+static u32 mt9p012_sensor_set_xclk(u32 xclkfreq)
+{
+	return isp_set_xclk(xclkfreq, MT9P012_USE_XCLKA);
+}
+
+static struct mt9p012_platform_data sdp3430_mt9p012_platform_data = {
+	.power_set      = mt9p012_sensor_power_set,
+	.priv_data_set  = mt9p012_sensor_set_prv_data,
+	.set_xclk       = mt9p012_sensor_set_xclk,
+};
+
+#endif
+
+
 static struct platform_device sdp3430_lcd_device = {
 	.name		= "sdp2430_lcd",
 	.id		= -1,
@@ -434,11 +735,27 @@ static struct i2c_board_info __initdata sdp3430_i2c_boardinfo[] = {
 	},
 };
 
+static struct i2c_board_info __initdata sdp3430_i2c_boardinfo_2[] = {
+#if defined(CONFIG_VIDEO_MT9P012) || defined(CONFIG_VIDEO_MT9P012_MODULE)
+	{
+		I2C_BOARD_INFO("mt9p012", MT9P012_I2C_ADDR),
+		.platform_data = &sdp3430_mt9p012_platform_data,
+	},
+#ifdef CONFIG_VIDEO_DW9710
+	{
+		I2C_BOARD_INFO(DW9710_NAME,  DW9710_AF_I2C_ADDR),
+		.platform_data = &sdp3430_dw9710_platform_data,
+	},
+#endif
+#endif
+};
+
 static int __init omap3430_i2c_init(void)
 {
 	omap_register_i2c_bus(1, 2600, sdp3430_i2c_boardinfo,
 			ARRAY_SIZE(sdp3430_i2c_boardinfo));
-	omap_register_i2c_bus(2, 400, NULL, 0);
+	omap_register_i2c_bus(2, 400, sdp3430_i2c_boardinfo_2,
+			ARRAY_SIZE(sdp3430_i2c_boardinfo_2));
 	omap_register_i2c_bus(3, 400, NULL, 0);
 	return 0;
 }
-- 
1.5.6.5

