Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr13.xs4all.nl ([194.109.24.33]:3141 "EHLO
	smtp-vbr13.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753817Ab0GIK7T (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 9 Jul 2010 06:59:19 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: "Matti J. Aaltonen" <matti.j.aaltonen@nokia.com>
Subject: Re: [PATCH v4 4/5] V4L2: WL1273 FM Radio: Controls for the FM radio.
Date: Fri, 9 Jul 2010 13:01:40 +0200
Cc: linux-media@vger.kernel.org, eduardo.valentin@nokia.com
References: <1275647663-20650-1-git-send-email-matti.j.aaltonen@nokia.com> <1275647663-20650-4-git-send-email-matti.j.aaltonen@nokia.com> <1275647663-20650-5-git-send-email-matti.j.aaltonen@nokia.com>
In-Reply-To: <1275647663-20650-5-git-send-email-matti.j.aaltonen@nokia.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-6"
Content-Transfer-Encoding: 7bit
Message-Id: <201007091301.40295.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Friday 04 June 2010 12:34:22 Matti J. Aaltonen wrote:
> This file implements V4L2 controls for using the Texas Instruments
> WL1273 FM Radio.
> 
> Signed-off-by: Matti J. Aaltonen <matti.j.aaltonen@nokia.com>
> ---
>  drivers/media/radio/Kconfig        |   15 +
>  drivers/media/radio/Makefile       |    1 +
>  drivers/media/radio/radio-wl1273.c | 1907 ++++++++++++++++++++++++++++++++++++
>  3 files changed, 1923 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/media/radio/radio-wl1273.c
> 
> diff --git a/drivers/media/radio/Kconfig b/drivers/media/radio/Kconfig
> index 83567b8..209fd37 100644
> --- a/drivers/media/radio/Kconfig
> +++ b/drivers/media/radio/Kconfig
> @@ -452,4 +452,19 @@ config RADIO_TIMBERDALE
>  	  found behind the Timberdale FPGA on the Russellville board.
>  	  Enabling this driver will automatically select the DSP and tuner.
>  
> +config RADIO_WL1273
> +	tristate "Texas Instruments WL1273 I2C FM Radio"
> +        depends on I2C && VIDEO_V4L2 && SND
> +	select FW_LOADER
> +	---help---
> +	  Choose Y here if you have this FM radio chip.
> +
> +	  In order to control your radio card, you will need to use programs
> +	  that are compatible with the Video For Linux 2 API.  Information on
> +	  this API and pointers to "v4l2" programs may be found at
> +	  <file:Documentation/video4linux/API.html>.
> +
> +	  To compile this driver as a module, choose M here: the
> +	  module will be called radio-wl1273.
> +
>  endif # RADIO_ADAPTERS
> diff --git a/drivers/media/radio/Makefile b/drivers/media/radio/Makefile
> index f615583..d297074 100644
> --- a/drivers/media/radio/Makefile
> +++ b/drivers/media/radio/Makefile
> @@ -26,5 +26,6 @@ obj-$(CONFIG_RADIO_TEA5764) += radio-tea5764.o
>  obj-$(CONFIG_RADIO_SAA7706H) += saa7706h.o
>  obj-$(CONFIG_RADIO_TEF6862) += tef6862.o
>  obj-$(CONFIG_RADIO_TIMBERDALE) += radio-timb.o
> +obj-$(CONFIG_RADIO_WL1273) += radio-wl1273.o
>  
>  EXTRA_CFLAGS += -Isound
> diff --git a/drivers/media/radio/radio-wl1273.c b/drivers/media/radio/radio-wl1273.c
> new file mode 100644
> index 0000000..473c194
> --- /dev/null
> +++ b/drivers/media/radio/radio-wl1273.c
> @@ -0,0 +1,1907 @@
> +/*
> + * Driver for the Texas Instruments WL1273 FM radio.
> + *
> + * Copyright (C) Nokia Corporation
> + * Author: Matti J. Aaltonen <matti.j.aaltonen@nokia.com>
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public License
> + * version 2 as published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.	See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program; if not, write to the Free Software
> + * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
> + */
> +
> +#undef DEBUG
> +
> +#include <asm/unaligned.h>
> +#include <linux/delay.h>
> +#include <linux/firmware.h>
> +#include <linux/mfd/wl1273-core.h>
> +#include <linux/platform_device.h>
> +#include <media/v4l2-common.h>
> +#include <media/v4l2-device.h>
> +#include <media/v4l2-ioctl.h>
> +
> +#define DRIVER_DESC "Wl1273 FM Radio - V4L2"
> +
> +#define WL1273_POWER_SET_OFF		0
> +#define WL1273_POWER_SET_FM		(1 << 0)
> +#define WL1273_POWER_SET_RDS		(1 << 1)
> +#define WL1273_POWER_SET_RETENTION	(1 << 4)
> +
> +#define WL1273_PUPD_SET_OFF		0x00
> +#define WL1273_PUPD_SET_ON		0x01
> +#define WL1273_PUPD_SET_RETENTION	0x10
> +
> +#define WL1273_FREQ_MULT		(10000 / 625)
> +#define WL1273_INV_FREQ_MULT		(625 / 10000)
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
> + * static int radio_nr - The number of the radio device
> + *
> + * The default is 0.
> + */
> +static int radio_nr = -1;
> +module_param(radio_nr, int, 0);
> +MODULE_PARM_DESC(radio_nr, "Radio Nr");
> +
> +struct wl1273_device {
> +	struct v4l2_device v4l2dev;
> +	struct video_device videodev;
> +	struct device *dev;
> +	struct wl1273_core *core;
> +	struct file *owner;
> +	char *write_buf;
> +	bool rds_on;
> +};
> +
> +static int wl1273_fm_set_tx_freq(struct wl1273_core *core, unsigned int freq)
> +{
> +	int r = 0;
> +
> +	if (freq < 76000) {
> +		dev_err(&core->i2c_dev->dev,
> +			"Frequency out of range: %d < %d\n",
> +			freq, core->bands[core->band].bottom_frequency);
> +		return -EDOM;
> +	}
> +
> +	if (freq > 108000) {
> +		dev_err(&core->i2c_dev->dev,
> +			"Frequency out of range: %d > %d\n",
> +			freq, core->bands[core->band].top_frequency);
> +		return -EDOM;
> +	}
> +
> +	/*
> +	 *  The driver works better with this msleep,
> +	 *  the documentation doesn't mention it.
> +	 */
> +	msleep(5);
> +	dev_dbg(&core->i2c_dev->dev, "%s: freq: %d kHz\n", __func__, freq);
> +
> +	INIT_COMPLETION(core->busy);
> +	/* Set the current tx channel */
> +	r = wl1273_fm_write_cmd(core, WL1273_CHANL_SET, freq / 10);
> +	if (r)
> +		return r;
> +
> +	/* wait for the FR IRQ */
> +	r = wait_for_completion_timeout(&core->busy, msecs_to_jiffies(1000));
> +	if (!r)
> +		return -ETIMEDOUT;
> +
> +	dev_dbg(&core->i2c_dev->dev, "WL1273_CHANL_SET: %d\n", r);
> +
> +	/* Enable the output power */
> +	INIT_COMPLETION(core->busy);
> +	r = wl1273_fm_write_cmd(core, WL1273_POWER_ENB_SET, 1);
> +	if (r)
> +		return r;
> +
> +	/* wait for the POWER_ENB IRQ */
> +	r = wait_for_completion_timeout(&core->busy, msecs_to_jiffies(1000));
> +	if (!r)
> +		return -ETIMEDOUT;
> +
> +	core->tx_frequency = freq;
> +	dev_dbg(&core->i2c_dev->dev, "WL1273_POWER_ENB_SET: %d\n", r);
> +
> +	return	0;
> +}
> +
> +static int wl1273_fm_set_rx_freq(struct wl1273_core *core, unsigned int freq)
> +{
> +	int r;
> +	int f;
> +
> +	if (freq < core->bands[core->band].bottom_frequency) {
> +		dev_err(&core->i2c_dev->dev,
> +			"Frequency out of range: %d < %d\n",
> +			freq, core->bands[core->band].bottom_frequency);
> +		r = -EDOM;
> +		goto err;
> +	}
> +
> +	if (freq > core->bands[core->band].top_frequency) {
> +		dev_err(&core->i2c_dev->dev,
> +			"Frequency out of range: %d > %d\n",
> +			freq, core->bands[core->band].top_frequency);
> +		r = -EDOM;
> +		goto err;
> +	}
> +
> +	dev_dbg(&core->i2c_dev->dev, "%s: %dkHz\n", __func__, freq);
> +
> +	wl1273_fm_write_cmd(core, WL1273_INT_MASK_SET,
> +			    core->irq_flags);
> +
> +	f = (freq - core->bands[core->band].bottom_frequency) / 50;
> +	r = wl1273_fm_write_cmd(core, WL1273_FREQ_SET, f);
> +	if (r)
> +		goto err;
> +
> +	INIT_COMPLETION(core->busy);
> +	r = wl1273_fm_write_cmd(core, WL1273_TUNER_MODE_SET,
> +				TUNER_MODE_PRESET);
> +	if (r) {
> +		complete(&core->busy);
> +		goto err;
> +	}
> +
> +	r = wait_for_completion_timeout(&core->busy, msecs_to_jiffies(2000));
> +	if (!r)
> +		return -ETIMEDOUT;
> +
> +	core->rd_index = 0;
> +	core->wr_index = 0;
> +	core->rx_frequency = freq;
> +	return 0;
> +
> +err:
> +	return r;
> +}
> +
> +static int wl1273_fm_get_freq(struct wl1273_core *core)
> +{
> +	unsigned int freq;
> +	u16 f;
> +	int r;
> +
> +	if (core->mode == WL1273_MODE_RX) {
> +		r = wl1273_fm_read_reg(core, WL1273_FREQ_SET, &f);
> +		if (r)
> +			return r;
> +
> +		dev_dbg(&core->i2c_dev->dev, "Freq get: 0x%04x\n", f);
> +		freq = core->bands[core->band].bottom_frequency + 50 * f;
> +	} else {
> +		r = wl1273_fm_read_reg(core, WL1273_CHANL_SET, &f);
> +		if (r)
> +			return r;
> +
> +		freq = f * 10;
> +	}
> +
> +	return freq;
> +}
> +
> +/**
> + * wl1273_fm_upload_firmware_patch() -	Upload the firmware.
> + * @core:				A pointer to the device struct.
> + *
> + * The firmware file consists of arrays of bytes where the first byte
> + * gives the array length. The first byte in the file gives the
> + * number of these arrays.
> + */
> +static int wl1273_fm_upload_firmware_patch(struct wl1273_core *core)
> +{
> +	unsigned int packet_num;
> +	const struct firmware *fw_p;
> +	const char *fw_name = "radio-wl1273-fw.bin";
> +	struct i2c_client *client;
> +	__u8 *ptr;
> +	int i, n, len, r;
> +	struct i2c_msg *msgs;
> +
> +	client = core->i2c_dev;
> +	dev_dbg(&client->dev, "%s:\n", __func__);
> +
> +	if (request_firmware(&fw_p, fw_name, &client->dev)) {
> +		dev_info(&client->dev, "%s - %s not found\n", __func__,
> +			 fw_name);
> +
> +		return 0;
> +	}
> +
> +	ptr = (__u8 *) fw_p->data;
> +	packet_num = ptr[0];
> +	dev_dbg(&client->dev, "%s: packets: %d\n", __func__, packet_num);
> +
> +	msgs = kmalloc((packet_num + 1)*sizeof(struct i2c_msg), GFP_KERNEL);
> +	if (!msgs) {
> +		r = -ENOMEM;
> +		goto out;
> +	}
> +
> +	i = 1;
> +	for (n = 0; n <= packet_num; n++) {
> +		len = ptr[i];
> +
> +		dev_dbg(&client->dev, "%s: len[%d]: %d\n",
> +			__func__, n, len);
> +
> +		if (i + len + 1 <= fw_p->size) {
> +			msgs[n].addr = client->addr;
> +			msgs[n].flags = 0;
> +			msgs[n].len = len;
> +			msgs[n].buf = ptr + i + 1;
> +		} else {
> +			break;
> +		}
> +
> +		i += len + 1;
> +	}
> +
> +	r = i2c_transfer(client->adapter, msgs, packet_num);
> +	kfree(msgs);
> +
> +	if (r != packet_num) {
> +		dev_err(&client->dev, "FW upload error: %d\n", r);
> +		dev_dbg(&client->dev, "%d != %d\n", packet_num, r);
> +
> +		r =  -EREMOTEIO;
> +		goto out;
> +	} else {
> +		r = 0;
> +	}
> +
> +	/* ignore possible error here */
> +	wl1273_fm_write_cmd(core, WL1273_RESET, 0);
> +	dev_dbg(&client->dev, "n: %d, i: %d\n", n, i);
> +
> +	if (n - 1  != packet_num)
> +		dev_warn(&client->dev, "%s - incorrect firmware size.\n",
> +			 __func__);
> +
> +	if (i != fw_p->size)
> +		dev_warn(&client->dev, "%s - inconsistent firmware.\n",
> +			 __func__);
> +
> +	dev_dbg(&client->dev, "%s - download OK, r: %d\n", __func__, r);
> +
> +out:
> +	release_firmware(fw_p);
> +	return r;
> +}
> +
> +static int wl1273_fm_stop(struct wl1273_core *core)
> +{
> +	struct i2c_client *client = core->i2c_dev;
> +	struct wl1273_fm_platform_data *pdata =
> +		client->dev.platform_data;
> +
> +	if (core->mode == WL1273_MODE_RX) {
> +		int r = wl1273_fm_write_cmd(core, WL1273_POWER_SET,
> +					    WL1273_POWER_SET_OFF);
> +		if (r)
> +			dev_err(&core->i2c_dev->dev,
> +				"%s: POWER_SET fails: %d\n", __func__, r);
> +	} else if (core->mode == WL1273_MODE_TX) {
> +		int r = wl1273_fm_write_cmd(core, WL1273_PUPD_SET,
> +					    WL1273_PUPD_SET_OFF);
> +		if (r)
> +			dev_err(&core->i2c_dev->dev,
> +				"%s: PUPD_SET fails: %d\n", __func__, r);
> +	}
> +
> +	if (pdata->disable) {
> +		pdata->disable();
> +		dev_dbg(&core->i2c_dev->dev, "Back to reset\n");
> +	}
> +
> +	return 0;
> +}
> +
> +static int wl1273_fm_start(struct wl1273_core *core, int new_mode)
> +{
> +	struct i2c_client *client = core->i2c_dev;
> +	struct wl1273_fm_platform_data *pdata =
> +		client->dev.platform_data;
> +	int r = -EINVAL;
> +
> +	if (pdata->enable && core->mode == WL1273_MODE_OFF) {
> +		pdata->enable();
> +		msleep(250);
> +	}
> +
> +	if (new_mode == WL1273_MODE_RX) {
> +		u16 val = WL1273_POWER_SET_FM;
> +
> +		if (core->rds_on)
> +			val |= WL1273_POWER_SET_RDS;
> +
> +		/* If this fails try again */
> +		r = wl1273_fm_write_cmd(core, WL1273_POWER_SET, val);
> +		if (r) {
> +			msleep(100);
> +
> +			r = wl1273_fm_write_cmd(core, WL1273_POWER_SET, val);
> +			if (r) {
> +				dev_err(&client->dev, "%s: POWER_SET fails.\n",
> +					__func__);
> +				goto fail;
> +			}
> +		}
> +
> +		/* rds buffer configuration */
> +		core->wr_index = 0;
> +		core->rd_index = 0;
> +
> +	} else if (new_mode == WL1273_MODE_TX) {
> +		/* If this fails try again */
> +		r = wl1273_fm_write_cmd(core, WL1273_PUPD_SET,
> +					WL1273_PUPD_SET_ON);
> +		if (r) {
> +			msleep(100);
> +			r = wl1273_fm_write_cmd(core, WL1273_PUPD_SET,
> +						WL1273_PUPD_SET_ON);
> +			if (r) {
> +				dev_err(&client->dev, "%s: PUPD_SET fails.\n",
> +					__func__);
> +				goto fail;
> +			}
> +		}
> +
> +		if (core->rds_on)
> +			r = wl1273_fm_write_cmd(core, WL1273_RDS_DATA_ENB, 1);
> +		else
> +			r = wl1273_fm_write_cmd(core, WL1273_RDS_DATA_ENB, 0);
> +	} else {
> +		dev_warn(&client->dev, "%s: Illegal mode.\n", __func__);
> +	}
> +
> +	if (core->mode == WL1273_MODE_OFF) {
> +		dev_dbg(&core->i2c_dev->dev, "Out of reset\n");
> +
> +		r = wl1273_fm_upload_firmware_patch(core);
> +		if (r)
> +			dev_warn(&client->dev, "Firmware upload failed.\n");
> +	}
> +
> +	return 0;
> +fail:
> +	if (pdata->disable)
> +		pdata->disable();
> +
> +	dev_dbg(&client->dev, "%s: return: %d\n", __func__, r);
> +	return r;
> +}
> +
> +static int wl1273_fm_suspend(struct wl1273_core *core)
> +{
> +	int r = 0;
> +	struct i2c_client *client = core->i2c_dev;
> +
> +	/* Cannot go from OFF to SUSPENDED */
> +	if (core->mode == WL1273_MODE_RX)
> +		r = wl1273_fm_write_cmd(core, WL1273_POWER_SET,
> +					WL1273_POWER_SET_RETENTION);
> +	else if (core->mode == WL1273_MODE_TX)
> +		r = wl1273_fm_write_cmd(core, WL1273_PUPD_SET,
> +					WL1273_PUPD_SET_RETENTION);
> +	else
> +		r = -EINVAL;
> +
> +	if (r) {
> +		dev_err(&client->dev, "%s: POWER_SET fails: %d\n", __func__, r);
> +		goto out;
> +	}
> +
> +out:
> +	return r;
> +}
> +
> +static int wl1273_fm_set_mode(struct wl1273_core *core, int mode)
> +{
> +	int r;
> +	int old_mode;
> +
> +	dev_dbg(&core->i2c_dev->dev, "%s\n", __func__);
> +	dev_dbg(&core->i2c_dev->dev, "Allowed modes: %d\n",
> +		core->allowed_modes);
> +
> +	mutex_lock(&core->lock);
> +	old_mode = core->mode;
> +
> +	switch (mode) {
> +	case WL1273_MODE_RX:
> +	case WL1273_MODE_TX:
> +		if (mode ==  WL1273_MODE_RX &&
> +		    !(core->allowed_modes & WL1273_RX_ALLOWED)) {
> +			r = -EPERM;
> +			goto out;
> +		} else if (mode ==  WL1273_MODE_TX &&
> +			   !(core->allowed_modes & WL1273_TX_ALLOWED)) {
> +			r = -EPERM;
> +			goto out;
> +		}
> +
> +		r = wl1273_fm_start(core, mode);
> +		if (r) {
> +			dev_err(&core->i2c_dev->dev, "%s: Cannot start.\n",
> +				__func__);
> +			wl1273_fm_stop(core);
> +			goto out;
> +		} else {
> +			core->mode = mode;
> +			r = wl1273_fm_set_audio(core, core->audio_mode);
> +			if (r)
> +				dev_err(&core->i2c_dev->dev,
> +					"Cannot set audio mode.\n");
> +		}
> +
> +		r = wl1273_fm_write_cmd(core, WL1273_INT_MASK_SET,
> +					core->irq_flags);
> +		if (r) {
> +			dev_err(&core->i2c_dev->dev,
> +				"INT_MASK_SET fails.\n");
> +			goto out;
> +		}
> +
> +		/* remember previous settings */
> +		if (mode == WL1273_MODE_RX) {
> +			r = wl1273_fm_set_rx_freq(core, core->rx_frequency);
> +			if (r) {
> +				dev_err(&core->i2c_dev->dev,
> +					"set freq fails: %d.\n", r);
> +				goto out;
> +			}
> +
> +			r = wl1273_fm_set_volume(core, core->volume);
> +			if (r) {
> +				dev_err(&core->i2c_dev->dev,
> +					"set volume fails: %d.\n", r);
> +				goto out;
> +			}
> +
> +			dev_dbg(&core->i2c_dev->dev, "%s: Set vol: %d.\n",
> +				__func__, core->volume);
> +		} else {
> +			r = wl1273_fm_set_tx_freq(core, core->tx_frequency);
> +			if (r) {
> +				dev_err(&core->i2c_dev->dev,
> +					"set freq fails: %d.\n", r);
> +				goto out;
> +			}
> +		}
> +
> +		break;
> +
> +	case WL1273_MODE_OFF:
> +		r = wl1273_fm_stop(core);
> +		if (r)
> +			dev_err(&core->i2c_dev->dev,
> +				"%s: Off fails: %d\n", __func__, r);
> +		else
> +			core->mode = WL1273_MODE_OFF;
> +
> +		break;
> +
> +	case WL1273_MODE_SUSPENDED:
> +		r = wl1273_fm_suspend(core);
> +		if (r)
> +			dev_err(&core->i2c_dev->dev,
> +				"%s: Suspend fails: %d\n", __func__, r);
> +		else
> +			core->mode = WL1273_MODE_SUSPENDED;
> +
> +		break;
> +
> +	default:
> +		dev_err(&core->i2c_dev->dev, "%s: Unknown mode: %d\n",
> +			__func__, mode);
> +		r = -EINVAL;
> +		break;
> +	}
> +
> +out:
> +	if (r)
> +		core->mode = old_mode ;
> +
> +	mutex_unlock(&core->lock);
> +
> +	return r;
> +}
> +
> +static int wl1273_fm_set_seek(struct wl1273_core *core,
> +			      unsigned int wrap_around,
> +			      unsigned int seek_upward,
> +			      int level)
> +{
> +	int r = 0;
> +	unsigned int dir = (seek_upward == 0) ? 0 : 1;
> +	unsigned int rx_frequency, top_frequency, bottom_frequency;
> +
> +	rx_frequency = core->rx_frequency;
> +	top_frequency = core->bands[core->band].top_frequency;
> +	bottom_frequency = core->bands[core->band].bottom_frequency;
> +	dev_dbg(&core->i2c_dev->dev, "core->rx_frequency: %d\n",
> +		rx_frequency);
> +
> +	if (dir && rx_frequency + core->spacing <= top_frequency)
> +		r = wl1273_fm_set_rx_freq(core, rx_frequency + core->spacing);
> +	else if (dir && wrap_around)
> +		r = wl1273_fm_set_rx_freq(core, bottom_frequency);
> +	else if (rx_frequency - core->spacing >= bottom_frequency)
> +		r = wl1273_fm_set_rx_freq(core, rx_frequency - core->spacing);
> +	else if (wrap_around)
> +		r = wl1273_fm_set_rx_freq(core, top_frequency);
> +
> +	if (r)
> +		goto out;
> +
> +	if (level < SCHAR_MIN || level > SCHAR_MAX)
> +		return -EINVAL;
> +
> +	INIT_COMPLETION(core->busy);
> +	dev_dbg(&core->i2c_dev->dev, "%s: BUSY\n", __func__);
> +
> +	r = wl1273_fm_write_cmd(core, WL1273_INT_MASK_SET,
> +				core->irq_flags);
> +	if (r)
> +		goto out;
> +
> +	dev_dbg(&core->i2c_dev->dev, "%s\n", __func__);
> +
> +	r = wl1273_fm_write_cmd(core, WL1273_SEARCH_LVL_SET, level);
> +	if (r)
> +		goto out;
> +
> +	r = wl1273_fm_write_cmd(core, WL1273_SEARCH_DIR_SET, dir);
> +	if (r)
> +		goto out;
> +
> +	r = wl1273_fm_write_cmd(core, WL1273_TUNER_MODE_SET,
> +				TUNER_MODE_AUTO_SEEK);
> +	if (r)
> +		goto out;
> +
> +	wait_for_completion_timeout(&core->busy, msecs_to_jiffies(1000));
> +	if (!(core->irq_received & WL1273_BL_EVENT))
> +		goto out;
> +
> +	core->irq_received &= ~WL1273_BL_EVENT;
> +
> +	if (!wrap_around)
> +		goto out;
> +
> +	/* Wrap around */
> +	dev_dbg(&core->i2c_dev->dev, "Wrap around in HW seek.\n");
> +
> +	if (seek_upward)
> +		rx_frequency = bottom_frequency;
> +	else
> +		rx_frequency = top_frequency;
> +
> +	r = wl1273_fm_set_rx_freq(core, rx_frequency);
> +	if (r)
> +		goto out;
> +
> +	INIT_COMPLETION(core->busy);
> +	dev_dbg(&core->i2c_dev->dev, "%s: BUSY\n", __func__);
> +
> +	r = wl1273_fm_write_cmd(core, WL1273_TUNER_MODE_SET,
> +				TUNER_MODE_AUTO_SEEK);
> +	if (r)
> +		goto out;
> +
> +	wait_for_completion_timeout(&core->busy, msecs_to_jiffies(1000));
> +out:
> +	dev_dbg(&core->i2c_dev->dev, "%s: Err: %d\n", __func__, r);
> +	return r;
> +}
> +
> +/**
> + * wl1273_fm_set_band() -	Change the current band.
> + * @core:			A pointer to the device structure.
> + * @band:			The ID of the new band.
> + *
> + * Wl1273 supports only two bands USA/Europe and Japan.
> + */
> +static int wl1273_fm_set_band(struct wl1273_core *core, unsigned int band)
> +{
> +	int r = 0;
> +	unsigned int new_frequency = 0;
> +
> +	dev_err(&core->i2c_dev->dev, "%s: number of resion: %d\n", __func__,
> +		core->number_of_bands);
> +
> +	if (band == core->band)
> +		return 0;
> +
> +	if (core->mode == WL1273_MODE_OFF ||
> +	    core->mode == WL1273_MODE_SUSPENDED)
> +		return -EPERM;
> +
> +	if (band >= core->number_of_bands)
> +		return -EINVAL;
> +
> +	mutex_lock(&core->lock);
> +
> +	core->band = band;
> +
> +	if (core->rx_frequency < core->bands[core->band].bottom_frequency)
> +		new_frequency = core->bands[core->band].bottom_frequency;
> +	else if (core->rx_frequency > core->bands[core->band].top_frequency)
> +		new_frequency = core->bands[core->band].top_frequency;
> +
> +	if (new_frequency) {
> +		core->rx_frequency = new_frequency;
> +		if (core->mode == WL1273_MODE_RX) {
> +			r = wl1273_fm_set_rx_freq(core, new_frequency);
> +			if (r)
> +				goto out;
> +		}
> +	}
> +
> +	new_frequency = 0;
> +	if (core->tx_frequency < core->bands[core->band].bottom_frequency)
> +		new_frequency = core->bands[core->band].bottom_frequency;
> +	else if (core->tx_frequency > core->bands[core->band].top_frequency)
> +		new_frequency = core->bands[core->band].top_frequency;
> +
> +	if (new_frequency) {
> +		core->tx_frequency = new_frequency;
> +
> +		if (core->mode == WL1273_MODE_TX) {
> +			r = wl1273_fm_set_tx_freq(core, new_frequency);
> +			if (r)
> +				goto out;
> +		}
> +	}
> +
> +out:
> +	mutex_unlock(&core->lock);
> +	return r;
> +}
> +
> +/**
> + * wl1273_fm_get_tx_ctune() -	Get the TX tuning capacitor value.
> + * @core:			A pointer to the device struct.
> + */
> +static unsigned int wl1273_fm_get_tx_ctune(struct wl1273_core *core)
> +{
> +	struct i2c_client *client = core->i2c_dev;
> +	u16 val;
> +	int r;
> +
> +	if (core->mode == WL1273_MODE_OFF ||
> +	    core->mode == WL1273_MODE_SUSPENDED)
> +		return -EPERM;
> +
> +	r = wl1273_fm_read_reg(core, WL1273_READ_FMANT_TUNE_VALUE, &val);
> +	if (r) {
> +		dev_err(&client->dev, "%s: I2C error: %d\n", __func__, r);
> +		goto out;
> +	}
> +
> +out:
> +	return val;
> +}
> +
> +/**
> + * wl1273_fm_set_preemphasis() - Set the TX pre-emphasis value.
> + * @core:			 A pointer to the device struct.
> + * @preemphasis:		 The new pre-amphasis value.
> + *
> + * Possible pre-emphasis values are: V4L2_PREEMPHASIS_DISABLED,
> + * V4L2_PREEMPHASIS_50_uS and V4L2_PREEMPHASIS_75_uS.
> + */
> +static int wl1273_fm_set_preemphasis(struct wl1273_core *core,
> +				     unsigned int preemphasis)
> +{
> +	int r;
> +	u16 em;
> +
> +	if (core->mode == WL1273_MODE_OFF ||
> +	    core->mode == WL1273_MODE_SUSPENDED)
> +		return -EPERM;
> +
> +	mutex_lock(&core->lock);
> +
> +	switch (preemphasis) {
> +	case V4L2_PREEMPHASIS_DISABLED:
> +		em = 1;
> +		break;
> +	case V4L2_PREEMPHASIS_50_uS:
> +		em = 0;
> +		break;
> +	case V4L2_PREEMPHASIS_75_uS:
> +		em = 2;
> +		break;
> +	default:
> +		r = -EINVAL;
> +		goto out;
> +	}
> +
> +	r = wl1273_fm_write_cmd(core, WL1273_PREMPH_SET, em);
> +	if (r)
> +		goto out;
> +
> +	core->preemphasis = preemphasis;
> +
> +out:
> +	mutex_unlock(&core->lock);
> +	return r;
> +}
> +
> +static int wl1273_fm_rds_on(struct wl1273_core *core)
> +{
> +	int r;
> +
> +	dev_dbg(&core->i2c_dev->dev, "%s\n", __func__);
> +
> +	r = wl1273_fm_write_cmd(core, WL1273_POWER_SET,
> +				WL1273_POWER_SET_FM | WL1273_POWER_SET_RDS);
> +	if (r)
> +		goto out;
> +
> +	r = wl1273_fm_set_rx_freq(core, core->rx_frequency);
> +	if (r)
> +		dev_err(&core->i2c_dev->dev, "set freq fails: %d.\n", r);
> +out:
> +	return r;
> +}
> +
> +static int wl1273_fm_rds_off(struct wl1273_core *core)
> +{
> +	struct device *dev = &core->i2c_dev->dev;
> +	int r;
> +
> +	core->irq_flags &= ~WL1273_RDS_EVENT;
> +
> +	r = wl1273_fm_write_cmd(core, WL1273_INT_MASK_SET,
> +				core->irq_flags);
> +	if (r)
> +		goto out;
> +
> +	/* stop rds reception */
> +	cancel_delayed_work(&core->work);
> +
> +	/* Service pending read */
> +	wake_up_interruptible(&core->read_queue);
> +
> +	dev_dbg(dev, "%s\n", __func__);
> +
> +	r = wl1273_fm_write_cmd(core, WL1273_POWER_SET, WL1273_POWER_SET_FM);
> +
> +out:
> +	dev_dbg(dev, "%s: exiting...\n", __func__);
> +
> +	return r;
> +}
> +
> +static int wl1273_fm_set_rds(struct wl1273_core *core, unsigned int new_mode)
> +{
> +	int r = 0;
> +	struct i2c_client *client = core->i2c_dev;
> +
> +	if (core->mode == WL1273_MODE_OFF ||
> +	    core->mode == WL1273_MODE_SUSPENDED)
> +		return -EPERM;
> +
> +	if (new_mode == WL1273_RDS_RESET) {
> +		r = wl1273_fm_write_cmd(core, WL1273_RDS_CNTRL_SET, 1);
> +		return r;
> +	}
> +
> +	mutex_lock(&core->lock);
> +
> +	if (core->mode == WL1273_MODE_TX && new_mode == WL1273_RDS_OFF) {
> +		r = wl1273_fm_write_cmd(core, WL1273_RDS_DATA_ENB, 0);
> +	} else if (core->mode == WL1273_MODE_TX && new_mode == WL1273_RDS_ON) {
> +		r = wl1273_fm_write_cmd(core, WL1273_RDS_DATA_ENB, 1);
> +	} else if (core->mode == WL1273_MODE_RX && new_mode == WL1273_RDS_OFF) {
> +		r = wl1273_fm_rds_off(core);
> +	} else if (core->mode == WL1273_MODE_RX && new_mode == WL1273_RDS_ON) {
> +		r = wl1273_fm_rds_on(core);
> +	} else {
> +		dev_err(&client->dev, "%s: Unknown mode: %d\n", __func__,
> +			new_mode);
> +		r = -EINVAL;
> +	}
> +
> +	if (!r)
> +		core->rds_on = (new_mode == WL1273_RDS_ON) ? true : false;
> +
> +	mutex_unlock(&core->lock);
> +
> +	return r;
> +}
> +
> +static ssize_t wl1273_fm_fops_write(struct file *file, const char __user *buf,
> +				    size_t count, loff_t *ppos)
> +{
> +	struct wl1273_device *radio = video_get_drvdata(video_devdata(file));
> +	unsigned char *s;
> +	u16 val;
> +	int r;
> +
> +	dev_dbg(radio->dev, "%s\n", __func__);
> +
> +	if (radio->core->mode != WL1273_MODE_TX)
> +		return count;
> +
> +	if (!radio->rds_on) {
> +		dev_warn(radio->dev, "%s: RDS not on.\n", __func__);
> +		return 0;
> +	}
> +
> +	if (mutex_lock_interruptible(&radio->core->lock))
> +		return -EINTR;
> +
> +
> +	/*
> +	 * Multiple processes can open the device, but only
> +	 * one gets to write to it.
> +	 */
> +	if (radio->owner && radio->owner != file) {
> +		r = -EBUSY;
> +		goto out;
> +	}
> +	radio->owner = file;
> +
> +	/* Manual Mode */
> +	if (count > 255)
> +		val = 255;
> +	else
> +		val = count;
> +
> +	wl1273_fm_write_cmd(radio->core, WL1273_RDS_CONFIG_DATA_SET, val);
> +
> +	if (copy_from_user(radio->write_buf + 1, buf, val)) {
> +		r = -EFAULT;
> +		goto out;
> +	}
> +
> +	dev_dbg(radio->dev, "Count: %d\n", val);
> +	dev_dbg(radio->dev, "From user: \"%s\"\n", s);
> +
> +	radio->write_buf[0] = WL1273_RDS_DATA_SET;
> +	wl1273_fm_write_data(radio->core, radio->write_buf, val + 1);
> +
> +	r = val;
> +out:
> +	mutex_unlock(&radio->core->lock);
> +
> +	return r;
> +}
> +
> +static unsigned int wl1273_fm_fops_poll(struct file *file,
> +					struct poll_table_struct *pts)
> +{
> +	struct wl1273_device *radio = video_get_drvdata(video_devdata(file));
> +	struct wl1273_core *core = radio->core;
> +	unsigned int rd_index, wr_index;
> +
> +	/* TODO: handle the case of multiple readers */

Please remove this comment: multiple reader support does not belong in the kernel,
so this will never happen.

> +
> +	poll_wait(file, &core->read_queue, pts);
> +
> +	rd_index = core->rd_index;
> +	wr_index = core->wr_index;
> +	if (rd_index != wr_index)
> +		return POLLIN | POLLRDNORM;

Since you can write as well, shouldn't there be POLLOUT handling too?

> +
> +	return 0;
> +}

<snip>

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG, part of Cisco
