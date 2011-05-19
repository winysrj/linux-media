Return-path: <mchehab@pedra>
Received: from smtp-vbr5.xs4all.nl ([194.109.24.25]:2723 "EHLO
	smtp-vbr5.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932304Ab1ESGp6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 19 May 2011 02:45:58 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Ondrej Zary <linux@rainbow-software.org>
Subject: Re: [PATCH v4] tea575x: convert to control framework
Date: Thu, 19 May 2011 08:45:38 +0200
Cc: linux-media@vger.kernel.org, alsa-devel@alsa-project.org,
	"Kernel development list" <linux-kernel@vger.kernel.org>
References: <201105140017.26968.linux@rainbow-software.org> <201105182225.58838.hverkuil@xs4all.nl> <201105182335.25161.linux@rainbow-software.org>
In-Reply-To: <201105182335.25161.linux@rainbow-software.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201105190845.38194.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Wednesday, May 18, 2011 23:35:22 Ondrej Zary wrote:
> Convert tea575x-tuner to use the new V4L2 control framework. Also add
> ext_init() callback that can be used by a card driver for additional
> initialization right before registering the video device (for SF16-FMR2).
> 
> Also embed struct video_device to struct snd_tea575x to simplify the code.
> 
> Signed-off-by: Ondrej Zary <linux@rainbow-software.org>
> 
> --- linux-2.6.39-rc2-/include/sound/tea575x-tuner.h	2011-05-13 19:39:23.000000000 +0200
> +++ linux-2.6.39-rc2/include/sound/tea575x-tuner.h	2011-05-18 23:14:48.000000000 +0200
> @@ -23,8 +23,8 @@
>   */
>  
>  #include <linux/videodev2.h>
> +#include <media/v4l2-ctrls.h>
>  #include <media/v4l2-dev.h>
> -#include <media/v4l2-ioctl.h>
>  
>  #define TEA575X_FMIF	10700
>  
> @@ -42,7 +42,8 @@ struct snd_tea575x_ops {
>  };
>  
>  struct snd_tea575x {
> -	struct video_device *vd;	/* video device */
> +	struct video_device vd;		/* video device */
> +	bool initialized;

This isn't needed, more about that below.

>  	bool tea5759;			/* 5759 chip is present */
>  	bool mute;			/* Device is muted? */
>  	bool stereo;			/* receiving stereo */
> @@ -54,6 +55,8 @@ struct snd_tea575x {
>  	void *private_data;
>  	u8 card[32];
>  	u8 bus_info[32];
> +	struct v4l2_ctrl_handler ctrl_handler;
> +	void (*ext_init)(struct snd_tea575x *tea);

ext_init should return int to pass back errors.

>  };
>  
>  int snd_tea575x_init(struct snd_tea575x *tea);
> --- linux-2.6.39-rc2-/sound/i2c/other/tea575x-tuner.c	2011-05-13 19:39:23.000000000 +0200
> +++ linux-2.6.39-rc2/sound/i2c/other/tea575x-tuner.c	2011-05-18 23:22:44.000000000 +0200
> @@ -22,11 +22,11 @@
>  
>  #include <asm/io.h>
>  #include <linux/delay.h>
> -#include <linux/interrupt.h>
>  #include <linux/init.h>
>  #include <linux/slab.h>
>  #include <linux/version.h>
> -#include <sound/core.h>
> +#include <media/v4l2-dev.h>
> +#include <media/v4l2-ioctl.h>
>  #include <sound/tea575x-tuner.h>
>  
>  MODULE_AUTHOR("Jaroslav Kysela <perex@perex.cz>");
> @@ -62,17 +62,6 @@ module_param(radio_nr, int, 0);
>  #define TEA575X_BIT_DUMMY	(1<<15)		/* buffer */
>  #define TEA575X_BIT_FREQ_MASK	0x7fff
>  
> -static struct v4l2_queryctrl radio_qctrl[] = {
> -	{
> -		.id            = V4L2_CID_AUDIO_MUTE,
> -		.name          = "Mute",
> -		.minimum       = 0,
> -		.maximum       = 1,
> -		.default_value = 1,
> -		.type          = V4L2_CTRL_TYPE_BOOLEAN,
> -	}
> -};
> -
>  /*
>   * lowlevel part
>   */
> @@ -266,47 +255,17 @@ static int vidioc_s_audio(struct file *f
>  	return 0;
>  }
>  
> -static int vidioc_queryctrl(struct file *file, void *priv,
> -					struct v4l2_queryctrl *qc)
> -{
> -	int i;
> -
> -	for (i = 0; i < ARRAY_SIZE(radio_qctrl); i++) {
> -		if (qc->id && qc->id == radio_qctrl[i].id) {
> -			memcpy(qc, &(radio_qctrl[i]),
> -						sizeof(*qc));
> -			return 0;
> -		}
> -	}
> -	return -EINVAL;
> -}
> -
> -static int vidioc_g_ctrl(struct file *file, void *priv,
> -					struct v4l2_control *ctrl)
> +static int tea575x_s_ctrl(struct v4l2_ctrl *ctrl)
>  {
> -	struct snd_tea575x *tea = video_drvdata(file);
> +	struct snd_tea575x *tea = container_of(ctrl->handler, struct snd_tea575x, ctrl_handler);
>  
>  	switch (ctrl->id) {
>  	case V4L2_CID_AUDIO_MUTE:
> -		ctrl->value = tea->mute;
> +		tea->mute = ctrl->val;
> +		snd_tea575x_set_freq(tea);
>  		return 0;
>  	}
> -	return -EINVAL;
> -}
> -
> -static int vidioc_s_ctrl(struct file *file, void *priv,
> -					struct v4l2_control *ctrl)
> -{
> -	struct snd_tea575x *tea = video_drvdata(file);
>  
> -	switch (ctrl->id) {
> -	case V4L2_CID_AUDIO_MUTE:
> -		if (tea->mute != ctrl->value) {
> -			tea->mute = ctrl->value;
> -			snd_tea575x_set_freq(tea);
> -		}
> -		return 0;
> -	}
>  	return -EINVAL;
>  }
>  
> @@ -355,16 +314,17 @@ static const struct v4l2_ioctl_ops tea57
>  	.vidioc_s_input     = vidioc_s_input,
>  	.vidioc_g_frequency = vidioc_g_frequency,
>  	.vidioc_s_frequency = vidioc_s_frequency,
> -	.vidioc_queryctrl   = vidioc_queryctrl,
> -	.vidioc_g_ctrl      = vidioc_g_ctrl,
> -	.vidioc_s_ctrl      = vidioc_s_ctrl,
>  };
>  
>  static struct video_device tea575x_radio = {
>  	.name           = "tea575x-tuner",
>  	.fops           = &tea575x_fops,
>  	.ioctl_ops 	= &tea575x_ioctl_ops,
> -	.release	= video_device_release,
> +	.release	= video_device_release_empty,
> +};
> +
> +static const struct v4l2_ctrl_ops tea575x_ctrl_ops = {
> +	.s_ctrl = tea575x_s_ctrl,
>  };
>  
>  /*
> @@ -373,7 +333,6 @@ static struct video_device tea575x_radio
>  int snd_tea575x_init(struct snd_tea575x *tea)
>  {
>  	int retval;
> -	struct video_device *tea575x_radio_inst;
>  
>  	tea->mute = 1;
>  
> @@ -384,39 +343,44 @@ int snd_tea575x_init(struct snd_tea575x
>  	tea->in_use = 0;
>  	tea->val = TEA575X_BIT_BAND_FM | TEA575X_BIT_SEARCH_10_40;
>  	tea->freq = 90500 * 16;		/* 90.5Mhz default */
> +	snd_tea575x_set_freq(tea);
>  
> -	tea575x_radio_inst = video_device_alloc();
> -	if (tea575x_radio_inst == NULL) {
> -		printk(KERN_ERR "tea575x-tuner: not enough memory\n");
> -		return -ENOMEM;
> -	}
> +	memcpy(&tea->vd, &tea575x_radio, sizeof(tea575x_radio));

You can use tea->vd = tea575x_radio instead of memcpy.

> +	video_set_drvdata(&tea->vd, tea);
>  
> -	memcpy(tea575x_radio_inst, &tea575x_radio, sizeof(tea575x_radio));
> +	v4l2_ctrl_handler_init(&tea->ctrl_handler, 1);
> +	tea->vd.ctrl_handler = &tea->ctrl_handler;
> +	v4l2_ctrl_new_std(&tea->ctrl_handler, &tea575x_ctrl_ops, V4L2_CID_AUDIO_MUTE, 0, 1, 1, 1);
> +	retval = tea->ctrl_handler.error;
> +	if (retval) {
> +		printk(KERN_ERR "tea575x-tuner: can't initialize controls\n");
> +		v4l2_ctrl_handler_free(&tea->ctrl_handler);
> +		return retval;
> +	}
> +	v4l2_ctrl_handler_setup(&tea->ctrl_handler);

It's better to move this after the ext_init call, then the driver implementing
ext_init doesn't have to call v4l2_ctrl_handler_setup again.

>  
> -	strcpy(tea575x_radio.name, tea->tea5759 ?
> -				   "TEA5759 radio" : "TEA5757 radio");
> +	if (tea->ext_init)
> +		tea->ext_init(tea);

ext_init can return an error. In particular, radio-sf16fmr2 should return
tea->ctrl_handler.error after adding the two new controls since adding
those controls might have failed.

>  
> -	video_set_drvdata(tea575x_radio_inst, tea);
> +	tea->initialized = 1;
>  
> -	retval = video_register_device(tea575x_radio_inst,
> -				       VFL_TYPE_RADIO, radio_nr);
> +	retval = video_register_device(&tea->vd, VFL_TYPE_RADIO, radio_nr);
>  	if (retval) {
>  		printk(KERN_ERR "tea575x-tuner: can't register video device!\n");
> -		kfree(tea575x_radio_inst);
> +		v4l2_ctrl_handler_free(&tea->ctrl_handler);
> +		tea->initialized = 0;
>  		return retval;
>  	}
>  
> -	snd_tea575x_set_freq(tea);
> -	tea->vd = tea575x_radio_inst;
> -
>  	return 0;
>  }
>  
>  void snd_tea575x_exit(struct snd_tea575x *tea)
>  {
> -	if (tea->vd) {
> -		video_unregister_device(tea->vd);
> -		tea->vd = NULL;
> +	if (tea->initialized) {
> +		video_unregister_device(&tea->vd);

video_unregister_device is smart enough to detect a failed video_register_device
call, so there is no need to use this 'initialized' field.

> +		v4l2_ctrl_handler_free(&tea->ctrl_handler);
> +		tea->initialized = 0;
>  	}
>  }
>  
> 
> 
> 

Regards,

	Hans
