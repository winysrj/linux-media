Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m72KiMKf010549
	for <video4linux-list@redhat.com>; Sat, 2 Aug 2008 16:44:22 -0400
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id m72Ki9nF014996
	for <video4linux-list@redhat.com>; Sat, 2 Aug 2008 16:44:10 -0400
Date: Sat, 2 Aug 2008 22:44:03 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Robert Jarzmik <robert.jarzmik@free.fr>
In-Reply-To: <1217694634-32756-2-git-send-email-robert.jarzmik@free.fr>
Message-ID: <Pine.LNX.4.64.0808022224490.27474@axis700.grange>
References: <87d4krv0rd.fsf@free.fr>
	<1217694634-32756-1-git-send-email-robert.jarzmik@free.fr>
	<1217694634-32756-2-git-send-email-robert.jarzmik@free.fr>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: video4linux-list@redhat.com
Subject: Re: [PATCH 2/2] Add support for Micron MT9M111 camera.
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

Nice! Not knowing this specific camera, I can only provide a couple of 
nitpicks:

On Sat, 2 Aug 2008, Robert Jarzmik wrote:

> diff --git a/drivers/media/video/mt9m111.c b/drivers/media/video/mt9m111.c
> new file mode 100644
> index 0000000..de03e78
> --- /dev/null
> +++ b/drivers/media/video/mt9m111.c
> @@ -0,0 +1,962 @@
> +/*
> + * Driver for MT9M111 CMOS Image Sensor from Micron
> + *
> + * Copyright (C) 2008, Robert Jarzmik <robert.jarzmik@free.fr>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + */
> +#include <linux/videodev2.h>
> +#include <linux/slab.h>
> +#include <linux/i2c.h>
> +#include <linux/log2.h>
> +#include <linux/gpio.h>
> +#include <linux/delay.h>
> +
> +#include <media/v4l2-common.h>
> +#include <media/v4l2-chip-ident.h>
> +#include <media/soc_camera.h>
> +
> +/* mt9m111 i2c address is 0x5d or 0x48 (depending on SAddr pin)
> + * The platform has to define i2c_board_info
> + * and call i2c_register_board_info() */

Please reformat this comment to

/*
 * mt9m111 i2c address is 0x5d or 0x48 (depending on SAddr pin)
 * The platform has to define i2c_board_info
 * and call i2c_register_board_info()
 */

or similar

> +
> +/* mt9m111: Sensor register addresses */
> +#define MT9M111_CHIP_VERSION		0x000
> +#define MT9M111_ROW_START		0x001
> +#define MT9M111_COLUMN_START		0x002
> +#define MT9M111_WINDOW_HEIGHT		0x003
> +#define MT9M111_WINDOW_WIDTH		0x004
> +#define MT9M111_HORIZONTAL_BLANKING_B	0x005
> +#define MT9M111_VERTICAL_BLANKING_B	0x006
> +#define MT9M111_HORIZONTAL_BLANKING_A	0x007
> +#define MT9M111_VERTICAL_BLANKING_A	0x008
> +#define MT9M111_SHUTTER_WIDTH		0x009
> +#define MT9M111_ROW_SPEED		0x00a
> +#define MT9M111_EXTRA_DELAY		0x00b
> +#define MT9M111_SHUTTER_DELAY		0x00c
> +#define MT9M111_RESET			0x00d
> +#define MT9M111_READ_MODE_B		0x020
> +#define MT9M111_READ_MODE_A		0x021
> +#define MT9M111_FLASH_CONTROL		0x023
> +#define MT9M111_GREEN1_GAIN		0x02b
> +#define MT9M111_BLUE_GAIN		0x02c
> +#define MT9M111_RED_GAIN		0x02d
> +#define MT9M111_GREEN2_GAIN		0x02e
> +#define MT9M111_GLOBAL_GAIN		0x02f
> +#define MT9M111_CONTEXT_CONTROL		0x0c8
> +#define MT9M111_PAGE_MAP		0x0f0
> +#define MT9M111_BYTE_WISE_ADDR		0x0f1
> +
> +#define MT9M111_RESET_SYNC_CHANGES	(1<<15)
> +#define MT9M111_RESET_RESTART_BAD_FRAME	(1<<9)
> +#define MT9M111_RESET_SHOW_BAD_FRAMES	(1<<8)
> +#define MT9M111_RESET_RESET_SOC		(1<<5)
> +#define MT9M111_RESET_OUTPUT_DISABLE	(1<<4)
> +#define MT9M111_RESET_CHIP_ENABLE	(1<<3)
> +#define MT9M111_RESET_ANALOG_STANDBY	(1<<2)
> +#define MT9M111_RESET_RESTART_FRAME	(1<<1)
> +#define MT9M111_RESET_RESET_MODE	(1<<0)
> +
> +#define MT9M111_RMB_MIRROR_COLS		(1<<1)
> +#define MT9M111_RMB_MIRROR_ROWS		(1<<0)
> +#define MT9M111_CTXT_CTRL_RESTART	(1<<15)
> +#define MT9M111_CTXT_CTRL_DEFECTCOR_B	(1<<12)
> +#define MT9M111_CTXT_CTRL_RESIZE_B	(1<<10)
> +#define MT9M111_CTXT_CTRL_CTRL2_B	(1<<9)
> +#define MT9M111_CTXT_CTRL_GAMMA_B	(1<<8)
> +#define MT9M111_CTXT_CTRL_XENON_EN	(1<<7)
> +#define MT9M111_CTXT_CTRL_READ_MODE_B	(1<<3)
> +#define MT9M111_CTXT_CTRL_LED_FLASH_EN	(1<<2)
> +#define MT9M111_CTXT_CTRL_VBLANK_SEL_B	(1<<1)
> +#define MT9M111_CTXT_CTRL_HBLANK_SEL_B	(1<<0)
> +/*
> + * mt9m111: Colorpipe register addresses (0x100..0x1ff)
> + */
> +#define MT9M111_OPER_MODE_CTRL		0x106
> +#define MT9M111_OUTPUT_FORMAT_CTRL	0x108
> +#define MT9M111_REDUCER_XZOOM_B		0x1a0
> +#define MT9M111_REDUCER_XSIZE_B		0x1a1
> +#define MT9M111_REDUCER_YZOOM_B		0x1a3
> +#define MT9M111_REDUCER_YSIZE_B		0x1a4
> +#define MT9M111_REDUCER_XZOOM_A		0x1a6
> +#define MT9M111_REDUCER_XSIZE_A		0x1a7
> +#define MT9M111_REDUCER_YZOOM_A		0x1a9
> +#define MT9M111_REDUCER_YSIZE_A		0x1aa
> +
> +#define MT9M111_OUTPUT_FORMAT_CTRL2_A	0x13a
> +#define MT9M111_OUTPUT_FORMAT_CTRL2_B	0x19b
> +
> +#define MT9M111_OPMODE_AUTOEXPO_EN	(1<<14)
> +
> +
> +#define MT9M111_OUTFMT_PROCESSED_BAYER	(1<<14)
> +#define MT9M111_OUTFMT_BYPASS_IFP	(1<<10)
> +#define MT9M111_OUTFMT_INV_PIX_CLOCK	(1<<9)
> +#define MT9M111_OUTFMT_RGB		(1<<8)
> +#define MT9M111_OUTFMT_RGB565		(0x0 << 6)
> +#define MT9M111_OUTFMT_RGB555		(0x1 << 6)
> +#define MT9M111_OUTFMT_RGB444x		(0x2 << 6)
> +#define MT9M111_OUTFMT_RGBx444		(0x3 << 6)
> +#define MT9M111_OUTFMT_TST_RAMP_OFF	(0x0 << 4)
> +#define MT9M111_OUTFMT_TST_RAMP_COL	(0x1 << 4)
> +#define MT9M111_OUTFMT_TST_RAMP_ROW	(0x2 << 4)
> +#define MT9M111_OUTFMT_TST_RAMP_FRAME	(0x3 << 4)
> +#define MT9M111_OUTFMT_SHIFT_3_UP	(1<<3)
> +#define MT9M111_OUTFMT_AVG_CHROMA	(1<<2)
> +#define MT9M111_OUTFMT_SWAP_YCbCr_C_Y	(1<<1)
> +#define MT9M111_OUTFMT_SWAP_RGB_EVEN	(1<<1)
> +#define MT9M111_OUTFMT_SWAP_YCbCr_Cb_Cr	(1<<0)

Please, add spaces around the "<<" in all defines above (except where they 
are already there, of course:-))

[snip]

> +#define COL_FMT(_name, _depth, _fourcc, _colorspace) \
> +	{ .name = _name, .depth = _depth, .fourcc = _fourcc, \
> +	.colorspace = _colorspace }
> +#define RGB_FMT(_name, _depth, _fourcc) \
> +	COL_FMT(_name, _depth, _fourcc, V4L2_COLORSPACE_SRGB)
> +
> +static const struct soc_camera_data_format mt9m111_colour_formats[] = {
> +	COL_FMT("YCrYCb 8 bit", 8, V4L2_PIX_FMT_YUYV, V4L2_COLORSPACE_JPEG),
> +	RGB_FMT("RGB 565", 16, V4L2_PIX_FMT_RGB565),
> +	RGB_FMT("RGB 555", 16, V4L2_PIX_FMT_RGB555),
> +	RGB_FMT("Bayer (sRGB) 10 bit", 10, V4L2_PIX_FMT_SBGGR16),
> +	RGB_FMT("Bayer (sRGB) 8 bit", 8, V4L2_PIX_FMT_SBGGR8),
> +};

This is where you would add all those swapped pixel formats.

> +static int mt9m111_enable(struct soc_camera_device *icd)
> +{
> +	struct mt9m111 *mt9m111 = container_of(icd, struct mt9m111, icd);
> +	int ret;
> +
> +	ret = reg_set(RESET, MT9M111_RESET_CHIP_ENABLE);
> +	if (ret >= 0)
> +		mt9m111->powered = 1;
> +	return ret;
> +}
> +
> +static int mt9m111_disable(struct soc_camera_device *icd)
> +{
> +	struct mt9m111 *mt9m111 = container_of(icd, struct mt9m111, icd);
> +	int ret;
> +
> +	ret = reg_clear(RESET, MT9M111_RESET_CHIP_ENABLE);
> +	if (ret >= 0)
> +		mt9m111->powered = 0;
> +	return ret;
> +}
> +
> +static int mt9m111_reset(struct soc_camera_device *icd)
> +{
> +	int ret;
> +
> +	ret = reg_set(RESET, MT9M111_RESET_RESET_MODE);
> +	if (ret >= 0)
> +		ret = reg_set(RESET, MT9M111_RESET_RESET_SOC);
> +	if (ret >= 0)
> +		ret = reg_clear(RESET, MT9M111_RESET_RESET_MODE
> +				| MT9M111_RESET_RESET_SOC);
> +	return ret;
> +}
> +
> +static int mt9m111_start_capture(struct soc_camera_device *icd)
> +{
> +	return 0;
> +}
> +
> +static int mt9m111_stop_capture(struct soc_camera_device *icd)
> +{
> +	return 0;
> +}

Is it really a good idea to keep the camera active all the time? Maybe 
only call enable / disable here, not on init / release?

[snip]

> +static int mt9m111_set_pixfmt(struct soc_camera_device *icd, u32 pixfmt)
> +{
> +	struct mt9m111 *mt9m111 = container_of(icd, struct mt9m111, icd);
> +	int ret = 0;
> +
> +	switch (pixfmt) {
> +	case V4L2_PIX_FMT_SBGGR8:
> +		ret = mt9m111_setfmt_bayer8(icd);
> +		break;
> +	case V4L2_PIX_FMT_SBGGR16:
> +		ret = mt9m111_setfmt_bayer10(icd);
> +		break;
> +	case V4L2_PIX_FMT_RGB555:
> +		ret = mt9m111_setfmt_rgb555(icd);
> +		break;
> +	case V4L2_PIX_FMT_RGB565:
> +		ret = mt9m111_setfmt_rgb565(icd);
> +		break;
> +	case V4L2_PIX_FMT_YUYV:
> +		ret = mt9m111_setfmt_yuv(icd);
> +		break;
> +	default:
> +		dev_err(&icd->dev, "Pixel format not handled : %x\n", pixfmt);
> +		ret = -EINVAL;
> +	}
> +
> +	if (ret >= 0)
> +		mt9m111->pixfmt = pixfmt;
> +
> +	return ret;
> +}

And here you would support a few more formats.

[snip]

> +static const struct v4l2_queryctrl mt9m111_controls[] = {
> +	{
> +		.id		= V4L2_CID_VFLIP,
> +		.type		= V4L2_CTRL_TYPE_BOOLEAN,
> +		.name		= "Flip Verticaly",
> +		.minimum	= 0,
> +		.maximum	= 1,
> +		.step		= 1,
> +		.default_value	= 0,
> +	}, {
> +		.id		= V4L2_CID_HFLIP,
> +		.type		= V4L2_CTRL_TYPE_BOOLEAN,
> +		.name		= "Flip Horizontaly",
> +		.minimum	= 0,
> +		.maximum	= 1,
> +		.step		= 1,
> +		.default_value	= 0,
> +	}, {	/* gain = 1/32*val (=>gain=1 if val==32) */
> +		.id		= V4L2_CID_GAIN,
> +		.type		= V4L2_CTRL_TYPE_INTEGER,
> +		.name		= "Gain",
> +		.minimum	= 0,
> +		.maximum	= 63*2*2,
> +		.step		= 1,
> +		.default_value	= 32,
> +		.flags		= V4L2_CTRL_FLAG_SLIDER,

Come on, be generous, add a couple of spaces around that multiplication 
above.

[snip]

> +static int mt9m111_set_global_gain(struct soc_camera_device *icd, int gain)
> +{
> +	u16 val;
> +
> +	if (gain > 63*2*2)
> +		return -EINVAL;
> +
> +	icd->gain = gain;
> +	if ((gain >= 64*2) && (gain < 63*2*2))
> +		val = (1 << 10) | (1 << 9) | (gain / 4);
> +	else if ((gain >= 64) && (gain < 64*2))
> +		val = (1<<9) | (gain / 2);
> +	else
> +		val = gain;
> +
> +	return reg_write(GLOBAL_GAIN, val);
> +}

And here too, please.

[snip]

> +/* Interface active, can use i2c. If it fails, it can indeed mean, that
> + * this wasn't our capture interface, so, we wait for the right one */

Reformat the comment, please.

Thanks
Guennadi
---
Guennadi Liakhovetski

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
