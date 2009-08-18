Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yw0-f173.google.com ([209.85.211.173]:38424 "EHLO
	mail-yw0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759159AbZHROHE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 18 Aug 2009 10:07:04 -0400
Received: by ywh3 with SMTP id 3so5174121ywh.22
        for <linux-media@vger.kernel.org>; Tue, 18 Aug 2009 07:07:05 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20090818110041.GA14710@linuxtv.org>
References: <bc18792f0908171325s391d9e36nb0ce20f40017678@mail.gmail.com>
	 <37219a840908171359m152363a2ub377abe6e27ff237@mail.gmail.com>
	 <20090818110041.GA14710@linuxtv.org>
Date: Tue, 18 Aug 2009 10:07:04 -0400
Message-ID: <829197380908180707r3aba262fie192090c653c42be@mail.gmail.com>
Subject: Re: [linux-dvb] au0828: experimental support for Syntek Teledongle
	[05e1:0400]
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: linux-media@vger.kernel.org
Cc: Michael Krufky <mkrufky@kernellabs.com>, linux-dvb@linuxtv.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Aug 18, 2009 at 7:00 AM, Johannes Stezenbach<js@linuxtv.org> wrote:
> I would be interested to know if someone _actually_ managed
> to break their hardware by using buggy drivers.

The short answer is *absolutely*.

/me takes off "driver developer hat" and puts on "hardware developer hat"

In a world of flash, eeproms, and software programmable clocks, there
are all sorts of ways where a driver bug can damage the hardware.
Looking for some simple examples?

1.  Think of the "overclocking" community and what happens when they
reconfigure a GPU's software controlled clock to perform beyond its
maximum expected rating without extra cooling.

2.  Think of all the reports of corrupted eeproms you read about on
the mailing list.  Sure, in many cases a good developer can hack a way
to reprogram the eeprom in software, but in many cases the board won't
even come up, so you end up with an RMA.  It's not "damaged" in the
more traditional sense, but the net effect is the same - the board is
rendered inoperable and has to be sent back to the manufacturer.

3.  Try loading the xc3028 tuner firmware onto the low power version
of the chip (xc3028l).  It took me a minute before I realized the
smell of burning plastic was coming from my tuner.

Don't get me wrong, in many cases things can be designed into the
hardware to mitigate the effects of software bugs.  In any hardware
design, your goal is to minimize the return rate, so you build
failsafes for the most likely to occur problems.  However, in many
cases this adds additional cost to the BOM, and you make educated
decisions about the probability of certain classes of failure and
instead build the reliability into the driver instead (making sure
that the Windows driver can *never* put the hardware into a state).  A
random open source developer doesn't know what these sorts of
decisions were, and would not be able to replicate the corresponding
checks in a Linux driver.

4.  Ever see a user complaint of how a tuner runs "hot" under Linux
compared to the same device running under Windows?  Almost certainly
an improperly GPIO configuration which resulted in a condition such as
having the digital demod powered on at the same time as the analog
decoder.  Sure, it will work for a while but you're running the device
outside of the expected thermal profile and shortening the life of the
hardware.

The above are just a few *simple* examples.  The nastier ones are
often too difficult to explain in less than fifty words.

> IANAL but
> I think that consumer electronics hardware which can be damaged by
> software is broken by design.  A vendor selling such hardware is
> stupid because people would return the broken hardware and get
> a replacement.  I don't see how a vendor could proof that the device
> was not damaged by an obscure bug in the Windows driver to get
> around their responsibility to replace broken hardware within
> the warranty period.

Yeah, you're right.  Usually they cannot tell right away and will
perform an RMA.  And the board will end up on a lab bench with a
hardware engineering isolating which component failed, and then
working with the driver developer trying to figure out how the hell
their Windows driver put the board in such a state.  The risk of
trusting some random Linux developer's driver work is a reason why
some vendors don't want to support Linux.  If I were a vendor, and I
endorsed a Linux driver written by someone without the appropriate
knowledge of the hardware, I could end up with large number of product
returns, and I would incur the cost of those losses.

Also, in many cases the board doesn't burn out immediately.  But
because of crappy drivers it takes three or four months to burn out,
and the result is a board that is designed to run without problems for
tens of thousands of hours dies in a significantly shorter time.

Good device driver developers realize and accept this risk whenever
they attempt to write a reverse engineered driver.   I certainly don't
want to discourage people from learning how to write Linux drivers for
tuners, but caveat emptor - you can end up permanently damaging your
hardware.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
