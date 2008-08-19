Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m7JErF2n022607
	for <video4linux-list@redhat.com>; Tue, 19 Aug 2008 10:53:15 -0400
Received: from mail-in-05.arcor-online.net (mail-in-05.arcor-online.net
	[151.189.21.45])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m7JEr1Z4009457
	for <video4linux-list@redhat.com>; Tue, 19 Aug 2008 10:53:02 -0400
From: hermann pitton <hermann-pitton@arcor.de>
To: "A. Fichtner" <anfichtner@atfichtner.de>
In-Reply-To: <48AAA89A.5010704@atfichtner.de>
References: <48A99EB1.3030707@atfichtner.de>
	<1219112329.4107.8.camel@pc10.localdom.local>
	<48AA823C.7050300@atfichtner.de>
	<1219139468.2678.30.camel@pc10.localdom.local>
	<48AAA89A.5010704@atfichtner.de>
Content-Type: text/plain
Date: Tue, 19 Aug 2008 16:52:30 +0200
Message-Id: <1219157550.4070.22.camel@pc10.localdom.local>
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


Am Dienstag, den 19.08.2008, 13:03 +0200 schrieb A. Fichtner:
> > Initialization and read/write traffic to the tda8275a and from the
> > tda8290 analog IF demodulator looks ok.
> >
> > As said, a next question is, if it has a separate radio antenna input.
> >
> > Most cards switch the antenna input and AGC on gpio21 then.
> > Examples are card=65, 81 or 78, with swapped switching some LifeView
> > cards, keeping gpio21 high for TV input and low for radio.
> >
> > Card=78 has a second female antenna connector, which is also used for
> > radio and DVB-T, card=81 has a normal male second connector for radio
> > only and shares analog TV and DVB-T input on the same single female
> > connector. See also saa7134-dvb.c for switching.
> >
> > If you enable debug=1 for tuner, the tda8275a reports "lock" on found
> > channels. You might see still a black picture only, even with tvtime's
> > signal detection disabled and correct antenna input set.
> >
> > Then in a next step try an other vmux on the saa713x for TV.
> > If the most common vmux = 1 still fails, next popular is vmux = 3 for
> > TV, but it can be also 0, 2 and 4.
> >
> > Good luck,
> > Hermann
> >
> >   
> 
> Hello again!
> 
> The card has only one female antenna connector. There is also a combined 
> input
> for svideo and composite.
> 
> I've tried card=81 with only takes a long time for scanning for channels 
> but
> dont find one. dmesg output isnt an other.
> 
> i tried card=65, there dmesg will still tell me more as you can see below.
> [ 6532.970222] pccard: CardBus card inserted into slot 0
> [ 6532.970342] yenta EnE: chaning testregister 0xC9, 44 -> 44
> [ 4081.678929] saa7130/34: v4l2 driver version 0.2.14 loaded
> [ 4081.679505] PCI: Enabling device 0000:02:00.0 (0000 -> 0002)
> [ 4081.679800] ACPI: PCI Interrupt 0000:02:00.0[A] -> Link [LNKB] -> GSI 
> 11 (level, low) -> IRQ 11
> [ 4081.679819] saa7133[0]: found at 0000:02:00.0, rev: 16, irq: 11, 
> latency: 0, mmio: 0x34000000
> [ 4081.679829] PCI: Setting latency timer of device 0000:02:00.0 to 64
> [ 4081.679838] saa7133[0]: subsystem: 1132:2004, board: V-Stream Studio 
> TV Terminator [card=65,insmod option]
> [ 4081.679857] saa7133[0]: board init: gpio is 0
> [ 4081.679868] saa7133[0]: gpio: mode=0x0000000 in=0x0000000 
> out=0x0000000 [pre-init]
> [ 4081.681436] input: saa7134 IR (V-Stream Studio TV  as 
> /devices/pci0000:00/0000:00:09.0/0000:02:00.0/input/input11
> [ 4081.810479] saa7133[0]: i2c xfer: < a0 00 >
> [ 4081.818628] saa7133[0]: i2c xfer: < a1 =32 =11 =04 =20 =54 =20 =1c 
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
> [ 4081.858323] saa7133[0]: i2c eeprom 00: 32 11 04 20 54 20 1c 00 43 43 
> a9 1c 55 d2 b2 92
> [ 4081.858338] saa7133[0]: i2c eeprom 10: 00 00 f0 0f ff 20 ff ff ff ff 
> ff ff ff ff ff ff
> [ 4081.858351] saa7133[0]: i2c eeprom 20: 01 40 01 02 02 01 01 03 08 ff 
> 00 1d ff ff ff ff
> [ 4081.858364] saa7133[0]: i2c eeprom 30: ff ff ff ff ff ff ff ff ff ff 
> ff ff ff ff ff ff
> [ 4081.858376] saa7133[0]: i2c eeprom 40: ff 22 00 c2 96 ff 02 30 15 ff 
> ff ff ff ff ff ff
> [ 4081.858389] saa7133[0]: i2c eeprom 50: ff ff ff ff ff ff ff ff ff ff 
> ff ff ff ff ff ff
> [ 4081.858402] saa7133[0]: i2c eeprom 60: ff ff ff ff ff ff ff ff ff ff 
> ff ff ff ff ff ff
> [ 4081.858414] saa7133[0]: i2c eeprom 70: ff ff ff ff ff ff ff ff ff ff 
> ff ff ff ff ff ff
> [ 4081.858427] saa7133[0]: i2c eeprom 80: 00 00 00 00 00 00 00 00 00 00 
> 00 00 00 00 00 00
> [ 4081.858439] saa7133[0]: i2c eeprom 90: 00 00 00 00 00 00 00 00 00 00 
> 00 00 00 00 00 00
> [ 4081.858451] saa7133[0]: i2c eeprom a0: 00 00 00 00 00 00 00 00 00 00 
> 00 00 00 00 00 00
> [ 4081.858463] saa7133[0]: i2c eeprom b0: 00 00 00 00 00 00 00 00 00 00 
> 00 00 00 00 00 00
> [ 4081.858475] saa7133[0]: i2c eeprom c0: 00 00 00 00 00 00 00 00 00 00 
> 00 00 00 00 00 00
> [ 4081.858488] saa7133[0]: i2c eeprom d0: 00 00 00 00 00 00 00 00 00 00 
> 00 00 00 00 00 00
> [ 4081.858500] saa7133[0]: i2c eeprom e0: 00 00 00 00 00 00 00 00 00 00 
> 00 00 00 00 00 00
> [ 4081.858512] saa7133[0]: i2c eeprom f0: 00 00 00 00 00 00 00 00 00 00 
> 00 00 00 00 00 00
> [ 6533.589841] saa7133[0]: i2c xfer: < 97 >
> [ 6533.597908] saa7133[0]: i2c scan: found device @ 0x96  [???]
> [ 6533.600655] saa7133[0]: i2c xfer: < a1 >
> [ 6533.605905] saa7133[0]: i2c scan: found device @ 0xa0  [eeprom]
> [ 6533.695409] saa7133[0]: i2c xfer: < 96 >
> [ 6533.701896] tuner' 2-004b: Setting mode_mask to 0x0e
> [ 6533.701905] tuner' 2-004b: chip found @ 0x96 (saa7133[0])
> [ 6533.701913] tuner' 2-004b: tuner 0x4b: Tuner type absent
> [ 6533.703284] tuner' i2c attach [addr=0x4b,client=tuner']
> [ 6533.712918] tuner' 2-004b: Calling set_type_addr for type=54, 
> addr=0xff, mode=0x0e, config=0x00
> [ 6533.712934] tuner' 2-004b: defining GPIO callback
> [ 6533.713147] saa7133[0]: i2c xfer: < 96 1f >
> [ 6533.717927] saa7133[0]: i2c xfer: < 97 =89 >
> [ 6533.725857] saa7133[0]: i2c xfer: < 96 2f >
> [ 6533.733848] saa7133[0]: i2c xfer: < 97 =00 >
> [ 6533.741857] saa7133[0]: i2c xfer: < 96 21 c0 >
> [ 6533.773830] saa7133[0]: i2c xfer: < c1 ERROR: NO_DEVICE
> [ 6533.773983] saa7133[0]: i2c xfer: < c3 =88 >
> [ 6533.781841] saa7133[0]: i2c xfer: < c5 ERROR: NO_DEVICE
> [ 6533.781989] saa7133[0]: i2c xfer: < c7 ERROR: NO_DEVICE
> [ 6533.782134] saa7133[0]: i2c xfer: < 96 21 00 >
> [ 6533.789838] tda829x 2-004b: setting tuner address to 61
> [ 6533.789846] saa7133[0]: i2c xfer: < 96 21 c0 >
> [ 6533.821817] saa7133[0]: i2c xfer: < c3 =08 >
> [ 6533.830014] saa7133[0]: i2c xfer: < c3 =08 >
> [ 6533.837825] saa7133[0]: i2c xfer: < c2 30 90 >
> [ 6533.845820] saa7133[0]: i2c xfer: < 96 21 00 >
> [ 6533.853818] tda829x 2-004b: type set to tda8290+75a
> [ 6533.853826] saa7133[0]: i2c xfer: < 96 21 c0 >
> [ 6533.885797] saa7133[0]: i2c xfer: < c2 00 00 00 00 dc 05 8b 0c 04 20 
> ff 00 00 4b >
> [ 6533.893796] saa7133[0]: i2c xfer: < 96 21 00 >
> [ 6533.901799] saa7133[0]: i2c xfer: < 96 20 0b >
> [ 6533.909796] saa7133[0]: i2c xfer: < 96 30 6f >
> [ 6533.917793] tuner' 2-004b: type set to tda8290+75a
> [ 6533.917801] tuner' 2-004b: tv freq set to 400.00
> [ 6533.917811] saa7133[0]: i2c xfer: < 96 01 00 >
> [ 6533.925790] saa7133[0]: i2c xfer: < 96 02 00 >
> [ 6533.933788] saa7133[0]: i2c xfer: < 96 00 00 >
> [ 6533.949796] saa7133[0]: i2c xfer: < 96 01 90 >
> [ 6533.957916] saa7133[0]: i2c xfer: < 96 28 14 >
> [ 6533.965776] saa7133[0]: i2c xfer: < 96 0f 88 >
> [ 6533.973766] saa7133[0]: i2c xfer: < 96 05 04 >
> [ 6533.981770] saa7133[0]: i2c xfer: < 96 0d 47 >
> [ 6533.989769] saa7133[0]: i2c xfer: < 96 21 c0 >
> [ 6534.037746] saa7133[0]: i2c xfer: < c2 00 32 f8 00 16 3b bb 1c 04 20 00 >
> [ 6534.045743] saa7133[0]: i2c xfer: < c2 90 ff e0 00 99 >
> [ 6534.053747] saa7133[0]: i2c xfer: < c2 a0 c0 >
> [ 6534.061734] saa7133[0]: i2c xfer: < c2 30 10 >
> [ 6534.069736] saa7133[0]: i2c xfer: < c3 =49 =a9 >
> [ 6534.196961] saa7133[0]: i2c xfer: < c2 60 3c >
> [ 6534.369630] saa7133[0]: i2c xfer: < c2 50 bf >
> [ 6534.377629] saa7133[0]: i2c xfer: < c2 80 28 >
> [ 6534.385632] saa7133[0]: i2c xfer: < c2 b0 01 >
> [ 6534.393629] saa7133[0]: i2c xfer: < c2 c0 19 >
> [ 6534.401615] saa7133[0]: i2c xfer: < 96 1b >
> [ 6534.409622] saa7133[0]: i2c xfer: < 97 =60 >
> [ 6534.521572] saa7133[0]: i2c xfer: < 96 1b >
> [ 6534.529576] saa7133[0]: i2c xfer: < 97 =59 >
> [ 6534.641536] saa7133[0]: i2c xfer: < 96 1b >
> [ 6534.649533] saa7133[0]: i2c xfer: < 97 =50 >
> [ 6534.761532] saa7133[0]: i2c xfer: < 96 21 00 >
> [ 6534.769488] saa7133[0]: i2c xfer: < 96 0f 81 >
> [ 6534.777496] tuner' 2-004b: saa7133[0] tuner' I2C addr 0x96 with type 
> 54 used for 0x0e
> [ 6534.777518] tuner' 2-004b: switching to v4l2
> [ 6534.777528] tuner' 2-004b: tv freq set to 400.00
> [ 6534.777536] saa7133[0]: i2c xfer: < 96 01 10 >
> [ 6534.785477] saa7133[0]: i2c xfer: < 96 02 00 >
> [ 6534.793486] saa7133[0]: i2c xfer: < 96 00 00 >
> [ 6534.809475] saa7133[0]: i2c xfer: < 96 01 82 >
> [ 6534.817492] saa7133[0]: i2c xfer: < 96 28 14 >
> [ 6534.825467] saa7133[0]: i2c xfer: < 96 0f 88 >
> [ 6534.833473] saa7133[0]: i2c xfer: < 96 05 04 >
> [ 6534.841809] saa7133[0]: i2c xfer: < 96 0d 47 >
> [ 6534.849462] saa7133[0]: i2c xfer: < 96 21 c0 >
> [ 6534.897443] saa7133[0]: i2c xfer: < c2 00 32 d8 00 16 3b bb 1c 04 20 00 >
> [ 6534.905444] saa7133[0]: i2c xfer: < c2 90 ff e0 00 99 >
> [ 6534.913444] saa7133[0]: i2c xfer: < c2 a0 c0 >
> [ 6534.921622] saa7133[0]: i2c xfer: < c2 30 10 >
> [ 6534.929451] saa7133[0]: i2c xfer: < c3 =49 =a9 >
> [ 6535.041394] saa7133[0]: i2c xfer: < c2 60 3c >
> [ 6535.217340] saa7133[0]: i2c xfer: < c2 50 bf >
> [ 6535.225328] saa7133[0]: i2c xfer: < c2 80 28 >
> [ 6535.233324] saa7133[0]: i2c xfer: < c2 b0 01 >
> [ 6535.241332] saa7133[0]: i2c xfer: < c2 c0 19 >
> [ 6535.249332] saa7133[0]: i2c xfer: < 96 1b >
> [ 6535.257327] saa7133[0]: i2c xfer: < 97 =7f >
> [ 6535.369306] saa7133[0]: i2c xfer: < 96 1b >
> [ 6535.377274] saa7133[0]: i2c xfer: < 97 =0f >
> [ 6535.489254] saa7133[0]: i2c xfer: < 96 1b >
> [ 6535.497239] saa7133[0]: i2c xfer: < 97 =04 >
> [ 6535.609202] saa7133[0]: i2c xfer: < 96 21 00 >
> [ 6535.617197] saa7133[0]: i2c xfer: < 96 0f 81 >
> [ 6535.625205] tuner' 2-004b: tv freq set to 400.00
> [ 6535.625214] saa7133[0]: i2c xfer: < 96 01 02 >
> [ 6535.633194] saa7133[0]: i2c xfer: < 96 02 00 >
> [ 6535.641193] saa7133[0]: i2c xfer: < 96 00 00 >
> [ 6535.657183] saa7133[0]: i2c xfer: < 96 01 82 >
> [ 6535.665179] saa7133[0]: i2c xfer: < 96 28 14 >
> [ 6535.673178] saa7133[0]: i2c xfer: < 96 0f 88 >
> [ 6535.681177] saa7133[0]: i2c xfer: < 96 05 04 >
> [ 6535.689330] saa7133[0]: i2c xfer: < 96 0d 47 >
> [ 6535.697180] saa7133[0]: i2c xfer: < 96 21 c0 >
> [ 6535.745166] saa7133[0]: i2c xfer: < c2 00 32 d8 00 16 3b bb 1c 04 20 00 >
> [ 6535.753446] saa7133[0]: i2c xfer: < c2 90 ff e0 00 99 >
> [ 6535.761400] saa7133[0]: i2c xfer: < c2 a0 c0 >
> [ 6535.769349] saa7133[0]: i2c xfer: < c2 30 10 >
> [ 6535.777339] saa7133[0]: i2c xfer: < c3 =49 =a9 >
> [ 6535.889102] saa7133[0]: i2c xfer: < c2 60 3c >
> [ 6536.065035] saa7133[0]: i2c xfer: < c2 50 bf >
> [ 6536.073426] saa7133[0]: i2c xfer: < c2 80 28 >
> [ 6536.081248] saa7133[0]: i2c xfer: < c2 b0 01 >
> [ 6536.089238] saa7133[0]: i2c xfer: < c2 c0 19 >
> [ 6536.097235] saa7133[0]: i2c xfer: < 96 1b >
> [ 6536.105231] saa7133[0]: i2c xfer: < 97 =72 >
> [ 6536.217004] saa7133[0]: i2c xfer: < 96 1b >
> [ 6536.225346] saa7133[0]: i2c xfer: < 97 =75 >
> [ 6536.336943] saa7133[0]: i2c xfer: < 96 1b >
> [ 6536.345325] saa7133[0]: i2c xfer: < 97 =6d >
> [ 6536.456911] saa7133[0]: i2c xfer: < 96 21 00 >
> [ 6536.465224] saa7133[0]: i2c xfer: < 96 0f 81 >
> [ 6536.473195] saa7133[0]: gpio: mode=0x0200000 in=0x0000000 
> out=0x0000000 [Television]
> [ 6536.473284] saa7133[0]: gpio: mode=0x0200000 in=0x0000000 
> out=0x0000000 [Television]
> [ 6536.474294] saa7133[0]/audio: tvaudio thread scan start [1]
> [ 6536.474306] saa7133[0]/audio: scanning: B/G D/K I
> [ 6536.501582] saa7133[0]: registered device video0 [v4l2]
> [ 6536.502600] saa7133[0]: registered device vbi0
> [ 6536.503459] saa7133[0]: registered device radio0
> [ 6536.503961] saa7133[0]: gpio: mode=0x0200000 in=0x0000000 
> out=0x0000000 [Television]
> [ 6536.504453] tuner' 2-004b: Cmd TUNER_SET_STANDBY accepted for analog TV
> [ 6536.504950] saa7133[0]: i2c xfer: < 96 21 c0 >
> [ 6536.536862] saa7133[0]: i2c xfer: < c2 30 90 ><7>saa7133[0]: gpio: 
> mode=0x0200000 in=0x0000000 out=0x0000000 [Television]
> [ 6536.544875]
> [ 6536.544889] saa7133[0]: i2c xfer: < 96 21 00 >
> [ 6536.552855] saa7133[0]: i2c xfer: < 96 02 20 ><7>saa7133[0]: gpio: 
> mode=0x0200000 in=0x0000000 out=0x0000000 [Television]
> [ 6536.560850]
> [ 6536.560862] saa7133[0]: i2c xfer: < 96 00 02 >
> [ 6536.597483] saa7134_alsa: disagrees about version of symbol 
> saa7134_tvaudio_setmute
> [ 6536.597509] saa7134_alsa: Unknown symbol saa7134_tvaudio_setmute
> [ 6536.597960] saa7134_alsa: disagrees about version of symbol 
> saa_dsp_writel
> [ 6536.597967] saa7134_alsa: Unknown symbol saa_dsp_writel
> [ 6536.598420] saa7134_alsa: disagrees about version of symbol 
> videobuf_dma_free
> [ 6536.598426] saa7134_alsa: Unknown symbol videobuf_dma_free
> [ 6536.598922] saa7134_alsa: disagrees about version of symbol 
> saa7134_pgtable_alloc
> [ 6536.598929] saa7134_alsa: Unknown symbol saa7134_pgtable_alloc
> [ 6536.599038] saa7134_alsa: disagrees about version of symbol 
> saa7134_pgtable_build
> [ 6536.599045] saa7134_alsa: Unknown symbol saa7134_pgtable_build
> [ 6536.599137] saa7134_alsa: disagrees about version of symbol 
> saa7134_pgtable_free
> [ 6536.599144] saa7134_alsa: Unknown symbol saa7134_pgtable_free
> [ 6536.599238] saa7134_alsa: disagrees about version of symbol 
> saa7134_dmasound_init
> [ 6536.599245] saa7134_alsa: Unknown symbol saa7134_dmasound_init
> [ 6536.599604] saa7134_alsa: disagrees about version of symbol 
> saa7134_dmasound_exit
> [ 6536.599611] saa7134_alsa: Unknown symbol saa7134_dmasound_exit
> [ 6536.599861] saa7134_alsa: disagrees about version of symbol 
> videobuf_dma_init
> [ 6536.599867] saa7134_alsa: Unknown symbol videobuf_dma_init
> [ 6536.600250] saa7134_alsa: disagrees about version of symbol 
> videobuf_dma_init_kernel
> [ 6536.600257] saa7134_alsa: Unknown symbol videobuf_dma_init_kernel
> [ 6536.600593] saa7134_alsa: Unknown symbol videobuf_pci_dma_unmap
> [ 6536.601047] saa7134_alsa: Unknown symbol videobuf_pci_dma_map
> [ 6536.601157] saa7134_alsa: disagrees about version of symbol 
> saa7134_set_dmabits
> [ 6536.601164] saa7134_alsa: Unknown symbol saa7134_set_dmabits
> [ 6536.732363] tuner' 2-004b: Cmd VIDIOC_S_STD accepted for analog TV
> [ 6536.732396] tuner' 2-004b: tv freq set to 400.00
> [ 6536.732408] saa7133[0]: i2c xfer: < 96 01 02 >
> [ 6536.740806] saa7133[0]: i2c xfer: < 96 02 00 >
> [ 4083.880811] saa7133[0]: i2c xfer: < 96 00 00 >
> [ 4083.896764] saa7133[0]: i2c xfer: < 96 01 82 >
> [ 4083.904770] saa7133[0]: i2c xfer: < 96 28 14 >
> [ 4083.912747] saa7133[0]: i2c xfer: < 96 0f 88 >
> [ 4083.920747] saa7133[0]: i2c xfer: < 96 05 04 >
> [ 4083.928734] saa7133[0]: i2c xfer: < 96 0d 47 >
> [ 4083.936728] saa7133[0]: i2c xfer: < 96 21 c0 >
> [ 4083.984696] saa7133[0]: i2c xfer: < c2 00 32 d8 00 16 3b bb 1c 04 20 00 >
> [ 4083.997886] saa7133[0]: i2c xfer: < c2 90 ff e0 00 99 >
> [ 4084.005127] saa7133[0]: i2c xfer: < c2 a0 c0 >
> [ 4084.012685] saa7133[0]: i2c xfer: < c2 30 10 >
> [ 4084.020668] saa7133[0]: i2c xfer: < c3 =49 =a9 >
> [ 4668.782582] saa7133[0]: i2c xfer: < c2 60 3c >
> [ 6537.376506] saa7133[0]: i2c xfer: < c2 50 bf >
> [ 6537.384478] saa7133[0]: i2c xfer: < c2 80 28 >
> [ 6537.392483] saa7133[0]: i2c xfer: < c2 b0 01 >
> [ 6537.400553] saa7133[0]: i2c xfer: < c2 c0 19 >
> 
> But tvtime-scanner dont find any channels.
> 
> Which way i can set up an other value to vmux?
> 

Hi,

you need to enable debug also for tda8290 to see lock or no lock.

A pattern for tuning failed in the middle of two successful tuning
attempts looks like this.

tuner' 2-004b: tv freq set to 182.25
tda829x 2-004b: setting tda829x to system B
tda827x: setting tda827x to system B
tda827x: AGC2 gain is: 3
tda829x 2-004b: tda8290 is locked, AGC: 144
tda829x 2-004b: adjust gain, step 1. Agc: 144, ADC stat: 0, lock: 128
tda829x 2-004b: adjust gain, step 2. Agc: 118, lock: 128
tuner' 2-004b: VIDIOC_S_FREQUENCY
tuner' 2-004b: tv freq set to 495.25
tda829x 2-004b: setting tda829x to system B
tda827x: setting tda827x to system B
tda827x: AGC2 gain is: 3
tda829x 2-004b: tda8290 not locked, no signal?
tda829x 2-004b: tda8290 not locked, no signal?
tda829x 2-004b: tda8290 not locked, no signal?
tuner' 2-004b: VIDIOC_S_FREQUENCY
tuner' 2-004b: tv freq set to 210.25
tda829x 2-004b: setting tda829x to system B
tda827x: setting tda827x to system B
tda827x: AGC2 gain is: 3
tda829x 2-004b: tda8290 is locked, AGC: 159
tda829x 2-004b: adjust gain, step 1. Agc: 159, ADC stat: 0, lock: 128
tda829x 2-004b: adjust gain, step 2. Agc: 126, lock: 128

What you see with "tv freq set to 400.00" is only a dummy tuning needed
for some tuners to have charge pump ready for radio tuning, but there is
no broadcast.

Only if you see "lock" and still no picture it is worth to change the TV
vmux for the card you are testing in saa7134-cards.c.
Simplest is to install recent v4l-dvb and after the change

make
make rmmod
make install
modprobe -v saa7134 card=N tuner=54

You need a way to get rid of the ubuntu troubles for saa7134-alsa too.

A card with TV vmux = 4 is card=77, for other tests better change the
vmux in the code.

Good lock :)

Hermann




--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
