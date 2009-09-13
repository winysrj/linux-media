Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-14.arcor-online.net ([151.189.21.54]:40818 "EHLO
	mail-in-14.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752610AbZIMWqc (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 13 Sep 2009 18:46:32 -0400
Subject: Re: Problems with Pinnacle 310i (saa7134) and recent kernels
From: hermann pitton <hermann-pitton@arcor.de>
To: Avl Jawrowski <avljawrowski@gmail.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org
In-Reply-To: <loom.20090913T115105-855@post.gmane.org>
References: <loom.20090718T135733-267@post.gmane.org>
	 <1248033581.3667.40.camel@pc07.localdom.local>
	 <loom.20090720T224156-477@post.gmane.org>
	 <1248146456.3239.6.camel@pc07.localdom.local>
	 <loom.20090722T123703-889@post.gmane.org>
	 <1248338430.3206.34.camel@pc07.localdom.local>
	 <loom.20090910T234610-403@post.gmane.org>
	 <1252630820.3321.14.camel@pc07.localdom.local>
	 <loom.20090912T211959-273@post.gmane.org>
	 <1252815178.3259.39.camel@pc07.localdom.local>
	 <loom.20090913T115105-855@post.gmane.org>
Content-Type: text/plain
Date: Mon, 14 Sep 2009 00:42:16 +0200
Message-Id: <1252881736.4318.48.camel@pc07.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

Am Sonntag, den 13.09.2009, 12:02 +0000 schrieb Avl Jawrowski:
> Hi,
> 
> hermann pitton <hermann-pitton <at> arcor.de> writes:
> 
> > 
> > I'm sorry that we have some mess on some of such devices, but currently
> > really nobody can help much further.
> > 
> > Mike and Hauppauge don't have any schematics for LNA and external
> > antenna voltage switching for now, he assured it to me personally and we
> > must live with the back hacks for now and try to further work through
> > it.
> > 
> > However, mplayer should work as well, but my last checkout is a little
> > out dated.
> > 
> > It will go to Nico anyway, he is usually at the list here.
> > 
> > If you can tell me on what you are, I might be able to confirm or not.
> 
> Do you mean the exact card I have? I can do some photos if they can help.
> Unfortunately I don't have the original eeprom content.

no, in this case I meant mplayer should work for you too.
You need to have DVB support enabled and a channels.conf file in
~/.mplayer.

We might collect pictures of the cards and remotes as well.
To identify those card with an additional LNA circuitry is likely not
easy hardware wise, since the tuner shielding is soldered with 16 pins,
many close to lines. Maybe we can identify those boards by the card
revision printed on them. Don't know how to auto detect them.

> In the matter of the IR, the modules seems to be loaded:
> 
> tda1004x               13048  1
> saa7134_dvb            20772  0
> videobuf_dvb            5644  1 saa7134_dvb
> ir_kbd_i2c              5500  0
> tda827x                 8880  2
> tuner                  16960  1
> saa7134               138436  1 saa7134_dvb
> ir_common              41828  2 ir_kbd_i2c,saa7134
> videobuf_dma_sg         9876  2 saa7134_dvb,saa7134
> videobuf_core          13596  3 videobuf_dvb,saa7134,videobuf_dma_sg
> tveeprom               10488  1 saa7134
> 
> But I can't find anything in /proc/bus/input/devices.

We might have more than the two supported remotes on such cards.
After all that would not make me wonder anymore and the windows driver
presents some more. Do you have that silver remote with colored buttons.
There must be a device at 0x47 detected to support it.

You might have to load ir-kbd-i2c at first or reload saa7134-alsa and
saa7134-dvb, which includes saa7134.

If OK, looks like this here.

saa7133[2]: setting pci latency timer to 64
saa7133[2]: found at 0000:04:03.0, rev: 208, irq: 21, latency: 64, mmio: 0xfebfe800
saa7133[2]: subsystem: 11bd:002f, board: Pinnacle PCTV 310i [card=101,insmod option]
saa7133[2]: board init: gpio is 600c000
saa7133[2]: gpio: mode=0x0000000 in=0x600c000 out=0x0000000 [pre-init]
IRQ 21/saa7133[2]: IRQF_DISABLED is not guaranteed on shared IRQs
saa7133[2]: i2c eeprom 00: bd 11 2f 00 54 20 1c 00 43 43 a9 1c 55 d2 b2 92
saa7133[2]: i2c eeprom 10: ff e0 60 06 ff 20 ff ff 00 30 8d 2c b0 22 ff ff
saa7133[2]: i2c eeprom 20: 01 2c 01 02 02 01 04 30 98 ff 00 a5 ff 21 00 c2
saa7133[2]: i2c eeprom 30: 96 10 03 32 15 20 ff ff 0c 22 17 88 03 44 31 f9
saa7133[2]: i2c eeprom 40: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[2]: i2c eeprom 50: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[2]: i2c eeprom 60: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[2]: i2c eeprom 70: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[2]: i2c eeprom 80: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[2]: i2c eeprom 90: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[2]: i2c eeprom a0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[2]: i2c eeprom b0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[2]: i2c eeprom c0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[2]: i2c eeprom d0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[2]: i2c eeprom e0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[2]: i2c eeprom f0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
input: i2c IR (Pinnacle PCTV) as /class/input/input7
ir-kbd-i2c: i2c IR (Pinnacle PCTV) detected at i2c-3/3-0047/ir0 [saa7133[2]]
tuner 3-004b: chip found @ 0x96 (saa7133[2])
tda829x 3-004b: setting tuner address to 61
tda829x 3-004b: type set to tda8290+75a
saa7133[2]: gpio: mode=0x0200000 in=0x600e000 out=0x0000000 [Television]
saa7133[2]: gpio: mode=0x0200000 in=0x600e000 out=0x0000000 [Television]
saa7133[2]: gpio: mode=0x0200000 in=0x600c000 out=0x0000000 [Television]
saa7133[2]: registered device video2 [v4l2]
saa7133[2]: registered device vbi2
saa7133[2]: registered device radio0
dvb_init() allocating 1 frontend
DVB: registering new adapter (saa7133[0])
DVB: registering adapter 0 frontend 0 (Philips TDA10046H DVB-T)...
tda1004x: setting up plls for 48MHz sampling clock
tda1004x: found firmware revision 29 -- ok
saa7133[0]/dvb: setting GPIO21 to 1 (Radio antenna?)
dvb_init() allocating 1 frontend
DVB: registering new adapter (saa7133[1])
DVB: registering adapter 1 frontend 0 (Philips TDA10086 DVB-S)...
dvb_init() allocating 1 frontend
DVB: registering new adapter (saa7133[2])
DVB: registering adapter 2 frontend 0 (Philips TDA10046H DVB-T)...
tda1004x: setting up plls for 48MHz sampling clock
tda1004x: found firmware revision 29 -- ok

> > The only other issue I'm aware of is that radio is broken since guessed
> > 8 weeks on my tuners, only realized when testing on enabling external
> > active antenna voltage for DVB-T on a/some 310i.
> > 
> > Might be anything, hm, hopefully I should not have caused it ;)
> 
> The radio works for me, even if there's much noise (I don't usually use it).
> I'm using the internal audio cable.

The radio is broken for all tuners, you must be on older stuff.

I finally found the time to do the mercurial bisect today.

It is broken since Hans' changeset 12429 on seventh August.

Cheers,
Hermann


