Return-path: <linux-media-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:59167 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751929AbZCCVky convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 3 Mar 2009 16:40:54 -0500
From: "Curran, Dominic" <dcurran@ti.com>
To: "Aguirre Rodriguez, Sergio Alberto" <saaguirre@ti.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>
CC: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>,
	"Tuukka.O Toivonen" <tuukka.o.toivonen@nokia.com>,
	Hiroshi DOYU <Hiroshi.DOYU@nokia.com>,
	"DongSoo(Nathaniel) Kim" <dongsoo.kim@gmail.com>,
	MiaoStanley <stanleymiao@hotmail.com>,
	"Nagalla, Hari" <hnagalla@ti.com>,
	"Hiremath, Vaibhav" <hvaibhav@ti.com>,
	"Lakhani, Amish" <amish@ti.com>, "Menon, Nishanth" <nm@ti.com>
Date: Tue, 3 Mar 2009 15:40:31 -0600
Subject: RE: [PATCH 5/5] LDP: Add support for built-in camera
Message-ID: <96DA7A230D3B2F42BA3EF203A7A1B3B5012EA393AA@dlee07.ent.ti.com>
In-Reply-To: <A24693684029E5489D1D202277BE89442E1D9224@dlee02.ent.ti.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



> -----Original Message-----
> From: linux-omap-owner@vger.kernel.org [mailto:linux-omap-
> owner@vger.kernel.org] On Behalf Of Aguirre Rodriguez, Sergio Alberto
> Sent: Tuesday, March 03, 2009 2:44 PM
> To: linux-media@vger.kernel.org; linux-omap@vger.kernel.org
> Cc: Sakari Ailus; Tuukka.O Toivonen; Hiroshi DOYU; DongSoo(Nathaniel) Kim;
> MiaoStanley; Nagalla, Hari; Hiremath, Vaibhav; Lakhani, Amish; Menon, Nishanth
> Subject: [PATCH 5/5] LDP: Add support for built-in camera
>
> This patch adds support for the LDP builtin camera sensor:
>  - Primary sensor (/dev/video4): OV3640 (CSI2).
>
> It introduces also a new file for storing all camera sensors board
> specific related functions, like other platforms do (N800 for example).
>
> Signed-off-by: Sergio Aguirre <saaguirre@ti.com>
> ---
>  arch/arm/mach-omap2/Makefile                |    3 +-
>  arch/arm/mach-omap2/board-ldp-camera.c      |  203
> +++++++++++++++++++++++++++
>  arch/arm/mach-omap2/board-ldp.c             |   17 +++
>  arch/arm/plat-omap/include/mach/board-ldp.h |    1 +
>  4 files changed, 223 insertions(+), 1 deletions(-)
>  create mode 100644 arch/arm/mach-omap2/board-ldp-camera.c
>
> diff --git a/arch/arm/mach-omap2/Makefile b/arch/arm/mach-omap2/Makefile
> index 8888ee6..097bc58 100644
> --- a/arch/arm/mach-omap2/Makefile
> +++ b/arch/arm/mach-omap2/Makefile
> @@ -63,7 +63,8 @@ obj-$(CONFIG_MACH_OMAP3_BEAGLE)             += board-
> omap3beagle.o \
>                                          mmc-twl4030.o \
>                                          twl4030-generic-scripts.o
>  obj-$(CONFIG_MACH_OMAP_LDP)          += board-ldp.o \
> -                                        mmc-twl4030.o
> +                                        mmc-twl4030.o \
> +                                        board-ldp-camera.o
>  obj-$(CONFIG_MACH_OMAP_APOLLON)              += board-apollon.o \
>                                          board-apollon-mmc.o  \
>                                          board-apollon-keys.o
> diff --git a/arch/arm/mach-omap2/board-ldp-camera.c b/arch/arm/mach-
> omap2/board-ldp-camera.c
> new file mode 100644
> index 0000000..0db085c
> --- /dev/null
> +++ b/arch/arm/mach-omap2/board-ldp-camera.c
> @@ -0,0 +1,203 @@
> +/*
> + * linux/arch/arm/mach-omap2/board-ldp0-camera.c

Minor typo, should be:
 linux/arch/arm/mach-omap2/board-ldp-camera.c


> + *
> + * Copyright (C) 2009 Texas Instruments Inc.
> + * Sergio Aguirre <saaguirre@ti.com>
> + *
> + * Modified from mach-omap2/board-ldp.c
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + */
> +
> +#ifdef CONFIG_TWL4030_CORE
> +
> +#include <linux/clk.h>
> +#include <linux/platform_device.h>
> +#include <linux/delay.h>
> +
> +#include <linux/i2c/twl4030.h>
> +
> +#include <asm/io.h>
> +
> +#include <mach/gpio.h>
> +
> +static int cam_inited;
> +#include <media/v4l2-int-device.h>
> +#include <../drivers/media/video/omap34xxcam.h>
> +#include <../drivers/media/video/isp/ispreg.h>
> +
> +#define LDPCAM_USE_XCLKB     1
> +
> +#define VAUX_1_8_V           0x05
> +#define VAUX_DEV_GRP_P1              0x20
> +#define VAUX_DEV_GRP_NONE    0x00
> +
> +#if defined(CONFIG_VIDEO_OV3640) || defined(CONFIG_VIDEO_OV3640_MODULE)
> +#define OV3640_RESET_GPIO    98
> +#define OV3640_STANDBY_GPIO  7
> +#include <media/ov3640.h>
> +#include <../drivers/media/video/isp/ispcsi2.h>
> +static       struct omap34xxcam_hw_config *hwc;
> +#define OV3640_CSI2_CLOCK_POLARITY   0       /* +/- pin order */
> +#define OV3640_CSI2_DATA0_POLARITY   0       /* +/- pin order */
> +#define OV3640_CSI2_DATA1_POLARITY   0       /* +/- pin order */
> +#define OV3640_CSI2_CLOCK_LANE               1        /* Clock lane position: 1 */
> +#define OV3640_CSI2_DATA0_LANE               2        /* Data0 lane position: 2 */
> +#define OV3640_CSI2_DATA1_LANE               3        /* Data1 lane position: 3 */
> +#define OV3640_CSI2_PHY_THS_TERM     4
> +#define OV3640_CSI2_PHY_THS_SETTLE   14
> +#define OV3640_CSI2_PHY_TCLK_TERM    0
> +#define OV3640_CSI2_PHY_TCLK_MISS    1
> +#define OV3640_CSI2_PHY_TCLK_SETTLE  14
> +
> +static struct omap34xxcam_sensor_config ov3640_hwc = {
> +     .sensor_isp = 0,
> +     .xclk = OMAP34XXCAM_XCLK_B,
> +     .capture_mem = 2592 * 1944 * 2 * 2,

Should this be  2048 * 1536 * 2 * 2  ?


Ack-by: Dominic Curran <dcurran@ti.com>

> +     .ival_default   = { 1, 15 },
> +};
> +
> +static struct isp_interface_config ov3640_if_config = {
> +     .ccdc_par_ser = ISP_CSIA,
> +     .dataline_shift = 0x0,
> +     .hsvs_syncdetect = ISPCTRL_SYNC_DETECT_VSRISE,
> +     .strobe = 0x0,
> +     .prestrobe = 0x0,
> +     .shutter = 0x0,
> +     .prev_sph = 2,
> +     .prev_slv = 1,
> +     .wenlog = ISPCCDC_CFG_WENLOG_AND,
> +     .wait_hs_vs = 2,
> +     .u.csi.crc = 0x0,
> +     .u.csi.mode = 0x0,
> +     .u.csi.edge = 0x0,
> +     .u.csi.signalling = 0x0,
> +     .u.csi.strobe_clock_inv = 0x0,
> +     .u.csi.vs_edge = 0x0,
> +     .u.csi.channel = 0x1,
> +     .u.csi.vpclk = 0x1,
> +     .u.csi.data_start = 0x0,
> +     .u.csi.data_size = 0x0,
> +     .u.csi.format = V4L2_PIX_FMT_SGRBG10,
> +};
> +
> +static int ov3640_sensor_set_prv_data(void *priv)
> +{
> +     hwc = priv;
> +     hwc->u.sensor.xclk = ov3640_hwc.xclk;
> +     hwc->u.sensor.sensor_isp = ov3640_hwc.sensor_isp;
> +     hwc->dev_index = 1;
> +     hwc->dev_minor = 4;
> +     hwc->dev_type = OMAP34XXCAM_SLAVE_SENSOR;
> +     return 0;
> +}
> +
> +static int ov3640_sensor_power_set(enum v4l2_power power)
> +{
> +     struct isp_csi2_lanes_cfg lanecfg;
> +     struct isp_csi2_phy_cfg phyconfig;
> +     static enum v4l2_power previous_power = V4L2_POWER_OFF;
> +
> +     if (!cam_inited) {
> +             printk(KERN_ERR "OV3640: Unable to control board GPIOs!\n");
> +             return -EFAULT;
> +     }
> +
> +     switch (power) {
> +     case V4L2_POWER_ON:
> +             if (previous_power == V4L2_POWER_OFF)
> +                     isp_csi2_reset();
> +             lanecfg.clk.pol = OV3640_CSI2_CLOCK_POLARITY;
> +             lanecfg.clk.pos = OV3640_CSI2_CLOCK_LANE;
> +             lanecfg.data[0].pol = OV3640_CSI2_DATA0_POLARITY;
> +             lanecfg.data[0].pos = OV3640_CSI2_DATA0_LANE;
> +             lanecfg.data[1].pol = OV3640_CSI2_DATA1_POLARITY;
> +             lanecfg.data[1].pos = OV3640_CSI2_DATA1_LANE;
> +             lanecfg.data[2].pol = 0;
> +             lanecfg.data[2].pos = 0;
> +             lanecfg.data[3].pol = 0;
> +             lanecfg.data[3].pos = 0;
> +             isp_csi2_complexio_lanes_config(&lanecfg);
> +             isp_csi2_complexio_lanes_update(true);
> +
> +             phyconfig.ths_term = OV3640_CSI2_PHY_THS_TERM;
> +             phyconfig.ths_settle = OV3640_CSI2_PHY_THS_SETTLE;
> +             phyconfig.tclk_term = OV3640_CSI2_PHY_TCLK_TERM;
> +             phyconfig.tclk_miss = OV3640_CSI2_PHY_TCLK_MISS;
> +             phyconfig.tclk_settle = OV3640_CSI2_PHY_TCLK_SETTLE;
> +             isp_csi2_phy_config(&phyconfig);
> +             isp_csi2_phy_update(true);
> +
> +             isp_configure_interface(&ov3640_if_config);
> +
> +             if (previous_power == V4L2_POWER_OFF) {
> +                     /* turn on analog power */
> +                     twl4030_i2c_write_u8(TWL4030_MODULE_PM_RECEIVER,
> +                                     VAUX_1_8_V, TWL4030_VAUX4_DEDICATED);
> +                     twl4030_i2c_write_u8(TWL4030_MODULE_PM_RECEIVER,
> +                                     VAUX_DEV_GRP_P1, TWL4030_VAUX4_DEV_GRP);
> +                     udelay(100);
> +                     /* Turn ON Omnivision sensor */
> +                     gpio_set_value(OV3640_RESET_GPIO, 1);
> +                     gpio_set_value(OV3640_STANDBY_GPIO, 0);
> +                     udelay(100);
> +
> +                     /* RESET Omnivision sensor */
> +                     gpio_set_value(OV3640_RESET_GPIO, 0);
> +                     udelay(100);
> +                     gpio_set_value(OV3640_RESET_GPIO, 1);
> +             }
> +             break;
> +     case V4L2_POWER_OFF:
> +             /* Power Down Sequence */
> +             isp_csi2_complexio_power(ISP_CSI2_POWER_OFF);
> +             twl4030_i2c_write_u8(TWL4030_MODULE_PM_RECEIVER,
> +                             VAUX_DEV_GRP_NONE, TWL4030_VAUX4_DEV_GRP);
> +             break;
> +     case V4L2_POWER_STANDBY:
> +             break;
> +     }
> +     previous_power = power;
> +     return 0;
> +}
> +
> +static u32 ov3640_sensor_set_xclk(u32 xclkfreq)
> +{
> +     return isp_set_xclk(xclkfreq, LDPCAM_USE_XCLKB);
> +}
> +
> +struct ov3640_platform_data ldp_ov3640_platform_data = {
> +     .power_set       = ov3640_sensor_power_set,
> +     .priv_data_set   = ov3640_sensor_set_prv_data,
> +     .set_xclk        = ov3640_sensor_set_xclk,
> +};
> +
> +#endif
> +
> +void __init ldp_cam_init(void)
> +{
> +     cam_inited = 0;
> +     /* Request and configure gpio pins */
> +     if (gpio_request(OV3640_RESET_GPIO, "ov3640_reset_gpio") != 0) {
> +             printk(KERN_ERR "Could not request GPIO %d",
> +                                     OV3640_RESET_GPIO);
> +             return;
> +     }
> +     if (gpio_request(OV3640_STANDBY_GPIO, "ov3640_standby_gpio") != 0) {
> +             printk(KERN_ERR "Could not request GPIO %d",
> +                                     OV3640_STANDBY_GPIO);
> +             gpio_free(OV3640_RESET_GPIO);
> +             return;
> +     }
> +     /* set to output mode */
> +     gpio_direction_output(OV3640_RESET_GPIO, true);
> +     gpio_direction_output(OV3640_STANDBY_GPIO, true);
> +     cam_inited = 1;
> +}
> +#else
> +void __init ldp_cam_init(void)
> +{
> +}
> +#endif
> diff --git a/arch/arm/mach-omap2/board-ldp.c b/arch/arm/mach-omap2/board-ldp.c
> index 1e1fd84..513aa8f 100644
> --- a/arch/arm/mach-omap2/board-ldp.c
> +++ b/arch/arm/mach-omap2/board-ldp.c
> @@ -47,6 +47,13 @@
>  #define SDP3430_SMC91X_CS    3
>  #define CONFIG_DISABLE_HFCLK 1
>
> +#include <media/v4l2-int-device.h>
> +
> +#if defined(CONFIG_VIDEO_OV3640) || defined(CONFIG_VIDEO_OV3640_MODULE)
> +#include <media/ov3640.h>
> +extern struct ov3640_platform_data ldp_ov3640_platform_data;
> +#endif
> +
>  #define ENABLE_VAUX1_DEDICATED       0x03
>  #define ENABLE_VAUX1_DEV_GRP 0x20
>
> @@ -496,6 +503,15 @@ static struct i2c_board_info __initdata
> ldp_i2c_boardinfo[] = {
>       },
>  };
>
> +static struct i2c_board_info __initdata ldp_i2c_boardinfo_2[] = {
> +#if defined(CONFIG_VIDEO_OV3640) || defined(CONFIG_VIDEO_OV3640_MODULE)
> +     {
> +             I2C_BOARD_INFO("ov3640", OV3640_I2C_ADDR),
> +             .platform_data = &ldp_ov3640_platform_data,
> +     },
> +#endif
> +};
> +
>  static int __init omap_i2c_init(void)
>  {
>       omap_register_i2c_bus(1, 2600, ldp_i2c_boardinfo,
> @@ -530,6 +546,7 @@ static void __init omap_ldp_init(void)
>       omap_serial_init();
>       usb_musb_init();
>       twl4030_mmc_init(mmc);
> +     ldp_cam_init();
>  }
>
>  static void __init omap_ldp_map_io(void)
> diff --git a/arch/arm/plat-omap/include/mach/board-ldp.h b/arch/arm/plat-
> omap/include/mach/board-ldp.h
> index f233996..8e5d90b 100644
> --- a/arch/arm/plat-omap/include/mach/board-ldp.h
> +++ b/arch/arm/plat-omap/include/mach/board-ldp.h
> @@ -30,6 +30,7 @@
>  #define __ASM_ARCH_OMAP_LDP_H
>
>  extern void twl4030_bci_battery_init(void);
> +extern void ldp_cam_init(void);
>
>  #define TWL4030_IRQNUM               INT_34XX_SYS_NIRQ
>  #define LDP_SMC911X_CS         1
> --
> 1.5.6.5
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-omap" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

