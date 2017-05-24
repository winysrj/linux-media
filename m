Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:36367 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1161079AbdEXXOV (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 24 May 2017 19:14:21 -0400
From: "Yang, Hyungwoo" <hyungwoo.yang@intel.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "sakari.ailus@linux.intel.com" <sakari.ailus@linux.intel.com>,
        "Zheng, Jian Xu" <jian.xu.zheng@intel.com>
Subject: RE: [PATCH 1/1] [media] i2c: add support for OV13858 sensor
Date: Wed, 24 May 2017 23:13:50 +0000
Message-ID: <7A4F467111FEF64486F40DFE7DF3500A03E99242@ORSMSX111.amr.corp.intel.com>
References: <1495583908-2479-1-git-send-email-hyungwoo.yang@intel.com>
 <20170524125111.GJ29527@valkosipuli.retiisi.org.uk>
In-Reply-To: <20170524125111.GJ29527@valkosipuli.retiisi.org.uk>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

Thank you for the review, I've left my comments below. I'll submit v2 soon.

-Hyungwoo

-----Original Message-----
From: Sakari Ailus [mailto:sakari.ailus@iki.fi] 
Sent: Wednesday, May 24, 2017 5:51 AM
To: Yang, Hyungwoo <hyungwoo.yang@intel.com>
Cc: linux-media@vger.kernel.org; sakari.ailus@linux.intel.com; Zheng, Jian Xu <jian.xu.zheng@intel.com>
Subject: Re: [PATCH 1/1] [media] i2c: add support for OV13858 sensor
> Hi Hyungwoo,
> 
> Thanks for the patch. Please see my comments below.
> 
> On Tue, May 23, 2017 at 04:58:28PM -0700, Hyungwoo Yang wrote:
> > This patch adds driver for Omnivision's ov13858 sensor, the driver 
> > supports following features:
> > 
> > - manual exposure/analog gain
> > - two link frequencies
> > - media controller support
> > - runtime pm support
> > 
> > Signed-off-by: Hyungwoo Yang <hyungwoo.yang@intel.com>
> > ---
> >  drivers/media/i2c/Kconfig   |    8 +
> >  drivers/media/i2c/Makefile  |    1 +
> >  drivers/media/i2c/ov13858.c | 1853 
> > +++++++++++++++++++++++++++++++++++++++++++
> >  3 files changed, 1862 insertions(+)
> >  create mode 100644 drivers/media/i2c/ov13858.c
> > 
> > diff --git a/drivers/media/i2c/Kconfig b/drivers/media/i2c/Kconfig 
> > index fd181c9..f8c5cca 100644
> > --- a/drivers/media/i2c/Kconfig
> > +++ b/drivers/media/i2c/Kconfig
> > @@ -589,6 +589,14 @@ config VIDEO_OV9650
> >  	  This is a V4L2 sensor-level driver for the Omnivision
> >  	  OV9650 and OV9652 camera sensors.
> >  
> > +config VIDEO_OV13858
> > +	tristate "OmniVision OV13858 sensor support"
> > +	depends on I2C && VIDEO_V4L2 && VIDEO_V4L2_SUBDEV_API
> > +	depends on MEDIA_CAMERA_SUPPORT
> > +	---help---
> > +	  This is a Video4Linux2 sensor-level driver for the OmniVision
> > +	  OV13858 camera.
> > +
> >  config VIDEO_VS6624
> >  	tristate "ST VS6624 sensor support"
> >  	depends on VIDEO_V4L2 && I2C
> > diff --git a/drivers/media/i2c/Makefile b/drivers/media/i2c/Makefile 
> > index 62323ec..3f4dc02 100644
> > --- a/drivers/media/i2c/Makefile
> > +++ b/drivers/media/i2c/Makefile
> > @@ -63,6 +63,7 @@ obj-$(CONFIG_VIDEO_OV5647) += ov5647.o
> >  obj-$(CONFIG_VIDEO_OV7640) += ov7640.o
> >  obj-$(CONFIG_VIDEO_OV7670) += ov7670.o
> >  obj-$(CONFIG_VIDEO_OV9650) += ov9650.o
> > +obj-$(CONFIG_VIDEO_OV13858) += ov13858.o
> >  obj-$(CONFIG_VIDEO_MT9M032) += mt9m032.o
> >  obj-$(CONFIG_VIDEO_MT9M111) += mt9m111.o
> >  obj-$(CONFIG_VIDEO_MT9P031) += mt9p031.o diff --git 
> > a/drivers/media/i2c/ov13858.c b/drivers/media/i2c/ov13858.c new file 
> > mode 100644 index 0000000..7fc735e
> > --- /dev/null
> > +++ b/drivers/media/i2c/ov13858.c
> > @@ -0,0 +1,1853 @@
> > +/*
> > + * Copyright (c) 2017 Intel Corporation.
> > + *
> > + * This program is free software; you can redistribute it and/or
> > + * modify it under the terms of the GNU General Public License 
> > +version
> > + * 2 as published by the Free Software Foundation.
> > + *
> > + * This program is distributed in the hope that it will be useful,
> > + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> > + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
> > + * GNU General Public License for more details.
> > + *
> > + */
> > +
> > +#include <linux/acpi.h>
> > +#include <linux/i2c.h>
> > +#include <linux/module.h>
> > +#include <linux/pm_runtime.h>
> > +#include <media/v4l2-ctrls.h>
> > +#include <media/v4l2-device.h>
> > +
> > +#define OV13858_REG_VALUE_08BIT		1
> > +#define OV13858_REG_VALUE_16BIT		2
> > +#define OV13858_REG_VALUE_24BIT		3
> > +
> > +#define OV13858_REG_MODE_SELECT		0x0100
> > +#define OV13858_MODE_STANDBY		0x00
> > +#define OV13858_MODE_STREAMING		0x01
> > +
> > +#define OV13858_REG_SOFTWARE_RST	0x0103
> > +#define OV13858_SOFTWARE_RST		0x01
> > +
> > +/* PLL1 generates PCLK and MIPI_PHY_CLK */
> > +#define OV13858_REG_PLL1_CTRL_0		0x0300
> > +#define OV13858_REG_PLL1_CTRL_1		0x0301
> > +#define OV13858_REG_PLL1_CTRL_2		0x0302
> > +#define OV13858_REG_PLL1_CTRL_3		0x0303
> > +#define OV13858_REG_PLL1_CTRL_4		0x0304
> > +#define OV13858_REG_PLL1_CTRL_5		0x0305
> > +
> > +/* PLL2 generates DAC_CLK, SCLK and SRAM_CLK */
> > +#define OV13858_REG_PLL2_CTRL_B		0x030b
> > +#define OV13858_REG_PLL2_CTRL_C		0x030c
> > +#define OV13858_REG_PLL2_CTRL_D		0x030d
> > +#define OV13858_REG_PLL2_CTRL_E		0x030e
> > +#define OV13858_REG_PLL2_CTRL_F		0x030f
> > +#define OV13858_REG_PLL2_CTRL_12	0x0312
> > +#define OV13858_REG_MIPI_SC_CTRL0	0x3016
> > +#define OV13858_REG_MIPI_SC_CTRL1	0x3022
> > +
> > +/* Chip ID */
> > +#define OV13858_REG_CHIP_ID		0x300a
> > +#define OV13858_CHIP_ID			0x00d855
> > +
> > +/* Group access */
> > +#define OV13858_REG_GROUP_ACCESS	0x3208
> > +#define OV13858_GROUP_HOLD_START(g_id)	(0x00 | (g_id))
> > +#define OV13858_GROUP_HOLD_END(g_id)	(0x10 | (g_id))
> > +#define OV13858_GROUP_LAUNCH(g_id)	(0xa0 | (g_id))
> > +#define OV13858_GROUP_FAST_LAUNCH(g_id)	(0xe0 | (g_id))
> > +
> > +/* H-/V-offset control for expected bayer order */
> > +#define OV13858_REG_H_OFFSET		0x3810
> > +#define OV13858_REG_V_OFFSET		0x3812
> > +
> > +/* V-timing internal */
> > +#define OV13858_REG_VTS			0x380e
> > +#define OV13858_VTS_30FPS		0x0c8e /* 30 fps */
> > +#define OV13858_VTS_60FPS		0x0648 /* 60 fps */
> > +#define OV13858_VTS_MAX			0x7fff
> > +
> > +/* Exposure control */
> > +#define OV13858_REG_EXPOSURE		0x3500
> > +#define OV13858_EXP_GAIN_MIN		4
> > +#define OV13858_EXP_GAIN_MAX		(OV13858_VTS_MAX - 8)
> > +#define OV13858_EXP_GAIN_STEP		1
> > +#define OV13858_EXP_GAIN_DEFAULT	0x640
> > +
> > +/* Analog gain control */
> > +#define OV13858_REG_ANALOG_GAIN		0x3508
> > +#define OV13858_ANA_GAIN_MIN		0
> > +#define OV13858_ANA_GAIN_MAX		0x1fff
> > +#define OV13858_ANA_GAIN_STEP		1
> > +#define OV13858_ANA_GAIN_DEFAULT	0x80
> > +
> > +/* Number of frames to skip */
> > +#define OV13858_NUM_OF_SKIP_FRAMES	2
> > +
> > +struct ov13858_reg {
> > +	u16 address;
> > +	u8 val;
> > +};
> > +
> > +struct ov13858_reg_list {
> > +	u32 num_of_regs;
> > +	const struct ov13858_reg *regs;
> > +};
> > +
> > +/* Link frequency config */
> > +struct ov13858_link_freq_config {
> > +	u32 pixel_rate;
> > +
> > +	/* PLL registers for this link frequency */
> > +	struct ov13858_reg_list reg_list;
> > +};
> > +
> > +/* Mode : resolution and related config&values */ struct ov13858_mode 
> > +{
> > +	/* Frame width */
> > +	u32 width;
> > +	/* Frame height */
> > +	u32 height;
> > +
> > +	/* V-timing */
> > +	u32 vts;
> > +
> > +	/* Index of Link frequency config to be used */
> > +	u32 link_freq_index;
> > +	/* Default register values */
> > +	struct ov13858_reg_list reg_list;
> > +};
> > +
> > +/* 4224x3136 needs 1080Mbps/lane, 4 lanes */ static const struct 
> > +ov13858_reg mipi_data_rate_1080mbps[] = {
> > +	/* PLL1 registers */
> > +	{OV13858_REG_PLL1_CTRL_0, 0x07},
> > +	{OV13858_REG_PLL1_CTRL_1, 0x01},
> > +	{OV13858_REG_PLL1_CTRL_2, 0xc2},
> > +	{OV13858_REG_PLL1_CTRL_3, 0x00},
> > +	{OV13858_REG_PLL1_CTRL_4, 0x00},
> > +	{OV13858_REG_PLL1_CTRL_5, 0x01},
> > +
> > +	/* PLL2 registers */
> > +	{OV13858_REG_PLL2_CTRL_B, 0x05},
> > +	{OV13858_REG_PLL2_CTRL_C, 0x01},
> > +	{OV13858_REG_PLL2_CTRL_D, 0x0e},
> > +	{OV13858_REG_PLL2_CTRL_E, 0x05},
> > +	{OV13858_REG_PLL2_CTRL_F, 0x01},
> > +	{OV13858_REG_PLL2_CTRL_12, 0x01},
> > +	{OV13858_REG_MIPI_SC_CTRL0, 0x72},
> > +	{OV13858_REG_MIPI_SC_CTRL1, 0x01},
> > +};
> > +
> > +/*
> > + * 2112x1568, 2112x1188, 1056x784 need 540Mbps/lane,
> > + * 4 lanes
> > + */
> > +static const struct ov13858_reg mipi_data_rate_540mbps[] = {
> > +	/* PLL1 registers */
> > +	{OV13858_REG_PLL1_CTRL_0, 0x07},
> > +	{OV13858_REG_PLL1_CTRL_1, 0x01},
> > +	{OV13858_REG_PLL1_CTRL_2, 0xc2},
> > +	{OV13858_REG_PLL1_CTRL_3, 0x01},
> > +	{OV13858_REG_PLL1_CTRL_4, 0x00},
> > +	{OV13858_REG_PLL1_CTRL_5, 0x01},
> > +
> > +	/* PLL2 registers */
> > +	{OV13858_REG_PLL2_CTRL_B, 0x05},
> > +	{OV13858_REG_PLL2_CTRL_C, 0x01},
> > +	{OV13858_REG_PLL2_CTRL_D, 0x0e},
> > +	{OV13858_REG_PLL2_CTRL_E, 0x05},
> > +	{OV13858_REG_PLL2_CTRL_F, 0x01},
> > +	{OV13858_REG_PLL2_CTRL_12, 0x01},
> > +	{OV13858_REG_MIPI_SC_CTRL0, 0x72},
> > +	{OV13858_REG_MIPI_SC_CTRL1, 0x01},
> > +};
> > +
> > +static const struct ov13858_reg mode_4224x3136_regs[] = {
> > +	{0x3013, 0x32},
> > +	{0x301b, 0xf0},
> > +	{0x301f, 0xd0},
> > +	{0x3106, 0x15},
> > +	{0x3107, 0x23},
> > +	{0x350a, 0x00},
> > +	{0x350e, 0x00},
> > +	{0x3510, 0x00},
> > +	{0x3511, 0x02},
> > +	{0x3512, 0x00},
> > +	{0x3600, 0x2b},
> > +	{0x3601, 0x52},
> > +	{0x3602, 0x60},
> > +	{0x3612, 0x05},
> > +	{0x3613, 0xa4},
> > +	{0x3620, 0x80},
> > +	{0x3621, 0x10},
> > +	{0x3622, 0x30},
> > +	{0x3624, 0x1c},
> > +	{0x3640, 0x10},
> > +	{0x3641, 0x70},
> > +	{0x3661, 0x80},
> > +	{0x3662, 0x12},
> > +	{0x3664, 0x73},
> > +	{0x3665, 0xa7},
> > +	{0x366e, 0xff},
> > +	{0x366f, 0xf4},
> > +	{0x3674, 0x00},
> > +	{0x3679, 0x0c},
> > +	{0x367f, 0x01},
> > +	{0x3680, 0x0c},
> > +	{0x3681, 0x50},
> > +	{0x3682, 0x50},
> > +	{0x3683, 0xa9},
> > +	{0x3684, 0xa9},
> > +	{0x3709, 0x5f},
> > +	{0x3714, 0x24},
> > +	{0x371a, 0x3e},
> > +	{0x3737, 0x04},
> > +	{0x3738, 0xcc},
> > +	{0x3739, 0x12},
> > +	{0x373d, 0x26},
> > +	{0x3764, 0x20},
> > +	{0x3765, 0x20},
> > +	{0x37a1, 0x36},
> > +	{0x37a8, 0x3b},
> > +	{0x37ab, 0x31},
> > +	{0x37c2, 0x04},
> > +	{0x37c3, 0xf1},
> > +	{0x37c5, 0x00},
> > +	{0x37d8, 0x03},
> > +	{0x37d9, 0x0c},
> > +	{0x37da, 0xc2},
> > +	{0x37dc, 0x02},
> > +	{0x37e0, 0x00},
> > +	{0x37e1, 0x0a},
> > +	{0x37e2, 0x14},
> > +	{0x37e3, 0x04},
> > +	{0x37e4, 0x2a},
> > +	{0x37e5, 0x03},
> > +	{0x37e6, 0x04},
> > +	{0x3800, 0x00},
> > +	{0x3801, 0x00},
> > +	{0x3802, 0x00},
> > +	{0x3803, 0x00},
> > +	{0x3804, 0x10},
> > +	{0x3805, 0x9f},
> > +	{0x3806, 0x0c},
> > +	{0x3807, 0x5f},
> > +	{0x3808, 0x10},
> > +	{0x3809, 0x80},
> > +	{0x380a, 0x0c},
> > +	{0x380b, 0x40},
> > +	{0x380c, 0x04},
> > +	{0x380d, 0x62},
> > +	{0x380e, 0x0c},
> > +	{0x380f, 0x8e},
> > +	{0x3811, 0x04},
> > +	{0x3813, 0x05},
> > +	{0x3814, 0x01},
> > +	{0x3815, 0x01},
> > +	{0x3816, 0x01},
> > +	{0x3817, 0x01},
> > +	{0x3820, 0xa8},
> > +	{0x3821, 0x00},
> > +	{0x3822, 0xc2},
> > +	{0x3823, 0x18},
> > +	{0x3826, 0x11},
> > +	{0x3827, 0x1c},
> > +	{0x3829, 0x03},
> > +	{0x3832, 0x00},
> > +	{0x3c80, 0x00},
> > +	{0x3c87, 0x01},
> > +	{0x3c8c, 0x19},
> > +	{0x3c8d, 0x1c},
> > +	{0x3c90, 0x00},
> > +	{0x3c91, 0x00},
> > +	{0x3c92, 0x00},
> > +	{0x3c93, 0x00},
> > +	{0x3c94, 0x40},
> > +	{0x3c95, 0x54},
> > +	{0x3c96, 0x34},
> > +	{0x3c97, 0x04},
> > +	{0x3c98, 0x00},
> > +	{0x3d8c, 0x73},
> > +	{0x3d8d, 0xc0},
> > +	{0x3f00, 0x0b},
> > +	{0x3f03, 0x00},
> > +	{0x4001, 0xe0},
> > +	{0x4008, 0x00},
> > +	{0x4009, 0x0f},
> > +	{0x4011, 0xf0},
> > +	{0x4017, 0x08},
> > +	{0x4050, 0x04},
> > +	{0x4051, 0x0b},
> > +	{0x4052, 0x00},
> > +	{0x4053, 0x80},
> > +	{0x4054, 0x00},
> > +	{0x4055, 0x80},
> > +	{0x4056, 0x00},
> > +	{0x4057, 0x80},
> > +	{0x4058, 0x00},
> > +	{0x4059, 0x80},
> > +	{0x405e, 0x20},
> > +	{0x4500, 0x07},
> > +	{0x4503, 0x00},
> > +	{0x450a, 0x04},
> > +	{0x4809, 0x04},
> > +	{0x480c, 0x12},
> > +	{0x481f, 0x30},
> > +	{0x4833, 0x10},
> > +	{0x4837, 0x0e},
> > +	{0x4902, 0x01},
> > +	{0x4d00, 0x03},
> > +	{0x4d01, 0xc9},
> > +	{0x4d02, 0xbc},
> > +	{0x4d03, 0xd7},
> > +	{0x4d04, 0xf0},
> > +	{0x4d05, 0xa2},
> > +	{0x5000, 0xfd},
> > +	{0x5001, 0x01},
> > +	{0x5040, 0x39},
> > +	{0x5041, 0x10},
> > +	{0x5042, 0x10},
> > +	{0x5043, 0x84},
> > +	{0x5044, 0x62},
> > +	{0x5180, 0x00},
> > +	{0x5181, 0x10},
> > +	{0x5182, 0x02},
> > +	{0x5183, 0x0f},
> > +	{0x5200, 0x1b},
> > +	{0x520b, 0x07},
> > +	{0x520c, 0x0f},
> > +	{0x5300, 0x04},
> > +	{0x5301, 0x0c},
> > +	{0x5302, 0x0c},
> > +	{0x5303, 0x0f},
> > +	{0x5304, 0x00},
> > +	{0x5305, 0x70},
> > +	{0x5306, 0x00},
> > +	{0x5307, 0x80},
> > +	{0x5308, 0x00},
> > +	{0x5309, 0xa5},
> > +	{0x530a, 0x00},
> > +	{0x530b, 0xd3},
> > +	{0x530c, 0x00},
> > +	{0x530d, 0xf0},
> > +	{0x530e, 0x01},
> > +	{0x530f, 0x10},
> > +	{0x5310, 0x01},
> > +	{0x5311, 0x20},
> > +	{0x5312, 0x01},
> > +	{0x5313, 0x20},
> > +	{0x5314, 0x01},
> > +	{0x5315, 0x20},
> > +	{0x5316, 0x08},
> > +	{0x5317, 0x08},
> > +	{0x5318, 0x10},
> > +	{0x5319, 0x88},
> > +	{0x531a, 0x88},
> > +	{0x531b, 0xa9},
> > +	{0x531c, 0xaa},
> > +	{0x531d, 0x0a},
> > +	{0x5405, 0x02},
> > +	{0x5406, 0x67},
> > +	{0x5407, 0x01},
> > +	{0x5408, 0x4a},
> > +};
> > +
> > +static const struct ov13858_reg mode_2112x1568_regs[] = {
> > +	{0x3013, 0x32},
> > +	{0x301b, 0xf0},
> > +	{0x301f, 0xd0},
> > +	{0x3106, 0x15},
> > +	{0x3107, 0x23},
> > +	{0x350a, 0x00},
> > +	{0x350e, 0x00},
> > +	{0x3510, 0x00},
> > +	{0x3511, 0x02},
> > +	{0x3512, 0x00},
> > +	{0x3600, 0x2b},
> > +	{0x3601, 0x52},
> > +	{0x3602, 0x60},
> > +	{0x3612, 0x05},
> > +	{0x3613, 0xa4},
> > +	{0x3620, 0x80},
> > +	{0x3621, 0x10},
> > +	{0x3622, 0x30},
> > +	{0x3624, 0x1c},
> > +	{0x3640, 0x10},
> > +	{0x3641, 0x70},
> > +	{0x3661, 0x80},
> > +	{0x3662, 0x10},
> > +	{0x3664, 0x73},
> > +	{0x3665, 0xa7},
> > +	{0x366e, 0xff},
> > +	{0x366f, 0xf4},
> > +	{0x3674, 0x00},
> > +	{0x3679, 0x0c},
> > +	{0x367f, 0x01},
> > +	{0x3680, 0x0c},
> > +	{0x3681, 0x50},
> > +	{0x3682, 0x50},
> > +	{0x3683, 0xa9},
> > +	{0x3684, 0xa9},
> > +	{0x3709, 0x5f},
> > +	{0x3714, 0x28},
> > +	{0x371a, 0x3e},
> > +	{0x3737, 0x08},
> > +	{0x3738, 0xcc},
> > +	{0x3739, 0x20},
> > +	{0x373d, 0x26},
> > +	{0x3764, 0x20},
> > +	{0x3765, 0x20},
> > +	{0x37a1, 0x36},
> > +	{0x37a8, 0x3b},
> > +	{0x37ab, 0x31},
> > +	{0x37c2, 0x14},
> > +	{0x37c3, 0xf1},
> > +	{0x37c5, 0x00},
> > +	{0x37d8, 0x03},
> > +	{0x37d9, 0x0c},
> > +	{0x37da, 0xc2},
> > +	{0x37dc, 0x02},
> > +	{0x37e0, 0x00},
> > +	{0x37e1, 0x0a},
> > +	{0x37e2, 0x14},
> > +	{0x37e3, 0x08},
> > +	{0x37e4, 0x38},
> > +	{0x37e5, 0x03},
> > +	{0x37e6, 0x08},
> > +	{0x3800, 0x00},
> > +	{0x3801, 0x00},
> > +	{0x3802, 0x00},
> > +	{0x3803, 0x00},
> > +	{0x3804, 0x10},
> > +	{0x3805, 0x9f},
> > +	{0x3806, 0x0c},
> > +	{0x3807, 0x5f},
> > +	{0x3808, 0x08},
> > +	{0x3809, 0x40},
> > +	{0x380a, 0x06},
> > +	{0x380b, 0x20},
> > +	{0x380c, 0x04},
> > +	{0x380d, 0x62},
> > +	{0x380e, 0x0c},
> > +	{0x380f, 0x8e},
> > +	{0x3811, 0x04},
> > +	{0x3813, 0x05},
> > +	{0x3814, 0x03},
> > +	{0x3815, 0x01},
> > +	{0x3816, 0x03},
> > +	{0x3817, 0x01},
> > +	{0x3820, 0xab},
> > +	{0x3821, 0x00},
> > +	{0x3822, 0xc2},
> > +	{0x3823, 0x18},
> > +	{0x3826, 0x04},
> > +	{0x3827, 0x90},
> > +	{0x3829, 0x07},
> > +	{0x3832, 0x00},
> > +	{0x3c80, 0x00},
> > +	{0x3c87, 0x01},
> > +	{0x3c8c, 0x19},
> > +	{0x3c8d, 0x1c},
> > +	{0x3c90, 0x00},
> > +	{0x3c91, 0x00},
> > +	{0x3c92, 0x00},
> > +	{0x3c93, 0x00},
> > +	{0x3c94, 0x40},
> > +	{0x3c95, 0x54},
> > +	{0x3c96, 0x34},
> > +	{0x3c97, 0x04},
> > +	{0x3c98, 0x00},
> > +	{0x3d8c, 0x73},
> > +	{0x3d8d, 0xc0},
> > +	{0x3f00, 0x0b},
> > +	{0x3f03, 0x00},
> > +	{0x4001, 0xe0},
> > +	{0x4008, 0x00},
> > +	{0x4009, 0x0d},
> > +	{0x4011, 0xf0},
> > +	{0x4017, 0x08},
> > +	{0x4050, 0x04},
> > +	{0x4051, 0x0b},
> > +	{0x4052, 0x00},
> > +	{0x4053, 0x80},
> > +	{0x4054, 0x00},
> > +	{0x4055, 0x80},
> > +	{0x4056, 0x00},
> > +	{0x4057, 0x80},
> > +	{0x4058, 0x00},
> > +	{0x4059, 0x80},
> > +	{0x405e, 0x20},
> > +	{0x4500, 0x07},
> > +	{0x4503, 0x00},
> > +	{0x450a, 0x04},
> > +	{0x4809, 0x04},
> > +	{0x480c, 0x12},
> > +	{0x481f, 0x30},
> > +	{0x4833, 0x10},
> > +	{0x4837, 0x1c},
> > +	{0x4902, 0x01},
> > +	{0x4d00, 0x03},
> > +	{0x4d01, 0xc9},
> > +	{0x4d02, 0xbc},
> > +	{0x4d03, 0xd7},
> > +	{0x4d04, 0xf0},
> > +	{0x4d05, 0xa2},
> > +	{0x5000, 0xfd},
> > +	{0x5001, 0x01},
> > +	{0x5040, 0x39},
> > +	{0x5041, 0x10},
> > +	{0x5042, 0x10},
> > +	{0x5043, 0x84},
> > +	{0x5044, 0x62},
> > +	{0x5180, 0x00},
> > +	{0x5181, 0x10},
> > +	{0x5182, 0x02},
> > +	{0x5183, 0x0f},
> > +	{0x5200, 0x1b},
> > +	{0x520b, 0x07},
> > +	{0x520c, 0x0f},
> > +	{0x5300, 0x04},
> > +	{0x5301, 0x0c},
> > +	{0x5302, 0x0c},
> > +	{0x5303, 0x0f},
> > +	{0x5304, 0x00},
> > +	{0x5305, 0x70},
> > +	{0x5306, 0x00},
> > +	{0x5307, 0x80},
> > +	{0x5308, 0x00},
> > +	{0x5309, 0xa5},
> > +	{0x530a, 0x00},
> > +	{0x530b, 0xd3},
> > +	{0x530c, 0x00},
> > +	{0x530d, 0xf0},
> > +	{0x530e, 0x01},
> > +	{0x530f, 0x10},
> > +	{0x5310, 0x01},
> > +	{0x5311, 0x20},
> > +	{0x5312, 0x01},
> > +	{0x5313, 0x20},
> > +	{0x5314, 0x01},
> > +	{0x5315, 0x20},
> > +	{0x5316, 0x08},
> > +	{0x5317, 0x08},
> > +	{0x5318, 0x10},
> > +	{0x5319, 0x88},
> > +	{0x531a, 0x88},
> > +	{0x531b, 0xa9},
> > +	{0x531c, 0xaa},
> > +	{0x531d, 0x0a},
> > +	{0x5405, 0x02},
> > +	{0x5406, 0x67},
> > +	{0x5407, 0x01},
> > +	{0x5408, 0x4a},
> > +};
> > +
> > +static const struct ov13858_reg mode_2112x1188_regs[] = {
> > +	{0x3013, 0x32},
> > +	{0x301b, 0xf0},
> > +	{0x301f, 0xd0},
> > +	{0x3106, 0x15},
> > +	{0x3107, 0x23},
> > +	{0x350a, 0x00},
> > +	{0x350e, 0x00},
> > +	{0x3510, 0x00},
> > +	{0x3511, 0x02},
> > +	{0x3512, 0x00},
> > +	{0x3600, 0x2b},
> > +	{0x3601, 0x52},
> > +	{0x3602, 0x60},
> > +	{0x3612, 0x05},
> > +	{0x3613, 0xa4},
> > +	{0x3620, 0x80},
> > +	{0x3621, 0x10},
> > +	{0x3622, 0x30},
> > +	{0x3624, 0x1c},
> > +	{0x3640, 0x10},
> > +	{0x3641, 0x70},
> > +	{0x3661, 0x80},
> > +	{0x3662, 0x10},
> > +	{0x3664, 0x73},
> > +	{0x3665, 0xa7},
> > +	{0x366e, 0xff},
> > +	{0x366f, 0xf4},
> > +	{0x3674, 0x00},
> > +	{0x3679, 0x0c},
> > +	{0x367f, 0x01},
> > +	{0x3680, 0x0c},
> > +	{0x3681, 0x50},
> > +	{0x3682, 0x50},
> > +	{0x3683, 0xa9},
> > +	{0x3684, 0xa9},
> > +	{0x3709, 0x5f},
> > +	{0x3714, 0x28},
> > +	{0x371a, 0x3e},
> > +	{0x3737, 0x08},
> > +	{0x3738, 0xcc},
> > +	{0x3739, 0x20},
> > +	{0x373d, 0x26},
> > +	{0x3764, 0x20},
> > +	{0x3765, 0x20},
> > +	{0x37a1, 0x36},
> > +	{0x37a8, 0x3b},
> > +	{0x37ab, 0x31},
> > +	{0x37c2, 0x14},
> > +	{0x37c3, 0xf1},
> > +	{0x37c5, 0x00},
> > +	{0x37d8, 0x03},
> > +	{0x37d9, 0x0c},
> > +	{0x37da, 0xc2},
> > +	{0x37dc, 0x02},
> > +	{0x37e0, 0x00},
> > +	{0x37e1, 0x0a},
> > +	{0x37e2, 0x14},
> > +	{0x37e3, 0x08},
> > +	{0x37e4, 0x38},
> > +	{0x37e5, 0x03},
> > +	{0x37e6, 0x08},
> > +	{0x3800, 0x00},
> > +	{0x3801, 0x00},
> > +	{0x3802, 0x01},
> > +	{0x3803, 0x84},
> > +	{0x3804, 0x10},
> > +	{0x3805, 0x9f},
> > +	{0x3806, 0x0a},
> > +	{0x3807, 0xd3},
> > +	{0x3808, 0x08},
> > +	{0x3809, 0x40},
> > +	{0x380a, 0x04},
> > +	{0x380b, 0xa4},
> > +	{0x380c, 0x04},
> > +	{0x380d, 0x62},
> > +	{0x380e, 0x0c},
> > +	{0x380f, 0x8e},
> > +	{0x3811, 0x08},
> > +	{0x3813, 0x03},
> > +	{0x3814, 0x03},
> > +	{0x3815, 0x01},
> > +	{0x3816, 0x03},
> > +	{0x3817, 0x01},
> > +	{0x3820, 0xab},
> > +	{0x3821, 0x00},
> > +	{0x3822, 0xc2},
> > +	{0x3823, 0x18},
> > +	{0x3826, 0x04},
> > +	{0x3827, 0x90},
> > +	{0x3829, 0x07},
> > +	{0x3832, 0x00},
> > +	{0x3c80, 0x00},
> > +	{0x3c87, 0x01},
> > +	{0x3c8c, 0x19},
> > +	{0x3c8d, 0x1c},
> > +	{0x3c90, 0x00},
> > +	{0x3c91, 0x00},
> > +	{0x3c92, 0x00},
> > +	{0x3c93, 0x00},
> > +	{0x3c94, 0x40},
> > +	{0x3c95, 0x54},
> > +	{0x3c96, 0x34},
> > +	{0x3c97, 0x04},
> > +	{0x3c98, 0x00},
> > +	{0x3d8c, 0x73},
> > +	{0x3d8d, 0xc0},
> > +	{0x3f00, 0x0b},
> > +	{0x3f03, 0x00},
> > +	{0x4001, 0xe0},
> > +	{0x4008, 0x00},
> > +	{0x4009, 0x0d},
> > +	{0x4011, 0xf0},
> > +	{0x4017, 0x08},
> > +	{0x4050, 0x04},
> > +	{0x4051, 0x0b},
> > +	{0x4052, 0x00},
> > +	{0x4053, 0x80},
> > +	{0x4054, 0x00},
> > +	{0x4055, 0x80},
> > +	{0x4056, 0x00},
> > +	{0x4057, 0x80},
> > +	{0x4058, 0x00},
> > +	{0x4059, 0x80},
> > +	{0x405e, 0x20},
> > +	{0x4500, 0x07},
> > +	{0x4503, 0x00},
> > +	{0x450a, 0x04},
> > +	{0x4809, 0x04},
> > +	{0x480c, 0x12},
> > +	{0x481f, 0x30},
> > +	{0x4833, 0x10},
> > +	{0x4837, 0x1c},
> > +	{0x4902, 0x01},
> > +	{0x4d00, 0x03},
> > +	{0x4d01, 0xc9},
> > +	{0x4d02, 0xbc},
> > +	{0x4d03, 0xd7},
> > +	{0x4d04, 0xf0},
> > +	{0x4d05, 0xa2},
> > +	{0x5000, 0xfd},
> > +	{0x5001, 0x01},
> > +	{0x5040, 0x39},
> > +	{0x5041, 0x10},
> > +	{0x5042, 0x10},
> > +	{0x5043, 0x84},
> > +	{0x5044, 0x62},
> > +	{0x5180, 0x00},
> > +	{0x5181, 0x10},
> > +	{0x5182, 0x02},
> > +	{0x5183, 0x0f},
> > +	{0x5200, 0x1b},
> > +	{0x520b, 0x07},
> > +	{0x520c, 0x0f},
> > +	{0x5300, 0x04},
> > +	{0x5301, 0x0c},
> > +	{0x5302, 0x0c},
> > +	{0x5303, 0x0f},
> > +	{0x5304, 0x00},
> > +	{0x5305, 0x70},
> > +	{0x5306, 0x00},
> > +	{0x5307, 0x80},
> > +	{0x5308, 0x00},
> > +	{0x5309, 0xa5},
> > +	{0x530a, 0x00},
> > +	{0x530b, 0xd3},
> > +	{0x530c, 0x00},
> > +	{0x530d, 0xf0},
> > +	{0x530e, 0x01},
> > +	{0x530f, 0x10},
> > +	{0x5310, 0x01},
> > +	{0x5311, 0x20},
> > +	{0x5312, 0x01},
> > +	{0x5313, 0x20},
> > +	{0x5314, 0x01},
> > +	{0x5315, 0x20},
> > +	{0x5316, 0x08},
> > +	{0x5317, 0x08},
> > +	{0x5318, 0x10},
> > +	{0x5319, 0x88},
> > +	{0x531a, 0x88},
> > +	{0x531b, 0xa9},
> > +	{0x531c, 0xaa},
> > +	{0x531d, 0x0a},
> > +	{0x5405, 0x02},
> > +	{0x5406, 0x67},
> > +	{0x5407, 0x01},
> > +	{0x5408, 0x4a},
> > +};
> > +
> > +static const struct ov13858_reg mode_1056x784_regs[] = {
> > +	{0x3013, 0x32},
> > +	{0x301b, 0xf0},
> > +	{0x301f, 0xd0},
> > +	{0x3106, 0x15},
> > +	{0x3107, 0x23},
> > +	{0x350a, 0x00},
> > +	{0x350e, 0x00},
> > +	{0x3510, 0x00},
> > +	{0x3511, 0x02},
> > +	{0x3512, 0x00},
> > +	{0x3600, 0x2b},
> > +	{0x3601, 0x52},
> > +	{0x3602, 0x60},
> > +	{0x3612, 0x05},
> > +	{0x3613, 0xa4},
> > +	{0x3620, 0x80},
> > +	{0x3621, 0x10},
> > +	{0x3622, 0x30},
> > +	{0x3624, 0x1c},
> > +	{0x3640, 0x10},
> > +	{0x3641, 0x70},
> > +	{0x3661, 0x80},
> > +	{0x3662, 0x08},
> > +	{0x3664, 0x73},
> > +	{0x3665, 0xa7},
> > +	{0x366e, 0xff},
> > +	{0x366f, 0xf4},
> > +	{0x3674, 0x00},
> > +	{0x3679, 0x0c},
> > +	{0x367f, 0x01},
> > +	{0x3680, 0x0c},
> > +	{0x3681, 0x50},
> > +	{0x3682, 0x50},
> > +	{0x3683, 0xa9},
> > +	{0x3684, 0xa9},
> > +	{0x3709, 0x5f},
> > +	{0x3714, 0x30},
> > +	{0x371a, 0x3e},
> > +	{0x3737, 0x08},
> > +	{0x3738, 0xcc},
> > +	{0x3739, 0x20},
> > +	{0x373d, 0x26},
> > +	{0x3764, 0x20},
> > +	{0x3765, 0x20},
> > +	{0x37a1, 0x36},
> > +	{0x37a8, 0x3b},
> > +	{0x37ab, 0x31},
> > +	{0x37c2, 0x2c},
> > +	{0x37c3, 0xf1},
> > +	{0x37c5, 0x00},
> > +	{0x37d8, 0x03},
> > +	{0x37d9, 0x06},
> > +	{0x37da, 0xc2},
> > +	{0x37dc, 0x02},
> > +	{0x37e0, 0x00},
> > +	{0x37e1, 0x0a},
> > +	{0x37e2, 0x14},
> > +	{0x37e3, 0x08},
> > +	{0x37e4, 0x36},
> > +	{0x37e5, 0x03},
> > +	{0x37e6, 0x08},
> > +	{0x3800, 0x00},
> > +	{0x3801, 0x00},
> > +	{0x3802, 0x00},
> > +	{0x3803, 0x00},
> > +	{0x3804, 0x10},
> > +	{0x3805, 0x9f},
> > +	{0x3806, 0x0c},
> > +	{0x3807, 0x5f},
> > +	{0x3808, 0x04},
> > +	{0x3809, 0x20},
> > +	{0x380a, 0x03},
> > +	{0x380b, 0x10},
> > +	{0x380c, 0x04},
> > +	{0x380d, 0x62},
> > +	{0x380e, 0x0c},
> > +	{0x380f, 0x8e},
> > +	{0x3811, 0x04},
> > +	{0x3813, 0x05},
> > +	{0x3814, 0x07},
> > +	{0x3815, 0x01},
> > +	{0x3816, 0x07},
> > +	{0x3817, 0x01},
> > +	{0x3820, 0xac},
> > +	{0x3821, 0x00},
> > +	{0x3822, 0xc2},
> > +	{0x3823, 0x18},
> > +	{0x3826, 0x04},
> > +	{0x3827, 0x48},
> > +	{0x3829, 0x03},
> > +	{0x3832, 0x00},
> > +	{0x3c80, 0x00},
> > +	{0x3c87, 0x01},
> > +	{0x3c8c, 0x19},
> > +	{0x3c8d, 0x1c},
> > +	{0x3c90, 0x00},
> > +	{0x3c91, 0x00},
> > +	{0x3c92, 0x00},
> > +	{0x3c93, 0x00},
> > +	{0x3c94, 0x40},
> > +	{0x3c95, 0x54},
> > +	{0x3c96, 0x34},
> > +	{0x3c97, 0x04},
> > +	{0x3c98, 0x00},
> > +	{0x3d8c, 0x73},
> > +	{0x3d8d, 0xc0},
> > +	{0x3f00, 0x0b},
> > +	{0x3f03, 0x00},
> > +	{0x4001, 0xe0},
> > +	{0x4008, 0x00},
> > +	{0x4009, 0x05},
> > +	{0x4011, 0xf0},
> > +	{0x4017, 0x08},
> > +	{0x4050, 0x02},
> > +	{0x4051, 0x05},
> > +	{0x4052, 0x00},
> > +	{0x4053, 0x80},
> > +	{0x4054, 0x00},
> > +	{0x4055, 0x80},
> > +	{0x4056, 0x00},
> > +	{0x4057, 0x80},
> > +	{0x4058, 0x00},
> > +	{0x4059, 0x80},
> > +	{0x405e, 0x20},
> > +	{0x4500, 0x07},
> > +	{0x4503, 0x00},
> > +	{0x450a, 0x04},
> > +	{0x4809, 0x04},
> > +	{0x480c, 0x12},
> > +	{0x481f, 0x30},
> > +	{0x4833, 0x10},
> > +	{0x4837, 0x1e},
> > +	{0x4902, 0x02},
> > +	{0x4d00, 0x03},
> > +	{0x4d01, 0xc9},
> > +	{0x4d02, 0xbc},
> > +	{0x4d03, 0xd7},
> > +	{0x4d04, 0xf0},
> > +	{0x4d05, 0xa2},
> > +	{0x5000, 0xfd},
> > +	{0x5001, 0x01},
> > +	{0x5040, 0x39},
> > +	{0x5041, 0x10},
> > +	{0x5042, 0x10},
> > +	{0x5043, 0x84},
> > +	{0x5044, 0x62},
> > +	{0x5180, 0x00},
> > +	{0x5181, 0x10},
> > +	{0x5182, 0x02},
> > +	{0x5183, 0x0f},
> > +	{0x5200, 0x1b},
> > +	{0x520b, 0x07},
> > +	{0x520c, 0x0f},
> > +	{0x5300, 0x04},
> > +	{0x5301, 0x0c},
> > +	{0x5302, 0x0c},
> > +	{0x5303, 0x0f},
> > +	{0x5304, 0x00},
> > +	{0x5305, 0x70},
> > +	{0x5306, 0x00},
> > +	{0x5307, 0x80},
> > +	{0x5308, 0x00},
> > +	{0x5309, 0xa5},
> > +	{0x530a, 0x00},
> > +	{0x530b, 0xd3},
> > +	{0x530c, 0x00},
> > +	{0x530d, 0xf0},
> > +	{0x530e, 0x01},
> > +	{0x530f, 0x10},
> > +	{0x5310, 0x01},
> > +	{0x5311, 0x20},
> > +	{0x5312, 0x01},
> > +	{0x5313, 0x20},
> > +	{0x5314, 0x01},
> > +	{0x5315, 0x20},
> > +	{0x5316, 0x08},
> > +	{0x5317, 0x08},
> > +	{0x5318, 0x10},
> > +	{0x5319, 0x88},
> > +	{0x531a, 0x88},
> > +	{0x531b, 0xa9},
> > +	{0x531c, 0xaa},
> > +	{0x531d, 0x0a},
> > +	{0x5405, 0x02},
> > +	{0x5406, 0x67},
> > +	{0x5407, 0x01},
> > +	{0x5408, 0x4a},
> > +};
> > +
> > +/* Configurations for supported link frequencies */
> > +#define OV13858_NUM_OF_LINK_FREQS	2
> > +#define OV13858_LINK_FREQ_1080MBPS	1080000000
> > +#define OV13858_LINK_FREQ_540MBPS	540000000
> > +#define OV13858_LINK_FREQ_INDEX_0	0
> > +#define OV13858_LINK_FREQ_INDEX_1	1
> > +
> > +/* Menu items for LINK_FREQ V4L2 control */ static const const s64 
> > +link_freq_menu_items[OV13858_NUM_OF_LINK_FREQS] = {
> > +	OV13858_LINK_FREQ_1080MBPS,
> > +	OV13858_LINK_FREQ_540MBPS
> > +};
> > +
> > +/* Link frequency configs */
> > +static const struct ov13858_link_freq_config
> > +			link_freq_configs[OV13858_NUM_OF_LINK_FREQS] = {
> > +	{
> > +		.pixel_rate = 864000000,
> > +		.reg_list = {
> > +			.num_of_regs = ARRAY_SIZE(mipi_data_rate_1080mbps),
> > +			.regs = mipi_data_rate_1080mbps,
> > +		}
> > +	},
> > +	{
> > +		.pixel_rate = 432000000,
> > +		.reg_list = {
> > +			.num_of_regs = ARRAY_SIZE(mipi_data_rate_540mbps),
> > +			.regs = mipi_data_rate_540mbps,
> > +		}
> > +	}
> > +};
> > +
> > +#define OV13858_GET_PIXEL_RATE(index) 
> > +(link_freq_configs[index].pixel_rate)
> 
> Please refer to link_freq_configs directly. No really reason to have a macro.

For reason, I've done this do reduce the number of charaters in a line to have better look in 80.
Anyway, I will use it directly.

> 
> > +
> > +/* Mode configs */
> > +static const struct ov13858_mode supported_modes[] = {
> > +	{
> > +		.width = 4224,
> > +		.height = 3136,
> > +		.vts = OV13858_VTS_30FPS,
> > +		.reg_list = {
> > +			.num_of_regs = ARRAY_SIZE(mode_4224x3136_regs),
> > +			.regs = mode_4224x3136_regs,
> > +		},
> > +		.link_freq_index = OV13858_LINK_FREQ_INDEX_0,
> > +	},
> > +	{
> > +		.width = 2112,
> > +		.height = 1568,
> > +		.vts = OV13858_VTS_30FPS,
> > +		.reg_list = {
> > +			.num_of_regs = ARRAY_SIZE(mode_2112x1568_regs),
> > +			.regs = mode_2112x1568_regs,
> > +		},
> > +		.link_freq_index = OV13858_LINK_FREQ_INDEX_1,
> > +	},
> > +	{
> > +		.width = 2112,
> > +		.height = 1188,
> > +		.vts = OV13858_VTS_30FPS,
> > +		.reg_list = {
> > +			.num_of_regs = ARRAY_SIZE(mode_2112x1188_regs),
> > +			.regs = mode_2112x1188_regs,
> > +		},
> > +		.link_freq_index = OV13858_LINK_FREQ_INDEX_1,
> > +	},
> > +	{
> > +		.width = 1056,
> > +		.height = 784,
> > +		.vts = OV13858_VTS_30FPS,
> > +		.reg_list = {
> > +			.num_of_regs = ARRAY_SIZE(mode_1056x784_regs),
> > +			.regs = mode_1056x784_regs,
> > +		},
> > +		.link_freq_index = OV13858_LINK_FREQ_INDEX_1,
> > +	}
> > +};
> > +
> > +/* Supported raw bayer orders */
> > +static const u32 supported_bayer_format[] = {
> > +	MEDIA_BUS_FMT_SGRBG10_1X10,
> > +	MEDIA_BUS_FMT_SRGGB10_1X10,
> > +	MEDIA_BUS_FMT_SBGGR10_1X10,
> > +	MEDIA_BUS_FMT_SGBRG10_1X10
> > +};
> > +
> > +struct ov13858 {
> > +	struct v4l2_subdev sd;
> > +	struct media_pad pad;
> > +
> > +	struct v4l2_ctrl_handler ctrl_handler;
> > +	/* Two read only controls */
> > +	struct v4l2_ctrl *link_freq;
> > +	struct v4l2_ctrl *pixel_rate;
> > +
> > +	/* Current mode */
> > +	const struct ov13858_mode *cur_mode;
> > +
> > +	/* Current bayer format */
> > +	u32 cur_bayer_format;
> > +
> > +	/* Num of skip frames */
> > +	u32 num_of_skip_frames;
> > +
> > +	/* Mutex for serialized access */
> > +	struct mutex mutex;
> > +
> > +	/* Streaming on/off */
> > +	bool streaming;
> > +};
> > +
> > +#define to_ov13858(_sd)	container_of(_sd, struct ov13858, sd)
> > +
> > +/* Read registers up to 4 at a time */ static int 
> > +ov13858_read_reg(struct ov13858 *ov13858, u16 reg, u32 len, u32 *val) 
> > +{
> > +	struct i2c_client *client = v4l2_get_subdevdata(&ov13858->sd);
> > +	struct i2c_msg msgs[2];
> > +	u8 *data_be_p;
> > +	int ret;
> > +	u32 data_be = 0;
> > +	u16 reg_addr_be = cpu_to_be16(reg);
> > +
> > +	if (len > 4)
> > +		return -EINVAL;
> > +
> > +	data_be_p = (u8 *)&data_be;
> > +	/* Write register address */
> > +	msgs[0].addr = client->addr;
> > +	msgs[0].flags = 0;
> > +	msgs[0].len = 2;
> > +	msgs[0].buf = (u8 *)&reg_addr_be;
> > +
> > +	/* Read data from register */
> > +	msgs[1].addr = client->addr;
> > +	msgs[1].flags = I2C_M_RD;
> > +	msgs[1].len = len;
> > +	msgs[1].buf = &data_be_p[4 - len];
> > +
> > +	ret = i2c_transfer(client->adapter, msgs, ARRAY_SIZE(msgs));
> > +	if (ret != ARRAY_SIZE(msgs))
> > +		return -EIO;
> > +
> > +	*val = be32_to_cpu(data_be);
> > +
> > +	return 0;
> > +}
> > +
> > +/* Write registers up to 4 at a time */ static int 
> > +ov13858_write_reg(struct ov13858 *ov13858, u16 reg, u32 len, u32 val) 
> > +{
> > +	struct i2c_client *client = v4l2_get_subdevdata(&ov13858->sd);
> > +	int buf_i, val_i;
> > +	u8 buf[6], *val_p;
> > +
> > +	if (len > 4)
> > +		return -EINVAL;
> > +
> > +	buf[0] = reg >> 8;
> > +	buf[1] = reg & 0xff;
> > +
> > +	buf_i = 2;
> > +	val_p = (u8 *)&val;
> > +	val_i = len - 1;
> > +
> > +	while (val_i >= 0)
> > +		buf[buf_i++] = val_p[val_i--];
> > +
> > +	if (i2c_master_send(client, buf, len + 2) != len + 2)
> > +		return -EIO;
> > +
> > +	return 0;
> > +}
> > +
> > +/* Write a list of registers */
> > +static int ov13858_write_regs(struct ov13858 *ov13858,
> > +			      const struct ov13858_reg *regs, u32 len) {
> > +	struct i2c_client *client = v4l2_get_subdevdata(&ov13858->sd);
> > +	int ret;
> > +	u32 i;
> > +
> > +	for (i = 0; i < len; i++) {
> > +		ret = ov13858_write_reg(ov13858, regs[i].address, 1,
> > +					regs[i].val);
> > +		if (ret) {
> > +			dev_err_ratelimited(
> > +				&client->dev,
> > +				"Failed to write reg 0x%4.4x. error = %d\n",
> > +				regs[i].address, ret);
> > +
> > +			return ret;
> > +		}
> > +	}
> > +
> > +	return 0;
> > +}
> > +
> > +static inline int ov13858_write_reg_list(struct ov13858 *ov13858,
> 
> I'd drop inline.

if it's not mandatory for upstream, I prefer to keep inline for people who want to port this with a not-good-compiler.
Is it mandatory ?

> 
> > +					 const struct ov13858_reg_list *r_list) {
> > +	return ov13858_write_regs(ov13858, r_list->regs, 
> > +r_list->num_of_regs); }
> > +
> > +/* Open sub-device */
> > +static int ov13858_open(struct v4l2_subdev *sd, struct v4l2_subdev_fh 
> > +*fh) {
> > +	struct ov13858 *ov13858 = to_ov13858(sd);
> > +	struct v4l2_mbus_framefmt *try_fmt;
> > +
> > +	mutex_lock(&ov13858->mutex);
> > +
> > +	/* Initialize try_fmt */
> > +	try_fmt = v4l2_subdev_get_try_format(sd, fh->pad, 0);
> > +	try_fmt->width = ov13858->cur_mode->width;
> > +	try_fmt->height = ov13858->cur_mode->height;
> > +	try_fmt->code = ov13858->cur_bayer_format;
> > +	try_fmt->field = V4L2_FIELD_NONE;
> > +
> > +	/* No crop or compose */
> > +	mutex_unlock(&ov13858->mutex);
> > +
> > +	return 0;
> > +}
> > +
> > +/*
> > + * Get the index of matched bayer format  */ static int 
> > +ov13858_get_bayer_format(u32 format) {
> > +	int i;
> > +
> > +	for (i = 0; i < ARRAY_SIZE(supported_bayer_format); i++) {
> > +		if (supported_bayer_format[i] == format)
> > +			return i;
> > +	}
> > +
> > +	return -EINVAL;
> > +}
> > +
> > +/*
> > + * Start register group hold
> > + */
> > +static inline int ov13858_group_hold_start(struct ov13858 *ov13858,
> > +					   u8 group_id)
> > +{
> > +	return ov13858_write_reg(ov13858, OV13858_REG_GROUP_ACCESS,
> > +					  OV13858_REG_VALUE_08BIT,
> > +					  OV13858_GROUP_HOLD_START(group_id));
> > +}
> > +
> > +/*
> > + * End register group hold
> > + */
> > +static inline int ov13858_group_hold_end(struct ov13858 *ov13858,
> > +					 u8 group_id)
> > +{
> > +	return ov13858_write_reg(ov13858, OV13858_REG_GROUP_ACCESS,
> > +					  OV13858_REG_VALUE_08BIT,
> > +					  OV13858_GROUP_HOLD_END(group_id));
> > +}
> > +
> > +/*
> > + * Launch registers
> > + */
> > +static inline int ov13858_launch_group(struct ov13858 *ov13858,
> > +				       u8 group_id)
> > +{
> > +	return ov13858_write_reg(ov13858, OV13858_REG_GROUP_ACCESS,
> > +					  OV13858_REG_VALUE_08BIT,
> > +					  OV13858_GROUP_LAUNCH(group_id)); }
> > +
> > +/*
> > + * This function is called only after powerup to change the default 
> > +bayer order
> > + * to the user requested order.
> > + */
> > +static int ov13858_increase_offset(struct ov13858 *ov13858, u16 reg) 
> > +{
> > +	int ret;
> > +	u32 val;
> > +
> > +	ret = ov13858_read_reg(ov13858, reg, OV13858_REG_VALUE_16BIT, &val);
> > +	if (ret)
> > +		return ret;
> > +
> > +	val++;
> > +
> > +	return ov13858_write_reg(ov13858, reg, OV13858_REG_VALUE_16BIT, 
> > +val); }
> > +
> > +/*
> > + * Change the bayer order to meet the requested one.
> > + */
> > +static int ov13858_apply_bayer_order(struct ov13858 *ov13858) {
> > +	int ret;
> > +
> > +	switch (ov13858->cur_bayer_format) {
> > +	case MEDIA_BUS_FMT_SGRBG10_1X10:
> > +		break;
> > +	case MEDIA_BUS_FMT_SRGGB10_1X10:
> > +		return ov13858_increase_offset(ov13858, OV13858_REG_H_OFFSET);
> > +	case MEDIA_BUS_FMT_SGBRG10_1X10:
> > +		ret = ov13858_increase_offset(ov13858, OV13858_REG_H_OFFSET);
> 
> The bayer pixel order is defined by cropping the pixel array. If the sensor can do that, you should implement support for the crop selection rectangle instead.

Sorry, I'm new to imaging world but, as you can see, bayer order in this sensor IS DEFINED by both cropping and offset(where you start to read).
Is there a strict (implicit or explicit) rule or specific reason that we should use only crop to apply expected bayer order, even though the bayer order in the sensor is defined by both crop and offset ?

Anyway, I changed H_/V_OFFSET(0x3810, 0x3812) to H_/V_CROP_START(0x3800, 0x3802) with no changes in initial values.

> 
> I think it'd be possible to add support for that later on as well if needed.
> 
> > +		if (ret)
> > +			return ret;
> > +	/* no break, for GBRG, we need v offset too */
> > +	case MEDIA_BUS_FMT_SBGGR10_1X10:
> > +		return ov13858_increase_offset(ov13858, OV13858_REG_V_OFFSET);
> > +	}
> > +
> > +	return 0;
> > +}
> > +
> > +/*
> > + * Update analog gain
> > + */
> > +static inline int ov13858_update_analog_gain(struct ov13858 *ov13858,
> > +					     struct v4l2_ctrl *ctrl)
> > +{
> > +	return ov13858_write_reg(ov13858, OV13858_REG_ANALOG_GAIN,
> > +				 OV13858_REG_VALUE_16BIT, ctrl->val); }
> > +
> > +/* Exposure control */
> > +static int ov13858_update_exposure(struct ov13858 *ov13858,
> > +				   struct v4l2_ctrl *ctrl)
> > +{
> > +	int ret;
> > +	u32 exposure, new_vts = 0;
> > +
> > +	exposure = ctrl->val;
> > +	if (exposure > ov13858->cur_mode->vts - 8)
> > +		new_vts = exposure + 8;
> > +	else
> > +		new_vts = ov13858->cur_mode->vts;
> 
> Instead of changing the vertical blanking interval implicitly, could you do it explicitly though the VBLANK control instead?
> 
> As you do already control the vertical sync and provide the pixel rate control, how about adding a HBLANK control as well? I suppose it could be added later on as well. And presumably will be read only.

I'll introduce VBLANK control with READ ONLY and the value of the control will be updated here.

> 
> > +
> > +	ret = ov13858_group_hold_start(ov13858, 0);
> > +	if (ret)
> > +		return ret;
> > +
> > +	ret = ov13858_write_reg(ov13858, OV13858_REG_VTS,
> > +				OV13858_REG_VALUE_16BIT, new_vts);
> > +	if (ret)
> > +		return ret;
> > +
> 
> If you want group hold for that, too, we need a new callback (or two) for the control handler I believe.

I don't understand wht this means. Can you give me detail ?

> 
> > +	exposure <<= 4;
> > +	ret = ov13858_write_reg(ov13858, OV13858_REG_EXPOSURE,
> > +				OV13858_REG_VALUE_24BIT, exposure);
> > +	if (ret)
> > +		return ret;
> > +
> > +	ret = ov13858_group_hold_end(ov13858, 0);
> > +	if (ret)
> > +		return ret;
> > +
> > +	return ov13858_launch_group(ov13858, 0); }
> > +
> > +/* Initialize control handlers */
> > +static int ov13858_set_ctrl(struct v4l2_ctrl *ctrl) {
> > +	struct ov13858 *ov13858 = container_of(ctrl->handler,
> > +					       struct ov13858, ctrl_handler);
> > +	struct i2c_client *client = v4l2_get_subdevdata(&ov13858->sd);
> > +	int ret = 0;
> 
> No need to initialise ret.

Done.

> 
> > +
> > +	/* Values of V4L2 controls will be applied only when power is up */
> > +	if (atomic_read(&client->dev.power.usage_count) == 0)
> 
> I wonder if using pm_runtime_active() would work for this. Checking the usage_count directly does not look like something a driver should be doing.

Agree, I really wanted to use any helper(accesor) method for this but when I checked the pm_runtime_active() it wasn't good enough.
Anyway I just found better one for this case.
I'll not use using usage_count and instread of using pm_runtime_get_sync, I'll use pm_runtime_get_if_in_use() 

> 
> > +		return 0;
> > +
> > +	ret = pm_runtime_get_sync(&client->dev);
> > +	if (ret < 0) {
> > +		pm_runtime_put_noidle(&client->dev);
> > +		return ret;
> > +	}
> > +
> > +	ret = 0;
> > +	switch (ctrl->id) {
> > +	case V4L2_CID_ANALOGUE_GAIN:
> > +		ret = ov13858_update_analog_gain(ov13858, ctrl);
> > +		break;
> > +	case V4L2_CID_EXPOSURE:
> > +		ret = ov13858_update_exposure(ov13858, ctrl);
> > +		break;
> > +	default:
> > +		dev_info(&client->dev,
> > +			 "ctrl(id:0x%x,val:0x%x) is not handled\n",
> > +			 ctrl->id, ctrl->val);
> > +		break;
> > +	};
> > +
> > +	pm_runtime_put(&client->dev);
> > +
> > +	return ret;
> > +}
> > +
> > +static const struct v4l2_ctrl_ops ov13858_ctrl_ops = {
> > +	.s_ctrl = ov13858_set_ctrl,
> > +};
> > +
> > +/* Initialize control handlers */
> > +static int ov13858_init_controls(struct ov13858 *ov13858) {
> > +	struct i2c_client *client = v4l2_get_subdevdata(&ov13858->sd);
> > +	struct v4l2_ctrl_handler *ctrl_hdlr;
> > +	int ret;
> > +
> > +	ctrl_hdlr = &ov13858->ctrl_handler;
> > +	ret = v4l2_ctrl_handler_init(ctrl_hdlr, 4);
> > +	if (ret)
> > +		return ret;
> > +
> > +	ctrl_hdlr->lock = &ov13858->mutex;
> > +	ov13858->link_freq = v4l2_ctrl_new_int_menu(ctrl_hdlr,
> > +				&ov13858_ctrl_ops,
> > +				V4L2_CID_LINK_FREQ,
> > +				OV13858_NUM_OF_LINK_FREQS - 1,
> > +				0,
> > +				link_freq_menu_items);
> > +	ov13858->link_freq->flags |= V4L2_CTRL_FLAG_READ_ONLY;
> > +
> > +	/* By default, PIXEL_RATE is read only */
> > +	ov13858->pixel_rate = v4l2_ctrl_new_std(ctrl_hdlr, &ov13858_ctrl_ops,
> > +					V4L2_CID_PIXEL_RATE, 0,
> > +					OV13858_GET_PIXEL_RATE(0), 1,
> > +					OV13858_GET_PIXEL_RATE(0));
> > +
> > +	v4l2_ctrl_new_std(ctrl_hdlr, &ov13858_ctrl_ops, V4L2_CID_ANALOGUE_GAIN,
> > +			  OV13858_ANA_GAIN_MIN, OV13858_ANA_GAIN_MAX,
> > +			  OV13858_ANA_GAIN_STEP, OV13858_ANA_GAIN_DEFAULT);
> > +
> > +	v4l2_ctrl_new_std(ctrl_hdlr, &ov13858_ctrl_ops, V4L2_CID_EXPOSURE,
> > +			  OV13858_EXP_GAIN_MIN, OV13858_EXP_GAIN_MAX,
> > +			  OV13858_EXP_GAIN_STEP, OV13858_EXP_GAIN_DEFAULT);
> 
> Are the minimum and maximum values dependent on the register list chosen?

We are going to use the same HTS for all reolutions.
The supports 4 lines as minimum and MAX_VTS - 8 as maximum.

> 
> > +	if (ctrl_hdlr->error) {
> > +		ret = ctrl_hdlr->error;
> > +		dev_err(&client->dev, "%s control init failed (%d)\n",
> > +			__func__, ret);
> > +		goto error;
> > +	}
> > +
> > +	ov13858->sd.ctrl_handler = ctrl_hdlr;
> > +
> > +	return 0;
> > +
> > +error:
> > +	v4l2_ctrl_handler_free(ctrl_hdlr);
> > +
> > +	return ret;
> > +}
> > +
> > +static void ov13858_update_pad_format(struct ov13858 *ov13858,
> > +				      const struct ov13858_mode *mode,
> > +				      struct v4l2_subdev_format *fmt) {
> > +	fmt->format.width = mode->width;
> > +	fmt->format.height = mode->height;
> > +	fmt->format.code = ov13858->cur_bayer_format;
> > +	fmt->format.field = V4L2_FIELD_NONE; }
> > +
> > +static int ov13858_do_get_pad_format(struct ov13858 *ov13858,
> > +				     struct v4l2_subdev_pad_config *cfg,
> > +				     struct v4l2_subdev_format *fmt) {
> > +	struct v4l2_mbus_framefmt *framefmt;
> > +	struct v4l2_subdev *sd = &ov13858->sd;
> > +
> > +	if (fmt->which == V4L2_SUBDEV_FORMAT_TRY) {
> > +		framefmt = v4l2_subdev_get_try_format(sd, cfg, fmt->pad);
> > +		fmt->format = *framefmt;
> 
> You could write this as :
> 
> fmt->format = *v4l2_subdev_get_try_format(&ov13858->sd, cfg, fmt->pad);
> 

Personally I don't like this since I believe readablity of this kind of code is not good.
If there's no stric rule for this, I want to keep this since believe there's no difference in generated code.

> 
> > +	} else {
> > +		ov13858_update_pad_format(ov13858, ov13858->cur_mode, fmt);
> > +	}
> > +
> > +	return 0;
> > +}
> > +
> > +static int ov13858_enum_mbus_code(struct v4l2_subdev *sd,
> > +				  struct v4l2_subdev_pad_config *cfg,
> > +				  struct v4l2_subdev_mbus_code_enum *code) {
> > +	if (code->index >= ARRAY_SIZE(supported_bayer_format))
> > +		return -EINVAL;
> > +
> > +	code->code = supported_bayer_format[code->index];
> 
> Newline, please.

Done.

> 
> > +	return 0;
> > +}
> > +
> > +static int ov13858_enum_frame_size(struct v4l2_subdev *sd,
> > +				   struct v4l2_subdev_pad_config *cfg,
> > +				   struct v4l2_subdev_frame_size_enum *fse) {
> > +	if (fse->index >= ARRAY_SIZE(supported_modes))
> > +		return -EINVAL;
> > +
> > +	if (ov13858_get_bayer_format(fse->code) < 0)
> > +		return -EINVAL;
> > +
> > +	fse->min_width = supported_modes[fse->index].width;
> > +	fse->max_width = fse->min_width;
> > +	fse->min_height = supported_modes[fse->index].height;
> > +	fse->max_height = fse->min_height;
> > +
> > +	return 0;
> > +}
> > +
> > +static int ov13858_get_pad_format(struct v4l2_subdev *sd,
> > +				  struct v4l2_subdev_pad_config *cfg,
> > +				  struct v4l2_subdev_format *fmt) {
> > +	struct ov13858 *ov13858 = to_ov13858(sd);
> > +	int ret;
> > +
> > +	mutex_lock(&ov13858->mutex);
> > +	ret = ov13858_do_get_pad_format(ov13858, cfg, fmt);
> 
> It'd be nice to have ov13858_do_get_pad_format() defined right above this function.

Agree~~, Done.

> 
> > +	mutex_unlock(&ov13858->mutex);
> > +
> > +	return ret;
> > +}
> > +
> > +/*
> > + * Calculate resolution distance
> > + */
> > +static inline int
> > +ov13858_get_resolution_dist(const struct ov13858_mode *mode,
> > +			    struct v4l2_mbus_framefmt *framefmt) {
> > +	return abs(mode->width - framefmt->width) +
> > +	       abs(mode->height - framefmt->height); }
> > +
> > +/*
> > + * Find the closest supported resolution to the requested resolution
> > + */
> > +static const struct ov13858_mode *
> > +ov13858_find_best_fit(struct ov13858 *ov13858,
> > +		      struct v4l2_subdev_format *fmt)
> > +{
> > +	int i, dist, cur_best_fit = 0, cur_best_fit_dist = -1;
> > +	struct v4l2_mbus_framefmt *framefmt = &fmt->format;
> > +
> > +	for (i = 0; i < ARRAY_SIZE(supported_modes); i++) {
> > +		dist = ov13858_get_resolution_dist(&supported_modes[i],
> > +						   framefmt);
> > +		if (cur_best_fit_dist == -1 || dist < cur_best_fit_dist) {
> > +			cur_best_fit_dist = dist;
> > +			cur_best_fit = i;
> > +		}
> > +	}
> > +
> > +	return &supported_modes[cur_best_fit];
> > +}
> > +
> > +static int
> > +ov13858_set_pad_format(struct v4l2_subdev *sd,
> > +		       struct v4l2_subdev_pad_config *cfg,
> > +		       struct v4l2_subdev_format *fmt)
> > +{
> > +	struct ov13858 *ov13858 = to_ov13858(sd);
> > +	const struct ov13858_mode *mode;
> > +	struct v4l2_mbus_framefmt *framefmt;
> > +	int bayer_index;
> > +
> > +	mutex_lock(&ov13858->mutex);
> > +
> > +	/* Only raw bayer is supported */
> > +	bayer_index = ov13858_get_bayer_format(fmt->format.code);
> > +	if (bayer_index < 0)
> > +		bayer_index = 0; /* Not found, suggest GRBG */
> > +
> > +	ov13858->cur_bayer_format = supported_bayer_format[bayer_index];
> > +	mode = ov13858_find_best_fit(ov13858, fmt);
> > +	ov13858_update_pad_format(ov13858, mode, fmt);
> > +	if (fmt->which == V4L2_SUBDEV_FORMAT_TRY) {
> > +		framefmt = v4l2_subdev_get_try_format(sd, cfg, fmt->pad);
> > +		*framefmt = fmt->format;
> 
> This, too, could be more simple without temporary variables.

Same, it can be simple but I prefer not to have "*func() = xxx;" or "xxx = *func()" due to readability.

> 
> > +	} else {
> > +		ov13858->cur_mode = mode;
> > +		__v4l2_ctrl_s_ctrl(ov13858->link_freq, mode->link_freq_index);
> > +		__v4l2_ctrl_s_ctrl_int64(
> > +				ov13858->pixel_rate,
> > +				OV13858_GET_PIXEL_RATE(mode->link_freq_index));
> > +	}
> > +
> > +	mutex_unlock(&ov13858->mutex);
> > +
> > +	return 0;
> > +}
> > +
> > +static int ov13858_get_skip_frames(struct v4l2_subdev *sd, u32 *frames)
> > +{
> > +	struct ov13858 *ov13858 = to_ov13858(sd);
> > +
> > +	mutex_lock(&ov13858->mutex);
> > +	*frames = ov13858->num_of_skip_frames;
> > +	mutex_unlock(&ov13858->mutex);
> > +
> > +	return 0;
> > +}
> > +
> > +/*
> > + * Prepare streaming by writing default values and customized values.
> > + * This should be called with ov13858->mutex acquired.
> > + */
> > +static int ov13858_prepare_streaming(struct ov13858 *ov13858)
> > +{
> > +	struct i2c_client *client = v4l2_get_subdevdata(&ov13858->sd);
> > +	const struct ov13858_reg_list *reg_list;
> > +	int ret, link_freq_index;
> > +
> > +	/* Get out of from software reset */
> > +	ret = ov13858_write_reg(ov13858, OV13858_REG_SOFTWARE_RST,
> > +				OV13858_REG_VALUE_08BIT, OV13858_SOFTWARE_RST);
> > +	if (ret) {
> > +		dev_err(&client->dev, "%s failed to set powerup registers\n",
> > +			__func__);
> > +		return ret;
> > +	}
> > +
> > +	/* Setup PLL */
> > +	link_freq_index = ov13858->cur_mode->link_freq_index;
> > +	reg_list = &link_freq_configs[link_freq_index].reg_list;
> > +	ret = ov13858_write_reg_list(ov13858, reg_list);
> > +	if (ret) {
> > +		dev_err(&client->dev, "%s failed to set plls\n", __func__);
> > +		return ret;
> > +	}
> > +
> > +	/* Apply default values of current mode */
> > +	reg_list = &ov13858->cur_mode->reg_list;
> > +	ret = ov13858_write_reg_list(ov13858, reg_list);
> > +	if (ret) {
> > +		dev_err(&client->dev, "%s failed to set mode\n", __func__);
> > +		return ret;
> > +	}
> > +
> > +	/* Apply customized values from user */
> > +	__v4l2_ctrl_handler_setup(ov13858->sd.ctrl_handler);
> > +
> > +	/* Apply bayer order from user */
> > +	return ov13858_apply_bayer_order(ov13858);
> > +}
> > +
> > +/* Start streaming */
> > +static inline int ov13858_start_streaming(struct ov13858 *ov13858)
> > +{
> > +	int ret;
> > +
> > +	/* Write default & customized values */
> > +	ret = ov13858_prepare_streaming(ov13858);
> > +	if (ret)
> > +		return ret;
> > +
> > +	return ov13858_write_reg(ov13858, OV13858_REG_MODE_SELECT,
> > +				 OV13858_REG_VALUE_08BIT,
> > +				 OV13858_MODE_STREAMING);
> > +}
> > +
> > +/* Stop streaming */
> > +static inline int ov13858_stop_streaming(struct ov13858 *ov13858)
> > +{
> > +	return ov13858_write_reg(ov13858, OV13858_REG_MODE_SELECT,
> > +				 OV13858_REG_VALUE_08BIT, OV13858_MODE_STANDBY);
> > +}
> > +
> > +static int ov13858_set_stream(struct v4l2_subdev *sd, int enable)
> > +{
> > +	struct ov13858 *ov13858 = to_ov13858(sd);
> > +	struct i2c_client *client = v4l2_get_subdevdata(sd);
> > +	int ret = 0;
> > +
> > +	mutex_lock(&ov13858->mutex);
> > +	if (ov13858->streaming == enable) {
> > +		mutex_unlock(&ov13858->mutex);
> > +		return 0;
> > +	}
> > +
> > +	if (enable) {
> > +		ret = pm_runtime_get_sync(&client->dev);
> > +		if (ret < 0) {
> > +			pm_runtime_put_noidle(&client->dev);
> > +			goto err_unlock;
> > +		}
> > +
> > +		/*
> > +		 * Apply default & customized values
> > +		 * and then start streaming.
> > +		 */
> > +		ret = ov13858_start_streaming(ov13858);
> > +		if (ret)
> > +			goto err_rpm_put;
> > +	} else {
> > +		ret = ov13858_stop_streaming(ov13858);
> 
> Providing a non-zero return value on disabling streaming doesn't really
> help. Please just use zero.
> 
> ov13858_stop_streaming() could have void return type, but perhaps it could
> complain out lout about a failing write.
> 

Agree on returning zero, since we turn off the sensor but let's keep return type for porting and development work.

> > +		pm_runtime_put(&client->dev);
> > +	}
> > +
> > +	ov13858->streaming = enable;
> > +	mutex_unlock(&ov13858->mutex);
> > +
> > +	return ret;
> > +
> > +err_rpm_put:
> > +	pm_runtime_put(&client->dev);
> > +err_unlock:
> > +	mutex_unlock(&ov13858->mutex);
> > +
> > +	return ret;
> > +}
> > +
> > +#ifdef CONFIG_PM
> > +
> > +static int ov13858_suspend(struct device *dev)
> > +{
> > +	struct i2c_client *client = to_i2c_client(dev);
> > +	struct v4l2_subdev *sd = i2c_get_clientdata(client);
> > +	struct ov13858 *ov13858 = to_ov13858(sd);
> > +
> > +	if (ov13858->streaming)
> > +		ov13858_stop_streaming(ov13858);
> > +
> > +	return 0;
> > +}
> > +
> > +static int ov13858_resume(struct device *dev)
> > +{
> > +	struct i2c_client *client = to_i2c_client(dev);
> > +	struct v4l2_subdev *sd = i2c_get_clientdata(client);
> > +	struct ov13858 *ov13858 = to_ov13858(sd);
> > +	int ret;
> > +
> > +	if (ov13858->streaming) {
> > +		ret = ov13858_start_streaming(ov13858);
> > +		if (ret)
> > +			goto error;
> > +	}
> > +
> > +	return 0;
> > +
> > +error:
> > +	ov13858_stop_streaming(ov13858);
> > +	ov13858->streaming = 0;
> > +	return ret;
> > +}
> > +
> > +#else
> > +
> > +#define ov13858_suspend	NULL
> > +#define ov13858_resume	NULL
> 
> Please use __maybe_unused as the smiapp driver does for the same, no need
> for #ifdefs.
> 

Oh... got it~

> > +
> > +#endif	/* CONFIG_PM */
> > +
> > +/* Verify chip ID */
> > +static inline int ov13858_identify_module(struct ov13858 *ov13858)
> > +{
> > +	struct i2c_client *client = v4l2_get_subdevdata(&ov13858->sd);
> > +	int ret;
> > +	u32 val;
> > +
> > +	ret = ov13858_read_reg(ov13858, OV13858_REG_CHIP_ID,
> > +			       OV13858_REG_VALUE_24BIT, &val);
> > +	if (ret)
> > +		return ret;
> > +
> > +	if (val != OV13858_CHIP_ID) {
> > +		dev_err(&client->dev, "chip id mismatch: %x!=%x\n",
> > +			OV13858_CHIP_ID, val);
> > +		return -EIO;
> > +	}
> > +
> > +	return 0;
> > +}
> > +
> > +static const struct v4l2_subdev_video_ops ov13858_video_ops = {
> > +	.s_stream = ov13858_set_stream,
> > +};
> > +
> > +static const struct v4l2_subdev_pad_ops ov13858_pad_ops = {
> > +	.enum_mbus_code = ov13858_enum_mbus_code,
> > +	.get_fmt = ov13858_get_pad_format,
> > +	.set_fmt = ov13858_set_pad_format,
> > +	.enum_frame_size = ov13858_enum_frame_size,
> > +};
> > +
> > +static const struct v4l2_subdev_sensor_ops ov13858_sensor_ops = {
> > +	.g_skip_frames = ov13858_get_skip_frames,
> > +};
> > +
> > +static const struct v4l2_subdev_ops ov13858_subdev_ops = {
> > +	.video = &ov13858_video_ops,
> > +	.pad = &ov13858_pad_ops,
> > +	.sensor = &ov13858_sensor_ops,
> > +};
> > +
> > +static const struct media_entity_operations ov13858_subdev_entity_ops = {
> > +	.link_validate = v4l2_subdev_link_validate,
> > +};
> > +
> > +static const struct v4l2_subdev_internal_ops ov13858_internal_ops = {
> > +	.open = ov13858_open,
> > +};
> > +
> > +static int ov13858_probe(struct i2c_client *client,
> > +			 const struct i2c_device_id *devid)
> > +{
> > +	struct ov13858 *ov13858;
> > +	int ret;
> > +
> > +	ov13858 = devm_kzalloc(&client->dev, sizeof(*ov13858), GFP_KERNEL);
> > +	if (!ov13858)
> > +		return -ENOMEM;
> > +
> > +	/* Initialize subdev */
> > +	v4l2_i2c_subdev_init(&ov13858->sd, client, &ov13858_subdev_ops);
> > +
> > +	/* Check module identity */
> > +	ret = ov13858_identify_module(ov13858);
> > +	if (ret) {
> > +		dev_err(&client->dev, "failed to find sensor: %d\n", ret);
> > +		return ret;
> > +	}
> > +
> > +	mutex_init(&ov13858->mutex);
> > +
> > +	/* Set default mode to max resolution */
> > +	ov13858->cur_mode = &supported_modes[0];
> > +
> > +	/* Set default bayer format with GRBG */
> > +	ov13858->cur_bayer_format = supported_bayer_format[0];
> > +
> > +	/* Set number of frames to skip */
> > +	ov13858->num_of_skip_frames = OV13858_NUM_OF_SKIP_FRAMES;
> > +
> > +	ret = ov13858_init_controls(ov13858);
> > +	if (ret)
> 
> mutex_init() needs to be followed by mutex_destroy(). Add a new label for
> error handling?
> 

Here, since we give up the mutex that is never owned by any context and mutex_init doesn't involve any system resource, so actually we don't need.
For now, I believe mostly mutex_destroy() is for debug purpose. we can have it for porting and development.

Anyway, it is a rule and since we don't know what will happen to mutex_destroy(), I'll do.

> > +		return ret;
> > +
> > +	/* Initialize subdev */
> > +	ov13858->sd.internal_ops = &ov13858_internal_ops;
> > +	ov13858->sd.flags |= V4L2_SUBDEV_FL_HAS_DEVNODE;
> > +	ov13858->sd.entity.ops = &ov13858_subdev_entity_ops;
> > +	ov13858->sd.entity.function = MEDIA_ENT_F_CAM_SENSOR;
> > +
> > +	/* Initialize source pad */
> > +	ov13858->pad.flags = MEDIA_PAD_FL_SOURCE;
> > +	ret = media_entity_pads_init(&ov13858->sd.entity, 1, &ov13858->pad);
> > +	if (ret) {
> > +		dev_err(&client->dev, "%s failed:%d\n", __func__, ret);
> > +		goto error_handler_free;
> > +	}
> > +
> > +	/* Enable runtime pm management */
> > +	pm_runtime_enable(&client->dev);
> > +
> > +	ret = v4l2_async_register_subdev(&ov13858->sd);
> > +	if (ret < 0)
> > +		goto error_disable_rpm;
> > +
> > +	dev_info(&client->dev, "%s done\n", __func__);
> 
> If that's all you'd tell I'd remove the print.

Although I think it's very meaningful to me, I'll remove.

> 
> > +
> > +	return 0;
> > +
> > +error_disable_rpm:
> > +	pm_runtime_disable(&client->dev);
> > +	media_entity_cleanup(&ov13858->sd.entity);
> > +
> > +error_handler_free:
> > +	v4l2_ctrl_handler_free(ov13858->sd.ctrl_handler);
> > +	dev_err(&client->dev, "%s failed:%d\n", __func__, ret);
> > +
> > +	return ret;
> > +}
> > +
> > +static int ov13858_remove(struct i2c_client *client)
> > +{
> > +	struct v4l2_subdev *sd = i2c_get_clientdata(client);
> > +
> > +	v4l2_async_unregister_subdev(sd);
> > +	media_entity_cleanup(&sd->entity);
> > +	v4l2_ctrl_handler_free(sd->ctrl_handler);
> > +	pm_runtime_disable(&client->dev);
> 
> mutex_destroy() here, too.

Done.

> 
> > +
> > +	return 0;
> > +}
> > +
> > +static const struct i2c_device_id ov13858_id_table[] = {
> > +	{"ov13858", 0},
> > +	{},
> > +};
> > +
> > +MODULE_DEVICE_TABLE(i2c, ov13858_id_table);
> > +
> > +static const struct dev_pm_ops ov13858_pm_ops = {
> > +	SET_SYSTEM_SLEEP_PM_OPS(ov13858_suspend, ov13858_resume)
> > +};
> > +
> > +#ifdef CONFIG_ACPI
> > +static const struct acpi_device_id ov13858_acpi_ids[] = {
> > +	{"OVTID858"},
> > +	{ /* sentinel */ }
> > +};
> > +
> > +MODULE_DEVICE_TABLE(acpi, ov13858_acpi_ids);
> > +#endif
> > +
> > +static struct i2c_driver ov13858_i2c_driver = {
> > +	.driver = {
> > +		.name = "ov13858",
> > +		.owner = THIS_MODULE,
> > +		.pm = &ov13858_pm_ops,
> > +		.acpi_match_table = ACPI_PTR(ov13858_acpi_ids),
> > +	},
> > +	.probe = ov13858_probe,
> > +	.remove = ov13858_remove,
> > +	.id_table = ov13858_id_table,
> > +};
> > +
> > +module_i2c_driver(ov13858_i2c_driver);
> > +
> > +MODULE_AUTHOR("Kan, Chris <chris.kan@intel.com>");
> > +MODULE_AUTHOR("Rapolu, Chiranjeevi <chiranjeevi.rapolu@intel.com>");
> > +MODULE_AUTHOR("Yang, Hyungwoo <hyungwoo.yang@intel.com>");
> > +MODULE_DESCRIPTION("Omnivision ov13858 sensor driver");
> > +MODULE_LICENSE("GPL v2");
> 
> -- 
> Kind regards,
> 
> Sakari Ailus
> e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
>

-----Original Message-----
From: Sakari Ailus [mailto:sakari.ailus@iki.fi] 
Sent: Wednesday, May 24, 2017 5:51 AM
To: Yang, Hyungwoo <hyungwoo.yang@intel.com>
Cc: linux-media@vger.kernel.org; sakari.ailus@linux.intel.com; Zheng, Jian Xu <jian.xu.zheng@intel.com>
Subject: Re: [PATCH 1/1] [media] i2c: add support for OV13858 sensor

Hi Hyungwoo,

Thanks for the patch. Please see my comments below.

On Tue, May 23, 2017 at 04:58:28PM -0700, Hyungwoo Yang wrote:
> This patch adds driver for Omnivision's ov13858 sensor, the driver 
> supports following features:
> 
> - manual exposure/analog gain
> - two link frequencies
> - media controller support
> - runtime pm support
> 
> Signed-off-by: Hyungwoo Yang <hyungwoo.yang@intel.com>
> ---
>  drivers/media/i2c/Kconfig   |    8 +
>  drivers/media/i2c/Makefile  |    1 +
>  drivers/media/i2c/ov13858.c | 1853 
> +++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 1862 insertions(+)
>  create mode 100644 drivers/media/i2c/ov13858.c
> 
> diff --git a/drivers/media/i2c/Kconfig b/drivers/media/i2c/Kconfig 
> index fd181c9..f8c5cca 100644
> --- a/drivers/media/i2c/Kconfig
> +++ b/drivers/media/i2c/Kconfig
> @@ -589,6 +589,14 @@ config VIDEO_OV9650
>  	  This is a V4L2 sensor-level driver for the Omnivision
>  	  OV9650 and OV9652 camera sensors.
>  
> +config VIDEO_OV13858
> +	tristate "OmniVision OV13858 sensor support"
> +	depends on I2C && VIDEO_V4L2 && VIDEO_V4L2_SUBDEV_API
> +	depends on MEDIA_CAMERA_SUPPORT
> +	---help---
> +	  This is a Video4Linux2 sensor-level driver for the OmniVision
> +	  OV13858 camera.
> +
>  config VIDEO_VS6624
>  	tristate "ST VS6624 sensor support"
>  	depends on VIDEO_V4L2 && I2C
> diff --git a/drivers/media/i2c/Makefile b/drivers/media/i2c/Makefile 
> index 62323ec..3f4dc02 100644
> --- a/drivers/media/i2c/Makefile
> +++ b/drivers/media/i2c/Makefile
> @@ -63,6 +63,7 @@ obj-$(CONFIG_VIDEO_OV5647) += ov5647.o
>  obj-$(CONFIG_VIDEO_OV7640) += ov7640.o
>  obj-$(CONFIG_VIDEO_OV7670) += ov7670.o
>  obj-$(CONFIG_VIDEO_OV9650) += ov9650.o
> +obj-$(CONFIG_VIDEO_OV13858) += ov13858.o
>  obj-$(CONFIG_VIDEO_MT9M032) += mt9m032.o
>  obj-$(CONFIG_VIDEO_MT9M111) += mt9m111.o
>  obj-$(CONFIG_VIDEO_MT9P031) += mt9p031.o diff --git 
> a/drivers/media/i2c/ov13858.c b/drivers/media/i2c/ov13858.c new file 
> mode 100644 index 0000000..7fc735e
> --- /dev/null
> +++ b/drivers/media/i2c/ov13858.c
> @@ -0,0 +1,1853 @@
> +/*
> + * Copyright (c) 2017 Intel Corporation.
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public License 
> +version
> + * 2 as published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
> + * GNU General Public License for more details.
> + *
> + */
> +
> +#include <linux/acpi.h>
> +#include <linux/i2c.h>
> +#include <linux/module.h>
> +#include <linux/pm_runtime.h>
> +#include <media/v4l2-ctrls.h>
> +#include <media/v4l2-device.h>
> +
> +#define OV13858_REG_VALUE_08BIT		1
> +#define OV13858_REG_VALUE_16BIT		2
> +#define OV13858_REG_VALUE_24BIT		3
> +
> +#define OV13858_REG_MODE_SELECT		0x0100
> +#define OV13858_MODE_STANDBY		0x00
> +#define OV13858_MODE_STREAMING		0x01
> +
> +#define OV13858_REG_SOFTWARE_RST	0x0103
> +#define OV13858_SOFTWARE_RST		0x01
> +
> +/* PLL1 generates PCLK and MIPI_PHY_CLK */
> +#define OV13858_REG_PLL1_CTRL_0		0x0300
> +#define OV13858_REG_PLL1_CTRL_1		0x0301
> +#define OV13858_REG_PLL1_CTRL_2		0x0302
> +#define OV13858_REG_PLL1_CTRL_3		0x0303
> +#define OV13858_REG_PLL1_CTRL_4		0x0304
> +#define OV13858_REG_PLL1_CTRL_5		0x0305
> +
> +/* PLL2 generates DAC_CLK, SCLK and SRAM_CLK */
> +#define OV13858_REG_PLL2_CTRL_B		0x030b
> +#define OV13858_REG_PLL2_CTRL_C		0x030c
> +#define OV13858_REG_PLL2_CTRL_D		0x030d
> +#define OV13858_REG_PLL2_CTRL_E		0x030e
> +#define OV13858_REG_PLL2_CTRL_F		0x030f
> +#define OV13858_REG_PLL2_CTRL_12	0x0312
> +#define OV13858_REG_MIPI_SC_CTRL0	0x3016
> +#define OV13858_REG_MIPI_SC_CTRL1	0x3022
> +
> +/* Chip ID */
> +#define OV13858_REG_CHIP_ID		0x300a
> +#define OV13858_CHIP_ID			0x00d855
> +
> +/* Group access */
> +#define OV13858_REG_GROUP_ACCESS	0x3208
> +#define OV13858_GROUP_HOLD_START(g_id)	(0x00 | (g_id))
> +#define OV13858_GROUP_HOLD_END(g_id)	(0x10 | (g_id))
> +#define OV13858_GROUP_LAUNCH(g_id)	(0xa0 | (g_id))
> +#define OV13858_GROUP_FAST_LAUNCH(g_id)	(0xe0 | (g_id))
> +
> +/* H-/V-offset control for expected bayer order */
> +#define OV13858_REG_H_OFFSET		0x3810
> +#define OV13858_REG_V_OFFSET		0x3812
> +
> +/* V-timing internal */
> +#define OV13858_REG_VTS			0x380e
> +#define OV13858_VTS_30FPS		0x0c8e /* 30 fps */
> +#define OV13858_VTS_60FPS		0x0648 /* 60 fps */
> +#define OV13858_VTS_MAX			0x7fff
> +
> +/* Exposure control */
> +#define OV13858_REG_EXPOSURE		0x3500
> +#define OV13858_EXP_GAIN_MIN		4
> +#define OV13858_EXP_GAIN_MAX		(OV13858_VTS_MAX - 8)
> +#define OV13858_EXP_GAIN_STEP		1
> +#define OV13858_EXP_GAIN_DEFAULT	0x640
> +
> +/* Analog gain control */
> +#define OV13858_REG_ANALOG_GAIN		0x3508
> +#define OV13858_ANA_GAIN_MIN		0
> +#define OV13858_ANA_GAIN_MAX		0x1fff
> +#define OV13858_ANA_GAIN_STEP		1
> +#define OV13858_ANA_GAIN_DEFAULT	0x80
> +
> +/* Number of frames to skip */
> +#define OV13858_NUM_OF_SKIP_FRAMES	2
> +
> +struct ov13858_reg {
> +	u16 address;
> +	u8 val;
> +};
> +
> +struct ov13858_reg_list {
> +	u32 num_of_regs;
> +	const struct ov13858_reg *regs;
> +};
> +
> +/* Link frequency config */
> +struct ov13858_link_freq_config {
> +	u32 pixel_rate;
> +
> +	/* PLL registers for this link frequency */
> +	struct ov13858_reg_list reg_list;
> +};
> +
> +/* Mode : resolution and related config&values */ struct ov13858_mode 
> +{
> +	/* Frame width */
> +	u32 width;
> +	/* Frame height */
> +	u32 height;
> +
> +	/* V-timing */
> +	u32 vts;
> +
> +	/* Index of Link frequency config to be used */
> +	u32 link_freq_index;
> +	/* Default register values */
> +	struct ov13858_reg_list reg_list;
> +};
> +
> +/* 4224x3136 needs 1080Mbps/lane, 4 lanes */ static const struct 
> +ov13858_reg mipi_data_rate_1080mbps[] = {
> +	/* PLL1 registers */
> +	{OV13858_REG_PLL1_CTRL_0, 0x07},
> +	{OV13858_REG_PLL1_CTRL_1, 0x01},
> +	{OV13858_REG_PLL1_CTRL_2, 0xc2},
> +	{OV13858_REG_PLL1_CTRL_3, 0x00},
> +	{OV13858_REG_PLL1_CTRL_4, 0x00},
> +	{OV13858_REG_PLL1_CTRL_5, 0x01},
> +
> +	/* PLL2 registers */
> +	{OV13858_REG_PLL2_CTRL_B, 0x05},
> +	{OV13858_REG_PLL2_CTRL_C, 0x01},
> +	{OV13858_REG_PLL2_CTRL_D, 0x0e},
> +	{OV13858_REG_PLL2_CTRL_E, 0x05},
> +	{OV13858_REG_PLL2_CTRL_F, 0x01},
> +	{OV13858_REG_PLL2_CTRL_12, 0x01},
> +	{OV13858_REG_MIPI_SC_CTRL0, 0x72},
> +	{OV13858_REG_MIPI_SC_CTRL1, 0x01},
> +};
> +
> +/*
> + * 2112x1568, 2112x1188, 1056x784 need 540Mbps/lane,
> + * 4 lanes
> + */
> +static const struct ov13858_reg mipi_data_rate_540mbps[] = {
> +	/* PLL1 registers */
> +	{OV13858_REG_PLL1_CTRL_0, 0x07},
> +	{OV13858_REG_PLL1_CTRL_1, 0x01},
> +	{OV13858_REG_PLL1_CTRL_2, 0xc2},
> +	{OV13858_REG_PLL1_CTRL_3, 0x01},
> +	{OV13858_REG_PLL1_CTRL_4, 0x00},
> +	{OV13858_REG_PLL1_CTRL_5, 0x01},
> +
> +	/* PLL2 registers */
> +	{OV13858_REG_PLL2_CTRL_B, 0x05},
> +	{OV13858_REG_PLL2_CTRL_C, 0x01},
> +	{OV13858_REG_PLL2_CTRL_D, 0x0e},
> +	{OV13858_REG_PLL2_CTRL_E, 0x05},
> +	{OV13858_REG_PLL2_CTRL_F, 0x01},
> +	{OV13858_REG_PLL2_CTRL_12, 0x01},
> +	{OV13858_REG_MIPI_SC_CTRL0, 0x72},
> +	{OV13858_REG_MIPI_SC_CTRL1, 0x01},
> +};
> +
> +static const struct ov13858_reg mode_4224x3136_regs[] = {
> +	{0x3013, 0x32},
> +	{0x301b, 0xf0},
> +	{0x301f, 0xd0},
> +	{0x3106, 0x15},
> +	{0x3107, 0x23},
> +	{0x350a, 0x00},
> +	{0x350e, 0x00},
> +	{0x3510, 0x00},
> +	{0x3511, 0x02},
> +	{0x3512, 0x00},
> +	{0x3600, 0x2b},
> +	{0x3601, 0x52},
> +	{0x3602, 0x60},
> +	{0x3612, 0x05},
> +	{0x3613, 0xa4},
> +	{0x3620, 0x80},
> +	{0x3621, 0x10},
> +	{0x3622, 0x30},
> +	{0x3624, 0x1c},
> +	{0x3640, 0x10},
> +	{0x3641, 0x70},
> +	{0x3661, 0x80},
> +	{0x3662, 0x12},
> +	{0x3664, 0x73},
> +	{0x3665, 0xa7},
> +	{0x366e, 0xff},
> +	{0x366f, 0xf4},
> +	{0x3674, 0x00},
> +	{0x3679, 0x0c},
> +	{0x367f, 0x01},
> +	{0x3680, 0x0c},
> +	{0x3681, 0x50},
> +	{0x3682, 0x50},
> +	{0x3683, 0xa9},
> +	{0x3684, 0xa9},
> +	{0x3709, 0x5f},
> +	{0x3714, 0x24},
> +	{0x371a, 0x3e},
> +	{0x3737, 0x04},
> +	{0x3738, 0xcc},
> +	{0x3739, 0x12},
> +	{0x373d, 0x26},
> +	{0x3764, 0x20},
> +	{0x3765, 0x20},
> +	{0x37a1, 0x36},
> +	{0x37a8, 0x3b},
> +	{0x37ab, 0x31},
> +	{0x37c2, 0x04},
> +	{0x37c3, 0xf1},
> +	{0x37c5, 0x00},
> +	{0x37d8, 0x03},
> +	{0x37d9, 0x0c},
> +	{0x37da, 0xc2},
> +	{0x37dc, 0x02},
> +	{0x37e0, 0x00},
> +	{0x37e1, 0x0a},
> +	{0x37e2, 0x14},
> +	{0x37e3, 0x04},
> +	{0x37e4, 0x2a},
> +	{0x37e5, 0x03},
> +	{0x37e6, 0x04},
> +	{0x3800, 0x00},
> +	{0x3801, 0x00},
> +	{0x3802, 0x00},
> +	{0x3803, 0x00},
> +	{0x3804, 0x10},
> +	{0x3805, 0x9f},
> +	{0x3806, 0x0c},
> +	{0x3807, 0x5f},
> +	{0x3808, 0x10},
> +	{0x3809, 0x80},
> +	{0x380a, 0x0c},
> +	{0x380b, 0x40},
> +	{0x380c, 0x04},
> +	{0x380d, 0x62},
> +	{0x380e, 0x0c},
> +	{0x380f, 0x8e},
> +	{0x3811, 0x04},
> +	{0x3813, 0x05},
> +	{0x3814, 0x01},
> +	{0x3815, 0x01},
> +	{0x3816, 0x01},
> +	{0x3817, 0x01},
> +	{0x3820, 0xa8},
> +	{0x3821, 0x00},
> +	{0x3822, 0xc2},
> +	{0x3823, 0x18},
> +	{0x3826, 0x11},
> +	{0x3827, 0x1c},
> +	{0x3829, 0x03},
> +	{0x3832, 0x00},
> +	{0x3c80, 0x00},
> +	{0x3c87, 0x01},
> +	{0x3c8c, 0x19},
> +	{0x3c8d, 0x1c},
> +	{0x3c90, 0x00},
> +	{0x3c91, 0x00},
> +	{0x3c92, 0x00},
> +	{0x3c93, 0x00},
> +	{0x3c94, 0x40},
> +	{0x3c95, 0x54},
> +	{0x3c96, 0x34},
> +	{0x3c97, 0x04},
> +	{0x3c98, 0x00},
> +	{0x3d8c, 0x73},
> +	{0x3d8d, 0xc0},
> +	{0x3f00, 0x0b},
> +	{0x3f03, 0x00},
> +	{0x4001, 0xe0},
> +	{0x4008, 0x00},
> +	{0x4009, 0x0f},
> +	{0x4011, 0xf0},
> +	{0x4017, 0x08},
> +	{0x4050, 0x04},
> +	{0x4051, 0x0b},
> +	{0x4052, 0x00},
> +	{0x4053, 0x80},
> +	{0x4054, 0x00},
> +	{0x4055, 0x80},
> +	{0x4056, 0x00},
> +	{0x4057, 0x80},
> +	{0x4058, 0x00},
> +	{0x4059, 0x80},
> +	{0x405e, 0x20},
> +	{0x4500, 0x07},
> +	{0x4503, 0x00},
> +	{0x450a, 0x04},
> +	{0x4809, 0x04},
> +	{0x480c, 0x12},
> +	{0x481f, 0x30},
> +	{0x4833, 0x10},
> +	{0x4837, 0x0e},
> +	{0x4902, 0x01},
> +	{0x4d00, 0x03},
> +	{0x4d01, 0xc9},
> +	{0x4d02, 0xbc},
> +	{0x4d03, 0xd7},
> +	{0x4d04, 0xf0},
> +	{0x4d05, 0xa2},
> +	{0x5000, 0xfd},
> +	{0x5001, 0x01},
> +	{0x5040, 0x39},
> +	{0x5041, 0x10},
> +	{0x5042, 0x10},
> +	{0x5043, 0x84},
> +	{0x5044, 0x62},
> +	{0x5180, 0x00},
> +	{0x5181, 0x10},
> +	{0x5182, 0x02},
> +	{0x5183, 0x0f},
> +	{0x5200, 0x1b},
> +	{0x520b, 0x07},
> +	{0x520c, 0x0f},
> +	{0x5300, 0x04},
> +	{0x5301, 0x0c},
> +	{0x5302, 0x0c},
> +	{0x5303, 0x0f},
> +	{0x5304, 0x00},
> +	{0x5305, 0x70},
> +	{0x5306, 0x00},
> +	{0x5307, 0x80},
> +	{0x5308, 0x00},
> +	{0x5309, 0xa5},
> +	{0x530a, 0x00},
> +	{0x530b, 0xd3},
> +	{0x530c, 0x00},
> +	{0x530d, 0xf0},
> +	{0x530e, 0x01},
> +	{0x530f, 0x10},
> +	{0x5310, 0x01},
> +	{0x5311, 0x20},
> +	{0x5312, 0x01},
> +	{0x5313, 0x20},
> +	{0x5314, 0x01},
> +	{0x5315, 0x20},
> +	{0x5316, 0x08},
> +	{0x5317, 0x08},
> +	{0x5318, 0x10},
> +	{0x5319, 0x88},
> +	{0x531a, 0x88},
> +	{0x531b, 0xa9},
> +	{0x531c, 0xaa},
> +	{0x531d, 0x0a},
> +	{0x5405, 0x02},
> +	{0x5406, 0x67},
> +	{0x5407, 0x01},
> +	{0x5408, 0x4a},
> +};
> +
> +static const struct ov13858_reg mode_2112x1568_regs[] = {
> +	{0x3013, 0x32},
> +	{0x301b, 0xf0},
> +	{0x301f, 0xd0},
> +	{0x3106, 0x15},
> +	{0x3107, 0x23},
> +	{0x350a, 0x00},
> +	{0x350e, 0x00},
> +	{0x3510, 0x00},
> +	{0x3511, 0x02},
> +	{0x3512, 0x00},
> +	{0x3600, 0x2b},
> +	{0x3601, 0x52},
> +	{0x3602, 0x60},
> +	{0x3612, 0x05},
> +	{0x3613, 0xa4},
> +	{0x3620, 0x80},
> +	{0x3621, 0x10},
> +	{0x3622, 0x30},
> +	{0x3624, 0x1c},
> +	{0x3640, 0x10},
> +	{0x3641, 0x70},
> +	{0x3661, 0x80},
> +	{0x3662, 0x10},
> +	{0x3664, 0x73},
> +	{0x3665, 0xa7},
> +	{0x366e, 0xff},
> +	{0x366f, 0xf4},
> +	{0x3674, 0x00},
> +	{0x3679, 0x0c},
> +	{0x367f, 0x01},
> +	{0x3680, 0x0c},
> +	{0x3681, 0x50},
> +	{0x3682, 0x50},
> +	{0x3683, 0xa9},
> +	{0x3684, 0xa9},
> +	{0x3709, 0x5f},
> +	{0x3714, 0x28},
> +	{0x371a, 0x3e},
> +	{0x3737, 0x08},
> +	{0x3738, 0xcc},
> +	{0x3739, 0x20},
> +	{0x373d, 0x26},
> +	{0x3764, 0x20},
> +	{0x3765, 0x20},
> +	{0x37a1, 0x36},
> +	{0x37a8, 0x3b},
> +	{0x37ab, 0x31},
> +	{0x37c2, 0x14},
> +	{0x37c3, 0xf1},
> +	{0x37c5, 0x00},
> +	{0x37d8, 0x03},
> +	{0x37d9, 0x0c},
> +	{0x37da, 0xc2},
> +	{0x37dc, 0x02},
> +	{0x37e0, 0x00},
> +	{0x37e1, 0x0a},
> +	{0x37e2, 0x14},
> +	{0x37e3, 0x08},
> +	{0x37e4, 0x38},
> +	{0x37e5, 0x03},
> +	{0x37e6, 0x08},
> +	{0x3800, 0x00},
> +	{0x3801, 0x00},
> +	{0x3802, 0x00},
> +	{0x3803, 0x00},
> +	{0x3804, 0x10},
> +	{0x3805, 0x9f},
> +	{0x3806, 0x0c},
> +	{0x3807, 0x5f},
> +	{0x3808, 0x08},
> +	{0x3809, 0x40},
> +	{0x380a, 0x06},
> +	{0x380b, 0x20},
> +	{0x380c, 0x04},
> +	{0x380d, 0x62},
> +	{0x380e, 0x0c},
> +	{0x380f, 0x8e},
> +	{0x3811, 0x04},
> +	{0x3813, 0x05},
> +	{0x3814, 0x03},
> +	{0x3815, 0x01},
> +	{0x3816, 0x03},
> +	{0x3817, 0x01},
> +	{0x3820, 0xab},
> +	{0x3821, 0x00},
> +	{0x3822, 0xc2},
> +	{0x3823, 0x18},
> +	{0x3826, 0x04},
> +	{0x3827, 0x90},
> +	{0x3829, 0x07},
> +	{0x3832, 0x00},
> +	{0x3c80, 0x00},
> +	{0x3c87, 0x01},
> +	{0x3c8c, 0x19},
> +	{0x3c8d, 0x1c},
> +	{0x3c90, 0x00},
> +	{0x3c91, 0x00},
> +	{0x3c92, 0x00},
> +	{0x3c93, 0x00},
> +	{0x3c94, 0x40},
> +	{0x3c95, 0x54},
> +	{0x3c96, 0x34},
> +	{0x3c97, 0x04},
> +	{0x3c98, 0x00},
> +	{0x3d8c, 0x73},
> +	{0x3d8d, 0xc0},
> +	{0x3f00, 0x0b},
> +	{0x3f03, 0x00},
> +	{0x4001, 0xe0},
> +	{0x4008, 0x00},
> +	{0x4009, 0x0d},
> +	{0x4011, 0xf0},
> +	{0x4017, 0x08},
> +	{0x4050, 0x04},
> +	{0x4051, 0x0b},
> +	{0x4052, 0x00},
> +	{0x4053, 0x80},
> +	{0x4054, 0x00},
> +	{0x4055, 0x80},
> +	{0x4056, 0x00},
> +	{0x4057, 0x80},
> +	{0x4058, 0x00},
> +	{0x4059, 0x80},
> +	{0x405e, 0x20},
> +	{0x4500, 0x07},
> +	{0x4503, 0x00},
> +	{0x450a, 0x04},
> +	{0x4809, 0x04},
> +	{0x480c, 0x12},
> +	{0x481f, 0x30},
> +	{0x4833, 0x10},
> +	{0x4837, 0x1c},
> +	{0x4902, 0x01},
> +	{0x4d00, 0x03},
> +	{0x4d01, 0xc9},
> +	{0x4d02, 0xbc},
> +	{0x4d03, 0xd7},
> +	{0x4d04, 0xf0},
> +	{0x4d05, 0xa2},
> +	{0x5000, 0xfd},
> +	{0x5001, 0x01},
> +	{0x5040, 0x39},
> +	{0x5041, 0x10},
> +	{0x5042, 0x10},
> +	{0x5043, 0x84},
> +	{0x5044, 0x62},
> +	{0x5180, 0x00},
> +	{0x5181, 0x10},
> +	{0x5182, 0x02},
> +	{0x5183, 0x0f},
> +	{0x5200, 0x1b},
> +	{0x520b, 0x07},
> +	{0x520c, 0x0f},
> +	{0x5300, 0x04},
> +	{0x5301, 0x0c},
> +	{0x5302, 0x0c},
> +	{0x5303, 0x0f},
> +	{0x5304, 0x00},
> +	{0x5305, 0x70},
> +	{0x5306, 0x00},
> +	{0x5307, 0x80},
> +	{0x5308, 0x00},
> +	{0x5309, 0xa5},
> +	{0x530a, 0x00},
> +	{0x530b, 0xd3},
> +	{0x530c, 0x00},
> +	{0x530d, 0xf0},
> +	{0x530e, 0x01},
> +	{0x530f, 0x10},
> +	{0x5310, 0x01},
> +	{0x5311, 0x20},
> +	{0x5312, 0x01},
> +	{0x5313, 0x20},
> +	{0x5314, 0x01},
> +	{0x5315, 0x20},
> +	{0x5316, 0x08},
> +	{0x5317, 0x08},
> +	{0x5318, 0x10},
> +	{0x5319, 0x88},
> +	{0x531a, 0x88},
> +	{0x531b, 0xa9},
> +	{0x531c, 0xaa},
> +	{0x531d, 0x0a},
> +	{0x5405, 0x02},
> +	{0x5406, 0x67},
> +	{0x5407, 0x01},
> +	{0x5408, 0x4a},
> +};
> +
> +static const struct ov13858_reg mode_2112x1188_regs[] = {
> +	{0x3013, 0x32},
> +	{0x301b, 0xf0},
> +	{0x301f, 0xd0},
> +	{0x3106, 0x15},
> +	{0x3107, 0x23},
> +	{0x350a, 0x00},
> +	{0x350e, 0x00},
> +	{0x3510, 0x00},
> +	{0x3511, 0x02},
> +	{0x3512, 0x00},
> +	{0x3600, 0x2b},
> +	{0x3601, 0x52},
> +	{0x3602, 0x60},
> +	{0x3612, 0x05},
> +	{0x3613, 0xa4},
> +	{0x3620, 0x80},
> +	{0x3621, 0x10},
> +	{0x3622, 0x30},
> +	{0x3624, 0x1c},
> +	{0x3640, 0x10},
> +	{0x3641, 0x70},
> +	{0x3661, 0x80},
> +	{0x3662, 0x10},
> +	{0x3664, 0x73},
> +	{0x3665, 0xa7},
> +	{0x366e, 0xff},
> +	{0x366f, 0xf4},
> +	{0x3674, 0x00},
> +	{0x3679, 0x0c},
> +	{0x367f, 0x01},
> +	{0x3680, 0x0c},
> +	{0x3681, 0x50},
> +	{0x3682, 0x50},
> +	{0x3683, 0xa9},
> +	{0x3684, 0xa9},
> +	{0x3709, 0x5f},
> +	{0x3714, 0x28},
> +	{0x371a, 0x3e},
> +	{0x3737, 0x08},
> +	{0x3738, 0xcc},
> +	{0x3739, 0x20},
> +	{0x373d, 0x26},
> +	{0x3764, 0x20},
> +	{0x3765, 0x20},
> +	{0x37a1, 0x36},
> +	{0x37a8, 0x3b},
> +	{0x37ab, 0x31},
> +	{0x37c2, 0x14},
> +	{0x37c3, 0xf1},
> +	{0x37c5, 0x00},
> +	{0x37d8, 0x03},
> +	{0x37d9, 0x0c},
> +	{0x37da, 0xc2},
> +	{0x37dc, 0x02},
> +	{0x37e0, 0x00},
> +	{0x37e1, 0x0a},
> +	{0x37e2, 0x14},
> +	{0x37e3, 0x08},
> +	{0x37e4, 0x38},
> +	{0x37e5, 0x03},
> +	{0x37e6, 0x08},
> +	{0x3800, 0x00},
> +	{0x3801, 0x00},
> +	{0x3802, 0x01},
> +	{0x3803, 0x84},
> +	{0x3804, 0x10},
> +	{0x3805, 0x9f},
> +	{0x3806, 0x0a},
> +	{0x3807, 0xd3},
> +	{0x3808, 0x08},
> +	{0x3809, 0x40},
> +	{0x380a, 0x04},
> +	{0x380b, 0xa4},
> +	{0x380c, 0x04},
> +	{0x380d, 0x62},
> +	{0x380e, 0x0c},
> +	{0x380f, 0x8e},
> +	{0x3811, 0x08},
> +	{0x3813, 0x03},
> +	{0x3814, 0x03},
> +	{0x3815, 0x01},
> +	{0x3816, 0x03},
> +	{0x3817, 0x01},
> +	{0x3820, 0xab},
> +	{0x3821, 0x00},
> +	{0x3822, 0xc2},
> +	{0x3823, 0x18},
> +	{0x3826, 0x04},
> +	{0x3827, 0x90},
> +	{0x3829, 0x07},
> +	{0x3832, 0x00},
> +	{0x3c80, 0x00},
> +	{0x3c87, 0x01},
> +	{0x3c8c, 0x19},
> +	{0x3c8d, 0x1c},
> +	{0x3c90, 0x00},
> +	{0x3c91, 0x00},
> +	{0x3c92, 0x00},
> +	{0x3c93, 0x00},
> +	{0x3c94, 0x40},
> +	{0x3c95, 0x54},
> +	{0x3c96, 0x34},
> +	{0x3c97, 0x04},
> +	{0x3c98, 0x00},
> +	{0x3d8c, 0x73},
> +	{0x3d8d, 0xc0},
> +	{0x3f00, 0x0b},
> +	{0x3f03, 0x00},
> +	{0x4001, 0xe0},
> +	{0x4008, 0x00},
> +	{0x4009, 0x0d},
> +	{0x4011, 0xf0},
> +	{0x4017, 0x08},
> +	{0x4050, 0x04},
> +	{0x4051, 0x0b},
> +	{0x4052, 0x00},
> +	{0x4053, 0x80},
> +	{0x4054, 0x00},
> +	{0x4055, 0x80},
> +	{0x4056, 0x00},
> +	{0x4057, 0x80},
> +	{0x4058, 0x00},
> +	{0x4059, 0x80},
> +	{0x405e, 0x20},
> +	{0x4500, 0x07},
> +	{0x4503, 0x00},
> +	{0x450a, 0x04},
> +	{0x4809, 0x04},
> +	{0x480c, 0x12},
> +	{0x481f, 0x30},
> +	{0x4833, 0x10},
> +	{0x4837, 0x1c},
> +	{0x4902, 0x01},
> +	{0x4d00, 0x03},
> +	{0x4d01, 0xc9},
> +	{0x4d02, 0xbc},
> +	{0x4d03, 0xd7},
> +	{0x4d04, 0xf0},
> +	{0x4d05, 0xa2},
> +	{0x5000, 0xfd},
> +	{0x5001, 0x01},
> +	{0x5040, 0x39},
> +	{0x5041, 0x10},
> +	{0x5042, 0x10},
> +	{0x5043, 0x84},
> +	{0x5044, 0x62},
> +	{0x5180, 0x00},
> +	{0x5181, 0x10},
> +	{0x5182, 0x02},
> +	{0x5183, 0x0f},
> +	{0x5200, 0x1b},
> +	{0x520b, 0x07},
> +	{0x520c, 0x0f},
> +	{0x5300, 0x04},
> +	{0x5301, 0x0c},
> +	{0x5302, 0x0c},
> +	{0x5303, 0x0f},
> +	{0x5304, 0x00},
> +	{0x5305, 0x70},
> +	{0x5306, 0x00},
> +	{0x5307, 0x80},
> +	{0x5308, 0x00},
> +	{0x5309, 0xa5},
> +	{0x530a, 0x00},
> +	{0x530b, 0xd3},
> +	{0x530c, 0x00},
> +	{0x530d, 0xf0},
> +	{0x530e, 0x01},
> +	{0x530f, 0x10},
> +	{0x5310, 0x01},
> +	{0x5311, 0x20},
> +	{0x5312, 0x01},
> +	{0x5313, 0x20},
> +	{0x5314, 0x01},
> +	{0x5315, 0x20},
> +	{0x5316, 0x08},
> +	{0x5317, 0x08},
> +	{0x5318, 0x10},
> +	{0x5319, 0x88},
> +	{0x531a, 0x88},
> +	{0x531b, 0xa9},
> +	{0x531c, 0xaa},
> +	{0x531d, 0x0a},
> +	{0x5405, 0x02},
> +	{0x5406, 0x67},
> +	{0x5407, 0x01},
> +	{0x5408, 0x4a},
> +};
> +
> +static const struct ov13858_reg mode_1056x784_regs[] = {
> +	{0x3013, 0x32},
> +	{0x301b, 0xf0},
> +	{0x301f, 0xd0},
> +	{0x3106, 0x15},
> +	{0x3107, 0x23},
> +	{0x350a, 0x00},
> +	{0x350e, 0x00},
> +	{0x3510, 0x00},
> +	{0x3511, 0x02},
> +	{0x3512, 0x00},
> +	{0x3600, 0x2b},
> +	{0x3601, 0x52},
> +	{0x3602, 0x60},
> +	{0x3612, 0x05},
> +	{0x3613, 0xa4},
> +	{0x3620, 0x80},
> +	{0x3621, 0x10},
> +	{0x3622, 0x30},
> +	{0x3624, 0x1c},
> +	{0x3640, 0x10},
> +	{0x3641, 0x70},
> +	{0x3661, 0x80},
> +	{0x3662, 0x08},
> +	{0x3664, 0x73},
> +	{0x3665, 0xa7},
> +	{0x366e, 0xff},
> +	{0x366f, 0xf4},
> +	{0x3674, 0x00},
> +	{0x3679, 0x0c},
> +	{0x367f, 0x01},
> +	{0x3680, 0x0c},
> +	{0x3681, 0x50},
> +	{0x3682, 0x50},
> +	{0x3683, 0xa9},
> +	{0x3684, 0xa9},
> +	{0x3709, 0x5f},
> +	{0x3714, 0x30},
> +	{0x371a, 0x3e},
> +	{0x3737, 0x08},
> +	{0x3738, 0xcc},
> +	{0x3739, 0x20},
> +	{0x373d, 0x26},
> +	{0x3764, 0x20},
> +	{0x3765, 0x20},
> +	{0x37a1, 0x36},
> +	{0x37a8, 0x3b},
> +	{0x37ab, 0x31},
> +	{0x37c2, 0x2c},
> +	{0x37c3, 0xf1},
> +	{0x37c5, 0x00},
> +	{0x37d8, 0x03},
> +	{0x37d9, 0x06},
> +	{0x37da, 0xc2},
> +	{0x37dc, 0x02},
> +	{0x37e0, 0x00},
> +	{0x37e1, 0x0a},
> +	{0x37e2, 0x14},
> +	{0x37e3, 0x08},
> +	{0x37e4, 0x36},
> +	{0x37e5, 0x03},
> +	{0x37e6, 0x08},
> +	{0x3800, 0x00},
> +	{0x3801, 0x00},
> +	{0x3802, 0x00},
> +	{0x3803, 0x00},
> +	{0x3804, 0x10},
> +	{0x3805, 0x9f},
> +	{0x3806, 0x0c},
> +	{0x3807, 0x5f},
> +	{0x3808, 0x04},
> +	{0x3809, 0x20},
> +	{0x380a, 0x03},
> +	{0x380b, 0x10},
> +	{0x380c, 0x04},
> +	{0x380d, 0x62},
> +	{0x380e, 0x0c},
> +	{0x380f, 0x8e},
> +	{0x3811, 0x04},
> +	{0x3813, 0x05},
> +	{0x3814, 0x07},
> +	{0x3815, 0x01},
> +	{0x3816, 0x07},
> +	{0x3817, 0x01},
> +	{0x3820, 0xac},
> +	{0x3821, 0x00},
> +	{0x3822, 0xc2},
> +	{0x3823, 0x18},
> +	{0x3826, 0x04},
> +	{0x3827, 0x48},
> +	{0x3829, 0x03},
> +	{0x3832, 0x00},
> +	{0x3c80, 0x00},
> +	{0x3c87, 0x01},
> +	{0x3c8c, 0x19},
> +	{0x3c8d, 0x1c},
> +	{0x3c90, 0x00},
> +	{0x3c91, 0x00},
> +	{0x3c92, 0x00},
> +	{0x3c93, 0x00},
> +	{0x3c94, 0x40},
> +	{0x3c95, 0x54},
> +	{0x3c96, 0x34},
> +	{0x3c97, 0x04},
> +	{0x3c98, 0x00},
> +	{0x3d8c, 0x73},
> +	{0x3d8d, 0xc0},
> +	{0x3f00, 0x0b},
> +	{0x3f03, 0x00},
> +	{0x4001, 0xe0},
> +	{0x4008, 0x00},
> +	{0x4009, 0x05},
> +	{0x4011, 0xf0},
> +	{0x4017, 0x08},
> +	{0x4050, 0x02},
> +	{0x4051, 0x05},
> +	{0x4052, 0x00},
> +	{0x4053, 0x80},
> +	{0x4054, 0x00},
> +	{0x4055, 0x80},
> +	{0x4056, 0x00},
> +	{0x4057, 0x80},
> +	{0x4058, 0x00},
> +	{0x4059, 0x80},
> +	{0x405e, 0x20},
> +	{0x4500, 0x07},
> +	{0x4503, 0x00},
> +	{0x450a, 0x04},
> +	{0x4809, 0x04},
> +	{0x480c, 0x12},
> +	{0x481f, 0x30},
> +	{0x4833, 0x10},
> +	{0x4837, 0x1e},
> +	{0x4902, 0x02},
> +	{0x4d00, 0x03},
> +	{0x4d01, 0xc9},
> +	{0x4d02, 0xbc},
> +	{0x4d03, 0xd7},
> +	{0x4d04, 0xf0},
> +	{0x4d05, 0xa2},
> +	{0x5000, 0xfd},
> +	{0x5001, 0x01},
> +	{0x5040, 0x39},
> +	{0x5041, 0x10},
> +	{0x5042, 0x10},
> +	{0x5043, 0x84},
> +	{0x5044, 0x62},
> +	{0x5180, 0x00},
> +	{0x5181, 0x10},
> +	{0x5182, 0x02},
> +	{0x5183, 0x0f},
> +	{0x5200, 0x1b},
> +	{0x520b, 0x07},
> +	{0x520c, 0x0f},
> +	{0x5300, 0x04},
> +	{0x5301, 0x0c},
> +	{0x5302, 0x0c},
> +	{0x5303, 0x0f},
> +	{0x5304, 0x00},
> +	{0x5305, 0x70},
> +	{0x5306, 0x00},
> +	{0x5307, 0x80},
> +	{0x5308, 0x00},
> +	{0x5309, 0xa5},
> +	{0x530a, 0x00},
> +	{0x530b, 0xd3},
> +	{0x530c, 0x00},
> +	{0x530d, 0xf0},
> +	{0x530e, 0x01},
> +	{0x530f, 0x10},
> +	{0x5310, 0x01},
> +	{0x5311, 0x20},
> +	{0x5312, 0x01},
> +	{0x5313, 0x20},
> +	{0x5314, 0x01},
> +	{0x5315, 0x20},
> +	{0x5316, 0x08},
> +	{0x5317, 0x08},
> +	{0x5318, 0x10},
> +	{0x5319, 0x88},
> +	{0x531a, 0x88},
> +	{0x531b, 0xa9},
> +	{0x531c, 0xaa},
> +	{0x531d, 0x0a},
> +	{0x5405, 0x02},
> +	{0x5406, 0x67},
> +	{0x5407, 0x01},
> +	{0x5408, 0x4a},
> +};
> +
> +/* Configurations for supported link frequencies */
> +#define OV13858_NUM_OF_LINK_FREQS	2
> +#define OV13858_LINK_FREQ_1080MBPS	1080000000
> +#define OV13858_LINK_FREQ_540MBPS	540000000
> +#define OV13858_LINK_FREQ_INDEX_0	0
> +#define OV13858_LINK_FREQ_INDEX_1	1
> +
> +/* Menu items for LINK_FREQ V4L2 control */ static const const s64 
> +link_freq_menu_items[OV13858_NUM_OF_LINK_FREQS] = {
> +	OV13858_LINK_FREQ_1080MBPS,
> +	OV13858_LINK_FREQ_540MBPS
> +};
> +
> +/* Link frequency configs */
> +static const struct ov13858_link_freq_config
> +			link_freq_configs[OV13858_NUM_OF_LINK_FREQS] = {
> +	{
> +		.pixel_rate = 864000000,
> +		.reg_list = {
> +			.num_of_regs = ARRAY_SIZE(mipi_data_rate_1080mbps),
> +			.regs = mipi_data_rate_1080mbps,
> +		}
> +	},
> +	{
> +		.pixel_rate = 432000000,
> +		.reg_list = {
> +			.num_of_regs = ARRAY_SIZE(mipi_data_rate_540mbps),
> +			.regs = mipi_data_rate_540mbps,
> +		}
> +	}
> +};
> +
> +#define OV13858_GET_PIXEL_RATE(index) 
> +(link_freq_configs[index].pixel_rate)

Please refer to link_freq_configs directly. No really reason to have a macro.

> +
> +/* Mode configs */
> +static const struct ov13858_mode supported_modes[] = {
> +	{
> +		.width = 4224,
> +		.height = 3136,
> +		.vts = OV13858_VTS_30FPS,
> +		.reg_list = {
> +			.num_of_regs = ARRAY_SIZE(mode_4224x3136_regs),
> +			.regs = mode_4224x3136_regs,
> +		},
> +		.link_freq_index = OV13858_LINK_FREQ_INDEX_0,
> +	},
> +	{
> +		.width = 2112,
> +		.height = 1568,
> +		.vts = OV13858_VTS_30FPS,
> +		.reg_list = {
> +			.num_of_regs = ARRAY_SIZE(mode_2112x1568_regs),
> +			.regs = mode_2112x1568_regs,
> +		},
> +		.link_freq_index = OV13858_LINK_FREQ_INDEX_1,
> +	},
> +	{
> +		.width = 2112,
> +		.height = 1188,
> +		.vts = OV13858_VTS_30FPS,
> +		.reg_list = {
> +			.num_of_regs = ARRAY_SIZE(mode_2112x1188_regs),
> +			.regs = mode_2112x1188_regs,
> +		},
> +		.link_freq_index = OV13858_LINK_FREQ_INDEX_1,
> +	},
> +	{
> +		.width = 1056,
> +		.height = 784,
> +		.vts = OV13858_VTS_30FPS,
> +		.reg_list = {
> +			.num_of_regs = ARRAY_SIZE(mode_1056x784_regs),
> +			.regs = mode_1056x784_regs,
> +		},
> +		.link_freq_index = OV13858_LINK_FREQ_INDEX_1,
> +	}
> +};
> +
> +/* Supported raw bayer orders */
> +static const u32 supported_bayer_format[] = {
> +	MEDIA_BUS_FMT_SGRBG10_1X10,
> +	MEDIA_BUS_FMT_SRGGB10_1X10,
> +	MEDIA_BUS_FMT_SBGGR10_1X10,
> +	MEDIA_BUS_FMT_SGBRG10_1X10
> +};
> +
> +struct ov13858 {
> +	struct v4l2_subdev sd;
> +	struct media_pad pad;
> +
> +	struct v4l2_ctrl_handler ctrl_handler;
> +	/* Two read only controls */
> +	struct v4l2_ctrl *link_freq;
> +	struct v4l2_ctrl *pixel_rate;
> +
> +	/* Current mode */
> +	const struct ov13858_mode *cur_mode;
> +
> +	/* Current bayer format */
> +	u32 cur_bayer_format;
> +
> +	/* Num of skip frames */
> +	u32 num_of_skip_frames;
> +
> +	/* Mutex for serialized access */
> +	struct mutex mutex;
> +
> +	/* Streaming on/off */
> +	bool streaming;
> +};
> +
> +#define to_ov13858(_sd)	container_of(_sd, struct ov13858, sd)
> +
> +/* Read registers up to 4 at a time */ static int 
> +ov13858_read_reg(struct ov13858 *ov13858, u16 reg, u32 len, u32 *val) 
> +{
> +	struct i2c_client *client = v4l2_get_subdevdata(&ov13858->sd);
> +	struct i2c_msg msgs[2];
> +	u8 *data_be_p;
> +	int ret;
> +	u32 data_be = 0;
> +	u16 reg_addr_be = cpu_to_be16(reg);
> +
> +	if (len > 4)
> +		return -EINVAL;
> +
> +	data_be_p = (u8 *)&data_be;
> +	/* Write register address */
> +	msgs[0].addr = client->addr;
> +	msgs[0].flags = 0;
> +	msgs[0].len = 2;
> +	msgs[0].buf = (u8 *)&reg_addr_be;
> +
> +	/* Read data from register */
> +	msgs[1].addr = client->addr;
> +	msgs[1].flags = I2C_M_RD;
> +	msgs[1].len = len;
> +	msgs[1].buf = &data_be_p[4 - len];
> +
> +	ret = i2c_transfer(client->adapter, msgs, ARRAY_SIZE(msgs));
> +	if (ret != ARRAY_SIZE(msgs))
> +		return -EIO;
> +
> +	*val = be32_to_cpu(data_be);
> +
> +	return 0;
> +}
> +
> +/* Write registers up to 4 at a time */ static int 
> +ov13858_write_reg(struct ov13858 *ov13858, u16 reg, u32 len, u32 val) 
> +{
> +	struct i2c_client *client = v4l2_get_subdevdata(&ov13858->sd);
> +	int buf_i, val_i;
> +	u8 buf[6], *val_p;
> +
> +	if (len > 4)
> +		return -EINVAL;
> +
> +	buf[0] = reg >> 8;
> +	buf[1] = reg & 0xff;
> +
> +	buf_i = 2;
> +	val_p = (u8 *)&val;
> +	val_i = len - 1;
> +
> +	while (val_i >= 0)
> +		buf[buf_i++] = val_p[val_i--];
> +
> +	if (i2c_master_send(client, buf, len + 2) != len + 2)
> +		return -EIO;
> +
> +	return 0;
> +}
> +
> +/* Write a list of registers */
> +static int ov13858_write_regs(struct ov13858 *ov13858,
> +			      const struct ov13858_reg *regs, u32 len) {
> +	struct i2c_client *client = v4l2_get_subdevdata(&ov13858->sd);
> +	int ret;
> +	u32 i;
> +
> +	for (i = 0; i < len; i++) {
> +		ret = ov13858_write_reg(ov13858, regs[i].address, 1,
> +					regs[i].val);
> +		if (ret) {
> +			dev_err_ratelimited(
> +				&client->dev,
> +				"Failed to write reg 0x%4.4x. error = %d\n",
> +				regs[i].address, ret);
> +
> +			return ret;
> +		}
> +	}
> +
> +	return 0;
> +}
> +
> +static inline int ov13858_write_reg_list(struct ov13858 *ov13858,

I'd drop inline.

> +					 const struct ov13858_reg_list *r_list) {
> +	return ov13858_write_regs(ov13858, r_list->regs, 
> +r_list->num_of_regs); }
> +
> +/* Open sub-device */
> +static int ov13858_open(struct v4l2_subdev *sd, struct v4l2_subdev_fh 
> +*fh) {
> +	struct ov13858 *ov13858 = to_ov13858(sd);
> +	struct v4l2_mbus_framefmt *try_fmt;
> +
> +	mutex_lock(&ov13858->mutex);
> +
> +	/* Initialize try_fmt */
> +	try_fmt = v4l2_subdev_get_try_format(sd, fh->pad, 0);
> +	try_fmt->width = ov13858->cur_mode->width;
> +	try_fmt->height = ov13858->cur_mode->height;
> +	try_fmt->code = ov13858->cur_bayer_format;
> +	try_fmt->field = V4L2_FIELD_NONE;
> +
> +	/* No crop or compose */
> +	mutex_unlock(&ov13858->mutex);
> +
> +	return 0;
> +}
> +
> +/*
> + * Get the index of matched bayer format  */ static int 
> +ov13858_get_bayer_format(u32 format) {
> +	int i;
> +
> +	for (i = 0; i < ARRAY_SIZE(supported_bayer_format); i++) {
> +		if (supported_bayer_format[i] == format)
> +			return i;
> +	}
> +
> +	return -EINVAL;
> +}
> +
> +/*
> + * Start register group hold
> + */
> +static inline int ov13858_group_hold_start(struct ov13858 *ov13858,
> +					   u8 group_id)
> +{
> +	return ov13858_write_reg(ov13858, OV13858_REG_GROUP_ACCESS,
> +					  OV13858_REG_VALUE_08BIT,
> +					  OV13858_GROUP_HOLD_START(group_id));
> +}
> +
> +/*
> + * End register group hold
> + */
> +static inline int ov13858_group_hold_end(struct ov13858 *ov13858,
> +					 u8 group_id)
> +{
> +	return ov13858_write_reg(ov13858, OV13858_REG_GROUP_ACCESS,
> +					  OV13858_REG_VALUE_08BIT,
> +					  OV13858_GROUP_HOLD_END(group_id));
> +}
> +
> +/*
> + * Launch registers
> + */
> +static inline int ov13858_launch_group(struct ov13858 *ov13858,
> +				       u8 group_id)
> +{
> +	return ov13858_write_reg(ov13858, OV13858_REG_GROUP_ACCESS,
> +					  OV13858_REG_VALUE_08BIT,
> +					  OV13858_GROUP_LAUNCH(group_id)); }
> +
> +/*
> + * This function is called only after powerup to change the default 
> +bayer order
> + * to the user requested order.
> + */
> +static int ov13858_increase_offset(struct ov13858 *ov13858, u16 reg) 
> +{
> +	int ret;
> +	u32 val;
> +
> +	ret = ov13858_read_reg(ov13858, reg, OV13858_REG_VALUE_16BIT, &val);
> +	if (ret)
> +		return ret;
> +
> +	val++;
> +
> +	return ov13858_write_reg(ov13858, reg, OV13858_REG_VALUE_16BIT, 
> +val); }
> +
> +/*
> + * Change the bayer order to meet the requested one.
> + */
> +static int ov13858_apply_bayer_order(struct ov13858 *ov13858) {
> +	int ret;
> +
> +	switch (ov13858->cur_bayer_format) {
> +	case MEDIA_BUS_FMT_SGRBG10_1X10:
> +		break;
> +	case MEDIA_BUS_FMT_SRGGB10_1X10:
> +		return ov13858_increase_offset(ov13858, OV13858_REG_H_OFFSET);
> +	case MEDIA_BUS_FMT_SGBRG10_1X10:
> +		ret = ov13858_increase_offset(ov13858, OV13858_REG_H_OFFSET);

The bayer pixel order is defined by cropping the pixel array. If the sensor can do that, you should implement support for the crop selection rectangle instead.

I think it'd be possible to add support for that later on as well if needed.

> +		if (ret)
> +			return ret;
> +	/* no break, for GBRG, we need v offset too */
> +	case MEDIA_BUS_FMT_SBGGR10_1X10:
> +		return ov13858_increase_offset(ov13858, OV13858_REG_V_OFFSET);
> +	}
> +
> +	return 0;
> +}
> +
> +/*
> + * Update analog gain
> + */
> +static inline int ov13858_update_analog_gain(struct ov13858 *ov13858,
> +					     struct v4l2_ctrl *ctrl)
> +{
> +	return ov13858_write_reg(ov13858, OV13858_REG_ANALOG_GAIN,
> +				 OV13858_REG_VALUE_16BIT, ctrl->val); }
> +
> +/* Exposure control */
> +static int ov13858_update_exposure(struct ov13858 *ov13858,
> +				   struct v4l2_ctrl *ctrl)
> +{
> +	int ret;
> +	u32 exposure, new_vts = 0;
> +
> +	exposure = ctrl->val;
> +	if (exposure > ov13858->cur_mode->vts - 8)
> +		new_vts = exposure + 8;
> +	else
> +		new_vts = ov13858->cur_mode->vts;

Instead of changing the vertical blanking interval implicitly, could you do it explicitly though the VBLANK control instead?

As you do already control the vertical sync and provide the pixel rate control, how about adding a HBLANK control as well? I suppose it could be added later on as well. And presumably will be read only.

> +
> +	ret = ov13858_group_hold_start(ov13858, 0);
> +	if (ret)
> +		return ret;
> +
> +	ret = ov13858_write_reg(ov13858, OV13858_REG_VTS,
> +				OV13858_REG_VALUE_16BIT, new_vts);
> +	if (ret)
> +		return ret;
> +

If you want group hold for that, too, we need a new callback (or two) for the control handler I believe.

> +	exposure <<= 4;
> +	ret = ov13858_write_reg(ov13858, OV13858_REG_EXPOSURE,
> +				OV13858_REG_VALUE_24BIT, exposure);
> +	if (ret)
> +		return ret;
> +
> +	ret = ov13858_group_hold_end(ov13858, 0);
> +	if (ret)
> +		return ret;
> +
> +	return ov13858_launch_group(ov13858, 0); }
> +
> +/* Initialize control handlers */
> +static int ov13858_set_ctrl(struct v4l2_ctrl *ctrl) {
> +	struct ov13858 *ov13858 = container_of(ctrl->handler,
> +					       struct ov13858, ctrl_handler);
> +	struct i2c_client *client = v4l2_get_subdevdata(&ov13858->sd);
> +	int ret = 0;

No need to initialise ret.

> +
> +	/* Values of V4L2 controls will be applied only when power is up */
> +	if (atomic_read(&client->dev.power.usage_count) == 0)

I wonder if using pm_runtime_active() would work for this. Checking the usage_count directly does not look like something a driver should be doing.

> +		return 0;
> +
> +	ret = pm_runtime_get_sync(&client->dev);
> +	if (ret < 0) {
> +		pm_runtime_put_noidle(&client->dev);
> +		return ret;
> +	}
> +
> +	ret = 0;
> +	switch (ctrl->id) {
> +	case V4L2_CID_ANALOGUE_GAIN:
> +		ret = ov13858_update_analog_gain(ov13858, ctrl);
> +		break;
> +	case V4L2_CID_EXPOSURE:
> +		ret = ov13858_update_exposure(ov13858, ctrl);
> +		break;
> +	default:
> +		dev_info(&client->dev,
> +			 "ctrl(id:0x%x,val:0x%x) is not handled\n",
> +			 ctrl->id, ctrl->val);
> +		break;
> +	};
> +
> +	pm_runtime_put(&client->dev);
> +
> +	return ret;
> +}
> +
> +static const struct v4l2_ctrl_ops ov13858_ctrl_ops = {
> +	.s_ctrl = ov13858_set_ctrl,
> +};
> +
> +/* Initialize control handlers */
> +static int ov13858_init_controls(struct ov13858 *ov13858) {
> +	struct i2c_client *client = v4l2_get_subdevdata(&ov13858->sd);
> +	struct v4l2_ctrl_handler *ctrl_hdlr;
> +	int ret;
> +
> +	ctrl_hdlr = &ov13858->ctrl_handler;
> +	ret = v4l2_ctrl_handler_init(ctrl_hdlr, 4);
> +	if (ret)
> +		return ret;
> +
> +	ctrl_hdlr->lock = &ov13858->mutex;
> +	ov13858->link_freq = v4l2_ctrl_new_int_menu(ctrl_hdlr,
> +				&ov13858_ctrl_ops,
> +				V4L2_CID_LINK_FREQ,
> +				OV13858_NUM_OF_LINK_FREQS - 1,
> +				0,
> +				link_freq_menu_items);
> +	ov13858->link_freq->flags |= V4L2_CTRL_FLAG_READ_ONLY;
> +
> +	/* By default, PIXEL_RATE is read only */
> +	ov13858->pixel_rate = v4l2_ctrl_new_std(ctrl_hdlr, &ov13858_ctrl_ops,
> +					V4L2_CID_PIXEL_RATE, 0,
> +					OV13858_GET_PIXEL_RATE(0), 1,
> +					OV13858_GET_PIXEL_RATE(0));
> +
> +	v4l2_ctrl_new_std(ctrl_hdlr, &ov13858_ctrl_ops, V4L2_CID_ANALOGUE_GAIN,
> +			  OV13858_ANA_GAIN_MIN, OV13858_ANA_GAIN_MAX,
> +			  OV13858_ANA_GAIN_STEP, OV13858_ANA_GAIN_DEFAULT);
> +
> +	v4l2_ctrl_new_std(ctrl_hdlr, &ov13858_ctrl_ops, V4L2_CID_EXPOSURE,
> +			  OV13858_EXP_GAIN_MIN, OV13858_EXP_GAIN_MAX,
> +			  OV13858_EXP_GAIN_STEP, OV13858_EXP_GAIN_DEFAULT);

Are the minimum and maximum values dependent on the register list chosen?

> +	if (ctrl_hdlr->error) {
> +		ret = ctrl_hdlr->error;
> +		dev_err(&client->dev, "%s control init failed (%d)\n",
> +			__func__, ret);
> +		goto error;
> +	}
> +
> +	ov13858->sd.ctrl_handler = ctrl_hdlr;
> +
> +	return 0;
> +
> +error:
> +	v4l2_ctrl_handler_free(ctrl_hdlr);
> +
> +	return ret;
> +}
> +
> +static void ov13858_update_pad_format(struct ov13858 *ov13858,
> +				      const struct ov13858_mode *mode,
> +				      struct v4l2_subdev_format *fmt) {
> +	fmt->format.width = mode->width;
> +	fmt->format.height = mode->height;
> +	fmt->format.code = ov13858->cur_bayer_format;
> +	fmt->format.field = V4L2_FIELD_NONE; }
> +
> +static int ov13858_do_get_pad_format(struct ov13858 *ov13858,
> +				     struct v4l2_subdev_pad_config *cfg,
> +				     struct v4l2_subdev_format *fmt) {
> +	struct v4l2_mbus_framefmt *framefmt;
> +	struct v4l2_subdev *sd = &ov13858->sd;
> +
> +	if (fmt->which == V4L2_SUBDEV_FORMAT_TRY) {
> +		framefmt = v4l2_subdev_get_try_format(sd, cfg, fmt->pad);
> +		fmt->format = *framefmt;

You could write this as :

fmt->format = *v4l2_subdev_get_try_format(&ov13858->sd, cfg, fmt->pad);


> +	} else {
> +		ov13858_update_pad_format(ov13858, ov13858->cur_mode, fmt);
> +	}
> +
> +	return 0;
> +}
> +
> +static int ov13858_enum_mbus_code(struct v4l2_subdev *sd,
> +				  struct v4l2_subdev_pad_config *cfg,
> +				  struct v4l2_subdev_mbus_code_enum *code) {
> +	if (code->index >= ARRAY_SIZE(supported_bayer_format))
> +		return -EINVAL;
> +
> +	code->code = supported_bayer_format[code->index];

Newline, please.

> +	return 0;
> +}
> +
> +static int ov13858_enum_frame_size(struct v4l2_subdev *sd,
> +				   struct v4l2_subdev_pad_config *cfg,
> +				   struct v4l2_subdev_frame_size_enum *fse) {
> +	if (fse->index >= ARRAY_SIZE(supported_modes))
> +		return -EINVAL;
> +
> +	if (ov13858_get_bayer_format(fse->code) < 0)
> +		return -EINVAL;
> +
> +	fse->min_width = supported_modes[fse->index].width;
> +	fse->max_width = fse->min_width;
> +	fse->min_height = supported_modes[fse->index].height;
> +	fse->max_height = fse->min_height;
> +
> +	return 0;
> +}
> +
> +static int ov13858_get_pad_format(struct v4l2_subdev *sd,
> +				  struct v4l2_subdev_pad_config *cfg,
> +				  struct v4l2_subdev_format *fmt) {
> +	struct ov13858 *ov13858 = to_ov13858(sd);
> +	int ret;
> +
> +	mutex_lock(&ov13858->mutex);
> +	ret = ov13858_do_get_pad_format(ov13858, cfg, fmt);

It'd be nice to have ov13858_do_get_pad_format() defined right above this function.

> +	mutex_unlock(&ov13858->mutex);
> +
> +	return ret;
> +}
> +
> +/*
> + * Calculate resolution distance
> + */
> +static inline int
> +ov13858_get_resolution_dist(const struct ov13858_mode *mode,
> +			    struct v4l2_mbus_framefmt *framefmt) {
> +	return abs(mode->width - framefmt->width) +
> +	       abs(mode->height - framefmt->height); }
> +
> +/*
> + * Find the closest supported resolution to the requested resolution
> + */
> +static const struct ov13858_mode *
> +ov13858_find_best_fit(struct ov13858 *ov13858,
> +		      struct v4l2_subdev_format *fmt)
> +{
> +	int i, dist, cur_best_fit = 0, cur_best_fit_dist = -1;
> +	struct v4l2_mbus_framefmt *framefmt = &fmt->format;
> +
> +	for (i = 0; i < ARRAY_SIZE(supported_modes); i++) {
> +		dist = ov13858_get_resolution_dist(&supported_modes[i],
> +						   framefmt);
> +		if (cur_best_fit_dist == -1 || dist < cur_best_fit_dist) {
> +			cur_best_fit_dist = dist;
> +			cur_best_fit = i;
> +		}
> +	}
> +
> +	return &supported_modes[cur_best_fit];
> +}
> +
> +static int
> +ov13858_set_pad_format(struct v4l2_subdev *sd,
> +		       struct v4l2_subdev_pad_config *cfg,
> +		       struct v4l2_subdev_format *fmt)
> +{
> +	struct ov13858 *ov13858 = to_ov13858(sd);
> +	const struct ov13858_mode *mode;
> +	struct v4l2_mbus_framefmt *framefmt;
> +	int bayer_index;
> +
> +	mutex_lock(&ov13858->mutex);
> +
> +	/* Only raw bayer is supported */
> +	bayer_index = ov13858_get_bayer_format(fmt->format.code);
> +	if (bayer_index < 0)
> +		bayer_index = 0; /* Not found, suggest GRBG */
> +
> +	ov13858->cur_bayer_format = supported_bayer_format[bayer_index];
> +	mode = ov13858_find_best_fit(ov13858, fmt);
> +	ov13858_update_pad_format(ov13858, mode, fmt);
> +	if (fmt->which == V4L2_SUBDEV_FORMAT_TRY) {
> +		framefmt = v4l2_subdev_get_try_format(sd, cfg, fmt->pad);
> +		*framefmt = fmt->format;

This, too, could be more simple without temporary variables.

> +	} else {
> +		ov13858->cur_mode = mode;
> +		__v4l2_ctrl_s_ctrl(ov13858->link_freq, mode->link_freq_index);
> +		__v4l2_ctrl_s_ctrl_int64(
> +				ov13858->pixel_rate,
> +				OV13858_GET_PIXEL_RATE(mode->link_freq_index));
> +	}
> +
> +	mutex_unlock(&ov13858->mutex);
> +
> +	return 0;
> +}
> +
> +static int ov13858_get_skip_frames(struct v4l2_subdev *sd, u32 *frames)
> +{
> +	struct ov13858 *ov13858 = to_ov13858(sd);
> +
> +	mutex_lock(&ov13858->mutex);
> +	*frames = ov13858->num_of_skip_frames;
> +	mutex_unlock(&ov13858->mutex);
> +
> +	return 0;
> +}
> +
> +/*
> + * Prepare streaming by writing default values and customized values.
> + * This should be called with ov13858->mutex acquired.
> + */
> +static int ov13858_prepare_streaming(struct ov13858 *ov13858)
> +{
> +	struct i2c_client *client = v4l2_get_subdevdata(&ov13858->sd);
> +	const struct ov13858_reg_list *reg_list;
> +	int ret, link_freq_index;
> +
> +	/* Get out of from software reset */
> +	ret = ov13858_write_reg(ov13858, OV13858_REG_SOFTWARE_RST,
> +				OV13858_REG_VALUE_08BIT, OV13858_SOFTWARE_RST);
> +	if (ret) {
> +		dev_err(&client->dev, "%s failed to set powerup registers\n",
> +			__func__);
> +		return ret;
> +	}
> +
> +	/* Setup PLL */
> +	link_freq_index = ov13858->cur_mode->link_freq_index;
> +	reg_list = &link_freq_configs[link_freq_index].reg_list;
> +	ret = ov13858_write_reg_list(ov13858, reg_list);
> +	if (ret) {
> +		dev_err(&client->dev, "%s failed to set plls\n", __func__);
> +		return ret;
> +	}
> +
> +	/* Apply default values of current mode */
> +	reg_list = &ov13858->cur_mode->reg_list;
> +	ret = ov13858_write_reg_list(ov13858, reg_list);
> +	if (ret) {
> +		dev_err(&client->dev, "%s failed to set mode\n", __func__);
> +		return ret;
> +	}
> +
> +	/* Apply customized values from user */
> +	__v4l2_ctrl_handler_setup(ov13858->sd.ctrl_handler);
> +
> +	/* Apply bayer order from user */
> +	return ov13858_apply_bayer_order(ov13858);
> +}
> +
> +/* Start streaming */
> +static inline int ov13858_start_streaming(struct ov13858 *ov13858)
> +{
> +	int ret;
> +
> +	/* Write default & customized values */
> +	ret = ov13858_prepare_streaming(ov13858);
> +	if (ret)
> +		return ret;
> +
> +	return ov13858_write_reg(ov13858, OV13858_REG_MODE_SELECT,
> +				 OV13858_REG_VALUE_08BIT,
> +				 OV13858_MODE_STREAMING);
> +}
> +
> +/* Stop streaming */
> +static inline int ov13858_stop_streaming(struct ov13858 *ov13858)
> +{
> +	return ov13858_write_reg(ov13858, OV13858_REG_MODE_SELECT,
> +				 OV13858_REG_VALUE_08BIT, OV13858_MODE_STANDBY);
> +}
> +
> +static int ov13858_set_stream(struct v4l2_subdev *sd, int enable)
> +{
> +	struct ov13858 *ov13858 = to_ov13858(sd);
> +	struct i2c_client *client = v4l2_get_subdevdata(sd);
> +	int ret = 0;
> +
> +	mutex_lock(&ov13858->mutex);
> +	if (ov13858->streaming == enable) {
> +		mutex_unlock(&ov13858->mutex);
> +		return 0;
> +	}
> +
> +	if (enable) {
> +		ret = pm_runtime_get_sync(&client->dev);
> +		if (ret < 0) {
> +			pm_runtime_put_noidle(&client->dev);
> +			goto err_unlock;
> +		}
> +
> +		/*
> +		 * Apply default & customized values
> +		 * and then start streaming.
> +		 */
> +		ret = ov13858_start_streaming(ov13858);
> +		if (ret)
> +			goto err_rpm_put;
> +	} else {
> +		ret = ov13858_stop_streaming(ov13858);

Providing a non-zero return value on disabling streaming doesn't really
help. Please just use zero.

ov13858_stop_streaming() could have void return type, but perhaps it could
complain out lout about a failing write.

> +		pm_runtime_put(&client->dev);
> +	}
> +
> +	ov13858->streaming = enable;
> +	mutex_unlock(&ov13858->mutex);
> +
> +	return ret;
> +
> +err_rpm_put:
> +	pm_runtime_put(&client->dev);
> +err_unlock:
> +	mutex_unlock(&ov13858->mutex);
> +
> +	return ret;
> +}
> +
> +#ifdef CONFIG_PM
> +
> +static int ov13858_suspend(struct device *dev)
> +{
> +	struct i2c_client *client = to_i2c_client(dev);
> +	struct v4l2_subdev *sd = i2c_get_clientdata(client);
> +	struct ov13858 *ov13858 = to_ov13858(sd);
> +
> +	if (ov13858->streaming)
> +		ov13858_stop_streaming(ov13858);
> +
> +	return 0;
> +}
> +
> +static int ov13858_resume(struct device *dev)
> +{
> +	struct i2c_client *client = to_i2c_client(dev);
> +	struct v4l2_subdev *sd = i2c_get_clientdata(client);
> +	struct ov13858 *ov13858 = to_ov13858(sd);
> +	int ret;
> +
> +	if (ov13858->streaming) {
> +		ret = ov13858_start_streaming(ov13858);
> +		if (ret)
> +			goto error;
> +	}
> +
> +	return 0;
> +
> +error:
> +	ov13858_stop_streaming(ov13858);
> +	ov13858->streaming = 0;
> +	return ret;
> +}
> +
> +#else
> +
> +#define ov13858_suspend	NULL
> +#define ov13858_resume	NULL

Please use __maybe_unused as the smiapp driver does for the same, no need
for #ifdefs.

> +
> +#endif	/* CONFIG_PM */
> +
> +/* Verify chip ID */
> +static inline int ov13858_identify_module(struct ov13858 *ov13858)
> +{
> +	struct i2c_client *client = v4l2_get_subdevdata(&ov13858->sd);
> +	int ret;
> +	u32 val;
> +
> +	ret = ov13858_read_reg(ov13858, OV13858_REG_CHIP_ID,
> +			       OV13858_REG_VALUE_24BIT, &val);
> +	if (ret)
> +		return ret;
> +
> +	if (val != OV13858_CHIP_ID) {
> +		dev_err(&client->dev, "chip id mismatch: %x!=%x\n",
> +			OV13858_CHIP_ID, val);
> +		return -EIO;
> +	}
> +
> +	return 0;
> +}
> +
> +static const struct v4l2_subdev_video_ops ov13858_video_ops = {
> +	.s_stream = ov13858_set_stream,
> +};
> +
> +static const struct v4l2_subdev_pad_ops ov13858_pad_ops = {
> +	.enum_mbus_code = ov13858_enum_mbus_code,
> +	.get_fmt = ov13858_get_pad_format,
> +	.set_fmt = ov13858_set_pad_format,
> +	.enum_frame_size = ov13858_enum_frame_size,
> +};
> +
> +static const struct v4l2_subdev_sensor_ops ov13858_sensor_ops = {
> +	.g_skip_frames = ov13858_get_skip_frames,
> +};
> +
> +static const struct v4l2_subdev_ops ov13858_subdev_ops = {
> +	.video = &ov13858_video_ops,
> +	.pad = &ov13858_pad_ops,
> +	.sensor = &ov13858_sensor_ops,
> +};
> +
> +static const struct media_entity_operations ov13858_subdev_entity_ops = {
> +	.link_validate = v4l2_subdev_link_validate,
> +};
> +
> +static const struct v4l2_subdev_internal_ops ov13858_internal_ops = {
> +	.open = ov13858_open,
> +};
> +
> +static int ov13858_probe(struct i2c_client *client,
> +			 const struct i2c_device_id *devid)
> +{
> +	struct ov13858 *ov13858;
> +	int ret;
> +
> +	ov13858 = devm_kzalloc(&client->dev, sizeof(*ov13858), GFP_KERNEL);
> +	if (!ov13858)
> +		return -ENOMEM;
> +
> +	/* Initialize subdev */
> +	v4l2_i2c_subdev_init(&ov13858->sd, client, &ov13858_subdev_ops);
> +
> +	/* Check module identity */
> +	ret = ov13858_identify_module(ov13858);
> +	if (ret) {
> +		dev_err(&client->dev, "failed to find sensor: %d\n", ret);
> +		return ret;
> +	}
> +
> +	mutex_init(&ov13858->mutex);
> +
> +	/* Set default mode to max resolution */
> +	ov13858->cur_mode = &supported_modes[0];
> +
> +	/* Set default bayer format with GRBG */
> +	ov13858->cur_bayer_format = supported_bayer_format[0];
> +
> +	/* Set number of frames to skip */
> +	ov13858->num_of_skip_frames = OV13858_NUM_OF_SKIP_FRAMES;
> +
> +	ret = ov13858_init_controls(ov13858);
> +	if (ret)

mutex_init() needs to be followed by mutex_destroy(). Add a new label for
error handling?

> +		return ret;
> +
> +	/* Initialize subdev */
> +	ov13858->sd.internal_ops = &ov13858_internal_ops;
> +	ov13858->sd.flags |= V4L2_SUBDEV_FL_HAS_DEVNODE;
> +	ov13858->sd.entity.ops = &ov13858_subdev_entity_ops;
> +	ov13858->sd.entity.function = MEDIA_ENT_F_CAM_SENSOR;
> +
> +	/* Initialize source pad */
> +	ov13858->pad.flags = MEDIA_PAD_FL_SOURCE;
> +	ret = media_entity_pads_init(&ov13858->sd.entity, 1, &ov13858->pad);
> +	if (ret) {
> +		dev_err(&client->dev, "%s failed:%d\n", __func__, ret);
> +		goto error_handler_free;
> +	}
> +
> +	/* Enable runtime pm management */
> +	pm_runtime_enable(&client->dev);
> +
> +	ret = v4l2_async_register_subdev(&ov13858->sd);
> +	if (ret < 0)
> +		goto error_disable_rpm;
> +
> +	dev_info(&client->dev, "%s done\n", __func__);

If that's all you'd tell I'd remove the print.

> +
> +	return 0;
> +
> +error_disable_rpm:
> +	pm_runtime_disable(&client->dev);
> +	media_entity_cleanup(&ov13858->sd.entity);
> +
> +error_handler_free:
> +	v4l2_ctrl_handler_free(ov13858->sd.ctrl_handler);
> +	dev_err(&client->dev, "%s failed:%d\n", __func__, ret);
> +
> +	return ret;
> +}
> +
> +static int ov13858_remove(struct i2c_client *client)
> +{
> +	struct v4l2_subdev *sd = i2c_get_clientdata(client);
> +
> +	v4l2_async_unregister_subdev(sd);
> +	media_entity_cleanup(&sd->entity);
> +	v4l2_ctrl_handler_free(sd->ctrl_handler);
> +	pm_runtime_disable(&client->dev);

mutex_destroy() here, too.

> +
> +	return 0;
> +}
> +
> +static const struct i2c_device_id ov13858_id_table[] = {
> +	{"ov13858", 0},
> +	{},
> +};
> +
> +MODULE_DEVICE_TABLE(i2c, ov13858_id_table);
> +
> +static const struct dev_pm_ops ov13858_pm_ops = {
> +	SET_SYSTEM_SLEEP_PM_OPS(ov13858_suspend, ov13858_resume)
> +};
> +
> +#ifdef CONFIG_ACPI
> +static const struct acpi_device_id ov13858_acpi_ids[] = {
> +	{"OVTID858"},
> +	{ /* sentinel */ }
> +};
> +
> +MODULE_DEVICE_TABLE(acpi, ov13858_acpi_ids);
> +#endif
> +
> +static struct i2c_driver ov13858_i2c_driver = {
> +	.driver = {
> +		.name = "ov13858",
> +		.owner = THIS_MODULE,
> +		.pm = &ov13858_pm_ops,
> +		.acpi_match_table = ACPI_PTR(ov13858_acpi_ids),
> +	},
> +	.probe = ov13858_probe,
> +	.remove = ov13858_remove,
> +	.id_table = ov13858_id_table,
> +};
> +
> +module_i2c_driver(ov13858_i2c_driver);
> +
> +MODULE_AUTHOR("Kan, Chris <chris.kan@intel.com>");
> +MODULE_AUTHOR("Rapolu, Chiranjeevi <chiranjeevi.rapolu@intel.com>");
> +MODULE_AUTHOR("Yang, Hyungwoo <hyungwoo.yang@intel.com>");
> +MODULE_DESCRIPTION("Omnivision ov13858 sensor driver");
> +MODULE_LICENSE("GPL v2");

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
