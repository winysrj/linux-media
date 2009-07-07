Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ew0-f226.google.com ([209.85.219.226]:38224 "EHLO
	mail-ew0-f226.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755298AbZGGXSc (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 7 Jul 2009 19:18:32 -0400
Received: by ewy26 with SMTP id 26so1119075ewy.37
        for <linux-media@vger.kernel.org>; Tue, 07 Jul 2009 16:18:31 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1246999504.9754.9.camel@pc07.localdom.local>
References: <200907070644.n676iS803945@neptune.localwarp.net>
	 <1246999504.9754.9.camel@pc07.localdom.local>
Date: Tue, 7 Jul 2009 19:18:30 -0400
Message-ID: <37219a840907071618x3842aaaeo21c48c3d9273155c@mail.gmail.com>
Subject: Re: regression : saa7134 with Pinnacle PCTV 50i (analog) can not tune
	anymore
From: Michael Krufky <mkrufky@kernellabs.com>
To: hermann pitton <hermann-pitton@arcor.de>
Cc: eric.paturage@orange.fr, linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Jul 7, 2009 at 4:45 PM, hermann pitton<hermann-pitton@arcor.de> wrote:
> As far I know we did not change the bus speed or anything, but some
> cards need and i2c quirk to work correctly with the clients.
>
> Mike recently changed the old quirk with good reasons and it was widely
> tested, also by me, without any negative effect seen.
>
> Maybe your card is a rare case needing the old quirk.

I've already testes in the Pinnacle board and the quirk did not cause
any new problems.

I mentioned, however, that I saw some frontend issues that should be
looked at.  I dont have time right now to deal with this myself, but
perhaps within the next few weeks I can take a look at it.

Meanwhile, that was with respect to digital reception, only -- I did
not have such problems with analog -- not that I recall, at least.

Also, it does no good to manually modprobe tda8290, tda827x or
tda18271 -- the -dvb bridge driver will attach those modules as
needed, just as the tuner.ko module would as well.

I'd recommend to go back to a stable vanilla kernel, then rebuild
v4l-dvb from linuxtv.org with all options enabled.  If there are still
issues at that point, it should be looked at again.

Sorry I dont have any real answers, but I have my eye on this thread
-- I'll chime in if I can offer any more advice.

Good Luck,

Mike
