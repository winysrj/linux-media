Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:51142 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750774AbdBBKgN (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 2 Feb 2017 05:36:13 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Steve Longerbeam <slongerbeam@gmail.com>
Cc: robh+dt@kernel.org, mark.rutland@arm.com, shawnguo@kernel.org,
        kernel@pengutronix.de, fabio.estevam@nxp.com,
        linux@armlinux.org.uk, mchehab@kernel.org, hverkuil@xs4all.nl,
        nick@shmanahar.org, markus.heiser@darmarit.de,
        p.zabel@pengutronix.de, laurent.pinchart+renesas@ideasonboard.com,
        bparrot@ti.com, geert@linux-m68k.org, arnd@arndb.de,
        sudipm.mukherjee@gmail.com, minghsiu.tsai@mediatek.com,
        tiffany.lin@mediatek.com, jean-christophe.trotin@st.com,
        horms+renesas@verge.net.au, niklas.soderlund+renesas@ragnatech.se,
        robert.jarzmik@free.fr, songjun.wu@microchip.com,
        andrew-ct.chen@mediatek.com, gregkh@linuxfoundation.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org,
        Steve Longerbeam <steve_longerbeam@mentor.com>
Subject: Re: [PATCH v3 22/24] media: imx: Add MIPI CSI-2 OV5640 sensor subdev driver
Date: Thu, 02 Feb 2017 12:36:31 +0200
Message-ID: <15482412.XOGz6nc3Rt@avalon>
In-Reply-To: <1483755102-24785-23-git-send-email-steve_longerbeam@mentor.com>
References: <1483755102-24785-1-git-send-email-steve_longerbeam@mentor.com> <1483755102-24785-23-git-send-email-steve_longerbeam@mentor.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Steve,

Thank you for the patch. Many of the comments below apply to the ov5642 driver 
too, please take them into account when reworking patch 23/24.

On Friday 06 Jan 2017 18:11:40 Steve Longerbeam wrote:
> This driver is based on ov5640_mipi.c from Freescale imx_3.10.17_1.0.0_beta
> branch, modified heavily to bring forward to latest interfaces and code
> cleanup.
> 
> Signed-off-by: Steve Longerbeam <steve_longerbeam@mentor.com>
> ---
>  drivers/staging/media/imx/Kconfig       |    8 +
>  drivers/staging/media/imx/Makefile      |    2 +
>  drivers/staging/media/imx/ov5640-mipi.c | 2348 ++++++++++++++++++++++++++++

You're missing DT bindings.

The driver should go to drivers/media/i2c/ as it should not be specific to the 
i.MX6, and you can just call it ov5640.c.

>  3 files changed, 2358 insertions(+)
>  create mode 100644 drivers/staging/media/imx/ov5640-mipi.c
> 
> diff --git a/drivers/staging/media/imx/Kconfig
> b/drivers/staging/media/imx/Kconfig index ce2d2c8..09f373d 100644
> --- a/drivers/staging/media/imx/Kconfig
> +++ b/drivers/staging/media/imx/Kconfig
> @@ -17,5 +17,13 @@ config VIDEO_IMX_CAMERA
>  	---help---
>  	  A video4linux camera capture driver for i.MX5/6.
> 
> +config IMX_OV5640_MIPI
> +       tristate "OmniVision OV5640 MIPI CSI-2 camera support"
> +       depends on GPIOLIB && VIDEO_IMX_CAMERA

The sensor driver is generic, it shouldn't depend on IMX. It should however 
depend on at least I2C and OF by the look of it.

> +       select IMX_MIPI_CSI2
> +       default y
> +       ---help---
> +         MIPI CSI-2 OV5640 Camera support.
> +
>  endmenu
>  endif

[snip]

> diff --git a/drivers/staging/media/imx/ov5640-mipi.c
> b/drivers/staging/media/imx/ov5640-mipi.c new file mode 100644
> index 0000000..54647a7
> --- /dev/null
> +++ b/drivers/staging/media/imx/ov5640-mipi.c
> @@ -0,0 +1,2348 @@
> +/*
> + * Copyright (c) 2014 Mentor Graphics Inc.
> + * Copyright (C) 2011-2013 Freescale Semiconductor, Inc. All Rights
> Reserved.
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
> + */
> +
> +#include <linux/module.h>
> +#include <linux/init.h>
> +#include <linux/slab.h>
> +#include <linux/ctype.h>
> +#include <linux/types.h>
> +#include <linux/delay.h>
> +#include <linux/device.h>
> +#include <linux/i2c.h>
> +#include <linux/of_device.h>
> +#include <linux/gpio/consumer.h>
> +#include <linux/regulator/consumer.h>
> +#include <linux/clk.h>
> +#include <linux/clk-provider.h>
> +#include <linux/clkdev.h>
> +#include <media/v4l2-device.h>
> +#include <media/v4l2-subdev.h>
> +#include <media/v4l2-async.h>
> +#include <media/v4l2-of.h>
> +#include <media/v4l2-ctrls.h>

Pet peeve of mine, please sort the headers alphabetically. It makes it easier 
to locate duplicated.

> +
> +#define OV5640_VOLTAGE_ANALOG               2800000
> +#define OV5640_VOLTAGE_DIGITAL_CORE         1500000
> +#define OV5640_VOLTAGE_DIGITAL_IO           1800000
> +
> +#define MIN_FPS 15
> +#define MAX_FPS 30
> +#define DEFAULT_FPS 30
> +
> +/* min/typical/max system clock (xclk) frequencies */
> +#define OV5640_XCLK_MIN  6000000
> +#define OV5640_XCLK_TYP 24000000
> +#define OV5640_XCLK_MAX 54000000
> +
> +/* min/typical/max pixel clock (mclk) frequencies */
> +#define OV5640_MCLK_MIN 48000000
> +#define OV5640_MCLK_TYP 48000000
> +#define OV5640_MCLK_MAX 96000000
> +
> +#define OV5640_CHIP_ID  0x300A
> +#define OV5640_SLAVE_ID 0x3100
> +#define OV5640_DEFAULT_SLAVE_ID 0x3c

You're mixing lower-case and upper-case hex constants. Let's pick one. Kernel 
code usually favours lower-case.

Please define macros for all the other numerical constants you use in the 
driver (register addresses and values). The large registers tables can be an 
exception if you don't have access to the information, but for registers 
written manually, hardcoding numerical values isn't good.

> +
> +#define OV5640_MAX_CONTROLS 64
> +
> +enum ov5640_mode {
> +	ov5640_mode_MIN = 0,
> +	ov5640_mode_QCIF_176_144 = 0,
> +	ov5640_mode_QVGA_320_240,
> +	ov5640_mode_VGA_640_480,
> +	ov5640_mode_NTSC_720_480,
> +	ov5640_mode_PAL_720_576,
> +	ov5640_mode_XGA_1024_768,
> +	ov5640_mode_720P_1280_720,
> +	ov5640_mode_1080P_1920_1080,
> +	ov5640_mode_QSXGA_2592_1944,
> +	ov5640_num_modes,
> +	ov5640_mode_INIT = 0xff, /*only for sensor init*/

Please add spaces after /* and before */.

Enumerated values should be all upper-case.

> +};
> +
> +enum ov5640_frame_rate {
> +	ov5640_15_fps,
> +	ov5640_30_fps
> +};
> +
> +static int ov5640_framerates[] = {
> +	[ov5640_15_fps] = 15,
> +	[ov5640_30_fps] = 30,
> +};
> +#define ov5640_num_framerates ARRAY_SIZE(ov5640_framerates)
> +
> +/* image size under 1280 * 960 are SUBSAMPLING
> + * image size upper 1280 * 960 are SCALING
> + */

The kernel multi-line comment style is

/*
 * text
 * text
 */

> +enum ov5640_downsize_mode {
> +	SUBSAMPLING,
> +	SCALING,
> +};
> +
> +struct reg_value {
> +	u16 reg_addr;
> +	u8 val;
> +	u8 mask;
> +	u32 delay_ms;
> +};
> +
> +struct ov5640_mode_info {
> +	enum ov5640_mode mode;
> +	enum ov5640_downsize_mode dn_mode;
> +	u32 width;
> +	u32 height;
> +	struct reg_value *init_data_ptr;
> +	u32 init_data_size;
> +};
> +
> +struct ov5640_dev {
> +	struct i2c_client *i2c_client;
> +	struct device *dev;
> +	struct v4l2_subdev sd;
> +	struct media_pad pad;
> +	struct v4l2_ctrl_handler ctrl_hdl;
> +	struct v4l2_of_endpoint ep; /* the parsed DT endpoint info */
> +	struct v4l2_mbus_framefmt fmt;
> +	struct v4l2_captureparm streamcap;
> +	struct clk *xclk; /* system clock to OV5640 */
> +	int xclk_freq;    /* requested xclk freq from devicetree */
> +
> +	enum ov5640_mode current_mode;

Store a (const) pointer to the corresponding ov5640_mode_info instead, it will 
simplify the code and allow you to get rid of the ov5640_mode enum.

> +	enum ov5640_frame_rate current_fr;
> +
> +	bool on;
> +	bool awb_on;
> +	bool agc_on;
> +
> +	/* cached control settings */
> +	int ctrl_cache[OV5640_MAX_CONTROLS];
> +
> +	struct gpio_desc *reset_gpio;
> +	struct gpio_desc *pwdn_gpio;
> +	struct gpio_desc *gp_gpio;
> +
> +	int prev_sysclk, prev_hts;
> +	int ae_low, ae_high, ae_target;

Can't these be unsigned int ?

> +
> +	struct regulator *io_regulator;
> +	struct regulator *core_regulator;
> +	struct regulator *analog_regulator;
> +	struct regulator *gpo_regulator;
> +};
> +
> +static inline struct ov5640_dev *to_ov5640_dev(struct v4l2_subdev *sd)
> +{
> +	return container_of(sd, struct ov5640_dev, sd);
> +}
> +
> +static inline struct ov5640_dev *ctrl_to_ov5640_dev(struct v4l2_ctrl *ctrl)
> +{
> +	return container_of(ctrl->handler, struct ov5640_dev, ctrl_hdl);
> +}
> +
> +struct ov5640_control {
> +	struct v4l2_queryctrl ctrl;
> +	int (*set)(struct ov5640_dev *sensor, int value);
> +};
> +
> +static void ov5640_power(struct ov5640_dev *sensor, bool enable);
> +static void ov5640_reset(struct ov5640_dev *sensor);
> +static int ov5640_restore_ctrls(struct ov5640_dev *sensor);
> +static int ov5640_set_agc(struct ov5640_dev *sensor, int value);
> +static int ov5640_set_exposure(struct ov5640_dev *sensor, int value);
> +static int ov5640_get_exposure(struct ov5640_dev *sensor);
> +static int ov5640_set_gain(struct ov5640_dev *sensor, int value);
> +static int ov5640_get_gain(struct ov5640_dev *sensor);

No forward declarations please. You should reorder functions as needed (and of 
course still group related functions together).

> +static struct reg_value ov5640_init_setting_30fps_VGA[] = {
> +
> +	{0x3103, 0x11, 0, 0}, {0x3008, 0x82, 0, 5}, {0x3008, 0x42, 0, 0},
> +	{0x3103, 0x03, 0, 0}, {0x3017, 0x00, 0, 0}, {0x3018, 0x00, 0, 0},
> +	{0x3034, 0x18, 0, 0}, {0x3035, 0x14, 0, 0}, {0x3036, 0x38, 0, 0},
> +	{0x3037, 0x13, 0, 0}, {0x3108, 0x01, 0, 0}, {0x3630, 0x36, 0, 0},
> +	{0x3631, 0x0e, 0, 0}, {0x3632, 0xe2, 0, 0}, {0x3633, 0x12, 0, 0},
> +	{0x3621, 0xe0, 0, 0}, {0x3704, 0xa0, 0, 0}, {0x3703, 0x5a, 0, 0},
> +	{0x3715, 0x78, 0, 0}, {0x3717, 0x01, 0, 0}, {0x370b, 0x60, 0, 0},
> +	{0x3705, 0x1a, 0, 0}, {0x3905, 0x02, 0, 0}, {0x3906, 0x10, 0, 0},
> +	{0x3901, 0x0a, 0, 0}, {0x3731, 0x12, 0, 0}, {0x3600, 0x08, 0, 0},
> +	{0x3601, 0x33, 0, 0}, {0x302d, 0x60, 0, 0}, {0x3620, 0x52, 0, 0},
> +	{0x371b, 0x20, 0, 0}, {0x471c, 0x50, 0, 0}, {0x3a13, 0x43, 0, 0},
> +	{0x3a18, 0x00, 0, 0}, {0x3a19, 0xf8, 0, 0}, {0x3635, 0x13, 0, 0},
> +	{0x3636, 0x03, 0, 0}, {0x3634, 0x40, 0, 0}, {0x3622, 0x01, 0, 0},
> +	{0x3c01, 0xa4, 0, 0}, {0x3c04, 0x28, 0, 0}, {0x3c05, 0x98, 0, 0},
> +	{0x3c06, 0x00, 0, 0}, {0x3c07, 0x08, 0, 0}, {0x3c08, 0x00, 0, 0},
> +	{0x3c09, 0x1c, 0, 0}, {0x3c0a, 0x9c, 0, 0}, {0x3c0b, 0x40, 0, 0},
> +	{0x3820, 0x41, 0, 0}, {0x3821, 0x07, 0, 0}, {0x3814, 0x31, 0, 0},
> +	{0x3815, 0x31, 0, 0}, {0x3800, 0x00, 0, 0}, {0x3801, 0x00, 0, 0},
> +	{0x3802, 0x00, 0, 0}, {0x3803, 0x04, 0, 0}, {0x3804, 0x0a, 0, 0},
> +	{0x3805, 0x3f, 0, 0}, {0x3806, 0x07, 0, 0}, {0x3807, 0x9b, 0, 0},
> +	{0x3808, 0x02, 0, 0}, {0x3809, 0x80, 0, 0}, {0x380a, 0x01, 0, 0},
> +	{0x380b, 0xe0, 0, 0}, {0x380c, 0x07, 0, 0}, {0x380d, 0x68, 0, 0},
> +	{0x380e, 0x03, 0, 0}, {0x380f, 0xd8, 0, 0}, {0x3810, 0x00, 0, 0},
> +	{0x3811, 0x10, 0, 0}, {0x3812, 0x00, 0, 0}, {0x3813, 0x06, 0, 0},
> +	{0x3618, 0x00, 0, 0}, {0x3612, 0x29, 0, 0}, {0x3708, 0x64, 0, 0},
> +	{0x3709, 0x52, 0, 0}, {0x370c, 0x03, 0, 0}, {0x3a02, 0x03, 0, 0},
> +	{0x3a03, 0xd8, 0, 0}, {0x3a08, 0x01, 0, 0}, {0x3a09, 0x27, 0, 0},
> +	{0x3a0a, 0x00, 0, 0}, {0x3a0b, 0xf6, 0, 0}, {0x3a0e, 0x03, 0, 0},
> +	{0x3a0d, 0x04, 0, 0}, {0x3a14, 0x03, 0, 0}, {0x3a15, 0xd8, 0, 0},
> +	{0x4001, 0x02, 0, 0}, {0x4004, 0x02, 0, 0}, {0x3000, 0x00, 0, 0},
> +	{0x3002, 0x1c, 0, 0}, {0x3004, 0xff, 0, 0}, {0x3006, 0xc3, 0, 0},
> +	{0x300e, 0x45, 0, 0}, {0x302e, 0x08, 0, 0}, {0x4300, 0x3f, 0, 0},
> +	{0x501f, 0x00, 0, 0}, {0x4713, 0x03, 0, 0}, {0x4407, 0x04, 0, 0},
> +	{0x440e, 0x00, 0, 0}, {0x460b, 0x35, 0, 0}, {0x460c, 0x22, 0, 0},
> +	{0x4837, 0x0a, 0, 0}, {0x4800, 0x04, 0, 0}, {0x3824, 0x02, 0, 0},
> +	{0x5000, 0xa7, 0, 0}, {0x5001, 0xa3, 0, 0}, {0x5180, 0xff, 0, 0},
> +	{0x5181, 0xf2, 0, 0}, {0x5182, 0x00, 0, 0}, {0x5183, 0x14, 0, 0},
> +	{0x5184, 0x25, 0, 0}, {0x5185, 0x24, 0, 0}, {0x5186, 0x09, 0, 0},
> +	{0x5187, 0x09, 0, 0}, {0x5188, 0x09, 0, 0}, {0x5189, 0x88, 0, 0},
> +	{0x518a, 0x54, 0, 0}, {0x518b, 0xee, 0, 0}, {0x518c, 0xb2, 0, 0},
> +	{0x518d, 0x50, 0, 0}, {0x518e, 0x34, 0, 0}, {0x518f, 0x6b, 0, 0},
> +	{0x5190, 0x46, 0, 0}, {0x5191, 0xf8, 0, 0}, {0x5192, 0x04, 0, 0},
> +	{0x5193, 0x70, 0, 0}, {0x5194, 0xf0, 0, 0}, {0x5195, 0xf0, 0, 0},
> +	{0x5196, 0x03, 0, 0}, {0x5197, 0x01, 0, 0}, {0x5198, 0x04, 0, 0},
> +	{0x5199, 0x6c, 0, 0}, {0x519a, 0x04, 0, 0}, {0x519b, 0x00, 0, 0},
> +	{0x519c, 0x09, 0, 0}, {0x519d, 0x2b, 0, 0}, {0x519e, 0x38, 0, 0},
> +	{0x5381, 0x1e, 0, 0}, {0x5382, 0x5b, 0, 0}, {0x5383, 0x08, 0, 0},
> +	{0x5384, 0x0a, 0, 0}, {0x5385, 0x7e, 0, 0}, {0x5386, 0x88, 0, 0},
> +	{0x5387, 0x7c, 0, 0}, {0x5388, 0x6c, 0, 0}, {0x5389, 0x10, 0, 0},
> +	{0x538a, 0x01, 0, 0}, {0x538b, 0x98, 0, 0}, {0x5300, 0x08, 0, 0},
> +	{0x5301, 0x30, 0, 0}, {0x5302, 0x10, 0, 0}, {0x5303, 0x00, 0, 0},
> +	{0x5304, 0x08, 0, 0}, {0x5305, 0x30, 0, 0}, {0x5306, 0x08, 0, 0},
> +	{0x5307, 0x16, 0, 0}, {0x5309, 0x08, 0, 0}, {0x530a, 0x30, 0, 0},
> +	{0x530b, 0x04, 0, 0}, {0x530c, 0x06, 0, 0}, {0x5480, 0x01, 0, 0},
> +	{0x5481, 0x08, 0, 0}, {0x5482, 0x14, 0, 0}, {0x5483, 0x28, 0, 0},
> +	{0x5484, 0x51, 0, 0}, {0x5485, 0x65, 0, 0}, {0x5486, 0x71, 0, 0},
> +	{0x5487, 0x7d, 0, 0}, {0x5488, 0x87, 0, 0}, {0x5489, 0x91, 0, 0},
> +	{0x548a, 0x9a, 0, 0}, {0x548b, 0xaa, 0, 0}, {0x548c, 0xb8, 0, 0},
> +	{0x548d, 0xcd, 0, 0}, {0x548e, 0xdd, 0, 0}, {0x548f, 0xea, 0, 0},
> +	{0x5490, 0x1d, 0, 0}, {0x5580, 0x02, 0, 0}, {0x5583, 0x40, 0, 0},
> +	{0x5584, 0x10, 0, 0}, {0x5589, 0x10, 0, 0}, {0x558a, 0x00, 0, 0},
> +	{0x558b, 0xf8, 0, 0}, {0x5800, 0x23, 0, 0}, {0x5801, 0x14, 0, 0},
> +	{0x5802, 0x0f, 0, 0}, {0x5803, 0x0f, 0, 0}, {0x5804, 0x12, 0, 0},
> +	{0x5805, 0x26, 0, 0}, {0x5806, 0x0c, 0, 0}, {0x5807, 0x08, 0, 0},
> +	{0x5808, 0x05, 0, 0}, {0x5809, 0x05, 0, 0}, {0x580a, 0x08, 0, 0},
> +	{0x580b, 0x0d, 0, 0}, {0x580c, 0x08, 0, 0}, {0x580d, 0x03, 0, 0},
> +	{0x580e, 0x00, 0, 0}, {0x580f, 0x00, 0, 0}, {0x5810, 0x03, 0, 0},
> +	{0x5811, 0x09, 0, 0}, {0x5812, 0x07, 0, 0}, {0x5813, 0x03, 0, 0},
> +	{0x5814, 0x00, 0, 0}, {0x5815, 0x01, 0, 0}, {0x5816, 0x03, 0, 0},
> +	{0x5817, 0x08, 0, 0}, {0x5818, 0x0d, 0, 0}, {0x5819, 0x08, 0, 0},
> +	{0x581a, 0x05, 0, 0}, {0x581b, 0x06, 0, 0}, {0x581c, 0x08, 0, 0},
> +	{0x581d, 0x0e, 0, 0}, {0x581e, 0x29, 0, 0}, {0x581f, 0x17, 0, 0},
> +	{0x5820, 0x11, 0, 0}, {0x5821, 0x11, 0, 0}, {0x5822, 0x15, 0, 0},
> +	{0x5823, 0x28, 0, 0}, {0x5824, 0x46, 0, 0}, {0x5825, 0x26, 0, 0},
> +	{0x5826, 0x08, 0, 0}, {0x5827, 0x26, 0, 0}, {0x5828, 0x64, 0, 0},
> +	{0x5829, 0x26, 0, 0}, {0x582a, 0x24, 0, 0}, {0x582b, 0x22, 0, 0},
> +	{0x582c, 0x24, 0, 0}, {0x582d, 0x24, 0, 0}, {0x582e, 0x06, 0, 0},
> +	{0x582f, 0x22, 0, 0}, {0x5830, 0x40, 0, 0}, {0x5831, 0x42, 0, 0},
> +	{0x5832, 0x24, 0, 0}, {0x5833, 0x26, 0, 0}, {0x5834, 0x24, 0, 0},
> +	{0x5835, 0x22, 0, 0}, {0x5836, 0x22, 0, 0}, {0x5837, 0x26, 0, 0},
> +	{0x5838, 0x44, 0, 0}, {0x5839, 0x24, 0, 0}, {0x583a, 0x26, 0, 0},
> +	{0x583b, 0x28, 0, 0}, {0x583c, 0x42, 0, 0}, {0x583d, 0xce, 0, 0},
> +	{0x5025, 0x00, 0, 0}, {0x3a0f, 0x30, 0, 0}, {0x3a10, 0x28, 0, 0},
> +	{0x3a1b, 0x30, 0, 0}, {0x3a1e, 0x26, 0, 0}, {0x3a11, 0x60, 0, 0},
> +	{0x3a1f, 0x14, 0, 0}, {0x3008, 0x02, 0, 0}, {0x3c00, 0x04, 0, 300},
> +};

You only use the delay feature of the registers tables twice, once after 
writing the first two registers (to select the clock source and perform a 
software reset) and once at the very end. Remove it, write the first two 
registers manually in the code with a manual delay afterwards, and add another 
manual delay after writing the whole table.

I'm actually wondering whether you couldn't remove the 300ms delay at the end, 
the 50/60Hz control register (0x3c00) doesn't look like it needs a delay after 
being written.

[snip]

> +static struct reg_value ov5640_setting_15fps_QSXGA_2592_1944[] = {
> +	{0x4202, 0x0f, 0, 0},	/* stream off the sensor */
> +	{0x3820, 0x40, 0, 0}, {0x3821, 0x06, 0, 0}, /*disable flip*/
> +	{0x3035, 0x21, 0, 0}, {0x3036, 0x54, 0, 0}, {0x3c07, 0x08, 0, 0},
> +	{0x3c09, 0x1c, 0, 0}, {0x3c0a, 0x9c, 0, 0}, {0x3c0b, 0x40, 0, 0},
> +	{0x3820, 0x40, 0, 0}, {0x3821, 0x06, 0, 0}, {0x3814, 0x11, 0, 0},
> +	{0x3815, 0x11, 0, 0}, {0x3800, 0x00, 0, 0}, {0x3801, 0x00, 0, 0},
> +	{0x3802, 0x00, 0, 0}, {0x3803, 0x00, 0, 0}, {0x3804, 0x0a, 0, 0},
> +	{0x3805, 0x3f, 0, 0}, {0x3806, 0x07, 0, 0}, {0x3807, 0x9f, 0, 0},
> +	{0x3808, 0x0a, 0, 0}, {0x3809, 0x20, 0, 0}, {0x380a, 0x07, 0, 0},
> +	{0x380b, 0x98, 0, 0}, {0x380c, 0x0b, 0, 0}, {0x380d, 0x1c, 0, 0},
> +	{0x380e, 0x07, 0, 0}, {0x380f, 0xb0, 0, 0}, {0x3810, 0x00, 0, 0},
> +	{0x3811, 0x10, 0, 0}, {0x3812, 0x00, 0, 0}, {0x3813, 0x04, 0, 0},
> +	{0x3618, 0x04, 0, 0}, {0x3612, 0x29, 0, 0}, {0x3708, 0x21, 0, 0},
> +	{0x3709, 0x12, 0, 0}, {0x370c, 0x00, 0, 0}, {0x3a02, 0x03, 0, 0},
> +	{0x3a03, 0xd8, 0, 0}, {0x3a08, 0x01, 0, 0}, {0x3a09, 0x27, 0, 0},
> +	{0x3a0a, 0x00, 0, 0}, {0x3a0b, 0xf6, 0, 0}, {0x3a0e, 0x03, 0, 0},
> +	{0x3a0d, 0x04, 0, 0}, {0x3a14, 0x03, 0, 0}, {0x3a15, 0xd8, 0, 0},
> +	{0x4001, 0x02, 0, 0}, {0x4004, 0x06, 0, 0}, {0x4713, 0x03, 0, 0},
> +	{0x4407, 0x04, 0, 0}, {0x460b, 0x35, 0, 0}, {0x460c, 0x22, 0, 0},
> +	{0x3824, 0x02, 0, 0}, {0x5001, 0x83, 0, 70},
> +	{0x4202, 0x00, 0, 0},	/* stream on the sensor */

Don't turn the stream on in the init sequences, it should only be turned on 
from the .s_stream() operation.

> +};
> +
> +static struct ov5640_mode_info
> +ov5640_mode_info_data[ov5640_num_framerates][ov5640_num_modes] = {

There's very few differences between the 15fps and 30fps tables. It would be 
better if you could merge them, and manually write the registers that differ.

> +	{
> +		{ov5640_mode_QCIF_176_144, SUBSAMPLING, 176, 144,
> +		 ov5640_setting_15fps_QCIF_176_144,
> +		 ARRAY_SIZE(ov5640_setting_15fps_QCIF_176_144)},
> +		{ov5640_mode_QVGA_320_240, SUBSAMPLING, 320,  240,
> +		 ov5640_setting_15fps_QVGA_320_240,
> +		 ARRAY_SIZE(ov5640_setting_15fps_QVGA_320_240)},
> +		{ov5640_mode_VGA_640_480, SUBSAMPLING, 640,  480,
> +		 ov5640_setting_15fps_VGA_640_480,
> +		 ARRAY_SIZE(ov5640_setting_15fps_VGA_640_480)},
> +		{ov5640_mode_NTSC_720_480, SUBSAMPLING, 720, 480,
> +		 ov5640_setting_15fps_NTSC_720_480,
> +		 ARRAY_SIZE(ov5640_setting_15fps_NTSC_720_480)},
> +		{ov5640_mode_PAL_720_576, SUBSAMPLING, 720, 576,
> +		 ov5640_setting_15fps_PAL_720_576,
> +		 ARRAY_SIZE(ov5640_setting_15fps_PAL_720_576)},
> +		{ov5640_mode_XGA_1024_768, SUBSAMPLING, 1024, 768,
> +		 ov5640_setting_15fps_XGA_1024_768,
> +		 ARRAY_SIZE(ov5640_setting_15fps_XGA_1024_768)},
> +		{ov5640_mode_720P_1280_720, SUBSAMPLING, 1280, 720,
> +		 ov5640_setting_15fps_720P_1280_720,
> +		 ARRAY_SIZE(ov5640_setting_15fps_720P_1280_720)},
> +		{ov5640_mode_1080P_1920_1080, SCALING, 1920, 1080,
> +		 ov5640_setting_15fps_1080P_1920_1080,
> +		 ARRAY_SIZE(ov5640_setting_15fps_1080P_1920_1080)},
> +		{ov5640_mode_QSXGA_2592_1944, SCALING, 2592, 1944,
> +		 ov5640_setting_15fps_QSXGA_2592_1944,
> +		 ARRAY_SIZE(ov5640_setting_15fps_QSXGA_2592_1944)},
> +	}, {
> +		{ov5640_mode_QCIF_176_144, SUBSAMPLING, 176, 144,
> +		 ov5640_setting_30fps_QCIF_176_144,
> +		 ARRAY_SIZE(ov5640_setting_30fps_QCIF_176_144)},
> +		{ov5640_mode_QVGA_320_240, SUBSAMPLING, 320,  240,
> +		 ov5640_setting_30fps_QVGA_320_240,
> +		 ARRAY_SIZE(ov5640_setting_30fps_QVGA_320_240)},
> +		{ov5640_mode_VGA_640_480, SUBSAMPLING, 640,  480,
> +		 ov5640_setting_30fps_VGA_640_480,
> +		 ARRAY_SIZE(ov5640_setting_30fps_VGA_640_480)},
> +		{ov5640_mode_NTSC_720_480, SUBSAMPLING, 720, 480,
> +		 ov5640_setting_30fps_NTSC_720_480,
> +		 ARRAY_SIZE(ov5640_setting_30fps_NTSC_720_480)},
> +		{ov5640_mode_PAL_720_576, SUBSAMPLING, 720, 576,
> +		 ov5640_setting_30fps_PAL_720_576,
> +		 ARRAY_SIZE(ov5640_setting_30fps_PAL_720_576)},
> +		{ov5640_mode_XGA_1024_768, SUBSAMPLING, 1024, 768,
> +		 ov5640_setting_30fps_XGA_1024_768,
> +		 ARRAY_SIZE(ov5640_setting_30fps_XGA_1024_768)},
> +		{ov5640_mode_720P_1280_720, SUBSAMPLING, 1280, 720,
> +		 ov5640_setting_30fps_720P_1280_720,
> +		 ARRAY_SIZE(ov5640_setting_30fps_720P_1280_720)},
> +		{ov5640_mode_1080P_1920_1080, SCALING, 1920, 1080,
> +		 ov5640_setting_30fps_1080P_1920_1080,
> +		 ARRAY_SIZE(ov5640_setting_30fps_1080P_1920_1080)},
> +		{ov5640_mode_QSXGA_2592_1944, -1, 0, 0, NULL, 0},
> +	},
> +};
> +
> +static int ov5640_probe(struct i2c_client *adapter,
> +			const struct i2c_device_id *device_id);
> +static int ov5640_remove(struct i2c_client *client);

No forward declarations please.

> +static int ov5640_init_slave_id(struct ov5640_dev *sensor)
> +{
> +	struct i2c_msg msg;
> +	u8 buf[4];
> +	int ret;
> +
> +	if (sensor->i2c_client->addr == OV5640_DEFAULT_SLAVE_ID)
> +		return 0;
> +
> +	buf[0] = OV5640_SLAVE_ID >> 8;
> +	buf[1] = OV5640_SLAVE_ID & 0xff;
> +	buf[2] = sensor->i2c_client->addr << 1;
> +	msg.addr = OV5640_DEFAULT_SLAVE_ID;
> +	msg.flags = 0;
> +	msg.len = 3;
> +	msg.buf = buf;
> +
> +	ret = i2c_transfer(sensor->i2c_client->adapter, &msg, 1);
> +	if (ret < 0) {
> +		dev_err(sensor->dev, "%s: failed with %d\n", __func__, ret);
> +		return ret;
> +	}
> +
> +	return 0;
> +}
> +
> +static int ov5640_write_reg(struct ov5640_dev *sensor, u16 reg, u8 val)
> +{
> +	u8 buf[3] = {0};
> +	int ret;
> +
> +	buf[0] = reg >> 8;
> +	buf[1] = reg & 0xff;
> +	buf[2] = val;
> +
> +	ret = i2c_master_send(sensor->i2c_client, buf, 3);
> +	if (ret < 0) {
> +		v4l2_err(&sensor->sd, "%s: error: reg=%x, val=%x\n",
> +			__func__, reg, val);
> +		return ret;
> +	}
> +
> +	return 0;
> +}
> +
> +static int ov5640_read_reg(struct ov5640_dev *sensor, u16 reg, u8 *val)
> +{
> +	u8 reg_buf[2] = {0};
> +	u8 read_val = 0;
> +
> +	reg_buf[0] = reg >> 8;
> +	reg_buf[1] = reg & 0xff;
> +
> +	if (2 != i2c_master_send(sensor->i2c_client, reg_buf, 2)) {
> +		v4l2_err(&sensor->sd, "%s: write reg error: reg=%x\n",
> +			__func__, reg);
> +		return -EIO;
> +	}
> +
> +	if (1 != i2c_master_recv(sensor->i2c_client, &read_val, 1)) {
> +		v4l2_err(&sensor->sd, "%s: read reg error: reg=%x, val=%x\n",
> +			__func__, reg, read_val);
> +		return -EIO;
> +	}

Wouldn't i2c_transfer() be more efficient here ?

> +	*val = read_val;
> +	return 0;
> +}
> +
> +#define OV5640_READ_REG(s, r, v) {				\
> +		ret = ov5640_read_reg((s), (r), (v));		\
> +		if (ret)					\
> +			return ret;				\
> +	}

No. No. No no no. Don't ever return from a macro. Hiding the return makes 
following the code flow much more difficult, it's just asking for trouble.

And don't use externally defined variables (ret in this case), that's also 
asking for trouble.

> +#define OV5640_WRITE_REG(s, r, v) {				\
> +		ret = ov5640_write_reg((s), (r), (v));		\
> +		if (ret)					\
> +			return ret;				\
> +	}
> +
> +static int ov5640_read_reg16(struct ov5640_dev *sensor, u16 reg, u16 *val)
> +{
> +	u8 hi, lo;
> +	int ret;
> +
> +	OV5640_READ_REG(sensor, reg, &hi);
> +	OV5640_READ_REG(sensor, reg+1, &lo);
> +
> +	*val = ((u16)hi << 8) | (u16)lo;
> +	return 0;
> +}
> +#define OV5640_READ_REG16(s, r, v) {				\
> +		ret = ov5640_read_reg16((s), (r), (v));		\
> +		if (ret)					\
> +			return ret;				\
> +	}
> +
> +static int ov5640_write_reg16(struct ov5640_dev *sensor, u16 reg, u16 val)
> +{
> +	int ret;
> +
> +	OV5640_WRITE_REG(sensor, reg, val >> 8);
> +	OV5640_WRITE_REG(sensor, reg+1, val & 0xff);
> +	return 0;
> +}
> +#define OV5640_WRITE_REG16(s, r, v) {				\
> +		ret = ov5640_write_reg16((s), (r), (v));	\
> +		if (ret)					\
> +			return ret;				\
> +	}
> +
> +static int ov5640_mod_reg(struct ov5640_dev *sensor, u16 reg,
> +			  u8 mask, u8 val)
> +{
> +	u8 readval;
> +	int ret;
> +
> +	OV5640_READ_REG(sensor, reg, &readval);
> +
> +	readval &= ~mask;
> +	val &= mask;
> +	val |= readval;
> +
> +	OV5640_WRITE_REG(sensor, reg, val);
> +	return 0;
> +}
> +#define OV5640_MOD_REG(s, r, m, v) {				\
> +		ret = ov5640_mod_reg((s), (r), (m), (v));	\
> +		if (ret)					\
> +			return ret;				\
> +	}

If you need to modify registers a lot, switch to regmap for register access. 
It will provide you with a cache, removing the need to read registers back 
from the device.

> +/* download ov5640 settings to sensor through i2c */
> +static int ov5640_load_regs(struct ov5640_dev *sensor,
> +			    struct reg_value *regs,
> +			    int size)

size is never negative.

> +{
> +	register u32 delay_ms = 0;
> +	register u16 reg_addr = 0;
> +	register u8 mask = 0;
> +	register u8 val = 0;

register ? The compiler is nowadays likely smarter than us when it comes to 
register allocation.

There's also no need to initialize the variables to 0.

> +	int i, ret;

And i isn't either.

> +
> +	for (i = 0; i < size; ++i, ++regs) {
> +		delay_ms = regs->delay_ms;
> +		reg_addr = regs->reg_addr;
> +		val = regs->val;
> +		mask = regs->mask;
> +
> +		if (mask) {
> +			OV5640_MOD_REG(sensor, reg_addr, mask, val);
> +		} else {
> +			OV5640_WRITE_REG(sensor, reg_addr, val);
> +		}
> +		if (delay_ms)
> +			usleep_range(1000*delay_ms, 1000*delay_ms+100);
> +	}
> +
> +	return 0;
> +}
> +
> +static int ov5640_set_stream(struct ov5640_dev *sensor, bool on)
> +{
> +	int ret;
> +
> +	OV5640_WRITE_REG(sensor, 0x4202, on ? 0x00 : 0x0f);
> +	return 0;
> +}
> +
> +static int ov5640_get_sysclk(struct ov5640_dev *sensor)
> +{
> +	 /* calculate sysclk */
> +	int xvclk = sensor->xclk_freq / 10000;
> +	int multiplier, prediv, VCO, sysdiv, pll_rdiv;
> +	int sclk_rdiv_map[] = {1, 2, 4, 8};
> +	int bit_div2x = 1, sclk_rdiv, sysclk;
> +	u8 temp1, temp2;
> +	int ret;
> +
> +	OV5640_READ_REG(sensor, 0x3034, &temp1);
> +	temp2 = temp1 & 0x0f;
> +	if (temp2 == 8 || temp2 == 10)
> +		bit_div2x = temp2 / 2;
> +
> +	OV5640_READ_REG(sensor, 0x3035, &temp1);
> +	sysdiv = temp1>>4;
> +	if (sysdiv == 0)
> +		sysdiv = 16;
> +
> +	OV5640_READ_REG(sensor, 0x3036, &temp1);
> +	multiplier = temp1;
> +
> +	OV5640_READ_REG(sensor, 0x3037, &temp1);
> +	prediv = temp1 & 0x0f;
> +	pll_rdiv = ((temp1 >> 4) & 0x01) + 1;
> +
> +	OV5640_READ_REG(sensor, 0x3108, &temp1);
> +	temp2 = temp1 & 0x03;
> +	sclk_rdiv = sclk_rdiv_map[temp2];
> +
> +	VCO = xvclk * multiplier / prediv;
> +
> +	sysclk = VCO / sysdiv / pll_rdiv * 2 / bit_div2x / sclk_rdiv;
> +
> +	return sysclk;
> +}
> +
> +static int ov5640_set_night_mode(struct ov5640_dev *sensor)
> +{
> +	 /* read HTS from register settings */
> +	u8 mode;
> +	int ret;
> +
> +	OV5640_READ_REG(sensor, 0x3a00, &mode);
> +	mode &= 0xfb;
> +	OV5640_WRITE_REG(sensor, 0x3a00, mode);
> +	return 0;
> +}
> +
> +static int ov5640_get_HTS(struct ov5640_dev *sensor)
> +{
> +	 /* read HTS from register settings */
> +	u16 HTS;

Function names and variables are lower case.

> +	int ret;
> +
> +	OV5640_READ_REG16(sensor, 0x380c, &HTS);
> +	return HTS;
> +}
> +
> +static int ov5640_get_VTS(struct ov5640_dev *sensor)
> +{
> +	u16 VTS;
> +	int ret;
> +
> +	OV5640_READ_REG16(sensor, 0x380e, &VTS);
> +	return VTS;
> +}
> +
> +static int ov5640_set_VTS(struct ov5640_dev *sensor, int VTS)
> +{
> +	int ret;
> +
> +	OV5640_WRITE_REG16(sensor, 0x380e, VTS);
> +	return 0;
> +}
> +
> +static int ov5640_get_light_freq(struct ov5640_dev *sensor)
> +{
> +	/* get banding filter value */
> +	u8 temp, temp1;
> +	int light_freq = 0;
> +	int ret;
> +
> +	OV5640_READ_REG(sensor, 0x3c01, &temp);
> +
> +	if (temp & 0x80) {
> +		/* manual */
> +		OV5640_READ_REG(sensor, 0x3c00, &temp1);
> +		if (temp1 & 0x04) {
> +			/* 50Hz */
> +			light_freq = 50;
> +		} else {
> +			/* 60Hz */
> +			light_freq = 60;
> +		}
> +	} else {
> +		/* auto */
> +		OV5640_READ_REG(sensor, 0x3c0c, &temp1);
> +		if (temp1 & 0x01) {
> +			/* 50Hz */
> +			light_freq = 50;
> +		} else {
> +			/* 60Hz */
> +		}
> +	}
> +
> +	return light_freq;
> +}
> +
> +static int ov5640_set_bandingfilter(struct ov5640_dev *sensor)
> +{
> +	int prev_vts;
> +	int band_step60, max_band60, band_step50, max_band50;

Aren't these values unsigned ?

> +	int ret;
> +
> +	/* read preview PCLK */
> +	ret = ov5640_get_sysclk(sensor);
> +	if (ret < 0)
> +		return ret;
> +	sensor->prev_sysclk = ret;
> +	/* read preview HTS */
> +	ret = ov5640_get_HTS(sensor);
> +	if (ret < 0)
> +		return ret;
> +	sensor->prev_hts = ret;
> +
> +	/* read preview VTS */
> +	ret = ov5640_get_VTS(sensor);
> +	if (ret < 0)
> +		return ret;
> +	prev_vts = ret;
> +
> +	/* calculate banding filter */
> +	/* 60Hz */
> +	band_step60 = sensor->prev_sysclk * 100 / sensor->prev_hts * 100/120;
> +	OV5640_WRITE_REG16(sensor, 0x3a0a, band_step60);
> +
> +	max_band60 = (int)((prev_vts-4)/band_step60);
> +	OV5640_WRITE_REG(sensor, 0x3a0d, max_band60);
> +
> +	/* 50Hz */
> +	band_step50 = sensor->prev_sysclk * 100 / sensor->prev_hts;
> +	OV5640_WRITE_REG16(sensor, 0x3a08, band_step50);
> +
> +	max_band50 = (int)((prev_vts-4)/band_step50);
> +	OV5640_WRITE_REG(sensor, 0x3a0e, max_band50);
> +
> +	return 0;
> +}
> +
> +static int ov5640_set_AE_target(struct ov5640_dev *sensor, int target)
> +{
> +	/* stable in high */
> +	int fast_high, fast_low;

Aren't these values unsigned ?

> +	int ret;
> +
> +	sensor->ae_low = target * 23 / 25;	/* 0.92 */
> +	sensor->ae_high = target * 27 / 25;	/* 1.08 */
> +
> +	fast_high = sensor->ae_high<<1;

Missing spaces around <<

> +	if (fast_high > 255)
> +		fast_high = 255;
> +
> +	fast_low = sensor->ae_low >> 1;
> +
> +	OV5640_WRITE_REG(sensor, 0x3a0f, sensor->ae_high);
> +	OV5640_WRITE_REG(sensor, 0x3a10, sensor->ae_low);
> +	OV5640_WRITE_REG(sensor, 0x3a1b, sensor->ae_high);
> +	OV5640_WRITE_REG(sensor, 0x3a1e, sensor->ae_low);
> +	OV5640_WRITE_REG(sensor, 0x3a11, fast_high);
> +	OV5640_WRITE_REG(sensor, 0x3a1f, fast_low);
> +
> +	return 0;
> +}
> +
> +static int ov5640_binning_on(struct ov5640_dev *sensor)
> +{
> +	u8 temp;
> +	int ret;
> +
> +	OV5640_READ_REG(sensor, 0x3821, &temp);
> +	temp &= 0xfe;
> +
> +	return temp ? 1 : 0;
> +}
> +
> +static int ov5640_set_virtual_channel(struct ov5640_dev *sensor)
> +{
> +	u8 temp, channel = sensor->ep.base.id;

The endpoint id isn't meant to select a virtual channel. V4L2 has no virtual 
channel API at the moment, you can hardcode the VC to 0 for now.

> +	int ret;
> +
> +	OV5640_READ_REG(sensor, 0x4814, &temp);
> +	temp &= ~(3 << 6);
> +	temp |= (channel << 6);
> +	OV5640_WRITE_REG(sensor, 0x4814, temp);
> +
> +	return 0;
> +}
> +
> +static enum ov5640_mode
> +ov5640_find_nearest_mode(struct ov5640_dev *sensor,
> +			 int width, int height)

How about using v4l2_find_nearest_format() ?

> +{
> +	int i;
> +
> +	for (i = ov5640_num_modes - 1; i >= 0; i--) {
> +		if (ov5640_mode_info_data[0][i].width <= width &&
> +		    ov5640_mode_info_data[0][i].height <= height)
> +			break;
> +	}
> +
> +	if (i < 0)
> +		i = 0;
> +
> +	return (enum ov5640_mode)i;
> +}
> +
> +/*
> + * sensor changes between scaling and subsampling, go through
> + * exposure calculation
> + */
> +static int ov5640_change_mode_exposure_calc(struct ov5640_dev *sensor,
> +					    enum ov5640_frame_rate frame_rate,
> +					    enum ov5640_mode mode)
> +{
> +	struct reg_value *mode_data = NULL;
> +	int mode_size = 0;
> +	u8 average;
> +	int prev_shutter, prev_gain16;
> +	int cap_shutter, cap_gain16;
> +	int cap_sysclk, cap_hts, cap_vts;
> +	int light_freq, cap_bandfilt, cap_maxband;
> +	long cap_gain16_shutter;
> +	int ret = 0;
> +
> +	/* check if the input mode and frame rate is valid */
> +	mode_data = ov5640_mode_info_data[frame_rate][mode].init_data_ptr;
> +	mode_size = ov5640_mode_info_data[frame_rate][mode].init_data_size;
> +
> +	sensor->fmt.width = ov5640_mode_info_data[frame_rate][mode].width;
> +	sensor->fmt.height = ov5640_mode_info_data[frame_rate][mode].height;
> +
> +	if (sensor->fmt.width == 0 || sensor->fmt.height == 0 ||
> +	    mode_data == NULL || mode_size == 0)
> +		return -EINVAL;
> +
> +	/* auto focus */
> +	/* ov5640_auto_focus();//if no af function, just skip it */
> +
> +	/* turn off AE/AG */
> +	ret = ov5640_set_agc(sensor, false);
> +	if (ret < 0)
> +		return ret;
> +
> +	/* read preview shutter */
> +	ret = ov5640_get_exposure(sensor);
> +	if (ret < 0)
> +		return ret;
> +	prev_shutter = ret;
> +	ret = ov5640_binning_on(sensor);
> +	if (ret < 0)
> +		return ret;
> +	if (ret && mode != ov5640_mode_720P_1280_720 &&
> +	    mode != ov5640_mode_1080P_1920_1080)
> +		prev_shutter *= 2;
> +
> +	/* read preview gain */
> +	ret = ov5640_get_gain(sensor);
> +	if (ret < 0)
> +		return ret;
> +	prev_gain16 = ret;
> +
> +	/* get average */
> +	OV5640_READ_REG(sensor, 0x56a1, &average);
> +
> +	/* turn off night mode for capture */
> +	ret = ov5640_set_night_mode(sensor);
> +	if (ret < 0)
> +		return ret;
> +
> +	/* turn off overlay */
> +	/* OV5640_WRITE_REG(0x3022, 0x06); //if no af function,
> +	   just skip it */
> +
> +	ret = ov5640_set_stream(sensor, false);
> +	if (ret < 0)
> +		return ret;
> +
> +	/* Write capture setting */
> +	ret = ov5640_load_regs(sensor, mode_data, mode_size);
> +	if (ret < 0)
> +		return ret;
> +
> +	/* read capture VTS */
> +	ret = ov5640_get_VTS(sensor);
> +	if (ret < 0)
> +		return ret;
> +	cap_vts = ret;
> +	ret = ov5640_get_HTS(sensor);
> +	if (ret < 0)
> +		return ret;
> +	cap_hts = ret;
> +	ret = ov5640_get_sysclk(sensor);
> +	if (ret < 0)
> +		return ret;
> +	cap_sysclk = ret;
> +
> +	/* calculate capture banding filter */
> +	ret = ov5640_get_light_freq(sensor);
> +	if (ret < 0)
> +		return ret;
> +	light_freq = ret;
> +
> +	if (light_freq == 60) {
> +		/* 60Hz */
> +		cap_bandfilt = cap_sysclk * 100 / cap_hts * 100 / 120;
> +	} else {
> +		/* 50Hz */
> +		cap_bandfilt = cap_sysclk * 100 / cap_hts;
> +	}
> +	cap_maxband = (int)((cap_vts - 4) / cap_bandfilt);
> +
> +	/* calculate capture shutter/gain16 */
> +	if (average > sensor->ae_low && average < sensor->ae_high) {
> +		/* in stable range */
> +		cap_gain16_shutter =
> +			prev_gain16 * prev_shutter *
> +			cap_sysclk / sensor->prev_sysclk *
> +			sensor->prev_hts / cap_hts *
> +			sensor->ae_target / average;
> +	} else {
> +		cap_gain16_shutter =
> +			prev_gain16 * prev_shutter *
> +			cap_sysclk / sensor->prev_sysclk *
> +			sensor->prev_hts / cap_hts;
> +	}
> +
> +	/* gain to shutter */
> +	if (cap_gain16_shutter < (cap_bandfilt * 16)) {
> +		/* shutter < 1/100 */
> +		cap_shutter = cap_gain16_shutter / 16;
> +		if (cap_shutter < 1)
> +			cap_shutter = 1;
> +
> +		cap_gain16 = cap_gain16_shutter / cap_shutter;
> +		if (cap_gain16 < 16)
> +			cap_gain16 = 16;
> +	} else {
> +		if (cap_gain16_shutter > (cap_bandfilt * cap_maxband * 16)) {
> +			/* exposure reach max */
> +			cap_shutter = cap_bandfilt * cap_maxband;
> +			cap_gain16 = cap_gain16_shutter / cap_shutter;
> +		} else {
> +			/* 1/100 < (cap_shutter = n/100) =< max */
> +			cap_shutter =
> +				((int)(cap_gain16_shutter / 16 / 
cap_bandfilt))
> +				* cap_bandfilt;
> +			cap_gain16 = cap_gain16_shutter / cap_shutter;
> +		}
> +	}
> +
> +	/* write capture gain */
> +	ret = ov5640_set_gain(sensor, cap_gain16);
> +	if (ret < 0)
> +		return ret;
> +
> +	/* write capture shutter */
> +	if (cap_shutter > (cap_vts - 4)) {
> +		cap_vts = cap_shutter + 4;
> +		ret = ov5640_set_VTS(sensor, cap_vts);
> +		if (ret < 0)
> +			return ret;
> +	}
> +
> +	ret = ov5640_set_exposure(sensor, cap_shutter);
> +	if (ret < 0)
> +		return ret;
> +
> +	return ov5640_set_stream(sensor, true);
> +}
> +
> +/*
> + * if sensor changes inside scaling or subsampling
> + * change mode directly
> + */
> +static int ov5640_change_mode_direct(struct ov5640_dev *sensor,
> +				     enum ov5640_frame_rate frame_rate,
> +				     enum ov5640_mode mode)
> +{
> +	struct reg_value *mode_data = NULL;
> +	int mode_size = 0;
> +	int ret = 0;
> +
> +	/* check if the input mode and frame rate is valid */
> +	mode_data = ov5640_mode_info_data[frame_rate][mode].init_data_ptr;
> +	mode_size = ov5640_mode_info_data[frame_rate][mode].init_data_size;
> +
> +	sensor->fmt.width = ov5640_mode_info_data[frame_rate][mode].width;
> +	sensor->fmt.height = ov5640_mode_info_data[frame_rate][mode].height;
> +
> +	if (sensor->fmt.width == 0 || sensor->fmt.height == 0 ||
> +	    mode_data == NULL || mode_size == 0)
> +		return -EINVAL;
> +
> +	/* turn off AE/AG */
> +	ret = ov5640_set_agc(sensor, false);
> +	if (ret < 0)
> +		return ret;
> +
> +	ret = ov5640_set_stream(sensor, false);
> +	if (ret < 0)
> +		return ret;
> +
> +	/* Write capture setting */
> +	ret = ov5640_load_regs(sensor, mode_data, mode_size);
> +	if (ret < 0)
> +		return ret;
> +
> +	ret = ov5640_set_stream(sensor, true);

This will turn streaming on when you set the format, which I don't think is 
correct. You should only turn streaming on in the .s_stream() operation. The 
same comment applies to the previous function.

> +	if (ret < 0)
> +		return ret;
> +
> +	return ov5640_set_agc(sensor, true);
> +}
> +
> +static int ov5640_change_mode(struct ov5640_dev *sensor,
> +			      enum ov5640_frame_rate frame_rate,
> +			      enum ov5640_mode mode,
> +			      enum ov5640_mode orig_mode)
> +{
> +	enum ov5640_downsize_mode dn_mode, orig_dn_mode;
> +	struct reg_value *mode_data = NULL;
> +	int mode_size = 0;
> +	int ret = 0;

No need to initialize ret to 0.

> +
> +	if ((mode >= ov5640_num_modes || mode < ov5640_mode_MIN) &&
> +	    mode != ov5640_mode_INIT) {
> +		v4l2_err(&sensor->sd, "Wrong ov5640 mode detected!\n");
> +		return -EINVAL;
> +	}
> +
> +	dn_mode = ov5640_mode_info_data[frame_rate][mode].dn_mode;
> +	orig_dn_mode = ov5640_mode_info_data[frame_rate][orig_mode].dn_mode;
> +	if (mode == ov5640_mode_INIT) {
> +		mode_data = ov5640_init_setting_30fps_VGA;
> +		mode_size = ARRAY_SIZE(ov5640_init_setting_30fps_VGA);
> +
> +		sensor->fmt.width = 640;
> +		sensor->fmt.height = 480;

Don't reset the format here. The format must be preserved across subdev 
open/close.

> +		ret = ov5640_load_regs(sensor, mode_data, mode_size);
> +		if (ret < 0)
> +			return ret;
> +
> +		mode_data = ov5640_setting_30fps_VGA_640_480;
> +		mode_size = ARRAY_SIZE(ov5640_setting_30fps_VGA_640_480);
> +		ret = ov5640_load_regs(sensor, mode_data, mode_size);
> +	} else if ((dn_mode == SUBSAMPLING && orig_dn_mode == SCALING) ||
> +			(dn_mode == SCALING && orig_dn_mode == SUBSAMPLING)) {
> +		/* change between subsampling and scaling
> +		 * go through exposure calucation */
> +		ret = ov5640_change_mode_exposure_calc(sensor, frame_rate,
> +							  mode);
> +	} else {
> +		/* change inside subsampling or scaling
> +		 * download firmware directly */
> +		ret = ov5640_change_mode_direct(sensor, frame_rate, mode);
> +	}
> +
> +	if (ret < 0)
> +		return ret;
> +
> +	ret = ov5640_set_AE_target(sensor, sensor->ae_target);
> +	if (ret < 0)
> +		return ret;
> +	ret = ov5640_get_light_freq(sensor);
> +	if (ret < 0)
> +		return ret;
> +	ret = ov5640_set_bandingfilter(sensor);
> +	if (ret < 0)
> +		return ret;
> +	ret = ov5640_set_virtual_channel(sensor);
> +	if (ret < 0)
> +		return ret;
> +
> +	/* restore controls */
> +	ov5640_restore_ctrls(sensor);
> +
> +	if (ret >= 0 && mode != ov5640_mode_INIT) {
> +		sensor->current_mode = mode;
> +		sensor->current_fr = frame_rate;
> +	}
> +
> +	return 0;
> +}
> +
> +/* restore the last set video mode after chip power-on */
> +static int ov5640_restore_mode(struct ov5640_dev *sensor)
> +{
> +	int ret = 0;

No need to initialize ret to 0.

> +
> +	/* first we need to set some initial register values */
> +	ret = ov5640_change_mode(sensor, sensor->current_fr,
> +				    ov5640_mode_INIT, ov5640_mode_INIT);

I wouldn't use ov5640_change_mode() here. You only need to apply the init 
register values, just call ov5640_load_regs(). The rest of the 
ov5640_change_mode() isn't needed, as you're calling it below. This will also 
allow you to get rid of ov5640_mode_INIT, simplifying the logic.

> +	if (ret < 0)
> +		return ret;
> +
> +	/* now restore the last capture mode */
> +	return ov5640_change_mode(sensor,
> +				  sensor->current_fr,
> +				  sensor->current_mode,
> +				  ov5640_mode_VGA_640_480);

You can fit that in fewer lines while still staying within the 80 columns 
limit.

> +}
> +
> +static int ov5640_regulators_on(struct ov5640_dev *sensor)
> +{
> +	int ret;
> +
> +	if (sensor->io_regulator) {
> +		ret = regulator_enable(sensor->io_regulator);
> +		if (ret) {
> +			v4l2_err(&sensor->sd, "io reg enable failed\n");
> +			return ret;
> +		}
> +	}
> +	if (sensor->core_regulator) {
> +		ret = regulator_enable(sensor->core_regulator);
> +		if (ret) {
> +			v4l2_err(&sensor->sd, "core reg enable failed\n");
> +			return ret;
> +		}
> +	}
> +	if (sensor->gpo_regulator) {
> +		ret = regulator_enable(sensor->gpo_regulator);
> +		if (ret) {
> +			v4l2_err(&sensor->sd, "gpo reg enable failed\n");
> +			return ret;
> +		}
> +	}
> +	if (sensor->analog_regulator) {
> +		ret = regulator_enable(sensor->analog_regulator);
> +		if (ret) {
> +			v4l2_err(&sensor->sd, "analog reg enable failed\n");
> +			return ret;
> +		}
> +	}

Maybe you should use the bulk regulator API ?

> +
> +	return 0;
> +}
> +
> +static void ov5640_regulators_off(struct ov5640_dev *sensor)
> +{
> +	if (sensor->analog_regulator)
> +		regulator_disable(sensor->analog_regulator);
> +	if (sensor->core_regulator)
> +		regulator_disable(sensor->core_regulator);
> +	if (sensor->io_regulator)
> +		regulator_disable(sensor->io_regulator);
> +	if (sensor->gpo_regulator)
> +		regulator_disable(sensor->gpo_regulator);
> +}
> +
> +/* --------------- Subdev Operations --------------- */
> +
> +static int ov5640_s_power(struct v4l2_subdev *sd, int on)
> +{
> +	struct ov5640_dev *sensor = to_ov5640_dev(sd);
> +	int ret;
> +
> +	v4l2_info(sd, "power %s\n", on ? "ON" : "OFF");
> +
> +	if (on && !sensor->on) {

The .s_power() calls need to be ref-counted, similarly to how the regulator 
enable/disable calls work. See the mt9p031 sensor driver for an example.

> +		if (sensor->xclk)
> +			clk_prepare_enable(sensor->xclk);
> +
> +		ret = ov5640_regulators_on(sensor);
> +		if (ret)
> +			return ret;
> +
> +		ov5640_reset(sensor);
> +		ov5640_power(sensor, true);
> +
> +		ret = ov5640_init_slave_id(sensor);

Why is this needed ?

> +		if (ret)
> +			return ret;
> +
> +		ret = ov5640_restore_mode(sensor);
> +		if (ret)
> +			return ret;
> +
> +		/*
> +		 * NOTE: Freescale adds a long delay (600 msec) after
> +		 * powering up and programming a mode on the ov5640-mipi
> +		 * camera (search for "msec_wait4stable" in FSL's
> +		 * ov5640_mipi.c), which equivalently would need to go
> +		 * right here. If we run into MIPI CSI-2 receiver dphy
> +		 * ready timeouts, it might be a clue to add that delay
> +		 * here.
> +		 */
> +	} else if (!on && sensor->on) {
> +		ov5640_power(sensor, false);
> +
> +		ov5640_regulators_off(sensor);
> +
> +		if (sensor->xclk)
> +			clk_disable_unprepare(sensor->xclk);
> +	}
> +
> +	sensor->on = on;
> +
> +	return 0;
> +}
> +
> +static int ov5640_g_parm(struct v4l2_subdev *sd, struct v4l2_streamparm *a)
> +{
> +	struct ov5640_dev *sensor = to_ov5640_dev(sd);
> +	struct v4l2_captureparm *cparm = &a->parm.capture;
> +
> +	if (a->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
> +		return -EINVAL;
> +
> +	/* This is the only case currently handled. */
> +	memset(a, 0, sizeof(*a));
> +	a->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
> +	cparm->capability = sensor->streamcap.capability;
> +	cparm->timeperframe = sensor->streamcap.timeperframe;
> +	cparm->capturemode = sensor->streamcap.capturemode;
> +
> +	return 0;
> +}
> +
> +static int ov5640_s_parm(struct v4l2_subdev *sd, struct v4l2_streamparm *a)
> +{
> +	struct ov5640_dev *sensor = to_ov5640_dev(sd);
> +	struct v4l2_fract *timeperframe = &a->parm.capture.timeperframe;
> +	enum ov5640_frame_rate frame_rate;
> +	u32 tgt_fps;	/* target frames per secound */
> +	int ret = 0;

No need to initialize ret to 0.

> +
> +	if (a->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
> +		return -EINVAL;
> +
> +	/* Check that the new frame rate is allowed. */
> +	if ((timeperframe->numerator == 0) ||
> +	    (timeperframe->denominator == 0)) {
> +		timeperframe->denominator = DEFAULT_FPS;
> +		timeperframe->numerator = 1;
> +	}
> +
> +	tgt_fps = timeperframe->denominator / timeperframe->numerator;
> +
> +	if (tgt_fps > MAX_FPS) {
> +		timeperframe->denominator = MAX_FPS;
> +		timeperframe->numerator = 1;
> +	} else if (tgt_fps < MIN_FPS) {
> +		timeperframe->denominator = MIN_FPS;
> +		timeperframe->numerator = 1;
> +	}
> +
> +	/* Actual frame rate we use */
> +	tgt_fps = timeperframe->denominator / timeperframe->numerator;
> +
> +	if (tgt_fps == 15)
> +		frame_rate = ov5640_15_fps;
> +	else if (tgt_fps == 30)
> +		frame_rate = ov5640_30_fps;
> +	else {
> +		v4l2_err(&sensor->sd, "frame rate %u not supported!\n",
> +			 tgt_fps);

Don't print an error message that is userspace-triggerable, we have enough 
ways for applications to flood the kernel log already :-)

> +		return -EINVAL;
> +	}
> +
> +	ret = ov5640_change_mode(sensor, frame_rate,
> +				 sensor->current_mode,
> +				 sensor->current_mode);
> +	if (ret < 0)
> +		return ret;
> +
> +	sensor->streamcap.timeperframe = *timeperframe;
> +
> +	return 0;
> +}
> +
> +static int ov5640_get_fmt(struct v4l2_subdev *sd,
> +			  struct v4l2_subdev_pad_config *cfg,
> +			  struct v4l2_subdev_format *format)
> +{
> +	struct ov5640_dev *sensor = to_ov5640_dev(sd);
> +
> +	if (format->pad != 0)
> +		return -EINVAL;
> +
> +	format->format = sensor->fmt;

You need to handle the TRY format here. You can have a look at the mt9p031 
driver for an example on how to do so.

> +
> +	return 0;
> +}
> +
> +static int ov5640_try_fmt_internal(struct v4l2_subdev *sd,
> +				   struct v4l2_mbus_framefmt *fmt,
> +				   enum ov5640_mode *new_mode)
> +{
> +	struct ov5640_dev *sensor = to_ov5640_dev(sd);
> +	enum ov5640_mode mode;
> +
> +	mode = ov5640_find_nearest_mode(sensor, fmt->width, fmt->height);
> +
> +	fmt->width = ov5640_mode_info_data[0][mode].width;
> +	fmt->height = ov5640_mode_info_data[0][mode].height;
> +	fmt->code = sensor->fmt.code;
> +
> +	if (new_mode)
> +		*new_mode = mode;
> +	return 0;
> +}
> +
> +static int ov5640_set_fmt(struct v4l2_subdev *sd,
> +			  struct v4l2_subdev_pad_config *cfg,
> +			  struct v4l2_subdev_format *format)
> +{
> +	struct ov5640_dev *sensor = to_ov5640_dev(sd);
> +	enum ov5640_mode new_mode;
> +	int ret;
> +
> +	if (format->pad != 0)
> +		return -EINVAL;
> +
> +	if (format->which == V4L2_SUBDEV_FORMAT_TRY) {
> +		ret = ov5640_try_fmt_internal(sd, &format->format, NULL);
> +		if (ret)
> +			return ret;

You can move this code above the test to avoid the duplicated call below.

> +		cfg->try_fmt = format->format;

Please use the v4l2_subdev_get_try_format() function to get the try format, 
don't dereference cfg directly.

> +		return 0;
> +	}
> +
> +	ret = ov5640_try_fmt_internal(sd, &format->format, &new_mode);
> +	if (ret)
> +		return ret;
> +
> +	ret = ov5640_change_mode(sensor, sensor->current_fr,
> +				 new_mode, sensor->current_mode);
> +	if (ret >= 0)
> +		sensor->fmt = format->format;
> +
> +	return ret;
> +}
> +
> +
> +/*
> + * Sensor Controls.
> + */
> +
> +static int ov5640_set_hue(struct ov5640_dev *sensor, int value)
> +{
> +	int ret;
> +
> +	if (value) {
> +		OV5640_MOD_REG(sensor, 0x5580, 1 << 0, 1 << 0);
> +		OV5640_WRITE_REG16(sensor, 0x5581, value);
> +	} else
> +		OV5640_MOD_REG(sensor, 0x5580, 1 << 0, 0);

According to the kernel coding style, you need curly braces around the else 
branch if you use them around the if branch.

> +
> +	return 0;
> +}
> +
> +static int ov5640_set_contrast(struct ov5640_dev *sensor, int value)
> +{
> +	int ret;
> +
> +	if (value) {
> +		OV5640_MOD_REG(sensor, 0x5580, 1 << 2, 1 << 2);
> +		OV5640_WRITE_REG(sensor, 0x5585, value & 0xff);
> +	} else
> +		OV5640_MOD_REG(sensor, 0x5580, 1 << 2, 0);

Ditto

> +
> +	return 0;
> +}
> +
> +static int ov5640_set_saturation(struct ov5640_dev *sensor, int value)
> +{
> +	int ret;
> +
> +	if (value) {
> +		OV5640_MOD_REG(sensor, 0x5580, 1 << 1, 1 << 1);
> +		OV5640_WRITE_REG(sensor, 0x5583, value & 0xff);
> +		OV5640_WRITE_REG(sensor, 0x5584, value & 0xff);
> +	} else
> +		OV5640_MOD_REG(sensor, 0x5580, 1 << 1, 0);

Ditto

> +
> +	return 0;
> +}
> +
> +static int ov5640_set_awb(struct ov5640_dev *sensor, int value)
> +{
> +	int ret;
> +
> +	sensor->awb_on = value ? true : false;
> +	OV5640_MOD_REG(sensor, 0x3406, 1 << 0, sensor->awb_on ? 0 : 1);
> +	return 0;
> +}
> +
> +static int ov5640_set_red_balance(struct ov5640_dev *sensor, int value)
> +{
> +	int ret;
> +
> +	if (sensor->awb_on)
> +		return -EINVAL;
> +
> +	OV5640_WRITE_REG(sensor, 0x3401, value & 0xff);
> +	OV5640_WRITE_REG(sensor, 0x3400, (value & 0xf00) >> 8);
> +	return 0;
> +}
> +
> +#if 0

No compiled-out code please.

> +static int ov5640_set_green_balance(struct ov5640_dev *sensor, int value)
> +{
> +	int ret;
> +
> +	if (sensor->awb_on)
> +		return -EINVAL;
> +
> +	OV5640_WRITE_REG(sensor, 0x3403, value & 0xff);
> +	OV5640_WRITE_REG(sensor, 0x3402, (value & 0xf00) >> 8);
> +	return 0;
> +}
> +#endif
> +
> +static int ov5640_set_blue_balance(struct ov5640_dev *sensor, int value)
> +{
> +	int ret;
> +
> +	if (sensor->awb_on)
> +		return -EINVAL;
> +
> +	OV5640_WRITE_REG(sensor, 0x3405, value & 0xff);
> +	OV5640_WRITE_REG(sensor, 0x3404, (value & 0xf00) >> 8);
> +	return 0;
> +}
> +
> +static int ov5640_set_exposure(struct ov5640_dev *sensor, int value)
> +{
> +	u16 max_exp = 0;
> +	int ret;
> +
> +	if (sensor->agc_on)
> +		return -EINVAL;
> +
> +	OV5640_READ_REG16(sensor, 0x350c, &max_exp);
> +	if (value < max_exp) {
> +		u32 exp = value << 4;
> +
> +		OV5640_WRITE_REG(sensor, 0x3502, exp & 0xff);
> +		OV5640_WRITE_REG(sensor, 0x3501, (exp >> 8) & 0xff);
> +		OV5640_WRITE_REG(sensor, 0x3500, (exp >> 16) & 0x0f);
> +	}
> +
> +	return 0;
> +}
> +
> +/* read exposure, in number of line periods */
> +static int ov5640_get_exposure(struct ov5640_dev *sensor)
> +{
> +	u8 temp;
> +	int exp, ret;
> +
> +	if (sensor->agc_on)
> +		return -EINVAL;
> +
> +	OV5640_READ_REG(sensor, 0x3500, &temp);
> +	exp = ((int)temp & 0x0f) << 16;
> +	OV5640_READ_REG(sensor, 0x3501, &temp);
> +	exp |= ((int)temp << 8);
> +	OV5640_READ_REG(sensor, 0x3502, &temp);
> +	exp |= (int)temp;
> +
> +	return exp >> 4;
> +}
> +
> +static int ov5640_set_agc(struct ov5640_dev *sensor, int value)
> +{
> +	int ret;
> +
> +	/* this enables/disables both AEC and AGC */
> +	sensor->agc_on = value ? true : false;
> +	OV5640_MOD_REG(sensor, 0x3503, 0x3, sensor->agc_on ? 0 : 0x3);
> +
> +	return 0;
> +}
> +
> +static int ov5640_set_gain(struct ov5640_dev *sensor, int value)
> +{
> +	int ret;
> +
> +	if (sensor->agc_on)
> +		return -EINVAL;

You can create a cluster with the autogain and manual gain controls 
(v4l2_ctrl_auto_cluster) to have the control framework disabling the manual 
control automatically when autogain is enabled.

> +	OV5640_WRITE_REG16(sensor, 0x350a, value & 0x3ff);
> +	return 0;
> +}
> +
> +static int ov5640_get_gain(struct ov5640_dev *sensor)
> +{
> +	u16 gain;
> +	int ret;
> +
> +	if (sensor->agc_on)
> +		return -EINVAL;
> +
> +	OV5640_READ_REG16(sensor, 0x350a, &gain);
> +
> +	return gain & 0x3ff;
> +}
> +
> +#if 0
> +static int ov5640_set_test_pattern(struct ov5640_dev *sensor, int value)
> +{
> +	int ret;
> +
> +	OV5640_MOD_REG(sensor, 0x503d, 0xa4, value ? 0xa4 : 0);
> +	return 0;
> +}
> +#endif

You can use a control to expose the test pattern function, it's quite useful.

> +static struct ov5640_control ov5640_ctrls[] = {
> +	{
> +		.set = ov5640_set_agc,
> +		.ctrl = {
> +			.id = V4L2_CID_AUTOGAIN,
> +			.name = "Auto Gain/Exposure Control",
> +			.minimum = 0,
> +			.maximum = 1,
> +			.step = 1,
> +			.default_value = 1,
> +			.type = V4L2_CTRL_TYPE_BOOLEAN,
> +		},
> +	}, {
> +		.set = ov5640_set_exposure,
> +		.ctrl = {
> +			.id = V4L2_CID_EXPOSURE,
> +			.name = "Exposure",
> +			.minimum = 0,
> +			.maximum = 65535,
> +			.step = 1,
> +			.default_value = 0,
> +			.type = V4L2_CTRL_TYPE_INTEGER,
> +		},
> +	}, {
> +		.set = ov5640_set_gain,
> +		.ctrl = {
> +			.id = V4L2_CID_GAIN,
> +			.name = "Gain",
> +			.minimum = 0,
> +			.maximum = 1023,
> +			.step = 1,
> +			.default_value = 0,
> +			.type = V4L2_CTRL_TYPE_INTEGER,
> +		},
> +	}, {
> +		.set = ov5640_set_hue,
> +		.ctrl = {
> +			.id = V4L2_CID_HUE,
> +			.name = "Hue",
> +			.minimum = 0,
> +			.maximum = 359,
> +			.step = 1,
> +			.default_value = 0,
> +			.type = V4L2_CTRL_TYPE_INTEGER,
> +		},
> +	}, {
> +		.set = ov5640_set_contrast,
> +		.ctrl = {
> +			.id = V4L2_CID_CONTRAST,
> +			.name = "Contrast",
> +			.minimum = 0,
> +			.maximum = 255,
> +			.step = 1,
> +			.default_value = 0,
> +			.type = V4L2_CTRL_TYPE_INTEGER,
> +		},
> +	}, {
> +		.set = ov5640_set_saturation,
> +		.ctrl = {
> +			.id = V4L2_CID_SATURATION,
> +			.name = "Saturation",
> +			.minimum = 0,
> +			.maximum = 255,
> +			.step = 1,
> +			.default_value = 64,
> +			.type = V4L2_CTRL_TYPE_INTEGER,
> +		},
> +	}, {
> +		.set = ov5640_set_awb,
> +		.ctrl = {
> +			.id = V4L2_CID_AUTO_WHITE_BALANCE,
> +			.name = "Auto White Balance",
> +			.minimum = 0,
> +			.maximum = 1,
> +			.step = 1,
> +			.default_value = 1,
> +			.type = V4L2_CTRL_TYPE_BOOLEAN,
> +		},
> +	}, {
> +		.set = ov5640_set_red_balance,
> +		.ctrl = {
> +			.id = V4L2_CID_RED_BALANCE,
> +			.name = "Red Balance",
> +			.minimum = 0,
> +			.maximum = 4095,
> +			.step = 1,
> +			.default_value = 0,
> +			.type = V4L2_CTRL_TYPE_INTEGER,
> +		},
> +	}, {
> +		.set = ov5640_set_blue_balance,
> +		.ctrl = {
> +			.id = V4L2_CID_BLUE_BALANCE,
> +			.name = "Blue Balance",
> +			.minimum = 0,
> +			.maximum = 4095,
> +			.step = 1,
> +			.default_value = 0,
> +			.type = V4L2_CTRL_TYPE_INTEGER,
> +		},
> +	},
> +};
> +#define OV5640_NUM_CONTROLS ARRAY_SIZE(ov5640_ctrls)
> +
> +static struct ov5640_control *ov5640_get_ctrl(int id, int *index)
> +{
> +	struct ov5640_control *ret = NULL;
> +	int i;

i is never negative, it should be unsigned int.

> +	for (i = 0; i < OV5640_NUM_CONTROLS; i++) {
> +		if (id == ov5640_ctrls[i].ctrl.id) {
> +			ret = &ov5640_ctrls[i];
> +			break;
> +		}
> +	}
> +
> +	if (ret && index)
> +		*index = i;
> +	return ret;
> +}
> +
> +static int ov5640_restore_ctrls(struct ov5640_dev *sensor)
> +{
> +	struct ov5640_control *c;
> +	int i;

i is never negative, it should be unsigned int.

> +
> +	for (i = 0; i < OV5640_NUM_CONTROLS; i++) {
> +		c = &ov5640_ctrls[i];
> +		c->set(sensor, sensor->ctrl_cache[i]);
> +	}
> +
> +	return 0;
> +}
> +
> +static int ov5640_s_ctrl(struct v4l2_ctrl *ctrl)
> +{
> +	struct ov5640_dev *sensor = ctrl_to_ov5640_dev(ctrl);
> +	struct ov5640_control *c;
> +	int ret = 0;
> +	int i;
> +
> +	c = ov5640_get_ctrl(ctrl->id, &i);

You can inline the function call here as it's not used anywhere else.

> +	if (!c)
> +		return -EINVAL;
> +
> +	ret = c->set(sensor, ctrl->val);
> +	/* update cached value if no error */
> +	if (!ret)
> +		sensor->ctrl_cache[i] = ctrl->val;
> +
> +	return ret;
> +}
> +
> +static const struct v4l2_ctrl_ops ov5640_ctrl_ops = {
> +	.s_ctrl = ov5640_s_ctrl,
> +};
> +
> +static int ov5640_init_controls(struct ov5640_dev *sensor)
> +{
> +	struct ov5640_control *c;

I would name this ctrl or control, c can be a bit confusing. You can also 
declare it inside the loop.

> +	int i;

i can never be negative, you can make it an unsigned int.

> +
> +	v4l2_ctrl_handler_init(&sensor->ctrl_hdl, OV5640_NUM_CONTROLS);
> +
> +	for (i = 0; i < OV5640_NUM_CONTROLS; i++) {
> +		c = &ov5640_ctrls[i];
> +
> +		v4l2_ctrl_new_std(&sensor->ctrl_hdl, &ov5640_ctrl_ops,
> +				  c->ctrl.id, c->ctrl.minimum, c-
>ctrl.maximum,
> +				  c->ctrl.step, c->ctrl.default_value);
> +	}
> +
> +	sensor->sd.ctrl_handler = &sensor->ctrl_hdl;
> +	if (sensor->ctrl_hdl.error) {
> +		int err = sensor->ctrl_hdl.error;
> +
> +		v4l2_ctrl_handler_free(&sensor->ctrl_hdl);
> +
> +		v4l2_err(&sensor->sd, "%s: error %d\n", __func__, err);

I'm not sure this brings much value.

> +		return err;
> +	}
> +	v4l2_ctrl_handler_setup(&sensor->ctrl_hdl);

You shouldn't call this function here for the reason explained below.

> +
> +	return 0;
> +}
> +
> +static int ov5640_enum_frame_size(struct v4l2_subdev *sd,
> +				  struct v4l2_subdev_pad_config *cfg,
> +				  struct v4l2_subdev_frame_size_enum *fse)
> +{
> +	if (fse->pad != 0)
> +		return -EINVAL;
> +	if (fse->index >= ov5640_num_modes)
> +		return -EINVAL;
> +
> +	fse->min_width = fse->max_width =
> +		ov5640_mode_info_data[0][fse->index].width;
> +	fse->min_height = fse->max_height =
> +		ov5640_mode_info_data[0][fse->index].height;
> +
> +	return 0;
> +}
> +
> +static int ov5640_enum_frame_interval(
> +	struct v4l2_subdev *sd,
> +	struct v4l2_subdev_pad_config *cfg,
> +	struct v4l2_subdev_frame_interval_enum *fie)
> +{
> +	struct ov5640_dev *sensor = to_ov5640_dev(sd);
> +	enum ov5640_mode mode;
> +
> +	if (fie->pad != 0)
> +		return -EINVAL;
> +	if (fie->index < 0 || fie->index >= ov5640_num_framerates)
> +		return -EINVAL;
> +
> +	if (fie->width == 0 || fie->height == 0)
> +		return -EINVAL;
> +
> +	mode = ov5640_find_nearest_mode(sensor, fie->width, fie->height);

You should find an exact mode here, not the nearest one. If with and height 
don't match, return -EINVAL. That will replace with above width == 0 and 
height == 0 test.

> +	if (ov5640_mode_info_data[fie->index][mode].init_data_ptr == NULL)
> +		return -EINVAL;
> +
> +	fie->interval.numerator = 1;
> +	fie->interval.denominator = ov5640_framerates[fie->index];
> +
> +	dev_dbg(sensor->dev, "%dx%d: [%d] = %d fps\n",
> +		fie->width, fie->height, fie->index, fie-
>interval.denominator);

I'm not sure this is very useful, you can use ftrace if you want to trace 
function calls.

> +	return 0;
> +}
> +
> +static int ov5640_g_input_status(struct v4l2_subdev *sd, u32 *status)
> +{
> +	struct ov5640_dev *sensor = to_ov5640_dev(sd);
> +
> +	*status = !sensor->on ? V4L2_IN_ST_NO_POWER : 0;
> +
> +	return 0;
> +}
> +
> +static int ov5640_s_routing(struct v4l2_subdev *sd, u32 input,
> +			    u32 output, u32 config)
> +{
> +	return (input != 0) ? -EINVAL : 0;
> +}

The g_input_status and s_routing subdev operations are not mandatory, you 
don't have to implement them as the sensor doesn't have multiple inputs.

[snip]

> +static int ov5640_s_stream(struct v4l2_subdev *sd, int enable)
> +{
> +	struct ov5640_dev *sensor = to_ov5640_dev(sd);
> +
> +	v4l2_info(sd, "stream %s\n", enable ? "ON" : "OFF");

You can use ftrace to trace function calls, there's no need to add debugging 
statements that duplicate the functionality.

> +	return ov5640_set_stream(sensor, enable);
> +}
> +
> +static struct v4l2_subdev_core_ops ov5640_core_ops = {
> +	.s_power = ov5640_s_power,
> +};
> +
> +static struct v4l2_subdev_video_ops ov5640_video_ops = {
> +	.s_parm = ov5640_s_parm,
> +	.g_parm = ov5640_g_parm,
> +	.g_input_status = ov5640_g_input_status,
> +	.s_routing = ov5640_s_routing,
> +	.g_mbus_config  = ov5640_g_mbus_config,
> +	.s_stream = ov5640_s_stream,
> +};
> +
> +static struct v4l2_subdev_pad_ops ov5640_pad_ops = {
> +	.enum_mbus_code = ov5640_enum_mbus_code,
> +	.get_fmt = ov5640_get_fmt,
> +	.set_fmt = ov5640_set_fmt,
> +	.enum_frame_size = ov5640_enum_frame_size,
> +	.enum_frame_interval = ov5640_enum_frame_interval,
> +};
> +
> +static struct v4l2_subdev_ops ov5640_subdev_ops = {
> +	.core = &ov5640_core_ops,
> +	.video = &ov5640_video_ops,
> +	.pad = &ov5640_pad_ops,
> +};

All these structures should be static const.

> +
> +static void ov5640_power(struct ov5640_dev *sensor, bool enable)
> +{
> +	gpiod_set_value(sensor->pwdn_gpio, enable ? 0 : 1);
> +}
> +
> +static void ov5640_reset(struct ov5640_dev *sensor)
> +{
> +	gpiod_set_value(sensor->reset_gpio, 0);
> +
> +	/* camera power cycle */
> +	ov5640_power(sensor, false);
> +	usleep_range(5000, 10000);
> +	ov5640_power(sensor, true);
> +	usleep_range(5000, 10000);
> +
> +	gpiod_set_value(sensor->reset_gpio, 1);
> +	usleep_range(1000, 2000);
> +
> +	gpiod_set_value(sensor->reset_gpio, 0);
> +	usleep_range(5000, 10000);
> +}
> +
> +static void ov5640_get_regulators(struct ov5640_dev *sensor)
> +{
> +	sensor->io_regulator = devm_regulator_get(sensor->dev, "DOVDD");
> +	if (!IS_ERR(sensor->io_regulator)) {
> +		regulator_set_voltage(sensor->io_regulator,
> +				      OV5640_VOLTAGE_DIGITAL_IO,
> +				      OV5640_VOLTAGE_DIGITAL_IO);
> +	} else {
> +		dev_dbg(sensor->dev, "%s: no io voltage reg found\n",
> +			__func__);
> +		sensor->io_regulator = NULL;

How about making the power supplies mandatory in DT instead ? They are 
mandatory after all, if they're not controllable DT should just declare fixed 
supplies.

> +	}
> +
> +	sensor->core_regulator = devm_regulator_get(sensor->dev, "DVDD");
> +	if (!IS_ERR(sensor->core_regulator)) {
> +		regulator_set_voltage(sensor->core_regulator,
> +				      OV5640_VOLTAGE_DIGITAL_CORE,
> +				      OV5640_VOLTAGE_DIGITAL_CORE);
> +	} else {
> +		sensor->core_regulator = NULL;
> +		dev_dbg(sensor->dev, "%s: no core voltage reg found\n",
> +			__func__);
> +	}
> +
> +	sensor->analog_regulator = devm_regulator_get(sensor->dev, "AVDD");
> +	if (!IS_ERR(sensor->analog_regulator)) {
> +		regulator_set_voltage(sensor->analog_regulator,
> +				      OV5640_VOLTAGE_ANALOG,
> +				      OV5640_VOLTAGE_ANALOG);
> +	} else {
> +		sensor->analog_regulator = NULL;
> +		dev_dbg(sensor->dev, "%s: no analog voltage reg found\n",
> +			__func__);
> +	}
> +}
> +
> +static int ov5640_probe(struct i2c_client *client,
> +			const struct i2c_device_id *id)
> +{
> +	struct device *dev = &client->dev;
> +	struct device_node *endpoint;
> +	struct ov5640_dev *sensor;
> +	int i, xclk, ret;

i and xclk are never negative, you can make them unsigned int.

> +
> +	sensor = devm_kzalloc(dev, sizeof(struct ov5640_dev), GFP_KERNEL);

Please use sizeof(*variable) instead of sizeof(type).

devm_kzalloc() doesn't play nicely with dynamic removal of devices. We're in 
the process of fixing related race conditions in the media subsystem. In order 
not to make the problem worse, please use kzalloc() instead.

> +	if (!sensor)
> +		return -ENOMEM;
> +
> +	sensor->i2c_client = client;
> +	sensor->dev = dev;

Do you really need to store both i2c_client and dev, given that the latter is 
just &client->dev ?

> +	sensor->fmt.code = MEDIA_BUS_FMT_UYVY8_2X8;
> +	sensor->fmt.width = 640;
> +	sensor->fmt.height = 480;
> +	sensor->fmt.field = V4L2_FIELD_NONE;
> +	sensor->streamcap.capability = V4L2_MODE_HIGHQUALITY |
> +					   V4L2_CAP_TIMEPERFRAME;

Please fix the indentation.

> +	sensor->streamcap.capturemode = 0;
> +	sensor->streamcap.timeperframe.denominator = DEFAULT_FPS;
> +	sensor->streamcap.timeperframe.numerator = 1;
> +
> +	sensor->current_mode = ov5640_mode_VGA_640_480;
> +	sensor->current_fr = ov5640_30_fps;
> +
> +	sensor->ae_target = 52;
> +
> +	endpoint = of_graph_get_next_endpoint(client->dev.of_node, NULL);
> +	if (!endpoint) {
> +		dev_err(dev, "endpoint node not found\n");
> +		return -EINVAL;
> +	}
> +
> +	v4l2_of_parse_endpoint(endpoint, &sensor->ep);
> +	if (sensor->ep.bus_type != V4L2_MBUS_CSI2) {
> +		dev_err(dev, "invalid bus type, must be MIPI CSI2\n");
> +		return -EINVAL;

You're leaking endpoint here. You should move the of_node_put() call right 
after the v4l2_of_parse_endpoint() call.

> +	}
> +	of_node_put(endpoint);
> +
> +	/* get system clock (xclk) frequency */
> +	ret = of_property_read_u32(dev->of_node, "xclk", &xclk);

Instead of adding a custom DT property for this, use assigned-clock-rates. You 
won't need to set it manually in the driver, and can verify its frequency with 
clk_get_rate().

> +	if (!ret) {
> +		if (xclk < OV5640_XCLK_MIN || xclk > OV5640_XCLK_MAX) {

Are your register tables above independent of the clock frequency ? You should 
ideally compute register values at runtime instead of hardcoding them, but 
given the lack of information from Omnivision I understand this isn't 
possible. You thus need to be stricter here and reject any value other than 
the nominal frequency.

> +			dev_err(dev, "invalid xclk frequency\n");
> +			return -EINVAL;
> +		}
> +		sensor->xclk_freq = xclk;
> +	}
> +
> +	/* get system clock (xclk) */
> +	sensor->xclk = devm_clk_get(dev, "xclk");
> +	if (!IS_ERR(sensor->xclk)) {
> +		if (!sensor->xclk_freq) {
> +			dev_err(dev, "xclk requires xclk frequency!\n");
> +			return -EINVAL;
> +		}
> +		clk_set_rate(sensor->xclk, sensor->xclk_freq);
> +	} else {
> +		/* assume system clock enabled by default */
> +		sensor->xclk = NULL;

Please don't. The clock should be mandatory.

> +	}
> +
> +	/* request power down pin */
> +	sensor->pwdn_gpio = devm_gpiod_get(dev, "pwdn", GPIOD_OUT_HIGH);

Are the GPIOs mandatory or optional ? Can a system tie some of them to ground 
or a voltage rail, or do they need to always be manually controllable ?

> +	if (IS_ERR(sensor->pwdn_gpio)) {
> +		dev_err(dev, "request for power down gpio failed\n");
> +		return PTR_ERR(sensor->pwdn_gpio);
> +	}
> +
> +	/* request reset pin */
> +	sensor->reset_gpio = devm_gpiod_get(dev, "reset", GPIOD_OUT_HIGH);
> +	if (IS_ERR(sensor->reset_gpio)) {
> +		dev_err(dev, "request for reset gpio failed\n");
> +		return PTR_ERR(sensor->reset_gpio);
> +	}
> +
> +	/* initialize the cached controls to their defaults */
> +	for (i = 0; i < OV5640_NUM_CONTROLS; i++) {
> +		struct ov5640_control *c = &ov5640_ctrls[i];
> +
> +		sensor->ctrl_cache[i] = c->ctrl.default_value;
> +	}
> +	sensor->awb_on = sensor->agc_on = true;
> +
> +	v4l2_i2c_subdev_init(&sensor->sd, client, &ov5640_subdev_ops);
> +
> +	sensor->sd.flags = V4L2_SUBDEV_FL_HAS_DEVNODE;
> +	sensor->pad.flags = MEDIA_PAD_FL_SOURCE;
> +	sensor->sd.entity.function = MEDIA_ENT_F_CAM_SENSOR;
> +	ret = media_entity_pads_init(&sensor->sd.entity, 1, &sensor->pad);
> +	if (ret)
> +		return ret;
> +
> +	ov5640_get_regulators(sensor);
> +
> +	ret = ov5640_s_power(&sensor->sd, 1);
> +	if (ret)
> +		goto entity_cleanup;
> +	ret = ov5640_init_controls(sensor);
> +	if (ret)
> +		goto power_off;
> +
> +	ret = ov5640_s_power(&sensor->sd, 0);
> +	if (ret)
> +		goto free_ctrls;

Writing the controls here is pointless, as powering the chip down will lose 
all the values. You shouldn't call v4l2_ctrl_handler_setup() in 
ov5640_init_controls(), and you can then remove the ov5640_s_power() calls 
here.

> +	ret = v4l2_async_register_subdev(&sensor->sd);
> +	if (ret)
> +		goto free_ctrls;
> +
> +	return 0;
> +
> +free_ctrls:
> +	v4l2_ctrl_handler_free(&sensor->ctrl_hdl);
> +power_off:
> +	ov5640_s_power(&sensor->sd, 0);
> +entity_cleanup:
> +	media_entity_cleanup(&sensor->sd.entity);
> +	ov5640_regulators_off(sensor);

Won't ov5640_s_power(0) already disable the regulators ?

> +	return ret;
> +}
> +
> +/*!
> + * ov5640 I2C detach function
> + *
> + * @param client            struct i2c_client *
> + * @return  Error code indicating success or failure
> + */

That's not the kerneldoc comment style. Given that this is the only documented 
function, and that the comment is completely useless, you can just drop it.

> +static int ov5640_remove(struct i2c_client *client)
> +{
> +	struct v4l2_subdev *sd = i2c_get_clientdata(client);
> +	struct ov5640_dev *sensor = to_ov5640_dev(sd);
> +
> +	ov5640_regulators_off(sensor);
> +
> +	v4l2_async_unregister_subdev(&sensor->sd);
> +	media_entity_cleanup(&sensor->sd.entity);
> +	v4l2_device_unregister_subdev(sd);

This function is called by v4l2_async_unregister_subdev(), there's no need to 
duplicate it.

> +	v4l2_ctrl_handler_free(&sensor->ctrl_hdl);
> +
> +	return 0;
> +}

[snip]

> +MODULE_AUTHOR("Freescale Semiconductor, Inc.");

MODULE_AUTHOR isn't a synonym for copyright ownership. I don't think you 
should add Freescale as an author. If you know who wrote the original code you 
can list that developer explicitly.

> +MODULE_AUTHOR("Steve Longerbeam <steve_longerbeam@mentor.com>");
> +MODULE_DESCRIPTION("OV5640 MIPI Camera Subdev Driver");
> +MODULE_LICENSE("GPL");
> +MODULE_VERSION("1.0");

Version numbers are never updated. I wouldn't bother adding one.

-- 
Regards,

Laurent Pinchart
