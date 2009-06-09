Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr4.xs4all.nl ([194.109.24.24]:1237 "EHLO
	smtp-vbr4.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760879AbZFIKmB (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 9 Jun 2009 06:42:01 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Eduardo Valentin <eduardo.valentin@nokia.com>
Subject: Re: [PATCHv6 5 of 7] FMTx: si4713: Add files to add radio interface for si4713
Date: Tue, 9 Jun 2009 12:41:38 +0200
Cc: "ext Mauro Carvalho Chehab" <mchehab@infradead.org>,
	"ext Douglas Schilling Landgraf" <dougsland@gmail.com>,
	Linux-Media <linux-media@vger.kernel.org>,
	"Nurkkala Eero.An (EXT-Offcode/Oulu)" <ext-Eero.Nurkkala@nokia.com>
References: <1244449087-5543-1-git-send-email-eduardo.valentin@nokia.com> <1244449087-5543-5-git-send-email-eduardo.valentin@nokia.com> <1244449087-5543-6-git-send-email-eduardo.valentin@nokia.com>
In-Reply-To: <1244449087-5543-6-git-send-email-eduardo.valentin@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906091241.38423.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Monday 08 June 2009 10:18:05 Eduardo Valentin wrote:
> From: Eduardo Valentin <eduardo.valentin@nokia.com>
> 
> # HG changeset patch
> # User "Eduardo Valentin <eduardo.valentin@nokia.com>"
> # Date 1244446611 -10800
> # Node ID 92ec243dd1882c136a588898dd5b7a1913ca0f4b
> # Parent  2456c8fc506ecf928d2e95da36d611d094c0ec55
> This patch adds files which creates the radio interface
> for si4713 FM transmitter devices.
> 
> Priority: normal
> 
> Signed-off-by: "Eduardo Valentin <eduardo.valentin@nokia.com>"
> 
> diff -r 2456c8fc506e -r 92ec243dd188 linux/drivers/media/radio/radio-si4713.c
> --- /dev/null	Thu Jan 01 00:00:00 1970 +0000
> +++ b/linux/drivers/media/radio/radio-si4713.c	Mon Jun 08 10:36:51 2009 +0300
> @@ -0,0 +1,332 @@
> +/*
> + * drivers/media/radio/radio-si4713.c
> + *
> + * Platform Driver for Silicon Labs Si4713 FM Radio Transmitter:
> + *
> + * Copyright (c) 2008 Instituto Nokia de Tecnologia - INdT
> + * Contact: Eduardo Valentin <eduardo.valentin@nokia.com>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program; if not, write to the Free Software
> + * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
> + */
> +
> +#include <linux/kernel.h>
> +#include <linux/module.h>
> +#include <linux/init.h>
> +#include <linux/version.h>
> +#include <linux/platform_device.h>
> +#include <linux/i2c.h>
> +#include <linux/videodev2.h>
> +#include <media/v4l2-device.h>
> +#include <media/v4l2-common.h>
> +#include <media/v4l2-ioctl.h>
> +
> +#include "radio-si4713.h"
> +#include "si4713.h"
> +
> +/* module parameters */
> +static int radio_nr = -1;	/* radio device minor (-1 ==> auto assign) */
> +
> +/* radio_si4713_fops - file operations interface */
> +static const struct v4l2_file_operations radio_si4713_fops = {
> +	.owner		= THIS_MODULE,
> +	.ioctl		= video_ioctl2,
> +};
> +
> +/* Video4Linux Interface */
> +static int radio_si4713_vidioc_g_audio(struct file *file, void *priv,
> +					struct v4l2_audio *audio)
> +{
> +	if (audio->index > 1)
> +		return -EINVAL;
> +
> +	strncpy(audio->name, "Radio", 32);
> +	audio->capability = V4L2_AUDCAP_STEREO;
> +
> +	return 0;
> +}
> +
> +static int radio_si4713_vidioc_s_audio(struct file *file, void *priv,
> +					struct v4l2_audio *audio)
> +{
> +	if (audio->index != 0)
> +		return -EINVAL;
> +
> +	return 0;
> +}

This is a transmitter (aka modulator) device, so it should implement g_audout,
s_audout and enumaudout rather than s_audio and g_audio.

> +
> +static int radio_si4713_vidioc_g_input(struct file *file, void *priv,
> +					unsigned int *i)
> +{
> +	*i = 0;
> +
> +	return 0;
> +}
> +
> +static int radio_si4713_vidioc_s_input(struct file *file, void *priv,
> +					unsigned int i)
> +{
> +	if (i != 0)
> +		return -EINVAL;
> +
> +	return 0;
> +}

These are not needed: it is an audio only device, so no video. Since g/s_input
deals with video inputs these are not relevant. And even if it was, then it
would have to be g/s_output :-)

> +
> +/* radio_si4713_vidioc_querycap - query device capabilities */
> +static int radio_si4713_vidioc_querycap(struct file *file, void *priv,
> +					struct v4l2_capability *capability)
> +{
> +	struct radio_si4713_device *rsdev;
> +
> +	rsdev = video_get_drvdata(video_devdata(file));
> +
> +	strlcpy(capability->driver, "radio-si4713", sizeof(capability->driver));
> +	strlcpy(capability->card, "Silicon Labs Si4713 FM Radio Transmitter",
> +				sizeof(capability->card));
> +	capability->capabilities = V4L2_CAP_TUNER;
> +
> +	return 0;
> +}
> +
> +/* radio_si4713_vidioc_queryctrl - enumerate control items */
> +static int radio_si4713_vidioc_queryctrl(struct file *file, void *priv,
> +						struct v4l2_queryctrl *qc)
> +{
> +
> +	/* Must be sorted from low to high control ID! */
> +	static const u32 user_ctrls[] = {
> +		V4L2_CID_USER_CLASS,
> +		V4L2_CID_AUDIO_VOLUME,
> +		V4L2_CID_AUDIO_BALANCE,
> +		V4L2_CID_AUDIO_BASS,
> +		V4L2_CID_AUDIO_TREBLE,
> +		V4L2_CID_AUDIO_LOUDNESS,
> +		V4L2_CID_AUDIO_MUTE,
> +		0
> +	};
> +
> +	/* Must be sorted from low to high control ID! */
> +	static const u32 fmtx_ctrls[] = {
> +		V4L2_CID_FMTX_CLASS,
> +		V4L2_CID_RDS_ENABLED,
> +		V4L2_CID_RDS_PI,
> +		V4L2_CID_RDS_PTY,
> +		V4L2_CID_RDS_PS_NAME,
> +		V4L2_CID_RDS_RADIO_TEXT,
> +		V4L2_CID_AUDIO_LIMITER_ENABLED,
> +		V4L2_CID_AUDIO_LIMITER_RELEASE_TIME,
> +		V4L2_CID_AUDIO_LIMITER_DEVIATION,
> +		V4L2_CID_AUDIO_COMPRESSION_ENABLED,
> +		V4L2_CID_AUDIO_COMPRESSION_GAIN,
> +		V4L2_CID_AUDIO_COMPRESSION_THRESHOLD,
> +		V4L2_CID_AUDIO_COMPRESSION_ATTACK_TIME,
> +		V4L2_CID_AUDIO_COMPRESSION_RELEASE_TIME,
> +		V4L2_CID_PILOT_TONE_ENABLED,
> +		V4L2_CID_PILOT_TONE_DEVIATION,
> +		V4L2_CID_PILOT_TONE_FREQUENCY,
> +		V4L2_CID_PREEMPHASIS,
> +		V4L2_CID_TUNE_POWER_LEVEL,
> +		V4L2_CID_TUNE_ANTENNA_CAPACITOR,
> +		0
> +	};
> +	static const u32 *ctrl_classes[] = {
> +		user_ctrls,
> +		fmtx_ctrls,
> +		NULL
> +	};
> +	struct radio_si4713_device *rsdev;
> +
> +	rsdev = video_get_drvdata(video_devdata(file));
> +
> +	qc->id = v4l2_ctrl_next(ctrl_classes, qc->id);
> +	if (qc->id == 0)
> +		return -EINVAL;
> +
> +	if (qc->id == V4L2_CID_USER_CLASS || qc->id == V4L2_CID_FMTX_CLASS)
> +		return v4l2_ctrl_query_fill(qc, 0, 0, 0, 0);
> +
> +	return v4l2_device_call_until_err(&rsdev->v4l2_dev, 0, core,
> +						queryctrl, qc);
> +}
> +
> +
> +/*
> + * radio_si4713_vidioc_template - Produce a v4l2 vidioc call back.
> + * Can be used because we are just a wrapper for v4l2_sub_devs.
> + */
> +#define radio_si4713_vidioc_template(type, callback, arg_type)		\
> +static int radio_si4713_vidioc_##callback(struct file *file, void *p,	\
> +						arg_type a)		\
> +{									\
> +	struct radio_si4713_device *rsdev;				\
> +									\
> +	rsdev = video_get_drvdata(video_devdata(file));			\
> +									\
> +	return v4l2_device_call_until_err(&rsdev->v4l2_dev, 0, type,	\
> +							callback, a);	\
> +}
> +
> +radio_si4713_vidioc_template(core, g_ext_ctrls, struct v4l2_ext_controls *)
> +radio_si4713_vidioc_template(core, s_ext_ctrls, struct v4l2_ext_controls *)
> +radio_si4713_vidioc_template(core, g_ctrl, struct v4l2_control *)
> +radio_si4713_vidioc_template(core, s_ctrl, struct v4l2_control *)
> +radio_si4713_vidioc_template(tuner, g_tuner, struct v4l2_tuner *)
> +radio_si4713_vidioc_template(tuner, s_tuner, struct v4l2_tuner *)
> +radio_si4713_vidioc_template(tuner, g_frequency, struct v4l2_frequency *)
> +radio_si4713_vidioc_template(tuner, s_frequency, struct v4l2_frequency *)

Yuck. Just write it like this:

static inline struct v4l2_device *get_v4l2_dev(struct file *file)
{
	return &((struct radio_si4713_device *)video_drvdata(file))->v4l2_dev;
}

static int radio_si4713_vidioc_g_tuner(struct file *file, void *priv,
						struct v4l2_tuner *t)
{
	return v4l2_device_call_until_err(get_v4l2_dev(file), 0, tuner, g_tuner, t);
}

It's much nicer than using macros.

I also suggest shortening the function name to si4713_g_tuner. The current
naming convention is a bit of a mouthful.

> +
> +static struct v4l2_ioctl_ops radio_si4713_ioctl_ops = {
> +	.vidioc_g_input		= radio_si4713_vidioc_g_input,
> +	.vidioc_s_input		= radio_si4713_vidioc_s_input,
> +	.vidioc_g_audio		= radio_si4713_vidioc_g_audio,
> +	.vidioc_s_audio		= radio_si4713_vidioc_s_audio,
> +	.vidioc_querycap	= radio_si4713_vidioc_querycap,
> +	.vidioc_queryctrl	= radio_si4713_vidioc_queryctrl,
> +	.vidioc_g_ext_ctrls	= radio_si4713_vidioc_g_ext_ctrls,
> +	.vidioc_s_ext_ctrls	= radio_si4713_vidioc_s_ext_ctrls,
> +	.vidioc_g_ctrl		= radio_si4713_vidioc_g_ctrl,
> +	.vidioc_s_ctrl		= radio_si4713_vidioc_s_ctrl,
> +	.vidioc_g_tuner		= radio_si4713_vidioc_g_tuner,
> +	.vidioc_s_tuner		= radio_si4713_vidioc_s_tuner,

It's a modulator device, so it should implement g/s_modulator rather than
g/s_tuner.

Now, here I am running into a problem: looking at section 1.6.2 in the v4l2
spec I see that in QUERYCAP you are supposed to return CAP_TUNER and rely on
ENUMOUTPUT to determine which output has a modulator. I think it is nuts that
there is no CAP_MODULATOR. I propose adding this. There are currently NO
modulator drivers in v4l-dvb, nor have I ever heard from out-of-tree
modulator drivers (not that I particularly care about that), so it should be
safe to add it.

The next problem is that ENUMOUTPUT does not apply to a radio modulator.
This problem is actually also present on radio tuners. Currently all radio
tuner drivers implement g/s_input and g/s_audio but no enuminput or enumaudio.

I think g/s_input is bogus since these devices have no video inputs.
However, neither g/s_audio nor enumaudio can currently tell the application
whether the audio input is connected to a tuner. Only enuminput can do that
currently. This would be an argument for using g/s_input if it wasn't for
the fact that none of the radio drivers actually implements enuminput.

I propose adding a V4L2_AUDCAP_TUNER capability telling this application
that the audio input is connected to a tuner, and adding a
V4L2_AUDOUTCAP_MODULATOR capability for struct v4l2_audioout to do the same
for a modulator.

Comments?

Regards,

	Hans


> +	.vidioc_g_frequency	= radio_si4713_vidioc_g_frequency,
> +	.vidioc_s_frequency	= radio_si4713_vidioc_s_frequency,
> +};
> +
> +/* radio_si4713_vdev_template - video device interface */
> +static struct video_device radio_si4713_vdev_template = {
> +	.fops			= &radio_si4713_fops,
> +	.name			= "radio-si4713",
> +	.release		= video_device_release,
> +	.ioctl_ops		= &radio_si4713_ioctl_ops,
> +};
> +
> +/* Platform driver interface */
> +/* radio_si4713_pdriver_probe - probe for the device */
> +static int radio_si4713_pdriver_probe(struct platform_device *pdev)
> +{
> +	struct radio_si4713_platform_data *pdata = pdev->dev.platform_data;
> +	struct radio_si4713_device *rsdev;
> +	struct i2c_adapter *adapter;
> +	struct v4l2_subdev *sd;
> +	int rval = 0;
> +
> +	if (!pdata) {
> +		dev_err(&pdev->dev, "Cannot proceed without platform data.\n");
> +		rval = -EINVAL;
> +		goto exit;
> +	}
> +
> +	rsdev = kzalloc(sizeof *rsdev, GFP_KERNEL);
> +	if (!rsdev) {
> +		dev_err(&pdev->dev, "Failed to alloc video device.\n");
> +		rval = -ENOMEM;
> +		goto exit;
> +	}
> +
> +	rval = v4l2_device_register(&pdev->dev, &rsdev->v4l2_dev);
> +	if (rval) {
> +		dev_err(&pdev->dev, "Failed to register v4l2 device.\n");
> +		goto free_rsdev;
> +	}
> +
> +	adapter = i2c_get_adapter(pdata->i2c_bus);
> +	if (!adapter) {
> +		dev_err(&pdev->dev, "Cannot get i2c adapter %d\n",
> +							pdata->i2c_bus);
> +		rval = -ENODEV;
> +		goto unregister_v4l2_dev;
> +	}
> +
> +	sd = v4l2_i2c_new_subdev_board(&rsdev->v4l2_dev, adapter, "si4713_i2c",
> +					pdata->subdev_board_info, NULL);
> +	if (!sd) {
> +		dev_err(&pdev->dev, "Cannot get v4l2 subdevice\n");
> +		rval = -ENODEV;
> +		goto unregister_v4l2_dev;
> +	}
> +
> +	rsdev->radio_dev = video_device_alloc();
> +	if (!rsdev->radio_dev) {
> +		dev_err(&pdev->dev, "Failed to alloc video device.\n");
> +		rval = -ENOMEM;
> +		goto unregister_v4l2_dev;
> +	}
> +
> +	memcpy(rsdev->radio_dev, &radio_si4713_vdev_template,
> +			sizeof(radio_si4713_vdev_template));
> +	video_set_drvdata(rsdev->radio_dev, rsdev);
> +	if (video_register_device(rsdev->radio_dev, VFL_TYPE_RADIO, radio_nr)) {
> +		dev_err(&pdev->dev, "Could not register video device.\n");
> +		rval = -EIO;
> +		goto free_vdev;
> +	}
> +	dev_info(&pdev->dev, "New device successfully probed\n");
> +
> +	goto exit;
> +
> +free_vdev:
> +	video_device_release(rsdev->radio_dev);
> +unregister_v4l2_dev:
> +	v4l2_device_unregister(&rsdev->v4l2_dev);
> +free_rsdev:
> +	kfree(rsdev);
> +exit:
> +	return rval;
> +}
> +
> +/* radio_si4713_pdriver_remove - remove the device */
> +static int __exit radio_si4713_pdriver_remove(struct platform_device *pdev)
> +{
> +	struct v4l2_device *v4l2_dev = platform_get_drvdata(pdev);
> +	struct radio_si4713_device *rsdev = container_of(v4l2_dev,
> +						struct radio_si4713_device,
> +						v4l2_dev);
> +
> +	video_unregister_device(rsdev->radio_dev);
> +	v4l2_device_unregister(&rsdev->v4l2_dev);
> +	kfree(rsdev);
> +
> +	return 0;
> +}
> +
> +static struct platform_driver radio_si4713_pdriver = {
> +	.driver		= {
> +		.name	= "radio-si4713",
> +	},
> +	.probe		= radio_si4713_pdriver_probe,
> +	.remove         = __exit_p(radio_si4713_pdriver_remove),
> +};
> +
> +/* Module Interface */
> +static int __init radio_si4713_module_init(void)
> +{
> +	return platform_driver_register(&radio_si4713_pdriver);
> +}
> +
> +static void __exit radio_si4713_module_exit(void)
> +{
> +	platform_driver_unregister(&radio_si4713_pdriver);
> +}
> +
> +module_init(radio_si4713_module_init);
> +module_exit(radio_si4713_module_exit);
> +
> +module_param(radio_nr, int, 0);
> +MODULE_PARM_DESC(radio_nr,
> +		 "Minor number for radio device (-1 ==> auto assign)");
> +
> +MODULE_LICENSE("GPL");
> +MODULE_AUTHOR("Eduardo Valentin <eduardo.valentin@nokia.com>");
> +MODULE_DESCRIPTION("Platform driver for Si4713 FM Radio Transmitter");
> +MODULE_VERSION("0.0.1");
> diff -r 2456c8fc506e -r 92ec243dd188 linux/drivers/media/radio/radio-si4713.h
> --- /dev/null	Thu Jan 01 00:00:00 1970 +0000
> +++ b/linux/drivers/media/radio/radio-si4713.h	Mon Jun 08 10:36:51 2009 +0300
> @@ -0,0 +1,48 @@
> +/*
> + * drivers/media/radio/radio-si4713.h
> + *
> + * Property and commands definitions for Si4713 radio transmitter chip.
> + *
> + * Copyright (c) 2008 Instituto Nokia de Tecnologia - INdT
> + * Contact: Eduardo Valentin <eduardo.valentin@nokia.com>
> + *
> + * This file is licensed under the terms of the GNU General Public License
> + * version 2. This program is licensed "as is" without any warranty of any
> + * kind, whether express or implied.
> + *
> + */
> +
> +#ifndef RADIO_SI4713_H
> +#define RADIO_SI4713_H
> +
> +#include <linux/i2c.h>
> +#include <media/v4l2-device.h>
> +
> +#define SI4713_NAME "radio-si4713"
> +
> +/* The SI4713 I2C sensor chip has a fixed slave address of 0xc6. */
> +#define SI4713_I2C_ADDR_BUSEN_HIGH	0x63
> +#define SI4713_I2C_ADDR_BUSEN_LOW	0x11
> +
> +/*
> + * Platform dependent definition
> + */
> +struct si4713_platform_data {
> +	/* Set power state, zero is off, non-zero is on. */
> +	int (*set_power)(int power);
> +};
> +
> +/*
> + * Platform driver device state struct
> + */
> +struct radio_si4713_device {
> +	struct v4l2_device		v4l2_dev;
> +	struct video_device		*radio_dev;
> +};
> +
> +struct radio_si4713_platform_data {
> +	int i2c_bus;
> +	struct i2c_board_info *subdev_board_info;
> +};
> +
> +#endif /* ifndef RADIO_SI4713_H*/
> 
> 



-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG Telecom
