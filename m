Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-02.arcor-online.net ([151.189.21.42]:38982 "EHLO
	mail-in-02.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752904AbZHTCqP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 19 Aug 2009 22:46:15 -0400
Subject: Re: [linux-dvb] au0828: experimental support for Syntek Teledongle
	[05e1:0400]
From: hermann pitton <hermann-pitton@arcor.de>
To: linux-media@vger.kernel.org, Johannes Stezenbach <js@linuxtv.org>
Cc: linux-dvb@linuxtv.org, Michael Krufky <mkrufky@kernellabs.com>
In-Reply-To: <829197380908180707r3aba262fie192090c653c42be@mail.gmail.com>
References: <bc18792f0908171325s391d9e36nb0ce20f40017678@mail.gmail.com>
	 <37219a840908171359m152363a2ub377abe6e27ff237@mail.gmail.com>
	 <20090818110041.GA14710@linuxtv.org>
	 <829197380908180707r3aba262fie192090c653c42be@mail.gmail.com>
Content-Type: text/plain
Date: Thu, 20 Aug 2009 04:38:16 +0200
Message-Id: <1250735896.3259.9.camel@pc07.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Am Dienstag, den 18.08.2009, 10:07 -0400 schrieb Devin Heitmueller:
> On Tue, Aug 18, 2009 at 7:00 AM, Johannes Stezenbach<js@linuxtv.org> wrote:
> > I would be interested to know if someone _actually_ managed
> > to break their hardware by using buggy drivers.
> 
> The short answer is *absolutely*.
> 
> /me takes off "driver developer hat" and puts on "hardware developer hat"
> 
> In a world of flash, eeproms, and software programmable clocks, there
> are all sorts of ways where a driver bug can damage the hardware.
> Looking for some simple examples?
> 
> 1.  Think of the "overclocking" community and what happens when they
> reconfigure a GPU's software controlled clock to perform beyond its
> maximum expected rating without extra cooling.
> 
> 2.  Think of all the reports of corrupted eeproms you read about on
> the mailing list.  Sure, in many cases a good developer can hack a way
> to reprogram the eeprom in software, but in many cases the board won't
> even come up, so you end up with an RMA.  It's not "damaged" in the
> more traditional sense, but the net effect is the same - the board is
> rendered inoperable and has to be sent back to the manufacturer.
> 
> 3.  Try loading the xc3028 tuner firmware onto the low power version
> of the chip (xc3028l).  It took me a minute before I realized the
> smell of burning plastic was coming from my tuner.
> 
> Don't get me wrong, in many cases things can be designed into the
> hardware to mitigate the effects of software bugs.  In any hardware
> design, your goal is to minimize the return rate, so you build
> failsafes for the most likely to occur problems.  However, in many
> cases this adds additional cost to the BOM, and you make educated
> decisions about the probability of certain classes of failure and
> instead build the reliability into the driver instead (making sure
> that the Windows driver can *never* put the hardware into a state).  A
> random open source developer doesn't know what these sorts of
> decisions were, and would not be able to replicate the corresponding
> checks in a Linux driver.
> 
> 4.  Ever see a user complaint of how a tuner runs "hot" under Linux
> compared to the same device running under Windows?  Almost certainly
> an improperly GPIO configuration which resulted in a condition such as
> having the digital demod powered on at the same time as the analog
> decoder.  Sure, it will work for a while but you're running the device
> outside of the expected thermal profile and shortening the life of the
> hardware.
> 
> The above are just a few *simple* examples.  The nastier ones are
> often too difficult to explain in less than fifty words.
> 
> > IANAL but
> > I think that consumer electronics hardware which can be damaged by
> > software is broken by design.  A vendor selling such hardware is
> > stupid because people would return the broken hardware and get
> > a replacement.  I don't see how a vendor could proof that the device
> > was not damaged by an obscure bug in the Windows driver to get
> > around their responsibility to replace broken hardware within
> > the warranty period.
> 
> Yeah, you're right.  Usually they cannot tell right away and will
> perform an RMA.  And the board will end up on a lab bench with a
> hardware engineering isolating which component failed, and then
> working with the driver developer trying to figure out how the hell
> their Windows driver put the board in such a state.  The risk of
> trusting some random Linux developer's driver work is a reason why
> some vendors don't want to support Linux.  If I were a vendor, and I
> endorsed a Linux driver written by someone without the appropriate
> knowledge of the hardware, I could end up with large number of product
> returns, and I would incur the cost of those losses.
> 
> Also, in many cases the board doesn't burn out immediately.  But
> because of crappy drivers it takes three or four months to burn out,
> and the result is a board that is designed to run without problems for
> tens of thousands of hours dies in a significantly shorter time.
> 
> Good device driver developers realize and accept this risk whenever
> they attempt to write a reverse engineered driver.   I certainly don't
> want to discourage people from learning how to write Linux drivers for
> tuners, but caveat emptor - you can end up permanently damaging your
> hardware.
> 
> Devin
> 

Hi,

again, both can be right.

I don't deny the smell you had, what a crap on the other hand.

But Johannes is right too. I did not manage to burn a single Philips
device during the last seven years.

And i did all the worst every single day ;)

So, there might be still a slight difference ...

Cheers,
Hermann





