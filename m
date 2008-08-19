Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m7J9qUWl031584
	for <video4linux-list@redhat.com>; Tue, 19 Aug 2008 05:52:30 -0400
Received: from mail-in-03.arcor-online.net (mail-in-03.arcor-online.net
	[151.189.21.43])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m7J9qELj014487
	for <video4linux-list@redhat.com>; Tue, 19 Aug 2008 05:52:15 -0400
From: hermann pitton <hermann-pitton@arcor.de>
To: "A. Fichtner" <anfichtner@atfichtner.de>
In-Reply-To: <48AA823C.7050300@atfichtner.de>
References: <48A99EB1.3030707@atfichtner.de>
	<1219112329.4107.8.camel@pc10.localdom.local>
	<48AA823C.7050300@atfichtner.de>
Content-Type: text/plain
Date: Tue, 19 Aug 2008 11:51:08 +0200
Message-Id: <1219139468.2678.30.camel@pc10.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com
Subject: Re: noname PCMCIA TV-Tuner Card - no tv ?
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>


Am Dienstag, den 19.08.2008, 10:20 +0200 schrieb A. Fichtner:
> hermann pitton schrieb:
> > Hi,
> >
> > Am Montag, den 18.08.2008, 18:09 +0200 schrieb A. Fichtner: 
> >   
> >> Hello!
> >>
> >> I have some trouble to get my new TV-Card installed.
> >>
> >> The documentation says it has a philips *tda8275a, tda8290 new silicon 
> >> tuner*
> >> google means that it is a hybrid card.
> >>
> >> dmesg says the following:
> >> [ 8847.678136] pccard: CardBus card inserted into slot 0
> >> [ 8847.678260] yenta EnE: chaning testregister 0xC9, 44 -> 44
> >> [ 3538.107500] saa7130/34: v4l2 driver version 0.2.14 loaded
> >> [ 3538.107990] PCI: Enabling device 0000:02:00.0 (0000 -> 0002)
> >> [ 3538.108259] ACPI: PCI Interrupt 0000:02:00.0[A] -> Link [LNKB] -> GSI 
> >> 11 (level, low) -> IRQ 11
> >> [ 3538.108273] saa7133[0]: found at 0000:02:00.0, rev: 16, irq: 11, 
> >> latency: 0, mmio: 0x34000000
> >> [ 3538.108282] PCI: Setting latency timer of device 0000:02:00.0 to 64
> >> [ 3538.108288] saa7133[0]: subsystem: 1132:2004, board: UNKNOWN/GENERIC 
> >> [card=0,autodetected]
> >> [ 3538.108301] saa7133[0]: board init: gpio is 0
> >> [ 3538.108310] saa7133[0]: gpio: mode=0x0000000 in=0x0000000 
> >> out=0x0000000 [pre-init]
> >> [ 3538.210612] saa7133[0]: i2c xfer: < 20 ERROR: NO_DEVICE
> >> [ 3538.211153] saa7133[0]: i2c xfer: < 84 ERROR: NO_DEVICE
> >> [ 3538.211474] saa7133[0]: i2c xfer: < 86 ERROR: NO_DEVICE
> >> [ 3538.211791] saa7133[0]: i2c xfer: < 94 ERROR: NO_DEVICE
> >> [ 3538.212160] saa7133[0]: i2c xfer: < 96 >
> >> [ 3538.218890] saa7133[0]: i2c xfer: < 96 00 >
> >> [ 3538.226599] saa7133[0]: i2c xfer: < 97 =01 =01 =00 =11 =01 =04 =01 =85 >
> >> [ 3538.234599] saa7133[0]: i2c xfer: < 96 1f >
> >> [ 3538.242589] saa7133[0]: i2c xfer: < 97 =89 >
> >> [ 3538.250532] tuner' 2-004b: chip found @ 0x96 (saa7133[0])
> >> [ 3538.250812] tuner' i2c attach [addr=0x4b,client=tuner']
> >> [ 3538.250986] saa7133[0]: i2c xfer: < c0 ERROR: NO_DEVICE
> >> .
> >> .
> >> .
> >> [ 3538.255805] saa7133[0]: i2c xfer: < de ERROR: NO_DEVICE
> >> [ 3538.256145] saa7133[0]: i2c xfer: < a0 00 >
> >> [ 3538.262577] saa7133[0]: i2c xfer: < a1 =32 =11 =04 =20 =54 =20 =1c 
> >> =00 =43 =43 =a9 =1c =55 =d2 =b2 =92 =00 =00 =f0 =0f =ff =20 =ff =ff =ff 
> >> =ff =ff =ff =ff =ff =ff =ff =01 =40 =01 =02 =02 =01 =01 =03 =08 =ff =00 
> >> =1d =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff 
> >> =ff =ff =ff =ff =22 =00 =c2 =96 =ff =02 =30 =15 =ff =ff =ff =ff =ff =ff 
> >> =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff 
> >> =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff 
> >> =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =00 =00 =00 =00 =00 
> >> =00 =00 =00 =00 =00 =00 =00 =00 =00 =00 =00 =00 =00 =00 =00 =00 =00 =00 
> >> =00 =00 =00 =00 =00 =00 =00 =00 =00 =00 =00 =00 =00 =00 =00 =00 =00 =00 
> >> =00 =00 =00 =00 =00 =00 =00 =00 =00 =00 =00 =00 =00 =00 =00 =00 =00 =00 
> >> =00 =00 =00 =00 =00 =00 =00 =00 =00 =00 =00 =00 =00 =00 =00 =00 =00 =00 
> >> =00 =00 =00 =00 =00 =00 =00 =00 =00 =00 =00 =00 =00 =00 =00 =00 =00 =00 
> >> =00 =00 =00 =00 =00 =00 =00 =00 =00 =00 =00 =00 =00 =00 =00 =00 =00 =00 
> >> =00 =00 =00 =00 =00 =00 =00 =00 =00 =00 =00 =00 =00 =00 =00 >
> >> [ 3538.302466] saa7133[0]: i2c eeprom 00: 32 11 04 20 54 20 1c 00 43 43 
> >> a9 1c 55 d2 b2 92
> >> [ 3538.302478] saa7133[0]: i2c eeprom 10: 00 00 f0 0f ff 20 ff ff ff ff 
> >> ff ff ff ff ff ff
> >> [ 3538.302486] saa7133[0]: i2c eeprom 20: 01 40 01 02 02 01 01 03 08 ff 
> >> 00 1d ff ff ff ff
> >> [ 3538.302494] saa7133[0]: i2c eeprom 30: ff ff ff ff ff ff ff ff ff ff 
> >> ff ff ff ff ff ff
> >> [ 3538.302502] saa7133[0]: i2c eeprom 40: ff 22 00 c2 96 ff 02 30 15 ff 
> >> ff ff ff ff ff ff
> >> [ 3538.302510] saa7133[0]: i2c eeprom 50: ff ff ff ff ff ff ff ff ff ff 
> >> ff ff ff ff ff ff
> >> [ 3538.302518] saa7133[0]: i2c eeprom 60: ff ff ff ff ff ff ff ff ff ff 
> >> ff ff ff ff ff ff
> >> [ 3538.302525] saa7133[0]: i2c eeprom 70: ff ff ff ff ff ff ff ff ff ff 
> >> ff ff ff ff ff ff
> >> [ 3538.302533] saa7133[0]: i2c eeprom 80: 00 00 00 00 00 00 00 00 00 00 
> >> 00 00 00 00 00 00
> >> [ 3538.302541] saa7133[0]: i2c eeprom 90: 00 00 00 00 00 00 00 00 00 00 
> >> 00 00 00 00 00 00
> >> [ 3538.302548] saa7133[0]: i2c eeprom a0: 00 00 00 00 00 00 00 00 00 00 
> >> 00 00 00 00 00 00
> >> [ 3538.302555] saa7133[0]: i2c eeprom b0: 00 00 00 00 00 00 00 00 00 00 
> >> 00 00 00 00 00 00
> >> [ 3538.302563] saa7133[0]: i2c eeprom c0: 00 00 00 00 00 00 00 00 00 00 
> >> 00 00 00 00 00 00
> >> [ 3538.302570] saa7133[0]: i2c eeprom d0: 00 00 00 00 00 00 00 00 00 00 
> >> 00 00 00 00 00 00
> >> [ 3538.302578] saa7133[0]: i2c eeprom e0: 00 00 00 00 00 00 00 00 00 00 
> >> 00 00 00 00 00 00
> >> [ 3538.302585] saa7133[0]: i2c eeprom f0: 00 00 00 00 00 00 00 00 00 00 
> >> 00 00 00 00 00 00
> >> [ 3538.305263] saa7133[0]: i2c xfer: < 01 ERROR: NO_DEVICE
> >> .
> >> .
> >> .
> >> [ 3538.328512] saa7133[0]: i2c xfer: < 95 ERROR: NO_DEVICE
> >> [ 3538.328825] saa7133[0]: i2c xfer: < 97 >
> >> [ 3538.334431] saa7133[0]: i2c scan: found device @ 0x96  [???]
> >> [ 3538.334681] saa7133[0]: i2c xfer: < 99 ERROR: NO_DEVICE
> >> [ 3538.334996] saa7133[0]: i2c xfer: < 9b ERROR: NO_DEVICE
> >> [ 3538.335307] saa7133[0]: i2c xfer: < 9d ERROR: NO_DEVICE
> >> [ 3538.335620] saa7133[0]: i2c xfer: < 9f ERROR: NO_DEVICE
> >> [ 3538.335932] saa7133[0]: i2c xfer: < a1 >
> >> [ 3538.342422] saa7133[0]: i2c scan: found device @ 0xa0  [eeprom]
> >> [ 3538.342645] saa7133[0]: i2c xfer: < a3 ERROR: NO_DEVICE
> >> .
> >> .
> >> .
> >> [ 3538.357086] saa7133[0]: i2c xfer: < ff ERROR: NO_DEVICE
> >> [ 3538.357656] saa7133[0]/audio: sound IF not in use, skipping scan
> >> [ 3538.382884] saa7133[0]: registered device video0 [v4l2]
> >> [ 3538.383483] saa7133[0]: registered device vbi0
> >> [ 3538.474259] saa7134_alsa: disagrees about version of symbol 
> >> saa7134_tvaudio_setmute
> >> [ 3538.474273] saa7134_alsa: Unknown symbol saa7134_tvaudio_setmute
> >> [ 3538.474550] saa7134_alsa: disagrees about version of symbol 
> >> saa_dsp_writel
> >> [ 3538.474554] saa7134_alsa: Unknown symbol saa_dsp_writel
> >> [ 3538.474739] saa7134_alsa: disagrees about version of symbol 
> >> videobuf_dma_free
> >> [ 3538.474742] saa7134_alsa: Unknown symbol videobuf_dma_free
> >> [ 3538.474945] saa7134_alsa: disagrees about version of symbol 
> >> saa7134_pgtable_alloc
> >> [ 3538.474948] saa7134_alsa: Unknown symbol saa7134_pgtable_alloc
> >> [ 3538.474992] saa7134_alsa: disagrees about version of symbol 
> >> saa7134_pgtable_build
> >> [ 3538.474994] saa7134_alsa: Unknown symbol saa7134_pgtable_build
> >> [ 3538.475031] saa7134_alsa: disagrees about version of symbol 
> >> saa7134_pgtable_free
> >> [ 3538.475035] saa7134_alsa: Unknown symbol saa7134_pgtable_free
> >> [ 3538.475072] saa7134_alsa: disagrees about version of symbol 
> >> saa7134_dmasound_init
> >> [ 3538.475075] saa7134_alsa: Unknown symbol saa7134_dmasound_init
> >> [ 3538.475221] saa7134_alsa: disagrees about version of symbol 
> >> saa7134_dmasound_exit
> >> [ 3538.475224] saa7134_alsa: Unknown symbol saa7134_dmasound_exit
> >> [ 3538.475327] saa7134_alsa: disagrees about version of symbol 
> >> videobuf_dma_init
> >> [ 3538.475330] saa7134_alsa: Unknown symbol videobuf_dma_init
> >> [ 3538.475488] saa7134_alsa: disagrees about version of symbol 
> >> videobuf_dma_init_kernel
> >> [ 3538.475491] saa7134_alsa: Unknown symbol videobuf_dma_init_kernel
> >> [ 3538.475646] saa7134_alsa: Unknown symbol videobuf_pci_dma_unmap
> >> [ 3538.475810] saa7134_alsa: Unknown symbol videobuf_pci_dma_map
> >> [ 3538.475854] saa7134_alsa: disagrees about version of symbol 
> >> saa7134_set_dmabits
> >> [ 3538.475857] saa7134_alsa: Unknown symbol saa7134_set_dmabits
> >>
> >>
> >> "lsmod |grep saa" says the following:
> >>
> >> saa7134               148052  0
> >> tveeprom               13444  1 saa7134
> >> ir_common              42244  1 saa7134
> >> videodev               36864  2 saa7134,tuner
> >> compat_ioctl32          2304  1 saa7134
> >> v4l2_common            13952  2 saa7134,tuner
> >> videobuf_dma_sg        14980  1 saa7134
> >> videobuf_core          19716  3 saa7134,videobuf_dvb,videobuf_dma_sg
> >> i2c_core               24832  11 
> >> saa7134,tda1004x,tda827x,tda8290,tveeprom,tuner_simple,tuner,v4l2_common,i2c_viapro,i2c_prosavage,i2c_algo_bit
> >>
> >>
> >> Windows-Driver:
> >> Named as "Philips SAA713x BDA Capture Driver"
> >>
> >> Can anyone give me a suggestion what drivers i need to load? What card= 
> >> - insmod options can work?
> >>     
> >
> > the saa7134 is correct and you likely might get it to work.
> >
> > A good and simple start is to test with card=39 tuner=54.
> >
> > If it has a radio antenna input too, card=65 tuner=54 might be
> > close.
> >
> > >From the i2c scan and from the eeprom it seems not to have a digital
> > channel decoder.
> >
> > For testing sound you need saa7134-alsa in a proper state.
> >
> > You can read here and on other places how you might achieve that.
> > http://www.linuxtv.org/pipermail/linux-dvb/2008-August/027910.html
> >
> > You can also find something about how to use it then on the v4l wiki at
> > linuxtv.org.
> >
> > The saa713x chips have two possible clocks/xtals for the audio.
> > Try README.saa7134 and "modinfo saa7134".
> >
> > With the saa7134 option audio_clock_override= you can change the cards
> > defaults. Card=39 has 0x00200000 and card=65 the other possible value of
> > 0x00187de7. A wrong clock produces noise only.
> >
> > Have a look at saa7134-cards.c and saa7134.h for known other cards and
> > different configurations with tuner=54. In case it should have radio,
> > some switch the other way round.
> >
> > On many cardbus devices the power for the tuner must be enabled with a
> > GPIO pin of the saa713x, some also have a fan that needs to be turned
> > on.
> >
> > If you don't get a start such easily, you might consider to dig deeper
> > into it.
> >
> > Cheers,
> > Hermann
> >
> >
> >
> >
> >
> >
> >
> >
> > --
> > video4linux-list mailing list
> > Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
> > https://www.redhat.com/mailman/listinfo/video4linux-list
> >
> >
> >   
> Hello!
> 
> I've tried card=39 and some other values like card=22 in cobination with 
> tuner=54
> 
> here is a dmesg-log:
> 
> [62175.374306] pccard: CardBus card inserted into slot 0
> [62175.374430] yenta EnE: chaning testregister 0xC9, 44 -> 44
> [62176.046010] saa7130/34: v4l2 driver version 0.2.14 loaded
> [62176.046928] PCI: Enabling device 0000:02:00.0 (0000 -> 0002)
> [62176.047368] ACPI: PCI Interrupt 0000:02:00.0[A] -> Link [LNKB] -> GSI 
> 11 (level, low) -> IRQ 11
> [62176.047394] saa7133[0]: found at 0000:02:00.0, rev: 16, irq: 11, 
> latency: 0, mmio: 0x34000000
> [62176.047408] PCI: Setting latency timer of device 0000:02:00.0 to 64
> [62176.047421] saa7133[0]: subsystem: 1132:2004, board: LifeView FlyTV 
> Platinum Mini [card=39,insmod option]
> [62176.047444] saa7133[0]: board init: gpio is 0
> [62176.047456] saa7133[0]: gpio: mode=0x0000000 in=0x0000000 
> out=0x0000000 [pre-init]
> [62176.150166] saa7133[0]: i2c xfer: < a0 00 >
> [62176.158353] saa7133[0]: i2c xfer: < a1 =32 =11 =04 =20 =54 =20 =1c 
> =00 =43 =43 =a9 =1c =55 =d2 =b2 =92 =00 =00 =f0 =0f =ff =20 =ff =ff =ff 
> =ff =ff =ff =ff =ff =ff =ff =01 =40 =01 =02 =02 =01 =01 =03 =08 =ff =00 
> =1d =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff 
> =ff =ff =ff =ff =22 =00 =c2 =96 =ff =02 =30 =15 =ff =ff =ff =ff =ff =ff 
> =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff 
> =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff 
> =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =00 =00 =00 =00 =00 
> =00 =00 =00 =00 =00 =00 =00 =00 =00 =00 =00 =00 =00 =00 =00 =00 =00 =00 
> =00 =00 =00 =00 =00 =00 =00 =00 =00 =00 =00 =00 =00 =00 =00 =00 =00 =00 
> =00 =00 =00 =00 =00 =00 =00 =00 =00 =00 =00 =00 =00 =00 =00 =00 =00 =00 
> =00 =00 =00 =00 =00 =00 =00 =00 =00 =00 =00 =00 =00 =00 =00 =00 =00 =00 
> =00 =00 =00 =00 =00 =00 =00 =00 =00 =00 =00 =00 =00 =00 =00 =00 =00 =00 
> =00 =00 =00 =00 =00 =00 =00 =00 =00 =00 =00 =00 =00 =00 =00 =00 =00 =00 
> =00 =00 =00 =00 =00 =00 =00 =00 =00 =00 =00 =00 =00 =00 =00 >
> [62176.198232] saa7133[0]: i2c eeprom 00: 32 11 04 20 54 20 1c 00 43 43 
> a9 1c 55 d2 b2 92
> [62176.198257] saa7133[0]: i2c eeprom 10: 00 00 f0 0f ff 20 ff ff ff ff 
> ff ff ff ff ff ff
> [62176.198278] saa7133[0]: i2c eeprom 20: 01 40 01 02 02 01 01 03 08 ff 
> 00 1d ff ff ff ff
> [62176.198297] saa7133[0]: i2c eeprom 30: ff ff ff ff ff ff ff ff ff ff 
> ff ff ff ff ff ff
> [62176.198317] saa7133[0]: i2c eeprom 40: ff 22 00 c2 96 ff 02 30 15 ff 
> ff ff ff ff ff ff
> [62176.198336] saa7133[0]: i2c eeprom 50: ff ff ff ff ff ff ff ff ff ff 
> ff ff ff ff ff ff
> [62176.198355] saa7133[0]: i2c eeprom 60: ff ff ff ff ff ff ff ff ff ff 
> ff ff ff ff ff ff
> [62176.198375] saa7133[0]: i2c eeprom 70: ff ff ff ff ff ff ff ff ff ff 
> ff ff ff ff ff ff
> [62176.198394] saa7133[0]: i2c eeprom 80: 00 00 00 00 00 00 00 00 00 00 
> 00 00 00 00 00 00
> [62176.198413] saa7133[0]: i2c eeprom 90: 00 00 00 00 00 00 00 00 00 00 
> 00 00 00 00 00 00
> [62176.198431] saa7133[0]: i2c eeprom a0: 00 00 00 00 00 00 00 00 00 00 
> 00 00 00 00 00 00
> [62176.198450] saa7133[0]: i2c eeprom b0: 00 00 00 00 00 00 00 00 00 00 
> 00 00 00 00 00 00
> [62176.198468] saa7133[0]: i2c eeprom c0: 00 00 00 00 00 00 00 00 00 00 
> 00 00 00 00 00 00
> [62176.198487] saa7133[0]: i2c eeprom d0: 00 00 00 00 00 00 00 00 00 00 
> 00 00 00 00 00 00
> [62176.198506] saa7133[0]: i2c eeprom e0: 00 00 00 00 00 00 00 00 00 00 
> 00 00 00 00 00 00
> [62176.198525] saa7133[0]: i2c eeprom f0: 00 00 00 00 00 00 00 00 00 00 
> 00 00 00 00 00 00
> [62176.205219] saa7133[0]: i2c xfer: < 01 ERROR: NO_DEVICE
> [62176.256752] saa7133[0]: i2c xfer: < 97 >
> [62176.261986] saa7133[0]: i2c scan: found device @ 0x96  [???]
> [62176.263991] saa7133[0]: i2c xfer: < a1 >
> [62176.269977] saa7133[0]: i2c scan: found device @ 0xa0  [eeprom]
> [62176.396596] saa7133[0]: i2c xfer: < 96 >
> [62176.552405] saa7133[0]: i2c xfer: < 96 00 >
> [62176.557873] saa7133[0]: i2c xfer: < 97 =01 =01 =00 =11 =01 =04 =01 =85 >
> [62176.565885] saa7133[0]: i2c xfer: < 96 1f >
> [62176.573861] saa7133[0]: i2c xfer: < 97 =89 >
> [62176.582033] tuner' 2-004b: chip found @ 0x96 (saa7133[0])
> [62176.582119] tuner' i2c attach [addr=0x4b,client=tuner']
> [62176.584970] saa7133[0]: i2c xfer: < 96 1f >
> [62176.590368] saa7133[0]: i2c xfer: < 97 =89 >
> [62176.597898] saa7133[0]: i2c xfer: < 96 2f >
> [62176.605849] saa7133[0]: i2c xfer: < 97 =00 >
> [62176.613846] saa7133[0]: i2c xfer: < 96 21 c0 >
> [62176.645840] saa7133[0]: i2c xfer: < c1 ERROR: NO_DEVICE
> [62176.646004] saa7133[0]: i2c xfer: < c3 =88 >
> [62176.653846] saa7133[0]: i2c xfer: < c5 ERROR: NO_DEVICE
> [62176.653994] saa7133[0]: i2c xfer: < c7 ERROR: NO_DEVICE
> [62176.654139] saa7133[0]: i2c xfer: < 96 21 00 >
> [62176.661843] tda829x 2-004b: setting tuner address to 61
> [62176.661851] saa7133[0]: i2c xfer: < 96 21 c0 >
> [62176.693820] saa7133[0]: i2c xfer: < c3 =08 >
> [62176.819741] saa7133[0]: i2c xfer: < c3 =08 >
> [62176.826892] saa7133[0]: i2c xfer: < c2 30 90 >
> [62176.833826] saa7133[0]: i2c xfer: < 96 21 00 >
> [62176.841767] tda829x 2-004b: type set to tda8290+75a
> [62176.841775] saa7133[0]: i2c xfer: < 96 21 c0 >
> [62176.873758] saa7133[0]: i2c xfer: < c2 00 00 00 00 dc 05 8b 0c 04 20 
> ff 00 00 4b >
> [62176.881760] saa7133[0]: i2c xfer: < 96 21 00 >
> [62176.889760] saa7133[0]: i2c xfer: < 96 20 0b >
> [62176.897747] saa7133[0]: i2c xfer: < 96 30 6f >
> [62176.905802] saa7133[0]: i2c xfer: < 96 01 00 >
> [62176.913754] saa7133[0]: i2c xfer: < 96 02 00 >
> [62176.921748] saa7133[0]: i2c xfer: < 96 00 00 >
> [62176.937727] saa7133[0]: i2c xfer: < 96 01 90 >
> [62176.945729] saa7133[0]: i2c xfer: < 96 28 14 >
> [62176.953739] saa7133[0]: i2c xfer: < 96 0f 88 >
> [62176.961734] saa7133[0]: i2c xfer: < 96 05 04 >
> [62176.969713] saa7133[0]: i2c xfer: < 96 0d 47 >
> [62176.977729] saa7133[0]: i2c xfer: < 96 21 c0 >
> [62177.025700] saa7133[0]: i2c xfer: < c2 00 32 f8 00 16 3b bb 1c 04 20 00 >
> [62177.033742] saa7133[0]: i2c xfer: < c2 90 ff e0 00 99 >
> [62177.041706] saa7133[0]: i2c xfer: < c2 a0 c0 >
> [62177.049704] saa7133[0]: i2c xfer: < c2 30 10 >
> [62177.057700] saa7133[0]: i2c xfer: < c3 =09 =a9 >
> [62177.171912] saa7133[0]: i2c xfer: < c2 60 3c >
> [62177.347113] saa7133[0]: i2c xfer: < c2 50 bf >
> [62177.353605] saa7133[0]: i2c xfer: < c2 80 28 >
> [62177.361589] saa7133[0]: i2c xfer: < c2 b0 01 >
> [62177.369585] saa7133[0]: i2c xfer: < c2 c0 19 >
> [62177.377593] saa7133[0]: i2c xfer: < 96 1b >
> [62177.385591] saa7133[0]: i2c xfer: < 97 =63 >
> [62177.497545] saa7133[0]: i2c xfer: < 96 1b >
> [62177.505546] saa7133[0]: i2c xfer: < 97 =5b >
> [62177.617523] saa7133[0]: i2c xfer: < 96 1b >
> [62177.628981] saa7133[0]: i2c xfer: < 97 =52 >
> [62177.737477] saa7133[0]: i2c xfer: < 96 28 64 >
> [62177.849471] saa7133[0]: i2c xfer: < 96 1d >
> [62177.857421] saa7133[0]: i2c xfer: < 97 =ba >
> [62177.865417] saa7133[0]: i2c xfer: < 96 1b >
> [62177.873409] saa7133[0]: i2c xfer: < 97 =43 >
> [62177.881419] saa7133[0]: i2c xfer: < c2 80 2c >
> [62177.993382] saa7133[0]: i2c xfer: < 96 1d >
> [62178.001370] saa7133[0]: i2c xfer: < 97 =56 >
> [62178.009370] saa7133[0]: i2c xfer: < 96 1b >
> [62178.017363] saa7133[0]: i2c xfer: < 97 =3b >
> [62178.028948] saa7133[0]: i2c xfer: < 96 05 01 >
> [62178.037368] saa7133[0]: i2c xfer: < 96 0d 27 >
> [62178.149310] saa7133[0]: i2c xfer: < 96 21 00 >
> [62178.157316] saa7133[0]: i2c xfer: < 96 0f 81 >
> [62178.165545] saa7133[0]: i2c xfer: < 96 01 10 >
> [62178.173506] saa7133[0]: i2c xfer: < 96 02 00 >
> [62178.181511] saa7133[0]: i2c xfer: < 96 00 00 >
> [62178.197421] saa7133[0]: i2c xfer: < 96 01 82 >
> [62178.205686] saa7133[0]: i2c xfer: < 96 28 14 >
> [62178.213507] saa7133[0]: i2c xfer: < 96 0f 88 >
> [62178.221498] saa7133[0]: i2c xfer: < 96 05 04 >
> [62178.229748] saa7133[0]: i2c xfer: < 96 0d 47 >
> [62178.237500] saa7133[0]: i2c xfer: < 96 21 c0 >
> [62178.285268] saa7133[0]: i2c xfer: < c2 00 32 d8 00 16 3b bb 1c 04 20 00 >
> [62178.293471] saa7133[0]: i2c xfer: < c2 90 ff e0 00 99 >
> [62178.301473] saa7133[0]: i2c xfer: < c2 a0 c0 >
> [62178.309464] saa7133[0]: i2c xfer: < c2 30 10 >
> [62178.317468] saa7133[0]: i2c xfer: < c3 =09 =a9 >
> [62178.429343] saa7133[0]: i2c xfer: < c2 60 3c >
> [62178.605177] saa7133[0]: i2c xfer: < c2 50 bf >
> [62178.613414] saa7133[0]: i2c xfer: < c2 80 28 >
> [62178.621352] saa7133[0]: i2c xfer: < c2 b0 01 >
> [62178.629612] saa7133[0]: i2c xfer: < c2 c0 19 >
> [62178.637353] saa7133[0]: i2c xfer: < 96 1b >
> [62178.645341] saa7133[0]: i2c xfer: < 97 =5e >
> [62178.757099] saa7133[0]: i2c xfer: < 96 1b >
> [62178.765454] saa7133[0]: i2c xfer: < 97 =56 >
> [62178.877057] saa7133[0]: i2c xfer: < 96 1b >
> [62178.885426] saa7133[0]: i2c xfer: < 97 =4c >
> [62178.997008] saa7133[0]: i2c xfer: < 96 28 64 >
> [62179.108975] saa7133[0]: i2c xfer: < 96 1d >
> [62179.117349] saa7133[0]: i2c xfer: < 97 =bb >
> [62179.125273] saa7133[0]: i2c xfer: < 96 1b >
> [62179.133298] saa7133[0]: i2c xfer: < 97 =37 >
> [62179.141152] saa7133[0]: i2c xfer: < c2 80 2c >
> [62179.252930] saa7133[0]: i2c xfer: < 96 1d >
> [62179.261338] saa7133[0]: i2c xfer: < 97 =56 >
> [62179.269197] saa7133[0]: i2c xfer: < 96 1b >
> [62179.277155] saa7133[0]: i2c xfer: < 97 =2e >
> [62179.285110] saa7133[0]: i2c xfer: < 96 05 01 >
> [62179.293107] saa7133[0]: i2c xfer: < 96 0d 27 >
> [62179.404866] saa7133[0]: i2c xfer: < 96 21 00 >
> [62179.413258] saa7133[0]: i2c xfer: < 96 0f 81 >
> [62179.421301] saa7133[0]: i2c xfer: < 96 01 02 >
> [62179.429301] saa7133[0]: i2c xfer: < 96 02 00 >
> [62179.437068] saa7133[0]: i2c xfer: < 96 00 00 >
> [62179.452851] saa7133[0]: i2c xfer: < 96 01 82 >
> [62179.461053] saa7133[0]: i2c xfer: < 96 28 14 >
> [62179.469051] saa7133[0]: i2c xfer: < 96 0f 88 >
> [62179.477047] saa7133[0]: i2c xfer: < 96 05 04 >
> [62179.485045] saa7133[0]: i2c xfer: < 96 0d 47 >
> [62179.493033] saa7133[0]: i2c xfer: < 96 21 c0 >
> [62179.540818] saa7133[0]: i2c xfer: < c2 00 32 d8 00 16 3b bb 1c 04 20 00 >
> [62179.549018] saa7133[0]: i2c xfer: < c2 90 ff e0 00 99 >
> [62179.557020] saa7133[0]: i2c xfer: < c2 a0 c0 >
> [62179.565016] saa7133[0]: i2c xfer: < c2 30 10 >
> [62179.573014] saa7133[0]: i2c xfer: < c3 =09 =a9 >
> [62179.684781] saa7133[0]: i2c xfer: < c2 60 3c >
> [62179.860715] saa7133[0]: i2c xfer: < c2 50 bf >
> [62179.869082] saa7133[0]: i2c xfer: < c2 80 28 >
> [62179.876913] saa7133[0]: i2c xfer: < c2 b0 01 >
> [62179.884902] saa7133[0]: i2c xfer: < c2 c0 19 >
> [62179.892902] saa7133[0]: i2c xfer: < 96 1b >
> [62179.900893] saa7133[0]: i2c xfer: < 97 =60 >
> [62180.012661] saa7133[0]: i2c xfer: < 96 1b >
> [62180.021035] saa7133[0]: i2c xfer: < 97 =58 >
> [62180.132736] saa7133[0]: i2c xfer: < 96 1b >
> [62180.140954] saa7133[0]: i2c xfer: < 97 =4e >
> [62180.252580] saa7133[0]: i2c xfer: < 96 28 64 >
> [62180.364540] saa7133[0]: i2c xfer: < 96 1d >
> [62180.372917] saa7133[0]: i2c xfer: < 97 =bb >
> [62180.380735] saa7133[0]: i2c xfer: < 96 1b >
> [62180.388745] saa7133[0]: i2c xfer: < 97 =3b >
> [62180.396718] saa7133[0]: i2c xfer: < c2 80 2c >
> [62180.508482] saa7133[0]: i2c xfer: < 96 1d >
> [62180.516861] saa7133[0]: i2c xfer: < 97 =56 >
> [62180.524679] saa7133[0]: i2c xfer: < 96 1b >
> [62180.532675] saa7133[0]: i2c xfer: < 97 =3b >
> [62180.540670] saa7133[0]: i2c xfer: < 96 05 01 >
> [62180.548661] saa7133[0]: i2c xfer: < 96 0d 27 >
> [62180.660431] saa7133[0]: i2c xfer: < 96 21 00 >
> [62180.668798] saa7133[0]: i2c xfer: < 96 0f 81 >
> [62180.676922] saa7133[0]/audio: tvaudio thread scan start [1]
> [62180.676934] saa7133[0]/audio: scanning: B/G D/K I
> [62180.696144] saa7133[0]: registered device video0 [v4l2]
> [62180.697350] saa7133[0]: registered device vbi0
> [62180.697899] saa7133[0]: i2c xfer: < 96 21 c0 >
> [62180.732390] saa7133[0]: i2c xfer: < c2 30 90 >
> [62180.740387] saa7133[0]: i2c xfer: < 96 21 00 >
> [62180.748902] saa7133[0]: i2c xfer: < 96 02 20 >
> [62180.756375] saa7133[0]: i2c xfer: < 96 00 02 >
> [62180.879535] saa7134_alsa: disagrees about version of symbol 
> saa7134_tvaudio_setmute
> [62180.879557] saa7134_alsa: Unknown symbol saa7134_tvaudio_setmute
> [62180.879990] saa7134_alsa: disagrees about version of symbol 
> saa_dsp_writel
> [62180.879997] saa7134_alsa: Unknown symbol saa_dsp_writel
> [62180.880506] saa7134_alsa: disagrees about version of symbol 
> videobuf_dma_free
> [62180.880513] saa7134_alsa: Unknown symbol videobuf_dma_free
> [62180.881001] saa7134_alsa: disagrees about version of symbol 
> saa7134_pgtable_alloc
> [62180.881008] saa7134_alsa: Unknown symbol saa7134_pgtable_alloc
> [62180.881118] saa7134_alsa: disagrees about version of symbol 
> saa7134_pgtable_build
> [62180.881125] saa7134_alsa: Unknown symbol saa7134_pgtable_build
> [62180.881218] saa7134_alsa: disagrees about version of symbol 
> saa7134_pgtable_free
> [62180.881225] saa7134_alsa: Unknown symbol saa7134_pgtable_free
> [62180.881320] saa7134_alsa: disagrees about version of symbol 
> saa7134_dmasound_init
> [62180.881327] saa7134_alsa: Unknown symbol saa7134_dmasound_init
> [62180.881682] saa7134_alsa: disagrees about version of symbol 
> saa7134_dmasound_exit
> [62180.881689] saa7134_alsa: Unknown symbol saa7134_dmasound_exit
> [62180.881937] saa7134_alsa: disagrees about version of symbol 
> videobuf_dma_init
> [62180.881943] saa7134_alsa: Unknown symbol videobuf_dma_init
> [62180.882322] saa7134_alsa: disagrees about version of symbol 
> videobuf_dma_init_kernel
> [62180.882329] saa7134_alsa: Unknown symbol videobuf_dma_init_kernel
> [62180.882668] saa7134_alsa: Unknown symbol videobuf_pci_dma_unmap
> [62180.883065] saa7134_alsa: Unknown symbol videobuf_pci_dma_map
> [62180.883176] saa7134_alsa: disagrees about version of symbol 
> saa7134_set_dmabits
> [62180.883183] saa7134_alsa: Unknown symbol saa7134_set_dmabits
> [62180.995598] saa7133[0]: i2c xfer: < 96 01 02 >
> [62181.012389] saa7133[0]: i2c xfer: < 96 02 00 >
> [62181.020713] saa7133[0]: i2c xfer: < 96 00 00 >
> [62181.036851] saa7133[0]: i2c xfer: < 96 01 82 >
> [62181.044320] saa7133[0]: i2c xfer: < 96 28 14 >
> [62181.052315] saa7133[0]: i2c xfer: < 96 0f 88 >
> [62181.060277] saa7133[0]: i2c xfer: < 96 05 04 >
> [62181.068282] saa7133[0]: i2c xfer: < 96 0d 47 >
> [62181.076277] saa7133[0]: i2c xfer: < 96 21 c0 >
> [62181.124245] saa7133[0]: i2c xfer: < c2 00 32 d8 00 16 3b bb 1c 04 20 00 >
> [62181.132375] saa7133[0]: i2c xfer: < c2 90 ff e0 00 99 >
> [62181.140255] saa7133[0]: i2c xfer: < c2 a0 c0 >
> [62181.148254] saa7133[0]: i2c xfer: < c2 30 10 >
> [62181.156245] saa7133[0]: i2c xfer: < c3 =09 =a9 >
> [62181.268220] saa7133[0]: i2c xfer: < c2 60 3c >
> [62181.444164] saa7133[0]: i2c xfer: < c2 50 bf >
> [62181.452145] saa7133[0]: i2c xfer: < c2 80 28 >
> [62181.460150] saa7133[0]: i2c xfer: < c2 b0 01 >
> [62181.468144] saa7133[0]: i2c xfer: < c2 c0 19 >
> [62181.476141] saa7133[0]: i2c xfer: < 96 1b >
> [62181.484142] saa7133[0]: i2c xfer: < 97 =5e >
> [62181.596117] saa7133[0]: i2c xfer: < 96 1b >
> [62181.604089] saa7133[0]: i2c xfer: < 97 =56 >
> [62181.716070] saa7133[0]: i2c xfer: < 96 1b >
> [62181.724055] saa7133[0]: i2c xfer: < 97 =4c >
> [62181.836040] saa7133[0]: i2c xfer: < 96 28 64 >
> [62181.947974] saa7133[0]: i2c xfer: < 96 1d >
> [62181.955952] saa7133[0]: i2c xfer: < 97 =ba >
> [62181.964179] saa7133[0]: i2c xfer: < 96 1b >
> [62181.972168] saa7133[0]: i2c xfer: < 97 =3a >
> [62181.980162] saa7133[0]: i2c xfer: < c2 80 2c >
> [62182.091930] saa7133[0]: i2c xfer: < 96 1d >
> [62182.100302] saa7133[0]: i2c xfer: < 97 =56 >
> [62182.108135] saa7133[0]: i2c xfer: < 96 1b >
> [62182.116744] saa7133[0]: i2c xfer: < 97 =3d >
> [62182.130111] saa7133[0]: i2c xfer: < 96 05 01 >
> [62182.140342] saa7133[0]: i2c xfer: < 96 0d 27 >
> [62182.255866] saa7133[0]: i2c xfer: < 96 21 00 >
> [62182.264831] saa7133[0]: i2c xfer: < 96 0f 81 >
> [62182.277256] saa7133[0]: i2c xfer: < 96 21 c0 >
> [62182.307843] saa7133[0]: i2c xfer: < c2 30 90 >
> [62182.315843] saa7133[0]: i2c xfer: < 96 21 00 >
> [62182.325960] saa7133[0]: i2c xfer: < 96 02 20 >
> [62182.331848] saa7133[0]: i2c xfer: < 96 00 02 >
> [62182.557506] saa7133[0]: i2c xfer: < 96 01 02 >
> [62182.567606] saa7133[0]: i2c xfer: < 96 02 00 >
> [62182.576148] saa7133[0]: i2c xfer: < 96 00 00 >
> [62182.592391] saa7133[0]: i2c xfer: < 96 01 82 >
> [62182.599776] saa7133[0]: i2c xfer: < 96 28 14 >
> [62182.607740] saa7133[0]: i2c xfer: < 96 0f 88 >
> [62182.615731] saa7133[0]: i2c xfer: < 96 05 04 >
> [62182.623732] saa7133[0]: i2c xfer: < 96 0d 47 >
> [62182.631871] saa7133[0]: i2c xfer: < 96 21 c0 >
> [62182.679704] saa7133[0]: i2c xfer: < c2 00 32 d8 00 16 3b bb 1c 04 20 00 >
> [62182.687712] saa7133[0]: i2c xfer: < c2 90 ff e0 00 99 >
> [62182.695738] saa7133[0]: i2c xfer: < c2 a0 c0 >
> [62182.703714] saa7133[0]: i2c xfer: < c2 30 10 >
> [62182.711690] saa7133[0]: i2c xfer: < c3 =09 =a9 >
> [62182.827310] saa7133[0]: i2c xfer: < c2 60 3c >
> [62183.003605] saa7133[0]: i2c xfer: < c2 50 bf >
> [62183.011589] saa7133[0]: i2c xfer: < c2 80 28 >
> [62183.019599] saa7133[0]: i2c xfer: < c2 b0 01 >
> [62183.027625] saa7133[0]: i2c xfer: < c2 c0 19 >
> [62183.035598] saa7133[0]: i2c xfer: < 96 1b >
> [62183.043590] saa7133[0]: i2c xfer: < 97 =5e >
> [62183.155545] saa7133[0]: i2c xfer: < 96 1b >
> [62183.163545] saa7133[0]: i2c xfer: < 97 =56 >
> [62183.275509] saa7133[0]: i2c xfer: < 96 1b >
> [62183.283503] saa7133[0]: i2c xfer: < 97 =4c >
> [62183.395485] saa7133[0]: i2c xfer: < 96 28 64 >
> [62183.507432] saa7133[0]: i2c xfer: < 96 1d >
> [62183.515424] saa7133[0]: i2c xfer: < 97 =c0 >
> [62183.523426] saa7133[0]: i2c xfer: < 96 1b >
> [62183.531419] saa7133[0]: i2c xfer: < 97 =41 >
> [62183.539421] saa7133[0]: i2c xfer: < c2 80 2c >
> [62183.651388] saa7133[0]: i2c xfer: < 96 1d >
> [62183.659367] saa7133[0]: i2c xfer: < 97 =5a >
> [62183.667375] saa7133[0]: i2c xfer: < 96 1b ><7>saa7133[0]/audio: 
> tvaudio thread status: 0x100000 [no standard detected]
> [62183.675388] saa7133[0]/audio: detailed status: ############# init done
> [62183.676168]
> [62183.676178] saa7133[0]: i2c xfer: < 97 =3b >
> [62183.683370] saa7133[0]: i2c xfer: < 96 05 01 >
> [62183.691557] saa7133[0]: i2c xfer: < 96 0d 27 >
> [62183.803329] saa7133[0]: i2c xfer: < 96 21 00 >
> [62183.811664] saa7133[0]: i2c xfer: < 96 0f 81 >
> [62183.829485] saa7133[0]: i2c xfer: < 96 21 c0 >
> [62183.859298] saa7133[0]: i2c xfer: < c2 30 90 >
> [62183.867520] saa7133[0]: i2c xfer: < 96 21 00 >
> [62183.875566] saa7133[0]: i2c xfer: < 96 02 20 >
> [62183.883498] saa7133[0]: i2c xfer: < 96 00 02 >
> 
> tvtime-scanner finds no channels, not in PAL, nor SECAM or NTSC mode....
> 
> Any suggestions?
> 

Initialization and read/write traffic to the tda8275a and from the
tda8290 analog IF demodulator looks ok.

As said, a next question is, if it has a separate radio antenna input.

Most cards switch the antenna input and AGC on gpio21 then.
Examples are card=65, 81 or 78, with swapped switching some LifeView
cards, keeping gpio21 high for TV input and low for radio.

Card=78 has a second female antenna connector, which is also used for
radio and DVB-T, card=81 has a normal male second connector for radio
only and shares analog TV and DVB-T input on the same single female
connector. See also saa7134-dvb.c for switching.

If you enable debug=1 for tuner, the tda8275a reports "lock" on found
channels. You might see still a black picture only, even with tvtime's
signal detection disabled and correct antenna input set.

Then in a next step try an other vmux on the saa713x for TV.
If the most common vmux = 1 still fails, next popular is vmux = 3 for
TV, but it can be also 0, 2 and 4.

Good luck,
Hermann




--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
