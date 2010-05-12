Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-18.arcor-online.net ([151.189.21.58]:40243 "EHLO
	mail-in-18.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752879Ab0ELJKW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 12 May 2010 05:10:22 -0400
Subject: Re: Remote control at Zolid Hybrid TV Tuner
From: hermann pitton <hermann-pitton@arcor.de>
To: Sander Pientka <cumulus0007@gmail.com>
Cc: linux-media@vger.kernel.org
In-Reply-To: <AANLkTin6b9JT1j0iNBmrp0UIhN9Z2Y-V6xdrEy7g5NQb@mail.gmail.com>
References: <db09c9681002161116k52278916ob68884ddc989044@mail.gmail.com>
	 <1266375385.3176.5.camel@pc07.localdom.local>
	 <db09c9681002170838tdb15cbbu67cd45a518c11b4b@mail.gmail.com>
	 <1266445236.7202.17.camel@pc07.localdom.local>
	 <AANLkTin6b9JT1j0iNBmrp0UIhN9Z2Y-V6xdrEy7g5NQb@mail.gmail.com>
Content-Type: text/plain
Date: Wed, 12 May 2010 11:02:33 +0200
Message-Id: <1273654953.3195.15.camel@pc07.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sander,

Am Samstag, den 08.05.2010, 16:12 +0200 schrieb Sander Pientka:
> Hi Hermann,
> 
> I am going to revive this old thread, I completely forgot about it and
> I still want to solve this problem.
> 
> Yes, with the IR transmitter not plugged in, the gpio is reported as
> 00000 by dmesg.
> 
> I am aware there is a picture of the backside missing on the wiki, I
> will try to make one a.s.a.p.
> 
> NEC IR support seems to be built-in already: drivers/media/IR/ir-nec-decoder.c.
> 
> Besides, dmesg outputs a section of error messages I don't understand:
> 
> [ 1585.548221] tda18271_write_regs: ERROR: idx = 0x5, len = 1,
> i2c_transfer returned: -5
> [ 1585.548229] tda18271_toggle_output: error -5 on line 47
> [ 1585.720118] tda18271_write_regs: ERROR: idx = 0x5, len = 1,
> i2c_transfer returned: -5
> [ 1585.720129] tda18271_init: error -5 on line 826
> [ 1585.720136] tda18271_tune: error -5 on line 904
> [ 1585.720141] tda18271_set_analog_params: error -5 on line 1041
> [ 1586.381026] tda18271_write_regs: ERROR: idx = 0x6, len = 1,
> i2c_transfer returned: -5
> [ 1586.500589] tda18271_write_regs: ERROR: idx = 0x1d, len = 1,
> i2c_transfer returned: -5
> [ 1586.629447] tda18271_write_regs: ERROR: idx = 0x10, len = 1,
> i2c_transfer returned: -5
> [ 1586.629458] tda18271_channel_configuration: error -5 on line 160
> [ 1586.629465] tda18271_set_analog_params: error -5 on line 1041
> 
> 
> Do you have any idea about the origin of these errors? Do you think
> they affect the IR functionality?
> 

you are still welcome with such delayed reports.

But I don't have any influence anymore, how such are treated.

For the tda18271 stuff, you must be on latest and Michael Krufky should
take it on.

For to be on latest, I also can't give any advice anymore.

For the IR/remote stuff, try with Mauro and all others working through.

Cheers,
Hermann

> --
> 
> Sander Pientka
> 
> 2010/2/17 hermann pitton <hermann-pitton@arcor.de>:
> > Hi,
> >
> > Am Mittwoch, den 17.02.2010, 17:38 +0100 schrieb Sander Pientka:
> >> Thanks for your answer. If I understand you correctly, I should
> >> disattach the IR receiver, which is a cable with a diode at the end?
> >> It is plugged in to a port like the green one for audio.
> >
> > did you remove the copy to the list by will?
> >
> > Then I will not complain about top posting here ;)
> >
> > I think we have only a photo of the frontside of that card.
> >
> > One line from the IR input connector vanishes to the backside.
> >
> > If on the backside is not a dedicated IR controller chip, gpio18 might
> > be in use for the remote. This gpio is capable of triggering IRQs and is
> > also connected to the clock.
> >
> > On recent Asus saa713x cards it is used for some RC5 protocol derived
> > from those IRQs, gpio18 is the up/down button and the only changing gpio
> > pin concerning the remote. That pin goes low, if the receiver is not
> > plugged on the Asus cards.
> >
> > Mauro recently added also support for NEC IR protocol also on that gpio.
> >
> > You should be able to track rc5 and nec support from the mercurial/cvs
> > interface or from the lists. Maybe it gets you started.
> >
> > Cheers,
> > Hermann
> >
> >> 2010/2/17 hermann pitton <hermann-pitton@arcor.de>:
> >> > Hi Sander,
> >> >
> >> > Am Dienstag, den 16.02.2010, 20:16 +0100 schrieb Sander Pientka:
> >> >> Hi,
> >> >>
> >> >> my Zolid Hybrid TV Tuner has been working like a charm for over two
> >> >> months now. The remote control is not working though, which is a
> >> >> showstopper. I don't have experience with remote controls in any kind,
> >> >> I've heard of LIRC but I would rather choose a more elegant solution,
> >> >> for instance evdev in X11.
> >> >>
> >> >> It's wiki page: http://www.linuxtv.org/wiki/index.php/Zolid_Hybrid_TV_Tuner
> >> >
> >> > gpio init of your board is reported as 0x240000.
> >> >
> >> > So gpio18/0x40000 is high.
> >> >
> >> > Assuming the IR receiver is plugged during that, unplug it on next boot
> >> > and see if gpio init is now only 0x200000.
> >> >
> >> > Cheers,
> >> > Hermann
> >> >
> >> >
> >> >
> >
> >

