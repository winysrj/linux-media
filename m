Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-16.arcor-online.net ([151.189.21.56]:42383 "EHLO
	mail-in-16.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757490AbZINW6k (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Sep 2009 18:58:40 -0400
Subject: Re: Problems with Pinnacle 310i (saa7134) and recent kernels
From: hermann pitton <hermann-pitton@arcor.de>
To: Avl Jawrowski <avljawrowski@gmail.com>
Cc: linux-media@vger.kernel.org
In-Reply-To: <loom.20090914T150511-456@post.gmane.org>
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
	 <1252881736.4318.48.camel@pc07.localdom.local>
	 <loom.20090914T150511-456@post.gmane.org>
Content-Type: text/plain
Date: Tue, 15 Sep 2009 00:53:13 +0200
Message-Id: <1252968793.3250.23.camel@pc07.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

Am Montag, den 14.09.2009, 13:32 +0000 schrieb Avl Jawrowski:
> Hi,
> 
> hermann pitton <hermann-pitton <at> arcor.de> writes:
> 
> > no, in this case I meant mplayer should work for you too.
> > You need to have DVB support enabled and a channels.conf file in
> > ~/.mplayer.
> 
> It's compiled with --enable-dvbhead, and the channels.conf is made by w_scan,
> but I tried even with a made by scan one.

mplayer works on all my cards including the 310i for DVB-T and DVB-S
since years. Guess you miss something or have a broken checkout.

> > We might collect pictures of the cards and remotes as well.
> > To identify those card with an additional LNA circuitry is likely not
> > easy hardware wise, since the tuner shielding is soldered with 16 pins,
> > many close to lines. Maybe we can identify those boards by the card
> > revision printed on them. Don't know how to auto detect them.
> 
> I will post some photos.

Best is to add them to the wiki, else upload somewhere else or post off
list.

> > > In the matter of the IR, the modules seems to be loaded:
> > > 
> > > tda1004x               13048  1
> > > saa7134_dvb            20772  0
> > > videobuf_dvb            5644  1 saa7134_dvb
> > > ir_kbd_i2c              5500  0
> > > tda827x                 8880  2
> > > tuner                  16960  1
> > > saa7134               138436  1 saa7134_dvb
> > > ir_common              41828  2 ir_kbd_i2c,saa7134
> > > videobuf_dma_sg         9876  2 saa7134_dvb,saa7134
> > > videobuf_core          13596  3 videobuf_dvb,saa7134,videobuf_dma_sg
> > > tveeprom               10488  1 saa7134
> > > 
> > > But I can't find anything in /proc/bus/input/devices.
> > 
> > We might have more than the two supported remotes on such cards.
> > After all that would not make me wonder anymore and the windows driver
> > presents some more. Do you have that silver remote with colored buttons.
> > There must be a device at 0x47 detected to support it.
> 
> Yes that is: http://www.hwp.ru/Tvtuners/Pinnaclehybridpro.pci
> /Pinnaclepctvhybridpropci-1sm.jpg

Remote and IR sensor look the same like mine on the 310i, but they still
might have changed something and you are by far not the first reporting
the remote not working on newer devices. BTW, mine seems not to work on
vista with the Pinnacle media software.

> > You might have to load ir-kbd-i2c at first or reload saa7134-alsa and
> > saa7134-dvb, which includes saa7134.
> 
> I've unloaded all modules, then loaded first ir-kbd-i2c and next saa7134-dvb,
> but I can't see any difference.
> Loading saa7134 with ir_debug=1 and i2c_debug=1 I can see some of these errors:
> 
> saa7133[0]: i2c xfer: < 8e ERROR: NO_DEVICE

Here is the problem. The supported cards do have the i2c chip at 0x47 or
0x8e in 8bit notation. Needs closer investigation.

> saa7133[0]: i2c xfer: < e2 ERROR: NO_DEVICE
> saa7133[0]: i2c xfer: < 5a ERROR: NO_DEVICE
> 
> > > > The only other issue I'm aware of is that radio is broken since guessed
> > > > 8 weeks on my tuners, only realized when testing on enabling external
> > > > active antenna voltage for DVB-T on a/some 310i.
> > > > 
> > > > Might be anything, hm, hopefully I should not have caused it ;)
> > > 
> > > The radio works for me, even if there's much noise (I don't usually use it).
> > > I'm using the internal audio cable.
> > 
> > The radio is broken for all tuners, you must be on older stuff.
> 
> Using 2.6.31 and mplayer it really works for me.

Ah, thanks. Should have thought about it. Most radio apps are still
v4l1. Mplayer indeed works, tested with saa7134-alsa, as does "kradio",
just installed it again, both are v4l2. 

> > I finally found the time to do the mercurial bisect today.
> > 
> > It is broken since Hans' changeset 12429 on seventh August.

So only all the v4l1 apps are broken.

Cheers,
Hermann




