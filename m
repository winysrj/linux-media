Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mANM104L023738
	for <video4linux-list@redhat.com>; Sun, 23 Nov 2008 17:01:00 -0500
Received: from smtp-vbr16.xs4all.nl (smtp-vbr16.xs4all.nl [194.109.24.36])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mANM0nGX027905
	for <video4linux-list@redhat.com>; Sun, 23 Nov 2008 17:00:49 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: video4linux-list@redhat.com
Date: Sun, 23 Nov 2008 23:00:40 +0100
References: <hvaibhav@ti.com>
	<1227280923-31654-1-git-send-email-hvaibhav@ti.com>
In-Reply-To: <1227280923-31654-1-git-send-email-hvaibhav@ti.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200811232300.40530.hverkuil@xs4all.nl>
Cc: linux-omap@vger.kernel.org,
	davinci-linux-open-source-bounces@linux.davincidsp.com
Subject: Re: [PATCH 2/2] TVP514x V4L int device driver support
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

Hi Vaibhav,

Here is my review as promised (although a day late). It's a mix of 
smaller and larger issues:

1) CONFIG_VIDEO_ADV_DEBUG is meant to enable the ability to set/get 
registers through the VIDIOC_DBG_G/S_REGISTER ioctls. For general 
debugging you should use a debug module option (see e.g. saa7115.c).

2) Please use the media/v4l2-i2c-drv.h or media/v4l2-i2c-drv-legacy.h 
header to hide some of the i2c complexity (again, see e.g. saa7115.c). 
The i2c API tends to change a lot (and some changes are upcoming) so 
using this header will mean that i2c driver changes will be minimal in 
the future. In addition it will ensure that this driver can be compiled 
with older kernels as well once it is part of the v4l-dvb repository.

3) Remember that the use of v4l2-int-device.h must be temporary only. It 
will make it impossible to use this driver with any other platform but 
omap. I had hoped to release my generic v4l2 subdevice support today 
which should replace v4l2-int-device.h in time, but I hit a bug that 
needs to be resolved first. I hope to fix it during the next week so 
that I can finally make it available for use asap.

4) This is the really big problem I have with this driver: it relies on 
the bridge driver to do the initialization of the registers. This is 
very much the wrong approach. It would require all bridge drivers that 
are going to use this chip to program the chips registers. That's not 
the way to do it. The tvp514x driver should do this and the bridge 
driver should only pass high-level config data (such as with 
input/output pins are being used). Again, see saa7115, cx25840, etc. 
This approach means that all the relevant programming is inside the 
chip's driver and that bridge drivers can easily replace one chip for 
another since except for a little bit of initialization (usually 
routing, clock frequencies) there is otherwise no difference between 
using one chip or another.

Remember that this is not a driver for use with omap, this is a generic 
i2c driver for this chip. omap just happens to be the only bridge 
driver using it right now, but that can easily change.

Yes, it makes it harder to write an i2c driver, but experience has shown 
us that the advantages regarding reuse far outweigh this initial cost.

Regards,

	Hans

On Friday 21 November 2008 16:22:03 hvaibhav@ti.com wrote:
> From: Vaibhav Hiremath <hvaibhav@ti.com>
>
> Added new V4L2 slave driver for TVP514x.
>
> The Driver interface has been tested on OMAP3EVM board
> with TI daughter card (TVP5146). Soon the patch for Daughter card
> will be posted on community.
>
> Signed-off-by: Brijesh Jadav <brijesh.j@ti.com>
> 		Hardik Shah <hardik.shah@ti.com>
> 		Manjunath Hadli <mrh@ti.com>
> 		R Sivaraj <sivaraj@ti.com>
> 		Vaibhav Hiremath <hvaibhav@ti.com>
> 		Karicheri Muralidharan <m-karicheri2@ti.com>
> ---
>  drivers/media/video/Kconfig   |   11 +
>  drivers/media/video/Makefile  |    1 +
>  drivers/media/video/tvp514x.c | 1331
> +++++++++++++++++++++++++++++++++++++++++ include/media/tvp514x.h    
>   |  406 +++++++++++++
>  4 files changed, 1749 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/media/video/tvp514x.c
>  create mode 100644 include/media/tvp514x.h
>
> diff --git a/drivers/media/video/Kconfig
> b/drivers/media/video/Kconfig index 47102c2..377d14e 100644
> --- a/drivers/media/video/Kconfig
> +++ b/drivers/media/video/Kconfig
> @@ -361,6 +361,17 @@ config VIDEO_SAA7191
>  	  To compile this driver as a module, choose M here: the
>  	  module will be called saa7191.
>
> +config VIDEO_TVP514X
> +	tristate "Texas Instruments TVP5146/47 video decoder"
> +	depends on VIDEO_V4L2 && I2C
> +	---help---
> +	  This is a Video4Linux2 sensor-level driver for the TI TVP5146/47
> +	  decoder. It is currently working with the TI OMAP3 camera
> +	  controller.
> +
> +	  To compile this driver as a module, choose M here: the
> +	  module will be called tvp514x.
> +
>  config VIDEO_TVP5150
>  	tristate "Texas Instruments TVP5150 video decoder"
>  	depends on VIDEO_V4L2 && I2C
> diff --git a/drivers/media/video/Makefile
> b/drivers/media/video/Makefile index 16962f3..cdbbf38 100644
> --- a/drivers/media/video/Makefile
> +++ b/drivers/media/video/Makefile
> @@ -66,6 +66,7 @@ obj-$(CONFIG_VIDEO_CX88) += cx88/
>  obj-$(CONFIG_VIDEO_EM28XX) += em28xx/
>  obj-$(CONFIG_VIDEO_USBVISION) += usbvision/
>  obj-$(CONFIG_VIDEO_TVP5150) += tvp5150.o
> +obj-$(CONFIG_VIDEO_TVP514X) += tvp514x.o
>  obj-$(CONFIG_VIDEO_PVRUSB2) += pvrusb2/
>  obj-$(CONFIG_VIDEO_MSP3400) += msp3400.o
>  obj-$(CONFIG_VIDEO_CS5345) += cs5345.o
> diff --git a/drivers/media/video/tvp514x.c
> b/drivers/media/video/tvp514x.c new file mode 100644
> index 0000000..b68ddf5
> --- /dev/null
> +++ b/drivers/media/video/tvp514x.c
> @@ -0,0 +1,1331 @@
> +/*
> + * drivers/media/video/tvp514x.c
> + *
> + * TI TVP5146/47 decoder driver
> + *
> + * Copyright (C) 2008 Texas Instruments Inc
> + *
> + * Contributors:
> + *     Brijesh R Jadav <brijesh.j@ti.com>
> + *     Hardik Shah <hardik.shah@ti.com>
> + *     Manjunath Hadli <mrh@ti.com>
> + *     Sivaraj R <sivaraj@ti.com>
> + *     Vaibhav Hiremath <hvaibhav@ti.com>
> + *
> + * This package is free software; you can redistribute it and/or
> modify + * it under the terms of the GNU General Public License
> version 2 as + * published by the Free Software Foundation.
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
> +#include <linux/i2c.h>
> +#include <linux/delay.h>
> +#include <linux/videodev2.h>
> +#include <media/v4l2-int-device.h>
> +#include <media/tvp514x.h>
> +
> +#define MODULE_NAME	TVP514X_MODULE_NAME
> +
> +/* Debug functions */
> +#ifdef CONFIG_VIDEO_ADV_DEBUG
> +
> +#define dump_reg(client, reg, val)					\
> +	do {								\
> +		tvp514x_read_reg(client, reg, &val);			\
> +		dev_dbg(&(client)->dev, "Reg(0x%.2X): 0x%.2X\n", reg, val); \
> +	} while (0)
> +
> +#endif				/* #ifdef CONFIG_VIDEO_ADV_DEBUG */
> +
> +/* List of image formats supported by TVP5146/47 decoder
> + * Currently we are using 8 bit mode only, but can be
> + * extended to 10/20 bit mode.
> + */
> +static const struct v4l2_fmtdesc tvp514x_fmt_list[] = {
> +	{
> +	 .index = 0,
> +	 .type = V4L2_BUF_TYPE_VIDEO_CAPTURE,
> +	 .flags = 0,
> +	 .description = "8-bit UYVY 4:2:2 Format",
> +	 .pixelformat = V4L2_PIX_FMT_UYVY,
> +	 }
> +};
> +
> +#define TVP514X_NUM_FORMATS		ARRAY_SIZE(tvp514x_fmt_list)
> +
> +/*
> + * Supported standards - These must be ordered according to enum
> tvp514x_std + * order.
> + * Currently supports two standards only, need to add support for
> rest of the + * modes, like SECAM, etc...
> + */
> +static struct tvp514x_std_info tvp514x_std_list[] = {
> +	{
> +	 .width = NTSC_NUM_ACTIVE_PIXELS,
> +	 .height = NTSC_NUM_ACTIVE_LINES,
> +	 .video_std = VIDEO_STD_NTSC_MJ_BIT,
> +	 .standard = {
> +		      .index = 0,
> +		      .id = V4L2_STD_NTSC,
> +		      .name = "NTSC",
> +		      .frameperiod = {1001, 30000},
> +		      .framelines = 525}
> +	 },
> +	{
> +	 .width = PAL_NUM_ACTIVE_PIXELS,
> +	 .height = PAL_NUM_ACTIVE_LINES,
> +	 .video_std = VIDEO_STD_PAL_BDGHIN_BIT,
> +	 .standard = {
> +		      .index = 1,
> +		      .id = V4L2_STD_PAL,
> +		      .name = "PAL",
> +		      .frameperiod = {1, 25},
> +		      .framelines = 625}
> +	 }
> +};
> +
> +#define TVP514X_NUM_STANDARDS		ARRAY_SIZE(tvp514x_std_list)
> +
> +/* Supported controls */
> +static const struct tvp514x_ctrl_info tvp514x_ctrl_list[] = {
> +	{
> +	 .reg_address = REG_BRIGHTNESS,
> +	 .query_ctrl = {
> +			.id = V4L2_CID_BRIGHTNESS,
> +			.name = "BRIGHTNESS",
> +			.type = V4L2_CTRL_TYPE_INTEGER,
> +			.minimum = 0,
> +			.maximum = 255,
> +			.step = 1,
> +			.default_value = 128}
> +	 },
> +	{
> +	 .reg_address = REG_CONTRAST,
> +	 .query_ctrl = {
> +			.id = V4L2_CID_CONTRAST,
> +			.name = "CONTRAST",
> +			.type = V4L2_CTRL_TYPE_INTEGER,
> +			.minimum = 0,
> +			.maximum = 255,
> +			.step = 1,
> +			.default_value = 128}
> +	 },
> +	{
> +	 .reg_address = REG_SATURATION,
> +	 .query_ctrl = {
> +			.id = V4L2_CID_SATURATION,
> +			.name = "SATURATION",
> +			.type = V4L2_CTRL_TYPE_INTEGER,
> +			.minimum = 0,
> +			.maximum = 255,
> +			.step = 1,
> +			.default_value = 128}
> +	 },
> +	{
> +	 .reg_address = REG_HUE,
> +	 .query_ctrl = {
> +			.id = V4L2_CID_HUE,
> +			.name = "HUE",
> +			.type = V4L2_CTRL_TYPE_INTEGER,
> +			.minimum = -180,
> +			.maximum = 180,
> +			.step = 180,
> +			.default_value = 0}
> +	 },
> +	{
> +	 .reg_address = REG_AFE_GAIN_CTRL,
> +	 .query_ctrl = {
> +			.id = V4L2_CID_AUTOGAIN,
> +			.name = "Automatic Gain Control",
> +			.type = V4L2_CTRL_TYPE_BOOLEAN,
> +			.minimum = 0,
> +			.maximum = 1,
> +			.step = 1,
> +			.default_value = 1}
> +	 }
> +};
> +
> +#define TVP514X_NUM_CONTROLS		ARRAY_SIZE(tvp514x_ctrl_list)
> +
> +/*
> + * Read a value from a register in an TVP5146/47 decoder device.
> + * The value is returned in 'val'.
> + * Returns zero if successful, or non-zero otherwise.
> + */
> +static int tvp514x_read_reg(struct i2c_client *client, u8 reg, u8
> *val) +{
> +	int err;
> +	struct i2c_msg msg[2];
> +	u8 data;
> +
> +	if (!client->adapter)
> +		return -ENODEV;
> +
> +	/* [MSG1] fill the register address data */
> +	data = reg;
> +	msg[0].addr = client->addr;
> +	msg[0].len = 1;
> +	msg[0].flags = 0;
> +	msg[0].buf = &data;
> +
> +	/* [MSG2] fill the data rx buffer */
> +	msg[1].addr = client->addr;
> +	msg[1].len = 1;		/* only 1 byte */
> +	msg[1].flags = I2C_M_RD;	/* Read the register values */
> +	msg[1].buf = val;
> +	err = i2c_transfer(client->adapter, msg, 2);
> +	if (err >= 0)
> +		return 0;
> +
> +	dev_err(&client->dev,
> +		"read from device 0x%.2x, offset 0x%.2x error %d\n",
> +		client->addr, reg, err);
> +
> +	return err;
> +}
> +
> +/*
> + * Write a value to a register in an TVP5146/47 decoder device.
> + * Returns zero if successful, or non-zero otherwise.
> + */
> +static int tvp514x_write_reg(struct i2c_client *client, u8 reg, u8
> val) +{
> +	int err;
> +	int retry = 0;
> +	struct i2c_msg msg[1];
> +	u8 data[2];
> +
> +	if (!client->adapter)
> +		return -ENODEV;
> +
> +again:
> +	data[0] = reg;		/* Register offset */
> +	data[1] = val;		/* Register value */
> +	msg->addr = client->addr;
> +	msg->len = 2;
> +	msg->flags = 0;		/* write operation */
> +	msg->buf = data;
> +
> +	err = i2c_transfer(client->adapter, msg, 1);
> +	if (err >= 0)
> +		return 0;
> +
> +	dev_err(&client->dev,
> +		"wrote 0x%.2x to offset 0x%.2x error %d\n", val, reg, err);
> +	if (retry <= I2C_RETRY_COUNT) {
> +		dev_info(&client->dev, "retry ... %d\n", retry);
> +		retry++;
> +		schedule_timeout(msecs_to_jiffies(20));
> +		goto again;
> +	}
> +	return err;
> +}
> +
> +/*
> + * tvp514x_write_regs : Initializes a list of TVP5146/47 registers
> + *		if token is TOK_TERM, then entire write operation terminates
> + *		if token is TOK_DELAY, then a delay of 'val' msec is introduced
> + *		if token is TOK_SKIP, then the register write is skipped
> + *		if token is TOK_WRITE, then the register write is performed
> + *
> + * reglist - list of registers to be written
> + * Returns zero if successful, or non-zero otherwise.
> + */
> +static int tvp514x_write_regs(struct i2c_client *client,
> +			      const struct tvp514x_reg reglist[])
> +{
> +	int err;
> +	const struct tvp514x_reg *next = reglist;
> +
> +	for (; next->token != TOK_TERM; next++) {
> +		if (next->token == TOK_DELAY) {
> +			schedule_timeout(msecs_to_jiffies(next->val));
> +			continue;
> +		}
> +
> +		if (next->token == TOK_SKIP)
> +			continue;
> +
> +		err = tvp514x_write_reg(client, next->reg, (u8) next->val);
> +		if (err) {
> +			dev_err(&client->dev, "write failed. Err[%d]\n",
> +				err);
> +			return err;
> +		}
> +	}
> +	return 0;
> +}
> +
> +/*
> + * tvp514x_get_current_std:
> + * Returns the current standard detected by TVP5146/47
> + */
> +static enum tvp514x_std tvp514x_get_current_std(struct
> tvp514x_decoder +						*decoder)
> +{
> +	u8 std, std_status;
> +
> +	if (tvp514x_read_reg(decoder->client, REG_VIDEO_STD, &std))
> +		return STD_INVALID;
> +
> +	if ((std & VIDEO_STD_MASK) == VIDEO_STD_AUTO_SWITCH_BIT) {
> +		/* use the standard status register */
> +		if (tvp514x_read_reg(decoder->client, REG_VIDEO_STD_STATUS,
> +				     &std_status))
> +			return STD_INVALID;
> +	} else
> +		std_status = std;	/* use the standard register itself */
> +
> +	switch (std_status & VIDEO_STD_MASK) {
> +	case VIDEO_STD_NTSC_MJ_BIT:
> +		return STD_NTSC_MJ;
> +		break;
> +
> +	case VIDEO_STD_PAL_BDGHIN_BIT:
> +		return STD_PAL_BDGHIN;
> +		break;
> +
> +	default:
> +		return STD_INVALID;
> +		break;
> +	}
> +
> +	return STD_INVALID;
> +}
> +
> +#ifdef CONFIG_VIDEO_ADV_DEBUG
> +/*
> + * TVP5146/47 register dump function
> + */
> +void tvp514x_reg_dump(struct tvp514x_decoder *decoder)
> +{
> +	u8 value;
> +
> +	dump_reg(decoder->client, REG_INPUT_SEL, value);
> +	dump_reg(decoder->client, REG_AFE_GAIN_CTRL, value);
> +	dump_reg(decoder->client, REG_VIDEO_STD, value);
> +	dump_reg(decoder->client, REG_OPERATION_MODE, value);
> +	dump_reg(decoder->client, REG_COLOR_KILLER, value);
> +	dump_reg(decoder->client, REG_LUMA_CONTROL1, value);
> +	dump_reg(decoder->client, REG_LUMA_CONTROL2, value);
> +	dump_reg(decoder->client, REG_LUMA_CONTROL3, value);
> +	dump_reg(decoder->client, REG_BRIGHTNESS, value);
> +	dump_reg(decoder->client, REG_CONTRAST, value);
> +	dump_reg(decoder->client, REG_SATURATION, value);
> +	dump_reg(decoder->client, REG_HUE, value);
> +	dump_reg(decoder->client, REG_CHROMA_CONTROL1, value);
> +	dump_reg(decoder->client, REG_CHROMA_CONTROL2, value);
> +	dump_reg(decoder->client, REG_COMP_PR_SATURATION, value);
> +	dump_reg(decoder->client, REG_COMP_Y_CONTRAST, value);
> +	dump_reg(decoder->client, REG_COMP_PB_SATURATION, value);
> +	dump_reg(decoder->client, REG_COMP_Y_BRIGHTNESS, value);
> +	dump_reg(decoder->client, REG_AVID_START_PIXEL_LSB, value);
> +	dump_reg(decoder->client, REG_AVID_START_PIXEL_MSB, value);
> +	dump_reg(decoder->client, REG_AVID_STOP_PIXEL_LSB, value);
> +	dump_reg(decoder->client, REG_AVID_STOP_PIXEL_MSB, value);
> +	dump_reg(decoder->client, REG_HSYNC_START_PIXEL_LSB, value);
> +	dump_reg(decoder->client, REG_HSYNC_START_PIXEL_MSB, value);
> +	dump_reg(decoder->client, REG_HSYNC_STOP_PIXEL_LSB, value);
> +	dump_reg(decoder->client, REG_HSYNC_STOP_PIXEL_MSB, value);
> +	dump_reg(decoder->client, REG_VSYNC_START_LINE_LSB, value);
> +	dump_reg(decoder->client, REG_VSYNC_START_LINE_MSB, value);
> +	dump_reg(decoder->client, REG_VSYNC_STOP_LINE_LSB, value);
> +	dump_reg(decoder->client, REG_VSYNC_STOP_LINE_MSB, value);
> +	dump_reg(decoder->client, REG_VBLK_START_LINE_LSB, value);
> +	dump_reg(decoder->client, REG_VBLK_START_LINE_MSB, value);
> +	dump_reg(decoder->client, REG_VBLK_STOP_LINE_LSB, value);
> +	dump_reg(decoder->client, REG_VBLK_STOP_LINE_MSB, value);
> +	dump_reg(decoder->client, REG_SYNC_CONTROL, value);
> +	dump_reg(decoder->client, REG_OUTPUT_FORMATTER1, value);
> +	dump_reg(decoder->client, REG_OUTPUT_FORMATTER2, value);
> +	dump_reg(decoder->client, REG_OUTPUT_FORMATTER3, value);
> +	dump_reg(decoder->client, REG_OUTPUT_FORMATTER4, value);
> +	dump_reg(decoder->client, REG_OUTPUT_FORMATTER5, value);
> +	dump_reg(decoder->client, REG_OUTPUT_FORMATTER6, value);
> +	dump_reg(decoder->client, REG_CLEAR_LOST_LOCK, value);
> +}
> +#endif		/* #ifdef CONFIG_VIDEO_ADV_DEBUG */
> +
> +/*
> + * Configure the TVP5146/47 with the current register settings
> + * Returns zero if successful, or non-zero otherwise.
> + */
> +static int tvp514x_configure(struct tvp514x_decoder *decoder)
> +{
> +	int err;
> +
> +	/* common register initialization */
> +	err =
> +	    tvp514x_write_regs(decoder->client, decoder->pdata->reg_list);
> +	if (err)
> +		return err;
> +
> +#ifdef CONFIG_VIDEO_ADV_DEBUG
> +	tvp514x_reg_dump(decoder);
> +#endif
> +
> +	return 0;
> +}
> +
> +/*
> + * Detect if an tvp514x is present, and if so which revision.
> + * A device is considered to be detected if the chip ID (LSB and
> MSB) + * registers match the expected values.
> + * Any value of the rom version register is accepted.
> + * Returns ENODEV error number if no device is detected, or zero
> + * if a device is detected.
> + */
> +static int tvp514x_detect(struct tvp514x_decoder *decoder)
> +{
> +	u8 chip_id_msb, chip_id_lsb, rom_ver;
> +
> +	if (tvp514x_read_reg
> +	    (decoder->client, REG_CHIP_ID_MSB, &chip_id_msb))
> +		return -ENODEV;
> +	if (tvp514x_read_reg
> +	    (decoder->client, REG_CHIP_ID_LSB, &chip_id_lsb))
> +		return -ENODEV;
> +	if (tvp514x_read_reg(decoder->client, REG_ROM_VERSION, &rom_ver))
> +		return -ENODEV;
> +
> +	dev_info(&decoder->client->dev,
> +		 "chip id detected msb:0x%x lsb:0x%x rom version:0x%x\n",
> +		 chip_id_msb, chip_id_lsb, rom_ver);
> +	if ((chip_id_msb != TVP514X_CHIP_ID_MSB)
> +		|| ((chip_id_lsb != TVP5146_CHIP_ID_LSB)
> +		&& (chip_id_lsb != TVP5147_CHIP_ID_LSB))) {
> +		/* We didn't read the values we expected, so this must not be
> +		 * an TVP5146/47.
> +		 */
> +		dev_err(&decoder->client->dev,
> +			"chip id mismatch msb:0x%x lsb:0x%x\n",
> +			chip_id_msb, chip_id_lsb);
> +		return -ENODEV;
> +	}
> +
> +	decoder->ver = rom_ver;
> +	decoder->state = STATE_DETECTED;
> +
> +	return 0;
> +}
> +
> +/*
> + * Following are decoder interface functions implemented by
> + * TVP5146/47 decoder driver.
> + */
> +
> +/**
> + * ioctl_querystd - V4L2 decoder interface handler for
> VIDIOC_QUERYSTD ioctl + * @s: pointer to standard V4L2 device
> structure
> + * @std_id: standard V4L2 std_id ioctl enum
> + *
> + * Returns the current standard detected by TVP5146/47. If no active
> input is + * detected, returns -EINVAL
> + */
> +static int ioctl_querystd(struct v4l2_int_device *s, v4l2_std_id
> *std_id) +{
> +	struct tvp514x_decoder *decoder = s->priv;
> +	enum tvp514x_std current_std;
> +	u8 sync_lock_status, lock_mask;
> +
> +	if (std_id == NULL)
> +		return -EINVAL;
> +
> +	/* get the current standard */
> +	current_std = tvp514x_get_current_std(decoder);
> +	if (current_std == STD_INVALID)
> +		return -EINVAL;
> +
> +	/* check whether signal is locked */
> +	if (tvp514x_read_reg
> +	    (decoder->client, REG_STATUS1, &sync_lock_status))
> +		return -EINVAL;
> +
> +	lock_mask =
> +	    decoder->pdata->input_list[decoder->inputidx].lock_mask;
> +	if (lock_mask != (sync_lock_status & lock_mask))
> +		return -EINVAL;	/* No input detected */
> +
> +	decoder->current_std = current_std;
> +	*std_id = decoder->std_list[current_std].standard.id;
> +
> +	return 0;
> +}
> +
> +/**
> + * ioctl_s_std - V4L2 decoder interface handler for VIDIOC_S_STD
> ioctl + * @s: pointer to standard V4L2 device structure
> + * @std_id: standard V4L2 v4l2_std_id ioctl enum
> + *
> + * If std_id is supported, sets the requested standard. Otherwise,
> returns + * -EINVAL
> + */
> +static int ioctl_s_std(struct v4l2_int_device *s, v4l2_std_id
> *std_id) +{
> +	struct tvp514x_decoder *decoder = s->priv;
> +	int err, i;
> +
> +	if (std_id == NULL)
> +		return -EINVAL;
> +
> +	for (i = 0; i < decoder->num_stds; i++)
> +		if (*std_id & decoder->std_list[i].standard.id)
> +			break;
> +
> +	if (i == decoder->num_stds)
> +		return -EINVAL;
> +
> +	err = tvp514x_write_reg(decoder->client, REG_VIDEO_STD,
> +				decoder->std_list[i].video_std);
> +	if (err)
> +		return err;
> +
> +	decoder->current_std = i;
> +	decoder->pdata->reg_list[REG_VIDEO_STD].val =
> +	    decoder->std_list[i].video_std;
> +
> +	return 0;
> +}
> +
> +/**
> + * ioctl_enum_input - V4L2 decoder interface handler for
> VIDIOC_ENUMINPUT ioctl + * @s: pointer to standard V4L2 device
> structure
> + * @input: standard V4L2 VIDIOC_ENUMINPUT ioctl structure
> + *
> + * If index is valid, returns the description of the input.
> Otherwise, returns + * -EINVAL if any error occurs
> + */
> +static int
> +ioctl_enum_input(struct v4l2_int_device *s, struct v4l2_input
> *input) +{
> +	struct tvp514x_decoder *decoder = s->priv;
> +	int index;
> +
> +	if (input == NULL)
> +		return -EINVAL;
> +
> +	index = input->index;
> +	if ((index >= decoder->pdata->num_inputs) || (index < 0))
> +		return -EINVAL;	/* Index out of bound */
> +
> +	memcpy(input, &decoder->pdata->input_list[index].input,
> +		sizeof(struct v4l2_input));
> +
> +	return 0;
> +}
> +
> +/**
> + * ioctl_s_input - V4L2 decoder interface handler for VIDIOC_S_INPUT
> ioctl + * @s: pointer to standard V4L2 device structure
> + * @index: number of the input
> + *
> + * If index is valid, selects the requested input. Otherwise,
> returns -EINVAL if + * the input is not supported or there is no
> active signal present in the + * selected input.
> + */
> +static int ioctl_s_input(struct v4l2_int_device *s, int index)
> +{
> +	struct tvp514x_decoder *decoder = s->priv;
> +	u8 input_sel;
> +	int err;
> +	enum tvp514x_std current_std = STD_INVALID;
> +	u8 sync_lock_status, lock_mask;
> +	int try_count = LOCK_RETRY_COUNT;
> +
> +	if ((index >= decoder->pdata->num_inputs) || (index < 0))
> +		return -EINVAL;	/* Index out of bound */
> +
> +	/* Get the register value to be written to select the requested
> input */ +	input_sel = decoder->pdata->input_list[index].input_sel;
> +	err = tvp514x_write_reg(decoder->client, REG_INPUT_SEL, input_sel);
> +	if (err)
> +		return err;
> +
> +	decoder->inputidx = index;
> +	decoder->pdata->reg_list[REG_INPUT_SEL].val = input_sel;
> +
> +	/* Clear status */
> +	msleep(LOCK_RETRY_DELAY);
> +	err =
> +	    tvp514x_write_reg(decoder->client, REG_CLEAR_LOST_LOCK, 0x01);
> +	if (err)
> +		return err;
> +
> +	while (try_count-- > 0) {
> +		/* Allow decoder to sync up with new input */
> +		msleep(LOCK_RETRY_DELAY);
> +
> +		/* get the current standard for future reference */
> +		current_std = tvp514x_get_current_std(decoder);
> +		if (current_std == STD_INVALID)
> +			continue;
> +
> +		if (tvp514x_read_reg(decoder->client, REG_STATUS1,
> +					&sync_lock_status))
> +			return -EINVAL;
> +
> +		lock_mask =
> +		    decoder->pdata->input_list[decoder->inputidx].
> +		    lock_mask;
> +		if (lock_mask == (sync_lock_status & lock_mask))
> +			break;	/* Input detected */
> +	}
> +
> +	if ((current_std == STD_INVALID) || (try_count < 0))
> +		return -EINVAL;
> +
> +	decoder->current_std = current_std;
> +
> +	return 0;
> +}
> +
> +/**
> + * ioctl_g_input - V4L2 decoder interface handler for VIDIOC_G_INPUT
> ioctl + * @s: pointer to standard V4L2 device structure
> + * @index: returns the current selected input
> + *
> + * Returns the current selected input. Returns -EINVAL if any error
> occurs + */
> +static int ioctl_g_input(struct v4l2_int_device *s, int *index)
> +{
> +	struct tvp514x_decoder *decoder = s->priv;
> +	int err = -EINVAL, i, inputidx;
> +
> +	if (index == NULL)
> +		return -EINVAL;
> +
> +	/* Search through the input list for active inputs */
> +	inputidx = decoder->inputidx;
> +	for (i = 0; i < decoder->pdata->num_inputs; i++) {
> +		inputidx++;	/* Move to next input */
> +		if (inputidx >= decoder->pdata->num_inputs)
> +			inputidx = 0;	/* fall back to first input */
> +
> +		err = ioctl_s_input(s, inputidx);
> +		if (!err) {
> +			/* Active input found - select it and return success */
> +			*index = inputidx;
> +			return 0;
> +		}
> +	}
> +
> +	return err;
> +}
> +
> +/**
> + * ioctl_queryctrl - V4L2 decoder interface handler for
> VIDIOC_QUERYCTRL ioctl + * @s: pointer to standard V4L2 device
> structure
> + * @qc: standard V4L2 VIDIOC_QUERYCTRL ioctl structure
> + *
> + * If the requested control is supported, returns the control
> information + * from the ctrl_list[] array. Otherwise, returns
> -EINVAL if the + * control is not supported.
> + */
> +static int
> +ioctl_queryctrl(struct v4l2_int_device *s, struct v4l2_queryctrl
> *qctrl) +{
> +	struct tvp514x_decoder *decoder = s->priv;
> +	int id, index;
> +	const struct tvp514x_ctrl_info *control = NULL;
> +
> +	if (qctrl == NULL)
> +		return -EINVAL;
> +
> +	id = qctrl->id;
> +	memset(qctrl, 0, sizeof(struct v4l2_queryctrl));
> +	qctrl->id = id;
> +
> +	for (index = 0; index < decoder->num_ctrls; index++) {
> +		control = &decoder->ctrl_list[index];
> +		if (control->query_ctrl.id == qctrl->id)
> +			break;	/* Match found */
> +	}
> +	if (index == decoder->num_ctrls)
> +		return -EINVAL;	/* Index out of bound */
> +
> +	memcpy(qctrl, &control->query_ctrl, sizeof(struct v4l2_queryctrl));
> +
> +	return 0;
> +}
> +
> +/**
> + * ioctl_g_ctrl - V4L2 decoder interface handler for VIDIOC_G_CTRL
> ioctl + * @s: pointer to standard V4L2 device structure
> + * @vc: standard V4L2 VIDIOC_G_CTRL ioctl structure
> + *
> + * If the requested control is supported, returns the control's
> current + * value from the decoder. Otherwise, returns -EINVAL if the
> control is not + * supported.
> + */
> +static int
> +ioctl_g_ctrl(struct v4l2_int_device *s, struct v4l2_control *ctrl)
> +{
> +	struct tvp514x_decoder *decoder = s->priv;
> +	int err, index;
> +	u8 val;
> +	int value;
> +	const struct tvp514x_ctrl_info *control = NULL;
> +
> +	if (ctrl == NULL)
> +		return -EINVAL;
> +
> +	for (index = 0; index < decoder->num_ctrls; index++) {
> +		control = &decoder->ctrl_list[index];
> +		if (control->query_ctrl.id == ctrl->id)
> +			break;	/* Match found */
> +	}
> +	if (index == decoder->num_ctrls)
> +		return -EINVAL;	/* Index out of bound */
> +
> +	err =
> +	    tvp514x_read_reg(decoder->client, control->reg_address, &val);
> +	if (err < 0)
> +		return err;
> +
> +	/* cross check */
> +	if (val != decoder->pdata->reg_list[control->reg_address].val)
> +		return -EINVAL;	/* Driver & TVP5146/47 setting mismatch */
> +
> +	value = val;
> +	if (V4L2_CID_AUTOGAIN == ctrl->id) {
> +		if ((value & 0x3) == 3)
> +			value = 1;
> +		else
> +			value = 0;
> +	}
> +
> +	if (V4L2_CID_HUE == ctrl->id) {
> +		if (value == 0x7F)
> +			value = 180;
> +		else if (value == 0x80)
> +			value = -180;
> +		else
> +			value = 0;
> +	}
> +
> +	ctrl->value = value;
> +
> +	return err;
> +}
> +
> +/**
> + * ioctl_s_ctrl - V4L2 decoder interface handler for VIDIOC_S_CTRL
> ioctl + * @s: pointer to standard V4L2 device structure
> + * @vc: standard V4L2 VIDIOC_S_CTRL ioctl structure
> + *
> + * If the requested control is supported, sets the control's current
> + * value in HW. Otherwise, returns -EINVAL if the control is not
> supported. + */
> +static int
> +ioctl_s_ctrl(struct v4l2_int_device *s, struct v4l2_control *ctrl)
> +{
> +	struct tvp514x_decoder *decoder = s->priv;
> +	int err, value, index;
> +	const struct tvp514x_ctrl_info *control = NULL;
> +
> +	if (ctrl == NULL)
> +		return -EINVAL;
> +
> +	value = (__s32) ctrl->value;
> +	for (index = 0; index < decoder->num_ctrls; index++) {
> +		control = &decoder->ctrl_list[index];
> +		if (control->query_ctrl.id == ctrl->id)
> +			break;	/* Match found */
> +	}
> +	if (index == decoder->num_ctrls)
> +		return -EINVAL;	/* Index out of bound */
> +
> +	if (V4L2_CID_AUTOGAIN == ctrl->id) {
> +		if (value == 1)
> +			value = 0x0F;
> +		else if (value == 0)
> +			value = 0x0C;
> +		else
> +			return -ERANGE;
> +	} else if (V4L2_CID_HUE == ctrl->id) {
> +		if (value == 180)
> +			value = 0x7F;
> +		else if (value == -180)
> +			value = 0x80;
> +		else if (value == 0)
> +			value = 0;
> +		else
> +			return -ERANGE;
> +	} else {
> +		if ((value < control->query_ctrl.minimum)
> +			|| (value > control->query_ctrl.maximum))
> +			return -ERANGE;
> +	}
> +
> +	err =
> +	    tvp514x_write_reg(decoder->client, control->reg_address,
> +				value);
> +	if (err < 0)
> +		return err;
> +
> +	decoder->pdata->reg_list[control->reg_address].val = value;
> +	return err;
> +}
> +
> +/**
> + * ioctl_enum_fmt_cap - Implement the CAPTURE buffer VIDIOC_ENUM_FMT
> ioctl + * @s: pointer to standard V4L2 device structure
> + * @fmt: standard V4L2 VIDIOC_ENUM_FMT ioctl structure
> + *
> + * Implement the VIDIOC_ENUM_FMT ioctl to enumerate supported
> formats + */
> +static int
> +ioctl_enum_fmt_cap(struct v4l2_int_device *s, struct v4l2_fmtdesc
> *fmt) +{
> +	struct tvp514x_decoder *decoder = s->priv;
> +	int index;
> +
> +	if (fmt == NULL)
> +		return -EINVAL;
> +
> +	index = fmt->index;
> +	if ((index >= decoder->num_fmts) || (index < 0))
> +		return -EINVAL;	/* Index out of bound */
> +
> +	if (fmt->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
> +		return -EINVAL;	/* only capture is supported */
> +
> +	memcpy(fmt, &decoder->fmt_list[index],
> +		sizeof(struct v4l2_fmtdesc));
> +
> +	return 0;
> +}
> +
> +/**
> + * ioctl_try_fmt_cap - Implement the CAPTURE buffer VIDIOC_TRY_FMT
> ioctl + * @s: pointer to standard V4L2 device structure
> + * @f: pointer to standard V4L2 VIDIOC_TRY_FMT ioctl structure
> + *
> + * Implement the VIDIOC_TRY_FMT ioctl for the CAPTURE buffer type.
> This + * ioctl is used to negotiate the image capture size and pixel
> format + * without actually making it take effect.
> + */
> +static int
> +ioctl_try_fmt_cap(struct v4l2_int_device *s, struct v4l2_format *f)
> +{
> +	struct tvp514x_decoder *decoder = s->priv;
> +	int ifmt;
> +	struct v4l2_pix_format *pix;
> +	enum tvp514x_std current_std;
> +
> +	if (f == NULL)
> +		return -EINVAL;
> +
> +	if (f->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
> +		f->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
> +
> +	pix = &f->fmt.pix;
> +
> +	/* Calculate height and width based on current standard */
> +	current_std = tvp514x_get_current_std(decoder);
> +	if (current_std == STD_INVALID)
> +		return -EINVAL;
> +
> +	decoder->current_std = current_std;
> +	pix->width = decoder->std_list[current_std].width;
> +	pix->height = decoder->std_list[current_std].height;
> +
> +	for (ifmt = 0; ifmt < decoder->num_fmts; ifmt++) {
> +		if (pix->pixelformat ==
> +			decoder->fmt_list[ifmt].pixelformat)
> +			break;
> +	}
> +	if (ifmt == decoder->num_fmts)
> +		ifmt = 0;	/* None of the format matched, select default */
> +	pix->pixelformat = decoder->fmt_list[ifmt].pixelformat;
> +
> +	pix->field = V4L2_FIELD_INTERLACED;
> +	pix->bytesperline = pix->width * 2;
> +	pix->sizeimage = pix->bytesperline * pix->height;
> +	pix->colorspace = V4L2_COLORSPACE_SMPTE170M;
> +	pix->priv = 0;
> +
> +	return 0;
> +}
> +
> +/**
> + * ioctl_s_fmt_cap - V4L2 decoder interface handler for VIDIOC_S_FMT
> ioctl + * @s: pointer to standard V4L2 device structure
> + * @f: pointer to standard V4L2 VIDIOC_S_FMT ioctl structure
> + *
> + * If the requested format is supported, configures the HW to use
> that + * format, returns error code if format not supported or HW
> can't be + * correctly configured.
> + */
> +static int
> +ioctl_s_fmt_cap(struct v4l2_int_device *s, struct v4l2_format *f)
> +{
> +	struct tvp514x_decoder *decoder = s->priv;
> +	struct v4l2_pix_format *pix;
> +	int rval;
> +
> +	if (f == NULL)
> +		return -EINVAL;
> +
> +	if (f->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
> +		return -EINVAL;	/* only capture is supported */
> +
> +	pix = &f->fmt.pix;
> +	rval = ioctl_try_fmt_cap(s, f);
> +	if (rval)
> +		return rval;
> +	else
> +		decoder->pix = *pix;
> +
> +	return rval;
> +}
> +
> +/**
> + * ioctl_g_fmt_cap - V4L2 decoder interface handler for
> ioctl_g_fmt_cap + * @s: pointer to standard V4L2 device structure
> + * @f: pointer to standard V4L2 v4l2_format structure
> + *
> + * Returns the decoder's current pixel format in the v4l2_format
> + * parameter.
> + */
> +static int
> +ioctl_g_fmt_cap(struct v4l2_int_device *s, struct v4l2_format *f)
> +{
> +	struct tvp514x_decoder *decoder = s->priv;
> +
> +	if (f == NULL)
> +		return -EINVAL;
> +
> +	if (f->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
> +		return -EINVAL;	/* only capture is supported */
> +
> +	f->fmt.pix = decoder->pix;
> +
> +	return 0;
> +}
> +
> +/**
> + * ioctl_g_parm - V4L2 decoder interface handler for VIDIOC_G_PARM
> ioctl + * @s: pointer to standard V4L2 device structure
> + * @a: pointer to standard V4L2 VIDIOC_G_PARM ioctl structure
> + *
> + * Returns the decoder's video CAPTURE parameters.
> + */
> +static int
> +ioctl_g_parm(struct v4l2_int_device *s, struct v4l2_streamparm *a)
> +{
> +	struct tvp514x_decoder *decoder = s->priv;
> +	struct v4l2_captureparm *cparm;
> +	enum tvp514x_std current_std;
> +
> +	if (a == NULL)
> +		return -EINVAL;
> +
> +	if (a->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
> +		return -EINVAL;	/* only capture is supported */
> +
> +	memset(a, 0, sizeof(*a));
> +	a->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
> +
> +	/* get the current standard */
> +	current_std = tvp514x_get_current_std(decoder);
> +	decoder->current_std = current_std;
> +
> +	cparm = &a->parm.capture;
> +	cparm->capability = V4L2_CAP_TIMEPERFRAME;
> +	cparm->timeperframe
> +	    = decoder->std_list[current_std].standard.frameperiod;
> +
> +	return 0;
> +}
> +
> +/**
> + * ioctl_s_parm - V4L2 decoder interface handler for VIDIOC_S_PARM
> ioctl + * @s: pointer to standard V4L2 device structure
> + * @a: pointer to standard V4L2 VIDIOC_S_PARM ioctl structure
> + *
> + * Configures the decoder to use the input parameters, if possible.
> If + * not possible, returns the appropriate error code.
> + */
> +static int
> +ioctl_s_parm(struct v4l2_int_device *s, struct v4l2_streamparm *a)
> +{
> +	struct tvp514x_decoder *decoder = s->priv;
> +	struct v4l2_fract *timeperframe;
> +	enum tvp514x_std current_std;
> +
> +	if (a == NULL)
> +		return -EINVAL;
> +
> +	if (a->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
> +		return -EINVAL;	/* only capture is supported */
> +
> +	timeperframe = &a->parm.capture.timeperframe;
> +
> +	/* get the current standard */
> +	current_std = tvp514x_get_current_std(decoder);
> +	decoder->current_std = current_std;
> +
> +	*timeperframe =
> +	    decoder->std_list[current_std].standard.frameperiod;
> +
> +	return 0;
> +}
> +
> +/**
> + * ioctl_g_ifparm - V4L2 decoder interface handler for
> vidioc_int_g_ifparm_num + * @s: pointer to standard V4L2 device
> structure
> + * @p: pointer to standard V4L2 vidioc_int_g_ifparm_num ioctl
> structure + *
> + * Gets slave interface parameters.
> + * Calculates the required xclk value to support the requested
> + * clock parameters in p. This value is returned in the p
> + * parameter.
> + */
> +static int ioctl_g_ifparm(struct v4l2_int_device *s, struct
> v4l2_ifparm *p) +{
> +	struct tvp514x_decoder *decoder = s->priv;
> +	int rval;
> +
> +	if (p == NULL)
> +		return -EINVAL;
> +
> +	if (NULL == decoder->pdata->ifparm)
> +		return -EINVAL;
> +
> +	rval = decoder->pdata->ifparm(p);
> +	if (rval) {
> +		dev_err(&decoder->client->dev, "error. Err[%d]\n", rval);
> +		return rval;
> +	}
> +
> +	p->u.bt656.clock_curr = TVP514X_XCLK_BT656;
> +
> +	return 0;
> +}
> +
> +/**
> + * ioctl_g_priv - V4L2 decoder interface handler for
> vidioc_int_g_priv_num + * @s: pointer to standard V4L2 device
> structure
> + * @p: void pointer to hold decoder's private data address
> + *
> + * Returns device's (decoder's) private data area address in p
> parameter + */
> +static int ioctl_g_priv(struct v4l2_int_device *s, void *p)
> +{
> +	struct tvp514x_decoder *decoder = s->priv;
> +
> +	if (NULL == decoder->pdata->priv_data_set)
> +		return -EINVAL;
> +
> +	return decoder->pdata->priv_data_set(p);
> +}
> +
> +/**
> + * ioctl_s_power - V4L2 decoder interface handler for
> vidioc_int_s_power_num + * @s: pointer to standard V4L2 device
> structure
> + * @on: power state to which device is to be set
> + *
> + * Sets devices power state to requrested state, if possible.
> + */
> +static int ioctl_s_power(struct v4l2_int_device *s, enum v4l2_power
> on) +{
> +	struct tvp514x_decoder *decoder = s->priv;
> +	int err = 0;
> +
> +	switch (on) {
> +	case V4L2_POWER_OFF:
> +		/* Power Down Sequence */
> +		err =
> +		    tvp514x_write_reg(decoder->client, REG_OPERATION_MODE,
> +					0x01);
> +		/* Disable mux for TVP5146/47 decoder data path */
> +		if (decoder->pdata->power_set)
> +			err |= decoder->pdata->power_set(on);
> +		break;
> +
> +	case V4L2_POWER_STANDBY:
> +		if (decoder->pdata->power_set)
> +			err = decoder->pdata->power_set(on);
> +		break;
> +
> +	case V4L2_POWER_ON:
> +		/* Enable mux for TVP5146/47 decoder data path */
> +		if (decoder->pdata->power_set)
> +			err = decoder->pdata->power_set(on);
> +
> +		/* Power Up Sequence */
> +		err |=
> +		    tvp514x_write_reg(decoder->client, REG_OPERATION_MODE,
> +					0x01);
> +		err |=
> +		    tvp514x_write_reg(decoder->client, REG_OPERATION_MODE,
> +					0x00);
> +
> +		/* Detect the sensor is not already detected */
> +		if (decoder->state == STATE_NOT_DETECTED) {
> +			err |= tvp514x_detect(decoder);
> +			if (err < 0) {
> +				dev_err(&decoder->client->dev,
> +					"Unable to detect decoder\n");
> +				return err;
> +			}
> +			dev_info(&decoder->client->dev,
> +				 "chip version 0x%.2x detected\n",
> +				 decoder->ver);
> +		}
> +		break;
> +
> +	default:
> +		return -ENODEV;
> +		break;
> +	}
> +
> +	return err;
> +}
> +
> +/**
> + * ioctl_init - V4L2 decoder interface handler for VIDIOC_INT_INIT
> + * @s: pointer to standard V4L2 device structure
> + *
> + * Initialize the decoder device (calls tvp514x_configure())
> + */
> +static int ioctl_init(struct v4l2_int_device *s)
> +{
> +	struct tvp514x_decoder *decoder = s->priv;
> +
> +	/* Set default standard to auto */
> +	decoder->pdata->reg_list[REG_VIDEO_STD].val =
> +	    VIDEO_STD_AUTO_SWITCH_BIT;
> +
> +	return tvp514x_configure(decoder);
> +}
> +
> +/**
> + * ioctl_dev_exit - V4L2 decoder interface handler for
> vidioc_int_dev_exit_num + * @s: pointer to standard V4L2 device
> structure
> + *
> + * Delinitialise the dev. at slave detach. The complement of
> ioctl_dev_init. + */
> +static int ioctl_dev_exit(struct v4l2_int_device *s)
> +{
> +	return 0;
> +}
> +
> +/**
> + * ioctl_dev_init - V4L2 decoder interface handler for
> vidioc_int_dev_init_num + * @s: pointer to standard V4L2 device
> structure
> + *
> + * Initialise the device when slave attaches to the master. Returns
> 0 if + * TVP5146/47 device could be found, otherwise returns
> appropriate error. + */
> +static int ioctl_dev_init(struct v4l2_int_device *s)
> +{
> +	struct tvp514x_decoder *decoder = s->priv;
> +	int err;
> +
> +	err = tvp514x_detect(decoder);
> +	if (err < 0) {
> +		dev_err(&decoder->client->dev,
> +			"Unable to detect decoder\n");
> +		return err;
> +	}
> +
> +	dev_info(&decoder->client->dev,
> +		 "chip version 0x%.2x detected\n", decoder->ver);
> +
> +	return 0;
> +}
> +
> +static struct v4l2_int_ioctl_desc tvp514x_ioctl_desc[] = {
> +	{vidioc_int_dev_init_num, (v4l2_int_ioctl_func*) ioctl_dev_init},
> +	{vidioc_int_dev_exit_num, (v4l2_int_ioctl_func*) ioctl_dev_exit},
> +	{vidioc_int_s_power_num, (v4l2_int_ioctl_func*) ioctl_s_power},
> +	{vidioc_int_g_priv_num, (v4l2_int_ioctl_func*) ioctl_g_priv},
> +	{vidioc_int_g_ifparm_num, (v4l2_int_ioctl_func*) ioctl_g_ifparm},
> +	{vidioc_int_init_num, (v4l2_int_ioctl_func*) ioctl_init},
> +	{vidioc_int_enum_fmt_cap_num,
> +	 (v4l2_int_ioctl_func *) ioctl_enum_fmt_cap},
> +	{vidioc_int_try_fmt_cap_num,
> +	 (v4l2_int_ioctl_func *) ioctl_try_fmt_cap},
> +	{vidioc_int_g_fmt_cap_num,
> +	 (v4l2_int_ioctl_func *) ioctl_g_fmt_cap},
> +	{vidioc_int_s_fmt_cap_num,
> +	 (v4l2_int_ioctl_func *) ioctl_s_fmt_cap},
> +	{vidioc_int_g_parm_num, (v4l2_int_ioctl_func *) ioctl_g_parm},
> +	{vidioc_int_s_parm_num, (v4l2_int_ioctl_func *) ioctl_s_parm},
> +	{vidioc_int_queryctrl_num,
> +	 (v4l2_int_ioctl_func *) ioctl_queryctrl},
> +	{vidioc_int_g_ctrl_num, (v4l2_int_ioctl_func *) ioctl_g_ctrl},
> +	{vidioc_int_s_ctrl_num, (v4l2_int_ioctl_func *) ioctl_s_ctrl},
> +	{vidioc_int_querystd_num, (v4l2_int_ioctl_func *) ioctl_querystd},
> +	{vidioc_int_s_std_num, (v4l2_int_ioctl_func *) ioctl_s_std},
> +	{vidioc_int_enum_input_num,
> +	 (v4l2_int_ioctl_func *) ioctl_enum_input},
> +	{vidioc_int_g_input_num, (v4l2_int_ioctl_func *) ioctl_g_input},
> +	{vidioc_int_s_input_num, (v4l2_int_ioctl_func *) ioctl_s_input},
> +};
> +
> +static struct v4l2_int_slave tvp514x_slave = {
> +	.ioctls = tvp514x_ioctl_desc,
> +	.num_ioctls = ARRAY_SIZE(tvp514x_ioctl_desc),
> +};
> +
> +static struct tvp514x_decoder tvp514x_dev = {
> +	.state = STATE_NOT_DETECTED,
> +
> +	.num_fmts = TVP514X_NUM_FORMATS,
> +	.fmt_list = tvp514x_fmt_list,
> +
> +	.pix = {		/* Default to NTSC 8-bit YUV 422 */
> +		.width = NTSC_NUM_ACTIVE_PIXELS,
> +		.height = NTSC_NUM_ACTIVE_LINES,
> +		.pixelformat = V4L2_PIX_FMT_UYVY,
> +		.field = V4L2_FIELD_INTERLACED,
> +		.bytesperline = NTSC_NUM_ACTIVE_PIXELS * 2,
> +		.sizeimage =
> +		NTSC_NUM_ACTIVE_PIXELS * 2 * NTSC_NUM_ACTIVE_LINES,
> +		.colorspace = V4L2_COLORSPACE_SMPTE170M,
> +		},
> +
> +	.current_std = STD_NTSC_MJ,
> +	.num_stds = TVP514X_NUM_STANDARDS,
> +	.std_list = tvp514x_std_list,
> +
> +	.num_ctrls = TVP514X_NUM_CONTROLS,
> +	.ctrl_list = tvp514x_ctrl_list,
> +
> +	.inputidx = 0,		/* Composite selected */
> +};
> +
> +static struct v4l2_int_device tvp514x_int_device = {
> +	.module = THIS_MODULE,
> +	.name = MODULE_NAME,
> +	.priv = &tvp514x_dev,
> +	.type = v4l2_int_type_slave,
> +	.u = {
> +	      .slave = &tvp514x_slave,
> +	      },
> +};
> +
> +/**
> + * tvp514x_probe - decoder driver i2c probe handler
> + * @client: i2c driver client device structure
> + *
> + * Register decoder as an i2c client device and V4L2
> + * device.
> + */
> +static int
> +tvp514x_probe(struct i2c_client *client, const struct i2c_device_id
> *id) +{
> +	struct tvp514x_decoder *decoder = &tvp514x_dev;
> +	int err;
> +
> +	if (i2c_get_clientdata(client))
> +		return -EBUSY;
> +
> +	decoder->pdata = client->dev.platform_data;
> +	if (!decoder->pdata) {
> +		dev_err(&client->dev, "No platform data\n!!");
> +		return -ENODEV;
> +	}
> +
> +	/* Attach to Master */
> +	strcpy(tvp514x_int_device.u.slave->attach_to,
> decoder->pdata->master); +	decoder->v4l2_int_device =
> &tvp514x_int_device;
> +	decoder->client = client;
> +	i2c_set_clientdata(client, decoder);
> +
> +	/* Register with V4L2 layer as slave device */
> +	err = v4l2_int_device_register(decoder->v4l2_int_device);
> +	if (err) {
> +		i2c_set_clientdata(client, NULL);
> +		dev_err(&client->dev,
> +			"Unable to register to v4l2. Err[%d]\n", err);
> +
> +	} else
> +		dev_info(&client->dev, "Registered to v4l2 master %s!!\n",
> +				decoder->pdata->master);
> +
> +	return 0;
> +}
> +
> +/**
> + * tvp514x_remove - decoder driver i2c remove handler
> + * @client: i2c driver client device structure
> + *
> + * Unregister decoder as an i2c client device and V4L2
> + * device. Complement of tvp514x_probe().
> + */
> +static int __exit tvp514x_remove(struct i2c_client *client)
> +{
> +	struct tvp514x_decoder *decoder = i2c_get_clientdata(client);
> +
> +	if (!client->adapter)
> +		return -ENODEV;	/* our client isn't attached */
> +
> +	v4l2_int_device_unregister(decoder->v4l2_int_device);
> +	i2c_set_clientdata(client, NULL);
> +
> +	return 0;
> +}
> +
> +static const struct i2c_device_id tvp514x_id[] = {
> +	{MODULE_NAME, 0},
> +	{},
> +};
> +
> +MODULE_DEVICE_TABLE(i2c, tvp514x_id);
> +
> +static struct i2c_driver tvp514x_i2c_driver = {
> +	.driver = {
> +		   .name = MODULE_NAME,
> +		   .owner = THIS_MODULE,
> +		   },
> +	.probe = tvp514x_probe,
> +	.remove = __exit_p(tvp514x_remove),
> +	.id_table = tvp514x_id,
> +};
> +
> +/**
> + * tvp514x_init
> + *
> + * Module init function
> + */
> +static int __init tvp514x_init(void)
> +{
> +	int err;
> +
> +	err = i2c_add_driver(&tvp514x_i2c_driver);
> +	if (err) {
> +		printk(KERN_ERR "Failed to register " MODULE_NAME ".\n");
> +		return err;
> +	}
> +	return 0;
> +}
> +
> +/**
> + * tvp514x_cleanup
> + *
> + * Module exit function
> + */
> +static void __exit tvp514x_cleanup(void)
> +{
> +	i2c_del_driver(&tvp514x_i2c_driver);
> +}
> +
> +late_initcall(tvp514x_init);
> +module_exit(tvp514x_cleanup);
> +
> +MODULE_AUTHOR("Texas Instruments");
> +MODULE_DESCRIPTION("TVP514x linux decoder driver");
> +MODULE_LICENSE("GPL");
> diff --git a/include/media/tvp514x.h b/include/media/tvp514x.h
> new file mode 100644
> index 0000000..4433b96
> --- /dev/null
> +++ b/include/media/tvp514x.h
> @@ -0,0 +1,406 @@
> +/*
> + * drivers/media/video/tvp514x.h
> + *
> + * Copyright (C) 2008 Texas Instruments Inc
> + *
> + * This package is free software; you can redistribute it and/or
> modify + * it under the terms of the GNU General Public License
> version 2 as + * published by the Free Software Foundation.
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
> +#ifndef _TVP514X_H
> +#define _TVP514X_H
> +
> +/*
> + * TVP5146/47 registers
> + */
> +#define REG_INPUT_SEL			(0x00)
> +#define REG_AFE_GAIN_CTRL		(0x01)
> +#define REG_VIDEO_STD			(0x02)
> +#define REG_OPERATION_MODE		(0x03)
> +#define REG_AUTOSWITCH_MASK		(0x04)
> +
> +#define REG_COLOR_KILLER		(0x05)
> +#define REG_LUMA_CONTROL1		(0x06)
> +#define REG_LUMA_CONTROL2		(0x07)
> +#define REG_LUMA_CONTROL3		(0x08)
> +
> +#define REG_BRIGHTNESS			(0x09)
> +#define REG_CONTRAST			(0x0A)
> +#define REG_SATURATION			(0x0B)
> +#define REG_HUE				(0x0C)
> +
> +#define REG_CHROMA_CONTROL1		(0x0D)
> +#define REG_CHROMA_CONTROL2		(0x0E)
> +
> +/* 0x0F Reserved */
> +
> +#define REG_COMP_PR_SATURATION		(0x10)
> +#define REG_COMP_Y_CONTRAST		(0x11)
> +#define REG_COMP_PB_SATURATION		(0x12)
> +
> +/* 0x13 Reserved */
> +
> +#define REG_COMP_Y_BRIGHTNESS		(0x14)
> +
> +/* 0x15 Reserved */
> +
> +#define REG_AVID_START_PIXEL_LSB	(0x16)
> +#define REG_AVID_START_PIXEL_MSB	(0x17)
> +#define REG_AVID_STOP_PIXEL_LSB		(0x18)
> +#define REG_AVID_STOP_PIXEL_MSB		(0x19)
> +
> +#define REG_HSYNC_START_PIXEL_LSB	(0x1A)
> +#define REG_HSYNC_START_PIXEL_MSB	(0x1B)
> +#define REG_HSYNC_STOP_PIXEL_LSB	(0x1C)
> +#define REG_HSYNC_STOP_PIXEL_MSB	(0x1D)
> +
> +#define REG_VSYNC_START_LINE_LSB	(0x1E)
> +#define REG_VSYNC_START_LINE_MSB	(0x1F)
> +#define REG_VSYNC_STOP_LINE_LSB		(0x20)
> +#define REG_VSYNC_STOP_LINE_MSB		(0x21)
> +
> +#define REG_VBLK_START_LINE_LSB		(0x22)
> +#define REG_VBLK_START_LINE_MSB		(0x23)
> +#define REG_VBLK_STOP_LINE_LSB		(0x24)
> +#define REG_VBLK_STOP_LINE_MSB		(0x25)
> +
> +/* 0x26 - 0x27 Reserved */
> +
> +#define REG_FAST_SWTICH_CONTROL		(0x28)
> +
> +/* 0x29 Reserved */
> +
> +#define REG_FAST_SWTICH_SCART_DELAY	(0x2A)
> +
> +/* 0x2B Reserved */
> +
> +#define REG_SCART_DELAY			(0x2C)
> +#define REG_CTI_DELAY			(0x2D)
> +#define REG_CTI_CONTROL			(0x2E)
> +
> +/* 0x2F - 0x31 Reserved */
> +
> +#define REG_SYNC_CONTROL		(0x32)
> +#define REG_OUTPUT_FORMATTER1		(0x33)
> +#define REG_OUTPUT_FORMATTER2		(0x34)
> +#define REG_OUTPUT_FORMATTER3		(0x35)
> +#define REG_OUTPUT_FORMATTER4		(0x36)
> +#define REG_OUTPUT_FORMATTER5		(0x37)
> +#define REG_OUTPUT_FORMATTER6		(0x38)
> +#define REG_CLEAR_LOST_LOCK		(0x39)
> +
> +#define REG_STATUS1			(0x3A)
> +#define REG_STATUS2			(0x3B)
> +
> +#define REG_AGC_GAIN_STATUS_LSB		(0x3C)
> +#define REG_AGC_GAIN_STATUS_MSB		(0x3D)
> +
> +/* 0x3E Reserved */
> +
> +#define REG_VIDEO_STD_STATUS		(0x3F)
> +#define REG_GPIO_INPUT1			(0x40)
> +#define REG_GPIO_INPUT2			(0x41)
> +
> +/* 0x42 - 0x45 Reserved */
> +
> +#define REG_AFE_COARSE_GAIN_CH1		(0x46)
> +#define REG_AFE_COARSE_GAIN_CH2		(0x47)
> +#define REG_AFE_COARSE_GAIN_CH3		(0x48)
> +#define REG_AFE_COARSE_GAIN_CH4		(0x49)
> +
> +#define REG_AFE_FINE_GAIN_PB_B_LSB	(0x4A)
> +#define REG_AFE_FINE_GAIN_PB_B_MSB	(0x4B)
> +#define REG_AFE_FINE_GAIN_Y_G_CHROMA_LSB	(0x4C)
> +#define REG_AFE_FINE_GAIN_Y_G_CHROMA_MSB	(0x4D)
> +#define REG_AFE_FINE_GAIN_PR_R_LSB	(0x4E)
> +#define REG_AFE_FINE_GAIN_PR_R_MSB	(0x4F)
> +#define REG_AFE_FINE_GAIN_CVBS_LUMA_LSB	(0x50)
> +#define REG_AFE_FINE_GAIN_CVBS_LUMA_MSB	(0x51)
> +
> +/* 0x52 - 0x68 Reserved */
> +
> +#define REG_FBIT_VBIT_CONTROL1		(0x69)
> +
> +/* 0x6A - 0x6B Reserved */
> +
> +#define REG_BACKEND_AGC_CONTROL		(0x6C)
> +
> +/* 0x6D - 0x6E Reserved */
> +
> +#define REG_AGC_DECREMENT_SPEED_CONTROL	(0x6F)
> +#define REG_ROM_VERSION			(0x70)
> +
> +/* 0x71 - 0x73 Reserved */
> +
> +#define REG_AGC_WHITE_PEAK_PROCESSING	(0x74)
> +#define REG_FBIT_VBIT_CONTROL2		(0x75)
> +#define REG_VCR_TRICK_MODE_CONTROL	(0x76)
> +#define REG_HORIZONTAL_SHAKE_INCREMENT	(0x77)
> +#define REG_AGC_INCREMENT_SPEED		(0x78)
> +#define REG_AGC_INCREMENT_DELAY		(0x79)
> +
> +/* 0x7A - 0x7F Reserved */
> +
> +#define REG_CHIP_ID_MSB			(0x80)
> +#define REG_CHIP_ID_LSB			(0x81)
> +
> +/* 0x82 Reserved */
> +
> +#define REG_CPLL_SPEED_CONTROL		(0x83)
> +
> +/* 0x84 - 0x96 Reserved */
> +
> +#define REG_STATUS_REQUEST		(0x97)
> +
> +/* 0x98 - 0x99 Reserved */
> +
> +#define REG_VERTICAL_LINE_COUNT_LSB	(0x9A)
> +#define REG_VERTICAL_LINE_COUNT_MSB	(0x9B)
> +
> +/* 0x9C - 0x9D Reserved */
> +
> +#define REG_AGC_DECREMENT_DELAY		(0x9E)
> +
> +/* 0x9F - 0xB0 Reserved */
> +
> +#define REG_VDP_TTX_FILTER_1_MASK1	(0xB1)
> +#define REG_VDP_TTX_FILTER_1_MASK2	(0xB2)
> +#define REG_VDP_TTX_FILTER_1_MASK3	(0xB3)
> +#define REG_VDP_TTX_FILTER_1_MASK4	(0xB4)
> +#define REG_VDP_TTX_FILTER_1_MASK5	(0xB5)
> +#define REG_VDP_TTX_FILTER_2_MASK1	(0xB6)
> +#define REG_VDP_TTX_FILTER_2_MASK2	(0xB7)
> +#define REG_VDP_TTX_FILTER_2_MASK3	(0xB8)
> +#define REG_VDP_TTX_FILTER_2_MASK4	(0xB9)
> +#define REG_VDP_TTX_FILTER_2_MASK5	(0xBA)
> +#define REG_VDP_TTX_FILTER_CONTROL	(0xBB)
> +#define REG_VDP_FIFO_WORD_COUNT		(0xBC)
> +#define REG_VDP_FIFO_INTERRUPT_THRLD	(0xBD)
> +
> +/* 0xBE Reserved */
> +
> +#define REG_VDP_FIFO_RESET		(0xBF)
> +#define REG_VDP_FIFO_OUTPUT_CONTROL	(0xC0)
> +#define REG_VDP_LINE_NUMBER_INTERRUPT	(0xC1)
> +#define REG_VDP_PIXEL_ALIGNMENT_LSB	(0xC2)
> +#define REG_VDP_PIXEL_ALIGNMENT_MSB	(0xC3)
> +
> +/* 0xC4 - 0xD5 Reserved */
> +
> +#define REG_VDP_LINE_START		(0xD6)
> +#define REG_VDP_LINE_STOP		(0xD7)
> +#define REG_VDP_GLOBAL_LINE_MODE	(0xD8)
> +#define REG_VDP_FULL_FIELD_ENABLE	(0xD9)
> +#define REG_VDP_FULL_FIELD_MODE		(0xDA)
> +
> +/* 0xDB - 0xDF Reserved */
> +
> +#define REG_VBUS_DATA_ACCESS_NO_VBUS_ADDR_INCR	(0xE0)
> +#define REG_VBUS_DATA_ACCESS_VBUS_ADDR_INCR	(0xE1)
> +#define REG_FIFO_READ_DATA			(0xE2)
> +
> +/* 0xE3 - 0xE7 Reserved */
> +
> +#define REG_VBUS_ADDRESS_ACCESS1	(0xE8)
> +#define REG_VBUS_ADDRESS_ACCESS2	(0xE9)
> +#define REG_VBUS_ADDRESS_ACCESS3	(0xEA)
> +
> +/* 0xEB - 0xEF Reserved */
> +
> +#define REG_INTERRUPT_RAW_STATUS0	(0xF0)
> +#define REG_INTERRUPT_RAW_STATUS1	(0xF1)
> +#define REG_INTERRUPT_STATUS0		(0xF2)
> +#define REG_INTERRUPT_STATUS1		(0xF3)
> +#define REG_INTERRUPT_MASK0		(0xF4)
> +#define REG_INTERRUPT_MASK1		(0xF5)
> +#define REG_INTERRUPT_CLEAR0		(0xF6)
> +#define REG_INTERRUPT_CLEAR1		(0xF7)
> +
> +/* 0xF8 - 0xFF Reserved */
> +
> +/*
> + * Mask and bit definitions of TVP5146/47 registers
> + */
> +/* The ID values we are looking for */
> +#define TVP514X_CHIP_ID_MSB		(0x51)
> +#define TVP5146_CHIP_ID_LSB		(0x46)
> +#define TVP5147_CHIP_ID_LSB		(0x47)
> +
> +#define VIDEO_STD_MASK			(0x07)
> +#define VIDEO_STD_AUTO_SWITCH_BIT	(0x00)
> +#define VIDEO_STD_NTSC_MJ_BIT		(0x01)
> +#define VIDEO_STD_PAL_BDGHIN_BIT	(0x02)
> +#define VIDEO_STD_PAL_M_BIT		(0x03)
> +#define VIDEO_STD_PAL_COMBINATION_N_BIT	(0x04)
> +#define VIDEO_STD_NTSC_4_43_BIT		(0x05)
> +#define VIDEO_STD_SECAM_BIT		(0x06)
> +#define VIDEO_STD_PAL_60_BIT		(0x07)
> +
> +/*
> + * Other macros
> + */
> +#define TVP514X_MODULE_NAME		"tvp514x"
> +#define TVP514X_I2C_DELAY		(3)
> +#define I2C_RETRY_COUNT			(5)
> +#define LOCK_RETRY_COUNT		(3)
> +#define LOCK_RETRY_DELAY		(200)
> +
> +#define TOK_WRITE			(0)	/* token for write operation */
> +#define TOK_TERM			(1)	/* terminating token */
> +#define TOK_DELAY			(2)	/* delay token for reg list */
> +#define TOK_SKIP			(3)	/* token to skip a register */
> +
> +#define TVP514X_XCLK_BT656		(27000000)
> +
> +/* Number of pixels and number of lines per frame for different
> standards */ +#define NTSC_NUM_ACTIVE_PIXELS		(720)
> +#define NTSC_NUM_ACTIVE_LINES		(480)
> +#define PAL_NUM_ACTIVE_PIXELS		(720)
> +#define PAL_NUM_ACTIVE_LINES		(576)
> +
> +/**
> + * enum tvp514x_std - enum for supported standards
> + */
> +enum tvp514x_std {
> +	STD_NTSC_MJ = 0,
> +	STD_PAL_BDGHIN,
> +	STD_INVALID
> +};
> +
> +/**
> + * enum tvp514x_state - enum for different decoder states
> + */
> +enum tvp514x_state {
> +	STATE_NOT_DETECTED,
> +	STATE_DETECTED
> +};
> +
> +/**
> + * struct tvp514x_reg - Structure for TVP5146/47 register
> initialization values + * @token - Token: TOK_WRITE, TOK_TERM etc..
> + * @reg - Register offset
> + * @val - Register Value for TOK_WRITE or delay in ms for TOK_DELAY
> + */
> +struct tvp514x_reg {
> +	u8 token;
> +	u8 reg;
> +	u32 val;
> +};
> +
> +/**
> + * struct tvp514x_std_info - Structure to store standard
> informations + * @width: Line width in pixels
> + * @height:Number of active lines
> + * @video_std: Value to write in REG_VIDEO_STD register
> + * @standard: v4l2 standard structure information
> + */
> +struct tvp514x_std_info {
> +	unsigned long width;
> +	unsigned long height;
> +	u8 video_std;
> +	struct v4l2_standard standard;
> +};
> +
> +/**
> + * struct tvp514x_ctrl_info - Information regarding supported
> controls + * @reg_address: Register offset of control register
> + * @query_ctrl: v4l2 query control information
> + */
> +struct tvp514x_ctrl_info {
> +	u8 reg_address;
> +	struct v4l2_queryctrl query_ctrl;
> +};
> +
> +/**
> + * struct tvp514x_input_info - Information regarding supported
> inputs + * @input_sel: Input select register
> + * @lock_mask: lock mask - depends on Svideo/CVBS
> + * @input: v4l2 input information
> + */
> +struct tvp514x_input_info {
> +	u8 input_sel;
> +	u8 lock_mask;
> +	struct v4l2_input input;
> +};
> +
> +/**
> + * struct tvp514x_platform_data - Platform data values and access
> functions + * @power_set: Power state access function, zero is off,
> non-zero is on. + * @ifparm: Interface parameters access function
> + * @priv_data_set: Device private data (pointer) access function
> + * @reg_list: The board dependent driver should fill the default
> value for + *            required registers depending on board
> layout. The TVP5146/47 + *            driver will update this
> register list for the registers + *            whose values should be
> maintained across open()/close() like + *            setting
> brightness as defined in V4L2.
> + *            The register list should be in the same order as
> defined in + *            TVP5146/47 datasheet including reserved
> registers. As of now + *            the driver expects the size of
> this list to be a minimum of + *            57 + 1 (upto regsiter
> REG_CLEAR_LOST_LOCK).
> + *            The last member should be of the list should be
> + *            {TOK_TERM, 0, 0} to indicate the end of register list.
> + * @num_inputs: Number of input connection in board
> + * @input_list: Input information list for num_inputs
> + */
> +struct tvp514x_platform_data {
> +	char *master;
> +	int (*power_set) (enum v4l2_power on);
> +	int (*ifparm) (struct v4l2_ifparm *p);
> +	int (*priv_data_set) (void *);
> +
> +	struct tvp514x_reg *reg_list;
> +
> +	int num_inputs;
> +	const struct tvp514x_input_info *input_list;
> +};
> +
> +/**
> + * struct tvp514x_decoded - TVP5146/47 decoder object
> + * @v4l2_int_device: Slave handle
> + * @pdata: Board specific
> + * @client: I2C client data
> + * @ver: Chip version
> + * @state: TVP5146/47 decoder state - detected or not-detected
> + * @pix: Current pixel format
> + * @num_fmts: Number of formats
> + * @fmt_list: Format list
> + * @current_std: Current standard
> + * @num_stds: Number of standards
> + * @std_list: Standards list
> + * @num_ctrls: Number of controls
> + * @ctrl_list: Control list
> + */
> +struct tvp514x_decoder {
> +	struct v4l2_int_device *v4l2_int_device;
> +	const struct tvp514x_platform_data *pdata;
> +	struct i2c_client *client;
> +
> +	int ver;
> +	enum tvp514x_state state;
> +
> +	struct v4l2_pix_format pix;
> +	int num_fmts;
> +	const struct v4l2_fmtdesc *fmt_list;
> +
> +	enum tvp514x_std current_std;
> +	int num_stds;
> +	struct tvp514x_std_info *std_list;
> +
> +	int num_ctrls;
> +	const struct tvp514x_ctrl_info *ctrl_list;
> +
> +	int inputidx;
> +};
> +
> +#endif				/* ifndef _TVP514X_H */
> --
> 1.5.6
>
> --
> video4linux-list mailing list
> Unsubscribe
> mailto:video4linux-list-request@redhat.com?subject=unsubscribe
> https://www.redhat.com/mailman/listinfo/video4linux-list


--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
