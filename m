Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-07.arcor-online.net ([151.189.21.47]:52550 "EHLO
	mail-in-07.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751583AbZGWIr1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 23 Jul 2009 04:47:27 -0400
Subject: Re: Problems with Pinnacle 310i (saa7134) and recent kernels
From: hermann pitton <hermann-pitton@arcor.de>
To: Avl Jawrowski <avljawrowski@gmail.com>
Cc: linux-media@vger.kernel.org
In-Reply-To: <loom.20090722T123703-889@post.gmane.org>
References: <loom.20090718T135733-267@post.gmane.org>
	 <1248033581.3667.40.camel@pc07.localdom.local>
	 <loom.20090720T224156-477@post.gmane.org>
	 <1248146456.3239.6.camel@pc07.localdom.local>
	 <loom.20090722T123703-889@post.gmane.org>
Content-Type: text/plain
Date: Thu, 23 Jul 2009 10:40:30 +0200
Message-Id: <1248338430.3206.34.camel@pc07.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

Am Mittwoch, den 22.07.2009, 12:41 +0000 schrieb Avl Jawrowski:
> Hi,
> 
> hermann pitton <hermann-pitton <at> arcor.de> writes:
> 
> > there is no excuse for getting errors on linux ;)
> > 
> > Where you got this card from and did it ever work on the same machine
> > with m$ stuff?
> 
> I don't have m$ stuff.

also fine. We can exclude the eeprom was messed up by windows toys.

> > Clean up your module mess, read again, and if the eeprom has still
> > nothing to tell than 1 for all, get rid of it.
> 
> The errors were caused by a statically compiled v4l module.
> However the patch seems makes no difference. Maybe it make working
> the EPG but I haven't test it enough because the card works occasionally.

As said, 2.6.25 is reported working fine without LNA or other issues.
If that doesn't work, there are issues with your card itself or other
hardware environment involved.

> Is the eeprom so important? With a certain kernel configuration (all modules
> compiled) gives no errors but only "f"s:

The eeprom content is not important on that card at all, except for auto
detection, but flaky eeprom read outs likely indicate more and other
hardware trouble.

If it seems to deliver stable results now, you can even try to re-flash
it with rewrite_eeprom.pl in v4l2-apps/util. Read the instructions on
top of it. 

> Linux video capture interface: v2.00
> saa7130/34: v4l2 driver version 0.2.15 loaded
> saa7134 0000:01:01.0: PCI INT A -> GSI 21 (level, low) -> IRQ 21
> saa7133[0]: found at 0000:01:01.0, rev: 209, irq: 21, latency: 32, mmio:
> 0xcfddf800
> saa7133[0]: subsystem: ffff:ffff, board: Pinnacle PCTV 310i [card=101,insmod
> option]
> saa7133[0]: board init: gpio is 600e000
> IRQ 21/saa7133[0]: IRQF_DISABLED is not guaranteed on shared IRQs
> saa7133[0]: i2c eeprom 00: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> saa7133[0]: i2c eeprom 10: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> saa7133[0]: i2c eeprom 20: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> saa7133[0]: i2c eeprom 30: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> saa7133[0]: i2c eeprom 40: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> saa7133[0]: i2c eeprom 50: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> saa7133[0]: i2c eeprom 60: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> saa7133[0]: i2c eeprom 70: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> saa7133[0]: i2c eeprom 80: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> saa7133[0]: i2c eeprom 90: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> saa7133[0]: i2c eeprom a0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> saa7133[0]: i2c eeprom b0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> saa7133[0]: i2c eeprom c0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> saa7133[0]: i2c eeprom d0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> saa7133[0]: i2c eeprom e0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> saa7133[0]: i2c eeprom f0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> tuner 1-004b: chip found @ 0x96 (saa7133[0])
> tda829x 1-004b: setting tuner address to 61
> tda829x 1-004b: type set to tda8290+75a
> saa7133[0]: registered device video0 [v4l2]
> saa7133[0]: registered device vbi0
> saa7133[0]: registered device radio0
> dvb_init() allocating 1 frontend
> DVB: registering new adapter (saa7133[0])
> DVB: registering adapter 0 frontend 0 (Philips TDA10046H DVB-T)...
> tda1004x: setting up plls for 48MHz sampling clock
> tda1004x: found firmware revision 29 -- ok
> saa7134 ALSA driver for DMA sound loaded
> IRQ 21/saa7133[0]: IRQF_DISABLED is not guaranteed on shared IRQs
> saa7133[0]/alsa: saa7133[0] at 0xcfddf800 irq 21 registered as card -1
> 
> But now the card don't works not even with Kaffeine:

Hm, with the patch on current v4l-dvb and 2.6.30 something? On 2.6.25
current v4l-dvb won't compile anymore and you should try that kernel
without any changes.

> /dev/dvb/adapter0/frontend0 : opened ( Philips TDA10046H DVB-T ) (0ms)
> 0 EPG plugins loaded for device 0:0.
> Loaded epg data : 0 events (0 msecs)
> DvbCam::probe(): /dev/dvb/adapter0/ca0: : No such file or directory
> Using DVB device 0:0 "Philips TDA10046H DVB-T"
> Not able to lock to the signal on the given frequency
> Frontend closed
> Tuning delay: 1701 ms

Also increase tuning delay to 5000 ms and check for different signal and
SNR values. In that mentioned "2.6.26 regression ..." thread analog TV
functionality was fully restored by a similar hack, but also lots of
changes to the drivers since 2.6.25.  

> I think the occasional nonfunctional are caused by this error:
> 
> IRQ 21/saa7133[0]: IRQF_DISABLED is not guaranteed on shared IRQs
> 
> Is it possible?

We see that hint on almost all drivers since 2.6.29 and not using that
IRQ flag anymore did not make any difference so far, for what I can
tell.

> The option disable_ir=1 has no effect. Changing PCI slot makes no difference.
> Anyway with w_scan and Kaffeine in normal conditions the tuner works almost
> always.

Thanks for your reports and sorry for not having a final conclusion yet.

Cheers,
Hermann



