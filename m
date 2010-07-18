Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr16.xs4all.nl ([194.109.24.36]:3852 "EHLO
	smtp-vbr16.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753700Ab0GRJu2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 18 Jul 2010 05:50:28 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: "Matti J. Aaltonen" <matti.j.aaltonen@nokia.com>
Subject: Re: [PATCH v5 4/5] V4L2: WL1273 FM Radio: Controls for the FM radio.
Date: Sun, 18 Jul 2010 11:52:57 +0200
Cc: linux-media@vger.kernel.org, eduardo.valentin@nokia.com
References: <1279276067-1736-1-git-send-email-matti.j.aaltonen@nokia.com> <1279276067-1736-4-git-send-email-matti.j.aaltonen@nokia.com> <1279276067-1736-5-git-send-email-matti.j.aaltonen@nokia.com>
In-Reply-To: <1279276067-1736-5-git-send-email-matti.j.aaltonen@nokia.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-6"
Content-Transfer-Encoding: 7bit
Message-Id: <201007181152.57515.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Friday 16 July 2010 12:27:46 Matti J. Aaltonen wrote:
> This file implements V4L2 controls for using the Texas Instruments
> WL1273 FM Radio.
> 
> Signed-off-by: Matti J. Aaltonen <matti.j.aaltonen@nokia.com>

<snip>

> +
> +static unsigned int wl1273_fm_fops_poll(struct file *file,
> +					struct poll_table_struct *pts)
> +{
> +	struct wl1273_device *radio = video_get_drvdata(video_devdata(file));
> +	struct wl1273_core *core = radio->core;
> +	unsigned int rd_index, wr_index;
> +
> +	if (radio->owner && radio->owner != file)
> +		return -EBUSY;
> +
> +	radio->owner = file;
> +	poll_wait(file, &core->read_queue, pts);
> +
> +	rd_index = core->rd_index;
> +	wr_index = core->wr_index;
> +	if (rd_index != wr_index)
> +		return POLLIN | POLLOUT | POLLRDNORM;

You also need to add POLLWRNORM.

I wonder if this code is correct. Doesn't this depend on whether the device
is in receive or transmit mode? So either poll returns POLLIN|POLLRDNORM or
POLLOUT|POLLWRNORM. Or am I missing something?

> +
> +	return 0;
> +}

<snip>

> +#define WL1273_RDS_NOT_SYNCHRONIZED 0
> +#define WL1273_RDS_SYNCHRONIZED 1
> +
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
> +	strcpy(tuner->name, WL1273_FM_DRIVER_NAME);

strlcpy

> +	tuner->type = V4L2_TUNER_RADIO;
> +
> +	tuner->rangelow	=
> +		WL1273_FREQ(core->bands[core->band].bottom_frequency);
> +	tuner->rangehigh =
> +		WL1273_FREQ(core->bands[core->band].top_frequency);
> +
> +	tuner->rxsubchans = V4L2_TUNER_SUB_MONO | V4L2_TUNER_SUB_STEREO;

You can't detect whether mono or stereo is received? Does the alsa codec always
receive two channel audio? How does it handle mono vs stereo?

> +	tuner->capability = V4L2_TUNER_CAP_LOW | V4L2_TUNER_CAP_RDS;

Shouldn't CAP_STEREO be added?

> +
> +	if (core->mode != WL1273_MODE_RX)
> +		return 0;
> +
> +	if (mutex_lock_interruptible(&core->lock))
> +		return -EINTR;
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

tuner->audmode isn't filled!

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
> +			 ": set tuner mode failed with %d\n", r);
> +out:
> +	mutex_unlock(&core->lock);
> +
> +	return r;
> +}
> +
> +static int wl1273_fm_vidioc_g_frequency(struct file *file, void *priv,
> +					struct v4l2_frequency *freq)
> +{
> +	struct wl1273_device *radio = video_get_drvdata(video_devdata(file));
> +	struct wl1273_core *core = radio->core;
> +
> +	dev_dbg(radio->dev, "%s\n", __func__);
> +
> +	if (mutex_lock_interruptible(&core->lock))
> +		return -EINTR;
> +
> +	freq->type = V4L2_TUNER_RADIO;
> +	freq->frequency = WL1273_FREQ(wl1273_fm_get_freq(core));
> +
> +	mutex_unlock(&core->lock);
> +
> +	return 0;
> +}
> +
> +static int wl1273_fm_vidioc_s_frequency(struct file *file, void *priv,
> +					struct v4l2_frequency *freq)
> +{
> +	struct wl1273_device *radio = video_get_drvdata(video_devdata(file));
> +	struct wl1273_core *core = radio->core;
> +	int r;
> +
> +	dev_dbg(radio->dev, "%s: %d\n", __func__, freq->frequency);
> +
> +	if (freq->type != V4L2_TUNER_RADIO) {
> +		dev_dbg(radio->dev,
> +			"freq->type != V4L2_TUNER_RADIO: %d\n", freq->type);
> +		return -EINVAL;
> +	}
> +
> +	if (mutex_lock_interruptible(&core->lock))
> +		return -EINTR;
> +
> +	if (core->mode == WL1273_MODE_RX) {
> +		dev_dbg(radio->dev, "freq: %d\n", freq->frequency);
> +
> +		r = wl1273_fm_set_rx_freq(core,
> +					  WL1273_INV_FREQ(freq->frequency));
> +		if (r)
> +			dev_warn(radio->dev, WL1273_FM_DRIVER_NAME
> +				 ": set frequency failed with %d\n", r);
> +	} else {
> +		r = wl1273_fm_set_tx_freq(core,
> +					  WL1273_INV_FREQ(freq->frequency));
> +		if (r)
> +			dev_warn(radio->dev, WL1273_FM_DRIVER_NAME
> +				 ": set frequency failed with %d\n", r);
> +	}
> +
> +	mutex_unlock(&core->lock);
> +
> +	dev_dbg(radio->dev, "wl1273_vidioc_s_frequency: DONE\n");
> +	return r;
> +}
> +
> +#define WL1273_DEFAULT_SEEK_LEVEL	7
> +
> +static int wl1273_fm_vidioc_s_hw_freq_seek(struct file *file, void *priv,
> +					   struct v4l2_hw_freq_seek *seek)
> +{
> +	struct wl1273_device *radio = video_get_drvdata(video_devdata(file));
> +	struct wl1273_core *core = radio->core;
> +	int r;
> +
> +	dev_dbg(radio->dev, "%s\n", __func__);
> +
> +	if (seek->tuner != 0 || seek->type != V4L2_TUNER_RADIO)
> +		return -EINVAL;
> +
> +	if (mutex_lock_interruptible(&core->lock))
> +		return -EINTR;
> +
> +	r = wl1273_fm_set_mode(core, WL1273_MODE_RX);
> +	if (r)
> +		goto out;
> +
> +	r = wl1273_fm_tx_set_spacing(core, seek->spacing);
> +	if (r)
> +		dev_warn(radio->dev, "HW seek failed: %d\n", r);
> +
> +	r = wl1273_fm_set_seek(core, seek->wrap_around, seek->seek_upward,
> +			       WL1273_DEFAULT_SEEK_LEVEL);
> +	if (r)
> +		dev_warn(radio->dev, "HW seek failed: %d\n", r);
> +
> +	mutex_unlock(&core->lock);
> + out:
> +	return r;
> +}
> +
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

There is no support for SUB_MONO or SUB_STEREO?

> +
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
> +
> +	dev_dbg(radio->dev, "%s\n", __func__);
> +
> +	if (mutex_lock_interruptible(&core->lock))
> +		return -EINTR;
> +
> +	strcpy(modulator->name, WL1273_FM_DRIVER_NAME);
> +
> +	modulator->rangelow =
> +		WL1273_FREQ(core->bands[core->band].bottom_frequency);
> +	modulator->rangehigh =
> +		WL1273_FREQ(core->bands[core->band].top_frequency);
> +
> +	modulator->capability = V4L2_TUNER_CAP_RDS;

Shouldn't CAP_LOW and CAP_STEREO be added here?

> +
> +	if (core->rds_on)
> +		modulator->txsubchans |= V4L2_TUNER_SUB_RDS;
> +	else
> +		modulator->txsubchans &= ~V4L2_TUNER_SUB_RDS;

The SUB_MONO/SUB_STEREO flags aren't handled here.

> +
> +	mutex_unlock(&core->lock);
> +
> +	return 0;
> +}
> +

The g/s_tuner and g/s_modulator functions are always hard to get right. Lots of
tricky flags and settings...

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG, part of Cisco
