Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-07.arcor-online.net ([151.189.21.47]:59618 "EHLO
	mail-in-07.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750877AbZEAFTV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 1 May 2009 01:19:21 -0400
Subject: Re: [PATCH] FM1216ME_MK3 some changes
From: hermann pitton <hermann-pitton@arcor.de>
To: Andy Walls <awalls@radix.net>
Cc: Dmitri Belimov <d.belimov@gmail.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	video4linux-list@redhat.com, linux-media@vger.kernel.org
In-Reply-To: <1241054047.3374.42.camel@palomino.walls.org>
References: <20090422174848.1be88f61@glory.loctelecom.ru>
	 <1240452534.3232.70.camel@palomino.walls.org>
	 <20090423203618.4ac2bc6f@glory.loctelecom.ru>
	 <1240537394.3231.37.camel@palomino.walls.org>
	 <20090427192905.3ad2b88c@glory.loctelecom.ru>
	 <20090428151832.241fa9b4@pedra.chehab.org>
	 <20090428195922.1a079e46@glory.loctelecom.ru>
	 <1240974643.4280.24.camel@pc07.localdom.local>
	 <20090429201225.6ba681cf@glory.loctelecom.ru>
	 <1241054047.3374.42.camel@palomino.walls.org>
Content-Type: text/plain
Date: Fri, 01 May 2009 07:18:18 +0200
Message-Id: <1241155098.3713.26.camel@pc07.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Am Mittwoch, den 29.04.2009, 21:14 -0400 schrieb Andy Walls:
> On Wed, 2009-04-29 at 20:12 +1000, Dmitri Belimov wrote:
> > Hi,
> >  
> > > Am Dienstag, den 28.04.2009, 19:59 +1000 schrieb Dmitri Belimov:
> > > > On Tue, 28 Apr 2009 15:18:32 -0300
> > > > Mauro Carvalho Chehab <mchehab@infradead.org> wrote:
> > > > 
> > > > > On Mon, 27 Apr 2009 19:29:05 +1000
> > > > > Dmitri Belimov <d.belimov@gmail.com> wrote:
> > > > > 
> > > > > > Hi All
> > > > > > 
> > > > > > Step by step.
> > > > > > 
> > > > > > This is patch for change only range of FM1216ME_MK3. Slow
> > > > > > tunning is not a big problem.
> > > > > 
> > > > > Dmitri,
> > > > > 
> > > > > I'll mark those patches as RFC at patchwork until the end of those
> > > > > discussions. After that, please send it again into a new thread.
> > > > 
> > > > You mark patch with TOP AGC not this.
> > > > 
> > > > I think need discuss about FM1216ME_MK3 because I'll have a big
> > > > patch for support control TOP AGC (sensitivity) of this tuner. It
> > > > can be bad for compatible tuners.
> > > 
> > > hmm, in Europe, that TOP AGC did not ever made much difference and it
> > > is an insmod option since ever.
> > > 
> > > I can't tell for Sibiria and initially that tuner had no SECAM-DK
> > > support officially at all. There are no good/much_better tuners for
> > > FTA at all and never have been ;)
> > > 
> > > Some examples, user success reports, to make it more easily to
> > > understand? I think it can only change some _very little_ under
> > > already worst conditions.
> > 
> > This is my idea for RFC about TOP AGC:
> > 
> > 1. Add gain variable to tuner structure.
> > 2. Add V4L2_CID_GAIN control to saa7134 and disable this control.
> > 3. Add workaround to simple_post_tune function for write sensitivity level to the tuner.
> > 4. Enable V4L2_CID_GAIN control when module load if card is right.
> > 
> > My expirience not so good, step 4 segfault the kernel. How to we can make it?
> > 
> > Our windows end-user programm control the sensitivity of each TV channel and change when
> > channel changed.
> > 
> > What you think about it??
> 
> Dmitri,
> 
> >From my understanding the take over point is the signal strength level
> that you want the second stage (an IF demod chip like the TDA9887) to
> take over automatic gain control from the first stage (a tuner chip like
> the TUA6030).  The objective is to set the TOP to achieve maximum gain
> in the first stage while avoiding clipping in the first stage.  When the
> input signal level is smaller than the TOP, the first stage gain is at a
> maximum, and the second stage is performing automatic gain control
> internally.  When the input signal level becomes greater than the TOP,
> the first stage gain needs to be reduced by an AGC, and the second stage
> gain remains constant.
> 
> 
> As I understand it, it would be best to set the first stage (TUA6030 or
> similar) to "External AGC" and set the take over point in the second
> stage (the TDA9887), if the pins between the chips are wired up properly
> inside the tuner.  This should coordinate the AGC in both the first
> stage and second stage of the tuner, as the second stage will be
> providing the gain control to the first stage as needed when the signal
> reaches the TOP.
> 
> http://www.comsec.com/usrp/microtune/NF_tutorial.pdf
> 
> It allows you to achieve maximum gain in the first stage to minimize
> overall receiver noise figure, and avoid clipping the input signal in
> the first stage (TUA6030) with a proper TOP setting in the second stage
> (TDA9887).  The TOP setting in the second stage needs to take into
> account IF SAW filter attenuation of course.
> 
> Do the circuit board traces in the FM1216ME_MK3 support the TDA9887
> controlling the gain of the first stage?  (I've never opened an
> equivalent NTSC tuner assembly to take a look.)

"equivalent" NTSC tuners _do not_ exist at all.

I don't forget all the time we spend to find out that some of them are
Intercarrier only!

Also, the tda988x stuff is underneath the tuner PCB.

I cut one off for those interested in line tracing ...

Without port2=0 you don't get any SECAM-L into the sound trap.

It needs amplification from minus 40 dB AM for the first sound carrier,
and then of course you prefer the second with NICAM.

> If not, then, if I understand things correctly, you need to set the
> first stage and second stage TOP settings so that they refer to about
> the same signal level before the IF SAW filter.  
> 
> 
> I would think AGC TOP settings, for both stages of the tuner, are
> tuner-dependent and relatively constant once you figure out what they
> should be.
> 
> Do you have a different understanding or insight?
> 
> Regards,
> Andy

Since I have some m$ system again after 9 years, not used within the
last three months, I would prefer to get it demonstrated there at first.

I leave on the first BSOD.

Cheers,
Hermann

> 
> 
> 
> > If TV card is not touch V4L2_CTRL_FLAG_DISABLED in this control. The programm can't change AGC TOP.
> > And write default value to AGC TOP like now.
> > 
> > diff -r 43dbc8ebb5a2 linux/drivers/media/common/tuners/tuner-simple.c
> > --- a/linux/drivers/media/common/tuners/tuner-simple.c	Tue Jan 27 23:47:50 2009 -0200
> > +++ b/linux/drivers/media/common/tuners/tuner-simple.c	Tue Apr 21 09:44:38 2009 +1000
> > @@ -116,6 +116,7 @@
> >  
> >  	u32 frequency;
> >  	u32 bandwidth;
> > +	signed int gain;
> >  };
> >  
> >  /* ---------------------------------------------------------------------- */
> > @@ -495,15 +507,57 @@
> >  				   "(should be 4)\n", rc);
> >  		break;
> >  	}
> > +	case TUNER_PHILIPS_FM1216ME_MK3:
> > +	{
> > +		buffer[2] = 0xDE; /* T2 = 0, T1 = 1 and T0 = 1 */
> > +		switch (priv->gain) {
> > +		case 0:
> > +			/* TOP = External AGC, ATC = OFF */
> > +			buffer[3] = 0x60;
> > +			break;
> > +		case 1:
> > +			/* TOP = 118 dB, ATC = OFF */
> > +			buffer[3] = 0x00;
> > +			break;
> > +		case 2:
> > +			/* TOP = 115 dB, ATC = OFF */
> > +			buffer[3] = 0x10;
> > +			break;
> > +		case 3:
> > +			/* TOP = 112 dB, ATC = OFF */
> > +			buffer[3] = 0x20;
> > +			break;
> > +		case 4:
> > +			/* TOP = 109 dB, ATC = OFF */
> > +			buffer[3] = 0x30;
> > +			break;
> > +		case 5:
> > +			/* TOP = 106 dB, ATC = OFF */
> > +			buffer[3] = 0x40;
> > +			break;
> > +		case 6:
> > +			/* TOP = 103 dB, ATC = OFF */
> > +			buffer[3] = 0x50;
> > +			break;
> > +		default:
> > +			/* TOP = 112 dB, ATC = OFF */
> > +			buffer[3] = 0x20;
> > +			break;
> > +		}
> > +
> > +		tuner_dbg("tv 0x%02x 0x%02x 0x%02x 0x%02x\n",
> > +			  buffer[0], buffer[1], buffer[2], buffer[3]);
> > +
> > +		rc = tuner_i2c_xfer_send(&priv->i2c_props, buffer, 4);
> > +		if (4 != rc)
> > +			tuner_warn("i2c i/o error: rc == %d "
> > +				   "(should be 4)\n", rc);
> > +
> > +		break;
> >  	}
> > -
> > +	}
> >  	return 0;
> >  }
> >  
> > diff -r 43dbc8ebb5a2 linux/drivers/media/video/saa7134/saa7134-cards.c
> > --- a/linux/drivers/media/video/saa7134/saa7134-cards.c	Tue Jan 27 23:47:50 2009 -0200
> > +++ b/linux/drivers/media/video/saa7134/saa7134-cards.c	Tue Apr 21 09:44:38 2009 +1000
> > @@ -6506,6 +6806,20 @@
> >  		saa_call_all(dev, tuner, s_config, &tea5767_cfg);
> >  		break;
> >  	}
> > +	case SAA7134_BOARD_BEHOLD_M6_EXTRA:
> > +	{
> > +		struct v4l2_queryctrl *ctl;
> > +		struct saa7134_fh *fh;
> > +		struct file *fl;
> > +
> > +		ctl->id = V4L2_CID_GAIN;
> > +		if (saa7134_queryctrl(fl, fh, ctl) == 0) {                /* BUG here */
> > +			/* enable this control */
> > +			ctl->flags &= ~(V4L2_CTRL_FLAG_DISABLED);
> > +		}
> > +	}
> >  	} /* switch() */
> >  
> >  	saa7134_tuner_setup(dev);
> > diff -r 43dbc8ebb5a2 linux/drivers/media/video/saa7134/saa7134-video.c
> > --- a/linux/drivers/media/video/saa7134/saa7134-video.c	Tue Jan 27 23:47:50 2009 -0200
> > +++ b/linux/drivers/media/video/saa7134/saa7134-video.c	Tue Apr 21 09:44:38 2009 +1000
> > @@ -417,6 +417,15 @@
> >  		.step          = 1,
> >  		.default_value = 0,
> >  		.type          = V4L2_CTRL_TYPE_INTEGER,
> > +	}, {
> > +		.id 		= V4L2_CID_GAIN,
> > +		.name 		= "Gain",
> > +		.minimum 	= 0,
> > +		.maximum 	= 6,
> > +		.step 		= 1,
> > +		.default_value 	= 3,
> > +		.type 		= V4L2_CTRL_TYPE_INTEGER,
> > +		.flags 		= V4L2_CTRL_FLAG_DISABLED,
> >  	},{
> >  		.id            = V4L2_CID_HFLIP,
> >  		.name          = "Mirror",
> > @@ -1129,6 +1138,9 @@
> >  	case V4L2_CID_HUE:
> >  		c->value = dev->ctl_hue;
> >  		break;
> > +	case V4L2_CID_GAIN:
> > +		c->value = dev->ctl_gain;
> > +		break;
> >  	case V4L2_CID_CONTRAST:
> >  		c->value = dev->ctl_contrast;
> >  		break;
> > @@ -1214,6 +1226,10 @@
> >  	case V4L2_CID_HUE:
> >  		dev->ctl_hue = c->value;
> >  		saa_writeb(SAA7134_DEC_CHROMA_HUE, dev->ctl_hue);
> > +		break;
> > +	case V4L2_CID_GAIN:
> > +		dev->ctl_gain = c->value;
> > +
> >  		break;
> >  	case V4L2_CID_CONTRAST:
> >  		dev->ctl_contrast = c->value;
> > @@ -2502,6 +2518,7 @@
> >  	dev->ctl_bright     = ctrl_by_id(V4L2_CID_BRIGHTNESS)->default_value;
> >  	dev->ctl_contrast   = ctrl_by_id(V4L2_CID_CONTRAST)->default_value;
> >  	dev->ctl_hue        = ctrl_by_id(V4L2_CID_HUE)->default_value;
> > +	dev->ctl_gain       = ctrl_by_id(V4L2_CID_GAIN)->default_value;
> >  	dev->ctl_saturation = ctrl_by_id(V4L2_CID_SATURATION)->default_value;
> >  	dev->ctl_volume     = ctrl_by_id(V4L2_CID_AUDIO_VOLUME)->default_value;
> >  	dev->ctl_mute       = 1; // ctrl_by_id(V4L2_CID_AUDIO_MUTE)->default_value;
> > diff -r 43dbc8ebb5a2 linux/drivers/media/video/saa7134/saa7134.h
> > --- a/linux/drivers/media/video/saa7134/saa7134.h	Tue Jan 27 23:47:50 2009 -0200
> > +++ b/linux/drivers/media/video/saa7134/saa7134.h	Tue Apr 21 09:44:38 2009 +1000
> > @@ -548,6 +558,7 @@
> >  	int                        ctl_bright;
> >  	int                        ctl_contrast;
> >  	int                        ctl_hue;
> > +	int                        ctl_gain;             /* gain */
> >  	int                        ctl_saturation;
> >  	int                        ctl_freq;
> >  	int                        ctl_mute;             /* audio */
> > 
> > 
> > With my best regards, Dmitry.
> > 
> > > Cheers,
> > > Hermann
> > > 
> > > > With my best regards, Dmitry.
> > > > 
> > > > > 
> > > > > Cheers,
> > > > > Mauro.
> > > > > 
> > > > > > 
> > > > > > diff -r b40d628f830d
> > > > > > linux/drivers/media/common/tuners/tuner-types.c ---
> > > > > > a/linux/drivers/media/common/tuners/tuner-types.c	Fri
> > > > > > Apr 24 01:46:41 2009 -0300 +++
> > > > > > b/linux/drivers/media/common/tuners/tuner-types.c	Tue
> > > > > > Apr 28 03:35:42 2009 +1000 @@ -558,8 +558,8 @@ static struct
> > > > > > tuner_range tuner_fm1216me_mk3_pal_ranges[] = { { 16 *
> > > > > > 158.00 /*MHz*/, 0x8e, 0x01, },
> > > > > > -	{ 16 * 442.00 /*MHz*/, 0x8e, 0x02, },
> > > > > > -	{ 16 * 999.99        , 0x8e, 0x04, },
> > > > > > +	{ 16 * 441.00 /*MHz*/, 0x8e, 0x02, },
> > > > > > +	{ 16 * 864.00        , 0x8e, 0x04, },
> > > > > >  };
> > > > > >  
> > > > > >  static struct tuner_params tuner_fm1216me_mk3_params[] = {
> > > > > > 
> > > > > > Signed-off-by: Beholder Intl. Ltd. Dmitry Belimov
> > > > > > <d.belimov@gmail.com>
> > > > > > 
> > > > > > 
> > > > > > With my best regards, Dmitry.
> > > > > > 
> > > > > > > Hi Dmitri,
> > > > > > > 
> > > > > > > Thank you for you responses.
> > > > > > > 
> > > > > > > Just a few more comments...
> > > > > > > 
> > > > > > > On Thu, 2009-04-23 at 20:36 +1000, Dmitri Belimov wrote:
> > > > > > > > Hi Andy
> > > > > > > > 
> > > > > > > > > Dmitri,
> > > > > > > > > 
> > > > > > > > > 
> > > > > > > > > On Wed, 2009-04-22 at 17:48 +1000, Dmitri Belimov wrote:
> > > > > > > > > > Hi All
> > > > > > > > > > 
> > > > > > > > > > 1. Change middle band. In the end of the middle band the
> > > > > > > > > > sensitivity of receiver not good. If we switch to higher
> > > > > > > > > > band, sensitivity more better. Hardware trick.
> > > > > > > > > 
> > > > > > > 
> > > > > > > > Several years a go your customers write some messages about
> > > > > > > > bad quality of TV if frequency of TV is the end of band. It
> > > > > > > > can be low band or middle. Our hardware engeneer make some
> > > > > > > > tests with hardware TV generator and our TV tuners.
> > > > > > > > 
> > > > > > > > If we set default frequency range for low and middle band,
> > > > > > > > quality of TV signal on 159MHz and 442 MHz is bad. When we
> > > > > > > > make our changes with moving end of bands the quality of TV
> > > > > > > > much better. And our system programmer for OS Windows use
> > > > > > > > changed bands for drivers. Customers be happy.
> > > > > > > 
> > > > > > > OK.  A properly run experiment wins over theory every time. :)
> > > > > > > 
> > > > > > > 
> > > > > > > 
> > > > > > > > You can test it if in your placement available TV programm
> > > > > > > > on 159MHz or 442MHz. This trick can be usefull for other
> > > > > > > > tuners.
> > > > > > > 
> > > > > > > If you look at tveeprom.c, a number of other tuners are using
> > > > > > > that tuner definition:
> > > > > > > 
> > > > > > > $ grep FM1216ME_MK3 tveeprom.c
> > > > > > > 	{ TUNER_PHILIPS_FM1216ME_MK3, 	"Philips
> > > > > > > FQ1216ME MK3"}, { TUNER_PHILIPS_FM1216ME_MK3,
> > > > > > > 	"Philips FM1216 ME MK3"},
> > > > > > > { TUNER_PHILIPS_FM1216ME_MK3, 	"LG S001D MK3"},
> > > > > > > { TUNER_PHILIPS_FM1216ME_MK3, 	"LG S701D MK3"},
> > > > > > > { TUNER_PHILIPS_FM1216ME_MK3, 	"Philips FQ1216LME
> > > > > > > MK3"}, { TUNER_PHILIPS_FM1216ME_MK3, 	"TCL MFPE05 2"},
> > > > > > > { TUNER_PHILIPS_FM1216ME_MK3, 	"TCL MPE05-2"},
> > > > > > > { TUNER_PHILIPS_FM1216ME_MK3, 	"Philips FM1216ME MK5"},
> > > > > > > 
> > > > > > > If your change makes things bad for the other tuners, we'll
> > > > > > > probably have to create an alternate entry for the other
> > > > > > > tuners instead of using the FM1216ME_MK3 defintion.  I
> > > > > > > suspect most of them are clones of the FM1216ME MK3 however,
> > > > > > > so it probably won't matter.
> > > > > > > 
> > > > > > > > > > 3. Set charge pump bit
> > > > > > > > > 
> > > > > > > > > This will improve the time to initially tune to a
> > > > > > > > > frequency, but will likely add some noise as the PLL
> > > > > > > > > continues to maintain lock on the signal.  If there is no
> > > > > > > > > way to turn off the CP after the lock bit is set in the
> > > > > > > > > tuner, it's probably better to leave it off for lower
> > > > > > > > > noise and just live with slower tuning.
> > > > > > > > 
> > > > > > > > We discuss with our windows system programmer about it. He
> > > > > > > > sad that in analog TV mode noise from PLL don't give any
> > > > > > > > problem.
> > > > > > > 
> > > > > > > I would be concerned about phase noise affecting the colors or
> > > > > > > any FM sound carriers.  If the noise isn't noticably affecting
> > > > > > > colors to the human eye (do color bars look OK?), or sound to
> > > > > > > the human ear, then OK.
> > > > > > > 
> > > > > > > 
> > > > > > > >  But in digital TV mode
> > > > > > > > noise from PLL decreased BER.
> > > > > > > 
> > > > > > > I thought the FM1216ME MK3 was an analog only tuner.  I guess
> > > > > > > I don't know DVB-T or cable in Europe well enough.
> > > > > > > 
> > > > > > > 
> > > > > > > > > Leaving the CP bit set should be especially noticable ad
> > > > > > > > > FM noise when set to tune to FM radio stations.  From the
> > > > > > > > > FM1236ME_MK3 datasheet: "It is recommended to set CP=0 in
> > > > > > > > > the FM mode at all times." But the VHF low band control
> > > > > > > > > byte is also used when setting FM radio (AFAICT with a
> > > > > > > > > quick look at the code.)
> > > > > > > > 
> > > > > > > > Yes. You are right. We can swith CP off in FM mode.
> > > > > > > 
> > > > > > > OK.  Thank you.
> > > > > > > 
> > > > > > > > With my best regards, Dmitry.
> > > > > > > 
> > > > > > > 
> > > > > > > Regards,
> > > > > > > Andy
> > > > > > > 
> > > > > > > 
> > > > > > > 
> > > > > 
> > > > > 
> > > > > 
> > > > > 
> > > > > Cheers,
> > > > > Mauro
> > > 
> > > 
> > 
> 

