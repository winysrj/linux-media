Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-16.arcor-online.net ([151.189.21.56]:42392 "EHLO
	mail-in-16.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753245AbZH1U72 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 28 Aug 2009 16:59:28 -0400
Subject: Re: [PATCH] Add support for RoverMedia TV Link Pro FM v3
From: hermann pitton <hermann-pitton@arcor.de>
To: Eugene Yudin <eugene.yudin@gmail.com>
Cc: linux-media@vger.kernel.org
In-Reply-To: <200908281917.23079.Eugene.Yudin@gmail.com>
References: <200908272104.59221.Eugene.Yudin@gmail.com>
	 <1251420843.3674.3.camel@pc07.localdom.local>
	 <200908281846.01964.Eugene.Yudin@gmail.com>
	 <200908281917.23079.Eugene.Yudin@gmail.com>
Content-Type: text/plain; charset=UTF-8
Date: Fri, 28 Aug 2009 22:49:03 +0200
Message-Id: <1251492543.9277.23.camel@pc07.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Eugene,

Am Freitag, den 28.08.2009, 19:17 +0400 schrieb Eugene Yudin:
> В сообщении от Пятница 28 августа 2009 18:46:01 автор Eugene Yudin написал:
> > Updated patch is at the end of letter. I also checked the auto-detection.
> > It works correctly with this "modprobe.conf":
> > alias char-major-81 videodev
> > alias char-major-81-0 saa7134
> > options saa7134 i2c_scan=1
> 
> Sorry, I'm a little confused. Tuner working great with:
> > alias char-major-81 videodev
> > alias char-major-81-0 saa7134
> > options saa7134 secam=dk
> 
> Dmesg:
> saa7130/34: v4l2 driver version 0.2.15 loaded
> saa7134 0000:01:07.0: PCI INT A -> Link[APC4] -> GSI 19 (level, high) -> IRQ 
> 19
> saa7134[0]: found at 0000:01:07.0, rev: 1, irq: 19, latency: 32, mmio: 
> 0xea000000
> saa7134[0]: subsystem: 19d1:0138, board: RoverMedia TV Link Pro FM 
> [card=170,autodetected]
> saa7134[0]: board init: gpio is 3b000                                                     
> input: saa7134 IR (RoverMedia TV Link  as 
> /devices/pci0000:00/0000:00:08.0/0000:01:07.0/input/input6                                                                                      
> IRQ 19/saa7134[0]: IRQF_DISABLED is not guaranteed on shared IRQs                            
> saa7134[0]: i2c eeprom 00: d1 19 38 01 10 28 ff ff ff ff ff ff ff ff ff ff                   
> saa7134[0]: i2c eeprom 10: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> saa7134[0]: i2c eeprom 20: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> saa7134[0]: i2c eeprom 30: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> saa7134[0]: i2c eeprom 40: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> saa7134[0]: i2c eeprom 50: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> saa7134[0]: i2c eeprom 60: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> saa7134[0]: i2c eeprom 70: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> saa7134[0]: i2c eeprom 80: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> saa7134[0]: i2c eeprom 90: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> saa7134[0]: i2c eeprom a0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> saa7134[0]: i2c eeprom b0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> saa7134[0]: i2c eeprom c0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> saa7134[0]: i2c eeprom d0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> saa7134[0]: i2c eeprom e0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> saa7134[0]: i2c eeprom f0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> saa7134[0]: i2c scan: found device @ 0x86  [tda9887]
> saa7134[0]: i2c scan: found device @ 0xa0  [eeprom]
> saa7134[0]: i2c scan: found device @ 0xc2  [???]
> tuner 2-0043: chip found @ 0x86 (saa7134[0])
> tuner 2-0061: chip found @ 0xc2 (saa7134[0])
> saa7134[0]: registered device video0 [v4l2]
> saa7134[0]: registered device vbi0
> saa7134[0]: registered device radio0
> saa7134 ALSA driver for DMA sound loaded
> IRQ 19/saa7134[0]: IRQF_DISABLED is not guaranteed on shared IRQs
> saa7134[0]/alsa: saa7134[0] at 0xea000000 irq 19 registered as card -1
> 
> It also determined correctly with setting i2c_scan = 1, but seems to be using 
> some other tuner.

hm, because not printing tda9887 and tuner type set?

We use since years tuner=38 for that TCL MFPE05 2, also in tveeprom.c
for those using that.

For me the patch looks OK now, just some details to get it to
"patchwork".

We have already a card=170 meanwhile.
Their are line breakages, please also send it as attachment.
In the auto detection a comment pointing to LR138 REV:I might be
appropriate and one behind the Philips FM1216ME/I H-3 (MK3) mentioning
that TCL tuner. Guess we will see more OEMs with MultiEurope tuners on
the LR138 design in the future and we can use that entry then.

Dmitri Belimov tries to tweak that TCL better for Secam DK currently.
If he gets his code in, we can also change to that dedicated tuner.

Best is to install "mercurial" and then:
"hg clone http://linuxtv.org/hg/v4l-dvb"

Try to get your patch applied on that and run "make checkpatch" once.
Fix the spaces about it may complain and the like and with
"hg diff > saa7134_support-Rovermedia-etc....patch" you likely have
something ready for inclusion then. Don't forget to attach it as well
and test it once.

Cheers,
Hermann


