Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr16.xs4all.nl ([194.109.24.36]:2898 "EHLO
	smtp-vbr16.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752792Ab0GIKre (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 9 Jul 2010 06:47:34 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: "Matti J. Aaltonen" <matti.j.aaltonen@nokia.com>
Subject: Re: [PATCH v4 2/5] MFD: WL1273 FM Radio: MFD driver for the FM radio.
Date: Fri, 9 Jul 2010 12:49:55 +0200
Cc: linux-media@vger.kernel.org, eduardo.valentin@nokia.com
References: <1275647663-20650-1-git-send-email-matti.j.aaltonen@nokia.com> <1275647663-20650-2-git-send-email-matti.j.aaltonen@nokia.com> <1275647663-20650-3-git-send-email-matti.j.aaltonen@nokia.com>
In-Reply-To: <1275647663-20650-3-git-send-email-matti.j.aaltonen@nokia.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-6"
Content-Transfer-Encoding: 7bit
Message-Id: <201007091249.55567.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Matti,

My apologies for the long delay in reviewing. But here is (finally!) my
review of this code.

On Friday 04 June 2010 12:34:20 Matti J. Aaltonen wrote:
> This is a parent driver for two child drivers: the V4L2 driver and
> the ALSA codec driver. The MFD part provides the I2C communication
> to the device and a couple of functions that are called from both
> children.
> 
> Signed-off-by: Matti J. Aaltonen <matti.j.aaltonen@nokia.com>
> ---
>  drivers/mfd/Kconfig             |    6 +
>  drivers/mfd/Makefile            |    2 +
>  drivers/mfd/wl1273-core.c       |  616 +++++++++++++++++++++++++++++++++++++++
>  include/linux/mfd/wl1273-core.h |  326 +++++++++++++++++++++
>  4 files changed, 950 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/mfd/wl1273-core.c
>  create mode 100644 include/linux/mfd/wl1273-core.h
> 
> diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
> index 413576a..5998a94 100644
> --- a/drivers/mfd/Kconfig
> +++ b/drivers/mfd/Kconfig
> @@ -135,6 +135,12 @@ config TWL4030_CODEC
>  	select MFD_CORE
>  	default n
>  
> +config WL1273_CORE
> +	bool
> +	depends on I2C
> +	select MFD_CORE
> +	default n
> +
>  config MFD_TMIO
>  	bool
>  	default n
> diff --git a/drivers/mfd/Makefile b/drivers/mfd/Makefile
> index 78295d6..46e611d 100644
> --- a/drivers/mfd/Makefile
> +++ b/drivers/mfd/Makefile
> @@ -30,6 +30,8 @@ obj-$(CONFIG_TWL4030_CORE)	+= twl-core.o twl4030-irq.o twl6030-irq.o
>  obj-$(CONFIG_TWL4030_POWER)    += twl4030-power.o
>  obj-$(CONFIG_TWL4030_CODEC)	+= twl4030-codec.o
>  
> +obj-$(CONFIG_WL1273_CORE)	+= wl1273-core.o
> +
>  obj-$(CONFIG_MFD_MC13783)	+= mc13783-core.o
>  
>  obj-$(CONFIG_MFD_CORE)		+= mfd-core.o
> diff --git a/drivers/mfd/wl1273-core.c b/drivers/mfd/wl1273-core.c
> new file mode 100644
> index 0000000..6c7dbba
> --- /dev/null
> +++ b/drivers/mfd/wl1273-core.c
> @@ -0,0 +1,616 @@
> +/*
> + * MFD driver for wl1273 FM radio and audio codec submodules.
> + *
> + * Author:	Matti Aaltonen <matti.j.aaltonen@nokia.com>
> + *
> + * Copyright:   (C) 2010 Nokia Corporation
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful, but
> + * WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
> + * General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program; if not, write to the Free Software
> + * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
> + * 02110-1301 USA
> + *
> + */
> +
> +#undef DEBUG
> +
> +#include <asm/unaligned.h>
> +#include <linux/completion.h>
> +#include <linux/delay.h>
> +#include <linux/i2c.h>
> +#include <linux/interrupt.h>
> +#include <linux/module.h>
> +#include <linux/types.h>
> +#include <linux/kernel.h>
> +#include <linux/fs.h>
> +#include <linux/platform_device.h>
> +#include <linux/mfd/core.h>
> +#include <linux/mfd/wl1273-core.h>
> +#include <media/v4l2-common.h>
> +
> +#define DRIVER_DESC "WL1273 FM Radio Core"
> +
> +#define WL1273_IRQ_MASK	 (WL1273_FR_EVENT		|	\
> +			  WL1273_POW_ENB_EVENT)
> +
> +static const struct band_info bands[] = {
> +	/* USA & Europe */
> +	{
> +		.bottom_frequency	= 87500,
> +		.top_frequency		= 108000,
> +		.band			= V4L2_FM_BAND_OTHER,
> +	},
> +	/* Japan */
> +	{
> +		.bottom_frequency	= 76000,
> +		.top_frequency		= 90000,
> +		.band			= V4L2_FM_BAND_JAPAN,
> +	},
> +};
> +
> +/*
> + * static unsigned char radio_band - Band
> + *
> + * The bands are 0=Japan, 1=USA-Europe. USA-Europe is the default.
> + */
> +static unsigned char radio_band = 1;
> +module_param(radio_band, byte, 0);
> +MODULE_PARM_DESC(radio_band, "Band: 0=Japan, 1=USA-Europe*");
> +
> +/*
> + * static unsigned int rds_buf - the number of RDS buffer blocks used.
> + *
> + * The default number is 100.
> + */
> +static unsigned int rds_buf = 100;
> +module_param(rds_buf, uint, 0);
> +MODULE_PARM_DESC(rds_buf, "RDS buffer entries: *100*");
> +
> +int wl1273_fm_read_reg(struct wl1273_core *core, u8 reg, u16 *value)
> +{
> +	struct i2c_client *client = core->i2c_dev;
> +	u8 b[2];
> +	int r;
> +
> +	r = i2c_smbus_read_i2c_block_data(client, reg, 2, b);
> +	if (r != 2) {
> +		dev_err(&client->dev, "%s: Read: %d fails.\n", __func__, reg);
> +		return -EREMOTEIO;
> +	}
> +
> +	*value = (u16)b[0] << 8 | b[1];
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL(wl1273_fm_read_reg);
> +
> +int wl1273_fm_write_cmd(struct wl1273_core *core, u8 cmd, u16 param)
> +{
> +	struct i2c_client *client = core->i2c_dev;
> +	u8 buf[] = { (param >> 8) & 0xff, param & 0xff };
> +	int r;
> +
> +	r = i2c_smbus_write_i2c_block_data(client, cmd, 2, buf);
> +	if (r) {
> +		dev_err(&client->dev, "%s: Cmd: %d fails.\n", __func__, cmd);
> +		return r;
> +	}
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL(wl1273_fm_write_cmd);
> +
> +int wl1273_fm_write_data(struct wl1273_core *core, u8 *data, u16 len)
> +{
> +	struct i2c_client *client = core->i2c_dev;
> +	struct i2c_msg msg[1];
> +	int r;
> +
> +	msg[0].addr = client->addr;
> +	msg[0].flags = 0;
> +	msg[0].buf = data;
> +	msg[0].len = len;
> +
> +	r = i2c_transfer(client->adapter, msg, 1);
> +
> +	if (r != 1) {
> +		dev_err(&client->dev, "%s: write error.\n", __func__);
> +		return -EREMOTEIO;
> +	}
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL(wl1273_fm_write_data);
> +
> +/**
> + * wl1273_fm_set_audio() -	Set audio mode.
> + * @core:			A pointer to the device struct.
> + * @new_mode:			The new audio mode.
> + *
> + * Audio modes are WL1273_AUDIO_DIGITAL and WL1273_AUDIO_ANALOG.
> + */
> +int wl1273_fm_set_audio(struct wl1273_core *core, unsigned int new_mode)
> +{
> +	int r = 0;
> +
> +	if (core->mode == WL1273_MODE_OFF ||
> +	    core->mode == WL1273_MODE_SUSPENDED)
> +		return -EPERM;
> +
> +	if (core->mode == WL1273_MODE_RX && new_mode == WL1273_AUDIO_DIGITAL) {
> +		r = wl1273_fm_write_cmd(core, WL1273_PCM_MODE_SET,
> +					WL1273_PCM_DEF_MODE);
> +		if (r)
> +			goto out;
> +
> +		r = wl1273_fm_write_cmd(core, WL1273_I2S_MODE_CONFIG_SET,
> +					core->i2s_mode);
> +		if (r)
> +			goto out;
> +
> +		r = wl1273_fm_write_cmd(core, WL1273_AUDIO_ENABLE,
> +					WL1273_AUDIO_ENABLE_I2S);
> +		if (r)
> +			goto out;
> +
> +	} else if (core->mode == WL1273_MODE_RX &&
> +		   new_mode == WL1273_AUDIO_ANALOG) {
> +		r = wl1273_fm_write_cmd(core, WL1273_AUDIO_ENABLE,
> +					WL1273_AUDIO_ENABLE_ANALOG);
> +		if (r)
> +			goto out;
> +
> +	} else if (core->mode == WL1273_MODE_TX &&
> +		   new_mode == WL1273_AUDIO_DIGITAL) {
> +		r = wl1273_fm_write_cmd(core, WL1273_I2S_MODE_CONFIG_SET,
> +					core->i2s_mode);
> +		if (r)
> +			goto out;
> +
> +		r = wl1273_fm_write_cmd(core, WL1273_AUDIO_IO_SET,
> +					WL1273_AUDIO_IO_SET_I2S);
> +		if (r)
> +			goto out;
> +
> +	} else if (core->mode == WL1273_MODE_TX &&
> +		   new_mode == WL1273_AUDIO_ANALOG) {
> +		r = wl1273_fm_write_cmd(core, WL1273_AUDIO_IO_SET,
> +					WL1273_AUDIO_IO_SET_ANALOG);
> +		if (r)
> +			goto out;
> +	}
> +
> +	core->audio_mode = new_mode;
> +
> +out:
> +	return r;
> +}
> +EXPORT_SYMBOL(wl1273_fm_set_audio);
> +
> +/**
> + * wl1273_fm_set_volume() -	Set volume.
> + * @core:			A pointer to the device struct.
> + * @volume:			The new volume value.
> + */
> +int wl1273_fm_set_volume(struct wl1273_core *core, unsigned int volume)
> +{
> +	u16 val;
> +	int r;
> +
> +	if (volume > WL1273_MAX_VOLUME)
> +		return -EINVAL;
> +
> +	if (core->volume == volume)
> +		return 0;
> +
> +	val = volume;
> +	r = wl1273_fm_read_reg(core, WL1273_VOLUME_SET, &val);
> +	if (r)
> +		return r;
> +
> +	core->volume = volume;
> +	return 0;
> +}
> +EXPORT_SYMBOL(wl1273_fm_set_volume);
> +
> +#define WL1273_RDS_FIFO_EMPTY(status)	(!(1 << 6 &  status))
> +
> +#define WL1273_RDS_CORRECTABLE_ERROR	(1 << 3)
> +#define WL1273_RDS_UNCORRECTABLE_ERROR	(1 << 4)
> +
> +static int wl1273_fm_rds(struct wl1273_core *core)
> +{
> +	struct i2c_client *client = core->i2c_dev;
> +	struct device *dev = &client->dev;
> +	struct v4l2_rds_data rds = { 0, 0, 0 };
> +	struct i2c_msg msg[] = {
> +		{
> +			.addr = client->addr,
> +			.flags = 0,
> +			.buf = b0,
> +			.len = 1
> +		},
> +		{
> +			.addr = client->addr,
> +			.flags = I2C_M_RD,
> +			.buf = (u8 *) &rds,
> +			.len = 3
> +		}
> +	};
> +	u8 b0[] = { WL1273_RDS_DATA_GET }, status;
> +	u16 val;
> +	int r;
> +
> +	r = wl1273_fm_read_reg(core, WL1273_RDS_SYNC_GET, &val);
> +	if (r)
> +		return r;
> +
> +	/* Is RDS decoder synchronized? */
> +	if ((val & 0x01) == 0)
> +		return -EAGAIN;
> +
> +	/* copy all four RDS blocks to internal buffer */
> +	do {
> +		r = i2c_transfer(client->adapter, msg, 2);
> +		if (r != 2) {
> +			dev_err(dev, WL1273_FM_DRIVER_NAME
> +				": %s: read_rds error r == %i)\n",
> +				__func__, r);
> +		}
> +
> +		status = rds.block;
> +
> +		if (WL1273_RDS_FIFO_EMPTY(status))
> +			break;
> +
> +		/* copy RDS block to internal buffer */
> +		memcpy(&core->buffer[core->wr_index], &rds, 3);
> +		core->wr_index += 3;
> +
> +		/* copy the error bits to standard positions */
> +		if (WL1273_RDS_UNCORRECTABLE_ERROR & status) {
> +			rds.block |= V4L2_RDS_BLOCK_ERROR;
> +			rds.block &= ~V4L2_RDS_BLOCK_CORRECTED;
> +		} else if  (WL1273_RDS_CORRECTABLE_ERROR & status) {
> +			rds.block &= ~V4L2_RDS_BLOCK_ERROR;
> +			rds.block |= V4L2_RDS_BLOCK_CORRECTED;
> +		} else {
> +			rds.block &= ~V4L2_RDS_BLOCK_ERROR;
> +			rds.block &= ~V4L2_RDS_BLOCK_CORRECTED;
> +		}

Have you verified that bits 0-2 correctly match the block numbering as defined
by the spec? You should also copy bits 0-2 into bits 3-5. This is for backwards
compatibility. Eventually we should be able to drop this, but for now we still
need to do this.

<snip>

Regards,

          Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG, part of Cisco
