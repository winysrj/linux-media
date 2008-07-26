Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m6Q2kNq6030987
	for <video4linux-list@redhat.com>; Fri, 25 Jul 2008 22:46:23 -0400
Received: from arroyo.ext.ti.com (arroyo.ext.ti.com [192.94.94.40])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m6Q2kBP1030386
	for <video4linux-list@redhat.com>; Fri, 25 Jul 2008 22:46:11 -0400
Received: from dlep36.itg.ti.com ([157.170.170.91])
	by arroyo.ext.ti.com (8.13.7/8.13.7) with ESMTP id m6Q2k1IO010247
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <video4linux-list@redhat.com>; Fri, 25 Jul 2008 21:46:06 -0500
Received: from legion.dal.design.ti.com (localhost [127.0.0.1])
	by dlep36.itg.ti.com (8.13.8/8.13.8) with ESMTP id m6Q2k0eT024799
	for <video4linux-list@redhat.com>; Fri, 25 Jul 2008 21:46:01 -0500 (CDT)
Received: from dirac.dal.design.ti.com (dirac.dal.design.ti.com
	[128.247.25.123])
	by legion.dal.design.ti.com (8.11.7p1+Sun/8.11.7) with ESMTP id
	m6Q2k0G29363
	for <video4linux-list@redhat.com>; Fri, 25 Jul 2008 21:46:00 -0500 (CDT)
Received: from dirac.dal.design.ti.com (localhost.localdomain [127.0.0.1])
	by dirac.dal.design.ti.com (8.12.11/8.12.11) with ESMTP id
	m6Q2k08q009594
	for <video4linux-list@redhat.com>; Fri, 25 Jul 2008 21:46:00 -0500
Received: (from a0270762@localhost)
	by dirac.dal.design.ti.com (8.12.11/8.12.11/Submit) id m6Q2k0Ht009592
	for video4linux-list@redhat.com; Fri, 25 Jul 2008 21:46:00 -0500
Date: Fri, 25 Jul 2008 21:46:00 -0500
From: Mohit Jalori <mjalori@ti.com>
To: video4linux-list@redhat.com
Message-ID: <20080726024600.GA9587@dirac.dal.design.ti.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Subject: [Patch 2/4] sensor driver for OMAP3 camera
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

diff -purN c/arch/arm/mach-omap2/board-3430sdp.c d/arch/arm/mach-omap2/board-3430sdp.c
--- c/arch/arm/mach-omap2/board-3430sdp.c	2008-05-07 00:46:41.000000000 -0500
+++ d/arch/arm/mach-omap2/board-3430sdp.c	2008-07-24 17:17:09.000000000 -0500
@@ -41,6 +41,15 @@
 #include <asm/arch/dma.h>
 #include <asm/arch/gpmc.h>
 
+#ifdef CONFIG_VIDEO_OMAP3
+#include <media/v4l2-int-device.h>
+#include <../drivers/media/video/omap34xxcam.h>
+#include <../drivers/media/video/isp/ispreg.h>
+#if defined(CONFIG_VIDEO_MT9P012) || defined(CONFIG_VIDEO_MT9P012_MODULE)
+#include <../drivers/media/video/mt9p012.h>
+#endif
+#endif
+
 #include <asm/io.h>
 #include <asm/delay.h>
 
@@ -203,6 +212,185 @@ static struct spi_board_info sdp3430_spi
 	},
 };
 
+#if defined(CONFIG_VIDEO_MT9P012) || defined(CONFIG_VIDEO_MT9P012_MODULE)
+static void __iomem *fpga_map_addr;
+
+static struct omap34xxcam_sensor_config cam_hwc = {
+	.sensor_isp = V4L2_IF_CAP_RAW,
+	.xclk = OMAP34XXCAM_XCLK_A,
+};
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
+
+static int mt9p012_sensor_set_prv_data(void *priv)
+{
+	struct omap34xxcam_hw_config *hwc = priv;
+
+	hwc->u.sensor.xclk = cam_hwc.xclk;
+	hwc->u.sensor.sensor_isp = cam_hwc.sensor_isp;
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
+		omap_free_gpio(MT9P012_RESET_GPIO);
+		iounmap(fpga_map_addr);
+		omap_free_gpio(MT9P012_STANDBY_GPIO);
+		break;
+	case V4L2_POWER_ON:
+		/* Power Up Sequence */
+		isp_configure_interface(&mt9p012_if_config);
+
+		/* Request and configure gpio pins */
+		if (omap_request_gpio(MT9P012_STANDBY_GPIO) != 0) {
+			printk(KERN_WARNING "Could not request GPIO %d for "
+					"AF D88\n", MT9P012_STANDBY_GPIO);
+			return -EIO;
+		}
+
+		/* Request and configure gpio pins */
+		if (omap_request_gpio(MT9P012_RESET_GPIO) != 0)
+			return -EIO;
+
+		/* set to output mode */
+		omap_set_gpio_direction(MT9P012_STANDBY_GPIO, 0);
+		/* set to output mode */
+		omap_set_gpio_direction(MT9P012_RESET_GPIO, 0);
+
+		/* STANDBY_GPIO is active HIGH for set LOW to release */
+		omap_set_gpio_dataout(MT9P012_STANDBY_GPIO, 1);
+
+		/* nRESET is active LOW. set HIGH to release reset */
+		omap_set_gpio_dataout(MT9P012_RESET_GPIO, 1);
+
+		/* turn on digital power */
+		enable_fpga_vio_1v8(1);
+#ifdef CONFIG_TWL4030_CORE
+		/* turn on analog power */
+		twl4030_i2c_write_u8(TWL4030_MODULE_PM_RECEIVER,
+					VAUX_2_8_V, TWL4030_VAUX2_DEDICATED);
+		twl4030_i2c_write_u8(TWL4030_MODULE_PM_RECEIVER,
+					VAUX_DEV_GRP_P1, TWL4030_VAUX2_DEV_GRP);
+#else
+#error "no power companion board defined!"
+#endif
+
+		omap_set_gpio_dataout(MT9P012_STANDBY_GPIO, 0);
+
+		udelay(1000);
+
+		/* have to put sensor to reset to guarantee detection */
+		omap_set_gpio_dataout(MT9P012_RESET_GPIO, 0);
+
+		udelay(1500);
+
+		/* nRESET is active LOW. set HIGH to release reset */
+		omap_set_gpio_dataout(MT9P012_RESET_GPIO, 1);
+		/* give sensor sometime to get out of the reset. Datasheet says
+		   2400 xclks. At 6 MHz, 400 usec are enough */
+		udelay(300);
+		break;
+	case V4L2_POWER_STANDBY:
+		/* stand by */
+		omap_set_gpio_dataout(MT9P012_STANDBY_GPIO, 1);
+		break;
+	case V4L2_POWER_RESUME:
+		/* out of standby */
+		omap_set_gpio_dataout(MT9P012_STANDBY_GPIO, 0);
+		udelay(1000);
+		break;
+	}
+
+	return 0;
+}
+
+static struct v4l2_ifparm ifparm = {
+	.capability = V4L2_IF_CAP_RAW,
+	.if_type = V4L2_IF_TYPE_BT656,
+	.u = {
+		.bt656 = {
+			.frame_start_on_rising_vs = 1,
+			.latch_clk_inv = 0,
+			.mode = V4L2_IF_TYPE_BT656_MODE_NOBT_10BIT,
+			.clock_min = MT9P012_XCLK_MIN,
+			.clock_max = MT9P012_XCLK_MAX,
+		},
+	},
+};
+
+static int mt9p012_ifparm(struct v4l2_ifparm *p)
+{
+	*p = ifparm;
+	return 0;
+}
+
+static struct mt9p012_platform_data sdp3430_mt9p012_platform_data = {
+	.power_set      = mt9p012_sensor_power_set,
+	.priv_data_set  = mt9p012_sensor_set_prv_data,
+	.default_regs   = NULL,
+	.ifparm         = mt9p012_ifparm,
+};
+
+static struct i2c_board_info __initdata sdp3430_i2c_board_info[] = {
+	{
+		I2C_BOARD_INFO("mt9p012", MT9P012_I2C_ADDR),
+		.platform_data = &sdp3430_mt9p012_platform_data,
+	},
+};
+
+#endif
+
 static struct platform_device sdp3430_lcd_device = {
 	.name		= "sdp2430_lcd",
 	.id		= -1,
@@ -278,7 +466,12 @@ static struct omap_board_config_kernel s
 static int __init omap3430_i2c_init(void)
 {
 	omap_register_i2c_bus(1, 2600, NULL, 0);
+#if defined(CONFIG_VIDEO_MT9P012) || defined(CONFIG_VIDEO_MT9P012_MODULE)
+	omap_register_i2c_bus(2, 400, sdp3430_i2c_board_info,
+			      ARRAY_SIZE(sdp3430_i2c_board_info));
+#else
 	omap_register_i2c_bus(2, 400, NULL, 0);
+#endif
 	omap_register_i2c_bus(3, 400, NULL, 0);
 	return 0;
 }

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
