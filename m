Return-path: <mchehab@pedra>
Received: from smtp-vbr9.xs4all.nl ([194.109.24.29]:1266 "EHLO
	smtp-vbr9.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757696Ab1FKNg5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 11 Jun 2011 09:36:57 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Ondrej Zary <linux@rainbow-software.org>
Subject: Re: [PATCH] tea575x: allow multiple opens
Date: Sat, 11 Jun 2011 15:36:39 +0200
Cc: linux-media@vger.kernel.org, alsa-devel@alsa-project.org,
	Kernel development list <linux-kernel@vger.kernel.org>
References: <201106111529.04319.linux@rainbow-software.org>
In-Reply-To: <201106111529.04319.linux@rainbow-software.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201106111536.39174.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Saturday, June 11, 2011 15:28:59 Ondrej Zary wrote:
> Change locking to allow tea575x-radio device to be opened multiple times.

Very nice!

Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>

Regards,

	Hans

> Signed-off-by: Ondrej Zary <linux@rainbow-software.org>
> 
> --- linux-2.6.39-rc2-/include/sound/tea575x-tuner.h	2011-06-11 15:21:50.000000000 +0200
> +++ linux-2.6.39-rc2/include/sound/tea575x-tuner.h	2011-06-11 14:50:55.000000000 +0200
> @@ -49,7 +49,7 @@ struct snd_tea575x {
>  	bool tuned;			/* tuned to a station */
>  	unsigned int val;		/* hw value */
>  	unsigned long freq;		/* frequency */
> -	unsigned long in_use;		/* set if the device is in use */
> +	struct mutex mutex;
>  	struct snd_tea575x_ops *ops;
>  	void *private_data;
>  	u8 card[32];
> --- linux-2.6.39-rc2-/sound/i2c/other/tea575x-tuner.c	2011-06-11 15:21:50.000000000 +0200
> +++ linux-2.6.39-rc2/sound/i2c/other/tea575x-tuner.c	2011-06-11 14:57:28.000000000 +0200
> @@ -282,26 +282,9 @@ static int vidioc_s_input(struct file *f
>  	return 0;
>  }
>  
> -static int snd_tea575x_exclusive_open(struct file *file)
> -{
> -	struct snd_tea575x *tea = video_drvdata(file);
> -
> -	return test_and_set_bit(0, &tea->in_use) ? -EBUSY : 0;
> -}
> -
> -static int snd_tea575x_exclusive_release(struct file *file)
> -{
> -	struct snd_tea575x *tea = video_drvdata(file);
> -
> -	clear_bit(0, &tea->in_use);
> -	return 0;
> -}
> -
>  static const struct v4l2_file_operations tea575x_fops = {
>  	.owner		= THIS_MODULE,
> -	.open           = snd_tea575x_exclusive_open,
> -	.release        = snd_tea575x_exclusive_release,
> -	.ioctl		= video_ioctl2,
> +	.unlocked_ioctl	= video_ioctl2,
>  };
>  
>  static const struct v4l2_ioctl_ops tea575x_ioctl_ops = {
> @@ -340,13 +323,14 @@ int snd_tea575x_init(struct snd_tea575x
>  	if (snd_tea575x_read(tea) != 0x55AA)
>  		return -ENODEV;
>  
> -	tea->in_use = 0;
>  	tea->val = TEA575X_BIT_BAND_FM | TEA575X_BIT_SEARCH_10_40;
>  	tea->freq = 90500 * 16;		/* 90.5Mhz default */
>  	snd_tea575x_set_freq(tea);
>  
>  	tea->vd = tea575x_radio;
>  	video_set_drvdata(&tea->vd, tea);
> +	mutex_init(&tea->mutex);
> +	tea->vd.lock = &tea->mutex;
>  
>  	v4l2_ctrl_handler_init(&tea->ctrl_handler, 1);
>  	tea->vd.ctrl_handler = &tea->ctrl_handler;
> 
> 
> 
