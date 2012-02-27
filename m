Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr4.xs4all.nl ([194.109.24.24]:2581 "EHLO
	smtp-vbr4.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751144Ab2B0InH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 27 Feb 2012 03:43:07 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Ondrej Zary <linux@rainbow-software.org>
Subject: Re: [PATCH] tea575x: fix HW seek
Date: Mon, 27 Feb 2012 09:42:40 +0100
Cc: linux-media@vger.kernel.org, alsa-devel@alsa-project.org
References: <201202181745.49819.linux@rainbow-software.org> <201202241000.01922.hverkuil@xs4all.nl> <201202262202.55787.linux@rainbow-software.org>
In-Reply-To: <201202262202.55787.linux@rainbow-software.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201202270942.40162.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sunday, February 26, 2012 22:02:51 Ondrej Zary wrote:
> On Friday 24 February 2012 10:00:01 Hans Verkuil wrote:
> > On Wednesday, February 22, 2012 09:35:28 Ondrej Zary wrote:
> > > On Tuesday 21 February 2012, Hans Verkuil wrote:
> > > > On Saturday, February 18, 2012 17:45:45 Ondrej Zary wrote:
> > > > > Fix HW seek in TEA575x to work properly:
> > > > >  - a delay must be present after search start and before first
> > > > > register read or the seek does weird things
> > > > >  - when the search stops, the new frequency is not available
> > > > > immediately, we must wait until it appears in the register
> > > > > (fortunately, we can clear the frequency bits when starting the
> > > > > search as it starts at the frequency currently set, not from the
> > > > > value written)
> > > > >  - sometimes, seek remains on the current frequency (or moves only a
> > > > > little), so repeat it until it moves by at least 50 kHz
> > > > >
> > > > > Signed-off-by: Ondrej Zary <linux@rainbow-software.org>
> > > > >
> > > > > --- a/sound/i2c/other/tea575x-tuner.c
> > > > > +++ b/sound/i2c/other/tea575x-tuner.c
> > > > > @@ -89,7 +89,7 @@ static void snd_tea575x_write(struct snd_tea575x
> > > > > *tea, unsigned int val) tea->ops->set_pins(tea, 0);
> > > > >  }
> > > > >
> > > > > -static unsigned int snd_tea575x_read(struct snd_tea575x *tea)
> > > > > +static u32 snd_tea575x_read(struct snd_tea575x *tea)
> > > > >  {
> > > > >  	u16 l, rdata;
> > > > >  	u32 data = 0;
> > > > > @@ -120,6 +120,27 @@ static unsigned int snd_tea575x_read(struct
> > > > > snd_tea575x *tea) return data;
> > > > >  }
> > > > >
> > > > > +static void snd_tea575x_get_freq(struct snd_tea575x *tea)
> > > > > +{
> > > > > +	u32 freq = snd_tea575x_read(tea) & TEA575X_BIT_FREQ_MASK;
> > > > > +
> > > > > +	if (freq == 0) {
> > > > > +		tea->freq = 0;
> > > >
> > > > Wouldn't it be better to return -EBUSY in this case? VIDIOC_G_FREQUENCY
> > > > should not return frequencies outside the valid frequency range. In
> > > > this case returning -EBUSY seems to make more sense to me.
> > >
> > > The device returns zero frequency when the scan fails to find a
> > > frequency. This is not an error, just an indication that "nothing" is
> > > tuned. So maybe we can return some bogus frequency in vidioc_g_frequency
> > > (like FREQ_LO) in this case (don't know if -EBUSY will break anything).
> > > But HW seek should get the real one (i.e. zero when it's there).
> >
> > How about the following patch? vidioc_g_frequency just returns the last set
> > frequency and the hw_seek restores the original frequency if it can't find
> > another channel.
> 
> Seems to work. That's probably the right thing to do.
> 
> > Also note that the check for < 50 kHz in hw_seek actually checked for < 500
> > kHz. I've fixed that, but I can't test it.
> 
> Thanks. It finds more stations now. To improve reliability, an additional 
> check should be added - the seek sometimes stop at the same station, just a 
> bit more than 50kHz of the original frequency, often in wrong direction. 
> Something like this:
> 
> --- a/sound/i2c/other/tea575x-tuner.c
> +++ b/sound/i2c/other/tea575x-tuner.c
> @@ -280,8 +280,13 @@ static int vidioc_s_hw_freq_seek(struct file *file, void 
> *fh,
>                         }
>                         if (freq == 0) /* shouldn't happen */
>                                 break;
> -                       /* if we moved by less than 50 kHz, continue seeking 
> */
> -                       if (abs(tea->freq - freq) < 16 * 50) {
> +                       /*
> +                        * if we moved by less than 50 kHz, or in the wrong
> +                        * direction, continue seeking
> +                        */
> +                       if (abs(tea->freq - freq) < 16 * 50 ||
> +                           (a->seek_upward && freq < tea->freq) ||
> +                           (!a->seek_upward && freq > tea->freq)) {
>                                 snd_tea575x_write(tea, tea->val);
>                                 continue;
>                         }

Added to the patch series.

> 
> 
> > Do you also know what happens at the boundaries of the frequency range?
> > Does it wrap around, or do you get a timeout?
> 
> No wraparound, it times out so the original frequency is restored. I wonder 
> if -ETIMEDOUT is correct here.

That's actually wrong, it should be -EAGAIN according to the spec.

I'm now returning -EINVAL if the wrap_around value is not supported and I've
updated the spec to mention that possibility explicitly.

My latest tree is here:

The following changes since commit a3db60bcf7671cc011ab4f848cbc40ff7ab52c1e:

  [media] xc5000: declare firmware configuration structures as static const (2012-02-14 17:22:46 -0200)

are available in the git repository at:
  git://linuxtv.org/hverkuil/media_tree.git radio-pci

Hans Verkuil (4):
      tea575x-tuner: update to latest V4L2 framework requirements.
      tea575x: fix HW seek
      radio-maxiradio: use the tea575x framework.
      V4L2 Spec: return -EINVAL on unsupported wrap_around value.

 .../DocBook/media/v4l/vidioc-s-hw-freq-seek.xml    |    6 +-
 drivers/media/radio/Kconfig                        |    2 +-
 drivers/media/radio/radio-maxiradio.c              |  379 ++++----------------
 drivers/media/radio/radio-sf16fmr2.c               |   61 +++-
 include/sound/tea575x-tuner.h                      |    6 +-
 sound/i2c/other/tea575x-tuner.c                    |  169 ++++++---
 sound/pci/es1968.c                                 |   15 +
 sound/pci/fm801.c                                  |   20 +-
 8 files changed, 273 insertions(+), 385 deletions(-)

If there are no more comments, then I want to make a pull request for this
by the end of the week.

Regards,

	Hans
