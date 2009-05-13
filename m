Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-14.arcor-online.net ([151.189.21.54]:50455 "EHLO
	mail-in-14.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756391AbZEMXtt (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 13 May 2009 19:49:49 -0400
Subject: Re: [PATCH] FM1216ME_MK3 some changes
From: hermann pitton <hermann-pitton@arcor.de>
To: Dmitri Belimov <d.belimov@gmail.com>
Cc: Andy Walls <awalls@radix.net>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	video4linux-list@redhat.com, linux-media@vger.kernel.org
In-Reply-To: <20090513073757.6177c42e@glory.loctelecom.ru>
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
	 <1241836025.3717.9.camel@pc07.localdom.local>
	 <1241916185.3694.8.camel@pc07.localdom.local>
	 <20090510085258.03068a1e@glory.loctelecom.ru>
	 <1242012951.3753.21.camel@pc07.localdom.local>
	 <20090513073757.6177c42e@glory.loctelecom.ru>
Content-Type: text/plain
Date: Thu, 14 May 2009 01:44:43 +0200
Message-Id: <1242258283.4781.26.camel@pc07.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Dmitry,

Am Mittwoch, den 13.05.2009, 07:37 +1000 schrieb Dmitri Belimov:
> Hi hermann
> 
> > Am Sonntag, den 10.05.2009, 08:52 +1000 schrieb Dmitri Belimov:
> > > Hi All.
> > > 
> > > > [snip]
> > > > > > 
> > > > > > Channel designations I dug out of ivtv-tune:
> > > > > > 
> > > > > > S38 439.250 MHz (European cable)
> > > > > > H18 439.250 MHz (SECAM France)
> > > > > > 47  440.250 MHz (PAL China)
> > > > > > 059 440.250 MHz (PAL Argentina)
> > > > > > 
> > > > > > come close, but are unaffected by the change from 442 to 441
> > > > > > as the bandswitch cutover point.  These channels fall right
> > > > > > on top of the cutover, but are not affected by the proposed
> > > > > > change in any meaningful way.  The VHF-High filter and VCO
> > > > > > would still be used.  Dmitri's proposed change is a "don't
> > > > > > care" unless the cutover point is changed to 440 MHz. 
> > > > > > 
> > > > > > 
> > > > > > Let's pretend that the proposed cutover point is 440 MHz.
> > > > 
> > > > NO! it is not
> > > > 
> > > > Dmitri,
> > > > 
> > > > can you cut one off and tell us what it is all about ?
> > > > 
> > > > Unless you do so, all other is pointless and I likely stop to
> > > > participate in such stuff.
> > > 
> > > Sorry my delay. I lost subject of discussion. What main question??
> > > 
> > > 1. AGC TOP of RF part - I think need support for MK3
> > > 2. Changing to 441MHz is not critical. We can write some
> > > information about this case to Wiki or docs.
> > 
> > for 2.: Discussed to the end if you stay at 441MHz. If you still want
> > to have it in, just send  a patch and no more info is needed. (Likely
> > Andy is giving only examples for more difficult cases, sorry.)
> > 
> > for 1.: I would like to be absolutely sure, that we are talking about
> > the same tuner. I want to have the exact filters on it at least.
> > 
> > 3.: That is what Andy noted. Following the Philips datasheet for TOP,
> > it should be added for negative modulation, positive modulation and FM
> > accordingly. (2 and 3 are out of discussion)
> > 
> > If you still have some sort of Secam fire and can improve it, we must
> > know the tuner you are on "exactly". If it is the original Philips,
> > without any such TOP suggestions over the full range in recent
> > datasheets (???), I assume you might have them, I would say you can
> > proceed, if you have shown that you are really still on the same
> > tuner.
> 
> This is real Philips MK3 and MK5 tuner. We have all docs from vendor.
> 
> This is some photos of the MK3 hybrid tuner. I make photos of the analog MK3 little later.
> 

thanks a lot.

I had only a first look on this one.

There are a lot of different revisions, yours is F4 on the tuner PCB.

Taifun PLL versions vary, different combinations of ceramic and SMD
filters are used for the radio IF,

but even on a revision C1 with Taifun 6034T A1 and tuner revision SV21
0437 (CTX918_V2 md7134) all three SAW filters are the same already. 

A CTX925 with your Taifun 6034T B1 had also no better performance for
what I can say. PCB still has C1, but SV21 0502 tuner revision.

Important to know was, that you are on original Philips tuners and SAW
filters are the same. Guess this will hold for the analog FM1216ME/I MK3
too.

Good decision, it are still the best tuners for analog and digital I
have around, but can't talk for Secam D/K. I wonder about missing
complaints during the last four years.

Cheers,
Hermann


