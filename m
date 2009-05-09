Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-14.arcor-online.net ([151.189.21.54]:35442 "EHLO
	mail-in-14.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751207AbZEICfl (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 8 May 2009 22:35:41 -0400
Subject: Re: [PATCH] FM1216ME_MK3 some changes
From: hermann pitton <hermann-pitton@arcor.de>
To: Andy Walls <awalls@radix.net>
Cc: Dmitri Belimov <d.belimov@gmail.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	video4linux-list@redhat.com, linux-media@vger.kernel.org
In-Reply-To: <1241834493.3482.140.camel@palomino.walls.org>
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
	 <1241741304.4864.29.camel@pc07.localdom.local>
	 <1241834493.3482.140.camel@palomino.walls.org>
Content-Type: text/plain
Date: Sat, 09 May 2009 04:27:05 +0200
Message-Id: <1241836025.3717.9.camel@pc07.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Am Freitag, den 08.05.2009, 22:01 -0400 schrieb Andy Walls:
> On Fri, 2009-05-08 at 02:08 +0200, hermann pitton wrote:
> > Am Mittwoch, den 06.05.2009, 23:03 -0400 schrieb Andy Walls:
> 
> > > > For the change of UHF start I don't see any problem.
> > > 
> > > If you're talking about the frequency for the bandswitch, I don't see a
> > > problem either in general.  It may cause a problem for clones of the
> > > FM1216ME MK3 that don't have the same filter performance near the
> > > cutover, but use the same tuner defintion as the FM1216ME MK3 in
> > > tuner-types.c.
> > > 
> > > It may be best to point any clones to a new entry that looks like the
> > > current FM1216ME MK3 entry unmodified.
> > 
> > Andy, thanks a lot for participating in such stuff and I think your
> > diagnosis is right.
> > 
> > Just a small question in between, already late here and not trying to
> > cover the whole scope.
> > 
> > What ever should be the effect of Dmitri's trick one, changing beginning
> > of UHF a little. We did that for midband and there was real broadcast
> > and it improved one single channel there indeed.
> > 
> > But here, it is plain theory. I honor the lab results they have, no
> > problem anyway, but to change something for not at all existing
> > broadcast does exactly nothing, except for awaiting it in the future.
> > 
> > No problem with that change, but do I miss something?
> 
> Now that you ask, maybe.
> 
> It first depends on whether there is a station at 441 MHz that normally
> would have used the VHF-High filter and VCO, but now uses the UHF filter
> and VCO.
> 
> Channel designations I dug out of ivtv-tune:
> 
> S38 439.250 MHz (European cable)
> H18 439.250 MHz (SECAM France)
> 47  440.250 MHz (PAL China)
> 059 440.250 MHz (PAL Argentina)
> 
> come close, but are unaffected by the change from 442 to 441 as the
> bandswitch cutover point.  These channels fall right on top of the
> cutover, but are not affected by the proposed change in any meaningful
> way.  The VHF-High filter and VCO would still be used.  Dmitri's
> proposed change is a "don't care" unless the cutover point is changed to
> 440 MHz. 
> 
> 
> Let's pretend that the proposed cutover point is 440 MHz.  The high
> frequencies in the channel (~ 447 MHz) may have perhaps been in the
> roll-off of the VHF-High preselector filter.  At the edges of filters,
> amplitude ripple and especially group delay variation - two aspects of
> filters that cause distortion - would have been at their worst,
> affecting the high frequencies of the channel (sound and color
> sub-carriers).  (I assume PAL is VSB with the carrier towards the low
> end, similar to NTSC.)  Now instead, the low frequencies of the channel
> (~ 440 MHz) may be in the roll-off of the UHF preselector filter.  Thus
> the vestigal sideband and carrier could be affected most by ripple and
> group delay variation of the UHF filter.
> 
> Either way, a channel at 440 MHz could face distortion by this tuner.
> It really depends on the preselector filter design.
> 
> 
> I also checked the MID and HIGH band oscillator spec's in the TUA6030
> datasheet.  Both of them can cover 440 MHz, but it looks like the MID
> band VCO may be preferred since it doesn't drift as badly as the HIGH
> band VCO.  Since I don't know the component values used in the loop
> filters for the VCO's, I can't do any real analysis to see which VCO
> would be better at handling 440 MHz.  I suspect the difference may not
> be significant anyway.
> 
> 
> > Also, after hundreds of "new" tuners did appear, in the beginning not
> > even known from where, I suggested to not allow a new tuner entry for
> > all of them, only duplicate code, until they really need it and show off
> > their difference.
> > 
> > I would like to keep it especially for this one the same. ;)
> 
> OK.
> 
> > Such subsumed under it have done nothing for Linux so far and have to
> > face their faith :) And show off, if _not_ compatible.
> > 
> > And not the other way round.
> 
> Wait until people complain? :)

Yes, of course. They had it for free and that is the trap.

Again, don't try to start it the other way round.

I still wait for Dmitri, to show really off what he has.

And, unfortunately, I don't have anything to test on currently :)

Cheers,
Hermann

> 
> Regards,
> Andy
> 
> > Dmitri, if we are talking about the same tuner and filters, we should
> > try to get Secam D/K improvements into the original tuner entry.
> > 
> > That NTSC hack stuff might go elsewhere I guess.
> > 
> > Cheers,
> > Hermann
> 
> 

