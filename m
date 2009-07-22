Return-path: <linux-media-owner@vger.kernel.org>
Received: from main.gmane.org ([80.91.229.2]:45443 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753730AbZGVMlX (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 22 Jul 2009 08:41:23 -0400
Received: from list by ciao.gmane.org with local (Exim 4.43)
	id 1MTb8I-0006lO-DQ
	for linux-media@vger.kernel.org; Wed, 22 Jul 2009 12:41:18 +0000
Received: from host-78-14-98-178.cust-adsl.tiscali.it ([78.14.98.178])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Wed, 22 Jul 2009 12:41:18 +0000
Received: from avljawrowski by host-78-14-98-178.cust-adsl.tiscali.it with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Wed, 22 Jul 2009 12:41:18 +0000
To: linux-media@vger.kernel.org
From: Avl Jawrowski <avljawrowski@gmail.com>
Subject: Re: Problems with Pinnacle 310i (saa7134) and recent kernels
Date: Wed, 22 Jul 2009 12:41:03 +0000 (UTC)
Message-ID: <loom.20090722T123703-889@post.gmane.org>
References: <loom.20090718T135733-267@post.gmane.org>  <1248033581.3667.40.camel@pc07.localdom.local>  <loom.20090720T224156-477@post.gmane.org> <1248146456.3239.6.camel@pc07.localdom.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

hermann pitton <hermann-pitton <at> arcor.de> writes:

> there is no excuse for getting errors on linux ;)
> 
> Where you got this card from and did it ever work on the same machine
> with m$ stuff?

I don't have m$ stuff.

> Clean up your module mess, read again, and if the eeprom has still
> nothing to tell than 1 for all, get rid of it.

The errors were caused by a statically compiled v4l module.
However the patch seems makes no difference. Maybe it make working
the EPG but I haven't test it enough because the card works occasionally.

Is the eeprom so important? With a certain kernel configuration (all modules
compiled) gives no errors but only "f"s:

Linux video capture interface: v2.00
saa7130/34: v4l2 driver version 0.2.15 loaded
saa7134 0000:01:01.0: PCI INT A -> GSI 21 (level, low) -> IRQ 21
saa7133[0]: found at 0000:01:01.0, rev: 209, irq: 21, latency: 32, mmio:
0xcfddf800
saa7133[0]: subsystem: ffff:ffff, board: Pinnacle PCTV 310i [card=101,insmod
option]
saa7133[0]: board init: gpio is 600e000
IRQ 21/saa7133[0]: IRQF_DISABLED is not guaranteed on shared IRQs
saa7133[0]: i2c eeprom 00: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom 10: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom 20: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom 30: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom 40: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom 50: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom 60: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom 70: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom 80: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom 90: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom a0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom b0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom c0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom d0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom e0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom f0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
tuner 1-004b: chip found @ 0x96 (saa7133[0])
tda829x 1-004b: setting tuner address to 61
tda829x 1-004b: type set to tda8290+75a
saa7133[0]: registered device video0 [v4l2]
saa7133[0]: registered device vbi0
saa7133[0]: registered device radio0
dvb_init() allocating 1 frontend
DVB: registering new adapter (saa7133[0])
DVB: registering adapter 0 frontend 0 (Philips TDA10046H DVB-T)...
tda1004x: setting up plls for 48MHz sampling clock
tda1004x: found firmware revision 29 -- ok
saa7134 ALSA driver for DMA sound loaded
IRQ 21/saa7133[0]: IRQF_DISABLED is not guaranteed on shared IRQs
saa7133[0]/alsa: saa7133[0] at 0xcfddf800 irq 21 registered as card -1

But now the card don't works not even with Kaffeine:

/dev/dvb/adapter0/frontend0 : opened ( Philips TDA10046H DVB-T ) (0ms)
0 EPG plugins loaded for device 0:0.
Loaded epg data : 0 events (0 msecs)
DvbCam::probe(): /dev/dvb/adapter0/ca0: : No such file or directory
Using DVB device 0:0 "Philips TDA10046H DVB-T"
Not able to lock to the signal on the given frequency
Frontend closed
Tuning delay: 1701 ms

I think the occasional nonfunctional are caused by this error:

IRQ 21/saa7133[0]: IRQF_DISABLED is not guaranteed on shared IRQs

Is it possible?

The option disable_ir=1 has no effect. Changing PCI slot makes no difference.
Anyway with w_scan and Kaffeine in normal conditions the tuner works almost
always.

> Cheers,
> Hermann

Thank you!


