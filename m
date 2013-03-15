Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr15.xs4all.nl ([194.109.24.35]:3929 "EHLO
	smtp-vbr15.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754236Ab3COMTb (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 15 Mar 2013 08:19:31 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: [REVIEW PATCH 1/5] v4l2: add const to argument of write-only s_frequency ioctl.
Date: Fri, 15 Mar 2013 13:18:52 +0100
Cc: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Scott Jiang <scott.jiang.linux@gmail.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Andy Walls <awalls@md.metrocast.net>,
	Prabhakar Lad <prabhakar.csengg@gmail.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Tomasz Stanislawski <t.stanislaws@samsung.com>,
	Alexey Klimov <klimov.linux@gmail.com>,
	Hans de Goede <hdegoede@redhat.com>,
	Brian Johnson <brijohn@gmail.com>,
	Mike Isely <isely@pobox.com>,
	Ezequiel Garcia <elezegarcia@gmail.com>,
	Huang Shijie <shijie8@gmail.com>,
	Ismael Luceno <ismael.luceno@corp.bluecherry.net>,
	Takashi Iwai <tiwai@suse.de>,
	Ondrej Zary <linux@rainbow-software.org>,
	Hans Verkuil <hans.verkuil@cisco.com>
References: <1363343245-23531-1-git-send-email-hverkuil@xs4all.nl> <9ae3227f74816dbf699bbc8b1ce6202a5de1582f.1363342714.git.hans.verkuil@cisco.com> <3287631.eGTFbPRya4@avalon>
In-Reply-To: <3287631.eGTFbPRya4@avalon>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201303151318.52634.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri March 15 2013 13:08:23 Laurent Pinchart wrote:
> Hi Hans,
> 
> Thanks for the patch.
> 
> On Friday 15 March 2013 11:27:21 Hans Verkuil wrote:
> > From: Hans Verkuil <hans.verkuil@cisco.com>
> > 
> > This ioctl is defined as IOW, so pass the argument as const.
> > 
> > Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> 
> [snip]
> 
> > diff --git a/drivers/media/radio/radio-isa.c
> > b/drivers/media/radio/radio-isa.c index fe0a4f8..0c1e27b 100644
> > --- a/drivers/media/radio/radio-isa.c
> > +++ b/drivers/media/radio/radio-isa.c
> > @@ -102,17 +102,18 @@ static int radio_isa_s_tuner(struct file *file, void
> > *priv, }
> > 
> >  static int radio_isa_s_frequency(struct file *file, void *priv,
> > -				struct v4l2_frequency *f)
> > +				const struct v4l2_frequency *f)
> >  {
> >  	struct radio_isa_card *isa = video_drvdata(file);
> > +	u32 freq = f->frequency;
> >  	int res;
> > 
> >  	if (f->tuner != 0 || f->type != V4L2_TUNER_RADIO)
> >  		return -EINVAL;
> > -	f->frequency = clamp(f->frequency, FREQ_LOW, FREQ_HIGH);
> > -	res = isa->drv->ops->s_frequency(isa, f->frequency);
> > +	freq = clamp(freq, FREQ_LOW, FREQ_HIGH);
> 
> Micro-optimization here, you could just declare
> 
> 	u32 freq;
> 
> above and then write
> 
> 	freq = clamp(f->frequency, FREQ_LOW, FREQ_HIGH);

I'd call this a nano-optimization :-)

> 
> > +	res = isa->drv->ops->s_frequency(isa, freq);
> >  	if (res == 0)
> > -		isa->freq = f->frequency;
> > +		isa->freq = freq;
> >  	return res;
> >  }
> > 
> > diff --git a/drivers/media/radio/radio-keene.c
> > b/drivers/media/radio/radio-keene.c index 296941a..a90b7a8 100644
> > --- a/drivers/media/radio/radio-keene.c
> > +++ b/drivers/media/radio/radio-keene.c
> > @@ -82,9 +82,12 @@ static inline struct keene_device *to_keene_dev(struct
> > v4l2_device *v4l2_dev) /* Set frequency (if non-0), PA, mute and turn
> > on/off the FM transmitter. */ static int keene_cmd_main(struct keene_device
> > *radio, unsigned freq, bool play) {
> > -	unsigned short freq_send = freq ? (freq - 76 * 16000) / 800 : 0;
> > +	unsigned short freq_send;
> >  	int ret;
> > 
> > +	if (freq)
> > +		freq = clamp(freq, FREQ_MIN * FREQ_MUL, FREQ_MAX * FREQ_MUL);
> 
> There was no similar if (freq) in the function below, doesn't this change the 
> behaviour ?

You are correct. Well spotted. I'll correct that.

> 
> > +	freq_send = freq ? (freq - 76 * 16000) / 800 : 0;
> >  	radio->buffer[0] = 0x00;
> >  	radio->buffer[1] = 0x50;
> >  	radio->buffer[2] = (freq_send >> 8) & 0xff;
> > @@ -215,14 +218,12 @@ static int vidioc_s_modulator(struct file *file, void
> > *priv, }
> > 
> >  static int vidioc_s_frequency(struct file *file, void *priv,
> > -				struct v4l2_frequency *f)
> > +				const struct v4l2_frequency *f)
> >  {
> >  	struct keene_device *radio = video_drvdata(file);
> > 
> >  	if (f->tuner != 0 || f->type != V4L2_TUNER_RADIO)
> >  		return -EINVAL;
> > -	f->frequency = clamp(f->frequency,
> > -			FREQ_MIN * FREQ_MUL, FREQ_MAX * FREQ_MUL);
> >  	return keene_cmd_main(radio, f->frequency, true);
> >  }
> > 
> 
> [snip]
> 
> > diff --git a/drivers/media/radio/radio-miropcm20.c
> > b/drivers/media/radio/radio-miropcm20.c index 3d0ff44..2b8d31d 100644
> > --- a/drivers/media/radio/radio-miropcm20.c
> > +++ b/drivers/media/radio/radio-miropcm20.c
> > @@ -131,14 +131,14 @@ static int vidioc_g_frequency(struct file *file, void
> > *priv,
> > 
> > 
> >  static int vidioc_s_frequency(struct file *file, void *priv,
> > -				struct v4l2_frequency *f)
> > +				const struct v4l2_frequency *f)
> >  {
> >  	struct pcm20 *dev = video_drvdata(file);
> > 
> >  	if (f->tuner != 0 || f->type != V4L2_TUNER_RADIO)
> >  		return -EINVAL;
> > 
> > -	dev->freq = clamp(f->frequency, 87 * 16000U, 108 * 16000U);
> > +	dev->freq = clamp_t(u32, f->frequency, 87 * 16000U, 108 * 16000U);
> 
> f->frequency and the two clamp boundaries are unsigned, did clamp() throw a 
> warning ?

Yeah. clamp uses:

	typeof(val) __val = (val)

where 'val' is f->frequency, and typeof(f->frequency) == const u32. So assigning
'val' to __val gives a compiler error. clamp_t doesn't have that problem.

> 
> >  	pcm20_setfreq(dev, dev->freq);
> >  	return 0;
> >  }
> 
> [snip]
> 
> > diff --git a/drivers/media/usb/tlg2300/pd-video.c
> > b/drivers/media/usb/tlg2300/pd-video.c index dab0ca3..8ef7c8c 100644
> > --- a/drivers/media/usb/tlg2300/pd-video.c
> > +++ b/drivers/media/usb/tlg2300/pd-video.c
> > @@ -1079,10 +1079,11 @@ static int set_frequency(struct poseidon *pd, u32
> > *frequency) }
> > 
> >  static int vidioc_s_frequency(struct file *file, void *fh,
> > -				struct v4l2_frequency *freq)
> > +				const struct v4l2_frequency *freq)
> >  {
> >  	struct front_face *front = fh;
> >  	struct poseidon *pd = front->pd;
> > +	u32 frequency = freq->frequency;
> > 
> >  	if (freq->tuner)
> >  		return -EINVAL;
> > @@ -1090,7 +1091,7 @@ static int vidioc_s_frequency(struct file *file, void
> > *fh, pd->pm_suspend = pm_video_suspend;
> >  	pd->pm_resume = pm_video_resume;
> >  #endif
> > -	return set_frequency(pd, &freq->frequency);
> > +	return set_frequency(pd, &frequency);
> 
> Wouldn't it be better to pass the frequency by value to set_frequency() ?

Looking at the code, I'd say so. However, I am very hesitant to change too
much in this driver. My only tlg2300 usb stick died on me and I am unable to
find another so I have no way of testing. In other words, I want the change
to be minimal here.

> 
> >  }
> > 
> 
> [snip]
> 
> > diff --git a/include/media/v4l2-subdev.h b/include/media/v4l2-subdev.h
> > index b137a5e..1a82a50 100644
> > --- a/include/media/v4l2-subdev.h
> > +++ b/include/media/v4l2-subdev.h
> > @@ -191,7 +191,7 @@ struct v4l2_subdev_core_ops {
> >   */
> >  struct v4l2_subdev_tuner_ops {
> >  	int (*s_radio)(struct v4l2_subdev *sd);
> > -	int (*s_frequency)(struct v4l2_subdev *sd, struct v4l2_frequency *freq);
> > +	int (*s_frequency)(struct v4l2_subdev *sd, const struct v4l2_frequency
> > *freq);
> 
> Ideally we shouldn't push the same design mistake to subdev ops, but that 
> would require too many changes in all the drivers, so I'm fine with this.
> 
> > 	int (*g_frequency)(struct v4l2_subdev *sd, struct v4l2_frequency *freq);
> > 	int (*g_tuner)(struct v4l2_subdev *sd, struct v4l2_tuner *vt);
> >  	int (*s_tuner)(struct v4l2_subdev *sd, struct v4l2_tuner *vt);
> 
> 

Thanks for your review!

Regards,

	Hans
