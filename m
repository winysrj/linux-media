Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f158.google.com ([209.85.220.158]:48160 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752087AbZEJMwn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 10 May 2009 08:52:43 -0400
Received: by fxm2 with SMTP id 2so2196317fxm.37
        for <linux-media@vger.kernel.org>; Sun, 10 May 2009 05:52:42 -0700 (PDT)
Date: Sun, 10 May 2009 08:52:58 +1000
From: Dmitri Belimov <d.belimov@gmail.com>
To: hermann pitton <hermann-pitton@arcor.de>
Cc: Andy Walls <awalls@radix.net>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	video4linux-list@redhat.com, linux-media@vger.kernel.org
Subject: Re: [PATCH] FM1216ME_MK3 some changes
Message-ID: <20090510085258.03068a1e@glory.loctelecom.ru>
In-Reply-To: <1241916185.3694.8.camel@pc07.localdom.local>
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
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi All.

> [snip]
> > > 
> > > Channel designations I dug out of ivtv-tune:
> > > 
> > > S38 439.250 MHz (European cable)
> > > H18 439.250 MHz (SECAM France)
> > > 47  440.250 MHz (PAL China)
> > > 059 440.250 MHz (PAL Argentina)
> > > 
> > > come close, but are unaffected by the change from 442 to 441 as
> > > the bandswitch cutover point.  These channels fall right on top
> > > of the cutover, but are not affected by the proposed change in
> > > any meaningful way.  The VHF-High filter and VCO would still be
> > > used.  Dmitri's proposed change is a "don't care" unless the
> > > cutover point is changed to 440 MHz. 
> > > 
> > > 
> > > Let's pretend that the proposed cutover point is 440 MHz.
> 
> NO! it is not
> 
> Dmitri,
> 
> can you cut one off and tell us what it is all about ?
> 
> Unless you do so, all other is pointless and I likely stop to
> participate in such stuff.

Sorry my delay. I lost subject of discussion. What main question??

1. AGC TOP of RF part - I think need support for MK3
2. Changing to 441MHz is not critical. We can write some information about this case to Wiki or docs.

With my best regards, Dmitry.

> 
> Cheers,
> Hermann
> 
> 
> 
> 
> 
