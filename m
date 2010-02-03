Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr6.xs4all.nl ([194.109.24.26]:4197 "EHLO
	smtp-vbr6.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755177Ab0BCOlZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 3 Feb 2010 09:41:25 -0500
Date: Wed, 3 Feb 2010 15:41:04 +0100 (CET)
From: Hans Verkuil <hverkuil@xs4all.nl>
To: =?ISO-8859-15?Q?Richard_R=F6jfors?=
	<richard.rojfors@pelagicore.com>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Douglas Schilling Landgraf <dougsland@gmail.com>
Subject: Re: [PATCH v3 1/1] radio: Add radio-timb
In-Reply-To: <4B6983CF.2040406@pelagicore.com>
Message-ID: <alpine.LNX.2.01.1002031534350.18547@alastor>
References: <4B6983CF.2040406@pelagicore.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Richard,

On Wed, 3 Feb 2010, Richard R?jfors wrote:

> This patch add supports for the radio system on the Intel Russellville board.
>
> It's a In-Vehicle Infotainment board with a radio tuner and DSP.
>
> This umbrella driver has the DSP and tuner as V4L2 subdevs and calls them
> when needed.
>
> Signed-off-by: Richard R?jfors <richard.rojfors@pelagicore.com>
> ---
> diff --git a/drivers/media/radio/Kconfig b/drivers/media/radio/Kconfig
> index 3f40f37..c242939 100644
> --- a/drivers/media/radio/Kconfig
> +++ b/drivers/media/radio/Kconfig
> @@ -429,4 +429,14 @@ config RADIO_TEF6862
> 	  To compile this driver as a module, choose M here: the
> 	  module will be called TEF6862.
>
> +config RADIO_TIMBERDALE
> +	tristate "Enable the Timberdale radio driver"
> +	depends on MFD_TIMBERDALE && VIDEO_V4L2
> +	select RADIO_TEF6862
> +	select RADIO_SAA7706H
> +	---help---
> +	  This is a kind of umbrella driver for the Radio Tuner and DSP
> +	  found behind the Timberdale FPGA on the Russellville board.
> +	  Enabling this driver will automatically select the DSP and tuner.
> +
> endif # RADIO_ADAPTERS
> diff --git a/drivers/media/radio/Makefile b/drivers/media/radio/Makefile
> index 01922ad..8973850 100644
> --- a/drivers/media/radio/Makefile
> +++ b/drivers/media/radio/Makefile
> @@ -24,5 +24,6 @@ obj-$(CONFIG_RADIO_SI470X) += si470x/
> obj-$(CONFIG_USB_MR800) += radio-mr800.o
> obj-$(CONFIG_RADIO_TEA5764) += radio-tea5764.o
> obj-$(CONFIG_RADIO_TEF6862) += tef6862.o
> +obj-$(CONFIG_RADIO_TIMBERDALE) += radio-timb.o
>
> EXTRA_CFLAGS += -Isound
> diff --git a/drivers/media/radio/radio-timb.c 
> b/drivers/media/radio/radio-timb.c
> new file mode 100644
> index 0000000..c650865
> --- /dev/null
> +++ b/drivers/media/radio/radio-timb.c
> @@ -0,0 +1,260 @@
> +/*
> + * radio-timb.c Timberdale FPGA Radio driver
> + * Copyright (c) 2009 Intel Corporation
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
> + * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
> + */
> +
> +#include <linux/version.h>
> +#include <linux/io.h>
> +#include <media/v4l2-ioctl.h>
> +#include <media/v4l2-device.h>
> +#include <linux/platform_device.h>
> +#include <linux/interrupt.h>
> +#include <linux/i2c.h>
> +#include <media/timb_radio.h>
> +
> +#define DRIVER_NAME "timb-radio"
> +
> +struct timbradio {
> +	struct timb_radio_platform_data	pdata;
> +	struct v4l2_subdev	*sd_tuner;
> +	struct v4l2_subdev	*sd_dsp;
> +	struct video_device	*video_dev;

Recommend removing '*' here. See notes below.

> +	struct v4l2_device	v4l2_dev;
> +};
> +
> +
> +static int timbradio_vidioc_querycap(struct file *file, void  *priv,
> +	struct v4l2_capability *v)
> +{
> +	strlcpy(v->driver, DRIVER_NAME, sizeof(v->driver));
> +	strlcpy(v->card, "Timberdale Radio", sizeof(v->card));
> +	snprintf(v->bus_info, sizeof(v->bus_info), "platform:"DRIVER_NAME);
> +	v->version = KERNEL_VERSION(0, 0, 1);
> +	v->capabilities = V4L2_CAP_TUNER | V4L2_CAP_RADIO;
> +	return 0;
> +}
> +
> +static int timbradio_vidioc_g_tuner(struct file *file, void *priv,
> +	struct v4l2_tuner *v)
> +{
> +	struct timbradio *tr = video_drvdata(file);
> +	return v4l2_subdev_call(tr->sd_tuner, tuner, g_tuner, v);
> +}
> +
> +static int timbradio_vidioc_s_tuner(struct file *file, void *priv,
> +	struct v4l2_tuner *v)
> +{
> +	struct timbradio *tr = video_drvdata(file);
> +	return v4l2_subdev_call(tr->sd_tuner, tuner, s_tuner, v);
> +}
> +
> +static int timbradio_vidioc_g_input(struct file *filp, void *priv,
> +	unsigned int *i)
> +{
> +	*i = 0;
> +	return 0;
> +}
> +
> +static int timbradio_vidioc_s_input(struct file *filp, void *priv,
> +	unsigned int i)
> +{
> +	return i ? -EINVAL : 0;
> +}
> +
> +static int timbradio_vidioc_g_audio(struct file *file, void *priv,
> +	struct v4l2_audio *a)
> +{
> +	a->index = 0;
> +	strlcpy(a->name, "Radio", sizeof(a->name));
> +	a->capability = V4L2_AUDCAP_STEREO;
> +	return 0;
> +}
> +
> +
> +static int timbradio_vidioc_s_audio(struct file *file, void *priv,
> +	struct v4l2_audio *a)
> +{
> +	return a->index ? -EINVAL : 0;
> +}
> +
> +static int timbradio_vidioc_s_frequency(struct file *file, void *priv,
> +	struct v4l2_frequency *f)
> +{
> +	struct timbradio *tr = video_drvdata(file);
> +	return v4l2_subdev_call(tr->sd_tuner, tuner, s_frequency, f);
> +}
> +
> +static int timbradio_vidioc_g_frequency(struct file *file, void *priv,
> +	struct v4l2_frequency *f)
> +{
> +	struct timbradio *tr = video_drvdata(file);
> +	return v4l2_subdev_call(tr->sd_tuner, tuner, g_frequency, f);
> +}
> +
> +static int timbradio_vidioc_queryctrl(struct file *file, void *priv,
> +	struct v4l2_queryctrl *qc)
> +{
> +	struct timbradio *tr = video_drvdata(file);
> +	return v4l2_subdev_call(tr->sd_dsp, core, queryctrl, qc);
> +}
> +
> +static int timbradio_vidioc_g_ctrl(struct file *file, void *priv,
> +	struct v4l2_control *ctrl)
> +{
> +	struct timbradio *tr = video_drvdata(file);
> +	return v4l2_subdev_call(tr->sd_dsp, core, g_ctrl, ctrl);
> +}
> +
> +static int timbradio_vidioc_s_ctrl(struct file *file, void *priv,
> +	struct v4l2_control *ctrl)
> +{
> +	struct timbradio *tr = video_drvdata(file);
> +	return v4l2_subdev_call(tr->sd_dsp, core, s_ctrl, ctrl);
> +}
> +
> +static const struct v4l2_ioctl_ops timbradio_ioctl_ops = {
> +	.vidioc_querycap	= timbradio_vidioc_querycap,
> +	.vidioc_g_tuner		= timbradio_vidioc_g_tuner,
> +	.vidioc_s_tuner		= timbradio_vidioc_s_tuner,
> +	.vidioc_g_frequency	= timbradio_vidioc_g_frequency,
> +	.vidioc_s_frequency	= timbradio_vidioc_s_frequency,
> +	.vidioc_g_input		= timbradio_vidioc_g_input,
> +	.vidioc_s_input		= timbradio_vidioc_s_input,
> +	.vidioc_g_audio		= timbradio_vidioc_g_audio,
> +	.vidioc_s_audio		= timbradio_vidioc_s_audio,
> +	.vidioc_queryctrl	= timbradio_vidioc_queryctrl,
> +	.vidioc_g_ctrl		= timbradio_vidioc_g_ctrl,
> +	.vidioc_s_ctrl		= timbradio_vidioc_s_ctrl
> +};
> +
> +static const struct v4l2_file_operations timbradio_fops = {
> +	.owner		= THIS_MODULE,
> +	.ioctl		= video_ioctl2,
> +};
> +
> +static const struct video_device timbradio_template = {
> +	.name		= "Timberdale Radio",
> +	.fops		= &timbradio_fops,
> +	.ioctl_ops 	= &timbradio_ioctl_ops,
> +	.release	= video_device_release_empty,
> +	.minor		= -1
> +};
> +
> +
> +static int __devinit timbradio_probe(struct platform_device *pdev)
> +{
> +	struct timb_radio_platform_data *pdata = pdev->dev.platform_data;
> +	struct timbradio *tr;
> +	int err;
> +
> +	if (!pdata) {
> +		dev_err(&pdev->dev, "Platform data missing\n");
> +		err = -EINVAL;
> +		goto err;
> +	}
> +
> +	tr = kzalloc(sizeof(*tr), GFP_KERNEL);
> +	if (!tr) {
> +		err = -ENOMEM;
> +		goto err;
> +	}
> +
> +	tr->pdata = *pdata;
> +
> +	tr->video_dev = video_device_alloc();
> +	if (!tr->video_dev) {
> +		err = -ENOMEM;
> +		goto err_video_alloc;
> +	}
> +	*tr->video_dev = timbradio_template;

This is a mismatch: either embed struct video_device in struct timbradio and
use video_device_release_empty, or use video_device_alloc and use
video_device_release. I personally prefer to embed it.

The way it is done now creates a memory leak since tr->video_dev is now never
freed.

Note that I would also recommend filling in the video_dev fields explicitly
instead of from a template. That way you clearly see how the struct is
initialized instead of having to hunt for the template definition.

Regards,

 	Hans

> +
> +	strlcpy(tr->v4l2_dev.name, DRIVER_NAME, sizeof(tr->v4l2_dev.name));
> +	err = v4l2_device_register(NULL, &tr->v4l2_dev);
> +	if (err)
> +		goto err_v4l2_dev;
> +
> +	tr->video_dev->v4l2_dev = &tr->v4l2_dev;
> +
> +	err = video_register_device(tr->video_dev, VFL_TYPE_RADIO, -1);
> +	if (err) {
> +		dev_err(&pdev->dev, "Error reg video\n");
> +		goto err_video_req;
> +	}
> +
> +	video_set_drvdata(tr->video_dev, tr);
> +
> +	platform_set_drvdata(pdev, tr);
> +	return 0;
> +
> +err_video_req:
> +	v4l2_device_unregister(&tr->v4l2_dev);
> +err_v4l2_dev:
> +	if (tr->video_dev->minor != -1)
> +		video_unregister_device(tr->video_dev);
> +	else
> +		video_device_release(tr->video_dev);
> +err_video_alloc:
> +	kfree(tr);
> +err:
> +	dev_err(&pdev->dev, "Failed to register: %d\n", err);
> +
> +	return err;
> +}
> +
> +static int __devexit timbradio_remove(struct platform_device *pdev)
> +{
> +	struct timbradio *tr = platform_get_drvdata(pdev);
> +
> +	if (tr->video_dev->minor != -1)
> +		video_unregister_device(tr->video_dev);
> +	else
> +		video_device_release(tr->video_dev);
> +
> +	v4l2_device_unregister(&tr->v4l2_dev);
> +
> +	kfree(tr);
> +
> +	return 0;
> +}
> +
> +static struct platform_driver timbradio_platform_driver = {
> +	.driver = {
> +		.name	= DRIVER_NAME,
> +		.owner	= THIS_MODULE,
> +	},
> +	.probe		= timbradio_probe,
> +	.remove		= timbradio_remove,
> +};
> +
> +/*--------------------------------------------------------------------------*/
> +
> +static int __init timbradio_init(void)
> +{
> +	return platform_driver_register(&timbradio_platform_driver);
> +}
> +
> +static void __exit timbradio_exit(void)
> +{
> +	platform_driver_unregister(&timbradio_platform_driver);
> +}
> +
> +module_init(timbradio_init);
> +module_exit(timbradio_exit);
> +
> +MODULE_DESCRIPTION("Timberdale Radio driver");
> +MODULE_AUTHOR("Mocean Laboratories <info@mocean-labs.com>");
> +MODULE_LICENSE("GPL v2");
> +MODULE_ALIAS("platform:"DRIVER_NAME);
> diff --git a/include/media/timb_radio.h b/include/media/timb_radio.h
> new file mode 100644
> index 0000000..fcd32a3
> --- /dev/null
> +++ b/include/media/timb_radio.h
> @@ -0,0 +1,36 @@
> +/*
> + * timb_radio.h Platform struct for the Timberdale radio driver
> + * Copyright (c) 2009 Intel Corporation
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
> + * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
> + */
> +
> +#ifndef _TIMB_RADIO_
> +#define _TIMB_RADIO_ 1
> +
> +#include <linux/i2c.h>
> +
> +struct timb_radio_platform_data {
> +	int i2c_adapter; /* I2C adapter where the tuner and dsp are attached 
> */
> +	struct {
> +		const char *module_name;
> +		struct i2c_board_info *info;
> +	} tuner;
> +	struct {
> +		const char *module_name;
> +		struct i2c_board_info *info;
> +	} dsp;
> +};
> +
> +#endif
>
