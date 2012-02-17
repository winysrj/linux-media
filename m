Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr7.xs4all.nl ([194.109.24.27]:4918 "EHLO
	smtp-vbr7.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751251Ab2BQVQH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 17 Feb 2012 16:16:07 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Ondrej Zary <linux@rainbow-software.org>
Subject: Re: [alsa-devel] tea575x-tuner improvements & use in maxiradio
Date: Fri, 17 Feb 2012 22:15:43 +0100
Cc: alsa-devel@alsa-project.org, linux-media@vger.kernel.org
References: <201202172113.43729.linux@rainbow-software.org>
In-Reply-To: <201202172113.43729.linux@rainbow-software.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201202172215.43484.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Friday, February 17, 2012 21:13:40 Ondrej Zary wrote:
> On Wednesday 08 February 2012 08:29:25 Hans Verkuil wrote:
> > On Tuesday, February 07, 2012 23:20:19 Ondrej Zary wrote:
> > > On Sunday 05 February 2012 14:17:05 Hans Verkuil wrote:
> > > > These patches improve the tea575x-tuner module to make it up to date
> > > > with the latest V4L2 frameworks.
> > > >
> > > > The maxiradio driver has also been converted to use the tea575x-tuner
> > > > and I've used that card to test it.
> > > >
> > > > Unfortunately, this card can't read the data pin, so the new hardware
> > > > seek functionality has been tested only partially (yes, it seeks, but
> > > > when it finds a channel I can't read back the frequency).
> > > >
> > > > Ondrej, are you able to test these patches for the sound cards that use
> > > > this tea575x tuner?
> > > >
> > > > Note that these two patches rely on other work that I did and that
> > > > hasn't been merged yet. So it is best to pull from my git tree:
> > > >
> > > > http://git.linuxtv.org/hverkuil/media_tree.git/shortlog/refs/heads/radi
> > > >o-pc i2
> > > >
> > > > You can use the v4l-utils repository
> > > > (http://git.linuxtv.org/v4l-utils.git) to test the drivers: the
> > > > v4l2-compliance test should succeed and with v4l2-ctl you can test the
> > > > hardware seek:
> > > >
> > > > To seek down:
> > > >
> > > > v4l2-ctl -d /dev/radio0 --freq-seek=dir=0
> > > >
> > > > To seek up:
> > > >
> > > > v4l2-ctl -d /dev/radio0 --freq-seek=dir=1
> > > >
> > > > To do the compliance test:
> > > >
> > > > v4l2-compliance -r /dev/radio0
> > >
> > > It seems to work (tested with SF64-PCR - snd_fm801) but the seek is
> > > severely broken. Reading the frequency immediately after seek does not
> > > work, it always returns the old value (haven't found a delay that works).
> > > Reading it later (copied back snd_tea575x_get_freq function) works. The
> > > chip seeks randomly up or down, ignoring UP/DOWN flag and often stops at
> > > wrong place (only noise) or even outside the FM range.
> > >
> > > So I strongly suggest not to enable this (mis-)feature. The HW seems to
> > > be completely broken (unless there's some weird bug in the code).
> >
> > Well, it seemed like a good idea at the time :-) I'll remove this
> > 'feature', it's really not worth our time to try and make this work for
> > these old cards.
> 
> I fixed it somehow. Now it works most of the time.
> The important things:
>  - a delay must be present after search start and before first register read
>    or the seek does weird things
>  - when the search stops, the new frequency is not available immediately, we
>    must wait until it appears in the register (fortunately, we can clear the
>    frequency bits when starting the search as it starts at the frequency
>    currently set, not from the value written)
>  - sometimes, seek remains on the current frequency (or moves only a little),
>    so repeat it until it moves by at least 50 kHz

Thanks! And I'm impressed that you spent all that time on this old hardware :-)

Can I get your Signed-off-by line for this patch?

Regards,

	Hans

> 
> --- a/sound/i2c/other/tea575x-tuner.c
> +++ b/sound/i2c/other/tea575x-tuner.c
> @@ -89,7 +89,7 @@ static void snd_tea575x_write(struct snd_tea575x *tea, unsigned int val)
>  		tea->ops->set_pins(tea, 0);
>  }
>  
> -static unsigned int snd_tea575x_read(struct snd_tea575x *tea)
> +static u32 snd_tea575x_read(struct snd_tea575x *tea)
>  {
>  	u16 l, rdata;
>  	u32 data = 0;
> @@ -120,6 +120,27 @@ static unsigned int snd_tea575x_read(struct snd_tea575x *tea)
>  	return data;
>  }
>  
> +static void snd_tea575x_get_freq(struct snd_tea575x *tea)
> +{
> +	u32 freq = snd_tea575x_read(tea) & TEA575X_BIT_FREQ_MASK;
> +
> +	if (freq == 0) {
> +		tea->freq = 0;
> +		return;
> +	}
> +
> +	/* freq *= 12.5 */
> +	freq *= 125;
> +	freq /= 10;
> +	/* crystal fixup */
> +	if (tea->tea5759)
> +		freq += TEA575X_FMIF;
> +	else
> +		freq -= TEA575X_FMIF;
> +
> +	tea->freq = clamp(freq * 16, FREQ_LO, FREQ_HI); /* from kHz */
> +}
> +
>  static void snd_tea575x_set_freq(struct snd_tea575x *tea)
>  {
>  	u32 freq = tea->freq;
> @@ -203,6 +224,8 @@ static int vidioc_g_frequency(struct file *file, void *priv,
>  	if (f->tuner != 0)
>  		return -EINVAL;
>  	f->type = V4L2_TUNER_RADIO;
> +	if (!tea->cannot_read_data)
> +		snd_tea575x_get_freq(tea);
>  	f->frequency = tea->freq;
>  	return 0;
>  }
> @@ -225,36 +248,50 @@ static int vidioc_s_hw_freq_seek(struct file *file, void *fh,
>  					struct v4l2_hw_freq_seek *a)
>  {
>  	struct snd_tea575x *tea = video_drvdata(file);
> +	int i, old_freq;
> +	unsigned long timeout;
>  
>  	if (tea->cannot_read_data)
>  		return -ENOTTY;
> +
> +	snd_tea575x_get_freq(tea);
> +	old_freq = tea->freq;
> +	/* clear the frequency, HW will fill it in */
> +	tea->val &= ~TEA575X_BIT_FREQ_MASK;
>  	tea->val |= TEA575X_BIT_SEARCH;
> -	tea->val &= ~TEA575X_BIT_UPDOWN;
>  	if (a->seek_upward)
>  		tea->val |= TEA575X_BIT_UPDOWN;
> +	else
> +		tea->val &= ~TEA575X_BIT_UPDOWN;
>  	snd_tea575x_write(tea, tea->val);
> +	timeout = jiffies + msecs_to_jiffies(10000);
>  	for (;;) {
> -		unsigned val = snd_tea575x_read(tea);
> -
> -		if (!(val & TEA575X_BIT_SEARCH)) {
> -			/* Found a frequency */
> -			val &= TEA575X_BIT_FREQ_MASK;
> -			val = (val * 10) / 125;
> -			if (tea->tea5759)
> -				val += TEA575X_FMIF;
> -			else
> -				val -= TEA575X_FMIF;
> -			tea->freq = clamp(val * 16, FREQ_LO, FREQ_HI);
> -			return 0;
> -		}
> +		if (time_after(jiffies, timeout))
> +			break;
>  		if (schedule_timeout_interruptible(msecs_to_jiffies(10))) {
>  			/* some signal arrived, stop search */
>  			tea->val &= ~TEA575X_BIT_SEARCH;
>  			snd_tea575x_write(tea, tea->val);
>  			return -ERESTARTSYS;
>  		}
> +		if (!(snd_tea575x_read(tea) & TEA575X_BIT_SEARCH)) {
> +			/* Found a frequency, wait until it can be read */
> +			for (i = 0; i < 100; i++) {
> +				msleep(10);
> +				snd_tea575x_get_freq(tea);
> +				if (tea->freq != 0) /* available */
> +					break;
> +			}
> +			/* if we moved by less than 50 kHz, continue seeking */
> +			if (abs(old_freq - tea->freq) < 16 * 500) {
> +				snd_tea575x_write(tea, tea->val);
> +				continue;
> +			}
> +			tea->val &= ~TEA575X_BIT_SEARCH;
> +			return 0;
> +		}
>  	}
> -	return 0;
> +	return -ETIMEDOUT;
>  }
>  
>  static int tea575x_s_ctrl(struct v4l2_ctrl *ctrl)
> @@ -318,7 +355,7 @@ int snd_tea575x_init(struct snd_tea575x *tea)
>  			return -ENODEV;
>  	}
>  
> -	tea->val = TEA575X_BIT_BAND_FM | TEA575X_BIT_SEARCH_10_40;
> +	tea->val = TEA575X_BIT_BAND_FM | TEA575X_BIT_SEARCH_5_28;
>  	tea->freq = 90500 * 16;		/* 90.5Mhz default */
>  	snd_tea575x_set_freq(tea);
>  
> 
> 
> 
> 
