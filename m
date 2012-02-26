Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-1-out2.atlantis.sk ([80.94.52.71]:38637 "EHLO
	mail.atlantis.sk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752913Ab2BZVDW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 26 Feb 2012 16:03:22 -0500
From: Ondrej Zary <linux@rainbow-software.org>
To: Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [PATCH] tea575x: fix HW seek
Date: Sun, 26 Feb 2012 22:02:51 +0100
Cc: linux-media@vger.kernel.org, alsa-devel@alsa-project.org
References: <201202181745.49819.linux@rainbow-software.org> <201202220935.29155.linux@rainbow-software.org> <201202241000.01922.hverkuil@xs4all.nl>
In-Reply-To: <201202241000.01922.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201202262202.55787.linux@rainbow-software.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Friday 24 February 2012 10:00:01 Hans Verkuil wrote:
> On Wednesday, February 22, 2012 09:35:28 Ondrej Zary wrote:
> > On Tuesday 21 February 2012, Hans Verkuil wrote:
> > > On Saturday, February 18, 2012 17:45:45 Ondrej Zary wrote:
> > > > Fix HW seek in TEA575x to work properly:
> > > >  - a delay must be present after search start and before first
> > > > register read or the seek does weird things
> > > >  - when the search stops, the new frequency is not available
> > > > immediately, we must wait until it appears in the register
> > > > (fortunately, we can clear the frequency bits when starting the
> > > > search as it starts at the frequency currently set, not from the
> > > > value written)
> > > >  - sometimes, seek remains on the current frequency (or moves only a
> > > > little), so repeat it until it moves by at least 50 kHz
> > > >
> > > > Signed-off-by: Ondrej Zary <linux@rainbow-software.org>
> > > >
> > > > --- a/sound/i2c/other/tea575x-tuner.c
> > > > +++ b/sound/i2c/other/tea575x-tuner.c
> > > > @@ -89,7 +89,7 @@ static void snd_tea575x_write(struct snd_tea575x
> > > > *tea, unsigned int val) tea->ops->set_pins(tea, 0);
> > > >  }
> > > >
> > > > -static unsigned int snd_tea575x_read(struct snd_tea575x *tea)
> > > > +static u32 snd_tea575x_read(struct snd_tea575x *tea)
> > > >  {
> > > >  	u16 l, rdata;
> > > >  	u32 data = 0;
> > > > @@ -120,6 +120,27 @@ static unsigned int snd_tea575x_read(struct
> > > > snd_tea575x *tea) return data;
> > > >  }
> > > >
> > > > +static void snd_tea575x_get_freq(struct snd_tea575x *tea)
> > > > +{
> > > > +	u32 freq = snd_tea575x_read(tea) & TEA575X_BIT_FREQ_MASK;
> > > > +
> > > > +	if (freq == 0) {
> > > > +		tea->freq = 0;
> > >
> > > Wouldn't it be better to return -EBUSY in this case? VIDIOC_G_FREQUENCY
> > > should not return frequencies outside the valid frequency range. In
> > > this case returning -EBUSY seems to make more sense to me.
> >
> > The device returns zero frequency when the scan fails to find a
> > frequency. This is not an error, just an indication that "nothing" is
> > tuned. So maybe we can return some bogus frequency in vidioc_g_frequency
> > (like FREQ_LO) in this case (don't know if -EBUSY will break anything).
> > But HW seek should get the real one (i.e. zero when it's there).
>
> How about the following patch? vidioc_g_frequency just returns the last set
> frequency and the hw_seek restores the original frequency if it can't find
> another channel.

Seems to work. That's probably the right thing to do.

> Also note that the check for < 50 kHz in hw_seek actually checked for < 500
> kHz. I've fixed that, but I can't test it.

Thanks. It finds more stations now. To improve reliability, an additional 
check should be added - the seek sometimes stop at the same station, just a 
bit more than 50kHz of the original frequency, often in wrong direction. 
Something like this:

--- a/sound/i2c/other/tea575x-tuner.c
+++ b/sound/i2c/other/tea575x-tuner.c
@@ -280,8 +280,13 @@ static int vidioc_s_hw_freq_seek(struct file *file, void 
*fh,
                        }
                        if (freq == 0) /* shouldn't happen */
                                break;
-                       /* if we moved by less than 50 kHz, continue seeking 
*/
-                       if (abs(tea->freq - freq) < 16 * 50) {
+                       /*
+                        * if we moved by less than 50 kHz, or in the wrong
+                        * direction, continue seeking
+                        */
+                       if (abs(tea->freq - freq) < 16 * 50 ||
+                           (a->seek_upward && freq < tea->freq) ||
+                           (!a->seek_upward && freq > tea->freq)) {
                                snd_tea575x_write(tea, tea->val);
                                continue;
                        }


> Do you also know what happens at the boundaries of the frequency range?
> Does it wrap around, or do you get a timeout?

No wraparound, it times out so the original frequency is restored. I wonder 
if -ETIMEDOUT is correct here.

> Regards,
>
> 	Hans
>
> diff --git a/sound/i2c/other/tea575x-tuner.c
> b/sound/i2c/other/tea575x-tuner.c index 474bb81..1bdf1f3 100644
> --- a/sound/i2c/other/tea575x-tuner.c
> +++ b/sound/i2c/other/tea575x-tuner.c
> @@ -120,14 +120,12 @@ static u32 snd_tea575x_read(struct snd_tea575x *tea)
>  	return data;
>  }
>
> -static void snd_tea575x_get_freq(struct snd_tea575x *tea)
> +static u32 snd_tea575x_get_freq(struct snd_tea575x *tea)
>  {
>  	u32 freq = snd_tea575x_read(tea) & TEA575X_BIT_FREQ_MASK;
>
> -	if (freq == 0) {
> -		tea->freq = 0;
> -		return;
> -	}
> +	if (freq == 0)
> +		return freq;
>
>  	/* freq *= 12.5 */
>  	freq *= 125;
> @@ -138,7 +136,7 @@ static void snd_tea575x_get_freq(struct snd_tea575x
> *tea) else
>  		freq -= TEA575X_FMIF;
>
> -	tea->freq = clamp(freq * 16, FREQ_LO, FREQ_HI); /* from kHz */
> +	return clamp(freq * 16, FREQ_LO, FREQ_HI); /* from kHz */
>  }
>
>  static void snd_tea575x_set_freq(struct snd_tea575x *tea)
> @@ -224,8 +222,6 @@ static int vidioc_g_frequency(struct file *file, void
> *priv, if (f->tuner != 0)
>  		return -EINVAL;
>  	f->type = V4L2_TUNER_RADIO;
> -	if (!tea->cannot_read_data)
> -		snd_tea575x_get_freq(tea);
>  	f->frequency = tea->freq;
>  	return 0;
>  }
> @@ -248,14 +244,12 @@ static int vidioc_s_hw_freq_seek(struct file *file,
> void *fh, struct v4l2_hw_freq_seek *a)
>  {
>  	struct snd_tea575x *tea = video_drvdata(file);
> -	int i, old_freq;
>  	unsigned long timeout;
> +	int i;
>
>  	if (tea->cannot_read_data)
>  		return -ENOTTY;
>
> -	snd_tea575x_get_freq(tea);
> -	old_freq = tea->freq;
>  	/* clear the frequency, HW will fill it in */
>  	tea->val &= ~TEA575X_BIT_FREQ_MASK;
>  	tea->val |= TEA575X_BIT_SEARCH;
> @@ -271,26 +265,33 @@ static int vidioc_s_hw_freq_seek(struct file *file,
> void *fh, if (schedule_timeout_interruptible(msecs_to_jiffies(10))) {
>  			/* some signal arrived, stop search */
>  			tea->val &= ~TEA575X_BIT_SEARCH;
> -			snd_tea575x_write(tea, tea->val);
> +			snd_tea575x_set_freq(tea);
>  			return -ERESTARTSYS;
>  		}
>  		if (!(snd_tea575x_read(tea) & TEA575X_BIT_SEARCH)) {
> +			u32 freq;
> +
>  			/* Found a frequency, wait until it can be read */
>  			for (i = 0; i < 100; i++) {
>  				msleep(10);
> -				snd_tea575x_get_freq(tea);
> -				if (tea->freq != 0) /* available */
> +				freq = snd_tea575x_get_freq(tea);
> +				if (freq) /* available */
>  					break;
>  			}
> +			if (freq == 0) /* shouldn't happen */
> +				break;
>  			/* if we moved by less than 50 kHz, continue seeking */
> -			if (abs(old_freq - tea->freq) < 16 * 500) {
> +			if (abs(tea->freq - freq) < 16 * 50) {
>  				snd_tea575x_write(tea, tea->val);
>  				continue;
>  			}
> +			tea->freq = freq;
>  			tea->val &= ~TEA575X_BIT_SEARCH;
>  			return 0;
>  		}
>  	}
> +	tea->val &= ~TEA575X_BIT_SEARCH;
> +	snd_tea575x_set_freq(tea);
>  	return -ETIMEDOUT;
>  }



-- 
Ondrej Zary
