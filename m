Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-12.arcor-online.net ([151.189.21.52]:34847 "EHLO
	mail-in-12.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756211AbZGGXp3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 7 Jul 2009 19:45:29 -0400
Subject: Re: regression : saa7134 with Pinnacle PCTV 50i (analog) can not
	tune  anymore
From: hermann pitton <hermann-pitton@arcor.de>
To: Michael Krufky <mkrufky@kernellabs.com>
Cc: eric.paturage@orange.fr, linux-media@vger.kernel.org
In-Reply-To: <37219a840907071618x3842aaaeo21c48c3d9273155c@mail.gmail.com>
References: <200907070644.n676iS803945@neptune.localwarp.net>
	 <1246999504.9754.9.camel@pc07.localdom.local>
	 <37219a840907071618x3842aaaeo21c48c3d9273155c@mail.gmail.com>
Content-Type: text/plain
Date: Wed, 08 Jul 2009 01:41:16 +0200
Message-Id: <1247010076.7300.7.camel@pc07.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mike,

Am Dienstag, den 07.07.2009, 19:18 -0400 schrieb Michael Krufky:
> On Tue, Jul 7, 2009 at 4:45 PM, hermann pitton<hermann-pitton@arcor.de> wrote:
> > As far I know we did not change the bus speed or anything, but some
> > cards need and i2c quirk to work correctly with the clients.
> >
> > Mike recently changed the old quirk with good reasons and it was widely
> > tested, also by me, without any negative effect seen.
> >
> > Maybe your card is a rare case needing the old quirk.
> 
> I've already testes in the Pinnacle board and the quirk did not cause
> any new problems.
> 
> I mentioned, however, that I saw some frontend issues that should be
> looked at.  I dont have time right now to deal with this myself, but
> perhaps within the next few weeks I can take a look at it.
> 
> Meanwhile, that was with respect to digital reception, only -- I did
> not have such problems with analog -- not that I recall, at least.
> 
> Also, it does no good to manually modprobe tda8290, tda827x or
> tda18271 -- the -dvb bridge driver will attach those modules as
> needed, just as the tuner.ko module would as well.
> 
> I'd recommend to go back to a stable vanilla kernel, then rebuild
> v4l-dvb from linuxtv.org with all options enabled.  If there are still
> issues at that point, it should be looked at again.
> 
> Sorry I dont have any real answers, but I have my eye on this thread
> -- I'll chime in if I can offer any more advice.
> 
> Good Luck,
> 
> Mike

thanks a lot for following Eric's report.

I admit the case looks really strange and I have no better ideas at the
moment than to take the quirk into account, since i2c seems really to be
messed up on his card.

Did build a 2.6.30.1 one hour back and installed a recent v4l-dvb
mercurial on it and even have full support for my graphics card now.

No issues at all for what I can tell.

Cheers,
Hermann


