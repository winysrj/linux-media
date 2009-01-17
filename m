Return-path: <linux-media-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.170]:42771 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754775AbZAQKuk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 17 Jan 2009 05:50:40 -0500
Received: by ug-out-1314.google.com with SMTP id 39so91209ugf.37
        for <linux-media@vger.kernel.org>; Sat, 17 Jan 2009 02:50:38 -0800 (PST)
Date: Sat, 17 Jan 2009 11:50:32 +0100 (CET)
From: BOUWSMA Barry <freebeer.bouwsma@gmail.com>
To: Patrick Boettcher <patrick.boettcher@desy.de>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [linux-dvb] RFC - Flexcop Streaming watchdog (VDSB)
In-Reply-To: <alpine.LRH.1.10.0901170923030.5725@pub4.ifh.de>
Message-ID: <alpine.DEB.2.00.0901171116420.18169@ybpnyubfg.ybpnyqbznva>
References: <alpine.LRH.1.10.0901161548460.28478@pub2.ifh.de> <4970D464.5070509@gmx.de> <alpine.DEB.2.00.0901170035190.18012@ybpnyubfg.ybpnyqbznva> <alpine.LRH.1.10.0901170923030.5725@pub4.ifh.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, 17 Jan 2009, Patrick Boettcher wrote:

> > Same here -- never experienced this ever in some four-ish years
> > with one SkyStar2 of model long forgotten, with that card being

> Using VDR or a single application (like kaffeine), you most likely don't see
> the error anymore thanks to the work-around which is already in place. It is
> resetting the streaming interface at the end of a streaming-session, ie. when
> the pid-filter count is going from 1 to 0. This happens all the time with VDR
> (and similar) when it is retuning.

Okay, I've been using `dvbstream' standalone, also modified so
that it and related utilities get an exclusive lock on the
adapter (otherwise when I'd make a mistake, the second invocation
of `dvbstream' would not only fail, but the first recording was
also messed up, so less than useless).

`scan' has also been used, although in my latest installation
(including a 12-output multiswitch), the card I have has been
unable to lock or to get error-free output from transponders at
the ends of the frequency range -- this affects at Astra 19E2
the ORF transponders among others, and at 28E many of the Channel 
4 family, while all other devices on the same multiswitch have
no difficulties at even higher frequencies and can scan the
entire range perfectly.  I've also guessed this could be due to
spiders taking up residence in the warm interior of the tuning
circuits.  Anyway, someday I'll replace this card with an -S2
or perhaps dual- hybrid- whatever is available later.


> Now when you launch an application which is just requesting a pid and another
> one which is tuning independently, you can fall easily in this problem.
> PS: how to reproduce:
> shell 1: $ tzap channel
> shell 2: $ dvbtraffic
> [lots of output that streaming is working]
> shell 1: $ <C-c>
> shell 1: $ tzap "channel2_which is on a different frequency"
> shell 2: no output of dvbtraffic any longer... (problem)

This lack-of-output is something that I've experienced with
other cards (a dvb-usb DVB-T device), which I did not
investigate further.  If I remember rightly, and with a
more recent kernel.

Note that in my `dvbstream'-exclusively use of the SkyStar2, I
have never seen the error message (since trimmed from the
quoted original post).

I'll see if I can reproduce this on my production machine once
it's idle, or if my hacks might be involved, and report back
about this...


thanks
barry bouwsma
