Return-path: <mchehab@pedra>
Received: from mail-in-01.arcor-online.net ([151.189.21.41]:32996 "EHLO
	mail-in-01.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755076Ab1CRB6e (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 17 Mar 2011 21:58:34 -0400
Subject: Re: [linux-dvb] Problem with saa7134: Asus Tiger revision 1.0,
	subsys 1043:4857
From: hermann pitton <hermann-pitton@arcor.de>
To: linux-media@vger.kernel.org
Cc: linux-dvb@linuxtv.org
In-Reply-To: <AANLkTikV3LW5JZdUMjctretv8_ZWN6YFhhfwzDo8NzbW@mail.gmail.com>
References: <AANLkTikV3LW5JZdUMjctretv8_ZWN6YFhhfwzDo8NzbW@mail.gmail.com>
Content-Type: text/plain
Date: Fri, 18 Mar 2011 02:49:06 +0100
Message-Id: <1300412946.9136.18.camel@pc07.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Jason,

Am Samstag, den 12.03.2011, 10:43 +1100 schrieb Jason Hecker:
> I just bought a pair of what are a version of the My Cinema 7131
> Hybrid cards.
> 
> The kernel reports it as saa7134: Asus Tiger revision 1.0, subsys
> 1043:4857 
> 
> I did inititially try Mythbuntu 10.04 but the firmware upload seemed
> to fail fairly consistently.  Restarting with v10.10 the firmware
> loads but I can't seem to scan the channels with Mythbackend - it has
> a 0% signal and 100% signal to noise.  I am using MythTV 0.24 with
> Avenard's latest patches.
> 
> This version of the card has written on the silkscreen Tiger rev 3.02,
> a sticker that says Tiger_8M AA.F7.C0.01 (which would appear to be the
> latest firmware for this card on Asus's support site) but there is
> only one RF connector on CON1.  CON2 is not fitted nor is the IR
> receiver.  Now I saw mentioned on a list that to get DVB working on
> this card in Linux you need to connect the TV antenna to the FM port,
> which I suspect is the one not fitted.  The latest Windows drivers for
> this card is circa 2009.
> 
> Two questions:
> - Is there some sort of SAA7134 module argument I need to use to get
> the card working on the TV RF input?
> - Why does the kernel show the firmware is being reloaded every time
> MythTV seems to want to talk to the card?  This slows down access as
> it seems to take about 30 seconds for the firmware to install each
> time.
> 
> I am happy to provide whatever debug dumps or more info if need be.
> 

this hits me only by accident, reading through backlash, but I added
that Asus Tiger Revision 1.0 with subsys 1043:4857, with a huge delay
only. (approximately 1 1/2 years)

The development and testing for the new tuner types was done only much
later on freely available stuff, a so called Asus Dual _non_ OEM
variant.

Not to tell what we did all see thereafter, but that all was at least,
with only one exception, valid using the PCI subsystem as unique
identifier.

Luckily, as far as I can see, we have only a fictional radio device on
your "new" variant left over.

This can still be very annoying, but won't do any harm, except wasting a
users time, bad enough, but at least not any radiation from that sort of
radio flaw.

Since the PCI subsystem is identical with mine, still around somewhere,
with radio support, either take that dead radio device for now or a last
chance is to discover, if any eeprom differences are there to eventually
filter that minor, but unpleasant shortcoming for those trying in vain
on the radio.

Cheers,
Hermann

To restore the power on a failing power plant in urgent need of it seems
to be a good idea, after six or seven days ...

All my excuses for the failing radio device on that not yet seen OEM
stuff, but I can ensure, to piss on it doesn't help any further.

Hopefully it does help in that other case.





