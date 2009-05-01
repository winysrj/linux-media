Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-16.arcor-online.net ([151.189.21.56]:38055 "EHLO
	mail-in-16.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753130AbZEAX6E (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 1 May 2009 19:58:04 -0400
Subject: Re: [PATCH] FM1216ME_MK3 some changes
From: hermann pitton <hermann-pitton@arcor.de>
To: Andy Walls <awalls@radix.net>,
	Hartmut Hackmann <hartmut.hackmann@t-online.de>
Cc: Dmitri Belimov <d.belimov@gmail.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	video4linux-list@redhat.com, linux-media@vger.kernel.org
In-Reply-To: <1241155098.3713.26.camel@pc07.localdom.local>
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
	 <1241155098.3713.26.camel@pc07.localdom.local>
Content-Type: text/plain
Date: Sat, 02 May 2009 01:55:42 +0200
Message-Id: <1241222142.3709.14.camel@pc07.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Guys,

[snip]

> > 
> > Do the circuit board traces in the FM1216ME_MK3 support the TDA9887
> > controlling the gain of the first stage?  (I've never opened an
> > equivalent NTSC tuner assembly to take a look.)
> 
> "equivalent" NTSC tuners _do not_ exist at all.
> 
> I don't forget all the time we spend to find out that some of them are
> Intercarrier only!
> 
> Also, the tda988x stuff is underneath the tuner PCB.
> 
> I cut one off for those interested in line tracing ...

still on the to do list ;)

> Without port2=0 you don't get any SECAM-L into the sound trap.
> 
> It needs amplification from minus 40 dB AM for the first sound carrier,
> and then of course you prefer the second with NICAM.
> 
> > If not, then, if I understand things correctly, you need to set the
> > first stage and second stage TOP settings so that they refer to about
> > the same signal level before the IF SAW filter.  
> > 
> > 
> > I would think AGC TOP settings, for both stages of the tuner, are
> > tuner-dependent and relatively constant once you figure out what they
> > should be.
> > 
> > Do you have a different understanding or insight?
> > 
> > Regards,
> > Andy

Hartmut once offered to make contacts with colleagues at Philips Hamburg
for such tuners and related tda9887 stuff.

Unfortunately he is not active on the lists currently.

If I see, how easily someone can get a patch to Andrew and disables all
other SECAM stuff, again from Russia, I'm not convinced on anything from
there.

I seriously doubt that those tuners are meant for fumbling on TOP RF/IF
settings from user space.

Cheers,
Hermann




