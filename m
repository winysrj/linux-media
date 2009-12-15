Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ew0-f219.google.com ([209.85.219.219]:52795 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752616AbZLOIvc (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 15 Dec 2009 03:51:32 -0500
Received: by ewy19 with SMTP id 19so239442ewy.21
        for <linux-media@vger.kernel.org>; Tue, 15 Dec 2009 00:51:31 -0800 (PST)
Date: Tue, 15 Dec 2009 09:51:25 +0100 (CET)
From: BOUWSMA Barry <freebeer.bouwsma@gmail.com>
To: Michael Akey <akeym@onid.orst.edu>
cc: Linux Media <linux-media@vger.kernel.org>
Subject: Re: scan/scan-s2 doesn't tune, but dvbtune does?
In-Reply-To: <4B269F1A.30107@onid.orst.edu>
Message-ID: <alpine.DEB.2.01.0912150922430.31371@ybpnyubfg.ybpnyqbznva>
References: <4B269F1A.30107@onid.orst.edu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 14 Dec 2009, Michael Akey wrote:

> I can't get the scan/scan-s2 utilities to lock any transponders (DVB-S).  My
> test satellite is AMC1 103W, the Pentagon Channel tp. This is probably some
> simple user error on my part, but I can't figure it out.  I have a Corotor II
> with polarity changed via serial command to an external IRD.  C/Ku is switched
> by 22KHz tone, voltage is always 18V.  Ku is with tone off, C with tone on.

I'm afraid that I have a european background into which your use
does not fit my expectations.  What I expect is that the voltage
will be determined by what sort of polarisation you are trying to
receive (your fixed 18V would correspond to horizontally polarised
transponders) whilst the 22kHz tone would be used to select within
the Ku band between the low and high band (switchover between a
universal LNB's 9750 and 10 600 MHz IF at actual frequency near
11 700 MHz).

Variants thereupon may depend on older installations, and while
C band does exist, I've never personally bothered to use it or
play with LNBs and such to learn those details.  With this
background, I'll attempt to interpret what I see below.


> $ ./scan-s2 -a 0 -v -o zap -l 10750 INIT

> initial transponder DVB-S  12100000 H 20000000 AUTO AUTO AUTO
> initial transponder DVB-S2 12100000 H 20000000 AUTO AUTO AUTO
> ----------------------------------> Using DVB-S
> >>> tune to: 12100:h:0:20000
> DVB-S IF freq is 1350000

This frequency would normally be tuned with 22kHz tone on, with
a traditional Universal LNB.  I can't be arsed to look up the
particular bird on which your transponder lies to get its
particulars (frequency 12100h, SR 20000 I will take from your
parameters), but if this utility is selecting the 22kHz
switching signal based on the frequency, it may assume
that 12100 needs this tone, in spite of your specifying the
LO intermediate frequency, which apparently you use to select
between Ku band and when active, C band.


> If I use dvbtune, it works though..
> 
> $ dvbtune -f 1350000 -p H -s 20000 -c 0 -tone 0 -m

> tuning DVB-S to L-Band:0, Pol:H Srate=20000000, 22kHz=off

Here you're tuning directly to the IF frequency which the
above utility determines from your specified LO value and
desired tuning frequency.

I'd look at the source code for the above utilities which
fail to see if it's deciding 22kHz tone based on the tuned
frequencies.  If so, and there aren't options to work around
this as you can with directly specifying the IF to `dvbtune'
as above, then it may work to massage the input values you
feed to `scan' not to be the actual frequencies.


> The tuning file 'INIT' contains only the following line:
> S 12100000 H 20000000 AUTO

If this corresponds to 1 350 000 kHz IF, and you faked that
your LNB had an IF of 9750 MHz, the corresponding ``tuning
frequency'' would be 11 100 MHz, or 11100000 H in the above
line.  Horizontal polarisation corresponds to your 18V
nicely.  Otherwise it's a particular configuration which would
be alien to me with my limited hands-on experience.

Note that what you get back from parsing the NIT tables when
tuning the above transponder at the hacked value would need
to be again adjusted similarly.  But I don't know what the
frequencies and bands are that are used by this bird, nor do
I know what sort of consumer equipment is used outside the
part of the world where I learned my knowledge of the trade.

Anyway, that's how I interpret your results.  I'd be happy if
someone with more intimate knowledge of those utilities, their
options, and other setups, could give you a one-line cure for
your woes -- otherwise I hope I've provided a bit of background
to help you better understand what may be going on.
