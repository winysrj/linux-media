Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-14.arcor-online.net ([151.189.21.54]:57877 "EHLO
	mail-in-14.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762445AbZEHAPL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 7 May 2009 20:15:11 -0400
Subject: Re: [PATCH] FM1216ME_MK3 some changes
From: hermann pitton <hermann-pitton@arcor.de>
To: Andy Walls <awalls@radix.net>
Cc: Dmitri Belimov <d.belimov@gmail.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	video4linux-list@redhat.com, linux-media@vger.kernel.org
In-Reply-To: <1241665384.3147.53.camel@palomino.walls.org>
References: <20090422174848.1be88f61@glory.loctelecom.ru>
	 <1240452534.3232.70.camel@palomino.walls.org>
	 <20090423203618.4ac2bc6f@glory.loctelecom.ru>
	 <1240537394.3231.37.camel@palomino.walls.org>
	 <20090427192905.3ad2b88c@glory.loctelecom.ru>
	 <20090428151832.241fa9b4@pedra.chehab.org>
	 <20090428195922.1a079e46@glory.loctelecom.ru>
	 <1240974643.4280.24.camel@pc07.localdom.local>
	 <20090429201225.6ba681cf@glory.loctelecom.ru>
	 <1241050556.3710.109.camel@pc07.localdom.local>
	 <20090506044231.31f2d8aa@glory.loctelecom.ru>
	 <1241654513.5862.37.camel@pc07.localdom.local>
	 <1241665384.3147.53.camel@palomino.walls.org>
Content-Type: text/plain; charset=UTF-8
Date: Fri, 08 May 2009 02:08:24 +0200
Message-Id: <1241741304.4864.29.camel@pc07.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Am Mittwoch, den 06.05.2009, 23:03 -0400 schrieb Andy Walls:
> On Thu, 2009-05-07 at 02:01 +0200, hermann pitton wrote:
> > Hi,
> > 
> > Am Mittwoch, den 06.05.2009, 04:42 +1000 schrieb Dmitri Belimov:
> > > Hi Hermann
> > > 
> > > > Hi Dmitry,
> > > > 
> > > > Am Mittwoch, den 29.04.2009, 20:12 +1000 schrieb Dmitri Belimov:
> > > > > Hi,
> > > > >  
> > > > > > Am Dienstag, den 28.04.2009, 19:59 +1000 schrieb Dmitri Belimov:
> > > > > > > On Tue, 28 Apr 2009 15:18:32 -0300
> > > > > > > Mauro Carvalho Chehab <mchehab@infradead.org> wrote:
> > > > > > > 
> > > > > > > > On Mon, 27 Apr 2009 19:29:05 +1000
> > > > > > > > Dmitri Belimov <d.belimov@gmail.com> wrote:
> > > > > > > > 
> > > > > > > > > Hi All
> > > > > > > > > 
> > > > > > > > > Step by step.
> > > > > > > > > 
> > > > > > > > > This is patch for change only range of FM1216ME_MK3. Slow
> > > > > > > > > tunning is not a big problem.
> > > > > > > > 
> > > > > > > > Dmitri,
> > > > > > > > 
> > > > > > > > I'll mark those patches as RFC at patchwork until the end of
> > > > > > > > those discussions. After that, please send it again into a
> > > > > > > > new thread.
> > > > > > > 
> > > > > > > You mark patch with TOP AGC not this.
> > > > > > > 
> > > > > > > I think need discuss about FM1216ME_MK3 because I'll have a big
> > > > > > > patch for support control TOP AGC (sensitivity) of this tuner.
> > > > > > > It can be bad for compatible tuners.
> > > > > > 
> > > > > > hmm, in Europe, that TOP AGC did not ever made much difference
> > > > > > and it is an insmod option since ever.
> > 
> > >From the tda9887_3 datasheet.
> > 
> > 8.2  Tuner AGC and VIF-AGC
> > 
> > This block adapts the voltages, generated at the VIF-AGC
> > and SIF-AGC detectors, to the internal signal processing
> > at the VIF and SIF amplifiers and performs the tuner AGC
> > control current generation. The onset of the tuner AGC
> > control current generation can be set either via the I2C-bus
> > (see Table 13) or optionally by a potentiometer at pin TOP
> > (in case that the I2C-bus information cannot be stored).
> > The presence of a potentiometer is automatically detected
> > and the I2C-bus setting is disabled.
> > 
> > Reads for me that on some tuners, like NTSC only, the tuner AGC is fix.
> > 
> > To change it per channel is not needed at all.
> 
> I've started looking at the photographs of the tuner that Hermann sent.
> Looking at the TDA9887 v4 datasheet, I can see how the TOP related pins
> are (not) wired to the 1st stage oscillator/mixer chip.
> 
> Pin 9 (TOP) is supposed to either be tied to ground through a resistor
> or left open.  This design has the pin connected to a white SMT
> capacitor(?) which I will assume the TDA9887 will see as an open
> circuit.  This means the TOP in the TDA9887 should be programmable via
> I2C.
> 
> Pin 14 (TAGC) looks like it is unconnected.  This means the TDA9887 TAGC
> output is not actively taking over gain control of the 1st stage RF
> mixer/oscialltor chip.
> 
> 
> So this answers a question I had posed to Dmitry: Is this tuner wired up
> so the TDA9887 can adjust the gain of the 1st stage?  That answer is no.
> 
> 
> That means, that in this tuner, the AGC's in the two chips are operating
> independently and need their TOP's set in a coordinated manner that
> takes into account the IF filter losses and the modulation.  Since the
> FM1216ME data sheet makes recommendations for TOP values for both chips:
> 
> 
> RF mixer/osc chip:
>   109 dBμV Recommended for negative modulation
>   106 dBμV Recommended for positive modulation
> 
>   It is recommended to set the TOP at 109 dBμV for PAL B/G, D/K, I 
>   For system L/L’, it is recommended to set the TOP at 106 dBμV.
>   For FM radio, it is also recommended to set the TOP to 109 dBμV
> 
> IF demod chip:
>   C4-C0 = 10000 [0 dB, 17 mV (RMS) according to the TDA9887 datasheet]
>     for all FM modes and B/G D/K I L and L' systems
> 
> 
> it is probably best to use those.  I can try and look at the IF filter
> from the picutres Hermann sent, but I'm not sure I'd be able to figure
> out the loss and come up with better TOP setting recommendations than
> the manufacturer's datasheet.
> 
> 
> > > > > > 
> > > > > > I can't tell for Sibiria and initially that tuner had no SECAM-DK
> > > > > > support officially at all. There are no good/much_better tuners
> > > > > > for FTA at all and never have been ;)
> > > > > > 
> > > > > > Some examples, user success reports, to make it more easily to
> > > > > > understand? I think it can only change some _very little_ under
> > > > > > already worst conditions.
> > > > > 
> > > > > This is my idea for RFC about TOP AGC:
> > > > 
> > > > what about to create a new FM1216ME MK3 tuner type for testing?
> > > 
> > > Yes. Can you do it?
> > > 
> > > I start add MK5 tuner.
> > 
> > Yes, if really needed, but I see no hint anywhere that it should be
> > useful to have TOP settings per channel for user applications and will
> > stay away from it.
> 
> 
> Right now, I don't think the tuner-simple.c code adjusts the TOP value
> based on the video system or FM mode.  It probably should.
> 
> I don't think a user control will be very useful.
> 
> 
> > For the change of UHF start I don't see any problem.
> 
> If you're talking about the frequency for the bandswitch, I don't see a
> problem either in general.  It may cause a problem for clones of the
> FM1216ME MK3 that don't have the same filter performance near the
> cutover, but use the same tuner defintion as the FM1216ME MK3 in
> tuner-types.c.
> 
> It may be best to point any clones to a new entry that looks like the
> current FM1216ME MK3 entry unmodified.

Andy, thanks a lot for participating in such stuff and I think your
diagnosis is right.

Just a small question in between, already late here and not trying to
cover the whole scope.

What ever should be the effect of Dmitri's trick one, changing beginning
of UHF a little. We did that for midband and there was real broadcast
and it improved one single channel there indeed.

But here, it is plain theory. I honor the lab results they have, no
problem anyway, but to change something for not at all existing
broadcast does exactly nothing, except for awaiting it in the future.

No problem with that change, but do I miss something?

Also, after hundreds of "new" tuners did appear, in the beginning not
even known from where, I suggested to not allow a new tuner entry for
all of them, only duplicate code, until they really need it and show off
their difference.

I would like to keep it especially for this one the same. ;)

Such subsumed under it have done nothing for Linux so far and have to
face their faith :) And show off, if _not_ compatible.

And not the other way round.

Dmitri, if we are talking about the same tuner and filters, we should
try to get Secam D/K improvements into the original tuner entry.

That NTSC hack stuff might go elsewhere I guess.

Cheers,
Hermann

> Regards,
> Andy
> 
> > SECAM_DK is never mentioned explicitly in the old datasheet we have at
> > ivtvdriver.org. Maybe we miss something here, but you try to change over
> > the full range and simply 109 dB is recommended for negative
> > demodulation. (page 13 for recommended TOP settings)
> > http://dl.ivtvdriver.org/datasheets/tuners
> > 
> > Maybe we are really talking about different tuner versions/revisions.
> > 
> > Can you have a look at the tuner pictures I did send?
> > 
> > > > It is for sure maybe the best tuner around and likely is also the best
> > > > for tweaks in countries with huge lands to cover, not restricted to
> > > > Russia, Australia or Canada.
> > > 
> > > All our tuners tested with all standarts SECAM, PAL, NTSC because
> > > big country, some people want receive TV from Korea and Japan.
> > > For tests, our hardware engineer has hardware TV generator.
> > 
> > That confuses me a lot :)
> > 
> > You mean you test that tuner with its PAL/SECAM SAW filters on NTSC_KR
> > and NTSC_JP ?
> > 
> > > With my best regards, Dmitry.
> > > 
> > > > I would like to have also Hans' opinion on it, since he did some final
> > > > steps to get them right.
> > > > 
> > 
> > Andy might have a look too. Please wait a little for more opinions.
> > 
> > Cheers,
> > Hermann
> > 
> > > > 
> > > > > 1. Add gain variable to tuner structure.
> > > > > 2. Add V4L2_CID_GAIN control to saa7134 and disable this control.
> > > > > 3. Add workaround to simple_post_tune function for write
> > > > > sensitivity level to the tuner. 4. Enable V4L2_CID_GAIN control
> > > > > when module load if card is right.
> > > > > 
> > > > > My expirience not so good, step 4 segfault the kernel. How to we
> > > > > can make it?
> > > > > 
> > > > > Our windows end-user programm control the sensitivity of each TV
> > > > > channel and change when channel changed.
> > > > > 
> > > > > What you think about it??
> > > > > 
> > > > > If TV card is not touch V4L2_CTRL_FLAG_DISABLED in this control.
> > > > > The programm can't change AGC TOP. And write default value to AGC
> > > > > TOP like now.
> > > > > 
> > > > > diff -r 43dbc8ebb5a2
> > > > > linux/drivers/media/common/tuners/tuner-simple.c ---
> > > > > a/linux/drivers/media/common/tuners/tuner-simple.c	Tue Jan
> > > > > 27 23:47:50 2009 -0200 +++
> > > > > b/linux/drivers/media/common/tuners/tuner-simple.c	Tue Apr
> > > > > 21 09:44:38 2009 +1000 @@ -116,6 +116,7 @@ u32 frequency;
> > > > >  	u32 bandwidth;
> > > > > +	signed int gain;
> > > > >  };
> > > > >  
> > > > >  /*
> > > > > ----------------------------------------------------------------------
> > > > > */ @@ -495,15 +507,57 @@ "(should be 4)\n", rc);
> > > > >  		break;
> > > > >  	}
> > > > > +	case TUNER_PHILIPS_FM1216ME_MK3:
> > > > > +	{
> > > > > +		buffer[2] = 0xDE; /* T2 = 0, T1 = 1 and T0 = 1 */
> > > > > +		switch (priv->gain) {
> > > > > +		case 0:
> > > > > +			/* TOP = External AGC, ATC = OFF */
> > > > > +			buffer[3] = 0x60;
> > > > > +			break;
> > > > > +		case 1:
> > > > > +			/* TOP = 118 dB, ATC = OFF */
> > > > > +			buffer[3] = 0x00;
> > > > > +			break;
> > > > > +		case 2:
> > > > > +			/* TOP = 115 dB, ATC = OFF */
> > > > > +			buffer[3] = 0x10;
> > > > > +			break;
> > > > > +		case 3:
> > > > > +			/* TOP = 112 dB, ATC = OFF */
> > > > > +			buffer[3] = 0x20;
> > > > > +			break;
> > > > > +		case 4:
> > > > > +			/* TOP = 109 dB, ATC = OFF */
> > > > > +			buffer[3] = 0x30;
> > > > > +			break;
> > > > > +		case 5:
> > > > > +			/* TOP = 106 dB, ATC = OFF */
> > > > > +			buffer[3] = 0x40;
> > > > > +			break;
> > > > > +		case 6:
> > > > > +			/* TOP = 103 dB, ATC = OFF */
> > > > > +			buffer[3] = 0x50;
> > > > > +			break;
> > > > > +		default:
> > > > > +			/* TOP = 112 dB, ATC = OFF */
> > > > > +			buffer[3] = 0x20;
> > > > > +			break;
> > > > > +		}
> > > > > +
> > > > > +		tuner_dbg("tv 0x%02x 0x%02x 0x%02x 0x%02x\n",
> > > > > +			  buffer[0], buffer[1], buffer[2],
> > > > > buffer[3]); +
> > > > > +		rc = tuner_i2c_xfer_send(&priv->i2c_props, buffer,
> > > > > 4);
> > > > > +		if (4 != rc)
> > > > > +			tuner_warn("i2c i/o error: rc == %d "
> > > > > +				   "(should be 4)\n", rc);
> > > > > +
> > > > > +		break;
> > > > >  	}
> > > > > -
> > > > > +	}
> > > > >  	return 0;
> > > > >  }
> > > > >  
> > > > > diff -r 43dbc8ebb5a2
> > > > > linux/drivers/media/video/saa7134/saa7134-cards.c ---
> > > > > a/linux/drivers/media/video/saa7134/saa7134-cards.c	Tue Jan
> > > > > 27 23:47:50 2009 -0200 +++
> > > > > b/linux/drivers/media/video/saa7134/saa7134-cards.c	Tue Apr
> > > > > 21 09:44:38 2009 +1000 @@ -6506,6 +6806,20 @@ saa_call_all(dev,
> > > > > tuner, s_config, &tea5767_cfg); break; }
> > > > > +	case SAA7134_BOARD_BEHOLD_M6_EXTRA:
> > > > > +	{
> > > > > +		struct v4l2_queryctrl *ctl;
> > > > > +		struct saa7134_fh *fh;
> > > > > +		struct file *fl;
> > > > > +
> > > > > +		ctl->id = V4L2_CID_GAIN;
> > > > > +		if (saa7134_queryctrl(fl, fh, ctl) == 0)
> > > > > {                /* BUG here */
> > > > > +			/* enable this control */
> > > > > +			ctl->flags &= ~(V4L2_CTRL_FLAG_DISABLED);
> > > > > +		}
> > > > > +	}
> > > > >  	} /* switch() */
> > > > >  
> > > > >  	saa7134_tuner_setup(dev);
> > > > > diff -r 43dbc8ebb5a2
> > > > > linux/drivers/media/video/saa7134/saa7134-video.c ---
> > > > > a/linux/drivers/media/video/saa7134/saa7134-video.c	Tue Jan
> > > > > 27 23:47:50 2009 -0200 +++
> > > > > b/linux/drivers/media/video/saa7134/saa7134-video.c	Tue Apr
> > > > > 21 09:44:38 2009 +1000 @@ -417,6 +417,15 @@ .step          =
> > > > > 1, .default_value = 0, .type          = V4L2_CTRL_TYPE_INTEGER,
> > > > > +	}, {
> > > > > +		.id 		= V4L2_CID_GAIN,
> > > > > +		.name 		= "Gain",
> > > > > +		.minimum 	= 0,
> > > > > +		.maximum 	= 6,
> > > > > +		.step 		= 1,
> > > > > +		.default_value 	= 3,
> > > > > +		.type 		= V4L2_CTRL_TYPE_INTEGER,
> > > > > +		.flags 		= V4L2_CTRL_FLAG_DISABLED,
> > > > >  	},{
> > > > >  		.id            = V4L2_CID_HFLIP,
> > > > >  		.name          = "Mirror",
> > > > > @@ -1129,6 +1138,9 @@
> > > > >  	case V4L2_CID_HUE:
> > > > >  		c->value = dev->ctl_hue;
> > > > >  		break;
> > > > > +	case V4L2_CID_GAIN:
> > > > > +		c->value = dev->ctl_gain;
> > > > > +		break;
> > > > >  	case V4L2_CID_CONTRAST:
> > > > >  		c->value = dev->ctl_contrast;
> > > > >  		break;
> > > > > @@ -1214,6 +1226,10 @@
> > > > >  	case V4L2_CID_HUE:
> > > > >  		dev->ctl_hue = c->value;
> > > > >  		saa_writeb(SAA7134_DEC_CHROMA_HUE, dev->ctl_hue);
> > > > > +		break;
> > > > > +	case V4L2_CID_GAIN:
> > > > > +		dev->ctl_gain = c->value;
> > > > > +
> > > > >  		break;
> > > > >  	case V4L2_CID_CONTRAST:
> > > > >  		dev->ctl_contrast = c->value;
> > > > > @@ -2502,6 +2518,7 @@
> > > > >  	dev->ctl_bright     =
> > > > > ctrl_by_id(V4L2_CID_BRIGHTNESS)->default_value; dev->ctl_contrast
> > > > > = ctrl_by_id(V4L2_CID_CONTRAST)->default_value; dev->ctl_hue
> > > > > = ctrl_by_id(V4L2_CID_HUE)->default_value;
> > > > > +	dev->ctl_gain       =
> > > > > ctrl_by_id(V4L2_CID_GAIN)->default_value; dev->ctl_saturation =
> > > > > ctrl_by_id(V4L2_CID_SATURATION)->default_value; dev->ctl_volume
> > > > > = ctrl_by_id(V4L2_CID_AUDIO_VOLUME)->default_value;
> > > > > dev->ctl_mute       = 1; //
> > > > > ctrl_by_id(V4L2_CID_AUDIO_MUTE)->default_value; diff -r
> > > > > 43dbc8ebb5a2 linux/drivers/media/video/saa7134/saa7134.h ---
> > > > > a/linux/drivers/media/video/saa7134/saa7134.h	Tue Jan 27
> > > > > 23:47:50 2009 -0200 +++
> > > > > b/linux/drivers/media/video/saa7134/saa7134.h	Tue Apr 21
> > > > > 09:44:38 2009 +1000 @@ -548,6 +558,7 @@ int
> > > > > ctl_bright; int                        ctl_contrast;
> > > > > int                        ctl_hue;
> > > > > +	int                        ctl_gain;             /* gain */
> > > > >  	int                        ctl_saturation;
> > > > >  	int                        ctl_freq;
> > > > >  	int                        ctl_mute;             /* audio
> > > > > */
> > > > > 
> > > > > 
> > > > > With my best regards, Dmitry.
> > > > > 
> > > > > > Cheers,
> > > > > > Hermann
> > > > > > 
> > > > > > > With my best regards, Dmitry.
> > > > > > > 
> > > > > > > > 
> > > > > > > > Cheers,
> > > > > > > > Mauro.
> > > > > > > > 
> > > > > > > > > 
> > > > > > > > > diff -r b40d628f830d
> > > > > > > > > linux/drivers/media/common/tuners/tuner-types.c ---
> > > > > > > > > a/linux/drivers/media/common/tuners/tuner-types.c	Fri
> > > > > > > > > Apr 24 01:46:41 2009 -0300 +++
> > > > > > > > > b/linux/drivers/media/common/tuners/tuner-types.c	Tue
> > > > > > > > > Apr 28 03:35:42 2009 +1000 @@ -558,8 +558,8 @@ static struct
> > > > > > > > > tuner_range tuner_fm1216me_mk3_pal_ranges[] = { { 16 *
> > > > > > > > > 158.00 /*MHz*/, 0x8e, 0x01, },
> > > > > > > > > -	{ 16 * 442.00 /*MHz*/, 0x8e, 0x02, },
> > > > > > > > > -	{ 16 * 999.99        , 0x8e, 0x04, },
> > > > > > > > > +	{ 16 * 441.00 /*MHz*/, 0x8e, 0x02, },
> > > > > > > > > +	{ 16 * 864.00        , 0x8e, 0x04, },
> > > > > > > > >  };
> > > > > > > > >  
> > > > > > > > >  static struct tuner_params tuner_fm1216me_mk3_params[] = {
> > > > > > > > > 
> > > > > > > > > Signed-off-by: Beholder Intl. Ltd. Dmitry Belimov
> > > > > > > > > <d.belimov@gmail.com>
> > > > > > > > > 
> > > > > > > > > 
> > > > > > > > > With my best regards, Dmitry.
> > > > > > > > > 
> > > > > > > > > > Hi Dmitri,
> > > > > > > > > > 
> > > > > > > > > > Thank you for you responses.
> > > > > > > > > > 
> > > > > > > > > > Just a few more comments...
> > > > > > > > > > 
> > > > > > > > > > On Thu, 2009-04-23 at 20:36 +1000, Dmitri Belimov wrote:
> > > > > > > > > > > Hi Andy
> > > > > > > > > > > 
> > > > > > > > > > > > Dmitri,
> > > > > > > > > > > > 
> > > > > > > > > > > > 
> > > > > > > > > > > > On Wed, 2009-04-22 at 17:48 +1000, Dmitri Belimov
> > > > > > > > > > > > wrote:
> > > > > > > > > > > > > Hi All
> > > > > > > > > > > > > 
> > > > > > > > > > > > > 1. Change middle band. In the end of the middle
> > > > > > > > > > > > > band the sensitivity of receiver not good. If we
> > > > > > > > > > > > > switch to higher band, sensitivity more better.
> > > > > > > > > > > > > Hardware trick.
> > > > > > > > > > > > 
> > > > > > > > > > 
> > > > > > > > > > > Several years a go your customers write some messages
> > > > > > > > > > > about bad quality of TV if frequency of TV is the end
> > > > > > > > > > > of band. It can be low band or middle. Our hardware
> > > > > > > > > > > engeneer make some tests with hardware TV generator and
> > > > > > > > > > > our TV tuners.
> > > > > > > > > > > 
> > > > > > > > > > > If we set default frequency range for low and middle
> > > > > > > > > > > band, quality of TV signal on 159MHz and 442 MHz is
> > > > > > > > > > > bad. When we make our changes with moving end of bands
> > > > > > > > > > > the quality of TV much better. And our system
> > > > > > > > > > > programmer for OS Windows use changed bands for
> > > > > > > > > > > drivers. Customers be happy.
> > > > > > > > > > 
> > > > > > > > > > OK.  A properly run experiment wins over theory every
> > > > > > > > > > time. :)
> > > > > > > > > > 
> > > > > > > > > > 
> > > > > > > > > > 
> > > > > > > > > > > You can test it if in your placement available TV
> > > > > > > > > > > programm on 159MHz or 442MHz. This trick can be usefull
> > > > > > > > > > > for other tuners.
> > > > > > > > > > 
> > > > > > > > > > If you look at tveeprom.c, a number of other tuners are
> > > > > > > > > > using that tuner definition:
> > > > > > > > > > 
> > > > > > > > > > $ grep FM1216ME_MK3 tveeprom.c
> > > > > > > > > > 	{ TUNER_PHILIPS_FM1216ME_MK3, 	"Philips
> > > > > > > > > > FQ1216ME MK3"}, { TUNER_PHILIPS_FM1216ME_MK3,
> > > > > > > > > > 	"Philips FM1216 ME MK3"},
> > > > > > > > > > { TUNER_PHILIPS_FM1216ME_MK3, 	"LG S001D MK3"},
> > > > > > > > > > { TUNER_PHILIPS_FM1216ME_MK3, 	"LG S701D MK3"},
> > > > > > > > > > { TUNER_PHILIPS_FM1216ME_MK3, 	"Philips FQ1216LME
> > > > > > > > > > MK3"}, { TUNER_PHILIPS_FM1216ME_MK3, 	"TCL MFPE05
> > > > > > > > > > 2"}, { TUNER_PHILIPS_FM1216ME_MK3, 	"TCL MPE05-2"},
> > > > > > > > > > { TUNER_PHILIPS_FM1216ME_MK3, 	"Philips FM1216ME
> > > > > > > > > > MK5"},
> > > > > > > > > > 
> > > > > > > > > > If your change makes things bad for the other tuners,
> > > > > > > > > > we'll probably have to create an alternate entry for the
> > > > > > > > > > other tuners instead of using the FM1216ME_MK3
> > > > > > > > > > defintion.  I suspect most of them are clones of the
> > > > > > > > > > FM1216ME MK3 however, so it probably won't matter.
> > > > > > > > > > 
> > > > > > > > > > > > > 3. Set charge pump bit
> > > > > > > > > > > > 
> > > > > > > > > > > > This will improve the time to initially tune to a
> > > > > > > > > > > > frequency, but will likely add some noise as the PLL
> > > > > > > > > > > > continues to maintain lock on the signal.  If there
> > > > > > > > > > > > is no way to turn off the CP after the lock bit is
> > > > > > > > > > > > set in the tuner, it's probably better to leave it
> > > > > > > > > > > > off for lower noise and just live with slower tuning.
> > > > > > > > > > > 
> > > > > > > > > > > We discuss with our windows system programmer about it.
> > > > > > > > > > > He sad that in analog TV mode noise from PLL don't give
> > > > > > > > > > > any problem.
> > > > > > > > > > 
> > > > > > > > > > I would be concerned about phase noise affecting the
> > > > > > > > > > colors or any FM sound carriers.  If the noise isn't
> > > > > > > > > > noticably affecting colors to the human eye (do color
> > > > > > > > > > bars look OK?), or sound to the human ear, then OK.
> > > > > > > > > > 
> > > > > > > > > > 
> > > > > > > > > > >  But in digital TV mode
> > > > > > > > > > > noise from PLL decreased BER.
> > > > > > > > > > 
> > > > > > > > > > I thought the FM1216ME MK3 was an analog only tuner.  I
> > > > > > > > > > guess I don't know DVB-T or cable in Europe well enough.
> > > > > > > > > > 
> > > > > > > > > > 
> > > > > > > > > > > > Leaving the CP bit set should be especially noticable
> > > > > > > > > > > > ad FM noise when set to tune to FM radio stations.
> > > > > > > > > > > > From the FM1236ME_MK3 datasheet: "It is recommended
> > > > > > > > > > > > to set CP=0 in the FM mode at all times." But the VHF
> > > > > > > > > > > > low band control byte is also used when setting FM
> > > > > > > > > > > > radio (AFAICT with a quick look at the code.)
> > > > > > > > > > > 
> > > > > > > > > > > Yes. You are right. We can swith CP off in FM mode.
> > > > > > > > > > 
> > > > > > > > > > OK.  Thank you.
> > > > > > > > > > 
> > > > > > > > > > > With my best regards, Dmitry.
> > > > > > > > > > 
> > > > > > > > > > 
> > > > > > > > > > Regards,
> > > > > > > > > > Andy
> > > > > > > > > > 
> > > > > > > > > > 
> > > > > > > > > > 
> > > > > > > > 
> > > > > > > > 
> > > > > > > > 
> > > > > > > > 
> > > > > > > > Cheers,
> > > > > > > > Mauro
> > > > > > 
> > > > > > 
> > > > 
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-media" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > 
> 

