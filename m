Return-path: <mchehab@pedra>
Received: from smtp-vbr16.xs4all.nl ([194.109.24.36]:2928 "EHLO
	smtp-vbr16.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752095Ab0H1J7O (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 28 Aug 2010 05:59:14 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: "Matti J. Aaltonen" <matti.j.aaltonen@nokia.com>
Subject: Re: [PATCH v8 4/5] V4L2: WL1273 FM Radio: Controls for the FM radio.
Date: Sat, 28 Aug 2010 11:58:46 +0200
Cc: linux-media@vger.kernel.org, eduardo.valentin@nokia.com,
	mchehab@redhat.com
References: <1282813338-13882-1-git-send-email-matti.j.aaltonen@nokia.com> <1282813338-13882-4-git-send-email-matti.j.aaltonen@nokia.com> <1282813338-13882-5-git-send-email-matti.j.aaltonen@nokia.com>
In-Reply-To: <1282813338-13882-5-git-send-email-matti.j.aaltonen@nokia.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-6"
Content-Transfer-Encoding: 7bit
Message-Id: <201008281158.46115.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

On Thursday, August 26, 2010 11:02:17 Matti J. Aaltonen wrote:
> This driver implements V4L2 controls for the Texas Instruments
> WL1273 FM Radio.
> 
> Signed-off-by: Matti J. Aaltonen <matti.j.aaltonen@nokia.com>
> ---
>  drivers/media/radio/Kconfig        |   15 +
>  drivers/media/radio/Makefile       |    1 +
>  drivers/media/radio/radio-wl1273.c | 1947 ++++++++++++++++++++++++++++++++++++
>  drivers/mfd/Kconfig                |    5 +
>  drivers/mfd/Makefile               |    2 +
>  5 files changed, 1970 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/media/radio/radio-wl1273.c

<skip>

> +static int wl1273_fm_g_volatile_ctrl(struct v4l2_ctrl *ctrl)
> +{
> +	struct wl1273_device *radio = ctrl->priv;
> +	struct wl1273_core *core = radio->core;
> +
> +	dev_dbg(radio->dev, "%s\n", __func__);
> +
> +	if (mutex_lock_interruptible(&core->lock))
> +		return -EINTR;
> +
> +	switch (ctrl->id) {
> +	case  V4L2_CID_TUNE_ANTENNA_CAPACITOR:
> +		ctrl->val = wl1273_fm_get_tx_ctune(core);
> +		break;
> +
> +	default:
> +		dev_warn(radio->dev, "%s: Unknown IOCTL: %d\n",
> +			 __func__, ctrl->id);
> +		break;
> +	}
> +
> +	mutex_unlock(&core->lock);
> +
> +	return 0;
> +}
> +
> +#define WL1273_MUTE_SOFT_ENABLE    (1 << 0)
> +#define WL1273_MUTE_AC             (1 << 1)
> +#define WL1273_MUTE_HARD_LEFT      (1 << 2)
> +#define WL1273_MUTE_HARD_RIGHT     (1 << 3)
> +#define WL1273_MUTE_SOFT_FORCE     (1 << 4)
> +
> +static int wl1273_fm_vidioc_s_ctrl(struct v4l2_ctrl *ctrl)
> +{
> +	struct wl1273_device *radio = ctrl->priv;

No need to use priv for this. You can use this instead:

static inline struct wl1273_device *to_radio(struct v4l2_ctrl *ctrl)
{
        return container_of(ctrl->handler, struct wl1273_device, ctrl_handler);
}

struct wl1273_device *radio = to_radio(ctrl);

> +	struct wl1273_core *core = radio->core;
> +	int r = 0;
> +
> +	dev_dbg(radio->dev, "%s\n", __func__);
> +
> +	switch (ctrl->id) {
> +	case V4L2_CID_AUDIO_MUTE:
> +		if (mutex_lock_interruptible(&core->lock))
> +			return -EINTR;
> +
> +		if (core->mode == WL1273_MODE_RX && ctrl->val)
> +			r = wl1273_fm_write_cmd(core,
> +						WL1273_MUTE_STATUS_SET,
> +						WL1273_MUTE_HARD_LEFT |
> +						WL1273_MUTE_HARD_RIGHT);
> +		else if (core->mode == WL1273_MODE_RX)
> +			r = wl1273_fm_write_cmd(core,
> +						WL1273_MUTE_STATUS_SET, 0x0);
> +		else if (core->mode == WL1273_MODE_TX && ctrl->val)
> +			r = wl1273_fm_write_cmd(core, WL1273_MUTE, 1);
> +		else if (core->mode == WL1273_MODE_TX)
> +			r = wl1273_fm_write_cmd(core, WL1273_MUTE, 0);
> +
> +		mutex_unlock(&core->lock);
> +		break;
> +
> +	case V4L2_CID_AUDIO_VOLUME:
> +		if (ctrl->val == 0)
> +			r = wl1273_fm_set_mode(core, WL1273_MODE_OFF);
> +		else
> +			r =  wl1273_fm_set_volume(core, core->volume);
> +		break;
> +
> +	case V4L2_CID_TUNE_PREEMPHASIS:
> +		r = wl1273_fm_set_preemphasis(core, ctrl->val);
> +		break;
> +
> +	case V4L2_CID_TUNE_POWER_LEVEL:
> +		r = wl1273_fm_set_tx_power(core, ctrl->val);
> +		break;
> +
> +	case V4L2_CID_FM_BAND:
> +		r = wl1273_fm_set_band(core, ctrl->val);
> +		break;
> +
> +	default:
> +		dev_warn(radio->dev, "%s: Unknown IOCTL: %d\n",
> +			 __func__, ctrl->id);
> +		break;
> +	}
> +
> +	dev_dbg(radio->dev, "%s\n", __func__);
> +	return r;
> +}

Was the documentation on the control handler understandable enough? Any
comments on how to improve the API or documentation? It's very new, so
I'm interested in hearing about your experiences implementing this API.

<skip>

> +static int __devinit wl1273_fm_radio_probe(struct platform_device *pdev)
> +{
> +	struct wl1273_core **pdata = pdev->dev.platform_data;
> +	struct wl1273_device *radio;
> +	struct v4l2_ctrl *ctrl;
> +	int r = 0;
> +
> +	dev_dbg(&pdev->dev, "%s\n", __func__);
> +
> +	if (!pdata) {
> +		dev_err(&pdev->dev, "No platform data.\n");
> +		r = -EINVAL;
> +		goto pdata_err;
> +	}
> +
> +	radio = kzalloc(sizeof(*radio), GFP_KERNEL);
> +	if (!radio) {
> +		r = -ENOMEM;
> +		goto pdata_err;
> +	}
> +
> +	radio->write_buf = kmalloc(256, GFP_KERNEL);
> +	if (!radio->write_buf) {
> +		r = -ENOMEM;
> +		goto write_buf_err;
> +	}
> +
> +	radio->core = *pdata;
> +	radio->dev = &pdev->dev;
> +	radio->v4l2dev.ctrl_handler = &radio->ctrl_handler;
> +	radio->rds_users = 0;
> +
> +	r = v4l2_device_register(&pdev->dev, &radio->v4l2dev);
> +	if (r) {
> +		dev_err(&pdev->dev, "Cannot register v4l2_device.\n");
> +		goto device_register_err;
> +	}
> +
> +	/* V4L2 configuration */
> +	memcpy(&radio->videodev, &wl1273_viddev_template,
> +	       sizeof(wl1273_viddev_template));
> +
> +	radio->videodev.v4l2_dev = &radio->v4l2dev;
> +
> +	/* register video device */
> +	r = video_register_device(&radio->videodev, VFL_TYPE_RADIO, radio_nr);
> +	if (r) {
> +		dev_err(&pdev->dev, WL1273_FM_DRIVER_NAME
> +			": Could not register video device\n");
> +		goto video_register_err;
> +	}
> +
> +	v4l2_ctrl_handler_init(&radio->ctrl_handler, 7);
> +	/* add in ascending ID order */
> +	ctrl = v4l2_ctrl_new_std(&radio->ctrl_handler, &wl1273_ctrl_ops,
> +				 V4L2_CID_AUDIO_VOLUME, 0, WL1273_MAX_VOLUME, 1,
> +				 WL1273_DEFAULT_VOLUME);
> +	if (ctrl)
> +		ctrl->priv = radio;

No need to use priv.

> +
> +	ctrl = v4l2_ctrl_new_std(&radio->ctrl_handler, &wl1273_ctrl_ops,
> +				 V4L2_CID_AUDIO_MUTE, 0, 1, 1, 1);
> +	if (ctrl)
> +		ctrl->priv = radio;
> +
> +	v4l2_ctrl_new_std(&radio->ctrl_handler, &wl1273_ctrl_ops,
> +			  V4L2_CID_TUNE_PREEMPHASIS, V4L2_PREEMPHASIS_DISABLED,
> +			  V4L2_PREEMPHASIS_75_uS, 1, V4L2_PREEMPHASIS_50_uS);
> +	if (ctrl)
> +		ctrl->priv = radio;
> +
> +	ctrl = v4l2_ctrl_new_std(&radio->ctrl_handler, &wl1273_ctrl_ops,
> +				 V4L2_CID_TUNE_POWER_LEVEL, 91, 122, 1, 118);
> +	if (ctrl)
> +		ctrl->priv = radio;
> +
> +	ctrl = v4l2_ctrl_new_std(&radio->ctrl_handler, &wl1273_ctrl_ops,
> +				 V4L2_CID_FM_BAND, V4L2_FM_BAND_OTHER,

First V4L2_CID_FM_BAND using new_std instead of new_std_menu (which it should
be).

> +				 V4L2_FM_BAND_JAPAN, 1, V4L2_FM_BAND_OTHER);
> +	if (ctrl)
> +		ctrl->priv = radio;
> +
> +	ctrl = v4l2_ctrl_new_std(&radio->ctrl_handler, &wl1273_ctrl_ops,
> +				 V4L2_CID_TUNE_ANTENNA_CAPACITOR,
> +				 0, 255, 1, 255);
> +	if (ctrl)
> +		ctrl->priv = radio;
> +
> +	ctrl = v4l2_ctrl_new_std_menu(&radio->ctrl_handler, &wl1273_ctrl_ops,
> +				      V4L2_CID_FM_BAND, V4L2_FM_BAND_JAPAN, 0,
> +				      V4L2_FM_BAND_OTHER);

And a second?!

> +	if (ctrl) {
> +		ctrl->is_volatile = 1;
> +		ctrl->priv = radio;
> +	}

And it is volatile? I thought that the ANTENNA_CAPACITOR was volatile.
Something is messed up here.

See also my other email on writing raw RDS data.

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG, part of Cisco
