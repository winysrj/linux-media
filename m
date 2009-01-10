Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ew0-f17.google.com ([209.85.219.17]:52920 "EHLO
	mail-ew0-f17.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752784AbZAJBlD (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 9 Jan 2009 20:41:03 -0500
Subject: Re: [REVIEW PATCH 2/2] Added OMAP3EVM Multi-Media Daughter Card
 Support
From: Alexey Klimov <klimov.linux@gmail.com>
To: hvaibhav@ti.com
Cc: linux-omap@vger.kernel.org, linux-media@vger.kernel.org,
	video4linux-list@redhat.com, Brijesh Jadav <brijesh.j@ti.com>,
	Hardik Shah <hardik.shah@ti.com>, Manjunath Hadli <mrh@ti.com>,
	R Sivaraj <sivaraj@ti.com>
In-Reply-To: <1231308470-31159-1-git-send-email-hvaibhav@ti.com>
References: <hvaibhav@ti.com>
	 <1231308470-31159-1-git-send-email-hvaibhav@ti.com>
Content-Type: text/plain
Date: Sat, 10 Jan 2009 04:41:21 +0300
Message-Id: <1231551681.4474.238.camel@tux.localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello, just two small comments if you don't mind.

On Wed, 2009-01-07 at 11:37 +0530, hvaibhav@ti.com wrote:
> From: Vaibhav Hiremath <hvaibhav@ti.com>
> 
> This is first version of OMAP3EVM Mulit-Media Daughter
> Card support.
> 
> Tested:
>     - TVP5146 (BT656) decoder interface on top of
>       Sergio's ISP-Camera patches.
>     - Loopback application, capturing image through TVP5146
>       and displaying it onto the TV/LCD on top of Hardik's
>       V4L2 driver.
>     - Basic functionality of HSUSB Transceiver USB-83320
>     -
> 
> TODO:
>     - Camera sensor support
>     - Driver header file inclusion (dependency on ISP-Camera patches)
>     - Some more clean-up may required.
> 
> Signed-off-by: Brijesh Jadav <brijesh.j@ti.com>
> Signed-off-by: Hardik Shah <hardik.shah@ti.com>
> Signed-off-by: Manjunath Hadli <mrh@ti.com>
> Signed-off-by: R Sivaraj <sivaraj@ti.com>
> Signed-off-by: Vaibhav Hiremath <hvaibhav@ti.com>
> ---
>  arch/arm/mach-omap2/Kconfig             |    4 +
>  arch/arm/mach-omap2/Makefile            |    1 +
>  arch/arm/mach-omap2/board-omap3evm-dc.c |  417 +++++++++++++++++++++++++++++++
>  arch/arm/mach-omap2/board-omap3evm-dc.h |   43 ++++
>  arch/arm/mach-omap2/mux.c               |    7 +
>  arch/arm/plat-omap/include/mach/mux.h   |    4 +
>  6 files changed, 476 insertions(+), 0 deletions(-)
>  mode change 100644 => 100755 arch/arm/mach-omap2/Kconfig
>  mode change 100644 => 100755 arch/arm/mach-omap2/Makefile
>  create mode 100755 arch/arm/mach-omap2/board-omap3evm-dc.c
>  create mode 100755 arch/arm/mach-omap2/board-omap3evm-dc.h
>  mode change 100644 => 100755 arch/arm/mach-omap2/mux.c
>  mode change 100644 => 100755 arch/arm/plat-omap/include/mach/mux.h
> 
> diff --git a/arch/arm/mach-omap2/Kconfig b/arch/arm/mach-omap2/Kconfig
> old mode 100644
> new mode 100755
> index ca24a7a..094c97f
> --- a/arch/arm/mach-omap2/Kconfig
> +++ b/arch/arm/mach-omap2/Kconfig
> @@ -121,6 +121,10 @@ config MACH_OMAP3EVM
>  	bool "OMAP 3530 EVM board"
>  	depends on ARCH_OMAP3 && ARCH_OMAP34XX
> 
> +config MACH_OMAP3EVM_DC
> +	bool "OMAP 3530 EVM daughter card board"
> +	depends on ARCH_OMAP3 && ARCH_OMAP34XX && MACH_OMAP3EVM
> +
>  config MACH_OMAP3_BEAGLE
>  	bool "OMAP3 BEAGLE board"
>  	depends on ARCH_OMAP3 && ARCH_OMAP34XX
> diff --git a/arch/arm/mach-omap2/Makefile b/arch/arm/mach-omap2/Makefile
> old mode 100644
> new mode 100755
> index 3897347..16fa35a
> --- a/arch/arm/mach-omap2/Makefile
> +++ b/arch/arm/mach-omap2/Makefile
> @@ -60,6 +60,7 @@ obj-$(CONFIG_MACH_OMAP3EVM)		+= board-omap3evm.o \
>  					   usb-musb.o usb-ehci.o \
>  					   board-omap3evm-flash.o \
>  					   twl4030-generic-scripts.o
> +obj-$(CONFIG_MACH_OMAP3EVM_DC)		+= board-omap3evm-dc.o
>  obj-$(CONFIG_MACH_OMAP3_BEAGLE)		+= board-omap3beagle.o \
>  					   usb-musb.o usb-ehci.o \
>  					   mmc-twl4030.o \
> diff --git a/arch/arm/mach-omap2/board-omap3evm-dc.c b/arch/arm/mach-omap2/board-omap3evm-dc.c
> new file mode 100755
> index 0000000..233c219
> --- /dev/null
> +++ b/arch/arm/mach-omap2/board-omap3evm-dc.c
> @@ -0,0 +1,417 @@
> +/*
> + * arch/arm/mach-omap2/board-omap3evm-dc.c
> + *
> + * Driver for OMAP3 EVM Daughter Card
> + *
> + * Copyright (C) 2008 Texas Instruments Inc
> + * Author: Vaibhav Hiremath <hvaibhav@ti.com>
> + *
> + * Contributors:
> + *     Anuj Aggarwal <anuj.aggarwal@ti.com>
> + *     Sivaraj R <sivaraj@ti.com>
> + *
> + * This package is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program; if not, write to the Free Software
> + * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
> + *
> + */
> +
> +#include <linux/module.h>
> +#include <linux/kernel_stat.h>
> +#include <linux/init.h>
> +#include <linux/i2c.h>
> +#include <linux/delay.h>
> +#include <linux/spinlock.h>
> +#include <linux/clk.h>
> +#include <linux/device.h>
> +#include <linux/io.h>
> +#include <linux/gpio.h>
> +
> +#include <mach/io.h>
> +#include <mach/mux.h>
> +
> +#if defined(CONFIG_VIDEO_TVP514X) || defined(CONFIG_VIDEO_TVP514X_MODULE)
> +#include <linux/videodev2.h>
> +#include <media/v4l2-int-device.h>
> +#include <media/tvp514x.h>
> +/* include V4L2 camera driver related header file */
> +#if defined(CONFIG_VIDEO_OMAP3) || defined(CONFIG_VIDEO_OMAP3_MODULE)
> +#include <../drivers/media/video/omap34xxcam.h>
> +#include <../drivers/media/video/isp/ispreg.h>
> +#endif				/* #ifdef CONFIG_VIDEO_OMAP3 */
> +#endif				/* #ifdef CONFIG_VIDEO_TVP514X*/
> +
> +#include "board-omap3evm-dc.h"
> +
> +#define MODULE_NAME			"omap3evmdc"
> +
> +#ifdef DEBUG
> +#define dprintk(fmt, args...) printk(KERN_ERR MODULE_NAME ": " fmt, ## args)
> +#else
> +#define dprintk(fmt, args...)
> +#endif				/* #ifdef DEBUG */
> +
> +/* Macro Definitions */
> +
> +/* System control module register offsets */
> +#define REG_CONTROL_PADCONF_I2C2_SDA	(0x480021C0u)
> +#define REG_CONTROL_PADCONF_I2C3_SDA	(0x480021C4u)
> +
> +#define PADCONF_I2C3_SCL_MASK		(0xFFFF0000u)
> +#define PADCONF_I2C3_SDA_MASK		(0x0000FFFFu)
> +
> +/* mux mode 0 (enable I2C3 SCL), pull-up enable, input enable */
> +#define PADCONF_I2C3_SCL_DEF		(0x01180000u)
> +/* mux mode 0 (enable I2C3 SDA), pull-up enable, input enable */
> +#define PADCONF_I2C3_SDA_DEF		(0x00000118u)
> +
> +/* GPIO pins */
> +#define GPIO134_SEL_Y                   (134)
> +#define GPIO54_SEL_EXP_CAM              (54)
> +#define GPIO136_SEL_CAM                 (136)
> +
> +/* board internal information (BEGIN) */
> +
> +/* I2C bus to which all I2C slave devices are attached */
> +#define BOARD_I2C_BUSNUM		(3)
> +
> +/* I2C address of chips present in board */
> +#define TVP5146_I2C_ADDR		(0x5D)
> +
> +/* Register offsets */
> +#define REG_BUS_CTRL1			(0x00000180u)
> +#define REG_BUS_CTRL2			(0x000001C0u)
> +
> +/* Bit defines for Bus Control 1 register */
> +#define TVP5146_EN_SHIFT		(0x0000u)
> +#define TVP5146_EN_MASK			(1u << TVP5146_EN_SHIFT)
> +
> +#define CAMERA_SENSOR_EN_SHIFT		(0x0008u)
> +#define CAMERA_SENSOR_EN_MASK		(1u << CAMERA_SENSOR_EN_SHIFT)
> +
> +/* default value for bus control registers */
> +#define BUS_CONTROL1_DEF		(0x0141u)	/* Disable all mux */
> +#define BUS_CONTROL2_DEF		(0x010Au)	/* Disable all mux */
> +
> +#if defined(CONFIG_VIDEO_TVP514X) || defined(CONFIG_VIDEO_TVP514X_MODULE)
> +#if defined(CONFIG_VIDEO_OMAP3) || defined(CONFIG_VIDEO_OMAP3_MODULE)
> +static struct omap34xxcam_hw_config decoder_hwc = {
> +	.dev_index = 0,
> +	.dev_minor = 0,
> +	.dev_type = OMAP34XXCAM_SLAVE_SENSOR,
> +	.u.sensor.xclk = OMAP34XXCAM_XCLK_NONE,
> +	.u.sensor.sensor_isp = 1,
> +};
> +
> +static struct isp_interface_config tvp5146_if_config = {
> +	.ccdc_par_ser = ISP_PARLL_YUV_BT,
> +	.dataline_shift = 0x1,
> +	.hsvs_syncdetect = ISPCTRL_SYNC_DETECT_VSRISE,
> +	.vdint0_timing = 0x0,
> +	.vdint1_timing = 0x0,
> +	.strobe = 0x0,
> +	.prestrobe = 0x0,
> +	.shutter = 0x0,
> +	.u.par.par_bridge = 0x0,
> +	.u.par.par_clk_pol = 0x0,
> +};
> +#endif
> +
> +static struct v4l2_ifparm ifparm = {
> +	.if_type = V4L2_IF_TYPE_BT656,
> +	.u = {
> +	      .bt656 = {
> +			.frame_start_on_rising_vs = 1,
> +			.bt_sync_correct = 0,
> +			.swap = 0,
> +			.latch_clk_inv = 0,
> +			.nobt_hs_inv = 0,	/* active high */
> +			.nobt_vs_inv = 0,	/* active high */
> +			.mode = V4L2_IF_TYPE_BT656_MODE_BT_8BIT,
> +			.clock_min = TVP514X_XCLK_BT656,
> +			.clock_max = TVP514X_XCLK_BT656,
> +			},
> +	      },
> +};
> +
> +/**
> + * @brief tvp5146_ifparm - Returns the TVP5146 decoder interface parameters
> + *
> + * @param p - pointer to v4l2_ifparm structure
> + *
> + * @return result of operation - 0 is success
> + */
> +static int tvp5146_ifparm(struct v4l2_ifparm *p)
> +{
> +	if (p == NULL)
> +		return -EINVAL;
> +
> +	*p = ifparm;
> +	return 0;
> +}
> +
> +/**
> + * @brief tvp5146_set_prv_data - Returns tvp5146 omap34xx driver private data
> + *
> + * @param priv - pointer to omap34xxcam_hw_config structure
> + *
> + * @return result of operation - 0 is success
> + */
> +static int tvp5146_set_prv_data(void *priv)
> +{
> +#if defined(CONFIG_VIDEO_OMAP3) || defined(CONFIG_VIDEO_OMAP3_MODULE)
> +	struct omap34xxcam_hw_config *hwc = priv;
> +
> +	if (priv == NULL)
> +		return -EINVAL;
> +
> +	hwc->u.sensor.sensor_isp = decoder_hwc.u.sensor.sensor_isp;
> +	hwc->u.sensor.xclk = decoder_hwc.u.sensor.xclk;
> +	hwc->dev_index = decoder_hwc.dev_index;
> +	hwc->dev_minor = decoder_hwc.dev_minor;
> +	hwc->dev_type = decoder_hwc.dev_type;
> +	return 0;
> +#else
> +	return -EINVAL;
> +#endif
> +}
> +
> +/**
> + * @brief omap3evmdc_set_mux - Sets mux to enable/disable signal routing to
> + *                             different peripherals present in board
> + * IMPORTANT - This function will take care of writing appropriate values for
> + * active low signals as well
> + *
> + * @param mux_id - enum, mux id to enable/disable
> + * @param value - enum, ENABLE_MUX for enabling and DISABLE_MUX for disabling
> + *
> + * @return result of operation - 0 is success
> + */
> +static int omap3evmdc_set_mux(enum omap3evmdc_mux mux_id, enum config_mux value)
> +{
> +	int err = 0;
> +
> +	if (unlikely(mux_id >= NUM_MUX)) {
> +		dprintk("Invalid mux id\n");

You have a lot of dprintk messages. May be it's better to move "\n" to
dprintk definition? And use dprintk without \n.
Probably, makes your life easier :)

> +		return -EPERM;
> +	}
> +
> +
> +	switch (mux_id) {
> +	case MUX_TVP5146:
> +		/* active low signal. set 0 to enable, 1 to disable */
> +		if (ENABLE_MUX == value) {
> +			/* pull down the GPIO GPIO134 = 0 */
> +			gpio_set_value(GPIO134_SEL_Y, 0);
> +			/* pull up the GPIO GPIO54 = 1 */
> +			gpio_set_value(GPIO54_SEL_EXP_CAM, 1);
> +			/* pull up the GPIO GPIO136 = 1 */
> +			gpio_set_value(GPIO136_SEL_CAM, 1);
> +		} else
> +			/* pull up the GPIO GPIO134 = 0 */
> +			gpio_set_value(GPIO134_SEL_Y, 1);

Well, please chech the Documentation/CodingStyle file.
Comments there say that you should use bracers with else expression
(statement?) also. Care to reformat the patch that it will look like:

if (ENABLE_MUX == value) {
	/* pull down the GPIO GPIO134 = 0 */
	gpio_set_value(GPIO134_SEL_Y, 0);
	/* pull up the GPIO GPIO54 = 1 */
	gpio_set_value(GPIO54_SEL_EXP_CAM, 1);
	/* pull up the GPIO GPIO136 = 1 */
	gpio_set_value(GPIO136_SEL_CAM, 1);
} else {
	/* pull up the GPIO GPIO134 = 0 */
	gpio_set_value(GPIO134_SEL_Y, 1);
}

?
You can check Chapter 2 of CodingStyle (lines number 170-180) about
that. 

<snip>

No more suggestions.

> --
> To unsubscribe from this list: send the line "unsubscribe linux-media"
> in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Best regards, Klimov Alexey

