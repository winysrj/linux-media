Return-path: <linux-media-owner@vger.kernel.org>
Received: from arroyo.ext.ti.com ([192.94.94.40]:45358 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754147AbZCCUoh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 3 Mar 2009 15:44:37 -0500
From: "Aguirre Rodriguez, Sergio Alberto" <saaguirre@ti.com>
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>
CC: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>,
	"Tuukka.O Toivonen" <tuukka.o.toivonen@nokia.com>,
	Hiroshi DOYU <Hiroshi.DOYU@nokia.com>,
	"DongSoo(Nathaniel) Kim" <dongsoo.kim@gmail.com>,
	MiaoStanley <stanleymiao@hotmail.com>,
	"Nagalla, Hari" <hnagalla@ti.com>,
	"Hiremath, Vaibhav" <hvaibhav@ti.com>,
	"Lakhani, Amish" <amish@ti.com>, "Menon, Nishanth" <nm@ti.com>
Date: Tue, 3 Mar 2009 14:44:22 -0600
Subject: [PATCH 4/5] OMAP3430SDP: Add support for Camera Kit v3
Message-ID: <A24693684029E5489D1D202277BE89442E1D9223@dlee02.ent.ti.com>
Content-Language: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch adds support for sensors contained in Camkit v3,
which has:
 - Primary sensor (/dev/video0): MT9P012 (Parallel) with
   DW9710 lens driver.
 - Secondary sensor (/dev/video4): OV3640 (CSI2).

It introduces also a new file for storing all camera sensors board
specific related functions, like other platforms do (N800 for example).

Signed-off-by: Sergio Aguirre <saaguirre@ti.com>
---
 arch/arm/mach-omap2/Makefile                    |    3 +-
 arch/arm/mach-omap2/board-3430sdp-camera.c      |  490 +++++++++++++++++++++++
 arch/arm/mach-omap2/board-3430sdp.c             |   42 ++-
 arch/arm/plat-omap/include/mach/board-3430sdp.h |    1 +
 4 files changed, 534 insertions(+), 2 deletions(-)
 create mode 100644 arch/arm/mach-omap2/board-3430sdp-camera.c

diff --git a/arch/arm/mach-omap2/Makefile b/arch/arm/mach-omap2/Makefile
index 33b5aa8..8888ee6 100644
--- a/arch/arm/mach-omap2/Makefile
+++ b/arch/arm/mach-omap2/Makefile
@@ -53,7 +53,8 @@ obj-$(CONFIG_MACH_OMAP2EVM)           += board-omap2evm.o \
                                           mmc-twl4030.o
 obj-$(CONFIG_MACH_OMAP_3430SDP)                += board-3430sdp.o \
                                           mmc-twl4030.o \
-                                          board-3430sdp-flash.o
+                                          board-3430sdp-flash.o \
+                                          board-3430sdp-camera.o
 obj-$(CONFIG_MACH_OMAP3EVM)            += board-omap3evm.o \
                                           mmc-twl4030.o \
                                           board-omap3evm-flash.o \
diff --git a/arch/arm/mach-omap2/board-3430sdp-camera.c b/arch/arm/mach-omap2/board-3430sdp-camera.c
new file mode 100644
index 0000000..661d5ed
--- /dev/null
+++ b/arch/arm/mach-omap2/board-3430sdp-camera.c
@@ -0,0 +1,490 @@
+/*
+ * linux/arch/arm/mach-omap2/board-3430sdp.c
+ *
+ * Copyright (C) 2007 Texas Instruments
+ *
+ * Modified from mach-omap2/board-generic.c
+ *
+ * Initial code: Syed Mohammed Khasim
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifdef CONFIG_TWL4030_CORE
+
+#include <linux/clk.h>
+#include <linux/platform_device.h>
+#include <linux/delay.h>
+#include <linux/mm.h>
+
+#include <linux/i2c/twl4030.h>
+
+#include <asm/io.h>
+
+#include <mach/gpio.h>
+
+static int cam_inited;
+#include <media/v4l2-int-device.h>
+#include <../drivers/media/video/omap34xxcam.h>
+#include <../drivers/media/video/isp/ispreg.h>
+#define DEBUG_BASE             0x08000000
+
+#define REG_SDP3430_FPGA_GPIO_2 (0x50)
+#define FPGA_SPR_GPIO1_3v3     (0x1 << 14)
+#define FPGA_GPIO6_DIR_CTRL    (0x1 << 6)
+
+#define VAUX_2_8_V             0x09
+#define VAUX_1_8_V             0x05
+#define VAUX_DEV_GRP_P1                0x20
+#define VAUX_DEV_GRP_NONE      0x00
+
+#define CAMKITV3_USE_XCLKA     0
+#define CAMKITV3_USE_XCLKB     1
+
+#define CAMKITV3_RESET_GPIO    98
+/* Sensor specific GPIO signals */
+#define MT9P012_STANDBY_GPIO   58
+#define OV3640_STANDBY_GPIO    55
+static void __iomem *fpga_map_addr;
+
+#if defined(CONFIG_VIDEO_MT9P012) || defined(CONFIG_VIDEO_MT9P012_MODULE)
+#include <media/mt9p012.h>
+static enum v4l2_power mt9p012_previous_power = V4L2_POWER_OFF;
+#endif
+
+#if defined(CONFIG_VIDEO_OV3640) || defined(CONFIG_VIDEO_OV3640_MODULE)
+#include <media/ov3640.h>
+#include <../drivers/media/video/isp/ispcsi2.h>
+static struct omap34xxcam_hw_config *hwc;
+#define OV3640_CSI2_CLOCK_POLARITY     0       /* +/- pin order */
+#define OV3640_CSI2_DATA0_POLARITY     0       /* +/- pin order */
+#define OV3640_CSI2_DATA1_POLARITY     0       /* +/- pin order */
+#define OV3640_CSI2_CLOCK_LANE         1        /* Clock lane position: 1 */
+#define OV3640_CSI2_DATA0_LANE         2        /* Data0 lane position: 2 */
+#define OV3640_CSI2_DATA1_LANE         3        /* Data1 lane position: 3 */
+#define OV3640_CSI2_PHY_THS_TERM       4
+#define OV3640_CSI2_PHY_THS_SETTLE     14
+#define OV3640_CSI2_PHY_TCLK_TERM      0
+#define OV3640_CSI2_PHY_TCLK_MISS      1
+#define OV3640_CSI2_PHY_TCLK_SETTLE    14
+#endif
+
+#ifdef CONFIG_VIDEO_DW9710
+#include <media/dw9710.h>
+#endif
+
+static void __iomem *fpga_map_addr;
+
+static void enable_fpga_vio_1v8(u8 enable)
+{
+       u16 reg_val;
+
+       fpga_map_addr = ioremap(DEBUG_BASE, 4096);
+       reg_val = readw(fpga_map_addr + REG_SDP3430_FPGA_GPIO_2);
+
+       /* Ensure that the SPR_GPIO1_3v3 is 0 - powered off.. 1 is on */
+       if (reg_val & FPGA_SPR_GPIO1_3v3) {
+               reg_val |= FPGA_SPR_GPIO1_3v3;
+               reg_val |= FPGA_GPIO6_DIR_CTRL; /* output mode */
+               writew(reg_val, fpga_map_addr + REG_SDP3430_FPGA_GPIO_2);
+               /* give a few milli sec to settle down
+                * Let the sensor also settle down.. if required..
+                */
+               if (enable)
+                       mdelay(10);
+       }
+
+       if (enable) {
+               reg_val |= FPGA_SPR_GPIO1_3v3 | FPGA_GPIO6_DIR_CTRL;
+               writew(reg_val, fpga_map_addr + REG_SDP3430_FPGA_GPIO_2);
+       }
+       /* Vrise time for the voltage - should be less than 1 ms */
+       mdelay(1);
+}
+
+#ifdef CONFIG_VIDEO_DW9710
+static int dw9710_lens_power_set(enum v4l2_power power)
+{
+       if (!cam_inited) {
+               printk(KERN_ERR "DW9710: Unable to control board GPIOs!\n");
+               return -EFAULT;
+       }
+
+       /* The power change depends on MT9P012 powerup, so if we request a
+        * power state different from sensor, we should return error
+        */
+       if ((mt9p012_previous_power != V4L2_POWER_OFF) &&
+                                       (power != mt9p012_previous_power))
+               return -EIO;
+
+       switch (power) {
+       case V4L2_POWER_OFF:
+               /* Power Down Sequence */
+               twl4030_i2c_write_u8(TWL4030_MODULE_PM_RECEIVER,
+                               VAUX_DEV_GRP_NONE, TWL4030_VAUX2_DEV_GRP);
+               enable_fpga_vio_1v8(0);
+               iounmap(fpga_map_addr);
+               break;
+       case V4L2_POWER_ON:
+               /* STANDBY_GPIO is active HIGH for set LOW to release */
+               gpio_set_value(MT9P012_STANDBY_GPIO, 1);
+
+               /* nRESET is active LOW. set HIGH to release reset */
+               gpio_set_value(CAMKITV3_RESET_GPIO, 1);
+
+               /* turn on digital power */
+               enable_fpga_vio_1v8(1);
+
+               /* turn on analog power */
+               twl4030_i2c_write_u8(TWL4030_MODULE_PM_RECEIVER,
+                               VAUX_2_8_V, TWL4030_VAUX2_DEDICATED);
+               twl4030_i2c_write_u8(TWL4030_MODULE_PM_RECEIVER,
+                               VAUX_DEV_GRP_P1, TWL4030_VAUX2_DEV_GRP);
+
+               /* out of standby */
+               gpio_set_value(MT9P012_STANDBY_GPIO, 0);
+               udelay(1000);
+
+               /* have to put sensor to reset to guarantee detection */
+               gpio_set_value(CAMKITV3_RESET_GPIO, 0);
+
+               udelay(1500);
+
+               /* nRESET is active LOW. set HIGH to release reset */
+               gpio_set_value(CAMKITV3_RESET_GPIO, 1);
+               /* give sensor sometime to get out of the reset.
+                * Datasheet says 2400 xclks. At 6 MHz, 400 usec is
+                * enough
+                */
+               udelay(300);
+               break;
+       case V4L2_POWER_STANDBY:
+               break;
+       }
+       return 0;
+}
+
+static int dw9710_lens_set_prv_data(void *priv)
+{
+       struct omap34xxcam_hw_config *hwc = priv;
+
+       hwc->dev_index = 0;
+       hwc->dev_minor = 0;
+       hwc->dev_type = OMAP34XXCAM_SLAVE_LENS;
+
+       return 0;
+}
+
+struct dw9710_platform_data sdp3430_dw9710_platform_data = {
+       .power_set      = dw9710_lens_power_set,
+       .priv_data_set  = dw9710_lens_set_prv_data,
+};
+#endif
+
+#if defined(CONFIG_VIDEO_MT9P012) || defined(CONFIG_VIDEO_MT9P012_MODULE)
+static struct omap34xxcam_sensor_config cam_hwc = {
+       .sensor_isp = 0,
+       .xclk = OMAP34XXCAM_XCLK_A,
+       .capture_mem = PAGE_ALIGN(2592 * 1944 * 2) * 4,
+       .ival_default   = { 1, 10 },
+};
+
+static int mt9p012_sensor_set_prv_data(void *priv)
+{
+       struct omap34xxcam_hw_config *hwc = priv;
+
+       hwc->u.sensor.xclk = cam_hwc.xclk;
+       hwc->u.sensor.sensor_isp = cam_hwc.sensor_isp;
+       hwc->u.sensor.capture_mem = cam_hwc.capture_mem;
+       hwc->dev_index = 0;
+       hwc->dev_minor = 0;
+       hwc->dev_type = OMAP34XXCAM_SLAVE_SENSOR;
+       return 0;
+}
+
+static struct isp_interface_config mt9p012_if_config = {
+       .ccdc_par_ser = ISP_PARLL,
+       .dataline_shift = 0x1,
+       .hsvs_syncdetect = ISPCTRL_SYNC_DETECT_VSRISE,
+       .strobe = 0x0,
+       .prestrobe = 0x0,
+       .shutter = 0x0,
+       .prev_sph = 2,
+       .prev_slv = 0,
+       .wenlog = ISPCCDC_CFG_WENLOG_AND,
+       .u.par.par_bridge = 0x0,
+       .u.par.par_clk_pol = 0x0,
+};
+
+static int mt9p012_sensor_power_set(enum v4l2_power power)
+{
+       if (!cam_inited) {
+               printk(KERN_ERR "MT9P012: Unable to control board GPIOs!\n");
+               return -EFAULT;
+       }
+
+       switch (power) {
+       case V4L2_POWER_OFF:
+               /* Power Down Sequence */
+               twl4030_i2c_write_u8(TWL4030_MODULE_PM_RECEIVER,
+                               VAUX_DEV_GRP_NONE, TWL4030_VAUX2_DEV_GRP);
+
+               enable_fpga_vio_1v8(0);
+               iounmap(fpga_map_addr);
+               break;
+       case V4L2_POWER_ON:
+               if (mt9p012_previous_power == V4L2_POWER_OFF) {
+                       /* Power Up Sequence */
+                       isp_configure_interface(&mt9p012_if_config);
+
+                       /* set to output mode */
+                       gpio_direction_output(MT9P012_STANDBY_GPIO, true);
+                       /* set to output mode */
+                       gpio_direction_output(CAMKITV3_RESET_GPIO, true);
+
+                       /* STANDBY_GPIO is active HIGH for set LOW to release */
+                       gpio_set_value(MT9P012_STANDBY_GPIO, 1);
+
+                       /* nRESET is active LOW. set HIGH to release reset */
+                       gpio_set_value(CAMKITV3_RESET_GPIO, 1);
+
+                       /* turn on digital power */
+                       enable_fpga_vio_1v8(1);
+
+                       /* turn on analog power */
+                       twl4030_i2c_write_u8(TWL4030_MODULE_PM_RECEIVER,
+                                       VAUX_2_8_V, TWL4030_VAUX2_DEDICATED);
+                       twl4030_i2c_write_u8(TWL4030_MODULE_PM_RECEIVER,
+                                       VAUX_DEV_GRP_P1, TWL4030_VAUX2_DEV_GRP);
+               }
+
+               /* out of standby */
+               gpio_set_value(MT9P012_STANDBY_GPIO, 0);
+               udelay(1000);
+
+               if (mt9p012_previous_power == V4L2_POWER_OFF) {
+                       /* have to put sensor to reset to guarantee detection */
+                       gpio_set_value(CAMKITV3_RESET_GPIO, 0);
+
+                       udelay(1500);
+
+                       /* nRESET is active LOW. set HIGH to release reset */
+                       gpio_set_value(CAMKITV3_RESET_GPIO, 1);
+                       /* give sensor sometime to get out of the reset.
+                        * Datasheet says 2400 xclks. At 6 MHz, 400 usec is
+                        * enough
+                        */
+                       udelay(300);
+               }
+               break;
+       case V4L2_POWER_STANDBY:
+               /* stand by */
+               gpio_set_value(MT9P012_STANDBY_GPIO, 1);
+               break;
+       }
+       /* Save powerstate to know what was before calling POWER_ON. */
+       mt9p012_previous_power = power;
+       return 0;
+}
+
+static u32 mt9p012_sensor_set_xclk(u32 xclkfreq)
+{
+       return isp_set_xclk(xclkfreq, CAMKITV3_USE_XCLKA);
+}
+
+struct mt9p012_platform_data sdp3430_mt9p012_platform_data = {
+       .power_set      = mt9p012_sensor_power_set,
+       .priv_data_set  = mt9p012_sensor_set_prv_data,
+       .set_xclk       = mt9p012_sensor_set_xclk,
+};
+
+#endif
+
+#if defined(CONFIG_VIDEO_OV3640) || defined(CONFIG_VIDEO_OV3640_MODULE)
+
+static struct omap34xxcam_sensor_config ov3640_hwc = {
+       .sensor_isp = 0,
+#if defined(CONFIG_VIDEO_OV3640_CSI2)
+       .xclk = OMAP34XXCAM_XCLK_B,
+#else
+       .xclk = OMAP34XXCAM_XCLK_A,
+#endif
+       .capture_mem = PAGE_ALIGN(2048 * 1536 * 2) * 2,
+       .ival_default   = { 1, 15 },
+};
+
+static struct isp_interface_config ov3640_if_config = {
+       .ccdc_par_ser = ISP_CSIA,
+       .dataline_shift = 0x0,
+       .hsvs_syncdetect = ISPCTRL_SYNC_DETECT_VSRISE,
+       .strobe = 0x0,
+       .prestrobe = 0x0,
+       .shutter = 0x0,
+       .prev_sph = 2,
+       .prev_slv = 0,
+       .wenlog = ISPCCDC_CFG_WENLOG_AND,
+       .wait_hs_vs = 2,
+       .u.csi.crc = 0x0,
+       .u.csi.mode = 0x0,
+       .u.csi.edge = 0x0,
+       .u.csi.signalling = 0x0,
+       .u.csi.strobe_clock_inv = 0x0,
+       .u.csi.vs_edge = 0x0,
+       .u.csi.channel = 0x1,
+       .u.csi.vpclk = 0x1,
+       .u.csi.data_start = 0x0,
+       .u.csi.data_size = 0x0,
+       .u.csi.format = V4L2_PIX_FMT_SGRBG10,
+};
+
+static int ov3640_sensor_set_prv_data(void *priv)
+{
+       hwc = priv;
+       hwc->u.sensor.xclk = ov3640_hwc.xclk;
+       hwc->u.sensor.sensor_isp = ov3640_hwc.sensor_isp;
+       hwc->u.sensor.capture_mem = ov3640_hwc.capture_mem;
+       hwc->dev_index = 1;
+       hwc->dev_minor = 4;
+       hwc->dev_type = OMAP34XXCAM_SLAVE_SENSOR;
+       return 0;
+}
+
+static int ov3640_sensor_power_set(enum v4l2_power power)
+{
+       struct isp_csi2_lanes_cfg lanecfg;
+       struct isp_csi2_phy_cfg phyconfig;
+       static enum v4l2_power previous_power = V4L2_POWER_OFF;
+
+       if (!cam_inited) {
+               printk(KERN_ERR "OV3640: Unable to control board GPIOs!\n");
+               return -EFAULT;
+       }
+
+       switch (power) {
+       case V4L2_POWER_ON:
+               if (previous_power == V4L2_POWER_OFF)
+                       isp_csi2_reset();
+
+               lanecfg.clk.pol = OV3640_CSI2_CLOCK_POLARITY;
+               lanecfg.clk.pos = OV3640_CSI2_CLOCK_LANE;
+               lanecfg.data[0].pol = OV3640_CSI2_DATA0_POLARITY;
+               lanecfg.data[0].pos = OV3640_CSI2_DATA0_LANE;
+               lanecfg.data[1].pol = OV3640_CSI2_DATA1_POLARITY;
+               lanecfg.data[1].pos = OV3640_CSI2_DATA1_LANE;
+               lanecfg.data[2].pol = 0;
+               lanecfg.data[2].pos = 0;
+               lanecfg.data[3].pol = 0;
+               lanecfg.data[3].pos = 0;
+               isp_csi2_complexio_lanes_config(&lanecfg);
+               isp_csi2_complexio_lanes_update(true);
+
+               phyconfig.ths_term = OV3640_CSI2_PHY_THS_TERM;
+               phyconfig.ths_settle = OV3640_CSI2_PHY_THS_SETTLE;
+               phyconfig.tclk_term = OV3640_CSI2_PHY_TCLK_TERM;
+               phyconfig.tclk_miss = OV3640_CSI2_PHY_TCLK_MISS;
+               phyconfig.tclk_settle = OV3640_CSI2_PHY_TCLK_SETTLE;
+               isp_csi2_phy_config(&phyconfig);
+               isp_csi2_phy_update(true);
+
+               isp_configure_interface(&ov3640_if_config);
+
+               if (previous_power == V4L2_POWER_OFF) {
+                       /* turn on analog power */
+#if defined(CONFIG_VIDEO_OV3640_CSI2)
+                       twl4030_i2c_write_u8(TWL4030_MODULE_PM_RECEIVER,
+                                       VAUX_1_8_V, TWL4030_VAUX4_DEDICATED);
+                       twl4030_i2c_write_u8(TWL4030_MODULE_PM_RECEIVER,
+                                       VAUX_DEV_GRP_P1, TWL4030_VAUX4_DEV_GRP);
+#else
+                       twl4030_i2c_write_u8(TWL4030_MODULE_PM_RECEIVER,
+                                       VAUX_2_8_V, TWL4030_VAUX2_DEDICATED);
+                       twl4030_i2c_write_u8(TWL4030_MODULE_PM_RECEIVER,
+                                       VAUX_DEV_GRP_P1, TWL4030_VAUX2_DEV_GRP);
+#endif
+                       udelay(100);
+
+                       /* Turn ON Omnivision sensor */
+                       gpio_set_value(CAMKITV3_RESET_GPIO, 1);
+                       gpio_set_value(OV3640_STANDBY_GPIO, 0);
+                       udelay(100);
+
+                       /* RESET Omnivision sensor */
+                       gpio_set_value(CAMKITV3_RESET_GPIO, 0);
+                       udelay(100);
+                       gpio_set_value(CAMKITV3_RESET_GPIO, 1);
+
+                       /* Wait 10 ms */
+                       mdelay(10);
+                       enable_fpga_vio_1v8(1);
+                       udelay(100);
+               }
+               break;
+       case V4L2_POWER_OFF:
+               /* Power Down Sequence */
+               isp_csi2_complexio_power(ISP_CSI2_POWER_OFF);
+#if defined(CONFIG_VIDEO_OV3640_CSI2)
+               twl4030_i2c_write_u8(TWL4030_MODULE_PM_RECEIVER,
+                               VAUX_DEV_GRP_NONE, TWL4030_VAUX4_DEV_GRP);
+#else
+               twl4030_i2c_write_u8(TWL4030_MODULE_PM_RECEIVER,
+                               VAUX_DEV_GRP_NONE, TWL4030_VAUX2_DEV_GRP);
+#endif
+               enable_fpga_vio_1v8(0);
+               iounmap(fpga_map_addr);
+               break;
+       case V4L2_POWER_STANDBY:
+               break;
+       }
+       previous_power = power;
+       return 0;
+}
+
+static u32 ov3640_sensor_set_xclk(u32 xclkfreq)
+{
+       return isp_set_xclk(xclkfreq, CAMKITV3_USE_XCLKB);
+}
+
+struct ov3640_platform_data sdp3430_ov3640_platform_data = {
+       .power_set       = ov3640_sensor_power_set,
+       .priv_data_set   = ov3640_sensor_set_prv_data,
+       .set_xclk        = ov3640_sensor_set_xclk,
+};
+
+#endif
+
+void __init sdp3430_cam_init(void)
+{
+       cam_inited = 0;
+       /* Request and configure gpio pins */
+       if (gpio_request(CAMKITV3_RESET_GPIO, "camkitv3_reset_gpio") != 0) {
+               printk(KERN_ERR "Could not request GPIO %d",
+                                       CAMKITV3_RESET_GPIO);
+               return;
+       }
+
+       if (gpio_request(OV3640_STANDBY_GPIO, "ov3640_standby_gpio") != 0) {
+               printk(KERN_ERR "Could not request GPIO %d",
+                                       OV3640_STANDBY_GPIO);
+               return;
+       }
+
+       if (gpio_request(MT9P012_STANDBY_GPIO, "mt9p012_standby_gpio")) {
+               printk(KERN_ERR "Could not request GPIO %d for MT9P012\n",
+                                                       MT9P012_STANDBY_GPIO);
+               return;
+       }
+
+       /* set to output mode */
+       gpio_direction_output(CAMKITV3_RESET_GPIO, true);
+       gpio_direction_output(OV3640_STANDBY_GPIO, true);
+       gpio_direction_output(MT9P012_STANDBY_GPIO, true);
+
+       cam_inited = 1;
+}
+#else
+void __init sdp3430_cam_init(void)
+{
+}
+#endif
diff --git a/arch/arm/mach-omap2/board-3430sdp.c b/arch/arm/mach-omap2/board-3430sdp.c
index 867f5f6..986f087 100644
--- a/arch/arm/mach-omap2/board-3430sdp.c
+++ b/arch/arm/mach-omap2/board-3430sdp.c
@@ -40,6 +40,23 @@
 #include <mach/dma.h>
 #include <mach/gpmc.h>

+#include <media/v4l2-int-device.h>
+
+#if defined(CONFIG_VIDEO_MT9P012) || defined(CONFIG_VIDEO_MT9P012_MODULE)
+#include <media/mt9p012.h>
+extern struct mt9p012_platform_data sdp3430_mt9p012_platform_data;
+#endif
+
+#if defined(CONFIG_VIDEO_OV3640) || defined(CONFIG_VIDEO_OV3640_MODULE)
+#include <media/ov3640.h>
+extern struct ov3640_platform_data sdp3430_ov3640_platform_data;
+#endif
+
+#ifdef CONFIG_VIDEO_DW9710
+#include <media/dw9710.h>
+extern struct dw9710_platform_data sdp3430_dw9710_platform_data;
+#endif
+
 #include <mach/control.h>

 #include "sdram-qimonda-hyb18m512160af-6.h"
@@ -610,13 +627,35 @@ static struct i2c_board_info __initdata sdp3430_i2c_boardinfo[] = {
        },
 };

+static struct i2c_board_info __initdata sdp3430_i2c_boardinfo_2[] = {
+#if defined(CONFIG_VIDEO_MT9P012) || defined(CONFIG_VIDEO_MT9P012_MODULE)
+       {
+               I2C_BOARD_INFO("mt9p012", MT9P012_I2C_ADDR),
+               .platform_data = &sdp3430_mt9p012_platform_data,
+       },
+#ifdef CONFIG_VIDEO_DW9710
+       {
+               I2C_BOARD_INFO("dw9710",  DW9710_AF_I2C_ADDR),
+               .platform_data = &sdp3430_dw9710_platform_data,
+       },
+#endif
+#endif
+#if defined(CONFIG_VIDEO_OV3640) || defined(CONFIG_VIDEO_OV3640_MODULE)
+       {
+               I2C_BOARD_INFO("ov3640", OV3640_I2C_ADDR),
+               .platform_data = &sdp3430_ov3640_platform_data,
+       },
+#endif
+};
+
 static int __init omap3430_i2c_init(void)
 {
        /* i2c1 for PMIC only */
        omap_register_i2c_bus(1, 2600, sdp3430_i2c_boardinfo,
                        ARRAY_SIZE(sdp3430_i2c_boardinfo));
        /* i2c2 on camera connector (for sensor control) and optional isp1301 */
-       omap_register_i2c_bus(2, 400, NULL, 0);
+       omap_register_i2c_bus(2, 400, sdp3430_i2c_boardinfo_2,
+                       ARRAY_SIZE(sdp3430_i2c_boardinfo_2));
        /* i2c3 on display connector (for DVI, tfp410) */
        omap_register_i2c_bus(3, 400, NULL, 0);
        return 0;
@@ -641,6 +680,7 @@ static void __init omap_3430sdp_init(void)
        omap_serial_init();
        usb_musb_init();
        usb_ehci_init();
+       sdp3430_cam_init();
 }

 static void __init omap_3430sdp_map_io(void)
diff --git a/arch/arm/plat-omap/include/mach/board-3430sdp.h b/arch/arm/plat-omap/include/mach/board-3430sdp.h
index 67d3f78..2ddb3e5 100644
--- a/arch/arm/plat-omap/include/mach/board-3430sdp.h
+++ b/arch/arm/plat-omap/include/mach/board-3430sdp.h
@@ -32,6 +32,7 @@
 extern void sdp3430_usb_init(void);
 extern void sdp3430_flash_init(void);
 extern void twl4030_bci_battery_init(void);
+extern void sdp3430_cam_init(void);

 #define DEBUG_BASE                     0x08000000  /* debug board */

--
1.5.6.5

