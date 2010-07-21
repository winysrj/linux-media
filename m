Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr11.xs4all.nl ([194.109.24.31]:2455 "EHLO
	smtp-vbr11.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753368Ab0GUJ1j (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 21 Jul 2010 05:27:39 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: "Matti J. Aaltonen" <matti.j.aaltonen@nokia.com>
Subject: Re: [PATCH v6 4/5] V4L2: WL1273 FM Radio: Controls for the FM radio.
Date: Wed, 21 Jul 2010 11:27:22 +0200
Cc: linux-media@vger.kernel.org, eduardo.valentin@nokia.com,
	mchehab@redhat.com
References: <1279624562-14125-1-git-send-email-matti.j.aaltonen@nokia.com> <1279624562-14125-4-git-send-email-matti.j.aaltonen@nokia.com> <1279624562-14125-5-git-send-email-matti.j.aaltonen@nokia.com>
In-Reply-To: <1279624562-14125-5-git-send-email-matti.j.aaltonen@nokia.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-6"
Content-Transfer-Encoding: 7bit
Message-Id: <201007211127.22359.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tuesday 20 July 2010 13:16:01 Matti J. Aaltonen wrote:
> This file implements V4L2 controls for using the Texas Instruments
> WL1273 FM Radio.
> 
> Signed-off-by: Matti J. Aaltonen <matti.j.aaltonen@nokia.com>
> ---
>  drivers/media/radio/Kconfig        |   15 +
>  drivers/media/radio/Makefile       |    1 +
>  drivers/media/radio/radio-wl1273.c | 1960 ++++++++++++++++++++++++++++++++++++
>  drivers/mfd/Kconfig                |    6 +
>  drivers/mfd/Makefile               |    2 +
>  5 files changed, 1984 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/media/radio/radio-wl1273.c
> 

<snip>

> +static int wl1273_fm_vidioc_g_tuner(struct file *file, void *priv,
> +				    struct v4l2_tuner *tuner)
> +{
> +	struct wl1273_device *radio = video_get_drvdata(video_devdata(file));
> +	struct wl1273_core *core = radio->core;
> +	u16 val;
> +	int r;
> +
> +	dev_dbg(radio->dev, "%s\n", __func__);
> +
> +	if (tuner->index > 0)
> +		return -EINVAL;
> +
> +	strlcpy(tuner->name, WL1273_FM_DRIVER_NAME, sizeof(tuner->name));
> +	tuner->type = V4L2_TUNER_RADIO;
> +
> +	tuner->rangelow	=
> +		WL1273_FREQ(core->bands[core->band].bottom_frequency);
> +	tuner->rangehigh =
> +		WL1273_FREQ(core->bands[core->band].top_frequency);
> +
> +	tuner->capability = V4L2_TUNER_CAP_LOW | V4L2_TUNER_CAP_RDS |
> +		V4L2_TUNER_CAP_STEREO;
> +

audmode must be set even when the device is in TX mode. Best is to just set it
to the last set audmode.

> +	if (core->mode != WL1273_MODE_RX)
> +		return 0;
> +
> +
> +	if (mutex_lock_interruptible(&core->lock))
> +		return -EINTR;
> +
> +	r = wl1273_fm_read_reg(core, WL1273_MOST_MODE_SET, &val);
> +	if (r)
> +		goto out;
> +
> +	if (val == WL1273_RX_MONO) {
> +		tuner->rxsubchans = V4L2_TUNER_SUB_MONO;
> +		tuner->audmode = V4L2_TUNER_MODE_MONO;
> +	} else {
> +		tuner->rxsubchans = V4L2_TUNER_SUB_STEREO;
> +		tuner->audmode = V4L2_TUNER_MODE_STEREO;
> +	}

There are two separate things: detecting whether the signal is stereo or mono
and selecting the audio mode (this is the format of the audio that is sent to
userspace). The first is set in rxsubchans and is dynamic, the second is fixed
and set by the application.

If the device can detect mono vs stereo signals, then rxsubchans should be set
accordingly. If the device cannot do this, then both mono and stereo should be
specified in rxsubchans.

The audmode field is like a control: it does not automatically change if the
signal switches from mono to stereo or vice versa. Unless the hardware is
unable to map a mono signal to a stereo audio stream or a stereo signal to a
mono audio stream.

The fact that the code above sets both rxsubchans and audmode suggests either
that the hardware cannot map stereo to mono or vice versa, or a program bug.
In the first case we need a comment here, in the second case it should be
fixed.

> +
> +	r = wl1273_fm_read_reg(core, WL1273_RSSI_LVL_GET, &val);
> +	if (r)
> +		goto out;
> +
> +	tuner->signal = (s16) val;
> +	dev_dbg(radio->dev, "Signal: %d\n", tuner->signal);
> +
> +	tuner->afc = 0;
> +
> +	r = wl1273_fm_read_reg(core, WL1273_RDS_SYNC_GET, &val);
> +	if (r)
> +		goto out;
> +
> +	if (val == WL1273_RDS_SYNCHRONIZED)
> +		tuner->rxsubchans |= V4L2_TUNER_SUB_RDS;
> +out:
> +	mutex_unlock(&core->lock);
> +
> +	return r;
> +}
> +
> +static int wl1273_fm_vidioc_s_tuner(struct file *file, void *priv,
> +				    struct v4l2_tuner *tuner)
> +{
> +	struct wl1273_device *radio = video_get_drvdata(video_devdata(file));
> +	struct wl1273_core *core = radio->core;
> +	int r = 0;
> +
> +	dev_dbg(radio->dev, "%s\n", __func__);
> +	dev_dbg(radio->dev, "tuner->index: %d\n", tuner->index);
> +	dev_dbg(radio->dev, "tuner->name: %s\n", tuner->name);
> +	dev_dbg(radio->dev, "tuner->capability: 0x%04x\n", tuner->capability);
> +	dev_dbg(radio->dev, "tuner->rxsubchans: 0x%04x\n", tuner->rxsubchans);
> +	dev_dbg(radio->dev, "tuner->rangelow: %d\n", tuner->rangelow);
> +	dev_dbg(radio->dev, "tuner->rangehigh: %d\n", tuner->rangehigh);
> +
> +	if (tuner->index > 0)
> +		return -EINVAL;
> +
> +	if (mutex_lock_interruptible(&core->lock))
> +		return -EINTR;
> +
> +	r = wl1273_fm_set_mode(core, WL1273_MODE_RX);
> +	if (r)
> +		goto out;
> +
> +	if (tuner->rxsubchans & V4L2_TUNER_SUB_RDS)
> +		r = wl1273_fm_set_rds(core, WL1273_RDS_ON);
> +	else
> +		r = wl1273_fm_set_rds(core, WL1273_RDS_OFF);
> +
> +	if (r)
> +		dev_warn(radio->dev, "%s: RDS fails: %d\n", __func__, r);
> +
> +	if (tuner->audmode == V4L2_TUNER_MODE_MONO)
> +		r = wl1273_fm_write_cmd(core, WL1273_MOST_MODE_SET,
> +					WL1273_RX_MONO);
> +	else
> +		r = wl1273_fm_write_cmd(core, WL1273_MOST_MODE_SET,
> +					WL1273_RX_STEREO);
> +	if (r < 0)
> +		dev_warn(radio->dev, WL1273_FM_DRIVER_NAME
> +			 "MOST_MODE_SET fails:  %d\n", r);
> +out:
> +	mutex_unlock(&core->lock);
> +
> +	return r;
> +}
> +

<snip>

> +static int wl1273_fm_vidioc_s_modulator(struct file *file, void *priv,
> +					struct v4l2_modulator *modulator)
> +{
> +	struct wl1273_device *radio = video_get_drvdata(video_devdata(file));
> +	struct wl1273_core *core = radio->core;
> +	int r = 0;
> +
> +	dev_dbg(radio->dev, "%s\n", __func__);
> +
> +	if (modulator->index > 0)
> +		return -EINVAL;
> +
> +	if (mutex_lock_interruptible(&core->lock))
> +		return -EINTR;
> +
> +	r = wl1273_fm_set_mode(core, WL1273_MODE_TX);
> +	if (r)
> +		goto out;
> +
> +	if (modulator->txsubchans & V4L2_TUNER_SUB_RDS)
> +		r = wl1273_fm_set_rds(core, WL1273_RDS_ON);
> +	else
> +		r = wl1273_fm_set_rds(core, WL1273_RDS_OFF);
> +
> +	if (modulator->txsubchans & V4L2_TUNER_SUB_MONO)
> +		r = wl1273_fm_write_cmd(core, WL1273_MONO_SET, WL1273_TX_MONO);
> +	else
> +		r = wl1273_fm_write_cmd(core, WL1273_MONO_SET,
> +					WL1273_RX_STEREO);
> +	if (r < 0)
> +		dev_warn(radio->dev, WL1273_FM_DRIVER_NAME
> +			 "MONO_SET fails: %d\n", r);
> +out:
> +	mutex_unlock(&core->lock);
> +
> +	return r;
> +}
> +
> +static int wl1273_fm_vidioc_g_modulator(struct file *file, void *priv,
> +					struct v4l2_modulator *modulator)
> +{
> +	struct wl1273_device *radio = video_get_drvdata(video_devdata(file));
> +	struct wl1273_core *core = radio->core;
> +	u16 val;
> +	int r;
> +
> +	dev_dbg(radio->dev, "%s\n", __func__);
> +
> +	strlcpy(modulator->name, WL1273_FM_DRIVER_NAME,
> +		sizeof(modulator->name));
> +
> +	modulator->rangelow =
> +		WL1273_FREQ(core->bands[core->band].bottom_frequency);
> +	modulator->rangehigh =
> +		WL1273_FREQ(core->bands[core->band].top_frequency);
> +
> +	modulator->capability =  V4L2_TUNER_CAP_LOW | V4L2_TUNER_CAP_RDS |
> +		V4L2_TUNER_CAP_STEREO;
> +
> +	if (core->mode != WL1273_MODE_TX)
> +		return 0;
> +
> +	if (mutex_lock_interruptible(&core->lock))
> +		return -EINTR;
> +
> +	r = wl1273_fm_read_reg(core, WL1273_MONO_SET, &val);
> +	if (r)
> +		goto out;
> +
> +	if (val == WL1273_TX_STEREO)
> +		modulator->txsubchans = V4L2_TUNER_SUB_STEREO;
> +	else
> +		modulator->txsubchans = V4L2_TUNER_SUB_MONO;
> +
> +	if (core->rds_on)
> +		modulator->txsubchans |= V4L2_TUNER_SUB_RDS;
> +	else
> +		modulator->txsubchans &= ~V4L2_TUNER_SUB_RDS;

This else is not needed.

> +
> +out:
> +	mutex_unlock(&core->lock);
> +
> +	return 0;
> +}

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG, part of Cisco
