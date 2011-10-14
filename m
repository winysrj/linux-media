Return-path: <linux-media-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:33466 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932297Ab1JNUHz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 14 Oct 2011 16:07:55 -0400
Message-ID: <4E989696.5030106@infradead.org>
Date: Fri, 14 Oct 2011 17:07:50 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
MIME-Version: 1.0
To: "Igor M. Liplianin" <liplianin@me.by>
CC: linux-media@vger.kernel.org, Steven Toth <stoth@linuxtv.org>,
	Mijhail Moreyra <mijhail.moreyra@gmail.com>,
	Abylai Ospan <aospan@netup.ru>
Subject: Re: [GIT PATCHES FOR 3.2] cx23885 alsa cleaned and prepaired
References: <201110101752.11536.liplianin@me.by>
In-Reply-To: <201110101752.11536.liplianin@me.by>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 10-10-2011 11:52, Igor M. Liplianin escreveu:
> Hi Mauro and Steven,
> 
> It's been a long time since cx23885-alsa pull was requested.
> To speed things up I created a git branch where I put the patches.
> Some patches merged, like introduce then correct checkpatch compliance
> or convert spinlock to mutex and back to spinlock, insert printk then remove printk as well.
> Minor corrections from me was silently merged, for major I created additional patches.
> 
> Hope it helps.
> 

> Steven Toth (31):
>       cx23885: mute the audio during channel change

> From 3241f9a7ba2505c48eaa608df7f2bd2a3e79eea0 Mon Sep 17 00:00:00 2001
> From: Steven Toth <stoth@kernellabs.com>
> Date: Mon, 10 Oct 2011 11:09:53 -0300
> Subject: [PATCH] [media] cx23885: mute the audio during channel change
> 
> Signed-off-by: Steven Toth <stoth@kernellabs.com>
> Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
> 
> diff --git a/drivers/media/video/cx23885/cx23885-video.c b/drivers/media/video/cx23885/cx23885-video.c
> index 58855b2..7e5342b 100644
> --- a/drivers/media/video/cx23885/cx23885-video.c
> +++ b/drivers/media/video/cx23885/cx23885-video.c
> @@ -1264,18 +1264,30 @@ static int vidioc_g_frequency(struct file *file, void *priv,
>  
>  static int cx23885_set_freq(struct cx23885_dev *dev, struct v4l2_frequency *f)
>  {
> +	struct v4l2_control ctrl;
> +
>  	if (unlikely(UNSET == dev->tuner_type))
>  		return -EINVAL;
>  	if (unlikely(f->tuner != 0))
>  		return -EINVAL;
>  
> +
>  	mutex_lock(&dev->lock);
>  	dev->freq = f->frequency;
>  
> +	/* I need to mute audio here */
> +	ctrl.id = V4L2_CID_AUDIO_MUTE;
> +	ctrl.value = 1;
> +	cx23885_set_control(dev, &ctrl);
> +
>  	call_all(dev, tuner, s_frequency, f);
>  
>  	/* When changing channels it is required to reset TVAUDIO */
> -	msleep(10);
> +	msleep(100);
> +
> +	/* I need to unmute audio here */
> +	ctrl.value = 0;
> +	cx23885_set_control(dev, &ctrl);
>  
>  	mutex_unlock(&dev->lock);
>  

This patch has a weird side effect: If the user has muted the audio, changing the channel will
unmute. The right thing to do here is to do a g_ctrl to check if the device is muted. If it is
muted, don't touch at the mute.

I'll drop this one from my patch series.

Regards,
Mauro
