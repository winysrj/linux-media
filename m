Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-07.arcor-online.net ([151.189.21.47]:46695 "EHLO
	mail-in-07.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751720AbZDWBzE (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 22 Apr 2009 21:55:04 -0400
Subject: Re: [PATCH] FM1216ME_MK3 some changes
From: hermann pitton <hermann-pitton@arcor.de>
To: Andy Walls <awalls@radix.net>
Cc: Dmitri Belimov <d.belimov@gmail.com>, video4linux-list@redhat.com,
	linux-media@vger.kernel.org
In-Reply-To: <1240452534.3232.70.camel@palomino.walls.org>
References: <20090422174848.1be88f61@glory.loctelecom.ru>
	 <1240452534.3232.70.camel@palomino.walls.org>
Content-Type: text/plain
Date: Thu, 23 Apr 2009 03:52:49 +0200
Message-Id: <1240451569.10367.18.camel@pc07.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Hi Andy and Dmitry,

Am Mittwoch, den 22.04.2009, 22:08 -0400 schrieb Andy Walls:
> Dmitri,
> 
> 
> On Wed, 2009-04-22 at 17:48 +1000, Dmitri Belimov wrote:
> > Hi All
> > 
> > 1. Change middle band. In the end of the middle band the sensitivity of receiver not good.
> > If we switch to higher band, sensitivity more better. Hardware trick.

first of all, Dmitry, you need to send all your patches, also the prior
ones, to linux-media@vger.kernel.org. Only there "patchwork" will parse
for them and you might eventually find them here.
http://patchwork.kernel.org/project/linux-media/list
http://patchwork.kernel.org/project/linux-media/list/?state=*

You seem to have missed that completely and thanks to Andy to start to
comment on this one, even only on video4linux previously.

> This concerns me slightly as it does not match the datasheet (hence the
> design objectives) of the FM1236ME_MK3.
> 
> How are you measuring sensitivity?  Do you know if it really is the
> middle-band preselector filter (and PLL and Mixer) or is it a problem
> with the input signal?  How do you know it is not manufacturing
> variations in the preselector filters with the particular tuner assembly
> you are testing?

I did not look into the datasheet again, we did not have it at all for a
very long time, but we had a similar case already and that time we made
the decision like it can be found in this thread. No complaints ever
until today.

http://marc.info/?l=linux-video&m=112639247330257&w=2

Did not look up all frequency tables again, but if it is the same again,
I would say the risk of doing something wrong is close to zero.

For the rest I never noticed any difference and we have it on lots of
other tuners like that. And, that one still means a lot of _different_
tuners and different manufacturers, filters definitely differ! ...

> Also, as an alternative to using a different frequency for the
> bandswitch, have you considered setting the Auxillary Byte in the tuner
> chip (Infineon TUA6030?) to use external AGC and experimented with
> changing the tuner AGC take-over point (TOP) in the TDA9887?
> 
> By maximizing the gain in the tuner chip, but avoiding clipping, with
> the proper TOP setting, you minimize the contributions by the rest of
> the receive chain to the overall receiver Noise Figure:
> 
> http://en.wikipedia.org/wiki/Friis_formulas_for_noise
> 
> This may be a way to improve receiver sensitivity that does not conflict
> with the data sheet specification.
> 
> 
> 
> 
> > 2. Set correct highest freq of the higher band.
> 
> :)
> 
> This bothers me too; all the tuners in tuner-types.c have it set too
> high (999.0 MHz).  I think I rememeber at time when all the tuner_range
> definitions had a real value there.
> 
> It would be nice to have a real value there for all the tuners.  The
> function tuner-simple.c:simple_config_lookup() would then prevent
> attempts to tune to an unsupported frequnecy.
> 
> 
> 
> > 3. Set charge pump bit
> 
> This will improve the time to initially tune to a frequency, but will
> likely add some noise as the PLL continues to maintain lock on the
> signal.  If there is no way to turn off the CP after the lock bit is set
> in the tuner, it's probably better to leave it off for lower noise and
> just live with slower tuning.
> 
> Leaving the CP bit set should be especially noticable ad FM noise when
> set to tune to FM radio stations.  From the FM1236ME_MK3 datasheet:
> "It is recommended to set CP=0 in the FM mode at all times."
> But the VHF low band control byte is also used when setting FM radio
> (AFAICT with a quick look at the code.)
> 
> Regards,
> Andy
> 
> > diff -r 43dbc8ebb5a2 linux/drivers/media/common/tuners/tuner-types.c
> > --- a/linux/drivers/media/common/tuners/tuner-types.c	Tue Jan 27 23:47:50 2009 -0200
> > +++ b/linux/drivers/media/common/tuners/tuner-types.c	Tue Apr 21 09:44:38 2009 +1000
> > @@ -557,9 +557,9 @@
> >  /* ------------ TUNER_PHILIPS_FM1216ME_MK3 - Philips PAL ------------ */
> >  
> >  static struct tuner_range tuner_fm1216me_mk3_pal_ranges[] = {
> > -	{ 16 * 158.00 /*MHz*/, 0x8e, 0x01, },
> > -	{ 16 * 442.00 /*MHz*/, 0x8e, 0x02, },
> > -	{ 16 * 999.99        , 0x8e, 0x04, },
> > +	{ 16 * 158.00 /*MHz*/, 0xc6, 0x01, },
> > +	{ 16 * 441.00 /*MHz*/, 0xc6, 0x02, },
> > +	{ 16 * 864.00        , 0xc6, 0x04, },
> >  };
> >  
> > 
> > 
> > Signed-off-by: Beholder Intl. Ltd. Dmitry Belimov <d.belimov@gmail.com>
> > 
> > With my best regards, Dmitry.

Cheers,
Hermann


