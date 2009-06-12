Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-14.arcor-online.net ([151.189.21.54]:41161 "EHLO
	mail-in-14.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752487AbZFLQRF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 12 Jun 2009 12:17:05 -0400
Subject: Re: [linux-dvb] ASUS 'My Cinema Europa Hybrid' (P7131 DVB-T)
	[SAA7134] Firmware oddities
From: hermann pitton <hermann-pitton@arcor.de>
To: chatura <ckuruwita.pub@gmail.com>
Cc: linux-media@vger.kernel.org
In-Reply-To: <4A3264E6.2000403@gmail.com>
References: <5e20e5fc0904280647o7862f0e6r5175d73a9c8ad340@mail.gmail.com>
	 <4A3264E6.2000403@gmail.com>
Content-Type: text/plain
Date: Fri, 12 Jun 2009 18:14:20 +0200
Message-Id: <1244823260.9239.4.camel@pc07.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

Am Samstag, den 13.06.2009, 00:23 +1000 schrieb chatura:
> Sam Spilsbury wrote:
> > Hi everyone,
> > 
> > So It's my first time to LinuxTV hacking, debugging etc, so I
> > apologize if I've failed to provide anything essential.
> > 
> > Anyways, I've just bought a ASUS 'My Cinema Europa Hybrid' (P7131
> > DVB-T) which has the Phillips saa7131 chipset in it (supported by the
> > saa7131 module et al). There is a problem getting the firmware in this
> > card to boot correctly - I may have the wrong card number and I cannot
> > use i2c because it detects it as UNKNOWN/GENERIC (i.e type 0) which
> > doesn't work.
> > 
> > According to /usr/share/doc/linux/video4linux etc my card number
> > should be either 78, 111 or 112. Specifying card=x seems to make the
> > module somewhat recognize the card, and even though I have the
> > firmware - it won't actually boot. This is shown by the fact that all
> > dvb operations essentially just time out and the fact that I cannot
> > scan channels in software like tvtime. I might be wrong though.
> > 
> > Here is relevant output which might assist in helping the problem:
> > 
> > ==== dmesg log ====c
> > 
> > saa7130/34: v4l2 driver version 0.2.14 loaded
> > saa7134[0]: found at 0000:00:09.0, rev: 1, irq: 18, latency: 32, mmio:
> > 0xeb007000
> > saa7134[0]: subsystem: 1043:4847, board: ASUSTeK P7131 Dual
> > [card=78,insmod option]
> > saa7134[0]: board init: gpio is 200000
> > input: saa7134 IR (ASUSTeK P7131 Dual) as
> > /devices/pci0000:00/0000:00:09.0/input/input7
> > tuner' 3-0043: chip found @ 0x86 (saa7134[0])
> > tda9887 3-0043: creating new instance
> > tda9887 3-0043: tda988[5/6/7] found
> > saa7134[0]: i2c eeprom 00: 43 10 47 48 54 20 1c 00 43 43 a9 1c 55 d2 b2 92
> > saa7134[0]: i2c eeprom 10: 00 ff 82 0e ff 20 ff ff ff ff ff ff ff ff ff ff
> > saa7134[0]: i2c eeprom 20: 01 40 01 02 03 ff 03 04 08 ff 00 2a ff ff ff ff
> > saa7134[0]: i2c eeprom 30: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> > saa7134[0]: i2c eeprom 40: ff 02 00 c2 86 10 ff ff ff ff ff ff ff ff ff ff
> > saa7134[0]: i2c eeprom 50: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> > saa7134[0]: i2c eeprom 60: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> > saa7134[0]: i2c eeprom 70: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> > saa7134[0]: i2c eeprom 80: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> > saa7134[0]: i2c eeprom 90: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> > saa7134[0]: i2c eeprom a0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> > saa7134[0]: i2c eeprom b0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> > saa7134[0]: i2c eeprom c0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> > saa7134[0]: i2c eeprom d0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> > saa7134[0]: i2c eeprom e0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> > saa7134[0]: i2c eeprom f0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> > saa7134[0]: registered device video0 [v4l2]
> > saa7134[0]: registered device vbi0
> > saa7134[0]: registered device radio0
> > DVB: registering new adapter (saa7134[0])
> > DVB: registering frontend 0 (Philips TDA10046H DVB-T)...
> > tda1004x: setting up plls for 48MHz sampling clock
> > tda1004x: timeout waiting for DSP ready
> > tda1004x: found firmware revision 0 -- invalid
> > tda1004x: trying to boot from eeprom
> > tda1004x: found firmware revision 26 -- ok
> > saa7134[0]/dvb: could not access tda8290 I2C gate
> > tda827x_probe_version: could not read from tuner at addr: 0xc2
> > 
> > ===== Relevant bits of lspci =====
> > 
> > 00:09.0 Multimedia controller: Philips Semiconductors
> > SAA7134/SAA7135HL Video Broadcast Decoder (rev 01)
> > 	Subsystem: ASUSTeK Computer Inc. Device 4847
> > 	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
> > Stepping- SERR- FastB2B- DisINTx-
> > 	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
> > <TAbort- <MAbort- >SERR- <PERR- INTx-
> > 	Latency: 32 (21000ns min, 8000ns max)
> > 	Interrupt: pin A routed to IRQ 18
> > 	Region 0: Memory at eb007000 (32-bit, non-prefetchable) [size=1K]
> > 	Capabilities: [40] Power Management version 1
> > 		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
> > 		Status: D0 PME-Enable- DSel=0 DScale=1 PME-
> > 	Kernel driver in use: saa7134
> > 	Kernel modules: saa7134
> > 
> > 
> > Any help would be greatly appreciated however I understand if this
> > isn't a fixable issue. If so it would be nice to know where I could
> > buy (online) TV Tuner cards with a composite input, are the old PCI
> > type and of course work well with Linux (Fedora 10 at least).
> > 
> > Thanks in advance,
> > 
> > Sam
> 
> Hi Sam and everyone
> 
> First off I'm new to the LinuxTV mailing list and just like Sam this is my first time hacking, debugging etc.
> 
> I also have an ASUS 'My Cinema Europa Hybrid' and it is currently unsupported right now.
> However looking over the hardware component's on the card itself, it seems that the individual components seem to be supported
> and we merely have to get all the components "interacting" with each other.
> 
> The card has a:
> 	* Philips SAA7134HL video decoder, which is supported by the saa7134 driver
> 	* Philips TDA10046A digital demodulator, which is supported by the tda1004x driver
> 	* Philips TDA9886TS analog demodulator, which is supported by the tda9887 driver
> 
> I went and compiled and installed the recent 2.6.30 kernel and also a recent v4l-dvb snapshot.
> So i can make sure that i have the most recent drivers. It still seems to be unsupported in recent kernels and also v4l-dvb snapshots
> I done a modprobe saa7134 i2c_scan=1 so any attached/associated components are scanned and detect.
> It seems that the TDA9886TS analog demodulator is detected and i believe the device at 0x10 is the TDA10046A digital demodulator as shown by the dmesg output:
> 
> =================================================================================
> Linux video capture interface: v2.00
> saa7130/34: v4l2 driver version 0.2.15 loaded
> saa7134[0]: found at 0000:06:05.0, rev: 1, irq: 20, latency: 64, mmio: 0xfebffc00
> saa7134[0]: subsystem: 1043:4847, board: UNKNOWN/GENERIC [card=0,autodetected]
> saa7134[0]: board init: gpio is 0
> IRQ 20/saa7134[0]: IRQF_DISABLED is not guaranteed on shared IRQs
> saa7134[0]: i2c eeprom 00: 43 10 47 48 54 20 1c 00 43 43 a9 1c 55 d2 b2 92
> saa7134[0]: i2c eeprom 10: 00 ff 82 0e ff 20 ff ff ff ff ff ff ff ff ff ff
> saa7134[0]: i2c eeprom 20: 01 40 01 02 03 ff 03 04 08 ff 00 2a ff ff ff ff
> saa7134[0]: i2c eeprom 30: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> saa7134[0]: i2c eeprom 40: ff 02 00 c2 86 10 ff ff ff ff ff ff ff ff ff ff
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
> saa7134[0]: i2c scan: found device @ 0x10  [???]
> saa7134[0]: i2c scan: found device @ 0x86  [tda9887]
> saa7134[0]: i2c scan: found device @ 0xa0  [eeprom]
> saa7134[0]: registered device video0 [v4l2]
> saa7134[0]: registered device vbi0
> saa7134 ALSA driver for DMA sound loaded
> IRQ 20/saa7134[0]: IRQF_DISABLED is not guaranteed on shared IRQs
> saa7134[0]/alsa: saa7134[0] at 0xfebffc00 irq 20 registered as card -2
> =================================================================================
> 
> According to this wiki entry: http://www.linuxtv.org/wiki/index.php/Development:_How_to_add_support_for_a_device
> To add support for a new saa7134 card we just need to modify saa7134-cards.c and saa7134.h and 
> add any card specific details such as vendor/device id, tuner and inputs etc.
> So started by modifying those two files, i highly doubt the card will work with just the modifications i have made.
> Anyway here's a patch containing  what i have modified,
> it's mostly copied and pasted from the SAA7134_BOARD_ASUS_EUROPA2_HYBRID section but changed to suit the card
> 
> ======================================================================================
> diff -r bff77ec33116 linux/drivers/media/video/saa7134/saa7134-cards.c
> --- a/linux/drivers/media/video/saa7134/saa7134-cards.c Thu Jun 11 18:44:23 2009 -0300
> +++ b/linux/drivers/media/video/saa7134/saa7134-cards.c Sat Jun 13 00:12:26 2009 +1000
> @@ -5155,6 +5155,22 @@
>                         .gpio = 0x00,
>                 },
>         },
> +       [SAA7134_BOARD_ASUS_EUROPA_HYBRID] = {
> +               .name           = "Asus Europa Hybrid OEM",
> +               .audio_clock    = 0x00187de7,
> +               .tuner_type     = TUNER_PHILIPS_FMD1216ME_MK3,
> +               .radio_type     = UNSET,
> +               .tuner_addr     = ADDR_UNSET,
> +               .radio_addr     = ADDR_UNSET,
> +               .tda9887_conf   = TDA9887_PRESENT,
> +               .mpeg           = SAA7134_MPEG_DVB,
> +               .inputs = {{
> +                       .name   = name_tv,
> +                       .vmux   = 1,
> +                       .amux   = TV,
> +                       .tv     = 1,
> +               }},
> +       },
>  };
>  
>  const unsigned int saa7134_bcount = ARRAY_SIZE(saa7134_boards);
> @@ -6257,7 +6273,13 @@
>                 .subdevice    = 0xf31d,
>                 .driver_data  = SAA7134_BOARD_AVERMEDIA_GO_007_FM_PLUS,
>  
> -       }, {
> +       },{
> +               .vendor       = PCI_VENDOR_ID_PHILIPS,
> +               .device       = PCI_DEVICE_ID_PHILIPS_SAA7134,
> +               .subvendor    = 0x1043,
> +               .subdevice    = 0x4847,
> +               .driver_data  = SAA7134_BOARD_ASUS_EUROPA_HYBRID,
> +       },{
>                 /* --- boards without eeprom + subsystem ID --- */
>                 .vendor       = PCI_VENDOR_ID_PHILIPS,
>                 .device       = PCI_DEVICE_ID_PHILIPS_SAA7134,
> diff -r bff77ec33116 linux/drivers/media/video/saa7134/saa7134.h
> --- a/linux/drivers/media/video/saa7134/saa7134.h       Thu Jun 11 18:44:23 2009 -0300
> +++ b/linux/drivers/media/video/saa7134/saa7134.h       Sat Jun 13 00:12:26 2009 +1000
> @@ -293,6 +293,7 @@
>  #define SAA7134_BOARD_BEHOLD_607RDS_MK5     166
>  #define SAA7134_BOARD_BEHOLD_609RDS_MK3     167
>  #define SAA7134_BOARD_BEHOLD_609RDS_MK5     168
> +#define SAA7134_BOARD_ASUS_EUROPA_HYBRID    169
>  
>  #define SAA7134_MAXBOARDS 32
>  #define SAA7134_INPUT_MAX 8
> ======================================================================================
> 
> When you compile and load the saa7134 module with my modification the dmesg out looks like this:
> 
> ======================================================================================================
> [ 3133.621063] Linux video capture interface: v2.00
> [ 3133.665786] saa7130/34: v4l2 driver version 0.2.15 loaded
> [ 3133.666477] saa7134[0]: found at 0000:06:05.0, rev: 1, irq: 20, latency: 64, mmio: 0xfebffc00
> [ 3133.666492] saa7134[0]: subsystem: 1043:4847, board: Asus Europa Hybrid OEM [card=169,autodetected]
> [ 3133.666534] saa7134[0]: board init: gpio is 0
> [ 3133.666554] IRQ 20/saa7134[0]: IRQF_DISABLED is not guaranteed on shared IRQs
> [ 3133.816516] saa7134[0]: i2c eeprom 00: 43 10 47 48 54 20 1c 00 43 43 a9 1c 55 d2 b2 92
> [ 3133.816534] saa7134[0]: i2c eeprom 10: 00 ff 82 0e ff 20 ff ff ff ff ff ff ff ff ff ff
> [ 3133.816550] saa7134[0]: i2c eeprom 20: 01 40 01 02 03 ff 03 04 08 ff 00 2a ff ff ff ff
> [ 3133.816565] saa7134[0]: i2c eeprom 30: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> [ 3133.816580] saa7134[0]: i2c eeprom 40: ff 02 00 c2 86 10 ff ff ff ff ff ff ff ff ff ff
> [ 3133.816595] saa7134[0]: i2c eeprom 50: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> [ 3133.816610] saa7134[0]: i2c eeprom 60: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> [ 3133.816626] saa7134[0]: i2c eeprom 70: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> [ 3133.816641] saa7134[0]: i2c eeprom 80: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> [ 3133.816656] saa7134[0]: i2c eeprom 90: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> [ 3133.816671] saa7134[0]: i2c eeprom a0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> [ 3133.816686] saa7134[0]: i2c eeprom b0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> [ 3133.816701] saa7134[0]: i2c eeprom c0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> [ 3133.816716] saa7134[0]: i2c eeprom d0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> [ 3133.816732] saa7134[0]: i2c eeprom e0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> [ 3133.816747] saa7134[0]: i2c eeprom f0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> [ 3133.816765] i2c-adapter i2c-1: Invalid 7-bit address 0x7a
> [ 3133.876679] tuner 1-0043: chip found @ 0x86 (saa7134[0])
> [ 3133.892053] tda9887 1-0043: creating new instance
> [ 3133.892059] tda9887 1-0043: tda988[5/6/7] found
> [ 3133.916628] saa7134[0]: registered device video0 [v4l2]
> [ 3133.916676] saa7134[0]: registered device vbi0
> [ 3133.927331] saa7134 ALSA driver for DMA sound loaded
> [ 3133.927355] IRQ 20/saa7134[0]: IRQF_DISABLED is not guaranteed on shared IRQs
> [ 3133.927397] saa7134[0]/alsa: saa7134[0] at 0xfebffc00 irq 20 registered as card -2
> [ 3134.047574] dvb_init() allocating 1 frontend
> [ 3134.047584] saa7134[0]/dvb: Huh? unknown DVB card?
> [ 3134.047589] saa7134[0]/dvb: frontend initialization failed
> ======================================================================================================
> 
> Right now with my modifications it is able to pick it up as a "Asus Europa Hybrid OEM" card and also load the drivers for the analog tuner.
> My modification has a number of problems such as:
> 	* Not being able to recognise the TDA10046A digital demodulator and load the tda1004x driver.
> 	  I believe i have to specify it in the ".tuner_type" line but i don't know what exactly to specify.
> 	* Not being able to recognise/initilze the frontend.
> 	* Analog/Digital scanning fails.
> 
> Anyway it's a start, hopefully a developer can help me fix some of the problems mentioned above and get this card supported
> 
> Thanks
> 
> Chatura

as previously said in this thread, you don't even have a RF tuner so
far.

I assume trying with card=70 as recommended previously did not help
either then?

Cheers,
Hermann


