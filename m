Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (mx1.redhat.com [172.16.48.31])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n0U0sJ5U032332
	for <video4linux-list@redhat.com>; Thu, 29 Jan 2009 19:54:19 -0500
Received: from arroyo.ext.ti.com (arroyo.ext.ti.com [192.94.94.40])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id n0U0s27x028159
	for <video4linux-list@redhat.com>; Thu, 29 Jan 2009 19:54:02 -0500
From: Dominic Curran <dcurran@ti.com>
To: "linux-omap" <linux-omap@vger.kernel.org>, video4linux-list@redhat.com
Date: Thu, 29 Jan 2009 18:53:55 -0600
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901291853.55996.dcurran@ti.com>
Cc: greg.hofer@hp.com
Subject: [OMAPZOOM][PATCH 6/6] Add support for Sony imx046 to OMAP zoom2
	board.
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

From: Dominic Curran <dcurran@ti.com>
Subject: [OMAPZOOM][PATCH 6/6] Add support for Sony imx046 to OMAP zoom2 board.

Support for the Sony IMX046 sensor on the OMAP Zoom2 board.

Signed-off-by: Dominic Curran <dcurran@ti.com>
---
 arch/arm/configs/omap_zoom2_defconfig |    1 
 arch/arm/mach-omap2/board-zoom2.c     |  206 +++++++++++++++++++++++++++++++++-
 2 files changed, 205 insertions(+), 2 deletions(-)

Index: omapzoom04/arch/arm/configs/omap_zoom2_defconfig
===================================================================
--- omapzoom04.orig/arch/arm/configs/omap_zoom2_defconfig
+++ omapzoom04/arch/arm/configs/omap_zoom2_defconfig
@@ -994,6 +994,7 @@ CONFIG_VIDEO_CAPTURE_DRIVERS=y
 # CONFIG_VIDEO_MT9P012 is not set
 # CONFIG_VIDEO_DW9710 is not set
 # CONFIG_VIDEO_OV3640 is not set
+CONFIG_VIDEO_IMX046=y
 # CONFIG_VIDEO_SAA711X is not set
 # CONFIG_VIDEO_SAA717X is not set
 # CONFIG_VIDEO_TVP5150 is not set
Index: omapzoom04/arch/arm/mach-omap2/board-zoom2.c
===================================================================
--- omapzoom04.orig/arch/arm/mach-omap2/board-zoom2.c
+++ omapzoom04/arch/arm/mach-omap2/board-zoom2.c
@@ -23,6 +23,7 @@
 #include <linux/synaptics_i2c_rmi.h>
 #include <linux/spi/spi.h>
 #include <linux/i2c/twl4030.h>
+#include <linux/mm.h>
 
 #include <mach/hardware.h>
 #include <asm/mach-types.h>
@@ -50,6 +51,30 @@
 #include <mach/prcm_34xx.h>
 #endif
 
+#ifdef CONFIG_VIDEO_OMAP3
+#include <media/v4l2-int-device.h>
+#include <../drivers/media/video/omap34xxcam.h>
+#include <../drivers/media/video/isp/ispreg.h>
+#if defined(CONFIG_VIDEO_IMX046) || defined(CONFIG_VIDEO_IMX046_MODULE)
+#include <../drivers/media/video/imx046.h>
+#include <../drivers/media/video/isp/ispcsi2.h>
+#define IMX046_CSI2_CLOCK_POLARITY	0	/* +/- pin order */
+#define IMX046_CSI2_DATA0_POLARITY	0	/* +/- pin order */
+#define IMX046_CSI2_DATA1_POLARITY	0	/* +/- pin order */
+#define IMX046_CSI2_CLOCK_LANE		1	 /* Clock lane position: 1 */
+#define IMX046_CSI2_DATA0_LANE		2	 /* Data0 lane position: 2 */
+#define IMX046_CSI2_DATA1_LANE		3	 /* Data1 lane position: 3 */
+#define IMX046_CSI2_PHY_THS_TERM	2
+#define IMX046_CSI2_PHY_THS_SETTLE	23
+#define IMX046_CSI2_PHY_TCLK_TERM	0
+#define IMX046_CSI2_PHY_TCLK_MISS	1
+#define IMX046_CSI2_PHY_TCLK_SETTLE	14
+#ifndef CONFIG_TWL4030_CORE
+#error "no power companion board defined!"
+#endif
+#endif
+#endif
+
 #ifdef CONFIG_TOUCHSCREEN_SYNAPTICS
 #define OMAP_SYNAPTICS_GPIO		163
 #endif
@@ -301,6 +326,175 @@ static struct twl4030_keypad_data ldp_kp
 	.irq		= TWL4030_MODIRQ_KEYPAD,
 };
 
+#if defined(CONFIG_VIDEO_IMX046) || defined(CONFIG_VIDEO_IMX046_MODULE)
+
+static struct omap34xxcam_sensor_config imx046_hwc = {
+	.sensor_isp = 0,
+	.xclk = OMAP34XXCAM_XCLK_B,
+	.capture_mem = PAGE_ALIGN(3280 * 2464 * 2) * 2,
+};
+
+static int imx046_sensor_set_prv_data(void *priv)
+{
+	struct omap34xxcam_hw_config *hwc = priv;
+
+	hwc->u.sensor.xclk = imx046_hwc.xclk;
+	hwc->u.sensor.sensor_isp = imx046_hwc.sensor_isp;
+	hwc->dev_index = 2;
+	hwc->dev_minor = 5;
+	hwc->dev_type = OMAP34XXCAM_SLAVE_SENSOR;
+	hwc->interface_type = ISP_CSIA;
+
+	hwc->csi2.hw_csi2.lanes.clock.polarity = IMX046_CSI2_CLOCK_POLARITY;
+	hwc->csi2.hw_csi2.lanes.clock.position = IMX046_CSI2_CLOCK_LANE;
+	hwc->csi2.hw_csi2.lanes.data[0].polarity = IMX046_CSI2_DATA0_POLARITY;
+	hwc->csi2.hw_csi2.lanes.data[0].position = IMX046_CSI2_DATA0_LANE;
+	hwc->csi2.hw_csi2.lanes.data[1].polarity = IMX046_CSI2_DATA1_POLARITY;
+	hwc->csi2.hw_csi2.lanes.data[1].position = IMX046_CSI2_DATA1_LANE;
+	hwc->csi2.hw_csi2.phy.ths_term = IMX046_CSI2_PHY_THS_TERM;
+	hwc->csi2.hw_csi2.phy.ths_settle = IMX046_CSI2_PHY_THS_SETTLE;
+	hwc->csi2.hw_csi2.phy.tclk_term = IMX046_CSI2_PHY_TCLK_TERM;
+	hwc->csi2.hw_csi2.phy.tclk_miss = IMX046_CSI2_PHY_TCLK_MISS;
+	hwc->csi2.hw_csi2.phy.tclk_settle = IMX046_CSI2_PHY_TCLK_SETTLE;
+	return 0;
+}
+
+static struct isp_interface_config imx046_if_config = {
+	.ccdc_par_ser = ISP_CSIA,
+	.dataline_shift = 0x0,
+	.hsvs_syncdetect = ISPCTRL_SYNC_DETECT_VSRISE,
+	.vdint0_timing = 0x0,
+	.vdint1_timing = 0x0,
+	.strobe = 0x0,
+	.prestrobe = 0x0,
+	.shutter = 0x0,
+	.prev_sph = 2,
+	.prev_slv = 0,
+	.wenlog = ISPCCDC_CFG_WENLOG_OR,
+	.dcsub = IMX046_BLACK_LEVEL_AVG,
+	.u.csi.crc = 0x0,
+	.u.csi.mode = 0x0,
+	.u.csi.edge = 0x0,
+	.u.csi.signalling = 0x0,
+	.u.csi.strobe_clock_inv = 0x0,
+	.u.csi.vs_edge = 0x0,
+	.u.csi.channel = 0x0,
+	.u.csi.vpclk = 0x2,
+	.u.csi.data_start = 0x0,
+	.u.csi.data_size = 0x0,
+	.u.csi.format = V4L2_PIX_FMT_SGRBG10,
+};
+
+
+static int imx046_sensor_power_set(enum v4l2_power power)
+{
+	struct isp_csi2_lanes_cfg lanecfg;
+	struct isp_csi2_phy_cfg phyconfig;
+	static enum v4l2_power previous_power = V4L2_POWER_OFF;
+	int err = 0;
+
+	switch (power) {
+	case V4L2_POWER_ON:
+		/* Power Up Sequence */
+		printk(KERN_DEBUG "imx046_sensor_power_set(ON)\n");
+		if (previous_power == V4L2_POWER_OFF)
+			isp_csi2_reset();
+
+		lanecfg.clk.pol = IMX046_CSI2_CLOCK_POLARITY;
+		lanecfg.clk.pos = IMX046_CSI2_CLOCK_LANE;
+		lanecfg.data[0].pol = IMX046_CSI2_DATA0_POLARITY;
+		lanecfg.data[0].pos = IMX046_CSI2_DATA0_LANE;
+		lanecfg.data[1].pol = IMX046_CSI2_DATA1_POLARITY;
+		lanecfg.data[1].pos = IMX046_CSI2_DATA1_LANE;
+		lanecfg.data[2].pol = 0;
+		lanecfg.data[2].pos = 0;
+		lanecfg.data[3].pol = 0;
+		lanecfg.data[3].pos = 0;
+		isp_csi2_complexio_lanes_config(&lanecfg);
+		isp_csi2_complexio_lanes_update(true);
+
+		isp_csi2_ctrl_config_ecc_enable(true);
+
+		phyconfig.ths_term = IMX046_CSI2_PHY_THS_TERM;
+		phyconfig.ths_settle = IMX046_CSI2_PHY_THS_SETTLE;
+		phyconfig.tclk_term = IMX046_CSI2_PHY_TCLK_TERM;
+		phyconfig.tclk_miss = IMX046_CSI2_PHY_TCLK_MISS;
+		phyconfig.tclk_settle = IMX046_CSI2_PHY_TCLK_SETTLE;
+		isp_csi2_phy_config(&phyconfig);
+		isp_csi2_phy_update(true);
+
+		isp_configure_interface(&imx046_if_config);
+
+		if (previous_power == V4L2_POWER_OFF) {
+			/* Request and configure gpio pins */
+			if (omap_request_gpio(IMX046_RESET_GPIO) != 0)
+				return -EIO;
+
+			/* nRESET is active LOW. set HIGH to release reset */
+			omap_set_gpio_dataout(IMX046_RESET_GPIO, 1);
+
+			/* set to output mode */
+			omap_set_gpio_direction(IMX046_RESET_GPIO,
+				GPIO_DIR_OUTPUT);
+
+			/* turn on analog power */
+			twl4030_i2c_write_u8(TWL4030_MODULE_PM_RECEIVER,
+					VAUX_2_8_V, TWL4030_VAUX2_DEDICATED);
+			twl4030_i2c_write_u8(TWL4030_MODULE_PM_RECEIVER,
+					VAUX_DEV_GRP_P1, TWL4030_VAUX2_DEV_GRP);
+
+			twl4030_i2c_write_u8(TWL4030_MODULE_PM_RECEIVER,
+					VAUX_1_8_V, TWL4030_VAUX4_DEDICATED);
+			twl4030_i2c_write_u8(TWL4030_MODULE_PM_RECEIVER,
+					VAUX_DEV_GRP_P1, TWL4030_VAUX4_DEV_GRP);
+			udelay(100);
+
+			/* have to put sensor to reset to guarantee detection */
+			omap_set_gpio_dataout(IMX046_RESET_GPIO, 0);
+			udelay(1500);
+
+			/* nRESET is active LOW. set HIGH to release reset */
+			omap_set_gpio_dataout(IMX046_RESET_GPIO, 1);
+			udelay(300);
+		}
+		break;
+	case V4L2_POWER_OFF:
+		printk(KERN_DEBUG "imx046_sensor_power_set(OFF)\n");
+		/* Power Down Sequence */
+		isp_csi2_complexio_power(ISP_CSI2_POWER_OFF);
+
+		twl4030_i2c_write_u8(TWL4030_MODULE_PM_RECEIVER,
+				VAUX_DEV_GRP_NONE, TWL4030_VAUX4_DEV_GRP);
+		twl4030_i2c_write_u8(TWL4030_MODULE_PM_RECEIVER,
+				VAUX_DEV_GRP_NONE, TWL4030_VAUX2_DEV_GRP);
+		omap_free_gpio(IMX046_RESET_GPIO);
+		break;
+	case V4L2_POWER_STANDBY:
+		printk(KERN_DEBUG "imx046_sensor_power_set(STANDBY)\n");
+		/*TODO*/
+		break;
+	}
+
+	/* Save powerstate to know what was before calling POWER_ON. */
+	previous_power = power;
+	return err;
+}
+
+static struct imx046_platform_data zoom2_imx046_platform_data = {
+	.power_set            = imx046_sensor_power_set,
+	.priv_data_set        = imx046_sensor_set_prv_data,
+	.default_regs         = NULL,
+	.set_xclk             = isp_set_xclk,
+	.cfg_interface_bridge = isp_configure_interface_bridge,
+	.csi2_lane_count      = isp_csi2_complexio_lanes_count,
+	.csi2_cfg_vp_out_ctrl = isp_csi2_ctrl_config_vp_out_ctrl,
+	.csi2_ctrl_update     = isp_csi2_ctrl_update,
+	.csi2_cfg_virtual_id  = isp_csi2_ctx_config_virtual_id,
+	.csi2_ctx_update      = isp_csi2_ctx_update,
+	.csi2_calc_phy_cfg0   = isp_csi2_calc_phy_cfg0,
+};
+#endif
+
 static int __init msecure_init(void)
 {
 	int ret = 0;
@@ -506,15 +700,23 @@ static struct synaptics_i2c_rmi_platform
 	.version	= 0,
 	.power		= &synaptics_power,
 };
+#endif
 
 static struct i2c_board_info __initdata zoom2_i2c_bus2_info[] = {
+#ifdef CONFIG_TOUCHSCREEN_SYNAPTICS
 	{
 		I2C_BOARD_INFO(SYNAPTICS_I2C_RMI_NAME,  SYNAPTICS_I2C_ADDR),
 		.platform_data = &ldp3430_synaptics_platform_data,
 		.irq = 0,
 	},
-};
 #endif
+#if defined(CONFIG_VIDEO_IMX046) || defined(CONFIG_VIDEO_IMX046_MODULE)
+	{
+		I2C_BOARD_INFO("imx046", IMX046_I2C_ADDR),
+		.platform_data = &zoom2_imx046_platform_data,
+	},
+#endif
+};
 
 static int __init omap_i2c_init(void)
 {
@@ -522,9 +724,9 @@ static int __init omap_i2c_init(void)
 			ARRAY_SIZE(zoom2_i2c_bus1_info));
 #ifdef CONFIG_TOUCHSCREEN_SYNAPTICS
 	zoom2_i2c_bus2_info[0].irq = OMAP_GPIO_IRQ(OMAP_SYNAPTICS_GPIO);
+#endif
 	omap_register_i2c_bus(2, 100, zoom2_i2c_bus2_info,
 			ARRAY_SIZE(zoom2_i2c_bus2_info));
-#endif
 	omap_register_i2c_bus(3, 400, NULL, 0);
 	return 0;
 }

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
