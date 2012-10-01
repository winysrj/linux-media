Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:45694 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752446Ab2JAMTx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 1 Oct 2012 08:19:53 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Prashanth Subramanya <sprashanth@aptina.com>
Cc: linux-media@vger.kernel.org, mchehab@infradead.org,
	g.liakhovetski@gmx.de, s.nawrocki@samsung.com,
	kyungmin.park@samsung.com, sakari.ailus@maxwell.research.nokia.com,
	scott.jiang.linux@gmail.com, DRittersdorf@xrite.com
Subject: Re: [PATCH 2/2] drivers: media: video: Add support for Aptina ar0130 sensor
Date: Mon, 01 Oct 2012 14:20:31 +0200
Message-ID: <2611942.XAgpFGr7Re@avalon>
In-Reply-To: <1348842049-32195-1-git-send-email-sprashanth@aptina.com>
References: <1348842049-32195-1-git-send-email-sprashanth@aptina.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="utf-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Prashanth,

Thank you for the patch. I've personally considered Aptina to be the most 
open-source friendly sensor vendor for some time, and I'm very happy to see 
direct contributions to the Linux kernel :-)

How different are the AR0130 and the AR0330 ? Would it make sense to have a 
single driver for both ? I'm asking because I wrote a driver for the AR0330. 
I'll post it as an RFC (I haven't posted it before because I haven't been able 
to get it working yet).

On Friday 28 September 2012 19:50:49 Prashanth Subramanya wrote:
> This driver adds basic support for Aptina ar0130 1.2M sensor.
> 
> Changes for v2:
> 1: Include new test pattern control as pointed by Hans and Lad.
> 2: Remove soc_camera.h as suggested by Guennadi.
> 3: Change auto exposure control as pointed by Dan Rittersdorf.
> 4: Change incorrect return value as pointed by Nicolas.
> 5: Change crop and binning settings.
> 
> Signed-off-by: Prashanth Subramanya <sprashanth@aptina.com>
> ---
>  drivers/media/video/Kconfig       |    7 +
>  drivers/media/video/Makefile      |    1 +
>  drivers/media/video/ar0130.c      | 1088 ++++++++++++++++++++++++++++++++++
>  drivers/media/video/ar0130_regs.h |  107 ++++
>  include/media/ar0130.h            |   52 ++
>  include/media/v4l2-chip-ident.h   |    1 +
>  6 files changed, 1256 insertions(+)
>  create mode 100644 drivers/media/video/ar0130.c
>  create mode 100644 drivers/media/video/ar0130_regs.h
>  create mode 100644 include/media/ar0130.h
> 
> diff --git a/drivers/media/video/Kconfig b/drivers/media/video/Kconfig
> index c128fac..821c021 100644
> --- a/drivers/media/video/Kconfig
> +++ b/drivers/media/video/Kconfig
> @@ -505,6 +505,13 @@ config VIDEO_VS6624
>  	  To compile this driver as a module, choose M here: the
>  	  module will be called vs6624.
> 
> +config VIDEO_AR0130
> +	tristate "Aptina AR0130 support"
> +	depends on I2C && VIDEO_V4L2 && VIDEO_V4L2_SUBDEV_API
> +	---help---
> +	  This is a Video4Linux2 sensor-level driver for the Aptina
> +	  ar0130 1.2 Mpixel camera.
> +
>  config VIDEO_MT9M032
>  	tristate "MT9M032 camera sensor support"
>  	depends on I2C && VIDEO_V4L2 && VIDEO_V4L2_SUBDEV_API
> diff --git a/drivers/media/video/Makefile b/drivers/media/video/Makefile
> index b7da9fa..4f97e30 100644
> --- a/drivers/media/video/Makefile
> +++ b/drivers/media/video/Makefile
> @@ -71,6 +71,7 @@ obj-$(CONFIG_VIDEO_UPD64083) += upd64083.o
>  obj-$(CONFIG_VIDEO_OV7670) 	+= ov7670.o
>  obj-$(CONFIG_VIDEO_TCM825X) += tcm825x.o
>  obj-$(CONFIG_VIDEO_TVEEPROM) += tveeprom.o
> +obj-$(CONFIG_VIDEO_AR0130) += ar0130.o
>  obj-$(CONFIG_VIDEO_MT9M032) += mt9m032.o
>  obj-$(CONFIG_VIDEO_MT9P031) += mt9p031.o
>  obj-$(CONFIG_VIDEO_MT9T001) += mt9t001.o
> diff --git a/drivers/media/video/ar0130.c b/drivers/media/video/ar0130.c
> new file mode 100644
> index 0000000..1fdbafa
> --- /dev/null
> +++ b/drivers/media/video/ar0130.c
> @@ -0,0 +1,1088 @@
> +/*
> + * drivers/media/video/ar0130.c

The file will move to drivers/media/i2c in the next kernel version, so let's 
remove that line. It's not very useful anyway.

> + *
> + * Aptina AR0130 sensor driver
> + *
> + * Copyright (C) 2012 Aptina Imaging
> + *
> + * Contributor Prashanth Subramanya <sprashanth@aptina.com>
> + *
> + * Based on MT9P031 driver
> + *
> + * This program is free software; you can redistribute it and/or modify
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
> + * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307 
> USA
> + *

You can remove the last paragraph. Kernel developers don't want to patch every 
single source file in case the FSF moves to a new location.

> + */
> +
> +#include <linux/delay.h>
> +#include <linux/device.h>
> +#include <linux/i2c.h>
> +#include <linux/log2.h>
> +#include <linux/pm.h>
> +#include <linux/slab.h>
> +#include <media/v4l2-subdev.h>

You've included that file twice.

> +#include <linux/videodev2.h>
> +#include <linux/module.h>
> +
> +#include <media/ar0130.h>
> +#include <media/v4l2-chip-ident.h>
> +#include <media/v4l2-ctrls.h>
> +#include <media/v4l2-device.h>
> +#include <media/v4l2-subdev.h>
> +#include "ar0130_regs.h"
> +
> +#define	AR0130_ROW_START_MIN		0
> +#define	AR0130_ROW_START_MAX		1280
> +#define	AR0130_ROW_START_DEF		0
> +#define	AR0130_COLUMN_START_MIN		0
> +#define	AR0130_COLUMN_START_MAX		960
> +#define	AR0130_COLUMN_START_DEF		0
> +#define	AR0130_WINDOW_HEIGHT_MIN	360
> +#define	AR0130_WINDOW_HEIGHT_MAX	960
> +#define	AR0130_WINDOW_HEIGHT_DEF	960
> +#define	AR0130_WINDOW_WIDTH_MIN		640
> +#define	AR0130_WINDOW_WIDTH_MAX		1280
> +#define	AR0130_WINDOW_WIDTH_DEF		1280
> +
> +#define AR0130_VGA_WIDTH		640
> +#define AR0130_VGA_HEIGHT		480
> +#define AR0130_ENABLE			1
> +#define AR0130_DISABLE			0
> +
> +#define AR0130_CHIP_VERSION_REG		0x3000
> +#define AR0130_CHIP_ID			0x2402
> +#define AR0130_RESET_REG		0x301A
> +#define AR0130_STREAM_ON		0x10DC
> +#define AR0130_STREAM_OFF		0x10D8
> +#define AR0130_SEQ_PORT			0x3086
> +#define AR0130_SEQ_PORT_CTRL		0x3088
> +#define AR0130_TEST_REG			0x3070
> +#define	AR0130_TEST_PATTERN_DISABLE	0x0000
> +
> +#define AR0130_DCDS_PROG_START_ADDR	0x309E
> +#define AR0130_ADC_BITS_6_7		0x30E4
> +#define AR0130_ADC_BITS_4_5		0x30E2
> +#define AR0130_ADC_BITS_2_3		0x30E0
> +#define AR0130_ADC_CONFIG1		0x30E6
> +#define AR0130_ADC_CONFIG2		0x30E8
> +
> +#define AR0130_VT_SYS_CLK_DIV		0x302C
> +#define AR0130_VT_PIX_CLK_DIV		0x302A
> +#define AR0130_PRE_PLL_CLK_DIV		0x302E
> +#define AR0130_PLL_MULTIPLIER		0x3030
> +#define AR0130_DIGITAL_TEST		0x30B0
> +
> +#define AR0130_OPERATION_MODE_CTRL	0x3082
> +#define AR0130_COLUMN_CORRECTION	0x30D4
> +#define AR0130_DARK_CONTROL		0x3044
> +#define AR0130_DAC_LD_14_15		0x3EDA
> +#define AR0130_DAC_LD_12_13		0x3ED8
> +#define AR0130_COARSE_INTEGRATION_TIME	0x3012
> +
> +#define AR0130_DIGITAL_BINNING		0x3032
> +#define AR0130_HOR_AND_VER_BIN		0x0002
> +#define AR0130_HOR_BIN			0x0001
> +#define AR0130_Y_ADDR_START		0x3002
> +#define AR0130_X_ADDR_START		0x3004
> +#define AR0130_Y_ADDR_END		0x3006
> +#define AR0130_X_ADDR_END		0x3008
> +#define AR0130_FRAME_LENGTH_LINES	0x300A
> +#define AR0130_LINE_LENGTH_PCK		0x300C
> +#define AR0130_DATAPATH_SELECT		0x306E
> +#define AR0130_EMBEDDED_DATA_CTRL	0x3064
> +#define AR0130_AE_CTRL_REG		0x3100
> +#define AR0130_AE_DCG_EXP_HIGH_REG	0x3112
> +#define AR0130_AE_DCG_EXP_LOW_REG	0x3114
> +#define AR0130_AE_DCG_G_FACTOR		0x3116
> +#define AR0130_AE_DCG_G_FACTOR_INV	0x3118
> +#define AR0130_AE_LUMA_TARGET_REG	0x3102
> +#define AR0130_AE_HIST_TARGET_REG	0x3104
> +#define AR0130_AE_ALPHA_V1_REG		0x3126
> +#define AR0130_AE_MAX_EXPOSURE_REG	0x311C
> +#define AR0130_AE_MIN_EXPOSURE_REG	0x311E
> +#define AR0130_HDR_COMP			0x31D0
> +
> +#define	AR0130_READ_MODE		0x3040
> +#define AR0130_HFLIP_ENABLE		0x4000
> +#define AR0130_HFLIP_DISABLE		0xBFFF
> +#define AR0130_VFLIP_ENABLE		0x8000
> +#define AR0130_VFLIP_DISABLE		0x7FFF
> +
> +#define AR0130_GLOBAL_GAIN_MIN		0x00
> +#define AR0130_GLOBAL_GAIN_MAX		0x11
> +#define AR0130_GLOBAL_GAIN_DEF		0x01
> +
> +struct ar0130_pll_divs {
> +	u32 ext_freq;
> +	u32 target_freq;
> +	u8 m;
> +	u8 n;
> +	u8 p1;
> +	u8 p2;
> +};

The sensor seems to have a PLL similar to the SMIA++ PLL. Could you use 
smiapp-pll.c to compute the PLL parameters instead of hardcoding them ?

> +struct ar0130_frame_size {
> +	u16 width;
> +	u16 height;
> +};
> +
> +static const struct ar0130_frame_size ar0130_supported_framesizes[] = {
> +	{  640,  360 },
> +	{  640,  480 },
> +	{ 1280,  720 },
> +	{ 1280,  960 }
> +};

I don't think you should limit the number of supported sizes. The user should 
be able to configure cropping and binning directly through the selection 
rectangles, without limitations other than the hardware limits.

> +enum ar0130_resolution {
> +	AR0130_640x360_BINNED,
> +	AR0130_640x480_BINNED,
> +	AR0130_720P_60FPS,
> +	AR0130_FULL_RES_45FPS
> +};
> +
> +struct ar0130_priv {
> +	struct v4l2_subdev subdev;
> +	struct media_pad pad;
> +	struct v4l2_rect crop;  /* Sensor window */
> +	struct v4l2_mbus_framefmt format;
> +	enum ar0130_resolution res_index;
> +	struct v4l2_ctrl_handler ctrls;
> +	struct ar0130_platform_data *pdata;
> +	struct mutex power_lock; /* lock to protect power_count */
> +	const struct ar0130_pll_divs *pll;
> +	int power_count;
> +};
> +
> +struct ar0130_reg {
> +	u16 addr;
> +	u16 data;
> +};
> +
> +/************************************************************************
> +			Helper Functions
> +************************************************************************/
> +/**
> + * to_ar0130 - A helper function which returns pointer to the
> + * private data structure
> + * @client: pointer to i2c client
> + *
> + */
> +static struct ar0130_priv *to_ar0130(const struct i2c_client *client)
> +{
> +	return container_of(i2c_get_clientdata(client),
> +			struct ar0130_priv, subdev);
> +}
> +
> +/**
> + * ar0130_read - reads the data from the given register
> + * @client: pointer to i2c client
> + * @command: address of the register which is to be read
> + *
> + */
> +static int ar0130_read(struct i2c_client *client, u16 command)

It's not really a command but more of a register address, isn't it ? I would 
then call the second parameter addr or reg (same for ar0130_write).

> +{
> +	struct i2c_msg msg[2];
> +	u8 buf[2];
> +	u16 ret;
> +
> +	/* 16 bit addressable register */
> +	command = swab16(command);

Please use cpu_to_be16() instead, as this code can run on a big-endian CPU in 
which case swapping isn't needed.

> +
> +	msg[0].addr  = client->addr;
> +	msg[0].flags = 0;
> +	msg[0].len   = 2;
> +	msg[0].buf   = (u8 *)&command;
> +
> +	msg[1].addr  = client->addr;
> +	msg[1].flags = I2C_M_RD; /* 1 */
> +	msg[1].len   = 2;
> +	msg[1].buf   = buf;
> +
> +	/*
> +	* if return value of this function is < 0,
> +	* it means error.
> +	* else, under 16bit is valid data.
> +	*/
> +	ret = i2c_transfer(client->adapter, msg, 2);
> +
> +	if (ret < 0) {
> +		v4l_err(client, "Read from offset 0x%x error %d",
> +					swab16(command), ret);

Maybe you could declare a local variable to stored the swapped command, that 
would avoid calling swab16() here again.

> +		return ret;
> +	}
> +
> +	memcpy(&ret, buf, 2);
> +	return swab16(ret);

Let's make this explicit:

	return (buf[0] << 8) | buf[1];

> +}
> +
> +/**
> + * ar0130_write - writes the data into the given register
> + * @client: pointer to i2c client
> + * @command: address of the register in which to write
> + * @data: data to be written into the register
> + *
> + */
> +static int ar0130_write(struct i2c_client *client, u16 command,
> +				u16 data)
> +{
> +	struct i2c_msg msg;
> +	u8 buf[4];
> +	int ret;
> +
> +	/* 16-bit addressable register */
> +
> +	command = swab16(command);
> +	data = swab16(data);
> +
> +	memcpy(buf + 0, &command, 2);
> +	memcpy(buf + 2, &data, 2);

You can make this explicit too:

	buf[0] = command >> 8;
	buf[1] = command & 0xff;
	buf[2] = addr >> 8;
	buf[3] = addr & 0xff;

I haven't checked, but I expect the resulting code to be smaller.

> +	msg.addr  = client->addr;
> +	msg.flags = 0;
> +	msg.len   = 4;
> +	msg.buf   = buf;
> +
> +	/* i2c_transfer returns message length, but function should return 0 */
> +	ret = i2c_transfer(client->adapter, &msg, 1);
> +	if (ret >= 0)
> +		return 0;
> +
> +	v4l_err(client, "Write failed at 0x%X error %d\n",

The kernel usually uses lower-case hex constants (%x).

> +				swab16(command), ret);
> +	return ret;
> +}
> +
> +/**
> + * ar0130_calc_size - Find the best match for a requested image capture
> size
> + * @request_width: requested image width in pixels
> + * @request_height: requested image height in pixels
> + *
> + * Find the best match for a requested image capture size.  The best match
> + * is chosen as the nearest match that has the same number or fewer pixels
> + * as the requested size, or the smallest image size if the requested size
> + * has fewer pixels than the smallest image.
> + */
> +static int ar0130_calc_size(unsigned int request_width,
> +				unsigned int request_height)
> +{
> +	int i = 0;
> +	unsigned long requested_pixels = request_width * request_height;
> +
> +	for (i = 0; i < ARRAY_SIZE(ar0130_supported_framesizes); i++) {
> +		if (ar0130_supported_framesizes[i].height *
> +		ar0130_supported_framesizes[i].width >= requested_pixels)
> +			return i;
> +	}
> +
> +	/* couldn't find a match, return the max size as a default */
> +	return ARRAY_SIZE(ar0130_supported_framesizes) - 1;
> +}

This function will go away if you implement proper support for cropping and 
binning, as mentioned above.

> +/**
> + * ar0130_v4l2_try_fmt_cap - Find the best match for a requested image size
> + * @requestedsize: pointer to the structure which contains requested image
> size
> + *
> + * Find the best match for a requested image capture size.  The best match
> + * is chosen as the nearest match that has the same number or fewer pixels
> + * as the requested size, or the smallest image size if the requested size
> + * has fewer pixels than the smallest image.
> + */
> +static int ar0130_v4l2_try_fmt_cap(struct ar0130_frame_size *requestedsize)
> +{
> +	int isize;
> +
> +	isize = ar0130_calc_size(requestedsize->width, requestedsize->height);
> +
> +	requestedsize->width = ar0130_supported_framesizes[isize].width;
> +	requestedsize->height = ar0130_supported_framesizes[isize].height;
> +
> +	return isize;
> +}
> +
> +/**
> + * ar0130_reset - Soft resets the sensor
> + * @client: pointer to the i2c client
> + *
> + */
> +static int ar0130_reset(struct i2c_client *client)
> +{
> +	int ret;
> +
> +	ret = ar0130_write(client, AR0130_RESET_REG, 0x0001);

Please define register bits and fields instead of hardcoding the values. 
Please have a look at the AR0330 code I'll post for an example.

> +	if (ret < 0)
> +		return ret;
> +
> +	mdelay(10);

What about usleep_range() instead, here and in all the other locations ? None 
of your code runs in non-sleepable context, so sleeping is better than mdelay.

> +
> +	ret = ar0130_write(client, AR0130_RESET_REG, AR0130_STREAM_OFF);
> +	if (ret < 0)
> +		return ret;
> +
> +	return 0;
> +}
> +
> +/**
> + * PLL Dividers
> + *
> + * Calculated according to the following formula:
> + *
> + *    target_freq = (ext_freq x M) / (N x P1 x P2)
> + *    VCO_freq    = (ext_freq x M) / N
> + *
> + * And subject to the following limitations:
> + *
> + *    Limitations of PLL parameters
> + *    -----------------------------
> + *    32     ≤ M        ≤ 384
> + *    1      ≤ N        ≤ 64
> + *    1      ≤ P1       ≤ 16
> + *    4      ≤ P2       ≤ 16
> + *    384MHz ≤ VCO_freq ≤ 768MHz
> + *
> + * TODO: Use Aptina PLL Helper module to calculate dividers

Very good idea :-D

> + */
> +
> +static const struct ar0130_pll_divs ar0130_divs[] = {
> +	/* ext_freq	target_freq	M	N	p1	p2 */
> +	{24000000,	48000000,	32,	2,	2,	4},
> +	{24000000,	66000000,	44,	2,	2,	4},
> +	{48000000,	48000000,	40,	5,	2,	4}
> +};
> +
> +static int ar0130_pll_get_divs(struct ar0130_priv *ar0130)
> +{
> +	struct i2c_client *client = v4l2_get_subdevdata(&ar0130->subdev);
> +	int i;
> +
> +	for (i = 0; i < ARRAY_SIZE(ar0130_divs); i++) {
> +		if (ar0130_divs[i].ext_freq == ar0130->pdata->ext_freq &&
> +		ar0130_divs[i].target_freq == ar0130->pdata->target_freq) {
> +			ar0130->pll = &ar0130_divs[i];
> +			return 0;
> +		}
> +	}
> +	dev_err(&client->dev, "Couldn't find PLL dividers for ext_freq = %d,
> target_freq = %d\n", +			ar0130->pdata->ext_freq,
> ar0130->pdata->target_freq);
> +
> +	return -EINVAL;
> +}
> +
> +/**
> + * ar0130_pll_enable - enable the sensor pll
> + * @client: pointer to the i2c client
> + *
> + */
> +static int ar0130_pll_enable(struct ar0130_priv *ar0130)
> +{
> +	struct i2c_client *client = v4l2_get_subdevdata(&ar0130->subdev);
> +	int ret;
> +
> +	ret = ar0130_pll_get_divs(ar0130);
> +	if (ret < 0)
> +		return ret;
> +
> +	ret  = ar0130_write(client, AR0130_VT_SYS_CLK_DIV, ar0130->pll->p1);
> +	ret |= ar0130_write(client, AR0130_VT_PIX_CLK_DIV, ar0130->pll->p2);
> +	ret |= ar0130_write(client, AR0130_PRE_PLL_CLK_DIV, ar0130->pll->n);
> +	ret |= ar0130_write(client, AR0130_PLL_MULTIPLIER, ar0130->pll->m);
> +
> +	mdelay(100);
> +
> +	return ret;

This would create a weird error code, you could check ret after each 
ar0130_write() call instead (same for the rest of the code below).

> +}
> +
> +/**
> + * ar0130_power_on - power on the sensor
> + * @ar0130: pointer to private data structure
> + *
> + */
> +static int ar0130_power_on(struct ar0130_priv *ar0130)
> +{
> +	struct i2c_client *client = v4l2_get_subdevdata(&ar0130->subdev);
> +	int ret;
> +
> +	/* Ensure RESET_BAR is low */
> +	if (ar0130->pdata->reset) {
> +		ar0130->pdata->reset(&ar0130->subdev, 1);
> +		usleep_range(1000, 2000);
> +	}
> +
> +	/* Enable clock */
> +	if (ar0130->pdata->set_xclk) {
> +		ar0130->pdata->set_xclk(&ar0130->subdev,
> +		ar0130->pdata->ext_freq);
> +		usleep_range(1000, 2000);
> +	}
> +
> +	/* Now RESET_BAR must be high */
> +	if (ar0130->pdata->reset) {
> +		ar0130->pdata->reset(&ar0130->subdev, 0);
> +		usleep_range(1000, 2000);
> +	}
> +
> +	ret = ar0130_reset(client);
> +
> +	if (ret < 0) {
> +		dev_err(&client->dev, "Failed to reset the camera\n");
> +		return ret;
> +	}
> +
> +	return v4l2_ctrl_handler_setup(&ar0130->ctrls);

You're calling this function in ar0130_registered(), where you're not sure yet 
if the sensor is really present or functional. I would thus move the 
ar0130_reset() and v4l2_ctrl_handler_setup() calls to ar0130_s_power().

> +}
> +
> +/**
> + * ar0130_power_off - power off the sensor
> + * @ar0130: pointer to private data structure
> + *
> + */
> +void ar0130_power_off(struct ar0130_priv *ar0130)
> +{
> +	if (ar0130->pdata->set_xclk)
> +		ar0130->pdata->set_xclk(&ar0130->subdev, 0);
> +}
> +
> +static struct v4l2_mbus_framefmt *
> +__ar0130_get_pad_format(struct ar0130_priv *ar0130, struct v4l2_subdev_fh
> *fh, +			unsigned int pad, u32 which)
> +{
> +	switch (which) {
> +	case V4L2_SUBDEV_FORMAT_TRY:
> +		return v4l2_subdev_get_try_format(fh, pad);
> +	case V4L2_SUBDEV_FORMAT_ACTIVE:
> +		return &ar0130->format;
> +	default:
> +		return NULL;
> +	}
> +}
> +
> +static int ar0130_linear_mode_setup(struct i2c_client *client)

What's linear mode ?

> +{
> +	int i, ret;

i is unsigned, so let's use unsigned int i;
> +
> +	ret = ar0130_write(client, AR0130_SEQ_PORT_CTRL, 0x8000);
> +	for (i = 0; i < 80; i++)

ARRAY_SIZE(ar0130_linear_data) instead of 80 ?

> +		ret |= ar0130_write(client, AR0130_SEQ_PORT,
> +					ar0130_linear_data[i]);
> +
> +	ret |= ar0130_write(client, AR0130_DCDS_PROG_START_ADDR, 0x0000);
> +	ret |= ar0130_write(client, AR0130_ADC_BITS_6_7, 0x6372);
> +	ret |= ar0130_write(client, AR0130_ADC_BITS_4_5, 0x7253);
> +	ret |= ar0130_write(client, AR0130_ADC_BITS_2_3, 0x5470);
> +	ret |= ar0130_write(client, AR0130_ADC_CONFIG1, 0xC4CC);
> +	ret |= ar0130_write(client, AR0130_ADC_CONFIG2, 0x8050);
> +
> +	mdelay(200);
> +
> +	ret |= ar0130_write(client, AR0130_OPERATION_MODE_CTRL, 0x0029);
> +	ret |= ar0130_write(client, AR0130_DIGITAL_TEST, 0x1300);
> +	ret |= ar0130_write(client, AR0130_COLUMN_CORRECTION, 0xE007);
> +	ret |= ar0130_write(client, AR0130_RESET_REG, 0x10DC);
> +	ret |= ar0130_write(client, AR0130_RESET_REG, 0x10D8);
> +	ret |= ar0130_write(client, AR0130_DARK_CONTROL, 0x0400);
> +	ret |= ar0130_write(client, AR0130_DAC_LD_14_15, 0x0F03);
> +	ret |= ar0130_write(client, AR0130_DAC_LD_12_13, 0x01EF);
> +	ret |= ar0130_write(client, AR0130_COARSE_INTEGRATION_TIME, 0x02A0);

Any chance to define the bits and fields instead of hardcoding the values ?

> +
> +	return ret;
> +}
> +
> +static int ar0130_set_resolution(struct i2c_client *client)
> +{
> +	struct ar0130_priv *ar0130 = to_ar0130(client);
> +	int ret = 0;
> +	unsigned int hratio, vratio;
> +
> +	hratio = DIV_ROUND_CLOSEST(ar0130->crop.width, ar0130->format.width);
> +	vratio = DIV_ROUND_CLOSEST(ar0130->crop.height, ar0130->format.height);
> +	if (hratio == 2) {
> +		if (vratio == 2)
> +			ret = ar0130_write(client, AR0130_DIGITAL_BINNING,
> +					AR0130_HOR_AND_VER_BIN);
> +		else if (vratio < 2)

Can vratio be > 2 here ? If not, a simple "if" will do.

> +			ret = ar0130_write(client, AR0130_DIGITAL_BINNING,
> +					AR0130_HOR_BIN);
> +	}

What if hratio == 1 and vratio == 2 ? Can the sensor bin vertically without 
binning horizontally ?

If hratio == 1 and vratio == 1 you don't write the AR0130_DIGITAL_BINNING 
register at all, and thus keep the old value that might be different. I would 
thus compute the register value based on hratio and vratio, and then call 
ar0130_write(client AR0130_DIGITAL_BINNING, value) unconditionally.

> +	ret |= ar0130_write(client, AR0130_X_ADDR_START, ar0130->crop.top);
> +	ret |= ar0130_write(client, AR0130_X_ADDR_END,
> +				ar0130->crop.top + ar0130->crop.width - 1);

top goes with height, and left with width.

> +	ret |= ar0130_write(client, AR0130_Y_ADDR_START, ar0130->crop.left);
> +	ret |= ar0130_write(client, AR0130_Y_ADDR_END,
> +				ar0130->crop.left + ar0130->crop.height - 1);
> +	ret |= ar0130_write(client, AR0130_LINE_LENGTH_PCK, 1650);

Shouldn't this depend on crop.width ?

> +	ret |= ar0130_write(client, AR0130_FRAME_LENGTH_LINES,
> +		ar0130->crop.height + 29);

At some point it would be useful to implement configurable blanking, but we 
can skip that for now.

> +
> +	return ret;
> +}
> +
> +static int ar0130_set_autoexposure(struct i2c_client *client,
> +					enum v4l2_exposure_auto_type ae_mode)
> +{
> +	int ret = 0;
> +
> +	switch (ae_mode) {
> +	case V4L2_EXPOSURE_AUTO:
> +		ret  = ar0130_write(client, AR0130_EMBEDDED_DATA_CTRL, 0x1982);
> +		ret |= ar0130_write(client, AR0130_AE_CTRL_REG, 0x001B);
> +		ret |= ar0130_write(client, AR0130_AE_DCG_EXP_HIGH_REG, 0x029F);
> +		ret |= ar0130_write(client, AR0130_AE_DCG_EXP_LOW_REG, 0x008C);
> +		ret |= ar0130_write(client, AR0130_AE_DCG_G_FACTOR, 0x02C0);
> +		ret |= ar0130_write(client, AR0130_AE_DCG_G_FACTOR_INV, 0x005B);
> +		ret |= ar0130_write(client, AR0130_AE_LUMA_TARGET_REG, 0x0384);
> +		ret |= ar0130_write(client, AR0130_AE_HIST_TARGET_REG, 0x1000);
> +		ret |= ar0130_write(client, AR0130_AE_ALPHA_V1_REG, 0x0080);
> +		ret |= ar0130_write(client, AR0130_AE_MAX_EXPOSURE_REG, 0x03DD);
> +		ret |= ar0130_write(client, AR0130_AE_MIN_EXPOSURE_REG, 0x0002);

No hardcoded constants please.

> +		return ret;
> +
> +	case V4L2_EXPOSURE_MANUAL:
> +		ret = ar0130_write(client, AR0130_RESET_REG, AR0130_STREAM_OFF);

Do you really have to stop the stream to turn auto-exposure off ? What will 
happen if the stream is running ? Will the sensor stop in the middle of a 
frame, or will it be completely transparent to the receiver ?

> +		ret |= ar0130_write(client, AR0130_AE_CTRL_REG, 0x001A);
> +		ret |= ar0130_write(client, AR0130_RESET_REG, AR0130_STREAM_ON);
> +		return ret;
> +
> +	case V4L2_EXPOSURE_SHUTTER_PRIORITY:
> +	case V4L2_EXPOSURE_APERTURE_PRIORITY:

Can the sensor really control the aperture ? If not the two modes you should 
support are V4L2_EXPOSURE_MANUAL and V4L2_EXPOSURE_APERTURE_PRIORITY.

> +		dev_err(&client->dev, "Unsupported auto-exposure mode requested: 
%d\n",
> +			ae_mode);
> +		ret = -EINVAL;
> +		break;
> +
> +	default:
> +		dev_err(&client->dev, "Auto Exposure mode out of range: %d\n",
> +			ae_mode);
> +		ret = -ERANGE;
> +		break;

The control framework will make sure you only get legal values, so you can 
remove those 3 cases.

> +	}
> +	return ret;
> +}
> +
> +/************************************************************************
> +			v4l2_subdev_core_ops
> +************************************************************************/
> +
> +static int ar0130_g_chip_ident(struct v4l2_subdev *sd,
> +				struct v4l2_dbg_chip_ident *id)
> +{
> +	id->ident    = V4L2_IDENT_AR0130;
> +	id->revision = 1;
> +
> +	return 0;
> +}

This isn't needed when implementing the subdev userspace API.

> +static int ar0130_s_ctrl(struct v4l2_ctrl *ctrl)
> +{
> +	struct ar0130_priv *ar0130 = container_of(ctrl->handler,
> +					struct ar0130_priv, ctrls);
> +	struct i2c_client *client = v4l2_get_subdevdata(&ar0130->subdev);
> +	int ret = 0;
> +	u16 reg16;
> +
> +	switch (ctrl->id) {
> +	case V4L2_CID_EXPOSURE_AUTO:
> +		return ar0130_set_autoexposure(client,
> +				(enum v4l2_exposure_auto_type)ctrl->val);
> +
> +	case V4L2_CID_GAIN:
> +		reg16  = ar0130_read(client, AR0130_DIGITAL_TEST);
> +		reg16 |= (ctrl->val << 5);

Shouldn't you mask the previous value ? Would it make sense to cache the value 
of the DIGITAL_TEST register to avoid having to read it back ?

> +		return ar0130_write(client, AR0130_DIGITAL_TEST, reg16);
> +
> +	case V4L2_CID_HFLIP:
> +		if (ctrl->val) {
> +			reg16 = ar0130_read(client, AR0130_READ_MODE);
> +			reg16 |= AR0130_HFLIP_ENABLE;
> +			return ar0130_write(client, AR0130_READ_MODE, reg16);
> +		}
> +		reg16 = ar0130_read(client, AR0130_READ_MODE);
> +		reg16 &= AR0130_HFLIP_DISABLE;
> +		return ar0130_write(client, AR0130_READ_MODE, reg16);
> +
> +	case V4L2_CID_VFLIP:
> +		if (ctrl->val) {
> +			reg16 = ar0130_read(client, AR0130_READ_MODE);
> +			reg16 |= AR0130_VFLIP_ENABLE;
> +			return ar0130_write(client, AR0130_READ_MODE, reg16);
> +		}
> +		reg16 = ar0130_read(client, AR0130_READ_MODE);
> +		reg16 &= AR0130_VFLIP_DISABLE;
> +		return ar0130_write(client, AR0130_READ_MODE, reg16);

Please put the two controls in a cluster. Look at the mt9m032 driver for an 
example. You should also cache the value of the READ_MODE register to avoid 
reading it back (the mt9m032 driver does so as well).

> +	case V4L2_CID_TEST_PATTERN:
> +		if (!ctrl->val)
> +			return ar0130_write(client, AR0130_TEST_REG,
> +						AR0130_TEST_PATTERN_DISABLE);
> +		else if (ctrl->val < 4)
> +			return ar0130_write(client, AR0130_TEST_REG, ctrl->val);
> +
> +		return ar0130_write(client, AR0130_TEST_REG, 256);

As AR0130_TEST_PATTERN_DISABLE == 0, I would simply do

		return ar0130_write(client, AR0130_TEST_REG, ctrl->val < 4 ? ctrl->val 
: 256);

(and replace 256 with a proper #define)

> +	default:
> +		dev_err(&client->dev, "Control %d not supported\n", ctrl->id);
> +		ret = -ERANGE;

The control framework will make sure you don't get called with an unsupported 
control, you can remove the default case.

> +		break;
> +	}
> +
> +	return ret;
> +}
> +
> +static struct v4l2_ctrl_ops ar0130_ctrl_ops = {
> +	.s_ctrl = ar0130_s_ctrl,
> +};
> +
> +/*
> +@AR0130_TEST_PATTERN
> +0 = Disabled. Normal operation. Generate output data from pixel array
> +1 = Solid color test pattern.
> +2 = Full color bar test pattern
> +3 = Fade to grey color bar test pattern
> +256 = Marching 1s test pattern (12 bit)
> +*/
> +static const char * const ar0130_test_pattern[] = {
> +	"Disabled",
> +	"Solid color",
> +	"Full color bar",
> +	"Fade to grey color bar",
> +	"Marching 1s",
> +	NULL
> +};
> +
> +#ifdef CONFIG_VIDEO_ADV_DEBUG
> +static int ar0130_g_reg(struct v4l2_subdev *sd,
> +				struct v4l2_dbg_register *reg)
> +{
> +	struct i2c_client *client = v4l2_get_subdevdata(sd);
> +	u16 data;
> +
> +	reg->size = 2;
> +	data = ar0130_read(client, reg->reg);

If ar0130_read() fails you should return an error.

> +	reg->val = (__u64)data;

I don't think an explicit cast is needed.

> +	return 0;
> +}
> +
> +static int ar0130_s_reg(struct v4l2_subdev *sd,
> +				struct v4l2_dbg_register *reg)
> +{
> +	struct i2c_client *client = v4l2_get_subdevdata(sd);
> +
> +	return ar0130_write(client, reg->reg, reg->val);
> +}
> +#endif
> +
> +static int ar0130_s_power(struct v4l2_subdev *sd, int on)
> +{
> +	struct ar0130_priv *ar0130 = container_of(sd,
> +				struct ar0130_priv, subdev);
> +	int ret = 0;
> +
> +	mutex_lock(&ar0130->power_lock);
> +
> +	/*
> +	* If the power count is modified from 0 to != 0 or from != 0 to 0,
> +	* update the power state.
> +	*/
> +	if (ar0130->power_count == !on) {
> +		if (on) {
> +			ret = ar0130_power_on(ar0130);
> +			if (ret) {
> +				dev_err(ar0130->subdev.v4l2_dev->dev,
> +				"Failed to power on: %d\n", ret);
> +				goto out;
> +			}
> +		} else
> +			ar0130_power_off(ar0130);
> +	}
> +	/* Update the power count. */
> +	ar0130->power_count += on ? 1 : -1;
> +	WARN_ON(ar0130->power_count < 0);
> +out:
> +	mutex_unlock(&ar0130->power_lock);
> +	return ret;
> +}
> +
> +/***************************************************
> +		v4l2_subdev_video_ops
> +****************************************************/
> +static int ar0130_s_stream(struct v4l2_subdev *sd, int enable)
> +{
> +	struct i2c_client *client = v4l2_get_subdevdata(sd);
> +	struct ar0130_priv *ar0130 = container_of(sd,
> +					struct ar0130_priv, subdev);
> +	int ret;
> +
> +	if (!enable) {
> +		ret = ar0130_write(client, AR0130_RESET_REG, AR0130_STREAM_OFF);

No need to assign ret if you don't use it.

> +		return 0;
> +	}
> +
> +	ret = ar0130_linear_mode_setup(client);
> +	if (ret < 0) {
> +		dev_err(ar0130->subdev.v4l2_dev->dev,
> +			"Failed to setup linear mode: %d\n", ret);
> +		return ret;
> +	}
> +
> +	ret = ar0130_set_resolution(client);
> +	if (ret < 0) {
> +		dev_err(ar0130->subdev.v4l2_dev->dev,
> +			"Failed to setup resolution: %d\n", ret);
> +		return ret;
> +	}
> +
> +	ret  = ar0130_write(client, AR0130_RESET_REG, AR0130_STREAM_OFF);
> +	ret |= ar0130_write(client, AR0130_HDR_COMP, 0x0001);
> +
> +	ret |= ar0130_pll_enable(ar0130);
> +	if (ret < 0) {
> +		dev_err(ar0130->subdev.v4l2_dev->dev,
> +			"Failed to enable pll: %d\n", ret);
> +		return ret;
> +	}
> +
> +	ret |= ar0130_write(client, AR0130_RESET_REG, AR0130_STREAM_ON);
> +
> +	return ret;
> +}
> +
> +/***************************************************
> +		v4l2_subdev_pad_ops
> +****************************************************/
> +static int ar0130_enum_mbus_code(struct v4l2_subdev *sd,
> +				struct v4l2_subdev_fh *fh,
> +				struct v4l2_subdev_mbus_code_enum *code)
> +{
> +	struct ar0130_priv *ar0130 = container_of(sd,
> +					struct ar0130_priv, subdev);
> +
> +	if (code->pad || code->index)
> +		return -EINVAL;
> +
> +	code->code = ar0130->format.code;
> +	return 0;
> +}
> +
> +static int ar0130_enum_frame_size(struct v4l2_subdev *sd,
> +				struct v4l2_subdev_fh *fh,
> +				struct v4l2_subdev_frame_size_enum *fse)
> +{
> +	struct ar0130_priv *ar0130 = container_of(sd,
> +					struct ar0130_priv, subdev);
> +
> +	if (fse->index >= 8 || fse->code != ar0130->format.code)
> +		return -EINVAL;
> +
> +	fse->min_width = AR0130_WINDOW_WIDTH_DEF
> +				/ min_t(unsigned int, 7, fse->index + 1);
> +	fse->max_width = fse->min_width;
> +	fse->min_height = AR0130_WINDOW_HEIGHT_DEF / (fse->index + 1);
> +	fse->max_height = fse->min_height;

This doesn't seem to match the AR0130 behaviour. The frame size ranges you 
return here should correspond to the different binning combinations.

> +	return 0;
> +}
> +
> +static int ar0130_get_format(struct v4l2_subdev *sd,
> +				struct v4l2_subdev_fh *fh,
> +				struct v4l2_subdev_format *fmt)
> +{
> +	struct ar0130_priv *ar0130 = container_of(sd,
> +					struct ar0130_priv, subdev);
> +
> +	fmt->format = *__ar0130_get_pad_format(ar0130, fh, fmt->pad,
> +						fmt->which);
> +
> +	return 0;
> +}
> +
> +static int ar0130_set_format(struct v4l2_subdev *sd,
> +				struct v4l2_subdev_fh *fh,
> +				struct v4l2_subdev_format *format)
> +{
> +	struct ar0130_priv *ar0130 = container_of(sd,
> +					struct ar0130_priv, subdev);
> +	struct ar0130_frame_size size;
> +
> +	size.height = format->format.height;
> +	size.width = format->format.width;
> +	ar0130->res_index		= ar0130_v4l2_try_fmt_cap(&size);
> +	ar0130->format.width		= size.width;
> +	ar0130->format.height		= size.height;
> +	ar0130->format.code		= V4L2_MBUS_FMT_SGRBG12_1X12;
> +
> +	format->format.width		= size.width;
> +	format->format.height		= size.height;
> +
> +	return 0;
> +}
> +
> +static struct v4l2_rect *
> +__ar0130_get_pad_crop(struct ar0130_priv *ar0130, struct v4l2_subdev_fh
> *fh, +	unsigned int pad, u32 which)
> +{
> +	switch (which) {
> +	case V4L2_SUBDEV_FORMAT_TRY:
> +		return v4l2_subdev_get_try_crop(fh, pad);
> +	case V4L2_SUBDEV_FORMAT_ACTIVE:
> +		return &ar0130->crop;
> +	default:
> +		return NULL;
> +	}
> +}
> +
> +static int ar0130_get_crop(struct v4l2_subdev *sd,
> +			struct v4l2_subdev_fh *fh,
> +			struct v4l2_subdev_crop *crop)
> +{
> +	struct ar0130_priv *ar0130 = container_of(sd,
> +					struct ar0130_priv, subdev);
> +
> +	crop->rect = *__ar0130_get_pad_crop(ar0130, fh, crop->pad, crop->which);
> +
> +	return 0;
> +}
> +
> +static int ar0130_set_crop(struct v4l2_subdev *sd,
> +			struct v4l2_subdev_fh *fh,
> +			struct v4l2_subdev_crop *crop)
> +{
> +	struct ar0130_priv *ar0130 = container_of(sd,
> +					struct ar0130_priv, subdev);
> +	struct ar0130_frame_size size;
> +
> +	size.width = crop->rect.width;
> +	size.height = crop->rect.height;
> +	ar0130_v4l2_try_fmt_cap(&size);
> +
> +	if (crop->rect.left < AR0130_COLUMN_START_MIN)
> +		crop->rect.left = AR0130_COLUMN_START_MIN;
> +	else if (crop->rect.left > AR0130_COLUMN_START_MAX)
> +		crop->rect.left = AR0130_COLUMN_START_MAX;
> +	if (crop->rect.top < AR0130_ROW_START_MIN)
> +		crop->rect.top = AR0130_ROW_START_MIN;
> +	else if (crop->rect.top > AR0130_ROW_START_MAX)
> +		crop->rect.top = AR0130_ROW_START_MAX;
> +
> +	ar0130->crop.left	= crop->rect.left;
> +	ar0130->crop.top	= crop->rect.top;
> +	ar0130->crop.width	= size.width;
> +	ar0130->crop.height	= size.height;
> +
> +	crop->rect.width	= size.width;
> +	crop->rect.height	= size.height;
> +
> +	return 0;
> +}
> +
> +/***********************************************************
> +	V4L2 subdev internal operations
> +************************************************************/
> +static int ar0130_registered(struct v4l2_subdev *sd)
> +{
> +	struct i2c_client *client = v4l2_get_subdevdata(sd);
> +	struct ar0130_priv *ar0130 = to_ar0130(client);
> +	s32 data;
> +	int ret;
> +
> +	ret = ar0130_power_on(ar0130);
> +	if (ret < 0) {
> +		dev_err(&client->dev, "AR0130 power up failed\n");
> +		return ret;
> +	}
> +
> +	/* Read out the chip version register */
> +	data = ar0130_read(client, AR0130_CHIP_VERSION_REG);
> +	if (data != AR0130_CHIP_ID) {
> +		dev_err(&client->dev, "AR0130 not detected, chip ID read:0x%4.4X\n",
> +				data);
> +		return -ENODEV;
> +	}
> +
> +	dev_info(&client->dev, "AR0130 detected at address 0x%02X:chip ID =
> 0x%4.4X\n", +			client->addr, AR0130_CHIP_ID);
> +
> +	ar0130_power_off(ar0130);
> +
> +	return ret;
> +}
> +
> +static int ar0130_open(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh)
> +{
> +	return ar0130_s_power(sd, 1);
> +}
> +
> +static int ar0130_close(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh)
> +{
> +	return ar0130_s_power(sd, 0);
> +}
> +
> +/***************************************************
> +		v4l2_subdev_ops
> +****************************************************/
> +static struct v4l2_subdev_core_ops ar0130_subdev_core_ops = {
> +	.g_chip_ident	= ar0130_g_chip_ident,
> +#ifdef CONFIG_VIDEO_ADV_DEBUG
> +	.g_register	= ar0130_g_reg,
> +	.s_register	= ar0130_s_reg,
> +#endif
> +	.s_power	= ar0130_s_power,
> +};
> +
> +static struct v4l2_subdev_video_ops ar0130_subdev_video_ops = {
> +	.s_stream	= ar0130_s_stream,
> +};
> +
> +static struct v4l2_subdev_pad_ops ar0130_subdev_pad_ops = {
> +	.enum_mbus_code	 = ar0130_enum_mbus_code,
> +	.enum_frame_size = ar0130_enum_frame_size,
> +	.get_fmt	 = ar0130_get_format,
> +	.set_fmt	 = ar0130_set_format,
> +	.get_crop	 = ar0130_get_crop,
> +	.set_crop	 = ar0130_set_crop,
> +};
> +
> +static struct v4l2_subdev_ops ar0130_subdev_ops = {
> +	.core	= &ar0130_subdev_core_ops,
> +	.video	= &ar0130_subdev_video_ops,
> +	.pad	= &ar0130_subdev_pad_ops,
> +};
> +
> +/*
> + * Internal ops. Never call this from drivers, only the v4l2 framework can
> call 
> + * these ops.
> + */
> +static const struct v4l2_subdev_internal_ops ar0130_subdev_internal_ops = {
> +	.registered	= ar0130_registered,
> +	.open		= ar0130_open,
> +	.close		= ar0130_close,
> +};
> +
> +/***************************************************
> +		I2C driver
> +****************************************************/
> +static int ar0130_probe(struct i2c_client *client,
> +			const struct i2c_device_id *did)
> +{
> +	struct ar0130_platform_data *pdata = client->dev.platform_data;
> +	struct i2c_adapter *adapter = to_i2c_adapter(client->dev.parent);
> +	struct ar0130_priv *ar0130;
> +	struct v4l2_ctrl *ar0130_test_ctrl;
> +	int ret;
> +
> +	if (pdata == NULL) {
> +		dev_err(&client->dev, "No platform data\n");
> +		return -EINVAL;
> +	}
> +
> +	if (!i2c_check_functionality(adapter, I2C_FUNC_SMBUS_WORD_DATA)) {
> +		dev_warn(&client->dev, "I2C-Adapter doesn't support
> I2C_FUNC_SMBUS_WORD\n");
> +		return -EIO;
> +	}
> +
> +	ar0130 = kzalloc(sizeof(struct ar0130_priv), GFP_KERNEL);

Please use devm_kzalloc(), the memory will then be freed automatically (no 
need for a kfree(ar0130) in the error path below or in ar0130_remove()).

> +	if (ar0130 == NULL)
> +		return -ENOMEM;
> +
> +	ar0130->pdata = pdata;
> +
> +	v4l2_ctrl_handler_init(&ar0130->ctrls, 5);
> +
> +	v4l2_ctrl_new_std(&ar0130->ctrls, &ar0130_ctrl_ops,
> +			V4L2_CID_GAIN, AR0130_GLOBAL_GAIN_MIN,
> +			AR0130_GLOBAL_GAIN_MAX, 1, AR0130_GLOBAL_GAIN_DEF);
> +	v4l2_ctrl_new_std(&ar0130->ctrls, &ar0130_ctrl_ops,
> +				V4L2_CID_HFLIP, 0, 1, 1, 0);
> +	v4l2_ctrl_new_std(&ar0130->ctrls, &ar0130_ctrl_ops,
> +				V4L2_CID_VFLIP, 0, 1, 1, 0);
> +	v4l2_ctrl_new_std_menu(&ar0130->ctrls, &ar0130_ctrl_ops,
> +		V4L2_CID_EXPOSURE_AUTO, V4L2_EXPOSURE_MANUAL, 0,
> +					V4L2_EXPOSURE_AUTO);
> +	ar0130_test_ctrl = v4l2_ctrl_new_std_menu(&ar0130->ctrls,
> +		&ar0130_ctrl_ops, V4L2_CID_TEST_PATTERN, 5, 0,
> +				V4L2_TEST_PATTERN_DISABLED);
> +
> +	if (ar0130->ctrls.error) {
> +		ret = ar0130->ctrls.error;
> +		dev_err(&client->dev, "Control initialization error: %d\n",
> +			ret);
> +		goto done;
> +	}
> +
> +	v4l2_ctrl_modify_menu(ar0130_test_ctrl, ar0130_test_pattern, 5, 0, 0);

The control API has merged v4l2_ctrl_new_std_menu() with 
v4l2_ctrl_modify_menu() into a new v4l2_ctrl_new_std_menu_user() function.

> +
> +	mutex_init(&ar0130->power_lock);
> +	v4l2_i2c_subdev_init(&ar0130->subdev, client, &ar0130_subdev_ops);
> +	ar0130->subdev.internal_ops = &ar0130_subdev_internal_ops;
> +	ar0130->subdev.ctrl_handler = &ar0130->ctrls;
> +
> +	ar0130->pad.flags = MEDIA_PAD_FL_SOURCE;
> +	ret = media_entity_init(&ar0130->subdev.entity, 1, &ar0130->pad, 0);
> +	if (ret < 0)
> +		goto done;
> +
> +	ar0130->subdev.flags |= V4L2_SUBDEV_FL_HAS_DEVNODE;
> +
> +	ar0130->crop.width	= AR0130_WINDOW_WIDTH_DEF;
> +	ar0130->crop.height	= AR0130_WINDOW_HEIGHT_DEF;
> +	ar0130->crop.left	= AR0130_COLUMN_START_DEF;
> +	ar0130->crop.top	= AR0130_ROW_START_DEF;
> +
> +	ar0130->format.code		= V4L2_MBUS_FMT_SGRBG12_1X12;
> +	ar0130->format.width		= AR0130_WINDOW_WIDTH_DEF;
> +	ar0130->format.height		= AR0130_WINDOW_HEIGHT_DEF;
> +	ar0130->format.field		= V4L2_FIELD_NONE;
> +	ar0130->format.colorspace	= V4L2_COLORSPACE_SRGB;
> +
> +done:
> +	if (ret < 0) {
> +		v4l2_ctrl_handler_free(&ar0130->ctrls);
> +		media_entity_cleanup(&ar0130->subdev.entity);
> +		kfree(ar0130);
> +		dev_err(&client->dev, "Probe failed\n");
> +	}
> +
> +	return ret;
> +}
> +
> +static int ar0130_remove(struct i2c_client *client)
> +{
> +	struct v4l2_subdev *subdev = i2c_get_clientdata(client);
> +	struct ar0130_priv *ar0130 = to_ar0130(client);
> +
> +	v4l2_ctrl_handler_free(&ar0130->ctrls);
> +	v4l2_device_unregister_subdev(subdev);
> +	media_entity_cleanup(&subdev->entity);
> +	kfree(ar0130);
> +
> +	return 0;
> +}
> +
> +static const struct i2c_device_id ar0130_id[] = {
> +	{ "ar0130", 0 },
> +	{ }
> +};
> +MODULE_DEVICE_TABLE(i2c, ar0130_id);
> +
> +static struct i2c_driver ar0130_i2c_driver = {
> +	.driver = {
> +		 .name = "ar0130",
> +	},
> +	.probe    = ar0130_probe,
> +	.remove   = ar0130_remove,
> +	.id_table = ar0130_id,
> +};
> +
> +module_i2c_driver(ar0130_i2c_driver);
> +
> +MODULE_DESCRIPTION("Aptina AR0130 Camera driver");
> +MODULE_AUTHOR("Aptina Imaging <drivers@aptina.com>");
> +MODULE_LICENSE("GPL v2");
> diff --git a/drivers/media/video/ar0130_regs.h
> b/drivers/media/video/ar0130_regs.h new file mode 100644
> index 0000000..a7a6619
> --- /dev/null
> +++ b/drivers/media/video/ar0130_regs.h
> @@ -0,0 +1,107 @@
> +/*
> + * drivers/media/video/ar0130_regs.h
> + *
> + * Aptina AR0130 sensor related register values
> + *
> + * Copyright (C) 2012 Aptina Imaging
> + *
> + * This program is free software; you can redistribute it and/or modify
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
> + * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307 
> USA + *
> + */
> +
> +#ifndef __AR0130_H__
> +#define __AR0130_H__
> +#endif /* __AR0130_H__ */

The #endif should be at the end of this file.

> +static unsigned int ar0130_linear_data[79] = {
> +0x0225,
> +0x5050,
> +0x2D26,
> +0x0828,
> +0x0D17,
> +0x0926,
> +0x0028,
> +0x0526,
> +0xA728,
> +0x0725,
> +0x8080,
> +0x2917,
> +0x0525,
> +0x0040,
> +0x2702,
> +0x1616,
> +0x2706,
> +0x1736,
> +0x26A6,
> +0x1703,
> +0x26A4,
> +0x171F,
> +0x2805,
> +0x2620,
> +0x2804,
> +0x2520,
> +0x2027,
> +0x0017,
> +0x1E25,
> +0x0020,
> +0x2117,
> +0x1028,
> +0x051B,
> +0x1703,
> +0x2706,
> +0x1703,
> +0x1741,
> +0x2660,
> +0x17AE,
> +0x2500,
> +0x9027,
> +0x0026,
> +0x1828,
> +0x002E,
> +0x2A28,
> +0x081E,
> +0x0831,
> +0x1440,
> +0x4014,
> +0x2020,
> +0x1410,
> +0x1034,
> +0x1400,
> +0x1014,
> +0x0020,
> +0x1400,
> +0x4013,
> +0x1802,
> +0x1470,
> +0x7004,
> +0x1470,
> +0x7003,
> +0x1470,
> +0x7017,
> +0x2002,
> +0x1400,
> +0x2002,
> +0x1400,
> +0x5004,
> +0x1400,
> +0x2004,
> +0x1400,
> +0x5022,
> +0x0314,
> +0x0020,
> +0x0314,
> +0x0050,
> +0x2C2C,
> +0x2C2C
> +};

Is this automatically generated ? If not you could move it to the ar0130.c 
file. I would also put 8 values per line, and indent them properly (one tab at 
the beginning of each line).

> diff --git a/include/media/ar0130.h b/include/media/ar0130.h
> new file mode 100644
> index 0000000..4a95b64
> --- /dev/null
> +++ b/include/media/ar0130.h
> @@ -0,0 +1,52 @@
> +/*
> + * include/media/ar0130.h
> + *
> + * Aptina AR0130 sensor related register values
> + *
> + * Copyright (C) 2012 Aptina Imaging
> + *
> + * This program is free software; you can redistribute it and/or modify
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
> + * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307 
> USA + *

Please remove this last paragraph.

> + */
> +
> +#ifndef __AR0130_H__
> +#define __AR0130_H__
> +#define AR0130_I2C_ADDR		0x10 /* (0x20 >> 1) */
> +
> +struct v4l2_subdev;
> +
> +enum {
> +	AR0130_COLOR_VERSION,
> +	AR0130_MONOCHROME_VERSION,
> +};
> +
> +/*
> + * struct ar0130_platform_data - AR0130 platform data
> + * @set_xclk: Clock frequency set callback
> + * @reset: Chip reset GPIO (set to -1 if not used)
> + * @ext_freq: Input clock frequency
> + * @target_freq: Pixel clock frequency
> + * @version: color or monochrome
> + * @clk_pol: parallel pixclk polarity
> + */
> +struct ar0130_platform_data {
> +	int (*set_xclk)(struct v4l2_subdev *subdev, int hz);
> +	int (*reset)(struct v4l2_subdev *subdev, int active);
> +	int ext_freq;
> +	int target_freq;
> +	int version;
> +	unsigned int clk_pol:1;
> +};
> +
> +#endif
> diff --git a/include/media/v4l2-chip-ident.h
> b/include/media/v4l2-chip-ident.h index 58f914a..d20f19d 100644
> --- a/include/media/v4l2-chip-ident.h
> +++ b/include/media/v4l2-chip-ident.h
> @@ -305,6 +305,7 @@ enum {
>  	V4L2_IDENT_MT9T112		= 45022,
>  	V4L2_IDENT_MT9V111		= 45031,
>  	V4L2_IDENT_MT9V112		= 45032,
> +	V4L2_IDENT_AR0130		= 45040,

This isn't needed, sensor drivers that support the subdev API don't need a 
V4L2_IDENT_*.

> 
>  	/* HV7131R CMOS sensor: just ident 46000 */
>  	V4L2_IDENT_HV7131R		= 46000,
-- 
Regards,

Laurent Pinchart

