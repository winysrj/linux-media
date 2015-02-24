Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:42122 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751147AbbBXLKb (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 24 Feb 2015 06:10:31 -0500
Date: Tue, 24 Feb 2015 13:09:51 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Lad Prabhakar <prabhakar.csengg@gmail.com>
Cc: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Ian Campbell <ijc+devicetree@hellion.org.uk>,
	Kumar Gala <galak@codeaurora.org>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-media@vger.kernel.org
Subject: Re: [PATCH v2] media: i2c: add support for omnivision's ov2659 sensor
Message-ID: <20150224110951.GE6539@valkosipuli.retiisi.org.uk>
References: <1424532167-11212-1-git-send-email-prabhakar.csengg@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1424532167-11212-1-git-send-email-prabhakar.csengg@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Prabhakar,

Thanks for the patch!

On Sat, Feb 21, 2015 at 03:22:47PM +0000, Lad Prabhakar wrote:
> From: Benoit Parrot <bparrot@ti.com>
> 
> this patch adds support for omnivision's ov2659
> sensor, the driver supports following features:
> 1: Asynchronous probing
> 2: DT support
> 3: Media controller support
> 
> Signed-off-by: Benoit Parrot <bparrot@ti.com>
> Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
> ---
>  Changes for v2:
>  1: Dropped prefix entry for ovti as its already merged.
>  2: Fixed review comments pointed by Laurent.
> 
>  .../devicetree/bindings/media/i2c/ov2659.txt       |   41 +
>  MAINTAINERS                                        |   10 +
>  drivers/media/i2c/Kconfig                          |   11 +
>  drivers/media/i2c/Makefile                         |    1 +
>  drivers/media/i2c/ov2659.c                         | 1513 ++++++++++++++++++++
>  include/media/ov2659.h                             |   33 +
>  6 files changed, 1609 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/media/i2c/ov2659.txt
>  create mode 100644 drivers/media/i2c/ov2659.c
>  create mode 100644 include/media/ov2659.h
> 
> diff --git a/Documentation/devicetree/bindings/media/i2c/ov2659.txt b/Documentation/devicetree/bindings/media/i2c/ov2659.txt
> new file mode 100644
> index 0000000..c3f350b
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/media/i2c/ov2659.txt
> @@ -0,0 +1,41 @@
> +* OV2659 1/5-Inch 2Mp SOC Camera
> +
> +The Omnivision OV2659 is a 1/5-inch SOC camera, with an active array size of
> +1632H x 1212V. It is programmable through a SCCB. The OV2659 sensor supports
> +multiple resolutions output, such as UXGA, SVGA, 720p. It also can support
> +YUV422, RGB565/555 or raw RGB output formats.
> +
> +Required Properties:
> +- compatible: Must be "ovti,ov2659"
> +- reg: I2C slave address
> +- clocks: reference to the xvclk input clock.
> +- clock-names: should be "xvclk".
> +- xvclk-frequency: Input clock frequency.

This should be probably in the device's OF node, not in the endpoint node. I
think you should document in which one each property is.

> +
> +For further reading on port node refer to
> +Documentation/devicetree/bindings/media/video-interfaces.txt.
> +
> +Example:
> +
> +	i2c0@1c22000 {
> +		...
> +		...
> +		 ov2659@30 {
> +			compatible = "ovti,ov2659";
> +			reg = <0x30>;
> +
> +			clocks = <&clk_ov2659>;
> +			clock-names = "xvclk";
> +
> +			assigned-clocks = <&clk_ov2659>;
> +			assigned-clock-rates = <12000000>;

These don't quite match with the documentation above.

> +
> +			port {
> +				ov2659_0: endpoint {
> +					remote-endpoint = <&vpfe_ep>;
> +					xvclk-frequency = <12000000>;
> +				};
> +			};
> +		};
> +		...
> +	};
> diff --git a/MAINTAINERS b/MAINTAINERS
> index becb274..1126c9e 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -8758,6 +8758,16 @@ T:	git git://linuxtv.org/mhadli/v4l-dvb-davinci_devices.git
>  S:	Maintained
>  F:	drivers/media/platform/am437x/
>  
> +OV2659 OMNIVISION SENSOR DRIVER
> +M:	Lad, Prabhakar <prabhakar.csengg@gmail.com>
> +L:	linux-media@vger.kernel.org
> +W:	http://linuxtv.org/
> +Q:	http://patchwork.linuxtv.org/project/linux-media/list/
> +T:	git git://linuxtv.org/mhadli/v4l-dvb-davinci_devices.git
> +S:	Maintained
> +F:	drivers/media/i2c/ov2659.c
> +F:	include/media/ov2659.h
> +
>  SIS 190 ETHERNET DRIVER
>  M:	Francois Romieu <romieu@fr.zoreil.com>
>  L:	netdev@vger.kernel.org
> diff --git a/drivers/media/i2c/Kconfig b/drivers/media/i2c/Kconfig
> index da58c9b..6f30ea7 100644
> --- a/drivers/media/i2c/Kconfig
> +++ b/drivers/media/i2c/Kconfig
> @@ -466,6 +466,17 @@ config VIDEO_APTINA_PLL
>  config VIDEO_SMIAPP_PLL
>  	tristate
>  
> +config VIDEO_OV2659
> +	tristate "OmniVision OV2659 sensor support"
> +	depends on VIDEO_V4L2 && I2C
> +	depends on MEDIA_CAMERA_SUPPORT
> +	---help---
> +	  This is a Video4Linux2 sensor-level driver for the OmniVision
> +	  OV2659 camera.
> +
> +	  To compile this driver as a module, choose M here: the
> +	  module will be called ov2659.
> +
>  config VIDEO_OV7640
>  	tristate "OmniVision OV7640 sensor support"
>  	depends on I2C && VIDEO_V4L2
> diff --git a/drivers/media/i2c/Makefile b/drivers/media/i2c/Makefile
> index 98589001..f165fae 100644
> --- a/drivers/media/i2c/Makefile
> +++ b/drivers/media/i2c/Makefile
> @@ -77,3 +77,4 @@ obj-$(CONFIG_VIDEO_SMIAPP_PLL)	+= smiapp-pll.o
>  obj-$(CONFIG_VIDEO_AK881X)		+= ak881x.o
>  obj-$(CONFIG_VIDEO_IR_I2C)  += ir-kbd-i2c.o
>  obj-$(CONFIG_VIDEO_ML86V7667)	+= ml86v7667.o
> +obj-$(CONFIG_VIDEO_OV2659)	+= ov2659.o
> diff --git a/drivers/media/i2c/ov2659.c b/drivers/media/i2c/ov2659.c
> new file mode 100644
> index 0000000..e79298b
> --- /dev/null
> +++ b/drivers/media/i2c/ov2659.c
> @@ -0,0 +1,1513 @@
> +/*
> + * Omnivision OV2659 CMOS Image Sensor driver
> + *
> + * Copyright (C) 2015 Texas Instruments, Inc.
> + *
> + * Benoit Parrot <bparrot@ti.com>
> + * Lad, Prabhakar <prabhakar.csengg@gmail.com>
> + *
> + * This program is free software; you may redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; version 2 of the License.
> + *
> + * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
> + * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
> + * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
> + * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
> + * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
> + * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
> + * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
> + * SOFTWARE.
> + */
> +
> +#include <linux/clk.h>
> +#include <linux/delay.h>
> +#include <linux/err.h>
> +#include <linux/init.h>
> +#include <linux/interrupt.h>
> +#include <linux/io.h>
> +#include <linux/i2c.h>
> +#include <linux/kernel.h>
> +#include <linux/media.h>
> +#include <linux/module.h>
> +#include <linux/of.h>
> +#include <linux/of_graph.h>
> +#include <linux/slab.h>
> +#include <linux/uaccess.h>
> +#include <linux/videodev2.h>
> +
> +#include <media/media-entity.h>
> +#include <media/ov2659.h>
> +#include <media/v4l2-common.h>
> +#include <media/v4l2-ctrls.h>
> +#include <media/v4l2-device.h>
> +#include <media/v4l2-event.h>

Your driver doesn't appear to support events. I propose to remove the
remaining references to them.

> +#include <media/v4l2-image-sizes.h>
> +#include <media/v4l2-mediabus.h>
> +#include <media/v4l2-of.h>
> +#include <media/v4l2-subdev.h>
> +
> +#define DRIVER_NAME "ov2659"
> +
> +/*
> + * OV2659 register definitions
> + */
> +#define REG_SOFTWARE_STANDBY		0x0100
> +#define REG_SOFTWARE_RESET		0x0103
> +#define REG_IO_CTRL00			0x3000
> +#define REG_IO_CTRL01			0x3001
> +#define REG_IO_CTRL02			0x3002
> +#define REG_OUTPUT_VALUE00		0x3008
> +#define REG_OUTPUT_VALUE01		0x3009
> +#define REG_OUTPUT_VALUE02		0x300d
> +#define REG_OUTPUT_SELECT00		0x300e
> +#define REG_OUTPUT_SELECT01		0x300f
> +#define REG_OUTPUT_SELECT02		0x3010
> +#define REG_OUTPUT_DRIVE		0x3011
> +#define REG_INPUT_READOUT00		0x302d
> +#define REG_INPUT_READOUT01		0x302e
> +#define REG_INPUT_READOUT02		0x302f
> +
> +#define REG_SC_PLL_CTRL0		0x3003
> +#define REG_SC_PLL_CTRL1		0x3004
> +#define REG_SC_PLL_CTRL2		0x3005
> +#define REG_SC_PLL_CTRL3		0x3006
> +#define REG_SC_CHIP_ID_H		0x300a
> +#define REG_SC_CHIP_ID_L		0x300b
> +#define REG_SC_PWC			0x3014
> +#define REG_SC_CLKRST0			0x301a
> +#define REG_SC_CLKRST1			0x301b
> +#define REG_SC_CLKRST2			0x301c
> +#define REG_SC_CLKRST3			0x301d
> +#define REG_SC_SUB_ID			0x302a
> +#define REG_SC_SCCB_ID			0x302b
> +
> +#define REG_GROUP_ADDRESS_00		0x3200
> +#define REG_GROUP_ADDRESS_01		0x3201
> +#define REG_GROUP_ADDRESS_02		0x3202
> +#define REG_GROUP_ADDRESS_03		0x3203
> +#define REG_GROUP_ACCESS		0x3208
> +
> +#define REG_AWB_R_GAIN_H		0x3400
> +#define REG_AWB_R_GAIN_L		0x3401
> +#define REG_AWB_G_GAIN_H		0x3402
> +#define REG_AWB_G_GAIN_L		0x3403
> +#define REG_AWB_B_GAIN_H		0x3404
> +#define REG_AWB_B_GAIN_L		0x3405
> +#define REG_AWB_MANUAL_CONTROL		0x3406
> +
> +#define REG_TIMING_HS_H			0x3800
> +#define REG_TIMING_HS_L			0x3801
> +#define REG_TIMING_VS_H			0x3802
> +#define REG_TIMING_VS_L			0x3803
> +#define REG_TIMING_HW_H			0x3804
> +#define REG_TIMING_HW_L			0x3805
> +#define REG_TIMING_VH_H			0x3806
> +#define REG_TIMING_VH_L			0x3807
> +#define REG_TIMING_DVPHO_H		0x3808
> +#define REG_TIMING_DVPHO_L		0x3809
> +#define REG_TIMING_DVPVO_H		0x380a
> +#define REG_TIMING_DVPVO_L		0x380b
> +#define REG_TIMING_HTS_H		0x380c
> +#define REG_TIMING_HTS_L		0x380d
> +#define REG_TIMING_VTS_H		0x380e
> +#define REG_TIMING_VTS_L		0x380f
> +#define REG_TIMING_HOFFS_H		0x3810
> +#define REG_TIMING_HOFFS_L		0x3811
> +#define REG_TIMING_VOFFS_H		0x3812
> +#define REG_TIMING_VOFFS_L		0x3813
> +#define REG_TIMING_XINC			0x3814
> +#define REG_TIMING_YINC			0x3815
> +#define REG_TIMING_VERT_FORMAT		0x3820
> +#define REG_TIMING_HORIZ_FORMAT		0x3821
> +
> +#define REG_AEC_PK_EXPOSURE_H		0x3500
> +#define REG_AEC_PK_EXPOSURE_M		0x3501
> +#define REG_AEC_PK_EXPOSURE_L		0x3502
> +#define REG_AEC_PK_MANUAL		0x3503
> +#define REG_AEC_MANUAL_GAIN_H		0x3504
> +#define REG_AEC_MANUAL_GAIN_L		0x3505
> +#define REG_AEC_ADD_VTS_H		0x3506
> +#define REG_AEC_ADD_VTS_L		0x3507
> +#define REG_AEK_PK_CTRL_08		0x3508
> +#define REG_AEK_PK_CTRL_09		0x3509
> +#define REG_AEC_PK_REAL_GAIN_H		0x350a
> +#define REG_AEC_PK_REAL_GAIN_L		0x350b
> +#define REG_AEC_REAL_GAIN_READ_H	0x3510
> +#define REG_AEC_REAL_GAIN_READ_L	0x3511
> +#define REG_AEC_SNR_GAIN_READ_H		0x3512
> +#define REG_AEC_SNR_GAIN_READ_L		0x3513
> +
> +#define REG_AEC_CTRL(num)		(0x3a00 + num)
> +
> +#define REG_FRAME_CTRL00		0x4201
> +#define REG_FRAME_CTRL01		0x4202
> +#define REG_FORMAT_CTRL00		0x4300
> +#define REG_CLIPPING_CTRL		0x4301
> +
> +#define REG_VFIFO_READ_CTRL		0x4601
> +#define REG_VFIFO_CTRL05		0x4605
> +#define REG_VFIFO_READ_START_H		0x4608
> +#define REG_VFIFO_READ_START_L		0x4609
> +
> +#define REG_DVP_CTRL01			0x4704
> +#define REG_DVP_CTRL02			0x4708
> +#define REG_DVP_CTRL03			0x4709
> +
> +#define REG_ISP_CTRL00			0x5000
> +#define REG_ISP_CTRL01			0x5001
> +#define REG_ISP_CTRL02			0x5002
> +#define REG_ISP_CTRL07			0x5007
> +#define REG_ISP_PRE_CTRL00		0x50a0
> +
> +#define REG_BLC_CTRL00			0x4000
> +#define REG_BLC_START_LINE		0x4001
> +#define REG_BLC_CTRL02			0x4002
> +#define REG_BLC_CTRL03			0x4003
> +#define REG_BLC_LINE_NUM		0x4004
> +#define REG_BLC_TARGET			0x4009
> +
> +#define REG_LENC_RED_X0_H		0x500c
> +#define REG_LENC_RED_X0_L		0x500d
> +#define REG_LENC_RED_Y0_H		0x500e
> +#define REG_LENC_RED_Y0_L		0x500f
> +#define REG_LENC_RED_A1			0x5010
> +#define REG_LENC_RED_B1			0x5011
> +#define REG_LENC_RED_A2_B2		0x5012
> +#define REG_LENC_GREEN_X0_H		0x5013
> +#define REG_LENC_GREEN_X0_L		0x5014
> +#define REG_LENC_GREEN_Y0_H		0x5015
> +#define REG_LENC_GREEN_Y0_L		0x5016
> +#define REG_LENC_GREEN_A1		0x5017
> +#define REG_LENC_GREEN_B1		0x5018
> +#define REG_LENC_GREEN_A2_B2		0x5019
> +#define REG_LENC_BLUE_X0_H		0x501a
> +#define REG_LENC_BLUE_X0_L		0x501b
> +#define REG_LENC_BLUE_Y0_H		0x501c
> +#define REG_LENC_BLUE_Y0_L		0x501d
> +#define REG_LENC_BLUE_A1		0x501e
> +#define REG_LENC_BLUE_B1		0x501f
> +#define REG_LENC_BLUE_A2_B2		0x5020
> +#define REG_LENC_CTRL00			0x5021
> +#define REG_LENC_CTRL01			0x5022
> +#define REG_COEFFICIENT_THRESH		0x5023
> +#define REG_COEFFICIENT_MANUAL_VAL	0x5024
> +
> +#define REG_GAMMA_YST(num)		(0x5025 + (num - 1))
> +#define REG_GAMMA_YSLP			0x5034
> +
> +#define REG_AWB_CTRL00			0x5035
> +#define REG_AWB_CTRL01			0x5036
> +#define REG_AWB_CTRL02			0x5037
> +#define REG_AWB_CTRL03			0x5038
> +#define REG_AWB_CTRL04			0x5039
> +#define REG_AWB_LOCAL_LIMIT		0x503a
> +#define REG_AWB_CTRL12			0x5049
> +#define REG_AWB_CTRL13			0x504a
> +#define REG_AWB_CTRL14			0x504b
> +
> +#define REG_AVG_CTRL(num)		(0x5060 + num)
> +#define REG_AVG_READOUT			0x5237
> +
> +#define REG_SHARPENMT_THRESH1		0x5064
> +#define REG_SHARPENMT_THRESH2		0x5065
> +#define REG_SHARPENMT_OFFSET1		0x5066
> +#define REG_SHARPENMT_OFFSET2		0x5067
> +#define REG_DENOISE_THRESH1		0x5068
> +#define REG_DENOISE_THRESH2		0x5069
> +#define REG_DENOISE_OFFSET1		0x506a
> +#define REG_DENOISE_OFFSET2		0x506b
> +#define REG_SHARPEN_THRESH1		0x506c
> +#define REG_SHARPEN_THRESH2		0x506d
> +#define REG_CIP_CTRL00			0x506e
> +#define REG_CIP_CTRL01			0x506f
> +
> +#define REG_CMX(num)			(0x5070 + (num - 1))
> +#define REG_CMX_SIGN			0x5079
> +#define REG_CMX_MISC_CTRL		0x507a
> +
> +#define REG_SDE_CTRL(num)		(0x507b + num)
> +
> +#define REG_SCALE_CTRL0			0x5600
> +#define REG_SCALE_CTRL1			0x5601
> +#define REG_XSC_H			0x5602
> +#define REG_XSC_L			0x5603
> +#define REG_YSC_H			0x5604
> +#define REG_YSC_L			0x5605
> +#define REG_VOFFSET			0x5606
> +#define REG_NULL			0x0000	/* Array end token */
> +
> +#define OV265X_ID(_msb, _lsb)		((_msb) << 8 | (_lsb))
> +#define OV2659_ID			0x2656
> +
> +/* Target Pixel Clock */
> +#define OV2659_PIXEL_CLOCK		70000000

Shouldn't this be something that comes form DT instead?

It may not matter everywhere, but due to EMI issues not all frequencies
can be used on some / many boards.

> +
> +struct sensor_register {
> +	u16 addr;
> +	u8 value;
> +};
> +
> +struct ov2659_framesize {
> +	u16 width;
> +	u16 height;
> +	u16 max_exp_lines;
> +	const struct sensor_register *regs;
> +};
> +
> +struct ov2659_pll_ctrl {
> +	u8 ctrl1;
> +	u8 ctrl2;
> +	u8 ctrl3;
> +};
> +
> +struct ov2659_pixfmt {
> +	u32 code;
> +	u32 colorspace;
> +	/* Output format Register Value (REG_FORMAT_CTRL00) */
> +	struct sensor_register *format_ctrl_regs;
> +};
> +
> +struct pll_ctrl_reg {
> +	unsigned int div;
> +	unsigned char reg;
> +};
> +
> +struct ov2659 {
> +	struct v4l2_subdev sd;
> +	struct media_pad pad;
> +	enum v4l2_mbus_type bus_type;
> +	struct v4l2_mbus_framefmt format;
> +	const struct ov2659_platform_data *pdata;
> +	struct mutex lock;
> +	struct i2c_client *client;
> +	const struct ov2659_framesize *frame_size;
> +	struct sensor_register *format_ctrl_regs;
> +	struct ov2659_pll_ctrl pll;
> +	int streaming;
> +};
> +
> +static const struct sensor_register ov2659_init_regs[] = {
> +	{0x3000, 0x03}, /* IO CTRL */
> +	{0x3001, 0xff}, /* IO CTRL */
> +	{0x3002, 0xe0}, /* IO CTRL */
> +	{0x3633, 0x3d},
> +	{0x3620, 0x02},
> +	{0x3631, 0x11},
> +	{0x3612, 0x04},
> +	{0x3630, 0x20},
> +	{0x4702, 0x02}, /* DVP Debug mode */
> +	{0x370c, 0x34},
> +	{0x3004, 0x10}, /* System Divider */
> +	{0x3005, 0x22}, /* Pixel clock Multiplier */

Do these belong here?

> +	{0x3800, 0x00}, /* TIMING */
> +	{0x3801, 0x00}, /* TIMING */
> +	{0x3802, 0x00}, /* TIMING */
> +	{0x3803, 0x00}, /* TIMING */
> +	{0x3804, 0x06}, /* TIMING */
> +	{0x3805, 0x5f}, /* TIMING */
> +	{0x3806, 0x04}, /* TIMING */
> +	{0x3807, 0xb7}, /* TIMING */
> +	{0x3808, 0x03}, /* Horizontal High Byte */
> +	{0x3809, 0x20}, /* Horizontal Low Byte */
> +	{0x380a, 0x02}, /* Vertical High Byte */
> +	{0x380b, 0x58}, /* Vertical Low Byte */
> +	{0x380c, 0x05}, /* TIMING */
> +	{0x380d, 0x14}, /* TIMING */
> +	{0x380e, 0x02}, /* TIMING */
> +	{0x380f, 0x68}, /* TIMING */
> +	{0x3811, 0x08}, /* TIMING */
> +	{0x3813, 0x02}, /* TIMING */
> +	{0x3814, 0x31}, /* TIMING */
> +	{0x3815, 0x31}, /* TIMING */
> +	{0x3a02, 0x02}, /* AEC */
> +	{0x3a03, 0x68}, /* AEC */
> +	{0x3a08, 0x00}, /* AEC */
> +	{0x3a09, 0x5c}, /* AEC */
> +	{0x3a0a, 0x00}, /* AEC */
> +	{0x3a0b, 0x4d}, /* AEC */
> +	{0x3a0d, 0x08}, /* AEC */
> +	{0x3a0e, 0x06}, /* AEC */
> +	{0x3a14, 0x02}, /* AEC */
> +	{0x3a15, 0x28}, /* AEC */
> +	{0x4708, 0x01}, /* DVP */
> +	{0x3623, 0x00},
> +	{0x3634, 0x76},
> +	{0x3701, 0x44},
> +	{0x3702, 0x18},
> +	{0x3703, 0x24},
> +	{0x3704, 0x24},
> +	{0x3705, 0x0c},
> +	{0x3820, 0x81}, /* TIMING */
> +	{0x3821, 0x01}, /* TIMING */
> +	{0x370a, 0x52},
> +	{0x4608, 0x00}, /* VFIFO */
> +	{0x4609, 0x80}, /* VFIFO */
> +	{0x4300, 0x30}, /* Format */
> +	{0x5086, 0x02},
> +	{0x5000, 0xfb}, /* DPC/ISP */
> +	{0x5001, 0x1f}, /* ISP */
> +	{0x5002, 0x00}, /* ISP */
> +	{0x5025, 0x0e}, /* GAMMA */
> +	{0x5026, 0x18}, /* GAMMA */
> +	{0x5027, 0x34}, /* GAMMA */
> +	{0x5028, 0x4c}, /* GAMMA */
> +	{0x5029, 0x62}, /* GAMMA */
> +	{0x502a, 0x74}, /* GAMMA */
> +	{0x502b, 0x85}, /* GAMMA */
> +	{0x502c, 0x92}, /* GAMMA */
> +	{0x502d, 0x9e}, /* GAMMA */
> +	{0x502e, 0xb2}, /* GAMMA */
> +	{0x502f, 0xc0}, /* GAMMA */
> +	{0x5030, 0xcc}, /* GAMMA */
> +	{0x5031, 0xe0}, /* GAMMA */
> +	{0x5032, 0xee}, /* GAMMA */
> +	{0x5033, 0xf6}, /* GAMMA */
> +	{0x5034, 0x11}, /* GAMMA */
> +	{0x5070, 0x1c}, /* CMX */
> +	{0x5071, 0x5b}, /* CMX */
> +	{0x5072, 0x05}, /* CMX */
> +	{0x5073, 0x20}, /* CMX */
> +	{0x5074, 0x94}, /* CMX */
> +	{0x5075, 0xb4}, /* CMX */
> +	{0x5076, 0xb4}, /* CMX */
> +	{0x5077, 0xaf}, /* CMX */
> +	{0x5078, 0x05}, /* CMX */
> +	{0x5079, 0x98}, /* CMX */
> +	{0x507a, 0x21}, /* CMX */
> +	{0x5035, 0x6a}, /* AWB */
> +	{0x5036, 0x11}, /* AWB */
> +	{0x5037, 0x92}, /* AWB */
> +	{0x5038, 0x21}, /* AWB */
> +	{0x5039, 0xe1}, /* AWB */
> +	{0x503a, 0x01}, /* AWB */
> +	{0x503c, 0x05}, /* AWB */
> +	{0x503d, 0x08}, /* AWB */
> +	{0x503e, 0x08}, /* AWB */
> +	{0x503f, 0x64}, /* AWB */
> +	{0x5040, 0x58}, /* AWB */
> +	{0x5041, 0x2a}, /* AWB */
> +	{0x5042, 0xc5}, /* AWB */
> +	{0x5043, 0x2e}, /* AWB */
> +	{0x5044, 0x3a}, /* AWB */
> +	{0x5045, 0x3c}, /* AWB */
> +	{0x5046, 0x44}, /* AWB */
> +	{0x5047, 0xf8}, /* AWB */
> +	{0x5048, 0x08}, /* AWB */
> +	{0x5049, 0x70}, /* AWB */
> +	{0x504a, 0xf0}, /* AWB */
> +	{0x504b, 0xf0}, /* AWB */
> +	{0x500c, 0x03}, /* LENC/ISP TOP Debug */
> +	{0x500d, 0x20}, /* LENC/ISP TOP Debug */
> +	{0x500e, 0x02}, /* LENC/ISP TOP Debug */
> +	{0x500f, 0x5c}, /* LENC/ISP TOP Debug */
> +	{0x5010, 0x48}, /* LENC/ISP TOP Debug */
> +	{0x5011, 0x00}, /* LENC/ISP TOP Debug */
> +	{0x5012, 0x66}, /* LENC/ISP TOP Debug */
> +	{0x5013, 0x03}, /* LENC/ISP TOP Debug */
> +	{0x5014, 0x30}, /* LENC/ISP TOP Debug */
> +	{0x5015, 0x02}, /* LENC/ISP TOP Debug */
> +	{0x5016, 0x7c}, /* LENC/ISP TOP Debug */
> +	{0x5017, 0x40}, /* LENC/ISP TOP Debug */
> +	{0x5018, 0x00}, /* LENC/ISP TOP Debug */
> +	{0x5019, 0x66}, /* LENC/ISP TOP Debug */
> +	{0x501a, 0x03}, /* LENC/ISP TOP Debug */
> +	{0x501b, 0x10}, /* LENC/ISP TOP Debug */
> +	{0x501c, 0x02}, /* LENC/ISP TOP Debug */
> +	{0x501d, 0x7c}, /* LENC/ISP TOP Debug */
> +	{0x501e, 0x3a}, /* LENC/ISP TOP Debug */
> +	{0x501f, 0x00}, /* LENC/ISP TOP Debug */
> +	{0x5020, 0x66}, /* LENC/ISP TOP Debug */
> +	{0x506e, 0x44}, /* CIP/DNS */
> +	{0x5064, 0x08}, /* CIP/DNS */
> +	{0x5065, 0x10}, /* CIP/DNS */
> +	{0x5066, 0x12}, /* CIP/DNS */
> +	{0x5067, 0x02}, /* CIP/DNS */
> +	{0x506c, 0x08}, /* CIP/DNS */
> +	{0x506d, 0x10}, /* CIP/DNS */
> +	{0x506f, 0xa6}, /* CIP/DNS */
> +	{0x5068, 0x08}, /* CIP/DNS */
> +	{0x5069, 0x10}, /* CIP/DNS */
> +	{0x506a, 0x04}, /* CIP/DNS */
> +	{0x506b, 0x12}, /* CIP/DNS */
> +	{0x507e, 0x40}, /* SDE */
> +	{0x507f, 0x20}, /* SDE */
> +	{0x507b, 0x02}, /* SDE */
> +	{0x507a, 0x01}, /* CMX/SDE */
> +	{0x5084, 0x0c}, /* SDE */
> +	{0x5085, 0x3e}, /* SDE */
> +	{0x5005, 0x80}, /* ISP TOP Debug */
> +	{0x3a0f, 0x30}, /* AEC */
> +	{0x3a10, 0x28}, /* AEC */
> +	{0x3a1b, 0x32}, /* AEC */
> +	{0x3a1e, 0x26}, /* AEC */
> +	{0x3a11, 0x60}, /* AEC */
> +	{0x3a1f, 0x14}, /* AEC */
> +	{0x5060, 0x69}, /* Y AVG */
> +	{0x5061, 0x7d}, /* Y AVG */
> +	{0x5062, 0x7d}, /* Y AVG */
> +	{0x5063, 0x69}, /* Y AVG */
> +	{0x0000, 0x00}
> +};
> +
> +/* 1280X720 720p */
> +static struct sensor_register ov2659_720p[] = {
> +	{0x3800, 0x00},
> +	{0x3801, 0xa0},
> +	{0x3802, 0x00},
> +	{0x3803, 0xf0},
> +	{0x3804, 0x05},
> +	{0x3805, 0xbf},
> +	{0x3806, 0x03},
> +	{0x3807, 0xcb},
> +	{0x3808, 0x05},
> +	{0x3809, 0x00},
> +	{0x380a, 0x02},
> +	{0x380b, 0xd0},
> +	{0x380c, 0x06},
> +	{0x380d, 0x4c},
> +	{0x380e, 0x02},
> +	{0x380f, 0xe8},
> +	{0x3811, 0x10},
> +	{0x3813, 0x06},
> +	{0x3814, 0x11},
> +	{0x3815, 0x11},
> +	{0x3820, 0x80},
> +	{0x3821, 0x00},
> +	{0x3a03, 0xe8},
> +	{0x3a09, 0x6f},
> +	{0x3a0b, 0x5d},
> +	{0x3a15, 0x9a},
> +	{0x0000, 0x00}
> +};
> +
> +/* 1600X1200 UXGA */
> +static struct sensor_register ov2659_uxga[] = {
> +	{0x3800, 0x00},
> +	{0x3801, 0x00},
> +	{0x3802, 0x00},
> +	{0x3803, 0x00},
> +	{0x3804, 0x06},
> +	{0x3805, 0x5f},
> +	{0x3806, 0x04},
> +	{0x3807, 0xbb},
> +	{0x3808, 0x06},
> +	{0x3809, 0x40},
> +	{0x380a, 0x04},
> +	{0x380b, 0xb0},
> +	{0x380c, 0x07},
> +	{0x380d, 0x9f},
> +	{0x380e, 0x04},
> +	{0x380f, 0xd0},
> +	{0x3811, 0x10},
> +	{0x3813, 0x06},
> +	{0x3814, 0x11},
> +	{0x3815, 0x11},
> +	{0x3a02, 0x04},
> +	{0x3a03, 0xd0},
> +	{0x3a08, 0x00},
> +	{0x3a09, 0xb8},
> +	{0x3a0a, 0x00},
> +	{0x3a0b, 0x9a},
> +	{0x3a0d, 0x08},
> +	{0x3a0e, 0x06},
> +	{0x3a14, 0x04},
> +	{0x3a15, 0x50},
> +	{0x3623, 0x00},
> +	{0x3634, 0x44},
> +	{0x3701, 0x44},
> +	{0x3702, 0x30},
> +	{0x3703, 0x48},
> +	{0x3704, 0x48},
> +	{0x3705, 0x18},
> +	{0x3820, 0x80},
> +	{0x3821, 0x00},
> +	{0x370a, 0x12},
> +	{0x4608, 0x00},
> +	{0x4609, 0x80},
> +	{0x5002, 0x00},
> +	{0x0000, 0x00}
> +};
> +
> +/* 1280X1024 SXGA */
> +static struct sensor_register ov2659_sxga[] = {
> +	{0x3800, 0x00},
> +	{0x3801, 0x00},
> +	{0x3802, 0x00},
> +	{0x3803, 0x00},
> +	{0x3804, 0x06},
> +	{0x3805, 0x5f},
> +	{0x3806, 0x04},
> +	{0x3807, 0xb7},
> +	{0x3808, 0x05},
> +	{0x3809, 0x00},
> +	{0x380a, 0x04},
> +	{0x380b, 0x00},
> +	{0x380c, 0x07},
> +	{0x380d, 0x9c},
> +	{0x380e, 0x04},
> +	{0x380f, 0xd0},
> +	{0x3811, 0x10},
> +	{0x3813, 0x06},
> +	{0x3814, 0x11},
> +	{0x3815, 0x11},
> +	{0x3a02, 0x02},
> +	{0x3a03, 0x68},
> +	{0x3a08, 0x00},
> +	{0x3a09, 0x5c},
> +	{0x3a0a, 0x00},
> +	{0x3a0b, 0x4d},
> +	{0x3a0d, 0x08},
> +	{0x3a0e, 0x06},
> +	{0x3a14, 0x02},
> +	{0x3a15, 0x28},
> +	{0x3623, 0x00},
> +	{0x3634, 0x76},
> +	{0x3701, 0x44},
> +	{0x3702, 0x18},
> +	{0x3703, 0x24},
> +	{0x3704, 0x24},
> +	{0x3705, 0x0c},
> +	{0x3820, 0x80},
> +	{0x3821, 0x00},
> +	{0x370a, 0x52},
> +	{0x4608, 0x00},
> +	{0x4609, 0x80},
> +	{0x5002, 0x00},
> +	{0x0000, 0x00}
> +};
> +
> +/* 1024X768 SXGA */
> +static struct sensor_register ov2659_xga[] = {
> +	{0x3800, 0x00},
> +	{0x3801, 0x00},
> +	{0x3802, 0x00},
> +	{0x3803, 0x00},
> +	{0x3804, 0x06},
> +	{0x3805, 0x5f},
> +	{0x3806, 0x04},
> +	{0x3807, 0xb7},
> +	{0x3808, 0x04},
> +	{0x3809, 0x00},
> +	{0x380a, 0x03},
> +	{0x380b, 0x00},
> +	{0x380c, 0x07},
> +	{0x380d, 0x9c},
> +	{0x380e, 0x04},
> +	{0x380f, 0xd0},
> +	{0x3811, 0x10},
> +	{0x3813, 0x06},
> +	{0x3814, 0x11},
> +	{0x3815, 0x11},
> +	{0x3a02, 0x02},
> +	{0x3a03, 0x68},
> +	{0x3a08, 0x00},
> +	{0x3a09, 0x5c},
> +	{0x3a0a, 0x00},
> +	{0x3a0b, 0x4d},
> +	{0x3a0d, 0x08},
> +	{0x3a0e, 0x06},
> +	{0x3a14, 0x02},
> +	{0x3a15, 0x28},
> +	{0x3623, 0x00},
> +	{0x3634, 0x76},
> +	{0x3701, 0x44},
> +	{0x3702, 0x18},
> +	{0x3703, 0x24},
> +	{0x3704, 0x24},
> +	{0x3705, 0x0c},
> +	{0x3820, 0x80},
> +	{0x3821, 0x00},
> +	{0x370a, 0x52},
> +	{0x4608, 0x00},
> +	{0x4609, 0x80},
> +	{0x5002, 0x00},
> +	{0x0000, 0x00}
> +};
> +
> +/* 800X600 SVGA */
> +static struct sensor_register ov2659_svga[] = {
> +	{0x3800, 0x00},
> +	{0x3801, 0x00},
> +	{0x3802, 0x00},
> +	{0x3803, 0x00},
> +	{0x3804, 0x06},
> +	{0x3805, 0x5f},
> +	{0x3806, 0x04},
> +	{0x3807, 0xb7},
> +	{0x3808, 0x03},
> +	{0x3809, 0x20},
> +	{0x380a, 0x02},
> +	{0x380b, 0x58},
> +	{0x380c, 0x05},
> +	{0x380d, 0x14},
> +	{0x380e, 0x02},
> +	{0x380f, 0x68},
> +	{0x3811, 0x08},
> +	{0x3813, 0x02},
> +	{0x3814, 0x31},
> +	{0x3815, 0x31},
> +	{0x3a02, 0x02},
> +	{0x3a03, 0x68},
> +	{0x3a08, 0x00},
> +	{0x3a09, 0x5c},
> +	{0x3a0a, 0x00},
> +	{0x3a0b, 0x4d},
> +	{0x3a0d, 0x08},
> +	{0x3a0e, 0x06},
> +	{0x3a14, 0x02},
> +	{0x3a15, 0x28},
> +	{0x3623, 0x00},
> +	{0x3634, 0x76},
> +	{0x3701, 0x44},
> +	{0x3702, 0x18},
> +	{0x3703, 0x24},
> +	{0x3704, 0x24},
> +	{0x3705, 0x0c},
> +	{0x3820, 0x81},
> +	{0x3821, 0x01},
> +	{0x370a, 0x52},
> +	{0x4608, 0x00},
> +	{0x4609, 0x80},
> +	{0x5002, 0x00},
> +	{0x0000, 0x00}
> +};
> +
> +/* 640X480 VGA */
> +static struct sensor_register ov2659_vga[] = {
> +	{0x3800, 0x00},
> +	{0x3801, 0x00},
> +	{0x3802, 0x00},
> +	{0x3803, 0x00},
> +	{0x3804, 0x06},
> +	{0x3805, 0x5f},
> +	{0x3806, 0x04},
> +	{0x3807, 0xb7},
> +	{0x3808, 0x02},
> +	{0x3809, 0x80},
> +	{0x380a, 0x01},
> +	{0x380b, 0xe0},
> +	{0x380c, 0x05},
> +	{0x380d, 0x14},
> +	{0x380e, 0x02},
> +	{0x380f, 0x68},
> +	{0x3811, 0x08},
> +	{0x3813, 0x02},
> +	{0x3814, 0x31},
> +	{0x3815, 0x31},
> +	{0x3a02, 0x02},
> +	{0x3a03, 0x68},
> +	{0x3a08, 0x00},
> +	{0x3a09, 0x5c},
> +	{0x3a0a, 0x00},
> +	{0x3a0b, 0x4d},
> +	{0x3a0d, 0x08},
> +	{0x3a0e, 0x06},
> +	{0x3a14, 0x02},
> +	{0x3a15, 0x28},
> +	{0x3623, 0x00},
> +	{0x3634, 0x76},
> +	{0x3701, 0x44},
> +	{0x3702, 0x18},
> +	{0x3703, 0x24},
> +	{0x3704, 0x24},
> +	{0x3705, 0x0c},
> +	{0x3820, 0x81},
> +	{0x3821, 0x01},
> +	{0x370a, 0x52},
> +	{0x4608, 0x00},
> +	{0x4609, 0x80},
> +	{0x5002, 0x10},
> +	{0x0000, 0x00}
> +};
> +
> +/* 320X240 QVGA */
> +static  struct sensor_register ov2659_qvga[] = {
> +	{0x3800, 0x00},
> +	{0x3801, 0x00},
> +	{0x3802, 0x00},
> +	{0x3803, 0x00},
> +	{0x3804, 0x06},
> +	{0x3805, 0x5f},
> +	{0x3806, 0x04},
> +	{0x3807, 0xb7},
> +	{0x3808, 0x01},
> +	{0x3809, 0x40},
> +	{0x380a, 0x00},
> +	{0x380b, 0xf0},
> +	{0x380c, 0x05},
> +	{0x380d, 0x14},
> +	{0x380e, 0x02},
> +	{0x380f, 0x68},
> +	{0x3811, 0x08},
> +	{0x3813, 0x02},
> +	{0x3814, 0x31},
> +	{0x3815, 0x31},
> +	{0x3a02, 0x02},
> +	{0x3a03, 0x68},
> +	{0x3a08, 0x00},
> +	{0x3a09, 0x5c},
> +	{0x3a0a, 0x00},
> +	{0x3a0b, 0x4d},
> +	{0x3a0d, 0x08},
> +	{0x3a0e, 0x06},
> +	{0x3a14, 0x02},
> +	{0x3a15, 0x28},
> +	{0x3623, 0x00},
> +	{0x3634, 0x76},
> +	{0x3701, 0x44},
> +	{0x3702, 0x18},
> +	{0x3703, 0x24},
> +	{0x3704, 0x24},
> +	{0x3705, 0x0c},
> +	{0x3820, 0x81},
> +	{0x3821, 0x01},
> +	{0x370a, 0x52},
> +	{0x4608, 0x00},
> +	{0x4609, 0x80},
> +	{0x5002, 0x10},
> +	{0x0000, 0x00}
> +};
> +
> +static const struct pll_ctrl_reg ctrl3[] = {
> +	{1, 0x00},
> +	{2, 0x02},
> +	{3, 0x03},
> +	{4, 0x06},
> +	{6, 0x0d},
> +	{8, 0x0e},
> +	{12, 0x0f},
> +	{16, 0x12},
> +	{24, 0x13},
> +	{32, 0x16},
> +	{48, 0x1b},
> +	{64, 0x1e},
> +	{96, 0x1f},
> +	{0, 0x00},
> +};
> +
> +static const struct pll_ctrl_reg ctrl1[] = {
> +	{2, 0x10},
> +	{4, 0x20},
> +	{6, 0x30},
> +	{8, 0x40},
> +	{10, 0x50},
> +	{12, 0x60},
> +	{14, 0x70},
> +	{16, 0x80},
> +	{18, 0x90},
> +	{20, 0xa0},
> +	{22, 0xb0},
> +	{24, 0xc0},
> +	{26, 0xd0},
> +	{28, 0xe0},
> +	{30, 0xf0},
> +	{0, 0x00},
> +};
> +
> +static const struct ov2659_framesize ov2659_framesizes[] = {
> +	{ /* QVGA */
> +		.width		= 320,
> +		.height		= 240,
> +		.regs		= ov2659_qvga,
> +		.max_exp_lines	= 248,
> +	}, { /* VGA */
> +		.width		= 640,
> +		.height		= 480,
> +		.regs		= ov2659_vga,
> +		.max_exp_lines	= 498,
> +	}, { /* SVGA */
> +		.width		= 800,
> +		.height		= 600,
> +		.regs		= ov2659_svga,
> +		.max_exp_lines	= 498,
> +	}, { /* XGA */
> +		.width		= 1024,
> +		.height		= 768,
> +		.regs		= ov2659_xga,
> +		.max_exp_lines	= 498,
> +	}, { /* 720P */
> +		.width		= 1280,
> +		.height		= 720,
> +		.regs		= ov2659_720p,
> +		.max_exp_lines	= 498,
> +	}, { /* SXGA */
> +		.width		= 1280,
> +		.height		= 1024,
> +		.regs		= ov2659_sxga,
> +		.max_exp_lines	= 1048,
> +	}, { /* UXGA */
> +		.width		= 1600,
> +		.height		= 1200,
> +		.regs		= ov2659_uxga,
> +		.max_exp_lines	= 498,
> +	},
> +};
> +
> +/* YUV422 YUYV*/
> +static struct sensor_register ov2659_format_yuyv[] = {
> +	{0x4300, 0x30},
> +	{0x0000, 0x0},
> +};
> +
> +/* YUV422 UYVY  */
> +static struct sensor_register ov2659_format_uyvy[] = {
> +	{0x4300, 0x32},
> +	{0x0000, 0x0},
> +};
> +
> +/* Raw Bayer BGGR */
> +static struct sensor_register ov2659_format_bggr[] = {
> +	{0x4300, 0x00},
> +	{0x0000, 0x0}
> +};
> +
> +/* RGB565 */
> +static struct sensor_register ov2659_format_rgb565[] = {
> +	{0x4300, 0x60},
> +	{0x0000, 0x0},
> +};
> +
> +static const struct ov2659_pixfmt ov2659_formats[] = {
> +	{
> +		.code = MEDIA_BUS_FMT_YUYV8_2X8,
> +		.colorspace = V4L2_COLORSPACE_JPEG,
> +		.format_ctrl_regs = ov2659_format_yuyv,
> +	},
> +	{
> +		.code = MEDIA_BUS_FMT_UYVY8_2X8,
> +		.colorspace = V4L2_COLORSPACE_JPEG,
> +		.format_ctrl_regs = ov2659_format_uyvy,
> +	},
> +	{
> +		.code = MEDIA_BUS_FMT_RGB565_2X8_BE,
> +		.colorspace = V4L2_COLORSPACE_JPEG,
> +		.format_ctrl_regs = ov2659_format_rgb565,
> +	},
> +	{
> +		.code = MEDIA_BUS_FMT_SBGGR8_1X8,
> +		.colorspace = V4L2_COLORSPACE_SMPTE170M,
> +		.format_ctrl_regs = ov2659_format_bggr,
> +	},
> +};
> +
> +static inline struct ov2659 *to_ov2659(struct v4l2_subdev *sd)
> +{
> +	return container_of(sd, struct ov2659, sd);
> +}
> +
> +/* sensor register write */
> +static int ov2659_write(struct i2c_client *client, u16 reg, u8 val)
> +{
> +	struct i2c_msg msg[1];

An array of size 1? :-) How about just plain msg scalar value instead?

> +	u8 buf[3];
> +	int ret;
> +
> +	buf[0] = reg >> 8;
> +	buf[1] = reg & 0xFF;
> +	buf[2] = val;
> +
> +	msg->addr = client->addr;
> +	msg->flags = client->flags;
> +	msg->buf = buf;
> +	msg->len = sizeof(buf);
> +
> +	ret = i2c_transfer(client->adapter, msg, 1);
> +	if (ret >= 0)
> +		return 0;
> +
> +	dev_dbg(&client->dev,
> +		"ov2659 write reg(0x%x val:0x%x) failed !\n", reg, val);
> +
> +	return ret;
> +}
> +
> +/* sensor register read */
> +static int ov2659_read(struct i2c_client *client, u16 reg, u8 *val)
> +{
> +	struct i2c_msg msg[2];
> +	u8 buf[2];
> +	int ret;
> +
> +	buf[0] = reg >> 8;
> +	buf[1] = reg & 0xFF;
> +
> +	msg[0].addr = client->addr;
> +	msg[0].flags = client->flags;
> +	msg[0].buf = buf;
> +	msg[0].len = sizeof(buf);
> +
> +	msg[1].addr = client->addr;
> +	msg[1].flags = client->flags | I2C_M_RD;
> +	msg[1].buf = buf;
> +	msg[1].len = 1;
> +
> +	ret = i2c_transfer(client->adapter, msg, 2);
> +	if (ret >= 0) {
> +		*val = buf[0];
> +		return 0;
> +	}
> +
> +	dev_dbg(&client->dev,
> +		"ov2659 read reg(0x%x val:0x%x) failed !\n", reg, *val);
> +
> +	return ret;
> +}
> +
> +static int ov2659_write_array(struct i2c_client *client,
> +			      const struct sensor_register *regs)
> +{
> +	int i, ret = 0;
> +
> +	for (i = 0; ret == 0 && regs[i].addr; i++)
> +		ret = ov2659_write(client, regs[i].addr, regs[i].value);
> +
> +	return ret;
> +}
> +
> +static unsigned int ov2659_pll_calc_params(struct ov2659 *ov2659)
> +{
> +	const struct ov2659_platform_data *pdata = ov2659->pdata;
> +	u8 ctrl1_reg = 0, ctrl2_reg = 0, ctrl3_reg = 0;
> +	struct i2c_client *client = ov2659->client;
> +	u32 s_prediv = 1, s_postdiv = 1, s_mult = 1;
> +	u32 desired = OV2659_PIXEL_CLOCK;
> +	u32 prediv, postdiv, mult;
> +	u32 bestdelta = -1;
> +	u32 delta, actual;
> +	int i, j;
> +
> +	for (i = 0; ctrl1[i].div != 0; i++) {
> +		postdiv = ctrl1[i].div;
> +		for (j = 0; ctrl3[j].div != 0; j++) {
> +			prediv = ctrl3[j].div;
> +			for (mult = 1; mult <= 63; mult++) {
> +				actual  = pdata->xvclk_frequency;
> +				actual *= mult;

I don't know about the exact composition of the PLL you have in this sensor,
however there typically are frequency limits in different parts of the PLL
tree. They are not checked here.

> +				actual /= prediv;
> +				actual /= postdiv;
> +				delta = (actual-desired);
> +				delta = abs(delta);
> +
> +				if ((delta < bestdelta) || (bestdelta == -1)) {
> +					bestdelta = delta;
> +					s_mult    = mult;
> +					s_prediv  = prediv;
> +					s_postdiv = postdiv;
> +					ctrl1_reg = ctrl1[i].reg;
> +					ctrl2_reg = mult;
> +					ctrl3_reg = ctrl3[j].reg;
> +				}
> +			}
> +		}
> +	}
> +	actual = pdata->xvclk_frequency * (s_mult);
> +	actual /= (s_prediv) * (s_postdiv);
> +
> +	dev_dbg(&client->dev, "Actual osc: %u pixel_clock: %u\n",
> +		pdata->xvclk_frequency, actual);
> +
> +	ov2659->pll.ctrl1 = ctrl1_reg;
> +	ov2659->pll.ctrl2 = ctrl2_reg;
> +	ov2659->pll.ctrl3 = ctrl3_reg;
> +
> +	dev_dbg(&client->dev,
> +		"Actual reg config: ctrl1_reg: %02x ctrl2_reg: %02x ctrl3_reg: %02x\n",
> +		ctrl1_reg, ctrl2_reg, ctrl3_reg);
> +
> +	return actual;
> +}
> +
> +static int ov2659_set_pixel_clock(struct ov2659 *ov2659)
> +{
> +	struct i2c_client *client = ov2659->client;
> +	struct sensor_register pll_regs[] = {
> +		{0x3004, 0x10}, /* System Divider */

You have human readable names for these registers. Please use them instead.

> +		{0x3005, 0x22}, /* Pixel clock Multiplier */
> +		{0x3006, 0x0d}, /* System Divider */
> +		{0x0000, 0x00},
> +	};
> +
> +	pll_regs[0].value = ov2659->pll.ctrl1;
> +	pll_regs[1].value = ov2659->pll.ctrl2;
> +	pll_regs[2].value = ov2659->pll.ctrl3;

You could assign these in variable declaration rather than overwriting
the values here.

> +	dev_dbg(&client->dev, "%s\n", __func__);
> +
> +	return ov2659_write_array(client, pll_regs);
> +};
> +
> +static void ov2659_get_default_format(struct v4l2_mbus_framefmt *format)
> +{
> +	format->width = ov2659_framesizes[2].width;
> +	format->height = ov2659_framesizes[2].height;
> +	format->colorspace = ov2659_formats[0].colorspace;
> +	format->code = ov2659_formats[0].code;
> +	format->field = V4L2_FIELD_NONE;
> +}
> +
> +static void ov2659_set_streaming(struct ov2659 *ov2659, int on)
> +{
> +	struct i2c_client *client = ov2659->client;
> +	int ret;
> +
> +	on = !!on;
> +
> +	dev_dbg(&client->dev, "%s: on: %d\n", __func__, on);
> +
> +	ret = ov2659_write(client, REG_SOFTWARE_STANDBY, on);
> +	if (ret)
> +		dev_err(&client->dev, "ov2659 soft standby failed\n");
> +}
> +
> +static int ov2659_reset(struct v4l2_subdev *sd, u32 val)
> +{
> +	struct i2c_client *client = v4l2_get_subdevdata(sd);
> +	int ret;
> +
> +	ret = ov2659_write(client, REG_SOFTWARE_RESET, 0x01);
> +	if (ret != 0) {
> +		dev_err(&client->dev, "Sensor soft reset failed\n");
> +		return -ENODEV;
> +	}
> +	usleep_range(1000, 2000);
> +
> +	return 0;
> +}
> +
> +static int ov2659_init(struct v4l2_subdev *sd, u32 val)
> +{
> +	struct i2c_client *client = v4l2_get_subdevdata(sd);
> +
> +	return ov2659_write_array(client, ov2659_init_regs);
> +}
> +
> +/*
> + * V4L2 subdev video and pad level operations
> + */
> +
> +static int ov2659_enum_mbus_code(struct v4l2_subdev *sd,
> +				 struct v4l2_subdev_fh *fh,
> +				 struct v4l2_subdev_mbus_code_enum *code)
> +{
> +	struct i2c_client *client = v4l2_get_subdevdata(sd);
> +
> +	dev_dbg(&client->dev, "%s:\n", __func__);
> +
> +	if (code->index >= ARRAY_SIZE(ov2659_formats))
> +		return -EINVAL;
> +
> +	code->code = ov2659_formats[code->index].code;
> +
> +	return 0;
> +}
> +
> +static int ov2659_enum_frame_sizes(struct v4l2_subdev *sd,
> +				   struct v4l2_subdev_fh *fh,
> +				   struct v4l2_subdev_frame_size_enum *fse)
> +{
> +	struct i2c_client *client = v4l2_get_subdevdata(sd);
> +	int i = ARRAY_SIZE(ov2659_formats);
> +
> +	dev_dbg(&client->dev, "%s:\n", __func__);
> +
> +	if (fse->index >= ARRAY_SIZE(ov2659_framesizes))
> +		return -EINVAL;
> +
> +	while (--i)
> +		if (fse->code == ov2659_formats[i].code)
> +			break;
> +
> +	fse->code = ov2659_formats[i].code;
> +
> +	fse->min_width  = ov2659_framesizes[fse->index].width;
> +	fse->max_width  = fse->min_width;
> +	fse->max_height = ov2659_framesizes[fse->index].height;
> +	fse->min_height = fse->max_height;
> +
> +	return 0;
> +}
> +
> +static int ov2659_get_fmt(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh,
> +			  struct v4l2_subdev_format *fmt)
> +{
> +	struct i2c_client *client = v4l2_get_subdevdata(sd);
> +	struct ov2659 *ov2659 = to_ov2659(sd);
> +	struct v4l2_mbus_framefmt *mf;
> +
> +	dev_dbg(&client->dev, "ov2659_get_fmt\n");
> +
> +	if (fmt->which == V4L2_SUBDEV_FORMAT_TRY) {
> +		mf = v4l2_subdev_get_try_format(fh, 0);
> +		fmt->format = *mf;
> +		return 0;
> +	}
> +
> +	mutex_lock(&ov2659->lock);
> +	fmt->format = ov2659->format;
> +	mutex_unlock(&ov2659->lock);
> +
> +	dev_dbg(&client->dev, "ov2659_get_fmt: %x %dx%d\n",
> +		ov2659->format.code, ov2659->format.width,
> +		ov2659->format.height);
> +
> +	return 0;
> +}
> +
> +static void __ov2659_try_frame_size(struct v4l2_mbus_framefmt *mf,
> +				    const struct ov2659_framesize **size)
> +{
> +	const struct ov2659_framesize *fsize = &ov2659_framesizes[0];
> +	const struct ov2659_framesize *match = NULL;
> +	int i = ARRAY_SIZE(ov2659_framesizes);
> +	unsigned int min_err = UINT_MAX;
> +
> +	while (i--) {
> +		int err = abs(fsize->width - mf->width)
> +				+ abs(fsize->height - mf->height);
> +		if ((err < min_err) && (fsize->regs[0].addr)) {
> +			min_err = err;
> +			match = fsize;
> +		}
> +		fsize++;
> +	}
> +
> +	if (!match)
> +		match = &ov2659_framesizes[2];
> +
> +	mf->width  = match->width;
> +	mf->height = match->height;
> +
> +	if (size)
> +		*size = match;
> +}
> +
> +static int ov2659_set_fmt(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh,
> +			  struct v4l2_subdev_format *fmt)
> +{
> +	struct i2c_client *client = v4l2_get_subdevdata(sd);
> +	unsigned int index = ARRAY_SIZE(ov2659_formats);
> +	struct v4l2_mbus_framefmt *mf = &fmt->format;
> +	const struct ov2659_framesize *size = NULL;
> +	struct ov2659 *ov2659 = to_ov2659(sd);
> +
> +	dev_dbg(&client->dev, "ov2659_set_fmt\n");
> +
> +	__ov2659_try_frame_size(mf, &size);
> +
> +	while (--index >= 0)
> +		if (ov2659_formats[index].code == mf->code)
> +			break;
> +
> +	if (index < 0)
> +		return -EINVAL;
> +
> +	mf->colorspace	= V4L2_COLORSPACE_JPEG;
> +	mf->code	= ov2659_formats[index].code;
> +	mf->field	= V4L2_FIELD_NONE;
> +
> +	mutex_lock(&ov2659->lock);
> +
> +	if (fmt->which == V4L2_SUBDEV_FORMAT_TRY) {
> +		if (fh) {
> +			mf = v4l2_subdev_get_try_format(fh, fmt->pad);
> +			*mf = fmt->format;
> +		}
> +	} else {
> +		if (ov2659->streaming) {
> +			mutex_unlock(&ov2659->lock);
> +			return -EBUSY;
> +		}
> +
> +		ov2659->frame_size = size;
> +		ov2659->format = fmt->format;
> +		ov2659->format_ctrl_regs =
> +			ov2659_formats[index].format_ctrl_regs;
> +	}
> +
> +	mutex_unlock(&ov2659->lock);
> +	return 0;
> +}
> +
> +static int ov2659_set_frame_size(struct ov2659 *ov2659)
> +{
> +	struct i2c_client *client = ov2659->client;
> +
> +	dev_dbg(&client->dev, "%s\n", __func__);
> +
> +	return ov2659_write_array(ov2659->client,
> +				  ov2659->frame_size->regs);
> +}
> +
> +static int ov2659_set_format(struct ov2659 *ov2659)
> +{
> +	struct i2c_client *client = ov2659->client;
> +
> +	dev_dbg(&client->dev, "%s\n", __func__);
> +
> +	return ov2659_write_array(ov2659->client,
> +				  ov2659->format_ctrl_regs);
> +}
> +
> +static int ov2659_s_stream(struct v4l2_subdev *sd, int on)
> +{
> +	struct i2c_client *client = v4l2_get_subdevdata(sd);
> +	struct ov2659 *ov2659 = to_ov2659(sd);
> +	int ret = 0;
> +
> +	dev_dbg(&client->dev, "%s: on: %d\n", __func__, on);
> +
> +	mutex_lock(&ov2659->lock);
> +
> +	on = !!on;
> +
> +	if (ov2659->streaming == on)
> +		goto unlock;
> +
> +	if (!on) {
> +		/* Stop Streaming Sequence */
> +		ov2659_set_streaming(ov2659, 0);
> +		ov2659->streaming = on;
> +		mutex_unlock(&ov2659->lock);
> +		goto unlock;
> +	}
> +
> +	ov2659_set_pixel_clock(ov2659);
> +	ov2659_set_frame_size(ov2659);
> +	ov2659_set_format(ov2659);
> +	ov2659_set_streaming(ov2659, 1);
> +	ov2659->streaming = on;
> +
> +unlock:
> +	mutex_unlock(&ov2659->lock);
> +	return ret;
> +}
> +
> +/* -----------------------------------------------------------------------------
> + * V4L2 subdev internal operations
> + */
> +
> +static int ov2659_open(struct v4l2_subdev *subdev, struct v4l2_subdev_fh *fh)
> +{
> +	struct i2c_client *client = v4l2_get_subdevdata(subdev);
> +	struct v4l2_mbus_framefmt *format = v4l2_subdev_get_try_format(fh, 0);
> +
> +	dev_dbg(&client->dev, "%s:\n", __func__);
> +
> +	ov2659_get_default_format(format);
> +
> +	return 0;
> +}
> +
> +static const struct v4l2_subdev_core_ops ov2659_subdev_core_ops = {
> +	.reset = ov2659_reset,

Do you really need this?

> +	.init = ov2659_init,
> +	.log_status = v4l2_ctrl_subdev_log_status,
> +	.subscribe_event = v4l2_ctrl_subdev_subscribe_event,
> +	.unsubscribe_event = v4l2_event_subdev_unsubscribe,
> +};
> +
> +static const struct v4l2_subdev_video_ops ov2659_subdev_video_ops = {
> +	.s_stream = ov2659_s_stream,
> +};
> +
> +static const struct v4l2_subdev_pad_ops ov2659_subdev_pad_ops = {
> +	.enum_mbus_code = ov2659_enum_mbus_code,
> +	.enum_frame_size = ov2659_enum_frame_sizes,
> +	.get_fmt = ov2659_get_fmt,
> +	.set_fmt = ov2659_set_fmt,
> +};
> +
> +static const struct v4l2_subdev_ops ov2659_subdev_ops = {
> +	.core  = &ov2659_subdev_core_ops,
> +	.video = &ov2659_subdev_video_ops,
> +	.pad   = &ov2659_subdev_pad_ops,
> +};
> +
> +static const struct v4l2_subdev_internal_ops ov2659_subdev_internal_ops = {
> +	.open = ov2659_open,
> +};
> +
> +static int ov2659_detect(struct v4l2_subdev *sd)
> +{
> +	struct i2c_client *client = v4l2_get_subdevdata(sd);
> +	u8 pid, ver;
> +	int ret;
> +
> +	dev_dbg(&client->dev, "%s:\n", __func__);
> +
> +	ret = ov2659_init(sd, 0);
> +	if (ret < 0)
> +		return ret;
> +
> +	/* Check sensor revision */
> +	ret = ov2659_read(client, REG_SC_CHIP_ID_H, &pid);
> +	if (!ret)
> +		ret = ov2659_read(client, REG_SC_CHIP_ID_L, &ver);
> +
> +	if (!ret) {
> +		unsigned short id;
> +
> +		id = OV265X_ID(pid, ver);
> +		if (id != OV2659_ID)
> +			dev_err(&client->dev,
> +				"Sensor detection failed (%04X, %d)\n",
> +				id, ret);
> +		else
> +			dev_info(&client->dev, "Found OV%04X sensor\n", id);
> +	}
> +
> +	return ret;
> +}
> +
> +static struct ov2659_platform_data *
> +ov2659_get_pdata(struct i2c_client *client)
> +{
> +	struct ov2659_platform_data *pdata;
> +	struct device_node *endpoint;
> +	int ret;
> +
> +	dev_dbg(&client->dev, "ov2659_get_pdata invoked\n");
> +
> +	if (!IS_ENABLED(CONFIG_OF) || !client->dev.of_node)
> +		return client->dev.platform_data;
> +
> +	dev_dbg(&client->dev, "ov2659_get_pdata: DT Node found\n");

If you wish to make this easier to debug, I'd probably print a warning or an
error when things don't work, rather than printing a debug message when all
is well. :-)

> +	endpoint = of_graph_get_next_endpoint(client->dev.of_node, NULL);
> +	if (!endpoint)
> +		return NULL;
> +
> +	dev_dbg(&client->dev, "ov2659_get_pdata: endpoint found\n");
> +
> +	pdata = devm_kzalloc(&client->dev, sizeof(*pdata), GFP_KERNEL);
> +	if (!pdata)
> +		goto done;
> +
> +	ret = of_property_read_u32(endpoint, "xvclk-frequency",
> +				   &pdata->xvclk_frequency);
> +	if (ret < 0) {
> +		dev_info(&client->dev, "using default %u Hz clock frequency\n",
> +			 pdata->xvclk_frequency);

What's the default? Zero? I think I'd just return an error if this happens.

> +	}
> +
> +done:
> +	of_node_put(endpoint);
> +	return pdata;
> +}
> +
> +static int ov2659_probe(struct i2c_client *client,
> +			const struct i2c_device_id *id)
> +{
> +	const struct ov2659_platform_data *pdata = ov2659_get_pdata(client);
> +	struct v4l2_subdev *sd;
> +	struct ov2659 *ov2659;
> +	unsigned int xvclk;
> +	struct clk *clk;
> +	int ret;
> +
> +	if (!pdata) {
> +		dev_err(&client->dev, "platform data not specified\n");
> +		return -EINVAL;
> +	}
> +
> +	ov2659 = devm_kzalloc(&client->dev, sizeof(*ov2659), GFP_KERNEL);
> +	if (!ov2659)
> +		return -ENOMEM;
> +
> +	ov2659->pdata = pdata;
> +	mutex_init(&ov2659->lock);
> +	ov2659->client = client;
> +
> +	clk = devm_clk_get(&client->dev, "xvclk");
> +	if (IS_ERR(clk))
> +		return PTR_ERR(clk);

You should do mutex_destroy() if probe fails. If you don't need the mutex
quite yet, I'd perhaps initialise it later on.

> +
> +	xvclk = clk_get_rate(clk);
> +	if (xvclk != pdata->xvclk_frequency || xvclk < 6000000 ||
> +		xvclk > 27000000)
> +		return -EINVAL;
> +
> +	sd = &ov2659->sd;
> +	client->flags |= I2C_CLIENT_SCCB;
> +	v4l2_i2c_subdev_init(sd, client, &ov2659_subdev_ops);
> +	strlcpy(sd->name, DRIVER_NAME, sizeof(sd->name));

Please add the i2c bus and address to the sub-device name (%d-%4.4x).

> +
> +	sd->internal_ops = &ov2659_subdev_internal_ops;
> +	sd->flags |= V4L2_SUBDEV_FL_HAS_DEVNODE |
> +		     V4L2_SUBDEV_FL_HAS_EVENTS;
> +
> +#if defined(CONFIG_MEDIA_CONTROLLER)
> +	ov2659->pad.flags = MEDIA_PAD_FL_SOURCE;
> +	sd->entity.type = MEDIA_ENT_T_V4L2_SUBDEV_SENSOR;
> +	ret = media_entity_init(&sd->entity, 1, &ov2659->pad, 0);
> +	if (ret < 0)
> +		return ret;
> +#endif
> +
> +	ov2659_get_default_format(&ov2659->format);
> +	ov2659->frame_size = &ov2659_framesizes[2];
> +	ov2659->format_ctrl_regs = ov2659_formats[0].format_ctrl_regs;
> +
> +	ret = ov2659_detect(sd);
> +	if (ret < 0)
> +		goto error;
> +
> +	/* Calculate the PLL register value needed */
> +	ov2659_pll_calc_params(ov2659);
> +
> +	ret = v4l2_async_register_subdev(&ov2659->sd);
> +	if (ret)
> +		goto error;
> +
> +	dev_info(&client->dev, "%s sensor driver registered !!\n", sd->name);
> +
> +	return 0;
> +
> +error:
> +#if defined(CONFIG_MEDIA_CONTROLLER)
> +	media_entity_cleanup(&sd->entity);
> +#endif
> +	return ret;
> +}
> +
> +static int ov2659_remove(struct i2c_client *client)
> +{
> +	struct v4l2_subdev *sd = i2c_get_clientdata(client);
> +
> +	v4l2_device_unregister_subdev(sd);
> +#if defined(CONFIG_MEDIA_CONTROLLER)
> +	media_entity_cleanup(&sd->entity);
> +#endif
> +	return 0;
> +}
> +
> +static const struct i2c_device_id ov2659_id[] = {
> +	{ "ov2659", 0 },
> +	{ /* sentinel */ },
> +};
> +MODULE_DEVICE_TABLE(i2c, ov2659_id);
> +
> +#if IS_ENABLED(CONFIG_OF)
> +static const struct of_device_id ov2659_of_match[] = {
> +	{ .compatible = "ovti,ov2659", },

This is not documented in
Documentation/devicetree/bindings/vendor-prefixes.txt . Could you add a
patch for that, please?

> +	{ /* sentinel */ },
> +};
> +MODULE_DEVICE_TABLE(of, ov2659_of_match);
> +#endif
> +
> +static struct i2c_driver ov2659_i2c_driver = {
> +	.driver = {
> +		.name	= DRIVER_NAME,
> +		.of_match_table = of_match_ptr(ov2659_of_match),
> +	},
> +	.probe		= ov2659_probe,
> +	.remove		= ov2659_remove,
> +	.id_table	= ov2659_id,
> +};
> +
> +module_i2c_driver(ov2659_i2c_driver);
> +
> +MODULE_AUTHOR("Benoit Parrot <bparrot@ti.com>");
> +MODULE_DESCRIPTION("OV2659 CMOS Image Sensor driver");
> +MODULE_LICENSE("GPL");
> diff --git a/include/media/ov2659.h b/include/media/ov2659.h
> new file mode 100644
> index 0000000..005044e
> --- /dev/null
> +++ b/include/media/ov2659.h
> @@ -0,0 +1,33 @@
> +/*
> + * Omnivision OV2659 CMOS Image Sensor driver
> + *
> + * Copyright (C) 2015 Texas Instruments, Inc.
> + *
> + * Benoit Parrot <bparrot@ti.com>
> + * Lad, Prabhakar <prabhakar.csengg@gmail.com>
> + *
> + * This program is free software; you may redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; version 2 of the License.
> + *
> + * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
> + * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
> + * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
> + * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
> + * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
> + * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
> + * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
> + * SOFTWARE.
> + */
> +
> +#ifndef OV2659_H
> +#define OV2659_H
> +
> +/**
> + * struct ov2659_platform_data - ov2659 driver platform data
> + * @xvclk_frequency: sensor's input clock frequency in Hz
> + */
> +struct ov2659_platform_data {
> +	unsigned int xvclk_frequency;
> +};
> +#endif /* OV2659_H */

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
