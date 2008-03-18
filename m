Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from bombadil.infradead.org ([18.85.46.34])
	by www.linuxtv.org with esmtp (Exim 4.63) (envelope-from
	<SRS0+b9c06d2e3da2f0ede24a+1668+infradead.org+mchehab@bombadil.srs.infradead.org>)
	id 1JbhL0-0000lx-Ja
	for linux-dvb@linuxtv.org; Tue, 18 Mar 2008 20:19:07 +0100
Date: Tue, 18 Mar 2008 16:17:29 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: timf <timf@iinet.net.au>
Message-ID: <20080318161729.6da782ee@gaivota>
In-Reply-To: <1205864312.11231.11.camel@ubuntu>
References: <47A5D8AF.2090800@googlemail.com> <20080205075014.6b7091d9@gaivota>
	<47A8CE7E.6020908@googlemail.com> <20080205222437.1397896d@gaivota>
	<47AA014F.2090608@googlemail.com> <20080207092607.0a1cacaa@gaivota>
	<47AAF0C4.8030804@googlemail.com> <47AB6A1B.5090100@googlemail.com>
	<20080207184221.1ea8e823@gaivota> <47ACA9AA.4090702@googlemail.com>
	<47AE20BD.7090503@googlemail.com> <20080212124734.62cd451d@gaivota>
	<47B1E22D.4090901@googlemail.com> <20080313114633.494bc7b1@gaivota>
	<1205457408.6358.5.camel@ubuntu> <20080314121423.670f31a0@gaivota>
	<1205518856.6094.14.camel@ubuntu> <20080314155851.52677f28@gaivota>
	<1205523274.6364.5.camel@ubuntu> <20080314172143.62390b1f@gaivota>
	<1205573636.5941.1.camel@ubuntu> <20080318103044.4363fefd@gaivota>
	<1205864312.11231.11.camel@ubuntu>
Mime-Version: 1.0
Cc: linux-dvb@linuxtv.org, "Richard \(MQ\)" <osl2008@googlemail.com>
Subject: Re: [linux-dvb] Any chance of help with v4l-dvb-experimental /
 Avermedia A16D please?
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

On Wed, 19 Mar 2008 03:18:32 +0900
timf <timf@iinet.net.au> wrote:

> Hi Mauro,
> 
> On Tue, 2008-03-18 at 10:30 -0300, Mauro Carvalho Chehab wrote:
> > On Sat, 15 Mar 2008 18:33:56 +0900
> > timf <timf@iinet.net.au> wrote:
> > 
> > > [   15.000000] saa7133[0]: subsystem: 1461:f936, board: AVerMedia Hybrid
> > > TV/Radio (A16D) [card=137,autodetected]
> > 
> > 
> > > [   15.296000] tuner' 2-0061: Setting mode_mask to 0x0e
> > > [   15.296000] tuner' 2-0061: chip found @ 0xc2 (saa7133[0])
> > > [   15.296000] tuner' 2-0061: tuner 0x61: Tuner type absent
> > 
> > The above is not right. It should be using type=71 for the tuner.
> > 
> > I think I found the bug: the tuner addresses should be set to ADDR_UNSET,
> > instead of keeping it blank.
> > 
> > Please do an "hg pull -u" and try again, recompiling and re-installing the modules:
> > 	hg pull -u
> > 	make rmmod
> > 	make
> > 	make install
> > 	modprobe saa7134
> > 
> > > 8) The chip on my card is xc3018. Why does module xc5000 load?
> > 
> > This is an issue on the way cards are attached, at tuner_core. Since they
> > directly access xc5000 code, with:
> > 
> >                 if (!xc5000_attach(&t->fe, t->i2c->adapter, &xc5000_cfg)) {
> > 
> > xc5000 module will be loaded, even if not used. It shouldn't be hard to fix
> > this, by using the macro dvb_attach().
> > 
> > 
> > 
> > Cheers,
> > Mauro
> 
> 
> 1) There is something wrong with the repo at present
>  - it just times out and aborts.
> 
> 2) So I copied the latest tip.tgz and extracted it.
> (Thus hg pull won't work - no .hg)
> 
> 3) I tried to interpret your meaning and tried this in saa7134-cards.c
> 
> 	},
> 	[SAA7134_BOARD_AVERMEDIA_A16D] = {
> 		.name           = "AVerMedia Hybrid TV/Radio (A16D)",
> 		.audio_clock    = 0x187de7,
> 		.tuner_type     = TUNER_XC2028,
> 		.tuner_addr	= ADDR_UNSET,
> 		.inputs         = {{
> 			.name = name_tv,
> 			.vmux = 1,
> 			.amux = TV,
> 			.tv   = 1,
> 		}, {
> 			.name = name_svideo,
> 			.vmux = 8,
> 			.amux = LINE1,
> 		} },
> 		.radio = {
> 			.name = name_radio,
> 			.amux = LINE1,
> 		},
> 	},
> 	[SAA7134_BOARD_AVERMEDIA_M115] = {
> 
> 4) My options file:
> 
> # Enable double-buffering so gstreamer et. al. work
> options quickcam compatible=2
> 
> # Default hostap to managed mode
> options hostap_pci iw_mode=2
> options hostap_cs iw_mode=2
> 
> options tuner-xc2028 debug=1
> options tuner debug=1
> options saa7134 i2c_scan=1
> # i2c_debug=1 ir_debug=1
> 
> 5) However, with or without ".tuner_addr = ADDR_UNSET,"
> dmesg is the same - no tuner.
> 
> <snip>
> [   40.560890] ACPI: PCI Interrupt 0000:04:09.0[A] -> Link [APC2] -> GSI
> 17 (level, low) -> IRQ 17
> [   40.560898] saa7133[0]: found at 0000:04:09.0, rev: 209, irq: 17,
> latency: 32, mmio: 0xfdbff000
> [   40.560905] saa7133[0]: subsystem: 1461:f936, board: AVerMedia Hybrid
> TV/Radio (A16D) [card=137,autodetected]
> [   40.560914] saa7133[0]: board init: gpio is 22000
> [   40.561341] input: PC Speaker as /class/input/input4
> [   40.727930] saa7133[0]: i2c eeprom 00: 61 14 36 f9 00 00 00 00 00 00
> 00 00 00 00 00 00
> [   40.727939] saa7133[0]: i2c eeprom 10: ff ff ff ff ff 20 ff ff ff ff
> ff ff ff ff ff ff
> [   40.727947] saa7133[0]: i2c eeprom 20: 01 40 01 02 02 01 01 00 08 ff
> 00 0e ff ff ff ff
> [   40.727953] saa7133[0]: i2c eeprom 30: ff ff ff ff ff ff ff ff ff ff
> ff ff ff ff ff ff
> [   40.727961] saa7133[0]: i2c eeprom 40: ff 65 00 ff c2 1e ff ff ff ff
> ff ff ff ff ff ff
> [   40.727968] saa7133[0]: i2c eeprom 50: ff ff ff ff ff ff ff ff ff ff
> ff ff ff ff ff ff
> [   40.727975] saa7133[0]: i2c eeprom 60: ff ff ff ff ff ff ff ff ff ff
> ff ff ff ff ff ff
> [   40.727982] saa7133[0]: i2c eeprom 70: ff ff ff ff ff ff ff ff ff ff
> ff ff ff ff ff ff
> [   40.727989] saa7133[0]: i2c eeprom 80: ff ff ff ff ff ff ff ff ff ff
> ff ff ff ff ff ff
> [   40.727996] saa7133[0]: i2c eeprom 90: ff ff ff ff ff ff ff ff ff ff
> ff ff ff ff ff ff
> [   40.728003] saa7133[0]: i2c eeprom a0: ff ff ff ff ff ff ff ff ff ff
> ff ff ff ff ff ff
> [   40.728010] saa7133[0]: i2c eeprom b0: ff ff ff ff ff ff ff ff ff ff
> ff ff ff ff ff ff
> [   40.728017] saa7133[0]: i2c eeprom c0: ff ff ff ff ff ff ff ff ff ff
> ff ff ff ff ff ff
> [   40.728024] saa7133[0]: i2c eeprom d0: ff ff ff ff ff ff ff ff ff ff
> ff ff ff ff ff ff
> [   40.728032] saa7133[0]: i2c eeprom e0: ff ff ff ff ff ff ff ff ff ff
> ff ff ff ff ff ff
> [   40.728039] saa7133[0]: i2c eeprom f0: ff ff ff ff ff ff ff ff ff ff
> ff ff ff ff ff ff
> [   40.740151] saa7133[0]: i2c scan: found device @ 0x1e  [???]
> [   40.759885] saa7133[0]: i2c scan: found device @ 0xa0  [eeprom]
> [   40.901555] saa7133[0]: registered device video0 [v4l2]
> [   40.901588] saa7133[0]: registered device vbi0
> [   40.901620] saa7133[0]: registered device radio0
> [   40.907417] ACPI: PCI Interrupt Link [AAZA] enabled at IRQ 22
> [   40.907423] ACPI: PCI Interrupt 0000:00:10.1[B] -> Link [AAZA] -> GSI
> 22 (level, low) -> IRQ 22
> [   40.907624] PCI: Setting latency timer of device 0000:00:10.1 to 64
> [   40.910779] saa7134 ALSA driver for DMA sound loaded
> [   40.910811] saa7133[0]/alsa: saa7133[0] at 0xfdbff000 irq 17
> registered as card -2
> [   41.776297] loop: module loaded
> [   41.799994] lp0: using parport0 (interrupt-driven).
> <snip>
> 
> 6) Perhaps I misinterpreted where you meant to put ".tuner_addr =
> ADDR_UNSET,"
> but I now don't even get this:
> > [   15.296000] tuner' 2-0061: Setting mode_mask to 0x0e
> > [   15.296000] tuner' 2-0061: chip found @ 0xc2 (saa7133[0])
> > [   15.296000] tuner' 2-0061: tuner 0x61: Tuner type absent

Argh! I forgot to send the patch to the main tree. 

Ok, I've updated saa7134 at v4l-dvb:
	http://linuxtv.org/hg/v4l-dvb/rev/3029b981e42c

please, update again and let's see if this time, it will detect xc3028.




Cheers,
Mauro

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
