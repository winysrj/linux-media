Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ew0-f176.google.com ([209.85.219.176]:34153 "EHLO
	mail-ew0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753722AbZEGLyJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 7 May 2009 07:54:09 -0400
Received: by ewy24 with SMTP id 24so985208ewy.37
        for <linux-media@vger.kernel.org>; Thu, 07 May 2009 04:54:08 -0700 (PDT)
Date: Thu, 7 May 2009 13:53:59 +0200 (CEST)
From: BOUWSMA Barry <freebeer.bouwsma@gmail.com>
To: Luca Olivetti <luca@ventoso.org>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [linux-dvb] RFC - Flexcop Streaming watchdog (VDSB)
In-Reply-To: <49F3468C.4070101@ventoso.org>
Message-ID: <alpine.DEB.2.00.0905071258330.14214@ybpnyubfg.ybpnyqbznva>
References: <alpine.LRH.1.10.0901161548460.28478@pub2.ifh.de> <alpine.DEB.2.00.0903312017420.10133@ybpnyubfg.ybpnyqbznva> <49F3468C.4070101@ventoso.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, 25 Apr 2009, Luca Olivetti wrote:

> > The above observations are so far, just observations, and I
> > don't expect anyone to be able to `fix' anything
> 
> They're nevertheless interesting, since I'm in a similar position: my vdr
> machine is using (almost flawlessly) a Skystar 2 (though I don't believe in
> this new fangled disecq thing and I use an old fashioned actuator to move my
> dish) and it's running a 2.6.17 kernel.

Rule number one -- never upgrade a working system ;-)
Actually, it seems to be a tradeoff -- some things get fixed,
or start working, work better, and a roughly equal number of
things break.  Make sure you can trivially revert to your
known working system, or else bite the bullet, spend time
figuring out what's broken, patch, hack, patch again, before
giving up and reverting your system...

If you don't use DiSEqC to switch between different LNBs, you
may well not have a problem.  My observations have been that
I'd had little to no difficulty with services at position 1/4,
which would be tuned by a device not supporting, or not set up
to use DiSEqC switching.


> I'll probably have to update one day (especially if I want to keep up with the
> "latest and greatest" vdr), but I'm not really in a hurry, even less so seeing
> your problems.

Rather than immediately replace this card with a DVB-S2-able
device that tunes better the frequency extremes, I decided to
pull it out and experiment a bit more, in a different box.
My observations:
 ============


Here's some more info, in case it would be of interest...

I'd suffered interrupt and other problems with the test server
I'm building, having tried the SkyStar2 2.6D card in it without
major success -- apart from most transponders on position 1/4.

Generally I'd have about a 1 in 10 to maybe 1 out of 5 chance
of success when tuning the BBC radios on position 3/4 -- usually
it would appear to lock to the ZDF transponder at position 3/4.

Attempts to tune a particular transponder at 2/4 and at 4/4
would fail around 100% of the time.

Usually my first attempt after a reboot would tune successfully.

While operating, the machine somehow got in a state where the
USB ports were no longer working completely right.  Interestingly
at this time, I'd be able to tune the SkyStar and get about a
50% success rate or better when tuning 2/4 and 3/4.  Also, one
higher-frequency transponder at 1/4 which would result in a TS
with errors (and thus errors in the radio stream audio) then
tuned cleanly.

So I decided to strip as much out of the machine as possible
and play a nice round of musical PCI-slots, in case there might
be a magical slot where it would work, or where I would not
be sharing the IRQ with anything.

Unfortunately, none of the four freed slots worked with the
SkyStar perfectly.  Three of them were shown by /proc/interrupts
as sharing an IRQ; the one which did not, was shown to be sharing
the IRQ, with `lspci'.

Now, I did confirm one thing -- after each reboot, all my first
tuning attempts, regardless of position 4/4, 3/4, 2/4, or 1/4,
were always successful.  This using `dvbstream'.  Any following
attempts to repeat that tuning, or tune elsewhere, failed or
had a negligible success rate, except for position 1/4.  This
appears to be the case both for cold boots from poweroff and
for warm reboots.  It doesn't appear to affect the case of the
weak radio stream, which may be near the card's weakened
sensitivity limit (it's become this way over time, it seems),
that could vary in strength during the day.

An attempt to `scan' the transponders at 3/4 got far more of
the 1/4 transponders, and failed more than not with active 3/4
frequencies.  If there's any pattern, it could be that the
successful transponders were largely vertical, with horizontal
polarised transponders rarely tuning.  The same cable feeding
a couple external USB boxen delivered clean signals on all
tuning attempts.


Probably I do need to bisect my way from 2.6.26-ish back to
2.6.14-ish to determine where things went boom.


However, I've observed that a second PCI DVB-T card (BT878-
based) has not only failed to deliver a clean signal, but has
also resulted in normally-clean signals from USB devices
becoming similarly corrupted every minute or so, so that card
will also suffer the musical-PCI-slot treatment to see if it's
an IRQ problem.

And if I motivate myself, I'll see about trying the SkyStar
in the two used slots, or trying to give it a truly-free IRQ.
By which time I'll probably have become insane trying to keep
track of which cards get which IRQs in which slots.

Man, sometimes I wish PC hardware weren't so illogical, or
that the logic were to be clearer...



Preliminary results of juggling BT878-DVB-T card -- if it is
sharing its IRQ with either my EHCI card (NEC, IRQ10), or
the sound card (CMIPCI, IRQ7) at boot, the machine will lock
up solid.  Presumably an interrupt storm, or something, as I
know little about such.  Otherwise it appears to work fine,
though with a few cards still missing.  Experimentation continues.
The corrupted streams I observed earlier haven't repeated.

Unfortunately, after quite some time, one USB device goes
wacky, some others continue to work, but no USB plug events
are recognised, `lsusb' hangs, and looks like time to reboot.  
Grrr.

barry bouwsma
