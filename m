Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-17.arcor-online.net ([151.189.21.57]:60172 "EHLO
	mail-in-17.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932572AbZKYAIm (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 24 Nov 2009 19:08:42 -0500
Subject: Re: Compile error saa7134 - compro videomate S350
From: hermann pitton <hermann-pitton@arcor.de>
To: Dominic Fernandes <dalf198@yahoo.com>
Cc: linux-media@vger.kernel.org
In-Reply-To: <990417.69725.qm@web110607.mail.gq1.yahoo.com>
References: <754577.88092.qm@web110614.mail.gq1.yahoo.com>
	 <1259025174.5511.24.camel@pc07.localdom.local>
	 <990417.69725.qm@web110607.mail.gq1.yahoo.com>
Content-Type: text/plain
Date: Wed, 25 Nov 2009 01:08:18 +0100
Message-Id: <1259107698.2535.10.camel@localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Dominic,

Am Dienstag, den 24.11.2009, 10:01 -0800 schrieb Dominic Fernandes:
> Hi Hermann,
> 
> Thanks for responding. I managed to do the compile and install this time without errors on a fresh copy of the v4l-dvb drivers.

Good. On a short look.
 
> However, from the thread (link) it said  Changing the PCI Vendor
> ID to 0x7133 in the S350 patch, - which file and location would specify this?

That won't work, since the T750 has already the same PCI subsystem with
some saa7133. (can be saa7133, 7135 or saa7131e, no way to detect)

Also Jan declared for sure to have a saa7130. Detection is correct so
far, but now we must either kick out the T750 or try with some eeprom
detection. Known problem for Compro, we try to guess on tuner types
then, but I don't like it much and they should care themselves or
provide the eeprom tables for card types..

> At the moment the dvb-s card is recognised as the compro T750 card (I made the other mod of changing the gpio to xc000 in saa7134-cards):

Can't tell much without any such device, but if OK, to force card=169
should work then for you with that change?

In that case, we still would create a new card entry for your saa7135
device.

Cheers,
Hermann

>    6.008121] saa7130/34: v4l2 driver version 0.2.15 loaded
> [    6.008173] saa7134 0000:03:01.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
> [    6.008180] saa7133[0]: found at 0000:03:01.0, rev: 209, irq: 17, latency: 64, mmio: 0xcfcff000
> [    6.008186] saa7133[0]: subsystem: 185b:c900, board: Compro VideoMate T750 [card=139,autodetected]
> [    6.008200] saa7133[0]: board init: gpio is 843f00
> [    6.008205] IRQ 17/saa7133[0]: IRQF_DISABLED is not guaranteed on shared IRQs
> [    6.160030] saa7133[0]: i2c eeprom 00: 5b 18 00 c9 54 20 1c 00 43 43 a9 1c 55 d2 b2 92
> [    6.160052] saa7133[0]: i2c eeprom 10: 00 ff 86 0f ff 20 ff ff ff ff ff ff ff ff ff ff
> [    6.160071] saa7133[0]: i2c eeprom 20: 01 40 01 02 02 01 03 01 08 ff 00 87 ff ff ff ff
> [    6.160091] saa7133[0]: i2c eeprom 30: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> [    6.160109] saa7133[0]: i2c eeprom 40: ff d6 00 c0 86 1c 02 01 02 ff ff ff ff ff ff ff
> [    6.160133] saa7133[0]: i2c eeprom 50: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff cb
> [    6.160144] saa7133[0]: i2c eeprom 60: 35 ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> [    6.160156] saa7133[0]: i2c eeprom 70: 00 00 00 01 4e c1 ff ff ff ff ff ff ff ff ff ff
> [    6.160167] saa7133[0]: i2c eeprom 80: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> [    6.160178] saa7133[0]: i2c eeprom 90: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> [    6.160190] saa7133[0]: i2c eeprom a0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> [    6.160201] saa7133[0]: i2c eeprom b0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> [    6.160212] saa7133[0]: i2c eeprom c0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> [    6.160223] saa7133[0]: i2c eeprom d0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> [    6.160235] saa7133[0]: i2c eeprom e0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> [    6.160246] saa7133[0]: i2c eeprom f0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> [    6.313949] saa7133[0]: registered device video0 [v4l2]
> [    6.313978] saa7133[0]: registered device vbi0
> [    6.314003] saa7133[0]: registered device radio0
> 
> thanks,
> Dominic
> 
> 
> 
> 
> 
> ----- Original Message ----
> From: hermann pitton <hermann-pitton@arcor.de>
> To: Dominic Fernandes <dalf198@yahoo.com>
> Cc: linux-media@vger.kernel.org
> Sent: Tue, November 24, 2009 1:12:54 AM
> Subject: Re: Compile error saa7134 - compro videomate S350
> 
> Hi Dominic,
> 
> Am Montag, den 23.11.2009, 10:01 -0800 schrieb Dominic Fernandes:
> > Hi,
> > 
> > I need help to compile v4l-dvb drivers for saa7134 modules. 
> > I'm new to v4l-dvb not sure how to get past the errors concerning
> > undefined declarations found in saa7134-inputs.c file for the videomate
> > S350 board, saying ir_codes, mask_keycodes, mask_keydown as undeclared:
> > 
> > snip:-
> > 
> > make[2]: Entering directory `/usr/src/linux-headers-2.6.31-14-generic'
> >   CC [M]  /home/tvbox/v4l-dvb/v4l/saa7134-input.o
> > /home/tvbox/v4l-dvb/v4l/saa7134-input.c: In function 'build_key':
> > /home/tvbox/v4l-dvb/v4l/saa7134-input.c:90: error: 'ir_codes' undeclared (first use in this function)
> > /home/tvbox/v4l-dvb/v4l/saa7134-input.c:90: error: (Each undeclared identifier is reported only once
> > /home/tvbox/v4l-dvb/v4l/saa7134-input.c:90: error: for each function it appears in.)
> > /home/tvbox/v4l-dvb/v4l/saa7134-input.c:90: error: 'ir_codes_videomate_s350' undeclared (first use in this function)
> > /home/tvbox/v4l-dvb/v4l/saa7134-input.c:91: error: 'mask_keycode' undeclared (first use in this function)
> > /home/tvbox/v4l-dvb/v4l/saa7134-input.c:92: error: 'mask_keydown' undeclared (first use in this function)
> > make[3]: *** [/home/tvbox/v4l-dvb/v4l/saa7134-input.o] Error 1
> > make[2]: *** [_module_/home/tvbox/v4l-dvb/v4l] Error 2
> > make[2]: Leaving directory `/usr/src/linux-headers-2.6.31-14-generic'
> > make[1]: *** [default] Error 2
> > make[1]: Leaving directory `/home/tvbox/v4l-dvb/v4l'
> > make: *** [all] Error 2
> > 
> > background:
> > Justbought last week a new compro videomate s350 (dvb-s) card after seeing
> > some positive feedback on forumes saying it is working.  But the card I
> > got has a newer chip set incorporating a saa7135 device and after some
> > searching found someone else also had the same issue back in June but
> > managed to fix it with a few changes.  I trying to re-produce the
> > actions (see link below) and re-build the drivers but I'm stuck at the
> > compile stage (make all). 
> > 
> > http://osdir.com/ml/linux-media/2009-06/msg01256.html
> > 
> > Can someone advise me on how get past the make error?
> > 
> > Thanks,
> > Dominic
> > 
> 
> hm, likely you are on some older/other stuff.
> 
> Igor had some merge conflict previously for the S350.
> 
> Can't see it with current linuxtv.org mercurial v4l-dvb.
> 
> Please try with that.
> 
> Cheers,
> Hermann


