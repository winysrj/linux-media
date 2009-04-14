Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-12.arcor-online.net ([151.189.21.52]:47601 "EHLO
	mail-in-12.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753929AbZDNVms (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 14 Apr 2009 17:42:48 -0400
Subject: Re: Kernel 2.6.29 breaks DVB-T ASUSTeK Tiger LNA Hybrid Capture
	Device
From: hermann pitton <hermann-pitton@arcor.de>
To: David Wong <davidtlwong@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>, ramsoft@virgilio.it,
	linux-media@vger.kernel.org
In-Reply-To: <15ed362e0904140230j5116e527p64afc9a1a47fb9bc@mail.gmail.com>
References: <loom.20090403T201901-786@post.gmane.org>
	 <1238805912.3498.18.camel@pc07.localdom.local>
	 <1238806956.3498.26.camel@pc07.localdom.local>
	 <49D77ACC.9050606@virgilio.it>
	 <1238955753.6627.29.camel@pc07.localdom.local>
	 <20090414002341.48b6d974@pedra.chehab.org>
	 <15ed362e0904140230j5116e527p64afc9a1a47fb9bc@mail.gmail.com>
Content-Type: text/plain
Date: Tue, 14 Apr 2009 23:33:57 +0200
Message-Id: <1239744837.3806.55.camel@pc07.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

Am Dienstag, den 14.04.2009, 17:30 +0800 schrieb David Wong:
> On Tue, Apr 14, 2009 at 11:23 AM, Mauro Carvalho Chehab
> <mchehab@infradead.org> wrote:
> > On Sun, 05 Apr 2009 20:22:33 +0200
> > hermann pitton <hermann-pitton@arcor.de> wrote:
> >
> >> Hi,
> >>
> >> Am Samstag, den 04.04.2009, 17:20 +0200 schrieb Ra.M.:
> >> > hermann pitton ha scritto:
> >> > > Am Samstag, den 04.04.2009, 02:45 +0200 schrieb hermann pitton:
> >> > >
> >> > >> Hi Ralph,
> >> > >>
> >> > >> Am Freitag, den 03.04.2009, 20:49 +0000 schrieb Ralph:
> >> > >>
> >> > >>> ASUSTeK Tiger LNA Hybrid Capture Device PCI - Analog/DVB-T card
> >> > >>> Multimedia controller: Philips Semiconductors SAA7131/SAA7133/SAA7135 Video
> >> > >>> Broadcast Decoder (rev d1)
> >> > >>>
> >> > >>> Works perfectly with kernel 2.6.28.4 (or older).
> >> > >>> Recently, I have switched to 2.6.29 (same .config as 2.6.28.4) and now, at
> >> > >>> boot
> >> > >>> time, I get the message:
> >> > >>>
> >> > >>> IRQ 18/saa7133[0]: IRQF_DISABLED is not guaranteed on shared IRQs
> >> > >>>
> >> > >>> Signal strength is very low and Kaffeine is unable to tune in any channel.
> >> > >>> Same problem with kernel 2.6.29.1
> >> > >>>
> >> > >>> -------------------------------------
> >> > >>>
> >> > >>> Messages from /var/log/dmesg
> >> > >>>
> >> > >>> saa7134 0000:03:0a.0: PCI INT A -> Link[APC3] -> GSI 18 (level, low) -> \
> >> > >>>  IRQ 18
> >> > >>> saa7133[0]: found at 0000:03:0a.0, rev: 209, irq: 18, latency: 32, mmio: \
> >> > >>> 0xfdefe000
> >> > >>> saa7133[0]: subsystem: 1043:4871, board: ASUS P7131 4871 \
> >> > >>> [card=111,autodetected]
> >> > >>> saa7133[0]: board init: gpio is 0
> >> > >>> IRQ 18/saa7133[0]: IRQF_DISABLED is not guaranteed on shared IRQs
> >> > >>> saa7133[0]: i2c eeprom 00: 43 10 71 48 54 20 1c 00 43 43 a9 1c 55 d2 b2 92
> >> > >>> saa7133[0]: i2c eeprom 10: ff ff ff 0f ff 20 ff ff ff ff ff ff ff ff ff ff
> >> > >>> saa7133[0]: i2c eeprom 20: 01 40 01 02 03 00 01 03 08 ff 00 cf ff ff ff ff
> >> > >>> saa7133[0]: i2c eeprom 30: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> >> > >>> saa7133[0]: i2c eeprom 40: ff 21 00 c2 96 10 03 22 15 50 ff ff ff ff ff ff
> >> > >>> saa7133[0]: i2c eeprom 50: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> >> > >>> saa7133[0]: i2c eeprom 60: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> >> > >>> saa7133[0]: i2c eeprom 70: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> >> > >>> saa7133[0]: i2c eeprom 80: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> >> > >>> saa7133[0]: i2c eeprom 90: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> >> > >>> saa7133[0]: i2c eeprom a0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> >> > >>> saa7133[0]: i2c eeprom b0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> >> > >>> saa7133[0]: i2c eeprom c0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> >> > >>> saa7133[0]: i2c eeprom d0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> >> > >>> saa7133[0]: i2c eeprom e0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> >> > >>> saa7133[0]: i2c eeprom f0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> >> > >>> tuner' 2-004b: chip found @ 0x96 (saa7133[0])
> >> > >>> tda829x 2-004b: setting tuner address to 61
> >> > >>> tda829x 2-004b: type set to tda8290+75a
> >> > >>> saa7133[0]: registered device video0 [v4l2]
> >> > >>> saa7133[0]: registered device vbi0
> >> > >>> dvb_init() allocating 1 frontend
> >> > >>> DVB: registering new adapter (saa7133[0])
> >> > >>> DVB: registering adapter 0 frontend -32769 (Philips TDA10046H DVB-T)...
> >> > >>> tda1004x: setting up plls for 48MHz sampling clock
> >> > >>> tda1004x: timeout waiting for DSP ready
> >> > >>> tda1004x: found firmware revision 0 -- invalid
> >> > >>> tda1004x: trying to boot from eeprom
> >> > >>> tda1004x: timeout waiting for DSP ready
> >> > >>> tda1004x: found firmware revision 0 -- invalid
> >> > >>> tda1004x: waiting for firmware upload...
> >> > >>> saa7134 0000:03:0a.0: firmware: requesting dvb-fe-tda10046.fw
> >> > >>> tda1004x: found firmware revision 29 -- ok
> >> > >>> saa7134 ALSA driver for DMA sound loaded
> >> > >>> IRQ 18/saa7133[0]: IRQF_DISABLED is not guaranteed on shared IRQs
> >> > >>> saa7133[0]/alsa: saa7133[0] at 0xfdefe000 irq 18 registered as card -1
> >> > >>>
> >> > >>>
> >> > >> thanks for your report, as announced previously, I unfortunately did not
> >> > >> have time to run with latest always ... (guess why ...)
> >> > >>
> >> > >> The driver always worked with shared IRQs, if not, it was always a
> >> > >> limitation of certain hardware or mostly in some combination with binary
> >> > >> only drivers.
> >> > >>
> >> > >> If the above should be the case in general now, and not only caused by
> >> > >> some blacklist, no print out in that direction, the driver is pretty
> >> > >> broken again.
> >> > >>
> >> > >> I for sure don't have all for last months, but that
> >> > >> "IRQF_DISABLED is not guaranteed on shared IRQs" for sure does not come
> >> > >> from us here.
> >> > >>
> >> > >
> >> > > Do use something unusual like pollirq or something?
> >> > >
> >> > > We only have in saa7134-core.c
> >> > >
> >> > >   /* initialize hardware #1 */
> >> > >   saa7134_board_init1(dev);
> >> > >   saa7134_hwinit1(dev);
> >> > >
> >> > >   /* get irq */
> >> > >   err = request_irq(pci_dev->irq, saa7134_irq,
> >> > >                     IRQF_SHARED | IRQF_DISABLED, dev->name, dev);
> >> > >   if (err < 0) {
> >> > >           printk(KERN_ERR "%s: can't get IRQ %d\n",
> >> > >                  dev->name,pci_dev->irq);
> >> > >           goto fail3;
> >> > >   }
> >> > >
> >> > > and in saa7134-alsa.c
> >> > >
> >> > >   err = request_irq(dev->pci->irq, saa7134_alsa_irq,
> >> > >                           IRQF_SHARED | IRQF_DISABLED, dev->name,
> >> > >                           (void*) &dev->dmasound);
> >> > >
> >> > >   if (err < 0) {
> >> > >           printk(KERN_ERR "%s: can't get IRQ %d for ALSA\n",
> >> > >                   dev->name, dev->pci->irq);
> >> > >           goto __nodev;
> >> > >   }
> >> > >
> >> > > Have fun ;)
> >> > > Hermann
> >> > >
> >> > >
> >> > >
> >> > >
> >> > No, I do not use pollirq.
> >> >
> >> > I have read that many users have had problems with 2.6.29 and IRQs.
> >> > Those problems affect WiFi cards, Ethernet cards, DVB-T cards, etc.
> >> >
> >> > For example:
> >> >
> >> > http://article.gmane.org/gmane.linux.uml.devel/12098
> >> > http://www.gossamer-threads.com/lists/linux/kernel/1044282
> >> > http://zen-sources.org/content/irqfshared-irqfdisabled-fix-2629-rc
> >> >
> >> > In all cases, at boot time appears the message:
> >> >
> >> > IRQ XY: IRQF_DISABLED is not guaranteed on shared IRQs
> >> >
> >> > So, probably, there is a kernel bug in the IRQs management of the
> >> > 2.6.29 and 2.6.29.1
> >> >
> >>
> >> did build a 2.6.29.1 now and your report is correct!
> >>
> >> DVB-T on saa7134 is broken at least for all tda10046 and tda8275 stuff
> >> and it is not restricted to devices with LNA.
> >>
> >> For what I can see so far, it is not related to the IRQF_DISABLED print
> >> out, since only a warning for now and removing it from the driver
> >> doesn't change anything.
> >>
> >> saa7134 DVB-S, analog TV and saa7134-alsa are not affected.
> >>
> >> Installing the current mercurial v4l-dvb on 2.6.29.1 does fix it.
> >>
> >> If on that saa7134-dvb.ko and saa7134.ko are replaced with the ones from
> >> 2.6.29.1 the breakage is back again. The related dvb and tuner modules
> >> tolerate such exchange on a first rough test.
> >>
> >> As you reported, symptoms are tumbling signal and SNR between very low
> >> and 100%, as if tuning and AGC would never stabilize.
> >>
> >> I suspect failing i2c stuff is involved. Did not notice anything like
> >> that on various mercurial versions during the last months.
> >
> > Hermann,
> >
> > Could you please try to bisect the patch that broke it? The instructions for
> > bisecting with mercurial are available at README.patches file.

hmm, current mercurial is not broken for DVB-T on the 2.6.29.1.
So we would have to find out if mercurial was ever bad.

Your on the 2.6.29 missing i2c gate control fixes made no difference too
porting them to 2.6.29.1. I was thinking about to test next if it is
already broken on the rc1 to come closer to it.

> Sorry for interrupt.
> Would your saa7134 i2c problem is due to the i2c quirk?
> I have problem on the saa7134 i2c quirk that I have to totally disable
> it on my work-in-progress card.
> Just a little suggestion that trying disable the i2c quirk like this change set:
> http://linuxtv.org/hg/~mkrufky/dmbth/rev/781ffa6c43d3
> 
> David.

I have quite some cards and never had problems with that.
The tuner status read out is also the same on the broken 2.6.29 and on
working mercurial v4l-dvb and quirks are still enabled.

Unfortunately I can't promise any time soon for excessive bisecting,
but I'll try to check if it is already on 29-rc1.

BTW, someone must disable the IR on the VIDEOMATE_T750 or add the
missing. People can't even boot up it seems. Must go to stable too.

Cheers,
Hermann


