Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m7J2K8bA027038
	for <video4linux-list@redhat.com>; Mon, 18 Aug 2008 22:20:08 -0400
Received: from mail-in-11.arcor-online.net (mail-in-11.arcor-online.net
	[151.189.21.51])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m7J2Jh3B025579
	for <video4linux-list@redhat.com>; Mon, 18 Aug 2008 22:19:44 -0400
Received: from mail-in-07-z2.arcor-online.net (mail-in-07-z2.arcor-online.net
	[151.189.8.19])
	by mail-in-11.arcor-online.net (Postfix) with ESMTP id 3133720909C
	for <video4linux-list@redhat.com>;
	Tue, 19 Aug 2008 04:19:43 +0200 (CEST)
Received: from mail-in-17.arcor-online.net (mail-in-17.arcor-online.net
	[151.189.21.57])
	by mail-in-07-z2.arcor-online.net (Postfix) with ESMTP id 180BE2C6BAC
	for <video4linux-list@redhat.com>;
	Tue, 19 Aug 2008 04:19:43 +0200 (CEST)
Received: from [192.168.0.10] (181.126.46.212.adsl.ncore.de [212.46.126.181])
	(Authenticated sender: hermann-pitton@arcor.de)
	by mail-in-17.arcor-online.net (Postfix) with ESMTP id 20A672BCC2B
	for <video4linux-list@redhat.com>;
	Tue, 19 Aug 2008 04:19:42 +0200 (CEST)
From: hermann pitton <hermann-pitton@arcor.de>
To: video4linux-list@redhat.com
In-Reply-To: <48A99EB1.3030707@atfichtner.de>
References: <48A99EB1.3030707@atfichtner.de>
Content-Type: text/plain
Date: Tue, 19 Aug 2008 04:18:49 +0200
Message-Id: <1219112329.4107.8.camel@pc10.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
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

Hi,

Am Montag, den 18.08.2008, 18:09 +0200 schrieb A. Fichtner: 
> Hello!
> 
> I have some trouble to get my new TV-Card installed.
> 
> The documentation says it has a philips *tda8275a, tda8290 new silicon 
> tuner*
> google means that it is a hybrid card.
> 
> dmesg says the following:
> [ 8847.678136] pccard: CardBus card inserted into slot 0
> [ 8847.678260] yenta EnE: chaning testregister 0xC9, 44 -> 44
> [ 3538.107500] saa7130/34: v4l2 driver version 0.2.14 loaded
> [ 3538.107990] PCI: Enabling device 0000:02:00.0 (0000 -> 0002)
> [ 3538.108259] ACPI: PCI Interrupt 0000:02:00.0[A] -> Link [LNKB] -> GSI 
> 11 (level, low) -> IRQ 11
> [ 3538.108273] saa7133[0]: found at 0000:02:00.0, rev: 16, irq: 11, 
> latency: 0, mmio: 0x34000000
> [ 3538.108282] PCI: Setting latency timer of device 0000:02:00.0 to 64
> [ 3538.108288] saa7133[0]: subsystem: 1132:2004, board: UNKNOWN/GENERIC 
> [card=0,autodetected]
> [ 3538.108301] saa7133[0]: board init: gpio is 0
> [ 3538.108310] saa7133[0]: gpio: mode=0x0000000 in=0x0000000 
> out=0x0000000 [pre-init]
> [ 3538.210612] saa7133[0]: i2c xfer: < 20 ERROR: NO_DEVICE
> [ 3538.211153] saa7133[0]: i2c xfer: < 84 ERROR: NO_DEVICE
> [ 3538.211474] saa7133[0]: i2c xfer: < 86 ERROR: NO_DEVICE
> [ 3538.211791] saa7133[0]: i2c xfer: < 94 ERROR: NO_DEVICE
> [ 3538.212160] saa7133[0]: i2c xfer: < 96 >
> [ 3538.218890] saa7133[0]: i2c xfer: < 96 00 >
> [ 3538.226599] saa7133[0]: i2c xfer: < 97 =01 =01 =00 =11 =01 =04 =01 =85 >
> [ 3538.234599] saa7133[0]: i2c xfer: < 96 1f >
> [ 3538.242589] saa7133[0]: i2c xfer: < 97 =89 >
> [ 3538.250532] tuner' 2-004b: chip found @ 0x96 (saa7133[0])
> [ 3538.250812] tuner' i2c attach [addr=0x4b,client=tuner']
> [ 3538.250986] saa7133[0]: i2c xfer: < c0 ERROR: NO_DEVICE
> .
> .
> .
> [ 3538.255805] saa7133[0]: i2c xfer: < de ERROR: NO_DEVICE
> [ 3538.256145] saa7133[0]: i2c xfer: < a0 00 >
> [ 3538.262577] saa7133[0]: i2c xfer: < a1 =32 =11 =04 =20 =54 =20 =1c 
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
> [ 3538.302466] saa7133[0]: i2c eeprom 00: 32 11 04 20 54 20 1c 00 43 43 
> a9 1c 55 d2 b2 92
> [ 3538.302478] saa7133[0]: i2c eeprom 10: 00 00 f0 0f ff 20 ff ff ff ff 
> ff ff ff ff ff ff
> [ 3538.302486] saa7133[0]: i2c eeprom 20: 01 40 01 02 02 01 01 03 08 ff 
> 00 1d ff ff ff ff
> [ 3538.302494] saa7133[0]: i2c eeprom 30: ff ff ff ff ff ff ff ff ff ff 
> ff ff ff ff ff ff
> [ 3538.302502] saa7133[0]: i2c eeprom 40: ff 22 00 c2 96 ff 02 30 15 ff 
> ff ff ff ff ff ff
> [ 3538.302510] saa7133[0]: i2c eeprom 50: ff ff ff ff ff ff ff ff ff ff 
> ff ff ff ff ff ff
> [ 3538.302518] saa7133[0]: i2c eeprom 60: ff ff ff ff ff ff ff ff ff ff 
> ff ff ff ff ff ff
> [ 3538.302525] saa7133[0]: i2c eeprom 70: ff ff ff ff ff ff ff ff ff ff 
> ff ff ff ff ff ff
> [ 3538.302533] saa7133[0]: i2c eeprom 80: 00 00 00 00 00 00 00 00 00 00 
> 00 00 00 00 00 00
> [ 3538.302541] saa7133[0]: i2c eeprom 90: 00 00 00 00 00 00 00 00 00 00 
> 00 00 00 00 00 00
> [ 3538.302548] saa7133[0]: i2c eeprom a0: 00 00 00 00 00 00 00 00 00 00 
> 00 00 00 00 00 00
> [ 3538.302555] saa7133[0]: i2c eeprom b0: 00 00 00 00 00 00 00 00 00 00 
> 00 00 00 00 00 00
> [ 3538.302563] saa7133[0]: i2c eeprom c0: 00 00 00 00 00 00 00 00 00 00 
> 00 00 00 00 00 00
> [ 3538.302570] saa7133[0]: i2c eeprom d0: 00 00 00 00 00 00 00 00 00 00 
> 00 00 00 00 00 00
> [ 3538.302578] saa7133[0]: i2c eeprom e0: 00 00 00 00 00 00 00 00 00 00 
> 00 00 00 00 00 00
> [ 3538.302585] saa7133[0]: i2c eeprom f0: 00 00 00 00 00 00 00 00 00 00 
> 00 00 00 00 00 00
> [ 3538.305263] saa7133[0]: i2c xfer: < 01 ERROR: NO_DEVICE
> .
> .
> .
> [ 3538.328512] saa7133[0]: i2c xfer: < 95 ERROR: NO_DEVICE
> [ 3538.328825] saa7133[0]: i2c xfer: < 97 >
> [ 3538.334431] saa7133[0]: i2c scan: found device @ 0x96  [???]
> [ 3538.334681] saa7133[0]: i2c xfer: < 99 ERROR: NO_DEVICE
> [ 3538.334996] saa7133[0]: i2c xfer: < 9b ERROR: NO_DEVICE
> [ 3538.335307] saa7133[0]: i2c xfer: < 9d ERROR: NO_DEVICE
> [ 3538.335620] saa7133[0]: i2c xfer: < 9f ERROR: NO_DEVICE
> [ 3538.335932] saa7133[0]: i2c xfer: < a1 >
> [ 3538.342422] saa7133[0]: i2c scan: found device @ 0xa0  [eeprom]
> [ 3538.342645] saa7133[0]: i2c xfer: < a3 ERROR: NO_DEVICE
> .
> .
> .
> [ 3538.357086] saa7133[0]: i2c xfer: < ff ERROR: NO_DEVICE
> [ 3538.357656] saa7133[0]/audio: sound IF not in use, skipping scan
> [ 3538.382884] saa7133[0]: registered device video0 [v4l2]
> [ 3538.383483] saa7133[0]: registered device vbi0
> [ 3538.474259] saa7134_alsa: disagrees about version of symbol 
> saa7134_tvaudio_setmute
> [ 3538.474273] saa7134_alsa: Unknown symbol saa7134_tvaudio_setmute
> [ 3538.474550] saa7134_alsa: disagrees about version of symbol 
> saa_dsp_writel
> [ 3538.474554] saa7134_alsa: Unknown symbol saa_dsp_writel
> [ 3538.474739] saa7134_alsa: disagrees about version of symbol 
> videobuf_dma_free
> [ 3538.474742] saa7134_alsa: Unknown symbol videobuf_dma_free
> [ 3538.474945] saa7134_alsa: disagrees about version of symbol 
> saa7134_pgtable_alloc
> [ 3538.474948] saa7134_alsa: Unknown symbol saa7134_pgtable_alloc
> [ 3538.474992] saa7134_alsa: disagrees about version of symbol 
> saa7134_pgtable_build
> [ 3538.474994] saa7134_alsa: Unknown symbol saa7134_pgtable_build
> [ 3538.475031] saa7134_alsa: disagrees about version of symbol 
> saa7134_pgtable_free
> [ 3538.475035] saa7134_alsa: Unknown symbol saa7134_pgtable_free
> [ 3538.475072] saa7134_alsa: disagrees about version of symbol 
> saa7134_dmasound_init
> [ 3538.475075] saa7134_alsa: Unknown symbol saa7134_dmasound_init
> [ 3538.475221] saa7134_alsa: disagrees about version of symbol 
> saa7134_dmasound_exit
> [ 3538.475224] saa7134_alsa: Unknown symbol saa7134_dmasound_exit
> [ 3538.475327] saa7134_alsa: disagrees about version of symbol 
> videobuf_dma_init
> [ 3538.475330] saa7134_alsa: Unknown symbol videobuf_dma_init
> [ 3538.475488] saa7134_alsa: disagrees about version of symbol 
> videobuf_dma_init_kernel
> [ 3538.475491] saa7134_alsa: Unknown symbol videobuf_dma_init_kernel
> [ 3538.475646] saa7134_alsa: Unknown symbol videobuf_pci_dma_unmap
> [ 3538.475810] saa7134_alsa: Unknown symbol videobuf_pci_dma_map
> [ 3538.475854] saa7134_alsa: disagrees about version of symbol 
> saa7134_set_dmabits
> [ 3538.475857] saa7134_alsa: Unknown symbol saa7134_set_dmabits
> 
> 
> "lsmod |grep saa" says the following:
> 
> saa7134               148052  0
> tveeprom               13444  1 saa7134
> ir_common              42244  1 saa7134
> videodev               36864  2 saa7134,tuner
> compat_ioctl32          2304  1 saa7134
> v4l2_common            13952  2 saa7134,tuner
> videobuf_dma_sg        14980  1 saa7134
> videobuf_core          19716  3 saa7134,videobuf_dvb,videobuf_dma_sg
> i2c_core               24832  11 
> saa7134,tda1004x,tda827x,tda8290,tveeprom,tuner_simple,tuner,v4l2_common,i2c_viapro,i2c_prosavage,i2c_algo_bit
> 
> 
> Windows-Driver:
> Named as "Philips SAA713x BDA Capture Driver"
> 
> Can anyone give me a suggestion what drivers i need to load? What card= 
> - insmod options can work?

the saa7134 is correct and you likely might get it to work.

A good and simple start is to test with card=39 tuner=54.

If it has a radio antenna input too, card=65 tuner=54 might be
close.

>From the i2c scan and from the eeprom it seems not to have a digital
channel decoder.

For testing sound you need saa7134-alsa in a proper state.

You can read here and on other places how you might achieve that.
http://www.linuxtv.org/pipermail/linux-dvb/2008-August/027910.html

You can also find something about how to use it then on the v4l wiki at
linuxtv.org.

The saa713x chips have two possible clocks/xtals for the audio.
Try README.saa7134 and "modinfo saa7134".

With the saa7134 option audio_clock_override= you can change the cards
defaults. Card=39 has 0x00200000 and card=65 the other possible value of
0x00187de7. A wrong clock produces noise only.

Have a look at saa7134-cards.c and saa7134.h for known other cards and
different configurations with tuner=54. In case it should have radio,
some switch the other way round.

On many cardbus devices the power for the tuner must be enabled with a
GPIO pin of the saa713x, some also have a fan that needs to be turned
on.

If you don't get a start such easily, you might consider to dig deeper
into it.

Cheers,
Hermann








--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
