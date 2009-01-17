Return-path: <linux-media-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.175]:46658 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756051AbZAQMgo (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 17 Jan 2009 07:36:44 -0500
Received: by ug-out-1314.google.com with SMTP id 39so94580ugf.37
        for <linux-media@vger.kernel.org>; Sat, 17 Jan 2009 04:36:43 -0800 (PST)
Date: Sat, 17 Jan 2009 13:36:36 +0100 (CET)
From: BOUWSMA Barry <freebeer.bouwsma@gmail.com>
To: Patrick Boettcher <patrick.boettcher@desy.de>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [linux-dvb] RFC - Flexcop Streaming watchdog (VDSB)
In-Reply-To: <alpine.DEB.2.00.0901171116420.18169@ybpnyubfg.ybpnyqbznva>
Message-ID: <alpine.DEB.2.00.0901171305400.18169@ybpnyubfg.ybpnyqbznva>
References: <alpine.LRH.1.10.0901161548460.28478@pub2.ifh.de> <4970D464.5070509@gmx.de> <alpine.DEB.2.00.0901170035190.18012@ybpnyubfg.ybpnyqbznva> <alpine.LRH.1.10.0901170923030.5725@pub4.ifh.de> <alpine.DEB.2.00.0901171116420.18169@ybpnyubfg.ybpnyqbznva>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Following up to myself is a sign of a sick mind.

On Sat, 17 Jan 2009, BOUWSMA Barry wrote:

> > shell 1: $ tzap channel
> > shell 2: $ dvbtraffic
> > [lots of output that streaming is working]
> > shell 1: $ <C-c>
> > shell 1: $ tzap "channel2_which is on a different frequency"
> > shell 2: no output of dvbtraffic any longer... (problem)

> I'll see if I can reproduce this on my production machine once
> it's idle, or if my hacks might be involved, and report back
> about this...

Here's what I see. It may not be meaningful.  This machine
uses utilities from 2005 or so, sometimes hacked but still
based on source from 2005.

Anyway, with the SkyStar2:
szap a-channel-which-locks
dvbtraffic-card0 ==> output, whee
^C szap; dvbtraffic continues for a few seconds (timeout)
szap the-same-channel or a-different-frequency
no dvbtraffic output yet
^C szap; immediately dvbtraffic outputs again for a few secs

With a DVB-T tuner:
tzap a-channel-which-locks
dvbtraffic-card1 ==> output, yay
^C tzap; dvbtraffic continues a few seconds
tzap again
no dvbtraffic output yet
^C tzap
still no dvbtraffic output...

But no errors are thrown up, nor does anything appear logged
to the console.

However, [ts]zap are system binaries from 2004; dvbtraffic
is hacked, though I'm not sure how heavily, so I don't know
if what I see is meaningful.

Invoking `dvbtraffic' first, then `dvbstream' also produces
some results for a fraction of a second, then no `dvbtraffic'
output.


So, at this point, I don't know what to say...

barry bouwsma
